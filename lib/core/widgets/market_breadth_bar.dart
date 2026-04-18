import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../theme/app_theme.dart';
import '../theme/app_text_style.dart';

class MarketBreadthBar extends StatelessWidget {
  final int advances;
  final int declines;
  final int unchanged;

  const MarketBreadthBar({
    super.key,
    required this.advances,
    required this.declines,
    required this.unchanged,
  });

  @override
  Widget build(BuildContext context) {
    final total = advances + declines + unchanged;
    if (total == 0) return const SizedBox.shrink();

    final data = [
      _BreadthSlice('Tăng ($advances)', advances, AppColors.gain),
      _BreadthSlice('Không đổi ($unchanged)', unchanged, AppColors.ref),
      _BreadthSlice('Giảm ($declines)', declines, AppColors.loss),
    ];

    return SizedBox(
      height: 160,
      child: SfCircularChart(
        margin: EdgeInsets.zero,
        legend: const Legend(
          isVisible: false,
        ),
        series: <CircularSeries>[
          PieSeries<_BreadthSlice, String>(
            dataSource: data,
            xValueMapper: (s, _) => s.label,
            yValueMapper: (s, _) => s.value,
            pointColorMapper: (s, _) => s.color,
            dataLabelMapper: (s, _) => s.label,
            radius: '80%',
            strokeWidth: 1.5,
            strokeColor: Colors.black,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: const ConnectorLineSettings(
                type: ConnectorType.line,
                length: '8%',
                color: Color(0xFF888888),
              ),
              textStyle: AppTextStyle.c10R.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreadthSlice {
  final String label;
  final int value;
  final Color color;
  const _BreadthSlice(this.label, this.value, this.color);
}
