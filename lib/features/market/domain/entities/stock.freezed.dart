// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Stock _$StockFromJson(Map<String, dynamic> json) {
  return _Stock.fromJson(json);
}

/// @nodoc
mixin _$Stock {
  String get symbol => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;
  double get changePercent => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double get low => throw _privateConstructorUsedError;
  double get open => throw _privateConstructorUsedError;
  double get prevClose => throw _privateConstructorUsedError;
  int get volume => throw _privateConstructorUsedError;
  String? get exchange => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Stock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockCopyWith<Stock> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockCopyWith<$Res> {
  factory $StockCopyWith(Stock value, $Res Function(Stock) then) =
      _$StockCopyWithImpl<$Res, Stock>;
  @useResult
  $Res call({
    String symbol,
    double price,
    double change,
    double changePercent,
    double high,
    double low,
    double open,
    double prevClose,
    int volume,
    String? exchange,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$StockCopyWithImpl<$Res, $Val extends Stock>
    implements $StockCopyWith<$Res> {
  _$StockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? price = null,
    Object? change = null,
    Object? changePercent = null,
    Object? high = null,
    Object? low = null,
    Object? open = null,
    Object? prevClose = null,
    Object? volume = null,
    Object? exchange = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            change:
                null == change
                    ? _value.change
                    : change // ignore: cast_nullable_to_non_nullable
                        as double,
            changePercent:
                null == changePercent
                    ? _value.changePercent
                    : changePercent // ignore: cast_nullable_to_non_nullable
                        as double,
            high:
                null == high
                    ? _value.high
                    : high // ignore: cast_nullable_to_non_nullable
                        as double,
            low:
                null == low
                    ? _value.low
                    : low // ignore: cast_nullable_to_non_nullable
                        as double,
            open:
                null == open
                    ? _value.open
                    : open // ignore: cast_nullable_to_non_nullable
                        as double,
            prevClose:
                null == prevClose
                    ? _value.prevClose
                    : prevClose // ignore: cast_nullable_to_non_nullable
                        as double,
            volume:
                null == volume
                    ? _value.volume
                    : volume // ignore: cast_nullable_to_non_nullable
                        as int,
            exchange:
                freezed == exchange
                    ? _value.exchange
                    : exchange // ignore: cast_nullable_to_non_nullable
                        as String?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StockImplCopyWith<$Res> implements $StockCopyWith<$Res> {
  factory _$$StockImplCopyWith(
    _$StockImpl value,
    $Res Function(_$StockImpl) then,
  ) = __$$StockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symbol,
    double price,
    double change,
    double changePercent,
    double high,
    double low,
    double open,
    double prevClose,
    int volume,
    String? exchange,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$StockImplCopyWithImpl<$Res>
    extends _$StockCopyWithImpl<$Res, _$StockImpl>
    implements _$$StockImplCopyWith<$Res> {
  __$$StockImplCopyWithImpl(
    _$StockImpl _value,
    $Res Function(_$StockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? price = null,
    Object? change = null,
    Object? changePercent = null,
    Object? high = null,
    Object? low = null,
    Object? open = null,
    Object? prevClose = null,
    Object? volume = null,
    Object? exchange = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$StockImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        change:
            null == change
                ? _value.change
                : change // ignore: cast_nullable_to_non_nullable
                    as double,
        changePercent:
            null == changePercent
                ? _value.changePercent
                : changePercent // ignore: cast_nullable_to_non_nullable
                    as double,
        high:
            null == high
                ? _value.high
                : high // ignore: cast_nullable_to_non_nullable
                    as double,
        low:
            null == low
                ? _value.low
                : low // ignore: cast_nullable_to_non_nullable
                    as double,
        open:
            null == open
                ? _value.open
                : open // ignore: cast_nullable_to_non_nullable
                    as double,
        prevClose:
            null == prevClose
                ? _value.prevClose
                : prevClose // ignore: cast_nullable_to_non_nullable
                    as double,
        volume:
            null == volume
                ? _value.volume
                : volume // ignore: cast_nullable_to_non_nullable
                    as int,
        exchange:
            freezed == exchange
                ? _value.exchange
                : exchange // ignore: cast_nullable_to_non_nullable
                    as String?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StockImpl implements _Stock {
  const _$StockImpl({
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.high,
    required this.low,
    required this.open,
    required this.prevClose,
    required this.volume,
    this.exchange,
    this.updatedAt,
  });

  factory _$StockImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockImplFromJson(json);

  @override
  final String symbol;
  @override
  final double price;
  @override
  final double change;
  @override
  final double changePercent;
  @override
  final double high;
  @override
  final double low;
  @override
  final double open;
  @override
  final double prevClose;
  @override
  final int volume;
  @override
  final String? exchange;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Stock(symbol: $symbol, price: $price, change: $change, changePercent: $changePercent, high: $high, low: $low, open: $open, prevClose: $prevClose, volume: $volume, exchange: $exchange, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.prevClose, prevClose) ||
                other.prevClose == prevClose) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    symbol,
    price,
    change,
    changePercent,
    high,
    low,
    open,
    prevClose,
    volume,
    exchange,
    updatedAt,
  );

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockImplCopyWith<_$StockImpl> get copyWith =>
      __$$StockImplCopyWithImpl<_$StockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockImplToJson(this);
  }
}

abstract class _Stock implements Stock {
  const factory _Stock({
    required final String symbol,
    required final double price,
    required final double change,
    required final double changePercent,
    required final double high,
    required final double low,
    required final double open,
    required final double prevClose,
    required final int volume,
    final String? exchange,
    final DateTime? updatedAt,
  }) = _$StockImpl;

  factory _Stock.fromJson(Map<String, dynamic> json) = _$StockImpl.fromJson;

  @override
  String get symbol;
  @override
  double get price;
  @override
  double get change;
  @override
  double get changePercent;
  @override
  double get high;
  @override
  double get low;
  @override
  double get open;
  @override
  double get prevClose;
  @override
  int get volume;
  @override
  String? get exchange;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Stock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockImplCopyWith<_$StockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
