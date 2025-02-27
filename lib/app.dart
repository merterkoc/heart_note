import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heart_note/core/bloc/theme_bloc.dart';
import 'package:heart_note/core/bloc/theme_event.dart';
import 'package:heart_note/core/bloc/theme_state.dart';
import 'package:heart_note/core/router/router.dart';
import 'package:heart_note/core/theme/app_theme.dart';
import 'package:heart_note/features/message/data/message_repository.dart';
import 'package:heart_note/features/message/presentation/bloc/history_bloc.dart';
import 'package:heart_note/features/message/presentation/bloc/history_event.dart';
import 'package:heart_note/features/message/presentation/bloc/message_bloc.dart';
import 'package:heart_note/features/message/presentation/bloc/message_event.dart';
import 'package:heart_note/features/special_days/bloc/special_day_bloc.dart';
import 'package:heart_note/features/special_days/bloc/special_day_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeartNoteApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseAnalytics analytics;

  const HeartNoteApp({super.key, required this.prefs, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => ThemeBloc(prefs: prefs)..add(LoadTheme()),
        ),
        BlocProvider(
          create: (context) => MessageBloc(
            repository: MessageRepository(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) => SpecialDayBloc()..add(LoadSpecialDays()),
        ),
        BlocProvider(
          create: (context) => HistoryBloc()..add(LoadHistory()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return CupertinoApp.router(
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            title: 'Heart Note',
            theme: state.themeMode == ThemeMode.light
                ? AppTheme.cupertinoLightTheme
                : AppTheme.cupertinoDarkTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}

class MessageCategory {
  final String title;
  final IconData icon;
  final String description;

  const MessageCategory({
    required this.title,
    required this.icon,
    required this.description,
  });
}

final List<MessageCategory> categories = [
  MessageCategory(
    title: 'Sevgililer Günü',
    icon: Icons.favorite,
    description: 'Aşkınızı ifade eden özel mesajlar',
  ),
  MessageCategory(
    title: 'Doğum Günü',
    icon: Icons.cake,
    description: 'Doğum günü kutlama mesajları',
  ),
  MessageCategory(
    title: 'Yıldönümü',
    icon: Icons.celebration,
    description: 'Özel günleriniz için anlamlı notlar',
  ),
  // ... diğer kategoriler
];
