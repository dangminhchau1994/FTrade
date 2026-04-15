import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/chart_api_datasource.dart';
import '../../domain/entities/chart_point.dart' as app;
import '../providers/market_providers.dart';

class StockChart extends ConsumerStatefulWidget {
  final String symbol;

  const StockChart({super.key, required this.symbol});

  @override
  ConsumerState<StockChart> createState() => _StockChartState();
}

class _StockChartState extends ConsumerState<StockChart> {
  String _selectedPeriod = '1M';
  List<app.ChartPoint> _data = [];
  bool _loading = true;
  int _loadRequestId = 0;

  final Set<String> _activeIndicators = {'MA20'};

  late final ChartApiDatasource _chartApi;

  static const _periods = ['1D', '1W', '1M', '3M', '1Y'];

  static const _maColors = {
    'MA5':  Color(0xFFEAB308),
    'MA10': Color(0xFFF97316),
    'MA20': Color(0xFF3B82F6),
    'MA50': Color(0xFFA855F7),
  };

  bool get _showRsi =>
      _activeIndicators.contains('RSI') && _data.isNotEmpty;
  bool get _showMacd =>
      _activeIndicators.contains('MACD') && _data.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _chartApi = ref.read(chartApiDatasourceProvider);
    _loadData();
  }

  @override
  void didUpdateWidget(covariant StockChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol) {
      setState(() {
        _data = [];
        _loading = true;
      });
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final id = ++_loadRequestId;
    setState(() => _loading = true);
    try {
      final data = await _chartApi.getChartData(
        widget.symbol,
        period: _selectedPeriod,
      );
      if (!mounted || id != _loadRequestId) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || id != _loadRequestId) return;
      setState(() {
        _data = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasData = _data.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Candlestick price chart ──────────────────────────────────────
        SizedBox(
          height: 260,
          child: _loading && !hasData
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : !hasData
                  ? Center(
                      child: Text(
                        'Không có dữ liệu',
                        style: TextStyle(
                            fontSize: 13, color: cs.onSurfaceVariant),
                      ),
                    )
                  : Stack(
                      children: [
                        _buildMainChart(context),
                        if (_loading)
                          Positioned.fill(
                            child: ColoredBox(
                              color: cs.surface.withValues(alpha: 0.5),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
        ),

        if (hasData) ...[
          // ── Volume bars ──────────────────────────────────────────────────
          SizedBox(height: 52, child: _buildVolumeChart()),

          // ── RSI sub-panel ────────────────────────────────────────────────
          if (_showRsi) ...[
            const SizedBox(height: 2),
            _SubPanelLabel('RSI (14)'),
            SizedBox(height: 90, child: _buildRsiChart()),
          ],

          // ── MACD sub-panel ───────────────────────────────────────────────
          if (_showMacd) ...[
            const SizedBox(height: 2),
            _SubPanelLabel('MACD (12, 26, 9)'),
            SizedBox(height: 90, child: _buildMacdChart()),
          ],
        ],

        const SizedBox(height: 8),

        // ── Indicator chips ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              ..._maColors.entries.map(
                (e) => _IndicatorChip(
                  label: e.key,
                  color: e.value,
                  active: _activeIndicators.contains(e.key),
                  onToggle: (v) => setState(() => v
                      ? _activeIndicators.add(e.key)
                      : _activeIndicators.remove(e.key)),
                ),
              ),
              _IndicatorChip(
                label: 'BB',
                color: const Color(0xFF06B6D4),
                active: _activeIndicators.contains('BB'),
                onToggle: (v) => setState(() =>
                    v ? _activeIndicators.add('BB') : _activeIndicators.remove('BB')),
              ),
              _IndicatorChip(
                label: 'RSI',
                color: const Color(0xFFF59E0B),
                active: _activeIndicators.contains('RSI'),
                onToggle: (v) => setState(() =>
                    v ? _activeIndicators.add('RSI') : _activeIndicators.remove('RSI')),
              ),
              _IndicatorChip(
                label: 'MACD',
                color: const Color(0xFF8B5CF6),
                active: _activeIndicators.contains('MACD'),
                onToggle: (v) => setState(() =>
                    v ? _activeIndicators.add('MACD') : _activeIndicators.remove('MACD')),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── Period selector ──────────────────────────────────────────────
        _PeriodSelector(
          periods: _periods,
          selected: _selectedPeriod,
          onSelect: (p) {
            if (p == _selectedPeriod) return;
            setState(() => _selectedPeriod = p);
            _loadData();
          },
        ),
      ],
    );
  }

  // ── Main candlestick chart ──────────────────────────────────────────────────

  Widget _buildMainChart(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SfCartesianChart(
      margin: const EdgeInsets.only(right: 4, top: 4),
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        activationMode: ActivationMode.longPress,
        lineType: CrosshairLineType.both,
        lineWidth: 1,
        lineColor: cs.onSurfaceVariant.withValues(alpha: 0.5),
        shouldAlwaysShow: false,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        zoomMode: ZoomMode.x,
      ),
      primaryXAxis: const DateTimeAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        minorTickLines: const MinorTickLines(size: 0),
        labelStyle: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: cs.outlineVariant.withValues(alpha: 0.4),
          dashArray: const <double>[4, 4],
        ),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          final v = details.value;
          final label = v >= 1000
              ? '${(v / 1000).toStringAsFixed(0)}k'
              : v.toStringAsFixed(0);
          return ChartAxisLabel(label, details.textStyle);
        },
      ),
      series: <CartesianSeries<app.ChartPoint, DateTime>>[
        CandleSeries<app.ChartPoint, DateTime>(
          dataSource: _data,
          name: 'price',
          xValueMapper: (p, _) => p.date,
          lowValueMapper: (p, _) => p.low,
          highValueMapper: (p, _) => p.high,
          openValueMapper: (p, _) => p.open,
          closeValueMapper: (p, _) => p.close,
          bearColor: AppTheme.lossColor,
          bullColor: AppTheme.gainColor,
          enableSolidCandles: true,
          animationDuration: 500,
          width: 0.7,
        ),
      ],
      indicators: <TechnicalIndicator<app.ChartPoint, DateTime>>[
        // ── MA overlays
        ..._maColors.entries
            .where((e) => _activeIndicators.contains(e.key))
            .map(
              (e) => SmaIndicator<app.ChartPoint, DateTime>(
                seriesName: 'price',
                period: int.parse(e.key.substring(2)),
                signalLineColor: e.value,
                signalLineWidth: 1.2,
                animationDuration: 0,
              ),
            ),

        // ── Bollinger Bands (Epic 7)
        if (_activeIndicators.contains('BB'))
          BollingerBandIndicator<app.ChartPoint, DateTime>(
            seriesName: 'price',
            period: 20,
            standardDeviation: 2,
            upperLineColor:
                const Color(0xFF06B6D4).withValues(alpha: 0.7),
            lowerLineColor:
                const Color(0xFF06B6D4).withValues(alpha: 0.7),
            signalLineColor:
                const Color(0xFF06B6D4).withValues(alpha: 0.45),
            bandColor:
                const Color(0xFF06B6D4).withValues(alpha: 0.08),
            upperLineWidth: 1,
            lowerLineWidth: 1,
            signalLineWidth: 0.8,
            animationDuration: 0,
          ),
      ],
    );
  }

  // ── Volume chart ────────────────────────────────────────────────────────────

  Widget _buildVolumeChart() {
    return SfCartesianChart(
      margin: const EdgeInsets.only(right: 4),
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      primaryXAxis: const DateTimeAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(isVisible: false),
      series: <CartesianSeries<app.ChartPoint, DateTime>>[
        ColumnSeries<app.ChartPoint, DateTime>(
          dataSource: _data,
          xValueMapper: (p, _) => p.date,
          yValueMapper: (p, _) => p.volume.toDouble(),
          pointColorMapper: (p, _) => p.close >= p.open
              ? AppTheme.gainColor.withValues(alpha: 0.45)
              : AppTheme.lossColor.withValues(alpha: 0.45),
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(1)),
          spacing: 0.15,
          animationDuration: 0,
        ),
      ],
    );
  }

  // ── RSI sub-panel ───────────────────────────────────────────────────────────

  Widget _buildRsiChart() {
    return SfCartesianChart(
      margin: const EdgeInsets.only(right: 4),
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      primaryXAxis: const DateTimeAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 25,
        opposedPosition: true,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: TextStyle(fontSize: 9, color: Colors.grey[500]),
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: Colors.grey.withValues(alpha: 0.2),
        ),
        plotBands: <PlotBand>[
          PlotBand(
            start: 30,
            end: 70,
            color: Colors.grey.withValues(alpha: 0.06),
          ),
          PlotBand(
            start: 70,
            end: 70,
            borderColor: AppTheme.lossColor.withValues(alpha: 0.4),
            borderWidth: 1,
            dashArray: const <double>[4, 4],
          ),
          PlotBand(
            start: 30,
            end: 30,
            borderColor: AppTheme.gainColor.withValues(alpha: 0.4),
            borderWidth: 1,
            dashArray: const <double>[4, 4],
          ),
        ],
      ),
      series: <CartesianSeries<app.ChartPoint, DateTime>>[
        // Invisible series as data source for RSI indicator
        CandleSeries<app.ChartPoint, DateTime>(
          dataSource: _data,
          name: 'rsiSrc',
          xValueMapper: (p, _) => p.date,
          lowValueMapper: (p, _) => p.low,
          highValueMapper: (p, _) => p.high,
          openValueMapper: (p, _) => p.open,
          closeValueMapper: (p, _) => p.close,
          opacity: 0,
        ),
      ],
      indicators: <TechnicalIndicator<app.ChartPoint, DateTime>>[
        RsiIndicator<app.ChartPoint, DateTime>(
          seriesName: 'rsiSrc',
          period: 14,
          signalLineColor: const Color(0xFFF59E0B),
          signalLineWidth: 1.5,
          animationDuration: 0,
        ),
      ],
    );
  }

  // ── MACD sub-panel ──────────────────────────────────────────────────────────

  Widget _buildMacdChart() {
    return SfCartesianChart(
      margin: const EdgeInsets.only(right: 4),
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      primaryXAxis: const DateTimeAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: TextStyle(fontSize: 9, color: Colors.grey[500]),
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: Colors.grey.withValues(alpha: 0.2),
        ),
        plotBands: <PlotBand>[
          PlotBand(
            start: 0,
            end: 0,
            borderColor: Colors.grey.withValues(alpha: 0.4),
            borderWidth: 1,
          ),
        ],
      ),
      series: <CartesianSeries<app.ChartPoint, DateTime>>[
        // Invisible series as data source for MACD indicator
        CandleSeries<app.ChartPoint, DateTime>(
          dataSource: _data,
          name: 'macdSrc',
          xValueMapper: (p, _) => p.date,
          lowValueMapper: (p, _) => p.low,
          highValueMapper: (p, _) => p.high,
          openValueMapper: (p, _) => p.open,
          closeValueMapper: (p, _) => p.close,
          opacity: 0,
        ),
      ],
      indicators: <TechnicalIndicator<app.ChartPoint, DateTime>>[
        MacdIndicator<app.ChartPoint, DateTime>(
          seriesName: 'macdSrc',
          shortPeriod: 12,
          longPeriod: 26,
          period: 9,
          macdType: MacdType.both,
          signalLineColor: const Color(0xFFF97316),
          macdLineColor: const Color(0xFF3B82F6),
          histogramPositiveColor:
              AppTheme.gainColor.withValues(alpha: 0.5),
          histogramNegativeColor:
              AppTheme.lossColor.withValues(alpha: 0.5),
          signalLineWidth: 1.2,
          animationDuration: 0,
        ),
      ],
    );
  }
}

// ── Shared sub-widgets ──────────────────────────────────────────────────────

class _SubPanelLabel extends StatelessWidget {
  final String text;
  const _SubPanelLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 2),
        child: Text(
          text,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
      );
}

class _IndicatorChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool active;
  final ValueChanged<bool> onToggle;

  const _IndicatorChip({
    required this.label,
    required this.color,
    required this.active,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) => FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active ? Colors.white : Colors.grey[400],
          ),
        ),
        selected: active,
        onSelected: onToggle,
        selectedColor: color.withValues(alpha: 0.3),
        checkmarkColor: color,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 2),
      );
}

class _PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final String selected;
  final ValueChanged<String> onSelect;

  const _PeriodSelector({
    required this.periods,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: periods.map((p) {
          final isSelected = p == selected;
          return GestureDetector(
            onTap: () => onSelect(p),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? cs.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                p,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? cs.onPrimaryContainer
                      : Colors.grey[500],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
