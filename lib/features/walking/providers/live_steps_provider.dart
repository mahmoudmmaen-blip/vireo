import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/data/step_permission.dart';

import 'package:vireo/features/walking/data/step_foreground_service.dart';

/// Live steps from the on-device pedometer (with Health fallback).
///
/// Does **not** request permission by itself — call [enableStepCounting]
/// after showing the in-app explanation.
final liveStepsProvider = StreamProvider<LiveStepsSnapshot>((ref) {
  return StepCounterService.stream;
});

/// Today's step count (0 while loading / denied).
final todayStepsProvider = Provider<int>((ref) {
  return ref.watch(liveStepsProvider).valueOrNull?.todaySteps ??
      StepCounterService.latest.todaySteps;
});

/// State of whether foreground step counting is active (running / paused).
final isStepCounterRunningProvider = StateProvider<bool>((ref) {
  return StepForegroundService.isActive;
});

/// Request permission, start the sensor stream, and push a snapshot.
final enableStepCountingProvider =
    Provider<Future<bool> Function()>((ref) {
  return () async {
    final granted = await StepPermission.request();
    if (granted) {
      await StepForegroundService.init();
      await StepForegroundService.start();
      ref.read(isStepCounterRunningProvider.notifier).state = true;
    }
    await StepCounterService.refresh();
    return granted;
  };
});

/// Bootstrap: if permission already granted, start listening (no dialog).
final stepCounterBootstrapProvider = FutureProvider<void>((ref) async {
  if (await StepPermission.isGranted()) {
    await StepForegroundService.init();
  }
  await StepCounterService.refresh();
});
