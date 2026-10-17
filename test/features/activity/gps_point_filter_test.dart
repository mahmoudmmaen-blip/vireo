import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/activity/domain/gps_point_filter.dart';

void main() {
  test('drops accuracy > 25 m', () {
    expect(
      GpsPointFilter.acceptPoint(
        accuracyM: 30,
        impliedSpeedMps: 1.2,
        isRunning: false,
      ),
      isFalse,
    );
  });

  test('drops walk speed > 7 m/s and run > 12 m/s', () {
    expect(
      GpsPointFilter.acceptPoint(
        accuracyM: 10,
        impliedSpeedMps: 8,
        isRunning: false,
      ),
      isFalse,
    );
    expect(
      GpsPointFilter.acceptPoint(
        accuracyM: 10,
        impliedSpeedMps: 8,
        isRunning: true,
      ),
      isTrue,
    );
    expect(
      GpsPointFilter.acceptPoint(
        accuracyM: 10,
        impliedSpeedMps: 13,
        isRunning: true,
      ),
      isFalse,
    );
  });

  test('noisy grade returns 0', () {
    expect(
      GpsPointFilter.gradeFromAltitude(deltaAltM: 50, horizontalM: 10),
      0,
    );
  });
}
