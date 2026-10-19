# P47 — Water tracker with fasting/Ramadan integration

## What changed
- Home: wired `QuickWaterCard` with wave progress + chips كوباية 250 / زجاجة 500 / مخصص
- Goal: default floor 2L; user override via tune icon (`water_goal_override_ml`)
- Ramadan: storage key follows iftar→suhoor window (`WaterWindowKey`); card title uses `ramadanWaterTrackerQuestion`
- Offline Hive + sync queue unchanged (`water_tracker` / `water_logs`)

## Deduped (single Home water UI)
- Removed water pillar from `TodayPillarsGrid` (food / workout / sleep only)
- Removed `_WaterHighlightCard` from `TodayPlanSection`
- Single tracker on Home: `QuickWaterCard` only (quick-log / smart-next may still nudge +glass)
