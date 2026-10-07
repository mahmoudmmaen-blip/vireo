/// Web / unsupported platforms: no hardware step stream.
Stream<int> pedometerCumulativeStream() => const Stream<int>.empty();

bool get pedometerHardwareSupported => false;
