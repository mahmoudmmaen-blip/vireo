import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/engagement/domain/daily_coin_task.dart';
import 'package:vireo/features/engagement/services/coins_service.dart';
import 'package:vireo/features/fasting/data/fasting_storage.dart';
import 'package:vireo/features/fasting/domain/fasting_plan.dart';
import 'package:vireo/features/fasting/domain/fasting_safety.dart';
import 'package:vireo/features/fasting/domain/fasting_session.dart';
import 'package:vireo/features/fasting/services/fasting_notification_service.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

class FastingState {
  const FastingState({
    this.activeSession,
    required this.selectedPlan,
    required this.customHours,
    required this.history,
    required this.safety,
    this.isRamadanSync = false,
  });

  final FastingSession? activeSession;
  final FastingPlanType selectedPlan;
  final int customHours;
  final List<FastingSession> history;
  final FastingSafetyProfile safety;
  final bool isRamadanSync;

  bool get isFasting => activeSession != null && activeSession!.isActive;

  int get completedCount => history.where((s) => s.isCompleted).length;

  int get currentStreak {
    if (history.isEmpty) return 0;
    final completed = history.where((s) => s.isCompleted).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    if (completed.isEmpty) return 0;

    var streak = 0;
    var checkDate = DateTime.now();

    // Group completed sessions by day
    final days = <String>{};
    for (final s in completed) {
      final key = '${s.startTime.year}-${s.startTime.month}-${s.startTime.day}';
      days.add(key);
    }

    final todayKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
    final yesterday = checkDate.subtract(const Duration(days: 1));
    final yesterdayKey = '${yesterday.year}-${yesterday.month}-${yesterday.day}';

    // If today is completed, start from today, else if yesterday was completed, start from yesterday
    var current = days.contains(todayKey) ? checkDate : (days.contains(yesterdayKey) ? yesterday : null);
    if (current == null) return 0;

    while (true) {
      final k = '${current!.year}-${current.month}-${current.day}';
      if (days.contains(k)) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  double get averageFastHours {
    final completed = history.where((s) => s.isCompleted).toList();
    if (completed.isEmpty) return 0.0;
    final totalHours = completed.fold<double>(
      0.0,
      (sum, s) => sum + (s.elapsed.inMinutes / 60.0),
    );
    return totalHours / completed.length;
  }

  double get longestFastHours {
    final completed = history.where((s) => s.isCompleted).toList();
    if (completed.isEmpty) return 0.0;
    return completed
        .map((s) => s.elapsed.inMinutes / 60.0)
        .reduce((a, b) => a > b ? a : b);
  }

  FastingState copyWith({
    FastingSession? activeSession,
    bool clearActiveSession = false,
    FastingPlanType? selectedPlan,
    int? customHours,
    List<FastingSession>? history,
    FastingSafetyProfile? safety,
    bool? isRamadanSync,
  }) {
    return FastingState(
      activeSession: clearActiveSession ? null : (activeSession ?? this.activeSession),
      selectedPlan: selectedPlan ?? this.selectedPlan,
      customHours: customHours ?? this.customHours,
      history: history ?? this.history,
      safety: safety ?? this.safety,
      isRamadanSync: isRamadanSync ?? this.isRamadanSync,
    );
  }
}

class FastingNotifier extends StateNotifier<FastingState> {
  FastingNotifier(this.ref, [FastingState? initialState])
      : super(initialState ?? _loadInitialState()) {
    if (initialState == null) {
      _checkRamadanAutoSync();
    }
  }

  final Ref ref;

  static FastingState _loadInitialState() {
    final active = FastingStorage.loadActiveSession();
    final plan = FastingStorage.loadSelectedPlan();
    final custom = FastingStorage.loadCustomHours();
    final history = FastingStorage.loadHistory();
    final safety = FastingStorage.loadSafetyProfile();

    return FastingState(
      activeSession: active,
      selectedPlan: plan,
      customHours: custom,
      history: history,
      safety: safety,
    );
  }

  void _checkRamadanAutoSync() {
    final ramadanState = ref.read(ramadanSettingsProvider);
    if (ramadanState.isEnabled) {
      state = state.copyWith(isRamadanSync: true);
    }
  }

  /// Starts a new fast.
  Future<bool> startFast({
    DateTime? customStartTime,
    FastingPlanType? plan,
    int? customHours,
    bool isArabic = true,
  }) async {
    final targetPlan = plan ?? state.selectedPlan;
    var targetH = targetPlan == FastingPlanType.custom
        ? (customHours ?? state.customHours)
        : targetPlan.defaultFastHours;

    // Hard safety cap: max 72 hours
    if (targetH > 72) targetH = 72;

    final ramadanState = ref.read(ramadanSettingsProvider);
    final isRamadan = ramadanState.isEnabled;

    if (isRamadan) {
      final schedule = RamadanPrayerTimes.calculate(
        date: DateTime.now(),
        method: ramadanState.calculationMethod,
        lat: ramadanState.latitude,
        lng: ramadanState.longitude,
      );
      final fajrToMaghrib = schedule.maghrib.difference(schedule.fajr);
      targetH = (fajrToMaghrib.inMinutes / 60.0).ceil();
    }

    final newSession = FastingSession(
      id: 'fast_${DateTime.now().millisecondsSinceEpoch}',
      planType: targetPlan,
      targetHours: targetH,
      startTime: customStartTime ?? DateTime.now(),
      isRamadan: isRamadan,
    );

    state = state.copyWith(activeSession: newSession);
    await FastingStorage.saveActiveSession(newSession);

    // Schedule milestone notifications
    await FastingNotificationService.instance.scheduleSessionNotifications(
      newSession,
      isArabic: isArabic,
    );

    return true;
  }

  /// Ends the active fast. Awards 15 coins once per completed fast.
  Future<int> endFast({bool isArabic = true}) async {
    final current = state.activeSession;
    if (current == null) return 0;

    final endedSession = current.copyWith(
      endTime: DateTime.now(),
    );

    // Completion rule: completed if elapsed >= target duration OR elapsed >= 12 hours
    final isCompleted = endedSession.elapsed >= endedSession.targetDuration ||
        endedSession.elapsed >= const Duration(hours: 12);

    var coinsAwarded = 0;
    var markedCoins = current.coinsAwarded;

    if (isCompleted && !current.coinsAwarded) {
      coinsAwarded = await CoinsService.awardTask(DailyCoinTask.fasting);
      markedCoins = true;
    }

    final finalizedSession = endedSession.copyWith(
      isCompleted: isCompleted,
      coinsAwarded: markedCoins,
    );

    final updatedHistory = [finalizedSession, ...state.history];

    state = state.copyWith(
      clearActiveSession: true,
      history: updatedHistory,
    );

    await FastingStorage.saveActiveSession(null);
    await FastingStorage.saveHistory(updatedHistory);
    await FastingNotificationService.instance.cancelAllFastingNotifications();

    // Schedule eating window closing reminder based on plan
    final eatingHours = current.planType.defaultEatingHours;
    final windowCloseTime = DateTime.now().add(Duration(hours: eatingHours));
    await FastingNotificationService.instance.scheduleEatingWindowClosing(
      windowCloseTime,
      isArabic: isArabic,
    );

    return coinsAwarded;
  }

  /// Edits the start time of the active fast (e.g. "بدأت من ساعتين").
  Future<void> editStartTime(DateTime newStartTime, {bool isArabic = true}) async {
    final current = state.activeSession;
    if (current == null) return;

    final updated = current.copyWith(startTime: newStartTime);
    state = state.copyWith(activeSession: updated);
    await FastingStorage.saveActiveSession(updated);

    await FastingNotificationService.instance.scheduleSessionNotifications(
      updated,
      isArabic: isArabic,
    );
  }

  /// Changes the user's preferred fasting plan.
  Future<void> selectPlan(FastingPlanType plan, {int? customHours}) async {
    state = state.copyWith(
      selectedPlan: plan,
      customHours: customHours,
    );
    await FastingStorage.saveSelectedPlan(plan);
    if (customHours != null) {
      await FastingStorage.saveCustomHours(customHours);
    }
  }

  /// Cancels the current fast without saving to history.
  Future<void> cancelFast() async {
    state = state.copyWith(clearActiveSession: true);
    await FastingStorage.saveActiveSession(null);
    await FastingNotificationService.instance.cancelAllFastingNotifications();
  }

  /// Updates safety profile flags.
  Future<void> updateSafety(FastingSafetyProfile safety) async {
    state = state.copyWith(safety: safety);
    await FastingStorage.saveSafetyProfile(safety);
  }
}

final fastingProvider = StateNotifierProvider<FastingNotifier, FastingState>((ref) {
  return FastingNotifier(ref);
});
