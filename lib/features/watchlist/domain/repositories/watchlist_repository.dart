import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/watchlist_item.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<WatchlistItem>>> getWatchlist();
  Future<Either<Failure, void>> addToWatchlist(String symbol);
  Future<Either<Failure, void>> removeFromWatchlist(String symbol);
  Future<bool> isInWatchlist(String symbol);
}
