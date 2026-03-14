// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_flow_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketFlowSummaryImpl _$$MarketFlowSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$MarketFlowSummaryImpl(
  totalForeignBuy: (json['totalForeignBuy'] as num).toDouble(),
  totalForeignSell: (json['totalForeignSell'] as num).toDouble(),
  totalForeignNet: (json['totalForeignNet'] as num).toDouble(),
  topNetBuyers:
      (json['topNetBuyers'] as List<dynamic>)
          .map((e) => ForeignFlow.fromJson(e as Map<String, dynamic>))
          .toList(),
  topNetSellers:
      (json['topNetSellers'] as List<dynamic>)
          .map((e) => ForeignFlow.fromJson(e as Map<String, dynamic>))
          .toList(),
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$$MarketFlowSummaryImplToJson(
  _$MarketFlowSummaryImpl instance,
) => <String, dynamic>{
  'totalForeignBuy': instance.totalForeignBuy,
  'totalForeignSell': instance.totalForeignSell,
  'totalForeignNet': instance.totalForeignNet,
  'topNetBuyers': instance.topNetBuyers,
  'topNetSellers': instance.topNetSellers,
  'date': instance.date.toIso8601String(),
};
