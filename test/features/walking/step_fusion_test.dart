import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/domain/step_fusion.dart';

void main() {
  test('never double-counts — prefers higher coverage per hour', () {
    final hour = DateTime(2026, 10, 17, 10);
    final fused = StepFusion.fuseDay(
      pedometerHours: [
        HourlyStepBucket(
          hourStart: hour,
          steps: 800,
          source: StepSource.pedometer,
          coverageRatio: 0.5,
        ),
      ],
      healthHours: [
        HourlyStepBucket(
          hourStart: hour,
          steps: 900,
          source: StepSource.health,
          coverageRatio: 0.95,
        ),
      ],
    );
    expect(fused.totalSteps, 900);
    expect(fused.source, StepSource.health);
  });

  test('day-level fallback uses max not sum', () {
    final fused = StepFusion.fuseDay(
      pedometerHours: const [],
      healthHours: const [],
      pedometerDayTotal: 5000,
      healthDayTotal: 4800,
    );
    expect(fused.totalSteps, 5000);
    expect(fused.totalSteps, isNot(9800));
  });
}
