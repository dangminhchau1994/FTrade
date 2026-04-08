// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  UserTier get tier => throw _privateConstructorUsedError;
  bool get tosAccepted => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  DateTime? get tosAcceptedAt => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call({
    String uid,
    UserTier tier,
    bool tosAccepted,
    String? email,
    String? displayName,
    DateTime? tosAcceptedAt,
    String? fcmToken,
  });
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? tier = null,
    Object? tosAccepted = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? tosAcceptedAt = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            uid:
                null == uid
                    ? _value.uid
                    : uid // ignore: cast_nullable_to_non_nullable
                        as String,
            tier:
                null == tier
                    ? _value.tier
                    : tier // ignore: cast_nullable_to_non_nullable
                        as UserTier,
            tosAccepted:
                null == tosAccepted
                    ? _value.tosAccepted
                    : tosAccepted // ignore: cast_nullable_to_non_nullable
                        as bool,
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            displayName:
                freezed == displayName
                    ? _value.displayName
                    : displayName // ignore: cast_nullable_to_non_nullable
                        as String?,
            tosAcceptedAt:
                freezed == tosAcceptedAt
                    ? _value.tosAcceptedAt
                    : tosAcceptedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            fcmToken:
                freezed == fcmToken
                    ? _value.fcmToken
                    : fcmToken // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
    _$AppUserImpl value,
    $Res Function(_$AppUserImpl) then,
  ) = __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    UserTier tier,
    bool tosAccepted,
    String? email,
    String? displayName,
    DateTime? tosAcceptedAt,
    String? fcmToken,
  });
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
    _$AppUserImpl _value,
    $Res Function(_$AppUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? tier = null,
    Object? tosAccepted = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? tosAcceptedAt = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(
      _$AppUserImpl(
        uid:
            null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                    as String,
        tier:
            null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                    as UserTier,
        tosAccepted:
            null == tosAccepted
                ? _value.tosAccepted
                : tosAccepted // ignore: cast_nullable_to_non_nullable
                    as bool,
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayName:
            freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                    as String?,
        tosAcceptedAt:
            freezed == tosAcceptedAt
                ? _value.tosAcceptedAt
                : tosAcceptedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        fcmToken:
            freezed == fcmToken
                ? _value.fcmToken
                : fcmToken // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl({
    required this.uid,
    required this.tier,
    required this.tosAccepted,
    this.email,
    this.displayName,
    this.tosAcceptedAt,
    this.fcmToken,
  });

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  final UserTier tier;
  @override
  final bool tosAccepted;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final DateTime? tosAcceptedAt;
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'AppUser(uid: $uid, tier: $tier, tosAccepted: $tosAccepted, email: $email, displayName: $displayName, tosAcceptedAt: $tosAcceptedAt, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.tosAccepted, tosAccepted) ||
                other.tosAccepted == tosAccepted) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.tosAcceptedAt, tosAcceptedAt) ||
                other.tosAcceptedAt == tosAcceptedAt) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    tier,
    tosAccepted,
    email,
    displayName,
    tosAcceptedAt,
    fcmToken,
  );

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(this);
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser({
    required final String uid,
    required final UserTier tier,
    required final bool tosAccepted,
    final String? email,
    final String? displayName,
    final DateTime? tosAcceptedAt,
    final String? fcmToken,
  }) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  UserTier get tier;
  @override
  bool get tosAccepted;
  @override
  String? get email;
  @override
  String? get displayName;
  @override
  DateTime? get tosAcceptedAt;
  @override
  String? get fcmToken;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
