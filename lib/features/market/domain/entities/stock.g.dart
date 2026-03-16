// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockImpl _$$StockImplFromJson(Map<String, dynamic> json) => _$StockImpl(
  symbol: json['symbol'] as String,
  price: (json['price'] as num).toDouble(),
  change: (json['change'] as num).toDouble(),
  changePercent: (json['changePercent'] as num).toDouble(),
  high: (json['high'] as num).toDouble(),
  low: (json['low'] as num).toDouble(),
  open: (json['open'] as num).toDouble(),
  prevClose: (json['prevClose'] as num).toDouble(),
  volume: (json['volume'] as num).toInt(),
  ceiling: (json['ceiling'] as num?)?.toDouble() ?? 0,
  floor: (json['floor'] as num?)?.toDouble() ?? 0,
  refPrice: (json['refPrice'] as num?)?.toDouble() ?? 0,
  exchange: json['exchange'] as String?,
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$StockImplToJson(_$StockImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'price': instance.price,
      'change': instance.change,
      'changePercent': instance.changePercent,
      'high': instance.high,
      'low': instance.low,
      'open': instance.open,
      'prevClose': instance.prevClose,
      'volume': instance.volume,
      'ceiling': instance.ceiling,
      'floor': instance.floor,
      'refPrice': instance.refPrice,
      'exchange': instance.exchange,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
