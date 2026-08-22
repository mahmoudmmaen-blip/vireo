# Vireo — Analytics Event Tracking Plan

**Version:** 1.0  
**Purpose:** Full-funnel instrumentation for product analytics, adherence trends, churn signals, and v1.5 prioritization.

| event_name | when_it_fires | key_properties | why_it_matters |
|------------|---------------|----------------|----------------|
| `onboarding_step_completed` | User taps Continue and successfully advances past each onboarding step (1–6) | `step_number` (int 1–6), `locale`, `unit_detected` (metric/imperial) | Funnel drop-off by step; which steps cause abandonment; optimize onboarding copy and validation; compare EN vs AR completion |
| `training_environment_selected` | User selects a training environment card during onboarding or re-assessment | `value` (home_no_equipment \| home_light_equipment \| gym_full \| walking_only), `source` (onboarding \| reassessment) | Distribution of environments drives exercise library investment; detect mismatch between selection and actual workout completion |
| `consent_accepted` | User checks legal consent checkbox and continues past consent screen | `consent_version`, `timestamp_client` | Compliance audit trail; correlate consent completion with downstream retention |
| `workout_started` | User begins active workout (after warm-up or directly if skipped) | `program_phase` (int), `week_number`, `day_index`, `exercise_count`, `medical_flag` (bool) | Workout engagement baseline; which phases/weeks see starts vs skips; medical_flag cohort behavior |
| `workout_completed` | User finishes last exercise + cool-down and reaches feedback screen (or submits feedback) | `adherence_pct` (0–100), `program_phase`, `duration_seconds`, `exercises_completed`, `exercises_planned` | Core success metric; adherence trends over time; identify phases with low completion for program design |
| `set_completed` | User marks a set checkbox complete during active workout | `exercise_id`, `set_index`, `rest_seconds`, `program_phase` | Granular engagement; rest-timer skip patterns; exercises with high drop-off mid-workout |
| `exercise_swapped` | User selects an alternative from Swap Exercise bottom sheet | `from_id`, `to_id`, `target_muscle`, `training_environment` | Which exercises users reject; improve library tagging; auto-down-rank swapped-away exercises/cuisines over time |
| `fridge_scan_used` | Vision scan returns successfully (ingredients detected, including empty array) | `items_detected_count`, `scan_id`, `remaining_scans` (nullable), `is_premium` (bool) | Feature adoption; hit rate of vision model; conversion trigger when free scans exhausted |
| `meal_swapped` | User confirms a replacement recipe for a meal-plan slot | `from_recipe_id`, `to_recipe_id`, `meal_type`, `day_index`, `cuisine_from`, `cuisine_to` | Variety preferences vs stated cuisine_preference; inform Surprise Me and cuisine weighting algorithms |
| `weight_logged` | User saves a weight entry (quick log sheet or reassessment) | `unit_displayed` (kg \| lb), `source` (progress_fab \| reassessment), `has_goal_line` (bool) | Progress feature stickiness; logging frequency as retention predictor |
| `reassessment_completed` | User finishes monthly re-assessment flow and sees summary card | `weight_delta`, `activity_level_changed` (bool), `training_environment_changed` (bool), `phase_recalculated` (bool) | Program adaptation impact; how often users materially change; correlate with 30-day retention |
| `paywall_viewed` | Paywall or trial-ended screen is shown | `trigger_source` (trial_expired \| feature_gate_fridge \| feature_gate_program \| profile_upgrade \| onboarding_end), `variant` (A/B paywall id) | Conversion funnel; which gates drive views vs annoyance; optimize trigger timing |
| `subscription_started` | Store confirms new active entitlement (incl. trial start if tracked separately) | `tier` (monthly \| annual \| lifetime), `is_trial` (bool), `store` (apple \| google) | Revenue mix; annual vs monthly ratio; trial-to-paid conversion by tier |
| `subscription_cancelled` | RevenueCat/store signals entitlement lapsed or user cancelled renewal | `tier`, `days_active`, `cancellation_reason` (if available from store) | Churn signals; average lifetime by tier; early churn vs long-term; inform win-back campaigns |
| `account_deleted` | User completes hard-delete confirmation flow | `reason_if_given` (nullable string from optional survey), `days_since_signup`, `was_premium` (bool) | Trust and product-market fit; top deletion reasons; differentiate churn vs delete |

---

## Recommended global properties (attach to all events)

| property | description |
|----------|-------------|
| `user_id` | Hashed or internal UUID (never raw email in analytics) |
| `session_id` | App session identifier |
| `locale` | `en` \| `ar` |
| `app_version` | Build number |
| `platform` | `ios` \| `android` |
| `is_guest` | bool |
| `subscription_status` | free \| trial \| premium \| expired |

---

## Derived metrics & decisions (v1.5+)

| metric | events used | product decision |
|--------|-------------|------------------|
| Onboarding completion rate | `onboarding_step_completed` | Shorten or split steps with >15% drop |
| Workout adherence trend | `workout_completed.adherence_pct` | Adjust AI volume rules when cohort median <70% |
| Swap-heavy exercises | `exercise_swapped` | Replace or re-tag low-retention exercises |
| Fridge scan → subscribe | `fridge_scan_used` + `paywall_viewed` + `subscription_started` | Tune free scan limit (5 vs 3) |
| Cuisine drift | `meal_swapped.cuisine_to` | Auto-adjust cuisine weights without manual preference change |
| Churn risk | `subscription_cancelled`, low `workout_started` frequency | Target re-engagement pushes (non-shaming copy) |
| Re-assessment impact | `reassessment_completed.phase_recalculated` | Validate monthly re-assessment UX worth keeping |

---

## Implementation notes

- Fire `paywall_viewed` once per presentation, not per pricing tile impression.
- Fire `workout_completed` once per session when feedback screen loads (dedupe if user backgrounds app).
- `account_deleted`: fire **before** server wipe while `reason_if_given` is still available client-side.
- Align `tier` values with RevenueCat product identifiers via a lookup table in analytics schema.
