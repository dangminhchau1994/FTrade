import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../domain/entities/foreign_flow.dart';
import '../providers/money_flow_providers.dart';

class ForeignHeatmapScreen extends ConsumerWidget {
  final String catId;
  const ForeignHeatmapScreen({super.key, this.catId = ''});

  static String _exchangeName(String catId) => switch (catId) {
        '2' => 'HSX',
        '1' => 'HNX',
        '3' => 'UPCOM',
        _ => 'Tất cả sàn',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowsAsync = ref.watch(foreignHeatmapProvider(catId));

    return Scaffold(
      appBar: AppBar(
        title: Text('TOP NN mua bán ròng trên ${_exchangeName(catId)}'),
      ),
      body: flowsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
        data: (flows) {
          final items = _buildItems(flows);
          if (items.isEmpty) {
            return Center(
              child: Text('Không có dữ liệu', style: AppTextStyle.b14R),
            );
          }
          return _Heatmap(items: items);
        },
      ),
    );
  }

  List<_HeatItem> _buildItems(List<ForeignFlow> flows) {
    return flows.map((f) {
      final bilValue = f.netValue / 1e9;
      final absVal = bilValue.abs();
      final color = f.netValue >= 0 ? _gainColor(absVal) : _lossColor(absVal);
      return _HeatItem(
        symbol: f.symbol,
        label: '${bilValue >= 0 ? '+' : ''}${bilValue.toStringAsFixed(2)} tỷ',
        weight: absVal,
        color: color,
      );
    }).toList();
  }

  Color _gainColor(double absVal) {
    if (absVal >= 200) return const Color(0xFF006600);
    if (absVal >= 100) return const Color(0xFF008800);
    if (absVal >= 50) return const Color(0xFF00AA00);
    if (absVal >= 20) return const Color(0xFF22BB22);
    return const Color(0xFF44CC44);
  }

  Color _lossColor(double absVal) {
    if (absVal >= 200) return const Color(0xFF880000);
    if (absVal >= 100) return const Color(0xFFAA1100);
    if (absVal >= 50) return const Color(0xFFBB2200);
    if (absVal >= 20) return const Color(0xFFCC3300);
    return const Color(0xFFDD4400);
  }
}

class _HeatItem {
  final String symbol;
  final String label;
  final double weight;
  final Color color;
  const _HeatItem({
    required this.symbol,
    required this.label,
    required this.weight,
    required this.color,
  });
}

class _Heatmap extends StatelessWidget {
  final List<_HeatItem> items;
  const _Heatmap({required this.items});

  @override
  Widget build(BuildContext context) {
    return SfTreemap(
      dataCount: items.length,
      weightValueMapper: (int index) => items[index].weight,
      tooltipSettings: const TreemapTooltipSettings(
        color: Color(0xFF2B2928),
      ),
      levels: [
        TreemapLevel(
          groupMapper: (int index) => items[index].symbol,
          colorValueMapper: (TreemapTile tile) =>
              items[tile.indices[0]].color,
          labelBuilder: (BuildContext context, TreemapTile tile) {
            final item = items[tile.indices[0]];
            return LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight;
                final w = constraints.maxWidth;
                if (h < 12 || w < 16) return const SizedBox.shrink();
                final symbolSize = (w / 5).clamp(7.0, 13.0);
                final valueSize = (symbolSize * 0.75).clamp(6.0, 10.0);
                final showValue = h >= symbolSize + valueSize + 6;
                return ClipRect(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.symbol,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: symbolSize,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          if (showValue) ...[
                            SizedBox(height: h * 0.04),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: valueSize,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          tooltipBuilder: (BuildContext context, TreemapTile tile) {
            final item = items[tile.indices[0]];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.symbol,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  Text(item.label,
                      style: const TextStyle(
                          color: AppColors.white, fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
