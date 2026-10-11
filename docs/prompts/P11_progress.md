Act as a Senior Flutter Engineer working on Vireo (branch ux-v2). Upgrade Progress. Reuse lib/core/ui.

1. WEIGHT TREND: show raw weigh-ins as dots + a smoothed trend line (exponential moving average, alpha 0.1). Headline = trend change over 7 and 30 days, not the daily number.
2. ADAPTIVE CALORIES: after 14+ days with ≥ 10 days of food logs and ≥ 4 weigh-ins, estimate real maintenance = avg intake − (trend weight change kg × 7700 / days). Each week suggest a new target toward the user's goal, max change ±150 kcal/week, never below 1500 kcal, respecting the active diet program's rules. User must accept the change (card on Home + Progress). Explain the math in one tap.
3. WEEKLY REPORT (every Friday, notification + screen): avg calories/protein vs target, days logged, workouts, steps avg, water avg, sleep avg, trend weight change, best day, one AI tip (ai-coach-chat). Shareable image card (Arabic/English) for WhatsApp/Instagram.
4. BODY: reuse lib/features/measurements (waist, chest, arms, thighs) with charts; progress photos (front/side/back) stored locally only by default, side-by-side compare with a slider; clear note that photos never leave the phone unless the user enables backup.
5. ACHIEVEMENTS: badges for streaks (3/7/30 days), first scan, 10 workouts, 100k steps week, protein goal 7 days.
Tests for the adaptive calorie math (floor, ±150 cap, not enough data → no suggestion).
flutter analyze → 0 errors. git add -A && git commit -m "feat(progress): trend weight, adaptive calories, weekly report, photos, badges". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.
