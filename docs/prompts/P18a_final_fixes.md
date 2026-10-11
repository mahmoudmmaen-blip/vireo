Act as a Senior Flutter + Supabase engineer working on Vireo (branch ux-v2). A code review of the last phases found real gaps. Fix ALL of them. Read the files mentioned first.

1. CRITICAL — Android INTERNET permission: android/app/src/main/AndroidManifest.xml has no <uses-permission android:name="android.permission.INTERNET"/>. Release builds would have no network (Supabase, Gemini, RevenueCat all fail). Add it. Also add the Health Connect permissions the InBody sync reads (READ_BODY_FAT, READ_LEAN_BODY_MASS, plus READ_WEIGHT already present) and list them in docs/store/HEALTH_CONNECT_DECLARATION.md.

2. SYNC IS NOT WIRED: lib/core/services/sync_engine.dart is never referenced anywhere, and pullChanges only handles water_logs. Make it real:
   - Provide it via Riverpod (syncEngineProvider). Call pullChanges on app start (after auth) and on app resume; push on connectivity regain.
   - Route the writes of every store listed in docs/DATA_MAP.md through enqueueChange (meals/AI meal logs, water, weight, measurements, body_composition, GPS workouts, daily steps history, diet program, Today Plan completions, vitality logs, settings).
   - pullChanges must handle every table in DATA_MAP.md with last-write-wins by updated_at and soft deletes (deleted_at).
   - Show sync status (last synced time / pending count) in Profile → Privacy.
   - Extend test/core/sync_engine_test.dart for queue persistence, LWW conflict, soft delete.

3. CRASH MONITORING IS A STUB: add sentry_flutter to pubspec, initialize it in main() only when SENTRY_DSN is non-empty (runZonedGuarded / SentryFlutter.init with beforeSend stripping user data), and make CrashMonitoringService actually call Sentry.captureException / addBreadcrumb.

4. LEGAL PAGES INCOMPLETE: add web/legal/terms_ar.html, web/legal/medical_disclaimer_en.html and medical_disclaimer_ar.html (wellness app, not medical advice, consult a doctor before diets/fasting, especially with the 12 health conditions in DietSafetyCopy). Link all legal pages from Settings, paywall and onboarding.

5. TESTS: add widget tests (with --timeout 2m, no infinite pumpAndSettle — use pump(Duration)) for Home today card, Today Plan, meal review screen, paywall, onboarding first screen. Un-skip test/core/language_picker_test.dart by replacing pumpAndSettle with bounded pumps; if it still hangs, keep it skipped with the reason.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete unrelated files. If a test hangs, skip it with a TODO and move on.
flutter analyze → 0 errors; run only new/affected tests with --timeout 2m.
git add -A && git commit -m "fix(release): internet permission, real sync wiring, sentry, legal pages, widget tests". Do not push.
Then update docs/prompts/AUTOPILOT.md (add a row "P18a_final_fixes.md | fix(release) | done <time>").
