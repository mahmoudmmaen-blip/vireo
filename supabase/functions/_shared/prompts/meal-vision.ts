/**
 * Port of VireoAiPrompts.mealVisionPrompt — keep in sync with Dart.
 */
export function mealVisionPrompt(args: {
  remainingCalories: number;
  remainingProtein: number;
  language?: string;
}): string {
  const protein = Math.round(args.remainingProtein);
  const langNote =
    args.language === 'en'
      ? '\nRespond with English food_name / portion_estimate / warning_message / smart_swaps when language is English; otherwise keep Arabic labels as in the JSON Format section.'
      : '';

  return `Act as an expert Computer Vision Nutritionist.
Analyze the image of the meal and calculate its nutritional content based on visual portion estimation.

User Context:
- Remaining Daily Calories: ${args.remainingCalories} kcal
- Remaining Daily Protein: ${protein} g

Task & Rules:
1. Estimate food items, total calories, protein, carbs, and fats using Middle Eastern & international food databases.
2. If calories > 600 OR exceed remaining daily calorie budget, set "is_high_calorie" to true and provide a brief Arabic warning in "warning_message".
3. Provide two practical Arabic "smart_swaps" (one to reduce calories/fats, one to boost protein).
4. Respond ONLY with a valid JSON object. No markdown fences, no commentary.

JSON Format:
{
  "food_name": "اسم الوجبة بالعربي",
  "portion_estimate": "تقدير الكمية (مثال: 200 جرام أو طبق متوسط)",
  "calories": 0,
  "protein": 0.0,
  "carbs": 0.0,
  "fats": 0.0,
  "is_high_calorie": false,
  "warning_message": null,
  "smart_swaps": ["اقتراح 1", "اقتراح 2"]
}${langNote}`;
}
