import 'package:freezed_annotation/freezed_annotation.dart';

part 'industry_comparison.freezed.dart';
part 'industry_comparison.g.dart';

@freezed
class IndustryComparison with _$IndustryComparison {
  const factory IndustryComparison({
    required String symbol,
    required String companyName,
    required String industry,
    required double pe,
    required double pb,
    required double roe,
    required double roa,
    required double debtToEquity,
    required double marketCap,
    required bool isTarget,
  }) = _IndustryComparison;

  factory IndustryComparison.fromJson(Map<String, dynamic> json) =>
      _$IndustryComparisonFromJson(json);
}
