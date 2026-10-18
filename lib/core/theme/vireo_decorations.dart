import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Shared premium card shadows, gradients, and radii.
abstract final class VireoDecorations {
  static const cardRadius = 16.0;
  static const glassRadius = 24.0;
  static const buttonRadius = 14.0;
  static const chipRadius = 20.0;

  static List<BoxShadow> cardShadow({Color? glow}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        if (glow != null)
          BoxShadow(
            color: glow.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
      ];

  static BoxShadow get softCardShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 16,
        offset: const Offset(0, 4),
      );

  static BoxDecoration glassCardDecoration({
    required Brightness brightness,
    Color? accent,
  }) {
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? Colors.black.withValues(alpha: 0.08)
          : Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(glassRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.15),
      ),
      boxShadow: [softCardShadow],
    );
  }

  static BoxDecoration glowButtonDecoration(Color accent) => BoxDecoration(
        borderRadius: BorderRadius.circular(buttonRadius),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static Widget glassCard({
    required Widget child,
    required VireoColors colors,
    required Brightness brightness,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Color? accentBorder,
  }) {
    final borderColor =
        accentBorder?.withValues(alpha: 0.08) ??
            colors.ember.withValues(alpha: 0.08);
    return ClipRRect(
      borderRadius: BorderRadius.circular(glassRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(glassRadius),
            border: Border.all(color: borderColor),
            boxShadow: [softCardShadow],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }

  static LinearGradient cardGradient(VireoColors colors) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.surfaceGradientStart, colors.surfaceGradientEnd],
      );

  static LinearGradient emberGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFC9622E)],
  );

  static LinearGradient streakGradient = const LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFC9A24B)],
  );

  static LinearGradient titleGradient(VireoColors colors) => LinearGradient(
        colors: [colors.text, colors.ember.withValues(alpha: 0.85)],
      );

  static LinearGradient mealThumbnail(VireoColors colors) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors.ember.withValues(alpha: 0.85),
          colors.gold.withValues(alpha: 0.65),
        ],
      );

  static BoxDecoration premiumCard(
    VireoColors colors, {
    bool glow = false,
    Gradient? gradient,
    Brightness brightness = Brightness.dark,
  }) =>
      BoxDecoration(
        gradient: gradient ?? cardGradient(colors),
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: glow
              ? colors.ember.withValues(alpha: 0.08)
              : colors.line.withValues(alpha: 0.6),
        ),
        boxShadow: [
          softCardShadow,
          if (glow)
            BoxShadow(
              color: colors.ember.withValues(alpha: 0.12),
              blurRadius: 20,
            ),
        ],
      );

  static BoxDecoration darkElevatedCard(VireoColors colors) => BoxDecoration(
        color: const Color(0xFF050505),
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: colors.ember.withValues(alpha: 0.08)),
        boxShadow: [softCardShadow],
      );
}
