import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/measurements/application/measurement_calculators.dart';
import 'package:vireo/features/measurements/data/measurement_repository_impl.dart';
import 'package:vireo/features/measurements/domain/body_measurement.dart';
import 'package:vireo/features/measurements/domain/i_measurement_repository.dart';
import 'package:vireo/features/measurements/domain/measurement_trend.dart';

enum MeasurementChartRange {
  days7,
  days30,
  months3,
  all,
}

final measurementRepositoryProvider = Provider<IMeasurementRepository>((ref) {
  return MeasurementRepositoryImpl(
    readProfileContext: readMeasurementProfileContext,
  );
});

final measurementChartRangeProvider = StateProvider<MeasurementChartRange>(
  (ref) => MeasurementChartRange.days30,
);

class MeasurementListNotifier extends AsyncNotifier<List<BodyMeasurement>> {
  @override
  Future<List<BodyMeasurement>> build() async {
    return ref.read(measurementRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(measurementRepositoryProvider).getAll(),
    );
  }

  Future<void> addMeasurement(BodyMeasurement measurement) async {
    await ref.read(measurementRepositoryProvider).add(measurement);
    ref.invalidate(latestMeasurementProvider);
    ref.invalidate(measurementTrendProvider);
    await refresh();
  }

  Future<void> deleteMeasurement(String id) async {
    await ref.read(measurementRepositoryProvider).delete(id);
    ref.invalidate(latestMeasurementProvider);
    ref.invalidate(measurementTrendProvider);
    await refresh();
  }
}

final measurementListProvider =
    AsyncNotifierProvider<MeasurementListNotifier, List<BodyMeasurement>>(
  MeasurementListNotifier.new,
);

final latestMeasurementProvider = FutureProvider<BodyMeasurement?>((ref) async {
  ref.watch(measurementListProvider);
  return ref.read(measurementRepositoryProvider).getLatest();
});

final measurementTrendProvider = Provider<MeasurementTrend>((ref) {
  final list = ref.watch(measurementListProvider).valueOrNull ?? const [];
  final ctx = readMeasurementProfileContext();
  final weights = list.take(3).map((m) => m.weightKg).toList();
  return MeasurementTrendCalculator.fromWeights(
    weightsKg: weights,
    deficitGoal: ctx.deficitGoal,
  );
});

final filteredMeasurementsProvider = Provider<List<BodyMeasurement>>((ref) {
  final list = ref.watch(measurementListProvider).valueOrNull ?? const [];
  final range = ref.watch(measurementChartRangeProvider);
  if (list.isEmpty) return list;

  final now = DateTime.now();
  DateTime? from;
  switch (range) {
    case MeasurementChartRange.days7:
      from = now.subtract(const Duration(days: 7));
    case MeasurementChartRange.days30:
      from = now.subtract(const Duration(days: 30));
    case MeasurementChartRange.months3:
      from = now.subtract(const Duration(days: 90));
    case MeasurementChartRange.all:
      from = null;
  }

  if (from == null) return list.reversed.toList();

  return list
      .where((m) => !m.date.isBefore(from!))
      .toList()
      .reversed
      .toList();
});

String newMeasurementId() => 'meas_${DateTime.now().millisecondsSinceEpoch}';
