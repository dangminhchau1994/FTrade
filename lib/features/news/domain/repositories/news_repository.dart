import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/news_article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsArticle>>> getLatestNews({int page = 1});
  Future<Either<Failure, List<NewsArticle>>> getNewsBySymbol(String symbol);
  Future<Either<Failure, NewsArticle>> getNewsDetail(String id);
}
