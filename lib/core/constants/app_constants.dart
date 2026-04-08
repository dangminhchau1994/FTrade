import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class AppConstants {
  AppConstants._();

  static const String appName = 'FTrade';
  static const String appVersion = '1.0.0';

  /// Enable Firebase emulator suite in debug mode.
  /// Set to false to hit production even in debug builds.
  static const bool useEmulators = kDebugMode;

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

  /// Functions base URL — switches between emulator and production
  static String get functionsBaseUrl {
    if (useEmulators) {
      return 'http://$emulatorHostForDevice:$functionsEmulatorPort/$firebaseProjectId/$firebaseRegion';
    }
    return 'https://$firebaseRegion-$firebaseProjectId.cloudfunctions.net';
  }
}
