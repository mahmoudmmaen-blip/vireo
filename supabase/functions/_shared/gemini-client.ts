const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY') ?? '';
/** Prefer an explicit secret; fall back to a known-stable Flash id. */
const GEMINI_MODEL = Deno.env.get('GEMINI_MODEL') ?? 'gemini-3.8-flash';
/** Keep under Edge Function wall clock so model fallbacks can run. */
const TIMEOUT_MS = 28_000;

/** Tried in order when the primary model returns 404/503. */
const MODEL_FALLBACKS = [
  'gemini-3.8-flash',
  'gemini-3.5-flash',
  'gemini-2.5-flash',
  'gemini-flash-latest',
];

export type GeminiPart =
  | { text: string }
  | { inline_data: { mime_type: string; data: string } }
  | { inlineData: { mimeType: string; data: string } };

export type GeminiContent = {
  role: 'user' | 'model';
  parts: GeminiPart[];
};

export type GeminiGenerateOptions = {
  contents: GeminiContent[];
  systemInstruction?: string;
  responseJson?: boolean;
  temperature?: number;
  modelOverride?: string;
  thinkingBudget?: number;
  maxOutputTokens?: number;
  responseSchema?: Record<string, unknown>;
};

/**
 * Normalize image parts to the REST snake_case shape Gemini expects.
 */
function normalizeContents(contents: GeminiContent[]): GeminiContent[] {
  return contents.map((c) => ({
    role: c.role,
    parts: c.parts.map((p) => {
      if ('inlineData' in p && p.inlineData) {
        return {
          inline_data: {
            mime_type: p.inlineData.mimeType,
            data: p.inlineData.data,
          },
        };
      }
      return p;
    }),
  }));
}

/**
 * Calls Gemini REST `generateContent` with fetch (no SDK).
 * Retries alternate models on 404/503.
 */
export async function generateContent(
  options: GeminiGenerateOptions,
): Promise<string> {
  if (!GEMINI_API_KEY) {
    throw new Error('GEMINI_NOT_CONFIGURED');
  }

  const primary = options.modelOverride || GEMINI_MODEL;
  const models = [
    primary,
    ...MODEL_FALLBACKS.filter((m) => m !== primary),
  ];

  let lastError = 'GEMINI_EMPTY_RESPONSE';
  for (const model of models) {
    for (let attempt = 0; attempt < 2; attempt++) {
      try {
        return await callModel(model, options);
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e);
        lastError = msg;
        const retryable =
          msg.includes('GEMINI_API_ERROR:404') ||
          msg.includes('GEMINI_API_ERROR:503') ||
          msg.includes('GEMINI_API_ERROR:429');
        if (!retryable) throw e;
        console.warn(
          `[gemini] model=${model} attempt=${attempt + 1} failed: ${msg}`,
        );
        if (attempt === 0 && msg.includes(':503')) {
          await new Promise((r) => setTimeout(r, 1500));
          continue;
        }
        break;
      }
    }
  }
  throw new Error(lastError);
}

async function callModel(
  model: string,
  options: GeminiGenerateOptions,
): Promise<string> {
  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent` +
    `?key=${encodeURIComponent(GEMINI_API_KEY)}`;

  const body: Record<string, unknown> = {
    contents: normalizeContents(options.contents),
    generationConfig: {
      temperature: options.temperature ?? 0.2,
      ...(options.responseJson
        ? { responseMimeType: 'application/json' }
        : {}),
      ...(options.thinkingBudget !== undefined
        ? { thinkingConfig: { thinkingBudget: options.thinkingBudget } }
        : {}),
      ...(options.maxOutputTokens !== undefined
        ? { maxOutputTokens: options.maxOutputTokens }
        : {}),
      ...(options.responseSchema
        ? { responseSchema: options.responseSchema }
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

    const rawText = await response.text();
    if (!response.ok) {
      const snippet = rawText.slice(0, 500).replace(/\s+/g, ' ');
      throw new Error(`GEMINI_API_ERROR:${response.status}:${snippet}`);
    }

    let payload: Record<string, unknown>;
    try {
      payload = JSON.parse(rawText);
    } catch {
      throw new Error('GEMINI_EMPTY_RESPONSE');
    }

    const parts = (payload as {
      candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
    })?.candidates?.[0]?.content?.parts;

    const text = parts?.map((p) => p.text ?? '').join('')?.trim();

    if (typeof text !== 'string' || text.length === 0) {
      throw new Error('GEMINI_EMPTY_RESPONSE');
    }

    return text;
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    const name = e instanceof Error ? e.name : '';
    const aborted =
      name === 'AbortError' ||
      /abort/i.test(msg) ||
      (typeof DOMException !== 'undefined' &&
        e instanceof DOMException &&
        e.name === 'AbortError');
    if (aborted) {
      throw new Error('GEMINI_API_ERROR:503:timeout');
    }
    throw e;
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
