import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/chart_point.dart';

class ChartApiDatasource {
  final Dio _dio;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  static const _ssiChartUrl =
      'https://iboard-api.ssi.com.vn/statistics/charts/history';

  ChartApiDatasource(this._dio);

  Future<List<ChartPoint>> getChartData(
    String symbol, {
    required String period,
  }) async {
    final now = DateTime.now();
    DateTime fromDate;

    switch (period) {
      case '1D':
        fromDate = now.subtract(const Duration(days: 3));
      case '1W':
        fromDate = now.subtract(const Duration(days: 10));
      case '1M':
        fromDate = now.subtract(const Duration(days: 35));
      case '3M':
        fromDate = now.subtract(const Duration(days: 100));
      case '1Y':
        fromDate = now.subtract(const Duration(days: 370));
      default:
        fromDate = now.subtract(const Duration(days: 35));
    }

    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'code:$symbol~date:gte:${_dateFormat.format(fromDate)}',
        'size': 365,
        'sort': 'date:asc',
      },
    );

    final data = response.data['data'] as List? ?? [];
    return data.map<ChartPoint>((d) {
      return ChartPoint(
        date: DateTime.parse(d['date'] as String),
        open: ((d['open'] as num?)?.toDouble() ?? 0) * 1000,
        high: ((d['high'] as num?)?.toDouble() ?? 0) * 1000,
        low: ((d['low'] as num?)?.toDouble() ?? 0) * 1000,
        close: ((d['close'] as num?)?.toDouble() ?? 0) * 1000,
        volume: (d['nmVolume'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  /// Latest session's intraday bars (15-min resolution) via SSI chart API.
  /// Looks back 3 days so weekends/holidays fall back to the last trading day.
  Future<List<ChartPoint>> getIntradayChartData(String symbol) async {
    final now = DateTime.now();
    final from = now.subtract(const Duration(days: 3));
    final response = await _dio.get(
      _ssiChartUrl,
      queryParameters: {
        'symbol': symbol,
        'resolution': '1',
        'from': from.millisecondsSinceEpoch ~/ 1000,
        'to': now.millisecondsSinceEpoch ~/ 1000,
      },
    );
    final payload = response.data as Map<String, dynamic>;
    if (payload['code'] != 'SUCCESS') return [];
    final d = payload['data'] as Map<String, dynamic>;
    final t = d['t'] as List? ?? [];
    final c = d['c'] as List? ?? [];
    if (t.isEmpty) return [];

    final all = List.generate(t.length, (i) => ChartPoint(
      date: DateTime.fromMillisecondsSinceEpoch((t[i] as num).toInt() * 1000),
      open: 0, high: 0, low: 0,
      close: (c[i] as num).toDouble(),
      volume: 0,
    ));

    // Keep only bars from the last trading day
    final lastDate = all.last.date;
    final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
    return all.where((p) {
      final d = DateTime(p.date.year, p.date.month, p.date.day);
      return d == lastDay;
    }).toList();
  }

  /// Historical OHLCV for market indices (VNINDEX, HNXINDEX, UPCOMINDEX).
  /// Uses SSI iboard chart API (no auth required).
  Future<List<ChartPoint>> getIndexChartData(
    String symbol, {
    required String period,
  }) async {
    final now = DateTime.now();
    final fromDate = switch (period) {
      '1M' => now.subtract(const Duration(days: 35)),
      '3M' => now.subtract(const Duration(days: 100)),
      '6M' => now.subtract(const Duration(days: 200)),
      '1Y' => now.subtract(const Duration(days: 400)),
      '5Y' => now.subtract(const Duration(days: 1900)),
      _ => now.subtract(const Duration(days: 100)),
    };

    final response = await _dio.get(
      _ssiChartUrl,
      queryParameters: {
        'symbol': symbol,
        'resolution': 'D',
        'from': fromDate.millisecondsSinceEpoch ~/ 1000,
        'to': now.millisecondsSinceEpoch ~/ 1000,
      },
    );

    final payload = response.data as Map<String, dynamic>;
    if (payload['code'] != 'SUCCESS') return [];

    final d = payload['data'] as Map<String, dynamic>;
    final t = d['t'] as List? ?? [];
    final o = d['o'] as List? ?? [];
    final h = d['h'] as List? ?? [];
    final l = d['l'] as List? ?? [];
    final c = d['c'] as List? ?? [];
    final v = d['v'] as List? ?? [];

    return List.generate(t.length, (i) {
      return ChartPoint(
        date: DateTime.fromMillisecondsSinceEpoch((t[i] as num).toInt() * 1000),
        open: (o[i] as num).toDouble(),
        high: (h[i] as num).toDouble(),
        low: (l[i] as num).toDouble(),
        close: (c[i] as num).toDouble(),
        volume: (v[i] as num).toInt(),
      );
    });
  }
}
