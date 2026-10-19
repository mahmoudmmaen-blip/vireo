import 'package:vireo/features/walking/data/step_counter_service.dart';

/// Single source of truth for today's steps (P51).
///
/// Health Connect when permitted, otherwise on-device pedometer.
/// Home and the Walk tab must both consume [stream] / [latest] — never
/// maintain independent step listeners.
abstract final class StepsRepository {
  static Stream<LiveStepsSnapshot> get stream => StepCounterService.stream;

  static LiveStepsSnapshot get latest => StepCounterService.latest;

  static int get todaySteps => latest.todaySteps;

  static Future<LiveStepsSnapshot> refresh() => StepCounterService.refresh();

  static Future<void> startListening() => StepCounterService.startListening();

  /// Manual entry (web / no sensor) — updates the same stream Home reads.
  static Future<void> applyManualTodaySteps(int steps) =>
      StepCounterService.applyManualTodaySteps(steps);
}
