/// Recovery score: Rest Days 40% + Steps 30% + Consistency 30%.
class RecoveryBreakdown {
  const RecoveryBreakdown({
    required this.restDaysScore,
    required this.stepsScore,
    required this.consistencyScore,
    required this.restDaysWeight,
    required this.stepsWeight,
    required this.consistencyWeight,
    required this.weeklyRestDays,
    required this.stepsToday,
    required this.stepsGoal,
    required this.mealsConfirmed,
    required this.mealsPlanned,
    required this.workoutCompletedThisWeek,
    required this.workoutsPlannedThisWeek,
  });

  final double restDaysScore; // 0–100
  final double stepsScore;
  final double consistencyScore;
  final double restDaysWeight; // 0.40
  final double stepsWeight; // 0.30
  final double consistencyWeight; // 0.30
  final int weeklyRestDays;
  final int stepsToday;
  final int stepsGoal;
  final int mealsConfirmed;
  final int mealsPlanned;
  final int workoutCompletedThisWeek;
  final int workoutsPlannedThisWeek;

  int get totalScore {
    final raw = restDaysScore * restDaysWeight +
        stepsScore * stepsWeight +
        consistencyScore * consistencyWeight;
    return raw.round().clamp(0, 100);
  }

  int get restContribution => (restDaysScore * restDaysWeight).round();
  int get stepsContribution => (stepsScore * stepsWeight).round();
  int get consistencyContribution =>
      (consistencyScore * consistencyWeight).round();
}

abstract final class RecoveryScoreCalculator {
  static const restWeight = 0.40;
  static const stepsWeight = 0.30;
  static const consistencyWeight = 0.30;

  static RecoveryBreakdown compute({
    required int weeklyRestDays,
    required int stepsToday,
    required int stepsGoal,
    required int mealsConfirmed,
    required int mealsPlanned,
    required int workoutsCompletedThisWeek,
    required int workoutsPlannedThisWeek,
  }) {
    // Ideal: 1–2 rest days/week. 0 days or 5+ days score lower.
    final restScore = switch (weeklyRestDays) {
      1 || 2 => 100.0,
      3 => 80.0,
      0 => 55.0,
      4 => 60.0,
      _ => 40.0,
    };

    final goal = stepsGoal <= 0 ? 8000 : stepsGoal;
    final stepsScore = ((stepsToday / goal) * 100).clamp(0.0, 100.0);

    final mealRatio = mealsPlanned <= 0
        ? 0.5
        : (mealsConfirmed / mealsPlanned).clamp(0.0, 1.0);
    final workoutRatio = workoutsPlannedThisWeek <= 0
        ? 0.5
        : (workoutsCompletedThisWeek / workoutsPlannedThisWeek).clamp(0.0, 1.0);
    final consistencyScore = ((mealRatio * 0.5 + workoutRatio * 0.5) * 100);

    return RecoveryBreakdown(
      restDaysScore: restScore,
      stepsScore: stepsScore,
      consistencyScore: consistencyScore,
      restDaysWeight: restWeight,
      stepsWeight: stepsWeight,
      consistencyWeight: consistencyWeight,
      weeklyRestDays: weeklyRestDays,
      stepsToday: stepsToday,
      stepsGoal: goal,
      mealsConfirmed: mealsConfirmed,
      mealsPlanned: mealsPlanned,
      workoutCompletedThisWeek: workoutsCompletedThisWeek,
      workoutsPlannedThisWeek: workoutsPlannedThisWeek,
    );
  }
}
