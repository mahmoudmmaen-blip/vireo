# P48 — Health Connect integration (steps, weight, workouts) — NOT Google Fit
Status: DONE

## What changed
- Kept maintained `health` package (Health Connect on Android) — **no Google Fit**
- `AndroidManifest.xml`: added `WRITE_STEPS`, `WRITE_WEIGHT`, `WRITE_EXERCISE`
- `lib/core/services/health_connect_write_service.dart`: RW request + weight/exercise writes
- `progress_repository.dart`: weight log writes to Health Connect (best-effort)
- `outdoor_gps_tracker.dart`: finished sessions write ExerciseSession to HC
- `step_counter_service.dart`: prefer HC when granted; `healthConnectDenied` flag
- `premium_steps_hero_card.dart`: fallback banner «من غير الإذن هنستخدم عداد الموبايل بس»
- `docs/store/HEALTH_CONNECT_DECLARATION.md` + `docs/P48_CHANGES.md`
- `test/core/health_connect_write_service_test.dart`

## Gate results
- analyze: pass (0 errors; 1 warning + 32 infos pre-existing)
- test: pass (`health_connect_write_service_test`, `step_fusion_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- On a Health Connect device: grant Steps/Weight/Exercise, confirm Home steps match HC and weight log appears in Health Connect
- Deny HC: confirm pedometer still works and the Arabic fallback banner shows

## Follow-ups suggested
- Inbox leftover: `011_P44_fix_package_name` (commit package revert if still uncommitted)
- Optional: surface HC grant CTA on the steps hero when denied
