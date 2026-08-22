import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Dark-only theme configuration for Vireo.
abstract final class AppTheme {
  static ThemeData get dark {
    const colors = VireoColors.dark;

    final colorScheme = ColorScheme.dark(
      surface: colors.surface,
      primary: colors.ember,
      secondary: colors.gold,
      error: colors.danger,
      onSurface: colors.text,
      onPrimary: colors.text,
      onSecondary: colors.background,
      onError: colors.text,
      surfaceContainerHighest: colors.surfaceRaised,
      outline: colors.line,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.background,
      colorScheme: colorScheme,
      extensions: const [VireoColors.dark],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.text,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.ember,
        foregroundColor: colors.text,
      ),
      dividerTheme: DividerThemeData(color: colors.line),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: colors.text),
        titleSmall: TextStyle(color: colors.text),
        bodyLarge: TextStyle(color: colors.text),
        bodyMedium: TextStyle(color: colors.text),
        bodySmall: TextStyle(color: colors.textMute),
        labelLarge: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: colors.textMute),
        labelSmall: TextStyle(color: colors.textMute),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colors.textMute),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.ember,
          foregroundColor: colors.text,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.ember,
          minimumSize: const Size(48, 48),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.surfaceRaised,
        contentTextStyle: TextStyle(color: colors.text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
