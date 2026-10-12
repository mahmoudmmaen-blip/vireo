# Vireo — final review (autopilot run, 11–12 Oct 2026)

Branch: ux-v2 (nothing pushed). All code phases are committed; last commit `fix(release)` (df8a119, 23:59).

## Built in this run (commit order)
1. feat(l10n): 10 languages (en, ar, ar_EG, ar_SA, fr, es, tr, ur, hi, id) + language picker
2. feat(reminders): smart local notifications (quiet hours, daily cap, deep links, dialect copy)
3. feat(progress): trend weight (EMA), adaptive calories (±150/wk, ≥1500 floor), weekly report, photos, badges
4. feat(onboarding): 60-second, 9-step value-first onboarding with resume + analytics
5. feat(energy): fat-equivalent grams (7.7 kcal ≈ 1 g) for workouts, steps, diet deficit, weekly report
6. feat(subscription): Pro entitlement, feature gates, paywall, RevenueCat webhook + subscriptions table
7. feat(social): friends, weekly step challenges, family group, share cards (steps/streak only)
8. feat(sync): offline-first sync, export, full account delete
9. chore(quality): monitoring hooks, analytics plan, tests, a11y/perf pass
10. chore(store): privacy/terms pages, Data Safety, Health Connect declaration, AR/EN listing, account-deletion page
11. fix(release) — review fixes: INTERNET permission (was missing → release build had no network), Health Connect body-fat/lean-mass permissions, sync engine actually wired (pull on start/resume, push on reconnect), real Sentry init (only when SENTRY_DSN set), terms_ar + medical disclaimers (AR/EN) linked in Settings/paywall/onboarding, widget tests for Home, Today Plan, meal review, paywall, onboarding.

## Known limitations
- Some interactive tests in test/core/language_picker_test.dart are skipped (async cycle hangs under pumpAndSettle) — the render test passes.
- Nothing was run on a real phone yet. Sync, notifications, Health Connect and GPS need on-device testing.
- Code was written by Gemini 3.8 Flash and reviewed by spot checks, not line by line.

## Owner to-do before launch (only you can do these)
1. Test on your Android phone (USB): flutter run → walk through onboarding, scan, water, GPS walk, reminders, language switch.
2. Supabase: `npx supabase db push` (new migrations: catalog seed, subscriptions, social, offline_sync) and deploy functions:
   analyze-body-report, revenuecat-webhook, delete-account, generate-program, generate-meal-plan, suggest-recipes, scan-fridge-vision (`npx supabase functions deploy <name> --use-api`).
3. Google Play Console: personal account ($25) + identity verification.
4. RevenueCat: create the app, "pro" entitlement, monthly + annual (7-day trial) products in Play Console; put keys in dart-defines; set webhook URL + secret.
5. Optional: Sentry project → SENTRY_DSN.
6. Release (Phase 18, needs you): confirm applicationId, create the upload keystore, build the App Bundle, internal → closed testing.
7. 12 testers with Android + Gmail for 14 consecutive days.
8. Host web/legal pages (Vercel) and put the URLs in the Play listing.
