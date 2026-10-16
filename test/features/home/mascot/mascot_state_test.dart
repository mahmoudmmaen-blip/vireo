import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/home/mascot/domain/mascot_state.dart';

void main() {
  group('MascotFillMath', () {
    test('fill levels: 0, 50%, 100%, 140% clamped with over badge', () {
      expect(const MascotFillMath(consumedKcal: 0, targetKcal: 2000).visualFill, 0);
      expect(const MascotFillMath(consumedKcal: 0, targetKcal: 2000).showOverBadge, isFalse);

      expect(const MascotFillMath(consumedKcal: 1000, targetKcal: 2000).visualFill, 0.5);
      expect(const MascotFillMath(consumedKcal: 1000, targetKcal: 2000).colorState,
          MascotFillColorState.calm);

      expect(const MascotFillMath(consumedKcal: 2000, targetKcal: 2000).visualFill, 1.0);
      expect(const MascotFillMath(consumedKcal: 2000, targetKcal: 2000).colorState,
          MascotFillColorState.onTrack);

      final over = const MascotFillMath(consumedKcal: 2800, targetKcal: 2000);
      expect(over.rawRatio, 1.4);
      expect(over.visualFill, 1.0);
      expect(over.showOverBadge, isTrue);
      expect(over.colorState, MascotFillColorState.over);
    });

    test('85–105% is onTrack', () {
      expect(
        const MascotFillMath(consumedKcal: 1700, targetKcal: 2000).colorState,
        MascotFillColorState.onTrack,
      );
      expect(
        const MascotFillMath(consumedKcal: 2100, targetKcal: 2000).colorState,
        MascotFillColorState.onTrack,
      );
    });

    test('state → expression mapping', () {
      final morning = DateTime(2026, 10, 16, 8);
      expect(
        const MascotFillMath(consumedKcal: 0, targetKcal: 2000).expressionAt(morning),
        MascotExpression.hungry,
      );
      expect(
        const MascotFillMath(consumedKcal: 1000, targetKcal: 2000).expressionAt(morning),
        MascotExpression.happy,
      );
      expect(
        const MascotFillMath(consumedKcal: 1900, targetKcal: 2000).expressionAt(morning),
        MascotExpression.satisfied,
      );
      expect(
        const MascotFillMath(consumedKcal: 2200, targetKcal: 2000).expressionAt(morning),
        MascotExpression.full,
      );
    });

    test('night state is sleepy after 11 PM', () {
      final night = DateTime(2026, 10, 16, 23, 30);
      expect(
        const MascotFillMath(consumedKcal: 800, targetKcal: 2000).expressionAt(night),
        MascotExpression.sleepy,
      );
      // Over still wins at night
      expect(
        const MascotFillMath(consumedKcal: 2300, targetKcal: 2000).expressionAt(night),
        MascotExpression.full,
      );
    });

    test('caption gender select', () {
      final m = mascotCaptionAr(remainingKcal: 1250, isOver: false, isFemale: false);
      final f = mascotCaptionAr(remainingKcal: 1250, isOver: false, isFemale: true);
      expect(m, contains('فاضلك'));
      expect(m, contains('1,250'));
      expect(f, contains('فاضلكِ'));
      expect(f, contains('كُلي'));
    });
  });
}
