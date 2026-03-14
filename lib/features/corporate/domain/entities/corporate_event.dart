import 'package:freezed_annotation/freezed_annotation.dart';

part 'corporate_event.freezed.dart';
part 'corporate_event.g.dart';

enum CorporateEventType {
  earnings,
  agm,
  rightsIssue,
  dividend,
  other,
}

@freezed
class CorporateEvent with _$CorporateEvent {
  const factory CorporateEvent({
    required String id,
    required String symbol,
    required String title,
    required CorporateEventType type,
    required DateTime eventDate,
    String? description,
  }) = _CorporateEvent;

  factory CorporateEvent.fromJson(Map<String, dynamic> json) =>
      _$CorporateEventFromJson(json);
}
