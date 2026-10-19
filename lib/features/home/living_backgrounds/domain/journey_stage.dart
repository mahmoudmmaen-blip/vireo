import 'package:flutter/material.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

/// Represents one of the 13 progression stages (0 to 12) of the step journey.
/// Evolving every 1,000 steps up to 12,000+ steps.
enum JourneySkyTime {
  dawn,
  morning,
  noon,
  golden,
}

enum LandmarkType {
  palm,
  pyramid,
  minaret,
  nileWave,
  mountainFlag,
  starBadge,
}

class JourneyStage {
  const JourneyStage({
    required this.index,
    required this.skyTime,
    required this.landmarks,
    required this.pathProgress,
    required this.hasStarBadge,
    required this.sunElevation,
    required this.sunAzimuth,
    required this.isNightOrDawn,
  });

  /// Stage index from 0 to 12.
  final int index;

  /// Sky atmosphere bucket.
  final JourneySkyTime skyTime;

  /// Landmarks unlocked at this stage.
  final Set<LandmarkType> landmarks;

  /// Progress of the journey path across the landscape (0.08 to 1.0).
  final double pathProgress;

  /// True when steps reach or exceed 12,000.
  final bool hasStarBadge;

  /// Sun elevation from horizon: 0.0 (horizon) to 1.0 (zenith).
  final double sunElevation;

  /// Sun horizontal position from 0.15 (east/left) to 0.85 (west/right).
  final double sunAzimuth;

  /// True for stages 0 and 1 where moon and stars are prominent.
  final bool isNightOrDawn;

  /// Calculates the stage from the user's current step count.
  /// 0..999 -> 0
  /// 1000..1999 -> 1
  /// ...
  /// 12000+ -> 12 (capped)
  static JourneyStage fromSteps(int steps) {
    final clampedSteps = steps < 0 ? 0 : steps;
    final stageIndex = (clampedSteps ~/ 1000).clamp(0, 12);
    final hasStar = clampedSteps >= 12000;

    final skyTime = switch (stageIndex) {
      0 || 1 => JourneySkyTime.dawn,
      2 || 3 || 4 || 5 => JourneySkyTime.morning,
      6 || 7 || 8 => JourneySkyTime.noon,
      _ => JourneySkyTime.golden,
    };

    final isNight = stageIndex <= 1;

    final landmarks = <LandmarkType>{};
    if (stageIndex >= 2) landmarks.add(LandmarkType.palm);
    if (stageIndex >= 4) landmarks.add(LandmarkType.pyramid);
    if (stageIndex >= 6) landmarks.add(LandmarkType.minaret);
    if (stageIndex >= 8) landmarks.add(LandmarkType.nileWave);
    if (stageIndex >= 10) landmarks.add(LandmarkType.mountainFlag);
    if (hasStar) landmarks.add(LandmarkType.starBadge);

    // Path expands from 0.12 at start up to 1.0 at stage 12
    final pathProgress = (0.12 + (stageIndex / 12.0) * 0.88).clamp(0.12, 1.0);

    // Sun/moon arc geometry
    final elevation = switch (stageIndex) {
      0 => 0.15, // Moon low
      1 => 0.35, // Moon mid
      2 => 0.20, // Sun sunrise
      3 => 0.40,
      4 => 0.60,
      5 => 0.75,
      6 || 7 => 0.90, // Zenith noon
      8 => 0.70,
      9 => 0.50,
      10 => 0.35,
      11 => 0.20, // Golden sunset
      _ => 0.15,
    };

    final azimuth = 0.15 + (stageIndex / 12.0) * 0.70;

    return JourneyStage(
      index: stageIndex,
      skyTime: skyTime,
      landmarks: landmarks,
      pathProgress: pathProgress,
      hasStarBadge: hasStar,
      sunElevation: elevation,
      sunAzimuth: azimuth,
      isNightOrDawn: isNight,
    );
  }

  /// Color accent ramp based on theme variant and stage progression.
  Color ringAccent(AppThemeVariant variant) {
    final base = variant.primaryAccent;
    final secondary = variant.secondaryAccent;

    if (index >= 12) {
      return VBridge.cFFFFD700; // Triumphant Gold at 12k+
    }

    final t = (index / 12.0).clamp(0.0, 1.0);
    return Color.lerp(base, secondary, t) ?? base;
  }
}
