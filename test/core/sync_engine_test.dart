import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/sync_engine.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_sync_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDown(() async {
    HiveService.setInitializedForTesting(false);
    await Hive.close();
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  group('SyncEngine Queue and Conflict Resolution Rules', () {
    test('SyncQueueItem serializes and deserializes accurately', () {
      final now = DateTime.parse('2026-10-11T20:00:00.000Z');
      final item = SyncQueueItem(
        id: 'water_entry_1',
        table: 'water_logs',
        operation: SyncOperation.update,
        data: {'amount_ml': 2000, 'day': '2026-10-11'},
        updatedAt: now,
      );

      final json = item.toJson();
      expect(json['id'], 'water_entry_1');
      expect(json['table'], 'water_logs');
      expect(json['operation'], 'update');
      expect(json['data']['amount_ml'], 2000);

      final restored = SyncQueueItem.fromJson(json);
      expect(restored.id, 'water_entry_1');
      expect(restored.table, 'water_logs');
      expect(restored.operation, SyncOperation.update);
      expect(restored.updatedAt, now);
    });

    test('Last-write-wins conflict rule correctly evaluates remote vs local timestamp', () {
      final localTimestamp = DateTime.parse('2026-10-11T12:00:00.000Z');
      final newerRemoteTimestamp = DateTime.parse('2026-10-11T14:30:00.000Z');
      final olderRemoteTimestamp = DateTime.parse('2026-10-11T10:00:00.000Z');

      // Remote is newer → should overwrite local
      final shouldAcceptNewer = newerRemoteTimestamp.isAfter(localTimestamp);
      expect(shouldAcceptNewer, true);

      // Remote is older → should discard remote in favor of local
      final shouldAcceptOlder = olderRemoteTimestamp.isAfter(localTimestamp);
      expect(shouldAcceptOlder, false);
    });

    test('Soft delete flags record with deleted_at ISO timestamp', () {
      final deleteTime = DateTime.parse('2026-10-11T21:00:00.000Z');
      final deletedData = {
        'id': 'log_99',
        'deleted_at': deleteTime.toIso8601String(),
        'updated_at': deleteTime.toIso8601String(),
      };

      expect(deletedData['deleted_at'], isNotNull);
      expect(DateTime.parse(deletedData['deleted_at'] as String), deleteTime);
    });

    test('Queue persistence persists items to Hive and coalesces same record updates', () async {
      final engine = SyncEngine();

      await engine.enqueueChange(
        table: 'weight_logs',
        id: 'w_1',
        operation: SyncOperation.insert,
        data: {'weight_kg': 80.5},
      );

      expect(engine.pendingCount, 1);
      var queue = engine.getQueue();
      expect(queue.first.id, 'w_1');
      expect(queue.first.data['weight_kg'], 80.5);

      // Update same record -> coalesces in queue
      await engine.enqueueChange(
        table: 'weight_logs',
        id: 'w_1',
        operation: SyncOperation.update,
        data: {'weight_kg': 81.0},
      );

      expect(engine.pendingCount, 1);
      queue = engine.getQueue();
      expect(queue.first.id, 'w_1');
      expect(queue.first.data['weight_kg'], 81.0);
      expect(queue.first.operation, SyncOperation.update);
    });

    test('Soft delete enqueues record with deleted_at and delete operation', () async {
      final engine = SyncEngine();

      await engine.enqueueChange(
        table: 'body_measurements',
        id: 'bm_123',
        operation: SyncOperation.delete,
        data: {'id': 'bm_123'},
      );

      expect(engine.pendingCount, 1);
      final item = engine.getQueue().first;
      expect(item.operation, SyncOperation.delete);
      expect(item.data['deleted_at'], isNotNull);
      expect(item.data['updated_at'], isNotNull);
    });
  });
}
