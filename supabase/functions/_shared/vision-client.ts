import { FRIDGE_VISION_SYSTEM_PROMPT } from '../_shared/prompts/fridge-vision.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');
const VISION_MODEL = Deno.env.get('VISION_MODEL') ?? 'gpt-4o-mini';

export type VisionMessage = {
  role: 'system' | 'user';
  content: string | VisionContentPart[];
};

export type VisionContentPart =
  | { type: 'text'; text: string }
  | { type: 'image_url'; image_url: { url: string; detail?: 'low' | 'high' | 'auto' } };

/**
 * Calls the configured vision model and returns raw text (expected: JSON array).
 */
export async function analyzeFridgeImage(
  imageUrl: string,
  userText: string,
): Promise<string> {
  if (!OPENAI_API_KEY) {
    throw new Error('VISION_API_NOT_CONFIGURED');
  }

  const messages: VisionMessage[] = [
    { role: 'system', content: FRIDGE_VISION_SYSTEM_PROMPT },
    {
      role: 'user',
      content: [
        { type: 'text', text: userText },
        { type: 'image_url', image_url: { url: imageUrl, detail: 'auto' } },
      ],
    },
  ];

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: VISION_MODEL,
      temperature: 0.1,
      max_tokens: 512,
      messages,
    }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`VISION_API_ERROR:${response.status}:${body}`);
  }

  const payload = await response.json();
  const content = payload?.choices?.[0]?.message?.content;
  if (typeof content !== 'string' || content.trim().length === 0) {
    throw new Error('VISION_EMPTY_RESPONSE');
  }

  return content.trim();
}

/**
 * Parses model output into a deduplicated Arabic ingredient list.
 * Accepts raw JSON array or fenced ```json blocks.
 */
export function parseIngredientArray(raw: string): string[] {
  let text = raw.trim();

  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/i);
  if (fenced?.[1]) {
    text = fenced[1].trim();
  }

  const parsed = JSON.parse(text);
  if (!Array.isArray(parsed)) {
    throw new Error('VISION_INVALID_SHAPE');
  }

  const ingredients: string[] = [];
  const seen = new Set<string>();

  for (const item of parsed) {
    if (typeof item !== 'string') continue;
    const normalized = item.trim();
    if (!normalized) continue;
    const key = normalized.toLowerCase();
    if (seen.has(key)) continue;
    seen.add(key);
    ingredients.push(normalized);
  }

  return ingredients;
}
