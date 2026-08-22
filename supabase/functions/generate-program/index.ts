import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  applyExerciseVolume,
  averageCheckInSignals,
  buildWeekDays,
  computeVolumeMultiplier,
} from '../_shared/coach-program-generator.ts';
import type { CoachProgramOutput } from '../_shared/prompts/ai-coach.ts';

/**
 * AI Coach — generates weekly workout program (Section 3).
 * Filters by training_environment, tunes volume from check-ins, returns strict JSON.
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

    const { data: checkins } = await client
      .from('checkins')
      .select('adherence, adherence_pct, energy_score, created_at')
      .eq('user_id', user.id)
      .order('created_at', { ascending: false })
      .limit(4);

    const signals = averageCheckInSignals(checkins ?? []);
    const volumeMultiplier = computeVolumeMultiplier(signals);

    const { data: exercises, error: exError } = await client
      .from('exercises')
      .select('id, environment_tags, difficulty, sets, reps, rest_seconds')
      .contains('environment_tags', [trainingEnv]);

    if (exError) return json({ error: exError.message }, 500);

    const pool = (exercises ?? []).map((e) => {
      const tuned = applyExerciseVolume(e, { medicalFlag, volumeMultiplier });
      return { ...e, sets: tuned.sets, rest_seconds: tuned.rest_seconds };
    });

    if (pool.length === 0) {
      return json({ error: 'NO_EXERCISES_FOR_ENVIRONMENT' }, 422);
    }

    const workoutDays = buildWeekDays(pool, medicalFlag);

    const { data: program, error: progError } = await client
      .from('programs')
      .insert({
        user_id: user.id,
        phase_number: body.phase_number ?? 1,
        week_number: weekNumber,
        start_date: new Date().toISOString().slice(0, 10),
      })
      .select('id')
      .single();

    if (progError) return json({ error: progError.message }, 500);

    const dayRows = workoutDays.map((day) => ({
      program_id: program.id,
      day_index: day.day_index,
      type: day.type,
      exercise_ids: day.exercise_ids,
    }));

    const { error: daysError } = await client.from('program_days').insert(dayRows);
    if (daysError) return json({ error: daysError.message }, 500);

    const output: CoachProgramOutput = {
      program_id: program.id,
      phase_number: body.phase_number ?? 1,
      week_number: weekNumber,
      training_environment: trainingEnv,
      medical_flag: medicalFlag,
      volume_multiplier: volumeMultiplier,
      check_in_signals: {
        adherence_pct: signals.adherencePct,
        energy_score: signals.energyScore,
      },
      days: workoutDays,
    };

    return json(output);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return json({ error: message }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
