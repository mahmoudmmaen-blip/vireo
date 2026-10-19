engine: agent
You are a senior engineer on the Vireo repo (branch ux-v2). Read AGENTS.md and docs/PRODUCT_DECISIONS.md first and follow them strictly. Only start if 'git log --oneline -10' shows the commit 'feat(ux): full UI/UX audit, design-system page, top-30 fixes'; if it is missing, write .runner/done/007_P37_release_ready_BLOCKED.txt explaining why and stop without changing code. Do queue item 8 in docs/prompts/QUEUE_ORDER.md (read its NOTE line): the full spec below (also docs/prompts/P37_release_ready.md). Never push/reset/clean/checkout/delete. Finish with the 5-line report.

Act as a senior Flutter release engineer on Vireo (branch ux-v2). Start after P36 is committed. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push. NEVER create, read or print keystores, passwords, API keys or key.properties contents; the owner does those.

Goal: make the build Google-Play-ready (policy + technical), so the owner only has to paste secrets, build the signed AAB, and fill the Console using docs/store/PLAY_CONSOLE_FORMS.md.

## 1. PERMISSIONS AUDIT (Play rejects unused sensitive permissions)
- For every `android.permission.health.READ_*` in AndroidManifest.xml (STEPS, HEART_RATE, RESTING_HEART_RATE, HEART_RATE_VARIABILITY, OXYGEN_SATURATION, SLEEP, WEIGHT, BODY_FAT, LEAN_BODY_MASS, EXERCISE), grep lib/ for real reads (the `health` package HealthDataType usage):
  - Keep a permission ONLY if a user-visible feature reads it.
  - Remove the rest from the manifest AND from the requested types list in code.
- Write docs/store/HEALTH_CONNECT_DECLARATION.md (update it): a table with permission → exact feature/screen → why it's needed. Also update the Health Connect privacy-rationale activity text to match.
- Justify or remove FOREGROUND_SERVICE_LOCATION / _HEALTH / _DATA_SYNC. Each kept service type needs a one-line justification in that doc for the Play "foreground service" declaration.
- RECORD_AUDIO and CAMERA: request at the moment of use only (not at startup), with rationale text in ar_EG/en.
- No background location anywhere (verify).

## 2. PRIVACY / LEGAL IN-APP
- New docs/legal/privacy_policy_{en,ar}.md and terms_of_service_{en,ar}.md are already in the repo (owner-approved v2).
- Generate static pages from them in web_legal/: privacy-en.html, privacy-ar.html (RTL), terms-en.html, terms-ar.html, delete-account.html (steps + email). Make them simple, mobile-friendly, self-contained HTML (no external JS), so the owner can host them on any static host.
- In Settings → About, add links to Privacy Policy, Terms, and "Delete my account" (in-app flow already exists; verify it deletes everything via the delete-account edge function and signs out).
- Put the base URL in AppConfig as `LEGAL_BASE_URL` dart-define with a TODO default, so the owner sets it after hosting.

## 3. ADS & CONSENT
- AdMob unit IDs must come only from dart-defines (no real IDs hard-coded). In release mode, if the IDs are test IDs, disable ads instead of showing test ads.
- UMP consent: show it before the first ad request (EEA/UK), with a "Privacy options" entry in Settings.
- Keep maxAdContentRating G plus the existing filters. Verify that no ads show for Pro, pro_grants or coin-unlocked Pro days.

## 4. RELEASE BUILD HYGIENE
- Set targetSdk/compileSdk to the current Play requirement (36 if the toolchain supports it, else 35). Report the value used.
- Enable R8/minify + shrinkResources for release, with keep rules for Hive adapters, RevenueCat, Health, AdMob and Supabase. Build a release APK locally with debug signing fallback to verify nothing crashes on startup (run the smoke test on the emulator if available).
- Remove or guard debug prints, the dev menus, and the test pro toggles behind kDebugMode.
- Set version to 1.0.0+2 in pubspec.yaml.
- Verify the app icon (adaptive + monochrome) and the splash in both themes. List any missing densities.
- Verify that the 10 locales have no missing keys, and that the ar_EG strings contain no Latin words except brand names (reuse the P36 test).

## 5. REVIEWER & QA
- Add docs/store/REVIEWER_NOTES.md (English) with:
  - how to reach every gated feature;
  - "any food photo works";
  - where InBody scan is;
  - a note that cycle data is local-only.
- Add an integration test flow (integration_test/play_review_flow_test.dart) that covers:
  - onboarding → home → meal log (manual) → fasting start/stop → body card → settings → privacy links.

## 6. STORE SCREENSHOTS
- Create tool/screenshots/ with an integration test that seeds realistic demo data (no real personal data) and captures the 8 screens listed in docs/store/LISTING_AR.md / LISTING_EN.md:
  - in ar_EG and en;
  - Calm Gold dark and Ember dark;
  - 1080×1920.
- Then compose them with the caption text on top, using a simple Dart or Python image script. Output to build/store_screenshots/{ar,en}/01..08.png.
- Women's-module screenshot must use neutral illustrations only (no photos of people).

## 7. VERIFY & DELIVER
- Run `flutter gen-l10n` and `flutter analyze` (0 errors).
- Run all tests, plus the new ones, each with `--timeout 2m`, using pump(Duration).
- Run `flutter build apk --release` with debug signing fallback and `flutter build apk --debug`. Poll until done.
- Write docs/P37_CHANGES.md, including a checklist of what the OWNER still must do (keystore, key.properties, real AdMob IDs, RevenueCat key, hosting legal pages, Console forms).
- `git add -A && git commit -m "chore(release): permissions audit, legal pages, consent, release hygiene, store screenshots"`. Do not push.
