# P38 — Adaptive coach accuracy

## What shipped
- **Activity energy (net):** ACSM walk/run VO2, Keytel HR blend (70/30), Compendium MET−1 for workouts, stride defaults + GPS EMA calibration (0.5–1.3 m), GPS filter (accuracy/speed), auto-pause &lt;0.5 m/s × 10 s.
- **Step fusion:** pedometer + Health Connect de-dupe (hourly coverage preference; day-level max — never double count); source shown via StepSource.
- **Adaptive TDEE engine:** observed + formula blend, water-spike filter, cycle down-weight hook, ±150 kcal/week, sex-aware floors (1200♀/1500♂), pregnancy/&lt;18 no deficit, weekly check-in copy.
- **Rebalance engine:** surplus/deficit/protein/steps-behind/Ramadan windows; options require tap; exceptional-day positive copy.
- **Missed steps (end of day → morning card):** gradual make-up (cap +1500, peak+15%), food balance ≤200, start fresh, lower to بصمتك after 3 misses.
- **Patterns + notification budget:** weekend/late/protein/steps/gaps/plateau; max 3/day + quiet hours + ignore×3.
- **Energy ledger رصيد حرقك:** Hive incremental totals + Insights card tabs; honesty note vs trend weight.
- **بصمتك (Vireo Fingerprint):** learner + 4-card screen (activity/nutrition/tolerance/chronotype).
- **AI router:** `supabase/functions/_shared/ai-router.ts` (Claude when `ANTHROPIC_API_KEY`, else Gemini); `ai-health`, `weekly-review`; coach chat validates numbers.
- **UI:** rebalance card, weekly balance chart, outdoor net metrics panel; GPS run screen remains behind `FeatureFlags.gpsRunScreen` (v1 hidden).
- **Docs:** `docs/SCIENCE.md` (Arabic summary + formula table).

## Tests
- Unit/sim: ACSM, adaptive TDEE (±5% perfect logger), rebalance, missed steps, ledger, fingerprint synthetics, step fusion, GPS filter, ARB blame-word grep.
- Audit: rebalance card, weekly balance chart, outdoor metrics @ 360×640 ar_EG textScale 1.3.

## Owner must do
1. Set Supabase secrets if desired: `ANTHROPIC_API_KEY`, optional `CLAUDE_MODEL` (Gemini already used for vision).
2. Deploy edge functions: `ai-coach-chat`, `ai-health`, `weekly-review` (`npx supabase functions deploy … --use-api`).
3. Optional DB table `ai_weekly_review_cache` for weekly Pro cache (function still works without it).
4. Keep `gpsRunScreen` false for v1 unless deliberately enabling outdoor GPS.

## Notes / TODOs
- Hourly Health Connect buckets: day-level fusion wired; richer hourly streams can plug into `StepFusion.fuseDay` without API change.
- Rebalance / missed-steps schedulers (5/6/8/9 PM) are deterministic evaluators — wire to notification jobs in a follow-up if not already covered by nurture plan.
