import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MarketBreadthBar extends StatelessWidget {
  final int advances;
  final int declines;
  final int unchanged;

  const MarketBreadthBar({
    super.key,
    required this.advances,
    required this.declines,
    required this.unchanged,
  });

  @override
  Widget build(BuildContext context) {
    final total = advances + declines + unchanged;
    if (total == 0) return const SizedBox.shrink();

    final advPct = advances / total;
    final unchPct = unchanged / total;
    final decPct = declines / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                Flexible(
                  flex: (advPct * 1000).toInt(),
                  child: Container(color: AppTheme.gainColor),
                ),
                Flexible(
                  flex: (unchPct * 1000).toInt(),
                  child: Container(color: Colors.amber),
                ),
                Flexible(
                  flex: (decPct * 1000).toInt(),
                  child: Container(color: AppTheme.lossColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Label(
              color: AppTheme.gainColor,
              text: 'Tăng: $advances',
            ),
            _Label(
              color: Colors.amber,
              text: 'Đứng: $unchanged',
            ),
            _Label(
              color: AppTheme.lossColor,
              text: 'Giảm: $declines',
            ),
          ],
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final Color color;
  final String text;

  const _Label({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: Colors.grey[400]),
        ),
      ],
    );
  }
}
