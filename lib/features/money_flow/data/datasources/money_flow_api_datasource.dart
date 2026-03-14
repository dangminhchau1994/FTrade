import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/vietstock_finance_client.dart';
import '../../domain/entities/foreign_flow.dart';
import '../../domain/entities/market_flow_summary.dart';

class MoneyFlowApiDatasource {
  MoneyFlowApiDatasource(this._dio)
    : _vietstockClient = VietstockFinanceClient(_dio);

  final Dio _dio;
  final VietstockFinanceClient _vietstockClient;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  final Map<String, _TimedCache<_ForeignTradingBatch>> _batchCache = {};
  final Map<String, _TimedCache<List<ForeignFlow>>> _flowCache = {};
  final Map<String, _TimedCache<_MarketTotals>> _totalsCache = {};
  _TimedCache<DateTime>? _latestTradingDateCache;

  static const _exchangeIds = ['1', '2', '3'];
  static const _pageSize = 50;
  static const _cacheTtl = Duration(seconds: 10);

  Future<MarketFlowSummary> getMarketFlowSummary() async {
    final tradingDate = await _getLatestTradingDate();
    final totals = await _getMarketTotals(tradingDate);
    final flows = await _getAllFlows(tradingDate);

    return MarketFlowSummary(
      totalForeignBuy: totals.buyValue,
      totalForeignSell: totals.sellValue,
      totalForeignNet: totals.netValue,
      topNetBuyers: _topBuyers(flows),
      topNetSellers: _topSellers(flows),
      date: tradingDate,
    );
  }

  Future<List<ForeignFlow>> getTopNetBuyers() async {
    final tradingDate = await _getLatestTradingDate();
    return _topBuyers(await _getAllFlows(tradingDate));
  }

  Future<List<ForeignFlow>> getTopNetSellers() async {
    final tradingDate = await _getLatestTradingDate();
    return _topSellers(await _getAllFlows(tradingDate));
  }

  Future<List<ForeignFlow>> getForeignFlowHistory(String symbol) async {
    final recentDates = await _getRecentTradingDates(10);
    final normalizedSymbol = symbol.toUpperCase();
    final history = <ForeignFlow>[];

    for (final date in recentDates) {
      if (_isMarketSymbol(normalizedSymbol)) {
        final totals = await _getMarketTotals(date);
        history.add(
          ForeignFlow(
            symbol: normalizedSymbol,
            buyVolume: totals.buyVolume,
            sellVolume: totals.sellVolume,
            netVolume: totals.netVolume,
            buyValue: totals.buyValue,
            sellValue: totals.sellValue,
            netValue: totals.netValue,
            date: date,
          ),
        );
        continue;
      }

      final dailyFlows = await _getAllFlows(date);
      final flow = dailyFlows.where((item) => item.symbol == normalizedSymbol);
      history.add(
        flow.isNotEmpty
            ? flow.first.copyWith(date: date)
            : ForeignFlow(
              symbol: normalizedSymbol,
              buyVolume: 0,
              sellVolume: 0,
              netVolume: 0,
              buyValue: 0,
              sellValue: 0,
              netValue: 0,
              date: date,
            ),
      );
    }

    return history;
  }

  Future<List<ForeignFlow>> _getAllFlows(DateTime date) async {
    final cacheKey = _dateFormat.format(date);
    final cached = _readCache(_flowCache, cacheKey);
    if (cached != null) {
      return cached;
    }

    final exchangeFlows = await Future.wait(
      _exchangeIds.map((exchangeId) => _fetchExchangeFlows(date, exchangeId)),
    );

    final merged = _mergeFlows(exchangeFlows.expand((items) => items).toList());
    _flowCache[cacheKey] = _TimedCache(
      value: merged,
      fetchedAt: DateTime.now(),
    );
    return merged;
  }

  Future<List<ForeignFlow>> _fetchExchangeFlows(
    DateTime date,
    String exchangeId,
  ) async {
    final firstBatch = await _fetchExchangeBatch(
      date: date,
      exchangeId: exchangeId,
      page: 1,
    );

    final rows = <Map<String, dynamic>>[...firstBatch.rows];
    final totalPages = (firstBatch.totalRecords / _pageSize).ceil();

    if (totalPages > 1) {
      final extraBatches = await Future.wait(
        List.generate(
          totalPages - 1,
          (index) => _fetchExchangeBatch(
            date: date,
            exchangeId: exchangeId,
            page: index + 2,
          ),
        ),
      );

      for (final batch in extraBatches) {
        rows.addAll(batch.rows);
      }
    }

    return rows.map((row) => _mapFlowRow(row, date)).toList();
  }

  Future<_ForeignTradingBatch> _fetchExchangeBatch({
    required DateTime date,
    required String exchangeId,
    required int page,
  }) async {
    final cacheKey = '${_dateFormat.format(date)}|$exchangeId|$page';
    final cached = _readCache(_batchCache, cacheKey);
    if (cached != null) {
      return cached;
    }

    final data = await _vietstockClient.postForm(
      url: ApiConstants.vietstockForeignTrading,
      referer: ApiConstants.vietstockMoneyFlowPage,
      data: {
        'code': '',
        'catID': exchangeId,
        'fDate': _dateFormat.format(date),
        'tDate': _dateFormat.format(date),
        'page': page,
        'pageSize': _pageSize,
        'orderBy': 'Code',
        'orderDir': 'asc',
      },
    );

    final payload = data as List? ?? const [];
    final rowsPayload =
        payload.length > 1 ? payload[1] as List? ?? const [] : const [];
    final summaryPayload =
        payload.length > 2 ? payload[2] as List? ?? const [] : const [];
    final totalPayload =
        payload.length > 3 ? payload[3] as List? ?? const [] : const [];

    final batch = _ForeignTradingBatch(
      rows:
          rowsPayload
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList(),
      totals:
          summaryPayload.isNotEmpty
              ? _MarketTotals.fromJson(
                Map<String, dynamic>.from(summaryPayload.first as Map),
              )
              : const _MarketTotals.empty(),
      totalRecords:
          totalPayload.isNotEmpty
              ? _toDouble(totalPayload.first).round()
              : rowsPayload.length,
    );

    _batchCache[cacheKey] = _TimedCache(
      value: batch,
      fetchedAt: DateTime.now(),
    );
    return batch;
  }

  Future<_MarketTotals> _getMarketTotals(DateTime date) async {
    final cacheKey = _dateFormat.format(date);
    final cached = _readCache(_totalsCache, cacheKey);
    if (cached != null) {
      return cached;
    }

    final batches = await Future.wait(
      _exchangeIds.map(
        (exchangeId) =>
            _fetchExchangeBatch(date: date, exchangeId: exchangeId, page: 1),
      ),
    );

    final totals = batches.fold<_MarketTotals>(
      const _MarketTotals.empty(),
      (current, batch) => current + batch.totals,
    );

    _totalsCache[cacheKey] = _TimedCache(
      value: totals,
      fetchedAt: DateTime.now(),
    );
    return totals;
  }

  Future<DateTime> _getLatestTradingDate() async {
    final cached = _latestTradingDateCache;
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) <
            const Duration(minutes: 5)) {
      return cached.value;
    }

    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {'q': 'code:FPT', 'size': 1, 'sort': 'date:desc'},
    );

    final data = response.data['data'] as List? ?? const [];
    final latest =
        data.isNotEmpty
            ? DateTime.parse((data.first as Map)['date'] as String)
            : DateTime.now();

    _latestTradingDateCache = _TimedCache(
      value: latest,
      fetchedAt: DateTime.now(),
    );
    return latest;
  }

  Future<List<DateTime>> _getRecentTradingDates(int count) async {
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {'q': 'code:FPT', 'size': count, 'sort': 'date:desc'},
    );

    final data = response.data['data'] as List? ?? const [];
    return data
        .map((item) => DateTime.parse((item as Map)['date'] as String))
        .toList()
        .reversed
        .toList();
  }

  List<ForeignFlow> _mergeFlows(List<ForeignFlow> flows) {
    final merged = <String, ForeignFlow>{};

    for (final flow in flows) {
      final current = merged[flow.symbol];
      if (current == null) {
        merged[flow.symbol] = flow;
        continue;
      }

      merged[flow.symbol] = current.copyWith(
        buyVolume: current.buyVolume + flow.buyVolume,
        sellVolume: current.sellVolume + flow.sellVolume,
        netVolume: current.netVolume + flow.netVolume,
        buyValue: current.buyValue + flow.buyValue,
        sellValue: current.sellValue + flow.sellValue,
        netValue: current.netValue + flow.netValue,
      );
    }

    return merged.values.toList();
  }

  List<ForeignFlow> _topBuyers(List<ForeignFlow> flows) {
    final sorted =
        flows.where((item) => item.netValue > 0).toList()
          ..sort((a, b) => b.netValue.compareTo(a.netValue));
    return sorted.take(10).toList();
  }

  List<ForeignFlow> _topSellers(List<ForeignFlow> flows) {
    final sorted =
        flows.where((item) => item.netValue < 0).toList()
          ..sort((a, b) => a.netValue.compareTo(b.netValue));
    return sorted.take(10).toList();
  }

  ForeignFlow _mapFlowRow(Map<String, dynamic> row, DateTime fallbackDate) {
    final buyVolume = _toDouble(row['BuyVol']) + _toDouble(row['BuyPutVol']);
    final sellVolume = _toDouble(row['SellVol']) + _toDouble(row['SellPutVol']);
    final buyValue =
        (_toDouble(row['BuyVal']) + _toDouble(row['BuyPutVal'])) * 1e6;
    final sellValue =
        (_toDouble(row['SellVal']) + _toDouble(row['SellPutVal'])) * 1e6;

    return ForeignFlow(
      symbol: (row['StockCode'] as String? ?? '').toUpperCase(),
      buyVolume: buyVolume,
      sellVolume: sellVolume,
      netVolume: buyVolume - sellVolume,
      buyValue: buyValue,
      sellValue: sellValue,
      netValue: buyValue - sellValue,
      date: _parseVietstockDate(row['TradingDate']) ?? fallbackDate,
    );
  }

  DateTime? _parseVietstockDate(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }

    final text = value.toString();
    final match = RegExp(r'/Date\((\d+)\)/').firstMatch(text);
    if (match != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(match.group(1)!));
    }

    return DateTime.tryParse(text);
  }

  bool _isMarketSymbol(String symbol) {
    return symbol == 'VN-INDEX' ||
        symbol == 'VNINDEX' ||
        symbol == 'MARKET' ||
        symbol == 'ALL';
  }

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString().replaceAll(',', '')) ?? 0;
  }

  T? _readCache<T>(Map<String, _TimedCache<T>> cache, String key) {
    final cached = cache[key];
    if (cached == null) {
      return null;
    }
    if (DateTime.now().difference(cached.fetchedAt) >= _cacheTtl) {
      cache.remove(key);
      return null;
    }
    return cached.value;
  }
}

class _ForeignTradingBatch {
  const _ForeignTradingBatch({
    required this.rows,
    required this.totals,
    required this.totalRecords,
  });

  final List<Map<String, dynamic>> rows;
  final _MarketTotals totals;
  final int totalRecords;
}

class _MarketTotals {
  const _MarketTotals({
    required this.buyVolume,
    required this.sellVolume,
    required this.netVolume,
    required this.buyValue,
    required this.sellValue,
    required this.netValue,
  });

  const _MarketTotals.empty()
    : buyVolume = 0,
      sellVolume = 0,
      netVolume = 0,
      buyValue = 0,
      sellValue = 0,
      netValue = 0;

  factory _MarketTotals.fromJson(Map<String, dynamic> json) {
    final buyVolume =
        json['TotalBuyVol'] != null
            ? _value(json['TotalBuyVol'])
            : _value(json['BuyVol']) + _value(json['BuyPutVol']);
    final sellVolume =
        json['TotalSellVol'] != null
            ? _value(json['TotalSellVol'])
            : _value(json['SellVol']) + _value(json['SellPutVol']);
    final buyValue =
        json['TotalBuyVal'] != null
            ? _value(json['TotalBuyVal']) * 1e6
            : (_value(json['BuyVal']) + _value(json['BuyPutVal'])) * 1e6;
    final sellValue =
        json['TotalSellVal'] != null
            ? _value(json['TotalSellVal']) * 1e6
            : (_value(json['SellVal']) + _value(json['SellPutVal'])) * 1e6;

    return _MarketTotals(
      buyVolume: buyVolume,
      sellVolume: sellVolume,
      netVolume: buyVolume - sellVolume,
      buyValue: buyValue,
      sellValue: sellValue,
      netValue: buyValue - sellValue,
    );
  }

  final double buyVolume;
  final double sellVolume;
  final double netVolume;
  final double buyValue;
  final double sellValue;
  final double netValue;

  _MarketTotals operator +(_MarketTotals other) {
    return _MarketTotals(
      buyVolume: buyVolume + other.buyVolume,
      sellVolume: sellVolume + other.sellVolume,
      netVolume: netVolume + other.netVolume,
      buyValue: buyValue + other.buyValue,
      sellValue: sellValue + other.sellValue,
      netValue: netValue + other.netValue,
    );
  }

  static double _value(dynamic raw, {double fallback = 0}) {
    if (raw == null) {
      return fallback;
    }
    if (raw is num) {
      return raw.toDouble();
    }
    return double.tryParse(raw.toString().replaceAll(',', '')) ?? fallback;
  }
}

class _TimedCache<T> {
  const _TimedCache({required this.value, required this.fetchedAt});

  final T value;
  final DateTime fetchedAt;
}
