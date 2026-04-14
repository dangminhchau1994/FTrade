import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../../corporate/data/datasources/corporate_api_datasource.dart';
import '../../../corporate/domain/entities/corporate_event.dart';
import '../../presentation/providers/watchlist_group_provider.dart';
import '../../presentation/providers/watchlist_providers.dart';

final contextualAlertMonitorProvider = Provider<ContextualAlertMonitor>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  final datasource = CorporateApiDatasource(dio);
  final monitor = ContextualAlertMonitor(ref: ref, datasource: datasource);
  monitor.check();
  return monitor;
});

class ContextualAlertMonitor {
  final Ref _ref;
  final CorporateApiDatasource _datasource;

  static const _boxName = 'contextual_alerts_shown';
  static const _alertDaysAhead = 3;

  ContextualAlertMonitor({
    required Ref ref,
    required CorporateApiDatasource datasource,
  })  : _ref = ref,
        _datasource = datasource;

  Future<void> check() async {
    try {
      final symbols = _collectSymbols();
      if (symbols.isEmpty) return;

      final box = await Hive.openBox<String>(_boxName);
      final now = DateTime.now();
      final cutoff = now.add(const Duration(days: _alertDaysAhead));

      // Process in batches of 5 to avoid hammering the API
      final list = symbols.toList();
      for (var i = 0; i < list.length; i += 5) {
        final chunk = list.sublist(i, (i + 5).clamp(0, list.length));
        await Future.wait(chunk.map((s) => _checkSymbol(s, now, cutoff, box)));
      }
    } catch (e) {
      debugPrint('[ContextualAlerts] check error: $e');
    }
  }

  Set<String> _collectSymbols() {
    final symbols = <String>{};
    for (final group in _ref.read(watchlistGroupsProvider)) {
      symbols.addAll(group.symbols);
    }
    symbols.addAll(_ref.read(watchlistSymbolsProvider));
    return symbols;
  }

  Future<void> _checkSymbol(
    String symbol,
    DateTime now,
    DateTime cutoff,
    Box<String> box,
  ) async {
    try {
      // Corporate events (AGM, rights issue, etc.)
      final events = await _datasource.getEventsBySymbol(symbol);
      for (final e in events) {
        if (e.eventDate.isAfter(now) && e.eventDate.isBefore(cutoff)) {
          await _maybeNotifyEvent(e, box);
        }
      }

      // Dividends — notify on ex-date approach
      final dividends = await _datasource.getDividendsBySymbol(symbol);
      for (final div in dividends) {
        if (div.exDate.isAfter(now) && div.exDate.isBefore(cutoff)) {
          final alertId = 'div_${symbol}_${_ymd(div.exDate)}';
          if (box.containsKey(alertId)) continue;

          final amountPart = div.cashAmount > 0
              ? ' ${_money(div.cashAmount)}/CP'
              : div.ratio > 0
                  ? ' ${div.ratio.toStringAsFixed(0)}%'
                  : '';
          await NotificationService.showContextualAlert(
            id: alertId,
            title: '💰 Cổ tức $symbol',
            body: '$symbol chốt quyền cổ tức$amountPart ngày ${_dd(div.exDate)}',
          );
          await box.put(alertId, now.toIso8601String());
        }
      }
    } catch (e) {
      debugPrint('[ContextualAlerts] $symbol: $e');
    }
  }

  Future<void> _maybeNotifyEvent(CorporateEvent event, Box<String> box) async {
    final alertId = 'evt_${event.id}';
    if (box.containsKey(alertId)) return;

    final dateStr = _dd(event.eventDate);
    final (emoji, label) = switch (event.type) {
      CorporateEventType.dividend    => ('📊', 'Chốt quyền'),
      CorporateEventType.rightsIssue => ('📋', 'Quyền mua thêm'),
      CorporateEventType.agm         => ('🏛️', 'ĐHCĐ'),
      CorporateEventType.earnings    => ('📈', 'Công bố KQKD'),
      CorporateEventType.other       => ('🔔', 'Sự kiện'),
    };

    await NotificationService.showContextualAlert(
      id: alertId,
      title: '$emoji $label ${event.symbol}',
      body: '${event.title} · Ngày $dateStr',
    );
    await box.put(alertId, DateTime.now().toIso8601String());
  }

  String _ymd(DateTime dt) => dt.toIso8601String().substring(0, 10);
  String _dd(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
  String _money(double v) => v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}k' : v.toStringAsFixed(0);
}
