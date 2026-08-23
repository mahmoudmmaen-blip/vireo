import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';

const _weeklyCheckInKey = 'last_weekly_checkin';
const _weeklyWaistKey = 'weekly_waist_cm';
const _weeklyEnergyKey = 'weekly_energy';
const _weeklyAdherenceKey = 'weekly_adherence';

class WeeklyCheckInInput {
  const WeeklyCheckInInput({
    required this.weightKg,
    required this.waistCm,
    required this.energyLevel,
    required this.adherencePct,
  });

  final double weightKg;
  final double waistCm;
  final int energyLevel; // 1–5
  final int adherencePct; // 0–100
}

class WeeklyCheckInResult {
  const WeeklyCheckInResult({
    required this.target,
    required this.previousCalories,
  });

  final CalorieTarget target;
  final int previousCalories;
}

class WeeklyCheckInNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(_weeklyCheckInKey) as String?;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  bool get isDue {
    final last = state;
    if (last == null) return true;
    return DateTime.now().difference(last).inDays >= 7;
  }

  Future<WeeklyCheckInResult> submit(WeeklyCheckInInput input) async {
    final previous = ref.read(calorieGoalProvider).calories;

    final profile = HiveService.cacheBox.get('guest_profile');
    var height = 170.0;
    var age = 30;
    var activity = ActivityLevel.moderatelyActive;
    var goal = FitnessGoal.generalVitality;

    if (profile is Map) {
      final map = Map<String, dynamic>.from(profile);
      height = (map['height_cm'] as num?)?.toDouble() ?? height;
      age = map['age'] as int? ?? age;
      activity = ActivityLevel.fromValue(
        map['activity_level'] as String? ?? activity.value,
      );
      goal = FitnessGoal.fromValue(map['goal'] as String? ?? goal.value);
      map['weight_kg'] = input.weightKg;
      await HiveService.cacheBox.put('guest_profile', map);
    } else {
      await HiveService.cacheBox.put('guest_profile', {
        'weight_kg': input.weightKg,
        'height_cm': height,
        'age': age,
        'activity_level': activity.value,
        'goal': goal.value,
      });
    }

    // Adherence & energy nudge activity slightly for next week.
    var adjusted = activity;
    if (input.adherencePct >= 80 && input.energyLevel >= 4) {
      adjusted = ActivityLevel.veryActive;
    } else if (input.adherencePct < 40 || input.energyLevel <= 2) {
      adjusted = ActivityLevel.sedentary;
    }

    final target = CalorieCalculator.compute(
      weightKg: input.weightKg,
      heightCm: height,
      age: age,
      activityLevel: adjusted,
      goal: goal,
    );

    // Persist as manual override so calorieGoalProvider picks it up.
    await setManualCalorieGoal(target.calories);
    await HiveService.settingsBox.put(_weeklyCheckInKey, DateTime.now().toIso8601String());
    await HiveService.settingsBox.put(_weeklyWaistKey, input.waistCm);
    await HiveService.settingsBox.put(_weeklyEnergyKey, input.energyLevel);
    await HiveService.settingsBox.put(_weeklyAdherenceKey, input.adherencePct);

    state = DateTime.now();
    ref.invalidate(calorieGoalProvider);
    return WeeklyCheckInResult(target: target, previousCalories: previous);
  }
}

final weeklyCheckInProvider =
    NotifierProvider<WeeklyCheckInNotifier, DateTime?>(WeeklyCheckInNotifier.new);

final weeklyCheckInDueProvider = Provider<bool>((ref) {
  final last = ref.watch(weeklyCheckInProvider);
  if (last == null) return true;
  return DateTime.now().difference(last).inDays >= 7;
});
