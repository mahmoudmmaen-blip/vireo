import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

void main() {
  group('BodyCompositionParser', () {
    test('parses confidence-wrapped fields and segmentals', () {
      final report = BodyCompositionParser.parse({
        'readable': true,
        'test_date': {'value': '2026-03-01', 'confidence': 0.92},
        'device_model': {'value': 'InBody 570', 'confidence': 0.8},
        'weight_kg': {'value': 82.4, 'confidence': 0.95},
        'skeletal_muscle_mass_kg': {'value': 36.1, 'confidence': 0.9},
        'body_fat_mass_kg': {'value': 18.2, 'confidence': 0.9},
        'percent_body_fat': {'value': 22.1, 'confidence': 0.9},
        'bmi': {'value': 26.4, 'confidence': 0.55},
        'visceral_fat_level': {'value': 8, 'confidence': 0.85},
        'bmr_kcal': {'value': 1680, 'confidence': 0.85},
        'segmental_lean': {
          'right_arm': {
            'kg': {'value': 3.2, 'confidence': 0.8},
            'percent': {'value': 98, 'confidence': 0.7},
          },
        },
      });

      expect(report, isNotNull);
      expect(report!.weightKg, 82.4);
      expect(report.skeletalMuscleMassKg, 36.1);
      expect(report.deviceModel, 'InBody 570');
      expect(report.testDate, DateTime(2026, 3, 1));
      expect(report.fieldConfidence['bmi'], 0.55);
      expect(report.segmentalLean.rightArm.kg?.value, 3.2);
      expect(report.leanMassKg, closeTo(82.4 - 18.2, 0.001));
    });

    test('parses JSON string payload', () {
      final report = BodyCompositionParser.parse(jsonEncode({
        'readable': true,
        'weight_kg': {'value': 70, 'confidence': 1},
        'percent_body_fat': {'value': 20, 'confidence': 1},
      }));
      expect(report, isNotNull);
      expect(report!.leanMassKg, closeTo(56, 0.001));
    });

    test('returns null for unreadable sheets', () {
      expect(
        BodyCompositionParser.parse({'readable': false, 'error': 'UNREADABLE'}),
        isNull,
      );
      expect(
        BodyCompositionParser.parse({'error': 'UNREADABLE'}),
        isNull,
      );
    });

    test('null fields stay null — never invents values', () {
      final report = BodyCompositionParser.parse({
        'readable': true,
        'weight_kg': {'value': null, 'confidence': 0.1},
        'skeletal_muscle_mass_kg': null,
      });
      expect(report, isNotNull);
      expect(report!.weightKg, isNull);
      expect(report.skeletalMuscleMassKg, isNull);
      expect(report.percentBodyFat, isNull);
    });
  });

  group('BodyCompositionMath', () {
    test('Katch-McArdle BMR = 370 + 21.6 × lean', () {
      expect(BodyCompositionMath.katchMcArdleBmr(60), closeTo(1666, 0.001));
      expect(
        BodyCompositionMath.maintenanceFromLean(
          leanMassKg: 60,
          activityMultiplier: 1.55,
        ),
        2582,
      );
    });

    test('protein from lean mass at 2.2 g/kg', () {
      expect(BodyCompositionMath.proteinFromLeanKg(50), 110);
      expect(BodyCompositionMath.proteinFromLeanKg(20), 80); // clamp min
      expect(BodyCompositionMath.proteinFromLeanKg(200), 280); // clamp max
    });

    test('comparison deltas highlight muscle up / fat down', () {
      final older = BodyCompositionReport(
        id: 'a',
        testDate: DateTime(2026, 1, 1),
        weightKg: 85,
        skeletalMuscleMassKg: 34,
        bodyFatMassKg: 20,
        percentBodyFat: 23.5,
        visceralFatLevel: 10,
      );
      final newer = BodyCompositionReport(
        id: 'b',
        testDate: DateTime(2026, 3, 1),
        weightKg: 83,
        skeletalMuscleMassKg: 35.5,
        bodyFatMassKg: 17.5,
        percentBodyFat: 21.1,
        visceralFatLevel: 8,
      );

      final delta = BodyCompositionMath.compare(newer, older);
      expect(delta.skeletalMuscleMassKg, closeTo(1.5, 0.001));
      expect(delta.bodyFatMassKg, closeTo(-2.5, 0.001));
      expect(delta.percentBodyFat, closeTo(-2.4, 0.001));
      expect(delta.weightKg, closeTo(-2, 0.001));
      expect(delta.visceralFatLevel, closeTo(-2, 0.001));
      expect(delta.muscleUp, isTrue);
      expect(delta.fatDown, isTrue);
    });
  });
}
