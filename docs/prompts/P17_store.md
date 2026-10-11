Act as a mobile release + compliance engineer working on Vireo (branch ux-v2). Prepare everything Google Play needs.

1. Legal pages as static HTML in web/legal/ (Arabic + English): privacy policy (what data, why, where stored: Supabase region, Gemini processing of meal photos and chat, RevenueCat, Sentry; retention; deletion; contact email), terms of use, medical disclaimer. Link them in Settings, paywall and onboarding.
2. docs/store/DATA_SAFETY.md: the exact answers for the Play Data Safety form based on the real code (location only during workouts, health data from Health Connect, photos, account info, purchase history, crash logs).
3. docs/store/HEALTH_CONNECT_DECLARATION.md: each Health Connect permission used + the user-facing reason, as Play requires.
4. Android manifest review: only permissions we really use; no ACCESS_BACKGROUND_LOCATION; ACTIVITY_RECOGNITION explained; foreground service type "location" only for workouts.
5. docs/store/LISTING_AR.md and LISTING_EN.md: app name (≤ 30 chars), short description (≤ 80), full description (≤ 4000), wellness wording only (energy, vitality, fitness), no sexual or medical-cure claims; list of 8 screenshots to capture with captions.
6. In-app account deletion reachable in ≤ 3 taps, plus a public web page explaining how to delete the account (Play requirement).
Commit "chore(store): legal pages, data safety, listing". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.
