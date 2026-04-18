import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/market_breadth_bar.dart';
import '../../../../core/widgets/stock_list_tile.dart';
import '../../../market/presentation/providers/market_providers.dart';
import '../../../news/presentation/providers/news_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indices = ref.watch(realtimeMarketIndicesProvider);
    final topGainers = ref.watch(topGainersProvider);
    final latestNews = ref.watch(latestNewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FTrade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/watchlist'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(marketIndicesProvider); // refresh REST base data
          ref.invalidate(topGainersProvider);
          ref.invalidate(latestNewsProvider);
        },
        child: ListView(
          children: [
            // Market Indices
            indices.when(
              data: (data) => SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final idx = data[index];
                    final isUp = idx.change >= 0;
                    const nameToSymbol = {
                      'VN-Index': 'VNINDEX',
                      'HNX-Index': 'HNXINDEX',
                      'UPCOM': 'UPCOMINDEX',
                      'VN30': 'VN30',
                      'HNX30': 'HNX30',
                    };
                    final rtSymbol = nameToSymbol[idx.name];
                    return GestureDetector(
                      onTap: rtSymbol != null
                          ? () => context.push('/index/$rtSymbol')
                          : null,
                      child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            idx.name,
                            style: AppTextStyle.sectionHeader,
                          ),
                          Text(
                            FormatUtils.indexValue(idx.value),
                            style: AppTextStyle.h20B.copyWith(
                              color: isUp ? AppColors.gain : AppColors.loss,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                isUp
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: isUp ? AppColors.gain : AppColors.loss,
                                size: 20,
                              ),
                              Text(
                                FormatUtils.indexChangeWithPercent(idx.change, idx.changePercent),
                                style: AppTextStyle.s12M.copyWith(
                                  color: isUp ? AppColors.gain : AppColors.loss,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                ),
              ),
              loading: () =>
                  const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Lỗi: $e'),
              ),
            ),

            // Market Breadth
            indices.when(
              data: (data) {
                if (data.isEmpty) return const SizedBox.shrink();
                final idx = data.first; // VN-Index
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: MarketBreadthBar(
                    advances: idx.advances,
                    declines: idx.declines,
                    unchanged: idx.unchanged,
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Quick Access Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickAccessCard(
                      icon: Icons.swap_vert,
                      label: 'Dòng tiền',
                      color: AppColors.info,
                      onTap: () => context.push('/money-flow'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAccessCard(
                      icon: Icons.business,
                      label: 'Doanh nghiệp',
                      color: AppColors.primary50,
                      onTap: () => context.push('/corporate'),
                    ),
                  ),
                ],
              ),
            ),

            // Top Gainers
            _SectionHeader(title: 'Top tăng giá', onViewAll: () => context.push('/market')),
            topGainers.when(
              data: (stocks) => Column(
                children: stocks
                    .take(5)
                    .map(
                      (s) => StockListTile(
                        symbol: s.symbol,
                        price: s.price,
                        change: s.change,
                        changePercent: s.changePercent,
                        volume: s.volume,
                        ceiling: s.ceiling,
                        floor: s.floor,
                        refPrice: s.refPrice,
                        onTap: () => context.push('/stock/${s.symbol}'),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Lỗi: $e'),
              ),
            ),

            const Divider(height: 1),

            // Latest News
            _SectionHeader(title: 'Tin tức mới nhất', onViewAll: () => context.go('/news')),
            latestNews.when(
              data: (articles) => Column(
                children: articles
                    .take(5)
                    .map(
                      (a) => ListTile(
                        onTap: () => context.push('/news/${a.id}'),
                        title: Text(
                          a.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.b14R,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Text(
                                a.source,
                                style: AppTextStyle.s12M.copyWith(
                                  color: AppColors.primary50,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                FormatUtils.timeAgo(a.publishedAt),
                                style: AppTextStyle.s12R.copyWith(
                                  color: AppColors.base50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Lỗi: $e'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyle.b14S.copyWith(color: cs.onSurface),
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 18, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const _SectionHeader({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.b16B),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text('Xem tất cả'),
            ),
        ],
      ),
    );
  }
}
