Act as a Senior Flutter QA + performance engineer working on Vireo (branch ux-v2).

1. Crash and error monitoring: sentry_flutter, DSN via dart-define (disabled when empty), no personal data in events, release + environment tags.
2. Analytics: finish lib/core/services/analytics_service.dart with a clear event list in docs/analytics (app_open, onboarding steps, scan_started/succeeded/failed, meal_saved, coach_message, workout_completed, paywall_viewed, purchase_started/completed, reminder_opened). No health values in analytics.
3. Tests: unit tests for every calculator (calories, macros, water, steps metrics, adaptive calories, diet engine), widget tests for Home, Today Plan, scan review, paywall, onboarding. All must pass.
4. Performance: cold start < 2.5 s on a mid Android phone, compress images before upload (≤ 1 MB), lazy lists, cache Google Fonts, remove unused packages, check web build size.
5. Accessibility + RTL: Semantics labels on all custom buttons, text scale 1.3 without overflow, contrast ≥ 4.5:1, every screen checked in Arabic and English, light and dark.
6. Remove every leftover placeholder or fake number (search for hardcoded demo values) and every developer message shown to users.
flutter analyze → 0 errors, flutter test green. git add -A && git commit -m "chore(quality): monitoring, analytics, tests, performance, a11y". Do not push. Give me a short report of what you fixed.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.
