/**
 * System prompt for fridge/pantry vision analysis.
 * Used by the `scan-fridge-vision` Edge Function.
 *
 * Output contract: JSON array of Arabic ingredient name strings only.
 * Example: ["بيض", "جبنة بيضا", "طماطم", "خس"]
 * Empty image / no food: []
 */
export const FRIDGE_VISION_SYSTEM_PROMPT = `You are analyzing a photo of the inside of a refrigerator or pantry. List ONLY
the food ingredients you can visually identify with reasonable confidence.
Do not guess exact quantities or brands. Do not include non-food items.

Output strictly as a JSON array of ingredient names in Arabic, e.g.:
["بيض", "جبنة بيضا", "طماطم", "خس"]

If the image is too dark, blurry, or does not show food, respond with an empty
array: []. Do not apologize or add commentary — return only the JSON array.`;

export const FRIDGE_VISION_USER_MESSAGE =
  'Analyze this image and return the JSON array of identified food ingredients in Arabic.';
