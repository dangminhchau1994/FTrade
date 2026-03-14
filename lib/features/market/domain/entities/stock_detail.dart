import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_detail.freezed.dart';
part 'stock_detail.g.dart';

@freezed
class StockDetail with _$StockDetail {
  const factory StockDetail({
    required String symbol,
    required String companyName,
    required String exchange,
    required double price,
    required double change,
    required double changePercent,
    required double high,
    required double low,
    required double open,
    required double prevClose,
    required int volume,
    required double ceiling,
    required double floor,
    required double refPrice,
    double? pe,
    double? pb,
    double? eps,
    double? marketCap,
    double? foreignBuy,
    double? foreignSell,
    DateTime? updatedAt,
  }) = _StockDetail;

  factory StockDetail.fromJson(Map<String, dynamic> json) =>
      _$StockDetailFromJson(json);
}
