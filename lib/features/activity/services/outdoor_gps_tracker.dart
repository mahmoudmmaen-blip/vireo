import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vireo/features/activity/data/outdoor_met_calculator.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';

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

/// GPS session — only tracks while [start] … [stop] is active.
class OutdoorGpsTracker {
  OutdoorGpsTracker({
    required this.type,
    required this.weightKg,
    this.autoPauseEnabled = true,
  });

  final OutdoorWorkoutType type;
  final double weightKg;
  bool autoPauseEnabled;

  StreamSubscription<Position>? _sub;
  DateTime? _startedAt;
  DateTime? _lastTick;
  int _elapsedSeconds = 0;
  int _activeSeconds = 0;
  bool _paused = false;
  int _slowSeconds = 0;
  double _distanceM = 0;
  LatLng? _lastPoint;
  final _route = <OutdoorRoutePoint>[];
  final _splits = <OutdoorKmSplit>[];
  int _lastKmAnnounced = 0;
  int _kmSegmentStartActive = 0;
  int _calories = 0;
  double _speedKmh = 0;

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

    final speed = pos.speed >= 0 ? pos.speed * 3.6 : _speedKmh;
    _speedKmh = speed.clamp(0, 60);

    if (autoPauseEnabled && !_paused) {
      if (_speedKmh < 1) {
        _slowSeconds++;
        if (_slowSeconds >= 10) _paused = true;
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
    _route.add(
      OutdoorRoutePoint(
        latitude: pos.latitude,
        longitude: pos.longitude,
        timestamp: now,
      ),
    );

    _calories = OutdoorMetCalculator.calories(
      type: type,
      weightKg: weightKg,
      durationSeconds: _activeSeconds,
      speedKmh: _speedKmh > 0.5 ? _speedKmh : 3.5,
    );

    _maybeSplitKm();
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
      ),
    );
  }

  Future<OutdoorWorkoutSession?> stop({
    required int stepsAtStart,
    required int stepsAtEnd,
  }) async {
    await _sub?.cancel();
    _sub = null;
    if (_startedAt == null) return null;
    final ended = DateTime.now();
    final session = OutdoorWorkoutSession(
      id: 'outdoor_${ended.millisecondsSinceEpoch}',
      type: type,
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
    return session;
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
