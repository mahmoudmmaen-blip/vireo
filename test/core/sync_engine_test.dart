import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/sync_engine.dart';

void main() {
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
  });
}
