// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corporate_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CorporateEventImpl _$$CorporateEventImplFromJson(Map<String, dynamic> json) =>
    _$CorporateEventImpl(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$CorporateEventTypeEnumMap, json['type']),
      eventDate: DateTime.parse(json['eventDate'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$CorporateEventImplToJson(
  _$CorporateEventImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'title': instance.title,
  'type': _$CorporateEventTypeEnumMap[instance.type]!,
  'eventDate': instance.eventDate.toIso8601String(),
  'description': instance.description,
};

const _$CorporateEventTypeEnumMap = {
  CorporateEventType.earnings: 'earnings',
  CorporateEventType.agm: 'agm',
  CorporateEventType.rightsIssue: 'rightsIssue',
  CorporateEventType.dividend: 'dividend',
  CorporateEventType.other: 'other',
};
