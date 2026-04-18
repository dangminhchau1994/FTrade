import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_text_style.dart';
import '../utils/format_utils.dart';

class StockChangeText extends StatelessWidget {
  final double change;
  final double changePercent;
  final double fontSize;
  final Color? color;

  const StockChangeText({
    super.key,
    required this.change,
    required this.changePercent,
    this.fontSize = 13,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ??
        (change > 0
            ? AppColors.gain
            : change < 0
                ? AppColors.loss
                : AppColors.base40);

    return Text(
      FormatUtils.changeWithPercent(change, changePercent),
      style: AppTextStyle.s12S.copyWith(
        color: displayColor,
        fontSize: fontSize,
      ),
    );
  }
}
