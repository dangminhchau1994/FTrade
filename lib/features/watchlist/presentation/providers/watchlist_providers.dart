import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../market/domain/entities/stock.dart';
import '../../../market/presentation/providers/market_providers.dart';
import 'watchlist_group_provider.dart';

const _boxName = 'watchlist';

final watchlistBoxProvider = FutureProvider<Box<String>>((ref) async {
  return Hive.openBox<String>(_boxName);
});

final watchlistSymbolsProvider = StateNotifierProvider<WatchlistNotifier, List<String>>((ref) {
  return WatchlistNotifier();
});

class WatchlistNotifier extends StateNotifier<List<String>> {
  Box<String>? _box;

  WatchlistNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<String>(_boxName);
    state = _box!.values.toList();
  }

  Future<void> add(String symbol) async {
    if (!state.contains(symbol)) {
      await _box?.add(symbol);
      state = [...state, symbol];
    }
  }

  Future<void> remove(String symbol) async {
    final index = state.indexOf(symbol);
    if (index >= 0) {
      // Find the key for this symbol
      final key = _box?.keys.firstWhere(
        (k) => _box?.get(k) == symbol,
        orElse: () => null,
      );
      if (key != null) await _box?.delete(key);
      state = state.where((s) => s != symbol).toList();
    }
  }

  bool contains(String symbol) => state.contains(symbol);
}

final watchlistStocksProvider = FutureProvider<List<Stock>>((ref) async {
  final symbols = ref.watch(watchlistSymbolsProvider);
  if (symbols.isEmpty) return [];

  return ref.watch(marketApiDatasourceProvider).getStocksBySymbols(symbols);
});

/// Fetch live prices for all symbols in an AI watchlist group.
/// Keyed by group id so Riverpod caches per group.
final groupStocksProvider = FutureProvider.family<List<Stock>, String>((ref, groupId) async {
  final groups = ref.watch(watchlistGroupsProvider);
  final group = groups.where((g) => g.id == groupId).firstOrNull;
  if (group == null || group.symbols.isEmpty) return [];
  return ref.watch(marketApiDatasourceProvider).getStocksBySymbols(group.symbols);
});
