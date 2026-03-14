import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/news_mock_datasource.dart';
import '../../domain/entities/news_article.dart';

final newsDatasourceProvider = Provider((ref) => NewsMockDatasource());

final latestNewsProvider = FutureProvider<List<NewsArticle>>((ref) {
  return ref.watch(newsDatasourceProvider).getLatestNews();
});

final newsBySymbolProvider =
    FutureProvider.family<List<NewsArticle>, String>((ref, symbol) {
  return ref.watch(newsDatasourceProvider).getNewsBySymbol(symbol);
});
