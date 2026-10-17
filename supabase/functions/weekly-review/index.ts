import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';
import {
  extractNumbers,
  providerHealth,
  routeGenerate,
  validateNumbersAgainstFacts,
} from '../_shared/ai-router.ts';
import { hasPremiumEntitlement } from '../_shared/ai-usage.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

type ReviewBody = {
  facts?: {
    tdeeBefore?: number;
    tdeeAfter?: number;
    bestDayLabel?: string;
    worstDayLabel?: string;
    patternLabel?: string;
    nextFocus?: string;
    weeklyDeficit?: number;
    adherencePct?: number;
  };
  language?: string;
  templateOnly?: boolean;
};

function templateBullets(f: NonNullable<ReviewBody['facts']>): string[] {
  return [
    `حرقك اتعدل: ${f.tdeeAfter ?? '—'} ← ${f.tdeeBefore ?? '—'}`,
    `أحسن يوم: ${f.bestDayLabel ?? '—'}`,
    `أصعب يوم: ${f.worstDayLabel ?? '—'}`,
    `نمط لاحظناه: ${f.patternLabel ?? '—'}`,
    `تركيز الأسبوع الجاي: ${f.nextFocus ?? 'ثبات التسجيل'}`,
  ];
}

function weekCacheKey(userId: string, now = new Date()): string {
  const onejan = new Date(now.getFullYear(), 0, 1);
  const week = Math.ceil(
    ((now.getTime() - onejan.getTime()) / 86400000 + onejan.getDay() + 1) / 7,
  );
  return `weekly_review:${userId}:${now.getFullYear()}-W${week}`;
}

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

    const body = (await req.json()) as ReviewBody;
    const facts = body.facts ?? {};
    const bullets = templateBullets(facts);
    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const premium = await hasPremiumEntitlement(adminClient, user.id, user.email);

    if (!premium || body.templateOnly) {
      return json({
        ok: true,
        provider: 'template',
        bullets,
        cached: false,
        health: providerHealth(),
      });
    }

    const cacheKey = weekCacheKey(user.id);
    const { data: cached } = await adminClient
      .from('ai_weekly_review_cache')
      .select('bullets, provider, input_tokens, output_tokens')
      .eq('cache_key', cacheKey)
      .maybeSingle();

    if (cached?.bullets) {
      return json({
        ok: true,
        provider: cached.provider ?? 'cache',
        bullets: cached.bullets,
        cached: true,
        tokens: {
          input: cached.input_tokens ?? 0,
          output: cached.output_tokens ?? 0,
        },
      });
    }

    const allowed = [
      facts.tdeeBefore,
      facts.tdeeAfter,
      facts.weeklyDeficit,
      facts.adherencePct,
    ].filter((n): n is number => typeof n === 'number');

    const system =
      'You are Vireo coach. Reply ONLY 5 short Egyptian Arabic bullets. ' +
      'Use ONLY the provided numbers. Never invent calories, weights, or days. ' +
      'No names, emails, or medical diagnosis.';

    const userText = JSON.stringify({ facts, template: bullets });

    const routed = await routeGenerate({
      task: 'weekly_review',
      systemInstruction: system,
      userText,
      temperature: 0.3,
      maxOutputTokens: 512,
    });

    let outBullets = routed.text
      .split('\n')
      .map((l) => l.replace(/^[-•*\d.)\s]+/, '').trim())
      .filter(Boolean)
      .slice(0, 5);

    if (
      outBullets.length < 5 ||
      !validateNumbersAgainstFacts(outBullets.join(' '), allowed)
    ) {
      outBullets = bullets;
    }

    try {
      await adminClient.from('ai_weekly_review_cache').upsert({
        cache_key: cacheKey,
        user_id: user.id,
        bullets: outBullets,
        provider: routed.provider,
        input_tokens: routed.inputTokens,
        output_tokens: routed.outputTokens,
        created_at: new Date().toISOString(),
      });
    } catch (_) {
      // Cache table may not exist yet — still return the review.
    }

    return json({
      ok: true,
      provider: routed.provider,
      bullets: outBullets,
      cached: false,
      tokens: {
        input: routed.inputTokens,
        output: routed.outputTokens,
      },
      numbersSeen: extractNumbers(outBullets.join(' ')),
    });
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : String(e) }, 500);
  }
});

function json(body: unknown, status: number) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
