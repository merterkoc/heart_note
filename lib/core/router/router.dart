import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_note/core/router/nav_bar.dart';
import '../../features/message/presentation/pages/home_page.dart';
import '../../features/message/presentation/pages/note_detail_page.dart';
import '../../features/message/presentation/pages/message_result_page.dart';
import '../../core/entities/message_category.dart';
import '../../features/message/presentation/pages/history_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

// Custom observer for logging navigation events
class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('Navigation: Pushed ${route.settings.name ?? 'unknown'} '
          '(from ${previousRoute?.settings.name ?? 'unknown'})');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('Navigation: Popped ${route.settings.name ?? 'unknown'} '
          '(to ${previousRoute?.settings.name ?? 'unknown'})');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (kDebugMode) {
      print('Navigation: Replaced ${oldRoute?.settings.name ?? 'unknown'} '
          'with ${newRoute?.settings.name ?? 'unknown'}');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (kDebugMode) {
      print('Navigation: Removed ${route.settings.name ?? 'unknown'} '
          '(from ${previousRoute?.settings.name ?? 'unknown'})');
    }
  }
}

final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true, // Built-in logging
  observers: [GoRouterObserver()], // Custom detailed logging
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              name: 'home', // Named routes for better logging
              builder: (context, state) => const HomePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'result/:category',
                  name: 'message_result',
                  builder: (context, state) {
                    final params = state.extra as Map<String, dynamic>;
                    return MessageResultPage(
                      category: params['category'] as MessageCategory,
                      selectedKeywords: params['keywords'] as List<String>,
                    );
                  },
                ),
                GoRoute(
                  path: 'note/:category',
                  name: 'note_detail',
                  builder: (context, state) {
                    final category = state.extra as MessageCategory;
                    return NoteDetailPage(category: category);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/history',
              name: 'history',
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
