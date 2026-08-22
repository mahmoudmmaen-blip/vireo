import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  analyzeFridgeImage,
  parseIngredientArray,
} from '../_shared/vision-client.ts';
import { FRIDGE_VISION_USER_MESSAGE } from '../_shared/prompts/fridge-vision.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

const BASIC_MONTHLY_SCAN_LIMIT = 5;

type ScanRequest = {
  image_url?: string;
  image_base64?: string;
  mime_type?: string;
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
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
      return json({ error: 'Unauthorized' }, 401);
    }

    const body = (await req.json()) as ScanRequest;
    const imageUrl = await resolveImageUrl(body, userClient, user.id);
    if (!imageUrl) {
      return json({ error: 'image_url or image_base64 is required' }, 400);
    }

    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const premium = await hasPremiumEntitlement(adminClient, user.id);
    if (!premium) {
      const allowed = await checkBasicScanQuota(adminClient, user.id);
      if (!allowed) {
        return json(
          {
            error: 'SCAN_LIMIT_REACHED',
            message: 'Monthly fridge scan limit reached. Upgrade for unlimited scans.',
          },
          429,
        );
      }
    }

    const raw = await analyzeFridgeImage(imageUrl, FRIDGE_VISION_USER_MESSAGE);
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
        image_url: body.image_url ?? 'inline-base64',
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
      : Math.max(0, BASIC_MONTHLY_SCAN_LIMIT - (await countScansThisMonth(adminClient, user.id)));

    return json({
      scan_id: scanRow.id,
      ingredients,
      remaining_scans: remaining,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return json({ error: message }, 500);
  }
});

async function resolveImageUrl(
  body: ScanRequest,
  client: ReturnType<typeof createClient>,
  userId: string,
): Promise<string | null> {
  if (body.image_url) return body.image_url;

  if (body.image_base64) {
    const mime = body.mime_type ?? 'image/jpeg';
    const bytes = Uint8Array.from(atob(body.image_base64), (c) => c.charCodeAt(0));
    const path = `${userId}/${crypto.randomUUID()}.jpg`;

    const { error } = await client.storage.from('fridge-scans').upload(path, bytes, {
      contentType: mime,
      upsert: false,
    });
    if (error) throw new Error(error.message);

    const { data } = client.storage.from('fridge-scans').getPublicUrl(path);
    return data.publicUrl;
  }

  return null;
}

async function hasPremiumEntitlement(
  admin: ReturnType<typeof createClient>,
  userId: string,
): Promise<boolean> {
  const { data } = await admin
    .from('users')
    .select('subscription_tier')
    .eq('id', userId)
    .maybeSingle();

  return data?.subscription_tier === 'premium';
}

async function countScansThisMonth(
  admin: ReturnType<typeof createClient>,
  userId: string,
): Promise<number> {
  const start = new Date();
  start.setUTCDate(1);
  start.setUTCHours(0, 0, 0, 0);

  const { count } = await admin
    .from('fridge_scans')
    .select('id', { count: 'exact', head: true })
    .eq('user_id', userId)
    .gte('created_at', start.toISOString());

  return count ?? 0;
}

async function checkBasicScanQuota(
  admin: ReturnType<typeof createClient>,
  userId: string,
): Promise<boolean> {
  const used = await countScansThisMonth(admin, userId);
  return used < BASIC_MONTHLY_SCAN_LIMIT;
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
