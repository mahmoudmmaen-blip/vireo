# AI backend (Gemini via Supabase Edge Functions)

Vireo never ships a Gemini API key in the Flutter client. Meal vision and the AI coach call Supabase Edge Functions, which hold `GEMINI_API_KEY` as a server secret.

## Functions

| Function | Purpose | Daily limits |
|---|---|---|
| `analyze-meal` | Meal photo → nutrition JSON | Free 3 / Premium 50 |
| `ai-coach-chat` | Chat reply with live macro context | Free 20 / Premium 200 |

Shared code lives under `supabase/functions/_shared/`:

- `gemini-client.ts` — REST `generateContent` (default model `gemini-3.5-flash`)
- `prompts/meal-vision.ts` — port of `VireoAiPrompts.mealVisionPrompt`
- `prompts/coach.ts` — port of `VireoAiPrompts.coachSystemPrompt`
- `ai-usage.ts` — premium check + `ai_usage` daily counters

Migration: `supabase/migrations/20261008120000_ai_usage.sql`.

## Deploy commands

From the repo root (with the [Supabase CLI](https://supabase.com/docs/guides/cli) installed and logged in):

```bash
# 1) Authenticate (once)
supabase login

# 2) Link this project (use your project ref)
supabase link --project-ref jzizpqriifrcgiksnddq

# 3) Set Gemini secrets (never commit these)
supabase secrets set GEMINI_API_KEY=YOUR_GEMINI_API_KEY
supabase secrets set GEMINI_MODEL=gemini-3.5-flash

# 4) Apply the ai_usage migration
supabase db push

# 5) Deploy the two AI functions
supabase functions deploy analyze-meal
supabase functions deploy ai-coach-chat
```

Optional: redeploy fridge vision / other functions the same way if needed.

## Verify

1. Sign in to the app (guests are gated before AI).
2. Meal scan: Nutrition → camera / gallery — expect a JSON analysis sheet.
3. Coach: send a message — expect a short Arabic/English reply.
4. Hit free daily limits → UI shows the daily-limit message and an Upgrade action (opens the paywall).

## Flutter config

`AppConfig.analyzeMealFunctionName` → `analyze-meal`  
`AppConfig.aiCoachChatFunctionName` → `ai-coach-chat`

No `GEMINI_API_KEY` / `--dart-define` for Gemini on the client.
