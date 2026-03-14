import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'price_alerts';

class PriceAlert {
  final String symbol;
  final double targetPrice;
  final bool isAbove; // true = alert when price goes above, false = below
  final bool enabled;

  PriceAlert({
    required this.symbol,
    required this.targetPrice,
    required this.isAbove,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'targetPrice': targetPrice,
        'isAbove': isAbove,
        'enabled': enabled,
      };

  factory PriceAlert.fromJson(Map<dynamic, dynamic> json) => PriceAlert(
        symbol: json['symbol'] as String,
        targetPrice: (json['targetPrice'] as num).toDouble(),
        isAbove: json['isAbove'] as bool,
        enabled: json['enabled'] as bool? ?? true,
      );
}

final priceAlertsProvider =
    StateNotifierProvider<PriceAlertNotifier, List<PriceAlert>>((ref) {
  return PriceAlertNotifier();
});

class PriceAlertNotifier extends StateNotifier<List<PriceAlert>> {
  Box? _box;

  PriceAlertNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_boxName);
    state = _box!.values
        .map((v) => PriceAlert.fromJson(v as Map<dynamic, dynamic>))
        .toList();
  }

  Future<void> add(PriceAlert alert) async {
    await _box?.add(alert.toJson());
    state = [...state, alert];
  }

  Future<void> remove(int index) async {
    if (index < 0 || index >= state.length) return;
    final keys = _box?.keys.toList();
    if (keys != null && index < keys.length) {
      await _box?.delete(keys[index]);
    }
    state = [...state]..removeAt(index);
  }

  Future<void> toggle(int index) async {
    if (index < 0 || index >= state.length) return;
    final alert = state[index];
    final updated = PriceAlert(
      symbol: alert.symbol,
      targetPrice: alert.targetPrice,
      isAbove: alert.isAbove,
      enabled: !alert.enabled,
    );
    final keys = _box?.keys.toList();
    if (keys != null && index < keys.length) {
      await _box?.put(keys[index], updated.toJson());
    }
    state = [
      ...state.sublist(0, index),
      updated,
      ...state.sublist(index + 1),
    ];
  }

  List<PriceAlert> alertsForSymbol(String symbol) {
    return state.where((a) => a.symbol == symbol).toList();
  }
}
