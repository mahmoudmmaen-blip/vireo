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

  bool get isOnboardingComplete {
    if (!HiveService.isInitialized) return false;
    return HiveService.settingsBox.get(onboardingCompleteKey, defaultValue: false)
        as bool;
  }

  Future<void> markOnboardingComplete() async {
    await HiveService.settingsBox.put(onboardingCompleteKey, true);
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
    } catch (_) {
      rethrow;
    }
  }

  /// Calls AI Coach edge function to generate week-1 program.
  Future<Map<String, dynamic>> generateWeekOneProgram({
    required String userId,
    required OnboardingDraft draft,
  }) async {
    if (!SupabaseService.isInitialized) {
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
        final data = response.data;
        final message = data is Map ? data['error']?.toString() : null;
        throw OnboardingException(message ?? 'Program generation failed.');
      }

      return Map<String, dynamic>.from(response.data as Map);
    } catch (_) {
      rethrow;
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
    try {
      await saveNotificationPreferences(draft);

      final effectiveUserId =
          userId ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';

      if (userId != null) {
        await saveProfileToSupabase(userId: userId, draft: draft);
        await generateWeekOneProgram(userId: userId, draft: draft);
      } else {
        await HiveService.cacheBox.put('guest_profile', draft.toUserRow(effectiveUserId));
      }

      await OnboardingCalorieSync.syncFromDraft(draft);
      await WorkoutRepository.saveProgramStart(DateTime.now());
      await markOnboardingComplete();
    } catch (_) {
      rethrow;
    }
  }
}

class OnboardingException implements Exception {
  const OnboardingException(this.message);
  final String message;

  @override
  String toString() => message;
}
