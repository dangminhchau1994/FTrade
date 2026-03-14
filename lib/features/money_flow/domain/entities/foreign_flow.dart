import 'package:freezed_annotation/freezed_annotation.dart';

part 'foreign_flow.freezed.dart';
part 'foreign_flow.g.dart';

@freezed
class ForeignFlow with _$ForeignFlow {
  const factory ForeignFlow({
    required String symbol,
    required double buyVolume,
    required double sellVolume,
    required double netVolume,
    required double buyValue,
    required double sellValue,
    required double netValue,
    required DateTime date,
  }) = _ForeignFlow;

  factory ForeignFlow.fromJson(Map<String, dynamic> json) =>
      _$ForeignFlowFromJson(json);
}
