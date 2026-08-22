import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/analytics/analytics_events.dart';
import 'package:vireo/core/services/analytics_service.dart';

void main() {
  group('AnalyticsService §14 event names', () {
    test('mealSwapped uses canonical event id', () {
      expect(AnalyticsEvents.mealSwapped, 'meal_swapped');
    });

    test('fridgeScanUsed uses canonical event id', () {
      expect(AnalyticsEvents.fridgeScanUsed, 'fridge_scan_used');
    });

    test('logEvent completes without throwing', () async {
      await expectLater(
        AnalyticsService.logEvent('test_event', properties: {'ok': true}),
        completes,
      );
    });

    test('mealSwapped helper completes without throwing', () async {
      await expectLater(
        AnalyticsService.mealSwapped(
          fromRecipeId: 'r1',
          toRecipeId: 'r2',
          mealType: 'lunch',
          dayIndex: 3,
        ),
        completes,
      );
    });
  });
}
