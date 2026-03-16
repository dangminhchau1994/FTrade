import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/market/presentation/providers/market_data_controller.dart';
import '../theme/app_theme.dart';
import '../utils/format_utils.dart';

class StockListTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // Overlay realtime data nếu có, fallback về REST data
    final realtime = ref.watch(realtimeStockProvider(symbol));

    final displayPrice =
        realtime != null && realtime.matchedPrice > 0
            ? realtime.matchedPrice
            : price;
    final displayChange =
        realtime != null && realtime.matchedPrice > 0
            ? realtime.change
            : change;
    final displayChangePercent =
        realtime != null && realtime.matchedPrice > 0
            ? realtime.changePercent
            : changePercent;
    final displayVolume =
        realtime != null && realtime.totalVolume > 0
            ? realtime.totalVolume
            : volume;

    final color = displayChange > 0
        ? AppTheme.gainColor
        : displayChange < 0
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
                'KL: ${FormatUtils.volume(displayVolume)}',
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
                  FormatUtils.price(displayPrice),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${FormatUtils.change(displayChange)} (${FormatUtils.percent(displayChangePercent)})',
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
