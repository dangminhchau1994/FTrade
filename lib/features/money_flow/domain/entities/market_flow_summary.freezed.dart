// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_flow_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketFlowSummary _$MarketFlowSummaryFromJson(Map<String, dynamic> json) {
  return _MarketFlowSummary.fromJson(json);
}

/// @nodoc
mixin _$MarketFlowSummary {
  double get totalForeignBuy => throw _privateConstructorUsedError;
  double get totalForeignSell => throw _privateConstructorUsedError;
  double get totalForeignNet => throw _privateConstructorUsedError;
  List<ForeignFlow> get topNetBuyers => throw _privateConstructorUsedError;
  List<ForeignFlow> get topNetSellers => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this MarketFlowSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketFlowSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketFlowSummaryCopyWith<MarketFlowSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketFlowSummaryCopyWith<$Res> {
  factory $MarketFlowSummaryCopyWith(
    MarketFlowSummary value,
    $Res Function(MarketFlowSummary) then,
  ) = _$MarketFlowSummaryCopyWithImpl<$Res, MarketFlowSummary>;
  @useResult
  $Res call({
    double totalForeignBuy,
    double totalForeignSell,
    double totalForeignNet,
    List<ForeignFlow> topNetBuyers,
    List<ForeignFlow> topNetSellers,
    DateTime date,
  });
}

/// @nodoc
class _$MarketFlowSummaryCopyWithImpl<$Res, $Val extends MarketFlowSummary>
    implements $MarketFlowSummaryCopyWith<$Res> {
  _$MarketFlowSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketFlowSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalForeignBuy = null,
    Object? totalForeignSell = null,
    Object? totalForeignNet = null,
    Object? topNetBuyers = null,
    Object? topNetSellers = null,
    Object? date = null,
  }) {
    return _then(
      _value.copyWith(
            totalForeignBuy:
                null == totalForeignBuy
                    ? _value.totalForeignBuy
                    : totalForeignBuy // ignore: cast_nullable_to_non_nullable
                        as double,
            totalForeignSell:
                null == totalForeignSell
                    ? _value.totalForeignSell
                    : totalForeignSell // ignore: cast_nullable_to_non_nullable
                        as double,
            totalForeignNet:
                null == totalForeignNet
                    ? _value.totalForeignNet
                    : totalForeignNet // ignore: cast_nullable_to_non_nullable
                        as double,
            topNetBuyers:
                null == topNetBuyers
                    ? _value.topNetBuyers
                    : topNetBuyers // ignore: cast_nullable_to_non_nullable
                        as List<ForeignFlow>,
            topNetSellers:
                null == topNetSellers
                    ? _value.topNetSellers
                    : topNetSellers // ignore: cast_nullable_to_non_nullable
                        as List<ForeignFlow>,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketFlowSummaryImplCopyWith<$Res>
    implements $MarketFlowSummaryCopyWith<$Res> {
  factory _$$MarketFlowSummaryImplCopyWith(
    _$MarketFlowSummaryImpl value,
    $Res Function(_$MarketFlowSummaryImpl) then,
  ) = __$$MarketFlowSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalForeignBuy,
    double totalForeignSell,
    double totalForeignNet,
    List<ForeignFlow> topNetBuyers,
    List<ForeignFlow> topNetSellers,
    DateTime date,
  });
}

/// @nodoc
class __$$MarketFlowSummaryImplCopyWithImpl<$Res>
    extends _$MarketFlowSummaryCopyWithImpl<$Res, _$MarketFlowSummaryImpl>
    implements _$$MarketFlowSummaryImplCopyWith<$Res> {
  __$$MarketFlowSummaryImplCopyWithImpl(
    _$MarketFlowSummaryImpl _value,
    $Res Function(_$MarketFlowSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketFlowSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalForeignBuy = null,
    Object? totalForeignSell = null,
    Object? totalForeignNet = null,
    Object? topNetBuyers = null,
    Object? topNetSellers = null,
    Object? date = null,
  }) {
    return _then(
      _$MarketFlowSummaryImpl(
        totalForeignBuy:
            null == totalForeignBuy
                ? _value.totalForeignBuy
                : totalForeignBuy // ignore: cast_nullable_to_non_nullable
                    as double,
        totalForeignSell:
            null == totalForeignSell
                ? _value.totalForeignSell
                : totalForeignSell // ignore: cast_nullable_to_non_nullable
                    as double,
        totalForeignNet:
            null == totalForeignNet
                ? _value.totalForeignNet
                : totalForeignNet // ignore: cast_nullable_to_non_nullable
                    as double,
        topNetBuyers:
            null == topNetBuyers
                ? _value._topNetBuyers
                : topNetBuyers // ignore: cast_nullable_to_non_nullable
                    as List<ForeignFlow>,
        topNetSellers:
            null == topNetSellers
                ? _value._topNetSellers
                : topNetSellers // ignore: cast_nullable_to_non_nullable
                    as List<ForeignFlow>,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketFlowSummaryImpl implements _MarketFlowSummary {
  const _$MarketFlowSummaryImpl({
    required this.totalForeignBuy,
    required this.totalForeignSell,
    required this.totalForeignNet,
    required final List<ForeignFlow> topNetBuyers,
    required final List<ForeignFlow> topNetSellers,
    required this.date,
  }) : _topNetBuyers = topNetBuyers,
       _topNetSellers = topNetSellers;

  factory _$MarketFlowSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketFlowSummaryImplFromJson(json);

  @override
  final double totalForeignBuy;
  @override
  final double totalForeignSell;
  @override
  final double totalForeignNet;
  final List<ForeignFlow> _topNetBuyers;
  @override
  List<ForeignFlow> get topNetBuyers {
    if (_topNetBuyers is EqualUnmodifiableListView) return _topNetBuyers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topNetBuyers);
  }

  final List<ForeignFlow> _topNetSellers;
  @override
  List<ForeignFlow> get topNetSellers {
    if (_topNetSellers is EqualUnmodifiableListView) return _topNetSellers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topNetSellers);
  }

  @override
  final DateTime date;

  @override
  String toString() {
    return 'MarketFlowSummary(totalForeignBuy: $totalForeignBuy, totalForeignSell: $totalForeignSell, totalForeignNet: $totalForeignNet, topNetBuyers: $topNetBuyers, topNetSellers: $topNetSellers, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketFlowSummaryImpl &&
            (identical(other.totalForeignBuy, totalForeignBuy) ||
                other.totalForeignBuy == totalForeignBuy) &&
            (identical(other.totalForeignSell, totalForeignSell) ||
                other.totalForeignSell == totalForeignSell) &&
            (identical(other.totalForeignNet, totalForeignNet) ||
                other.totalForeignNet == totalForeignNet) &&
            const DeepCollectionEquality().equals(
              other._topNetBuyers,
              _topNetBuyers,
            ) &&
            const DeepCollectionEquality().equals(
              other._topNetSellers,
              _topNetSellers,
            ) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalForeignBuy,
    totalForeignSell,
    totalForeignNet,
    const DeepCollectionEquality().hash(_topNetBuyers),
    const DeepCollectionEquality().hash(_topNetSellers),
    date,
  );

  /// Create a copy of MarketFlowSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketFlowSummaryImplCopyWith<_$MarketFlowSummaryImpl> get copyWith =>
      __$$MarketFlowSummaryImplCopyWithImpl<_$MarketFlowSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketFlowSummaryImplToJson(this);
  }
}

abstract class _MarketFlowSummary implements MarketFlowSummary {
  const factory _MarketFlowSummary({
    required final double totalForeignBuy,
    required final double totalForeignSell,
    required final double totalForeignNet,
    required final List<ForeignFlow> topNetBuyers,
    required final List<ForeignFlow> topNetSellers,
    required final DateTime date,
  }) = _$MarketFlowSummaryImpl;

  factory _MarketFlowSummary.fromJson(Map<String, dynamic> json) =
      _$MarketFlowSummaryImpl.fromJson;

  @override
  double get totalForeignBuy;
  @override
  double get totalForeignSell;
  @override
  double get totalForeignNet;
  @override
  List<ForeignFlow> get topNetBuyers;
  @override
  List<ForeignFlow> get topNetSellers;
  @override
  DateTime get date;

  /// Create a copy of MarketFlowSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketFlowSummaryImplCopyWith<_$MarketFlowSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
