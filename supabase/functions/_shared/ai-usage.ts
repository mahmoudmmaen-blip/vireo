import type { SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';

export type AiUsageKind = 'meal_scan' | 'coach_chat' | 'body_report';

export const MEAL_SCAN_LIMIT_ANON = 2;
export const MEAL_SCAN_LIMIT_FREE = 3;
export const MEAL_SCAN_LIMIT_PREMIUM = 50;
export const COACH_CHAT_LIMIT_ANON = 10;
export const COACH_CHAT_LIMIT_FREE = 20;
export const COACH_CHAT_LIMIT_PREMIUM = 200;

export function utcDay(): string {
  return new Date().toISOString().slice(0, 10);
}

export async function hasPremiumEntitlement(
  admin: SupabaseClient,
  userId: string,
): Promise<boolean> {
  const { data } = await admin
    .from('users')
    .select('subscription_tier')
    .eq('id', userId)
    .maybeSingle();

  return data?.subscription_tier === 'premium';
}

export function mealScanLimit(args: {
  premium: boolean;
  isAnonymous: boolean;
}): number {
  if (args.premium) return MEAL_SCAN_LIMIT_PREMIUM;
  if (args.isAnonymous) return MEAL_SCAN_LIMIT_ANON;
  return MEAL_SCAN_LIMIT_FREE;
}

export function coachChatLimit(args: {
  premium: boolean;
  isAnonymous: boolean;
}): number {
  if (args.premium) return COACH_CHAT_LIMIT_PREMIUM;
  if (args.isAnonymous) return COACH_CHAT_LIMIT_ANON;
  return COACH_CHAT_LIMIT_FREE;
}

/**
 * Returns true if the call is allowed and increments the daily counter.
 * Returns false when the daily limit is already reached.
 */
export async function consumeDailyQuota(
  admin: SupabaseClient,
  userId: string,
  kind: AiUsageKind,
  limit: number,
): Promise<boolean> {
  const day = utcDay();
  const { data } = await admin
    .from('ai_usage')
    .select('count')
    .eq('user_id', userId)
    .eq('day', day)
    .eq('kind', kind)
    .maybeSingle();

  const used = (data?.count as number | undefined) ?? 0;
  if (used >= limit) return false;

  const { error } = await admin.from('ai_usage').upsert(
    {
      user_id: userId,
      day,
      kind,
      count: used + 1,
      updated_at: new Date().toISOString(),
    },
    { onConflict: 'user_id,day,kind' },
  );

  if (error) throw new Error(error.message);
  return true;
}
