import 'package:vireo/features/measurements/domain/body_measurement.dart';

abstract interface class IMeasurementRepository {
  Future<List<BodyMeasurement>> getAll();

  Future<List<BodyMeasurement>> getRange(DateTime from, DateTime to);

  Future<void> add(BodyMeasurement measurement);

  Future<void> delete(String id);

  Future<BodyMeasurement?> getLatest();
}
