# P51 — Single source of truth for steps (StepsRepository stream)
Status: DONE

## What changed
- `lib/features/walking/data/steps_repository.dart`: SSOT facade over `StepCounterService`
- `live_steps_provider.dart`: stream/count from `StepsRepository`
- `premium_steps_hero_card.dart`: displays `todayStepsProvider` (same as Walk tab)
- HC passive poll ≤2s via `HealthStepsService.fetchIfPermitted` (no mid-stream permission prompts)
- Manual steps → `StepsRepository.applyManualTodaySteps` so Home stays aligned
- `docs/P51_CHANGES.md`, `test/features/walking/steps_repository_test.dart`

## Gate results
- analyze: pass (0 errors; 1 warning + 32 infos pre-existing)
- test: pass (`steps_repository_test`, `step_fusion_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- Open Home and Walk tab side by side: numbers should match within ~2s while walking
- Deny HC: both screens still show pedometer count

## Follow-ups suggested
- P49 home restructure (014), P50 theme tokens (015), P53–P55
