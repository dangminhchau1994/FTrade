// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_index.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketIndex _$MarketIndexFromJson(Map<String, dynamic> json) {
  return _MarketIndex.fromJson(json);
}

/// @nodoc
mixin _$MarketIndex {
  String get name => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;
  double get changePercent => throw _privateConstructorUsedError;
  int get totalVolume => throw _privateConstructorUsedError;
  int get advances => throw _privateConstructorUsedError;
  int get declines => throw _privateConstructorUsedError;
  int get unchanged => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MarketIndex to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketIndex
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketIndexCopyWith<MarketIndex> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketIndexCopyWith<$Res> {
  factory $MarketIndexCopyWith(
    MarketIndex value,
    $Res Function(MarketIndex) then,
  ) = _$MarketIndexCopyWithImpl<$Res, MarketIndex>;
  @useResult
  $Res call({
    String name,
    double value,
    double change,
    double changePercent,
    int totalVolume,
    int advances,
    int declines,
    int unchanged,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$MarketIndexCopyWithImpl<$Res, $Val extends MarketIndex>
    implements $MarketIndexCopyWith<$Res> {
  _$MarketIndexCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketIndex
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? change = null,
    Object? changePercent = null,
    Object? totalVolume = null,
    Object? advances = null,
    Object? declines = null,
    Object? unchanged = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
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
            totalVolume:
                null == totalVolume
                    ? _value.totalVolume
                    : totalVolume // ignore: cast_nullable_to_non_nullable
                        as int,
            advances:
                null == advances
                    ? _value.advances
                    : advances // ignore: cast_nullable_to_non_nullable
                        as int,
            declines:
                null == declines
                    ? _value.declines
                    : declines // ignore: cast_nullable_to_non_nullable
                        as int,
            unchanged:
                null == unchanged
                    ? _value.unchanged
                    : unchanged // ignore: cast_nullable_to_non_nullable
                        as int,
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
abstract class _$$MarketIndexImplCopyWith<$Res>
    implements $MarketIndexCopyWith<$Res> {
  factory _$$MarketIndexImplCopyWith(
    _$MarketIndexImpl value,
    $Res Function(_$MarketIndexImpl) then,
  ) = __$$MarketIndexImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    double value,
    double change,
    double changePercent,
    int totalVolume,
    int advances,
    int declines,
    int unchanged,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$MarketIndexImplCopyWithImpl<$Res>
    extends _$MarketIndexCopyWithImpl<$Res, _$MarketIndexImpl>
    implements _$$MarketIndexImplCopyWith<$Res> {
  __$$MarketIndexImplCopyWithImpl(
    _$MarketIndexImpl _value,
    $Res Function(_$MarketIndexImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketIndex
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? change = null,
    Object? changePercent = null,
    Object? totalVolume = null,
    Object? advances = null,
    Object? declines = null,
    Object? unchanged = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$MarketIndexImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
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
        totalVolume:
            null == totalVolume
                ? _value.totalVolume
                : totalVolume // ignore: cast_nullable_to_non_nullable
                    as int,
        advances:
            null == advances
                ? _value.advances
                : advances // ignore: cast_nullable_to_non_nullable
                    as int,
        declines:
            null == declines
                ? _value.declines
                : declines // ignore: cast_nullable_to_non_nullable
                    as int,
        unchanged:
            null == unchanged
                ? _value.unchanged
                : unchanged // ignore: cast_nullable_to_non_nullable
                    as int,
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
class _$MarketIndexImpl implements _MarketIndex {
  const _$MarketIndexImpl({
    required this.name,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.totalVolume,
    required this.advances,
    required this.declines,
    required this.unchanged,
    this.updatedAt,
  });

  factory _$MarketIndexImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketIndexImplFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  final double change;
  @override
  final double changePercent;
  @override
  final int totalVolume;
  @override
  final int advances;
  @override
  final int declines;
  @override
  final int unchanged;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MarketIndex(name: $name, value: $value, change: $change, changePercent: $changePercent, totalVolume: $totalVolume, advances: $advances, declines: $declines, unchanged: $unchanged, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketIndexImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            (identical(other.totalVolume, totalVolume) ||
                other.totalVolume == totalVolume) &&
            (identical(other.advances, advances) ||
                other.advances == advances) &&
            (identical(other.declines, declines) ||
                other.declines == declines) &&
            (identical(other.unchanged, unchanged) ||
                other.unchanged == unchanged) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    value,
    change,
    changePercent,
    totalVolume,
    advances,
    declines,
    unchanged,
    updatedAt,
  );

  /// Create a copy of MarketIndex
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketIndexImplCopyWith<_$MarketIndexImpl> get copyWith =>
      __$$MarketIndexImplCopyWithImpl<_$MarketIndexImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketIndexImplToJson(this);
  }
}

abstract class _MarketIndex implements MarketIndex {
  const factory _MarketIndex({
    required final String name,
    required final double value,
    required final double change,
    required final double changePercent,
    required final int totalVolume,
    required final int advances,
    required final int declines,
    required final int unchanged,
    final DateTime? updatedAt,
  }) = _$MarketIndexImpl;

  factory _MarketIndex.fromJson(Map<String, dynamic> json) =
      _$MarketIndexImpl.fromJson;

  @override
  String get name;
  @override
  double get value;
  @override
  double get change;
  @override
  double get changePercent;
  @override
  int get totalVolume;
  @override
  int get advances;
  @override
  int get declines;
  @override
  int get unchanged;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MarketIndex
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketIndexImplCopyWith<_$MarketIndexImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
