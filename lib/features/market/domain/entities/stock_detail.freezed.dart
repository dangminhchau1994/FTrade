// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StockDetail _$StockDetailFromJson(Map<String, dynamic> json) {
  return _StockDetail.fromJson(json);
}

/// @nodoc
mixin _$StockDetail {
  String get symbol => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get exchange => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;
  double get changePercent => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double get low => throw _privateConstructorUsedError;
  double get open => throw _privateConstructorUsedError;
  double get prevClose => throw _privateConstructorUsedError;
  int get volume => throw _privateConstructorUsedError;
  double get ceiling => throw _privateConstructorUsedError;
  double get floor => throw _privateConstructorUsedError;
  double get refPrice => throw _privateConstructorUsedError;
  double? get pe => throw _privateConstructorUsedError;
  double? get pb => throw _privateConstructorUsedError;
  double? get eps => throw _privateConstructorUsedError;
  double? get marketCap => throw _privateConstructorUsedError;
  double? get foreignBuy => throw _privateConstructorUsedError;
  double? get foreignSell => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this StockDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StockDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StockDetailCopyWith<StockDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockDetailCopyWith<$Res> {
  factory $StockDetailCopyWith(
    StockDetail value,
    $Res Function(StockDetail) then,
  ) = _$StockDetailCopyWithImpl<$Res, StockDetail>;
  @useResult
  $Res call({
    String symbol,
    String companyName,
    String exchange,
    double price,
    double change,
    double changePercent,
    double high,
    double low,
    double open,
    double prevClose,
    int volume,
    double ceiling,
    double floor,
    double refPrice,
    double? pe,
    double? pb,
    double? eps,
    double? marketCap,
    double? foreignBuy,
    double? foreignSell,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$StockDetailCopyWithImpl<$Res, $Val extends StockDetail>
    implements $StockDetailCopyWith<$Res> {
  _$StockDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StockDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? companyName = null,
    Object? exchange = null,
    Object? price = null,
    Object? change = null,
    Object? changePercent = null,
    Object? high = null,
    Object? low = null,
    Object? open = null,
    Object? prevClose = null,
    Object? volume = null,
    Object? ceiling = null,
    Object? floor = null,
    Object? refPrice = null,
    Object? pe = freezed,
    Object? pb = freezed,
    Object? eps = freezed,
    Object? marketCap = freezed,
    Object? foreignBuy = freezed,
    Object? foreignSell = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            companyName:
                null == companyName
                    ? _value.companyName
                    : companyName // ignore: cast_nullable_to_non_nullable
                        as String,
            exchange:
                null == exchange
                    ? _value.exchange
                    : exchange // ignore: cast_nullable_to_non_nullable
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
            ceiling:
                null == ceiling
                    ? _value.ceiling
                    : ceiling // ignore: cast_nullable_to_non_nullable
                        as double,
            floor:
                null == floor
                    ? _value.floor
                    : floor // ignore: cast_nullable_to_non_nullable
                        as double,
            refPrice:
                null == refPrice
                    ? _value.refPrice
                    : refPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            pe:
                freezed == pe
                    ? _value.pe
                    : pe // ignore: cast_nullable_to_non_nullable
                        as double?,
            pb:
                freezed == pb
                    ? _value.pb
                    : pb // ignore: cast_nullable_to_non_nullable
                        as double?,
            eps:
                freezed == eps
                    ? _value.eps
                    : eps // ignore: cast_nullable_to_non_nullable
                        as double?,
            marketCap:
                freezed == marketCap
                    ? _value.marketCap
                    : marketCap // ignore: cast_nullable_to_non_nullable
                        as double?,
            foreignBuy:
                freezed == foreignBuy
                    ? _value.foreignBuy
                    : foreignBuy // ignore: cast_nullable_to_non_nullable
                        as double?,
            foreignSell:
                freezed == foreignSell
                    ? _value.foreignSell
                    : foreignSell // ignore: cast_nullable_to_non_nullable
                        as double?,
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
abstract class _$$StockDetailImplCopyWith<$Res>
    implements $StockDetailCopyWith<$Res> {
  factory _$$StockDetailImplCopyWith(
    _$StockDetailImpl value,
    $Res Function(_$StockDetailImpl) then,
  ) = __$$StockDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symbol,
    String companyName,
    String exchange,
    double price,
    double change,
    double changePercent,
    double high,
    double low,
    double open,
    double prevClose,
    int volume,
    double ceiling,
    double floor,
    double refPrice,
    double? pe,
    double? pb,
    double? eps,
    double? marketCap,
    double? foreignBuy,
    double? foreignSell,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$StockDetailImplCopyWithImpl<$Res>
    extends _$StockDetailCopyWithImpl<$Res, _$StockDetailImpl>
    implements _$$StockDetailImplCopyWith<$Res> {
  __$$StockDetailImplCopyWithImpl(
    _$StockDetailImpl _value,
    $Res Function(_$StockDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StockDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? companyName = null,
    Object? exchange = null,
    Object? price = null,
    Object? change = null,
    Object? changePercent = null,
    Object? high = null,
    Object? low = null,
    Object? open = null,
    Object? prevClose = null,
    Object? volume = null,
    Object? ceiling = null,
    Object? floor = null,
    Object? refPrice = null,
    Object? pe = freezed,
    Object? pb = freezed,
    Object? eps = freezed,
    Object? marketCap = freezed,
    Object? foreignBuy = freezed,
    Object? foreignSell = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$StockDetailImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        companyName:
            null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                    as String,
        exchange:
            null == exchange
                ? _value.exchange
                : exchange // ignore: cast_nullable_to_non_nullable
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
        ceiling:
            null == ceiling
                ? _value.ceiling
                : ceiling // ignore: cast_nullable_to_non_nullable
                    as double,
        floor:
            null == floor
                ? _value.floor
                : floor // ignore: cast_nullable_to_non_nullable
                    as double,
        refPrice:
            null == refPrice
                ? _value.refPrice
                : refPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        pe:
            freezed == pe
                ? _value.pe
                : pe // ignore: cast_nullable_to_non_nullable
                    as double?,
        pb:
            freezed == pb
                ? _value.pb
                : pb // ignore: cast_nullable_to_non_nullable
                    as double?,
        eps:
            freezed == eps
                ? _value.eps
                : eps // ignore: cast_nullable_to_non_nullable
                    as double?,
        marketCap:
            freezed == marketCap
                ? _value.marketCap
                : marketCap // ignore: cast_nullable_to_non_nullable
                    as double?,
        foreignBuy:
            freezed == foreignBuy
                ? _value.foreignBuy
                : foreignBuy // ignore: cast_nullable_to_non_nullable
                    as double?,
        foreignSell:
            freezed == foreignSell
                ? _value.foreignSell
                : foreignSell // ignore: cast_nullable_to_non_nullable
                    as double?,
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
class _$StockDetailImpl implements _StockDetail {
  const _$StockDetailImpl({
    required this.symbol,
    required this.companyName,
    required this.exchange,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.high,
    required this.low,
    required this.open,
    required this.prevClose,
    required this.volume,
    required this.ceiling,
    required this.floor,
    required this.refPrice,
    this.pe,
    this.pb,
    this.eps,
    this.marketCap,
    this.foreignBuy,
    this.foreignSell,
    this.updatedAt,
  });

  factory _$StockDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockDetailImplFromJson(json);

  @override
  final String symbol;
  @override
  final String companyName;
  @override
  final String exchange;
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
  final double ceiling;
  @override
  final double floor;
  @override
  final double refPrice;
  @override
  final double? pe;
  @override
  final double? pb;
  @override
  final double? eps;
  @override
  final double? marketCap;
  @override
  final double? foreignBuy;
  @override
  final double? foreignSell;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'StockDetail(symbol: $symbol, companyName: $companyName, exchange: $exchange, price: $price, change: $change, changePercent: $changePercent, high: $high, low: $low, open: $open, prevClose: $prevClose, volume: $volume, ceiling: $ceiling, floor: $floor, refPrice: $refPrice, pe: $pe, pb: $pb, eps: $eps, marketCap: $marketCap, foreignBuy: $foreignBuy, foreignSell: $foreignSell, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockDetailImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
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
            (identical(other.ceiling, ceiling) || other.ceiling == ceiling) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.refPrice, refPrice) ||
                other.refPrice == refPrice) &&
            (identical(other.pe, pe) || other.pe == pe) &&
            (identical(other.pb, pb) || other.pb == pb) &&
            (identical(other.eps, eps) || other.eps == eps) &&
            (identical(other.marketCap, marketCap) ||
                other.marketCap == marketCap) &&
            (identical(other.foreignBuy, foreignBuy) ||
                other.foreignBuy == foreignBuy) &&
            (identical(other.foreignSell, foreignSell) ||
                other.foreignSell == foreignSell) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    symbol,
    companyName,
    exchange,
    price,
    change,
    changePercent,
    high,
    low,
    open,
    prevClose,
    volume,
    ceiling,
    floor,
    refPrice,
    pe,
    pb,
    eps,
    marketCap,
    foreignBuy,
    foreignSell,
    updatedAt,
  ]);

  /// Create a copy of StockDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StockDetailImplCopyWith<_$StockDetailImpl> get copyWith =>
      __$$StockDetailImplCopyWithImpl<_$StockDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockDetailImplToJson(this);
  }
}

abstract class _StockDetail implements StockDetail {
  const factory _StockDetail({
    required final String symbol,
    required final String companyName,
    required final String exchange,
    required final double price,
    required final double change,
    required final double changePercent,
    required final double high,
    required final double low,
    required final double open,
    required final double prevClose,
    required final int volume,
    required final double ceiling,
    required final double floor,
    required final double refPrice,
    final double? pe,
    final double? pb,
    final double? eps,
    final double? marketCap,
    final double? foreignBuy,
    final double? foreignSell,
    final DateTime? updatedAt,
  }) = _$StockDetailImpl;

  factory _StockDetail.fromJson(Map<String, dynamic> json) =
      _$StockDetailImpl.fromJson;

  @override
  String get symbol;
  @override
  String get companyName;
  @override
  String get exchange;
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
  double get ceiling;
  @override
  double get floor;
  @override
  double get refPrice;
  @override
  double? get pe;
  @override
  double? get pb;
  @override
  double? get eps;
  @override
  double? get marketCap;
  @override
  double? get foreignBuy;
  @override
  double? get foreignSell;
  @override
  DateTime? get updatedAt;

  /// Create a copy of StockDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StockDetailImplCopyWith<_$StockDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
