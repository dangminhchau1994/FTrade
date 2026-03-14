// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insider_trade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InsiderTradeImpl _$$InsiderTradeImplFromJson(Map<String, dynamic> json) =>
    _$InsiderTradeImpl(
      symbol: json['symbol'] as String,
      traderName: json['traderName'] as String,
      position: json['position'] as String,
      tradeType: $enumDecode(_$TradeTypeEnumMap, json['tradeType']),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      tradeDate: DateTime.parse(json['tradeDate'] as String),
      reportDate: DateTime.parse(json['reportDate'] as String),
      isProprietary: json['isProprietary'] as bool,
    );

Map<String, dynamic> _$$InsiderTradeImplToJson(_$InsiderTradeImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'traderName': instance.traderName,
      'position': instance.position,
      'tradeType': _$TradeTypeEnumMap[instance.tradeType]!,
      'quantity': instance.quantity,
      'price': instance.price,
      'tradeDate': instance.tradeDate.toIso8601String(),
      'reportDate': instance.reportDate.toIso8601String(),
      'isProprietary': instance.isProprietary,
    };

const _$TradeTypeEnumMap = {TradeType.buy: 'buy', TradeType.sell: 'sell'};
