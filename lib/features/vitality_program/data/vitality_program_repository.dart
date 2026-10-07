import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/vitality_program/data/vitality_program_content.dart';
import 'package:vireo/features/vitality_program/domain/vitality_metrics.dart';
import 'package:vireo/features/vitality_program/domain/vitality_program_phase.dart';
import 'package:vireo/features/vitality_program/domain/vitality_task.dart';
import 'package:vireo/features/vitality_program/domain/vitality_week.dart';

const _progressKey = 'vitality_program_progress';
const _metricsKey = 'vitality_metrics_history';

String _dateKey(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

class VitalityProgramRepository {
  const VitalityProgramRepository();

  List<VitalityWeek> getTemplateWeeks() =>
      VitalityProgramContent.templateWeeks();

  VitalityProgramProgress loadProgress() {
    if (!HiveService.isInitialized) {
      return const VitalityProgramProgress();
    }
    try {
      final raw = HiveService.cacheBox.get(_progressKey);
      if (raw is Map) {
        return _progressFromJson(Map<String, dynamic>.from(raw));
      }
    } catch (_) {}
    return const VitalityProgramProgress();
  }

  Future<void> saveProgress(VitalityProgramProgress progress) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.cacheBox.put(_progressKey, _progressToJson(progress));
    } catch (_) {}
  }

  List<VitalityMetrics> loadMetricsHistory() {
    if (!HiveService.isInitialized) return [];
    try {
      final raw = HiveService.cacheBox.get(_metricsKey);
      if (raw is List) {
        return raw
            .whereType<Map>()
            .map((e) => _metricsFromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> saveMetricsHistory(List<VitalityMetrics> history) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.cacheBox.put(
        _metricsKey,
        history.map(_metricsToJson).toList(),
      );
    } catch (_) {}
  }

  List<VitalityWeek> buildWeeksWithProgress(VitalityProgramProgress progress) {
    final templates = getTemplateWeeks();
    final today = _dateKey(DateTime.now());

    return templates.map((template) {
      final weekTasks = template.dailyTasks.map((task) {
        final dates = progress.taskCompletionDates[task.id] ?? [];
        final completedToday = dates.contains(today);
        final parsedDates = dates
            .map((d) => DateTime.tryParse(d))
            .whereType<DateTime>()
            .toList();
        return task.copyWith(
          isCompleted: completedToday,
          completionDates: parsedDates,
        );
      }).toList();

      final totalDays = 7;
      final completedDays = _countCompletedDaysInWeek(
        weekTasks,
        progress.taskCompletionDates,
      );
      final pct = (completedDays / totalDays).clamp(0.0, 1.0);
      final isUnlocked = progress.unlockedWeeks.contains(template.weekNumber);
      final isCompleted = pct >= 0.8 && template.weekNumber < progress.currentWeek ||
          (template.weekNumber == 12 && progress.isProgramComplete);

      return template.copyWith(
        dailyTasks: weekTasks,
        isUnlocked: isUnlocked,
        isCompleted: isCompleted || pct >= 1.0,
        completionPercentage: pct * 100,
      );
    }).toList();
  }

  int _countCompletedDaysInWeek(
    List<VitalityTask> tasks,
    Map<String, List<String>> completionDates,
  ) {
    final allDates = <String>{};
    for (final task in tasks) {
      allDates.addAll(completionDates[task.id] ?? []);
    }
    return allDates.length.clamp(0, 7);
  }

  VitalityWeeklyReport buildWeeklyReport(
    int weekNumber,
    VitalityProgramProgress progress,
    List<VitalityMetrics> metrics,
  ) {
    final weeks = buildWeeksWithProgress(progress);
    final week = weeks.firstWhere(
      (w) => w.weekNumber == weekNumber,
      orElse: () => weeks.first,
    );

    final weekMetrics = metrics.where((m) {
      final start = _weekStartDate(progress.startedAt, weekNumber);
      final end = start.add(const Duration(days: 7));
      return !m.date.isBefore(start) && m.date.isBefore(end);
    }).toList();

    final energy = _average(weekMetrics.map((m) => m.morningEnergyScore));
    final sleep = _average(weekMetrics.map((m) => m.sleepQuality));
    final workout = _average(weekMetrics.map((m) => m.workoutPerformance));

    final prevWeekMetrics = metrics.where((m) {
      final start = _weekStartDate(progress.startedAt, weekNumber - 1);
      final end = start.add(const Duration(days: 7));
      return !m.date.isBefore(start) && m.date.isBefore(end);
    }).toList();

    final prevEnergy = _average(prevWeekMetrics.map((m) => m.morningEnergyScore));
    final prevSleep = _average(prevWeekMetrics.map((m) => m.sleepQuality));
    final prevWorkout =
        _average(prevWeekMetrics.map((m) => m.workoutPerformance));

    final energyTrend = _trend(energy, prevEnergy);
    final sleepTrend = _trend(sleep, prevSleep);
    final workoutTrend = _trend(workout, prevWorkout);
    final improving = [energyTrend, sleepTrend, workoutTrend]
        .where((t) => t == VitalityTrendDirection.improving)
        .length >=
        2;

    return VitalityWeeklyReport(
      weekNumber: weekNumber,
      completionPercentage: week.completionPercentage,
      averageMorningEnergy: energy,
      averageSleepQuality: sleep,
      averageWorkoutPerformance: workout,
      energyTrend: energyTrend,
      sleepTrend: sleepTrend,
      workoutTrend: workoutTrend,
      isImproving: improving,
    );
  }

  DateTime _weekStartDate(DateTime? startedAt, int weekNumber) {
    final base = startedAt ?? DateTime.now();
    return DateTime(base.year, base.month, base.day)
        .add(Duration(days: (weekNumber - 1) * 7));
  }

  double _average(Iterable<int> values) {
    final list = values.toList();
    if (list.isEmpty) return 0;
    return list.reduce((a, b) => a + b) / list.length;
  }

  VitalityTrendDirection _trend(double current, double previous) {
    if (current <= 0 || previous <= 0) return VitalityTrendDirection.stable;
    if (current > previous + 0.5) return VitalityTrendDirection.improving;
    if (current < previous - 0.5) return VitalityTrendDirection.declining;
    return VitalityTrendDirection.stable;
  }

  Map<String, dynamic> _progressToJson(VitalityProgramProgress p) => {
        'current_week': p.currentWeek,
        'has_started': p.hasStarted,
        'is_complete': p.isProgramComplete,
        'unlocked_weeks': p.unlockedWeeks.toList(),
        'task_dates': p.taskCompletionDates,
        'badges': p.earnedBadges.toList(),
        'category_streaks': p.categoryStreaks,
        'started_at': p.startedAt?.toIso8601String(),
      };

  VitalityProgramProgress _progressFromJson(Map<String, dynamic> json) {
    final taskDatesRaw = json['task_dates'];
    final taskDates = <String, List<String>>{};
    if (taskDatesRaw is Map) {
      taskDatesRaw.forEach((key, value) {
        if (value is List) {
          taskDates[key.toString()] = value.map((e) => e.toString()).toList();
        }
      });
    }

    final streaksRaw = json['category_streaks'];
    final streaks = <String, int>{};
    if (streaksRaw is Map) {
      streaksRaw.forEach((key, value) {
        streaks[key.toString()] = (value as num?)?.toInt() ?? 0;
      });
    }

    return VitalityProgramProgress(
      currentWeek: json['current_week'] as int? ?? 1,
      hasStarted: json['has_started'] as bool? ?? false,
      isProgramComplete: json['is_complete'] as bool? ?? false,
      unlockedWeeks: (json['unlocked_weeks'] as List<dynamic>? ?? [1])
          .map((e) => (e as num).toInt())
          .toSet(),
      taskCompletionDates: taskDates,
      earnedBadges: (json['badges'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet(),
      categoryStreaks: streaks,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> _metricsToJson(VitalityMetrics m) => {
        'date': m.date.toIso8601String(),
        'morning_energy': m.morningEnergyScore,
        'sleep_quality': m.sleepQuality,
        'workout_performance': m.workoutPerformance,
        'stress_level': m.stressLevel,
        'body_fat': m.bodyFatPercentage,
        'weight': m.weight,
      };

  VitalityMetrics _metricsFromJson(Map<String, dynamic> json) {
    return VitalityMetrics(
      date: DateTime.parse(json['date'] as String),
      morningEnergyScore: json['morning_energy'] as int? ?? 5,
      sleepQuality: json['sleep_quality'] as int? ?? 5,
      workoutPerformance: json['workout_performance'] as int? ?? 5,
      stressLevel: json['stress_level'] as int? ?? 5,
      bodyFatPercentage: (json['body_fat'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }
}

String vitalityProgramTodayKey() => _dateKey(DateTime.now());

VitalityTaskCategory? categoryFromTaskId(String taskId, List<VitalityWeek> weeks) {
  for (final week in weeks) {
    for (final task in week.dailyTasks) {
      if (task.id == taskId) return task.category;
    }
  }
  return null;
}
