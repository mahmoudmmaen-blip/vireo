import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/data/models/unit_preference.dart';
import 'package:vireo/data/repositories/progress_repository.dart';
import 'package:vireo/data/repositories/reassessment_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => const ProgressRepository(),
);

final reassessmentRepositoryProvider = Provider<ReassessmentRepository>(
  (ref) => const ReassessmentRepository(),
);

final progressTabProvider = StateProvider<ProgressTab>((ref) => ProgressTab.weight);

final weightLogsProvider = FutureProvider<List<WeightLogEntry>>((ref) async {
  return ref.read(progressRepositoryProvider).fetchWeightLogs();
});

final weightGoalProvider = FutureProvider<double?>((ref) async {
  return ref.read(progressRepositoryProvider).fetchWeightGoalKg();
});

final adherenceWeeksProvider = FutureProvider<List<AdherenceWeek>>((ref) async {
  return ref.read(progressRepositoryProvider).fetchAdherenceWeeks();
});

final energyCheckInsProvider = FutureProvider<List<EnergyCheckIn>>((ref) async {
  return ref.read(progressRepositoryProvider).fetchEnergyCheckIns();
});

final unitPreferenceProvider = Provider<UnitPreference>((ref) {
  final locale = ref.watch(localeProvider);
  final stored = HiveService.settingsBox.get('unit_preference') as String?;
  if (stored != null) return UnitPreference.fromValue(stored);

  final guest = HiveService.cacheBox.get('guest_profile');
  if (guest is Map && guest['unit_preference'] != null) {
    return UnitPreference.fromValue(guest['unit_preference'] as String);
  }

  return UnitPreference.fromLocale(locale.countryCode);
});

final reassessmentDueProvider = FutureProvider<bool>((ref) async {
  return ref.read(reassessmentRepositoryProvider).isReassessmentDue();
});

final lastReassessmentProvider = FutureProvider<ReassessmentRecord?>((ref) async {
  return ref.read(reassessmentRepositoryProvider).fetchLastReassessment();
});
