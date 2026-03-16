/// Extension format giá cổ phiếu theo chuẩn TTCK Việt Nam
/// Giá lưu dạng VND (149800), hiển thị dạng nghìn đồng (149.80)
extension StockPriceFormat on double {
  /// Format giá VND → nghìn đồng: 149800 → "149.80", 10050 → "10.05"
  String toStockPrice() {
    final inThousand = this / 1000;
    final raw = inThousand.toStringAsFixed(3);
    // Trim trailing 0 ở vị trí thập phân thứ 3, giữ tối thiểu 2 decimals
    if (raw.endsWith('0')) {
      return inThousand.toStringAsFixed(2);
    }
    return raw;
  }

  /// Format thay đổi giá VND → nghìn đồng: 9800 → "9.80", -2300 → "-2.30"
  String toStockChange() {
    final inThousand = this / 1000;
    final raw = inThousand.abs().toStringAsFixed(3);
    final prefix = this > 0 ? '+' : this < 0 ? '-' : '';
    if (raw.endsWith('0')) {
      return '$prefix${inThousand.abs().toStringAsFixed(2)}';
    }
    return '$prefix$raw';
  }

  /// Format phần trăm: 7.0 → "7.00%", -1.5 → "-1.50%"
  String toStockPercent() {
    final prefix = this > 0 ? '+' : '';
    return '$prefix${toStringAsFixed(2)}%';
  }

  /// Format thay đổi kèm phần trăm: "9.80 / 7.00%"
  String toStockChangeWithPercent(double changePercent) {
    return '${toStockChange()} / ${changePercent.toStockPercent()}';
  }
}

extension StockVolumeFormat on int {
  /// Format khối lượng: 1480000 → "1.48M", 23500 → "23.5K"
  String toStockVolume() {
    if (this >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(2)}B';
    }
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(2)}M';
    }
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}
