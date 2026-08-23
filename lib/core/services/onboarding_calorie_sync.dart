import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/onboarding_draft.dart';

const calorieTargetCacheKey = 'calorie_target_macros';

/// Computes BMR/TDEE from onboarding inputs and persists targets to Hive.
abstract final class OnboardingCalorieSync {
  static Future<CalorieTarget?> syncFromDraft(OnboardingDraft draft) async {
    if (!HiveService.isInitialized) return null;
    if (!draft.isStep1Valid) return null;

    final target = CalorieCalculator.compute(
      weightKg: draft.weightKg!,
      heightCm: draft.heightCm!,
      age: draft.age!,
      activityLevel: draft.activityLevel,
      goal: draft.goal,
    );

    await HiveService.settingsBox.put('manual_calorie_goal', target.calories);
    await HiveService.cacheBox.put(calorieTargetCacheKey, {
      'calories': target.calories,
      'protein_g': target.proteinG,
      'carbs_g': target.carbsG,
      'fat_g': target.fatG,
      'goal': draft.goal.value,
      'activity_level': draft.activityLevel.value,
      'dietary_restrictions': draft.dietaryRestrictions,
      'updated_at': DateTime.now().toIso8601String(),
    });

    return target;
  }

  static CalorieTarget? readCached() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.cacheBox.get(calorieTargetCacheKey);
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final cal = map['calories'] as int?;
    if (cal == null) return null;
    return CalorieTarget(
      calories: cal,
      proteinG: map['protein_g'] as int? ?? 0,
      carbsG: map['carbs_g'] as int? ?? 0,
      fatG: map['fat_g'] as int? ?? 0,
    );
  }
}
