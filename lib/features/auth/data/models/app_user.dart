import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'app_user.g.dart';
part 'app_user.freezed.dart';

enum UserTier { free, premium }

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required UserTier tier,
    required bool tosAccepted,
    String? email,
    String? displayName,
    DateTime? tosAcceptedAt,
    String? fcmToken,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      tier: data['tier'] == 'premium' ? UserTier.premium : UserTier.free,
      tosAccepted: data['tosAccepted'] as bool? ?? false,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      tosAcceptedAt: (data['tosAcceptedAt'] as Timestamp?)?.toDate(),
      fcmToken: data['fcmToken'] as String?,
    );
  }
}
