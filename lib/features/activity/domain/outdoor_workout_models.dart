import 'package:flutter/foundation.dart';

enum OutdoorWorkoutType {
  walk('walk'),
  run('run'),
  cycle('cycle');

  const OutdoorWorkoutType(this.value);
  final String value;

  static OutdoorWorkoutType fromValue(String? v) {
    return OutdoorWorkoutType.values.firstWhere(
      (e) => e.value == v,
      orElse: () => OutdoorWorkoutType.walk,
    );
  }
}

@immutable
class OutdoorRoutePoint {
  const OutdoorRoutePoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  final double latitude;
  final double longitude;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'lat': latitude,
        'lng': longitude,
        'ts': timestamp.toIso8601String(),
      };

  factory OutdoorRoutePoint.fromJson(Map<String, dynamic> json) {
    return OutdoorRoutePoint(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      timestamp: DateTime.parse(json['ts'] as String),
    );
  }
}

@immutable
class OutdoorKmSplit {
  const OutdoorKmSplit({
    required this.kmIndex,
    required this.durationSeconds,
    required this.paceMinPerKm,
  });

  final int kmIndex;
  final int durationSeconds;
  final double paceMinPerKm;

  Map<String, dynamic> toJson() => {
        'km': kmIndex,
        'duration_s': durationSeconds,
        'pace': paceMinPerKm,
      };

  factory OutdoorKmSplit.fromJson(Map<String, dynamic> json) {
    return OutdoorKmSplit(
      kmIndex: json['km'] as int? ?? 1,
      durationSeconds: json['duration_s'] as int? ?? 0,
      paceMinPerKm: (json['pace'] as num?)?.toDouble() ?? 0,
    );
  }
}

@immutable
class OutdoorWorkoutSession {
  const OutdoorWorkoutSession({
    required this.id,
    required this.type,
    required this.startedAt,
    required this.endedAt,
    required this.routePoints,
    required this.splits,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.caloriesBurned,
    this.stepsAtStart,
    this.stepsAtEnd,
  });

  final String id;
  final OutdoorWorkoutType type;
  final DateTime startedAt;
  final DateTime endedAt;
  final List<OutdoorRoutePoint> routePoints;
  final List<OutdoorKmSplit> splits;
  final double distanceMeters;
  final int durationSeconds;
  final int caloriesBurned;
  final int? stepsAtStart;
  final int? stepsAtEnd;

  double get distanceKm => distanceMeters / 1000;

  double? get avgPaceMinPerKm {
    if (type == OutdoorWorkoutType.cycle) return null;
    if (distanceKm <= 0) return null;
    return (durationSeconds / 60) / distanceKm;
  }

  double? get avgSpeedKmh {
    if (durationSeconds <= 0) return null;
    return distanceKm / (durationSeconds / 3600);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.value,
        'started_at': startedAt.toIso8601String(),
        'ended_at': endedAt.toIso8601String(),
        'route': routePoints.map((p) => p.toJson()).toList(),
        'splits': splits.map((s) => s.toJson()).toList(),
        'distance_m': distanceMeters,
        'duration_s': durationSeconds,
        'calories': caloriesBurned,
        'steps_start': stepsAtStart,
        'steps_end': stepsAtEnd,
      };

  factory OutdoorWorkoutSession.fromJson(Map<String, dynamic> json) {
    return OutdoorWorkoutSession(
      id: json['id'] as String? ?? '',
      type: OutdoorWorkoutType.fromValue(json['type'] as String?),
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      routePoints: (json['route'] as List? ?? [])
          .whereType<Map>()
          .map((e) => OutdoorRoutePoint.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      splits: (json['splits'] as List? ?? [])
          .whereType<Map>()
          .map((e) => OutdoorKmSplit.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      distanceMeters: (json['distance_m'] as num?)?.toDouble() ?? 0,
      durationSeconds: json['duration_s'] as int? ?? 0,
      caloriesBurned: json['calories'] as int? ?? 0,
      stepsAtStart: (json['steps_start'] as num?)?.toInt(),
      stepsAtEnd: (json['steps_end'] as num?)?.toInt(),
    );
  }
}
