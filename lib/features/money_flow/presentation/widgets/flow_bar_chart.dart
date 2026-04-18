import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/foreign_flow.dart';

class FlowBarChart extends StatelessWidget {
  final List<ForeignFlow> data;

  const FlowBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final recent =
        data.length > 10 ? data.sublist(data.length - 10) : data;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mua/Bán ròng 10 phiên gần nhất',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
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
                labelStyle:
                    TextStyle(fontSize: 9, color: cs.onSurfaceVariant),
                labelIntersectAction: AxisLabelIntersectAction.hide,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle:
                    TextStyle(fontSize: 9, color: cs.onSurfaceVariant),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                  dashArray: const <double>[4, 4],
                ),
                plotBands: <PlotBand>[
                  PlotBand(
                    start: 0,
                    end: 0,
                    borderColor: cs.outlineVariant,
                    borderWidth: 1,
                  ),
                ],
                // yValueMapper already divides by 1e9, so axis values are in tỷ
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
                format: 'point.y tỷ',
                decimalPlaces: 1,
              ),
              series: <CartesianSeries<ForeignFlow, String>>[
                ColumnSeries<ForeignFlow, String>(
                  dataSource: recent,
                  xValueMapper: (f, _) =>
                      DateFormat('dd/MM').format(f.date),
                  yValueMapper: (f, _) => f.netValue / 1e9,
                  pointColorMapper: (f, _) => f.netValue >= 0
                      ? AppColors.gain
                      : AppColors.loss,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                    bottom: Radius.circular(3),
                  ),
                  spacing: 0.2,
                  animationDuration: 600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
