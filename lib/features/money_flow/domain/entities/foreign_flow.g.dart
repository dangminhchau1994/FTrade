// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foreign_flow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForeignFlowImpl _$$ForeignFlowImplFromJson(Map<String, dynamic> json) =>
    _$ForeignFlowImpl(
      symbol: json['symbol'] as String,
      buyVolume: (json['buyVolume'] as num).toDouble(),
      sellVolume: (json['sellVolume'] as num).toDouble(),
      netVolume: (json['netVolume'] as num).toDouble(),
      buyValue: (json['buyValue'] as num).toDouble(),
      sellValue: (json['sellValue'] as num).toDouble(),
      netValue: (json['netValue'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$ForeignFlowImplToJson(_$ForeignFlowImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'buyVolume': instance.buyVolume,
      'sellVolume': instance.sellVolume,
      'netVolume': instance.netVolume,
      'buyValue': instance.buyValue,
      'sellValue': instance.sellValue,
      'netValue': instance.netValue,
      'date': instance.date.toIso8601String(),
    };
