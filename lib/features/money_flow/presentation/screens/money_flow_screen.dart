import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../domain/entities/foreign_flow_stats.dart';
import '../providers/money_flow_providers.dart';
import '../widgets/flow_summary_card.dart';
import '../widgets/flow_bar_chart.dart';
import '../widgets/flow_ranking_list.dart';
import '../widgets/volume_anomaly_list.dart';

class MoneyFlowScreen extends ConsumerWidget {
  const MoneyFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dòng tiền'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Nước ngoài'),
              Tab(text: 'Top mua ròng'),
              Tab(text: 'Top bán ròng'),
              Tab(text: 'KL bất thường'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const _ForeignTab(),
            _BuyersTab(),
            _SellersTab(),
            _VolumeAnomalyTab(),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(marketFlowSummaryProvider);
    final history = ref.watch(foreignFlowHistoryProvider('VN-INDEX'));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(marketFlowSummaryProvider);
        ref.invalidate(foreignFlowHistoryProvider('VN-INDEX'));
      },
      child: ListView(
        children: [
          summary.when(
            data: (data) => FlowSummaryCard(
              totalBuy: data.totalForeignBuy,
              totalSell: data.totalForeignSell,
              totalNet: data.totalForeignNet,
            ),
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Lỗi: $e'),
            ),
          ),
          history.when(
            data: (data) => FlowBarChart(data: data),
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Lỗi: $e'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyers = ref.watch(topNetBuyersProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(topNetBuyersProvider),
      child: buyers.when(
        data: (data) => FlowRankingList(flows: data, isBuyers: true),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _SellersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellers = ref.watch(topNetSellersProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(topNetSellersProvider),
      child: sellers.when(
        data: (data) => FlowRankingList(flows: data, isBuyers: false),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _VolumeAnomalyTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anomalies = ref.watch(volumeAnomaliesProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(volumeAnomaliesProvider),
      child: anomalies.when(
        data: (data) => VolumeAnomalyList(anomalies: data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

// ── Foreign Investor Tab ─────────────────────────────────────────────────────

class _ForeignTab extends StatefulWidget {
  const _ForeignTab();

  @override
  State<_ForeignTab> createState() => _ForeignTabState();
}

class _ForeignTabState extends State<_ForeignTab> {
  String _catId = '2';
  bool _show10Sessions = true;

  static const _exchanges = [
    ('HSX', '2'),
    ('HNX', '1'),
    ('UPCOM', '3'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Exchange filter
        Container(
          color: cs.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: _exchanges.map((e) {
              final (label, id) = e;
              final isActive = _catId == id;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _catId = id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary50 : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: AppTextStyle.s12S.copyWith(
                        color: isActive ? AppColors.white : cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: _ForeignTabBody(
            catId: _catId,
            show10Sessions: _show10Sessions,
            onToggleChart: (v) => setState(() => _show10Sessions = v),
          ),
        ),
      ],
    );
  }
}

class _ForeignTabBody extends ConsumerWidget {
  final String catId;
  final bool show10Sessions;
  final ValueChanged<bool> onToggleChart;

  const _ForeignTabBody({
    required this.catId,
    required this.show10Sessions,
    required this.onToggleChart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(foreignExchangeSummaryProvider(catId));
    final history = ref.watch(foreignExchangeHistoryProvider(catId));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(foreignExchangeSummaryProvider(catId));
        ref.invalidate(foreignExchangeHistoryProvider(catId));
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Two-column stats card
          summary.when(
            data: (stats) => _TwoColumnStatsCard(stats: stats),
            loading: () => const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Lỗi: $e'),
            ),
          ),

          const SizedBox(height: 16),

          // Chart section header + toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text('Giá trị NN mua ròng', style: AppTextStyle.b14S),
                ),
                _ChartToggle(
                  show10Sessions: show10Sessions,
                  onChanged: onToggleChart,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Chart
          if (show10Sessions)
            history.when(
              data: (data) => FlowBarChart(data: data),
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Lỗi: $e'),
              ),
            )
          else
            summary.when(
              data: (stats) => _TodayFlowChart(stats: stats),
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Lỗi: $e'),
              ),
            ),

          const SizedBox(height: 8),

          // TOP stocks heatmap button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () => context.push('/foreign-heatmap', extra: catId),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.grid_view_rounded,
                        color: AppColors.info, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'TOP cổ phiếu NN mua bán',
                      style: AppTextStyle.b14S.copyWith(color: AppColors.info),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.info, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Today buy/sell bar chart ─────────────────────────────────────────────────

class _TodayFlowChart extends StatelessWidget {
  final ForeignFlowStats stats;
  const _TodayFlowChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final buyB = stats.buyValue / 1e9;
    final sellB = stats.sellValue / 1e9;
    final netB = stats.netValue / 1e9;

    final items = [
      _FlowBar('Mua', buyB, AppColors.gain),
      _FlowBar('Bán', sellB, AppColors.loss),
      _FlowBar('Ròng', netB, netB >= 0 ? AppColors.gain : AppColors.loss),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mua/Bán ròng hôm nay', style: AppTextStyle.b14S),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              backgroundColor: Colors.transparent,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: TextStyle(fontSize: 9, color: cs.onSurfaceVariant),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                  dashArray: const <double>[4, 4],
                ),
                plotBands: [
                  PlotBand(start: 0, end: 0, borderColor: cs.outlineVariant, borderWidth: 1),
                ],
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  final v = details.value;
                  return ChartAxisLabel(
                    v == 0 ? '0' : '${v.toStringAsFixed(0)}tỷ',
                    details.textStyle,
                  );
                },
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x: point.y tỷ',
                decimalPlaces: 1,
              ),
              series: <CartesianSeries<_FlowBar, String>>[
                ColumnSeries<_FlowBar, String>(
                  dataSource: items,
                  xValueMapper: (b, _) => b.label,
                  yValueMapper: (b, _) => b.value,
                  pointColorMapper: (b, _) => b.color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4), bottom: Radius.circular(4)),
                  spacing: 0.3,
                  animationDuration: 600,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 9, color: cs.onSurface),
                    builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                      final b = data as _FlowBar;
                      final sign = b.value >= 0 ? '+' : '';
                      return Text(
                        '$sign${b.value.toStringAsFixed(1)}tỷ',
                        style: TextStyle(fontSize: 9, color: b.color, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowBar {
  final String label;
  final double value;
  final Color color;
  const _FlowBar(this.label, this.value, this.color);
}

class _ChartToggle extends StatelessWidget {
  final bool show10Sessions;
  final ValueChanged<bool> onChanged;

  const _ChartToggle({required this.show10Sessions, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleChip(
            label: 'Hôm nay',
            active: !show10Sessions,
            onTap: () => onChanged(false),
          ),
          _ToggleChip(
            label: '10 phiên',
            active: show10Sessions,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToggleChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: AppTextStyle.s12S.copyWith(
            color: active ? cs.onPrimary : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Two-column stats card ────────────────────────────────────────────────────

class _TwoColumnStatsCard extends StatelessWidget {
  final ForeignFlowStats stats;
  const _TwoColumnStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatPanel(
              header: 'Khối lượng',
              headerColor: AppColors.info,
              rows: [
                ('Mua', _fmtVol(stats.buyVolume), AppColors.gain),
                ('Bán', _fmtVol(stats.sellVolume), AppColors.loss),
                ('Mua - Bán', _fmtVol(stats.netVolume),
                    stats.netVolume >= 0 ? AppColors.gain : AppColors.loss),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatPanel(
              header: 'Giá trị',
              headerColor: AppColors.ref,
              rows: [
                ('Mua', _fmtVal(stats.buyValue), AppColors.gain),
                ('Bán', _fmtVal(stats.sellValue), AppColors.loss),
                ('Mua - Bán', _fmtValSigned(stats.netValue),
                    stats.netValue >= 0 ? AppColors.gain : AppColors.loss),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtVol(double v) {
    final abs = v.abs();
    final sign = v < 0 ? '-' : '';
    if (abs >= 1e6) return '$sign${(abs / 1e6).toStringAsFixed(2)}M';
    if (abs >= 1e3) return '$sign${(abs / 1e3).toStringAsFixed(1)}K';
    return '$sign${abs.toStringAsFixed(0)}';
  }

  static String _fmtVal(double v) =>
      '${(v / 1e9).toStringAsFixed(1)} tỷ';

  static String _fmtValSigned(double v) =>
      '${v >= 0 ? '+' : ''}${(v / 1e9).toStringAsFixed(1)} tỷ';
}

class _StatPanel extends StatelessWidget {
  final String header;
  final Color headerColor;
  final List<(String, String, Color)> rows;

  const _StatPanel({
    required this.header,
    required this.headerColor,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: headerColor.withValues(alpha: 0.18),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              header,
              style: AppTextStyle.s12S.copyWith(color: headerColor),
              textAlign: TextAlign.center,
            ),
          ),
          // Rows
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: rows.map((r) {
                final (label, value, color) = r;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label,
                          style: AppTextStyle.s12R.copyWith(
                              color: cs.onSurfaceVariant)),
                      Text(value,
                          style: AppTextStyle.s12S.copyWith(color: color)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
