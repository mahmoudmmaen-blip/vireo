import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/auth/widgets/guest_auth_gate.dart';

/// Blocks guest users from subscribing until they create an account.
Future<CustomerInfo?> purchaseWithAccountGate(
  BuildContext context,
  WidgetRef ref,
  Package package,
) async {
  if (ref.read(isGuestProvider)) {
    final proceeded = await requireAccountAccess(
      context,
      ref,
      reason: AuthGateReason.subscribe,
    );
    if (!proceeded || ref.read(isGuestProvider)) return null;
  }

  try {
    return await RevenueCatService.purchasePackage(package);
  } catch (_) {
    rethrow;
  }
}

/// Blocks guest users from restoring purchases until they create an account.
Future<CustomerInfo?> restoreWithAccountGate(
  BuildContext context,
  WidgetRef ref,
) async {
  if (ref.read(isGuestProvider)) {
    final proceeded = await requireAccountAccess(
      context,
      ref,
      reason: AuthGateReason.subscribe,
    );
    if (!proceeded || ref.read(isGuestProvider)) return null;
  }

  try {
    return await RevenueCatService.restorePurchases();
  } catch (_) {
    rethrow;
  }
}
