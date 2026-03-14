import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/dividend.dart';
import '../providers/corporate_providers.dart';

class DividendList extends ConsumerWidget {
  const DividendList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dividends = ref.watch(dividendsProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dividendsProvider),
      child: dividends.when(
        data: (data) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: data.length,
          itemBuilder: (context, index) => _DividendCard(dividend: data[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _DividendCard extends StatelessWidget {
  final Dividend dividend;

  const _DividendCard({required this.dividend});

  @override
  Widget build(BuildContext context) {
    final hasCash = dividend.cashAmount > 0;
    final hasStock = dividend.ratio > 0;
    final accentColor = hasCash ? Colors.green[400]! : Colors.blue[400]!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    dividend.symbol,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                if (hasCash)
                  Chip(
                    label: Text(
                      '${FormatUtils.price(dividend.cashAmount)} đ/CP',
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                    visualDensity: VisualDensity.compact,
                  ),
                if (hasStock) ...[
                  const SizedBox(width: 4),
                  Chip(
                    label: Text(
                      '${dividend.ratio.toStringAsFixed(0)}% CP',
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow('GDKHQ', FormatUtils.date(dividend.exDate)),
            _InfoRow('Ngày thanh toán', FormatUtils.date(dividend.paymentDate)),
            if (dividend.note != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  dividend.note!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
