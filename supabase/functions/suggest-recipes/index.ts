import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import { filterRecipesForUser, type RecipeRow } from '../_shared/meal-plan-generator.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

type SuggestRequest = {
  ingredients: string[];
  scan_id?: string;
};

const GOAL_TAG_MAP: Record<string, string[]> = {
  weight_loss: ['light_energy', 'quick_easy'],
  muscle_gain: ['high_protein', 'quick_easy'],
  general_vitality: ['quick_easy', 'light_energy'],
  all_of_above: ['high_protein', 'quick_easy', 'light_energy'],
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

    const body = (await req.json()) as SuggestRequest;
    const ingredients = (body.ingredients ?? []).map((i) => i.trim()).filter(Boolean);
    if (ingredients.length === 0) {
      return json({ error: 'INGREDIENTS_REQUIRED' }, 400);
    }

    const { data: profile } = await client
      .from('users')
      .select('cuisine_preference, dietary_restrictions, goal')
      .eq('id', user.id)
      .maybeSingle();

    const cuisinePreferences: string[] = profile?.cuisine_preference?.length
      ? profile.cuisine_preference
      : ['international_healthy', 'egyptian', 'levantine', 'khaleeji'];
    const dietaryRestrictions: string[] = profile?.dietary_restrictions ?? [];
    const goal = profile?.goal ?? 'general_vitality';
    const preferredTags = GOAL_TAG_MAP[goal] ?? GOAL_TAG_MAP.general_vitality;

    const { data: recipes, error: recipesError } = await client
      .from('recipes')
      .select(
        'id, title_ar, title_en, prep_time_minutes, goal_tag, cuisine_tag, meal_type, dietary_tags, ingredient_ids',
      );

    if (recipesError) return json({ error: recipesError.message }, 500);

    const { data: foodItems } = await client
      .from('food_items')
      .select('id, name_en, name_ar');

    const foodById = new Map(
      (foodItems ?? []).map((f) => [f.id as string, f as { name_en: string; name_ar: string }]),
    );

    const pool = filterRecipesForUser(
      (recipes ?? []) as RecipeRow[],
      cuisinePreferences,
      dietaryRestrictions,
    );

    const normalizedIngredients = ingredients.map(normalize);

    const scored = pool
      .map((recipe) => {
        const full = (recipes ?? []).find((r) => r.id === recipe.id) as
          | { ingredient_ids?: string[]; goal_tag: string }
          | undefined;
        const names = (full?.ingredient_ids ?? [])
          .map((id) => foodById.get(id))
          .filter(Boolean)
          .flatMap((f) => [f!.name_en, f!.name_ar]);

        const haystack = [
          recipe.title_en,
          recipe.title_ar,
          ...names,
        ].map(normalize);

        let overlap = 0;
        for (const ing of normalizedIngredients) {
          if (haystack.some((h) => h.includes(ing) || ing.includes(h))) overlap++;
        }

        const goalBoost = preferredTags.includes(recipe.goal_tag) ? 2 : 0;
        return { recipe, score: overlap + goalBoost };
      })
      .filter((s) => s.score > 0)
      .sort((a, b) => b.score - a.score)
      .slice(0, 3);

    // Fallback: goal-filtered recipes even without ingredient overlap.
    const suggestions =
      scored.length > 0
        ? scored
        : pool
            .filter((r) => preferredTags.includes(r.goal_tag))
            .slice(0, 3)
            .map((recipe) => ({ recipe, score: 0 }));

    if (body.scan_id) {
      await client
        .from('fridge_scans')
        .update({ confirmed_items: ingredients })
        .eq('id', body.scan_id)
        .eq('user_id', user.id);
    }

    return json({
      recipes: suggestions.map(({ recipe }) => ({
        id: recipe.id,
        title_en: recipe.title_en,
        title_ar: recipe.title_ar,
        prep_time_minutes: recipe.prep_time_minutes,
        goal_tag: recipe.goal_tag,
        cuisine_tag: recipe.cuisine_tag,
        meal_type: recipe.meal_type,
      })),
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return json({ error: message }, 500);
  }
});

function normalize(value: string): string {
  return value.trim().toLowerCase();
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
