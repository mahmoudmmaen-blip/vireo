import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/data/steps_repository.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_steps_repo_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDown(() async {
    HiveService.setInitializedForTesting(false);
    await Hive.close();
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  test('manual steps update the shared StepsRepository stream', () async {
    final future = StepsRepository.stream
        .skip(1)
        .first
        .timeout(const Duration(seconds: 2));
    await StepsRepository.applyManualTodaySteps(4321);
    final snap = await future;
    expect(snap.todaySteps, 4321);
    expect(snap.source, StepSource.manual);
    expect(StepsRepository.todaySteps, 4321);
  });
}
