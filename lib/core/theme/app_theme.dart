import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextStyle get _vt323Style => GoogleFonts.vt323();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
        brightness: Brightness.light,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.pink.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: _vt323Style.copyWith(
          fontSize: 28,
          color: Colors.pink,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: _vt323Style.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: _vt323Style.copyWith(
          fontSize: 20,
        ),
        bodyLarge: _vt323Style.copyWith(
          fontSize: 18,
        ),
      ),
      iconTheme: const IconThemeData(
        size: 32,
        color: Colors.pink,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
        brightness: Brightness.dark,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: Colors.pinkAccent.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: _vt323Style.copyWith(
          fontSize: 28,
          color: Colors.pinkAccent,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: _vt323Style.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.pinkAccent,
        ),
        titleMedium: _vt323Style.copyWith(
          fontSize: 20,
          color: Colors.pinkAccent,
        ),
        bodyLarge: _vt323Style.copyWith(
          fontSize: 18,
          color: Colors.white70,
        ),
      ),
      iconTheme: const IconThemeData(
        size: 32,
        color: Colors.pinkAccent,
      ),
    );
  }
}
