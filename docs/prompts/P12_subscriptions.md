Act as a Senior Flutter + Supabase engineer working on Vireo (branch ux-v2). Finish subscriptions with RevenueCat (purchases_flutter is already a dependency; lib/core/services/revenue_cat_service.dart exists).

1. ONE entitlement "pro". Products: monthly, annual (7-day free trial), configured by IDs in AppConfig (dart-define), never hardcoded prices: always show RevenueCat's localized price (EGP, SAR, AED, USD).
2. FREE vs PRO (single source: lib/features/subscription/feature_gates.dart):
   - Free: 3 meal scans/day, 20 coach messages/day, Today Plan, water, steps, 2 diet programs (balanced + Egyptian clean), weight log, 7-day history.
   - Pro: 50 scans/day, 200 coach messages/day, all 7 diet programs, adaptive calories, weekly report, full history + trends, GPS workout history, wearable health trends, Vitality Pro protocol, no upsell banners.
3. PAYWALL (redesign): hero with the user's own numbers ("Lose ~0.5 kg/week with your plan"), 4 benefit rows, annual pre-selected with "save X%" computed from real prices, trial timeline (today / day 5 reminder / day 7 billing), restore purchases, terms + privacy links, close button visible from the start.
4. TRIGGERS: daily limit reached, tapping a PRO item, end of onboarding (once, skippable), weekly report day 7. Never more than once per day.
5. SERVER TRUTH: RevenueCat webhook → new Edge Function revenuecat-webhook → table subscriptions(user_id, entitlement, expires_at, status) with RLS; _shared/ai-usage.ts reads it for limits. Use RevenueCat app_user_id = Supabase user id; call logIn after sign-in and keep entitlement when an anonymous user upgrades.
6. Day-5 trial reminder notification.
flutter analyze → 0 errors. git add -A && git commit -m "feat(subscription): Pro entitlement, gates, paywall, webhook". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.
