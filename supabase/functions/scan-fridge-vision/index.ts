import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  analyzeFridgeImage,
  parseIngredientArray,
} from '../_shared/vision-client.ts';
import {
  approxBase64Bytes,
  stripDataUrl,
} from '../_shared/gemini-client.ts';
import { FRIDGE_VISION_USER_MESSAGE } from '../_shared/prompts/fridge-vision.ts';
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

const MAX_IMAGE_BYTES = 2 * 1024 * 1024;

type ScanRequest = {
  image_url?: string;
  image_base64?: string;
  mime_type?: string;
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

    const body = (await req.json()) as ScanRequest;
    if (!body.image_url && !body.image_base64) {
      return json({ error: 'image_url or image_base64 is required' }, 400);
    }

    if (
      body.image_base64 &&
      typeof body.image_base64 === 'string' &&
      approxBase64Bytes(body.image_base64) > MAX_IMAGE_BYTES
    ) {
      return json({ error: 'IMAGE_TOO_LARGE' }, 413);
    }

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
    if (!allowed) {
      return json(
        {
          error: 'SCAN_LIMIT_REACHED',
          message: 'Daily meal scan limit reached.',
        },
        429,
      );
    }

    const imageUrl = await resolveImageUrl(body, userClient, user.id);
    const imageInput = body.image_base64 ?? imageUrl!;
    const mime = body.mime_type ?? 'image/jpeg';

    const raw = await analyzeFridgeImage(imageInput, mime, FRIDGE_VISION_USER_MESSAGE);
    let ingredients: string[] = [];
    try {
      ingredients = parseIngredientArray(raw);
    } catch {
      return json({ error: 'VISION_PARSE_FAILED', raw }, 502);
    }

    const { data: scanRow, error: insertError } = await userClient
      .from('fridge_scans')
      .insert({
        user_id: user.id,
        image_url: imageUrl ?? 'inline-base64',
        detected_items: ingredients,
        confirmed_items: [],
      })
      .select('id, detected_items, created_at')
      .single();

    if (insertError) {
      return json({ error: insertError.message }, 500);
    }

    const remaining = premium
      ? null
      : Math.max(0, limit - (await countDailyUsage(adminClient, user.id, 'meal_scan')));

    return json({
      scan_id: scanRow.id,
      ingredients,
      remaining_scans: remaining,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    console.error('[scan-fridge-vision]', message);
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

async function countDailyUsage(
  admin: ReturnType<typeof createClient>,
  userId: string,
  kind: string,
): Promise<number> {
  const day = new Date().toISOString().slice(0, 10);
  const { data } = await admin
    .from('ai_usage')
    .select('count')
    .eq('user_id', userId)
    .eq('day', day)
    .eq('kind', kind)
    .maybeSingle();

  return (data?.count as number | undefined) ?? 0;
}

async function resolveImageUrl(
  body: ScanRequest,
  client: ReturnType<typeof createClient>,
  userId: string,
): Promise<string | null> {
  if (body.image_url) return body.image_url;

  if (body.image_base64) {
    const mime = body.mime_type ?? 'image/jpeg';
    try {
      const cleanBase64 = stripDataUrl(body.image_base64);
      const binaryStr = atob(cleanBase64);
      const bytes = new Uint8Array(binaryStr.length);
      for (let i = 0; i < binaryStr.length; i++) {
        bytes[i] = binaryStr.charCodeAt(i);
      }
      const path = `${userId}/${crypto.randomUUID()}.jpg`;

      const { error } = await client.storage
        .from('fridge-scans')
        .upload(path, bytes, {
          contentType: mime,
          upsert: false,
        });

      if (!error) {
        const { data } = client.storage
          .from('fridge-scans')
          .getPublicUrl(path);
        return data.publicUrl;
      }
      console.warn('[scan-fridge-vision] storage upload failed:', error.message);
    } catch (e) {
      console.warn('[scan-fridge-vision] storage upload exception:', e);
    }
  }

  return null;
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
