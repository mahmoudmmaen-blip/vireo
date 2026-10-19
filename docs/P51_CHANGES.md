# P51 — Single source of truth for steps

## What changed
- New `StepsRepository` — Home + Walk read `todayStepsProvider` / `StepsRepository.stream` only
- `PremiumStepsHeroCard` displays `todayStepsProvider` (not a stale prop)
- Health Connect passive poll every **2s** via `fetchIfPermitted` (no permission sheet on refresh)
- Manual / web entry pushes into the same stream (`applyManualTodaySteps`)

## Acceptance
- Home and Walk tab show the same number within 2 seconds
- No double-count after restart (single Hive baseline path + shared stream)
