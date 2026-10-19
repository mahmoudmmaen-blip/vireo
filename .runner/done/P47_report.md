# P47 — Water tracker with fasting/Ramadan integration
Status: DONE

## What changed
- `lib/features/home/widgets/quick_water_card.dart`: Home card with wave progress + كوباية 250 / زجاجة 500 / مخصص + goal tune
- `lib/features/home/widgets/home_dashboard_body.dart`: wired `QuickWaterCard` after Daily Score
- `lib/features/water/providers/water_window_key.dart`: iftar→suhoor storage day key
- `lib/features/water/providers/water_tracker_provider.dart`: uses Ramadan window key when enabled
- `lib/features/water/providers/water_goal_override_provider.dart`: persisted user goal override
- `lib/features/water/providers/water_daily_goal_provider.dart`: default floor 2L + override support
- `test/features/water/water_window_key_test.dart`
- `docs/P47_CHANGES.md`

## Gate results
- analyze: pass (0 errors; 1 warning + 32 infos pre-existing)
- test: pass (`water_window_key_test`, `home_simplicity_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- On device: from Home tap كوباية 250 once — should log without opening a sheet
- Enable Ramadan and confirm the card title is «شربت كام كوباية من الإفطار للسحور؟» and overnight logging stays on the same window

## Follow-ups suggested
- P48_health_connect
- Optional: suppress water nudges during fasting hours via `isFastingHoursNowProvider`
