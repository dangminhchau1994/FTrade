import 'package:flutter_riverpod/flutter_riverpod.dart';

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
