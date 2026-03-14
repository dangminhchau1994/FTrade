import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/foreign_flow.dart';

class FlowRankingList extends StatelessWidget {
  final List<ForeignFlow> flows;
  final bool isBuyers;

  const FlowRankingList({
    super.key,
    required this.flows,
    required this.isBuyers,
  });

  String _formatBillion(double value) {
    final abs = value.abs() / 1e9;
    final prefix = value >= 0 ? '+' : '-';
    return '$prefix${abs.toStringAsFixed(1)} tỷ';
  }

  String _formatVolume(double value) {
    final abs = value.abs();
    if (abs >= 1e6) return '${(abs / 1e6).toStringAsFixed(1)}M';
    if (abs >= 1e3) return '${(abs / 1e3).toStringAsFixed(0)}K';
    return abs.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: flows.length,
      itemBuilder: (context, index) {
        final flow = flows[index];
        final color = isBuyers ? AppTheme.gainColor : AppTheme.lossColor;

        return ListTile(
          onTap: () => context.push('/stock/${flow.symbol}'),
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          title: Text(
            flow.symbol,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            'KL ròng: ${_formatVolume(flow.netVolume)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          trailing: Text(
            _formatBillion(flow.netValue),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}
