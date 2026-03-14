// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockDetailImpl _$$StockDetailImplFromJson(Map<String, dynamic> json) =>
    _$StockDetailImpl(
      symbol: json['symbol'] as String,
      companyName: json['companyName'] as String,
      exchange: json['exchange'] as String,
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      open: (json['open'] as num).toDouble(),
      prevClose: (json['prevClose'] as num).toDouble(),
      volume: (json['volume'] as num).toInt(),
      ceiling: (json['ceiling'] as num).toDouble(),
      floor: (json['floor'] as num).toDouble(),
      refPrice: (json['refPrice'] as num).toDouble(),
      pe: (json['pe'] as num?)?.toDouble(),
      pb: (json['pb'] as num?)?.toDouble(),
      eps: (json['eps'] as num?)?.toDouble(),
      marketCap: (json['marketCap'] as num?)?.toDouble(),
      foreignBuy: (json['foreignBuy'] as num?)?.toDouble(),
      foreignSell: (json['foreignSell'] as num?)?.toDouble(),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StockDetailImplToJson(_$StockDetailImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'companyName': instance.companyName,
      'exchange': instance.exchange,
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
      'pe': instance.pe,
      'pb': instance.pb,
      'eps': instance.eps,
      'marketCap': instance.marketCap,
      'foreignBuy': instance.foreignBuy,
      'foreignSell': instance.foreignSell,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
