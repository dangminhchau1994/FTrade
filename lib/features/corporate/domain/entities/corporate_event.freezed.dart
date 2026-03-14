// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'corporate_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CorporateEvent _$CorporateEventFromJson(Map<String, dynamic> json) {
  return _CorporateEvent.fromJson(json);
}

/// @nodoc
mixin _$CorporateEvent {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  CorporateEventType get type => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this CorporateEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CorporateEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CorporateEventCopyWith<CorporateEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CorporateEventCopyWith<$Res> {
  factory $CorporateEventCopyWith(
    CorporateEvent value,
    $Res Function(CorporateEvent) then,
  ) = _$CorporateEventCopyWithImpl<$Res, CorporateEvent>;
  @useResult
  $Res call({
    String id,
    String symbol,
    String title,
    CorporateEventType type,
    DateTime eventDate,
    String? description,
  });
}

/// @nodoc
class _$CorporateEventCopyWithImpl<$Res, $Val extends CorporateEvent>
    implements $CorporateEventCopyWith<$Res> {
  _$CorporateEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CorporateEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? title = null,
    Object? type = null,
    Object? eventDate = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            symbol:
                null == symbol
                    ? _value.symbol
                    : symbol // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as CorporateEventType,
            eventDate:
                null == eventDate
                    ? _value.eventDate
                    : eventDate // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CorporateEventImplCopyWith<$Res>
    implements $CorporateEventCopyWith<$Res> {
  factory _$$CorporateEventImplCopyWith(
    _$CorporateEventImpl value,
    $Res Function(_$CorporateEventImpl) then,
  ) = __$$CorporateEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String symbol,
    String title,
    CorporateEventType type,
    DateTime eventDate,
    String? description,
  });
}

/// @nodoc
class __$$CorporateEventImplCopyWithImpl<$Res>
    extends _$CorporateEventCopyWithImpl<$Res, _$CorporateEventImpl>
    implements _$$CorporateEventImplCopyWith<$Res> {
  __$$CorporateEventImplCopyWithImpl(
    _$CorporateEventImpl _value,
    $Res Function(_$CorporateEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CorporateEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? title = null,
    Object? type = null,
    Object? eventDate = null,
    Object? description = freezed,
  }) {
    return _then(
      _$CorporateEventImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        symbol:
            null == symbol
                ? _value.symbol
                : symbol // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as CorporateEventType,
        eventDate:
            null == eventDate
                ? _value.eventDate
                : eventDate // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CorporateEventImpl implements _CorporateEvent {
  const _$CorporateEventImpl({
    required this.id,
    required this.symbol,
    required this.title,
    required this.type,
    required this.eventDate,
    this.description,
  });

  factory _$CorporateEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$CorporateEventImplFromJson(json);

  @override
  final String id;
  @override
  final String symbol;
  @override
  final String title;
  @override
  final CorporateEventType type;
  @override
  final DateTime eventDate;
  @override
  final String? description;

  @override
  String toString() {
    return 'CorporateEvent(id: $id, symbol: $symbol, title: $title, type: $type, eventDate: $eventDate, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CorporateEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, symbol, title, type, eventDate, description);

  /// Create a copy of CorporateEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CorporateEventImplCopyWith<_$CorporateEventImpl> get copyWith =>
      __$$CorporateEventImplCopyWithImpl<_$CorporateEventImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CorporateEventImplToJson(this);
  }
}

abstract class _CorporateEvent implements CorporateEvent {
  const factory _CorporateEvent({
    required final String id,
    required final String symbol,
    required final String title,
    required final CorporateEventType type,
    required final DateTime eventDate,
    final String? description,
  }) = _$CorporateEventImpl;

  factory _CorporateEvent.fromJson(Map<String, dynamic> json) =
      _$CorporateEventImpl.fromJson;

  @override
  String get id;
  @override
  String get symbol;
  @override
  String get title;
  @override
  CorporateEventType get type;
  @override
  DateTime get eventDate;
  @override
  String? get description;

  /// Create a copy of CorporateEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CorporateEventImplCopyWith<_$CorporateEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
