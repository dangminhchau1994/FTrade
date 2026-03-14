import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/market_mock_datasource.dart';
import '../../domain/entities/market_index.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/stock_detail.dart';

final marketDatasourceProvider = Provider((ref) => MarketMockDatasource());

final marketIndicesProvider = FutureProvider<List<MarketIndex>>((ref) {
  return ref.watch(marketDatasourceProvider).getMarketIndices();
});

final topGainersProvider = FutureProvider<List<Stock>>((ref) {
  return ref.watch(marketDatasourceProvider).getTopGainers();
});

final topLosersProvider = FutureProvider<List<Stock>>((ref) {
  return ref.watch(marketDatasourceProvider).getTopLosers();
});

final topVolumeProvider = FutureProvider<List<Stock>>((ref) {
  return ref.watch(marketDatasourceProvider).getTopVolume();
});

final stockDetailProvider =
    FutureProvider.family<StockDetail, String>((ref, symbol) {
  return ref.watch(marketDatasourceProvider).getStockDetail(symbol);
});
