import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/market_breadth_bar.dart';
import '../../../../core/widgets/stock_list_tile.dart';
import '../../../market/presentation/providers/market_providers.dart';
import '../../../news/presentation/providers/news_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indices = ref.watch(marketIndicesProvider);
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
          ref.invalidate(marketIndicesProvider);
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
                    return Container(
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            FormatUtils.price(idx.value),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isUp
                                  ? AppTheme.gainColor
                                  : AppTheme.lossColor,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                isUp
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: isUp
                                    ? AppTheme.gainColor
                                    : AppTheme.lossColor,
                                size: 20,
                              ),
                              Text(
                                '${FormatUtils.change(idx.change)} (${FormatUtils.percent(idx.changePercent)})',
                                style: TextStyle(
                                  color: isUp
                                      ? AppTheme.gainColor
                                      : AppTheme.lossColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                      color: Colors.blue,
                      onTap: () => context.push('/money-flow'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAccessCard(
                      icon: Icons.business,
                      label: 'Doanh nghiệp',
                      color: Colors.orange,
                      onTap: () => context.push('/corporate'),
                    ),
                  ),
                ],
              ),
            ),

            // Top Gainers
            _SectionHeader(title: 'Top tăng giá', onViewAll: () => context.go('/market')),
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
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Text(
                                a.source,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                FormatUtils.timeAgo(a.publishedAt),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
