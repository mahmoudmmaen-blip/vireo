/**
 * Items-only meal vision prompt.
 * Gemini must NEVER return calories — macros are computed client-side from foods.json.
 */
export function mealVisionPrompt(args: {
  remainingCalories: number;
  remainingProtein: number;
  language?: string;
  foodCatalogHint?: string;
  userHint?: string;
}): string {
  const lang = args.language === 'en' ? 'en' : 'ar';
  const catalog = args.foodCatalogHint?.trim()
    ? `\nKnown food ids (prefer these for food_id_guess when confident):\n${args.foodCatalogHint.trim()}\n`
    : '';
  const hint = args.userHint?.trim()
    ? `\nUser note about this meal (trust this for oil/sauce/bread type):\n"${args.userHint.trim()}"\n`
    : '';

  return `You are a computer-vision nutritionist for Egyptian and Gulf meals.
Identify EVERY distinct food item VISIBLE on the plate/tray. Estimate grams and cooking method.

User context (awareness only — do NOT compute calories):
- Remaining daily calories: ${args.remainingCalories} kcal
- Remaining daily protein: ${Math.round(args.remainingProtein)} g
- Preferred language for names: ${lang}
${catalog}${hint}
Rules:
1. Return ONLY a JSON object with "items" and "items_unsure" arrays. No markdown, no commentary, no calorie fields.
2. List ONLY foods that are CLEARLY VISIBLE on the plate. NEVER guess or hallucinate secondary meats, hidden ingredients, or invisible items (e.g., if there is chicken and rice, DO NOT add duck, lamb, or hidden meat unless unmistakably visible).
3. If an item might be present but you are not completely sure, DO NOT add it to "items"; place it in "items_unsure" with confidence < 0.5.
4. Spices, sumac, dry herbs, garnishes, and decorative leaves are NOT foods — omit them.
5. Prefer Egyptian/Gulf dish names (foul, ta'ameya, koshari, baladi bread, molokhia, etc.) when they fit.
6. Each item:
   - name_ar, name_en
   - food_id_guess: catalog id or null
   - estimated_grams: number > 0
   - cooking_method: boiled | grilled | fried | baked | raw | steamed | other
   - confidence: accurate number between 0.0 and 1.0 representing visual certainty
7. Put items with confidence >= 0.5 in "items". Items with confidence < 0.5 MUST go into "items_unsure".
8. Split mixed dishes into components when possible.
9. Never invent calories, protein, carbs, or fat.

JSON shape:
{
  "items": [
    {
      "name_ar": "أرز أبيض",
      "name_en": "white rice",
      "food_id_guess": "white_rice_cooked",
      "estimated_grams": 180,
      "cooking_method": "boiled",
      "confidence": 0.82
    }
  ],
  "items_unsure": []
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
  ],
  "items_unsure": []
}
Rules:
- Expand portions like "2 eggs", "رغيف بلدي", "كوباية شاي بسكر" into grams.
- Never return calories.
- Prefer Egyptian/Gulf names.
- cooking_method one of boiled|grilled|fried|baked|raw|steamed|other.`;
}
