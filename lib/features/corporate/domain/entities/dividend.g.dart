// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dividend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DividendImpl _$$DividendImplFromJson(Map<String, dynamic> json) =>
    _$DividendImpl(
      symbol: json['symbol'] as String,
      exDate: DateTime.parse(json['exDate'] as String),
      recordDate: DateTime.parse(json['recordDate'] as String),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      ratio: (json['ratio'] as num).toDouble(),
      cashAmount: (json['cashAmount'] as num).toDouble(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$DividendImplToJson(_$DividendImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'exDate': instance.exDate.toIso8601String(),
      'recordDate': instance.recordDate.toIso8601String(),
      'paymentDate': instance.paymentDate.toIso8601String(),
      'ratio': instance.ratio,
      'cashAmount': instance.cashAmount,
      'note': instance.note,
    };
