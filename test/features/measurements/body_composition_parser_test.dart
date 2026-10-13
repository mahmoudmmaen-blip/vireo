import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

void main() {
  group('BodyCompositionParser', () {
    test('parses full InBody report JSON correctly', () {
      final json = {
        'readable': true,
        'test_date': {'value': '2026-10-12', 'confidence': 0.95},
        'device_model': {'value': 'InBody 270', 'confidence': 0.9},
        'weight_kg': {'value': 78.5, 'confidence': 0.98},
        'skeletal_muscle_mass_kg': {'value': 35.2, 'confidence': 0.92},
        'body_fat_mass_kg': {'value': 14.8, 'confidence': 0.88},
        'percent_body_fat': {'value': 18.8, 'confidence': 0.94},
        'bmi': {'value': 24.2, 'confidence': 0.95},
        'visceral_fat_level': {'value': 6.0, 'confidence': 0.85},
        'bmr_kcal': {'value': 1680.0, 'confidence': 0.9},
        'total_body_water_l': {'value': 46.5, 'confidence': 0.85},
        'inbody_score': {'value': 78.0, 'confidence': 0.9},
      };

      final report = BodyCompositionParser.parse(json);
      expect(report, isNotNull);
      expect(report!.weightKg, equals(78.5));
      expect(report.skeletalMuscleMassKg, equals(35.2));
      expect(report.bodyFatMassKg, equals(14.8));
      expect(report.percentBodyFat, equals(18.8));
      expect(report.bmi, equals(24.2));
      expect(report.visceralFatLevel, equals(6.0));
      expect(report.bmrKcal, equals(1680.0));
      expect(report.inbodyScore, equals(78.0));
      expect(report.fieldConfidence['weight_kg'], equals(0.98));
    });

    test('returns null for unreadable report JSON', () {
      final json = {
        'readable': false,
        'error': 'UNREADABLE',
      };

      final report = BodyCompositionParser.parse(json);
      expect(report, isNull);
    });

    test('parses raw numbers without confidence objects', () {
      final json = {
        'weight_kg': 80.0,
        'percent_body_fat': 20.0,
      };

      final report = BodyCompositionParser.parse(json);
      expect(report, isNotNull);
      expect(report!.weightKg, equals(80.0));
      expect(report.percentBodyFat, equals(20.0));
    });
  });
}
