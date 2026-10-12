Act as a Supabase release engineer for Vireo (branch ux-v2, project already linked with `npx supabase link`). The owner asked to deploy the backend now.

1. Run `npx supabase migration list` and show which local migrations are not yet applied remotely.
2. Run `npx supabase db push`. If it asks for the database password or any login, STOP and tell me exactly what it asked (do not guess or type any password).
   If a migration fails, show the error, fix the SQL in a NEW follow-up migration file (never edit an already-applied one), and push again.
3. Deploy every Edge Function with `npx supabase functions deploy <name> --use-api` for: analyze-meal, parse-meal-text, ai-coach-chat, analyze-body-report, revenuecat-webhook, delete-account, generate-program, generate-meal-plan, suggest-recipes, scan-fridge-vision. Retry a function once if it times out.
4. Run `npx supabase secrets list` and report which secret NAMES exist (never print values). Tell me which ones are missing that the code expects (e.g. GEMINI_API_KEY, REVENUECAT_WEBHOOK_SECRET). Do NOT create or set any secret yourself.
5. Do not change app code. Do not push to GitHub. If you created a fix migration, commit it: git add -A && git commit -m "fix(db): migration fix for deploy".
Final message: a short table — migrations applied, functions deployed (ok/failed), missing secrets.

Work autonomously except for passwords/logins/secrets (stop and report those).
