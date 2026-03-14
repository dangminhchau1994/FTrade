import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/corporate_mock_datasource.dart';
import '../../domain/entities/dividend.dart';
import '../../domain/entities/corporate_event.dart';
import '../../domain/entities/insider_trade.dart';

final corporateDatasourceProvider =
    Provider((ref) => CorporateMockDatasource());

final dividendsProvider = FutureProvider<List<Dividend>>((ref) async {
  final ds = ref.watch(corporateDatasourceProvider);
  return ds.getDividends();
});

final dividendsBySymbolProvider =
    FutureProvider.family<List<Dividend>, String>((ref, symbol) async {
  final ds = ref.watch(corporateDatasourceProvider);
  return ds.getDividendsBySymbol(symbol);
});

final upcomingEventsProvider =
    FutureProvider<List<CorporateEvent>>((ref) async {
  final ds = ref.watch(corporateDatasourceProvider);
  return ds.getUpcomingEvents();
});

final insiderTradesProvider =
    FutureProvider<List<InsiderTrade>>((ref) async {
  final ds = ref.watch(corporateDatasourceProvider);
  return ds.getInsiderTrades();
});
