import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
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
            ? AppTheme.gainColor
            : change < 0
                ? AppTheme.lossColor
                : Colors.grey);

    return Text(
      FormatUtils.changeWithPercent(change, changePercent),
      style: TextStyle(
        color: displayColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
