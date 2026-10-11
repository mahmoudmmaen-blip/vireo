# Vireo Data Map: Hive Local Stores to Supabase Tables

This document audits every local store (Hive box / key) across Vireo and maps it to the corresponding Supabase table schema, sync direction, and conflict strategy.

## Audit Matrix

| Hive Box / Key | Local Domain | Supabase Table | Conflict Rule | Sync Policy |
| :--- | :--- | :--- | :--- | :--- |
| `cache:confirmed_meals` | Meals & Nutritional logs | `public.nutrition_logs` | Last-write-wins (`updated_at`) | Bidirectional sync with soft-delete |
| `cache:ai_nutrition_scans` | AI Photo & Voice Scans | `public.ai_nutrition_scans` | Last-write-wins (`updated_at`) | Write-first, push when online |
| `cache:water_tracker` / `settings:water_cup` | Water Intake & Cup Size | `public.water_logs` | Last-write-wins (`updated_at`) | Daily aggregation + logs sync |
| `settings:step_history` / `walking_state` | Steps History & Tracking | `public.daily_steps_history` | Last-write-wins (`updated_at`) | Push daily totals; aggregate server-side |
| `cache:workout_sessions` / `custom_workouts` | Workouts & Logged Sets | `public.workout_sessions` | Last-write-wins (`updated_at`) | Offline-first sync |
| `cache:outdoor_gps_sessions` | Outdoor GPS Routes & Walks | `public.gps_workouts` | Last-write-wins (`updated_at`) | Routes with lat/lng points; push online |
| `cache:weight_logs` / `last_reassessment` | Weight Entries & Goals | `public.weight_logs` | Last-write-wins (`updated_at`) | History sync with soft delete |
| `body_measurements:*` | InBody & Circumference Scans | `public.body_measurements` | Last-write-wins (`updated_at`) | Bidirectional sync |
| `settings:active_diet_program` | Active Diet Program | `public.user_diet_programs` | Last-write-wins (`updated_at`) | User active program phase & config |
| `cache:today_plan_checks` | Today Plan Task Completion | `public.today_plan_completions` | Last-write-wins (`updated_at`) | Daily checklist sync |
| `cache:vitality_log` / `vitality_progress` | Vitality Protocol & Habits | `public.vitality_daily_logs` | Last-write-wins (`updated_at`) | Habit logs sync |
| `settings:*` (notifications, theme, units) | User App Preferences | `public.user_settings` | Last-write-wins (`updated_at`) | Sync key-value preferences JSON |
| `cache:progress_photos` | Visual Progress Photos | Supabase Storage (`progress_photos`) | User Opt-in | Excluded unless "Back up photos" is ON |

## Sync & Privacy Guarantees
1. **Offline-first Architecture**: All user modifications write locally to Hive first and are queued in `sync_queue`. The queue pushes sequentially when network is restored.
2. **Soft Deletes**: Deletions flag `deleted_at = now()` so remote replicas clean up without race conditions.
3. **Anonymous to Real Account Upgrades**: Anonymous sessions keep the identical UUID upon linking/upgrading to permanent auth. If signing into a different existing account, Vireo prompts: `Keep this phone's data`, `Keep account data`, or `Merge both`.
4. **Account & Data Deletion**: Full deletion deletes all tables (including social & sync tables) and removes private storage buckets.
