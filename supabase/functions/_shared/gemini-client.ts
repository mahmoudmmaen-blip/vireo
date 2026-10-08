const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY') ?? '';
const GEMINI_MODEL = Deno.env.get('GEMINI_MODEL') ?? 'gemini-3.5-flash';
const TIMEOUT_MS = 30_000;

export type GeminiPart =
  | { text: string }
  | { inline_data: { mime_type: string; data: string } };

export type GeminiContent = {
  role: 'user' | 'model';
  parts: GeminiPart[];
};

export type GeminiGenerateOptions = {
  contents: GeminiContent[];
  systemInstruction?: string;
  responseJson?: boolean;
  temperature?: number;
};

/**
 * Calls Gemini REST `generateContent` with fetch (no SDK).
 */
export async function generateContent(
  options: GeminiGenerateOptions,
): Promise<string> {
  if (!GEMINI_API_KEY) {
    throw new Error('GEMINI_NOT_CONFIGURED');
  }

  const model = GEMINI_MODEL;
  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent` +
    `?key=${encodeURIComponent(GEMINI_API_KEY)}`;

  const body: Record<string, unknown> = {
    contents: options.contents,
    generationConfig: {
      temperature: options.temperature ?? 0.2,
      ...(options.responseJson
        ? { responseMimeType: 'application/json' }
        : {}),
    },
  };

  if (options.systemInstruction) {
    body.systemInstruction = {
      parts: [{ text: options.systemInstruction }],
    };
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), TIMEOUT_MS);

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
      signal: controller.signal,
    });

    if (!response.ok) {
      throw new Error(`GEMINI_API_ERROR:${response.status}`);
    }

    const payload = await response.json();
    const text = payload?.candidates?.[0]?.content?.parts
      ?.map((p: { text?: string }) => p.text ?? '')
      .join('')
      ?.trim();

    if (typeof text !== 'string' || text.length === 0) {
      throw new Error('GEMINI_EMPTY_RESPONSE');
    }

    return text;
  } finally {
    clearTimeout(timer);
  }
}

export function stripDataUrl(base64: string): string {
  const trimmed = base64.trim();
  const comma = trimmed.indexOf(',');
  if (trimmed.startsWith('data:') && comma >= 0) {
    return trimmed.slice(comma + 1);
  }
  return trimmed;
}

/** Approximate decoded byte length of a base64 string. */
export function approxBase64Bytes(base64: string): number {
  const clean = stripDataUrl(base64).replace(/\s/g, '');
  return Math.floor((clean.length * 3) / 4);
}
