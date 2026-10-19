import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

/// WCAG AA Contrast and Luminance utilities for automatic readability scrims.
abstract final class ScrimContrast {
  /// Converts an 8-bit sRGB color component (0..255) to linear luminance.
  static double _channelToLinear(int channel8) {
    final s = channel8 / 255.0;
    if (s <= 0.03928) {
      return s / 12.92;
    } else {
      return math.pow((s + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// Calculates the relative luminance of a color according to W3C WCAG 2.1 specifications.
  /// Normalized to [0.0..1.0].
  static double relativeLuminance(Color color) {
    final r = _channelToLinear((color.r * 255).round().clamp(0, 255));
    final g = _channelToLinear((color.g * 255).round().clamp(0, 255));
    final b = _channelToLinear((color.b * 255).round().clamp(0, 255));
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculates the WCAG contrast ratio between two colors (e.g. text vs composite background).
  /// Result is between 1.0 and 21.0.
  static double contrastRatio(Color c1, Color c2) {
    final l1 = relativeLuminance(c1);
    final l2 = relativeLuminance(c2);
    final lighter = math.max(l1, l2);
    final darker = math.min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Composites a translucent top color over an opaque bottom color.
  static Color composite(Color top, Color bottom) {
    final alpha = top.a;
    final invAlpha = 1.0 - alpha;

    final r = (top.r * alpha + bottom.r * invAlpha).clamp(0.0, 1.0);
    final g = (top.g * alpha + bottom.g * invAlpha).clamp(0.0, 1.0);
    final b = (top.b * alpha + bottom.b * invAlpha).clamp(0.0, 1.0);

    return Color.from(alpha: 1.0, red: r, green: g, blue: b);
  }

  /// Evaluates whether foreground text meets the WCAG AA requirement (>= 4.5:1)
  /// over the scene background with the given scrim applied.
  static bool meetsWcagAA({
    required Color foregroundText,
    required Color backgroundScene,
    required Color scrimColor,
  }) {
    final compositeBackground = composite(scrimColor, backgroundScene);
    final ratio = contrastRatio(foregroundText, compositeBackground);
    return ratio >= 4.5;
  }

  /// Standard dark scrim gradient used for the living steps card.
  /// Top opacity is 0.45 to reveal the atmospheric sky/sun, while the body and bottom
  /// transition to 0.85 opacity over dark slate to guarantee WCAG AA contrast (>= 4.5:1)
  /// for white text regardless of the scene colors underneath.
  static LinearGradient standardStepsScrim({Color? baseColor}) {
    final base = baseColor ?? VBridge.cFF0B1320;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        base.withValues(alpha: 0.45),
        base.withValues(alpha: 0.70),
        base.withValues(alpha: 0.88),
      ],
      stops: const [0.0, 0.45, 1.0],
    );
  }
}
