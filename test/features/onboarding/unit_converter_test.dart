import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/data/models/unit_preference.dart';

void main() {
  group('UnitConverter §2.2 step 1 — canonical kg/cm storage', () {
    test('metric input passes through unchanged', () {
      expect(UnitConverter.inputWeightToKg(80, UnitPreference.metric), 80);
      expect(UnitConverter.inputHeightToCm(175, UnitPreference.metric), 175);
    });

    test('imperial input converts to kg/cm', () {
      expect(
        UnitConverter.inputWeightToKg(176.37, UnitPreference.imperial),
        closeTo(80, 0.01),
      );
      expect(
        UnitConverter.inputHeightToCm(68.9, UnitPreference.imperial),
        closeTo(175, 0.1),
      );
    });
  });
}
