import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';

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
    final netColor = isPositive ? AppColors.gain : AppColors.loss;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Dòng tiền nước ngoài',
              style: AppTextStyle.b14R.copyWith(color: AppColors.base40),
            ),
            const SizedBox(height: 12),
            Text(
              _formatBillion(totalNet),
              style: AppTextStyle.h24B.copyWith(
                fontSize: 28,
                color: netColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isPositive ? 'Mua ròng' : 'Bán ròng',
              style: AppTextStyle.s12M.copyWith(color: netColor),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FlowItem(
                    label: 'Mua',
                    value: _formatBillion(totalBuy),
                    color: AppColors.gain,
                  ),
                ),
                Container(width: 1, height: 40, color: AppColors.base70),
                Expanded(
                  child: _FlowItem(
                    label: 'Bán',
                    value: _formatBillion(-totalSell),
                    color: AppColors.loss,
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
          style: AppTextStyle.s12R.copyWith(color: AppColors.base50),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyle.b14S.copyWith(color: color),
        ),
      ],
    );
  }
}
