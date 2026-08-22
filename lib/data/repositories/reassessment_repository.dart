import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/data/models/training_environment.dart';

class ReassessmentRepository {
  const ReassessmentRepository();

  static const minDaysBetween = 28;
  static const maxDaysBetween = 42;
  static const lastReassessmentKey = 'last_reassessment_at';
  static const meaningfulWeightDeltaKg = 2.0;

  Future<bool> isReassessmentDue() async {
    final last = await _lastReassessmentDate();
    if (last == null) {
      final onboarding = HiveService.settingsBox.get('onboarding_complete');
      if (onboarding != true) return false;
      return true;
    }
    final days = DateTime.now().difference(last).inDays;
    return days >= minDaysBetween;
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
