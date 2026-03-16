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
  final double? ceiling;
  final double? floor;
  final double? refPrice;
  final VoidCallback? onTap;

  const StockListTile({
    super.key,
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.volume,
    this.ceiling,
    this.floor,
    this.refPrice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realtime = ref.watch(realtimeStockProvider(symbol));
    final hasRt = realtime != null && realtime.matchedPrice > 0;

    final displayPrice = hasRt ? realtime.matchedPrice : price;
    final displayChange = hasRt ? realtime.change : change;
    final displayChangePercent = hasRt ? realtime.changePercent : changePercent;
    final displayVolume = hasRt && realtime.totalVolume > 0
        ? realtime.totalVolume
        : volume;

    // Dùng ceiling/floor/ref từ realtime nếu có, fallback về props
    final displayCeiling = hasRt && realtime.ceiling > 0
        ? realtime.ceiling
        : ceiling ?? 0;
    final displayFloor = hasRt && realtime.floor > 0
        ? realtime.floor
        : floor ?? 0;
    final displayRef = hasRt && realtime.refPrice > 0
        ? realtime.refPrice
        : refPrice ?? 0;

    // Màu theo chuẩn TTCK VN nếu có đủ thông tin trần/sàn/TC
    final color = (displayCeiling > 0 && displayFloor > 0 && displayRef > 0)
        ? AppTheme.stockColor(
            price: displayPrice,
            ceiling: displayCeiling,
            floor: displayFloor,
            refPrice: displayRef,
          )
        : displayChange > 0
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
                  FormatUtils.changeWithPercent(displayChange, displayChangePercent),
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
