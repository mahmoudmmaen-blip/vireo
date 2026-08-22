class DailyStepCount {
  const DailyStepCount({
    required this.date,
    required this.steps,
  });

  final DateTime date;
  final int steps;
}

enum HealthStepsStatus {
  loading,
  granted,
  denied,
  unavailable,
}

class HealthStepsSnapshot {
  const HealthStepsSnapshot({
    required this.status,
    this.todaySteps = 0,
    this.last7Days = const [],
  });

  final HealthStepsStatus status;
  final int todaySteps;
  final List<DailyStepCount> last7Days;
}
