import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/market_breadth_bar.dart';
import '../../../../core/widgets/stock_list_tile.dart';
import '../../domain/entities/chart_point.dart';
import '../../domain/entities/stock.dart';
import '../providers/market_data_controller.dart';
import '../providers/market_providers.dart';

// Exchange code per index symbol
const _symbolToExchange = {
  'VNINDEX': 'HOSE',
  'HNXINDEX': 'HNX',
  'UPCOMINDEX': 'UPCOM',
};

const _symbolToDisplayName = {
  'VNINDEX': 'VN-Index',
  'HNXINDEX': 'HNX-Index',
  'UPCOMINDEX': 'UPCOM',
  'VN30': 'VN30',
  'HNX30': 'HNX30',
};

class IndexDetailScreen extends ConsumerWidget {
  final String symbol;

  const IndexDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexAsync = ref.watch(indexBySymbolProvider(symbol));
    final exchange = _symbolToExchange[symbol];
    final displayName = _symbolToDisplayName[symbol] ?? symbol;

    return Scaffold(
      appBar: AppBar(title: Text(displayName)),
      body: indexAsync.when(
        data: (index) {
          if (index == null) {
            return const Center(child: Text('Không có dữ liệu'));
          }
          final isUp = index.change >= 0;
          final color = isUp ? AppTheme.gainColor : AppTheme.lossColor;

          return ListView(
            children: [
              // Header: value + change
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          FormatUtils.indexValue(index.value),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            FormatUtils.indexChangeWithPercent(
                              index.change,
                              index.changePercent,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _LiveBadge(symbol: symbol),
                  ],
                ),
              ),

              // Chart
              _IndexChart(symbol: symbol),

              const SizedBox(height: 12),
              const Divider(height: 1),

              // Breadth
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Độ rộng thị trường',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MarketBreadthBar(
                      advances: index.advances,
                      declines: index.declines,
                      unchanged: index.unchanged,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Stats grid
              Padding(
                padding: const EdgeInsets.all(16),
                child: _StatsGrid(items: [
                  _StatItem('KL giao dịch', FormatUtils.volume(index.totalVolume)),
                ]),
              ),

              const Divider(height: 1),

              // Top gainers / losers (only for exchanges with stock data)
              if (exchange != null) ...[
                _TopStocksSection(
                  title: 'Top tăng',
                  provider: indexTopGainersProvider(exchange),
                ),
                const Divider(height: 1),
                _TopStocksSection(
                  title: 'Top giảm',
                  provider: indexTopLosersProvider(exchange),
                ),
              ],

              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _LiveBadge extends ConsumerWidget {
  final String symbol;

  const _LiveBadge({required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketDataControllerProvider);
    final hasRt = state.indices.containsKey(symbol);

    if (!hasRt) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Live',
          style: TextStyle(
            fontSize: 11,
            color: Colors.green[400],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _IndexChart extends ConsumerStatefulWidget {
  final String symbol;

  const _IndexChart({required this.symbol});

  @override
  ConsumerState<_IndexChart> createState() => _IndexChartState();
}

class _IndexChartState extends ConsumerState<_IndexChart> {
  String _period = '3M';
  static const _periods = ['1M', '3M', '6M', '1Y', '5Y'];

  @override
  Widget build(BuildContext context) {
    final chartAsync = ref.watch(
      indexChartProvider((symbol: widget.symbol, period: _period)),
    );

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: chartAsync.when(
            data: (data) => _buildChart(data),
            loading: () => const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => Center(
              child: Text(
                'Không thể tải biểu đồ',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Period selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _periods.map((p) {
              final isSelected = p == _period;
              return GestureDetector(
                onTap: () => setState(() => _period = p),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    p,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Colors.grey[500],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(List<ChartPoint> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No chart data',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      );
    }

    final isUp = data.last.close >= data.first.close;
    final color = isUp ? AppTheme.gainColor : AppTheme.lossColor;
    final minY = data.map((p) => p.low).reduce(min);
    final maxY = data.map((p) => p.high).reduce(max);
    final padding = (maxY - minY) * 0.1;

    final spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.close))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  if (value == meta.min || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    FormatUtils.indexValue(value),
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: minY - padding,
          maxY: maxY + padding,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      FormatUtils.indexValue(s.y),
                      TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: color,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.25),
                    color.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopStocksSection extends ConsumerWidget {
  final String title;
  final ProviderListenable<AsyncValue<List<Stock>>> provider;

  const _TopStocksSection({required this.title, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        async.when(
          data: (stocks) => Column(
            children: stocks.map((s) {
              return StockListTile(
                symbol: s.symbol,
                price: s.price,
                change: s.change,
                changePercent: s.changePercent,
                volume: s.volume,
                ceiling: s.ceiling,
                floor: s.floor,
                refPrice: s.refPrice,
                onTap: () => context.push('/stock/${s.symbol}'),
              );
            }).toList(),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  _StatItem(this.label, this.value);
}

class _StatsGrid extends StatelessWidget {
  final List<_StatItem> items;

  const _StatsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: items
          .map(
            (item) => SizedBox(
              width: (MediaQuery.of(context).size.width - 32) / 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
