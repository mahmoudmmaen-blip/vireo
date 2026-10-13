import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

enum PlateSize { small, medium, large }

extension PlateSizeX on PlateSize {
  double get scale => switch (this) {
        PlateSize.small => 0.85,
        PlateSize.medium => 1.0,
        PlateSize.large => 1.2,
      };

  int get diameterCm => switch (this) {
        PlateSize.small => 20,
        PlateSize.medium => 24,
        PlateSize.large => 28,
      };

  String label(String locale) {
    final isAr = locale.startsWith('ar');
    return switch (this) {
      PlateSize.small => isAr ? 'صغير (20 سم)' : 'Small (20 cm)',
      PlateSize.medium => isAr ? 'متوسط (24 سم)' : 'Medium (24 cm)',
      PlateSize.large => isAr ? 'كبير (28 سم)' : 'Large (28 cm)',
    };
  }

  String get storageKey => name;
}

enum RiceCupSize {
  standard200,
  large250,
  mug300;

  int get ml => switch (this) {
        RiceCupSize.standard200 => 200,
        RiceCupSize.large250 => 250,
        RiceCupSize.mug300 => 300,
      };

  String label(String locale) {
    final isAr = locale.startsWith('ar');
    return switch (this) {
      RiceCupSize.standard200 => isAr ? 'كوب شاي عادي (200 مل)' : 'Standard tea cup (200 ml)',
      RiceCupSize.large250 => isAr ? 'كوب ماء متوسط (250 مل)' : 'Medium water glass (250 ml)',
      RiceCupSize.mug300 => isAr ? 'ماج كبير (300 مل)' : 'Large mug (300 ml)',
    };
  }
}

const _plateKey = 'usual_plate_size';
const _riceCupKey = 'usual_rice_cup_size';

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

class RiceCupSizeNotifier extends Notifier<RiceCupSize?> {
  @override
  RiceCupSize? build() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(_riceCupKey)?.toString();
    if (raw == null) return null;
    return RiceCupSize.values.where((e) => e.name == raw).firstOrNull;
  }

  Future<void> setSize(RiceCupSize size) async {
    state = size;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_riceCupKey, size.name);
  }
}

final plateSizeProvider =
    NotifierProvider<PlateSizeNotifier, PlateSize?>(PlateSizeNotifier.new);

final riceCupSizeProvider =
    NotifierProvider<RiceCupSizeNotifier, RiceCupSize?>(RiceCupSizeNotifier.new);
