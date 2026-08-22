/// Server-side vision prompt for fridge/pantry scanning (Section 4).
///
/// Canonical source: `supabase/functions/_shared/prompts/fridge-vision.ts`
/// Deployed via the `scan-fridge-vision` Edge Function — never send this
/// prompt from the client; the Edge Function injects it server-side.
abstract final class FridgeVisionPrompt {
  static const system = '''
You are analyzing a photo of the inside of a refrigerator or pantry. List ONLY
the food ingredients you can visually identify with reasonable confidence.
Do not guess exact quantities or brands. Do not include non-food items.

Output strictly as a JSON array of ingredient names in Arabic, e.g.:
["بيض", "جبنة بيضا", "طماطم", "خس"]

If the image is too dark, blurry, or does not show food, respond with an empty
array: []. Do not apologize or add commentary — return only the JSON array.''';

  static const userMessage =
      'Analyze this image and return the JSON array of identified food ingredients in Arabic.';
}
