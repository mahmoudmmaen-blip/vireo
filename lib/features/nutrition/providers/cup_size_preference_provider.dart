import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';

const _cupSizeKey = 'user_cup_size_ml';

/// User cup size preference in ml: small (200), standard (240), large (300).
class UserCupSizeNotifier extends Notifier<int> {
  static const int defaultCupMl = 240;
  static const List<int> supportedSizes = [200, 240, 300];

  @override
  int build() {
    if (!HiveService.isInitialized) return defaultCupMl;
    final raw = HiveService.settingsBox.get(_cupSizeKey);
    final ml = (raw as num?)?.toInt() ?? defaultCupMl;
    return supportedSizes.contains(ml) ? ml : defaultCupMl;
  }

  Future<void> setCupMl(int ml) async {
    final next = supportedSizes.contains(ml) ? ml : defaultCupMl;
    state = next;
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(_cupSizeKey, next);
  }
}

final userCupSizeProvider =
    NotifierProvider<UserCupSizeNotifier, int>(UserCupSizeNotifier.new);
