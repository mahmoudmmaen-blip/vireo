/**
 * AI Coach program builder (Section 3) — environment filter + check-in volume tuning.
 */

export type CheckInRow = {
  adherence?: number | null;
  adherence_pct?: number | null;
  energy_score?: number | null;
};

export type CheckInSignals = {
  adherencePct: number | null;
  energyScore: number | null;
};

export type ExercisePoolRow = {
  id: string;
  sets?: number | null;
  rest_seconds?: number | null;
};

/** Average the most recent check-in rows (up to 4 weeks). */
export function averageCheckInSignals(rows: CheckInRow[]): CheckInSignals {
  if (rows.length === 0) {
    return { adherencePct: null, energyScore: null };
  }

  let adherenceSum = 0;
  let adherenceCount = 0;
  let energySum = 0;
  let energyCount = 0;

  for (const row of rows) {
    const adherence = row.adherence ?? row.adherence_pct;
    if (adherence != null && !Number.isNaN(adherence)) {
      adherenceSum += adherence;
      adherenceCount++;
    }
    if (row.energy_score != null && !Number.isNaN(row.energy_score)) {
      energySum += row.energy_score;
      energyCount++;
    }
  }

  return {
    adherencePct: adherenceCount > 0 ? adherenceSum / adherenceCount : null,
    energyScore: energyCount > 0 ? energySum / energyCount : null,
  };
}

/**
 * Computes volume multiplier from adherence + energy (Section 3).
 * Clamped to [0.6, 1.15].
 */
export function computeVolumeMultiplier(signals: CheckInSignals): number {
  let multiplier = 1.0;
  const { adherencePct, energyScore } = signals;

  if (adherencePct != null) {
    if (adherencePct >= 85) multiplier += 0.1;
    else if (adherencePct < 40) multiplier -= 0.25;
    else if (adherencePct < 60) multiplier -= 0.15;
  }

  if (energyScore != null) {
    if (energyScore >= 8) multiplier += 0.05;
    else if (energyScore <= 4) multiplier -= 0.15;
  }

  return Math.max(0.6, Math.min(1.15, multiplier));
}

export function applyExerciseVolume(
  exercise: ExercisePoolRow,
  options: { medicalFlag: boolean; volumeMultiplier: number },
): { sets: number; rest_seconds: number } {
  const baseSets = exercise.sets ?? 3;
  const baseRest = exercise.rest_seconds ?? 60;

  let sets = Math.round(baseSets * options.volumeMultiplier);
  let rest = baseRest;

  if (options.medicalFlag) {
    sets = Math.max(1, Math.floor(sets * 0.75));
    rest = Math.floor(rest * 1.25);
  }

  return {
    sets: Math.max(1, sets),
    rest_seconds: Math.max(15, rest),
  };
}

export function buildWeekDays(
  pool: Array<{ id: string }>,
  medicalFlag: boolean,
): Array<{ day_index: number; type: string; exercise_ids: string[] }> {
  const days: Array<{ day_index: number; type: string; exercise_ids: string[] }> = [];
  const perWorkout = medicalFlag ? 3 : 4;

  for (let d = 0; d < 7; d++) {
    if (d === 2 || d === 6) {
      days.push({ day_index: d, type: 'rest', exercise_ids: [] });
      continue;
    }
    if (d === 4 && medicalFlag) {
      days.push({ day_index: d, type: 'walk', exercise_ids: [] });
      continue;
    }
    const start = (d * perWorkout) % pool.length;
    const ids: string[] = [];
    for (let i = 0; i < perWorkout; i++) {
      ids.push(pool[(start + i) % pool.length].id);
    }
    days.push({ day_index: d, type: 'workout', exercise_ids: ids });
  }
  return days;
}
