import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format_utils.dart';

class StockChangeText extends StatelessWidget {
  final double change;
  final double changePercent;
  final double fontSize;

  const StockChangeText({
    super.key,
    required this.change,
    required this.changePercent,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    final color = change > 0
        ? AppTheme.gainColor
        : change < 0
            ? AppTheme.lossColor
            : Colors.grey;

    return Text(
      '${FormatUtils.change(change)} (${FormatUtils.percent(changePercent)})',
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
