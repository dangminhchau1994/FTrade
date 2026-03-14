import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _themeKey = 'theme_mode';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  Box? _box;

  ThemeModeNotifier() : super(ThemeMode.dark) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox(_boxName);
    final saved = _box?.get(_themeKey, defaultValue: 'dark') as String;
    state = _fromString(saved);
  }

  Future<void> toggle() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _box?.put(_themeKey, state == ThemeMode.dark ? 'dark' : 'light');
  }

  ThemeMode _fromString(String value) {
    return value == 'light' ? ThemeMode.light : ThemeMode.dark;
  }
}
