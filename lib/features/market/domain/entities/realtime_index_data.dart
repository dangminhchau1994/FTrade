/// Realtime data cho chỉ số thị trường (VNINDEX, HNXIndex, v.v.)
/// Nhận từ VNDIRECT WebSocket (wss://price-cmc-04.vndirect.com.vn)
class RealtimeIndexData {
  final String symbol;
  final double value;
  final double change;
  final double changePercent;
  final int? advances;
  final int? declines;
  final int? unchanged;
  final DateTime updatedAt;

  const RealtimeIndexData({
    required this.symbol,
    required this.value,
    required this.change,
    required this.changePercent,
    this.advances,
    this.declines,
    this.unchanged,
    required this.updatedAt,
  });
}
