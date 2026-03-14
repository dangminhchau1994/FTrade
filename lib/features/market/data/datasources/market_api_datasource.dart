import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/market_index.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/stock_detail.dart';

class MarketApiDatasource {
  final Dio _dio;
  static const _vietstockOrigin = 'https://stockchart.vietstock.vn';
  static const _vietstockHeaders = {
    'Origin': _vietstockOrigin,
    'Referer': '$_vietstockOrigin/',
    'User-Agent': 'Mozilla/5.0',
  };

  MarketApiDatasource(this._dio);

  final _dateFormat = DateFormat('yyyy-MM-dd');

  /// Market indices - VNDirect doesn't have a public index endpoint,
  /// so we combine Vietstock index quotes with VNDirect breadth data.
  Future<List<MarketIndex>> getMarketIndices() async {
    final latestTradingDate = await _getLatestTradingDate();
    final results = await Future.wait<Object>([
      _fetchIndexQuote('VNINDEX'),
      _fetchIndexQuote('HNXINDEX'),
      _fetchIndexQuote('UPCOMINDEX'),
      _fetchMarketBreadth('HOSE', latestTradingDate),
      _fetchMarketBreadth('HNX', latestTradingDate),
      _fetchMarketBreadth('UPCOM', latestTradingDate),
    ]);

    return [
      _buildMarketIndex(
        name: 'VN-Index',
        quote: results[0] as Map<String, dynamic>,
        breadth: results[3] as _MarketBreadth,
      ),
      _buildMarketIndex(
        name: 'HNX-Index',
        quote: results[1] as Map<String, dynamic>,
        breadth: results[4] as _MarketBreadth,
      ),
      _buildMarketIndex(
        name: 'UPCOM',
        quote: results[2] as Map<String, dynamic>,
        breadth: results[5] as _MarketBreadth,
      ),
    ];
  }

  /// Top gainers - sorted by pctChange descending
  Future<List<Stock>> getTopGainers() async {
    final today = await _getLatestTradingDate();
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'floor:HOSE~date:$today~type:STOCK',
        'size': 10,
        'sort': 'pctChange:desc',
      },
    );
    return _parseStockList(response.data);
  }

  /// Top losers - sorted by pctChange ascending
  Future<List<Stock>> getTopLosers() async {
    final today = await _getLatestTradingDate();
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'floor:HOSE~date:$today~type:STOCK',
        'size': 10,
        'sort': 'pctChange:asc',
      },
    );
    return _parseStockList(response.data);
  }

  /// Top volume - sorted by nmVolume descending
  Future<List<Stock>> getTopVolume() async {
    final today = await _getLatestTradingDate();
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'floor:HOSE~date:$today~type:STOCK',
        'size': 10,
        'sort': 'nmVolume:desc',
      },
    );
    return _parseStockList(response.data);
  }

  /// Stock detail with fundamentals from ratios API
  Future<StockDetail> getStockDetail(String symbol) async {
    final priceFuture = _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'code:$symbol',
        'size': 1,
        'sort': 'date:desc',
      },
    );

    final ratioFuture = _dio.get(
      ApiConstants.ratios,
      queryParameters: {
        'filter': 'code:$symbol',
        'where': 'itemCode:${ApiConstants.ratioPE},${ApiConstants.ratioPB},${ApiConstants.ratioMarketCap}',
        'order': 'reportDate',
      },
    );

    final stockInfoFuture = _dio.get(
      ApiConstants.stocks,
      queryParameters: {
        'q': 'code:$symbol~type:STOCK',
        'size': 1,
      },
    );

    final priceResponse = await priceFuture;

    Response<dynamic>? ratioResponse;
    Response<dynamic>? stockInfoResponse;

    try {
      ratioResponse = await ratioFuture;
    } catch (_) {
      ratioResponse = null;
    }

    try {
      stockInfoResponse = await stockInfoFuture;
    } catch (_) {
      stockInfoResponse = null;
    }

    final priceData = (priceResponse.data['data'] as List?)?.firstOrNull;
    final ratioData = ratioResponse?.data['data'] as List? ?? [];
    final stockInfo = (stockInfoResponse?.data['data'] as List?)?.firstOrNull;

    if (priceData == null) {
      throw Exception('No price data found for $symbol');
    }

    // Parse ratios
    double? pe, pb, marketCap;
    for (final r in ratioData) {
      final code = r['itemCode'] as String?;
      final value = (r['value'] as num?)?.toDouble();
      if (code == ApiConstants.ratioPE) pe = value;
      if (code == ApiConstants.ratioPB) pb = value;
      if (code == ApiConstants.ratioMarketCap) marketCap = value;
    }

    final price = (priceData['close'] as num).toDouble();
    final change = (priceData['change'] as num?)?.toDouble() ?? 0;
    final basicPrice = (priceData['basicPrice'] as num?)?.toDouble() ?? price;
    final pctChange = (priceData['pctChange'] as num?)?.toDouble() ?? 0;

    return StockDetail(
      symbol: symbol,
      companyName: (stockInfo?['companyName'] as String?) ??
          (stockInfo?['shortName'] as String?) ??
          symbol,
      exchange: (priceData['floor'] as String?) ?? 'HOSE',
      price: price * 1000, // API returns in 1000 VND
      change: change * 1000,
      changePercent: pctChange,
      high: ((priceData['high'] as num?)?.toDouble() ?? price) * 1000,
      low: ((priceData['low'] as num?)?.toDouble() ?? price) * 1000,
      open: ((priceData['open'] as num?)?.toDouble() ?? price) * 1000,
      prevClose: (basicPrice) * 1000,
      volume: (priceData['nmVolume'] as num?)?.toInt() ?? 0,
      ceiling: ((priceData['ceilingPrice'] as num?)?.toDouble() ?? 0) * 1000,
      floor: ((priceData['floorPrice'] as num?)?.toDouble() ?? 0) * 1000,
      refPrice: basicPrice * 1000,
      pe: pe,
      pb: pb,
      marketCap: marketCap,
      foreignBuy: null,
      foreignSell: null,
      updatedAt: DateTime.now(),
    );
  }

  /// Search stocks by symbol or company name
  Future<List<Stock>> searchStocks(String query) async {
    // First search by code
    final response = await _dio.get(
      ApiConstants.stocks,
      queryParameters: {
        'q': 'type:STOCK~status:listed~code:$query',
        'size': 20,
      },
    );

    final stockData = response.data['data'] as List? ?? [];
    if (stockData.isEmpty) {
      // Try broader search
      final broadResponse = await _dio.get(
        ApiConstants.stocks,
        queryParameters: {
          'q': 'type:STOCK~status:listed',
          'size': 1000,
        },
      );
      final allStocks = broadResponse.data['data'] as List? ?? [];
      final matched = allStocks.where((s) {
        final code = (s['code'] as String?) ?? '';
        final name = (s['companyName'] as String?) ?? '';
        final q = query.toUpperCase();
        return code.toUpperCase().contains(q) ||
            name.toUpperCase().contains(q);
      }).take(20).toList();
      return _fetchPricesForSymbols(matched);
    }

    return _fetchPricesForSymbols(stockData);
  }

  Future<List<Stock>> getStocksBySymbols(List<String> symbols) async {
    final uniqueSymbols = _normalizeSymbols(symbols);
    if (uniqueSymbols.isEmpty) return [];

    final latestDate = await _getLatestTradingDate();
    final stocks = await _fetchStocksForDate(uniqueSymbols, latestDate);
    final stocksBySymbol = {
      for (final stock in stocks) stock.symbol: stock,
    };

    final missingSymbols = uniqueSymbols
        .where((symbol) => !stocksBySymbol.containsKey(symbol))
        .toList();
    if (missingSymbols.isNotEmpty) {
      final fallbackStocks = await Future.wait(
        missingSymbols.map(_fetchLatestStockForSymbol),
      );
      for (final stock in fallbackStocks.whereType<Stock>()) {
        stocksBySymbol[stock.symbol] = stock;
      }
    }

    return uniqueSymbols
        .map((symbol) => stocksBySymbol[symbol])
        .whereType<Stock>()
        .toList();
  }

  /// Fetch chart data for a symbol
  Future<List<Map<String, dynamic>>> getChartData(
    String symbol, {
    required String period,
  }) async {
    final now = DateTime.now();
    DateTime fromDate;

    switch (period) {
      case '1D':
        fromDate = now.subtract(const Duration(days: 1));
      case '1W':
        fromDate = now.subtract(const Duration(days: 7));
      case '1M':
        fromDate = now.subtract(const Duration(days: 30));
      case '3M':
        fromDate = now.subtract(const Duration(days: 90));
      case '1Y':
        fromDate = now.subtract(const Duration(days: 365));
      default:
        fromDate = now.subtract(const Duration(days: 30));
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
    return data.map<Map<String, dynamic>>((d) => {
      'date': d['date'],
      'open': ((d['open'] as num?)?.toDouble() ?? 0) * 1000,
      'high': ((d['high'] as num?)?.toDouble() ?? 0) * 1000,
      'low': ((d['low'] as num?)?.toDouble() ?? 0) * 1000,
      'close': ((d['close'] as num?)?.toDouble() ?? 0) * 1000,
      'volume': (d['nmVolume'] as num?)?.toInt() ?? 0,
    }).toList();
  }

  // --- Private helpers ---

  Future<String> _getLatestTradingDate() async {
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'code:FPT',
        'size': 1,
        'sort': 'date:desc',
      },
    );
    final data = response.data['data'] as List? ?? [];
    if (data.isNotEmpty) {
      return data.first['date'] as String;
    }
    return _dateFormat.format(DateTime.now());
  }

  Future<Map<String, dynamic>> _fetchIndexQuote(String symbol) async {
    final response = await _dio.get(
      '${ApiConstants.vietstockTvNew}/quotes',
      queryParameters: {
        'symbols': symbol,
      },
      options: Options(headers: _vietstockHeaders),
    );

    final payload = response.data as Map<String, dynamic>? ?? const {};
    final quotes = payload['d'] as List? ?? [];
    if (payload['s'] != 'ok' || quotes.isEmpty) {
      throw Exception('No quote data found for $symbol');
    }

    final quote = quotes.first as Map;
    final values = quote['v'];
    if (values is! Map) {
      throw Exception('Invalid quote payload for $symbol');
    }
    return Map<String, dynamic>.from(values);
  }

  Future<_MarketBreadth> _fetchMarketBreadth(String floor, String date) async {
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'floor:$floor~date:$date~type:STOCK',
        'size': 2000,
      },
    );

    final data = response.data['data'] as List? ?? [];
    int advances = 0;
    int declines = 0;
    int unchanged = 0;
    double totalVolume = 0;

    for (final item in data) {
      final row = item as Map;
      final change = (row['change'] as num?)?.toDouble() ?? 0;
      final volume = (row['nmVolume'] as num?)?.toDouble() ?? 0;
      totalVolume += volume;

      if (change > 0) {
        advances++;
      } else if (change < 0) {
        declines++;
      } else {
        unchanged++;
      }
    }

    return _MarketBreadth(
      advances: advances,
      declines: declines,
      unchanged: unchanged,
      totalVolume: totalVolume.toInt(),
    );
  }

  MarketIndex _buildMarketIndex({
    required String name,
    required Map<String, dynamic> quote,
    required _MarketBreadth breadth,
  }) {
    final volumeValue =
        (quote['volume '] as num?)?.toInt() ??
        (quote['volume'] as num?)?.toInt() ??
        breadth.totalVolume;

    return MarketIndex(
      name: name,
      value: (quote['lp'] as num?)?.toDouble() ?? 0,
      change: (quote['ch'] as num?)?.toDouble() ?? 0,
      changePercent: (quote['chp'] as num?)?.toDouble() ?? 0,
      totalVolume: volumeValue,
      advances: breadth.advances,
      declines: breadth.declines,
      unchanged: breadth.unchanged,
      updatedAt: DateTime.now(),
    );
  }

  List<Stock> _parseStockList(Map<String, dynamic> responseData) {
    final data = responseData['data'] as List? ?? [];
    return data.map<Stock>((d) {
      final price = (d['close'] as num?)?.toDouble() ?? 0;
      final change = (d['change'] as num?)?.toDouble() ?? 0;
      return Stock(
        symbol: d['code'] as String,
        price: price * 1000,
        change: change * 1000,
        changePercent: (d['pctChange'] as num?)?.toDouble() ?? 0,
        high: ((d['high'] as num?)?.toDouble() ?? price) * 1000,
        low: ((d['low'] as num?)?.toDouble() ?? price) * 1000,
        open: ((d['open'] as num?)?.toDouble() ?? price) * 1000,
        prevClose: ((d['basicPrice'] as num?)?.toDouble() ?? price) * 1000,
        volume: (d['nmVolume'] as num?)?.toInt() ?? 0,
        exchange: (d['floor'] as String?) ?? 'HOSE',
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  Future<List<Stock>> _fetchPricesForSymbols(List stockData) async {
    final symbols = stockData
        .map<String>((s) => s['code'] as String)
        .toList();

    return getStocksBySymbols(symbols);
  }

  Future<List<Stock>> _fetchStocksForDate(
    List<String> symbols,
    String date,
  ) async {
    final stocks = <Stock>[];

    for (final chunk in _chunkSymbols(symbols, 50)) {
      final response = await _dio.get(
        ApiConstants.stockPrices,
        queryParameters: {
          'q': 'code:in:(${chunk.join(",")})~date:$date',
          'size': chunk.length,
        },
      );
      stocks.addAll(_parseStockList(response.data));
    }

    return stocks;
  }

  Future<Stock?> _fetchLatestStockForSymbol(String symbol) async {
    final response = await _dio.get(
      ApiConstants.stockPrices,
      queryParameters: {
        'q': 'code:$symbol',
        'size': 1,
        'sort': 'date:desc',
      },
    );

    final stocks = _parseStockList(response.data);
    return stocks.isEmpty ? null : stocks.first;
  }

  List<String> _normalizeSymbols(List<String> symbols) {
    final normalized = <String>[];
    final seen = <String>{};

    for (final symbol in symbols) {
      final value = symbol.trim().toUpperCase();
      if (value.isNotEmpty && seen.add(value)) {
        normalized.add(value);
      }
    }

    return normalized;
  }

  Iterable<List<String>> _chunkSymbols(List<String> symbols, int size) sync* {
    for (var i = 0; i < symbols.length; i += size) {
      final end = (i + size < symbols.length) ? i + size : symbols.length;
      yield symbols.sublist(i, end);
    }
  }
}

class _MarketBreadth {
  final int advances;
  final int declines;
  final int unchanged;
  final int totalVolume;

  const _MarketBreadth({
    required this.advances,
    required this.declines,
    required this.unchanged,
    required this.totalVolume,
  });
}
