import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/coach_volume.dart';

void main() {
  group('CoachVolume §3 adherence + energy tuning', () {
    test('baseline multiplier is 1.0 with no signals', () {
      expect(CoachVolume.computeMultiplier(), 1.0);
    });

    test('high adherence adds +0.10', () {
      expect(
        CoachVolume.computeMultiplier(adherencePct: 90),
        closeTo(1.1, 0.001),
      );
    });

    test('low adherence (<60) subtracts 0.15', () {
      expect(
        CoachVolume.computeMultiplier(adherencePct: 55),
        closeTo(0.85, 0.001),
      );
    });

    test('very low adherence (<40) subtracts 0.25', () {
      expect(
        CoachVolume.computeMultiplier(adherencePct: 30),
        closeTo(0.75, 0.001),
      );
    });

    test('high energy adds +0.05', () {
      expect(
        CoachVolume.computeMultiplier(energyScore: 9),
        closeTo(1.05, 0.001),
      );
    });

    test('low energy subtracts 0.15', () {
      expect(
        CoachVolume.computeMultiplier(energyScore: 3),
        closeTo(0.85, 0.001),
      );
    });

    test('multiplier clamps to [0.6, 1.15]', () {
      expect(
        CoachVolume.computeMultiplier(adherencePct: 10, energyScore: 2),
        0.6,
      );
      expect(
        CoachVolume.computeMultiplier(adherencePct: 95, energyScore: 10),
        1.15,
      );
    });
  });

  group('CoachVolume §3 medical flag + tuned sets', () {
    test('medical flag reduces sets by ~25%', () {
      expect(
        CoachVolume.tunedSets(
          baseSets: 4,
          volumeMultiplier: 1.0,
          medicalFlag: true,
        ),
        3,
      );
    });

    test('never returns fewer than 1 set', () {
      expect(
        CoachVolume.tunedSets(
          baseSets: 1,
          volumeMultiplier: 0.6,
          medicalFlag: true,
        ),
        1,
      );
    });
  });
}
