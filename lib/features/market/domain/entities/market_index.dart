import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_index.freezed.dart';
part 'market_index.g.dart';

@freezed
class MarketIndex with _$MarketIndex {
  const factory MarketIndex({
    required String name,
    required double value,
    required double change,
    required double changePercent,
    required int totalVolume,
    required int advances,
    required int declines,
    required int unchanged,
    DateTime? updatedAt,
  }) = _MarketIndex;

  factory MarketIndex.fromJson(Map<String, dynamic> json) =>
      _$MarketIndexFromJson(json);
}
