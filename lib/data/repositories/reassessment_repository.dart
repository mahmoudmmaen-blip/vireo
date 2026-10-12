import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/data/models/training_environment.dart';

class ReassessmentRepository {
  const ReassessmentRepository();

  static const minDaysBetween = 30;
  static const maxDaysBetween = 42;
  static const snoozeDays = 3;
  static const onboardingGraceDays = 7;
  static const lastReassessmentKey = 'last_reassessment_at';
  static const snoozeUntilKey = 'reassessment_snoozed_until';
  static const onboardingCompletedAtKey = 'onboarding_completed_at';
  static const meaningfulWeightDeltaKg = 2.0;

  Future<bool> isReassessmentDue() async {
    final onboarding = HiveService.settingsBox.get('onboarding_complete') == true;
    if (!onboarding) return false;

    final last = await _lastReassessmentDate();
    final snoozedUntil = _readSnoozedUntil();
    var onboardingCompletedAt = _readOnboardingCompletedAt();
    if (onboardingCompletedAt == null) {
      onboardingCompletedAt = DateTime.now();
      await HiveService.settingsBox.put(
        onboardingCompletedAtKey,
        onboardingCompletedAt.toUtc().toIso8601String(),
      );
    }

    return isReassessmentDueFor(
      lastReassessment: last,
      referenceNow: DateTime.now(),
      onboardingComplete: onboarding,
      onboardingCompletedAt: onboardingCompletedAt,
      snoozedUntil: snoozedUntil,
    );
  }

  /// Pure due-check used by [isReassessmentDue] and scheduling tests.
  static bool isReassessmentDueFor({
    required DateTime? lastReassessment,
    required DateTime referenceNow,
    required bool onboardingComplete,
    DateTime? onboardingCompletedAt,
    DateTime? snoozedUntil,
  }) {
    if (!onboardingComplete) return false;

    // 1. Snoozed?
    if (snoozedUntil != null && referenceNow.isBefore(snoozedUntil)) {
      return false;
    }

    // 2. Never show during first 7 days after onboarding
    if (onboardingCompletedAt != null &&
        referenceNow.difference(onboardingCompletedAt).inDays < onboardingGraceDays) {
      return false;
    }

    // 3. Show at most once per 30 days after last completed check-in
    if (lastReassessment != null) {
      return referenceNow.difference(lastReassessment).inDays >= minDaysBetween;
    }

    // 4. If no prior check-in, show after 30 days from onboarding completion
    if (onboardingCompletedAt != null) {
      return referenceNow.difference(onboardingCompletedAt).inDays >= minDaysBetween;
    }

    return false;
  }

  DateTime? _readSnoozedUntil() {
    if (!HiveService.isInitialized) return null;
    final stored = HiveService.settingsBox.get(snoozeUntilKey) as String?;
    if (stored != null) {
      try {
        return DateTime.parse(stored);
      } catch (_) {}
    }
    return null;
  }

  DateTime? _readOnboardingCompletedAt() {
    if (!HiveService.isInitialized) return null;
    final stored = HiveService.settingsBox.get(onboardingCompletedAtKey) as String?;
    if (stored != null) {
      try {
        return DateTime.parse(stored);
      } catch (_) {}
    }
    return null;
  }

  Future<void> snooze({int days = snoozeDays}) async {
    if (!HiveService.isInitialized) return;
    final until = DateTime.now().add(Duration(days: days));
    await HiveService.settingsBox.put(snoozeUntilKey, until.toUtc().toIso8601String());
  }

  Future<DateTime?> _lastReassessmentDate() async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final row = await SupabaseService.client
              .from('users')
              .select('last_reassessment_at')
              .eq('id', userId)
              .maybeSingle();
          final ts = row?['last_reassessment_at'] as String?;
          if (ts != null) return DateTime.parse(ts);
        }
      }
    } catch (_) {}

    final stored = HiveService.settingsBox.get(lastReassessmentKey) as String?;
    if (stored != null) {
      try {
        return DateTime.parse(stored);
      } catch (_) {}
    }
    return null;
  }

  Future<ReassessmentRecord?> fetchLastReassessment() async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final row = await SupabaseService.client
              .from('reassessments')
              .select()
              .eq('user_id', userId)
              .order('created_at', ascending: false)
              .limit(1)
              .maybeSingle();
          if (row != null) {
            return ReassessmentRecord.fromJson(Map<String, dynamic>.from(row));
          }
        }
      }
    } catch (_) {}

    final cached = HiveService.cacheBox.get('last_reassessment');
    if (cached is Map) {
      return ReassessmentRecord.fromJson(Map<String, dynamic>.from(cached));
    }
    return null;
  }

  Future<ReassessmentRecord> completeReassessment({
    required double weightKg,
    required ActivityLevel activityLevel,
    required TrainingEnvironment trainingEnvironment,
  }) async {
    final previous = await fetchLastReassessment();
    final profile = await _currentProfileSnapshot();

    final meaningful = _isMeaningfulChange(
      previousWeightKg: previous?.weightKg ?? profile.weightKg,
      previousActivity: previous?.activityLevel ?? profile.activityLevel,
      previousEnvironment:
          previous?.trainingEnvironment ?? profile.trainingEnvironment,
      weightKg: weightKg,
      activityLevel: activityLevel.value,
      trainingEnvironment: trainingEnvironment.value,
    );

    var phase = profile.programPhase;
    var phaseRecalculated = false;

    if (meaningful) {
      phaseRecalculated = true;
      if (activityLevel == ActivityLevel.sedentary) {
        phase = phase > 1 ? phase - 1 : 1;
      } else if (activityLevel == ActivityLevel.veryActive) {
        phase = phase + 1;
      }
      await _regenerateProgram(
        weightKg: weightKg,
        activityLevel: activityLevel,
        trainingEnvironment: trainingEnvironment,
        phase: phase,
      );
    }

    final now = DateTime.now();
    final record = ReassessmentRecord(
      weightKg: weightKg,
      activityLevel: activityLevel.value,
      trainingEnvironment: trainingEnvironment.value,
      programPhase: phase,
      createdAt: now,
      previousWeightKg: previous?.weightKg ?? profile.weightKg,
      previousActivityLevel: previous?.activityLevel ?? profile.activityLevel,
      previousTrainingEnvironment:
          previous?.trainingEnvironment ?? profile.trainingEnvironment,
      phaseRecalculated: phaseRecalculated,
    );

    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          await SupabaseService.client.from('reassessments').insert({
            'user_id': userId,
            'weight_kg': weightKg,
            'activity_level': activityLevel.value,
            'training_environment': trainingEnvironment.value,
            'program_phase': phase,
            'previous_weight_kg': record.previousWeightKg,
            'previous_activity_level': record.previousActivityLevel,
            'previous_training_environment': record.previousTrainingEnvironment,
            'phase_recalculated': phaseRecalculated,
          });
          await SupabaseService.client.from('users').update({
            'weight_kg': weightKg,
            'activity_level': activityLevel.value,
            'training_environment': trainingEnvironment.value,
            'program_phase': phase,
            'last_reassessment_at': now.toUtc().toIso8601String(),
          }).eq('id', userId);
        }
      }
    } catch (_) {
      // Continue to local cache for offline/guest.
    }

    await HiveService.settingsBox.put(lastReassessmentKey, now.toIso8601String());
    await HiveService.settingsBox.delete(snoozeUntilKey);
    await HiveService.cacheBox.put('last_reassessment', {
      'weight_kg': weightKg,
      'activity_level': activityLevel.value,
      'training_environment': trainingEnvironment.value,
      'program_phase': phase,
      'created_at': now.toIso8601String(),
      'previous_weight_kg': record.previousWeightKg,
      'previous_activity_level': record.previousActivityLevel,
      'previous_training_environment': record.previousTrainingEnvironment,
      'phase_recalculated': phaseRecalculated,
    });

    final guest = HiveService.cacheBox.get('guest_profile');
    if (guest is Map) {
      final updated = Map<String, dynamic>.from(guest);
      updated['weight_kg'] = weightKg;
      updated['activity_level'] = activityLevel.value;
      updated['training_environment'] = trainingEnvironment.value;
      await HiveService.cacheBox.put('guest_profile', updated);
    }

    return record;
  }

  bool _isMeaningfulChange({
    required double? previousWeightKg,
    required String? previousActivity,
    required String? previousEnvironment,
    required double weightKg,
    required String activityLevel,
    required String trainingEnvironment,
  }) {
    if (previousActivity != null && previousActivity != activityLevel) {
      return true;
    }
    if (previousEnvironment != null && previousEnvironment != trainingEnvironment) {
      return true;
    }
    if (previousWeightKg != null &&
        (weightKg - previousWeightKg).abs() >= meaningfulWeightDeltaKg) {
      return true;
    }
    return false;
  }

  Future<void> _regenerateProgram({
    required double weightKg,
    required ActivityLevel activityLevel,
    required TrainingEnvironment trainingEnvironment,
    required int phase,
  }) async {
    if (!SupabaseService.isInitialized) return;
    try {
      final userId = SupabaseService.auth.currentUser?.id;
      if (userId == null) return;

      await SupabaseService.client.functions.invoke(
        AppConfig.generateProgramFunctionName,
        body: {
          'user_id': userId,
          'week_number': phase,
          'profile': {
            'weight_kg': weightKg,
            'activity_level': activityLevel.value,
            'training_environment': trainingEnvironment.value,
          },
        },
      );
    } catch (_) {
      // Non-fatal for offline guests.
    }
  }

  Future<_ProfileSnapshot> _currentProfileSnapshot() async {
    try {
      if (SupabaseService.isInitialized) {
        final userId = SupabaseService.auth.currentUser?.id;
        if (userId != null) {
          final row = await SupabaseService.client
              .from('users')
              .select(
                'weight_kg, activity_level, training_environment, program_phase',
              )
              .eq('id', userId)
              .maybeSingle();
          if (row != null) {
            return _ProfileSnapshot(
              weightKg: (row['weight_kg'] as num?)?.toDouble() ?? 75,
              activityLevel: row['activity_level'] as String? ?? 'moderately_active',
              trainingEnvironment:
                  row['training_environment'] as String? ?? 'home_no_equipment',
              programPhase: row['program_phase'] as int? ?? 1,
            );
          }
        }
      }
    } catch (_) {}

    final guest = HiveService.cacheBox.get('guest_profile');
    if (guest is Map) {
      return _ProfileSnapshot(
        weightKg: (guest['weight_kg'] as num?)?.toDouble() ?? 75,
        activityLevel: guest['activity_level'] as String? ?? 'moderately_active',
        trainingEnvironment:
            guest['training_environment'] as String? ?? 'home_no_equipment',
        programPhase: 1,
      );
    }

    return const _ProfileSnapshot(
      weightKg: 75,
      activityLevel: 'moderately_active',
      trainingEnvironment: 'home_no_equipment',
      programPhase: 1,
    );
  }
}

class _ProfileSnapshot {
  const _ProfileSnapshot({
    required this.weightKg,
    required this.activityLevel,
    required this.trainingEnvironment,
    required this.programPhase,
  });

  final double weightKg;
  final String activityLevel;
  final String trainingEnvironment;
  final int programPhase;
}
