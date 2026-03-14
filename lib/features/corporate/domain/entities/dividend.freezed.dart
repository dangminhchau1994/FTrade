// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dividend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Dividend _$DividendFromJson(Map<String, dynamic> json) {
  return _Dividend.fromJson(json);
}

/// @nodoc
mixin _$Dividend {
  String get symbol => throw _privateConstructorUsedError;
  DateTime get exDate => throw _privateConstructorUsedError;
  DateTime get recordDate => throw _privateConstructorUsedError;
  DateTime get paymentDate => throw _privateConstructorUsedError;
  double get ratio => throw _privateConstructorUsedError;
  double get cashAmount => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this Dividend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dividend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DividendCopyWith<Dividend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DividendCopyWith<$Res> {
  factory $DividendCopyWith(Dividend value, $Res Function(Dividend) then) =
      _$DividendCopyWithImpl<$Res, Dividend>;
  @useResult
  $Res call({
    String symbol,
    DateTime exDate,
    DateTime recordDate,
    DateTime paymentDate,
    double ratio,
    double cashAmount,
    String? note,
  });
}

/// @nodoc
class _$DividendCopyWithImpl<$Res, $Val extends Dividend>
    implements $DividendCopyWith<$Res> {
  _$DividendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dividend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? exDate = null,
    Object? recordDate = null,
    Object? paymentDate = null,
    Object? ratio = null,
    Object? cashAmount = null,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            exDate:
                null == exDate
                    ? _value.exDate
                    : exDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            recordDate:
                null == recordDate
                    ? _value.recordDate
                    : recordDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            paymentDate:
                null == paymentDate
                    ? _value.paymentDate
                    : paymentDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            ratio:
                null == ratio
                    ? _value.ratio
                    : ratio // ignore: cast_nullable_to_non_nullable
                        as double,
            cashAmount:
                null == cashAmount
                    ? _value.cashAmount
                    : cashAmount // ignore: cast_nullable_to_non_nullable
                        as double,
            note:
                freezed == note
                    ? _value.note
                    : note // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DividendImplCopyWith<$Res>
    implements $DividendCopyWith<$Res> {
  factory _$$DividendImplCopyWith(
    _$DividendImpl value,
    $Res Function(_$DividendImpl) then,
  ) = __$$DividendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symbol,
    DateTime exDate,
    DateTime recordDate,
    DateTime paymentDate,
    double ratio,
    double cashAmount,
    String? note,
  });
}

/// @nodoc
class __$$DividendImplCopyWithImpl<$Res>
    extends _$DividendCopyWithImpl<$Res, _$DividendImpl>
    implements _$$DividendImplCopyWith<$Res> {
  __$$DividendImplCopyWithImpl(
    _$DividendImpl _value,
    $Res Function(_$DividendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Dividend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? exDate = null,
    Object? recordDate = null,
    Object? paymentDate = null,
    Object? ratio = null,
    Object? cashAmount = null,
    Object? note = freezed,
  }) {
    return _then(
      _$DividendImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        exDate:
            null == exDate
                ? _value.exDate
                : exDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        recordDate:
            null == recordDate
                ? _value.recordDate
                : recordDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        paymentDate:
            null == paymentDate
                ? _value.paymentDate
                : paymentDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        ratio:
            null == ratio
                ? _value.ratio
                : ratio // ignore: cast_nullable_to_non_nullable
                    as double,
        cashAmount:
            null == cashAmount
                ? _value.cashAmount
                : cashAmount // ignore: cast_nullable_to_non_nullable
                    as double,
        note:
            freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DividendImpl implements _Dividend {
  const _$DividendImpl({
    required this.symbol,
    required this.exDate,
    required this.recordDate,
    required this.paymentDate,
    required this.ratio,
    required this.cashAmount,
    this.note,
  });

  factory _$DividendImpl.fromJson(Map<String, dynamic> json) =>
      _$$DividendImplFromJson(json);

  @override
  final String symbol;
  @override
  final DateTime exDate;
  @override
  final DateTime recordDate;
  @override
  final DateTime paymentDate;
  @override
  final double ratio;
  @override
  final double cashAmount;
  @override
  final String? note;

  @override
  String toString() {
    return 'Dividend(symbol: $symbol, exDate: $exDate, recordDate: $recordDate, paymentDate: $paymentDate, ratio: $ratio, cashAmount: $cashAmount, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DividendImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.exDate, exDate) || other.exDate == exDate) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.ratio, ratio) || other.ratio == ratio) &&
            (identical(other.cashAmount, cashAmount) ||
                other.cashAmount == cashAmount) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    symbol,
    exDate,
    recordDate,
    paymentDate,
    ratio,
    cashAmount,
    note,
  );

  /// Create a copy of Dividend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DividendImplCopyWith<_$DividendImpl> get copyWith =>
      __$$DividendImplCopyWithImpl<_$DividendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DividendImplToJson(this);
  }
}

abstract class _Dividend implements Dividend {
  const factory _Dividend({
    required final String symbol,
    required final DateTime exDate,
    required final DateTime recordDate,
    required final DateTime paymentDate,
    required final double ratio,
    required final double cashAmount,
    final String? note,
  }) = _$DividendImpl;

  factory _Dividend.fromJson(Map<String, dynamic> json) =
      _$DividendImpl.fromJson;

  @override
  String get symbol;
  @override
  DateTime get exDate;
  @override
  DateTime get recordDate;
  @override
  DateTime get paymentDate;
  @override
  double get ratio;
  @override
  double get cashAmount;
  @override
  String? get note;

  /// Create a copy of Dividend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DividendImplCopyWith<_$DividendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
