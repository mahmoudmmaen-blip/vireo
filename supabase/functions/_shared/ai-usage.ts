import type { SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';

export type AiUsageKind = 'meal_scan' | 'coach_chat' | 'body_report';

export const MEAL_SCAN_LIMIT_ANON = 2;
export const MEAL_SCAN_LIMIT_FREE = 3;
export const MEAL_SCAN_LIMIT_PREMIUM = 50;
export const BODY_REPORT_LIMIT_FREE = 1;
export const BODY_REPORT_LIMIT_PREMIUM = 50;
export const COACH_CHAT_LIMIT_ANON = 10;
export const COACH_CHAT_LIMIT_FREE = 20;
export const COACH_CHAT_LIMIT_PREMIUM = 200;

export function utcDay(): string {
  return new Date().toISOString().slice(0, 10);
}

export async function hasPremiumEntitlement(
  admin: SupabaseClient,
  userId: string,
  userEmail?: string,
): Promise<boolean> {
  // 1. Check pro_grants table by email (case-insensitive, unexpired or null expires_at)
  let email = userEmail;
  if (!email) {
    try {
      const { data: authUser } = await admin.auth.admin.getUserById(userId);
      email = authUser?.user?.email;
    } catch (_) {}
  }

  if (email && email.trim().length > 0) {
    const { data: grant } = await admin
      .from('pro_grants')
      .select('expires_at')
      .ilike('email', email.trim())
      .maybeSingle();

    if (grant) {
      const notExpired = !grant.expires_at || new Date(grant.expires_at).getTime() > Date.now();
      if (notExpired) {
        return true;
      }
    }
  }

  // 2. Check server-of-truth subscriptions table
  const { data: sub } = await admin
    .from('subscriptions')
    .select('entitlement, expires_at, status')
    .eq('user_id', userId)
    .maybeSingle();

  if (sub) {
    const isPro = sub.entitlement === 'pro' || sub.entitlement === 'premium';
    const isStatusActive = sub.status === 'active';
    const notExpired = !sub.expires_at || new Date(sub.expires_at).getTime() > Date.now();
    if (isPro && (isStatusActive || (sub.status === 'cancelled' && notExpired))) {
      return true;
    }
  }

  // 3. Fallback to users.subscription_tier
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
  rewardedBonus?: number;
}): number {
  if (args.premium) return MEAL_SCAN_LIMIT_PREMIUM;
  const base = args.isAnonymous ? MEAL_SCAN_LIMIT_ANON : MEAL_SCAN_LIMIT_FREE;
  const bonus = Math.min(Math.max(0, args.rewardedBonus ?? 0), 4); // Max 2 ads * 2 = 4
  return base + bonus;
}

export function bodyReportLimit(args: {
  premium: boolean;
}): number {
  if (args.premium) return BODY_REPORT_LIMIT_PREMIUM;
  return BODY_REPORT_LIMIT_FREE;
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
 * Checks if the user is within their daily quota without consuming it yet.
 */
export async function checkDailyQuota(
  admin: SupabaseClient,
  userId: string,
  kind: AiUsageKind,
  limit: number,
): Promise<{ allowed: boolean; used: number }> {
  const day = utcDay();
  const { data } = await admin
    .from('ai_usage')
    .select('count')
    .eq('user_id', userId)
    .eq('day', day)
    .eq('kind', kind)
    .maybeSingle();

  const used = (data?.count as number | undefined) ?? 0;
  return { allowed: used < limit, used };
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

/**
 * Decrements the daily quota on analysis failure (refund).
 */
export async function decrementDailyQuota(
  admin: SupabaseClient,
  userId: string,
  kind: AiUsageKind,
): Promise<void> {
  const day = utcDay();
  const { data } = await admin
    .from('ai_usage')
    .select('count')
    .eq('user_id', userId)
    .eq('day', day)
    .eq('kind', kind)
    .maybeSingle();

  const current = (data?.count as number | undefined) ?? 0;
  if (current <= 0) return;

  await admin.from('ai_usage').upsert(
    {
      user_id: userId,
      day,
      kind,
      count: current - 1,
      updated_at: new Date().toISOString(),
    },
    { onConflict: 'user_id,day,kind' },
  );
}
