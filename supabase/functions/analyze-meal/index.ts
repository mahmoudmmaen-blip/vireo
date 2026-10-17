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
  getAccountCreatedAt,
  hasPremiumEntitlement,
  installDayAgeFrom,
  mealScanLimit,
} from '../_shared/ai-usage.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

const MAX_IMAGE_BYTES = 2 * 1024 * 1024;

// In-memory cache for duplicate image re-analysis (P36: same photo => same
// result for 24 h unless the user taps "حلّل تاني" => forceReanalyze).
// key: "userId:mode:language:hint:hash", val: {timestamp, result}
const CACHE_TTL_MS = 24 * 60 * 60 * 1000;
const CACHE_MAX_ENTRIES = 500;
const recentAnalysesCache = new Map<string, { timestamp: number; result: unknown }>();

function pruneCache(now: number) {
  if (recentAnalysesCache.size < CACHE_MAX_ENTRIES) return;
  for (const [k, v] of recentAnalysesCache) {
    if (now - v.timestamp >= CACHE_TTL_MS) recentAnalysesCache.delete(k);
  }
  // Still too big: drop the oldest entries (Map keeps insertion order).
  while (recentAnalysesCache.size >= CACHE_MAX_ENTRIES) {
    const oldest = recentAnalysesCache.keys().next().value;
    if (oldest === undefined) break;
    recentAnalysesCache.delete(oldest);
  }
}

function cacheResult(key: string, result: unknown) {
  const now = Date.now();
  pruneCache(now);
  // delete first so re-analysis moves the entry to the newest position
  recentAnalysesCache.delete(key);
  recentAnalysesCache.set(key, { timestamp: now, result });
}

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
  plate_diameter_cm?: number;
  /** true => skip the 24 h image-hash cache ("حلّل تاني"). */
  forceReanalyze?: boolean;
  force_reanalyze?: boolean;
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

    // 24 h duplicate-photo cache by image hash (P36: stable results).
    // Skipped when the client sends forceReanalyze (body flag or ?forceReanalyze=true).
    const url = new URL(req.url);
    const forceReanalyze = body.forceReanalyze === true ||
      body.force_reanalyze === true ||
      url.searchParams.get('forceReanalyze') === 'true';
    const imageHash = await computeImagesHash(rawImages);
    const cacheKey = [
      user.id,
      body.mode ?? 'meal',
      body.language ?? '',
      (body.user_hint ?? '').trim().toLowerCase(),
      imageHash,
    ].join(':');
    const cached = recentAnalysesCache.get(cacheKey);
    if (!forceReanalyze && cached && Date.now() - cached.timestamp < CACHE_TTL_MS) {
      console.log(`[analyze-meal] duplicate photo within 24h for user ${user.id}, returning cached result`);
      const base = cached.result && typeof cached.result === 'object'
        ? cached.result as Record<string, unknown>
        : {};
      return json({
        ...base,
        cached: true,
        cached_at: new Date(cached.timestamp).toISOString(),
      });
    }
    if (forceReanalyze) {
      console.log(`[analyze-meal] forceReanalyze for user ${user.id}, skipping cache`);
    }

    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const premium = await hasPremiumEntitlement(adminClient, user.id, user.email);
    const isAnonymous = user.is_anonymous === true;
    const isBodyReport = body.mode === 'body_report';
    const quotaBucket = isBodyReport ? 'body_report' : 'meal_scan';
    // P40: free accounts get 5 scans/day during their first 7 days, then 3.
    // The age comes from the auth user's created_at (server truth, not the client).
    let installDayAge: number | null = null;
    if (!isBodyReport && !premium && !isAnonymous) {
      installDayAge = installDayAgeFrom(
        await getAccountCreatedAt(adminClient, user),
      );
    }
    const limit = isBodyReport
      ? bodyReportLimit({ premium })
      : mealScanLimit({ premium, isAnonymous, installDayAge });

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

    const plateDiameterCm = body.plate_diameter_cm ? Number(body.plate_diameter_cm) : undefined;
    const prompt = mealVisionPrompt({
      remainingCalories,
      remainingProtein,
      language: body.language,
      userHint: (body.user_hint ?? '') + multiPhotoInstruction,
      plateDiameterCm,
    });

    const imageParts = rawImages.map((img) => ({
      inline_data: { mime_type: mime, data: stripDataUrl(img) },
    }));

    const fastVisionModel =
      Deno.env.get('FAST_VISION_MODEL') ?? 'gemini-2.5-flash';
    const strongVisionModel =
      Deno.env.get('STRONG_VISION_MODEL') ?? 'gemini-2.5-pro';

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
        modelOverride: fastVisionModel,
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

      // Strip any personal identifiers server-side
      delete (obj as Record<string, unknown>).id_number;
      delete (obj as Record<string, unknown>).national_id;
      delete (obj as Record<string, unknown>).name;
      delete (obj as Record<string, unknown>).phone;
      delete (obj as Record<string, unknown>).patient_name;
      delete (obj as Record<string, unknown>).user_name;

      // Successful body report analysis: consume quota now
      await consumeDailyQuota(adminClient, user.id, quotaBucket, limit);
      cacheResult(cacheKey, obj);
      return json(obj);
    }

    const itemSchema = {
      type: 'OBJECT',
      properties: {
        name_ar: { type: 'STRING' },
        name_en: { type: 'STRING' },
        food_id_guess: { type: 'STRING', nullable: true },
        estimated_grams: { type: 'NUMBER' },
        grams_low: { type: 'NUMBER' },
        grams_high: { type: 'NUMBER' },
        cooking_method: {
          type: 'STRING',
          enum: [
            'boiled',
            'grilled',
            'fried',
            'baked',
            'raw',
            'steamed',
            'sauteed',
            'oven',
            'mahshi',
            'air_fried',
            'other',
          ],
        },
        confidence: { type: 'NUMBER' },
        visible_oil_or_sauce: { type: 'BOOLEAN' },
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
      maxOutputTokens: 1400,
      responseSchema: mealSchema,
      temperature: 0.1,
    });

    const elapsedMs = Date.now() - startTime;
    console.log(`[analyze-meal] pass 1 (${fastVisionModel}) completed in ${elapsedMs}ms`);

    let parsed = parseItemsJson(raw);
    if (!parsed) {
      return json({ error: 'VISION_PARSE_FAILED', raw }, 502);
    }

    // Evaluate overall confidence across recognized items
    const allItems = [...(parsed.items ?? []), ...(parsed.items_unsure ?? [])];
    const avgConfidence = allItems.length > 0
      ? allItems.reduce((sum, item) => sum + (Number(item.confidence) || 0), 0) / allItems.length
      : 0;

    // Escalation (P34 section 1.6):
    // If overall confidence < 0.5, re-run once with a stronger model with thinking budget enabled
    if (avgConfidence < 0.5 || allItems.length === 0) {
      console.log(`[analyze-meal] avg confidence ${avgConfidence.toFixed(2)} < 0.5, escalating to ${strongVisionModel} with thinking budget`);
      const escalateStart = Date.now();
      try {
        const strongRaw = await generateContent({
          modelOverride: strongVisionModel,
          contents: [
            {
              role: 'user',
              parts: [
                {
                  text: prompt +
                    '\nNOTE: Initial visual pass had low confidence (<0.5). Re-examine plate carefully with deep reasoning, verifying all ingredients, portion sizes and cooking methods.',
                },
                ...imageParts,
              ],
            },
          ],
          responseJson: true,
          thinkingBudget: 1024,
          maxOutputTokens: 2048,
          responseSchema: mealSchema,
          temperature: 0.1,
        });
        const strongElapsed = Date.now() - escalateStart;
        console.log(`[analyze-meal] escalation pass completed in ${strongElapsed}ms`);
        const strongParsed = parseItemsJson(strongRaw);
        if (strongParsed && (strongParsed.items.length > 0 || strongParsed.items_unsure.length > 0)) {
          parsed = strongParsed;
          (parsed as Record<string, unknown>).escalated = true;
          (parsed as Record<string, unknown>).escalated_model = strongVisionModel;
        }
      } catch (escErr) {
        console.warn('[analyze-meal] escalation failed, falling back to pass 1 result', escErr);
      }
    }

    const hasConfirmedItems = parsed.items && parsed.items.length > 0;
    const hasUnsureItems = parsed.items_unsure && parsed.items_unsure.length > 0;

    // Consume quota ONLY if there is at least 1 confirmed or unsure item
    if (hasConfirmedItems || hasUnsureItems) {
      await consumeDailyQuota(adminClient, user.id, quotaBucket, limit);
      cacheResult(cacheKey, parsed);
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
