# علوم Vireo — الدقة أولاً

الملخص بالعربية: فيريو بيحسب الحرق والسعرات من **معادلات علمية ثابتة** (مشي ACSM، قلب Keytel، نشاط Compendium، Mifflin / Katch للـ TDEE)، وبعدين الذكاء الاصطناعي **بيشرح بس** — مش بيخترع أرقام. حرق التمرين **صافي** (من غير ما نضيف معدل الراحة تاني)، والخطة بتتعدل من وزنك الفعلي وتسجيلك، مش من أرقام عامة.

---

## Formula table (source of truth)

| Formula | What it computes | Source | Test |
|---|---|---|---|
| Mifflin–St Jeor BMR | Sex-aware resting burn (+5 men / −161 women) | Mifflin et al. 1990 | `test/features/insights/energy_projection_test.dart`, `test/features/progress/adaptive_tdee_engine_test.dart` |
| Katch–McArdle BMR | BMR from lean mass: `370 + 21.6·FFM` | Katch & McArdle | `test/features/measurements/navy_tape_calculator_test.dart` |
| ACSM walking VO2 | `0.1·v + 1.8·v·G + 3.5` (ml/kg/min) | ACSM Guidelines | `test/features/activity/acsm_net_energy_test.dart` |
| ACSM running VO2 | `0.2·v + 0.9·v·G + 3.5` | ACSM Guidelines | `test/features/activity/acsm_net_energy_test.dart` |
| Net kcal from VO2 | `(VO2 − 3.5)·kg / 200` per minute | ACSM | same |
| kcal/step fallback | `0.0005·kg·stride_m` (±10% vs ACSM @ 100 spm) | Validated vs ACSM | same |
| Keytel 2005 HR | Sex/age/weight HR kcal/min; blend 70% HR / 30% ACSM | Keytel et al. 2005 | same |
| Compendium 2024 MET | Net = `(MET − 1)·kg·hours` | Ainsworth Compendium 2024 | same |
| Observed TDEE | `avg_intake − (Δtrend_kg × 7700 / days)` | Energy balance | `test/features/progress/adaptive_tdee_engine_test.dart` |
| Trend weight EMA | α = 0.1; spikes > 1.5 kg ignored | Standard EMA | same + `weight_trend_calculator` |
| Fat equivalent | 7700 kcal ≈ 1 kg adipose | ACSM | `test/core/utils/fat_equivalent_test.dart`, energy ledger tests |
| Safety floors | ♀ 1200 / ♂ 1500; no deficit pregnancy/&lt;18; ≤1%/week | Clinical floors | rebalance + adaptive TDEE tests |

## Design rules
1. **Deterministic science first** — LLM explains only.
2. **Net exercise only** — never add BMR again into eat-back.
3. **Adaptive blend** — `TDEE = w·observed + (1−w)·formula`, `w → 0.8` with data quality; ±150 kcal/week.
4. **No auto-punishment** — rebalance options require a user tap; copy never uses عقاب / فشلت / غلطت / ذنب.
