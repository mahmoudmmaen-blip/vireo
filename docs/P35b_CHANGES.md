# P35b — Accuracy Round 2: Matching & Portions

Branch: `ux-v2` · Date: 2026-10-15
Spec: `docs/prompts/P35b_accuracy_round2.md` · Details: `docs/ACCURACY.md`

## Methodology (hold-out first)

- Before any change, the 70-meal independent bench was split deterministically:
  20 TEST meals (13 egyptian + 7 generic — smallest FNV-1a hash of meal_id) and
  50 TUNING meals. All analysis and fixes used TUNING rows only; reference
  values (`items_text`, `true_kcal`) were never edited.
- Baseline: TUNING 26.40% / HELD-OUT 20.93% / ALL 24.84%.
- Final:   TUNING **9.26%** / HELD-OUT **20.93%** (unchanged — zero regression,
  every held-out meal identical to baseline) / ALL **12.60%** (< 15% target).
- Verified-only (excluding 5 `source_confidence=low` meals): 12.74%.

## Root causes fixed (tuning set)

1. **Arabic matching** (`bench_engine.dart`, `assets/food_db/foods.json`):
   - word-token checks (`hasWord`) instead of raw substrings: كفتة≠فتة،
     بيضاء≠بيض (egg regex gained `(?!ا)`)، سكوب≠كوب، زيت الزيتون≠زيتون.
   - Data fixes: removed the incorrect alias `كبدة اسكندراني` from
     `liver_pate` (it belongs to `kebda_iskandarani`); added `لوز مجروش`/
     `لوز مطحون` to `almonds`; fixed 4 wrong USDA fdc_ids
     (yogurt_greek, liver_beef_cooked, tortilla_flour, potato_boiled).
2. **Portion grams**: teaspoon 5 g (was 14), kaiser bun 60 g, pita 65 g,
   large tortilla 75 g, half/quarter fruit, ribeye 220 g, shawarma sandwich
   200 g, Alexandrian-liver sandwich 190 g; removeTokens sorted longest-first
   (fixes stray "ه" polluting match queries).
3. **Composite dishes**: sourced component expansions for shrimp pasta,
   orzo casserole (لسان عصفور باللحم), chili, cheese sandwich, chicken-noodle
   soup cup.
4. **Cooking oil by method (P34)**: +14 g/100 g only on explicit `مقلي` and
   only when the matched entry is not already `fried`/`cooked`. ("محمر" =
   roasted, excluded — applying it double-counted and regressed eg_06.)

## Verification

- `dart run tool/accuracy_bench/run_bench.dart` — output pasted in docs/ACCURACY.md §8.
- `flutter test test/features/accuracy/bench_engine_test.dart --timeout 2m` — 22/22 pass.
- Reference sources verified (NNI Egypt FCT 2006, FAO/INFOODS Arab tables 2005,
  USDA FDC SR Legacy); 5 unattributed "Cairo University lab analysis" meals
  marked `source_confidence=low`; MAPE with/without reported.
- Removed the unsupported "foreign apps exceed 50% error" claim from docs/ACCURACY.md.
- `flutter build apk --debug` — success.

## Files

- `tool/accuracy_bench/bench_engine.dart` (new, extracted engine), `run_bench.dart`
  (rewired CLI + split + worst-15 + verified-only report), `diagnose.dart` (new).
- `tool/accuracy_bench/reference_meals.csv` — added `source_confidence` column only.
- `assets/food_db/foods.json` — alias + fdc_id corrections only.
- `test/features/accuracy/bench_engine_test.dart` (new).
- `docs/ACCURACY.md` — honest round-2 numbers, methodology, weaknesses, bench output.

## Known remaining gaps (next round)

Held-out weaknesses deliberately NOT tuned: صامولي/بيكن/رانش/بطاطس مشوية missing
as standalone entries; حلاوة-طحينية stuffed-loaf sizing. A full audit of the
remaining USDA fdc_ids is recommended (4 of 4 spot-checked were wrong).
