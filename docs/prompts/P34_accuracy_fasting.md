Act as a senior Flutter + backend engineer and nutrition-science product designer on Vireo (branch ux-v2). Start only after P33 is committed. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

Competitor benchmark: "Calz: Calorie Counter AI" (1M+ installs, 4.7★). It has AI photo scan, a food DB, an intermittent-fasting timer, a step counter, a water tracker and dietitian articles. Goal: beat it on ACCURACY and on fasting.

## 1. CALORIE ACCURACY ENGINE (beat AI-only estimates)
Principle: the AI identifies foods and estimates GRAMS. Nutrition values come from VERIFIED databases, never from the model's own kcal guess.

1. **Two-step pipeline in analyze-meal:**
   - Step A (vision): items[] with {name_ar, name_en, food_db_id candidate, cooking_method, grams_estimate, grams_low, grams_high, confidence, visible_oil_or_sauce}.
   - Step B (server): look each item up in our bundled DB (Egyptian/Arab, 439+ items, sent as candidate ids) → else the USDA FoodData Central subset (bundle a compact JSON of ~1,500 common generic foods per-100 g into assets, generated from FDC Foundation/SR Legacy, public domain) → else the model's estimate, flagged "تقدير".
   - kcal = grams × kcal_per_100g / 100.
   - Return a source per item: "قاعدة بيانات" / "USDA" / "تقدير".
2. **Hidden calories (the biggest real-world error):**
   - **Cooking oil / ghee / butter:** add a per-method oil absorption table (fried, sautéed, grilled, boiled, oven, mahshi, etc.) and auto-add an "زيت الطبخ (تقديري)" line the user can adjust: لا / قليل / متوسط / كتير.
   - **Sauces, dressings, tahini and sugar in drinks:** chip prompts.
3. **Portion calibration:**
   - Settings: plate size (small 20 cm / medium 24 cm / large 28 cm) and "كوب الرز بتاعي" size.
   - Optional "ضع شوكة/ملعقة جنب الطبق" tip for scale.
   - Multi-angle photos (already supported) improve volume; tell the model the plate diameter.
4. **Learn from the user:** store every correction, (food_id, ai_grams, user_grams). After at least 3 corrections for a food, apply a personal correction factor (median ratio, clamped 0.6–1.6) to future estimates, and show "معدّلة على أكلك".
5. **Smart clarifying question:** when confidence < 0.6 or the method is ambiguous (fried vs grilled), ask ONE quick tap question in the review ("الفراخ دي مشوية ولا مقلية؟"). Never more than one popup.
6. **Escalation:** if overall confidence < 0.5, re-run once with a stronger model (env STRONG_VISION_MODEL, default gemini-2.5-pro) with the thinking budget enabled. Show the user "بنراجع بدقة أعلى…" while it runs. Log the latency.
7. **Accuracy benchmark (must do):**
   - Create tool/accuracy_bench/ with a CSV of reference meals: name, items, true grams, true kcal. Include at least 40 Egyptian/Arab meals and 20 generic ones, using standard recipe values. Photos are not required: use text descriptions through the same Step B pipeline to test DB matching and portion math.
   - Write a script that prints the mean absolute % error per meal and overall. Target < 15% on the text-path benchmark.
   - Save the results to docs/ACCURACY.md, which also explains the method in plain Arabic. That doc becomes store-listing material ("دقة أعلى للأكل المصري").
8. **Transparency in UI:** each item shows its source chip and a ± range (e.g., "≈ 430 سعرة (380–480)"). The "إزاي حسبناها" section explains: identify → grams → verified DB → oil → personal calibration.

## 2. INTERMITTENT FASTING (better than competitors)
- **Plans:** 12:12, 14:10, 16:8, 18:6, 20:4, OMAD, 5:2, custom. Recommend a starting plan by level (beginner → 12:12/14:10).
- **Big circular timer on its own screen.** One tap starts or ends the fast (the same reliable lock/optimistic pattern as the step toggle). Editable start time ("بدأت من ساعتين").
- **Live fasting stages with honest science:** anabolic → catabolic (~4–16 h) → fat-burning increases (~12 h+) → ketosis begins (~18–24 h, varies by person). Wording: "غالباً / تقريباً". No exaggerated claims.
- **Notifications:** fast started, halfway, 1 h left, goal reached, eating window closing. Persistent progress notification optional.
- **Integration:**
  - A Home card shows the fasting status when active.
  - Logging a meal during a fast asks "تنهي الصيام؟".
  - Ramadan mode uses the same engine with the Fajr→Maghrib window automatically.
  - Fasting days feed the score (consistency) and coins (+15 for a completed fast).
- **History:** calendar with completed fasts, streaks, average fast length, and longest fast. Weekly chart.
- **Safety:** disable fasting suggestions and show a warning if the user marked pregnancy/breastfeeding, is under 18, has diabetes on medication (ask once), or has an eating-disorder history flag. Cap custom fasts above 24 h behind a "استشر طبيبك" confirmation. No fasting > 72 h.
- **Unit tests:** stage calculation, window math across midnight and DST, Ramadan window, the safety gating, and coins once per fast.

## 3. VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors).
- Run the new tests plus test/audit (Fasting screen and the meal review with source chips at 360×640 ar_EG, textScale 1.3), each with `--timeout 2m`, using pump(Duration).
- Redeploy analyze-meal and confirm one real request succeeds in the logs.
- Run the accuracy bench and paste its results into docs/ACCURACY.md.
- Run `flutter build apk --debug`. Poll it until done.
- Write docs/P34_CHANGES.md.
- `git add -A && git commit -m "feat(accuracy+fasting): verified-DB calorie engine, oil & portion calibration, IF timer"`. Do not push.
