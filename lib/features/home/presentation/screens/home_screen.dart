import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/market_breadth_bar.dart';
import '../../../../core/widgets/stock_list_tile.dart';
import '../../../market/domain/entities/market_index.dart';
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
              data: (data) => _IndexCardsRow(data: data),
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
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

// ── Index cards (horizontal scroll, Fireant style) ───────────────────────────

class _IndexCardsRow extends StatelessWidget {
  final List<MarketIndex> data;

  const _IndexCardsRow({required this.data});

  static const _displayName = {
    'VN-Index': 'VNINDEX',
    'HNX-Index': 'HNXINDEX',
    'UPCOM': 'UPINDEX',
    'VN30': 'VN30',
    'HNX30': 'HNX30',
  };

  static const _chartSymbol = {
    'VN-Index': 'VNINDEX',
    'HNX-Index': 'HNXINDEX',
    'UPCOM': 'HNXUpcomIndex',
    'VN30': 'VN30',
    'HNX30': 'HNX30',
  };

  static const _rtSymbol = {
    'VN-Index': 'VNINDEX',
    'HNX-Index': 'HNXINDEX',
    'UPCOM': 'UPCOMINDEX',
    'VN30': 'VN30',
    'HNX30': 'HNX30',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        itemCount: data.length,
        itemBuilder: (context, i) {
          final idx = data[i];
          return _IndexCard(
            idx: idx,
            displayName: _displayName[idx.name] ?? idx.name,
            chartSym: _chartSymbol[idx.name],
            rtSym: _rtSymbol[idx.name],
          );
        },
      ),
    );
  }
}

class _IndexCard extends ConsumerWidget {
  final MarketIndex idx;
  final String displayName;
  final String? chartSym;
  final String? rtSym;

  const _IndexCard({
    required this.idx,
    required this.displayName,
    this.chartSym,
    this.rtSym,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUp = idx.change > 0;
    final isDown = idx.change < 0;
    final color = isUp
        ? AppColors.gain
        : isDown
            ? AppColors.loss
            : AppColors.ref;
    final sign = idx.change > 0 ? '+' : '';

    final prevClose = idx.value - idx.change;
    final chartAsync = chartSym != null
        ? ref.watch(indexIntradayChartProvider(chartSym!))
        : null;

    return GestureDetector(
      onTap: rtSym != null ? () => context.push('/index/$rtSym') : null,
      child: Container(
        width: 162,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index name
            Text(
              displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 3),
            // Price + percent
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  FormatUtils.indexValue(idx.value),
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '$sign${idx.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Sparkline with baseline
            SizedBox(
              height: 30,
              child: chartAsync == null
                  ? const SizedBox.shrink()
                  : chartAsync.when(
                      data: (pts) => pts.length >= 2
                          ? CustomPaint(
                              size: const Size(double.infinity, 30),
                              painter: _SparklinePainter(
                                values: pts.map((p) => p.close).toList(),
                                color: color,
                                prevClose: prevClose,
                              ),
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double prevClose;

  const _SparklinePainter({
    required this.values,
    required this.color,
    required this.prevClose,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    // Include prevClose in range so baseline is always visible
    final allValues = [...values, prevClose];
    final minV = allValues.reduce(math.min);
    final maxV = allValues.reduce(math.max);
    final range = maxV - minV;
    final lo = range > 0 ? minV : minV - 1;
    final hi = range > 0 ? maxV : maxV + 1;
    final span = hi - lo;

    double yOf(double v) => (1 - (v - lo) / span) * size.height;
    double xOf(int i) => i / (values.length - 1) * size.width;

    // Baseline (previous close) — dashed amber line
    final baseY = yOf(prevClose);
    const dashW = 4.0;
    const gapW = 3.0;
    final baselinePaint = Paint()
      ..color = AppColors.ref
      ..strokeWidth = 1.0;
    var dx = 0.0;
    while (dx < size.width) {
      canvas.drawLine(
        Offset(dx, baseY),
        Offset(math.min(dx + dashW, size.width), baseY),
        baselinePaint,
      );
      dx += dashW + gapW;
    }

    // Build sparkline path
    final path = Path()..moveTo(xOf(0), yOf(values[0]));
    for (var i = 1; i < values.length; i++) {
      path.lineTo(xOf(i), yOf(values[i]));
    }

    // Fill area between sparkline and baseline (makes chart visible like Fireant)
    final fillPath = Path.from(path);
    fillPath.lineTo(xOf(values.length - 1), baseY);
    fillPath.lineTo(xOf(0), baseY);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill,
    );

    // Sparkline stroke
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dot at last point
    canvas.drawCircle(
      Offset(xOf(values.length - 1), yOf(values.last)),
      3,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color || old.prevClose != prevClose;
}

// ── Quick access card ─────────────────────────────────────────────────────────

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
