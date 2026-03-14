import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/money_flow_mock_datasource.dart';
import '../../domain/entities/foreign_flow.dart';
import '../../domain/entities/market_flow_summary.dart';

final moneyFlowDatasourceProvider =
    Provider((ref) => MoneyFlowMockDatasource());

final marketFlowSummaryProvider =
    FutureProvider<MarketFlowSummary>((ref) async {
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
