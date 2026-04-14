import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserRepository {
  final FirebaseFirestore _db;

  UserRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  Future<AppUser?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<AppUser> createUser(String uid) async {
    await _db.collection('users').doc(uid).set({
      'tier': 'free',
      'tosAccepted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return AppUser(uid: uid, tier: UserTier.free, tosAccepted: false);
  }

  Future<AppUser> getOrCreateUser(String uid) async {
    final existing = await getUser(uid);
    if (existing != null) return existing;
    return createUser(uid);
  }

  Future<void> acceptTos(String uid) async {
    await _db.collection('users').doc(uid).update({
      'tosAccepted': true,
      'tosAcceptedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProfile(String uid, {String? email, String? displayName}) async {
    final updates = <String, dynamic>{};
    if (email != null) updates['email'] = email;
    if (displayName != null) updates['displayName'] = displayName;
    if (updates.isEmpty) return;
    await _db.collection('users').doc(uid).update(updates);
  }

  Future<void> updateFcmToken(String uid, String token) async {
    await _db.collection('users').doc(uid).update({'fcmToken': token});
  }

  Future<void> updateWatchlistSymbols(String uid, List<String> symbols) async {
    await _db.collection('users').doc(uid).update({
      'watchlistSymbols': symbols,
      'watchlistUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<AppUser?> watchUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromFirestore(doc);
    });
  }
}
