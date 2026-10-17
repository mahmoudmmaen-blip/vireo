import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vireo/core/config/feature_flags.dart';
import 'package:vireo/core/services/hive_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FeatureFlags defaults (v1)', () {
    test('GPS run and men\'s vitality are OFF', () {
      expect(FeatureFlags.gpsRunScreen, isFalse);
      expect(FeatureFlags.mensVitalityModule, isFalse);
      const d = FeatureFlagsState.defaults();
      expect(d.gpsRunScreen, isFalse);
      expect(d.mensVitalityModule, isFalse);
    });

    test('resolve() returns defaults before Hive is ready', () {
      HiveService.setInitializedForTesting(false);
      expect(FeatureFlags.resolve(), const FeatureFlagsState.defaults());
    });
  });

  group('FeatureFlagsState.fromOverrideJson', () {
    test('null / empty / malformed JSON keeps the defaults', () {
      const d = FeatureFlagsState.defaults();
      expect(FeatureFlagsState.fromOverrideJson(null), d);
      expect(FeatureFlagsState.fromOverrideJson('  '), d);
      expect(FeatureFlagsState.fromOverrideJson('{oops'), d);
      expect(FeatureFlagsState.fromOverrideJson('[1,2]'), d);
    });

    test('bool overrides apply, other types and unknown keys are ignored', () {
      final s = FeatureFlagsState.fromOverrideJson(
        '{"gpsRunScreen": true, "mensVitalityModule": "yes", "x": true}',
      );
      expect(s.gpsRunScreen, isTrue);
      expect(s.mensVitalityModule, isFalse);
    });
  });

  group('Hive override', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('vireo_flags_test_');
      Hive.init(tempDir.path);
      await Hive.openBox<dynamic>(HiveService.settingsBoxName);
      HiveService.setInitializedForTesting(true);
    });

    tearDown(() async {
      HiveService.setInitializedForTesting(false);
      await Hive.close().timeout(const Duration(seconds: 10));
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('saveOverride is read back by resolve() and can be cleared', () async {
      expect(FeatureFlags.resolve().gpsRunScreen, isFalse);

      await FeatureFlags.saveOverride({'gpsRunScreen': true});
      expect(FeatureFlags.resolve().gpsRunScreen, isTrue);
      expect(FeatureFlags.resolve().mensVitalityModule, isFalse);

      await FeatureFlags.saveOverride(null);
      expect(FeatureFlags.resolve().gpsRunScreen, isFalse);
    });
  });
}
