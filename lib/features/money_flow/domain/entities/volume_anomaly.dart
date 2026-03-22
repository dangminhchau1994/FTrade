/// Cổ phiếu có KL giao dịch bất thường so với trung bình 20 phiên
class VolumeAnomaly {
  final String symbol;
  final double todayVolume;
  final double avgVolume20d;
  final double ratio; // todayVolume / avgVolume20d
  final double price;
  final double changePercent;

  const VolumeAnomaly({
    required this.symbol,
    required this.todayVolume,
    required this.avgVolume20d,
    required this.ratio,
    required this.price,
    required this.changePercent,
  });
}
