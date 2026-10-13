import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/women_health/models/cycle_data.dart';
import 'package:vireo/features/women_health/services/women_health_service.dart';

class WomenHealthModeNotifier extends StateNotifier<WomenMode> {
  WomenHealthModeNotifier() : super(WomenHealthService.readMode());

  Future<void> setMode(WomenMode mode) async {
    state = mode;
    await WomenHealthService.saveMode(mode);
  }
}

final womenHealthModeProvider =
    StateNotifierProvider<WomenHealthModeNotifier, WomenMode>((ref) {
  return WomenHealthModeNotifier();
});

class PregnancyTrimesterNotifier extends StateNotifier<PregnancyTrimester> {
  PregnancyTrimesterNotifier() : super(WomenHealthService.readTrimester());

  Future<void> setTrimester(PregnancyTrimester trimester) async {
    state = trimester;
    await WomenHealthService.saveTrimester(trimester);
  }
}

final pregnancyTrimesterProvider =
    StateNotifierProvider<PregnancyTrimesterNotifier, PregnancyTrimester>((ref) {
  return PregnancyTrimesterNotifier();
});

class CycleEntriesNotifier extends StateNotifier<List<CycleLogEntry>> {
  CycleEntriesNotifier() : super(WomenHealthService.readEntries());

  Future<void> logEntry(CycleLogEntry entry) async {
    await WomenHealthService.saveEntry(entry);
    state = WomenHealthService.readEntries();
  }

  Future<void> clearAll() async {
    await WomenHealthService.clearAllCycleData();
    state = [];
  }
}

final cycleEntriesProvider =
    StateNotifierProvider<CycleEntriesNotifier, List<CycleLogEntry>>((ref) {
  return CycleEntriesNotifier();
});

final latestCycleEntryProvider = Provider<CycleLogEntry?>((ref) {
  final entries = ref.watch(cycleEntriesProvider);
  return entries.isNotEmpty ? entries.first : null;
});

final currentCyclePhaseProvider = Provider<CyclePhase?>((ref) {
  final entry = ref.watch(latestCycleEntryProvider);
  if (entry == null) return null;
  return WomenHealthService.predictPhase(
    lastPeriodStart: entry.startDate,
    cycleLength: entry.cycleLength,
    periodLength: entry.periodLength,
  );
});

final isLutealPhaseProvider = Provider<bool>((ref) {
  return ref.watch(currentCyclePhaseProvider) == CyclePhase.luteal;
});

final daysUntilNextPeriodProvider = Provider<int?>((ref) {
  final entry = ref.watch(latestCycleEntryProvider);
  if (entry == null) return null;
  return WomenHealthService.daysUntilNextPeriod(
    lastPeriodStart: entry.startDate,
    cycleLength: entry.cycleLength,
  );
});

final isPregnancyOrBreastfeedingProvider = Provider<bool>((ref) {
  final mode = ref.watch(womenHealthModeProvider);
  return mode == WomenMode.pregnant || mode == WomenMode.breastfeeding;
});

class WomenCalorieAdjustment {
  const WomenCalorieAdjustment({
    required this.disableDeficit,
    required this.surplusKcal,
    required this.reason,
  });

  final bool disableDeficit;
  final int surplusKcal;
  final String? reason;
}

final womenCalorieAdjustmentProvider = Provider<WomenCalorieAdjustment>((ref) {
  final mode = ref.watch(womenHealthModeProvider);
  if (mode == WomenMode.breastfeeding) {
    return const WomenCalorieAdjustment(
      disableDeficit: true,
      surplusKcal: 350, // +330-400 kcal spec
      reason: 'الرضاعة الطبيعية (+350 سعرة)',
    );
  }
  if (mode == WomenMode.pregnant) {
    final trimester = ref.watch(pregnancyTrimesterProvider);
    return WomenCalorieAdjustment(
      disableDeficit: true,
      surplusKcal: trimester.surplusKcal,
      reason: 'الحمل: ${trimester.displayNameAr} (+${trimester.surplusKcal} سعرة)',
    );
  }
  return const WomenCalorieAdjustment(
    disableDeficit: false,
    surplusKcal: 0,
    reason: null,
  );
});
