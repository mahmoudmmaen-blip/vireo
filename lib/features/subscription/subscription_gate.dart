import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';

/// Purchases package. Works for both anonymous/guest and signed-in users.
/// RevenueCat preserves entitlements when the anonymous user later logs in with their Supabase user ID.
Future<CustomerInfo?> purchaseWithAccountGate(
  BuildContext context,
  WidgetRef ref,
  Package package,
) async {
  try {
    final userId = ref.read(authProvider).valueOrNull?.user?.id;
    if (userId != null && RevenueCatService.isInitialized) {
      await RevenueCatService.logIn(userId);
    }
    return await RevenueCatService.purchasePackage(package);
  } catch (_) {
    rethrow;
  }
}

Future<CustomerInfo?> restoreWithAccountGate(
  BuildContext context,
  WidgetRef ref,
) async {
  try {
    final userId = ref.read(authProvider).valueOrNull?.user?.id;
    if (userId != null && RevenueCatService.isInitialized) {
      await RevenueCatService.logIn(userId);
    }
    return await RevenueCatService.restorePurchases();
  } catch (_) {
    rethrow;
  }
}
