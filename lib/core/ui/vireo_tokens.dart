import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Spacing scale (4pt grid). Use these instead of magic numbers.
abstract final class VSpace {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal page gutter.
  static const double gutter = 20;
}

/// Corner radius scale.
abstract final class VRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;
  static const double pill = 999;
}

/// Motion tokens — keep animations consistent across the app.
abstract final class VMotion {
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration base = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 520);
  static const Duration ring = Duration(milliseconds: 1100);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
  static const Curve spring = Curves.elasticOut;
}

/// Semantic macro colours (shared by rings, bars, chips, charts).
abstract final class VMacro {
  static const Color protein = Color(0xFF5B9DFF);
  static const Color carbs = Color(0xFFF5A524);
  static const Color fat = Color(0xFFFF6B8A);
  static const Color water = Color(0xFF38BDF8);
  static const Color steps = Color(0xFF34D399);
  static const Color ai = Color(0xFF8B5CF6);
}

/// Numeric display styles — tabular figures so counters don't jitter.
abstract final class VType {
  static TextStyle number({
    double size = 28,
    FontWeight weight = FontWeight.w700,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing ?? -0.5,
      height: 1.0,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  /// Small uppercase-ish overline label.
  static TextStyle overline(BuildContext context, {Color? color}) {
    final colors = context.vireoColors;
    return TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
      color: color ?? colors.textMute,
    );
  }
}

extension VireoBrightness on BuildContext {
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
}
