Act as a Senior Flutter + Supabase engineer working on Vireo (branch ux-v2). Add social features with privacy first.

1. Tables (migration + RLS): profiles_public(user_id, display_name, avatar_seed), friendships(user_id, friend_id, status), challenges(id, owner_id, type 'weekly_steps'|'logging_streak', starts_at, ends_at, invite_code), challenge_members(challenge_id, user_id), daily_shared_stats(user_id, day, steps, logged bool). Users only ever share steps, streak and logged-today. Never food, weight or health data.
2. Add friend by invite link/code (share sheet, WhatsApp-friendly deep link). Anonymous users must save progress first.
3. Challenges: create weekly steps challenge, join by code, leaderboard with ranks, daily updates, end-of-week winner card.
4. Family group: up to 6 members, shared weekly steps total.
5. Share achievement cards (image) from badges and weekly report.
6. Report/block a user; leave challenge; delete removes all shared rows.
flutter analyze → 0 errors. git add -A && git commit -m "feat(social): friends, challenges, family, share cards". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.
