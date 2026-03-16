import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/format_utils.dart';
import '../providers/news_providers.dart';
import '../../domain/entities/news_article.dart';

final _newsFilterProvider = StateProvider<String?>((ref) => null);

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(latestNewsProvider);
    final filter = ref.watch(_newsFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(filter != null ? 'Tin tức - $filter' : 'Tin tức'),
        actions: [
          if (filter != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => ref.read(_newsFilterProvider.notifier).state = null,
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, ref, news),
          ),
        ],
      ),
      body: news.when(
        data: (articles) {
          final filtered = filter != null
              ? articles.where((a) =>
                  a.relatedSymbols?.contains(filter) ?? false).toList()
              : articles;

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.article_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    filter != null
                        ? 'Không có tin tức cho $filter'
                        : 'Không có tin tức',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(latestNewsProvider),
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final article = filtered[index];
                return InkWell(
                  onTap: () => context.push('/news/${article.id}'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (article.summary != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          article.summary!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            article.source,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            FormatUtils.timeAgo(article.publishedAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          if (article.relatedSymbols != null &&
                              article.relatedSymbols!.isNotEmpty)
                            ...article.relatedSymbols!.take(3).map(
                                  (symbol) => Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      symbol,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }

  void _showFilterDialog(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<NewsArticle>> news,
  ) {
    final symbols = <String>{};
    news.whenData((articles) {
      for (final a in articles) {
        if (a.relatedSymbols != null) symbols.addAll(a.relatedSymbols!);
      }
    });

    if (symbols.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có mã CP nào trong tin tức')),
      );
      return;
    }

    final sorted = symbols.toList()..sort();
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Lọc theo mã CP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: sorted
                    .map((s) => ListTile(
                          title: Text(s),
                          onTap: () {
                            ref.read(_newsFilterProvider.notifier).state = s;
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
