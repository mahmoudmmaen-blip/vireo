import 'package:vireo/data/models/subscription_state.dart';

/// Egypt-facing display prices (P57). Charging still happens only via the
/// Google Play purchase sheet through RevenueCat — these strings are UI only.
abstract final class LocalProPrices {
  static const monthlyEgp = 99;
  static const annualEgp = 499;
  static const lifetimeEgp = 1499;

  static String displayFor(SubscriptionPlanId id, {required bool isAr}) {
    return switch (id) {
      SubscriptionPlanId.monthly =>
        isAr ? '$monthlyEgp ج.م / شهر' : '$monthlyEgp EGP / mo',
      SubscriptionPlanId.annual =>
        isAr ? '$annualEgp ج.م / سنة' : '$annualEgp EGP / yr',
      SubscriptionPlanId.lifetime =>
        isAr ? '$lifetimeEgp ج.م · مرة واحدة' : '$lifetimeEgp EGP · once',
    };
  }

  /// Demo / offline catalog used when RevenueCat offerings are missing.
  static List<SubscriptionPlan> demoPlans({required bool isAr}) => [
        SubscriptionPlan(
          id: SubscriptionPlanId.annual,
          title: isAr ? 'سنوي' : 'Annual',
          priceString: displayFor(SubscriptionPlanId.annual, isAr: isAr),
          packageIdentifier: 'annual',
          rawPrice: annualEgp.toDouble(),
          currencyCode: 'EGP',
          isBestValue: true,
          trialLabel: isAr ? 'تجربة ٧ أيام' : '7-day free trial',
          trialPeriodDays: 7,
        ),
        SubscriptionPlan(
          id: SubscriptionPlanId.monthly,
          title: isAr ? 'شهري' : 'Monthly',
          priceString: displayFor(SubscriptionPlanId.monthly, isAr: isAr),
          packageIdentifier: 'monthly',
          rawPrice: monthlyEgp.toDouble(),
          currencyCode: 'EGP',
        ),
        SubscriptionPlan(
          id: SubscriptionPlanId.lifetime,
          title: isAr ? 'مدى الحياة' : 'Lifetime',
          priceString: displayFor(SubscriptionPlanId.lifetime, isAr: isAr),
          packageIdentifier: 'lifetime',
          rawPrice: lifetimeEgp.toDouble(),
          currencyCode: 'EGP',
        ),
      ];
}
