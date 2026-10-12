import { generateContent, stripDataUrl } from './gemini-client.ts';
import {
  FRIDGE_VISION_SYSTEM_PROMPT,
  FRIDGE_VISION_USER_MESSAGE,
} from './prompts/fridge-vision.ts';

/**
 * Calls Gemini with the fridge vision prompt and image.
 * Accepts either a base64 string (with or without data URL prefix) or an HTTP/HTTPS image URL.
 */
export async function analyzeFridgeImage(
  imageInput: string,
  mimeType = 'image/jpeg',
  userText = FRIDGE_VISION_USER_MESSAGE,
): Promise<string> {
  let base64Data: string;
  let mime = mimeType;

  if (imageInput.startsWith('http://') || imageInput.startsWith('https://')) {
    const res = await fetch(imageInput);
    if (!res.ok) {
      throw new Error(`FAILED_TO_FETCH_IMAGE:${res.status}`);
    }
    const buf = await res.arrayBuffer();
    const bytes = new Uint8Array(buf);
    let binary = '';
    for (let i = 0; i < bytes.byteLength; i++) {
      binary += String.fromCharCode(bytes[i]);
    }
    base64Data = btoa(binary);
    mime = res.headers.get('content-type') || mime;
  } else {
    base64Data = stripDataUrl(imageInput);
  }

  return await generateContent({
    systemInstruction: FRIDGE_VISION_SYSTEM_PROMPT,
    contents: [
      {
        role: 'user',
        parts: [
          { text: userText },
          { inline_data: { mime_type: mime, data: base64Data } },
        ],
      },
    ],
    responseJson: true,
    temperature: 0.1,
  });
}

/**
 * Parses model output into a deduplicated Arabic ingredient list.
 * Accepts raw JSON array or fenced ```json blocks or wrapped JSON objects.
 */
export function parseIngredientArray(raw: string): string[] {
  let text = raw.trim();

  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/i);
  if (fenced?.[1]) {
    text = fenced[1].trim();
  }

  const startArr = text.indexOf('[');
  const endArr = text.lastIndexOf(']');
  if (startArr >= 0 && endArr > startArr) {
    text = text.slice(startArr, endArr + 1);
  }

  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    try {
      parsed = JSON.parse(raw.trim());
    } catch {
      throw new Error('VISION_INVALID_SHAPE');
    }
  }

  let items: unknown[] | null = null;
  if (Array.isArray(parsed)) {
    items = parsed;
  } else if (parsed && typeof parsed === 'object') {
    const obj = parsed as Record<string, unknown>;
    if (Array.isArray(obj.ingredients)) {
      items = obj.ingredients;
    } else if (Array.isArray(obj.items)) {
      items = obj.items;
    }
  }

  if (!items) {
    throw new Error('VISION_INVALID_SHAPE');
  }

  const ingredients: string[] = [];
  const seen = new Set<string>();

  for (const item of items) {
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
