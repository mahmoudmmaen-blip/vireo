import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:health/health.dart';
import 'package:vireo/data/models/daily_step_count.dart';

/// Reads step counts from HealthKit (iOS) and Health Connect (Android).
abstract final class HealthStepsService {
  static final Health _health = Health();
  static const _types = [HealthDataType.STEPS];
  static const _permissions = [HealthDataAccess.READ];
  static bool _configured = false;

  static bool get isSupported =>
      !Platform.isWindows && !Platform.isLinux && !Platform.isMacOS;

  static Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  static Future<bool> hasPermission() async {
    if (!isSupported) return false;
    try {
      await _ensureConfigured();
      return await _health.hasPermissions(_types, permissions: _permissions) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> requestPermission() async {
    if (!isSupported) return false;
    try {
      await _ensureConfigured();
      return await _health.requestAuthorization(
        _types,
        permissions: _permissions,
      );
    } catch (_) {
      return false;
    }
  }

  static Future<HealthStepsSnapshot> fetchSnapshot() async {
    if (!isSupported) {
      return const HealthStepsSnapshot(status: HealthStepsStatus.unavailable);
    }

    try {
      await _ensureConfigured();
      final granted = await requestPermission();
      if (!granted) {
        final hasAccess = await hasPermission();
        if (!hasAccess) {
          return const HealthStepsSnapshot(status: HealthStepsStatus.denied);
        }
      }

      final todaySteps = await _fetchStepsForDay(DateTime.now());
      final last7Days = await Future.wait(
        List.generate(7, (index) async {
          final date = DateTime.now().subtract(Duration(days: 6 - index));
          final steps = await _fetchStepsForDay(date);
          return DailyStepCount(
            date: DateTime(date.year, date.month, date.day),
            steps: steps,
          );
        }),
      );

      return HealthStepsSnapshot(
        status: HealthStepsStatus.granted,
        todaySteps: todaySteps,
        last7Days: last7Days,
      );
    } catch (_) {
      return const HealthStepsSnapshot(status: HealthStepsStatus.denied);
    }
  }

  static Future<int> _fetchStepsForDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final steps = await _health.getTotalStepsInInterval(start, end);
    return steps ?? 0;
  }

  static Future<void> openSystemSettings() async {
    try {
      await AppSettings.openAppSettings();
    } catch (_) {
      rethrow;
    }
  }
}
