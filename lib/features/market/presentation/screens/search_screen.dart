import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/stock_list_tile.dart';
import '../providers/market_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

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

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tìm mã CK, tên công ty...',
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
        ],
      ),
      body: query.isEmpty
          ? _buildSuggestions()
          : results.when(
              data: (stocks) {
                if (stocks.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không tìm thấy kết quả',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: stocks.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s = stocks[index];
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
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Lỗi: $e')),
            ),
    );
  }

  Widget _buildSuggestions() {
    final popular = ['FPT', 'VNM', 'HPG', 'TCB', 'MWG', 'VIC', 'VHM', 'ACB'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tìm kiếm phổ biến',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popular
                .map(
                  (symbol) => ActionChip(
                    label: Text(symbol),
                    onPressed: () {
                      _controller.text = symbol;
                      ref.read(searchQueryProvider.notifier).state = symbol;
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
