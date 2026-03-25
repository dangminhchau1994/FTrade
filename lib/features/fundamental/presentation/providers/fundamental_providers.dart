import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../data/datasources/fa_analysis_datasource.dart';
import '../../data/datasources/fundamental_api_datasource.dart';
import '../../domain/entities/fa_analysis.dart';
import '../../domain/entities/financial_statement.dart';
import '../../domain/entities/industry_comparison.dart';

final fundamentalDatasourceProvider = Provider<FundamentalApiDatasource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return FundamentalApiDatasource(dio);
});

final faAnalysisDatasourceProvider = Provider<FaAnalysisDatasource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return FaAnalysisDatasource(dio);
});

final incomeStatementsProvider =
    FutureProvider.family<List<FinancialStatement>, String>((
      ref,
      symbol,
    ) async {
      final ds = ref.watch(fundamentalDatasourceProvider);
      return ds.getIncomeStatements(symbol);
    });

final balanceSheetsProvider =
    FutureProvider.family<List<FinancialStatement>, String>((
      ref,
      symbol,
    ) async {
      final ds = ref.watch(fundamentalDatasourceProvider);
      return ds.getBalanceSheets(symbol);
    });

final cashFlowsProvider =
    FutureProvider.family<List<FinancialStatement>, String>((
      ref,
      symbol,
    ) async {
      final ds = ref.watch(fundamentalDatasourceProvider);
      return ds.getCashFlows(symbol);
    });

final industryComparisonProvider =
    FutureProvider.family<List<IndustryComparison>, String>((
      ref,
      symbol,
    ) async {
      final ds = ref.watch(fundamentalDatasourceProvider);
      return ds.getIndustryComparison(symbol);
    });

/// Params for FA analysis provider
typedef FaAnalysisParams = ({
  String symbol,
  double currentPrice,
  double eps,
  double marketCapBillion,
  double outstandingSharesMillion,
});

final faAnalysisProvider =
    FutureProvider.family<FaAnalysis, FaAnalysisParams>((ref, params) async {
  final ds = ref.watch(faAnalysisDatasourceProvider);
  return ds.getFaAnalysis(
    symbol: params.symbol,
    currentPrice: params.currentPrice,
    eps: params.eps,
    marketCapBillion: params.marketCapBillion,
    outstandingSharesMillion: params.outstandingSharesMillion,
  );
});
