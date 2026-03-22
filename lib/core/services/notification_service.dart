import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Wrapper cho flutter_local_notifications.
/// Gọi NotificationService.init() trong main() trước runApp.
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'price_alerts';
  static const _channelName = 'Cảnh báo giá';

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  static Future<void> showPriceAlert({
    required String symbol,
    required double targetPrice,
    required bool isAbove,
  }) async {
    final direction = isAbove ? 'vượt lên' : 'giảm xuống';
    final priceStr = _formatPrice(targetPrice);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Thông báo khi giá cổ phiếu đạt mục tiêu',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      symbol.hashCode ^ targetPrice.hashCode, // unique id per alert
      'Cảnh báo giá $symbol',
      '$symbol đã $direction $priceStr',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  static String _formatPrice(double price) {
    if (price >= 1000) return '${(price / 1000).toStringAsFixed(1)}k';
    return price.toStringAsFixed(0);
  }
}
