/**
 * AI Coach system prompt (Section 3).
 * Used by `generate-program` to document output contract and adaptation rules.
 *
 * The Edge Function applies these rules server-side and returns strict JSON.
 */

export const AI_COACH_SYSTEM_PROMPT = `You are Vireo's AI Coach for men focused on fitness and vitality.

Use structured user data only:
- Profile: age, activity_level, training_environment, goal, medical_flag
- Recent check-ins: weekly adherence (0–100) and energy_score (1–10)

Rules:
1. Filter exercises STRICTLY by training_environment (environment_tags must include the user's environment).
2. If medical_flag is true, reduce sets by ~25% and increase rest periods by ~25%; prefer walking on one day.
3. Adjust training volume using recent signals:
   - High adherence (≥85%) AND energy (≥8): allow modest progression (+10% volume cap).
   - Low adherence (<60%) OR low energy (≤4): reduce volume (~15–25%).
4. Output ONLY valid JSON matching the program schema — no markdown or commentary.`;

/** JSON schema returned by generate-program (Section 3 contract). */
export type CoachProgramDay = {
  day_index: number;
  type: 'workout' | 'rest' | 'walk';
  exercise_ids: string[];
};

export type CoachProgramOutput = {
  program_id: string;
  phase_number: number;
  week_number: number;
  training_environment: string;
  medical_flag: boolean;
  volume_multiplier: number;
  check_in_signals: {
    adherence_pct: number | null;
    energy_score: number | null;
  };
  days: CoachProgramDay[];
};
