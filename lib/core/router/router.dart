import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/message/presentation/pages/home_page.dart';
import '../../features/message/presentation/pages/note_detail_page.dart';
import '../../features/message/presentation/pages/message_result_page.dart';
import '../../core/entities/message_category.dart';
import '../../features/message/presentation/pages/history_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/note/:category',
      builder: (context, state) {
        final category = state.extra as MessageCategory;
        return NoteDetailPage(category: category);
      },
    ),
    GoRoute(
      path: '/result/:category',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        return MessageResultPage(
          category: params['category'] as MessageCategory,
          selectedKeywords: params['keywords'] as List<String>,
        );
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
  ],
);
