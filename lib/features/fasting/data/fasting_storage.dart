import 'dart:convert';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/fasting/domain/fasting_plan.dart';
import 'package:vireo/features/fasting/domain/fasting_safety.dart';
import 'package:vireo/features/fasting/domain/fasting_session.dart';

class FastingStorage {
  static const _activeSessionKey = 'fasting_active_session_json';
  static const _historyKey = 'fasting_history_sessions_json';
  static const _selectedPlanKey = 'fasting_selected_plan_name';
  static const _customHoursKey = 'fasting_custom_hours';
  static const _safetyKey = 'fasting_safety_profile_json';

  static FastingSession? loadActiveSession() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(_activeSessionKey);
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return FastingSession.fromJson(decoded);
      } catch (_) {}
    }
    return null;
  }

  static Future<void> saveActiveSession(FastingSession? session) async {
    if (!HiveService.isInitialized) return;
    if (session == null) {
      await HiveService.settingsBox.delete(_activeSessionKey);
    } else {
      await HiveService.settingsBox.put(_activeSessionKey, jsonEncode(session.toJson()));
    }
  }

  static List<FastingSession> loadHistory() {
    if (!HiveService.isInitialized) return [];
    final raw = HiveService.settingsBox.get(_historyKey);
    if (raw is String && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List;
        return list
            .map((item) => FastingSession.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
    return [];
  }

  static Future<void> saveHistory(List<FastingSession> sessions) async {
    if (!HiveService.isInitialized) return;
    final jsonList = sessions.map((s) => s.toJson()).toList();
    await HiveService.settingsBox.put(_historyKey, jsonEncode(jsonList));
  }

  static FastingPlanType loadSelectedPlan() {
    if (!HiveService.isInitialized) return FastingPlanType.p16_8;
    final name = HiveService.settingsBox.get(_selectedPlanKey) as String?;
    return FastingPlanType.values.firstWhere(
      (p) => p.name == name,
      orElse: () => FastingPlanType.p16_8,
    );
  }

  static Future<void> saveSelectedPlan(FastingPlanType plan) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_selectedPlanKey, plan.name);
  }

  static int loadCustomHours() {
    if (!HiveService.isInitialized) return 16;
    return (HiveService.settingsBox.get(_customHoursKey) as int?) ?? 16;
  }

  static Future<void> saveCustomHours(int hours) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_customHoursKey, hours);
  }

  static FastingSafetyProfile loadSafetyProfile() {
    if (!HiveService.isInitialized) return const FastingSafetyProfile();
    final raw = HiveService.settingsBox.get(_safetyKey);
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return FastingSafetyProfile.fromJson(decoded);
      } catch (_) {}
    }
    return const FastingSafetyProfile();
  }

  static Future<void> saveSafetyProfile(FastingSafetyProfile profile) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_safetyKey, jsonEncode(profile.toJson()));
  }
}
