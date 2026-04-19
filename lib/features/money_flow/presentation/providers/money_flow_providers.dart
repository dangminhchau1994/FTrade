import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/money_flow_api_datasource.dart';
import '../../domain/entities/foreign_flow.dart';
import '../../domain/entities/foreign_flow_stats.dart';
import '../../domain/entities/market_flow_summary.dart';
import '../../domain/entities/volume_anomaly.dart';

final moneyFlowDatasourceProvider = Provider<MoneyFlowApiDatasource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return MoneyFlowApiDatasource(dio);
});

final marketFlowSummaryProvider = FutureProvider<MarketFlowSummary>((
  ref,
) async {
  final ds = ref.watch(moneyFlowDatasourceProvider);
  return ds.getMarketFlowSummary();
});

final topNetBuyersProvider = FutureProvider<List<ForeignFlow>>((ref) async {
  final ds = ref.watch(moneyFlowDatasourceProvider);
  return ds.getTopNetBuyers();
});

final topNetSellersProvider = FutureProvider<List<ForeignFlow>>((ref) async {
  final ds = ref.watch(moneyFlowDatasourceProvider);
  return ds.getTopNetSellers();
});

/// [catId]: '' = tất cả, '2' = HSX, '1' = HNX, '3' = UPCOM
final topNetBuyersByCatProvider =
    FutureProvider.family<List<ForeignFlow>, String>((ref, catId) async {
  return ref.watch(moneyFlowDatasourceProvider).getTopNetBuyers(catId: catId);
});

final topNetSellersByCatProvider =
    FutureProvider.family<List<ForeignFlow>, String>((ref, catId) async {
  return ref.watch(moneyFlowDatasourceProvider).getTopNetSellers(catId: catId);
});

/// All non-zero flows for a given exchange sorted by |netValue| — used by heatmap.
final foreignHeatmapProvider =
    FutureProvider.family<List<ForeignFlow>, String>((ref, catId) async {
  return ref.watch(moneyFlowDatasourceProvider).getHeatmapFlows(catId: catId);
});

final foreignFlowHistoryProvider =
    FutureProvider.family<List<ForeignFlow>, String>((ref, symbol) async {
      final ds = ref.watch(moneyFlowDatasourceProvider);
      return ds.getForeignFlowHistory(symbol);
    });

final volumeAnomaliesProvider = FutureProvider<List<VolumeAnomaly>>((ref) async {
  final ds = ref.watch(moneyFlowDatasourceProvider);
  return ds.getVolumeAnomalies();
});

/// [catId]: '' = tất cả, '2' = HSX, '1' = HNX, '3' = UPCOM
final foreignExchangeSummaryProvider =
    FutureProvider.family<ForeignFlowStats, String>((ref, catId) async {
  return ref.watch(moneyFlowDatasourceProvider).getExchangeSummary(catId: catId);
});

final foreignExchangeHistoryProvider =
    FutureProvider.family<List<ForeignFlow>, String>((ref, catId) async {
  return ref.watch(moneyFlowDatasourceProvider).getExchangeFlowHistory(catId: catId);
});
