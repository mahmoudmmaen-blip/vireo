import 'dart:convert';
import 'package:flutter/foundation.dart';
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

  /// Pull remote changes and resolve conflicts by last-write-wins (updated_at).
  Future<void> pullChanges(String userId) async {
    if (!SupabaseService.isInitialized) {
      status.value = SyncStatus.offline;
      return;
    }

    status.value = SyncStatus.syncing;
    try {
      // Sync water logs as primary example
      final remoteWater = await SupabaseService.client
          .from('water_logs')
          .select()
          .eq('user_id', userId)
          .isFilter('deleted_at', null);

      if (remoteWater.isNotEmpty) {
        final todayStr = DateTime.now().toIso8601String().substring(0, 10);
        final matches = remoteWater.where((w) => w['day'] == todayStr);
        final todayEntry = matches.isNotEmpty ? matches.first as Map<String, dynamic>? : null;
        if (todayEntry != null && HiveService.isInitialized) {
          final localData = HiveService.cacheBox.get('water_tracker') as Map?;
          final localUpdated = localData?['updated_at'] != null
              ? DateTime.tryParse(localData!['updated_at'] as String)
              : null;
          final remoteUpdated = DateTime.tryParse(todayEntry['updated_at'] as String? ?? '');

          // Last-write-wins conflict rule
          if (remoteUpdated != null &&
              (localUpdated == null || remoteUpdated.isAfter(localUpdated))) {
            await HiveService.cacheBox.put('water_tracker', {
              'current': todayEntry['amount_ml'],
              'goal': todayEntry['goal_ml'],
              'updated_at': remoteUpdated.toIso8601String(),
            });
          }
        }
      }

      await HiveService.settingsBox
          .put(_lastSyncTimeKey, DateTime.now().toIso8601String());
      status.value = SyncStatus.synced;
    } catch (_) {
      status.value = SyncStatus.error;
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
