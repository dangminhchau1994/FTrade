import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class FlowSummaryCard extends StatelessWidget {
  final double totalBuy;
  final double totalSell;
  final double totalNet;

  const FlowSummaryCard({
    super.key,
    required this.totalBuy,
    required this.totalSell,
    required this.totalNet,
  });

  String _formatBillion(double value) {
    final abs = value.abs() / 1e9;
    final prefix = value >= 0 ? '+' : '-';
    return '$prefix${abs.toStringAsFixed(1)} tỷ';
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = totalNet >= 0;
    final netColor = isPositive ? AppTheme.gainColor : AppTheme.lossColor;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Dòng tiền nước ngoài',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatBillion(totalNet),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: netColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isPositive ? 'Mua ròng' : 'Bán ròng',
              style: TextStyle(
                fontSize: 13,
                color: netColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FlowItem(
                    label: 'Mua',
                    value: _formatBillion(totalBuy),
                    color: AppTheme.gainColor,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey[700]),
                Expanded(
                  child: _FlowItem(
                    label: 'Bán',
                    value: _formatBillion(-totalSell),
                    color: AppTheme.lossColor,
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

class _FlowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _FlowItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
