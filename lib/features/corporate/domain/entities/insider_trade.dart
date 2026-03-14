import 'package:freezed_annotation/freezed_annotation.dart';

part 'insider_trade.freezed.dart';
part 'insider_trade.g.dart';

enum TradeType { buy, sell }

@freezed
class InsiderTrade with _$InsiderTrade {
  const factory InsiderTrade({
    required String symbol,
    required String traderName,
    required String position,
    required TradeType tradeType,
    required int quantity,
    required double price,
    required DateTime tradeDate,
    required DateTime reportDate,
    required bool isProprietary,
  }) = _InsiderTrade;

  factory InsiderTrade.fromJson(Map<String, dynamic> json) =>
      _$InsiderTradeFromJson(json);
}
