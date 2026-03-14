import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/market_index.dart';
import '../entities/stock.dart';
import '../entities/stock_detail.dart';

abstract class MarketRepository {
  Future<Either<Failure, List<MarketIndex>>> getMarketIndices();
  Future<Either<Failure, List<Stock>>> getTopGainers();
  Future<Either<Failure, List<Stock>>> getTopLosers();
  Future<Either<Failure, List<Stock>>> getTopVolume();
  Future<Either<Failure, StockDetail>> getStockDetail(String symbol);
  Future<Either<Failure, List<Stock>>> searchStocks(String query);
}
