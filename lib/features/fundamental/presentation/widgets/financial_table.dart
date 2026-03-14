import 'package:flutter/material.dart';

import '../../domain/entities/financial_statement.dart';

class FinancialTable extends StatelessWidget {
  final List<FinancialStatement> statements;

  const FinancialTable({super.key, required this.statements});

  String _formatValue(double value) {
    final abs = value.abs();
    final prefix = value < 0 ? '-' : '';
    if (abs >= 1e12) return '$prefix${(abs / 1e12).toStringAsFixed(1)}T tỷ';
    if (abs >= 1e9) return '$prefix${(abs / 1e9).toStringAsFixed(1)} tỷ';
    if (abs >= 1e6) return '$prefix${(abs / 1e6).toStringAsFixed(1)} tr';
    return '$prefix${abs.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    if (statements.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    final lineItems = statements.first.items.keys.toList();
    final periods = statements.map((s) => s.period).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          headingRowHeight: 40,
          dataRowMinHeight: 36,
          dataRowMaxHeight: 36,
          columns: [
            const DataColumn(
              label: Text(
                'Chỉ tiêu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            ...periods.map(
              (p) => DataColumn(
                label: Text(
                  p,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                numeric: true,
              ),
            ),
          ],
          rows: lineItems.asMap().entries.map((entry) {
            final item = entry.value;
            final isEven = entry.key % 2 == 0;

            return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (states) => isEven
                    ? Colors.grey.withValues(alpha: 0.05)
                    : null,
              ),
              cells: [
                DataCell(
                  SizedBox(
                    width: 160,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ...statements.map((s) {
                  final value = s.items[item] ?? 0;
                  return DataCell(
                    Text(
                      _formatValue(value),
                      style: TextStyle(
                        fontSize: 12,
                        color: value < 0 ? Colors.red[400] : null,
                      ),
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
