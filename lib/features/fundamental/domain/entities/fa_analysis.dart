import 'package:freezed_annotation/freezed_annotation.dart';

part 'fa_analysis.freezed.dart';
part 'fa_analysis.g.dart';

/// Piotroski F-Score (0-9): higher = stronger fundamentals
@freezed
class PiotroskiScore with _$PiotroskiScore {
  const factory PiotroskiScore({
    required int totalScore,
    // Profitability (4 points)
    required bool positiveNetIncome,
    required bool positiveROA,
    required bool positiveCFO,
    required bool cfoGreaterThanNetIncome,
    // Leverage & Liquidity (3 points)
    required bool lowerLeverage,
    required bool higherCurrentRatio,
    required bool noNewShares,
    // Efficiency (2 points)
    required bool higherGrossMargin,
    required bool higherAssetTurnover,
  }) = _PiotroskiScore;

  factory PiotroskiScore.fromJson(Map<String, dynamic> json) =>
      _$PiotroskiScoreFromJson(json);
}

/// Altman Z-Score.
/// Original (manufacturing): Safe > 2.99, Grey 1.81-2.99, Distress < 1.81
/// EM (Z'' model):            Safe > 2.60, Grey 1.10-2.60, Distress < 1.10
@freezed
class AltmanZScore with _$AltmanZScore {
  const factory AltmanZScore({
    required double zScore,
    required String zone, // 'safe', 'grey', 'distress'
    required String model, // 'original' | 'em'
    required double x1, // Working Capital / Total Assets
    required double x2, // Retained Earnings / Total Assets
    required double x3, // EBIT / Total Assets
    required double x4, // Market Cap / Total Liabilities
    required double x5, // Revenue / Total Assets (0 for EM model)
  }) = _AltmanZScore;

  factory AltmanZScore.fromJson(Map<String, dynamic> json) =>
      _$AltmanZScoreFromJson(json);
}

/// DuPont decomposition of ROE per quarter
@freezed
class DuPontAnalysis with _$DuPontAnalysis {
  const factory DuPontAnalysis({
    required String period,
    required double roe,
    required double netMargin,
    required double assetTurnover,
    required double equityMultiplier,
  }) = _DuPontAnalysis;

  factory DuPontAnalysis.fromJson(Map<String, dynamic> json) =>
      _$DuPontAnalysisFromJson(json);
}

/// Revenue & profit growth per quarter
@freezed
class GrowthMetrics with _$GrowthMetrics {
  const factory GrowthMetrics({
    required String period,
    required double revenue,
    required double netIncome,
    double? revenueGrowthQoQ,
    double? revenueGrowthYoY,
    double? netIncomeGrowthQoQ,
    double? netIncomeGrowthYoY,
  }) = _GrowthMetrics;

  factory GrowthMetrics.fromJson(Map<String, dynamic> json) =>
      _$GrowthMetricsFromJson(json);
}

/// Valuation: Graham Number, PEG, DCF, EV/EBITDA, FCF Yield
@freezed
class ValuationResult with _$ValuationResult {
  const factory ValuationResult({
    required double currentPrice,
    // Graham Number
    double? grahamNumber,
    double? grahamUpside, // %
    // PEG
    double? pegRatio,
    double? earningsGrowthRate, // avg YoY %
    // DCF (2-stage FCFF)
    double? dcfValue, // per share, đồng
    double? dcfUpside, // %
    // EV/EBITDA
    double? evEbitda,
    double? ebitdaBillion, // tỷ đồng
    double? enterpriseValueBillion, // tỷ đồng
    // FCF Yield
    double? fcfYield, // %
    double? freeCashFlowBillion, // tỷ đồng
  }) = _ValuationResult;

  factory ValuationResult.fromJson(Map<String, dynamic> json) =>
      _$ValuationResultFromJson(json);
}

/// Risk metrics calculated from historical price series
@freezed
class RiskMetrics with _$RiskMetrics {
  const factory RiskMetrics({
    required double volatility, // annualized %, std dev of daily returns
    required double beta, // vs VN-Index
    required double maxDrawdown, // worst peak-to-trough %
    required double sharpeRatio, // (annualReturn - rf) / annualVol
  }) = _RiskMetrics;

  factory RiskMetrics.fromJson(Map<String, dynamic> json) =>
      _$RiskMetricsFromJson(json);
}

/// Combined FA analysis result for a stock
@freezed
class FaAnalysis with _$FaAnalysis {
  const factory FaAnalysis({
    required String symbol,
    PiotroskiScore? piotroski,
    AltmanZScore? altmanZOriginal,
    AltmanZScore? altmanZEm,
    List<DuPontAnalysis>? dupont,
    List<GrowthMetrics>? growth,
    ValuationResult? valuation,
    RiskMetrics? risk,
  }) = _FaAnalysis;

  factory FaAnalysis.fromJson(Map<String, dynamic> json) =>
      _$FaAnalysisFromJson(json);
}
