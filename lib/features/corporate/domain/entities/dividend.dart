import 'package:freezed_annotation/freezed_annotation.dart';

part 'dividend.freezed.dart';
part 'dividend.g.dart';

@freezed
class Dividend with _$Dividend {
  const factory Dividend({
    required String symbol,
    required DateTime exDate,
    required DateTime recordDate,
    required DateTime paymentDate,
    required double ratio,
    required double cashAmount,
    String? note,
  }) = _Dividend;

  factory Dividend.fromJson(Map<String, dynamic> json) =>
      _$DividendFromJson(json);
}
