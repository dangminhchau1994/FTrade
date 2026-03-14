// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_statement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FinancialStatement _$FinancialStatementFromJson(Map<String, dynamic> json) {
  return _FinancialStatement.fromJson(json);
}

/// @nodoc
mixin _$FinancialStatement {
  String get symbol => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  StatementType get type => throw _privateConstructorUsedError;
  Map<String, double> get items => throw _privateConstructorUsedError;

  /// Serializes this FinancialStatement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialStatementCopyWith<FinancialStatement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialStatementCopyWith<$Res> {
  factory $FinancialStatementCopyWith(
    FinancialStatement value,
    $Res Function(FinancialStatement) then,
  ) = _$FinancialStatementCopyWithImpl<$Res, FinancialStatement>;
  @useResult
  $Res call({
    String symbol,
    String period,
    StatementType type,
    Map<String, double> items,
  });
}

/// @nodoc
class _$FinancialStatementCopyWithImpl<$Res, $Val extends FinancialStatement>
    implements $FinancialStatementCopyWith<$Res> {
  _$FinancialStatementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? period = null,
    Object? type = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            period:
                null == period
                    ? _value.period
                    : period // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as StatementType,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as Map<String, double>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialStatementImplCopyWith<$Res>
    implements $FinancialStatementCopyWith<$Res> {
  factory _$$FinancialStatementImplCopyWith(
    _$FinancialStatementImpl value,
    $Res Function(_$FinancialStatementImpl) then,
  ) = __$$FinancialStatementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symbol,
    String period,
    StatementType type,
    Map<String, double> items,
  });
}

/// @nodoc
class __$$FinancialStatementImplCopyWithImpl<$Res>
    extends _$FinancialStatementCopyWithImpl<$Res, _$FinancialStatementImpl>
    implements _$$FinancialStatementImplCopyWith<$Res> {
  __$$FinancialStatementImplCopyWithImpl(
    _$FinancialStatementImpl _value,
    $Res Function(_$FinancialStatementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialStatement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? period = null,
    Object? type = null,
    Object? items = null,
  }) {
    return _then(
      _$FinancialStatementImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        period:
            null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as StatementType,
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as Map<String, double>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialStatementImpl implements _FinancialStatement {
  const _$FinancialStatementImpl({
    required this.symbol,
    required this.period,
    required this.type,
    required final Map<String, double> items,
  }) : _items = items;

  factory _$FinancialStatementImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialStatementImplFromJson(json);

  @override
  final String symbol;
  @override
  final String period;
  @override
  final StatementType type;
  final Map<String, double> _items;
  @override
  Map<String, double> get items {
    if (_items is EqualUnmodifiableMapView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_items);
  }

  @override
  String toString() {
    return 'FinancialStatement(symbol: $symbol, period: $period, type: $type, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialStatementImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    symbol,
    period,
    type,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of FinancialStatement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialStatementImplCopyWith<_$FinancialStatementImpl> get copyWith =>
      __$$FinancialStatementImplCopyWithImpl<_$FinancialStatementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialStatementImplToJson(this);
  }
}

abstract class _FinancialStatement implements FinancialStatement {
  const factory _FinancialStatement({
    required final String symbol,
    required final String period,
    required final StatementType type,
    required final Map<String, double> items,
  }) = _$FinancialStatementImpl;

  factory _FinancialStatement.fromJson(Map<String, dynamic> json) =
      _$FinancialStatementImpl.fromJson;

  @override
  String get symbol;
  @override
  String get period;
  @override
  StatementType get type;
  @override
  Map<String, double> get items;

  /// Create a copy of FinancialStatement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialStatementImplCopyWith<_$FinancialStatementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
