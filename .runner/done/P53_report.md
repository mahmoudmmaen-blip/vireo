# P53 — Weekly charts for steps and calories
Status: DONE

## What changed
- `steps_repository.dart`: `last7Days()` SSOT history for charts
- `weekly_steps_fl_chart.dart`: fl_chart bars + goal dashed line; Arabic empty state
- `weekly_calories_intake_chart.dart`: intake bars vs daily goal line; Arabic empty state
- `weekly_charts_screen.dart`: steps + calories + weight trend (with projection card) in one screen
- `calories_today_mascot_card.dart`: «التفاصيل» opens weekly charts (1 tap from Home)
- `full_walk_tab_screen.dart`: «التفاصيل» next to week charts → same screen
- `weekly_charts_empty_test.dart`: empty-state Arabic copy coverage

## Gate results
- analyze: pass (0 errors; infos/warnings pre-existing)
- test: pass (`weekly_charts_empty_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- من الهوم: كارت السعرات → **التفاصيل** → شوف الخطوات/السعرات/الوزن
- من تاب المشي: **التفاصيل** جنب رسم الأسبوع

## Follow-ups suggested
- P54 meal component chips (017)
- P55 AAB size audit (018)
