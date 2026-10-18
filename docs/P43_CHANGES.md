# P43 — AdMob production IDs + package rename (CHANGES)

Branch: `ux-v2`. Commit message:
`feat(ads): add real AdMob App ID and Ad Unit IDs, fix package name`

## What shipped

### AdMob
- Android manifest `APPLICATION_ID` default is the production App ID (overridable with `-PADMOB_APP_ID=...`).
- `lib/core/constants/admob_constants.dart` holds production banner, interstitial, and rewarded units.
- Debug builds keep Google official test units. Release uses production units for banner / interstitial / rewarded.
- Native unit is still Google test until a production native unit exists; native ads are not requested in release while that is true.
- `AdService.initialize` runs UMP consent then `MobileAds.instance.initialize()` from `MainShell` after the first frame, before any ad load. Ad unit IDs are not logged.

### Package name
Android applicationId / namespace moved from `com.vireofit.app` to `com.vireoapp.fitness` (Play Store conflict with `com.vireo.app`; previous id was already `com.vireofit.app`).
Kotlin sources live under `android/app/src/main/kotlin/com/vireoapp/fitness/`.
Auth deep link scheme and docs updated to `com.vireoapp.fitness://login-callback`.
Version code bumped to `1.0.0+3` in `pubspec.yaml`.

## Owner must do
1. In Supabase Auth URL configuration, add `com.vireoapp.fitness://login-callback` (keep the old scheme until users update).
2. Create a new Play Console app for `com.vireoapp.fitness` (or confirm the listing). An applicationId change is a new store listing if the old id was already published.
3. In AdMob, confirm the Android app package matches `com.vireoapp.fitness`.
4. Optional: create a Native ad unit and pass it via `--dart-define=ADMOB_NATIVE_ID=...`.

## Tests
- `flutter test test/core/release_ads_config_test.dart test/core/services/ad_service_test.dart --timeout 2m`: **16 passed**

## Build
- `flutter analyze`: **0 errors** (33 pre-existing infos)
- `flutter build apk --debug`: success (`build/app/outputs/flutter-apk/app-debug.apk`)
