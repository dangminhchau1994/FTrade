import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/storage/hive_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/connectivity_banner.dart';
import 'features/auth/data/repositories/user_repository.dart';
import 'features/market/presentation/providers/market_data_controller.dart';
import 'features/settings/presentation/providers/theme_provider.dart';
import 'features/watchlist/data/services/price_alert_monitor.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (AppConstants.useEmulators) {
    final host = AppConstants.emulatorHostForDevice;
    FirebaseFirestore.instance.useFirestoreEmulator(host, AppConstants.firestoreEmulatorPort);
    await FirebaseAuth.instance.useAuthEmulator(host, AppConstants.authEmulatorPort);
    debugPrint('🔧 Using Firebase emulators at $host');
  }

  await HiveStorage.init();
  await NotificationService.init();
  await _ensureAnonymousAuth();
  runApp(const ProviderScope(child: FTradeApp()));
}

/// Sign in anonymously if no user session exists.
/// Firestore user doc creation is best-effort — app continues even if unavailable.
Future<void> _ensureAnonymousAuth() async {
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    final credential = await auth.signInAnonymously();
    try {
      await UserRepository().getOrCreateUser(credential.user!.uid);
    } catch (_) {
      // Firestore unavailable on first launch — will retry next session
    }
  } else {
    // Already signed in — ensure Firestore doc exists (best-effort)
    try {
      await UserRepository().getOrCreateUser(auth.currentUser!.uid);
    } catch (_) {}
  }
}

class FTradeApp extends ConsumerStatefulWidget {
  const FTradeApp({super.key});

  @override
  ConsumerState<FTradeApp> createState() => _FTradeAppState();
}

class _FTradeAppState extends ConsumerState<FTradeApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(marketDataControllerProvider.notifier).connect();
      ref.read(priceAlertMonitorProvider);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(marketDataControllerProvider.notifier);
    if (state == AppLifecycleState.resumed) {
      controller.connect();
    } else if (state == AppLifecycleState.paused) {
      controller.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'FTrade',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) => ConnectivityBanner(child: child ?? const SizedBox()),
    );
  }
}
