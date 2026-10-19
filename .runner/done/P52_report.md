# P52 — Meal photo scan speed + trust UX
Status: DONE

## What changed
- `image_compressor.dart`: max long side **1024px** (was 800)
- `ai_scan_stage.dart` + overlay: staged copy بنحلل الطبق… / بنقدّر المكونات… / بنحسب الزيت…
- `ai_scan_provider.dart`: pre-compress, stage callbacks, duration analytics, offline enqueue
- `pending_meal_scan_queue.dart`: Hive queue when offline
- Analyze/camera screens: «هنحسبها أول ما النت يرجع»
- `meal_review_screen.dart`: line kcal always `≈`
- `docs/P52_CHANGES.md`, compressor unit test

## Gate results
- analyze: pass (0 errors; 1 warning + 32 infos pre-existing)
- test: pass (`image_compressor_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- On 4G: time a photo scan; expect analytics/boot log `duration_ms` and ideally under ~8s
- Airplane mode: scan → confirm queue message «هنحسبها أول ما النت يرجع»

## Follow-ups suggested
- P51 (013), P49 (014), P50 (015), P53–P55 still in inbox
- Drain `PendingMealScanQueue` automatically when connectivity returns (hook in sync/main shell)
