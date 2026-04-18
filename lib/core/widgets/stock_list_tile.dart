import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/market/presentation/providers/market_data_controller.dart';
import '../theme/app_theme.dart';
import '../theme/app_text_style.dart';
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
  final String? companyName;
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
    this.companyName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final realtime = ref.watch(realtimeStockProvider(symbol));
    final hasRt = realtime != null && realtime.matchedPrice > 0;

    final displayPrice = hasRt ? realtime.matchedPrice : price;
    final displayChange = hasRt ? realtime.change : change;
    final displayChangePercent =
        hasRt ? realtime.changePercent : changePercent;
    final displayVolume = hasRt && realtime.totalVolume > 0
        ? realtime.totalVolume
        : volume;

    final displayCeiling =
        hasRt && realtime.ceiling > 0 ? realtime.ceiling : ceiling ?? 0;
    final displayFloor =
        hasRt && realtime.floor > 0 ? realtime.floor : floor ?? 0;
    final displayRef =
        hasRt && realtime.refPrice > 0 ? realtime.refPrice : refPrice ?? 0;

    final color = (displayCeiling > 0 && displayFloor > 0 && displayRef > 0)
        ? AppTheme.stockColor(
            price: displayPrice,
            ceiling: displayCeiling,
            floor: displayFloor,
            refPrice: displayRef,
          )
        : displayChange > 0
            ? AppColors.gain
            : displayChange < 0
                ? AppColors.loss
                : AppColors.base40;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            // Symbol
            SizedBox(
              width: 62,
              child: Text(symbol, style: AppTextStyle.stockSymbol),
            ),

            // Company name or volume
            Expanded(
              child: companyName != null
                  ? Text(
                      companyName!,
                      style: AppTextStyle.s12R
                          .copyWith(color: cs.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      'KL: ${FormatUtils.volume(displayVolume)}',
                      style: AppTextStyle.s12R
                          .copyWith(color: cs.onSurfaceVariant),
                    ),
            ),

            // Price + change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  FormatUtils.price(displayPrice),
                  style: AppTextStyle.stockPrice.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  FormatUtils.changeWithPercent(
                      displayChange, displayChangePercent),
                  style: AppTextStyle.s12M.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
