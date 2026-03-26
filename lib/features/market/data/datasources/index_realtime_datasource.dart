import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/realtime_index_data.dart';

final _logger = Logger();

/// Realtime chỉ số thị trường bằng SSI iboard chart API (1-minute candle polling).
///
/// CafeF SignalR hub ngưng gửi RealtimePrice events (2026-03).
/// Thay thế: poll SSI iboard chart API mỗi [_pollInterval] giây, resolution=1 (1 phút).
/// Cần headers Referer/Origin từ iboard.ssi.com.vn.
class IndexRealtimeDatasource {
  static const _chartUrl =
      'https://iboard-api.ssi.com.vn/statistics/charts/history';

  static const _symbols = [
    'VNINDEX',
    'HNXINDEX',
    'VN30',
    'HNX30',
  ];

  /// Map SSI symbol → app display symbol (for backward compat with REST layer)
  static const _symbolMap = {
    'VNINDEX': 'VNINDEX',
    'HNXINDEX': 'HNXINDEX',
    'VN30': 'VN30',
    'HNX30': 'HNX30',
  };

  static const _pollInterval = Duration(seconds: 15);

  final Dio _dio;
  Timer? _pollTimer;
  bool _disposed = false;

  final _controller = StreamController<RealtimeIndexData>.broadcast();
  Stream<RealtimeIndexData> get stream => _controller.stream;

  // Cache previous close for computing change
  final _prevClose = <String, double>{};

  IndexRealtimeDatasource(this._dio);

  Future<void> connect() async {
    if (_disposed || _pollTimer != null) return;

    _logger.i('IndexRealtime: starting SSI poll (${_pollInterval.inSeconds}s)');

    // Fetch immediately, then start timer
    await _pollAll();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _pollAll());
  }

  Future<void> disconnect() async {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> dispose() async {
    _disposed = true;
    disconnect();
    if (!_controller.isClosed) await _controller.close();
  }

  Future<void> _pollAll() async {
    if (_disposed) return;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final from = now - 600; // last 10 minutes

    await Future.wait(
      _symbols.map((sym) => _fetchIndex(sym, from, now)),
    );
  }

  Future<void> _fetchIndex(String symbol, int from, int to) async {
    try {
      final response = await _dio.get(
        _chartUrl,
        queryParameters: {
          'symbol': symbol,
          'resolution': '1',
          'from': from,
          'to': to,
        },
        options: Options(
          headers: {
            'Referer': 'https://iboard.ssi.com.vn/',
            'Origin': 'https://iboard.ssi.com.vn',
          },
        ),
      );

      final payload = response.data as Map<String, dynamic>;
      if (payload['code'] != 'SUCCESS') return;

      final data = payload['data'] as Map<String, dynamic>;
      final closes = data['c'] as List?;
      final timestamps = data['t'] as List?;

      if (closes == null || closes.isEmpty) return;

      final latestClose = (closes.last as num).toDouble();
      // Compute change from first candle of the day (or previous session close)
      double prevClose;
      if (closes.length >= 2) {
        // Use first candle open as reference (approximate)
        final opens = data['o'] as List?;
        prevClose = opens != null && opens.isNotEmpty
            ? (opens.first as num).toDouble()
            : (closes.first as num).toDouble();
      } else {
        prevClose = _prevClose[symbol] ?? latestClose;
      }

      // Store for next poll
      if (closes.length >= 2) {
        _prevClose[symbol] = prevClose;
      }

      final change = latestClose - prevClose;
      final changePct = prevClose > 0 ? change / prevClose * 100 : 0.0;

      final displaySymbol = _symbolMap[symbol] ?? symbol;

      final indexData = RealtimeIndexData(
        symbol: displaySymbol,
        value: latestClose,
        change: change,
        changePercent: changePct,
        updatedAt: timestamps != null && timestamps.isNotEmpty
            ? DateTime.fromMillisecondsSinceEpoch(
                (timestamps.last as num).toInt() * 1000)
            : DateTime.now(),
      );

      if (!_controller.isClosed) {
        _controller.add(indexData);
      }
    } catch (e) {
      _logger.d('IndexRealtime poll $symbol failed: $e');
    }
  }
}
