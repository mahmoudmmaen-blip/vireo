# P57 — Pro paywall discovery: visible entry points, no dark patterns
Status: DONE

## What changed
- `soft_paywall_after_scan.dart`: soft prompt after **3rd** meal log (was 1st scan); one-shot Hive key
- `home_pro_teaser_row.dart` + `home_dashboard_body.dart`: subtle Home → Pro row (hidden for Pro)
- `local_pro_prices.dart`: Egypt list prices **99 / 499 / 1499 EGP** (display only)
- `paywall_screen.dart`: shows local EGP prices + lifetime tier; restore CTA kept; purchase still via Play sheet
- `subscription_state.dart` / `revenue_cat_service.dart` / `app_config.dart`: demo + RC catalog include lifetime (`vireo_pro_lifetime`)
- Call sites: `meal_review_screen.dart`, `ai_analysis_bottom_sheet.dart`

## Entry points (audit)

| Entry | Status |
|---|---|
| After 3rd meal logged (soft) | **Added** |
| Locked Pro feature tap (`requirePro` / rewarded) | Already present |
| Settings → Vireo Pro | Already present |
| Home subtle row | **Added** |
| Restore purchases | On PaywallScreen (AppBar + body) |
| Entitlement | `pro` via `AppConfig.revenueCatEntitlementId` → `hasPremiumAccessProvider` |

## Free vs Pro split

| Capability | Free | Pro |
|---|---|---|
| AI meal scans / day | 3 (5 first week) + rewarded | Fair-use 40/day |
| AI Coach | 0/day (+ rewarded unlock) | 30/day |
| History / trends | 7 days | Full |
| Diet programs | 2 free | All |
| Adaptive calories / weekly report / GPS history / wearables / vitality protocol | Locked | Unlocked |
| Workout phases | Phase 1 | Full |
| Ads | Shown | Hidden |
| Weight / steps / Ramadan / barcode / women’s | Always free | — |

## Pricing note
UI shows **99 EGP/mo · 499 EGP/yr · 1499 lifetime**. Real charge = Google Play bottom sheet via RevenueCat only. Lifetime product must exist in Play/RC (`vireo_pro_lifetime`) for that CTA to complete; otherwise user gets a friendly error — no silent charge.

## Gate results
- analyze: pass on new modules (0 errors)
- test: pass (`paywall_screen_test`, `soft_paywall_third_meal_test`, `screen_paywall_test`)
- build:aab: skipped (not in gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- افتح الهوم (مش Pro): لازم تشوف صف «ڤيريو برو»
- سجّل ٣ وجبات AI: بعد التالتة يفتح paywall soft (يتقفل بـ X)
- على الـ paywall: أسعار ٩٩ / ٤٩٩ / ١٤٩٩ ج.م + زر استعادة
- تأكد في Play Console / RevenueCat إن منتج lifetime موجود لو هتستخدمه

## Follow-ups suggested
- P57b: اربط منتج `vireo_pro_lifetime` في Play + RevenueCat offerings
- P58 voice logging (022)
- P59 InBody scan (023)
