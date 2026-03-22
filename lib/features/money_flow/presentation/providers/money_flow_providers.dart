import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/money_flow_api_datasource.dart';
import '../../domain/entities/foreign_flow.dart';
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

final foreignFlowHistoryProvider =
    FutureProvider.family<List<ForeignFlow>, String>((ref, symbol) async {
      final ds = ref.watch(moneyFlowDatasourceProvider);
      return ds.getForeignFlowHistory(symbol);
    });

final volumeAnomaliesProvider = FutureProvider<List<VolumeAnomaly>>((ref) async {
  final ds = ref.watch(moneyFlowDatasourceProvider);
  return ds.getVolumeAnomalies();
});
