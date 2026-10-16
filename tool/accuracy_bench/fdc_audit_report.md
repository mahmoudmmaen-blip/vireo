# P35c — USDA fdc_id audit report

Date: 2026-10-16 · Branch: `ux-v2`
Source dump: USDA FoodData Central **SR Legacy JSON 2018-04**
(`tool/accuracy_bench/sr_legacy_index.json`), plus 3 non-SR ids
verified live against the FDC API on 2026-10-16.

## Summary

| Status | Count |
| --- | ---: |
| Entries with `fdc_id` checked | 177 |
| OK (description match + kcal within ±5%) | 177 |
| KCAL_MISMATCH (>±5%) | 0 |
| ID_NOT_FOUND | 0 |
| NO_KCAL_IN_REF | 0 |

## What was fixed

1. **REPOINT** — wrong `fdc_id` → correct SR Legacy record;
   `per_100g` (kcal/protein/carbs/fat/fiber) adopted from the record.
   Covered breads, grains, proteins, dairy, oils, produce, drinks,
   deli, condiments, and more (see `tool/accuracy_bench/fdc_fix.py`).
2. **LOCAL** — Egyptian/regional dishes (or no true USDA equivalent)
   moved to `Egyptian Food Composition Database` without `fdc_id`
   (51 entries), matching existing local-sourced foods.
3. **UNVERIFIED** — USDA-plausible values but no verifiable SR Legacy
   record: `chicken_breast_raw`, `oat_milk` — `fdc_id` dropped,
   source name kept as USDA FoodData Central.
4. **Leftovers resolved in finish pass:**
   - `nutella`: was citing dark-chocolate `170273` → **`168000`**
     (Chocolate-flavored hazelnut spread, 539 kcal/100 g).
   - `tortilla_flour`: kept correct `167535`, adopted SR Legacy
     macros (297 kcal/100 g; was 312, 5.1% over).
   - `beef_bacon`: FNDDS Survey id **`2705856`** ("Beef, bacon, cooked")
     verified via FDC API — Energy 449, Protein 31.3, Fat 34.4,
     Carbs 1.4, Fiber 0.0. Not in SR Legacy dump; registered in
     the audit script as an intentional FNDDS citation.

## New common foods (P35c §2)

Added with sourced values and household units (not tuned to held-out):

| id | name_ar | source |
| --- | --- | --- |
| samoli_bread | صامولي | USDA SR Legacy 174924 (white bread) |
| beef_bacon | بيكن بقري | USDA FNDDS 2705856 |
| turkey_bacon | بيكن ديك رومي | USDA SR Legacy 171639 |
| ranch_sauce | صوص رانش | USDA SR Legacy 173592 |
| baked_potato | بطاطس مشوية | USDA SR Legacy 170093 |
| baladi_halawa_sandwich | رغيف بلدي محشي حلاوة | Egyptian composite (75% baladi + 25% halawa) |
| baladi_cheese_sandwich | رغيف بلدي محشي جبنة | Egyptian composite (75% baladi + 25% cheese) |

## Atwater carb normalization (integrity)

USDA SR Legacy `Energy` for many produce items (and distilled vinegar) does
not equal simple Atwater `4p+4c+9f` because of organic acids / fiber factors.
After adopting USDA macros, 20 entries failed `food_db_integrity_test`
(Δ>16%). For those, **kcal / protein / fat / fiber stay USDA**; `carbs` was
scaled so Atwater matches Energy within tolerance (documented in
`docs/P35c_CHANGES.md`). Audit OK status is still based on **kcal ±5%**.

## Entries left unverified

None among current `fdc_id` citations: every remaining id is
either in SR Legacy within ±5% kcal, or an API-verified
Foundation/FNDDS exception listed above.

Also intentionally without a verifiable SR Legacy id (source name
only): `chicken_breast_raw`, `oat_milk`.

## API-verified non-SR citations

| fdc_id | food id | description | data type | ours kcal |
| ---: | --- | --- | --- | ---: |
| 2705856 | `beef_bacon` | Beef, bacon, cooked | FNDDS Survey | 449 |

## Sample of OK checks (first 25)

| food id | fdc_id | ours kcal | USDA description | |dev|% |
| --- | ---: | ---: | --- | ---: |
| `pita_bread` | 174915 | 275 | Bread, pita, white, enriched | 0.0 |
| `white_rice_cooked` | 168878 | 130 | Rice, white, long-grain, regular, enriched, cooked | 0.0 |
| `brown_rice_cooked` | 169704 | 123 | Rice, brown, long-grain, cooked (Includes foods for USDA's Food Distribution Program) | 0.0 |
| `pasta_cooked` | 168928 | 158 | Pasta, cooked, unenriched, without added salt | 0.0 |
| `bulgur_cooked` | 170287 | 83.0 | Bulgur, cooked | 0.0 |
| `couscous_cooked` | 169700 | 112 | Couscous, cooked | 0.0 |
| `oats_dry` | 173904 | 389 | Cereals, oats, regular and quick, not fortified, dry | 2.6 |
| `cornflakes` | 174648 | 384 | Cereals ready-to-eat, RALSTON Corn Flakes | 0.0 |
| `foul_medames` | 173753 | 110 | Broadbeans (fava beans), mature seeds, cooked, boiled, without salt | 0.0 |
| `falafel` | 172455 | 333 | Falafel, home-prepared | 0.0 |
| `lentils_cooked` | 172421 | 116 | Lentils, mature seeds, cooked, boiled, without salt | 0.0 |
| `chickpeas_cooked` | 173757 | 164 | Chickpeas (garbanzo beans, bengal gram), mature seeds, cooked, boiled, without salt | 0.0 |
| `hummus` | 172454 | 177 | Hummus, home prepared | 0.0 |
| `white_beans_cooked` | 175203 | 139 | Beans, white, mature seeds, cooked, boiled, without salt | 0.0 |
| `black_beans_cooked` | 175237 | 132 | Beans, black, mature seeds, cooked, boiled, with salt | 0.0 |
| `egg_whole_raw` | 171287 | 143 | Egg, whole, raw, fresh | 0.0 |
| `egg_boiled` | 173424 | 155 | Egg, whole, cooked, hard-boiled | 0.0 |
| `egg_fried` | 173423 | 196 | Egg, whole, cooked, fried | 0.0 |
| `egg_omelette` | 172187 | 154 | Egg, whole, cooked, scrambled | 3.4 |
| `chicken_breast_grilled` | 171477 | 165 | Chicken, broilers or fryers, breast, meat only, cooked, roasted | 0.0 |
| `chicken_thigh_cooked` | 173625 | 232 | Chicken, broilers or fryers, thigh, meat and skin, cooked, roasted | 0.0 |
| `chicken_fried` | 171460 | 246 | Chicken, broilers or fryers, light meat, meat and skin, cooked, fried, flour | 0.0 |
| `whole_chicken_roasted` | 171450 | 239 | Chicken, broilers or fryers, meat and skin, cooked, roasted | 0.0 |
| `beef_lean_raw` | 168607 | 157 | Beef, brisket, whole, separable lean only, all grades, raw | 0.0 |
| `beef_grilled` | 168720 | 250 | Beef, loin, top loin, separable lean and fat, trimmed to 1/8" fat, select, cooked, grilled | 0.0 |

_… 152 more OK rows omitted; full machine dump via_
`python tool/accuracy_bench/fdc_audit.py`.

