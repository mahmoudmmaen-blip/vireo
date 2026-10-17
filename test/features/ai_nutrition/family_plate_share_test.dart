import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_nutrition/domain/family_plate_share.dart';

void main() {
  group('FamilyPlateShare', () {
    test('fractions are 1/4, 1/3, 1/2', () {
      expect(FamilyPlateShare.quarter.fraction, closeTo(0.25, 1e-9));
      expect(FamilyPlateShare.third.fraction, closeTo(1 / 3, 1e-9));
      expect(FamilyPlateShare.half.fraction, closeTo(0.5, 1e-9));
    });

    test('Egyptian labels', () {
      expect(FamilyPlateShare.quarter.labelAr, 'ربع');
      expect(FamilyPlateShare.third.labelAr, 'تلت');
      expect(FamilyPlateShare.half.labelAr, 'نص');
    });

    test('fromFraction round-trips and rejects unknown values', () {
      for (final s in FamilyPlateShare.values) {
        expect(FamilyPlateShare.fromFraction(s.fraction), s);
      }
      expect(FamilyPlateShare.fromFraction(0.4), isNull);
    });
  });

  group('scaleMealKcal / scaleGrams', () {
    test('koshari 900 kcal: quarter / third / half', () {
      expect(
        scaleMealKcal(totalKcal: 900, share: FamilyPlateShare.quarter.fraction),
        closeTo(225, 1e-9),
      );
      expect(
        scaleMealKcal(totalKcal: 900, share: FamilyPlateShare.third.fraction),
        closeTo(300, 1e-9),
      );
      expect(
        scaleMealKcal(totalKcal: 900, share: FamilyPlateShare.half.fraction),
        closeTo(450, 1e-9),
      );
    });

    test('grams scale the same way', () {
      expect(
        scaleGrams(totalGrams: 1200, share: FamilyPlateShare.third.fraction),
        closeTo(400, 1e-9),
      );
    });

    test('share of 1 keeps the whole dish', () {
      expect(scaleMealKcal(totalKcal: 640, share: 1), 640);
    });

    test('bad shares never zero out or inflate a meal', () {
      expect(scaleMealKcal(totalKcal: 500, share: 0), 500);
      expect(scaleMealKcal(totalKcal: 500, share: -1), 500);
      expect(scaleMealKcal(totalKcal: 500, share: double.nan), 500);
      expect(scaleMealKcal(totalKcal: 500, share: 2), 500);
    });

    test('non-positive totals give 0', () {
      expect(scaleMealKcal(totalKcal: 0, share: 0.5), 0);
      expect(scaleMealKcal(totalKcal: -10, share: 0.5), 0);
      expect(scaleGrams(totalGrams: double.nan, share: 0.5), 0);
    });
  });
}
