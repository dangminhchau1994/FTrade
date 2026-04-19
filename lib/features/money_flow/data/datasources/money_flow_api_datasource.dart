import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/vietstock_finance_client.dart';
import '../../domain/entities/foreign_flow.dart';
import '../../domain/entities/foreign_flow_stats.dart';
import '../../domain/entities/market_flow_summary.dart';
import '../../domain/entities/volume_anomaly.dart';

class MoneyFlowApiDatasource {
  MoneyFlowApiDatasource(this._dio)
    : _vietstockClient = VietstockFinanceClient(_dio);

  final Dio _dio;
  final VietstockFinanceClient _vietstockClient;
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _masvnDateFormat = DateFormat('yyyyMMdd');

  final Map<String, _TimedCache<_ForeignTradingBatch>> _batchCache = {};
  final Map<String, _TimedCache<List<ForeignFlow>>> _flowCache = {};
  final Map<String, _TimedCache<_MarketTotals>> _totalsCache = {};
  _TimedCache<DateTime>? _latestTradingDateCache;
  _TimedCache<ForeignFlowStats>? _allMarketSummaryCache;
  final Map<String, _TimedCache<List<String>>> _exchangeCodesCache = {};
  final Map<String, _TimedCache<List<ForeignFlow>>> _exchangeHistoryCache = {};
  final Map<String, _TimedCache<List<ForeignFlow>>> _heatmapCache = {};
  // Prevents duplicate concurrent fetches per exchange.
  final Map<String, Future<List<ForeignFlow>>?> _exchangeHistoryInFlight = {};

  static const _exchangeIds = ['1', '2', '3'];
  static const _pageSize = 50;
  static const _cacheTtl = Duration(seconds: 10);
  static const _hoseFlowCacheTtl = Duration(minutes: 5);
  static const _hoseCodesCacheTtl = Duration(hours: 6);

  static const _masvnForeignHistoryUrl =
      'https://masboard.masvn.com/api/v2/vs/foreignHistory';

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

  Future<List<ForeignFlow>> getTopNetBuyers({String catId = ''}) async {
    final tradingDate = await _getLatestTradingDate();
    return _topBuyers(await _getAllFlows(tradingDate, catId: catId));
  }

  Future<List<ForeignFlow>> getTopNetSellers({String catId = ''}) async {
    final tradingDate = await _getLatestTradingDate();
    return _topSellers(await _getAllFlows(tradingDate, catId: catId));
  }

  /// Per-stock foreign flows for a given exchange on the latest trading date.
  /// Uses MASVN per-stock data (same source as Fireant) — sorted by |netValue|.
  Future<List<ForeignFlow>> getHeatmapFlows({String catId = ''}) async {
    final cacheKey = catId.isEmpty ? 'all' : catId;
    final cached = _heatmapCache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) < _hoseFlowCacheTtl) {
      return cached.value;
    }

    final floor = catId.isEmpty ? 'HOSE' : (_catIdToFloor[catId] ?? 'HOSE');
    final tradingDate = await _getLatestTradingDate();
    final tradingDateStr = _masvnDateFormat.format(tradingDate);

    final codes = await _getExchangeStockCodes(floor);
    if (codes.isEmpty) return [];

    const chunkSize = 50;
    final stockFlows = <ForeignFlow>[];

    for (var i = 0; i < codes.length; i += chunkSize) {
      final end = (i + chunkSize < codes.length) ? i + chunkSize : codes.length;
      final chunkFlows = await Future.wait(
        codes.sublist(i, end).map((sym) async {
          final rows = await _fetchMasvnForeignHistory(sym);
          for (final row in rows) {
            if ((row['TradingDate'] as String? ?? '') == tradingDateStr) {
              final buyVal = _toDouble(row['TotalBuyVal']);
              final sellVal = _toDouble(row['TotalSellVal']);
              final netVal = buyVal - sellVal;
              if (netVal == 0) return null;
              return ForeignFlow(
                symbol: sym,
                buyVolume: _toDouble(row['TotalBuyVol']),
                sellVolume: _toDouble(row['TotalSellVol']),
                netVolume: _toDouble(row['TotalBuyVol']) - _toDouble(row['TotalSellVol']),
                buyValue: buyVal,
                sellValue: sellVal,
                netValue: netVal,
                date: tradingDate,
              );
            }
          }
          return null;
        }),
      );
      stockFlows.addAll(chunkFlows.whereType<ForeignFlow>());
    }

    stockFlows.sort((a, b) => b.netValue.abs().compareTo(a.netValue.abs()));
    final top50 = stockFlows.take(50).toList();
    _heatmapCache[cacheKey] = _TimedCache(value: top50, fetchedAt: DateTime.now());
    return top50;
  }

  /// Top cổ phiếu có KL giao dịch bất thường (ratio = today / avg20d > 1.5)
  Future<List<VolumeAnomaly>> getVolumeAnomalies({int minRatio = 2}) async {
    // 1. Lấy ngày giao dịch gần nhất
    final latestDate = await _getLatestTradingDate();
    final latestDateStr = _dateFormat.format(latestDate);

    // 2. Fetch top stocks by volume (sort date:desc,nmVolume:desc)
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'type:STOCK',
        'sort': 'date:desc,nmVolume:desc',
        'size': 200,
      },
    );

    final allData = (response.data['data'] as List? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .where((r) => r['date'] == latestDateStr && _toDouble(r['nmVolume']) > 0)
        .toList();

    if (allData.isEmpty) return [];

    // 3. Top 50 theo KL hôm nay
    allData.sort((a, b) => _toDouble(b['nmVolume']).compareTo(_toDouble(a['nmVolume'])));
    final top50 = allData.take(50).toList();
    final symbols = top50.map((r) => r['code'] as String).toList();

    // 4. Fetch 21 phiên gần nhất cho top50 (batch)
    final historyResp = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'code:${symbols.join(',')}',
        'sort': 'date:desc',
        'size': symbols.length * 21,
      },
    );

    final histData = (historyResp.data['data'] as List? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .toList();

    // Group volumes by symbol
    final volsBySymbol = <String, List<double>>{};
    for (final r in histData) {
      final code = r['code'] as String;
      volsBySymbol.putIfAbsent(code, () => []);
      if (volsBySymbol[code]!.length < 21) {
        volsBySymbol[code]!.add(_toDouble(r['nmVolume']));
      }
    }

    // 5. Tính anomaly ratio
    final anomalies = <VolumeAnomaly>[];
    for (final r in top50) {
      final symbol = r['code'] as String;
      final vols = volsBySymbol[symbol] ?? [];
      if (vols.length < 5) continue; // không đủ data lịch sử

      final todayVol = vols[0];
      final avgVol = vols.skip(1).fold(0.0, (a, b) => a + b) / (vols.length - 1);
      if (avgVol <= 0) continue;

      final ratio = todayVol / avgVol;
      if (ratio < minRatio) continue;

      anomalies.add(VolumeAnomaly(
        symbol: symbol,
        todayVolume: todayVol,
        avgVolume20d: avgVol,
        ratio: ratio,
        price: _toDouble(r['close']) * 1000,
        changePercent: _toDouble(r['pctChange']),
      ));
    }

    anomalies.sort((a, b) => b.ratio.compareTo(a.ratio));
    return anomalies;
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

  /// Today's totals for an exchange (catId: '2'=HOSE, '1'=HNX, '3'=UPCOM).
  /// catId='' → vsForeignTotal(range:"1D"), all exchanges.
  Future<ForeignFlowStats> getExchangeSummary({String catId = ''}) async {
    if (catId.isEmpty) return _getAllMarketSummary();
    return _getExchangeSummaryMasvn(catId);
  }

  /// 10-session history for an exchange via MASVN per-stock aggregation.
  Future<List<ForeignFlow>> getExchangeFlowHistory({String catId = ''}) async {
    return _getExchangeHistoryMasvn(catId.isEmpty ? '2' : catId);
  }

  // ── MASVN foreign flow (per-exchange, all stocks) ─────────────────────────

  static const _catIdToFloor = {'1': 'HNX', '2': 'HOSE', '3': 'UPCOM'};

  /// vsForeignTotal(range:"1D") — one request covering ALL exchanges today.
  Future<ForeignFlowStats> _getAllMarketSummary() async {
    final cached = _allMarketSummaryCache;
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) < _hoseFlowCacheTtl) {
      return cached.value;
    }
    final today = await _getLatestTradingDate();
    const query =
        'query{vsForeignTotal(range:"1D"){BuyVol,BuyVal,SellVol,SellVal,NetBuyVol,NetBuyVal}}';
    try {
      final response = await _dio.get<dynamic>(
        _masvnForeignHistoryUrl,
        queryParameters: {'query': query},
      );
      final raw = response.data as Map<String, dynamic>? ?? {};
      final stats = ForeignFlowStats(
        buyVolume: _toDouble(raw['BuyVol']),
        sellVolume: _toDouble(raw['SellVol']),
        netVolume: _toDouble(raw['NetBuyVol']),
        buyValue: _toDouble(raw['BuyVal']),
        sellValue: _toDouble(raw['SellVal']),
        netValue: _toDouble(raw['NetBuyVal']),
        date: today,
      );
      _allMarketSummaryCache = _TimedCache(value: stats, fetchedAt: DateTime.now());
      return stats;
    } catch (_) {
      return _getExchangeSummaryMasvn('2');
    }
  }

  /// Fetch stock codes for a given floor (HOSE/HNX/UPCOM) from VNDirect. Cached 6 h.
  Future<List<String>> _getExchangeStockCodes(String floor) async {
    final cached = _exchangeCodesCache[floor];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) < _hoseCodesCacheTtl) {
      return cached.value;
    }
    final response = await _dio.get<dynamic>(
      ApiConstants.stocks,
      queryParameters: {'q': 'floor:$floor~type:STOCK', 'fields': 'code', 'size': 1000},
    );
    final data = (response.data as Map?)?['data'] as List? ?? [];
    final codes = data
        .map((e) => ((e as Map)['code'] as String? ?? '').toUpperCase())
        .where((c) => c.isNotEmpty)
        .toList();
    _exchangeCodesCache[floor] = _TimedCache(value: codes, fetchedAt: DateTime.now());
    return codes;
  }

  Future<List<Map<String, dynamic>>> _fetchMasvnForeignHistory(
    String symbol,
  ) async {
    // fetchCount:15 without date range — avoids multi-day range query
    // which returns empty from Flutter's HTTP stack (works only in curl/Python).
    final query = 'query{vsForeignHistory('
        'StockCode:"$symbol",'
        'fetchCount:15'
        '){TotalBuyVol,TotalSellVol,TotalBuyVal,TotalSellVal,TradingDate}}';
    try {
      final response = await _dio.get<dynamic>(
        _masvnForeignHistoryUrl,
        queryParameters: {'query': query},
      );
      final list = response.data as List? ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ForeignFlow>> _getExchangeHistoryMasvn(String catId) async {
    final cached = _exchangeHistoryCache[catId];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt) < _hoseFlowCacheTtl) {
      return cached.value;
    }
    final inFlight = _exchangeHistoryInFlight[catId];
    if (inFlight != null) return inFlight;

    final future = _fetchExchangeHistoryMasvn(catId);
    _exchangeHistoryInFlight[catId] = future;
    try {
      return await future;
    } finally {
      _exchangeHistoryInFlight[catId] = null;
    }
  }

  Future<List<ForeignFlow>> _fetchExchangeHistoryMasvn(String catId) async {
    final floor = _catIdToFloor[catId] ?? 'HOSE';
    final dates = await _getRecentTradingDates(10);
    if (dates.isEmpty) return [];
    final codes = await _getExchangeStockCodes(floor);
    if (codes.isEmpty) return [];

    // Chunked parallel fetches — avoids overwhelming the iOS HTTP stack.
    const chunkSize = 100;
    final allRows = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < codes.length; i += chunkSize) {
      final end = (i + chunkSize < codes.length) ? i + chunkSize : codes.length;
      final chunkResults = await Future.wait(
        codes.sublist(i, end).map((sym) => _fetchMasvnForeignHistory(sym)),
      );
      allRows.addAll(chunkResults);
    }

    final Map<String, _FlowAccumulator> byDate = {};
    for (final stockRows in allRows) {
      for (final row in stockRows) {
        final key = row['TradingDate'] as String? ?? '';
        if (key.length != 8) continue;
        byDate.putIfAbsent(key, () => _FlowAccumulator());
        byDate[key]!.buyVolume += _toDouble(row['TotalBuyVol']);
        byDate[key]!.sellVolume += _toDouble(row['TotalSellVol']);
        byDate[key]!.buyValue += _toDouble(row['TotalBuyVal']);
        byDate[key]!.sellValue += _toDouble(row['TotalSellVal']);
      }
    }

    final history = dates.map((d) {
      final key = _masvnDateFormat.format(d);
      final t = byDate[key] ?? _FlowAccumulator();
      return ForeignFlow(
        symbol: floor,
        buyVolume: t.buyVolume,
        sellVolume: t.sellVolume,
        netVolume: t.buyVolume - t.sellVolume,
        buyValue: t.buyValue,
        sellValue: t.sellValue,
        netValue: t.buyValue - t.sellValue,
        date: d,
      );
    }).toList();

    _exchangeHistoryCache[catId] = _TimedCache(value: history, fetchedAt: DateTime.now());
    return history;
  }

  /// Derives today's summary from already-fetched history — avoids a duplicate batch.
  Future<ForeignFlowStats> _getExchangeSummaryMasvn(String catId) async {
    final floor = _catIdToFloor[catId] ?? 'HOSE';
    final history = await _getExchangeHistoryMasvn(catId);
    final today = await _getLatestTradingDate();
    final todayKey = _dateFormat.format(today);

    final todayFlow = history.firstWhere(
      (f) => _dateFormat.format(f.date) == todayKey,
      orElse: () => ForeignFlow(
        symbol: floor,
        buyVolume: 0, sellVolume: 0, netVolume: 0,
        buyValue: 0, sellValue: 0, netValue: 0,
        date: today,
      ),
    );

    return ForeignFlowStats(
      buyVolume: todayFlow.buyVolume,
      sellVolume: todayFlow.sellVolume,
      netVolume: todayFlow.netVolume,
      buyValue: todayFlow.buyValue,
      sellValue: todayFlow.sellValue,
      netValue: todayFlow.netValue,
      date: today,
    );
  }

  Future<List<ForeignFlow>> _getAllFlows(DateTime date, {String catId = ''}) async {
    final cacheKey = '${_dateFormat.format(date)}|$catId';
    final cached = _readCache(_flowCache, cacheKey);
    if (cached != null) {
      return cached;
    }

    final idsToFetch = catId.isNotEmpty ? [catId] : _exchangeIds;
    final exchangeFlows = await Future.wait(
      idsToFetch.map((exchangeId) => _fetchExchangeFlows(date, exchangeId)),
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

class _FlowAccumulator {
  double buyVolume = 0;
  double sellVolume = 0;
  double buyValue = 0;
  double sellValue = 0;
}
