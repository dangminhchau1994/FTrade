import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../core/services/notification_service.dart';
import '../../../market/data/datasources/market_realtime_datasource.dart';
import '../../../market/presentation/providers/market_data_controller.dart';
import '../../presentation/providers/price_alert_providers.dart';

final _logger = Logger();

/// Monitor giá realtime và fire notification khi alert triggered.
/// Tự động start khi được watch, dispose khi ref bị dispose.
final priceAlertMonitorProvider = Provider<PriceAlertMonitor>((ref) {
  final datasource = ref.watch(marketRealtimeDatasourceProvider);
  final alertNotifier = ref.read(priceAlertsProvider.notifier);

  final monitor = PriceAlertMonitor(
    datasource: datasource,
    alertNotifier: alertNotifier,
  );
  monitor.start();
  ref.onDispose(monitor.dispose);
  return monitor;
});

class PriceAlertMonitor {
  final MarketRealtimeDatasource _datasource;
  final PriceAlertNotifier _alertNotifier;

  StreamSubscription? _sub;

  // Track alerts đã triggered để không spam notification
  final _triggered = <String>{};

  PriceAlertMonitor({
    required MarketRealtimeDatasource datasource,
    required PriceAlertNotifier alertNotifier,
  })  : _datasource = datasource,
        _alertNotifier = alertNotifier;

  void start() {
    _sub = _datasource.dataStream.listen(_onPrice);
    _logger.i('PriceAlertMonitor started');
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  void _onPrice(dynamic data) {
    // data là RealtimeMarketData
    final symbol = (data.symbol as String).toUpperCase();
    final price = data.matchedPrice as double;
    if (price <= 0) return;

    final alerts = _alertNotifier.alerts
        .where((a) => a.symbol == symbol && a.enabled)
        .toList();

    for (final alert in alerts) {
      final key = '${alert.symbol}_${alert.targetPrice}_${alert.isAbove}';
      if (_triggered.contains(key)) continue;

      final triggered = alert.isAbove
          ? price >= alert.targetPrice
          : price <= alert.targetPrice;

      if (triggered) {
        _triggered.add(key);
        _logger.i('Alert triggered: $symbol ${alert.isAbove ? ">=" : "<="} ${alert.targetPrice}');

        NotificationService.showPriceAlert(
          symbol: symbol,
          targetPrice: alert.targetPrice,
          isAbove: alert.isAbove,
        );

        // Disable alert sau khi triggered
        final index = _alertNotifier.alerts.indexOf(alert);
        if (index >= 0) _alertNotifier.toggle(index);
      }
    }
  }
}
