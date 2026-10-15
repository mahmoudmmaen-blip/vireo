Act as a senior Flutter + nutrition-data engineer on Vireo (branch ux-v2). Start after P35 is committed. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

## Accuracy round 2. Target: MAPE < 15% overall on the honest bench
- Current honest result (docs/ACCURACY.md):
  - overall 24.8%;
  - Egyptian 19.4%;
  - generic 34.6%.
- **Hold out 20 meals as a TEST set before changing anything.** Tune only on the other meals, and report BOTH numbers (tuning set and held-out set). Never edit reference values to improve the score.
- Analyze the 15 worst meals and fix the root causes:
  1. Arabic name matching: synonyms and dialect spellings (رز/أرز، فراخ/دجاج، عيش/خبز، بطاطس/بطاطا…), fuzzy matching, and USDA mapping for generic foods.
  2. Household portion grams: cup, plate (small/medium/large), loaf, piece, spoon per food category.
  3. Composite dish defaults: koshary, mahshi, fatta, molokhia with rice, sandwiches. Add per-dish component breakdowns with sourced values.
  4. Cooking oil defaults by method (from P34), applied only when the method implies oil.
- **Verify every reference source** in reference_meals.csv is real (NNI Egypt, FAO/INFOODS Arab tables, USDA FDC IDs, published label). Mark any uncertain reference with `source_confidence=low` and report the MAPE with and without those.
- **Remove the unsupported sentence** in docs/ACCURACY.md claiming that foreign apps exceed 50% error. No claims about competitors.
- Update docs/ACCURACY.md with the honest numbers and a plain Arabic explanation.

## Verify & deliver
- Run `flutter analyze` (0 errors), unit tests for the matcher and portion math, and the bench script. Paste its output into the doc.
- `git add -A && git commit -m "feat(accuracy): round 2 matching & portions"`. Do not push.
