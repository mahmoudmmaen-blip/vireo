# P41 — Play Billing Library 8+ (CHANGES)

Branch: `ux-v2`. Commit message:
`fix(billing): upgrade purchases_flutter to Play Billing Library 8+`

## What shipped

Play Console reported Play Billing Library **7.1.1** and required **8.0.0+**.

The task text blamed `google_mobile_ads`. That package does not depend on `com.android.billingclient`. Latest published `google_mobile_ads` is **9.1.0** (no 10.x on pub.dev), and this app was already on 9.1.0. It stays there.

The 7.1.1 copy came from RevenueCat `purchases_flutter` **8.11.0**. Upgraded to **10.16.0**, which selects the Billing Client 8 variant (`missingDimensionStrategy billingclient = bc8`).

`releaseRuntimeClasspath` now resolves:

`com.android.billingclient:billing:8.3.0` ← `com.revenuecat.purchases:purchases:10.27.0` ← `purchases_flutter`

`Purchases.purchasePackage` was removed in favor of `Purchases.purchase(PurchaseParams.package(...))`, which returns `PurchaseResult`. `RevenueCatService.purchasePackage` still returns `CustomerInfo` via `result.customerInfo`, so paywall and account-gate callers are unchanged.

## Owner note

RevenueCat 9+ / Billing Library 8 cannot restore **consumed** one-time products. Lifetime products must be non-consumable in the RevenueCat dashboard. This app's paywall sells monthly and annual subscriptions.

## Tests

- `flutter analyze`: **0 errors** (33 pre-existing infos/warnings; `--no-fatal-infos --no-fatal-warnings` exit 0)
- `flutter test test/features/subscription test/core/services/ad_service_test.dart --timeout 2m`: **38 passed**

## Build

- `flutter build apk --debug`: success (`build/app/outputs/flutter-apk/app-debug.apk`)
- `flutter build appbundle --release`: success (`build/app/outputs/bundle/release/app-release.aab`, 77.6 MB)

## Not done

- `google_mobile_ads` was not set to `^10.0.0` because that version is not published. Doing so would fail `flutter pub get` and would not change the Billing Library.
