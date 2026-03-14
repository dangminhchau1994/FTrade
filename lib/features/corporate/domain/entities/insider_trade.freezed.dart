// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insider_trade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InsiderTrade _$InsiderTradeFromJson(Map<String, dynamic> json) {
  return _InsiderTrade.fromJson(json);
}

/// @nodoc
mixin _$InsiderTrade {
  String get symbol => throw _privateConstructorUsedError;
  String get traderName => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  TradeType get tradeType => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  DateTime get tradeDate => throw _privateConstructorUsedError;
  DateTime get reportDate => throw _privateConstructorUsedError;
  bool get isProprietary => throw _privateConstructorUsedError;

  /// Serializes this InsiderTrade to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InsiderTrade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsiderTradeCopyWith<InsiderTrade> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsiderTradeCopyWith<$Res> {
  factory $InsiderTradeCopyWith(
    InsiderTrade value,
    $Res Function(InsiderTrade) then,
  ) = _$InsiderTradeCopyWithImpl<$Res, InsiderTrade>;
  @useResult
  $Res call({
    String symbol,
    String traderName,
    String position,
    TradeType tradeType,
    int quantity,
    double price,
    DateTime tradeDate,
    DateTime reportDate,
    bool isProprietary,
  });
}

/// @nodoc
class _$InsiderTradeCopyWithImpl<$Res, $Val extends InsiderTrade>
    implements $InsiderTradeCopyWith<$Res> {
  _$InsiderTradeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsiderTrade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? traderName = null,
    Object? position = null,
    Object? tradeType = null,
    Object? quantity = null,
    Object? price = null,
    Object? tradeDate = null,
    Object? reportDate = null,
    Object? isProprietary = null,
  }) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            traderName:
                null == traderName
                    ? _value.traderName
                    : traderName // ignore: cast_nullable_to_non_nullable
                        as String,
            position:
                null == position
                    ? _value.position
                    : position // ignore: cast_nullable_to_non_nullable
                        as String,
            tradeType:
                null == tradeType
                    ? _value.tradeType
                    : tradeType // ignore: cast_nullable_to_non_nullable
                        as TradeType,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            tradeDate:
                null == tradeDate
                    ? _value.tradeDate
                    : tradeDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            reportDate:
                null == reportDate
                    ? _value.reportDate
                    : reportDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            isProprietary:
                null == isProprietary
                    ? _value.isProprietary
                    : isProprietary // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsiderTradeImplCopyWith<$Res>
    implements $InsiderTradeCopyWith<$Res> {
  factory _$$InsiderTradeImplCopyWith(
    _$InsiderTradeImpl value,
    $Res Function(_$InsiderTradeImpl) then,
  ) = __$$InsiderTradeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symbol,
    String traderName,
    String position,
    TradeType tradeType,
    int quantity,
    double price,
    DateTime tradeDate,
    DateTime reportDate,
    bool isProprietary,
  });
}

/// @nodoc
class __$$InsiderTradeImplCopyWithImpl<$Res>
    extends _$InsiderTradeCopyWithImpl<$Res, _$InsiderTradeImpl>
    implements _$$InsiderTradeImplCopyWith<$Res> {
  __$$InsiderTradeImplCopyWithImpl(
    _$InsiderTradeImpl _value,
    $Res Function(_$InsiderTradeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsiderTrade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? traderName = null,
    Object? position = null,
    Object? tradeType = null,
    Object? quantity = null,
    Object? price = null,
    Object? tradeDate = null,
    Object? reportDate = null,
    Object? isProprietary = null,
  }) {
    return _then(
      _$InsiderTradeImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        traderName:
            null == traderName
                ? _value.traderName
                : traderName // ignore: cast_nullable_to_non_nullable
                    as String,
        position:
            null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                    as String,
        tradeType:
            null == tradeType
                ? _value.tradeType
                : tradeType // ignore: cast_nullable_to_non_nullable
                    as TradeType,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        tradeDate:
            null == tradeDate
                ? _value.tradeDate
                : tradeDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        reportDate:
            null == reportDate
                ? _value.reportDate
                : reportDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        isProprietary:
            null == isProprietary
                ? _value.isProprietary
                : isProprietary // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InsiderTradeImpl implements _InsiderTrade {
  const _$InsiderTradeImpl({
    required this.symbol,
    required this.traderName,
    required this.position,
    required this.tradeType,
    required this.quantity,
    required this.price,
    required this.tradeDate,
    required this.reportDate,
    required this.isProprietary,
  });

  factory _$InsiderTradeImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsiderTradeImplFromJson(json);

  @override
  final String symbol;
  @override
  final String traderName;
  @override
  final String position;
  @override
  final TradeType tradeType;
  @override
  final int quantity;
  @override
  final double price;
  @override
  final DateTime tradeDate;
  @override
  final DateTime reportDate;
  @override
  final bool isProprietary;

  @override
  String toString() {
    return 'InsiderTrade(symbol: $symbol, traderName: $traderName, position: $position, tradeType: $tradeType, quantity: $quantity, price: $price, tradeDate: $tradeDate, reportDate: $reportDate, isProprietary: $isProprietary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsiderTradeImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.traderName, traderName) ||
                other.traderName == traderName) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.tradeType, tradeType) ||
                other.tradeType == tradeType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.tradeDate, tradeDate) ||
                other.tradeDate == tradeDate) &&
            (identical(other.reportDate, reportDate) ||
                other.reportDate == reportDate) &&
            (identical(other.isProprietary, isProprietary) ||
                other.isProprietary == isProprietary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    symbol,
    traderName,
    position,
    tradeType,
    quantity,
    price,
    tradeDate,
    reportDate,
    isProprietary,
  );

  /// Create a copy of InsiderTrade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsiderTradeImplCopyWith<_$InsiderTradeImpl> get copyWith =>
      __$$InsiderTradeImplCopyWithImpl<_$InsiderTradeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsiderTradeImplToJson(this);
  }
}

abstract class _InsiderTrade implements InsiderTrade {
  const factory _InsiderTrade({
    required final String symbol,
    required final String traderName,
    required final String position,
    required final TradeType tradeType,
    required final int quantity,
    required final double price,
    required final DateTime tradeDate,
    required final DateTime reportDate,
    required final bool isProprietary,
  }) = _$InsiderTradeImpl;

  factory _InsiderTrade.fromJson(Map<String, dynamic> json) =
      _$InsiderTradeImpl.fromJson;

  @override
  String get symbol;
  @override
  String get traderName;
  @override
  String get position;
  @override
  TradeType get tradeType;
  @override
  int get quantity;
  @override
  double get price;
  @override
  DateTime get tradeDate;
  @override
  DateTime get reportDate;
  @override
  bool get isProprietary;

  /// Create a copy of InsiderTrade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsiderTradeImplCopyWith<_$InsiderTradeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
