import 'package:vireo/core/l10n/generated/app_localizations.dart';

/// Localized display labels for internal muscle group keys.
String localizedMuscleLabel(AppLocalizations l10n, String muscleKey) {
  return switch (muscleKey) {
    'chest' => l10n.muscleChest,
    'back' => l10n.muscleBack,
    'shoulders' => l10n.muscleShoulders,
    'biceps' => l10n.muscleBiceps,
    'triceps' => l10n.muscleTriceps,
    'core' => l10n.muscleCore,
    'quads' => l10n.muscleQuads,
    'hamstrings' => l10n.muscleHamstrings,
    'glutes' => l10n.muscleGlutes,
    'calves' => l10n.muscleCalves,
    'forearms' => l10n.muscleForearms,
    'hip_flexors' => l10n.muscleHipFlexors,
    _ => muscleKey,
  };
}
