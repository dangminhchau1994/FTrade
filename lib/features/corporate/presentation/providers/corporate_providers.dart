import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/corporate_api_datasource.dart';
import '../../domain/entities/corporate_event.dart';
import '../../domain/entities/dividend.dart';
import '../../domain/entities/insider_trade.dart';

final corporateDatasourceProvider = Provider<CorporateApiDatasource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return CorporateApiDatasource(dio);
});

final dividendsProvider = FutureProvider<List<Dividend>>((ref) async {
  final ds = ref.watch(corporateDatasourceProvider);
  return ds.getDividends();
});

final dividendsBySymbolProvider = FutureProvider.family<List<Dividend>, String>(
  (ref, symbol) async {
    final ds = ref.watch(corporateDatasourceProvider);
    return ds.getDividendsBySymbol(symbol);
  },
);

final upcomingEventsProvider = FutureProvider<List<CorporateEvent>>((
  ref,
) async {
  final ds = ref.watch(corporateDatasourceProvider);
  return ds.getUpcomingEvents();
});

final insiderTradesProvider = FutureProvider<List<InsiderTrade>>((ref) async {
  final ds = ref.watch(corporateDatasourceProvider);
  return ds.getInsiderTrades();
});
