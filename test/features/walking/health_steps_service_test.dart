import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/health_steps_service.dart';

void main() {
  group('HealthStepsService §2.5 platform support', () {
    test('isSupported is false on desktop target platforms', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(HealthStepsService.isSupported, isFalse);
    });

    test('isSupported is true on Android target platform', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(HealthStepsService.isSupported, isTrue);
    });
  });
}
