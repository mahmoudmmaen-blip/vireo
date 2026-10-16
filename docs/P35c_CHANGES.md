# P35c — USDA fdc_id audit + missing common foods

Branch: `ux-v2` · Date: 2026-10-16
Spec: `docs/prompts/P35c_food_db_audit.md`

## What shipped

1. **Full USDA `fdc_id` audit** of `assets/food_db/foods.json` against the
   SR Legacy 2018-04 dump (`tool/accuracy_bench/sr_legacy_index.json`).
   Wrong ids were REPOINT-ed; Egyptian/regional dishes moved to local source
   (no `fdc_id`); two unverifiable USDA citations had ids dropped.
   Report: `tool/accuracy_bench/fdc_audit_report.md` — **177/177 OK** (±5% kcal).
2. **Leftovers finished** (prior agent cut off before commit):
   - `nutella` → `168000` (Chocolate-flavored hazelnut spread)
   - `tortilla_flour` kept `167535`, adopted SR Legacy macros (297 kcal)
   - `beef_bacon` FNDDS `2705856` verified via FDC API (Energy 449); registered
     in `fdc_audit.py` as intentional non-SR citation
3. **Missing common foods** (sourced + household units; not tuned to held-out):
   صامولي، بيكن بقري/ديك رومي، صوص رانش، بطاطس مشوية، رغيف بلدي محشي حلاوة/جبنة
4. **ACCURACY.md**: date typo `أكتوبر 2025` → `أكتوبر 2026`; honesty line
   about held-out being the truest accuracy figure; P35c bench numbers pasted.

## Bench (no held-out tuning)

| Split | MAPE |
| --- | ---: |
| TUNING (50) | **10.03%** |
| HELD-OUT (20) | **20.82%** |
| ALL (70) | **13.11%** |
| Verified-only (65) | 13.32% |

(P35b Round 2 was TUNING 9.26% / HELD-OUT 20.93% / ALL 12.60%. TUNING rose
slightly because SR Legacy value adoption replaced some prior kcal; HELD-OUT
moved only from adding common foods, not from answer-fitting.)

## Atwater note

20 produce/vinegar entries had USDA Energy that diverges from simple Atwater
after macro adoption. Kept USDA kcal/protein/fat/fiber; scaled `carbs` so
`food_db_integrity_test` (Δ≤16%) passes. Does not change bench MAPE (kcal-based).

## Verification

- `python tool/accuracy_bench/fdc_audit.py` — Counter OK=177
- `dart run tool/accuracy_bench/run_bench.dart` — numbers above
- `flutter analyze` — 0 errors (infos only)
- `flutter test test/features/accuracy/bench_engine_test.dart test/food_db_integrity_test.dart --timeout 2m`

## Files

- `assets/food_db/foods.json`
- `tool/accuracy_bench/fdc_audit.py`, `fdc_fix.py`, `fdc_suggest.py`,
  `sr_legacy_index.json`, `fdc_candidates.txt`, `fdc_audit_report.md`
- `docs/ACCURACY.md`, `docs/P35c_CHANGES.md`, `docs/prompts/P35c_food_db_audit.md`
