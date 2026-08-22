import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';

enum PaywallContext {
  standard,
  trialEnded,
  subscriptionExpired,
}

enum PurchaseOutcome {
  success,
  cancelled,
  error,
}

enum RestoreOutcome {
  success,
  nothingToRestore,
  cancelled,
  error,
}

class SubscriptionNotifier extends AsyncNotifier<SubscriptionSnapshot> {
  StreamSubscription<CustomerInfo>? _subscription;
  List<SubscriptionPlan> _plans = SubscriptionSnapshot.demoFree.plans;
  Offering? _offering;

  @override
  Future<SubscriptionSnapshot> build() async {
    ref.onDispose(() => _subscription?.cancel());

    ref.listen(authProvider, (previous, next) {
      next.whenData((state) => _syncRevenueCatUser(state.user?.id));
    });

    return _load();
  }

  Future<SubscriptionSnapshot> _load() async {
    if (!RevenueCatService.isConfigured) {
      return _demoSnapshot();
    }

    if (!RevenueCatService.isInitialized) {
      try {
        await RevenueCatService.init();
      } catch (_) {}
    }

    try {
      _offering = (await RevenueCatService.getOfferings())?.current;
      _plans = RevenueCatService.plansFromOffering(_offering);
    } catch (_) {
      _plans = SubscriptionSnapshot.demoFree.plans;
    }

    if (!RevenueCatService.isInitialized) {
      return SubscriptionSnapshot.demoFree.copyWith(
        plans: _plans,
        isConfigured: false,
      );
    }

    _subscription?.cancel();
    _subscription = RevenueCatService.customerInfoStream.listen((info) {
      state = AsyncData(_parse(info));
    });

    final userId = SupabaseService.auth.currentUser?.id;
    if (userId != null) {
      await _syncRevenueCatUser(userId);
    }

    final info = await RevenueCatService.getCustomerInfo();
    return _parse(info);
  }

  SubscriptionSnapshot _parse(CustomerInfo info) {
    return RevenueCatService.parseCustomerInfo(
      info,
      plans: _plans,
      isConfigured: RevenueCatService.isConfigured,
    );
  }

  SubscriptionSnapshot _demoSnapshot() {
    final override = HiveService.settingsBox.get('demo_subscription_level') as String?;
    if (override == 'trial') {
      return SubscriptionSnapshot.demoFree.copyWith(
        accessLevel: SubscriptionAccessLevel.trialActive,
        trialDaysRemaining: 5,
        plans: SubscriptionSnapshot.demoFree.plans,
        isConfigured: false,
      );
    }
    if (override == 'trial_expired') {
      return SubscriptionSnapshot.demoFree.copyWith(
        accessLevel: SubscriptionAccessLevel.trialExpired,
        plans: SubscriptionSnapshot.demoFree.plans,
        isConfigured: false,
      );
    }
    if (override == 'expired') {
      return SubscriptionSnapshot.demoFree.copyWith(
        accessLevel: SubscriptionAccessLevel.expired,
        plans: SubscriptionSnapshot.demoFree.plans,
        isConfigured: false,
      );
    }
    if (override == 'premium') {
      return SubscriptionSnapshot.demoFree.copyWith(
        accessLevel: SubscriptionAccessLevel.premium,
        activePlanId: SubscriptionPlanId.annual,
        plans: SubscriptionSnapshot.demoFree.plans,
        isConfigured: false,
      );
    }
    return SubscriptionSnapshot.demoFree.copyWith(
      plans: SubscriptionSnapshot.demoFree.plans,
      isConfigured: false,
    );
  }

  Future<void> _syncRevenueCatUser(String? userId) async {
    if (!RevenueCatService.isInitialized) return;
    try {
      if (userId != null) {
        await RevenueCatService.logIn(userId);
      } else {
        await RevenueCatService.logOut();
      }
      final info = await RevenueCatService.getCustomerInfo();
      state = AsyncData(_parse(info));
    } catch (_) {}
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<PurchaseOutcome> purchasePlan(SubscriptionPlanId planId) async {
    if (!RevenueCatService.isInitialized) {
      return PurchaseOutcome.error;
    }

    final package = RevenueCatService.findPackage(_offering, planId);
    if (package == null) return PurchaseOutcome.error;

    try {
      final info = await RevenueCatService.purchasePackage(package);
      state = AsyncData(_parse(info));
      return PurchaseOutcome.success;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return PurchaseOutcome.cancelled;
      }
      return PurchaseOutcome.error;
    } catch (_) {
      return PurchaseOutcome.error;
    }
  }

  Future<RestoreOutcome> restore() async {
    if (!RevenueCatService.isInitialized) {
      return RestoreOutcome.error;
    }

    try {
      final info = await RevenueCatService.restorePurchases();
      final snapshot = _parse(info);
      state = AsyncData(snapshot);
      if (snapshot.hasPremiumAccess) {
        return RestoreOutcome.success;
      }
      return RestoreOutcome.nothingToRestore;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return RestoreOutcome.cancelled;
      }
      return RestoreOutcome.error;
    } catch (_) {
      return RestoreOutcome.error;
    }
  }
}

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, SubscriptionSnapshot>(
  SubscriptionNotifier.new,
);

final hasPremiumAccessProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider).maybeWhen(
        data: (s) => s.hasPremiumAccess,
        orElse: () => false,
      );
});

final userProgramPhaseProvider = FutureProvider<int>((ref) async {
  try {
    if (SupabaseService.isInitialized) {
      final userId = SupabaseService.auth.currentUser?.id;
      if (userId != null) {
        final row = await SupabaseService.client
            .from('users')
            .select('program_phase')
            .eq('id', userId)
            .maybeSingle();
        return row?['program_phase'] as int? ?? 1;
      }
    }
  } catch (_) {}

  final guest = HiveService.cacheBox.get('guest_profile');
  if (guest is Map && guest['program_phase'] != null) {
    return guest['program_phase'] as int;
  }
  final last = HiveService.cacheBox.get('last_reassessment');
  if (last is Map && last['program_phase'] != null) {
    return last['program_phase'] as int;
  }
  return 1;
});
