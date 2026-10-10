import 'package:health/health.dart';
import 'package:vireo/core/utils/platform_utils.dart';

enum HealthMetricKind {
  heartRate,
  restingHeartRate,
  hrv,
  bloodOxygen,
  sleep,
  weight,
  workout,
  steps,
}

class DailyMetricPoint {
  const DailyMetricPoint({required this.day, required this.value});
  final DateTime day;
  final double value;
}

class HealthMetricCardData {
  const HealthMetricCardData({
    required this.kind,
    required this.todayValue,
    required this.unit,
    required this.last7Days,
  });

  final HealthMetricKind kind;
  final String todayValue;
  final String unit;
  final List<DailyMetricPoint> last7Days;
}

class HealthHubSnapshot {
  const HealthHubSnapshot({
    required this.permissionGranted,
    required this.metrics,
  });

  final bool permissionGranted;
  final List<HealthMetricCardData> metrics;

  bool get hasAnyData => metrics.isNotEmpty;
}

abstract final class WearableHealthService {
  static final Health _health = Health();
  static bool _configured = false;

  static bool get isSupported =>
      PlatformUtils.isIOS || PlatformUtils.isAndroid;

  static final _types = [
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WEIGHT,
    HealthDataType.WORKOUT,
    HealthDataType.STEPS,
  ];

  static Future<void> _configure() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  static Future<bool> requestPermissions() async {
    if (!isSupported) return false;
    await _configure();
    return _health.requestAuthorization(
      _types,
      permissions: List.filled(_types.length, HealthDataAccess.READ),
    );
  }

  static Future<bool> hasPermissions() async {
    if (!isSupported) return false;
    await _configure();
    return await _health.hasPermissions(
          _types,
          permissions: List.filled(_types.length, HealthDataAccess.READ),
        ) ??
        false;
  }

  static Future<HealthHubSnapshot> fetch() async {
    if (!isSupported) {
      return const HealthHubSnapshot(permissionGranted: false, metrics: []);
    }
    await _configure();
    final granted = await requestPermissions();
    if (!granted) {
      return const HealthHubSnapshot(permissionGranted: false, metrics: []);
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final end = now;

    final metrics = <HealthMetricCardData>[];

    Future<void> addNumeric(
      HealthMetricKind kind,
      HealthDataType type,
      String unit, {
      double Function(double)? transform,
    }) async {
      final series = await _dailySeries(type, start, end, transform: transform);
      if (series.isEmpty) return;
      final today = series.last.value;
      metrics.add(
        HealthMetricCardData(
          kind: kind,
          todayValue: _fmt(today),
          unit: unit,
          last7Days: series,
        ),
      );
    }

    await addNumeric(HealthMetricKind.heartRate, HealthDataType.HEART_RATE, 'bpm');
    await addNumeric(
      HealthMetricKind.restingHeartRate,
      HealthDataType.RESTING_HEART_RATE,
      'bpm',
    );
    await addNumeric(
      HealthMetricKind.hrv,
      HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
      'ms',
    );
    await addNumeric(
      HealthMetricKind.bloodOxygen,
      HealthDataType.BLOOD_OXYGEN,
      '%',
      transform: (v) => v <= 1 ? v * 100 : v,
    );
    await addNumeric(HealthMetricKind.weight, HealthDataType.WEIGHT, 'kg');
    await addNumeric(HealthMetricKind.steps, HealthDataType.STEPS, 'steps');

    final sleepHours = await _sleepHoursSeries(start, end);
    if (sleepHours.any((p) => p.value > 0)) {
      metrics.add(
        HealthMetricCardData(
          kind: HealthMetricKind.sleep,
          todayValue: _fmt(sleepHours.last.value),
          unit: 'h',
          last7Days: sleepHours,
        ),
      );
    }

    return HealthHubSnapshot(permissionGranted: true, metrics: metrics);
  }

  static String _fmt(double v) {
    if (v >= 100) return v.round().toString();
    return v.toStringAsFixed(1);
  }

  static Future<List<DailyMetricPoint>> _dailySeries(
    HealthDataType type,
    DateTime start,
    DateTime end, {
    double Function(double)? transform,
  }) async {
    final data = await _health.getHealthDataFromTypes(
      types: [type],
      startTime: start,
      endTime: end,
    );
    if (data.isEmpty) return const [];

    final buckets = <DateTime, List<double>>{};
    for (final p in data) {
      final day = DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day);
      var v = (p.value as num).toDouble();
      if (transform != null) v = transform(v);
      buckets.putIfAbsent(day, () => []).add(v);
    }

    final days = List.generate(7, (i) {
      final d = DateTime(start.year, start.month, start.day).add(Duration(days: i));
      final vals = buckets[d] ?? const [];
      final avg = vals.isEmpty ? 0.0 : vals.reduce((a, b) => a + b) / vals.length;
      return DailyMetricPoint(day: d, value: avg);
    });
    if (days.every((p) => p.value <= 0)) return const [];
    return days;
  }

  static Future<List<DailyMetricPoint>> _sleepHoursSeries(
    DateTime start,
    DateTime end,
  ) async {
    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.SLEEP_SESSION],
      startTime: start,
      endTime: end,
    );
    final buckets = <DateTime, double>{};
    for (final p in data) {
      final day = DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day);
      final hours = p.dateTo.difference(p.dateFrom).inMinutes / 60.0;
      buckets[day] = (buckets[day] ?? 0) + hours;
    }
    return List.generate(7, (i) {
      final d = DateTime(start.year, start.month, start.day).add(Duration(days: i));
      return DailyMetricPoint(day: d, value: buckets[d] ?? 0);
    });
  }

  /// Daily average HRV (ms) for stress baseline.
  static Future<List<DailyMetricPoint>> fetchHrvDaily(int days) async {
    if (!isSupported) return const [];
    await _configure();
    if (!await hasPermissions()) return const [];
    final end = DateTime.now();
    final start = DateTime(end.year, end.month, end.day)
        .subtract(Duration(days: days - 1));
    final data = await _health.getHealthDataFromTypes(
      types: [HealthDataType.HEART_RATE_VARIABILITY_RMSSD],
      startTime: start,
      endTime: end,
    );
    if (data.isEmpty) return const [];
    final buckets = <DateTime, List<double>>{};
    for (final p in data) {
      final day = DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day);
      final v = (p.value as num).toDouble();
      buckets.putIfAbsent(day, () => []).add(v);
    }
    return List.generate(days, (i) {
      final d = start.add(Duration(days: i));
      final vals = buckets[d] ?? const [];
      final avg = vals.isEmpty ? 0.0 : vals.reduce((a, b) => a + b) / vals.length;
      return DailyMetricPoint(day: d, value: avg);
    });
  }
}
