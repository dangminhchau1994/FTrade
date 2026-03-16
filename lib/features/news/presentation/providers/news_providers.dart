import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/news_api_datasource.dart';
import '../../domain/entities/news_article.dart';

final newsDioClientProvider = Provider<DioClient>((ref) => DioClient());

final newsDatasourceProvider = Provider<NewsApiDatasource>((ref) {
  final dio = ref.watch(newsDioClientProvider).dio;
  return NewsApiDatasource(dio);
});

final latestNewsProvider = FutureProvider<List<NewsArticle>>((ref) {
  return ref.watch(newsDatasourceProvider).getLatestNews();
});

final newsBySymbolProvider =
    FutureProvider.family<List<NewsArticle>, String>((ref, symbol) {
  return ref.watch(newsDatasourceProvider).getNewsBySymbol(symbol);
});

final newsDetailProvider =
    FutureProvider.family<NewsArticle, String>((ref, id) {
  return ref.watch(newsDatasourceProvider).getNewsDetail(id);
});

// Bookmark provider (lưu bài viết)
final bookmarkedNewsProvider =
    StateNotifierProvider<BookmarkedNewsNotifier, List<String>>((ref) {
  return BookmarkedNewsNotifier();
});

class BookmarkedNewsNotifier extends StateNotifier<List<String>> {
  static const _boxName = 'bookmarked_news';
  Box<String>? _box;

  BookmarkedNewsNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<String>(_boxName);
    state = _box!.values.toList();
  }

  void add(String articleId) {
    if (!state.contains(articleId)) {
      _box?.add(articleId);
      state = [...state, articleId];
    }
  }

  void remove(String articleId) {
    final key = _box?.keys.firstWhere(
      (k) => _box?.get(k) == articleId,
      orElse: () => null,
    );
    if (key != null) _box?.delete(key);
    state = state.where((id) => id != articleId).toList();
  }
}
