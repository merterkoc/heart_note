import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_note/core/router/nav_bar.dart';
import 'package:heart_note/main.dart';
import '../../features/message/presentation/pages/home_page.dart';
import '../../features/message/presentation/pages/note_detail_page.dart';
import '../../features/message/presentation/pages/message_result_page.dart';
import '../../core/entities/message_category.dart';
import '../../features/message/presentation/pages/history_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import '../../features/message/presentation/pages/category_detail_page.dart';
import '../../features/message/presentation/pages/recipient_page.dart';
import '../../features/message/presentation/pages/tone_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';

// Define route names as enums
enum AppRoute {
  home('/', 'home'),
  message_result('result/:category', 'message_result'),
  note_detail('note/:category', 'note_detail'),
  history('/history', 'history'),
  settings('/settings', 'settings'),
  categoryDetail('/categoryDetail', 'categoryDetail'),
  recipient('/recipient', 'recipient'),
  tone('/tone', 'tone'),
  messageResult('/messageResult', 'messageResult'),
  onboarding('/onboarding', 'onboarding');

  const AppRoute(this.path, this.name);

  final String path;
  final String name;
}

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
  debugLogDiagnostics: true,
  // Built-in logging
  observers: [GoRouterObserver(), observer],
  // Custom detailed logging
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted && state.location != AppRoute.onboarding.path) {
      return AppRoute.onboarding.path;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoute.onboarding.path,
      name: AppRoute.onboarding.name,
      builder: (context, state) => const OnboardingPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoute.home.path,
              name: AppRoute.home.name, // Use enum name
              builder: (context, state) => const HomePage(),
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoute.message_result.path,
                  name: AppRoute.message_result.name, // Use enum name
                  builder: (context, state) {
                    final params = state.extra as Map<String, dynamic>;
                    return MessageResultPage(
                      tone: params['tone'] as String,
                      recipient: params['recipient'] as String,
                      category: params['category'] as MessageCategory,
                      selectedKeywords: params['keywords'] as List<String>,
                    );
                  },
                ),
                GoRoute(
                  path: AppRoute.note_detail.path,
                  name: AppRoute.note_detail.name, // Use enum name
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
              path: AppRoute.history.path,
              name: AppRoute.history.name, // Use enum name
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: AppRoute.settings.path,
              name: AppRoute.settings.name, // Use enum name
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.categoryDetail.path,
      name: AppRoute.categoryDetail.name, // Use enum name
      builder: (context, state) {
        final category = state.extra as MessageCategory;
        return CategoryDetailPage(category: category);
      },
    ),
    GoRoute(
      path: AppRoute.recipient.path,
      name: AppRoute.recipient.name, // Use enum name
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final selectedKeywords = extra['keywords'] as List<String>;
        final category = extra['category'] as MessageCategory;
        return RecipientPage(
          selectedKeywords: selectedKeywords,
          category: category,
        );
      },
    ),
    GoRoute(
      path: AppRoute.tone.path,
      name: AppRoute.tone.name, // Use enum name
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final selectedKeywords = extra['selectedKeywords'] as List<String>;
        final category = extra['category'] as MessageCategory;
        final recipient = extra['recipient'] as String;
        return TonePage(
          selectedKeywords: selectedKeywords,
          category: category,
          recipient: recipient,
        );
      },
    ),
    GoRoute(
      path: AppRoute.messageResult.path,
      name: AppRoute.messageResult.name, // Use enum name
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final selectedKeywords = extra['selectedKeywords'] as List<String>;
        final category = extra['category'] as MessageCategory;
        final recipient = extra['recipient'] as String;
        final tone = extra['tone'] as String;

        return MessageResultPage(
          category: category,
          selectedKeywords: selectedKeywords,
          recipient: recipient,
          tone: tone,
        );
      },
    ),
  ],
);
