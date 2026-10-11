import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';

/// Hive keys + helpers for the active diet plan and screening answers.
abstract final class DietPlanStorage {
  static const activeProgramIdKey = 'diet_active_program_id';
  static const startDateKey = 'diet_program_start_date';
  static const conditionsKey = 'diet_health_conditions';
  static const preferencesKey = 'diet_preferences';
  static const doctorApprovedKey = 'diet_doctor_approved_ids';
  static const eatingWindowStartHourKey = 'diet_eating_window_start_hour';
  static const pendingQuizKey = 'pending_diet_quiz';

  static String? readActiveProgramId() {
    if (!HiveService.isInitialized) return null;
    return HiveService.settingsBox.get(activeProgramIdKey) as String?;
  }

  static DateTime? readStartDate() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(startDateKey) as String?;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  static Set<HealthCondition> readConditions() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.settingsBox.get(conditionsKey);
    if (raw is! List) return {};
    final out = <HealthCondition>{};
    for (final e in raw) {
      final c = HealthCondition.fromValue(e.toString());
      if (c != null) out.add(c);
    }
    return out;
  }

  static DietPreferences readPreferences() {
    if (!HiveService.isInitialized) return const DietPreferences();
    final raw = HiveService.settingsBox.get(preferencesKey);
    if (raw is! Map) return const DietPreferences();
    return DietPreferences.fromJson(Map<String, dynamic>.from(raw));
  }

  static Set<String> readDoctorApprovedIds() {
    if (!HiveService.isInitialized) return {};
    final raw = HiveService.settingsBox.get(doctorApprovedKey);
    if (raw is! List) return {};
    return raw.map((e) => e.toString()).toSet();
  }

  static int? readEatingWindowStartHour() {
    if (!HiveService.isInitialized) return null;
    return HiveService.settingsBox.get(eatingWindowStartHourKey) as int?;
  }

  static Future<void> saveConditions(Set<HealthCondition> conditions) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(
      conditionsKey,
      conditions.map((c) => c.value).toList(),
    );
  }

  static Future<void> savePreferences(DietPreferences preferences) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(preferencesKey, preferences.toJson());
  }

  static Future<void> markDoctorApproved(DietProgramId id) async {
    if (!HiveService.isInitialized) return;
    final ids = readDoctorApprovedIds()..add(id.value);
    await HiveService.settingsBox.put(doctorApprovedKey, ids.toList());
  }

  static bool isDoctorApproved(DietProgramId id) =>
      readDoctorApprovedIds().contains(id.value);

  static Future<void> startProgram(
    DietProgramId id, {
    int? eatingWindowStartHour,
  }) async {
    if (!HiveService.isInitialized) return;
    final now = DateTime.now().toIso8601String();
    await HiveService.settingsBox.put(activeProgramIdKey, id.value);
    await HiveService.settingsBox.put(
      startDateKey,
      now,
    );
    if (eatingWindowStartHour != null) {
      await HiveService.settingsBox.put(
        eatingWindowStartHourKey,
        eatingWindowStartHour,
      );
    }
    try {
      await SyncEngine().enqueueChange(
        table: 'user_diet_programs',
        id: 'active_diet_program',
        operation: SyncOperation.update,
        data: {
          'id': 'active_diet_program',
          'program_id': id.value,
          'start_date': now,
          if (eatingWindowStartHour != null) 'eating_window_start_hour': eatingWindowStartHour,
        },
      );
    } catch (_) {}
  }

  static Future<void> clearActiveProgram() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.delete(activeProgramIdKey);
    await HiveService.settingsBox.delete(startDateKey);
    try {
      await SyncEngine().enqueueChange(
        table: 'user_diet_programs',
        id: 'active_diet_program',
        operation: SyncOperation.delete,
        data: {'id': 'active_diet_program'},
      );
    } catch (_) {}
  }

  static Future<void> setEatingWindowStartHour(int hour) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(
      eatingWindowStartHourKey,
      hour.clamp(0, 23),
    );
  }

  static Future<void> setPendingQuiz(bool value) async {
    if (!HiveService.isInitialized) return;
    if (value) {
      await HiveService.settingsBox.put(pendingQuizKey, true);
    } else {
      await HiveService.settingsBox.delete(pendingQuizKey);
    }
  }

  static bool readPendingQuiz() {
    if (!HiveService.isInitialized) return false;
    return HiveService.settingsBox.get(pendingQuizKey, defaultValue: false) ==
        true;
  }
}
