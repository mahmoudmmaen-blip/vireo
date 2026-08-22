import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Shared premium card shadows, gradients, and radii.
abstract final class VireoDecorations {
  static const cardRadius = 16.0;
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

  static LinearGradient cardGradient(VireoColors colors) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.surfaceGradientStart, colors.surfaceGradientEnd],
      );

  static LinearGradient emberGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8763C), Color(0xFFC9622E)],
  );

  static LinearGradient streakGradient = const LinearGradient(
    colors: [Color(0xFFE8763C), Color(0xFFC9A24B)],
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
  }) =>
      BoxDecoration(
        gradient: gradient ?? cardGradient(colors),
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
        boxShadow: cardShadow(glow: glow ? colors.ember : null),
      );
}
