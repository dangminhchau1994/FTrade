// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fa_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PiotroskiScoreImpl _$$PiotroskiScoreImplFromJson(Map<String, dynamic> json) =>
    _$PiotroskiScoreImpl(
      totalScore: (json['totalScore'] as num).toInt(),
      positiveNetIncome: json['positiveNetIncome'] as bool,
      positiveROA: json['positiveROA'] as bool,
      positiveCFO: json['positiveCFO'] as bool,
      cfoGreaterThanNetIncome: json['cfoGreaterThanNetIncome'] as bool,
      lowerLeverage: json['lowerLeverage'] as bool,
      higherCurrentRatio: json['higherCurrentRatio'] as bool,
      noNewShares: json['noNewShares'] as bool,
      higherGrossMargin: json['higherGrossMargin'] as bool,
      higherAssetTurnover: json['higherAssetTurnover'] as bool,
    );

Map<String, dynamic> _$$PiotroskiScoreImplToJson(
  _$PiotroskiScoreImpl instance,
) => <String, dynamic>{
  'totalScore': instance.totalScore,
  'positiveNetIncome': instance.positiveNetIncome,
  'positiveROA': instance.positiveROA,
  'positiveCFO': instance.positiveCFO,
  'cfoGreaterThanNetIncome': instance.cfoGreaterThanNetIncome,
  'lowerLeverage': instance.lowerLeverage,
  'higherCurrentRatio': instance.higherCurrentRatio,
  'noNewShares': instance.noNewShares,
  'higherGrossMargin': instance.higherGrossMargin,
  'higherAssetTurnover': instance.higherAssetTurnover,
};

_$AltmanZScoreImpl _$$AltmanZScoreImplFromJson(Map<String, dynamic> json) =>
    _$AltmanZScoreImpl(
      zScore: (json['zScore'] as num).toDouble(),
      zone: json['zone'] as String,
      model: json['model'] as String,
      x1: (json['x1'] as num).toDouble(),
      x2: (json['x2'] as num).toDouble(),
      x3: (json['x3'] as num).toDouble(),
      x4: (json['x4'] as num).toDouble(),
      x5: (json['x5'] as num).toDouble(),
    );

Map<String, dynamic> _$$AltmanZScoreImplToJson(_$AltmanZScoreImpl instance) =>
    <String, dynamic>{
      'zScore': instance.zScore,
      'zone': instance.zone,
      'model': instance.model,
      'x1': instance.x1,
      'x2': instance.x2,
      'x3': instance.x3,
      'x4': instance.x4,
      'x5': instance.x5,
    };

_$DuPontAnalysisImpl _$$DuPontAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$DuPontAnalysisImpl(
      period: json['period'] as String,
      roe: (json['roe'] as num).toDouble(),
      netMargin: (json['netMargin'] as num).toDouble(),
      assetTurnover: (json['assetTurnover'] as num).toDouble(),
      equityMultiplier: (json['equityMultiplier'] as num).toDouble(),
    );

Map<String, dynamic> _$$DuPontAnalysisImplToJson(
  _$DuPontAnalysisImpl instance,
) => <String, dynamic>{
  'period': instance.period,
  'roe': instance.roe,
  'netMargin': instance.netMargin,
  'assetTurnover': instance.assetTurnover,
  'equityMultiplier': instance.equityMultiplier,
};

_$GrowthMetricsImpl _$$GrowthMetricsImplFromJson(Map<String, dynamic> json) =>
    _$GrowthMetricsImpl(
      period: json['period'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      netIncome: (json['netIncome'] as num).toDouble(),
      revenueGrowthQoQ: (json['revenueGrowthQoQ'] as num?)?.toDouble(),
      revenueGrowthYoY: (json['revenueGrowthYoY'] as num?)?.toDouble(),
      netIncomeGrowthQoQ: (json['netIncomeGrowthQoQ'] as num?)?.toDouble(),
      netIncomeGrowthYoY: (json['netIncomeGrowthYoY'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$GrowthMetricsImplToJson(_$GrowthMetricsImpl instance) =>
    <String, dynamic>{
      'period': instance.period,
      'revenue': instance.revenue,
      'netIncome': instance.netIncome,
      'revenueGrowthQoQ': instance.revenueGrowthQoQ,
      'revenueGrowthYoY': instance.revenueGrowthYoY,
      'netIncomeGrowthQoQ': instance.netIncomeGrowthQoQ,
      'netIncomeGrowthYoY': instance.netIncomeGrowthYoY,
    };

_$ValuationResultImpl _$$ValuationResultImplFromJson(
  Map<String, dynamic> json,
) => _$ValuationResultImpl(
  currentPrice: (json['currentPrice'] as num).toDouble(),
  grahamNumber: (json['grahamNumber'] as num?)?.toDouble(),
  grahamUpside: (json['grahamUpside'] as num?)?.toDouble(),
  pegRatio: (json['pegRatio'] as num?)?.toDouble(),
  earningsGrowthRate: (json['earningsGrowthRate'] as num?)?.toDouble(),
  dcfValue: (json['dcfValue'] as num?)?.toDouble(),
  dcfUpside: (json['dcfUpside'] as num?)?.toDouble(),
  evEbitda: (json['evEbitda'] as num?)?.toDouble(),
  ebitdaBillion: (json['ebitdaBillion'] as num?)?.toDouble(),
  enterpriseValueBillion: (json['enterpriseValueBillion'] as num?)?.toDouble(),
  fcfYield: (json['fcfYield'] as num?)?.toDouble(),
  freeCashFlowBillion: (json['freeCashFlowBillion'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$ValuationResultImplToJson(
  _$ValuationResultImpl instance,
) => <String, dynamic>{
  'currentPrice': instance.currentPrice,
  'grahamNumber': instance.grahamNumber,
  'grahamUpside': instance.grahamUpside,
  'pegRatio': instance.pegRatio,
  'earningsGrowthRate': instance.earningsGrowthRate,
  'dcfValue': instance.dcfValue,
  'dcfUpside': instance.dcfUpside,
  'evEbitda': instance.evEbitda,
  'ebitdaBillion': instance.ebitdaBillion,
  'enterpriseValueBillion': instance.enterpriseValueBillion,
  'fcfYield': instance.fcfYield,
  'freeCashFlowBillion': instance.freeCashFlowBillion,
};

_$RiskMetricsImpl _$$RiskMetricsImplFromJson(Map<String, dynamic> json) =>
    _$RiskMetricsImpl(
      volatility: (json['volatility'] as num).toDouble(),
      beta: (json['beta'] as num).toDouble(),
      maxDrawdown: (json['maxDrawdown'] as num).toDouble(),
      sharpeRatio: (json['sharpeRatio'] as num).toDouble(),
    );

Map<String, dynamic> _$$RiskMetricsImplToJson(_$RiskMetricsImpl instance) =>
    <String, dynamic>{
      'volatility': instance.volatility,
      'beta': instance.beta,
      'maxDrawdown': instance.maxDrawdown,
      'sharpeRatio': instance.sharpeRatio,
    };

_$FaAnalysisImpl _$$FaAnalysisImplFromJson(
  Map<String, dynamic> json,
) => _$FaAnalysisImpl(
  symbol: json['symbol'] as String,
  piotroski:
      json['piotroski'] == null
          ? null
          : PiotroskiScore.fromJson(json['piotroski'] as Map<String, dynamic>),
  altmanZOriginal:
      json['altmanZOriginal'] == null
          ? null
          : AltmanZScore.fromJson(
            json['altmanZOriginal'] as Map<String, dynamic>,
          ),
  altmanZEm:
      json['altmanZEm'] == null
          ? null
          : AltmanZScore.fromJson(json['altmanZEm'] as Map<String, dynamic>),
  dupont:
      (json['dupont'] as List<dynamic>?)
          ?.map((e) => DuPontAnalysis.fromJson(e as Map<String, dynamic>))
          .toList(),
  growth:
      (json['growth'] as List<dynamic>?)
          ?.map((e) => GrowthMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
  valuation:
      json['valuation'] == null
          ? null
          : ValuationResult.fromJson(json['valuation'] as Map<String, dynamic>),
  risk:
      json['risk'] == null
          ? null
          : RiskMetrics.fromJson(json['risk'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$FaAnalysisImplToJson(_$FaAnalysisImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'piotroski': instance.piotroski,
      'altmanZOriginal': instance.altmanZOriginal,
      'altmanZEm': instance.altmanZEm,
      'dupont': instance.dupont,
      'growth': instance.growth,
      'valuation': instance.valuation,
      'risk': instance.risk,
    };
