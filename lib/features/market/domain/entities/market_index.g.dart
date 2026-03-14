// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketIndexImpl _$$MarketIndexImplFromJson(Map<String, dynamic> json) =>
    _$MarketIndexImpl(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      totalVolume: (json['totalVolume'] as num).toInt(),
      advances: (json['advances'] as num).toInt(),
      declines: (json['declines'] as num).toInt(),
      unchanged: (json['unchanged'] as num).toInt(),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MarketIndexImplToJson(_$MarketIndexImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'change': instance.change,
      'changePercent': instance.changePercent,
      'totalVolume': instance.totalVolume,
      'advances': instance.advances,
      'declines': instance.declines,
      'unchanged': instance.unchanged,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
