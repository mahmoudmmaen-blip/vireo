import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import { generateContent, type GeminiContent } from '../_shared/gemini-client.ts';
import { buildCoachSystemInstruction } from '../_shared/prompts/coach.ts';
import {
  coachChatLimit,
  consumeDailyQuota,
  hasPremiumEntitlement,
} from '../_shared/ai-usage.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

type HistoryItem = { role?: string; content?: string };

type CoachRequest = {
  history?: HistoryItem[];
  message?: string;
  context?: {
    remainingCalories?: number;
    remainingProtein?: number;
    targetCalories?: number;
    targetProtein?: number;
    currentWeight?: number;
    goal?: string;
    inbodySummary?: string;
  };
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

    const body = (await req.json()) as CoachRequest;
    const message = body.message?.trim() ?? '';
    if (!message) {
      return json({ error: 'message is required' }, 400);
    }

    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const premium = await hasPremiumEntitlement(adminClient, user.id);
    const isAnonymous = user.is_anonymous === true;
    const limit = coachChatLimit({ premium, isAnonymous });
    const allowed = await consumeDailyQuota(
      adminClient,
      user.id,
      'coach_chat',
      limit,
    );
    if (!allowed) {
      return json({ error: 'DAILY_LIMIT' }, 429);
    }

    const ctx = body.context ?? {};
    const systemInstruction = buildCoachSystemInstruction({
      remainingCalories: Number(ctx.remainingCalories ?? 0),
      remainingProtein: Number(ctx.remainingProtein ?? 0),
      targetCalories: Number(ctx.targetCalories ?? 0),
      targetProtein: Number(ctx.targetProtein ?? 0),
      currentWeight: Number(ctx.currentWeight ?? 0),
      goal: String(ctx.goal ?? ''),
      inbodySummary:
        typeof ctx.inbodySummary === 'string' ? ctx.inbodySummary : undefined,
      language: body.language,
    });

    const history = (body.history ?? [])
      .filter((h) => typeof h.content === 'string' && h.content.trim().length > 0)
      .slice(-20);

    const contents: GeminiContent[] = history.map((h) => ({
      role: h.role === 'assistant' || h.role === 'model' ? 'model' : 'user',
      parts: [{ text: String(h.content) }],
    }));

    contents.push({
      role: 'user',
      parts: [{ text: message }],
    });

    const reply = await generateContent({
      contents,
      systemInstruction,
      temperature: 0.7,
    });

    return json({ reply });
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

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
