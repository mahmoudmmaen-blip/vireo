import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  approxBase64Bytes,
  generateContent,
  stripDataUrl,
} from '../_shared/gemini-client.ts';
import { mealVisionPrompt } from '../_shared/prompts/meal-vision.ts';
import {
  consumeDailyQuota,
  hasPremiumEntitlement,
  mealScanLimit,
} from '../_shared/ai-usage.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

const MAX_IMAGE_BYTES = 2 * 1024 * 1024;

type AnalyzeMealRequest = {
  image_base64?: string;
  mime_type?: string;
  remaining_calories?: number;
  remaining_protein?: number;
  language?: string;
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
      return json({ error: 'Unauthorized' }, 401);
    }

    const body = (await req.json()) as AnalyzeMealRequest;
    if (!body.image_base64 || typeof body.image_base64 !== 'string') {
      return json({ error: 'image_base64 is required' }, 400);
    }

    if (approxBase64Bytes(body.image_base64) > MAX_IMAGE_BYTES) {
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
      return json({ error: 'DAILY_LIMIT' }, 429);
    }

    const remainingCalories = Number(body.remaining_calories ?? 0);
    const remainingProtein = Number(body.remaining_protein ?? 0);
    const mime = body.mime_type ?? 'image/jpeg';
    const data = stripDataUrl(body.image_base64);

    const prompt = mealVisionPrompt({
      remainingCalories,
      remainingProtein,
      language: body.language,
    });

    const raw = await generateContent({
      contents: [
        {
          role: 'user',
          parts: [
            { text: prompt },
            { inline_data: { mime_type: mime, data } },
          ],
        },
      ],
      responseJson: true,
      temperature: 0.2,
    });

    const parsed = parseMealJson(raw);
    if (!parsed) {
      return json({ error: 'VISION_PARSE_FAILED', raw }, 502);
    }

    return json(parsed);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    if (message === 'GEMINI_NOT_CONFIGURED') {
      return json({ error: message }, 503);
    }
    if (message.startsWith('GEMINI_API_ERROR:')) {
      return json({ error: message }, 502);
    }
    if (message === 'GEMINI_EMPTY_RESPONSE') {
      return json({ error: message }, 502);
    }
    return json({ error: message }, 500);
  }
});

function parseMealJson(raw: string): Record<string, unknown> | null {
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
    return decoded as Record<string, unknown>;
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
