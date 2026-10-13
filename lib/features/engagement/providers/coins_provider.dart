import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/engagement/domain/daily_coin_task.dart';
import 'package:vireo/features/engagement/services/coins_service.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

class CoinsNotifier extends StateNotifier<int> {
  CoinsNotifier() : super(CoinsService.getBalance());

  Future<int> awardTask(DailyCoinTask task) async {
    final awarded = await CoinsService.awardTask(task);
    if (awarded > 0) {
      state = CoinsService.getBalance();
    }
    return awarded;
  }

  Future<bool> spendForPro() async {
    final success = await CoinsService.spendForPro();
    if (success) {
      state = CoinsService.getBalance();
    }
    return success;
  }

  void refresh() {
    state = CoinsService.getBalance();
  }
}

final coinsBalanceProvider =
    StateNotifierProvider<CoinsNotifier, int>((ref) {
  return CoinsNotifier();
});

final isCoinsProActiveProvider = Provider<bool>((ref) {
  ref.watch(coinsBalanceProvider); // re-check when balance changes
  return FeatureGates.isCoinProUnlocked();
});
