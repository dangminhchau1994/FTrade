import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/app_user.dart';
import '../../data/repositories/user_repository.dart';

final _userRepository = UserRepository();

// Firebase Auth user stream
final firebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// AppUser từ Firestore (tier, tosAccepted, v.v.)
final appUserProvider = StreamProvider<AppUser?>((ref) {
  final firebaseUser = ref.watch(firebaseUserProvider).valueOrNull;
  if (firebaseUser == null) return Stream.value(null);
  return _userRepository.watchUser(firebaseUser.uid);
});

// Auth actions
final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

class AuthService {
  AuthService(Ref ref);

  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    await _userRepository.getOrCreateUser(credential.user!.uid);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // user cancelled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final currentUser = FirebaseAuth.instance.currentUser;
    UserCredential result;

    if (currentUser != null && currentUser.isAnonymous) {
      // Link anonymous → Google
      result = await currentUser.linkWithCredential(credential);
    } else {
      result = await FirebaseAuth.instance.signInWithCredential(credential);
    }

    await _userRepository.updateProfile(
      result.user!.uid,
      email: result.user!.email,
      displayName: result.user!.displayName,
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.isAnonymous) {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      final result = await currentUser.linkWithCredential(credential);
      await _userRepository.updateProfile(result.user!.uid, email: email);
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.isAnonymous) {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      final result = await currentUser.linkWithCredential(credential);
      await _userRepository.updateProfile(result.user!.uid, email: email);
    } else {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _userRepository.getOrCreateUser(result.user!.uid);
    }
  }

  Future<void> acceptTos() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _userRepository.acceptTos(uid);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
