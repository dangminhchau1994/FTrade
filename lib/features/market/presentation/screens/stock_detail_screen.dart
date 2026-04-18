import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/realtime_market_data.dart';
import '../../../watchlist/presentation/providers/price_alert_providers.dart';
import '../../../watchlist/presentation/providers/watchlist_providers.dart';
import '../../../watchlist/presentation/widgets/add_alert_dialog.dart';
import '../providers/market_data_controller.dart';
import '../providers/market_providers.dart';
import '../widgets/stock_chart.dart';

class StockDetailScreen extends ConsumerWidget {
  final String symbol;

  const StockDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(stockDetailProvider(symbol));
    final realtime = ref.watch(realtimeStockProvider(symbol));
    final watchlist = ref.watch(watchlistSymbolsProvider);
    final isInWatchlist = watchlist.contains(symbol);

    return Scaffold(
      appBar: AppBar(
        title: Text(symbol),
        actions: [
          IconButton(
            icon: Icon(
              isInWatchlist ? Icons.star : Icons.star_outline,
              color: isInWatchlist ? AppColors.ref : null,
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
            onPressed: () {
              detail.whenData((stock) {
                final text = '$symbol - ${stock.companyName}\n'
                    'Giá: ${FormatUtils.price(stock.price)} '
                    '(${FormatUtils.change(stock.change)} / ${FormatUtils.percent(stock.changePercent)})\n'
                    'KL: ${FormatUtils.volume(stock.volume)}';
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã copy thông tin cổ phiếu')),
                );
              });
            },
          ),
        ],
      ),
      body: detail.when(
        data: (stock) {
          // Overlay realtime data lên REST data
          final rt = realtime;
          final hasRt = rt != null && rt.matchedPrice > 0;

          final displayPrice = hasRt ? rt.matchedPrice : stock.price;
          final displayChange = hasRt ? rt.change : stock.change;
          final displayChangePct = hasRt ? rt.changePercent : stock.changePercent;
          final displayHigh = hasRt && rt.high > 0 ? rt.high : stock.high;
          final displayLow = hasRt && rt.low > 0 ? rt.low : stock.low;
          final displayOpen = hasRt && rt.open > 0 ? rt.open : stock.open;
          final displayVolume = hasRt && rt.totalVolume > 0 ? rt.totalVolume : stock.volume;
          final displayCeiling = hasRt && rt.ceiling > 0 ? rt.ceiling : stock.ceiling;
          final displayFloor = hasRt && rt.floor > 0 ? rt.floor : stock.floor;
          final displayRef = hasRt && rt.refPrice > 0 ? rt.refPrice : stock.refPrice;
          final displayForeignBuy = hasRt ? rt.foreignBuyVolume : (stock.foreignBuy?.toInt() ?? 0);
          final displayForeignSell = hasRt ? rt.foreignSellVolume : (stock.foreignSell?.toInt() ?? 0);
          final displayUpdatedAt = hasRt ? rt.updatedAt : stock.updatedAt;

          final color = AppTheme.stockColor(
            price: displayPrice,
            ceiling: displayCeiling,
            floor: displayFloor,
            refPrice: displayRef,
          );

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
                      style: AppTextStyle.b14R.copyWith(color: AppColors.base40),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          FormatUtils.price(displayPrice),
                          style: AppTextStyle.indexValue.copyWith(color: color),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            FormatUtils.changeWithPercent(displayChange, displayChangePct),
                            style: AppTextStyle.b16S.copyWith(color: color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${stock.exchange} • ${FormatUtils.dateTime(displayUpdatedAt ?? DateTime.now())}',
                          style: AppTextStyle.s12R.copyWith(color: AppColors.base50),
                        ),
                        if (hasRt) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gain,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Live',
                            style: AppTextStyle.c10M.copyWith(
                              color: AppColors.gainLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Bid/Ask table (chỉ hiện khi có realtime)
              if (hasRt) _BidAskTable(data: rt),

              // Chart with period selector
              StockChart(symbol: symbol),

              const SizedBox(height: 8),

              // Price Range Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PriceRangeBar(
                  floor: displayFloor,
                  ref: displayRef,
                  ceiling: displayCeiling,
                  current: displayPrice,
                ),
              ),

              const SizedBox(height: 16),

              // Trading Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _InfoGrid(items: [
                  _InfoItem('Mở cửa', FormatUtils.price(displayOpen)),
                  _InfoItem('Cao nhất', FormatUtils.price(displayHigh)),
                  _InfoItem('Thấp nhất', FormatUtils.price(displayLow)),
                  _InfoItem('TC', FormatUtils.price(displayRef)),
                  _InfoItem('Trần', FormatUtils.price(displayCeiling)),
                  _InfoItem('Sàn', FormatUtils.price(displayFloor)),
                  _InfoItem('KL GD', FormatUtils.volume(displayVolume)),
                  _InfoItem(
                    'NN Mua',
                    FormatUtils.volume(displayForeignBuy),
                  ),
                  _InfoItem(
                    'NN Bán',
                    FormatUtils.volume(displayForeignSell),
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
                    Text('Chỉ số cơ bản', style: AppTextStyle.b16B),
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
                    Text('Phân tích cơ bản', style: AppTextStyle.b16B),
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.compare_arrows, size: 18),
                            label: const Text('So sánh'),
                            onPressed: () =>
                                context.push('/comparison/$symbol'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.analytics, size: 18),
                            label: const Text('FA'),
                            onPressed: () => context.push('/fa/$symbol'),
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
              Text('Cảnh báo giá', style: AppTextStyle.b16B),
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
              style: AppTextStyle.s12R.copyWith(color: AppColors.base50),
            )
          else
            ...symbolAlerts.map(
              (entry) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  entry.value.isAbove
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: entry.value.isAbove ? AppColors.gain : AppColors.loss,
                ),
                title: Text(
                  '${entry.value.isAbove ? "Vượt" : "Dưới"} ${FormatUtils.price(entry.value.targetPrice)}',
                  style: AppTextStyle.b14R,
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
                    AppColors.floor,
                    AppColors.ref,
                    AppColors.ceiling,
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
                  color: AppColors.white,
                  border: Border.all(color: AppColors.base40, width: 2),
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
              style: AppTextStyle.c10R.copyWith(color: AppColors.floor),
            ),
            Text(
              FormatUtils.price(ref),
              style: AppTextStyle.c10R.copyWith(color: AppColors.ref),
            ),
            Text(
              FormatUtils.price(ceiling),
              style: AppTextStyle.c10R.copyWith(color: AppColors.ceiling),
            ),
          ],
        ),
      ],
    );
  }
}

class _BidAskTable extends StatelessWidget {
  final RealtimeMarketData data;

  const _BidAskTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Bid (Mua)
          Expanded(
            child: Column(
              children: [
                _bidAskHeader('MUA', AppColors.gain),
                _bidAskRow(data.bid1Price, data.bid1Volume, AppColors.gain),
                _bidAskRow(data.bid2Price, data.bid2Volume, AppColors.gain),
                _bidAskRow(data.bid3Price, data.bid3Volume, AppColors.gain),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Ask (Bán)
          Expanded(
            child: Column(
              children: [
                _bidAskHeader('BÁN', AppColors.loss),
                _bidAskRow(data.ask1Price, data.ask1Volume, AppColors.loss),
                _bidAskRow(data.ask2Price, data.ask2Volume, AppColors.loss),
                _bidAskRow(data.ask3Price, data.ask3Volume, AppColors.loss),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bidAskHeader(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: AppTextStyle.s12B.copyWith(color: color),
      ),
    );
  }

  Widget _bidAskRow(double price, int volume, Color color) {
    if (price <= 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            FormatUtils.price(price),
            style: AppTextStyle.s12M.copyWith(color: color),
          ),
          Text(
            FormatUtils.volume(volume),
            style: AppTextStyle.s12R.copyWith(color: AppColors.base40),
          ),
        ],
      ),
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
                      style: AppTextStyle.s12R.copyWith(color: AppColors.base50),
                    ),
                    const SizedBox(height: 4),
                    Text(item.value, style: AppTextStyle.b14S),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
