# P48 — Health Connect (not Google Fit)

## Plugin
Kept maintained `health` ^13.x (Health Connect on Android + HealthKit on iOS). No Google Fit dependency.

## What changed
- Manifest: `WRITE_STEPS`, `WRITE_WEIGHT`, `WRITE_EXERCISE`
- `HealthConnectWriteService`: weight + exercise session writes (best-effort)
- `ProgressRepository.logWeight` → writes weight to HC
- Outdoor GPS `stop` → writes exercise session to HC
- Steps: prefer Health Connect when granted; pedometer fallback otherwise
- Home steps hero banner when HC denied: «من غير الإذن هنستخدم عداد الموبايل بس»
- Updated `HEALTH_CONNECT_DECLARATION.md`
