import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format_utils.dart';

class StockListTile extends StatelessWidget {
  final String symbol;
  final double price;
  final double change;
  final double changePercent;
  final int volume;
  final VoidCallback? onTap;

  const StockListTile({
    super.key,
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.volume,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = change > 0
        ? AppTheme.gainColor
        : change < 0
            ? AppTheme.lossColor
            : Colors.grey;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                symbol,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'KL: ${FormatUtils.volume(volume)}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  FormatUtils.price(price),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${FormatUtils.change(change)} (${FormatUtils.percent(changePercent)})',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
