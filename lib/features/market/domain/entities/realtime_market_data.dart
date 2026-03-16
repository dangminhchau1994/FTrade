import 'package:freezed_annotation/freezed_annotation.dart';

part 'realtime_market_data.freezed.dart';
part 'realtime_market_data.g.dart';

/// Trạng thái phiên giao dịch
enum TradingSession {
  preOpen, // Trước giờ mở cửa
  ato, // Phiên ATO (9:00 - 9:15)
  continuous, // Phiên liên tục (9:15 - 11:30, 13:00 - 14:30)
  atc, // Phiên ATC (14:30 - 14:45)
  putThrough, // Phiên thỏa thuận
  closed, // Đóng cửa
  unknown,
}

/// Dữ liệu thị trường realtime cho 1 mã cổ phiếu
@freezed
class RealtimeMarketData with _$RealtimeMarketData {
  const factory RealtimeMarketData({
    required String symbol,

    // Giá khớp & khối lượng
    @Default(0) double matchedPrice,
    @Default(0) int matchedVolume,
    @Default(0) double change,
    @Default(0) double changePercent,

    // Tổng KL & GT
    @Default(0) int totalVolume,
    @Default(0) double totalValue,

    // OHLC
    @Default(0) double open,
    @Default(0) double high,
    @Default(0) double low,

    // Giá tham chiếu
    @Default(0) double ceiling,
    @Default(0) double floor,
    @Default(0) double refPrice,

    // 3 bước giá mua (bid)
    @Default(0) double bid1Price,
    @Default(0) int bid1Volume,
    @Default(0) double bid2Price,
    @Default(0) int bid2Volume,
    @Default(0) double bid3Price,
    @Default(0) int bid3Volume,

    // 3 bước giá bán (ask/offer)
    @Default(0) double ask1Price,
    @Default(0) int ask1Volume,
    @Default(0) double ask2Price,
    @Default(0) int ask2Volume,
    @Default(0) double ask3Price,
    @Default(0) int ask3Volume,

    // Khối ngoại
    @Default(0) int foreignBuyVolume,
    @Default(0) int foreignSellVolume,

    // Phiên
    @Default(TradingSession.unknown) TradingSession session,

    DateTime? updatedAt,
  }) = _RealtimeMarketData;

  factory RealtimeMarketData.fromJson(Map<String, dynamic> json) =>
      _$RealtimeMarketDataFromJson(json);
}
