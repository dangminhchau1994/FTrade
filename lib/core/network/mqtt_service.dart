import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final _logger = Logger();

enum MqttConnectionStatus { disconnected, connecting, connected }

/// Generic MQTT service wrapping mqtt_client.
class MqttService {
  final String url;
  final int port;
  final String? username;
  final String? password;
  final int keepAliveSeconds;
  final int maxReconnectAttempts;

  MqttServerClient? _client;
  StreamSubscription? _updatesSub; // fix memory leak
  Timer? _reconnectTimer;

  bool _disposed = false; // true = lifecycle ended, never reconnect
  bool _shouldReconnect = true; // false = user called disconnect()
  int _reconnectAttempts = 0;

  // Persisted subscriptions → re-subscribe after reconnect
  final _topics = <String, MqttQos>{};

  final _statusController = StreamController<MqttConnectionStatus>.broadcast();
  final _messageController =
      StreamController<MqttReceivedMessage<MqttMessage>>.broadcast();

  MqttConnectionStatus _status = MqttConnectionStatus.disconnected;

  int _messageCount = 0;
  DateTime? _lastMessageAt;

  MqttConnectionStatus get status => _status;
  Stream<MqttConnectionStatus> get statusStream => _statusController.stream;
  Stream<MqttReceivedMessage<MqttMessage>> get messageStream =>
      _messageController.stream;
  bool get isConnected => _status == MqttConnectionStatus.connected;
  int get messageCount => _messageCount;
  DateTime? get lastMessageAt => _lastMessageAt;

  MqttService({
    required this.url,
    this.port = 443,
    this.username,
    this.password,
    this.keepAliveSeconds = 10,
    this.maxReconnectAttempts = 10,
  });

  Future<void> connect() async {
    if (_disposed || !_shouldReconnect) return;
    if (_status != MqttConnectionStatus.disconnected) return;

    _setStatus(MqttConnectionStatus.connecting);
    _logger.i('MQTT connecting to $url');

    final uri = Uri.parse(url);
    final clientId = 'flutter-${_randomId()}';

    _client = MqttServerClient.withPort(
      url, // full URL — WS handler dùng Uri.parse(server) để extract path
      clientId,
      uri.port > 0 ? uri.port : port,
    );

    // Force HTTP/1.1 via ALPN:
    // price-streaming.ssi.com.vn negotiates h2 in TLS handshake.
    // Standard WebSocket (dart:io WebSocket.connect) sends HTTP/1.1 Upgrade
    // headers, which are INVALID over h2 streams → connection fails silently.
    // Fix: useAlternateWebSocketImplementation uses SecureSocket + manual
    // HTTP/1.1 WebSocket handshake (bypasses h2 entirely).
    // Also set SecurityContext ALPN to ['http/1.1'] so the TLS layer itself
    // doesn't advertise h2, ensuring the server doesn't try to use it.
    final secCtx = SecurityContext(withTrustedRoots: true);
    try {
      secCtx.setAlpnProtocols(['http/1.1'], false);
    } catch (_) {
      // Ignore on platforms that don't support setAlpnProtocols
    }

    _client!
      ..useWebSocket = true
      ..useAlternateWebSocketImplementation = true
      ..securityContext = secCtx
      ..websocketProtocols = MqttClientConstants.protocolsSingleDefault
      ..keepAlivePeriod = keepAliveSeconds
      ..connectTimeoutPeriod = 10000
      ..autoReconnect = false
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected
      ..logging(on: false);

    // Keep bad-cert bypass as safety net in case SSI cert changes
    _client!.onBadCertificate = (Object _) => true;

    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    try {
      await _client!.connect(username, password);

      // Verify connection succeeded
      final connStatus = _client!.connectionStatus;
      if (connStatus?.state != MqttConnectionState.connected) {
        throw Exception(
          'MQTT connect failed: ${connStatus?.returnCode}',
        );
      }
    } catch (e) {
      _logger.e('MQTT connect error: $e');
      _client?.disconnect();
      _client = null;
      _setStatus(MqttConnectionStatus.disconnected);
      _scheduleReconnect();
    }
  }

  void subscribe(String topic, {MqttQos qos = MqttQos.atMostOnce}) {
    _topics[topic] = qos; // persist so we can re-subscribe after reconnect
    if (isConnected) {
      _client?.subscribe(topic, qos);
      _logger.i('MQTT subscribed: $topic');
    }
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _updatesSub?.cancel();
    _updatesSub = null;
    _client?.disconnect();
    _client = null;
    _setStatus(MqttConnectionStatus.disconnected);
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    if (!_statusController.isClosed) await _statusController.close();
    if (!_messageController.isClosed) await _messageController.close();
  }

  // ── Callbacks ──────────────────────────────────────────────────────────────

  void _onConnected() {
    _reconnectAttempts = 0;
    _setStatus(MqttConnectionStatus.connected);
    _logger.i('MQTT connected ✓');

    // Cancel previous listener before registering new one (prevent memory leak)
    _updatesSub?.cancel();
    _updatesSub = _client?.updates?.listen((messages) {
      for (final msg in messages) {
        _messageCount++;
        _lastMessageAt = DateTime.now();
        if (!_messageController.isClosed) _messageController.add(msg);
      }
    });

    // Re-subscribe to all persisted topics
    for (final entry in _topics.entries) {
      _client?.subscribe(entry.key, entry.value);
    }
    if (_topics.isNotEmpty) {
      _logger.i('MQTT re-subscribed ${_topics.length} topics');
    }
  }

  void _onDisconnected() {
    _logger.w('MQTT disconnected');
    _updatesSub?.cancel();
    _updatesSub = null;
    _setStatus(MqttConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed || !_shouldReconnect) return;

    _reconnectTimer?.cancel();

    // Reset counter after exhausting attempts so we keep retrying indefinitely
    // with the max backoff (30 s) rather than giving up.
    if (_reconnectAttempts >= maxReconnectAttempts) {
      _reconnectAttempts = 0;
    }

    final delay = Duration(seconds: min(3 * (_reconnectAttempts + 1), 30));
    _reconnectAttempts++;
    _logger.i(
      'MQTT reconnecting in ${delay.inSeconds}s '
      '(attempt $_reconnectAttempts)',
    );
    _reconnectTimer = Timer(delay, connect);
  }

  void _setStatus(MqttConnectionStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    if (!_statusController.isClosed) _statusController.add(newStatus);
  }

  static String _randomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rng = Random();
    return List.generate(8, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}

/// Extract raw bytes from an MQTT PUBLISH payload.
Uint8List mqttPayloadBytes(MqttReceivedMessage<MqttMessage> msg) {
  final publish = msg.payload as MqttPublishMessage;
  return Uint8List.fromList(publish.payload.message.toList());
}
