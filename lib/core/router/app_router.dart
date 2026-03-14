import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/market/presentation/screens/market_screen.dart';
import '../../features/market/presentation/screens/search_screen.dart';
import '../../features/market/presentation/screens/stock_detail_screen.dart';
import '../../features/news/presentation/screens/news_detail_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/watchlist/presentation/screens/watchlist_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/corporate/presentation/screens/corporate_screen.dart';
import '../../features/money_flow/presentation/screens/money_flow_screen.dart';
import '../../features/fundamental/presentation/screens/financial_statement_screen.dart';
import '../../features/fundamental/presentation/screens/industry_comparison_screen.dart';
import 'scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    // Full-screen routes (no bottom nav)
    GoRoute(
      path: '/stock/:symbol',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => StockDetailScreen(
        symbol: state.pathParameters['symbol']!,
      ),
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/news/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => NewsDetailScreen(
        id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/corporate',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CorporateScreen(),
    ),
    GoRoute(
      path: '/money-flow',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MoneyFlowScreen(),
    ),
    GoRoute(
      path: '/financials/:symbol',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => FinancialStatementScreen(
        symbol: state.pathParameters['symbol']!,
      ),
    ),
    GoRoute(
      path: '/comparison/:symbol',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => IndustryComparisonScreen(
        symbol: state.pathParameters['symbol']!,
      ),
    ),

    // Tab routes
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/market',
              builder: (context, state) => const MarketScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/news',
              builder: (context, state) => const NewsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/watchlist',
              builder: (context, state) => const WatchlistScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
