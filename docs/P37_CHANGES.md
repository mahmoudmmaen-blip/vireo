# P37 — Release ready (Play policy + technical)

## Shipped

### Permissions
- Audited every `health.READ_*` against `HealthDataType` usage in `lib/`; all declared types map to Health Hub, steps, or body composition (documented).
- Removed unused `FOREGROUND_SERVICE_LOCATION` (step FGS is `health|dataSync` only).
- Verified no `ACCESS_BACKGROUND_LOCATION`.
- Camera / mic: `SensitivePermissionGate` shows ar/en rationale and requests only at moment of use (meal camera, InBody, fridge, barcode label, progress photos, voice log).
- Updated `docs/store/HEALTH_CONNECT_DECLARATION.md` + Health Hub rationale copy.

### Legal
- Generated `web_legal/{privacy,terms}-{en,ar}.html` + `delete-account.html` from owner-approved markdown (`tool/gen_legal_html.py`).
- Settings → **About**: Privacy, Terms, Delete account (in-app → `delete-account` edge function + sign-out), web delete steps, Privacy Options (UMP), version.
- `AppConfig.legalBaseUrl` / `LEGAL_BASE_URL` dart-define (TODO default until owner hosts pages).

### Ads & consent
- AdMob unit IDs only via dart-defines (test IDs as debug defaults).
- Release + test IDs → ads disabled (`AppConfig.adsConfiguredForRelease`).
- UMP consent before first ad request; Privacy Options in Settings → About.
- `maxAdContentRating` G unchanged.
- Fixed `isProUserProvider` to include `pro_grants` (plus coin Pro day) so those users never see ads.

### Release hygiene
- `compileSdk` / `targetSdk` = **36**.
- R8 minify + shrinkResources for release + `android/app/proguard-rules.pro` (Hive, RevenueCat, Health, AdMob, Supabase, FGS).
- Release signing falls back to debug when `key.properties` missing (owner adds real keystore).
- Version **1.0.0+2**.
- Dev menus remain behind `kDebugMode`.
- Adaptive icon: monochrome layer added (reuses foreground until a dedicated asset is supplied).
- Splash densities present: mdpi–xxxhdpi. **Missing:** dedicated monochrome drawable (using foreground inset); no night-specific splash assets (theme styles cover light/dark launch).
- `compileSdk` / `targetSdk` reported: **36**.
- Local verify: `flutter build apk --debug` OK; `flutter build apk --release` OK (109 MB, debug signing fallback, R8 + Play Core dontwarn rules).

### Reviewer & QA
- `docs/store/REVIEWER_NOTES.md`
- `integration_test/play_review_flow_test.dart` (needs Android emulator / device; Windows desktop blocked by missing nuget for flutter_tts)
- Widget twin: `test/audit/audit_p37_play_review_flow_test.dart` (runs in CI)
- `test/audit/audit_p37_release_test.dart`, `test/core/release_ads_config_test.dart`
- Store screenshots: `tool/screenshots/store_capture_test.dart` + `compose_store_shots.py` → `build/store_screenshots/{ar,en}/01..08.png` (women’s slot = neutral illustration only).

## Owner checklist (still required)

1. Create upload keystore + `android/key.properties` (never commit secrets).
2. Host `web_legal/` on a static host; set `--dart-define=LEGAL_BASE_URL=https://…/legal`.
3. Replace AdMob dart-defines with real IDs (`ADMOB_APP_ID` gradle property + banner/native/interstitial/rewarded).
4. Set RevenueCat Google API key dart-define.
5. Fill Play Console using `docs/store/PLAY_CONSOLE_FORMS.md` + Health Connect declaration + Data safety.
6. Build signed AAB: `flutter build appbundle --release` with real signing + dart-defines.
7. Optional: replace monochrome launcher asset; refresh store screenshots on a device/emulator after compose.
8. Closed testing (12 testers × 14 days) before production.

## Notes
- GPS run / men’s vitality remain behind feature flags (`gpsRunScreen=false`, `mensVitalityModule=false`).
- Location permissions kept for while-in-use outdoor GPS when the flag is enabled remotely; no background location.
