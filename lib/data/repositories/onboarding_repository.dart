import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/onboarding_calorie_sync.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/models/onboarding_draft.dart';
import 'package:vireo/data/repositories/workout_repository.dart';

class OnboardingRepository {
  const OnboardingRepository();

  static const onboardingCompleteKey = 'onboarding_complete';
  static const notificationPrefsKey = 'notification_preferences';
  static const onboardingDraftKey = 'onboarding_draft';
  static const onboardingStepKey = 'onboarding_current_step';

  bool get isOnboardingComplete {
    if (!HiveService.isInitialized) return false;
    return HiveService.settingsBox.get(onboardingCompleteKey, defaultValue: false)
        as bool;
  }

  Future<void> saveDraft(OnboardingDraft draft) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(onboardingDraftKey, draft.toJson());
  }

  OnboardingDraft? readDraft() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(onboardingDraftKey);
    if (raw is! Map) return null;
    try {
      return OnboardingDraft.fromJson(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveStep(int step) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(onboardingStepKey, step);
  }

  int readStep() {
    if (!HiveService.isInitialized) return 0;
    final val = HiveService.settingsBox.get(onboardingStepKey, defaultValue: 0);
    return val is int ? val : 0;
  }

  Future<void> clearDraftAndStep() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.delete(onboardingDraftKey);
    await HiveService.settingsBox.delete(onboardingStepKey);
  }

  static const onboardingCompletedAtKey = 'onboarding_completed_at';

  Future<void> markOnboardingComplete() async {
    await HiveService.settingsBox.put(onboardingCompleteKey, true);
    await HiveService.settingsBox.put(
      onboardingCompletedAtKey,
      DateTime.now().toUtc().toIso8601String(),
    );
    await clearDraftAndStep();
  }

  Future<void> saveNotificationPreferences(OnboardingDraft draft) async {
    await HiveService.settingsBox.put(notificationPrefsKey, {
      'preferred_workout_time':
          draft.preferredWorkoutTime?.toIso8601String(),
      'walking_reminder_enabled': draft.walkingReminderEnabled,
      'weekly_checkin_reminder_enabled':
          draft.weeklyCheckInReminderEnabled,
    });
  }

  Future<void> saveProfileToSupabase({
    required String userId,
    required OnboardingDraft draft,
  }) async {
    if (!SupabaseService.isInitialized) {
      await HiveService.cacheBox.put('pending_profile_$userId', draft.toUserRow(userId));
      return;
    }

    try {
      await SupabaseService.client.from('users').upsert(draft.toUserRow(userId));
    } catch (e) {
      BootLog.warn('OnboardingRepository.saveProfileToSupabase failed', e);
      await HiveService.cacheBox.put('pending_profile_$userId', draft.toUserRow(userId));
    }
  }

  /// Calls AI Coach edge function to generate week-1 program.
  /// Never throws — returns empty map and relies on local [ProgramGenerator].
  Future<Map<String, dynamic>> generateWeekOneProgram({
    required String userId,
    required OnboardingDraft draft,
  }) async {
    if (!SupabaseService.isInitialized) {
      BootLog.step('generate-program skipped (offline) — local ProgramGenerator');
      return {'offline': true};
    }

    try {
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.generateProgramFunctionName,
        body: {
          'user_id': userId,
          'week_number': 1,
          'profile': draft.toUserRow(userId),
        },
      );

      if (response.status >= 400) {
        BootLog.warn(
          'generate-program HTTP ${response.status}',
          response.data,
        );
        return {'fallback': true};
      }

      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return {'ok': true};
    } catch (e) {
      BootLog.warn('generate-program failed — local ProgramGenerator', e);
      return {'fallback': true};
    }
  }

  /// Best-effort meal plan generation — never blocks onboarding.
  Future<void> generateMealPlanQuietly({required int weekNumber}) async {
    if (!SupabaseService.isInitialized) return;
    try {
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.generateMealPlanFunctionName,
        body: {'week_number': weekNumber},
      );
      if (response.status >= 400) {
        BootLog.warn(
          'generate-meal-plan HTTP ${response.status}',
          response.data,
        );
      }
    } catch (e) {
      BootLog.warn('generate-meal-plan failed', e);
    }
  }

  /// Uploads locally cached guest profile after the user creates an account.
  Future<void> syncGuestProfileToCloud({required String userId}) async {
    if (!SupabaseService.isInitialized) {
      throw const OnboardingException('Cloud sync is unavailable.');
    }

    try {
      final cached = HiveService.cacheBox.get('guest_profile');
      if (cached is! Map) {
        throw const OnboardingException('No local profile to sync.');
      }

      final row = Map<String, dynamic>.from(cached);
      row['id'] = userId;

      await SupabaseService.client.from('users').upsert(row);

      final draft = _draftFromGuestRow(row);
      await generateWeekOneProgram(userId: userId, draft: draft);
    } catch (_) {
      rethrow;
    }
  }

  OnboardingDraft _draftFromGuestRow(Map<String, dynamic> row) {
    return OnboardingDraft(
      age: row['age'] as int?,
      heightCm: (row['height_cm'] as num?)?.toDouble(),
      weightKg: (row['weight_kg'] as num?)?.toDouble(),
    );
  }

  Future<void> completeOnboarding({
    required String? userId,
    required OnboardingDraft draft,
  }) async {
    await saveNotificationPreferences(draft);

    final effectiveUserId =
        userId ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';

    await HiveService.cacheBox.put('guest_profile', draft.toUserRow(effectiveUserId));

    if (userId != null) {
      await saveProfileToSupabase(userId: userId, draft: draft);
      await generateWeekOneProgram(userId: userId, draft: draft);
      await generateMealPlanQuietly(weekNumber: 1);
    }

    await OnboardingCalorieSync.syncFromDraft(draft);
    await WorkoutRepository.saveProgramStart(DateTime.now());
    await markOnboardingComplete();
  }
}

class OnboardingException implements Exception {
  const OnboardingException(this.message);
  final String message;

  @override
  String toString() => message;
}
