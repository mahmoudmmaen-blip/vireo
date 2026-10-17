import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

const _softPaywallAfterFirstScanKey = 'soft_paywall_after_first_scan_shown';

/// Dismissible paywall (X on [PaywallScreen]) after the first successful meal scan.
Future<void> maybeShowSoftPaywallAfterFirstScan(
  BuildContext context,
  WidgetRef ref, {
  required int scanCountAfterSave,
}) async {
  if (scanCountAfterSave != 1) return;
  if (!HiveService.isInitialized) return;
  if (HiveService.settingsBox.get(_softPaywallAfterFirstScanKey) == true) return;

  final isPro = ref.read(subscriptionProvider).valueOrNull?.hasPremiumAccess == true;
  if (isPro) return;

  await HiveService.settingsBox.put(_softPaywallAfterFirstScanKey, true);
  if (!context.mounted) return;

  await openPaywall(context, paywallContext: PaywallContext.standard);
}
