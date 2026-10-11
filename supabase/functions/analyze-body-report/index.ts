import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  approxBase64Bytes,
  generateContent,
  stripDataUrl,
} from '../_shared/gemini-client.ts';
import { bodyReportPrompt } from '../_shared/prompts/body-report.ts';
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

type AnalyzeBodyRequest = {
  image_base64?: string;
  mime_type?: string;
  language?: string;
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return json({ ok: true }, 200);

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

    const body = (await req.json()) as AnalyzeBodyRequest;
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
      'body_report',
      limit,
    );
    if (!allowed) return json({ error: 'DAILY_LIMIT' }, 429);

    const mime = body.mime_type ?? 'image/jpeg';
    const data = stripDataUrl(body.image_base64);
    const prompt = bodyReportPrompt({ language: body.language });

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

    return json(obj);
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    console.error('[analyze-body-report]', message);
    if (message === 'GEMINI_NOT_CONFIGURED') {
      return json({ error: message }, 503);
    }
    if (/abort/i.test(message) || message.startsWith('GEMINI_API_ERROR:')) {
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
