import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vireo/core/services/accent_palette_provider.dart';
import 'package:vireo/core/services/app_skin_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';

/// Dark and light theme configuration for Vireo.
abstract final class AppTheme {
  static ThemeData get dark => darkWithAccent();
  static ThemeData get light => lightWithAccent();

  static ThemeData darkWithAccent([
    AccentPalette accent = AccentPalette.vireoOrange,
    AppSkin skin = AppSkin.standard,
  ]) {
    final base = switch (skin) {
      AppSkin.standard => VireoColors.dark.withAccent(accent.color),
      AppSkin.amoled => VireoColors.amoled,
      AppSkin.navy => VireoColors.navy,
    };
    return _build(base, Brightness.dark);
  }

  static ThemeData lightWithAccent([
    AccentPalette accent = AccentPalette.vireoOrange,
  ]) =>
      _build(VireoColors.light.withAccent(accent.color), Brightness.light);

  static ThemeData _build(VireoColors colors, Brightness brightness) {
    final cairo = GoogleFonts.cairoTextTheme();
    final tajawal = GoogleFonts.tajawalTextTheme();

    TextStyle heading(TextStyle? base) => (base ?? const TextStyle()).copyWith(
          fontFamily: GoogleFonts.cairo().fontFamily,
          fontWeight: FontWeight.w800,
          color: colors.text,
        );

    TextStyle body(TextStyle? base) => (base ?? const TextStyle()).copyWith(
          fontFamily: GoogleFonts.tajawal().fontFamily,
          color: colors.text,
        );

    final textTheme = TextTheme(
      displayLarge: heading(cairo.displayLarge),
      displayMedium: heading(cairo.displayMedium),
      displaySmall: heading(cairo.displaySmall),
      headlineLarge: heading(cairo.headlineLarge),
      headlineMedium: heading(cairo.headlineMedium),
      headlineSmall: heading(cairo.headlineSmall),
      titleLarge: heading(cairo.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      titleMedium: body(tajawal.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      titleSmall: body(tajawal.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      bodyLarge: body(tajawal.bodyLarge),
      bodyMedium: body(tajawal.bodyMedium),
      bodySmall: body(tajawal.bodySmall?.copyWith(color: colors.textMute)),
      labelLarge: body(tajawal.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
      labelMedium: body(tajawal.labelMedium?.copyWith(color: colors.textMute)),
      labelSmall: body(tajawal.labelSmall?.copyWith(color: colors.textMute)),
    );

    final colorScheme = brightness == Brightness.dark
        ? ColorScheme.dark(
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
          )
        : ColorScheme.light(
            surface: colors.surface,
            primary: colors.ember,
            secondary: colors.gold,
            error: colors.danger,
            onSurface: colors.text,
            onPrimary: Colors.white,
            onSecondary: colors.text,
            onError: Colors.white,
            surfaceContainerHighest: colors.surfaceRaised,
            outline: colors.line,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: colorScheme,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: heading(cairo.titleLarge),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceRaised,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
          side: BorderSide(color: colors.line.withValues(alpha: 0.75)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.ember.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return body(tajawal.labelSmall).copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.ember,
        foregroundColor: colors.text,
      ),
      dividerTheme: DividerThemeData(color: colors.line),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceRaised,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VireoDecorations.buttonRadius),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colors.textMute),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.ember,
          foregroundColor: brightness == Brightness.dark ? colors.text : Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VireoDecorations.buttonRadius),
          ),
          elevation: 4,
          shadowColor: colors.ember.withValues(alpha: 0.35),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.ember,
          side: BorderSide(color: colors.line),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VireoDecorations.buttonRadius),
          ),
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
        contentTextStyle: body(tajawal.bodyMedium),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
