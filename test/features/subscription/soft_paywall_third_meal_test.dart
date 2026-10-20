import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/subscription/widgets/soft_paywall_after_scan.dart';

void main() {
  test('soft paywall Hive key is third-meal scoped (P57)', () {
    expect(softPaywallAfterThirdMealKey, 'soft_paywall_after_third_meal_shown');
  });
}
