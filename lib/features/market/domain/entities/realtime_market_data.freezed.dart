// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'realtime_market_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RealtimeMarketData _$RealtimeMarketDataFromJson(Map<String, dynamic> json) {
  return _RealtimeMarketData.fromJson(json);
}

/// @nodoc
mixin _$RealtimeMarketData {
  String get symbol =>
      throw _privateConstructorUsedError; // Giá khớp & khối lượng
  double get matchedPrice => throw _privateConstructorUsedError;
  int get matchedVolume => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;
  double get changePercent =>
      throw _privateConstructorUsedError; // Tổng KL & GT
  int get totalVolume => throw _privateConstructorUsedError;
  double get totalValue => throw _privateConstructorUsedError; // OHLC
  double get open => throw _privateConstructorUsedError;
  double get high => throw _privateConstructorUsedError;
  double get low => throw _privateConstructorUsedError; // Giá tham chiếu
  double get ceiling => throw _privateConstructorUsedError;
  double get floor => throw _privateConstructorUsedError;
  double get refPrice =>
      throw _privateConstructorUsedError; // 3 bước giá mua (bid)
  double get bid1Price => throw _privateConstructorUsedError;
  int get bid1Volume => throw _privateConstructorUsedError;
  double get bid2Price => throw _privateConstructorUsedError;
  int get bid2Volume => throw _privateConstructorUsedError;
  double get bid3Price => throw _privateConstructorUsedError;
  int get bid3Volume =>
      throw _privateConstructorUsedError; // 3 bước giá bán (ask/offer)
  double get ask1Price => throw _privateConstructorUsedError;
  int get ask1Volume => throw _privateConstructorUsedError;
  double get ask2Price => throw _privateConstructorUsedError;
  int get ask2Volume => throw _privateConstructorUsedError;
  double get ask3Price => throw _privateConstructorUsedError;
  int get ask3Volume => throw _privateConstructorUsedError; // Khối ngoại
  int get foreignBuyVolume => throw _privateConstructorUsedError;
  int get foreignSellVolume => throw _privateConstructorUsedError; // Phiên
  TradingSession get session => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RealtimeMarketData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RealtimeMarketData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RealtimeMarketDataCopyWith<RealtimeMarketData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealtimeMarketDataCopyWith<$Res> {
  factory $RealtimeMarketDataCopyWith(
    RealtimeMarketData value,
    $Res Function(RealtimeMarketData) then,
  ) = _$RealtimeMarketDataCopyWithImpl<$Res, RealtimeMarketData>;
  @useResult
  $Res call({
    String symbol,
    double matchedPrice,
    int matchedVolume,
    double change,
    double changePercent,
    int totalVolume,
    double totalValue,
    double open,
    double high,
    double low,
    double ceiling,
    double floor,
    double refPrice,
    double bid1Price,
    int bid1Volume,
    double bid2Price,
    int bid2Volume,
    double bid3Price,
    int bid3Volume,
    double ask1Price,
    int ask1Volume,
    double ask2Price,
    int ask2Volume,
    double ask3Price,
    int ask3Volume,
    int foreignBuyVolume,
    int foreignSellVolume,
    TradingSession session,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$RealtimeMarketDataCopyWithImpl<$Res, $Val extends RealtimeMarketData>
    implements $RealtimeMarketDataCopyWith<$Res> {
  _$RealtimeMarketDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RealtimeMarketData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? matchedPrice = null,
    Object? matchedVolume = null,
    Object? change = null,
    Object? changePercent = null,
    Object? totalVolume = null,
    Object? totalValue = null,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? ceiling = null,
    Object? floor = null,
    Object? refPrice = null,
    Object? bid1Price = null,
    Object? bid1Volume = null,
    Object? bid2Price = null,
    Object? bid2Volume = null,
    Object? bid3Price = null,
    Object? bid3Volume = null,
    Object? ask1Price = null,
    Object? ask1Volume = null,
    Object? ask2Price = null,
    Object? ask2Volume = null,
    Object? ask3Price = null,
    Object? ask3Volume = null,
    Object? foreignBuyVolume = null,
    Object? foreignSellVolume = null,
    Object? session = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            matchedPrice:
                null == matchedPrice
                    ? _value.matchedPrice
                    : matchedPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            matchedVolume:
                null == matchedVolume
                    ? _value.matchedVolume
                    : matchedVolume // ignore: cast_nullable_to_non_nullable
                        as int,
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
            totalVolume:
                null == totalVolume
                    ? _value.totalVolume
                    : totalVolume // ignore: cast_nullable_to_non_nullable
                        as int,
            totalValue:
                null == totalValue
                    ? _value.totalValue
                    : totalValue // ignore: cast_nullable_to_non_nullable
                        as double,
            open:
                null == open
                    ? _value.open
                    : open // ignore: cast_nullable_to_non_nullable
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
            bid1Price:
                null == bid1Price
                    ? _value.bid1Price
                    : bid1Price // ignore: cast_nullable_to_non_nullable
                        as double,
            bid1Volume:
                null == bid1Volume
                    ? _value.bid1Volume
                    : bid1Volume // ignore: cast_nullable_to_non_nullable
                        as int,
            bid2Price:
                null == bid2Price
                    ? _value.bid2Price
                    : bid2Price // ignore: cast_nullable_to_non_nullable
                        as double,
            bid2Volume:
                null == bid2Volume
                    ? _value.bid2Volume
                    : bid2Volume // ignore: cast_nullable_to_non_nullable
                        as int,
            bid3Price:
                null == bid3Price
                    ? _value.bid3Price
                    : bid3Price // ignore: cast_nullable_to_non_nullable
                        as double,
            bid3Volume:
                null == bid3Volume
                    ? _value.bid3Volume
                    : bid3Volume // ignore: cast_nullable_to_non_nullable
                        as int,
            ask1Price:
                null == ask1Price
                    ? _value.ask1Price
                    : ask1Price // ignore: cast_nullable_to_non_nullable
                        as double,
            ask1Volume:
                null == ask1Volume
                    ? _value.ask1Volume
                    : ask1Volume // ignore: cast_nullable_to_non_nullable
                        as int,
            ask2Price:
                null == ask2Price
                    ? _value.ask2Price
                    : ask2Price // ignore: cast_nullable_to_non_nullable
                        as double,
            ask2Volume:
                null == ask2Volume
                    ? _value.ask2Volume
                    : ask2Volume // ignore: cast_nullable_to_non_nullable
                        as int,
            ask3Price:
                null == ask3Price
                    ? _value.ask3Price
                    : ask3Price // ignore: cast_nullable_to_non_nullable
                        as double,
            ask3Volume:
                null == ask3Volume
                    ? _value.ask3Volume
                    : ask3Volume // ignore: cast_nullable_to_non_nullable
                        as int,
            foreignBuyVolume:
                null == foreignBuyVolume
                    ? _value.foreignBuyVolume
                    : foreignBuyVolume // ignore: cast_nullable_to_non_nullable
                        as int,
            foreignSellVolume:
                null == foreignSellVolume
                    ? _value.foreignSellVolume
                    : foreignSellVolume // ignore: cast_nullable_to_non_nullable
                        as int,
            session:
                null == session
                    ? _value.session
                    : session // ignore: cast_nullable_to_non_nullable
                        as TradingSession,
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
abstract class _$$RealtimeMarketDataImplCopyWith<$Res>
    implements $RealtimeMarketDataCopyWith<$Res> {
  factory _$$RealtimeMarketDataImplCopyWith(
    _$RealtimeMarketDataImpl value,
    $Res Function(_$RealtimeMarketDataImpl) then,
  ) = __$$RealtimeMarketDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symbol,
    double matchedPrice,
    int matchedVolume,
    double change,
    double changePercent,
    int totalVolume,
    double totalValue,
    double open,
    double high,
    double low,
    double ceiling,
    double floor,
    double refPrice,
    double bid1Price,
    int bid1Volume,
    double bid2Price,
    int bid2Volume,
    double bid3Price,
    int bid3Volume,
    double ask1Price,
    int ask1Volume,
    double ask2Price,
    int ask2Volume,
    double ask3Price,
    int ask3Volume,
    int foreignBuyVolume,
    int foreignSellVolume,
    TradingSession session,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$RealtimeMarketDataImplCopyWithImpl<$Res>
    extends _$RealtimeMarketDataCopyWithImpl<$Res, _$RealtimeMarketDataImpl>
    implements _$$RealtimeMarketDataImplCopyWith<$Res> {
  __$$RealtimeMarketDataImplCopyWithImpl(
    _$RealtimeMarketDataImpl _value,
    $Res Function(_$RealtimeMarketDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RealtimeMarketData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? matchedPrice = null,
    Object? matchedVolume = null,
    Object? change = null,
    Object? changePercent = null,
    Object? totalVolume = null,
    Object? totalValue = null,
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? ceiling = null,
    Object? floor = null,
    Object? refPrice = null,
    Object? bid1Price = null,
    Object? bid1Volume = null,
    Object? bid2Price = null,
    Object? bid2Volume = null,
    Object? bid3Price = null,
    Object? bid3Volume = null,
    Object? ask1Price = null,
    Object? ask1Volume = null,
    Object? ask2Price = null,
    Object? ask2Volume = null,
    Object? ask3Price = null,
    Object? ask3Volume = null,
    Object? foreignBuyVolume = null,
    Object? foreignSellVolume = null,
    Object? session = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RealtimeMarketDataImpl(
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        matchedPrice:
            null == matchedPrice
                ? _value.matchedPrice
                : matchedPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        matchedVolume:
            null == matchedVolume
                ? _value.matchedVolume
                : matchedVolume // ignore: cast_nullable_to_non_nullable
                    as int,
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
        totalVolume:
            null == totalVolume
                ? _value.totalVolume
                : totalVolume // ignore: cast_nullable_to_non_nullable
                    as int,
        totalValue:
            null == totalValue
                ? _value.totalValue
                : totalValue // ignore: cast_nullable_to_non_nullable
                    as double,
        open:
            null == open
                ? _value.open
                : open // ignore: cast_nullable_to_non_nullable
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
        bid1Price:
            null == bid1Price
                ? _value.bid1Price
                : bid1Price // ignore: cast_nullable_to_non_nullable
                    as double,
        bid1Volume:
            null == bid1Volume
                ? _value.bid1Volume
                : bid1Volume // ignore: cast_nullable_to_non_nullable
                    as int,
        bid2Price:
            null == bid2Price
                ? _value.bid2Price
                : bid2Price // ignore: cast_nullable_to_non_nullable
                    as double,
        bid2Volume:
            null == bid2Volume
                ? _value.bid2Volume
                : bid2Volume // ignore: cast_nullable_to_non_nullable
                    as int,
        bid3Price:
            null == bid3Price
                ? _value.bid3Price
                : bid3Price // ignore: cast_nullable_to_non_nullable
                    as double,
        bid3Volume:
            null == bid3Volume
                ? _value.bid3Volume
                : bid3Volume // ignore: cast_nullable_to_non_nullable
                    as int,
        ask1Price:
            null == ask1Price
                ? _value.ask1Price
                : ask1Price // ignore: cast_nullable_to_non_nullable
                    as double,
        ask1Volume:
            null == ask1Volume
                ? _value.ask1Volume
                : ask1Volume // ignore: cast_nullable_to_non_nullable
                    as int,
        ask2Price:
            null == ask2Price
                ? _value.ask2Price
                : ask2Price // ignore: cast_nullable_to_non_nullable
                    as double,
        ask2Volume:
            null == ask2Volume
                ? _value.ask2Volume
                : ask2Volume // ignore: cast_nullable_to_non_nullable
                    as int,
        ask3Price:
            null == ask3Price
                ? _value.ask3Price
                : ask3Price // ignore: cast_nullable_to_non_nullable
                    as double,
        ask3Volume:
            null == ask3Volume
                ? _value.ask3Volume
                : ask3Volume // ignore: cast_nullable_to_non_nullable
                    as int,
        foreignBuyVolume:
            null == foreignBuyVolume
                ? _value.foreignBuyVolume
                : foreignBuyVolume // ignore: cast_nullable_to_non_nullable
                    as int,
        foreignSellVolume:
            null == foreignSellVolume
                ? _value.foreignSellVolume
                : foreignSellVolume // ignore: cast_nullable_to_non_nullable
                    as int,
        session:
            null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                    as TradingSession,
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
class _$RealtimeMarketDataImpl implements _RealtimeMarketData {
  const _$RealtimeMarketDataImpl({
    required this.symbol,
    this.matchedPrice = 0,
    this.matchedVolume = 0,
    this.change = 0,
    this.changePercent = 0,
    this.totalVolume = 0,
    this.totalValue = 0,
    this.open = 0,
    this.high = 0,
    this.low = 0,
    this.ceiling = 0,
    this.floor = 0,
    this.refPrice = 0,
    this.bid1Price = 0,
    this.bid1Volume = 0,
    this.bid2Price = 0,
    this.bid2Volume = 0,
    this.bid3Price = 0,
    this.bid3Volume = 0,
    this.ask1Price = 0,
    this.ask1Volume = 0,
    this.ask2Price = 0,
    this.ask2Volume = 0,
    this.ask3Price = 0,
    this.ask3Volume = 0,
    this.foreignBuyVolume = 0,
    this.foreignSellVolume = 0,
    this.session = TradingSession.unknown,
    this.updatedAt,
  });

  factory _$RealtimeMarketDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RealtimeMarketDataImplFromJson(json);

  @override
  final String symbol;
  // Giá khớp & khối lượng
  @override
  @JsonKey()
  final double matchedPrice;
  @override
  @JsonKey()
  final int matchedVolume;
  @override
  @JsonKey()
  final double change;
  @override
  @JsonKey()
  final double changePercent;
  // Tổng KL & GT
  @override
  @JsonKey()
  final int totalVolume;
  @override
  @JsonKey()
  final double totalValue;
  // OHLC
  @override
  @JsonKey()
  final double open;
  @override
  @JsonKey()
  final double high;
  @override
  @JsonKey()
  final double low;
  // Giá tham chiếu
  @override
  @JsonKey()
  final double ceiling;
  @override
  @JsonKey()
  final double floor;
  @override
  @JsonKey()
  final double refPrice;
  // 3 bước giá mua (bid)
  @override
  @JsonKey()
  final double bid1Price;
  @override
  @JsonKey()
  final int bid1Volume;
  @override
  @JsonKey()
  final double bid2Price;
  @override
  @JsonKey()
  final int bid2Volume;
  @override
  @JsonKey()
  final double bid3Price;
  @override
  @JsonKey()
  final int bid3Volume;
  // 3 bước giá bán (ask/offer)
  @override
  @JsonKey()
  final double ask1Price;
  @override
  @JsonKey()
  final int ask1Volume;
  @override
  @JsonKey()
  final double ask2Price;
  @override
  @JsonKey()
  final int ask2Volume;
  @override
  @JsonKey()
  final double ask3Price;
  @override
  @JsonKey()
  final int ask3Volume;
  // Khối ngoại
  @override
  @JsonKey()
  final int foreignBuyVolume;
  @override
  @JsonKey()
  final int foreignSellVolume;
  // Phiên
  @override
  @JsonKey()
  final TradingSession session;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RealtimeMarketData(symbol: $symbol, matchedPrice: $matchedPrice, matchedVolume: $matchedVolume, change: $change, changePercent: $changePercent, totalVolume: $totalVolume, totalValue: $totalValue, open: $open, high: $high, low: $low, ceiling: $ceiling, floor: $floor, refPrice: $refPrice, bid1Price: $bid1Price, bid1Volume: $bid1Volume, bid2Price: $bid2Price, bid2Volume: $bid2Volume, bid3Price: $bid3Price, bid3Volume: $bid3Volume, ask1Price: $ask1Price, ask1Volume: $ask1Volume, ask2Price: $ask2Price, ask2Volume: $ask2Volume, ask3Price: $ask3Price, ask3Volume: $ask3Volume, foreignBuyVolume: $foreignBuyVolume, foreignSellVolume: $foreignSellVolume, session: $session, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealtimeMarketDataImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.matchedPrice, matchedPrice) ||
                other.matchedPrice == matchedPrice) &&
            (identical(other.matchedVolume, matchedVolume) ||
                other.matchedVolume == matchedVolume) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            (identical(other.totalVolume, totalVolume) ||
                other.totalVolume == totalVolume) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.ceiling, ceiling) || other.ceiling == ceiling) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.refPrice, refPrice) ||
                other.refPrice == refPrice) &&
            (identical(other.bid1Price, bid1Price) ||
                other.bid1Price == bid1Price) &&
            (identical(other.bid1Volume, bid1Volume) ||
                other.bid1Volume == bid1Volume) &&
            (identical(other.bid2Price, bid2Price) ||
                other.bid2Price == bid2Price) &&
            (identical(other.bid2Volume, bid2Volume) ||
                other.bid2Volume == bid2Volume) &&
            (identical(other.bid3Price, bid3Price) ||
                other.bid3Price == bid3Price) &&
            (identical(other.bid3Volume, bid3Volume) ||
                other.bid3Volume == bid3Volume) &&
            (identical(other.ask1Price, ask1Price) ||
                other.ask1Price == ask1Price) &&
            (identical(other.ask1Volume, ask1Volume) ||
                other.ask1Volume == ask1Volume) &&
            (identical(other.ask2Price, ask2Price) ||
                other.ask2Price == ask2Price) &&
            (identical(other.ask2Volume, ask2Volume) ||
                other.ask2Volume == ask2Volume) &&
            (identical(other.ask3Price, ask3Price) ||
                other.ask3Price == ask3Price) &&
            (identical(other.ask3Volume, ask3Volume) ||
                other.ask3Volume == ask3Volume) &&
            (identical(other.foreignBuyVolume, foreignBuyVolume) ||
                other.foreignBuyVolume == foreignBuyVolume) &&
            (identical(other.foreignSellVolume, foreignSellVolume) ||
                other.foreignSellVolume == foreignSellVolume) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    symbol,
    matchedPrice,
    matchedVolume,
    change,
    changePercent,
    totalVolume,
    totalValue,
    open,
    high,
    low,
    ceiling,
    floor,
    refPrice,
    bid1Price,
    bid1Volume,
    bid2Price,
    bid2Volume,
    bid3Price,
    bid3Volume,
    ask1Price,
    ask1Volume,
    ask2Price,
    ask2Volume,
    ask3Price,
    ask3Volume,
    foreignBuyVolume,
    foreignSellVolume,
    session,
    updatedAt,
  ]);

  /// Create a copy of RealtimeMarketData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RealtimeMarketDataImplCopyWith<_$RealtimeMarketDataImpl> get copyWith =>
      __$$RealtimeMarketDataImplCopyWithImpl<_$RealtimeMarketDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RealtimeMarketDataImplToJson(this);
  }
}

abstract class _RealtimeMarketData implements RealtimeMarketData {
  const factory _RealtimeMarketData({
    required final String symbol,
    final double matchedPrice,
    final int matchedVolume,
    final double change,
    final double changePercent,
    final int totalVolume,
    final double totalValue,
    final double open,
    final double high,
    final double low,
    final double ceiling,
    final double floor,
    final double refPrice,
    final double bid1Price,
    final int bid1Volume,
    final double bid2Price,
    final int bid2Volume,
    final double bid3Price,
    final int bid3Volume,
    final double ask1Price,
    final int ask1Volume,
    final double ask2Price,
    final int ask2Volume,
    final double ask3Price,
    final int ask3Volume,
    final int foreignBuyVolume,
    final int foreignSellVolume,
    final TradingSession session,
    final DateTime? updatedAt,
  }) = _$RealtimeMarketDataImpl;

  factory _RealtimeMarketData.fromJson(Map<String, dynamic> json) =
      _$RealtimeMarketDataImpl.fromJson;

  @override
  String get symbol; // Giá khớp & khối lượng
  @override
  double get matchedPrice;
  @override
  int get matchedVolume;
  @override
  double get change;
  @override
  double get changePercent; // Tổng KL & GT
  @override
  int get totalVolume;
  @override
  double get totalValue; // OHLC
  @override
  double get open;
  @override
  double get high;
  @override
  double get low; // Giá tham chiếu
  @override
  double get ceiling;
  @override
  double get floor;
  @override
  double get refPrice; // 3 bước giá mua (bid)
  @override
  double get bid1Price;
  @override
  int get bid1Volume;
  @override
  double get bid2Price;
  @override
  int get bid2Volume;
  @override
  double get bid3Price;
  @override
  int get bid3Volume; // 3 bước giá bán (ask/offer)
  @override
  double get ask1Price;
  @override
  int get ask1Volume;
  @override
  double get ask2Price;
  @override
  int get ask2Volume;
  @override
  double get ask3Price;
  @override
  int get ask3Volume; // Khối ngoại
  @override
  int get foreignBuyVolume;
  @override
  int get foreignSellVolume; // Phiên
  @override
  TradingSession get session;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RealtimeMarketData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RealtimeMarketDataImplCopyWith<_$RealtimeMarketDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
