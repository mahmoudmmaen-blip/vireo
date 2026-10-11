import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

interface RevenueCatEvent {
  type: string;
  app_user_id: string;
  original_app_user_id?: string;
  aliases?: string[];
  entitlement_id?: string;
  entitlement_ids?: string[];
  expiration_at_ms?: number;
  purchased_at_ms?: number;
  product_id?: string;
  period_type?: string;
}

interface RevenueCatWebhookPayload {
  api_version?: string;
  event: RevenueCatEvent;
}

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return json({ ok: true }, 200);
  }

  if (req.method !== 'POST') {
    return json({ error: 'Method not allowed' }, 405);
  }

  try {
    // Optional secret verification
    const webhookAuth = Deno.env.get('REVENUECAT_WEBHOOK_AUTH_TOKEN');
    if (webhookAuth) {
      const headerAuth = req.headers.get('Authorization');
      if (headerAuth !== webhookAuth && headerAuth !== `Bearer ${webhookAuth}`) {
        return json({ error: 'Unauthorized webhook' }, 401);
      }
    }

    const payload = (await req.json()) as RevenueCatWebhookPayload;
    const event = payload?.event;
    if (!event || !event.app_user_id) {
      return json({ error: 'Invalid payload: missing event or app_user_id' }, 400);
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    const admin = createClient(supabaseUrl, serviceRoleKey);

    const appUserId = event.app_user_id;
    const eventType = event.type; // INITIAL_PURCHASE, RENEWAL, CANCELLATION, EXPIRATION, etc.
    const entitlement =
      event.entitlement_id ??
      (event.entitlement_ids && event.entitlement_ids.length > 0
        ? event.entitlement_ids[0]
        : 'pro');

    const expiresAt = event.expiration_at_ms
      ? new Date(event.expiration_at_ms).toISOString()
      : null;

    let status = 'active';
    if (eventType === 'EXPIRATION') {
      status = 'expired';
    } else if (eventType === 'CANCELLATION') {
      // Cancellation in RevenueCat means auto-renew turned off; entitlement remains active until expires_at
      status = 'cancelled';
    } else if (eventType === 'BILLING_ISSUE') {
      status = 'billing_issue';
    } else {
      status = 'active';
    }

    // Check if app_user_id is a valid UUID (Supabase user id)
    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    let targetUserId: string | null = uuidRegex.test(appUserId) ? appUserId : null;

    if (!targetUserId && event.aliases && event.aliases.length > 0) {
      for (const alias of event.aliases) {
        if (uuidRegex.test(alias)) {
          targetUserId = alias;
          break;
        }
      }
    }

    if (!targetUserId && event.original_app_user_id && uuidRegex.test(event.original_app_user_id)) {
      targetUserId = event.original_app_user_id;
    }

    if (!targetUserId) {
      // Anonymous user event before Supabase account link; acknowledge so RevenueCat doesn't retry
      return json(
        { ok: true, message: 'Non-UUID app_user_id ignored (anonymous)' },
        200,
      );
    }

    const nowIso = new Date().toISOString();

    // Upsert into subscriptions table
    const { error: subError } = await admin.from('subscriptions').upsert(
      {
        user_id: targetUserId,
        entitlement,
        expires_at: expiresAt,
        status,
        updated_at: nowIso,
      },
      { onConflict: 'user_id' },
    );

    if (subError) {
      console.error('Failed to upsert subscription:', subError);
      return json({ error: subError.message }, 500);
    }

    // Also update users.subscription_tier for backward compatibility
    const hasActiveAccess =
      status === 'active' ||
      (status === 'cancelled' && expiresAt && new Date(expiresAt).getTime() > Date.now());

    await admin
      .from('users')
      .update({
        subscription_tier: hasActiveAccess ? 'premium' : 'free',
        updated_at: nowIso,
      })
      .eq('id', targetUserId);

    return json({ ok: true, user_id: targetUserId, status }, 200);
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : String(err);
    console.error('Webhook error:', message);
    return json({ error: message }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
