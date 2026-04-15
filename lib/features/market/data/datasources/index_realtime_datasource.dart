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

  static const _pollInterval = Duration(seconds: 5);

  final Dio _dio;
  Timer? _pollTimer;
  bool _disposed = false;
  bool _polling = false; // guard against overlapping polls

  final _controller = StreamController<RealtimeIndexData>.broadcast();
  Stream<RealtimeIndexData> get stream => _controller.stream;

  // Reference price anchored at first fetch of the day (market open)
  final _refPrice = <String, double>{};
  DateTime? _refDate;

  IndexRealtimeDatasource(this._dio);

  Future<void> connect() async {
    if (_disposed || _pollTimer != null) return;

    _logger.i('IndexRealtime: starting SSI poll (${_pollInterval.inSeconds}s)');

    // Fetch immediately, then schedule next poll after completion
    await _pollAll();
    _schedulePoll();
  }

  void _schedulePoll() {
    if (_disposed || _pollTimer != null) return;
    _pollTimer = Timer(_pollInterval, () async {
      _pollTimer = null;
      if (!_disposed) {
        await _pollAll();
        _schedulePoll();
      }
    });
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
    if (_disposed || _polling) return;
    _polling = true;

    try {
      final now = DateTime.now();
      final nowSec = now.millisecondsSinceEpoch ~/ 1000;

      // Anchor 'from' to market open (9:00 AM Vietnam = UTC+7) for correct
      // daily change. If before 9 AM, use 1 hour back as fallback.
      final marketOpen = DateTime(now.year, now.month, now.day, 9, 0, 0);
      final fromDt = now.isBefore(marketOpen)
          ? now.subtract(const Duration(hours: 1))
          : marketOpen;
      final fromSec = fromDt.millisecondsSinceEpoch ~/ 1000;

      // Reset daily ref prices at start of new trading day
      final today = DateTime(now.year, now.month, now.day);
      if (_refDate != today) {
        _refPrice.clear();
        _refDate = today;
      }

      await Future.wait(
        _symbols.map((sym) => _fetchIndex(sym, fromSec, nowSec)),
      );
    } finally {
      _polling = false;
    }
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

      // Use the open of the FIRST candle since market open as daily reference.
      // Anchored once per day so it doesn't drift as the window rolls forward.
      double prevClose;
      if (!_refPrice.containsKey(symbol) && closes.isNotEmpty) {
        final opens = data['o'] as List?;
        _refPrice[symbol] = opens != null && opens.isNotEmpty
            ? (opens.first as num).toDouble()
            : (closes.first as num).toDouble();
      }
      prevClose = _refPrice[symbol] ?? latestClose;

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
