import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const _cupKey = 'water_default_cup_ml';
const kDefaultCupMl = 250;
const kQuickWaterAmounts = [150, 250, 330, 500, 750];

class WaterCupSizeNotifier extends Notifier<int> {
  @override
  int build() {
    if (!HiveService.isInitialized) return kDefaultCupMl;
    final raw = HiveService.settingsBox.get(_cupKey);
    final ml = (raw as num?)?.toInt() ?? kDefaultCupMl;
    return ml.clamp(100, 1000);
  }

  Future<void> setCupMl(int ml) async {
    final next = ml.clamp(100, 1000);
    state = next;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_cupKey, next);
  }
}

final waterCupSizeProvider =
    NotifierProvider<WaterCupSizeNotifier, int>(WaterCupSizeNotifier.new);
