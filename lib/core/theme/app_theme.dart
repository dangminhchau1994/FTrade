import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primaryColor = Color(0xFF1B5E20);
  static const _gainColor = Color(0xFF4CAF50);
  static const _lossColor = Color(0xFFF44336);
  static const _ceilingColor = Color(0xFFCE2AFF); // Tím - giá trần
  static const _floorColor = Color(0xFF2196F3);   // Xanh dương - giá sàn
  static const _refColor = Color(0xFFFFEB3B);     // Vàng - tham chiếu

  static Color get gainColor => _gainColor;
  static Color get lossColor => _lossColor;
  static Color get ceilingColor => _ceilingColor;
  static Color get floorColor => _floorColor;
  static Color get refColor => _refColor;

  /// Trả về màu theo chuẩn TTCK VN dựa trên giá hiện tại so với trần/sàn/TC
  static Color stockColor({
    required double price,
    required double ceiling,
    required double floor,
    required double refPrice,
  }) {
    if (price <= 0) return Colors.grey;
    if (price >= ceiling && ceiling > 0) return _ceilingColor;
    if (price <= floor && floor > 0) return _floorColor;
    if (price > refPrice) return _gainColor;
    if (price < refPrice) return _lossColor;
    return _refColor;
  }

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: _primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: _primaryColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
