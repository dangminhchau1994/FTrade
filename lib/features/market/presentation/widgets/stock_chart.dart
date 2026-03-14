import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/datasources/chart_api_datasource.dart';
import '../../data/datasources/indicator_calculator.dart';
import '../../domain/entities/chart_point.dart';
import '../providers/market_providers.dart';

class StockChart extends ConsumerStatefulWidget {
  final String symbol;

  const StockChart({super.key, required this.symbol});

  @override
  ConsumerState<StockChart> createState() => _StockChartState();
}

class _StockChartState extends ConsumerState<StockChart> {
  String _selectedPeriod = '1M';
  List<ChartPoint> _data = [];
  Map<String, List<double?>> _indicators = {};
  bool _loading = true;
  int _loadRequestId = 0;

  final Set<String> _activeIndicators = {'MA20'};

  static const _periods = ['1D', '1W', '1M', '3M', '1Y'];

  static const _maColors = {
    'MA5': Colors.yellow,
    'MA10': Colors.orange,
    'MA20': Colors.blue,
    'MA50': Colors.purple,
  };

  late final ChartApiDatasource _chartApi;

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
        _indicators = {};
        _loading = true;
      });
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final requestId = ++_loadRequestId;
    setState(() => _loading = true);

    List<ChartPoint> nextData;
    try {
      final data = await _chartApi.getChartData(
        widget.symbol,
        period: _selectedPeriod,
      );
      nextData = data;
    } catch (_) {
      nextData = [];
    }

    final nextIndicators = IndicatorCalculator.calculate(nextData);

    if (!mounted || requestId != _loadRequestId) {
      return;
    }

    setState(() {
      _data = nextData;
      _indicators = nextIndicators;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasData = _data.isNotEmpty;
    final isUp = hasData ? _data.last.close >= _data.first.open : true;
    final color = isUp ? AppTheme.gainColor : AppTheme.lossColor;
    final minY = hasData ? _data.map((p) => p.low).reduce(min) : 0.0;
    final maxY = hasData ? _data.map((p) => p.high).reduce(max) : 0.0;
    final padding = hasData ? (maxY - minY) * 0.1 : 0.0;

    return Column(
      children: [
        // Main price chart with MA overlays
        SizedBox(
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasData)
                Padding(
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
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              if (value == meta.min || value == meta.max) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                FormatUtils.price(value),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
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
                                  FormatUtils.price(s.y),
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
                        // Price line
                        LineChartBarData(
                          spots: _data.asMap().entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value.close))
                              .toList(),
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
                        // MA overlays
                        ..._maColors.entries
                            .where((e) => _activeIndicators.contains(e.key))
                            .map((e) => _maLine(e.key.toLowerCase(), e.value)),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'No chart data',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                    ),
                  ),
                ),
              if (_loading && hasData)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (hasData) ...[
          const SizedBox(height: 8),

          // Volume bars
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: _data.asMap().entries
                      .map((e) => BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.volume.toDouble(),
                                color: e.value.close >= e.value.open
                                    ? AppTheme.gainColor.withValues(alpha: 0.5)
                                    : AppTheme.lossColor.withValues(alpha: 0.5),
                                width:
                                    (MediaQuery.of(context).size.width - 32) /
                                    _data.length *
                                    0.7,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ],
                          ))
                      .toList(),
                  barTouchData: BarTouchData(enabled: false),
                ),
              ),
            ),
          ),
        ],

        // RSI panel
        if (hasData && _activeIndicators.contains('RSI')) ...[
          const SizedBox(height: 4),
          _buildRSIPanel(),
        ],

        // MACD panel
        if (hasData && _activeIndicators.contains('MACD')) ...[
          const SizedBox(height: 4),
          _buildMACDPanel(),
        ],

        const SizedBox(height: 8),

        // Indicator toggle chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: ['MA5', 'MA10', 'MA20', 'MA50', 'RSI', 'MACD'].map((name) {
              final isActive = _activeIndicators.contains(name);
              final chipColor = _maColors[name] ?? Colors.amber;
              return FilterChip(
                label: Text(name, style: TextStyle(fontSize: 11, color: isActive ? Colors.white : Colors.grey[400])),
                selected: isActive,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _activeIndicators.add(name);
                    } else {
                      _activeIndicators.remove(name);
                    }
                  });
                },
                selectedColor: chipColor.withValues(alpha: 0.3),
                checkmarkColor: chipColor,
                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 2),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        // Period selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _periods.map((period) {
              final isSelected = period == _selectedPeriod;
              return GestureDetector(
                onTap: () {
                  if (isSelected) return;
                  setState(() => _selectedPeriod = period);
                  _loadData();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  LineChartBarData _maLine(String key, Color color) {
    final values = _indicators[key] ?? [];
    final spots = <FlSpot>[];
    for (var i = 0; i < values.length; i++) {
      if (values[i] != null) {
        spots.add(FlSpot(i.toDouble(), values[i]!));
      }
    }
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      preventCurveOverShooting: true,
      color: color.withValues(alpha: 0.7),
      barWidth: 1.2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildRSIPanel() {
    final rsi = _indicators['rsi'] ?? [];
    final spots = <FlSpot>[];
    for (var i = 0; i < rsi.length; i++) {
      if (rsi[i] != null) spots.add(FlSpot(i.toDouble(), rsi[i]!));
    }
    if (spots.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text('RSI (14)', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ),
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value == 30 || value == 50 || value == 70) {
                          return Text('${value.toInt()}', style: TextStyle(fontSize: 9, color: Colors.grey[600]));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 100,
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(y: 70, color: Colors.red.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [4, 4]),
                    HorizontalLine(y: 30, color: Colors.green.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [4, 4]),
                  ],
                ),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    color: Colors.amber,
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMACDPanel() {
    final macdLine = _indicators['macdLine'] ?? [];
    final signalLine = _indicators['signalLine'] ?? [];
    final histogram = _indicators['macdHistogram'] ?? [];

    final macdSpots = <FlSpot>[];
    final signalSpots = <FlSpot>[];
    for (var i = 0; i < macdLine.length; i++) {
      if (macdLine[i] != null) macdSpots.add(FlSpot(i.toDouble(), macdLine[i]!));
      if (i < signalLine.length && signalLine[i] != null) {
        signalSpots.add(FlSpot(i.toDouble(), signalLine[i]!));
      }
    }
    if (macdSpots.isEmpty) return const SizedBox.shrink();

    // Calculate Y range from all MACD values
    final allValues = [
      ...macdLine.whereType<double>(),
      ...signalLine.whereType<double>(),
      ...histogram.whereType<double>(),
    ];
    if (allValues.isEmpty) return const SizedBox.shrink();
    final maxAbs = allValues.map((v) => v.abs()).reduce(max) * 1.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text('MACD (12,26,9)', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ),
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                // Histogram bars
                BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minY: -maxAbs,
                    maxY: maxAbs,
                    barGroups: histogram.asMap().entries
                        .where((e) => e.value != null)
                        .map((e) => BarChartGroupData(
                              x: e.key,
                              barRods: [
                                BarChartRodData(
                                  toY: e.value!,
                                  color: e.value! >= 0
                                      ? AppTheme.gainColor.withValues(alpha: 0.4)
                                      : AppTheme.lossColor.withValues(alpha: 0.4),
                                  width: (MediaQuery.of(context).size.width - 16) / _data.length * 0.5,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ],
                            ))
                        .toList(),
                    barTouchData: BarTouchData(enabled: false),
                  ),
                ),
                // MACD and Signal lines
                LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minY: -maxAbs,
                    maxY: maxAbs,
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: macdSpots,
                        isCurved: true,
                        preventCurveOverShooting: true,
                        color: Colors.blue,
                        barWidth: 1.2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: signalSpots,
                        isCurved: true,
                        preventCurveOverShooting: true,
                        color: Colors.orange,
                        barWidth: 1.2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
