import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _outdoorWorkoutsKey = 'outdoor_workout_sessions';
const _pendingSyncKey = 'outdoor_workouts_pending_sync';

class OutdoorWorkoutRepository {
  List<OutdoorWorkoutSession> loadAll() {
    if (!HiveService.isInitialized) return const [];
    final raw = HiveService.cacheBox.get(_outdoorWorkoutsKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => OutdoorWorkoutSession.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  Future<void> save(OutdoorWorkoutSession session) async {
    if (!HiveService.isInitialized) return;
    final all = loadAll();
    final next = [session, ...all.where((s) => s.id != session.id)];
    await HiveService.cacheBox.put(
      _outdoorWorkoutsKey,
      next.map((s) => s.toJson()).toList(),
    );
    try {
      await SyncEngine().enqueueChange(
        table: 'gps_workouts',
        id: session.id,
        operation: SyncOperation.insert,
        data: {
          'id': session.id,
          'type': session.type.value,
          'started_at': session.startedAt.toUtc().toIso8601String(),
          'ended_at': session.endedAt.toUtc().toIso8601String(),
          'distance_m': session.distanceMeters,
          'duration_s': session.durationSeconds,
          'calories': session.caloriesBurned,
          'payload': session.toJson(),
        },
      );
    } catch (_) {}
  }

  OutdoorWorkoutSession? byId(String id) {
    for (final s in loadAll()) {
      if (s.id == id) return s;
    }
    return null;
  }

  Future<void> syncIfSignedIn(
    OutdoorWorkoutSession session, {
    String? userId,
  }) async {
    if (!SupabaseService.isInitialized || userId == null) {
      await _queuePending(session);
      return;
    }
    try {
      await SupabaseService.client.from('outdoor_workouts').upsert({
        'id': session.id,
        'user_id': userId,
        'type': session.type.value,
        'started_at': session.startedAt.toUtc().toIso8601String(),
        'ended_at': session.endedAt.toUtc().toIso8601String(),
        'distance_m': session.distanceMeters,
        'duration_s': session.durationSeconds,
        'calories': session.caloriesBurned,
        'payload': session.toJson(),
      });
    } catch (e) {
      BootLog.warn('outdoor_workouts sync failed', e);
      await _queuePending(session);
    }
  }

  Future<void> _queuePending(OutdoorWorkoutSession session) async {
    if (!HiveService.isInitialized) return;
    final raw = HiveService.cacheBox.get(_pendingSyncKey);
    final list = raw is List ? List<Map<String, dynamic>>.from(raw) : <Map<String, dynamic>>[];
    list.add(session.toJson());
    await HiveService.cacheBox.put(_pendingSyncKey, list);
  }
}

final outdoorWorkoutRepositoryProvider = Provider<OutdoorWorkoutRepository>(
  (ref) => OutdoorWorkoutRepository(),
);

final outdoorWorkoutSessionsProvider = Provider<List<OutdoorWorkoutSession>>((ref) {
  ref.watch(outdoorWorkoutRevisionProvider);
  return ref.read(outdoorWorkoutRepositoryProvider).loadAll();
});

final outdoorWorkoutRevisionProvider = StateProvider<int>((ref) => 0);

final todayOutdoorWorkoutCaloriesProvider = Provider<int>((ref) {
  final sessions = ref.watch(outdoorWorkoutSessionsProvider);
  final today = DateTime.now();
  return sessions
      .where(
        (s) =>
            s.startedAt.year == today.year &&
            s.startedAt.month == today.month &&
            s.startedAt.day == today.day,
      )
      .fold<int>(0, (sum, s) => sum + s.caloriesBurned);
});
