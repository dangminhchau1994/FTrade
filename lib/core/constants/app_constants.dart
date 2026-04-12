import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  AppConstants._();

  static const String appName = 'FTrade';
  static const String appVersion = '1.0.0';

  /// Enable Firebase emulator suite in debug mode.
  /// Set to false to hit production even in debug builds.
  static const bool useEmulators = false; // Dùng Firebase production + Vercel backend

  static const String emulatorHost = '127.0.0.1';

  /// Localhost alias: iOS simulator needs 127.0.0.1, Android emulator needs 10.0.2.2
  static String get emulatorHostForDevice {
    if (kIsWeb) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return '127.0.0.1';
  }

  static const int firestoreEmulatorPort = 8080;
  static const int authEmulatorPort = 9099;
  static const int functionsEmulatorPort = 5001;

  static const String firebaseProjectId = 'ftrade-209d5';
  static const String firebaseRegion = 'asia-southeast1';

  /// Vercel backend URL — set production URL after deploy
  static const String _vercelProductionUrl = 'https://ftrade-backend.vercel.app'; // deployed 2026-04-12

  static String get functionsBaseUrl {
    if (useEmulators) {
      // Local Vercel dev: `vercel dev` runs on port 3000
      return 'http://$emulatorHostForDevice:3000/api';
    }
    return '$_vercelProductionUrl/api';
  }
}
