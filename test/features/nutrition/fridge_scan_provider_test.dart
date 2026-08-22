import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/nutrition/providers/fridge_scan_provider.dart';

void main() {
  group('FridgeScanFlowNotifier §2.6 ingredient chips', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    FridgeScanFlowNotifier notifier() =>
        container.read(fridgeScanFlowProvider.notifier);

    test('addIngredient deduplicates case-insensitively', () {
      notifier().addIngredient('Tomatoes');
      notifier().addIngredient('tomatoes');

      expect(container.read(fridgeScanFlowProvider).ingredients, ['Tomatoes']);
    });

    test('removeIngredient drops chip from list', () {
      notifier().setIngredients(['Eggs', 'Milk']);
      notifier().removeIngredient('Eggs');

      expect(container.read(fridgeScanFlowProvider).ingredients, ['Milk']);
    });

    test('setIngredients replaces detected items from vision scan', () {
      notifier().setIngredients(['Chicken', 'Rice', 'Broccoli']);

      expect(container.read(fridgeScanFlowProvider).ingredients.length, 3);
    });

    test('reset clears scan flow state', () {
      notifier().setIngredients(['Eggs']);
      notifier().reset();

      final state = container.read(fridgeScanFlowProvider);
      expect(state.ingredients, isEmpty);
      expect(state.scanId, isNull);
      expect(state.isScanning, isFalse);
    });
  });
}
