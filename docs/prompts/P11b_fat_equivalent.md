Act as a Senior Flutter Engineer working on Vireo (branch ux-v2). Read lib/ first. Reuse lib/core/ui, the existing calculators and l10n (all 10 locales; dialect copy for ar_EG / ar_SA).

FEATURE: "Fat equivalent" — show users how many grams of body fat their effort roughly equals.

Rule (single source of truth, new file lib/core/utils/fat_equivalent.dart):
- 1 g body fat ≈ 7.7 kcal (7700 kcal ≈ 1 kg). gramsFat = kcal / 7.7, rounded to whole grams (≥ 1000 g → show kg with 1 decimal).
- Always label it as an estimate ("≈", "تقريبًا") with a one-tap info sheet: "Real scale weight also changes with water and glycogen, so daily weight can move differently. This is the energy equivalent of fat."
- Never show negative values; 0 kcal → hide.

1. WALKING / RUNNING / CYCLING:
- Outdoor workout live screen + finish summary + history detail: under calories show "≈ X g fat".
- Daily steps card (Home + Activity hub): calories from steps today → "≈ X g fat".
- Cardio log entries: same line.

2. DIET / DAILY ENERGY:
- Home today card: today's net balance (goal/maintenance − eaten + burned). If in deficit: "Today's deficit ≈ X g fat". If in surplus: neutral copy, no shaming.
- Diet program detail + active plan card: planned daily deficit → "≈ X g fat/day • ≈ Y g/week" (reuse DietPlanEngine.weeklyLossKg; keep both consistent).
- Weekly report + Progress weekly deficit chart: total completed-days deficit → "≈ X g fat this week".

3. Copy (examples, translate naturally to all locales):
- en: "≈ 45 g of fat"  •  ar: "≈ ٤٥ جرام دهون" (keep Western digits per app rule: "≈ 45 جرام دهون")
- ar_EG: "حرقت ما يعادل ≈ 45 جرام دهون 🔥"  •  ar_SA: "حرقت ما يعادل ≈ 45 جرام دهون، كفو!"

4. Tests: unit tests for fat_equivalent (7.7 rule, rounding, kg switch, zero/negative), and that the diet program weekly grams match DietPlanEngine.weeklyLossKg × 1000 within rounding.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs.
flutter analyze → 0 errors; run only the new/affected tests (with --timeout 2m).
git add -A && git commit -m "feat(energy): fat-equivalent grams for workouts, steps and diet deficit". Do not push.
