import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

void main() {
  group('InBody Golden Offline Test (recorded response)', () {
    late Map<String, dynamic> recordedJson;

    setUpAll(() async {
      final file = File('test/fixtures/inbody_golden_response.json');
      expect(file.existsSync(), isTrue, reason: 'test/fixtures/inbody_golden_response.json must exist');
      final text = await file.readAsString();
      recordedJson = jsonDecode(text) as Map<String, dynamic>;
    });

    test('parses full Arabic InBody receipt golden fixture with high fidelity', () {
      final report = BodyCompositionParser.parse(recordedJson);
      expect(report, isNotNull);

      // Core metrics
      expect(report!.deviceBrand, equals('InBody'));
      expect(report.weightKg, closeTo(94.7, 0.5));
      expect(report.skeletalMuscleMassKg, closeTo(37.4, 0.5));
      expect(report.bodyFatMassKg, closeTo(28.6, 0.5));
      expect(report.percentBodyFat, closeTo(30.2, 0.5));
      expect(report.bmi, closeTo(29.2, 0.5));
      expect(report.bmrKcal, closeTo(1797.0, 15.0));
      expect(report.waistHipRatio, closeTo(0.96, 0.03));
      expect(report.visceralFatLevel, closeTo(12.0, 1.0));
      expect(report.inbodyScore, closeTo(69.0, 1.0));
      expect(report.fatControlKg, closeTo(-17.0, 0.5));
      expect(report.muscleControlKg, closeTo(0.0, 0.5));
      expect(report.phaseAngle, closeTo(5.9, 0.2));

      // Segmental Lean
      expect(report.segmentalLean.rightArm.kg?.value, closeTo(3.65, 0.25));
      expect(report.segmentalLean.leftArm.kg?.value, closeTo(3.66, 0.25));
      expect(report.segmentalLean.trunk.kg?.value, closeTo(28.6, 0.5));
      expect(report.segmentalLean.rightLeg.kg?.value, closeTo(10.5, 0.3));
      expect(report.segmentalLean.leftLeg.kg?.value, closeTo(10.38, 0.3));

      // Segmental Fat
      expect(report.segmentalFat.rightArm.kg?.value, closeTo(2.0, 0.5));
      expect(report.segmentalFat.trunk.kg?.value, closeTo(15.2, 0.5));
      expect(report.segmentalFat.rightLeg.kg?.value, closeTo(4.0, 0.5));
    });

    test('merges partial report with golden report preserving higher confidence', () {
      final goldenReport = BodyCompositionParser.parse(recordedJson)!;

      // Simulate a smart scale report with higher weight confidence but missing segmental
      final scaleJson = {
        'weight_kg': {'value': 94.5, 'confidence': 0.99},
        'percent_body_fat': {'value': 30.5, 'confidence': 0.80},
      };
      final scaleReport = BodyCompositionParser.parse(scaleJson)!;

      final merged = BodyCompositionParser.merge([goldenReport, scaleReport]);
      expect(merged, isNotNull);

      // Weight should come from scale (0.99 > 0.95)
      expect(merged.weightKg, equals(94.5));
      // SMM should be preserved from InBody
      expect(merged.skeletalMuscleMassKg, closeTo(37.4, 0.5));
      // Segmental lean trunk should be preserved from InBody
      expect(merged.segmentalLean.trunk.kg?.value, closeTo(28.6, 0.5));
    });
  });
}
