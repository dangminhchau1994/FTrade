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
    final aiGroups = groups.where((g) => g.isAiGenerated).toList();
    final userGroups = groups.where((g) => !g.isAiGenerated).toList();
    final hasContent = groups.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(context, ref),
          ),
        ],
      ),
      body: !hasContent
          ? _EmptyState(onAdd: () => _showCreateGroupDialog(context, ref))
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(watchlistGroupsProvider);
              },
              child: CustomScrollView(
                slivers: [
                  // ── AI Watchlist Groups ──
                  if (aiGroups.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _SectionHeader(
                        icon: Icons.auto_awesome,
                        title: 'Watchlist AI (${aiGroups.length})',
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _GroupCard(group: aiGroups[i]),
                        childCount: aiGroups.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ],

                  // ── User Watchlist Groups ──
                  if (userGroups.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _SectionHeader(
                        icon: Icons.person_outline,
                        title: 'Watchlist được tạo bởi bạn (${userGroups.length})',
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => _GroupCard(group: userGroups[i]),
                        childCount: userGroups.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ],
              ),
            ),
    );
  }

  Future<void> _showCreateGroupDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tạo Watchlist mới'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tên watchlist...',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;

    final now = DateTime.now();
    final group = WatchlistGroup(
      id: 'user_${now.millisecondsSinceEpoch}',
      name: name,
      symbols: const [],
      createdAt: now,
      isAiGenerated: false,
    );
    await ref.read(watchlistGroupsProvider.notifier).addGroup(group);

    // Navigate to search so user can immediately add stocks
    if (context.mounted) {
      context.push('/search', extra: group.id);
    }
  }
}

// ── Section Header ──────────────────────────────────────────────────────────

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
        Text(title, style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600,
            color: color, letterSpacing: 0.5)),
      ]),
    );
  }
}

// ── Group Card (AI + User) ──────────────────────────────────────────────────

class _GroupCard extends ConsumerStatefulWidget {
  final WatchlistGroup group;
  const _GroupCard({required this.group});

  @override
  ConsumerState<_GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends ConsumerState<_GroupCard> {
  bool _expanded = true;

  Color get _accentColor =>
      widget.group.isAiGenerated ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6);

  IconData get _headerIcon =>
      widget.group.isAiGenerated ? Icons.auto_awesome : Icons.star_outline;

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
        border: Border.all(color: _accentColor.withValues(alpha: 0.4)),
      ),
      child: Column(children: [
        // Header
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            child: Row(children: [
              Icon(_headerIcon, size: 14, color: _accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(group.name, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  Text(
                    group.symbols.isEmpty
                        ? 'Chưa có mã nào'
                        : '${group.symbols.length} mã${group.briefDate != null ? " · ${group.briefDate}" : ""}',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ]),
              ),
              // Add stocks button (user groups only)
              if (!group.isAiGenerated)
                IconButton(
                  icon: Icon(Icons.add, size: 18, color: _accentColor),
                  onPressed: () => context.push('/search', extra: group.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Thêm mã',
                ),
              const SizedBox(width: 8),
              // Delete group
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                onPressed: () => _confirmDelete(context),
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

        // Stocks list
        if (_expanded) ...[
          const Divider(height: 1),
          if (group.symbols.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(children: [
                Icon(Icons.add_circle_outline, size: 28, color: _accentColor.withValues(alpha: 0.5)),
                const SizedBox(height: 8),
                Text('Nhấn + để thêm mã cổ phiếu',
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
              ]),
            )
          else
            ref.watch(groupStocksProvider(group.id)).when(
              data: (stocks) {
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
                      onDismissed: (_) => ref
                          .read(watchlistGroupsProvider.notifier)
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text('Không tải được dữ liệu',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
              ),
            ),
        ],
      ]),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá watchlist?'),
        content: Text('Xoá "${widget.group.name}" sẽ không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(watchlistGroupsProvider.notifier).removeGroup(widget.group.id);
    }
  }
}

// ── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.star_outline, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        const Text('Chưa có watchlist nào',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 8),
        const Text('AI sẽ tự tạo nhóm từ bản tin sáng',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Tạo watchlist'),
        ),
      ]),
    );
  }
}
