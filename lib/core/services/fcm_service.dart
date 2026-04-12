import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/data/repositories/user_repository.dart';
import '../router/app_router.dart';

/// Top-level handler required by firebase_messaging for background messages.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are handled by the OS — no action needed here.
  debugPrint('FCM background message: ${message.messageId}');
}

class FcmService {
  FcmService._();

  static final _messaging = FirebaseMessaging.instance;
  static final _repo = UserRepository();

  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('FCM permission denied');
      return;
    }

    await _registerToken();

    // Refresh token when it rotates
    _messaging.onTokenRefresh.listen((token) async {
      await _saveToken(token);
    });

    // App opened by tapping a notification (foreground → background → tap)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // App launched cold from a notification
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleMessage(initial);
  }

  static Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) await _saveToken(token);
    } catch (e) {
      debugPrint('FCM get token failed: $e');
    }
  }

  static Future<void> _saveToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await _repo.updateFcmToken(uid, token);
      debugPrint('FCM token saved');
    } catch (e) {
      debugPrint('FCM save token failed: $e');
    }
  }

  static void _handleMessage(RemoteMessage message) {
    final route = message.data['route'] as String?;
    if (route == '/brief') {
      appRouter.go('/brief');
    }
  }
}
