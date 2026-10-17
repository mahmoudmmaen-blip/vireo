import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import type { GeminiContent } from '../_shared/gemini-client.ts';
import {
  routeGenerate,
  validateNumbersAgainstFacts,
} from '../_shared/ai-router.ts';
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
    sex?: string;
    isPregnancy?: boolean;
    isUnder18?: boolean;
    stepGoal?: number;
    recentSummary?: string;
    activePlan?: string;
    fastingState?: string;
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
    const premium = await hasPremiumEntitlement(adminClient, user.id, user.email);
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
      sex: typeof ctx.sex === 'string' ? ctx.sex : undefined,
      isPregnancy: Boolean(ctx.isPregnancy),
      isUnder18: Boolean(ctx.isUnder18),
      stepGoal: ctx.stepGoal ? Number(ctx.stepGoal) : undefined,
      recentSummary: typeof ctx.recentSummary === 'string' ? ctx.recentSummary : undefined,
      activePlan: typeof ctx.activePlan === 'string' ? ctx.activePlan : undefined,
      fastingState: typeof ctx.fastingState === 'string' ? ctx.fastingState : undefined,
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

    const allowedFacts = [
      Number(ctx.remainingCalories ?? 0),
      Number(ctx.remainingProtein ?? 0),
      Number(ctx.targetCalories ?? 0),
      Number(ctx.targetProtein ?? 0),
      Number(ctx.currentWeight ?? 0),
      Number(ctx.stepGoal ?? 0),
    ].filter((n) => Number.isFinite(n) && n !== 0);

    const historyText = history
      .map((h) => `${h.role === 'assistant' || h.role === 'model' ? 'coach' : 'user'}: ${h.content}`)
      .join('\n');
    const userText = `${historyText}\nuser: ${message}`.trim();

    const routed = await routeGenerate({
      task: 'coach_chat',
      systemInstruction,
      userText,
      contents,
      temperature: 0.7,
    });

    let reply = routed.text;
    if (!validateNumbersAgainstFacts(reply, allowedFacts)) {
      // Fall back to a deterministic template — never invent numbers.
      reply =
        `هدف يومك ${Number(ctx.targetCalories ?? 0)} سعرة، فاضلك ${Number(ctx.remainingCalories ?? 0)}. ` +
        `خلّي الخطوة الجاية بسيطة وواضحة — من غير أرقام زيادة.`;
    }

    return json({
      reply,
      provider: routed.provider,
      tokens: { input: routed.inputTokens, output: routed.outputTokens },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    if (message === 'GEMINI_NOT_CONFIGURED' || message === 'ANTHROPIC_NOT_CONFIGURED') {
      return json({ error: message }, 503);
    }
    if (message.startsWith('GEMINI_API_ERROR:') || message.startsWith('ANTHROPIC_HTTP_')) {
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
