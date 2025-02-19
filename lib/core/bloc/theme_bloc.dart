import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences prefs;

  ThemeBloc({required this.prefs}) : super(const ThemeState(ThemeMode.light)) {
    on<ToggleTheme>(_onToggleTheme);
    on<LoadTheme>(_onLoadTheme);
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    await prefs.setString('themeMode', event.themeMode.toString());
    emit(ThemeState(event.themeMode));
  }

  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final savedMode = prefs.getString('themeMode');
    if (savedMode != null) {
      emit(ThemeState(
        savedMode == ThemeMode.dark.toString()
            ? ThemeMode.dark
            : ThemeMode.light,
      ));
    }
  }
}
