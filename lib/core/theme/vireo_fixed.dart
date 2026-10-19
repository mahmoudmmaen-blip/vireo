import 'package:flutter/material.dart';

/// Named non-theme hues used across painters, charts, and feature widgets.
/// Prefer [VireoColors] / [VMacro] when a semantic theme token exists.
abstract final class VFixed {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color nearBlack = Color(0xFF1A1A1A);
  static const Color charcoal = Color(0xFF1E2124);
  static const Color charcoalDeep = Color(0xFF141618);

  static const Color goldStar = Color(0xFFFFD700);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberSoft = Color(0xFFFBBF24);
  static const Color warning = Color(0xFFF97316);

  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldDeep = Color(0xFF064E3B);
  static const Color emeraldBright = Color(0xFF34D399);

  static const Color cyan = Color(0xFF38BDF8);
  static const Color sky = Color(0xFF0EA5E9);
  static const Color indigo = Color(0xFF6366F1);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color rose = Color(0xFFEF4444);
  static const Color cheekPink = Color(0xFFFFB4A2);

  static const Color slate = Color(0xFF1E293B);
  static const Color slateMid = Color(0xFF2C3E55);
  static const Color slateDeep = Color(0xFF223048);
  static const Color slateMute = Color(0xFF9CA3AF);
  static const Color slateMuteDark = Color(0xFF6B7280);
  static const Color gray50 = Color(0xFFF9FAFB);

  /// Accent orange — CTA / FAB / today marker only (P50).
  static const Color accentOrange = Color(0xFFE8763C);
  static const Color accentOrangeBright = Color(0xFFFF6B35);
}
