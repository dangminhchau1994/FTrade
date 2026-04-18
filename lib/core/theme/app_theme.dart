import 'package:flutter/material.dart';

/// FTrade Design System — based on MASVN MTS color palette
class AppColors {
  AppColors._();

  // --- Primary (Orange) ---
  static const primary10 = Color(0xFFFFE5D0);
  static const primary20 = Color(0xFFFECBA1);
  static const primary30 = Color(0xFFFEB272);
  static const primary40 = Color(0xFFFD9843);
  static const primary50 = Color(0xFFFD7E14); // main brand
  static const primary60 = Color(0xFFCA6510);
  static const primary70 = Color(0xFF984C0C);
  static const primary80 = Color(0xFF653208);

  // --- Semantic: stock market ---
  static const gain = Color(0xFF18A13E);        // tăng
  static const gainLight = Color(0xFF64D583);
  static const gainBg = Color(0xFFCCEED5);
  static const loss = Color(0xFFDC3545);        // giảm
  static const lossLight = Color(0xFFEA868F);
  static const lossBg = Color(0xFFF8D7DA);
  static const ceiling = Color(0xFFA84DF0);     // trần — tím
  static const floor = Color(0xFF2CB8D4);       // sàn — xanh dương
  static const ref = Color(0xFFFFC107);         // tham chiếu — vàng

  // --- Status ---
  static const warning = Color(0xFFFFC107);
  static const warningBg = Color(0xFFFFF3CD);
  static const info = Color(0xFF2CB8D4);

  // --- Neutral (light → dark) ---
  static const base07 = Color(0xFFF7F2EF);
  static const base08 = Color(0xFFFFFDFB);
  static const base09 = Color(0xFFF4F4F4);
  static const base10 = Color(0xFFE5E5E5);
  static const base20 = Color(0xFFCDC9C5);
  static const base30 = Color(0xFFB1ACA9);
  static const base40 = Color(0xFF96928F);
  static const base50 = Color(0xFF7D7976);
  static const base51 = Color(0xFF6F767E);
  static const base60 = Color(0xFF64605D);
  static const base70 = Color(0xFF595552);
  static const base80 = Color(0xFF4C4846);
  static const base90 = Color(0xFF303030);
  static const base91 = Color(0xFF2B2928);
  static const base92 = Color(0xFF272727);
  static const base97 = Color(0xFF201D1B);
  static const base98 = Color(0xFF171615);
  static const base99 = Color(0xFF070506);

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

class AppTheme {
  AppTheme._();

  // Public getters used across the app
  static Color get gainColor => AppColors.gain;
  static Color get lossColor => AppColors.loss;
  static Color get ceilingColor => AppColors.ceiling;
  static Color get floorColor => AppColors.floor;
  static Color get refColor => AppColors.ref;
  static Color get primaryColor => AppColors.primary50;

  /// Trả về màu theo chuẩn TTCK VN
  static Color stockColor({
    required double price,
    required double ceiling,
    required double floor,
    required double refPrice,
  }) {
    if (price <= 0) return AppColors.base40;
    if (price >= ceiling && ceiling > 0) return AppColors.ceiling;
    if (price <= floor && floor > 0) return AppColors.floor;
    if (price > refPrice) return AppColors.gain;
    if (price < refPrice) return AppColors.loss;
    return AppColors.ref;
  }

  // ─── Dark Theme ───────────────────────────────────────────────────────────

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: AppColors.base99,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary50,
          onPrimary: AppColors.white,
          secondary: AppColors.primary40,
          onSecondary: AppColors.white,
          surface: AppColors.base92,
          onSurface: AppColors.base10,
          surfaceContainerHighest: AppColors.base91,
          onSurfaceVariant: AppColors.base40,
          outline: AppColors.base80,
          outlineVariant: AppColors.base70,
          error: AppColors.loss,
          onError: AppColors.white,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.base99,
          foregroundColor: AppColors.base10,
          titleTextStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.base10,
            letterSpacing: 0.01,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.base92,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.base80,
          thickness: 0.5,
          space: 0,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          dense: true,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.base91,
          selectedColor: AppColors.primary50,
          labelStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.base92,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary50,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primary50,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.primary50,
          unselectedLabelColor: AppColors.base51,
          indicatorColor: AppColors.primary50,
          dividerColor: AppColors.base80,
          labelStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.base98,
          selectedItemColor: AppColors.primary50,
          unselectedItemColor: AppColors.base51,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.base98,
          indicatorColor: AppColors.primary50.withValues(alpha: 0.15),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary50);
            }
            return const IconThemeData(color: AppColors.base51);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary50,
              );
            }
            return const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.base51,
            );
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary50,
            foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary50,
            textStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary50,
            side: const BorderSide(color: AppColors.primary50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.base91,
          contentTextStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: AppColors.base10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.base91,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titleTextStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.base10,
          ),
          contentTextStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: AppColors.base30,
          ),
        ),
      );

  // ─── Light Theme ──────────────────────────────────────────────────────────

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Manrope',
        scaffoldBackgroundColor: AppColors.base09,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary50,
          onPrimary: AppColors.white,
          secondary: AppColors.primary40,
          onSecondary: AppColors.white,
          surface: AppColors.white,
          onSurface: AppColors.base90,
          surfaceContainerHighest: AppColors.base07,
          onSurfaceVariant: AppColors.base50,
          outline: AppColors.base20,
          outlineVariant: AppColors.base10,
          error: AppColors.loss,
          onError: AppColors.white,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.base09,
          foregroundColor: AppColors.base90,
          titleTextStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.base90,
            letterSpacing: 0.01,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.base10,
          thickness: 0.5,
          space: 0,
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          dense: true,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.base09,
          selectedColor: AppColors.primary50,
          labelStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.base10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary50,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primary50,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.primary50,
          unselectedLabelColor: AppColors.base51,
          indicatorColor: AppColors.primary50,
          dividerColor: AppColors.base10,
          labelStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.base08,
          selectedItemColor: AppColors.primary50,
          unselectedItemColor: AppColors.base51,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.base08,
          indicatorColor: AppColors.primary50.withValues(alpha: 0.12),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary50);
            }
            return const IconThemeData(color: AppColors.base51);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary50,
              );
            }
            return const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.base51,
            );
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary50,
            foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary50,
            textStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary50,
            side: const BorderSide(color: AppColors.primary50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.base90,
          contentTextStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: AppColors.base08,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.base08,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titleTextStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.base90,
          ),
          contentTextStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: AppColors.base60,
          ),
        ),
      );
}
