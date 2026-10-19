import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/water/providers/water_goal_override_provider.dart';

const waterGlassMl = 250;

/// Default when the user has not set a personal goal (P47).
const waterDefaultGoalMl = 2000;

int _roundGoalMl(int raw) {
  final rounded = ((raw / 250).round() * 250);
  return rounded.clamp(1000, 5000);
}

double _profileWeightKg() {
  var weight = 75.0;
  if (HiveService.isInitialized) {
    final profile = HiveService.cacheBox.get('guest_profile');
    if (profile is Map) {
      weight = (Map<String, dynamic>.from(profile)['weight_kg'] as num?)
              ?.toDouble() ??
          weight;
    }
  }
  return weight;
}

/// Daily water target: user override, else weight × 35 ml (+500 workout),
/// floored at [waterDefaultGoalMl] when using the formula.
final waterDailyGoalMlProvider = Provider<int>((ref) {
  final override = ref.watch(waterGoalOverrideMlProvider);
  if (override != null) return _roundGoalMl(override);

  ref.watch(todayWorkoutProvider);
  var goal = (_profileWeightKg() * 35).round();
  final session = ref.watch(todayWorkoutProvider).valueOrNull;
  if (session != null && session.exercises.isNotEmpty) {
    goal += 500;
  }
  return _roundGoalMl(goal < waterDefaultGoalMl ? waterDefaultGoalMl : goal);
});

final waterProfileWeightKgProvider = Provider<double>((ref) {
  ref.watch(todayWorkoutProvider);
  return _profileWeightKg();
});

final waterGlassCountProvider = Provider<int>((ref) {
  final goal = ref.watch(waterDailyGoalMlProvider);
  // Prefer default cup when available; fall back to legacy 250 ml glass.
  return (goal / waterGlassMl).ceil().clamp(1, 20);
});
