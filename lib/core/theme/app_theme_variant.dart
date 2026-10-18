import 'package:flutter/material.dart';

/// App theme identities for Vireo:
/// 1. Ember (classic orange) — default for men.
/// 2. Calm Gold (charcoal background, warm gold/olive accents, white pill buttons) — default for women.
/// 3. Ocean (deep navy + teal).
/// 4. Rose (soft plum + rose, refined).
enum AppThemeVariant {
  ember,
  calmGold,
  ocean,
  rose;

  String get storageKey => name;

  static AppThemeVariant fromStorage(String? value, {bool isFemale = false}) {
    return AppThemeVariant.values.firstWhere(
      (v) => v.storageKey == value,
      orElse: () => isFemale ? AppThemeVariant.calmGold : AppThemeVariant.ember,
    );
  }

  String label(bool isArabic) => switch (this) {
        AppThemeVariant.ember => isArabic ? 'إمبر (برتقالي دافئ)' : 'Ember (Orange)',
        AppThemeVariant.calmGold => isArabic ? 'ذهب هادئ (شار كول وذهب)' : 'Calm Gold (Olive & Gold)',
        AppThemeVariant.ocean => isArabic ? 'أوشن (كحلي وتيل)' : 'Ocean (Deep Navy & Teal)',
        AppThemeVariant.rose => isArabic ? 'روز (برقوقي ووردي راقي)' : 'Rose (Plum & Rose)',
      };

  Color get primaryAccent => switch (this) {
        AppThemeVariant.ember => const Color(0xFFFF6B35),
        AppThemeVariant.calmGold => const Color(0xFFD4AF37),
        AppThemeVariant.ocean => const Color(0xFF00B4D8),
        AppThemeVariant.rose => const Color(0xFFD977A6),
      };

  Color get secondaryAccent => switch (this) {
        AppThemeVariant.ember => const Color(0xFFC9A24B),
        AppThemeVariant.calmGold => const Color(0xFF8F9E8B),
        AppThemeVariant.ocean => const Color(0xFF0077B6),
        AppThemeVariant.rose => const Color(0xFFA55B80),
      };
}
