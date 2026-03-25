import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/fa_analysis.dart';
import '../../domain/entities/financial_statement.dart';
import '../../domain/fa_calculator.dart';

// ── Isolate entry point (top-level required) ─────────────────────────────

FaAnalysis _computeFaAnalysis(_ComputeInput input) {
  final growthList = FaCalculator.growth(
    incomeStatements: input.incomeStatements,
  );

  return FaAnalysis(
    symbol: input.symbol,
    piotroski: FaCalculator.piotroski(
      incomeStatements: input.incomeStatements,
      balanceSheets: input.balanceSheets,
      cashFlows: input.cashFlows,
    ),
    altmanZOriginal: FaCalculator.altmanZOriginal(
      incomeStatements: input.incomeStatements,
      balanceSheets: input.balanceSheets,
      marketCapBillion: input.marketCapBillion,
    ),
    altmanZEm: FaCalculator.altmanZEm(
      incomeStatements: input.incomeStatements,
      balanceSheets: input.balanceSheets,
      marketCapBillion: input.marketCapBillion,
    ),
    dupont: FaCalculator.dupont(
      incomeStatements: input.incomeStatements,
      balanceSheets: input.balanceSheets,
    ),
    growth: growthList,
    valuation: FaCalculator.valuation(
      currentPrice: input.currentPrice,
      eps: input.eps,
      bookValuePerShare: input.bookValuePerShare,
      growth: growthList,
      incomeStatements: input.incomeStatements,
      cashFlows: input.cashFlows,
      balanceSheets: input.balanceSheets,
      marketCapBillion: input.marketCapBillion,
      outstandingSharesMillion: input.outstandingSharesMillion,
    ),
    risk: input.stockCloses.isNotEmpty && input.indexCloses.isNotEmpty
        ? FaCalculator.riskMetrics(
            stockCloses: input.stockCloses,
            indexCloses: input.indexCloses,
          )
        : null,
  );
}

class _ComputeInput {
  final String symbol;
  final List<FinancialStatement> incomeStatements;
  final List<FinancialStatement> balanceSheets;
  final List<FinancialStatement> cashFlows;
  final double currentPrice;
  final double eps;
  final double bookValuePerShare;
  final double marketCapBillion;
  final double outstandingSharesMillion;
  final List<double> stockCloses;
  final List<double> indexCloses;

  const _ComputeInput({
    required this.symbol,
    required this.incomeStatements,
    required this.balanceSheets,
    required this.cashFlows,
    required this.currentPrice,
    required this.eps,
    required this.bookValuePerShare,
    required this.marketCapBillion,
    required this.outstandingSharesMillion,
    required this.stockCloses,
    required this.indexCloses,
  });
}

// ── Datasource ────────────────────────────────────────────────────────────

class FaAnalysisDatasource {
  FaAnalysisDatasource(this._dio);

  final Dio _dio;

  // Cache: symbol → (fetchedAt, result)
  final _cache = <String, (DateTime, FaAnalysis)>{};
  static const _cacheTtl = Duration(hours: 6);

  Future<FaAnalysis> getFaAnalysis({
    required String symbol,
    required double currentPrice,
    required double eps,
    required double marketCapBillion,
    required double outstandingSharesMillion,
  }) async {
    final upper = symbol.toUpperCase();

    // Cache hit
    final cached = _cache[upper];
    if (cached != null &&
        DateTime.now().difference(cached.$1) < _cacheTtl) {
      return cached.$2;
    }

    // Parallel fetch: IS (8q) + BS (8q) + CF (8q) + price history + index history
    final futures = await Future.wait([
      _fetchStatements(upper, modelType: 2, lineItems: _incomeItems),
      _fetchStatements(upper, modelType: 1, lineItems: _balanceItems),
      _fetchStatements(upper, modelType: 3, lineItems: _cashFlowItems),
      _fetchPriceHistory(upper),
      _fetchPriceHistory('VNINDEX'),
    ]);

    final incomeStatements = futures[0] as List<FinancialStatement>;
    final balanceSheets = futures[1] as List<FinancialStatement>;
    final cashFlows = futures[2] as List<FinancialStatement>;
    final stockCloses = futures[3] as List<double>;
    final indexCloses = futures[4] as List<double>;

    // Book value per share = Equity / Shares
    final equity = balanceSheets.isNotEmpty
        ? (balanceSheets.first.items['Vốn chủ sở hữu'] ?? 0)
        : 0.0;
    final bvps = outstandingSharesMillion > 0
        ? equity / (outstandingSharesMillion * 1e6)
        : 0.0;

    final input = _ComputeInput(
      symbol: upper,
      incomeStatements: incomeStatements,
      balanceSheets: balanceSheets,
      cashFlows: cashFlows,
      currentPrice: currentPrice,
      eps: eps,
      bookValuePerShare: bvps,
      marketCapBillion: marketCapBillion,
      outstandingSharesMillion: outstandingSharesMillion,
      stockCloses: stockCloses,
      indexCloses: indexCloses,
    );

    // Heavy compute in isolate — keeps UI thread free
    final result = await compute(_computeFaAnalysis, input);

    _cache[upper] = (DateTime.now(), result);
    return result;
  }

  void clearCache([String? symbol]) {
    if (symbol != null) {
      _cache.remove(symbol.toUpperCase());
    } else {
      _cache.clear();
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<List<FinancialStatement>> _fetchStatements(
    String symbol, {
    required int modelType,
    required Map<String, int> lineItems,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.financialStatements,
        queryParameters: {
          'q': 'code:$symbol~reportType:QUARTER~modelType:$modelType',
          'filter': 'itemCode:${lineItems.values.join(",")}',
          'sort': 'fiscalDate:desc',
          'size': 500,
        },
      );

      final data = response.data['data'] as List? ?? [];
      if (data.isEmpty) return [];

      final periodMap = <String, Map<String, double>>{};
      for (final row in data) {
        final item = row as Map<String, dynamic>;
        final fiscalDate = item['fiscalDate'] as String? ?? '';
        final rawCode = item['itemCode'];
        final itemCode = rawCode is num
            ? rawCode.toInt()
            : int.tryParse('$rawCode') ?? 0;
        final value = _toDouble(item['numericValue']);
        final period = _formatPeriod(fiscalDate);
        periodMap.putIfAbsent(period, () => {});
        for (final entry in lineItems.entries) {
          if (entry.value == itemCode) {
            periodMap[period]![entry.key] = value;
            break;
          }
        }
      }

      final sorted = periodMap.keys.toList()..sort((a, b) => b.compareTo(a));
      return sorted.take(8).map((p) => FinancialStatement(
            symbol: symbol,
            period: p,
            type: _statementTypeFor(modelType),
            items: periodMap[p]!,
          )).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<double>> _fetchPriceHistory(String symbol) async {
    try {
      final from = DateTime.now().subtract(const Duration(days: 400));
      final response = await _dio.get(
        ApiConstants.stockPrices,
        queryParameters: {
          'q': 'code:$symbol~date:gte:${from.toIso8601String().substring(0, 10)}',
          'sort': 'date:asc',
          'size': 365,
        },
      );
      final data = response.data['data'] as List? ?? [];
      return data
          .map<double>((d) => (_toDouble(d['close'])) * 1000)
          .where((c) => c > 0)
          .toList();
    } catch (_) {
      return [];
    }
  }

  String _formatPeriod(String fiscalDate) {
    if (fiscalDate.length < 7) return fiscalDate;
    final year = fiscalDate.substring(0, 4);
    final month = int.tryParse(fiscalDate.substring(5, 7)) ?? 0;
    final q = month <= 3 ? 'Q1' : month <= 6 ? 'Q2' : month <= 9 ? 'Q3' : 'Q4';
    return '$q/$year';
  }

  StatementType _statementTypeFor(int modelType) => switch (modelType) {
        1 => StatementType.balanceSheet,
        3 => StatementType.cashFlow,
        _ => StatementType.incomeStatement,
      };

  double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString().replaceAll(',', '')) ?? 0;
  }

  // ── Item codes ────────────────────────────────────────────────────────────

  static const _incomeItems = {
    'Doanh thu thuần': 21001,
    'Lợi nhuận gộp': 23100,
    'Lợi nhuận từ HĐKD': 23110,
    'Lợi nhuận trước thuế': 23800,
    'Lợi nhuận sau thuế': 23003,
  };

  static const _balanceItems = {
    'Tổng tài sản': 12700,
    'Tài sản ngắn hạn': 11000,
    'Tiền và tương đương tiền': 11100,
    'Nợ phải trả': 13000,
    'Nợ ngắn hạn': 13100,
    'Vốn chủ sở hữu': 14000,
  };

  static const _cashFlowItems = {
    'Lưu chuyển tiền từ HĐKD': 32000,
    'Lưu chuyển tiền từ HĐĐT': 33000,
  };
}
