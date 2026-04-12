import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/watchlist_group.dart';

const _boxName = 'watchlist_groups';

final watchlistGroupsProvider =
    StateNotifierProvider<WatchlistGroupsNotifier, List<WatchlistGroup>>(
  (_) => WatchlistGroupsNotifier(),
);

class WatchlistGroupsNotifier extends StateNotifier<List<WatchlistGroup>> {
  Box<String>? _box;

  WatchlistGroupsNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<String>(_boxName);
    state = _box!.values
        .map((v) => WatchlistGroup.fromJson(jsonDecode(v) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addGroup(WatchlistGroup group) async {
    // Replace if same id exists
    await _box?.put(group.id, jsonEncode(group.toJson()));
    state = [group, ...state.where((g) => g.id != group.id)];
  }

  Future<void> removeGroup(String id) async {
    await _box?.delete(id);
    state = state.where((g) => g.id != id).toList();
  }

  Future<void> addSymbolToGroup(String groupId, String symbol) async {
    final group = state.firstWhere((g) => g.id == groupId);
    if (group.symbols.contains(symbol)) return;
    final updated = group.copyWith(symbols: [...group.symbols, symbol]);
    await _box?.put(groupId, jsonEncode(updated.toJson()));
    state = state.map((g) => g.id == groupId ? updated : g).toList();
  }

  Future<void> removeSymbolFromGroup(String groupId, String symbol) async {
    final group = state.firstWhere((g) => g.id == groupId);
    final updated = group.copyWith(symbols: group.symbols.where((s) => s != symbol).toList());
    await _box?.put(groupId, jsonEncode(updated.toJson()));
    state = state.map((g) => g.id == groupId ? updated : g).toList();
  }

  bool hasGroupForBriefDate(String briefDate) =>
      state.any((g) => g.isAiGenerated && g.briefDate == briefDate);
}
