import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/walking/data/step_permission.dart';
import 'package:vireo/features/walking/data/steps_repository.dart';

import 'package:vireo/features/walking/data/step_foreground_service.dart';

/// Live steps from [StepsRepository] (Health Connect + pedometer).
///
/// Does **not** request permission by itself — call [enableStepCounting]
/// after showing the in-app explanation.
final liveStepsProvider = StreamProvider<LiveStepsSnapshot>((ref) {
  return StepsRepository.stream;
});

/// Today's step count — **single source of truth for Home and Walk tab** (P51).
final todayStepsProvider = Provider<int>((ref) {
  return ref.watch(liveStepsProvider).valueOrNull?.todaySteps ??
      StepsRepository.todaySteps;
});

/// StateNotifier for foreground step counting status.
/// Single source of truth synchronized with FlutterForegroundTask and lifecycle.
class StepCounterRunningNotifier extends StateNotifier<bool> {
  StepCounterRunningNotifier() : super(StepForegroundService.isActive) {
    StepForegroundService.onRunningStateChanged = (isRunning) {
      if (mounted && state != isRunning) {
        state = isRunning;
      }
    };
    // Sync on creation
    resync();
  }

  Future<void> resync() async {
    final real = await StepForegroundService.syncRunningState();
    if (mounted && state != real) {
      state = real;
    }
  }

  void setOptimistic(bool value) {
    state = value;
  }
}

final isStepCounterRunningProvider =
    StateNotifierProvider<StepCounterRunningNotifier, bool>((ref) {
  return StepCounterRunningNotifier();
});

/// Request permission, start the sensor stream, and push a snapshot.
final enableStepCountingProvider =
    Provider<Future<bool> Function()>((ref) {
  return () async {
    final granted = await StepPermission.request();
    if (granted) {
      await StepForegroundService.init();
      await StepForegroundService.start();
      ref.read(isStepCounterRunningProvider.notifier).setOptimistic(true);
    }
    await StepsRepository.refresh();
    return granted;
  };
});

/// Bootstrap: if permission already granted, start listening (no dialog).
final stepCounterBootstrapProvider = FutureProvider<void>((ref) async {
  if (await StepPermission.isGranted()) {
    await StepForegroundService.init();
    if (!StepForegroundService.isActive) {
      await StepsRepository.startListening();
    }
  }
  await StepsRepository.refresh();
});
