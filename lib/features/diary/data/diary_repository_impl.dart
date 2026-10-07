import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/onboarding_calorie_sync.dart';
import 'package:vireo/core/utils/cardio_calorie_calculator.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/models/workout_session.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/diary/domain/diary_day.dart';
import 'package:vireo/features/diary/domain/diary_entry.dart';
import 'package:vireo/features/diary/domain/diary_goal_checker.dart';
import 'package:vireo/features/diary/domain/i_diary_repository.dart';
import 'package:vireo/features/vitality/data/vitality_daily_log.dart';
import 'package:vireo/core/utils/calorie_calculator.dart';

typedef AiLogsReader = List<AiMealLogEntry> Function();
typedef CardioLogsReader = List<CardioLogEntry> Function();
typedef WaterMlReader = int Function();
typedef CalorieTargetReader = CalorieTarget Function();
typedef ConfirmedMealsReader = Set<MealType> Function();
typedef TodayMealsReader = List<MealPlanEntry> Function();
typedef VitalityLogReader = VitalityDailyLog Function();
typedef WorkoutSessionReader = Future<WorkoutSession?> Function();
typedef FitnessGoalReader = FitnessGoal Function();
typedef WeightKgReader = double Function();
typedef SaveAiMeal = Future<void> Function(FoodAnalysisResult result, DateTime loggedAt);
typedef SaveCardioWorkout = Future<void> Function({
  required CardioActivityType activity,
  required int durationMinutes,
  required double weightKg,
  DateTime? loggedAt,
  int? caloriesOverride,
});

DateTime diaryDateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

bool diaryIsSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class DiaryRepositoryImpl implements IDiaryRepository {
  DiaryRepositoryImpl({
    required AiLogsReader readAiLogs,
    required CardioLogsReader readCardioLogs,
    required WaterMlReader readWaterMl,
    required CalorieTargetReader readCalorieTarget,
    required ConfirmedMealsReader readConfirmedMeals,
    required TodayMealsReader readTodayMeals,
    required VitalityLogReader readVitalityLog,
    required WorkoutSessionReader readWorkoutSession,
    required FitnessGoalReader readFitnessGoal,
    required WeightKgReader readWeightKg,
    required SaveAiMeal saveAiMeal,
    required SaveCardioWorkout saveCardioWorkout,
  })  : _readAiLogs = readAiLogs,
        _readCardioLogs = readCardioLogs,
        _readWaterMl = readWaterMl,
        _readCalorieTarget = readCalorieTarget,
        _readConfirmedMeals = readConfirmedMeals,
        _readTodayMeals = readTodayMeals,
        _readVitalityLog = readVitalityLog,
        _readWorkoutSession = readWorkoutSession,
        _readFitnessGoal = readFitnessGoal,
        _readWeightKg = readWeightKg,
        _saveAiMeal = saveAiMeal,
        _saveCardioWorkout = saveCardioWorkout;

  final AiLogsReader _readAiLogs;
  final CardioLogsReader _readCardioLogs;
  final WaterMlReader _readWaterMl;
  final CalorieTargetReader _readCalorieTarget;
  final ConfirmedMealsReader _readConfirmedMeals;
  final TodayMealsReader _readTodayMeals;
  final VitalityLogReader _readVitalityLog;
  final WorkoutSessionReader _readWorkoutSession;
  final FitnessGoalReader _readFitnessGoal;
  final WeightKgReader _readWeightKg;
  final SaveAiMeal _saveAiMeal;
  final SaveCardioWorkout _saveCardioWorkout;

  DateTime? _cacheTimestamp;
  DiaryDay? _cachedDay;

  @override
  Future<DiaryDay> getDay(DateTime date) async {
    final day = diaryDateOnly(date);
    try {
      final built = await _buildDay(day);
      _cachedDay = built;
      _cacheTimestamp = DateTime.now();
      return built;
    } catch (_) {
      if (_cachedDay != null && diaryIsSameDay(_cachedDay!.date, day)) {
        return _cachedDay!.copyWith(
          fromCache: true,
          lastUpdated: _cacheTimestamp,
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<DiaryDay>> getWeek(DateTime startDate) async {
    final start = diaryDateOnly(startDate);
    final days = <DiaryDay>[];
    for (var i = 0; i < 7; i++) {
      days.add(await getDay(start.add(Duration(days: i))));
    }
    return days;
  }

  @override
  Future<void> saveMealEntry(DateTime date, MealEntry meal) async {
    await _saveAiMeal(
      FoodAnalysisResult(
        foodName: meal.name,
        calories: meal.calories,
        protein: meal.protein,
        carbs: meal.carbs,
        fats: meal.fats,
        portionEstimate: '',
        isHighCalorie: meal.calories > 700,
      ),
      meal.time,
    );
  }

  @override
  Future<void> saveWorkoutEntry(DateTime date, WorkoutEntry workout) async {
    await _saveCardioWorkout(
      activity: CardioActivityType.hiit,
      durationMinutes: workout.duration.clamp(1, 300),
      weightKg: _readWeightKg(),
      loggedAt: workout.time,
      caloriesOverride: workout.caloriesBurned,
    );
  }

  Future<DiaryDay> _buildDay(DateTime day) async {
    final target = _readCalorieTarget();
    final hasTdee = _resolveHasTdee(target);
    final aiLogs = _readAiLogs();
    final cardioLogs = _readCardioLogs();
    final today = diaryDateOnly(DateTime.now());

    final meals = <MealEntry>[
      ..._mealsFromAiLogs(aiLogs, day),
      if (diaryIsSameDay(day, today)) ..._mealsFromPlan(_readTodayMeals(), _readConfirmedMeals(), day),
    ];

    final workouts = <WorkoutEntry>[
      ..._workoutsFromCardio(cardioLogs, day),
      if (diaryIsSameDay(day, today)) ...await _strengthWorkoutsForToday(day),
    ];

    final waterIntake = diaryIsSameDay(day, today) ? _readWaterMl() : 0;
    final waterLogs = waterIntake > 0
        ? [
            WaterEntry(
              id: 'water_${day.millisecondsSinceEpoch}',
              amountMl: waterIntake,
              time: DateTime(day.year, day.month, day.day, 20),
            ),
          ]
        : <WaterEntry>[];

    final totalCaloriesIn = meals.fold<int>(0, (sum, m) => sum + m.calories);
    final totalCaloriesOut =
        workouts.fold<int>(0, (sum, w) => sum + w.caloriesBurned);
    final proteinTotal =
        meals.fold<double>(0, (sum, m) => sum + m.protein).round();
    final netBalance = hasTdee
        ? target.calories - totalCaloriesIn + totalCaloriesOut
        : 0;

    return DiaryDay(
      date: day,
      meals: meals,
      workouts: workouts,
      waterLogs: waterLogs,
      waterIntake: waterIntake,
      totalCaloriesIn: totalCaloriesIn,
      totalCaloriesOut: totalCaloriesOut,
      netBalance: netBalance,
      tdee: target.calories,
      proteinTotal: proteinTotal,
      proteinTarget: target.proteinG,
      isGoalMet: hasTdee &&
          DiaryGoalChecker.isGoalMet(
            proteinTotal: proteinTotal,
            proteinTarget: target.proteinG,
            netBalance: netBalance,
            goal: _readFitnessGoal(),
          ),
      hasTdee: hasTdee,
      lastUpdated: DateTime.now(),
    );
  }

  bool _resolveHasTdee(CalorieTarget target) {
    if (target.calories <= 0) return false;
    final cached = OnboardingCalorieSync.readCached();
    if (cached != null && cached.calories > 0) return true;
    if (!HiveService.isInitialized) return false;
    final profile = HiveService.cacheBox.get('guest_profile');
    return profile is Map && (profile['weight_kg'] as num?) != null;
  }

  List<MealEntry> _mealsFromAiLogs(List<AiMealLogEntry> logs, DateTime day) {
    return logs
        .where((e) => diaryIsSameDay(e.loggedAt, day))
        .map(
          (e) => MealEntry(
            id: e.id,
            name: e.result.foodName,
            calories: e.result.calories,
            protein: e.result.protein,
            carbs: e.result.carbs,
            fats: e.result.fats,
            time: e.loggedAt,
          ),
        )
        .toList();
  }

  List<MealEntry> _mealsFromPlan(
    List<MealPlanEntry> meals,
    Set<MealType> confirmed,
    DateTime day,
  ) {
    final entries = <MealEntry>[];
    for (final meal in meals) {
      if (!confirmed.contains(meal.mealType)) continue;
      entries.add(
        MealEntry(
          id: 'plan_${meal.mealType.value}_${meal.recipe.id}',
          name: meal.recipe.titleEn,
          calories: meal.recipe.calories,
          protein: meal.recipe.proteinG.toDouble(),
          carbs: meal.recipe.carbsG.toDouble(),
          fats: meal.recipe.fatG.toDouble(),
          time: _defaultMealTime(day, meal.mealType),
        ),
      );
    }
    return entries;
  }

  DateTime _defaultMealTime(DateTime day, MealType type) {
    final hour = switch (type) {
      MealType.breakfast => 8,
      MealType.lunch => 13,
      MealType.dinner => 19,
      MealType.snack => 16,
    };
    return DateTime(day.year, day.month, day.day, hour);
  }

  List<WorkoutEntry> _workoutsFromCardio(
    List<CardioLogEntry> logs,
    DateTime day,
  ) {
    return logs
        .where((e) => diaryIsSameDay(e.loggedAt, day))
        .map(
          (e) => WorkoutEntry(
            id: e.id,
            name: e.activity.storageKey,
            duration: e.durationMinutes,
            caloriesBurned: e.caloriesBurned,
            time: e.loggedAt,
          ),
        )
        .toList();
  }

  Future<List<WorkoutEntry>> _strengthWorkoutsForToday(DateTime day) async {
    final log = _readVitalityLog();
    if (!log.workoutCompleted) return const [];

    final session = await _readWorkoutSession();
    if (session == null || session.exercises.isEmpty) return const [];

    final duration = (session.exercises.length * 8).clamp(20, 90);
    final weight = _readWeightKg();
    final calories = CardioCalorieCalculator.burn(
      activity: CardioActivityType.hiit,
      durationMinutes: duration,
      weightKg: weight,
    );

    return [
      WorkoutEntry(
        id: 'strength_${session.id}',
        name: session.exercises.first.name,
        duration: duration,
        caloriesBurned: calories,
        time: DateTime(day.year, day.month, day.day, 18),
      ),
    ];
  }
}

FitnessGoal diaryFitnessGoalFromProfile() {
  if (!HiveService.isInitialized) return FitnessGoal.generalVitality;
  final profile = HiveService.cacheBox.get('guest_profile');
  if (profile is! Map) return FitnessGoal.generalVitality;
  return FitnessGoal.fromValue(
    profile['goal'] as String? ?? FitnessGoal.generalVitality.value,
  );
}

double diaryWeightKgFromProfile() {
  if (!HiveService.isInitialized) return 75.0;
  final profile = HiveService.cacheBox.get('guest_profile');
  if (profile is! Map) return 75.0;
  return (profile['weight_kg'] as num?)?.toDouble() ?? 75.0;
}
