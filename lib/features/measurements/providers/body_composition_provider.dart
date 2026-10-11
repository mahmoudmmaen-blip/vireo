import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/measurements/data/body_composition_repository.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

final bodyCompositionRepositoryProvider =
    Provider<BodyCompositionRepository>((ref) => const BodyCompositionRepository());

final bodyCompositionListProvider =
    AsyncNotifierProvider<BodyCompositionListNotifier, List<BodyCompositionReport>>(
  BodyCompositionListNotifier.new,
);

class BodyCompositionListNotifier
    extends AsyncNotifier<List<BodyCompositionReport>> {
  @override
  Future<List<BodyCompositionReport>> build() {
    return ref.read(bodyCompositionRepositoryProvider).loadAll();
  }

  Future<void> save(BodyCompositionReport report) async {
    await ref.read(bodyCompositionRepositoryProvider).save(report);
    state = AsyncValue.data(await ref.read(bodyCompositionRepositoryProvider).loadAll());
  }

  Future<void> remove(String id) async {
    await ref.read(bodyCompositionRepositoryProvider).delete(id);
    state = AsyncValue.data(await ref.read(bodyCompositionRepositoryProvider).loadAll());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(
      await ref.read(bodyCompositionRepositoryProvider).loadAll(),
    );
  }
}

final latestBodyCompositionProvider = Provider<BodyCompositionReport?>((ref) {
  final list = ref.watch(bodyCompositionListProvider).valueOrNull ?? const [];
  if (list.isEmpty) return null;
  return list.first;
});
