import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/stock_list_tile.dart';
import '../../../watchlist/presentation/providers/watchlist_group_provider.dart';
import '../providers/market_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  /// When non-null, tapping a stock adds it to this group instead of navigating.
  final String? groupId;
  const SearchScreen({super.key, this.groupId});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  bool get _isAddMode => widget.groupId != null;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  Future<void> _handleStockTap(String symbol) async {
    if (_isAddMode) {
      await ref.read(watchlistGroupsProvider.notifier)
          .addSymbolToGroup(widget.groupId!, symbol);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Đã thêm $symbol vào watchlist'),
          duration: const Duration(seconds: 2),
        ));
      }
    } else {
      context.push('/stock/$symbol');
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider(query));

    // Snapshot added symbols for visual feedback
    final groups = ref.watch(watchlistGroupsProvider);
    final addedSymbols = _isAddMode
        ? (groups.where((g) => g.id == widget.groupId).firstOrNull?.symbols ?? []).toSet()
        : <String>{};

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: _isAddMode
                ? 'Tìm mã để thêm vào watchlist...'
                : 'Tìm mã CK, tên công ty...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
          if (_isAddMode)
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Xong'),
            ),
        ],
      ),
      body: query.isEmpty
          ? _buildSuggestions(addedSymbols)
          : results.when(
              data: (stocks) {
                if (stocks.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy kết quả',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView.separated(
                  itemCount: stocks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s = stocks[index];
                    final isAdded = addedSymbols.contains(s.symbol);
                    return Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        StockListTile(
                          symbol: s.symbol,
                          price: s.price,
                          change: s.change,
                          changePercent: s.changePercent,
                          volume: s.volume,
                          ceiling: s.ceiling,
                          floor: s.floor,
                          refPrice: s.refPrice,
                          onTap: () => _handleStockTap(s.symbol),
                        ),
                        if (_isAddMode)
                          Positioned(
                            right: 12,
                            child: isAdded
                                ? const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 22)
                                : IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 22),
                                    color: const Color(0xFF3B82F6),
                                    onPressed: () => _handleStockTap(s.symbol),
                                  ),
                          ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Lỗi: $e')),
            ),
    );
  }

  Widget _buildSuggestions(Set<String> addedSymbols) {
    final popular = ['FPT', 'VNM', 'HPG', 'TCB', 'MWG', 'VIC', 'VHM', 'ACB'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tìm kiếm phổ biến',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popular.map((symbol) {
              final isAdded = addedSymbols.contains(symbol);
              return ActionChip(
                avatar: isAdded ? const Icon(Icons.check, size: 14, color: Color(0xFF22C55E)) : null,
                label: Text(symbol),
                onPressed: () {
                  if (_isAddMode) {
                    _handleStockTap(symbol);
                  } else {
                    _controller.text = symbol;
                    ref.read(searchQueryProvider.notifier).state = symbol;
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
