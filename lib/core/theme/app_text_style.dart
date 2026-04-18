import 'package:flutter/material.dart';

import 'app_theme.dart';

/// FTrade typography system — Manrope font, matching MASVN MTS scale.
///
/// Naming: [size][weight][lineHeight]
/// Weights: R=400, M=500, S=600, B=700
class AppTextStyle {
  AppTextStyle._();

  static const _font = 'Manrope';
  static const _spacing = 0.01;

  // ─── Display ──────────────────────────────────────────────────────────────
  static const display = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: _spacing,
  );

  // ─── Headline ─────────────────────────────────────────────────────────────
  static const h24B = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: _spacing,
  );
  static const h24S = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: _spacing,
  );
  static const h20B = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const h20S = TextStyle(
    fontFamily: _font,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const h18B = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const h18M = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: _spacing,
  );

  // ─── Body (16) ────────────────────────────────────────────────────────────
  static const b16B = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const b16S = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const b16M = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const b16R = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: _spacing,
  );

  // ─── Body Small (14) ──────────────────────────────────────────────────────
  static const b14B = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const b14S = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const b14M = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const b14R = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: _spacing,
  );

  // ─── Caption (12) ─────────────────────────────────────────────────────────
  static const s12B = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const s12S = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const s12M = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const s12R = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: _spacing,
  );

  // ─── Extra Small (10) ─────────────────────────────────────────────────────
  static const c10B = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const c10M = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: _spacing,
  );
  static const c10R = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: _spacing,
  );

  // ─── Semantic shortcuts ───────────────────────────────────────────────────

  /// Stock symbol label (e.g. "VNM", "HPG")
  static const stockSymbol = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: _spacing,
  );

  /// Stock price display
  static const stockPrice = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: _spacing,
  );

  /// Index value large (e.g. "1,285.32")
  static const indexValue = TextStyle(
    fontFamily: _font,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// Section header inside screens
  static const sectionHeader = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: _spacing,
  );

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Apply a color to any style
  static TextStyle colored(TextStyle base, Color color) =>
      base.copyWith(color: color);

  /// Gain-colored
  static TextStyle gain(TextStyle base) =>
      base.copyWith(color: AppColors.gain);

  /// Loss-colored
  static TextStyle loss(TextStyle base) =>
      base.copyWith(color: AppColors.loss);
}
