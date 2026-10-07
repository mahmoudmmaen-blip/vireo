import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/vitality_program/data/vitality_program_repository.dart';
import 'package:vireo/features/vitality_program/domain/vitality_metrics.dart';
import 'package:vireo/features/vitality_program/domain/vitality_week.dart';

final vitalityProgramRepositoryProvider = Provider<VitalityProgramRepository>(
  (ref) => const VitalityProgramRepository(),
);

class VitalityProgramState {
  const VitalityProgramState({
    required this.progress,
    required this.weeks,
    this.isLoading = false,
  });

  final VitalityProgramProgress progress;
  final List<VitalityWeek> weeks;
  final bool isLoading;

  VitalityWeek? get currentWeekData {
    for (final w in weeks) {
      if (w.weekNumber == progress.currentWeek) return w;
    }
    return weeks.isNotEmpty ? weeks.first : null;
  }

  double get overallProgress {
    if (weeks.isEmpty) return 0;
    final sum = weeks.fold<double>(0, (a, w) => a + w.completionPercentage);
    return (sum / weeks.length).clamp(0, 100);
  }

  VitalityProgramState copyWith({
    VitalityProgramProgress? progress,
    List<VitalityWeek>? weeks,
    bool? isLoading,
  }) =>
      VitalityProgramState(
        progress: progress ?? this.progress,
        weeks: weeks ?? this.weeks,
        isLoading: isLoading ?? this.isLoading,
      );
}

class VitalityProgramNotifier extends Notifier<VitalityProgramState> {
  late VitalityProgramRepository _repo;

  @override
  VitalityProgramState build() {
    _repo = ref.read(vitalityProgramRepositoryProvider);
    final progress = _repo.loadProgress();
    final weeks = _repo.buildWeeksWithProgress(progress);
    return VitalityProgramState(progress: progress, weeks: weeks);
  }

  Future<void> startProgram() async {
    var progress = state.progress.copyWith(
      hasStarted: true,
      startedAt: DateTime.now(),
      unlockedWeeks: {1},
      currentWeek: 1,
    );
    await _persist(progress);
  }

  Future<void> completeTask(String taskId) async {
    final today = vitalityProgramTodayKey();
    var progress = state.progress;
    if (!progress.hasStarted) {
      await startProgram();
      progress = state.progress;
    }

    final dates = Map<String, List<String>>.from(progress.taskCompletionDates);
    final taskDates = List<String>.from(dates[taskId] ?? []);
    if (!taskDates.contains(today)) {
      taskDates.add(today);
    }
    dates[taskId] = taskDates;

    final category = categoryFromTaskId(taskId, state.weeks);
    var streaks = Map<String, int>.from(progress.categoryStreaks);
    var badges = Set<String>.from(progress.earnedBadges);
    if (category != null) {
      final key = category.name;
      streaks[key] = (streaks[key] ?? 0) + 1;
      if ((streaks[key] ?? 0) >= 7 && !badges.contains('streak_master')) {
        badges = {...badges, 'streak_master'};
      }
    }

    progress = progress.copyWith(
      taskCompletionDates: dates,
      categoryStreaks: streaks,
      earnedBadges: badges,
    );

    await _persist(progress);
    await _maybeUnlockNextWeek();
  }

  Future<void> uncompleteTask(String taskId) async {
    final today = vitalityProgramTodayKey();
    final dates = Map<String, List<String>>.from(state.progress.taskCompletionDates);
    final taskDates = List<String>.from(dates[taskId] ?? [])..remove(today);
    dates[taskId] = taskDates;
    await _persist(state.progress.copyWith(taskCompletionDates: dates));
  }

  Future<void> toggleTask(String taskId, bool completed) async {
    if (completed) {
      await completeTask(taskId);
    } else {
      await uncompleteTask(taskId);
    }
  }

  Future<void> _maybeUnlockNextWeek() async {
    final current = state.weeks.firstWhere(
      (w) => w.weekNumber == state.progress.currentWeek,
    );
    if (current.completionPercentage < 80) return;

    final next = state.progress.currentWeek + 1;
    if (next > 12) {
      var progress = state.progress.copyWith(isProgramComplete: true);
      var badges = Set<String>.from(progress.earnedBadges);
      if (!badges.contains('vitality_legend')) {
        badges = {...badges, 'vitality_legend'};
      }
      progress = progress.copyWith(earnedBadges: badges);
      await _persist(progress);
      return;
    }

    final unlocked = Set<int>.from(state.progress.unlockedWeeks)..add(next);
    await _persist(
      state.progress.copyWith(
        unlockedWeeks: unlocked,
        currentWeek: next,
      ),
    );
  }

  Future<void> unlockNextWeek() async {
    final current = state.weeks.firstWhere(
      (w) => w.weekNumber == state.progress.currentWeek,
    );
    if (current.completionPercentage < 80) return;
    await _maybeUnlockNextWeek();
  }

  VitalityWeeklyReport getWeeklyReport(int weekNumber) {
    final metrics = ref.read(vitalityMetricsProvider);
    return _repo.buildWeeklyReport(weekNumber, state.progress, metrics);
  }

  Future<void> _persist(VitalityProgramProgress progress) async {
    await _repo.saveProgress(progress);
    final weeks = _repo.buildWeeksWithProgress(progress);
    state = state.copyWith(progress: progress, weeks: weeks);
  }
}

final vitalityProgramProvider =
    NotifierProvider<VitalityProgramNotifier, VitalityProgramState>(
  VitalityProgramNotifier.new,
);

class VitalityMetricsNotifier extends Notifier<List<VitalityMetrics>> {
  @override
  List<VitalityMetrics> build() {
    return ref.read(vitalityProgramRepositoryProvider).loadMetricsHistory();
  }

  Future<void> logMetrics(VitalityMetrics metrics) async {
    final repo = ref.read(vitalityProgramRepositoryProvider);
    final today = DateTime(metrics.date.year, metrics.date.month, metrics.date.day);
    final updated = [...state.where((m) {
      final d = DateTime(m.date.year, m.date.month, m.date.day);
      return d != today;
    }), metrics];
    updated.sort((a, b) => a.date.compareTo(b.date));
    state = updated;
    await repo.saveMetricsHistory(updated);
  }

  List<VitalityMetrics> lastDays(int count) {
    if (state.length <= count) return state;
    return state.sublist(state.length - count);
  }
}

final vitalityMetricsProvider =
    NotifierProvider<VitalityMetricsNotifier, List<VitalityMetrics>>(
  VitalityMetricsNotifier.new,
);

final vitalityStreakProvider = Provider<int>((ref) {
  final progress = ref.watch(vitalityProgramProvider).progress;
  if (progress.categoryStreaks.isEmpty) return 0;
  return progress.categoryStreaks.values.reduce((a, b) => a > b ? a : b);
});

final vitalityProgramStartedProvider = Provider<bool>((ref) {
  return ref.watch(vitalityProgramProvider).progress.hasStarted;
});

final vitalityProgramOverallProgressProvider = Provider<double>((ref) {
  return ref.watch(vitalityProgramProvider).overallProgress;
});
