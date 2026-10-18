import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/sync_engine.dart';

void main() {
  test('water day keys are not sent as uuid ids', () {
    final payload = remoteSyncPayload({
      'id': 'water_2026-10-18',
      'day': '2026-10-18',
      'amount_ml': 250,
    });
    expect(payload.containsKey('id'), isFalse);
    expect(payload['day'], '2026-10-18');
    expect(payload['amount_ml'], 250);
  });

  test('a real uuid id is kept', () {
    const id = '11111111-1111-4111-8111-111111111111';
    final payload = remoteSyncPayload({'id': id, 'day': '2026-10-18'});
    expect(payload['id'], id);
  });

  test('water and steps upsert on user and day', () {
    expect(remoteSyncUsesDayConflict('water_logs'), isTrue);
    expect(remoteSyncUsesDayConflict('daily_steps_history'), isTrue);
    expect(remoteSyncUsesDayConflict('nutrition_logs'), isFalse);
  });
}
