import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/chart_api_datasource.dart';
import '../../data/datasources/market_api_datasource.dart';
import '../../domain/entities/market_index.dart';
import '../../domain/entities/stock.dart';
import '../../domain/entities/stock_detail.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

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

final stockDetailProvider =
    FutureProvider.family<StockDetail, String>((ref, symbol) async {
      return ref.watch(marketApiDatasourceProvider).getStockDetail(symbol);
    });

final searchResultsProvider =
    FutureProvider.family<List<Stock>, String>((ref, query) async {
  if (query.isEmpty) return [];
  return ref.watch(marketApiDatasourceProvider).searchStocks(query);
});
