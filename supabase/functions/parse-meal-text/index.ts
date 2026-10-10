import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import { generateContent } from '../_shared/gemini-client.ts';
import {
  mealTextPrompt,
  unmatchedFoodMacrosPrompt,
} from '../_shared/prompts/meal-vision.ts';
import {
  consumeDailyQuota,
  hasPremiumEntitlement,
  mealScanLimit,
} from '../_shared/ai-usage.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

type ParseMealTextRequest = {
  text?: string;
  language?: string;
  mode?: 'parse' | 'estimate_macros';
  items?: Array<{ name_ar?: string; name_en?: string }>;
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return json({ ok: true }, 200);
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return json({ error: 'Unauthorized' }, 401);

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY')!;
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

    const userClient = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const {
      data: { user },
      error: userError,
    } = await userClient.auth.getUser();
    if (userError || !user) return json({ error: 'Unauthorized' }, 401);

    const body = (await req.json()) as ParseMealTextRequest;

    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const premium = await hasPremiumEntitlement(adminClient, user.id);
    const isAnonymous = user.is_anonymous === true;
    const limit = mealScanLimit({ premium, isAnonymous });
    const allowed = await consumeDailyQuota(
      adminClient,
      user.id,
      'meal_scan',
      limit,
    );
    if (!allowed) return json({ error: 'DAILY_LIMIT' }, 429);

    if (body.mode === 'estimate_macros') {
      const list = (body.items ?? [])
        .map((i) => ({
          name_ar: i.name_ar ?? '',
          name_en: i.name_en ?? '',
        }))
        .filter((i) => i.name_en || i.name_ar);
      if (list.length === 0) return json({ error: 'items required' }, 400);
      const raw = await generateContent({
        contents: [
          {
            role: 'user',
            parts: [{ text: unmatchedFoodMacrosPrompt(list) }],
          },
        ],
        responseJson: true,
        temperature: 0.1,
      });
      const parsed = safeJson(raw);
      return json(parsed ?? { estimates: [] });
    }

    const text = body.text?.trim() ?? '';
    if (text.length < 2) return json({ error: 'text is required' }, 400);

    const raw = await generateContent({
      contents: [
        {
          role: 'user',
          parts: [
            {
              text: mealTextPrompt({ text, language: body.language }),
            },
          ],
        },
      ],
      responseJson: true,
      temperature: 0.1,
    });

    const parsed = safeJson(raw);
    const items = (parsed as { items?: unknown } | null)?.items;
    if (!Array.isArray(items) || items.length === 0) {
      return json({ error: 'VISION_PARSE_FAILED', raw }, 502);
    }

    return json({ items });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    console.error('[parse-meal-text]', message);
    if (message === 'GEMINI_NOT_CONFIGURED') {
      return json({ error: message }, 503);
    }
    if (message.startsWith('GEMINI_API_ERROR:')) {
      return json({ error: message }, 502);
    }
    return json({ error: message }, 500);
  }
});

function safeJson(raw: string): unknown | null {
  try {
    let t = raw.trim();
    const start = t.indexOf('{');
    const end = t.lastIndexOf('}');
    if (start >= 0 && end > start) t = t.slice(start, end + 1);
    return JSON.parse(t);
  } catch {
    return null;
  }
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
