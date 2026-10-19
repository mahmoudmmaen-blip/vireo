import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/health_connect_write_service.dart';

void main() {
  test('writeWeightKg rejects non-positive weight without throwing', () async {
    expect(await HealthConnectWriteService.writeWeightKg(0), isFalse);
    expect(await HealthConnectWriteService.writeWeightKg(-1), isFalse);
  });

  test('writeExerciseSession rejects inverted times without throwing', () async {
    final now = DateTime.now();
    expect(
      await HealthConnectWriteService.writeExerciseSession(
        start: now,
        end: now.subtract(const Duration(minutes: 1)),
        isRun: false,
      ),
      isFalse,
    );
  });
}
