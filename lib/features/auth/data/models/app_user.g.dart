// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      tier: $enumDecode(_$UserTierEnumMap, json['tier']),
      tosAccepted: json['tosAccepted'] as bool,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      tosAcceptedAt:
          json['tosAcceptedAt'] == null
              ? null
              : DateTime.parse(json['tosAcceptedAt'] as String),
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'tier': _$UserTierEnumMap[instance.tier]!,
      'tosAccepted': instance.tosAccepted,
      'email': instance.email,
      'displayName': instance.displayName,
      'tosAcceptedAt': instance.tosAcceptedAt?.toIso8601String(),
      'fcmToken': instance.fcmToken,
    };

const _$UserTierEnumMap = {UserTier.free: 'free', UserTier.premium: 'premium'};
