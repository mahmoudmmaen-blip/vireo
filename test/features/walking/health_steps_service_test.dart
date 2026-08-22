import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/health_steps_service.dart';

void main() {
  group('HealthStepsService §2.5 platform support', () {
    test('isSupported is false on desktop dev platforms', () {
      final isDesktop =
          Platform.isWindows || Platform.isLinux || Platform.isMacOS;
      expect(HealthStepsService.isSupported, !isDesktop);
    });
  });
}
