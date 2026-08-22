import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  buildDefaultWeekSlots,
  generateWeeklyMealPlan,
  type HistoryRow,
  type RecipeRow,
} from '../_shared/meal-plan-generator.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

type GenerateRequest = {
  week_number?: number;
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return json({ error: 'Unauthorized' }, 401);
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY')!;

    const client = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const {
      data: { user },
      error: userError,
    } = await client.auth.getUser();

    if (userError || !user) {
      return json({ error: 'Unauthorized' }, 401);
    }

    const body = req.method === 'POST' ? ((await req.json()) as GenerateRequest) : {};
    const weekNumber = body.week_number ?? isoWeekNumber(new Date());

    const { data: profile, error: profileError } = await client
      .from('users')
      .select('cuisine_preference, dietary_restrictions')
      .eq('id', user.id)
      .single();

    if (profileError) {
      return json({ error: profileError.message }, 500);
    }

    const cuisinePreferences: string[] = profile.cuisine_preference?.length
      ? profile.cuisine_preference
      : ['international_healthy'];
    const dietaryRestrictions: string[] = profile.dietary_restrictions ?? [];

    const { data: recipes, error: recipesError } = await client
      .from('recipes')
      .select(
        'id, title_ar, title_en, prep_time_minutes, goal_tag, cuisine_tag, meal_type, dietary_tags',
      );

    if (recipesError) {
      return json({ error: recipesError.message }, 500);
    }

    const historyCutoff = new Date();
    historyCutoff.setUTCDate(historyCutoff.getUTCDate() - 30);

    const { data: historyRows, error: historyError } = await client
      .from('user_recipe_history')
      .select('recipe_id, served_at, recipes(cuisine_tag)')
      .eq('user_id', user.id)
      .gte('served_at', historyCutoff.toISOString());

    if (historyError) {
      return json({ error: historyError.message }, 500);
    }

    const history: HistoryRow[] = (historyRows ?? []).map((row) => ({
      recipe_id: row.recipe_id as string,
      served_at: row.served_at as string,
      cuisine_tag: (row.recipes as { cuisine_tag?: string } | null)?.cuisine_tag,
    }));

    const planRows = generateWeeklyMealPlan({
      userId: user.id,
      weekNumber,
      cuisinePreferences,
      dietaryRestrictions,
      recipes: (recipes ?? []) as RecipeRow[],
      history,
      slots: buildDefaultWeekSlots(weekNumber),
    });

    // Replace existing plan for this week, then insert sequentially so history
    // rows from this run are visible to any follow-up logic in the same request.
    await client
      .from('meal_plans')
      .delete()
      .eq('user_id', user.id)
      .eq('week_number', weekNumber);

    const inserted: typeof planRows = [];

    for (const row of planRows) {
      const { data: mealPlan, error: mealPlanError } = await client
        .from('meal_plans')
        .insert({
          user_id: user.id,
          week_number: row.week_number,
          day_index: row.day_index,
          meal_type: row.meal_type,
          recipe_id: row.recipe_id,
        })
        .select('id')
        .single();

      if (mealPlanError) {
        return json({ error: mealPlanError.message }, 500);
      }

      const { error: historyInsertError } = await client
        .from('user_recipe_history')
        .insert({
          user_id: user.id,
          recipe_id: row.recipe_id,
          meal_plan_id: mealPlan.id,
          served_at: new Date().toISOString(),
        });

      if (historyInsertError) {
        return json({ error: historyInsertError.message }, 500);
      }

      inserted.push(row);
    }

    return json({
      week_number: weekNumber,
      meals: inserted,
      total_slots: inserted.length,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    const status = message.startsWith('NO_') ? 422 : 500;
    return json({ error: message }, status);
  }
});

function isoWeekNumber(date: Date): number {
  const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  return Math.ceil(((d.getTime() - yearStart.getTime()) / 86400000 + 1) / 7);
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
