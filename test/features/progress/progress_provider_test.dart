import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';

void main() {
  group('progressTabProvider §2.7', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('defaults to weight tab', () {
      expect(container.read(progressTabProvider), ProgressTab.weight);
    });

    test('switches between weight, adherence, and energy', () {
      container.read(progressTabProvider.notifier).state = ProgressTab.adherence;
      expect(container.read(progressTabProvider), ProgressTab.adherence);

      container.read(progressTabProvider.notifier).state = ProgressTab.energy;
      expect(container.read(progressTabProvider), ProgressTab.energy);
    });
  });
}
