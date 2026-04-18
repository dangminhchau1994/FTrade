import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:logger/logger.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

final _logger = Logger();

enum SocketConnectionStatus { disconnected, connecting, connected }

/// SocketCluster v1 client for MASVN wss://nmts.masvn.com/ws/
///
/// Wire format: msgpack binary frames.
/// Protocol:
///   Ping : server sends empty string '' → client echoes ''
///   Handshake: send {event:'#handshake', data:{authToken:null}, cid:1}
///   Subscribe: send {event:'#subscribe', data:{channel:'market.quote.VNM'}, cid:N}
///   Publish  : receive {p:[channel, data]}
class SocketClusterService {
  final String url;

  WebSocket? _ws;
  StreamSubscription? _wsSub;
  int _cid = 0;
  bool _handshakeDone = false;
  bool _disposed = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  final Set<String> _channels = {};
  final _statusCtrl = StreamController<SocketConnectionStatus>.broadcast();
  final _publishCtrl =
      StreamController<(String channel, dynamic data)>.broadcast();

  SocketConnectionStatus _status = SocketConnectionStatus.disconnected;
  int _messageCount = 0;
  DateTime? _lastMessageAt;
  String? _lastError;

  SocketConnectionStatus get status => _status;
  Stream<SocketConnectionStatus> get statusStream => _statusCtrl.stream;

  /// Emits (channel, data) for every #publish received.
  Stream<(String, dynamic)> get publishStream => _publishCtrl.stream;

  bool get isConnected => _status == SocketConnectionStatus.connected;
  int get messageCount => _messageCount;
  DateTime? get lastMessageAt => _lastMessageAt;
  String? get lastError => _lastError;

  SocketClusterService({required this.url});

  Future<void> connect() async {
    if (_disposed || !_shouldReconnect) return;
    if (_status != SocketConnectionStatus.disconnected) return;

    _setStatus(SocketConnectionStatus.connecting);
    _logger.i('SocketCluster connecting to $url');

    try {
      _ws = await WebSocket.connect(url).timeout(const Duration(seconds: 20));
      _handshakeDone = false;
      _cid = 0;

      _wsSub = _ws!.listen(
        _handleFrame,
        onDone: _onDisconnected,
        onError: (e) {
          _lastError = e.toString();
          _onDisconnected();
        },
        cancelOnError: false,
      );

      _setStatus(SocketConnectionStatus.connected);
      _reconnectAttempts = 0;

      // Send handshake — cid always 1 per SocketCluster spec
      _send({
        'event': '#handshake',
        'data': {'authToken': null},
        'cid': ++_cid,
      });
    } catch (e) {
      _lastError = e.toString();
      _logger.e('SocketCluster connect error: $e');
      _ws = null;
      _setStatus(SocketConnectionStatus.disconnected);
      _scheduleReconnect();
    }
  }

  /// Idempotent — safe to call multiple times for the same channel.
  void subscribe(String channel) {
    final added = _channels.add(channel);
    if (isConnected && _handshakeDone) {
      _send({
        'event': '#subscribe',
        'data': {'channel': channel},
        'cid': ++_cid,
      });
      if (added) _logger.d('SocketCluster subscribed: $channel');
    }
  }

  void unsubscribe(String channel) {
    _channels.remove(channel);
    if (isConnected) {
      _send({'event': '#unsubscribe', 'data': channel, 'cid': ++_cid});
    }
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _wsSub?.cancel();
    _wsSub = null;
    await _ws?.close();
    _ws = null;
    _setStatus(SocketConnectionStatus.disconnected);
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    if (!_statusCtrl.isClosed) await _statusCtrl.close();
    if (!_publishCtrl.isClosed) await _publishCtrl.close();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  void _send(dynamic obj) {
    if (_ws?.readyState == WebSocket.open) {
      try {
        _ws!.add(serialize(obj));
      } catch (e) {
        _lastError = e.toString();
      }
    }
  }

  void _handleFrame(dynamic msg) {
    // Ping: server sends empty string, respond with empty string
    if (msg is String) {
      try {
        _ws?.add('');
      } catch (_) {}
      return;
    }

    List<int> bytes;
    if (msg is Uint8List) {
      bytes = msg;
    } else if (msg is List<int>) {
      bytes = msg;
    } else {
      return;
    }

    try {
      final decoded = deserialize(Uint8List.fromList(bytes));
      if (decoded is! Map) return;

      _messageCount++;
      _lastMessageAt = DateTime.now();

      // Publish: {p: [channel, data]}
      final publish = decoded['p'];
      if (publish is List && publish.length >= 2) {
        final channel = publish[0]?.toString() ?? '';
        if (channel.isNotEmpty && !_publishCtrl.isClosed) {
          _publishCtrl.add((channel, publish[1]));
        }
        return;
      }

      // Handshake ack: {r: [1, null, {isAuthenticated: bool, ...}]}
      // rid==1 means handshake response per SocketCluster spec
      final resp = decoded['r'];
      if (resp is List && resp.isNotEmpty && resp[0] == 1) {
        _handshakeDone = true;
        _logger.i(
          'SocketCluster handshake ok — subscribing ${_channels.length} channels',
        );
        for (final ch in _channels) {
          _send({
            'event': '#subscribe',
            'data': {'channel': ch},
            'cid': ++_cid,
          });
        }
      }
    } catch (_) {}
  }

  void _onDisconnected() {
    _logger.w('SocketCluster disconnected');
    _wsSub?.cancel();
    _wsSub = null;
    _ws = null;
    _handshakeDone = false;
    _setStatus(SocketConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed || !_shouldReconnect) return;
    _reconnectTimer?.cancel();
    if (_reconnectAttempts >= 10) _reconnectAttempts = 0;
    final delay = Duration(seconds: min(3 * (_reconnectAttempts + 1), 30));
    _reconnectAttempts++;
    _logger.i(
      'SocketCluster reconnecting in ${delay.inSeconds}s '
      '(attempt $_reconnectAttempts)',
    );
    _reconnectTimer = Timer(delay, connect);
  }

  void _setStatus(SocketConnectionStatus s) {
    if (_status == s) return;
    _status = s;
    if (!_statusCtrl.isClosed) _statusCtrl.add(s);
  }
}
