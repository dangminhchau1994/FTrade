import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock.freezed.dart';
part 'stock.g.dart';

@freezed
class Stock with _$Stock {
  const factory Stock({
    required String symbol,
    required double price,
    required double change,
    required double changePercent,
    required double high,
    required double low,
    required double open,
    required double prevClose,
    required int volume,
    @Default(0) double ceiling,
    @Default(0) double floor,
    @Default(0) double refPrice,
    String? exchange,
    DateTime? updatedAt,
  }) = _Stock;

  factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);
}
