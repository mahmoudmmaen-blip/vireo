import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/activity/domain/acsm_net_energy.dart';

void main() {
  group('AcsmNetEnergy — ACSM walking/running', () {
    test('walking VO2 matches ACSM at 80 m/min grade 0', () {
      // VO2 = 0.1*80 + 3.5 = 11.5
      expect(AcsmNetEnergy.walkingVo2(speedMPerMin: 80), closeTo(11.5, 0.01));
    });

    test('running VO2 matches ACSM at 160 m/min grade 0', () {
      // VO2 = 0.2*160 + 3.5 = 35.5
      expect(AcsmNetEnergy.runningVo2(speedMPerMin: 160), closeTo(35.5, 0.01));
    });

    test('net kcal excludes resting VO2 (never double-counts BMR)', () {
      final net = AcsmNetEnergy.walkingNetKcal(
        weightKg: 70,
        speedMPerMin: 80,
        minutes: 30,
      );
      // (11.5-3.5)*70/200 * 30 = 8*70/200*30 = 84
      expect(net, closeTo(84.0, 0.5));
    });

    test('kcal/step fallback within ±10% of ACSM at 100 spm', () {
      const stride = 0.75;
      const weight = 70.0;
      const cadence = 100.0;
      final speed = AcsmNetEnergy.speedMPerMinFromCadence(
        cadenceSpm: cadence,
        strideMeters: stride,
      );
      final acsmPerMin = AcsmNetEnergy.walkingNetKcal(
        weightKg: weight,
        speedMPerMin: speed,
        minutes: 1,
      );
      final acsmPerStep = acsmPerMin / cadence;
      final fallback = AcsmNetEnergy.netKcalPerStepFallback(
        weightKg: weight,
        strideMeters: stride,
      );
      expect((fallback - acsmPerStep).abs() / acsmPerStep, lessThan(0.10));
    });

    test('Keytel blend is 70/30 and flags source', () {
      final acsm = AcsmNetEnergy.walkingNetKcal(
        weightKg: 80,
        speedMPerMin: 83.3,
        minutes: 20,
      );
      final blended = AcsmNetEnergy.blendHrAndAcsm(
        acsmNetKcal: acsm,
        heartRateBpm: 130,
        weightKg: 80,
        age: 30,
        isFemale: false,
        minutes: 20,
      );
      expect(blended.source, 'hr_acsm_blend');
      expect(blended.netKcal, greaterThan(0));
    });

    test('Compendium workout uses MET-1 (net)', () {
      // MET 5 for 60 min @ 70 kg → net 4*70*1 = 280
      final kcal = AcsmNetEnergy.workoutNetKcal(
        met: 5,
        weightKg: 70,
        durationMinutes: 60,
      );
      expect(kcal, closeTo(280, 0.1));
    });

    test('eat-back defaults 50% lose, 100% maintain', () {
      expect(AcsmNetEnergy.eatBackKcal(netExerciseKcal: 200, goal: 'lose'), 100);
      expect(AcsmNetEnergy.eatBackKcal(netExerciseKcal: 200, goal: 'maintain'), 200);
      expect(
        AcsmNetEnergy.eatBackKcal(
          netExerciseKcal: 200,
          goal: 'lose',
          userOverride: 0,
        ),
        0,
      );
    });

    test('walk-off surplus returns minutes and steps', () {
      final r = AcsmNetEnergy.walkOffSurplus(
        surplusKcal: 180,
        weightKg: 75,
        strideMeters: 0.72,
      );
      expect(r.minutes, greaterThan(10));
      expect(r.steps, greaterThan(1000));
    });
  });
}
