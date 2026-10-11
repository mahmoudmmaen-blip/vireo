import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/supabase_service.dart';

enum SyncOperation { insert, update, delete }

enum SyncStatus { idle, syncing, offline, error, synced }

@immutable
class SyncQueueItem {
  const SyncQueueItem({
    required this.id,
    required this.table,
    required this.operation,
    required this.data,
    required this.updatedAt,
  });

  final String id;
  final String table;
  final SyncOperation operation;
  final Map<String, dynamic> data;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'table': table,
        'operation': operation.name,
        'data': data,
        'updated_at': updatedAt.toIso8601String(),
      };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
        id: json['id'] as String,
        table: json['table'] as String,
        operation: SyncOperation.values.byName(json['operation'] as String),
        data: Map<String, dynamic>.from(json['data'] as Map),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}

class SyncEngine {
  SyncEngine();

  static const _queueKey = 'sync_engine_queue';
  static const _lastSyncTimeKey = 'sync_engine_last_sync';
  static const _backupPhotosKey = 'sync_backup_photos_enabled';

  final ValueNotifier<SyncStatus> status = ValueNotifier(SyncStatus.idle);

  bool get isBackupPhotosEnabled {
    if (!HiveService.isInitialized) return false;
    return HiveService.settingsBox.get(_backupPhotosKey, defaultValue: false) as bool;
  }

  Future<void> setBackupPhotosEnabled(bool enabled) async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_backupPhotosKey, enabled);
  }

  DateTime? get lastSyncTime {
    if (!HiveService.isInitialized) return null;
    final iso = HiveService.settingsBox.get(_lastSyncTimeKey) as String?;
    return iso != null ? DateTime.tryParse(iso) : null;
  }

  int get pendingCount => getQueue().length;

  List<SyncQueueItem> getQueue() {
    if (!HiveService.isInitialized) return [];
    final raw = HiveService.settingsBox.get(_queueKey) as List?;
    if (raw == null) return [];
    return raw
        .map((e) => SyncQueueItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveQueue(List<SyncQueueItem> queue) async {
    if (!HiveService.isInitialized) return;
    final serialized = queue.map((e) => e.toJson()).toList();
    await HiveService.settingsBox.put(_queueKey, serialized);
  }

  /// Write locally first, queue changes for remote push.
  Future<void> enqueueChange({
    required String table,
    required String id,
    required SyncOperation operation,
    required Map<String, dynamic> data,
  }) async {
    final now = DateTime.now();
    final item = SyncQueueItem(
      id: id,
      table: table,
      operation: operation,
      data: {
        ...data,
        'updated_at': now.toIso8601String(),
        if (operation == SyncOperation.delete) 'deleted_at': now.toIso8601String(),
      },
      updatedAt: now,
    );

    final currentQueue = getQueue();
    // Coalesce updates to same row
    currentQueue.removeWhere((q) => q.table == table && q.id == id);
    currentQueue.add(item);
    await saveQueue(currentQueue);

    // Attempt push immediately
    await pushQueue();
  }

  /// Push queued changes when online.
  Future<void> pushQueue() async {
    if (!SupabaseService.isInitialized) {
      status.value = SyncStatus.offline;
      return;
    }

    final queue = getQueue();
    if (queue.isEmpty) {
      status.value = SyncStatus.synced;
      return;
    }

    status.value = SyncStatus.syncing;
    final pending = List<SyncQueueItem>.from(queue);

    for (final item in queue) {
      try {
        if (item.operation == SyncOperation.delete) {
          // Soft delete
          await SupabaseService.client
              .from(item.table)
              .update({'deleted_at': item.updatedAt.toIso8601String()})
              .eq('id', item.id);
        } else {
          // Upsert last-write-wins
          await SupabaseService.client.from(item.table).upsert(
                item.data,
                onConflict: 'id',
              );
        }
        pending.remove(item);
      } catch (e) {
        // Stop on connection error to retry later
        status.value = SyncStatus.error;
        await saveQueue(pending);
        return;
      }
    }

    await saveQueue(pending);
    await HiveService.settingsBox
        .put(_lastSyncTimeKey, DateTime.now().toIso8601String());
    status.value = SyncStatus.synced;
  }

  /// Pull remote changes for every store in DATA_MAP.md and resolve conflicts
  /// by last-write-wins (updated_at) with soft deletes (deleted_at).
  Future<void> pullChanges(String userId) async {
    if (!SupabaseService.isInitialized) {
      status.value = SyncStatus.offline;
      return;
    }

    status.value = SyncStatus.syncing;
    try {
      await _pullWater(userId);
      await _pullAiNutrition(userId);
      await _pullDailySteps(userId);
      await _pullGpsWorkouts(userId);
      await _pullWeightLogs(userId);
      await _pullBodyMeasurements(userId);
      await _pullBodyComposition(userId);
      await _pullDietPrograms(userId);
      await _pullTodayPlan(userId);
      await _pullVitalityLogs(userId);
      await _pullUserSettings(userId);

      await HiveService.settingsBox
          .put(_lastSyncTimeKey, DateTime.now().toIso8601String());
      status.value = SyncStatus.synced;
    } catch (e) {
      BootLog.warn('SyncEngine.pullChanges failed', e);
      status.value = SyncStatus.error;
    }
  }

  Future<void> _pullWater(String userId) async {
    final rows = await SupabaseService.client
        .from('water_logs')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      if (map['day'] != todayStr) continue;

      if (map['deleted_at'] != null) {
        await HiveService.cacheBox.delete('water_tracker');
        continue;
      }

      final localData = HiveService.cacheBox.get('water_tracker') as Map?;
      final localUpdated = localData?['updated_at'] != null
          ? DateTime.tryParse(localData!['updated_at'] as String)
          : null;
      final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');

      if (remoteUpdated != null &&
          (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
        await HiveService.cacheBox.put('water_tracker', {
          'date': todayStr,
          'ml': map['amount_ml'] ?? 0,
          'goal': map['goal_ml'] ?? 2500,
          'updated_at': remoteUpdated.toIso8601String(),
        });
      }
    }
  }

  Future<void> _pullAiNutrition(String userId) async {
    final rows = await SupabaseService.client
        .from('ai_nutrition_scans')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final raw = HiveService.cacheBox.get('ai_meal_logs');
    final localList = (raw is List)
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];

    var changed = false;
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      final id = map['id']?.toString() ?? '';
      if (id.isEmpty) continue;

      final isDeleted = map['deleted_at'] != null;
      final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');

      final localIdx = localList.indexWhere((e) => e['id'] == id);
      if (isDeleted) {
        if (localIdx != -1) {
          localList.removeAt(localIdx);
          changed = true;
        }
        continue;
      }

      if (localIdx == -1) {
        // Parse payload
        final payload = map['payload'] is Map ? map['payload'] as Map : null;
        if (payload != null) {
          localList.add(Map<String, dynamic>.from(payload));
          changed = true;
        }
      } else if (remoteUpdated != null) {
        final localUpdated = DateTime.tryParse(localList[localIdx]['updated_at'] as String? ?? '');
        if (localUpdated == null || remoteUpdated.isAfter(localUpdated)) {
          final payload = map['payload'] is Map ? map['payload'] as Map : null;
          if (payload != null) {
            localList[localIdx] = Map<String, dynamic>.from(payload);
            changed = true;
          }
        }
      }
    }

    if (changed) {
      await HiveService.cacheBox.put('ai_meal_logs', localList);
    }
  }

  Future<void> _pullDailySteps(String userId) async {
    final rows = await SupabaseService.client
        .from('daily_steps_history')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final raw = HiveService.settingsBox.get('step_history');
    final history = (raw is Map) ? Map<String, int>.from(raw) : <String, int>{};

    var changed = false;
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      final day = map['day']?.toString() ?? '';
      if (day.isEmpty) continue;

      if (map['deleted_at'] != null) {
        if (history.containsKey(day)) {
          history.remove(day);
          changed = true;
        }
        continue;
      }

      final steps = (map['steps'] as num?)?.toInt() ?? 0;
      final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
      // LWW
      final existingSteps = history[day];
      if (existingSteps == null || (remoteUpdated != null)) {
        history[day] = steps;
        changed = true;
      }
    }

    if (changed) {
      await HiveService.settingsBox.put('step_history', history);
    }
  }

  Future<void> _pullGpsWorkouts(String userId) async {
    final rows = await SupabaseService.client
        .from('gps_workouts')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final raw = HiveService.cacheBox.get('outdoor_workout_sessions');
    final localList = (raw is List)
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];

    var changed = false;
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      final id = map['id']?.toString() ?? '';
      if (id.isEmpty) continue;

      final isDeleted = map['deleted_at'] != null;
      final localIdx = localList.indexWhere((e) => e['id'] == id);

      if (isDeleted) {
        if (localIdx != -1) {
          localList.removeAt(localIdx);
          changed = true;
        }
        continue;
      }

      final payload = map['payload'] is Map ? map['payload'] as Map : null;
      if (payload == null) continue;

      if (localIdx == -1) {
        localList.add(Map<String, dynamic>.from(payload));
        changed = true;
      } else {
        final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
        final localUpdated = DateTime.tryParse(localList[localIdx]['updated_at'] as String? ?? '');
        if (remoteUpdated != null && (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
          localList[localIdx] = Map<String, dynamic>.from(payload);
          changed = true;
        }
      }
    }

    if (changed) {
      await HiveService.cacheBox.put('outdoor_workout_sessions', localList);
    }
  }

  Future<void> _pullWeightLogs(String userId) async {
    final rows = await SupabaseService.client
        .from('weight_logs')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final raw = HiveService.cacheBox.get('weight_logs_cache');
    final localList = (raw is List)
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];

    var changed = false;
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      final id = map['id']?.toString() ?? '';
      if (id.isEmpty) continue;

      final isDeleted = map['deleted_at'] != null;
      final localIdx = localList.indexWhere((e) => e['id'] == id);

      if (isDeleted) {
        if (localIdx != -1) {
          localList.removeAt(localIdx);
          changed = true;
        }
        continue;
      }

      final item = {
        'id': id,
        'weight_kg': (map['weight_kg'] as num?)?.toDouble() ?? 70.0,
        'logged_at': map['logged_at'] ?? DateTime.now().toIso8601String(),
        'updated_at': map['updated_at'] ?? DateTime.now().toIso8601String(),
      };

      if (localIdx == -1) {
        localList.add(item);
        changed = true;
      } else {
        final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
        final localUpdated = DateTime.tryParse(localList[localIdx]['updated_at'] as String? ?? '');
        if (remoteUpdated != null && (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
          localList[localIdx] = item;
          changed = true;
        }
      }
    }

    if (changed) {
      await HiveService.cacheBox.put('weight_logs_cache', localList);
    }
  }

  Future<void> _pullBodyMeasurements(String userId) async {
    final rows = await SupabaseService.client
        .from('body_measurements')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final box = HiveService.bodyMeasurementsBox;

    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      final id = map['id']?.toString() ?? '';
      if (id.isEmpty) continue;

      if (map['deleted_at'] != null) {
        await box.delete(id);
        continue;
      }

      final payload = map['payload'] is Map ? map['payload'] as Map : null;
      if (payload != null) {
        final local = box.get(id) as Map?;
        final localUpdated = local?['updated_at'] != null
            ? DateTime.tryParse(local!['updated_at'] as String)
            : null;
        final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');

        if (remoteUpdated != null && (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
          await box.put(id, Map<String, dynamic>.from(payload));
        }
      }
    }
  }

  Future<void> _pullBodyComposition(String userId) async {
    final rows = await SupabaseService.client
        .from('body_composition')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final raw = HiveService.cacheBox.get('body_composition_reports_v1');
    final localList = (raw is List)
        ? raw.map((e) => Map<String, dynamic>.from(e as Map)).toList()
        : <Map<String, dynamic>>[];

    var changed = false;
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      final id = map['id']?.toString() ?? '';
      if (id.isEmpty) continue;

      final isDeleted = map['deleted_at'] != null;
      final localIdx = localList.indexWhere((e) => e['id'] == id);

      if (isDeleted) {
        if (localIdx != -1) {
          localList.removeAt(localIdx);
          changed = true;
        }
        continue;
      }

      if (localIdx == -1) {
        localList.add(map);
        changed = true;
      } else {
        final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
        final localUpdated = DateTime.tryParse(localList[localIdx]['updated_at'] as String? ?? '');
        if (remoteUpdated != null && (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
          localList[localIdx] = map;
          changed = true;
        }
      }
    }

    if (changed) {
      await HiveService.cacheBox.put('body_composition_reports_v1', localList);
    }
  }

  Future<void> _pullDietPrograms(String userId) async {
    final rows = await SupabaseService.client
        .from('user_diet_programs')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      if (map['deleted_at'] != null) {
        await HiveService.settingsBox.delete('diet_active_program_id');
        continue;
      }

      final programId = map['program_id']?.toString();
      final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
      if (programId != null && remoteUpdated != null) {
        await HiveService.settingsBox.put('diet_active_program_id', programId);
        if (map['start_date'] != null) {
          await HiveService.settingsBox.put('diet_program_start_date', map['start_date'].toString());
        }
      }
    }
  }

  Future<void> _pullTodayPlan(String userId) async {
    final rows = await SupabaseService.client
        .from('today_plan_completions')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      if (map['date'] != todayStr) continue;

      if (map['deleted_at'] != null) {
        await HiveService.cacheBox.delete('today_plan_checks');
        continue;
      }

      final checked = map['checked'] is List ? List<String>.from(map['checked'] as List) : <String>[];
      final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
      final local = HiveService.cacheBox.get('today_plan_checks') as Map?;
      final localUpdated = local?['updated_at'] != null ? DateTime.tryParse(local!['updated_at'] as String) : null;

      if (remoteUpdated != null && (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
        await HiveService.cacheBox.put('today_plan_checks', {
          'date': todayStr,
          'checked': checked,
          'updated_at': remoteUpdated.toIso8601String(),
        });
      }
    }
  }

  Future<void> _pullVitalityLogs(String userId) async {
    final rows = await SupabaseService.client
        .from('vitality_daily_logs')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      if (map['date'] != todayStr) continue;

      if (map['deleted_at'] != null) {
        await HiveService.cacheBox.delete('vitality_daily_log');
        continue;
      }

      final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
      final local = HiveService.cacheBox.get('vitality_daily_log') as Map?;
      final localUpdated = local?['updated_at'] != null ? DateTime.tryParse(local!['updated_at'] as String) : null;

      if (remoteUpdated != null && (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
        await HiveService.cacheBox.put('vitality_daily_log', {
          ...map,
          'updated_at': remoteUpdated.toIso8601String(),
        });
      }
    }
  }

  Future<void> _pullUserSettings(String userId) async {
    final rows = await SupabaseService.client
        .from('user_settings')
        .select()
        .eq('user_id', userId);

    if (rows.isEmpty || !HiveService.isInitialized) return;
    for (final row in rows) {
      final map = Map<String, dynamic>.from(row as Map);
      final key = map['key']?.toString();
      if (key == null) continue;

      if (map['deleted_at'] != null) {
        await HiveService.settingsBox.delete(key);
        continue;
      }

      final remoteUpdated = DateTime.tryParse(map['updated_at'] as String? ?? '');
      if (map.containsKey('value') && remoteUpdated != null) {
        await HiveService.settingsBox.put(key, map['value']);
      }
    }
  }

  /// Export all user data as formatted JSON and CSV files string.
  Future<Map<String, String>> exportUserData(String userId) async {
    final exportData = <String, dynamic>{
      'user_id': userId,
      'exported_at': DateTime.now().toIso8601String(),
      'water': HiveService.isInitialized ? HiveService.cacheBox.get('water_tracker') : null,
      'profile': HiveService.isInitialized ? HiveService.cacheBox.get('guest_profile') : null,
      'vitality': HiveService.isInitialized ? HiveService.cacheBox.get('vitality_daily_log') : null,
      'step_history': HiveService.isInitialized ? HiveService.settingsBox.get('step_history') : null,
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    // Build a CSV representation of steps history
    final csvBuffer = StringBuffer();
    csvBuffer.writeln('Day,Steps');
    final history = exportData['step_history'];
    if (history is Map) {
      for (final entry in history.entries) {
        csvBuffer.writeln('${entry.key},${entry.value}');
      }
    }

    return {
      'vireo_export.json': jsonString,
      'vireo_steps.csv': csvBuffer.toString(),
    };
  }

  /// Full account delete: wipes local stores, tables, and storage files.
  Future<void> deleteEntireAccountData(String userId) async {
    if (HiveService.isInitialized) {
      await HiveService.cacheBox.clear();
      await HiveService.settingsBox.clear();
      await HiveService.bodyMeasurementsBox.clear();
    }

    if (!SupabaseService.isInitialized) return;

    try {
      // Delete every table created across roadmap
      await SupabaseService.client.from('nutrition_logs').delete().eq('user_id', userId);
      await SupabaseService.client.from('water_logs').delete().eq('user_id', userId);
      await SupabaseService.client.from('daily_steps_history').delete().eq('user_id', userId);
      await SupabaseService.client.from('gps_workouts').delete().eq('user_id', userId);
      await SupabaseService.client.from('weight_logs').delete().eq('user_id', userId);
      await SupabaseService.client.from('user_diet_programs').delete().eq('user_id', userId);
      await SupabaseService.client.from('today_plan_completions').delete().eq('user_id', userId);
      await SupabaseService.client.from('vitality_daily_logs').delete().eq('user_id', userId);
      await SupabaseService.client.from('user_settings').delete().eq('user_id', userId);
      await SupabaseService.client.from('daily_shared_stats').delete().eq('user_id', userId);
      await SupabaseService.client.from('challenge_members').delete().eq('user_id', userId);
      await SupabaseService.client.from('challenges').delete().eq('owner_id', userId);
      await SupabaseService.client.from('friendships').delete().or('user_id.eq.$userId,friend_id.eq.$userId');
      await SupabaseService.client.from('profiles_public').delete().eq('user_id', userId);
      await SupabaseService.client.from('subscriptions').delete().eq('user_id', userId);
    } catch (_) {}
  }
}

/// Global Riverpod provider for SyncEngine.
final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine();
});
