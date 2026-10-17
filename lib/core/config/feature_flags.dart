import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

/// Compile-time defaults for the v1 launch ("hide non-core, keep the code").
///
/// The InBody / body module and the women's module have NO flag: they stay
/// visible in v1. Entry points of the flagged modules are hidden when the
/// flag is false; the code itself stays in the repo.
abstract final class FeatureFlags {
  /// Outdoor GPS run / walk map screens. Default OFF in v1
  /// (step-based walking energy stays).
  static const gpsRunScreen = false;

  /// Men's vitality / testosterone-style module. Default OFF in v1
  /// (Play health-sensitivity risk).
  static const mensVitalityModule = false;

  /// Hive (settings box) key holding an optional JSON override, e.g.
  /// `{"gpsRunScreen": true, "mensVitalityModule": false}`.
  static const overrideHiveKey = 'feature_flags_override_json';

  /// Resolves the effective flags (defaults + optional Hive override).
  /// Safe to call before Hive is ready: returns the defaults.
  static FeatureFlagsState resolve() {
    if (!HiveService.isInitialized) return const FeatureFlagsState.defaults();
    try {
      final raw = HiveService.settingsBox.get(overrideHiveKey) as String?;
      return FeatureFlagsState.fromOverrideJson(raw);
    } catch (_) {
      return const FeatureFlagsState.defaults();
    }
  }

  /// Persists an override. Pass `null` to clear it.
  /// Call `ref.invalidate(featureFlagsProvider)` afterwards.
  static Future<void> saveOverride(Map<String, bool>? override) async {
    if (!HiveService.isInitialized) return;
    if (override == null || override.isEmpty) {
      await HiveService.settingsBox.delete(overrideHiveKey);
      return;
    }
    await HiveService.settingsBox.put(overrideHiveKey, jsonEncode(override));
  }
}

/// Immutable snapshot of the effective flags.
@immutable
class FeatureFlagsState {
  const FeatureFlagsState({
    required this.gpsRunScreen,
    required this.mensVitalityModule,
  });

  const FeatureFlagsState.defaults()
      : gpsRunScreen = FeatureFlags.gpsRunScreen,
        mensVitalityModule = FeatureFlags.mensVitalityModule;

  final bool gpsRunScreen;
  final bool mensVitalityModule;

  /// Parses [raw] JSON; unknown keys, non-bool values and malformed JSON are
  /// ignored (the compile-time default wins).
  factory FeatureFlagsState.fromOverrideJson(String? raw) {
    const base = FeatureFlagsState.defaults();
    if (raw == null || raw.trim().isEmpty) return base;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return base;
      bool pick(String key, bool fallback) {
        final v = decoded[key];
        return v is bool ? v : fallback;
      }

      return FeatureFlagsState(
        gpsRunScreen: pick('gpsRunScreen', base.gpsRunScreen),
        mensVitalityModule: pick('mensVitalityModule', base.mensVitalityModule),
      );
    } catch (_) {
      return base;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is FeatureFlagsState &&
      other.gpsRunScreen == gpsRunScreen &&
      other.mensVitalityModule == mensVitalityModule;

  @override
  int get hashCode => Object.hash(gpsRunScreen, mensVitalityModule);
}

/// Effective feature flags (defaults + optional Hive override).
final featureFlagsProvider = Provider<FeatureFlagsState>(
  (ref) => FeatureFlags.resolve(),
);
