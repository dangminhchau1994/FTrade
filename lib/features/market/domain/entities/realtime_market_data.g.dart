// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_market_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RealtimeMarketDataImpl _$$RealtimeMarketDataImplFromJson(
  Map<String, dynamic> json,
) => _$RealtimeMarketDataImpl(
  symbol: json['symbol'] as String,
  matchedPrice: (json['matchedPrice'] as num?)?.toDouble() ?? 0,
  matchedVolume: (json['matchedVolume'] as num?)?.toInt() ?? 0,
  change: (json['change'] as num?)?.toDouble() ?? 0,
  changePercent: (json['changePercent'] as num?)?.toDouble() ?? 0,
  totalVolume: (json['totalVolume'] as num?)?.toInt() ?? 0,
  totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0,
  open: (json['open'] as num?)?.toDouble() ?? 0,
  high: (json['high'] as num?)?.toDouble() ?? 0,
  low: (json['low'] as num?)?.toDouble() ?? 0,
  ceiling: (json['ceiling'] as num?)?.toDouble() ?? 0,
  floor: (json['floor'] as num?)?.toDouble() ?? 0,
  refPrice: (json['refPrice'] as num?)?.toDouble() ?? 0,
  bid1Price: (json['bid1Price'] as num?)?.toDouble() ?? 0,
  bid1Volume: (json['bid1Volume'] as num?)?.toInt() ?? 0,
  bid2Price: (json['bid2Price'] as num?)?.toDouble() ?? 0,
  bid2Volume: (json['bid2Volume'] as num?)?.toInt() ?? 0,
  bid3Price: (json['bid3Price'] as num?)?.toDouble() ?? 0,
  bid3Volume: (json['bid3Volume'] as num?)?.toInt() ?? 0,
  ask1Price: (json['ask1Price'] as num?)?.toDouble() ?? 0,
  ask1Volume: (json['ask1Volume'] as num?)?.toInt() ?? 0,
  ask2Price: (json['ask2Price'] as num?)?.toDouble() ?? 0,
  ask2Volume: (json['ask2Volume'] as num?)?.toInt() ?? 0,
  ask3Price: (json['ask3Price'] as num?)?.toDouble() ?? 0,
  ask3Volume: (json['ask3Volume'] as num?)?.toInt() ?? 0,
  foreignBuyVolume: (json['foreignBuyVolume'] as num?)?.toInt() ?? 0,
  foreignSellVolume: (json['foreignSellVolume'] as num?)?.toInt() ?? 0,
  session:
      $enumDecodeNullable(_$TradingSessionEnumMap, json['session']) ??
      TradingSession.unknown,
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$RealtimeMarketDataImplToJson(
  _$RealtimeMarketDataImpl instance,
) => <String, dynamic>{
  'symbol': instance.symbol,
  'matchedPrice': instance.matchedPrice,
  'matchedVolume': instance.matchedVolume,
  'change': instance.change,
  'changePercent': instance.changePercent,
  'totalVolume': instance.totalVolume,
  'totalValue': instance.totalValue,
  'open': instance.open,
  'high': instance.high,
  'low': instance.low,
  'ceiling': instance.ceiling,
  'floor': instance.floor,
  'refPrice': instance.refPrice,
  'bid1Price': instance.bid1Price,
  'bid1Volume': instance.bid1Volume,
  'bid2Price': instance.bid2Price,
  'bid2Volume': instance.bid2Volume,
  'bid3Price': instance.bid3Price,
  'bid3Volume': instance.bid3Volume,
  'ask1Price': instance.ask1Price,
  'ask1Volume': instance.ask1Volume,
  'ask2Price': instance.ask2Price,
  'ask2Volume': instance.ask2Volume,
  'ask3Price': instance.ask3Price,
  'ask3Volume': instance.ask3Volume,
  'foreignBuyVolume': instance.foreignBuyVolume,
  'foreignSellVolume': instance.foreignSellVolume,
  'session': _$TradingSessionEnumMap[instance.session]!,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$TradingSessionEnumMap = {
  TradingSession.preOpen: 'preOpen',
  TradingSession.ato: 'ato',
  TradingSession.continuous: 'continuous',
  TradingSession.atc: 'atc',
  TradingSession.putThrough: 'putThrough',
  TradingSession.closed: 'closed',
  TradingSession.unknown: 'unknown',
};
