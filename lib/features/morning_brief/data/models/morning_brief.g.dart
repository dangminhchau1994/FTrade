// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'morning_brief.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockMentionImpl _$$StockMentionImplFromJson(Map<String, dynamic> json) =>
    _$StockMentionImpl(
      symbol: json['symbol'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$$StockMentionImplToJson(_$StockMentionImpl instance) =>
    <String, dynamic>{'symbol': instance.symbol, 'reason': instance.reason};

_$SectorAnalysisImpl _$$SectorAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$SectorAnalysisImpl(
      sectorId: json['sectorId'] as String,
      sectorName: json['sectorName'] as String,
      impact: $enumDecode(_$SectorImpactEnumMap, json['impact']),
      impactSummary: json['impactSummary'] as String,
      analysis: json['analysis'] as String,
      stocks:
          (json['stocks'] as List<dynamic>)
              .map((e) => StockMention.fromJson(e as Map<String, dynamic>))
              .toList(),
      disclaimer:
          json['disclaimer'] as String? ??
          'Thông tin mang tính tham khảo, không phải tư vấn đầu tư.',
    );

Map<String, dynamic> _$$SectorAnalysisImplToJson(
  _$SectorAnalysisImpl instance,
) => <String, dynamic>{
  'sectorId': instance.sectorId,
  'sectorName': instance.sectorName,
  'impact': _$SectorImpactEnumMap[instance.impact]!,
  'impactSummary': instance.impactSummary,
  'analysis': instance.analysis,
  'stocks': instance.stocks,
  'disclaimer': instance.disclaimer,
};

const _$SectorImpactEnumMap = {
  SectorImpact.positive: 'positive',
  SectorImpact.negative: 'negative',
  SectorImpact.neutral: 'neutral',
};

_$MorningBriefImpl _$$MorningBriefImplFromJson(Map<String, dynamic> json) =>
    _$MorningBriefImpl(
      date: json['date'] as String,
      summary:
          (json['summary'] as List<dynamic>).map((e) => e as String).toList(),
      sectors:
          (json['sectors'] as List<dynamic>)
              .map((e) => SectorAnalysis.fromJson(e as Map<String, dynamic>))
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFallback: json['isFallback'] as bool? ?? false,
      fallbackReason: json['fallbackReason'] as String?,
    );

Map<String, dynamic> _$$MorningBriefImplToJson(_$MorningBriefImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'summary': instance.summary,
      'sectors': instance.sectors,
      'createdAt': instance.createdAt.toIso8601String(),
      'isFallback': instance.isFallback,
      'fallbackReason': instance.fallbackReason,
    };
