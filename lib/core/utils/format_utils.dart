import 'package:intl/intl.dart';

class FormatUtils {
  FormatUtils._();

  static final _priceFormat = NumberFormat('#,##0', 'vi_VN');
  static final _volumeFormat = NumberFormat.compact(locale: 'en');
  static final _percentFormat = NumberFormat('+0.00;-0.00');
  static final _changeFormat = NumberFormat('+#,##0;-#,##0', 'vi_VN');
  static final _timeFormat = DateFormat('HH:mm');
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _dateTimeFormat = DateFormat('dd/MM HH:mm');

  static String price(double value) => _priceFormat.format(value);
  static String volume(int value) => _volumeFormat.format(value);
  static String percent(double value) => '${_percentFormat.format(value)}%';
  static String change(double value) => _changeFormat.format(value);
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
    return _priceFormat.format(value);
  }
}
