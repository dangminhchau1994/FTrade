import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/insider_trade.dart';
import '../providers/corporate_providers.dart';

class InsiderTradeList extends ConsumerStatefulWidget {
  const InsiderTradeList({super.key});

  @override
  ConsumerState<InsiderTradeList> createState() => _InsiderTradeListState();
}

class _InsiderTradeListState extends ConsumerState<InsiderTradeList> {
  int _filterIndex = 0; // 0=all, 1=insider, 2=proprietary

  @override
  Widget build(BuildContext context) {
    final trades = ref.watch(insiderTradesProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Tất cả')),
              ButtonSegment(value: 1, label: Text('Nội bộ')),
              ButtonSegment(value: 2, label: Text('Tự doanh')),
            ],
            selected: {_filterIndex},
            onSelectionChanged: (selected) {
              setState(() => _filterIndex = selected.first);
            },
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(insiderTradesProvider),
            child: trades.when(
              data: (data) {
                final filtered = _filterIndex == 0
                    ? data
                    : _filterIndex == 1
                        ? data.where((t) => !t.isProprietary).toList()
                        : data.where((t) => t.isProprietary).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _InsiderTradeTile(trade: filtered[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Lỗi: $e')),
            ),
          ),
        ),
      ],
    );
  }
}

class _InsiderTradeTile extends StatelessWidget {
  final InsiderTrade trade;

  const _InsiderTradeTile({required this.trade});

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.tradeType == TradeType.buy;
    final color = isBuy ? AppColors.gain : AppColors.loss;

    return ListTile(
      onTap: () => context.push('/stock/${trade.symbol}'),
      title: Row(
        children: [
          Text(trade.symbol, style: AppTextStyle.b14B),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isBuy ? 'MUA' : 'BÁN',
              style: AppTextStyle.c10B.copyWith(color: color),
            ),
          ),
          const Spacer(),
          Text(
            '${FormatUtils.volume(trade.quantity)} CP',
            style: AppTextStyle.s12S.copyWith(color: color),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            '${trade.traderName} • ${trade.position}',
            style: AppTextStyle.s12R.copyWith(color: AppColors.base40),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Giá: ${FormatUtils.price(trade.price)} • ${FormatUtils.date(trade.tradeDate)}',
            style: AppTextStyle.c10R.copyWith(color: AppColors.base60),
          ),
        ],
      ),
      isThreeLine: true,
      dense: true,
    );
  }
}
