// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'industry_comparison.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndustryComparisonImpl _$$IndustryComparisonImplFromJson(
  Map<String, dynamic> json,
) => _$IndustryComparisonImpl(
  symbol: json['symbol'] as String,
  companyName: json['companyName'] as String,
  industry: json['industry'] as String,
  pe: (json['pe'] as num).toDouble(),
  pb: (json['pb'] as num).toDouble(),
  roe: (json['roe'] as num).toDouble(),
  roa: (json['roa'] as num).toDouble(),
  debtToEquity: (json['debtToEquity'] as num).toDouble(),
  marketCap: (json['marketCap'] as num).toDouble(),
  isTarget: json['isTarget'] as bool,
);

Map<String, dynamic> _$$IndustryComparisonImplToJson(
  _$IndustryComparisonImpl instance,
) => <String, dynamic>{
  'symbol': instance.symbol,
  'companyName': instance.companyName,
  'industry': instance.industry,
  'pe': instance.pe,
  'pb': instance.pb,
  'roe': instance.roe,
  'roa': instance.roa,
  'debtToEquity': instance.debtToEquity,
  'marketCap': instance.marketCap,
  'isTarget': instance.isTarget,
};
