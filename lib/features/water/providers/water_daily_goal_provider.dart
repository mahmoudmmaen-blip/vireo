import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/data/repositories/workout_repository.dart';

const waterGlassMl = 250;

int _roundGoalMl(int raw) {
  final rounded = ((raw / 250).round() * 250);
  return rounded.clamp(2000, 4500);
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

/// Daily water target: weight × 35 ml, +500 ml on workout days, rounded to 250 ml.
final waterDailyGoalMlProvider = Provider<int>((ref) {
  ref.watch(todayWorkoutProvider);
  var goal = (_profileWeightKg() * 35).round();
  final session = ref.watch(todayWorkoutProvider).valueOrNull;
  if (session != null && session.exercises.isNotEmpty) {
    goal += 500;
  }
  return _roundGoalMl(goal);
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
