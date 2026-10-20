# P56 — Phantom 320 kcal meal auto-appears on app open
Status: DONE

## What changed
- `confirmed_meals_provider.dart`: default confirmed set is empty (was `{breakfast}`) — root cause of phantom ≈320 kcal demo omelette
- `phantom_meal_cleanup.dart`: one-shot Hive scrub of seed/demo `ai_meal_logs` entries; logs `[P56] meal cleanup…`
- `hive_service.dart`: runs cleanup after boxes open
- `phantom_meal_fix_test.dart`: fresh install → day log empty + demo-id/title scrub heuristics

## Root cause
`confirmedMealsProvider` pre-confirmed breakfast; offline demo plan primary breakfast (`demo-b1` Egg & Cheese Omelette) is exactly **320 kcal**, so every cold start looked like a logged meal. PendingMealScanQueue / widgets / sync were not auto-logging.

## Gate results
- analyze: pass (0 issues on touched files)
- test: pass (`phantom_meal_fix_test`, `meal_log_refresh_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- افتح التطبيق من cold start: سجل اليوم لازم يكون فاضي (0 سعرات) لحد ما تأكّد وجبة بنفسك
- لو لسه شايف وجبة قديمة غريبة، امسح بيانات التطبيق مرة وجرّب تاني (الـ cleanup بيشتغل مرة واحدة)

## Follow-ups suggested
- P56b: persist confirmed slots per day in Hive so toggles survive restart
- P57 paywall visibility (020)
- P58 voice logging (022)
