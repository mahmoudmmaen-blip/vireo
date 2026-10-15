import 'package:flutter/material.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/home/living_backgrounds/domain/journey_stage.dart';

enum ScenePackId {
  // Standard 6 (rotate every 3 days)
  nile,
  desertDunes,
  mountains,
  seaWaves,
  nightSky,
  garden,

  // Special overrides
  ramadan,
  eid,
  streakReward,

  // Extra Premium (Coins tie-in: 300 coins or Pro)
  pharaonicGold,
  alexandriaAurora;

  bool get isPremium => this == ScenePackId.pharaonicGold || this == ScenePackId.alexandriaAurora;
  int get coinCost => isPremium ? 300 : 0;

  String displayName(bool isArabic) => switch (this) {
        ScenePackId.nile => isArabic ? 'نهر النيل' : 'Nile River',
        ScenePackId.desertDunes => isArabic ? 'كثبان الصحراء' : 'Desert Dunes',
        ScenePackId.mountains => isArabic ? 'قمم الجبال' : 'Mountains',
        ScenePackId.seaWaves => isArabic ? 'أمواج البحر' : 'Sea Waves',
        ScenePackId.nightSky => isArabic ? 'سماء الليل' : 'Night Sky',
        ScenePackId.garden => isArabic ? 'الواحة الخضراء' : 'Lush Garden',
        ScenePackId.ramadan => isArabic ? 'ليالي رمضان المبارك' : 'Ramadan Nights',
        ScenePackId.eid => isArabic ? 'بهجة العيد' : 'Festive Eid',
        ScenePackId.streakReward => isArabic ? 'شعلة الالتزام 🔥' : 'Streak Flame 🔥',
        ScenePackId.pharaonicGold => isArabic ? 'أفق الفراعنة الذهبي 👑' : 'Pharaonic Gold 👑',
        ScenePackId.alexandriaAurora => isArabic ? 'شفق الإسكندرية 🌅' : 'Alexandria Aurora 🌅',
      };

  String subtitle(bool isArabic) => switch (this) {
        ScenePackId.nile => isArabic ? 'ضفاف النيل الهادئة والمياه الرقراقة' : 'Calm riverbanks & flowing waters',
        ScenePackId.desertDunes => isArabic ? 'تموجات رمال ذهبية أصيلة' : 'Golden undulating desert sands',
        ScenePackId.mountains => isArabic ? 'قمم سيناء الشامخة' : 'Majestic Sinai mountain ridges',
        ScenePackId.seaWaves => isArabic ? 'نسيم المتوسط وأمواجه المتتابعة' : 'Mediterranean waves and coastal breeze',
        ScenePackId.nightSky => isArabic ? 'نجوم القاهرة المتلألئة' : 'Twinkling Cairo stars and moon',
        ScenePackId.garden => isArabic ? 'طبيعة الدلتا والواحات الغنّاء' : 'Lush greenery and tranquil palms',
        ScenePackId.ramadan => isArabic ? 'فانوس رمضان وهلال البركة' : 'Crescent moon & festive lantern',
        ScenePackId.eid => isArabic ? 'أنوار وألعاب نارية احتفالية' : 'Festive lights & celebration sparkles',
        ScenePackId.streakReward => isArabic ? 'مكافأة 7 أيام التزام مستمر' : 'Reward for 7+ days streak',
        ScenePackId.pharaonicGold => isArabic ? 'حضارة ذهبية خالدة (300 نقطة)' : 'Ancient gilded glory (300 coins)',
        ScenePackId.alexandriaAurora => isArabic ? 'غروب ساحر ومنارة الإسكندرية (300 نقطة)' : 'Coastal dusk & lighthouse (300 coins)',
      };
}

class ScenePackPalette {
  const ScenePackPalette({
    required this.skyGradient,
    required this.sunOrMoonColor,
    required this.sunHaloColor,
    required this.distantTerrainColor,
    required this.midTerrainColor,
    required this.foregroundPathColor,
    required this.landmarkColor,
  });

  final List<Color> skyGradient;
  final Color sunOrMoonColor;
  final Color sunHaloColor;
  final Color distantTerrainColor;
  final Color midTerrainColor;
  final Color foregroundPathColor;
  final Color landmarkColor;
}

class ScenePack {
  const ScenePack({required this.id});

  final ScenePackId id;

  /// The 6 standard rotating packs in order.
  static const standardPacks = <ScenePackId>[
    ScenePackId.nile,
    ScenePackId.desertDunes,
    ScenePackId.mountains,
    ScenePackId.seaWaves,
    ScenePackId.nightSky,
    ScenePackId.garden,
  ];

  /// Deterministically picks a pack every 3 days based on UTC days since epoch.
  static ScenePackId rotatingPackForDate(DateTime date) {
    final daysSinceEpoch = date.toUtc().millisecondsSinceEpoch ~/ 86400000;
    final index = (daysSinceEpoch ~/ 3) % standardPacks.length;
    return standardPacks[index];
  }

  /// Determines the active pack given options, dates, and overrides.
  static ScenePackId resolveActive({
    required DateTime date,
    required bool isEnabled,
    ScenePackId? fixedPack,
    bool isRamadan = false,
    bool isEid = false,
    int streakDays = 0,
    bool isPro = false,
    Set<ScenePackId> unlockedCoinPacks = const {},
  }) {
    if (!isEnabled) {
      return ScenePackId.nile;
    }

    // 1. Explicit fixed pack choice takes precedence
    if (fixedPack != null) {
      if (fixedPack.isPremium) {
        final canUse = isPro || unlockedCoinPacks.contains(fixedPack);
        if (canUse) return fixedPack;
      } else {
        return fixedPack;
      }
    }

    // 2. Special seasonal overrides
    if (isRamadan) return ScenePackId.ramadan;
    if (isEid) return ScenePackId.eid;
    if (streakDays >= 7) return ScenePackId.streakReward;

    // 3. Deterministic 3-day rotation
    return rotatingPackForDate(date);
  }

  /// Generates the painting palette for a given step journey stage and theme variant.
  ScenePackPalette paletteFor(JourneyStage stage, AppThemeVariant variant, bool isDark) {
    final themeAccent = variant.primaryAccent;
    final themeSecondary = variant.secondaryAccent;

    return switch (id) {
      ScenePackId.nile => _buildNilePalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.desertDunes => _buildDesertPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.mountains => _buildMountainsPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.seaWaves => _buildSeaPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.nightSky => _buildNightPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.garden => _buildGardenPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.ramadan => _buildRamadanPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.eid => _buildEidPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.streakReward => _buildStreakPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.pharaonicGold => _buildPharaonicPalette(stage, themeAccent, themeSecondary, isDark),
      ScenePackId.alexandriaAurora => _buildAuroraPalette(stage, themeAccent, themeSecondary, isDark),
    };
  }

  /// Palette for MealCaptureHeroCard depending on meal slot and Ramadan.
  List<Color> mealCaptureGradient({
    required MealType slot,
    required bool isRamadan,
    required AppThemeVariant variant,
    required bool isDark,
  }) {
    final accent = variant.primaryAccent;

    if (isRamadan) {
      // Suhoor (soft night blue/indigo) vs Iftar (warm celebratory amber/gold)
      final nowHour = DateTime.now().hour;
      final isSuhoor = nowHour >= 22 || nowHour < 6;
      if (isSuhoor) {
        return [
          const Color(0xFF1E1B4B),
          const Color(0xFF312E81),
          accent.withValues(alpha: 0.6),
        ];
      } else {
        return [
          const Color(0xFF78350F),
          const Color(0xFFB45309),
          const Color(0xFFD97706),
        ];
      }
    }

    return switch (slot) {
      MealType.breakfast => [
          // Soft morning sunrise pastel tone
          isDark ? const Color(0xFF431407) : const Color(0xFFFFF7ED),
          accent.withValues(alpha: isDark ? 0.85 : 0.9),
          isDark ? const Color(0xFF7C2D12) : const Color(0xFFFDBA74),
        ],
      MealType.lunch => [
          // Bright energetic midday tone
          isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7),
          accent,
          isDark ? const Color(0xFFB45309) : const Color(0xFFF59E0B),
        ],
      MealType.dinner => [
          // Calm soothing evening twilight
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          accent.withValues(alpha: 0.8),
          isDark ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
        ],
      MealType.snack => [
          isDark ? const Color(0xFF1C1917) : const Color(0xFFFAFAF9),
          accent.withValues(alpha: 0.85),
          isDark ? const Color(0xFF292524) : const Color(0xFFD6D3D1),
        ],
    };
  }

  // ── Palette builders ────────────────────────────────────────────────────────

  static ScenePackPalette _buildNilePalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [const Color(0xFF0C1B2A), const Color(0xFF16324F), const Color(0xFF1F4E79)],
      JourneySkyTime.morning => [const Color(0xFF133E68), const Color(0xFF1E5F8A), const Color(0xFF4A90E2)],
      JourneySkyTime.noon => [const Color(0xFF0E4C7A), const Color(0xFF2A7FB8), const Color(0xFF5BA4CF)],
      JourneySkyTime.golden => [const Color(0xFF281C3E), const Color(0xFF6B3A5B), const Color(0xFFD97736)],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: stage.isNightOrDawn ? const Color(0xFFE2E8F0) : const Color(0xFFFFD166),
      sunHaloColor: stage.isNightOrDawn ? const Color(0x33CBD5E1) : const Color(0x4DFFA726),
      distantTerrainColor: const Color(0xFF0D283E),
      midTerrainColor: const Color(0xFF0F3B56),
      foregroundPathColor: const Color(0xFF185375),
      landmarkColor: const Color(0xFFE2E8F0),
    );
  }

  static ScenePackPalette _buildDesertPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [const Color(0xFF24141E), const Color(0xFF4A2535), const Color(0xFF8C4646)],
      JourneySkyTime.morning => [const Color(0xFF5A2A18), const Color(0xFF9E4B27), const Color(0xFFD97736)],
      JourneySkyTime.noon => [const Color(0xFF804E19), const Color(0xFFB87828), const Color(0xFFE4AC42)],
      JourneySkyTime.golden => [const Color(0xFF381418), const Color(0xFF7A2522), const Color(0xFFD4622B)],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: stage.isNightOrDawn ? const Color(0xFFFDE68A) : const Color(0xFFFFFBEB),
      sunHaloColor: const Color(0x4DF59E0B),
      distantTerrainColor: const Color(0xFF5C3317),
      midTerrainColor: const Color(0xFF7C441E),
      foregroundPathColor: const Color(0xFFA15E28),
      landmarkColor: const Color(0xFFFEF3C7),
    );
  }

  static ScenePackPalette _buildMountainsPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [const Color(0xFF171926), const Color(0xFF282B42), const Color(0xFF3F4466)],
      JourneySkyTime.morning => [const Color(0xFF1F2B3E), const Color(0xFF304563), const Color(0xFF4A6B94)],
      JourneySkyTime.noon => [const Color(0xFF1C3A5A), const Color(0xFF32608E), const Color(0xFF5188BD)],
      JourneySkyTime.golden => [const Color(0xFF2E1929), const Color(0xFF5A2C46), const Color(0xFFAB5E63)],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: stage.isNightOrDawn ? const Color(0xFFE0E7FF) : const Color(0xFFFEF08A),
      sunHaloColor: const Color(0x33818CF8),
      distantTerrainColor: const Color(0xFF1E2235),
      midTerrainColor: const Color(0xFF2B314B),
      foregroundPathColor: const Color(0xFF3B4466),
      landmarkColor: const Color(0xFFE0E7FF),
    );
  }

  static ScenePackPalette _buildSeaPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [const Color(0xFF0A1826), const Color(0xFF102A45), const Color(0xFF1A476F)],
      JourneySkyTime.morning => [const Color(0xFF0F3252), const Color(0xFF195587), const Color(0xFF2A7FC0)],
      JourneySkyTime.noon => [const Color(0xFF10436C), const Color(0xFF1D6AA3), const Color(0xFF399BE2)],
      JourneySkyTime.golden => [const Color(0xFF1F1C36), const Color(0xFF4B325E), const Color(0xFFC76950)],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: const Color(0xFFE0F2FE),
      sunHaloColor: const Color(0x3338BDF8),
      distantTerrainColor: const Color(0xFF0B2136),
      midTerrainColor: const Color(0xFF0F3657),
      foregroundPathColor: const Color(0xFF165282),
      landmarkColor: const Color(0xFFBAE6FD),
    );
  }

  static ScenePackPalette _buildNightPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [Color(0xFF070B14), Color(0xFF0E1626), Color(0xFF152238)],
      sunOrMoonColor: const Color(0xFFF1F5F9),
      sunHaloColor: const Color(0x3394A3B8),
      distantTerrainColor: const Color(0xFF0A101D),
      midTerrainColor: const Color(0xFF101B2E),
      foregroundPathColor: const Color(0xFF192A45),
      landmarkColor: const Color(0xFFF8FAFC),
    );
  }

  static ScenePackPalette _buildGardenPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [const Color(0xFF111E18), const Color(0xFF1B332A), const Color(0xFF284F41)],
      JourneySkyTime.morning => [const Color(0xFF1A3528), const Color(0xFF2A5741), const Color(0xFF3E805E)],
      JourneySkyTime.noon => [const Color(0xFF184232), const Color(0xFF2A6E52), const Color(0xFF44A076)],
      JourneySkyTime.golden => [const Color(0xFF2A2416), const Color(0xFF574624), const Color(0xFF9E7B36)],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: const Color(0xFFFEF3C7),
      sunHaloColor: const Color(0x3334D399),
      distantTerrainColor: const Color(0xFF10281F),
      midTerrainColor: const Color(0xFF163E2F),
      foregroundPathColor: const Color(0xFF1E5841),
      landmarkColor: const Color(0xFFD1FAE5),
    );
  }

  static ScenePackPalette _buildRamadanPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [Color(0xFF100E29), Color(0xFF1F1A4D), Color(0xFF2E246B)],
      sunOrMoonColor: const Color(0xFFFFE082),
      sunHaloColor: const Color(0x55FFD54F),
      distantTerrainColor: const Color(0xFF161338),
      midTerrainColor: const Color(0xFF231E54),
      foregroundPathColor: const Color(0xFF37307A),
      landmarkColor: const Color(0xFFFFD54F),
    );
  }

  static ScenePackPalette _buildEidPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [Color(0xFF210F33), Color(0xFF3F175E), Color(0xFF6B21A8)],
      sunOrMoonColor: const Color(0xFFFDE047),
      sunHaloColor: const Color(0x4DC084FC),
      distantTerrainColor: const Color(0xFF29123D),
      midTerrainColor: const Color(0xFF431C63),
      foregroundPathColor: const Color(0xFF632891),
      landmarkColor: const Color(0xFFFDE047),
    );
  }

  static ScenePackPalette _buildStreakPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [Color(0xFF3B1009), Color(0xFF6E1B0E), Color(0xFFB91C1C)],
      sunOrMoonColor: const Color(0xFFFEF08A),
      sunHaloColor: const Color(0x66F97316),
      distantTerrainColor: const Color(0xFF45140D),
      midTerrainColor: const Color(0xFF6B1D11),
      foregroundPathColor: const Color(0xFF992B19),
      landmarkColor: const Color(0xFFFEF08A),
    );
  }

  static ScenePackPalette _buildPharaonicPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [Color(0xFF291E0B), Color(0xFF543D15), Color(0xFF8A651E)],
      sunOrMoonColor: const Color(0xFFFFE57F),
      sunHaloColor: const Color(0x66FFC107),
      distantTerrainColor: const Color(0xFF3D2B0E),
      midTerrainColor: const Color(0xFF5E4317),
      foregroundPathColor: const Color(0xFF8A6424),
      landmarkColor: const Color(0xFFFFE57F),
    );
  }

  static ScenePackPalette _buildAuroraPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [Color(0xFF1E1035), Color(0xFF431D61), Color(0xFF86198F)],
      sunOrMoonColor: const Color(0xFFFBCFE8),
      sunHaloColor: const Color(0x4DF472B6),
      distantTerrainColor: const Color(0xFF2A1547),
      midTerrainColor: const Color(0xFF472173),
      foregroundPathColor: const Color(0xFF6D2F9E),
      landmarkColor: const Color(0xFFFDF2F8),
    );
  }
}
