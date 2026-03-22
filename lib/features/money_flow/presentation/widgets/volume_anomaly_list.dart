import 'package:flutter/material.dart';

import '../../domain/entities/volume_anomaly.dart';

class VolumeAnomalyList extends StatelessWidget {
  const VolumeAnomalyList({super.key, required this.anomalies});

  final List<VolumeAnomaly> anomalies;

  @override
  Widget build(BuildContext context) {
    if (anomalies.isEmpty) {
      return const Center(child: Text('Không có cổ phiếu KL bất thường'));
    }

    return ListView.separated(
      itemCount: anomalies.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = anomalies[index];
        return _VolumeAnomalyTile(item: item);
      },
    );
  }
}

class _VolumeAnomalyTile extends StatelessWidget {
  const _VolumeAnomalyTile({required this.item});

  final VolumeAnomaly item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUp = item.changePercent >= 0;
    final changeColor = isUp ? const Color(0xFF00C853) : const Color(0xFFD50000);

    return ListTile(
      dense: true,
      leading: Container(
        width: 48,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          item.symbol,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'KL: ${_formatVol(item.todayVolume)} (x${item.ratio.toStringAsFixed(1)} TB)',
              style: theme.textTheme.bodySmall,
            ),
          ),
          Text(
            _formatPrice(item.price),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6F00).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'x${item.ratio.toStringAsFixed(1)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFFFF6F00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'TB20: ${_formatVol(item.avgVolume20d)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Text(
            '${isUp ? '+' : ''}${item.changePercent.toStringAsFixed(2)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: changeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatVol(double vol) {
    if (vol >= 1e6) return '${(vol / 1e6).toStringAsFixed(1)}M';
    if (vol >= 1e3) return '${(vol / 1e3).toStringAsFixed(0)}K';
    return vol.toStringAsFixed(0);
  }

  String _formatPrice(double price) {
    if (price >= 1e9) return '${(price / 1e9).toStringAsFixed(1)}B';
    if (price >= 1e6) return '${(price / 1e6).toStringAsFixed(1)}M';
    if (price >= 1e3) return '${(price / 1e3).toStringAsFixed(1)}K';
    return price.toStringAsFixed(0);
  }
}
