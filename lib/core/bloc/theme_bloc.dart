import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {}

class LoadTheme extends ThemeEvent {}

// States
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

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
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString('themeMode', newMode.toString());
    emit(ThemeState(newMode));
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
