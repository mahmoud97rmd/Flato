import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/widgets/error_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/chart/presentation/pages/chart_page.dart';
import '../../features/trading/presentation/pages/trading_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(state.error.toString()),
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (c, s) => MaterialPage(child: HomePage()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (c, s) => MaterialPage(child: SettingsPage()),
    ),
    GoRoute(
      path: '/chart',
      pageBuilder: (c, s) {
        final symbol = s.queryParams['symbol'] ?? "";
        return MaterialPage(child: ChartPage(symbol: symbol));
      },
    ),
    GoRoute(
      path: '/trading',
      pageBuilder: (c, s) => MaterialPage(child: TradingPage()),
    ),
  ],
);
