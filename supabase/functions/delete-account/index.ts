import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';

/**
 * Hard-deletes the authenticated user's account and all owned data.
 * Callable only by the signed-in user (JWT verified via anon client).
 * Uses service role for cascade deletes and auth.admin.deleteUser.
 */

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
};

/** Tables with a direct user_id column, deleted before users row. */
const USER_OWNED_TABLES = [
  'workout_checkins',
  'workout_sessions',
  'reassessments',
  'checkins',
  'weight_logs',
  'walking_logs',
  'progress_photos',
  'fridge_scans',
  'user_recipe_history',
  'meal_plans',
] as const;

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  if (req.method !== 'POST') {
    return json({ error: 'Method not allowed' }, 405);
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

    // Optional body user_id must match the authenticated user.
    let bodyUserId: string | undefined;
    try {
      const body = await req.json();
      if (body && typeof body.user_id === 'string') {
        bodyUserId = body.user_id;
      }
    } catch {
      // Empty body is fine — always delete the caller's account.
    }

    if (bodyUserId && bodyUserId !== user.id) {
      return json({ error: 'Forbidden: user_id mismatch' }, 403);
    }

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const userId = user.id;

    await deleteStoragePrefix(admin, 'progress-photos', userId);
    await deleteStoragePrefix(admin, 'fridge-scans', userId);

    const { data: programs, error: programsListError } = await admin
      .from('programs')
      .select('id')
      .eq('user_id', userId);

    if (programsListError) {
      return json({ error: programsListError.message }, 500);
    }

    const programIds = (programs ?? []).map((p) => p.id as string);
    if (programIds.length > 0) {
      const { error: daysError } = await admin
        .from('program_days')
        .delete()
        .in('program_id', programIds);
      if (daysError) return json({ error: daysError.message }, 500);
    }

    const { error: programsError } = await admin
      .from('programs')
      .delete()
      .eq('user_id', userId);
    if (programsError) return json({ error: programsError.message }, 500);

    for (const table of USER_OWNED_TABLES) {
      const { error } = await admin.from(table).delete().eq('user_id', userId);
      if (error) return json({ error: `${table}: ${error.message}` }, 500);
    }

    const { error: profileError } = await admin
      .from('profiles')
      .delete()
      .eq('id', userId);
    if (profileError) return json({ error: profileError.message }, 500);

    const { error: usersError } = await admin
      .from('users')
      .delete()
      .eq('id', userId);
    if (usersError) return json({ error: usersError.message }, 500);

    const { error: deleteAuthError } = await admin.auth.admin.deleteUser(userId);
    if (deleteAuthError) {
      return json({ error: deleteAuthError.message }, 500);
    }

    return json({ success: true, deleted_user_id: userId });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return json({ error: message }, 500);
  }
});

async function deleteStoragePrefix(
  admin: ReturnType<typeof createClient>,
  bucket: string,
  userId: string,
) {
  const prefix = `${userId}`;
  const { data: files, error: listError } = await admin.storage
    .from(bucket)
    .list(prefix, { limit: 1000 });

  if (listError) {
    if (listError.message.toLowerCase().includes('not found')) return;
    throw listError;
  }

  if (!files?.length) return;

  const paths = files.map((f) => `${prefix}/${f.name}`);
  const { error: removeError } = await admin.storage.from(bucket).remove(paths);
  if (removeError) throw removeError;
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}
