Act as a senior Flutter engineer + senior product designer on Vireo (branch ux-v2). The owner tested build feat(pro) on a real phone. Reference screenshots are in docs/refs/:
- leap_step_tracker_home.jpg — the target look for steps;
- vireo_*_now.jpg — the current problems.
Open and look at them first. The bar is MyFitnessPal for food logging and Leap "Step Tracker" for steps. Fix everything below for real, then verify each item in code. No stubs. Never wait more than 3 minutes on a hanging command.

## 1. MEAL ANALYSIS SPEED (currently very slow)
Target: results in under 6 seconds on 4G.
- Client: resize every photo to max 768 px on the long side, JPEG quality 70 (~80–150 KB). Replace MealImageCompressor's 1 MB logic.
- Edge Function analyze-meal:
  - Use the fastest Gemini Flash model. If GEMINI_MODEL is a Pro/thinking model, override it for this function with a FAST_VISION_MODEL env var (fallback `gemini-2.5-flash`).
  - Set `thinkingConfig: { thinkingBudget: 0 }`, `responseMimeType: "application/json"`, a strict compact JSON schema and `maxOutputTokens` ~1200.
  - Log the timing.
  - Redeploy it with `npx supabase functions deploy analyze-meal --use-api`.
- UI while waiting: the photo with an animated scan line plus rotating tips. Show partial results as soon as they arrive. Add a 25 s timeout with a retry button.

## 2. MEAL RESULT = SUMMARY FIRST, DETAILS SECOND (like MyFitnessPal)
Replace the current review screen layout (see vireo_meal_review_now.jpg):
1. TOP SUMMARY CARD (always visible, no scrolling needed):
   - meal name the AI suggests, e.g. "رز + فراخ مشوية + خضار";
   - big total kcal;
   - macro donut with P/C/F grams and %;
   - a health score badge 1–10 with a one-line verdict ("وجبة متوازنة، بروتين عالي");
   - "≈ X جم دهون" equivalent;
   - "المتبقي من يومك" after this meal.
   - Primary button: "حفظ" (one tap) and secondary "عدّل التفاصيل".
2. ITEMS LIST, compact rows: name · grams · kcal; tap a row to expand the editor.
3. ITEM EDITOR (expanded only):
   - Grams stepper and slider.
   - Units that make sense per food. Rice gets كوب/ملعقة/جم, never "حبة". Chicken gets قطعة/صدر/جم. Bread gets رغيف. Use a per-food unit table, not a generic list.
   - Cooking-method chips only for foods where it matters.
4. "إزاي حسبناها" stays collapsed at the bottom.
5. Remove the interrupting popup "طبقك عادة قد إيه؟". If needed, ask it once in settings or onboarding.
6. Default meal type by time of day: before 11:00 فطار, before 16:00 غدا, before 21:00 عشا, else سناك. The user can still change it.
7. Add to the diary like MFP:
   - the Food tab shows each meal section with its items and kcal;
   - the formula row "الهدف − الأكل + التمرين = الباقي";
   - quick add "كرر وجبة امبارح" and favourites.

## 3. STEPS: ONE-TAP START/STOP ON HOME (like Leap) + REAL DAILY TOTAL
1. Home hero must look like leap_step_tracker_home.jpg:
   - huge step number;
   - "/7000 خطوة" goal;
   - a thick progress bar or ring;
   - 3 stats (كم, سعرات, الوقت);
   - a weekly row of 7 day circles (star when the goal is reached) + daily average;
   - a big ▶️/⏸ button on the card: ONE tap starts counting, ONE tap pauses.
2. Starting runs a foreground service with a persistent notification showing live steps (like Leap). Use `flutter_foreground_task` or an equivalent. Counting continues with the screen locked and the app closed. Pausing stops it. State persists and restores after a reboot.
3. Daily total = max(Health Connect today's steps, our own counter). Request Health Connect READ_STEPS at onboarding/first open so Samsung Health / Google Fit steps from before the app opened are included. The number must never show 0 when the phone has steps in Health Connect.
4. Home and the Walk tab must read the SAME provider (now Home shows 0 while Walk shows 17).

## 4. FIX VISIBLE BUGS (see screenshots)
- Walk tab:
  - the ring is broken (a tiny circle with a dot overlapping the text);
  - "RIGHT OVERFLOWED BY 45 PIXELS" in the chart header;
  - the chart is empty.
  Rebuild the Walk tab top like the Leap reference, then the charts with real bars (day hourly / week / month) and achievements.
- Home "اليوم" grid cards are empty (no values, empty circles, clipped workout title):
  - show real values and progress;
  - fix the text overflow;
  - min card height.
- Untranslated strings: "Sleep / How did you sleep" in quick log, "Cloud Sync: Offline-Ready" in profile, "Egyptian clean eating" on the plan screen. Grep the whole lib for remaining English UI text in ar locales and localize it.
- Language picker shows "العربية (فصحى)" although the user picked Egyptian. Make sure the selected locale persists and the label is correct.
- Hide the AdMob native validator popup in debug.

## 5. VERIFY & DELIVER
- Run `flutter gen-l10n` and `flutter analyze` (0 errors, no overflow warnings in tests).
- Run the affected tests with `--timeout 2m`.
- Run `flutter build apk --debug`. It MUST finish; do not kill it.
- Write docs/P27_CHANGES.md with file paths per item.
- `git add -A && git commit -m "feat(ux): MFP-style meal summary, fast analysis, one-tap step counter, bug fixes"`. Do not push.
