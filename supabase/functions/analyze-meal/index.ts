import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  approxBase64Bytes,
  generateContent,
  stripDataUrl,
} from '../_shared/gemini-client.ts';
import { mealVisionPrompt } from '../_shared/prompts/meal-vision.ts';
import { bodyReportPrompt } from '../_shared/prompts/body-report.ts';
import {
  bodyReportLimit,
  checkDailyQuota,
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

const MAX_IMAGE_BYTES = 2 * 1024 * 1024;

// In-memory cache for 10-minute duplicate image retry (key: "userId:hash", val: {timestamp, result})
const recentAnalysesCache = new Map<string, { timestamp: number; result: unknown }>();

async function computeImagesHash(images: string[]): Promise<string> {
  const encoder = new TextEncoder();
  const joined = images.map((img) => stripDataUrl(img)).join('|');
  const buffer = await crypto.subtle.digest('SHA-256', encoder.encode(joined));
  const hashArray = Array.from(new Uint8Array(buffer));
  return hashArray.map((b) => b.toString(16).padStart(2, '0')).join('');
}

type AnalyzeMealRequest = {
  mode?: string;
  image_base64?: string;
  images?: string[];
  mime_type?: string;
  remaining_calories?: number;
  remaining_protein?: number;
  language?: string;
  user_hint?: string;
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return json({ ok: true }, 200);
  }

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return json({ error: 'Unauthorized' }, 401);
    }

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

    if (userError || !user) {
      return json({ error: 'Unauthorized', detail: userError?.message }, 401);
    }

    const body = (await req.json()) as AnalyzeMealRequest;
    
    // Normalize images: accept images: string[] (max 5) or single image_base64
    const rawImages: string[] = [];
    if (Array.isArray(body.images) && body.images.length > 0) {
      rawImages.push(...body.images.slice(0, 5));
    } else if (body.image_base64 && typeof body.image_base64 === 'string') {
      rawImages.push(body.image_base64);
    }

    if (rawImages.length === 0) {
      return json({ error: 'image_base64 or images array is required' }, 400);
    }

    for (const img of rawImages) {
      if (approxBase64Bytes(img) > MAX_IMAGE_BYTES) {
        return json({ error: 'IMAGE_TOO_LARGE' }, 413);
      }
    }

    // Check for 10-minute duplicate retry by image hash
    const imageHash = await computeImagesHash(rawImages);
    const cacheKey = `${user.id}:${imageHash}`;
    const cached = recentAnalysesCache.get(cacheKey);
    if (cached && Date.now() - cached.timestamp < 10 * 60 * 1000) {
      console.log(`[analyze-meal] duplicate photo within 10min for user ${user.id}, returning cached result`);
      return json(cached.result);
    }

    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const premium = await hasPremiumEntitlement(adminClient, user.id, user.email);
    const isAnonymous = user.is_anonymous === true;
    const isBodyReport = body.mode === 'body_report';
    const quotaBucket = isBodyReport ? 'body_report' : 'meal_scan';
    const limit = isBodyReport
      ? bodyReportLimit({ premium })
      : mealScanLimit({ premium, isAnonymous });

    // Pre-check quota without consuming yet
    const { allowed } = await checkDailyQuota(
      adminClient,
      user.id,
      quotaBucket,
      limit,
    );
    if (!allowed) {
      return json({ error: 'DAILY_LIMIT' }, 429);
    }

    const remainingCalories = Number(body.remaining_calories ?? 0);
    const remainingProtein = Number(body.remaining_protein ?? 0);
    const mime = body.mime_type ?? 'image/jpeg';

    const multiPhotoInstruction = rawImages.length > 1
      ? '\nNOTE: These photos show the SAME meal from different angles; do not double count.\n'
      : '';

    const prompt = mealVisionPrompt({
      remainingCalories,
      remainingProtein,
      language: body.language,
      userHint: (body.user_hint ?? '') + multiPhotoInstruction,
    });

    const imageParts = rawImages.map((img) => ({
      inline_data: { mime_type: mime, data: stripDataUrl(img) },
    }));

    if (body.mode === 'body_report') {
      const prompt = bodyReportPrompt({ language: body.language });
      const raw = await generateContent({
        contents: [
          {
            role: 'user',
            parts: [
              { text: prompt },
              ...imageParts,
            ],
          },
        ],
        responseJson: true,
        temperature: 0.1,
      });

      const parsed = safeJson(raw);
      if (!parsed || typeof parsed !== 'object') {
        return json({ error: 'VISION_PARSE_FAILED', raw }, 502);
      }
      const obj = parsed as Record<string, unknown>;
      if (obj.readable === false) {
        return json({ error: 'UNREADABLE', ...obj }, 422);
      }

      // Successful body report analysis: consume quota now
      await consumeDailyQuota(adminClient, user.id, quotaBucket, limit);
      recentAnalysesCache.set(cacheKey, { timestamp: Date.now(), result: obj });
      return json(obj);
    }

    const fastVisionModel =
      Deno.env.get('FAST_VISION_MODEL') ?? 'gemini-2.5-flash';

    const itemSchema = {
      type: 'OBJECT',
      properties: {
        name_ar: { type: 'STRING' },
        name_en: { type: 'STRING' },
        food_id_guess: { type: 'STRING', nullable: true },
        estimated_grams: { type: 'NUMBER' },
        cooking_method: {
          type: 'STRING',
          enum: ['boiled', 'grilled', 'fried', 'baked', 'raw', 'steamed', 'other'],
        },
        confidence: { type: 'NUMBER' },
      },
      required: ['name_ar', 'name_en', 'estimated_grams', 'cooking_method', 'confidence'],
    };

    const mealSchema = {
      type: 'OBJECT',
      properties: {
        items: {
          type: 'ARRAY',
          items: itemSchema,
        },
        items_unsure: {
          type: 'ARRAY',
          items: itemSchema,
        },
      },
      required: ['items'],
    };

    const startTime = Date.now();
    console.log(`[analyze-meal] starting vision analysis with model=${fastVisionModel}, imageCount=${rawImages.length}`);

    const raw = await generateContent({
      modelOverride: fastVisionModel,
      contents: [
        {
          role: 'user',
          parts: [
            { text: prompt },
            ...imageParts,
          ],
        },
      ],
      responseJson: true,
      thinkingBudget: 0,
      maxOutputTokens: 1200,
      responseSchema: mealSchema,
      temperature: 0.1,
    });

    const elapsedMs = Date.now() - startTime;
    console.log(`[analyze-meal] completed in ${elapsedMs}ms`);

    const parsed = parseItemsJson(raw);
    if (!parsed) {
      return json({ error: 'VISION_PARSE_FAILED', raw }, 502);
    }

    const hasConfirmedItems = parsed.items && parsed.items.length > 0;
    const hasUnsureItems = parsed.items_unsure && parsed.items_unsure.length > 0;

    // Consume quota ONLY if there is at least 1 confirmed or unsure item
    if (hasConfirmedItems || hasUnsureItems) {
      await consumeDailyQuota(adminClient, user.id, quotaBucket, limit);
      recentAnalysesCache.set(cacheKey, { timestamp: Date.now(), result: parsed });
    } else {
      console.log(`[analyze-meal] 0 items recognized, not consuming daily quota for user ${user.id}`);
    }

    return json(parsed);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    console.error('[analyze-meal]', message);
    if (message === 'GEMINI_NOT_CONFIGURED') {
      return json({ error: message }, 503);
    }
    if (/abort/i.test(message)) {
      return json({ error: 'GEMINI_API_ERROR:503:timeout' }, 503);
    }
    if (message.startsWith('GEMINI_API_ERROR:')) {
      const status = message.includes(':503:')
        ? 503
        : message.includes(':429:')
        ? 429
        : 502;
      return json({ error: message }, status);
    }
    if (message === 'GEMINI_EMPTY_RESPONSE') {
      return json({ error: message }, 502);
    }
    return json({ error: message }, 500);
  }
});

function parseItemsJson(
  raw: string,
): { items: unknown[]; items_unsure: unknown[] } | null {
  try {
    let text = raw.trim();
    const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/i);
    if (fenced?.[1]) text = fenced[1].trim();
    const start = text.indexOf('{');
    const end = text.lastIndexOf('}');
    if (start >= 0 && end > start) {
      text = text.slice(start, end + 1);
    }
    const decoded = JSON.parse(text);
    if (!decoded || typeof decoded !== 'object' || Array.isArray(decoded)) {
      return null;
    }
    const unsure = Array.isArray(
      (decoded as { items_unsure?: unknown }).items_unsure,
    )
      ? (decoded as { items_unsure: unknown[] }).items_unsure
      : [];
    const rawItems = (decoded as { items?: unknown }).items;
    const items = Array.isArray(rawItems) ? rawItems : [];

    if (items.length === 0 && unsure.length === 0) {
      const legacy = decoded as Record<string, unknown>;
      if (legacy.food_name) {
        return {
          items: [
            {
              name_ar: legacy.food_name,
              name_en: legacy.food_name,
              food_id_guess: null,
              estimated_grams: 200,
              cooking_method: 'other',
              confidence: 0.5,
              _legacy_calories: legacy.calories,
              _legacy_protein: legacy.protein,
              _legacy_carbs: legacy.carbs,
              _legacy_fats: legacy.fats,
            },
          ],
          items_unsure: [],
        };
      }
    }

    return { items, items_unsure: unsure };
  } catch {
    return null;
  }
}

function safeJson(raw: string): unknown {
  try {
    let text = raw.trim();
    const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/i);
    if (fenced?.[1]) text = fenced[1].trim();
    const start = text.indexOf('{');
    const end = text.lastIndexOf('}');
    if (start >= 0 && end > start) {
      text = text.slice(start, end + 1);
    }
    return JSON.parse(text);
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
