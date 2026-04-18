import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../providers/fundamental_providers.dart';
import '../../domain/entities/industry_comparison.dart';

class IndustryComparisonScreen extends ConsumerStatefulWidget {
  final String symbol;

  const IndustryComparisonScreen({super.key, required this.symbol});

  @override
  ConsumerState<IndustryComparisonScreen> createState() =>
      _IndustryComparisonScreenState();
}

class _IndustryComparisonScreenState
    extends ConsumerState<IndustryComparisonScreen> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    final comparison = ref.watch(industryComparisonProvider(widget.symbol));

    return Scaffold(
      appBar: AppBar(
        title: Text('So sánh ngành - ${widget.symbol}'),
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(industryComparisonProvider(widget.symbol)),
        child: comparison.when(
          data: (data) {
            final sorted = List<IndustryComparison>.from(data);
            if (_sortColumnIndex != null) {
              sorted.sort((a, b) {
                final aVal = _getValue(a, _sortColumnIndex!);
                final bVal = _getValue(b, _sortColumnIndex!);
                return _sortAscending
                    ? aVal.compareTo(bVal)
                    : bVal.compareTo(aVal);
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columnSpacing: 16,
                  headingRowHeight: 40,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 40,
                  columns: [
                    DataColumn(label: Text('Mã CP', style: AppTextStyle.s12B)),
                    DataColumn(label: Text('P/E', style: AppTextStyle.s12B), numeric: true, onSort: _onSort),
                    DataColumn(label: Text('P/B', style: AppTextStyle.s12B), numeric: true, onSort: _onSort),
                    DataColumn(label: Text('ROE', style: AppTextStyle.s12B), numeric: true, onSort: _onSort),
                    DataColumn(label: Text('ROA', style: AppTextStyle.s12B), numeric: true, onSort: _onSort),
                    DataColumn(label: Text('D/E', style: AppTextStyle.s12B), numeric: true, onSort: _onSort),
                    DataColumn(label: Text('Vốn hóa\n(tỷ)', style: AppTextStyle.s12B), numeric: true, onSort: _onSort),
                  ],
                  rows: sorted.map((c) {
                    return DataRow(
                      color: WidgetStateProperty.resolveWith<Color?>(
                        (states) => c.isTarget
                            ? AppColors.gainBg.withValues(alpha: 0.5)
                            : null,
                      ),
                      cells: [
                        DataCell(Text(
                          c.symbol,
                          style: (c.isTarget ? AppTextStyle.s12B : AppTextStyle.s12M)
                              .copyWith(color: c.isTarget ? AppColors.gain : null),
                        )),
                        DataCell(Text(c.pe.toStringAsFixed(1), style: AppTextStyle.s12R)),
                        DataCell(Text(c.pb.toStringAsFixed(1), style: AppTextStyle.s12R)),
                        DataCell(Text('${c.roe.toStringAsFixed(1)}%', style: AppTextStyle.s12R)),
                        DataCell(Text('${c.roa.toStringAsFixed(1)}%', style: AppTextStyle.s12R)),
                        DataCell(Text(c.debtToEquity.toStringAsFixed(2), style: AppTextStyle.s12R)),
                        DataCell(Text(c.marketCap.toStringAsFixed(0), style: AppTextStyle.s12R)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Lỗi: $e')),
        ),
      ),
    );
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  double _getValue(IndustryComparison c, int col) {
    switch (col) {
      case 1: return c.pe;
      case 2: return c.pb;
      case 3: return c.roe;
      case 4: return c.roa;
      case 5: return c.debtToEquity;
      case 6: return c.marketCap;
      default: return 0;
    }
  }
}
