Act as a Senior Flutter engineer + product designer on Vireo (branch ux-v2). Build 5 launch features the owner approved. Respect existing architecture (Riverpod, Hive, sync engine, l10n with 10 locales, Pro gates, ads rules). Never write providers inside initState/build. Work autonomously.

1. DAILY SCORE ("سكور اليوم")
   - A 0–100 score on Home (top hero, next to or merged with the steps hero). Weighted:
     | Item | Weight |
     |---|---|
     | steps vs goal | 25 |
     | protein vs target | 20 |
     | calories within ±10% of target | 15 |
     | water vs goal | 15 |
     | workout done | 15 |
     | sleep ≥7 h | 10 |
   - Animated ring with color bands (red < 40, amber 40–69, green ≥ 70).
   - Tap shows the breakdown with "what to do next" tips.
   - Streak: consecutive days with score ≥ 60 (🔥 N days). Store daily scores in Hive and sync them.
   - Unit tests for the scoring function.

2. QUICK LOG + VOICE LOG
   - Center + opens a radial/bottom quick menu: وجبة (photo/gallery/text/voice), مية +250, وزن, تمرين, نوم.
   - Voice logging with speech_to_text (Arabic incl. ar-EG, plus English).
     - The transcript goes to the existing parse-meal-text Edge Function. Results open the normal meal review screen so the user can edit before saving.
     - Request the RECORD_AUDIO permission with an explanation. Add it to the Data safety notes in docs/store/DATA_SAFETY.md (audio processed on-device / not stored).

3. ANDROID HOME-SCREEN WIDGET
   - Use home_widget. Small and medium widgets: steps ring + water progress + daily score; tap opens the app on Home; a "+250 ml" action if feasible.
   - Update on app pause/resume and after each log (and via WorkManager every 30 min if simple).
   - RTL-aware.

4. WORKOUT PLAYER
   - A guided session screen:
     - current exercise card (from the rich exercise guide);
     - rep counter or timed set;
     - rest countdown with a big circular timer;
     - next-exercise preview;
     - pause/skip;
     - keep-screen-on.
   - Audio/voice cues with flutter_tts in the user's locale (ar-EG falls back to ar), e.g. "3… 2… 1… ارتاح 60 ثانية". Respect a mute toggle.
   - On finish: summary (duration, sets, est. kcal, ≈ g fat) → mark the workout done in Today Plan → natural-break point for the interstitial rule.

5. TYPOGRAPHY + VISUAL SYSTEM
   - Arabic locales: IBM Plex Sans Arabic (google_fonts or bundled assets; bundle for offline). Latin locales: Inter.
   - Consistent type scale; tabular numbers for stats.
   - Fix any truncation/overflow in all 10 locales on 360-dp-wide screens.
   - Check contrast (WCAG AA) on dark theme.

Rules:
- flutter gen-l10n.
- flutter analyze must show 0 errors.
- Run affected tests with --timeout 2m.
- flutter build apk --debug.
- git add -A && git commit -m "feat(launch): daily score, quick+voice log, home widget, workout player, typography". Do not push.
- Final message: a short list of changes and anything you could not do.
