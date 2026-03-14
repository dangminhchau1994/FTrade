import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/fundamental_mock_datasource.dart';
import '../../domain/entities/financial_statement.dart';
import '../../domain/entities/industry_comparison.dart';

final fundamentalDatasourceProvider =
    Provider((ref) => FundamentalMockDatasource());

final incomeStatementsProvider =
    FutureProvider.family<List<FinancialStatement>, String>((ref, symbol) async {
  final ds = ref.watch(fundamentalDatasourceProvider);
  return ds.getIncomeStatements(symbol);
});

final balanceSheetsProvider =
    FutureProvider.family<List<FinancialStatement>, String>((ref, symbol) async {
  final ds = ref.watch(fundamentalDatasourceProvider);
  return ds.getBalanceSheets(symbol);
});

final cashFlowsProvider =
    FutureProvider.family<List<FinancialStatement>, String>((ref, symbol) async {
  final ds = ref.watch(fundamentalDatasourceProvider);
  return ds.getCashFlows(symbol);
});

final industryComparisonProvider =
    FutureProvider.family<List<IndustryComparison>, String>((ref, symbol) async {
  final ds = ref.watch(fundamentalDatasourceProvider);
  return ds.getIndustryComparison(symbol);
});
