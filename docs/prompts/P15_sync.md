Act as a Senior Flutter + Supabase engineer working on Vireo (branch ux-v2). Make data safe across devices.

1. Audit every Hive store (meals, AI logs, water, steps history, workouts, GPS routes, weight, measurements, diet program, Today Plan checks, vitality, settings) and list them in docs/DATA_MAP.md with the matching Supabase table.
2. Create missing tables with user_id, updated_at, deleted_at and RLS (owner only). Anonymous users can write their own rows.
3. Sync engine: write locally first, queue changes, push when online, pull on app start and on resume; last-write-wins by updated_at; soft deletes. Show a small sync status in Profile.
4. Anonymous → permanent upgrade keeps the same user id, so nothing moves. If the user signs in to a DIFFERENT existing account, ask: "Keep this phone's data / keep account data / merge".
5. Export my data (JSON + CSV zip) and Delete my account (existing delete-account function must also delete every new table and storage files). Both in Profile → Privacy.
6. Progress photos are excluded from sync unless the user turns on "Back up photos" (private storage bucket, RLS).
Tests for the sync queue and conflict rule.
flutter analyze → 0 errors. git add -A && git commit -m "feat(sync): offline-first sync, export, full delete". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.
