import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/measurements/screens/navy_tape_measure_screen.dart';
import 'audit_test_helper.dart';

void main() {
  testScreenOverflow('BodyCompositionScreen', () => const BodyCompositionScreen());
  testScreenOverflow('NavyTapeMeasureScreen', () => const NavyTapeMeasureScreen());
}
