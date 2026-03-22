import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/entities/realtime_index_data.dart';

final _logger = Logger();

/// Realtime chỉ số thị trường từ CafeF SignalR hub.
/// Không cần auth. Connect thẳng WebSocket (skipNegotiation).
/// Hub: wss://realtime.cafef.vn/hub/priceshub
/// Method: JoinChannel(symbol)
/// Event: RealtimePrice
class IndexRealtimeDatasource {
  static const _url = 'wss://realtime.cafef.vn/hub/priceshub';

  // CafeF symbol names cho chỉ số
  static const _symbols = [
    'VNINDEX',
    'HNXINDEX',
    'UPCOMINDEX',
    'VN30',
    'HNX30',
  ];

  // Dấu kết thúc message của SignalR
  static const _delimiter = '\x1e';

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;

  bool _disposed = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 10;

  final _controller = StreamController<RealtimeIndexData>.broadcast();
  Stream<RealtimeIndexData> get stream => _controller.stream;

  Future<void> connect() async {
    if (_disposed || _channel != null) return;

    _logger.i('CafeF IndexWS connecting...');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));
      await _channel!.ready;

      _logger.i('CafeF IndexWS connected ✓');
      _reconnectAttempts = 0;

      // SignalR handshake
      _send({'protocol': 'json', 'version': 1});

      // Subscribe chỉ số
      for (var i = 0; i < _symbols.length; i++) {
        _send({
          'arguments': [_symbols[i]],
          'invocationId': '$i',
          'target': 'JoinChannel',
          'type': 1,
        });
      }

      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: (_) => _onDisconnected(),
        onDone: _onDisconnected,
      );
    } catch (e) {
      _logger.e('CafeF IndexWS connect error: $e');
      _channel = null;
      _scheduleReconnect();
    }
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    _cleanup();
  }

  Future<void> dispose() async {
    _disposed = true;
    _cleanup();
    if (!_controller.isClosed) await _controller.close();
  }

  void _send(Map<String, dynamic> msg) {
    _channel?.sink.add(jsonEncode(msg) + _delimiter);
  }

  void _cleanup() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  void _onDisconnected() {
    _logger.w('CafeF IndexWS disconnected');
    _cleanup();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed || !_shouldReconnect) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _logger.e('CafeF IndexWS max reconnect attempts reached');
      return;
    }

    final seconds = (_reconnectAttempts + 1) * 3;
    final delay = Duration(seconds: seconds > 30 ? 30 : seconds);
    _reconnectAttempts++;
    _logger.i('CafeF IndexWS reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)');
    _reconnectTimer = Timer(delay, connect);
  }

  void _onMessage(dynamic raw) {
    final text = raw as String;
    for (final part in text.split(_delimiter)) {
      if (part.trim().isEmpty) continue;
      _processMessage(part);
    }
  }

  void _processMessage(String text) {
    try {
      final json = jsonDecode(text) as Map<String, dynamic>;
      final type = json['type'] as int?;

      // type 1 = server invocation (push event)
      if (type != 1) return;

      final target = json['target'] as String?;
      if (target != 'RealtimePrice') return;

      final args = json['arguments'] as List?;
      if (args == null || args.isEmpty) return;

      final item = args.first as Map<String, dynamic>;
      _logger.d('CafeF RealtimePrice: $item');

      final data = _parse(item);
      if (data != null && !_controller.isClosed) {
        _controller.add(data);
      }
    } catch (e) {
      _logger.e('CafeF IndexWS parse error: $e');
    }
  }

  RealtimeIndexData? _parse(Map<String, dynamic> item) {
    // symbol field: 'symbol' hoặc alias 'a'
    final symbol = (item['symbol'] ?? item['a'])?.toString();
    if (symbol == null || !_symbols.contains(symbol)) return null;

    double _d(String key) {
      final v = item[key];
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }

    int _i(String key) {
      final v = item[key];
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    // Field names verify qua log "CafeF RealtimePrice: {...}"
    double value;
    if (_d('indexValue') != 0) {
      value = _d('indexValue');
    } else if (_d('lastPrice') != 0) {
      value = _d('lastPrice');
    } else if (_d('close') != 0) {
      value = _d('close');
    } else {
      value = _d('l');
    }

    double change;
    if (_d('indexChange') != 0) {
      change = _d('indexChange');
    } else if (_d('change') != 0) {
      change = _d('change');
    } else {
      change = _d('ch');
    }

    double changePercent;
    if (_d('changePercent') != 0) {
      changePercent = _d('changePercent');
    } else if (_d('percentChange') != 0) {
      changePercent = _d('percentChange');
    } else {
      changePercent = _d('r');
    }

    int? advances;
    if (_i('advance') != 0) {
      advances = _i('advance');
    } else if (_i('advances') != 0) {
      advances = _i('advances');
    }

    int? declines;
    if (_i('decline') != 0) {
      declines = _i('decline');
    } else if (_i('declines') != 0) {
      declines = _i('declines');
    }

    return RealtimeIndexData(
      symbol: symbol,
      value: value,
      change: change,
      changePercent: changePercent,
      advances: advances,
      declines: declines,
      unchanged: _i('noChange') != 0 ? _i('noChange') : null,
      updatedAt: DateTime.now(),
    );
  }
}
