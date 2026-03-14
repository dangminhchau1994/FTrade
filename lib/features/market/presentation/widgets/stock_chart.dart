import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/datasources/chart_mock_datasource.dart';
import '../../data/datasources/indicator_calculator.dart';

class StockChart extends StatefulWidget {
  final String symbol;

  const StockChart({super.key, required this.symbol});

  @override
  State<StockChart> createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  String _selectedPeriod = '1M';
  late List<ChartPoint> _data;
  late Map<String, List<double?>> _indicators;

  final Set<String> _activeIndicators = {'MA20'};

  static const _periods = ['1D', '1W', '1M', '3M', '1Y'];

  static const _maColors = {
    'MA5': Colors.yellow,
    'MA10': Colors.orange,
    'MA20': Colors.blue,
    'MA50': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _data = ChartMockDatasource.generate(period: _selectedPeriod);
    _indicators = IndicatorCalculator.calculate(_data);
  }

  @override
  Widget build(BuildContext context) {
    final isUp = _data.last.close >= _data.first.open;
    final color = isUp ? AppTheme.gainColor : AppTheme.lossColor;

    final minY = _data.map((p) => p.low).reduce(min);
    final maxY = _data.map((p) => p.high).reduce(max);
    final padding = (maxY - minY) * 0.1;

    return Column(
      children: [
        // Main price chart with MA overlays
        SizedBox(
          height: 200,
          child: Padding(
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
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: minY - padding,
                maxY: maxY + padding,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots
                        .map((s) => LineTooltipItem(
                              FormatUtils.price(s.y),
                              TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                            ))
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
          ),
        ),

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
                              width: (MediaQuery.of(context).size.width - 32) / _data.length * 0.7,
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

        // RSI panel
        if (_activeIndicators.contains('RSI')) ...[
          const SizedBox(height: 4),
          _buildRSIPanel(),
        ],

        // MACD panel
        if (_activeIndicators.contains('MACD')) ...[
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
                  setState(() {
                    _selectedPeriod = period;
                    _loadData();
                  });
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
