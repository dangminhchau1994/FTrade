import 'package:freezed_annotation/freezed_annotation.dart';

part 'morning_brief.g.dart';
part 'morning_brief.freezed.dart';

enum SectorImpact { positive, negative, neutral }

@freezed
class StockMention with _$StockMention {
  const factory StockMention({
    required String symbol,
    required String reason,
  }) = _StockMention;

  factory StockMention.fromJson(Map<String, dynamic> json) =>
      _$StockMentionFromJson(json);
}

@freezed
class SectorAnalysis with _$SectorAnalysis {
  const factory SectorAnalysis({
    required String sectorId,
    required String sectorName,
    required SectorImpact impact,
    required String impactSummary,
    required String analysis,
    required List<StockMention> stocks,
    @Default('Thông tin mang tính tham khảo, không phải tư vấn đầu tư.')
    String disclaimer,
  }) = _SectorAnalysis;

  factory SectorAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SectorAnalysisFromJson(json);
}

@freezed
class MorningBrief with _$MorningBrief {
  const factory MorningBrief({
    required String date,
    required List<String> summary,
    required List<SectorAnalysis> sectors,
    required DateTime createdAt,
    @Default(false) bool isFallback,
    String? fallbackReason,
  }) = _MorningBrief;

  factory MorningBrief.fromJson(Map<String, dynamic> json) =>
      _$MorningBriefFromJson(json);
}
