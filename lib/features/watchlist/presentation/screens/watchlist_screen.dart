import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/stock_list_tile.dart';
import '../../../market/presentation/providers/market_providers.dart';
import '../../domain/entities/watchlist_group.dart';
import '../providers/watchlist_group_provider.dart';
import '../providers/watchlist_providers.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(watchlistGroupsProvider);
    final symbols = ref.watch(watchlistSymbolsProvider);
    final stocks = ref.watch(watchlistStocksProvider);
    final aiGroups = groups.where((g) => g.isAiGenerated).toList();
    final hasContent = aiGroups.isNotEmpty || symbols.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: !hasContent
          ? _EmptyState()
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(watchlistStocksProvider),
              child: CustomScrollView(
                slivers: [
                  // ── AI Watchlist Groups ──
                  if (aiGroups.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _SectionHeader(
                        icon: Icons.auto_awesome,
                        title: 'Watchlist AI',
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _AiGroupCard(group: aiGroups[i]),
                        childCount: aiGroups.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ],

                  // ── Manual Watchlist ──
                  if (symbols.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _SectionHeader(
                        icon: Icons.star_outline,
                        title: 'Theo dõi thủ công (${symbols.length})',
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    stocks.when(
                      data: (list) => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final s = list[index];
                            return Dismissible(
                              key: Key(s.symbol),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) {
                                ref.read(watchlistSymbolsProvider.notifier).remove(s.symbol);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Đã xóa ${s.symbol}'),
                                  action: SnackBarAction(
                                    label: 'Hoàn tác',
                                    onPressed: () => ref.read(watchlistSymbolsProvider.notifier).add(s.symbol),
                                  ),
                                ));
                              },
                              child: StockListTile(
                                symbol: s.symbol, price: s.price, change: s.change,
                                changePercent: s.changePercent, volume: s.volume,
                                ceiling: s.ceiling, floor: s.floor, refPrice: s.refPrice,
                                onTap: () => context.push('/stock/${s.symbol}'),
                              ),
                            );
                          },
                          childCount: list.length,
                        ),
                      ),
                      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                      error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Lỗi: $e'))),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const _SectionHeader({required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: color, letterSpacing: 0.5)),
      ]),
    );
  }
}

class _AiGroupCard extends ConsumerStatefulWidget {
  final WatchlistGroup group;
  const _AiGroupCard({required this.group});

  @override
  ConsumerState<_AiGroupCard> createState() => _AiGroupCardState();
}

class _AiGroupCardState extends ConsumerState<_AiGroupCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final group = widget.group;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
      ),
      child: Column(children: [
        // Header
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            child: Row(children: [
              const Icon(Icons.auto_awesome, size: 14, color: Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(group.name, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  Text('${group.symbols.length} mã · ${group.briefDate ?? ""}',
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ]),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: () => ref.read(watchlistGroupsProvider.notifier).removeGroup(group.id),
                color: cs.onSurfaceVariant,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18, color: cs.onSurfaceVariant),
            ]),
          ),
        ),
        // Stocks linear list
        if (_expanded) ...[
          const Divider(height: 1),
          ref.watch(groupStocksProvider(group.id)).when(
            data: (stocks) {
              if (stocks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8, runSpacing: 8,
                    children: group.symbols.map((s) => _GroupSymbolChip(symbol: s, groupId: group.id)).toList(),
                  ),
                );
              }
              final stockMap = {for (final s in stocks) s.symbol: s};
              return Column(
                children: group.symbols.map((symbol) {
                  final s = stockMap[symbol];
                  if (s == null) return const SizedBox.shrink();
                  final detail = ref.watch(stockDetailProvider(symbol)).valueOrNull;
                  return Dismissible(
                    key: Key('group_${group.id}_$symbol'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => ref.read(watchlistGroupsProvider.notifier)
                        .removeSymbolFromGroup(group.id, symbol),
                    child: StockListTile(
                      symbol: s.symbol,
                      price: s.price,
                      change: s.change,
                      changePercent: s.changePercent,
                      volume: s.volume,
                      ceiling: s.ceiling,
                      floor: s.floor,
                      refPrice: s.refPrice,
                      companyName: detail?.companyName,
                      onTap: () => context.push('/stock/$symbol'),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8, runSpacing: 8,
                children: group.symbols.map((s) => _GroupSymbolChip(symbol: s, groupId: group.id)).toList(),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

class _GroupSymbolChip extends ConsumerWidget {
  final String symbol;
  final String groupId;
  const _GroupSymbolChip({required this.symbol, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push('/stock/$symbol'),
      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.candlestick_chart_outlined),
              title: Text('Xem $symbol'),
              onTap: () { Navigator.pop(context); context.push('/stock/$symbol'); },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline, color: Colors.red),
              title: const Text('Xóa khỏi nhóm này'),
              onTap: () {
                Navigator.pop(context);
                ref.read(watchlistGroupsProvider.notifier).removeSymbolFromGroup(groupId, symbol);
              },
            ),
          ]),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Text(symbol, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.star_outline, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text('Chưa có watchlist nào', style: TextStyle(fontSize: 16, color: Colors.grey)),
        SizedBox(height: 8),
        Text('Bản tin AI sáng sẽ tự tạo watchlist theo ngành', style: TextStyle(fontSize: 13, color: Colors.grey)),
      ]),
    );
  }
}
