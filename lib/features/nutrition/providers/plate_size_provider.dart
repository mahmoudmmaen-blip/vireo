import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

enum PlateSize { small, medium, large }

extension PlateSizeX on PlateSize {
  double get scale => switch (this) {
        PlateSize.small => 0.85,
        PlateSize.medium => 1.0,
        PlateSize.large => 1.2,
      };

  String get storageKey => name;
}

const _plateKey = 'usual_plate_size';

class PlateSizeNotifier extends Notifier<PlateSize?> {
  @override
  PlateSize? build() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(_plateKey)?.toString();
    if (raw == null) return null;
    return PlateSize.values.where((e) => e.name == raw).firstOrNull;
  }

  Future<void> setSize(PlateSize size) async {
    state = size;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_plateKey, size.name);
  }
}

final plateSizeProvider =
    NotifierProvider<PlateSizeNotifier, PlateSize?>(PlateSizeNotifier.new);
