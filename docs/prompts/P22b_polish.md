Act as a Senior Flutter engineer + product designer on Vireo (branch ux-v2). Second round of owner feedback from a real phone (ar_EG). Work autonomously, do not ask questions.

1. BOTTOM TABS are hard to read.
   - Bigger labels (12–13 sp, medium weight), better contrast, selected tab = filled pill with accent color + label.
   - Use clear Arabic labels: الرئيسية، التمارين، التغذية، التقدم. The center + stays.
   - Make sure labels never truncate in any of the 10 locales.

2. MEAL REVIEW "إزاي حسبناها" (how we calculated) needs a cleaner layout. Show it as a small table per item:
   - الكمية (g / حبة / حفنة with the gram equivalent);
   - kcal, protein, carbs, fat, each with its own colored chip;
   - source (USDA/Egyptian table/AI estimate) and confidence.
   Also:
   - Unit chips: "حبة" and "حفنة" must convert to grams and update the numbers instantly.
   - The cooking-method chips (نيء، مسلوق، مشوي، مقلي، في الفرن) must change the kcal (e.g. fried adds oil). Show the delta.
   - Put kcal BEFORE the unit in Arabic correctly, e.g. "339 سعرة"; avoid mixed "kcal 339" ordering. Use localized units in ar locales: سعرة، بروتين، كارب، دهون.

3. WORKOUT descriptions are too thin. For every exercise in the catalog/seed, show a proper exercise detail:
   - target muscles;
   - 3–5 numbered steps;
   - 2–3 common mistakes;
   - breathing cue;
   - sets × reps / rest for the user's level;
   - an easier and a harder variation;
   - a safety note.
   Localize to all 10 locales (ar_EG in Egyptian dialect). Store the data in the exercise catalog (JSON/seed), not hard-coded in widgets. If an exercise has an image/animation asset use it; otherwise use a clean muscle-group illustration placeholder.
   The warm-up screen ("الإحماء") should show the same short steps under each move.

4. DIET PROGRAMS + CUISINE:
   - The daily meal plan must be generated from: age, sex, weight, height, goal, activity, the chosen program (balanced, 16:8, Egyptian light, high-protein, low-carb, keto…), and the user's country/cuisine.
   - Add a "المطبخ" setting (Egyptian, Saudi/Gulf, Levantine, Moroccan, Turkish, Indian/Pakistani, Indonesian, Western/Mediterranean). Default it from locale/country.
   - Changing the cuisine or the program regenerates the meal suggestions with local dishes.
   - Make sure "الأكل النضيف المصري" uses Egyptian dishes. Other cuisines use their own dishes with the same macro targets.
   - Show on each program card why it fits the user, e.g. "مناسب لهدفك: خسارة دهون".

5. GENERAL POLISH ("ابدع شوية"):
   - Consistent spacing.
   - Card headers with icons.
   - Empty states with a helpful action instead of "Log more entries to see trends" (that text is English: localize it).
   - Celebratory micro-animations on goal completion.
   - Make sure no English text remains in ar/ar_EG screens; grep for hard-coded strings once more.

Rules:
- flutter gen-l10n.
- flutter analyze → 0 errors.
- Run the affected tests with --timeout 2m.
- Build `flutter build apk --debug`.
- git add -A && git commit -m "feat(polish): tabs, meal math table, rich exercise guides, cuisine-aware plans". Do not push.
- Final message: a short list of what changed + anything you could not do.
