import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';

/**
 * AI Coach — generates week-1 workout program (Section 3).
 * Selects exercises from library filtered by training_environment.
 * Applies medical_flag intensity reduction server-side.
 */

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return json({ error: 'Unauthorized' }, 401);

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY')!;

    const client = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const {
      data: { user },
    } = await client.auth.getUser();
    if (!user) return json({ error: 'Unauthorized' }, 401);

    const body = await req.json();
    const weekNumber = body.week_number ?? 1;
    const profile = body.profile ?? {};

    const trainingEnv = profile.training_environment ?? 'home_no_equipment';
    const medicalFlag = profile.medical_flag === true;

    const { data: exercises, error: exError } = await client
      .from('exercises')
      .select('id, environment_tags, difficulty, sets, reps, rest_seconds')
      .contains('environment_tags', [trainingEnv]);

    if (exError) return json({ error: exError.message }, 500);

    const pool = (exercises ?? []).map((e) => ({
      ...e,
      sets: medicalFlag ? Math.max(1, Math.floor((e.sets ?? 3) * 0.75)) : e.sets,
      rest_seconds: medicalFlag
        ? Math.floor((e.rest_seconds ?? 60) * 1.25)
        : e.rest_seconds,
    }));

    if (pool.length === 0) {
      return json({ error: 'NO_EXERCISES_FOR_ENVIRONMENT' }, 422);
    }

    const workoutDays = buildWeekDays(pool, medicalFlag);

    const { data: program, error: progError } = await client
      .from('programs')
      .insert({
        user_id: user.id,
        phase_number: 1,
        week_number: weekNumber,
        start_date: new Date().toISOString().slice(0, 10),
      })
      .select('id')
      .single();

    if (progError) return json({ error: progError.message }, 500);

    const dayRows = workoutDays.map((day, index) => ({
      program_id: program.id,
      day_index: index,
      type: day.type,
      exercise_ids: day.exercise_ids,
    }));

    const { error: daysError } = await client.from('program_days').insert(dayRows);
    if (daysError) return json({ error: daysError.message }, 500);

    return json({
      program_id: program.id,
      phase_number: 1,
      week_number: weekNumber,
      days: workoutDays,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return json({ error: message }, 500);
  }
});

function buildWeekDays(
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

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
