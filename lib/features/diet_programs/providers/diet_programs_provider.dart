import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/calorie_calculator.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/features/diet_programs/application/diet_plan_engine.dart';
import 'package:vireo/features/diet_programs/data/diet_plan_storage.dart';
import 'package:vireo/features/diet_programs/data/diet_programs_catalog.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

/// Bumps when Hive diet-plan state changes so providers rebuild.
final dietPlanRevisionProvider = StateProvider<int>((ref) => 0);

void _bumpDietPlan(Ref ref) {
  ref.read(dietPlanRevisionProvider.notifier).state++;
}

final dietPlanInputProvider = Provider<DietPlanInput>((ref) {
  ref.watch(dietPlanRevisionProvider);

  var weight = 75.0;
  var height = 170.0;
  var age = 30;
  var activity = ActivityLevel.moderatelyActive;

  if (HiveService.isInitialized) {
    final profile = HiveService.cacheBox.get('guest_profile');
    if (profile is Map) {
      final map = Map<String, dynamic>.from(profile);
      weight = (map['weight_kg'] as num?)?.toDouble() ?? weight;
      height = (map['height_cm'] as num?)?.toDouble() ?? height;
      age = map['age'] as int? ?? age;
      activity = ActivityLevel.fromValue(
        map['activity_level'] as String? ?? activity.value,
      );
    }
  }

  final maintenance = CalorieCalculator.maintenanceKcal(
    weightKg: weight,
    heightCm: height,
    age: age,
    activityLevel: activity,
  );

  return DietPlanInput(
    weightKg: weight,
    heightCm: height,
    age: age,
    maintenanceKcal: maintenance,
    conditions: DietPlanStorage.readConditions(),
    preferences: DietPlanStorage.readPreferences(),
  );
});

final rankedProgramsProvider = Provider<List<RankedProgram>>((ref) {
  final input = ref.watch(dietPlanInputProvider);
  return DietPlanEngine.rank(DietProgramsCatalog.all, input);
});

final activeDietProgramProvider = Provider<DietProgram?>((ref) {
  ref.watch(dietPlanRevisionProvider);
  final idValue = DietPlanStorage.readActiveProgramId();
  if (idValue == null) return null;
  final id = DietProgramId.fromValue(idValue);
  return DietProgramsCatalog.byId(id);
});

final activeDietTargetsProvider = Provider<DietPlanTargets?>((ref) {
  final program = ref.watch(activeDietProgramProvider);
  if (program == null) return null;
  final input = ref.watch(dietPlanInputProvider);
  return DietPlanEngine.targetsFor(program, input);
});

final eatingWindowStartHourProvider = Provider<int>((ref) {
  ref.watch(dietPlanRevisionProvider);
  final stored = DietPlanStorage.readEatingWindowStartHour();
  if (stored != null) return stored;
  final program = ref.watch(activeDietProgramProvider);
  return program?.window?.defaultStartHour ?? 12;
});

/// Live fasting / eating-window status for Home.
@immutable
class FastingWindowStatus {
  const FastingWindowStatus({
    required this.isEating,
    required this.minutesRemaining,
    required this.progress,
    required this.startHour,
    required this.eatingHours,
    required this.fastingHours,
  });

  final bool isEating;
  final int minutesRemaining;
  final double progress;
  final int startHour;
  final int eatingHours;
  final int fastingHours;
}

final fastingWindowStatusProvider = Provider<FastingWindowStatus?>((ref) {
  final program = ref.watch(activeDietProgramProvider);
  final window = program?.window;
  if (window == null) return null;

  final startHour = ref.watch(eatingWindowStartHourProvider);
  final now = DateTime.now();
  final minutesNow = now.hour * 60 + now.minute;
  final startMin = startHour * 60;
  final eatingMin = window.eatingHours * 60;
  final cycle = 24 * 60;

  var offset = minutesNow - startMin;
  if (offset < 0) offset += cycle;
  final inEating = offset < eatingMin;
  final remaining = inEating ? (eatingMin - offset) : (cycle - offset);
  final segmentTotal = inEating ? eatingMin : window.fastingHours * 60;
  final elapsed = segmentTotal - remaining;
  final progress =
      segmentTotal <= 0 ? 0.0 : (elapsed / segmentTotal).clamp(0.0, 1.0);

  return FastingWindowStatus(
    isEating: inEating,
    minutesRemaining: remaining,
    progress: progress,
    startHour: startHour,
    eatingHours: window.eatingHours,
    fastingHours: window.fastingHours,
  );
});

final dietPlanActionsProvider = Provider<DietPlanActions>((ref) {
  return DietPlanActions(ref);
});

class DietPlanActions {
  DietPlanActions(this._ref);
  final Ref _ref;

  Future<void> saveScreening({
    required Set<HealthCondition> conditions,
    required DietPreferences preferences,
  }) async {
    await DietPlanStorage.saveConditions(conditions);
    await DietPlanStorage.savePreferences(preferences);
    _bumpDietPlan(_ref);
  }

  Future<void> approveDoctor(DietProgramId id) async {
    await DietPlanStorage.markDoctorApproved(id);
    _bumpDietPlan(_ref);
  }

  Future<void> startProgram(DietProgram program) async {
    await DietPlanStorage.startProgram(
      program.id,
      eatingWindowStartHour: program.window?.defaultStartHour,
    );
    _bumpDietPlan(_ref);
  }

  Future<void> clearProgram() async {
    await DietPlanStorage.clearActiveProgram();
    _bumpDietPlan(_ref);
  }

  Future<void> setEatingWindowStartHour(int hour) async {
    await DietPlanStorage.setEatingWindowStartHour(hour);
    _bumpDietPlan(_ref);
  }
}
