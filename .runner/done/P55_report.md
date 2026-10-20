# P55 — AAB size audit (77.7MB is too heavy for Egyptian prepaid data)
Status: DONE

## What changed
- `lib/core/utils/asset_json.dart`: gzip JSON loader (`loadGzippedJsonAsset` / `loadGzippedJsonMap`)
- `food_db_repository.dart` / `food_facts_repository.dart` / `local_food_swap_library.dart`: load `*.json.gz` instead of plain JSON
- `pubspec.yaml`: ship only `.gz` food/content assets (plain JSON kept on disk for tools/tests, not packaged)
- `android/app/build.gradle.kts`: `ndk.abiFilters` = armeabi-v7a + arm64-v8a; `packaging.jniLibs` excludes x86/x86_64 from dependency AARs
- `lib/main.dart`: fixed duplicate `main()` + invalid AdMob tag enums (blocked earlier builds)

## Size results
| Metric | Before | After |
|---|---|---|
| AAB on disk | **77.7 MB** | **57.0 MB** (−20.7 MB, −27%) |
| Food/content JSON in bundle | ~1.83 MB | ~0.19 MB (gzip) |
| ABIs packaged | arm64 + armeabi-v7a + x86_64 | arm64 + armeabi-v7a only |

**Note:** Play delivers one ABI per device. Estimated arm64 download ≈ base arm64 native (~33 MB uncompressed) + dex + assets — often ~30–40 MB compressed, not the full AAB size. Target &lt;45 MB AAB not fully met without dropping armeabi-v7a or heavy native deps (`libbarhopper_v3` / ML Kit barcode, Sentry).

### Top 10 size offenders (uncompressed inside AAB `base/`)
1. `lib/armeabi-v7a/libapp.so` (~18.2 MB)
2. `lib/arm64-v8a/libapp.so` (~16.2 MB)
3. `lib/arm64-v8a/libflutter.so` (~10.8 MB)
4. `dex/classes3.dex` (~9.2 MB)
5. `lib/armeabi-v7a/libflutter.so` (~7.9 MB)
6. `dex/classes.dex` (~7.1 MB)
7. `lib/arm64-v8a/libbarhopper_v3.so` (~4.7 MB) — mobile_scanner / ML Kit
8. `lib/armeabi-v7a/libbarhopper_v3.so` (~3.1 MB)
9. `lib/*/libsentry.so` (~1–1.2 MB each)
10. ML Kit barcode `.tflite` models (~0.8 MB total)

Flutter assets themselves are small (largest: CupertinoIcons.ttf ~252 KB; gzipped food DBs &lt;75 KB each). No exercise GIFs/Lottie scene packs present.

## Gate results
- analyze: pass (0 errors; 37 infos/warnings pre-existing, incl. AdMob tag deprecations in `main.dart`)
- test: skipped (not in task gates)
- build:aab: `N:\vireo\build\app\outputs\bundle\release\app-release.aab`, **57.0 MB**, versionCode **6** (versionName **1.0.0**)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- ارفع الـ AAB ده على Play Console (Internal) وجرّب التحميل من جهاز arm64 — شوف حجم التحميل الفعلي من Play
- Inbox task `021_P55_aab_size_build_fix` (P55b) اتلغى عمليًا: الـ build نجح

## Follow-ups suggested
- P55c: arm64-only AAB (drop armeabi-v7a) لو عايزين &lt;45 MB على القرص — مع قبول فقدان أجهزة 32-bit
- P55d: بديل أخف لـ `mobile_scanner` / تأجيل barcode models (on-demand) عشان `libbarhopper_v3`
- P56 phantom meal fix (019)
- P57 paywall visibility (020)
