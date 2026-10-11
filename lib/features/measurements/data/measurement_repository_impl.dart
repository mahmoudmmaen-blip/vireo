import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/sync_engine.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/features/measurements/application/measurement_calculators.dart';
import 'package:vireo/features/measurements/domain/body_measurement.dart';
import 'package:vireo/features/measurements/domain/i_measurement_repository.dart';

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

class MeasurementRepositoryImpl implements IMeasurementRepository {
  MeasurementRepositoryImpl({required this.readProfileContext});

  final MeasurementProfileContext Function() readProfileContext;

  @override
  Future<List<BodyMeasurement>> getAll() async {
    return _readSorted();
  }

  @override
  Future<List<BodyMeasurement>> getRange(DateTime from, DateTime to) async {
    final start = _dateOnly(from);
    final end = _dateOnly(to);
    return _readSorted().where((m) {
      final d = _dateOnly(m.date);
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList();
  }

  @override
  Future<void> add(BodyMeasurement measurement) async {
    final enriched = _enrichBodyFat(measurement);
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.bodyMeasurementsBox.put(enriched.id, enriched.toJson());
      await SyncEngine().enqueueChange(
        table: 'body_measurements',
        id: enriched.id,
        operation: SyncOperation.insert,
        data: {
          'id': enriched.id,
          'payload': enriched.toJson(),
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    if (!HiveService.isInitialized) return;
    try {
      await HiveService.bodyMeasurementsBox.delete(id);
      await SyncEngine().enqueueChange(
        table: 'body_measurements',
        id: id,
        operation: SyncOperation.delete,
        data: {'id': id},
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<BodyMeasurement?> getLatest() async {
    final all = await getAll();
    return all.isEmpty ? null : all.first;
  }

  List<BodyMeasurement> _readSorted() {
    if (!HiveService.isInitialized) return const [];

    try {
      final box = HiveService.bodyMeasurementsBox;
      final items = box.values
          .whereType<Map>()
          .map((e) => BodyMeasurement.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return items;
    } catch (_) {
      return const [];
    }
  }

  BodyMeasurement _enrichBodyFat(BodyMeasurement measurement) {
    final ctx = readProfileContext();
    return BodyFatCalculator.withAutoBodyFat(
      measurement,
      heightCm: ctx.heightCm,
      isFemale: ctx.isFemale,
      neckCm: ctx.neckCm,
      hipCm: ctx.hipCm,
    );
  }
}

class MeasurementProfileContext {
  const MeasurementProfileContext({
    required this.heightCm,
    required this.isFemale,
    required this.goal,
    this.neckCm,
    this.hipCm,
  });

  final double heightCm;
  final bool isFemale;
  final FitnessGoal goal;
  final double? neckCm;
  final double? hipCm;

  bool get deficitGoal =>
      goal == FitnessGoal.weightLoss || goal == FitnessGoal.generalVitality;
}

MeasurementProfileContext readMeasurementProfileContext() {
  if (!HiveService.isInitialized) {
    return const MeasurementProfileContext(
      heightCm: 170,
      isFemale: false,
      goal: FitnessGoal.generalVitality,
    );
  }

  final profile = HiveService.cacheBox.get('guest_profile');
  if (profile is! Map) {
    return const MeasurementProfileContext(
      heightCm: 170,
      isFemale: false,
      goal: FitnessGoal.generalVitality,
    );
  }

  final map = Map<String, dynamic>.from(profile);
  final gender = (map['gender'] as String? ?? map['sex'] as String? ?? 'male')
      .toLowerCase();

  return MeasurementProfileContext(
    heightCm: (map['height_cm'] as num?)?.toDouble() ?? 170,
    isFemale: gender.startsWith('f'),
    goal: FitnessGoal.fromValue(
      map['goal'] as String? ?? FitnessGoal.generalVitality.value,
    ),
    neckCm: (map['neck_cm'] as num?)?.toDouble(),
    hipCm: (map['hip_cm'] as num?)?.toDouble(),
  );
}
