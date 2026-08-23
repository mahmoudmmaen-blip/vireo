import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/utils/platform_utils.dart';
import 'package:vireo/data/models/subscription_state.dart';

/// RevenueCat subscription management.
abstract final class RevenueCatService {
  static bool _initialized = false;
  static StreamController<CustomerInfo>? _customerInfoController;

  static const premiumEntitlementId = 'premium';

  static bool get isInitialized => _initialized;

  static bool get isConfigured => AppConfig.isRevenueCatConfigured;

  static Stream<CustomerInfo> get customerInfoStream {
    _customerInfoController ??= StreamController<CustomerInfo>.broadcast();
    return _customerInfoController!.stream;
  }

  static Future<void> init() async {
    if (_initialized) {
      BootLog.step('RevenueCatService.init skipped (already initialized)');
      return;
    }

    if (!isConfigured) {
      BootLog.step('RevenueCatService.init skipped (not configured)');
      return;
    }

    final apiKey = _platformApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      BootLog.step('RevenueCatService.init skipped (no API key for this platform)');
      return;
    }

    BootLog.step('RevenueCatService.init');
    try {
      BootLog.step('Starting Purchases.setLogLevel...');
      await Purchases.setLogLevel(
        kDebugMode ? LogLevel.debug : LogLevel.info,
      );
      BootLog.ok('Purchases.setLogLevel');

      final configuration = PurchasesConfiguration(apiKey);
      BootLog.step('Starting Purchases.configure...');
      await Purchases.configure(configuration).timeout(
        bootServiceTimeout,
        onTimeout: () => throw TimeoutException('Purchases.configure'),
      );
      BootLog.ok('Purchases.configure');

      Purchases.addCustomerInfoUpdateListener(_emitCustomerInfo);
      _initialized = true;

      BootLog.step('Starting Purchases.getCustomerInfo...');
      final info = await Purchases.getCustomerInfo().timeout(
        bootServiceTimeout,
        onTimeout: () => throw TimeoutException('Purchases.getCustomerInfo'),
      );
      _emitCustomerInfo(info);

      BootLog.ok('RevenueCatService.init');
    } on TimeoutException catch (e) {
      BootLog.warn('RevenueCatService.init timed out — demo subscription mode', e);
      _initialized = false;
    } catch (e) {
      BootLog.warn('RevenueCatService.init failed — demo subscription mode', e);
      _initialized = false;
    }
  }

  static void _emitCustomerInfo(CustomerInfo info) {
    _customerInfoController?.add(info);
  }

  static String? _platformApiKey() {
    if (kIsWeb) return null;
    if (PlatformUtils.isIOS) return AppConfig.revenueCatAppleApiKey;
    if (PlatformUtils.isAndroid) return AppConfig.revenueCatGoogleApiKey;
    return null;
  }

  static Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo().timeout(bootServiceTimeout);
    } catch (_) {
      rethrow;
    }
  }

  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings().timeout(bootServiceTimeout);
    } catch (_) {
      rethrow;
    }
  }

  static Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      return await Purchases.purchasePackage(package);
    } catch (_) {
      rethrow;
    }
  }

  static Future<CustomerInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> logIn(String appUserId) async {
    if (!_initialized) return;
    try {
      await Purchases.logIn(appUserId).timeout(bootServiceTimeout);
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> logOut() async {
    if (!_initialized) return;
    try {
      await Purchases.logOut().timeout(bootServiceTimeout);
    } catch (_) {
      rethrow;
    }
  }

  static Future<bool> hasActiveEntitlement(String entitlementId) async {
    try {
      final info = await getCustomerInfo();
      return info.entitlements.active.containsKey(entitlementId);
    } catch (_) {
      return false;
    }
  }

  static SubscriptionSnapshot parseCustomerInfo(
    CustomerInfo info, {
    List<SubscriptionPlan> plans = const [],
    bool isConfigured = true,
  }) {
    final active = info.entitlements.active[premiumEntitlementId];
    if (active != null) {
      if (active.periodType == PeriodType.trial) {
        return SubscriptionSnapshot(
          accessLevel: SubscriptionAccessLevel.trialActive,
          trialDaysRemaining: _daysUntil(active.expirationDate),
          activePlanId: _planFromProductId(active.productIdentifier),
          plans: plans,
          isConfigured: isConfigured,
        );
      }

      return SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.premium,
        activePlanId: _planFromProductId(active.productIdentifier),
        plans: plans,
        isConfigured: isConfigured,
      );
    }

    final historical = info.entitlements.all[premiumEntitlementId];
    if (historical != null && !historical.isActive) {
      if (historical.periodType == PeriodType.trial) {
        return SubscriptionSnapshot(
          accessLevel: SubscriptionAccessLevel.trialExpired,
          plans: plans,
          isConfigured: isConfigured,
        );
      }
      return SubscriptionSnapshot(
        accessLevel: SubscriptionAccessLevel.expired,
        plans: plans,
        isConfigured: isConfigured,
      );
    }

    return SubscriptionSnapshot(
      accessLevel: SubscriptionAccessLevel.free,
      plans: plans,
      isConfigured: isConfigured,
    );
  }

  static List<SubscriptionPlan> plansFromOffering(Offering? offering) {
    if (offering == null) return SubscriptionSnapshot.demoFree.plans;

    SubscriptionPlan? monthly;
    SubscriptionPlan? annual;
    SubscriptionPlan? lifetime;

    for (final package in offering.availablePackages) {
      final plan = SubscriptionPlan(
        id: _planIdFromPackage(package),
        title: package.storeProduct.title,
        priceString: package.storeProduct.priceString,
        packageIdentifier: package.identifier,
        isBestValue: package.packageType == PackageType.annual,
      );

      switch (package.packageType) {
        case PackageType.monthly:
          monthly = plan;
        case PackageType.annual:
          annual = plan.copyWith(isBestValue: true);
        case PackageType.lifetime:
          lifetime = plan;
        default:
          break;
      }
    }

    return [
      if (monthly != null) monthly,
      if (annual != null) annual,
      if (lifetime != null) lifetime,
    ];
  }

  static Package? findPackage(Offering? offering, SubscriptionPlanId planId) {
    if (offering == null) return null;
    for (final package in offering.availablePackages) {
      if (_planIdFromPackage(package) == planId) return package;
    }
    return null;
  }

  static SubscriptionPlanId _planIdFromPackage(Package package) {
    switch (package.packageType) {
      case PackageType.annual:
        return SubscriptionPlanId.annual;
      case PackageType.lifetime:
        return SubscriptionPlanId.lifetime;
      default:
        return SubscriptionPlanId.monthly;
    }
  }

  static SubscriptionPlanId? _planFromProductId(String productId) {
    final lower = productId.toLowerCase();
    if (lower.contains('lifetime')) return SubscriptionPlanId.lifetime;
    if (lower.contains('annual') || lower.contains('year')) {
      return SubscriptionPlanId.annual;
    }
    if (lower.contains('month')) return SubscriptionPlanId.monthly;
    return null;
  }

  static int? _daysUntil(String? isoDate) {
    if (isoDate == null) return null;
    try {
      final expiry = DateTime.parse(isoDate).toLocal();
      final diff = expiry.difference(DateTime.now()).inDays;
      return diff < 0 ? 0 : diff + 1;
    } catch (_) {
      return null;
    }
  }
}

extension on SubscriptionPlan {
  SubscriptionPlan copyWith({
    SubscriptionPlanId? id,
    String? title,
    String? priceString,
    String? packageIdentifier,
    bool? isBestValue,
    String? trialLabel,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      priceString: priceString ?? this.priceString,
      packageIdentifier: packageIdentifier ?? this.packageIdentifier,
      isBestValue: isBestValue ?? this.isBestValue,
      trialLabel: trialLabel ?? this.trialLabel,
    );
  }
}
