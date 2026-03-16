import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final _logger = Logger();

/// Trạng thái kết nối WebSocket
enum WebSocketStatus { disconnected, connecting, connected }

/// Generic WebSocket service với auto-reconnect
class WebSocketService {
  final String url;
  final Map<String, String>? protocols;
  final Duration reconnectDelay;
  final int maxReconnectAttempts;

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  int _reconnectAttempts = 0;
  bool _disposed = false;

  final _statusController = StreamController<WebSocketStatus>.broadcast();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  WebSocketStatus _status = WebSocketStatus.disconnected;

  WebSocketService({
    required this.url,
    this.protocols,
    this.reconnectDelay = const Duration(seconds: 3),
    this.maxReconnectAttempts = 10,
  });

  /// Stream trạng thái kết nối
  Stream<WebSocketStatus> get statusStream => _statusController.stream;

  /// Stream message nhận được (đã parse JSON)
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  /// Trạng thái hiện tại
  WebSocketStatus get status => _status;

  bool get isConnected => _status == WebSocketStatus.connected;

  /// Kết nối WebSocket
  Future<void> connect() async {
    if (_disposed) return;
    if (_status == WebSocketStatus.connecting ||
        _status == WebSocketStatus.connected) {
      return;
    }

    _setStatus(WebSocketStatus.connecting);
    _logger.i('WebSocket connecting to $url');

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(url),
        protocols: protocols?.values.toList(),
      );

      await _channel!.ready;
      _reconnectAttempts = 0;
      _setStatus(WebSocketStatus.connected);
      _logger.i('WebSocket connected');

      _startHeartbeat();
      _listenMessages();
    } catch (e) {
      _logger.e('WebSocket connection failed: $e');
      _setStatus(WebSocketStatus.disconnected);
      _scheduleReconnect();
    }
  }

  /// Gửi message dạng JSON
  void send(Map<String, dynamic> message) {
    if (_channel == null || _status != WebSocketStatus.connected) {
      _logger.w('WebSocket not connected, cannot send message');
      return;
    }
    final encoded = jsonEncode(message);
    _channel!.sink.add(encoded);
  }

  /// Gửi raw string
  void sendRaw(String message) {
    if (_channel == null || _status != WebSocketStatus.connected) {
      _logger.w('WebSocket not connected, cannot send message');
      return;
    }
    _channel!.sink.add(message);
  }

  /// Ngắt kết nối
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _reconnectTimer = null;
    _heartbeatTimer = null;

    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }

    _setStatus(WebSocketStatus.disconnected);
    _logger.i('WebSocket disconnected');
  }

  /// Dispose toàn bộ resources
  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _statusController.close();
    await _messageController.close();
  }

  void _listenMessages() {
    _channel?.stream.listen(
      (data) {
        try {
          final message = data is String ? jsonDecode(data) : data;
          if (message is Map<String, dynamic>) {
            _messageController.add(message);
          }
        } catch (e) {
          _logger.w('WebSocket parse error: $e');
        }
      },
      onError: (error) {
        _logger.e('WebSocket stream error: $error');
        _handleDisconnect();
      },
      onDone: () {
        _logger.w('WebSocket stream closed');
        _handleDisconnect();
      },
      cancelOnError: false,
    );
  }

  void _handleDisconnect() {
    _heartbeatTimer?.cancel();
    _channel = null;
    _setStatus(WebSocketStatus.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    if (_reconnectAttempts >= maxReconnectAttempts) {
      _logger.e('WebSocket max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = reconnectDelay * (_reconnectAttempts + 1);
    _reconnectAttempts++;

    _logger.i(
      'WebSocket reconnecting in ${delay.inSeconds}s '
      '(attempt $_reconnectAttempts/$maxReconnectAttempts)',
    );

    _reconnectTimer = Timer(delay, connect);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (isConnected) {
          send({'type': 'ping'});
        }
      },
    );
  }

  void _setStatus(WebSocketStatus newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    if (!_statusController.isClosed) {
      _statusController.add(newStatus);
    }
  }
}
