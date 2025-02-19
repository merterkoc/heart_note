import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {
  final ThemeMode themeMode;

  const ToggleTheme(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class LoadTheme extends ThemeEvent {}
