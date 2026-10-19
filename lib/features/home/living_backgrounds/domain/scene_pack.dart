import 'package:flutter/material.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/home/living_backgrounds/domain/journey_stage.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

enum ScenePackId {
  // Standard 6 (rotate every 3 days)
  nile,
  desertDunes,
  mountains,
  seaWaves,
  nightSky,
  garden,

  // Special overrides (P40 seasonal: Ramadan lantern free in Ramadan, Eid, winter)
  ramadan,
  eid,
  winter,
  streakReward,

  // Extra Premium (Coins tie-in: 300 coins or Pro)
  pharaonicGold,
  alexandriaAurora;

  bool get isPremium => this == ScenePackId.pharaonicGold || this == ScenePackId.alexandriaAurora;
  int get coinCost => isPremium ? 300 : 0;

  /// Free during Ramadan even for free users (P40 seasonal mascot pack).
  bool get isRamadanFree => this == ScenePackId.ramadan;

  String displayName(bool isArabic) => switch (this) {
        ScenePackId.nile => isArabic ? 'نهر النيل' : 'Nile River',
        ScenePackId.desertDunes => isArabic ? 'كثبان الصحراء' : 'Desert Dunes',
        ScenePackId.mountains => isArabic ? 'قمم الجبال' : 'Mountains',
        ScenePackId.seaWaves => isArabic ? 'أمواج البحر' : 'Sea Waves',
        ScenePackId.nightSky => isArabic ? 'سماء الليل' : 'Night Sky',
        ScenePackId.garden => isArabic ? 'الواحة الخضراء' : 'Lush Garden',
        ScenePackId.ramadan => isArabic ? 'ليالي رمضان المبارك' : 'Ramadan Nights',
        ScenePackId.eid => isArabic ? 'بهجة العيد' : 'Festive Eid',
        ScenePackId.winter => isArabic ? 'شتا دافي' : 'Cozy Winter',
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
        ScenePackId.ramadan => isArabic ? 'الجمل مع فانوس رمضان وهلال البركة' : 'Camel with Ramadan lantern & crescent',
        ScenePackId.eid => isArabic ? 'أنوار وألعاب نارية احتفالية' : 'Festive lights & celebration sparkles',
        ScenePackId.winter => isArabic ? 'سماء شتوية دافية ومشوار هادي' : 'Soft winter sky & a calm walk',
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
  /// Northern-hemisphere winter window used for the free winter scene (Dec–Feb).
  static bool isWinterSeason(DateTime date) {
    final m = date.month;
    return m == 12 || m == 1 || m == 2;
  }

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

    // 2. Special seasonal overrides (Ramadan lantern free forever during Ramadan)
    if (isRamadan) return ScenePackId.ramadan;
    if (isEid) return ScenePackId.eid;
    if (isWinterSeason(date)) return ScenePackId.winter;
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
      ScenePackId.winter => _buildWinterPalette(stage, themeAccent, themeSecondary, isDark),
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
          VBridge.cFF1E1B4B,
          VBridge.cFF312E81,
          accent.withValues(alpha: 0.6),
        ];
      } else {
        return [
          VBridge.cFF78350F,
          VBridge.cFFB45309,
          VBridge.cFFD97706,
        ];
      }
    }

    return switch (slot) {
      MealType.breakfast => [
          // Soft morning sunrise pastel tone
          isDark ? VBridge.cFF431407 : VBridge.cFFFFF7ED,
          accent.withValues(alpha: isDark ? 0.85 : 0.9),
          isDark ? VBridge.cFF7C2D12 : VBridge.cFFFDBA74,
        ],
      MealType.lunch => [
          // Bright energetic midday tone
          isDark ? VBridge.cFF78350F : VBridge.cFFFEF3C7,
          accent,
          isDark ? VBridge.cFFB45309 : VBridge.cFFF59E0B,
        ],
      MealType.dinner => [
          // Calm soothing evening twilight
          isDark ? VBridge.cFF0F172A : VBridge.cFFF1F5F9,
          accent.withValues(alpha: 0.8),
          isDark ? VBridge.cFF1E293B : VBridge.cFF94A3B8,
        ],
      MealType.snack => [
          isDark ? VBridge.cFF1C1917 : VBridge.cFFFAFAF9,
          accent.withValues(alpha: 0.85),
          isDark ? VBridge.cFF292524 : VBridge.cFFD6D3D1,
        ],
    };
  }

  // ── Palette builders ────────────────────────────────────────────────────────

  static ScenePackPalette _buildNilePalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [VBridge.cFF0C1B2A, VBridge.cFF16324F, VBridge.cFF1F4E79],
      JourneySkyTime.morning => [VBridge.cFF133E68, VBridge.cFF1E5F8A, VBridge.cFF4A90E2],
      JourneySkyTime.noon => [VBridge.cFF0E4C7A, VBridge.cFF2A7FB8, VBridge.cFF5BA4CF],
      JourneySkyTime.golden => [VBridge.cFF281C3E, VBridge.cFF6B3A5B, VBridge.cFFD97736],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: stage.isNightOrDawn ? VBridge.cFFE2E8F0 : VBridge.cFFFFD166,
      sunHaloColor: stage.isNightOrDawn ? VBridge.c33CBD5E1 : VBridge.c4DFFA726,
      distantTerrainColor: VBridge.cFF0D283E,
      midTerrainColor: VBridge.cFF0F3B56,
      foregroundPathColor: VBridge.cFF185375,
      landmarkColor: VBridge.cFFE2E8F0,
    );
  }

  static ScenePackPalette _buildDesertPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [VBridge.cFF24141E, VBridge.cFF4A2535, VBridge.cFF8C4646],
      JourneySkyTime.morning => [VBridge.cFF5A2A18, VBridge.cFF9E4B27, VBridge.cFFD97736],
      JourneySkyTime.noon => [VBridge.cFF804E19, VBridge.cFFB87828, VBridge.cFFE4AC42],
      JourneySkyTime.golden => [VBridge.cFF381418, VBridge.cFF7A2522, VBridge.cFFD4622B],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: stage.isNightOrDawn ? VBridge.cFFFDE68A : VBridge.cFFFFFBEB,
      sunHaloColor: VBridge.c4DF59E0B,
      distantTerrainColor: VBridge.cFF5C3317,
      midTerrainColor: VBridge.cFF7C441E,
      foregroundPathColor: VBridge.cFFA15E28,
      landmarkColor: VBridge.cFFFEF3C7,
    );
  }

  static ScenePackPalette _buildMountainsPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [VBridge.cFF171926, VBridge.cFF282B42, VBridge.cFF3F4466],
      JourneySkyTime.morning => [VBridge.cFF1F2B3E, VBridge.cFF304563, VBridge.cFF4A6B94],
      JourneySkyTime.noon => [VBridge.cFF1C3A5A, VBridge.cFF32608E, VBridge.cFF5188BD],
      JourneySkyTime.golden => [VBridge.cFF2E1929, VBridge.cFF5A2C46, VBridge.cFFAB5E63],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: stage.isNightOrDawn ? VBridge.cFFE0E7FF : VBridge.cFFFEF08A,
      sunHaloColor: VBridge.c33818CF8,
      distantTerrainColor: VBridge.cFF1E2235,
      midTerrainColor: VBridge.cFF2B314B,
      foregroundPathColor: VBridge.cFF3B4466,
      landmarkColor: VBridge.cFFE0E7FF,
    );
  }

  static ScenePackPalette _buildSeaPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [VBridge.cFF0A1826, VBridge.cFF102A45, VBridge.cFF1A476F],
      JourneySkyTime.morning => [VBridge.cFF0F3252, VBridge.cFF195587, VBridge.cFF2A7FC0],
      JourneySkyTime.noon => [VBridge.cFF10436C, VBridge.cFF1D6AA3, VBridge.cFF399BE2],
      JourneySkyTime.golden => [VBridge.cFF1F1C36, VBridge.cFF4B325E, VBridge.cFFC76950],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: VBridge.cFFE0F2FE,
      sunHaloColor: VBridge.c3338BDF8,
      distantTerrainColor: VBridge.cFF0B2136,
      midTerrainColor: VBridge.cFF0F3657,
      foregroundPathColor: VBridge.cFF165282,
      landmarkColor: VBridge.cFFBAE6FD,
    );
  }

  static ScenePackPalette _buildNightPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [VBridge.cFF070B14, VBridge.cFF0E1626, VBridge.cFF152238],
      sunOrMoonColor: VBridge.cFFF1F5F9,
      sunHaloColor: VBridge.c3394A3B8,
      distantTerrainColor: VBridge.cFF0A101D,
      midTerrainColor: VBridge.cFF101B2E,
      foregroundPathColor: VBridge.cFF192A45,
      landmarkColor: VBridge.cFFF8FAFC,
    );
  }

  static ScenePackPalette _buildGardenPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => [VBridge.cFF111E18, VBridge.cFF1B332A, VBridge.cFF284F41],
      JourneySkyTime.morning => [VBridge.cFF1A3528, VBridge.cFF2A5741, VBridge.cFF3E805E],
      JourneySkyTime.noon => [VBridge.cFF184232, VBridge.cFF2A6E52, VBridge.cFF44A076],
      JourneySkyTime.golden => [VBridge.cFF2A2416, VBridge.cFF574624, VBridge.cFF9E7B36],
    };

    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: VBridge.cFFFEF3C7,
      sunHaloColor: VBridge.c3334D399,
      distantTerrainColor: VBridge.cFF10281F,
      midTerrainColor: VBridge.cFF163E2F,
      foregroundPathColor: VBridge.cFF1E5841,
      landmarkColor: VBridge.cFFD1FAE5,
    );
  }

  static ScenePackPalette _buildRamadanPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [VBridge.cFF100E29, VBridge.cFF1F1A4D, VBridge.cFF2E246B],
      sunOrMoonColor: VBridge.cFFFFE082,
      sunHaloColor: VBridge.c55FFD54F,
      distantTerrainColor: VBridge.cFF161338,
      midTerrainColor: VBridge.cFF231E54,
      foregroundPathColor: VBridge.cFF37307A,
      landmarkColor: VBridge.cFFFFD54F,
    );
  }

  static ScenePackPalette _buildEidPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [VBridge.cFF210F33, VBridge.cFF3F175E, VBridge.cFF6B21A8],
      sunOrMoonColor: VBridge.cFFFDE047,
      sunHaloColor: VBridge.c4DC084FC,
      distantTerrainColor: VBridge.cFF29123D,
      midTerrainColor: VBridge.cFF431C63,
      foregroundPathColor: VBridge.cFF632891,
      landmarkColor: VBridge.cFFFDE047,
    );
  }

  static ScenePackPalette _buildWinterPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    final sky = switch (stage.skyTime) {
      JourneySkyTime.dawn => const [VBridge.cFF0F172A, VBridge.cFF1E293B, VBridge.cFF334155],
      JourneySkyTime.morning => const [VBridge.cFF1E3A5F, VBridge.cFF334155, VBridge.cFF64748B],
      JourneySkyTime.noon => const [VBridge.cFF1E40AF, VBridge.cFF3B82F6, VBridge.cFF93C5FD],
      JourneySkyTime.golden => const [VBridge.cFF1E293B, VBridge.cFF475569, VBridge.cFF94A3B8],
    };
    return ScenePackPalette(
      skyGradient: sky,
      sunOrMoonColor: stage.isNightOrDawn ? VBridge.cFFE2E8F0 : VBridge.cFFF8FAFC,
      sunHaloColor: VBridge.c3394A3B8,
      distantTerrainColor: VBridge.cFF0F172A,
      midTerrainColor: VBridge.cFF1E293B,
      foregroundPathColor: VBridge.cFF334155,
      landmarkColor: VBridge.cFFE2E8F0,
    );
  }

  static ScenePackPalette _buildStreakPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [VBridge.cFF3B1009, VBridge.cFF6E1B0E, VBridge.cFFB91C1C],
      sunOrMoonColor: VBridge.cFFFEF08A,
      sunHaloColor: VBridge.c66F97316,
      distantTerrainColor: VBridge.cFF45140D,
      midTerrainColor: VBridge.cFF6B1D11,
      foregroundPathColor: VBridge.cFF992B19,
      landmarkColor: VBridge.cFFFEF08A,
    );
  }

  static ScenePackPalette _buildPharaonicPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [VBridge.cFF291E0B, VBridge.cFF543D15, VBridge.cFF8A651E],
      sunOrMoonColor: VBridge.cFFFFE57F,
      sunHaloColor: VBridge.c66FFC107,
      distantTerrainColor: VBridge.cFF3D2B0E,
      midTerrainColor: VBridge.cFF5E4317,
      foregroundPathColor: VBridge.cFF8A6424,
      landmarkColor: VBridge.cFFFFE57F,
    );
  }

  static ScenePackPalette _buildAuroraPalette(
      JourneyStage stage, Color accent, Color secondary, bool isDark) {
    return ScenePackPalette(
      skyGradient: const [VBridge.cFF1E1035, VBridge.cFF431D61, VBridge.cFF86198F],
      sunOrMoonColor: VBridge.cFFFBCFE8,
      sunHaloColor: VBridge.c4DF472B6,
      distantTerrainColor: VBridge.cFF2A1547,
      midTerrainColor: VBridge.cFF472173,
      foregroundPathColor: VBridge.cFF6D2F9E,
      landmarkColor: VBridge.cFFFDF2F8,
    );
  }
}
