import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/storage/hive_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/market/presentation/providers/market_data_controller.dart';
import 'features/settings/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
  runApp(const ProviderScope(child: FTradeApp()));
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
    // Auto-connect WebSocket realtime khi app khởi động
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(marketDataControllerProvider.notifier).connect();
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
    );
  }
}
