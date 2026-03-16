import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/stock_list_tile.dart';
import '../providers/watchlist_providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocks = ref.watch(watchlistStocksProvider);
    final symbols = ref.watch(watchlistSymbolsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist (${symbols.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: symbols.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có cổ phiếu nào',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nhấn + để thêm cổ phiếu theo dõi',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : stocks.when(
              data: (list) => RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(watchlistStocksProvider),
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s = list[index];
                    return Dismissible(
                      key: Key(s.symbol),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child:
                            const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(watchlistSymbolsProvider.notifier)
                            .remove(s.symbol);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Đã xóa ${s.symbol} khỏi watchlist'),
                            action: SnackBarAction(
                              label: 'Hoàn tác',
                              onPressed: () => ref
                                  .read(watchlistSymbolsProvider.notifier)
                                  .add(s.symbol),
                            ),
                          ),
                        );
                      },
                      child: StockListTile(
                        symbol: s.symbol,
                        price: s.price,
                        change: s.change,
                        changePercent: s.changePercent,
                        volume: s.volume,
                        ceiling: s.ceiling,
                        floor: s.floor,
                        refPrice: s.refPrice,
                        onTap: () => context.push('/stock/${s.symbol}'),
                      ),
                    );
                  },
                ),
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Lỗi: $e')),
            ),
    );
  }
}
