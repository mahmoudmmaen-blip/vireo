# Vireo Analytics Event Tracking Plan

All analytics events in Vireo adhere to **strict privacy standards**:
- **NEVER** log health metrics (weight, body fat %, blood pressure, HRV values).
- **NEVER** log dietary items or calories consumed.
- **NEVER** log GPS coordinates or location data.
- Only log high-level feature engagement, user progression, and purchase intents.

## Comprehensive Events Matrix

| Event Name | Trigger | Properties |
| :--- | :--- | :--- |
| `app_open` | Cold start or app resume | `environment`, `locale` |
| `onboarding_step_viewed` | Screen rendered in onboarding | `step_index`, `step_name` |
| `onboarding_step_completed`| User taps next/continues step | `step_index`, `step_name`, `skipped` |
| `scan_started` | Food/fridge scanner opened | `mode` ('fridge' \| 'meal') |
| `scan_succeeded` | AI successfully parsed image/audio | `items_count`, `duration_ms` |
| `scan_failed` | AI scan returned an error | `error_type` |
| `meal_saved` | User logs meal into diary | `meal_type`, `has_photo` |
| `coach_message` | Message sent to AI Coach | `turn_count`, `has_context` |
| `workout_started` | User starts guided workout | `split_id` |
| `workout_completed` | User finishes workout session | `exercises_count`, `duration_min` |
| `paywall_viewed` | Paywall opened | `source` ('quota' \| 'pro_tap' \| 'weekly_report') |
| `purchase_started` | User initiates store checkout | `plan_id` ('monthly' \| 'annual') |
| `purchase_completed` | Store transaction finalized | `plan_id`, `has_trial` |
| `reminder_opened` | User taps on local notification | `reminder_type` |
| `account_deleted` | User confirms account wipe | `confirmed` |
