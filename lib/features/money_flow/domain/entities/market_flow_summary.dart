import 'package:freezed_annotation/freezed_annotation.dart';

import 'foreign_flow.dart';

part 'market_flow_summary.freezed.dart';
part 'market_flow_summary.g.dart';

@freezed
class MarketFlowSummary with _$MarketFlowSummary {
  const factory MarketFlowSummary({
    required double totalForeignBuy,
    required double totalForeignSell,
    required double totalForeignNet,
    required List<ForeignFlow> topNetBuyers,
    required List<ForeignFlow> topNetSellers,
    required DateTime date,
  }) = _MarketFlowSummary;

  factory MarketFlowSummary.fromJson(Map<String, dynamic> json) =>
      _$MarketFlowSummaryFromJson(json);
}
