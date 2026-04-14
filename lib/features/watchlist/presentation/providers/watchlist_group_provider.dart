import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../features/auth/data/repositories/user_repository.dart';
import '../../domain/entities/watchlist_group.dart';

const _boxName = 'watchlist_groups';

final watchlistGroupsProvider =
    StateNotifierProvider<WatchlistGroupsNotifier, List<WatchlistGroup>>(
  (_) => WatchlistGroupsNotifier(),
);

class WatchlistGroupsNotifier extends StateNotifier<List<WatchlistGroup>> {
  Box<String>? _box;
  final _repo = UserRepository();

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
    await _box?.put(group.id, jsonEncode(group.toJson()));
    state = [group, ...state.where((g) => g.id != group.id)];
    _syncFirestore();
  }

  Future<void> removeGroup(String id) async {
    await _box?.delete(id);
    state = state.where((g) => g.id != id).toList();
    _syncFirestore();
  }

  Future<void> addSymbolToGroup(String groupId, String symbol) async {
    final group = state.firstWhere((g) => g.id == groupId);
    if (group.symbols.contains(symbol)) return;
    final updated = group.copyWith(symbols: [...group.symbols, symbol]);
    await _box?.put(groupId, jsonEncode(updated.toJson()));
    state = state.map((g) => g.id == groupId ? updated : g).toList();
    _syncFirestore();
  }

  Future<void> removeSymbolFromGroup(String groupId, String symbol) async {
    final group = state.firstWhere((g) => g.id == groupId);
    final updated = group.copyWith(
        symbols: group.symbols.where((s) => s != symbol).toList());
    await _box?.put(groupId, jsonEncode(updated.toJson()));
    state = state.map((g) => g.id == groupId ? updated : g).toList();
    _syncFirestore();
  }

  bool hasGroupForBriefDate(String briefDate) =>
      state.any((g) => g.isAiGenerated && g.briefDate == briefDate);

  /// Push union of all group symbols to Firestore so backend can query.
  void _syncFirestore() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final symbols = state.expand((g) => g.symbols).toSet().toList();
    _repo.updateWatchlistSymbols(uid, symbols).catchError((_) {});
  }
}
