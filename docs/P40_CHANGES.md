# P40 — Launch growth pack (CHANGES)

Branch: `ux-v2`. Commit message:
`feat(growth): repeat meals, text/voice log, prayer-time fasting, widget, share card, scan limits, paywall, content`

## What shipped

### 1. Faster logging
- **زي امبارح** one-tap yesterday-slot copy (`repeat_meal_service.dart`) on Home meal card + quick relog.
- **وجباتي** favorites + **آخر حاجات أكلتها** recents (`saved_meals_sheets.dart`, favorites provider).
- Text/voice log via existing `parse-meal-text` → DB resolution (no free kcal guessing); mic permission on tap; ar-EG / ar-SA.
- Meal review hero calibration: portion ½/1/1½/2, oil خفيف/عادي/مسبّك, ≈ kcal + تقديري, family plate ربع/تلت/نص.

### 2. Ramadan & fasting
- Offline prayer times via `adhan` + expanded city presets (Cairo → Muscat + custom lat/lng). No location permission.
- Methods: Egypt = Egyptian General Authority; KSA/Gulf = Umm al-Qura / Dubai.
- Ramadan water UX: cups from iftar → suhoor.
- Never paywalled: Ramadan mode, barcode, women's module (`FeatureGates.neverPaywall*`).

### 3. Home widget (Android)
- `home_widget` 2×2: calories left, mascot emoji, fasting countdown; tap → camera deep link.
- Update on meal save (`force`) and ≤ every 30 min. Dark/light + RTL layouts.

### 4. Shareable weekly card
- 1080×1920 burn-balance story (`weekly_burn_share_screen.dart`); goal-gated eligibility; local PNG via RepaintBoundary + `share_plus`. No weight unless opted in.

### 5. Monetization (code only)
- Free AI photo scans: **3/day**, **5/day** first 7 days; Pro fair-use **40/day**; coach **30/day** Pro-only.
- Server enforcement in `analyze-meal` + `_shared/ai-usage.ts`. Text/voice/barcode unlimited (`parse-meal-text` does not consume meal_scan).
- Soft paywall after first successful scan; hard gate at daily limit.
- Paywall: yearly hero + tea/day math from RevenueCat prices; lifetime filtered out of UI.
- Settings → اشتراكي + Play subscriptions deep link.
- Image cost guard: client compress max **720 px WebP**; image-hash cache retained.

### 6. Content
- `tool/content/facts_gen.dart` → `assets/content/food_facts.json` (≥60; build produced 1000+ from DB + ACSM walking math).
- `tool/content/swaps_gen.dart` → `assets/content/local_food_swaps.json` (≥100; build produced 1000+).
- Daily "حقائق أكلك" Home card; Ramadan guide (suhoor ranking, iftar pacing, rebound).
- Seasonal packs: Ramadan lantern (free in Ramadan), Eid, **winter**.

### 7. Notifications
- Max 2/day, quiet hours 11 PM–7 AM (suhoor exception in Ramadan).
- Post-first-scan permission prompt; D0–7 nurture plan.
- Merciful streaks with يوم راحة token.

### 8. Focus flags
- `FeatureFlags.gpsRunScreen` / `mensVitalityModule` default **OFF**. InBody + women's module stay visible.

### 9. Performance
- Scene packs are vector-painted (no large PNGs under assets); food/content JSON is the bulk of assets.
- Release universal AAB: **75.3 MB** (see Build); per-device Play splits need owner confirmation vs ≤35 MB target.

## Tests
- Unit (all passed, `--timeout 2m`):
  - `test/core/feature_flags_test.dart`
  - `test/core/merciful_streak_test.dart`
  - `test/features/ai_nutrition/family_plate_share_test.dart`
  - `test/features/nutrition/repeat_meal_service_test.dart`
  - `test/features/subscription/scan_limits_test.dart`
  - `test/features/notifications/nurture_plan_test.dart`
  - `test/features/content/food_facts_test.dart`
  - `test/features/content/local_food_swap_library_test.dart`
  - `test/features/ramadan/ramadan_schedule_test.dart` (Cairo + Riyadh)
  - `test/features/ramadan/ramadan_prayer_city_test.dart`
  - `test/features/notifications/reminder_scheduler_test.dart`
- Audit 360×640 ar_EG textScale 1.3 (all passed):
  - `test/audit/audit_p40_repeat_meals_test.dart`
  - `test/audit/audit_p40_growth_test.dart` (paywall, widget preview, share card)
- `flutter analyze`: **0 errors** (infos/deprecations remain; 1 unused-import warning fixed)

## Build
- `flutter build apk --debug`: **OK** → `build/app/outputs/flutter-apk/app-debug.apk` (~233 MB debug; not a size target).
- `flutter build appbundle --release`: **OK** → `build/app/outputs/bundle/release/app-release.aab` (**75.3 MB** universal, debug-signing fallback).
- Content generators: `facts_gen` wrote **1372** facts; `swaps_gen` wrote **1243** swaps (both ≥ P40 floors).
- AAB per-device split ≤ 35 MB: universal AAB is 75.3 MB (all ABIs). **Owner must confirm** delivered split sizes in Play App Bundle Explorer after upload (Play serves one ABI + density). If splits stay >35 MB, trim fonts/unused assets in P37.

## Edge deploy
- `analyze-meal` redeployed (`--use-api`) → ACTIVE **v22**.
- `parse-meal-text` redeployed (text path stays unlimited / no meal_scan consume).
- CLI has no `functions logs` subcommand on this version — **owner: open**  
  https://supabase.com/dashboard/project/jzizpqriifrcgiksnddq/functions  
  and confirm one real `analyze-meal` request after a scan.

## OWNER must set (before launch)

### RevenueCat / Play Console prices (from `docs/PRODUCT_DECISIONS.md`)
| Market | Monthly | Yearly (hero, 7-day trial) |
|---|---|---|
| Egypt | 79 EGP | 499 EGP |
| KSA | 29.99 SAR | 119.99 SAR |
| UAE | 29.99 AED | 119.99 AED |
| KW/QA/BH/OM | Play auto-convert from SAR tier | |

- **No lifetime product** — remove/disable any lifetime SKU if it still exists in RC/Play.
- Ramadan offer (later): yearly 50% off for 2 weeks before Ramadan until Eid.
- Wire Play subscriptions manage URL already used in Settings.

### Also owner-side
- Keystore / `key.properties`, AdMob IDs, RevenueCat API key.
- Legal pages hosted; closed testing 12×14 days targeting Ramadan 2027.
- Confirm one real `analyze-meal` request in the Supabase Functions dashboard after a device scan.
