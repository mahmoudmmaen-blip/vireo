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
    String languageCode = 'ar',
  ]) {
    final base = switch (skin) {
      AppSkin.standard => VireoColors.dark.withAccent(accent.color),
      AppSkin.amoled => VireoColors.amoled,
      AppSkin.navy => VireoColors.navy,
    };
    return _build(base, Brightness.dark, languageCode);
  }

  static ThemeData lightWithAccent([
    AccentPalette accent = AccentPalette.vireoOrange,
    String languageCode = 'ar',
  ]) =>
      _build(VireoColors.light.withAccent(accent.color), Brightness.light, languageCode);

  static ThemeData _build(VireoColors colors, Brightness brightness, [String languageCode = 'ar']) {
    final isArabic = languageCode.startsWith('ar');

    // Arabic locales: IBM Plex Sans Arabic; Latin locales: Inter
    final fontTheme = isArabic
        ? GoogleFonts.ibmPlexSansArabicTextTheme()
        : GoogleFonts.interTextTheme();

    TextStyle heading(TextStyle? base) => (base ?? const TextStyle()).copyWith(
          fontFamily: isArabic
              ? GoogleFonts.ibmPlexSansArabic().fontFamily
              : GoogleFonts.inter().fontFamily,
          fontWeight: FontWeight.w800,
          color: colors.text,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    TextStyle body(TextStyle? base) => (base ?? const TextStyle()).copyWith(
          fontFamily: isArabic
              ? GoogleFonts.ibmPlexSansArabic().fontFamily
              : GoogleFonts.inter().fontFamily,
          color: colors.text,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    final textTheme = TextTheme(
      displayLarge: heading(fontTheme.displayLarge),
      displayMedium: heading(fontTheme.displayMedium),
      displaySmall: heading(fontTheme.displaySmall),
      headlineLarge: heading(fontTheme.headlineLarge),
      headlineMedium: heading(fontTheme.headlineMedium),
      headlineSmall: heading(fontTheme.headlineSmall),
      titleLarge: heading(fontTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      titleMedium: body(fontTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      titleSmall: body(fontTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      bodyLarge: body(fontTheme.bodyLarge),
      bodyMedium: body(fontTheme.bodyMedium),
      bodySmall: body(fontTheme.bodySmall?.copyWith(color: colors.textMute)),
      labelLarge: body(fontTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
      labelMedium: body(fontTheme.labelMedium?.copyWith(color: colors.textMute)),
      labelSmall: body(fontTheme.labelSmall?.copyWith(color: colors.textMute)),
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
        titleTextStyle: heading(fontTheme.titleLarge),
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
          return body(fontTheme.labelSmall).copyWith(
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
        contentTextStyle: body(fontTheme.bodyMedium),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.ember,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          textStyle: body(fontTheme.labelLarge).copyWith(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VireoDecorations.buttonRadius),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: colors.textMute.withValues(alpha: 0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceRaised,
        side: BorderSide(color: colors.line),
        labelStyle: body(fontTheme.labelLarge).copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VireoDecorations.chipRadius),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
