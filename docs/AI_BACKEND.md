# AI backend (Gemini via Supabase Edge Functions)

Vireo never ships a Gemini API key in the Flutter client. Meal vision, text meal parsing, and the AI coach call Supabase Edge Functions, which hold `GEMINI_API_KEY` as a server secret.

## Functions

| Function | Purpose | Daily limits |
|---|---|---|
| `analyze-meal` | Meal photo → **items only** (no calories) | Free 3 / Premium 50 |
| `parse-meal-text` | Text description (or unmatched macro estimate) → items / per-100g estimates | Shares meal-scan quota |
| `ai-coach-chat` | Chat reply with live macro context | Free 20 / Premium 200 |

Shared code lives under `supabase/functions/_shared/`:

- `gemini-client.ts` — REST `generateContent` (default model `gemini-3.8-flash`, with fallbacks + Abort→503 retry)
- `prompts/meal-vision.ts` — items-only vision + text parse + unmatched macro prompts
- `prompts/coach.ts` — port of `VireoAiPrompts.coachSystemPrompt`
- `ai-usage.ts` — premium check + `ai_usage` daily counters

Macros are **never** trusted from Gemini for catalog foods. The Flutter app matches `food_id_guess` / aliases against `assets/food_db/foods.json` (USDA FDC IDs) and computes kcal / P/C/F locally. Fried cooking adds ~8 g oil per 100 g unless the food row is already fried.

Migration: `supabase/migrations/20261008120000_ai_usage.sql`.

## Deploy commands

From the repo root (with the [Supabase CLI](https://supabase.com/docs/guides/cli) installed and logged in):

```bash
# 1) Authenticate (once)
supabase login

# 2) Link this project (use your project ref)
supabase link --project-ref jzizpqriifrcgiksnddq

# 3) Set Gemini secrets (never commit these)
npx supabase secrets set --project-ref jzizpqriifrcgiksnddq GEMINI_API_KEY=YOUR_GEMINI_API_KEY
npx supabase secrets set --project-ref jzizpqriifrcgiksnddq GEMINI_MODEL=gemini-3.8-flash

# 4) Apply the ai_usage migration
supabase db push

# 5) Deploy AI meal + coach functions
npx supabase functions deploy analyze-meal --use-api
npx supabase functions deploy parse-meal-text --use-api
npx supabase functions deploy ai-coach-chat --use-api
```

Optional: redeploy fridge vision / other functions the same way if needed.

## `parse-meal-text`

**Deploy note:** after changing prompts or `gemini-client.ts`, always redeploy both meal functions together:

```bash
npx supabase functions deploy analyze-meal --use-api
npx supabase functions deploy parse-meal-text --use-api
```

Request bodies:

1. **Parse text** (default): `{ "text": "أكلت 2 بيض ورغيف بلدي", "language": "ar" }` → `{ "items": [ ... ] }` (same item shape as `analyze-meal`).
2. **Estimate unmatched macros**: `{ "mode": "estimate_macros", "items": [{ "name_ar", "name_en" }] }` → `{ "estimates": [{ "name_en", "kcal", "protein", "carbs", "fat", "fiber" }] }` per 100 g. Shown in the review UI with an “estimated” badge.

Auth: Bearer user JWT (anonymous OK). CORS: `Access-Control-Allow-Origin: *`.

## Verify

1. App uses anonymous-first auth — guests have a real JWT.
2. Meal scan: Home “Scan your meal” / camera → review screen with editable grams (not a raw JSON sheet).
3. Text / voice: Quick log → Text meal → same review screen.
4. Coach: short Arabic/English reply.
5. Hit free daily limits → UI shows the daily-limit message and an Upgrade action.

Smoke-test `analyze-meal` with an anonymous session + small JPEG:

```bash
# Obtain anon JWT via auth signup, POST base64 image to /functions/v1/analyze-meal
# Expect HTTP 200 and { "items": [ { "name_en", "estimated_grams", ... } ] }
```

## Flutter config

`AppConfig.analyzeMealFunctionName` → `analyze-meal`  
`AppConfig.parseMealTextFunctionName` → `parse-meal-text`  
`AppConfig.aiCoachChatFunctionName` → `ai-coach-chat`

No `GEMINI_API_KEY` / `--dart-define` for Gemini on the client.

## Auth setup

Vireo uses **anonymous-first** auth. Guests get a real JWT via `signInAnonymously()`, so AI Edge Functions work immediately (with lower daily limits). Saving progress upgrades the same user (email OTP / Google / Apple) instead of creating a second account.

### Supabase Dashboard

1. **Authentication → Sign In / Providers**  
   Enable **Allow anonymous sign-ins**.

2. **Authentication → Emails → Magic Link template**  
   Include `{{ .Token }}` in the email body so users receive the **6-digit code** (passwordless OTP). Example line:

   ```
   Your Vireo code is {{ .Token }}
   ```

3. **Authentication → URL Configuration**  
   - **Site URL** = your Vercel production URL (e.g. `https://your-app.vercel.app`)  
   - **Redirect URLs** include that origin and local overrides, e.g.  
     `http://localhost:*`  
     `http://127.0.0.1:*`

4. Enable **Google** / **Apple** providers if you use those buttons (same screen as other providers).

### Deploy remaining Edge Functions

```bash
npx supabase functions deploy analyze-meal --use-api
npx supabase functions deploy parse-meal-text --use-api
npx supabase functions deploy ai-coach-chat --use-api
npx supabase functions deploy generate-program --use-api
npx supabase functions deploy generate-meal-plan --use-api
npx supabase functions deploy suggest-recipes --use-api
npx supabase functions deploy scan-fridge-vision --use-api
npx supabase functions deploy delete-account --use-api
```

Anonymous daily AI limits (server-side in `_shared/ai-usage.ts`): **2 meal scans / day**, **10 coach messages / day**. Signed-in free: 3 / 20. Premium: 50 / 200.
