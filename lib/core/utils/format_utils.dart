import 'package:intl/intl.dart';

import '../extensions/stock_format_extension.dart';

class FormatUtils {
  FormatUtils._();

  static final _timeFormat = DateFormat('HH:mm');
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _dateTimeFormat = DateFormat('dd/MM HH:mm');

  /// Giá cổ phiếu (VND → nghìn đồng): 149800 → "149.80"
  static String price(double value) => value.toStockPrice();

  /// Khối lượng: 1480000 → "1.48M"
  static String volume(int value) => value.toStockVolume();

  /// Phần trăm thay đổi: 7.0 → "+7.00%"
  static String percent(double value) => value.toStockPercent();

  /// Thay đổi giá (VND → nghìn đồng): 9800 → "+9.80"
  static String change(double value) => value.toStockChange();

  /// Thay đổi kèm %: "9.80 / 7.00%"
  static String changeWithPercent(double change, double percent) =>
      change.toStockChangeWithPercent(percent);

  static String time(DateTime dt) => _timeFormat.format(dt);
  static String date(DateTime dt) => _dateFormat.format(dt);
  static String dateTime(DateTime dt) => _dateTimeFormat.format(dt);

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return date(dt);
  }

  static String marketCap(double value) {
    if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(1)}T tỷ';
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)} tỷ';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(1)} triệu';
    return price(value);
  }
}
