/**
 * Meal-plan generation with history-aware, cuisine-weighted recipe selection.
 */

export type MealType = 'breakfast' | 'lunch' | 'dinner' | 'snack';

export type RecipeRow = {
  id: string;
  title_ar: string;
  title_en: string;
  prep_time_minutes: number;
  goal_tag: string;
  cuisine_tag: string;
  meal_type: MealType;
  dietary_tags: string[];
};

export type HistoryRow = {
  recipe_id: string;
  served_at: string;
  cuisine_tag?: string;
};

export type MealPlanSlot = {
  week_number: number;
  day_index: number;
  meal_type: MealType;
};

export type GeneratedMealPlanRow = {
  week_number: number;
  day_index: number;
  meal_type: MealType;
  recipe_id: string;
  cuisine_tag: string;
  title_en: string;
};

export type GenerateMealPlanInput = {
  userId: string;
  weekNumber: number;
  cuisinePreferences: string[];
  dietaryRestrictions: string[];
  recipes: RecipeRow[];
  history: HistoryRow[];
  slots?: MealPlanSlot[];
};

const MEAL_TYPES: MealType[] = ['breakfast', 'lunch', 'dinner', 'snack'];
const DEFAULT_HISTORY_DAYS = 14;
const RELAXED_HISTORY_DAYS = 7;
const MIN_ELIGIBLE_BEFORE_RELAX = 3;
const CUISINE_LOOKBACK_DAYS = 30;

export function buildDefaultWeekSlots(weekNumber: number): MealPlanSlot[] {
  const slots: MealPlanSlot[] = [];
  for (let day = 0; day < 7; day++) {
    for (const mealType of MEAL_TYPES) {
      slots.push({ week_number: weekNumber, day_index: day, meal_type: mealType });
    }
  }
  return slots;
}

/** Recipe passes cuisine + dietary filters. */
export function filterRecipesForUser(
  recipes: RecipeRow[],
  cuisinePreferences: string[],
  dietaryRestrictions: string[],
): RecipeRow[] {
  const cuisines = new Set(cuisinePreferences);
  const restrictions = dietaryRestrictions.filter(Boolean);

  return recipes.filter((recipe) => {
    if (!cuisines.has(recipe.cuisine_tag)) return false;
    if (restrictions.length === 0) return true;
    const tags = new Set(recipe.dietary_tags ?? []);
    return restrictions.every((r) => tags.has(r));
  });
}

function cutoffDate(daysAgo: number): Date {
  const d = new Date();
  d.setUTCDate(d.getUTCDate() - daysAgo);
  d.setUTCHours(0, 0, 0, 0);
  return d;
}

function recentRecipeIds(history: HistoryRow[], days: number): Set<string> {
  const cutoff = cutoffDate(days);
  const ids = new Set<string>();
  for (const row of history) {
    if (new Date(row.served_at) >= cutoff) {
      ids.add(row.recipe_id);
    }
  }
  return ids;
}

/** Inverse-frequency cuisine weights from the last 30 days. */
export function buildCuisineWeights(
  history: HistoryRow[],
  eligibleCuisines: string[],
): Map<string, number> {
  const cutoff = cutoffDate(CUISINE_LOOKBACK_DAYS);
  const counts = new Map<string, number>();

  for (const cuisine of eligibleCuisines) {
    counts.set(cuisine, 0);
  }

  for (const row of history) {
    if (!row.cuisine_tag) continue;
    if (new Date(row.served_at) < cutoff) continue;
    counts.set(row.cuisine_tag, (counts.get(row.cuisine_tag) ?? 0) + 1);
  }

  const weights = new Map<string, number>();
  for (const [cuisine, count] of counts.entries()) {
    weights.set(cuisine, 1 / (count + 1));
  }
  return weights;
}

function weightedPick<T extends { weight: number }>(items: T[]): T | null {
  if (items.length === 0) return null;
  const total = items.reduce((sum, item) => sum + item.weight, 0);
  if (total <= 0) return items[Math.floor(Math.random() * items.length)];

  let roll = Math.random() * total;
  for (const item of items) {
    roll -= item.weight;
    if (roll <= 0) return item;
  }
  return items[items.length - 1];
}

export type SelectRecipeResult = {
  recipe: RecipeRow;
  historyWindowDays: number;
};

/**
 * Select one recipe for a meal slot respecting history + cuisine weighting.
 */
export function selectRecipeForSlot(options: {
  mealType: MealType;
  pool: RecipeRow[];
  history: HistoryRow[];
  runExcludedIds: Set<string>;
  cuisineWeights: Map<string, number>;
}): SelectRecipeResult | null {
  const { mealType, pool, history, runExcludedIds, cuisineWeights } = options;

  const byMeal = pool.filter((r) => r.meal_type === mealType);

  const tryWindow = (days: number): RecipeRow[] => {
    const historyIds = recentRecipeIds(history, days);
    return byMeal.filter(
      (r) => !historyIds.has(r.id) && !runExcludedIds.has(r.id),
    );
  };

  let windowDays = DEFAULT_HISTORY_DAYS;
  let eligible = tryWindow(windowDays);

  if (eligible.length < MIN_ELIGIBLE_BEFORE_RELAX) {
    windowDays = RELAXED_HISTORY_DAYS;
    eligible = tryWindow(windowDays);
  }

  if (eligible.length === 0) {
    // Last resort: allow any recipe for meal type not yet used this run.
    eligible = byMeal.filter((r) => !runExcludedIds.has(r.id));
    windowDays = 0;
  }

  if (eligible.length === 0) return null;

  const weighted = eligible.map((recipe) => ({
    recipe,
    weight: cuisineWeights.get(recipe.cuisine_tag) ?? 1,
  }));

  const picked = weightedPick(weighted);
  if (!picked) return null;

  return { recipe: picked.recipe, historyWindowDays: windowDays };
}

/**
 * Generates a full weekly meal plan. Mutates run state via immediate virtual
 * history entries so later slots in the same run avoid duplicates.
 */
export function generateWeeklyMealPlan(
  input: GenerateMealPlanInput,
): GeneratedMealPlanRow[] {
  const pool = filterRecipesForUser(
    input.recipes,
    input.cuisinePreferences,
    input.dietaryRestrictions,
  );

  if (pool.length === 0) {
    throw new Error('NO_ELIGIBLE_RECIPES');
  }

  const eligibleCuisines = [...new Set(pool.map((r) => r.cuisine_tag))];
  const slots = input.slots ?? buildDefaultWeekSlots(input.weekNumber);

  const runHistory: HistoryRow[] = [...input.history];
  const runExcludedIds = new Set<string>();
  const output: GeneratedMealPlanRow[] = [];

  for (const slot of slots) {
    const cuisineWeights = buildCuisineWeights(runHistory, eligibleCuisines);

    const selection = selectRecipeForSlot({
      mealType: slot.meal_type,
      pool,
      history: runHistory,
      runExcludedIds,
      cuisineWeights,
    });

    if (!selection) {
      throw new Error(`NO_RECIPE_FOR_SLOT:${slot.day_index}:${slot.meal_type}`);
    }

    const { recipe } = selection;
    const servedAt = new Date().toISOString();

    runHistory.push({
      recipe_id: recipe.id,
      served_at: servedAt,
      cuisine_tag: recipe.cuisine_tag,
    });
    runExcludedIds.add(recipe.id);

    output.push({
      week_number: slot.week_number,
      day_index: slot.day_index,
      meal_type: slot.meal_type,
      recipe_id: recipe.id,
      cuisine_tag: recipe.cuisine_tag,
      title_en: recipe.title_en,
    });
  }

  return output;
}
