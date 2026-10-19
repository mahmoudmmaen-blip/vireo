import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vireo/core/services/health_connect_write_service.dart';
import 'package:vireo/features/activity/data/outdoor_met_calculator.dart';
import 'package:vireo/features/activity/domain/gps_point_filter.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/walking/data/pedometer_stream_stub.dart'
    if (dart.library.io) 'package:vireo/features/walking/data/pedometer_stream_io.dart';

@immutable
class OutdoorLiveStats {
  const OutdoorLiveStats({
    required this.elapsedSeconds,
    required this.activeSeconds,
    required this.distanceMeters,
    required this.speedKmh,
    required this.calories,
    required this.route,
    required this.splits,
    required this.isPaused,
    required this.autoPauseEnabled,
    this.currentType = OutdoorWorkoutType.walk,
    this.detectedType,
    this.isManuallyOverridden = false,
    this.cadenceSpm = 0,
  });

  final int elapsedSeconds;
  final int activeSeconds;
  final double distanceMeters;
  final double speedKmh;
  final int calories;
  final List<LatLng> route;
  final List<OutdoorKmSplit> splits;
  final bool isPaused;
  final bool autoPauseEnabled;
  final OutdoorWorkoutType currentType;
  final OutdoorWorkoutType? detectedType;
  final bool isManuallyOverridden;
  final double cadenceSpm;

  static const initial = OutdoorLiveStats(
    elapsedSeconds: 0,
    activeSeconds: 0,
    distanceMeters: 0,
    speedKmh: 0,
    calories: 0,
    route: [],
    splits: [],
    isPaused: false,
    autoPauseEnabled: true,
  );

  double? get paceMinPerKm {
    if (distanceMeters <= 0) return null;
    final km = distanceMeters / 1000;
    return (activeSeconds / 60) / km;
  }
}

class _Sample {
  const _Sample({required this.time, required this.speedKmh, required this.steps});
  final DateTime time;
  final double speedKmh;
  final int steps;
}

/// GPS session — only tracks while [start] … [stop] is active.
class OutdoorGpsTracker {
  OutdoorGpsTracker({
    required OutdoorWorkoutType type,
    required this.weightKg,
    this.autoPauseEnabled = true,
    this.age = 30,
    this.isFemale = false,
    this.heartRateBpm,
  }) : _currentType = type;

  OutdoorWorkoutType _currentType;
  OutdoorWorkoutType get currentType => _currentType;
  OutdoorWorkoutType? _detectedType;
  bool _isManuallyOverridden = false;

  final double weightKg;
  final int age;
  final bool isFemale;
  double? heartRateBpm;
  bool autoPauseEnabled;

  StreamSubscription<Position>? _sub;
  StreamSubscription<int>? _pedometerSub;
  int _latestSteps = 0;
  final _samples = <_Sample>[];
  double _smoothedSpeedKmh = 0;
  double _smoothedSpeedMps = 0;
  double _cadenceSpm = 0;
  double _smoothedAltitude = double.nan;
  double _grade = 0;
  DateTime? _startedAt;
  DateTime? _lastTick;
  DateTime? _lastAcceptedAt;
  int _elapsedSeconds = 0;
  int _activeSeconds = 0;
  bool _paused = false;
  int _slowSeconds = 0;
  double _distanceM = 0;
  LatLng? _lastPoint;
  double? _lastAltitude;
  final _route = <OutdoorRoutePoint>[];
  final _splits = <OutdoorKmSplit>[];
  int _lastKmAnnounced = 0;
  int _kmSegmentStartActive = 0;
  int _calories = 0;
  double _speedKmh = 0;
  double _accuracySum = 0;
  int _accuracyCount = 0;

  double get meanAccuracyM =>
      _accuracyCount == 0 ? 99 : _accuracySum / _accuracyCount;

  final _controller = StreamController<OutdoorLiveStats>.broadcast();
  Stream<OutdoorLiveStats> get stream => _controller.stream;

  List<OutdoorRoutePoint> get routePoints => List.unmodifiable(_route);

  Future<bool> ensureLocationPermission({required bool forWorkout}) async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (forWorkout &&
        perm == LocationPermission.whileInUse &&
        defaultTargetPlatform == TargetPlatform.android) {
      // Background / foreground service path uses while-in-use until user starts workout;
      // geolocator foreground notification keeps tracking during workout.
    }
    return perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse;
  }

  Future<void> start() async {
    if (_sub != null) return;
    _startedAt = DateTime.now();
    _lastTick = _startedAt;
    final LocationSettings settings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Vireo outdoor workout',
          notificationText: 'GPS tracking in progress',
          enableWakeLock: true,
        ),
      );
    } else {
      settings = AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
        activityType: ActivityType.fitness,
      );
    }
    if (pedometerHardwareSupported && !kIsWeb) {
      _pedometerSub = pedometerCumulativeStream().listen(
        (steps) {
          _latestSteps = steps;
        },
        onError: (_) {},
      );
    }
    _sub = Geolocator.getPositionStream(locationSettings: settings).listen(
      _onPosition,
      onError: (_) {},
    );
    _emit();
  }

  void _onPosition(Position pos) {
    final point = LatLng(pos.latitude, pos.longitude);
    final now = DateTime.now();
    _tickClock(now);

    final accuracy = pos.accuracy;
    _accuracySum += accuracy;
    _accuracyCount++;

    double impliedMps = 0;
    if (_lastPoint != null && _lastAcceptedAt != null) {
      final delta = const Distance().as(
        LengthUnit.Meter,
        _lastPoint!,
        point,
      );
      final dt = now.difference(_lastAcceptedAt!).inMilliseconds / 1000.0;
      if (dt > 0) impliedMps = delta / dt;
    } else if (pos.speed >= 0) {
      impliedMps = pos.speed;
    }

    final isRunning = _currentType == OutdoorWorkoutType.run;
    if (!GpsPointFilter.acceptPoint(
      accuracyM: accuracy,
      impliedSpeedMps: impliedMps,
      isRunning: isRunning,
    )) {
      _emit();
      return;
    }

    _smoothedSpeedMps = GpsPointFilter.smoothSpeed(
      previous: _smoothedSpeedMps,
      measured: impliedMps > 0 ? impliedMps : (pos.speed >= 0 ? pos.speed : 0),
    );
    _speedKmh = (_smoothedSpeedMps * 3.6).clamp(0, 60);
    _smoothedSpeedKmh = _speedKmh;

    if (pos.altitude.isFinite) {
      _smoothedAltitude = GpsPointFilter.smoothAltitude(
        previous: _smoothedAltitude,
        measured: pos.altitude,
      );
      if (_lastPoint != null && _lastAltitude != null) {
        final horiz = const Distance().as(
          LengthUnit.Meter,
          _lastPoint!,
          point,
        );
        _grade = GpsPointFilter.gradeFromAltitude(
          deltaAltM: _smoothedAltitude - _lastAltitude!,
          horizontalM: horiz,
        );
      }
      _lastAltitude = _smoothedAltitude;
    }

    // 20s smoothing buffer for cadence
    _samples.add(_Sample(time: now, speedKmh: _speedKmh, steps: _latestSteps));
    final windowCutoff = now.subtract(const Duration(seconds: 20));
    _samples.removeWhere((s) => s.time.isBefore(windowCutoff));

    if (_samples.length > 1) {
      final durationSec =
          _samples.last.time.difference(_samples.first.time).inSeconds;
      final stepDelta = _samples.last.steps - _samples.first.steps;
      if (durationSec > 0 && stepDelta >= 0) {
        _cadenceSpm = (stepDelta / durationSec) * 60;
      }
    }

    _evaluateAutoDetect();

    // Auto-pause: speed < 0.5 m/s for 10 s
    if (autoPauseEnabled && !_paused) {
      if (_smoothedSpeedMps < GpsPointFilter.autoPauseSpeedMps) {
        _slowSeconds++;
        if (_slowSeconds >= GpsPointFilter.autoPauseSeconds) _paused = true;
      } else {
        _slowSeconds = 0;
      }
    }

    if (_lastPoint != null) {
      final delta = const Distance().as(
        LengthUnit.Meter,
        _lastPoint!,
        point,
      );
      if (!_paused && delta > 0.5) {
        _distanceM += delta;
      }
    }
    _lastPoint = point;
    _lastAcceptedAt = now;
    _route.add(
      OutdoorRoutePoint(
        latitude: pos.latitude,
        longitude: pos.longitude,
        timestamp: now,
      ),
    );

    _recomputeCalories();

    _maybeSplitKm();
    _emit();
  }

  void _evaluateAutoDetect() {
    // Detection rules:
    // Cadence < 130 spm = walk, >= 140 spm = run, speed > 15 km/h with low cadence (< 90) = cycle
    OutdoorWorkoutType? detected;
    if (_smoothedSpeedKmh > 15.0 && _cadenceSpm < 90) {
      detected = OutdoorWorkoutType.cycle;
    } else if (_cadenceSpm >= 140) {
      detected = OutdoorWorkoutType.run;
    } else if (_cadenceSpm > 0 && _cadenceSpm < 130) {
      detected = OutdoorWorkoutType.walk;
    } else if (_smoothedSpeedKmh > 8.0 && _cadenceSpm == 0) {
      // Fallback if no step sensor: fast pace without pedometer
      detected = OutdoorWorkoutType.run;
    }

    if (detected != null) {
      _detectedType = detected;
      if (!_isManuallyOverridden && _currentType != detected) {
        _currentType = detected;
        _recomputeCalories();
      }
    }
  }

  void _recomputeCalories() {
    _calories = OutdoorMetCalculator.calories(
      type: _currentType,
      weightKg: weightKg,
      durationSeconds: _activeSeconds,
      speedKmh: _speedKmh > 0.5 ? _speedKmh : 3.5,
      grade: _grade,
      heartRateBpm: heartRateBpm,
      age: age,
      isFemale: isFemale,
    );
  }

  void manualOverrideType(OutdoorWorkoutType newType) {
    _isManuallyOverridden = true;
    _currentType = newType;
    _recomputeCalories();
    _emit();
  }

  void resetManualOverride() {
    _isManuallyOverridden = false;
    if (_detectedType != null) {
      _currentType = _detectedType!;
      _recomputeCalories();
    }
    _emit();
  }

  void _tickClock(DateTime now) {
    if (_lastTick == null) return;
    final delta = now.difference(_lastTick!).inSeconds;
    if (delta <= 0) return;
    _elapsedSeconds += delta;
    if (!_paused) _activeSeconds += delta;
    _lastTick = now;
  }

  void _maybeSplitKm() {
    final km = (_distanceM / 1000).floor();
    while (_lastKmAnnounced < km) {
      _lastKmAnnounced++;
      final segDuration = _activeSeconds - _kmSegmentStartActive;
      final pace = segDuration / 60;
      _splits.add(
        OutdoorKmSplit(
          kmIndex: _lastKmAnnounced,
          durationSeconds: segDuration,
          paceMinPerKm: pace,
        ),
      );
      _kmSegmentStartActive = _activeSeconds;
    }
  }

  void togglePause() {
    _paused = !_paused;
    _slowSeconds = 0;
    _emit();
  }

  void setAutoPause(bool enabled) {
    autoPauseEnabled = enabled;
    _emit();
  }

  void _emit() {
    if (_controller.isClosed) return;
    _controller.add(
      OutdoorLiveStats(
        elapsedSeconds: _elapsedSeconds,
        activeSeconds: _activeSeconds,
        distanceMeters: _distanceM,
        speedKmh: _speedKmh,
        calories: _calories,
        route: _route
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList(growable: false),
        splits: List.unmodifiable(_splits),
        isPaused: _paused,
        autoPauseEnabled: autoPauseEnabled,
        currentType: _currentType,
        detectedType: _detectedType,
        isManuallyOverridden: _isManuallyOverridden,
        cadenceSpm: _cadenceSpm,
      ),
    );
  }

  Future<OutdoorWorkoutSession?> stop({
    required int stepsAtStart,
    required int stepsAtEnd,
  }) async {
    await _sub?.cancel();
    _sub = null;
    await _pedometerSub?.cancel();
    _pedometerSub = null;
    if (_startedAt == null) return null;
    final ended = DateTime.now();
    final session = OutdoorWorkoutSession(
      id: 'outdoor_${ended.millisecondsSinceEpoch}',
      type: _currentType,
      startedAt: _startedAt!,
      endedAt: ended,
      routePoints: List.from(_route),
      splits: List.from(_splits),
      distanceMeters: _distanceM,
      durationSeconds: _activeSeconds,
      caloriesBurned: _calories,
      stepsAtStart: stepsAtStart,
      stepsAtEnd: stepsAtEnd,
    );
    await _controller.close();
    // Best-effort Health Connect write — never blocks local session save.
    unawaited(
      HealthConnectWriteService.writeExerciseSession(
        start: session.startedAt,
        end: session.endedAt,
        isRun: session.type == OutdoorWorkoutType.run,
        energyKcal: session.caloriesBurned,
        distanceMeters: session.distanceMeters.round(),
      ),
    );
    return session;
  }

  void dispose() {
    _sub?.cancel();
    _pedometerSub?.cancel();
    _controller.close();
  }
}
