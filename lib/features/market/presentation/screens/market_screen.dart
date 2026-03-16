import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/stock_list_tile.dart';
import '../providers/market_providers.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thị trường'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Top tăng'),
            Tab(text: 'Top giảm'),
            Tab(text: 'Top KL'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StockList(provider: topGainersProvider),
          _StockList(provider: topLosersProvider),
          _StockList(provider: topVolumeProvider),
        ],
      ),
    );
  }
}

class _StockList extends ConsumerWidget {
  final FutureProvider<List> provider;

  const _StockList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocks = ref.watch(provider);

    return stocks.when(
      data: (data) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(provider),
        child: ListView.separated(
          itemCount: data.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final s = data[index];
            return StockListTile(
              symbol: s.symbol,
              price: s.price,
              change: s.change,
              changePercent: s.changePercent,
              volume: s.volume,
              ceiling: s.ceiling,
              floor: s.floor,
              refPrice: s.refPrice,
              onTap: () => context.push('/stock/${s.symbol}'),
            );
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Lỗi: $e')),
    );
  }
}
