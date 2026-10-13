Act as a senior Flutter engineer + product designer on Vireo (branch ux-v2). The owner tested build feat(home) on his phone. New screenshots are docs/refs/p32_home_score.png, p32_insights_mid.png and p32_insights_bottom.png. Open them first. Fix everything for real and verify it in code. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files.

## 1. BUG (top priority): gallery → camera → "تحليل" does nothing
Repro: Home "صوّر وجبتك" → الاستوديو → pick photo(s) → the app opens the CAMERA screen with the photos in the strip → tap "تحليل (n)" → nothing happens.

What I found in code: `CalAiCameraScreen._analyze()` calls `scanMealMulti`, then only handles `scan.isSuccess`. On any failure (network, Edge Function error, timeout, JSON parse error after the P31 confidence change) it silently does nothing.

Fix all of these:
- **Find the real failure.** Check `npx supabase functions logs analyze-meal` (or add client logging). Make sure the P31 prompt/schema change (confidence field) parses on both server and client. Test a real call with a sample image via a small Dart or Deno script if needed.
- **Never fail silently.** Show the error state with an Egyptian Arabic message and a "حاول تاني" button. Map error types: no internet / timeout / server / couldn't recognize food.
- **Gallery must not open the camera.** After picking from the gallery, go straight to analysis: show the loading overlay with the picked photos, then the meal review. If the user wants to add more photos, offer "+ صورة" on the review/preview screen (gallery or camera), not the other way round. Apply this to every gallery entry: the Home capture card, the source sheet, the Food tab and the + button.
- Add a widget test: gallery entry with fake picked bytes and a fake vision service → reaches the review screen. Add a second test: the vision service throws → the error UI is visible.

## 2. HOME SCORE RING: numbers don't fit (see p32_home_score.png)
The 3 and "/100" are clipped and overlapping, and the red dot overlaps the number.
- Give the ring 112–120 dp. Put the number in a FittedBox, with "/100" on its own smaller line inside the ring. Place the progress-end dot on the arc, not over the text.
- Use tabular figures. Test it at textScale 1.3 with values 3, 75 and 100.

## 3. SCORE & INSIGHTS SCREEN: simple summary first, details after
New order, top to bottom:
1. **Summary card** (always visible, no scrolling): the score ring plus 3 one-line facts, e.g.:
   - "النهارده: أكلت 320 من 2157 سعرة"
   - "الأسبوع ده: خسرت ≈ 820 جم دهون"
   - "هتوصل لهدفك في ≈ 6 أسابيع"
   Plus one main action button, the most impactful next step (e.g. "سجّل وجبة بروتين").
2. **Smart predictions** (moved UP, directly under the summary).
3. Score breakdown bars.
4. Charts (score trend, energy balance, macros). Fix the energy chart so it has day labels on the x-axis and kcal values. Its bars currently have no labels.
5. Tips and actions.
6. "إزاي حسبناها" stays collapsed at the bottom.
- **Fix the warnings logic.** The screenshot shows both "عجز السعرات أعلى من 1,000" and the 1% clamp because today the user logged only 320 kcal (the day is not over). Compute the deficit from COMPLETED days only (exclude today). Hide the aggressive-deficit warning unless at least 3 completed days average more than 1000 kcal deficit. Days with fewer than 800 kcal logged count as "incomplete logging" and are excluded, not counted as a huge deficit.
- Localize the remaining MSA/hardcoded strings on this screen and in the step toggle error SnackBar into all 10 ARB files (Egyptian in ar_EG).

## 4. BODY COMPOSITION ("تحليل الجسم" like InBody), honest version
Add a "تحليل الجسم" section in أنا → التقدم and a card in Score & Insights. There are three sources; always show which one each value came from:
1. **Tape-measure estimate (US Navy method).** Inputs:
   - men: waist + neck + height;
   - women: + hips.

   Outputs: body fat %, fat mass kg, lean mass kg, BMI, BMR (Katch-McArdle when BF% is known), and a category (athletic / fit / average / high) by sex and age. Include a guided measuring screen with a simple illustration of where to measure. Label results "تقدير ±3–4%".
2. **InBody / scale printout scan.** The user photographs their InBody (or any body-composition) report. Send it through the existing analyze path, with a new `mode: "body_report"` in the Edge Function, using the same server key (never a key in the app). Extract weight, body fat %, skeletal muscle mass, visceral fat level, body water, BMR and segmental lean mass if present. Show an editable confirmation screen, then save it with the date.
3. **Health Connect.** Read BodyFat and LeanBodyMass from smart scales if they are available.

- History chart: body fat % and lean mass over time. Weekly reminder to measure (optional).
- Feed BF% and lean mass into the energy projection (BMR via Katch-McArdle when available) and into protein targets (g per kg of lean mass).
- No photo-of-body AI estimation (too inaccurate). If you are tempted to add it, don't.
- Unit tests: Navy formula for men and women against known reference values; Katch-McArdle; report JSON parsing.

## 5. VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors).
- Run the new tests plus test/audit (add Score & Insights and Body Comp at 360×640 ar_EG with textScale 1.3), each with `--timeout 2m`. Use `pump(Duration)`, never `pumpAndSettle`, on animated screens.
- Redeploy analyze-meal with `npx supabase functions deploy analyze-meal --use-api` and confirm one successful real request in the logs.
- Run `flutter build apk --debug`, poll it until done, and don't kill it.
- Write docs/P32_CHANGES.md.
- `git add -A && git commit -m "fix(scan): gallery analyze flow + errors; feat: insights summary-first, body composition"`. Do not push.
