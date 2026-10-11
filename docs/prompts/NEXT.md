Act as a Senior Flutter Engineer working on Vireo (branch ux-v2). Read lib/ first. Reuse lib/core/ui and the existing l10n (ARB files in lib/core/l10n, then run flutter gen-l10n).

Finish the missing Sprint A items:

1. APPEARANCE: Profile → new "Appearance / المظهر" screen: theme mode (System / Light / Dark) using the existing theme_mode_provider, plus 4 accent color themes (Ember default, Ocean, Forest, Royal) persisted in Hive and applied app-wide via AppTheme. Make Profile easy to find: tapping the Home avatar opens it, and add a clear "Profile" entry in the Home header.

2. AUTO-DETECT WALK / RUN / CYCLE in the outdoor live workout: use GPS speed + step cadence (pedometer). Cadence < 130 spm = walk, >= 140 spm = run, speed > 15 km/h with low cadence = cycle. Smooth over 20 s, switch type automatically, show a small chip "Detected: Running", allow manual override. Recalculate MET/calories when the type changes.

3. MEAL SCAN FOLLOW-UP: after analyze-meal, if any item is in items_unsure or confidence < 0.6, show 1-3 quick questions on the review screen (e.g. "Is this rice or bulgur?", "Fried or grilled?") as tappable chips that update the item.

4. CELEBRATIONS: subtle confetti + haptic + short message when the user hits the daily water goal, protein goal, step goal, or finishes a workout (once per day per goal).

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary.
flutter analyze → 0 errors; flutter test green.
git add -A && git commit -m "polish: sprint A part 2 (appearance, auto-detect, scan follow-ups, celebrations)"
Do not push.
