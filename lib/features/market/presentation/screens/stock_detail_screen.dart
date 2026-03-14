import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../watchlist/presentation/providers/price_alert_providers.dart';
import '../../../watchlist/presentation/providers/watchlist_providers.dart';
import '../../../watchlist/presentation/widgets/add_alert_dialog.dart';
import '../providers/market_providers.dart';
import '../widgets/stock_chart.dart';

class StockDetailScreen extends ConsumerWidget {
  final String symbol;

  const StockDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(stockDetailProvider(symbol));
    final watchlist = ref.watch(watchlistSymbolsProvider);
    final isInWatchlist = watchlist.contains(symbol);

    return Scaffold(
      appBar: AppBar(
        title: Text(symbol),
        actions: [
          IconButton(
            icon: Icon(
              isInWatchlist ? Icons.star : Icons.star_outline,
              color: isInWatchlist ? Colors.amber : null,
            ),
            onPressed: () {
              final notifier = ref.read(watchlistSymbolsProvider.notifier);
              if (isInWatchlist) {
                notifier.remove(symbol);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xóa $symbol khỏi watchlist')),
                );
              } else {
                notifier.add(symbol);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm $symbol vào watchlist')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: detail.when(
        data: (stock) {
          final isUp = stock.change >= 0;
          final color = isUp ? AppTheme.gainColor : AppTheme.lossColor;

          return ListView(
            children: [
              // Header: Price
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.companyName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          FormatUtils.price(stock.price),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${FormatUtils.change(stock.change)} (${FormatUtils.percent(stock.changePercent)})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stock.exchange} • ${FormatUtils.dateTime(stock.updatedAt ?? DateTime.now())}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              // Chart with period selector
              StockChart(symbol: symbol),

              const SizedBox(height: 8),

              // Price Range Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PriceRangeBar(
                  floor: stock.floor,
                  ref: stock.refPrice,
                  ceiling: stock.ceiling,
                  current: stock.price,
                ),
              ),

              const SizedBox(height: 16),

              // Trading Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _InfoGrid(items: [
                  _InfoItem('Mở cửa', FormatUtils.price(stock.open)),
                  _InfoItem('Cao nhất', FormatUtils.price(stock.high)),
                  _InfoItem('Thấp nhất', FormatUtils.price(stock.low)),
                  _InfoItem('TC', FormatUtils.price(stock.refPrice)),
                  _InfoItem('Trần', FormatUtils.price(stock.ceiling)),
                  _InfoItem('Sàn', FormatUtils.price(stock.floor)),
                  _InfoItem('KL GD', FormatUtils.volume(stock.volume)),
                  _InfoItem(
                    'NN Mua',
                    FormatUtils.volume(stock.foreignBuy?.toInt() ?? 0),
                  ),
                  _InfoItem(
                    'NN Bán',
                    FormatUtils.volume(stock.foreignSell?.toInt() ?? 0),
                  ),
                ]),
              ),

              const SizedBox(height: 16),
              const Divider(),

              // Fundamentals
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chỉ số cơ bản',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoGrid(items: [
                      _InfoItem('P/E', stock.pe?.toStringAsFixed(1) ?? '-'),
                      _InfoItem('P/B', stock.pb?.toStringAsFixed(1) ?? '-'),
                      _InfoItem(
                        'EPS',
                        stock.eps != null
                            ? FormatUtils.price(stock.eps!)
                            : '-',
                      ),
                      _InfoItem(
                        'Vốn hóa',
                        stock.marketCap != null
                            ? FormatUtils.marketCap(stock.marketCap!)
                            : '-',
                      ),
                    ]),
                  ],
                ),
              ),

              const Divider(),

              // Fundamental Analysis shortcuts
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phân tích cơ bản',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.table_chart, size: 18),
                            label: const Text('BCTC'),
                            onPressed: () =>
                                context.push('/financials/$symbol'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.compare_arrows, size: 18),
                            label: const Text('So sánh ngành'),
                            onPressed: () =>
                                context.push('/comparison/$symbol'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Price Alerts
              _AlertsSection(symbol: symbol, currentPrice: stock.price),

              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}

class _AlertsSection extends ConsumerWidget {
  final String symbol;
  final double currentPrice;

  const _AlertsSection({required this.symbol, required this.currentPrice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(priceAlertsProvider);
    final symbolAlerts = alerts
        .asMap()
        .entries
        .where((e) => e.value.symbol == symbol)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cảnh báo giá',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_alert, size: 22),
                onPressed: () async {
                  final alert = await showDialog<PriceAlert>(
                    context: context,
                    builder: (_) => AddAlertDialog(
                      symbol: symbol,
                      currentPrice: currentPrice,
                    ),
                  );
                  if (alert != null) {
                    ref.read(priceAlertsProvider.notifier).add(alert);
                  }
                },
              ),
            ],
          ),
          if (symbolAlerts.isEmpty)
            Text(
              'Chưa có cảnh báo nào',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            )
          else
            ...symbolAlerts.map(
              (entry) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  entry.value.isAbove
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color:
                      entry.value.isAbove ? AppTheme.gainColor : AppTheme.lossColor,
                ),
                title: Text(
                  '${entry.value.isAbove ? "Vượt" : "Dưới"} ${FormatUtils.price(entry.value.targetPrice)}',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: entry.value.enabled,
                      onChanged: (_) => ref
                          .read(priceAlertsProvider.notifier)
                          .toggle(entry.key),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => ref
                          .read(priceAlertsProvider.notifier)
                          .remove(entry.key),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceRangeBar extends StatelessWidget {
  final double floor;
  final double ref;
  final double ceiling;
  final double current;

  const _PriceRangeBar({
    required this.floor,
    required this.ref,
    required this.ceiling,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final range = ceiling - floor;
    final position = range > 0 ? (current - floor) / range : 0.5;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2196F3),
                    Color(0xFFFFEB3B),
                    Color(0xFFF44336),
                  ],
                ),
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width - 32) * position - 6,
              top: -3,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              FormatUtils.price(floor),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF2196F3),
              ),
            ),
            Text(
              FormatUtils.price(ref),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFFFEB3B),
              ),
            ),
            Text(
              FormatUtils.price(ceiling),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFF44336),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  _InfoItem(this.label, this.value);
}

class _InfoGrid extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: items
          .map(
            (item) => SizedBox(
              width: (MediaQuery.of(context).size.width - 32) / 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
