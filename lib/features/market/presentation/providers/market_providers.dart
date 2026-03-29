import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/chart_api_datasource.dart';
import '../../data/datasources/market_api_datasource.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/market_index.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/stock_detail.dart';
import 'market_data_controller.dart';

final chartApiDatasourceProvider = Provider<ChartApiDatasource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return ChartApiDatasource(dio);
});

final marketApiDatasourceProvider = Provider<MarketApiDatasource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return MarketApiDatasource(dio);
});

final marketIndicesProvider = FutureProvider<List<MarketIndex>>((ref) {
  return ref.watch(marketApiDatasourceProvider).getMarketIndices();
});

final topGainersProvider = FutureProvider<List<Stock>>((ref) async {
  return ref.watch(marketApiDatasourceProvider).getTopGainers();
});

final topLosersProvider = FutureProvider<List<Stock>>((ref) async {
  return ref.watch(marketApiDatasourceProvider).getTopLosers();
});

final topVolumeProvider = FutureProvider<List<Stock>>((ref) async {
  return ref.watch(marketApiDatasourceProvider).getTopVolume();
});

final stockDetailProvider = FutureProvider.family<StockDetail, String>((
  ref,
  symbol,
) async {
  return ref.watch(marketApiDatasourceProvider).getStockDetail(symbol);
});

final searchResultsProvider = FutureProvider.family<List<Stock>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  return ref.watch(marketApiDatasourceProvider).searchStocks(query);
});

final indexTopGainersProvider =
    FutureProvider.family<List<Stock>, String>((ref, exchange) async {
  return ref.watch(marketApiDatasourceProvider).getTopGainersForExchange(exchange);
});

final indexTopLosersProvider =
    FutureProvider.family<List<Stock>, String>((ref, exchange) async {
  return ref.watch(marketApiDatasourceProvider).getTopLosersForExchange(exchange);
});

final indexChartProvider =
    FutureProvider.family<List<ChartPoint>, ({String symbol, String period})>(
  (ref, args) async {
    return ref
        .watch(chartApiDatasourceProvider)
        .getIndexChartData(args.symbol, period: args.period);
  },
);

// Map symbol realtime → tên hiển thị (REST)
const _symbolToName = {
  'VNINDEX': 'VN-Index',
  'HNXINDEX': 'HNX-Index',
  'UPCOMINDEX': 'UPCOM',
  'VN30': 'VN30',
  'HNX30': 'HNX30',
};


final indexBySymbolProvider =
    Provider.family<AsyncValue<MarketIndex?>, String>((ref, symbol) {
  return ref.watch(realtimeMarketIndicesProvider).whenData((indices) {
    final name = _symbolToName[symbol];
    return indices.where((i) => i.name == name).firstOrNull;
  });
});

// Map tên hiển thị (REST) → symbol dùng trong realtime stream
const _indexNameToSymbol = {
  'VN-Index': 'VNINDEX',
  'HNX-Index': 'HNXINDEX',
  'UPCOM': 'UPCOMINDEX',
  'VN30': 'VN30',
  'HNX30': 'HNX30',
};

/// Market indices với realtime overlay.
/// Fallback về REST data nếu chưa có realtime data.
final realtimeMarketIndicesProvider = Provider<AsyncValue<List<MarketIndex>>>((ref) {
  final restAsync = ref.watch(marketIndicesProvider);
  final rtState = ref.watch(marketDataControllerProvider);

  return restAsync.whenData((indices) {
    return indices.map((idx) {
      final symbol = _indexNameToSymbol[idx.name];
      if (symbol == null) return idx;

      final rt = rtState.indices[symbol];
      if (rt == null) return idx; // chưa có realtime data → dùng REST

      // Recompute change from REST prev close + SSI latest value.
      // SSI polling only has 10-min candle data, so its change is wrong
      // (relative to 10-min ago, not previous day close).
      final prevClose = idx.value - idx.change;
      final newChange = prevClose > 0 ? rt.value - prevClose : rt.change;
      final newChangePct =
          prevClose > 0 ? newChange / prevClose * 100 : rt.changePercent;

      return idx.copyWith(
        value: rt.value,
        change: newChange,
        changePercent: newChangePct,
        advances: rt.advances ?? idx.advances,
        declines: rt.declines ?? idx.declines,
        unchanged: rt.unchanged ?? idx.unchanged,
        updatedAt: rt.updatedAt,
      );
    }).toList();
  });
});
