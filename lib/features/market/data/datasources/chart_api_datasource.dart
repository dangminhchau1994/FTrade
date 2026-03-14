import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/chart_point.dart';

class ChartApiDatasource {
  final Dio _dio;
  final _dateFormat = DateFormat('yyyy-MM-dd');

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
}
