/**
 * Items-only meal vision prompt.
 * Gemini must NEVER return calories — macros are computed client-side from foods.json.
 */
export function mealVisionPrompt(args: {
  remainingCalories: number;
  remainingProtein: number;
  language?: string;
  foodCatalogHint?: string;
}): string {
  const lang = args.language === 'en' ? 'en' : 'ar';
  const catalog = args.foodCatalogHint?.trim()
    ? `\nKnown food ids (prefer these for food_id_guess when confident):\n${args.foodCatalogHint.trim()}\n`
    : '';

  return `You are a computer-vision nutritionist for Egyptian and Gulf meals.
Identify EVERY distinct food item visible on the plate/tray. Estimate grams and cooking method.

User context (for your awareness only — do NOT compute calories):
- Remaining daily calories: ${args.remainingCalories} kcal
- Remaining daily protein: ${Math.round(args.remainingProtein)} g
- Preferred language for names: ${lang}
${catalog}
Rules:
1. Return ONLY a JSON object with an "items" array. No markdown, no commentary, no calorie fields.
2. Each item:
   - name_ar: Arabic name (Egyptian dialect OK)
   - name_en: English name
   - food_id_guess: string id if you recognize a catalog food, else null
   - estimated_grams: number > 0
   - cooking_method: one of boiled | grilled | fried | baked | raw | steamed | other
   - confidence: 0 to 1
3. Split mixed dishes into components when possible (e.g. koshari → rice, pasta, lentils, chickpeas, fried onion, sauce).
4. Prefer realistic Middle Eastern portion sizes.
5. Never invent calories, protein, carbs, or fat.

JSON shape:
{
  "items": [
    {
      "name_ar": "أرز أبيض",
      "name_en": "white rice",
      "food_id_guess": "rice_white_cooked",
      "estimated_grams": 180,
      "cooking_method": "boiled",
      "confidence": 0.82
    }
  ]
}`;
}

/** Second-pass: per-100g macros for unmatched foods only. */
export function unmatchedFoodMacrosPrompt(items: Array<{ name_ar: string; name_en: string }>): string {
  const list = items
    .map((i, idx) => `${idx + 1}. ${i.name_en} / ${i.name_ar}`)
    .join('\n');
  return `Estimate nutrition per 100 grams for these Middle Eastern / Gulf foods.
Return ONLY JSON:
{
  "estimates": [
    { "name_en": "...", "kcal": 0, "protein": 0, "carbs": 0, "fat": 0, "fiber": 0 }
  ]
}
Foods:
${list}
Use USDA-like values. No commentary.`;
}

/** Text meal parse — items only. */
export function mealTextPrompt(args: { text: string; language?: string }): string {
  const lang = args.language === 'en' ? 'en' : 'ar';
  return `Parse this user meal description into food items for an Egyptian/Gulf nutrition app.
Text: """${args.text}"""
Language preference: ${lang}

Return ONLY JSON:
{
  "items": [
    {
      "name_ar": "...",
      "name_en": "...",
      "food_id_guess": null,
      "estimated_grams": 0,
      "cooking_method": "raw",
      "confidence": 0.0
    }
  ]
}
Rules:
- Expand portions like "2 eggs", "رغيف بلدي", "كوباية شاي بسكر" into grams.
- Never return calories.
- cooking_method one of boiled|grilled|fried|baked|raw|steamed|other.`;
}
