/**
 * Model router: vision → Gemini; coach / weekly review / rebalance explain →
 * Anthropic Claude when ANTHROPIC_API_KEY is set, else Gemini.
 * Never log or return API key values.
 */

import { generateContent, type GeminiContent } from './gemini-client.ts';

const ANTHROPIC_API_KEY = Deno.env.get('ANTHROPIC_API_KEY') ?? '';
const CLAUDE_MODEL = Deno.env.get('CLAUDE_MODEL') ?? 'claude-sonnet-4-20250514';
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY') ?? '';

export type AiTask =
  | 'vision'
  | 'coach_chat'
  | 'weekly_review'
  | 'rebalance_explain';

export type ProviderHealth = {
  gemini: boolean;
  anthropic: boolean;
  /** Active provider names only — never key material. */
  active: string[];
};

export function providerHealth(): ProviderHealth {
  const gemini = Boolean(GEMINI_API_KEY);
  const anthropic = Boolean(ANTHROPIC_API_KEY);
  const active: string[] = [];
  if (gemini) active.push('gemini');
  if (anthropic) active.push('anthropic');
  return { gemini, anthropic, active };
}

export function resolveProvider(task: AiTask): 'gemini' | 'anthropic' {
  if (task === 'vision') return 'gemini';
  if (ANTHROPIC_API_KEY) return 'anthropic';
  return 'gemini';
}

export type RouterGenerateOptions = {
  task: AiTask;
  systemInstruction: string;
  userText: string;
  /** Optional multimodal for vision only. */
  contents?: GeminiContent[];
  temperature?: number;
  maxOutputTokens?: number;
};

/**
 * Extract integers/decimals from text for fact validation.
 */
export function extractNumbers(text: string): number[] {
  const matches = text.match(/-?\d+(?:[.,]\d+)?/g) ?? [];
  return matches.map((m) => Number(m.replace(',', '.'))).filter((n) => Number.isFinite(n));
}

/**
 * Every number in [reply] must appear in [allowedFacts] (within 1 for rounding).
 * Returns false if the model invented a number.
 */
export function validateNumbersAgainstFacts(
  reply: string,
  allowedFacts: number[],
): boolean {
  const found = extractNumbers(reply);
  if (found.length === 0) return true;
  return found.every((n) =>
    allowedFacts.some((f) => Math.abs(f - n) < 1.01 || Math.abs(f - n) / Math.max(1, Math.abs(f)) < 0.02),
  );
}

async function callClaude(options: {
  systemInstruction: string;
  userText: string;
  temperature?: number;
  maxOutputTokens?: number;
}): Promise<{ text: string; inputTokens: number; outputTokens: number }> {
  if (!ANTHROPIC_API_KEY) throw new Error('ANTHROPIC_NOT_CONFIGURED');

  const res = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      'x-api-key': ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: CLAUDE_MODEL,
      max_tokens: options.maxOutputTokens ?? 1024,
      temperature: options.temperature ?? 0.4,
      system: options.systemInstruction,
      messages: [{ role: 'user', content: options.userText }],
    }),
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`ANTHROPIC_HTTP_${res.status}:${body.slice(0, 200)}`);
  }

  const json = await res.json();
  const text = (json.content ?? [])
    .filter((c: { type?: string }) => c.type === 'text')
    .map((c: { text?: string }) => c.text ?? '')
    .join('\n')
    .trim();
  const inputTokens = Number(json.usage?.input_tokens ?? 0);
  const outputTokens = Number(json.usage?.output_tokens ?? 0);
  return { text, inputTokens, outputTokens };
}

export type RouterResult = {
  text: string;
  provider: 'gemini' | 'anthropic';
  inputTokens: number;
  outputTokens: number;
};

export async function routeGenerate(
  options: RouterGenerateOptions,
): Promise<RouterResult> {
  const provider = resolveProvider(options.task);

  if (provider === 'anthropic') {
    try {
      const r = await callClaude({
        systemInstruction: options.systemInstruction,
        userText: options.userText,
        temperature: options.temperature,
        maxOutputTokens: options.maxOutputTokens,
      });
      return {
        text: r.text,
        provider: 'anthropic',
        inputTokens: r.inputTokens,
        outputTokens: r.outputTokens,
      };
    } catch (_) {
      // Fall through to Gemini.
    }
  }

  const contents = options.contents ?? [
    { role: 'user' as const, parts: [{ text: options.userText }] },
  ];
  const text = await generateContent({
    contents,
    systemInstruction: options.systemInstruction,
    temperature: options.temperature,
    maxOutputTokens: options.maxOutputTokens,
  });
  return {
    text,
    provider: 'gemini',
    inputTokens: 0,
    outputTokens: 0,
  };
}
