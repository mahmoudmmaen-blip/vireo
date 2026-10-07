import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';

/// Native platforms with a step-counter sensor.
Stream<int> pedometerCumulativeStream() {
  if (kIsWeb) return const Stream<int>.empty();
  return Pedometer.stepCountStream.map((e) => e.steps);
}

bool get pedometerHardwareSupported => !kIsWeb;
