Act as a Senior Flutter Engineer working on Vireo (branch ux-v2). Build smart local reminders with flutter_local_notifications (already a dependency).

- Types (each with its own toggle + time in Settings → Reminders): water (spread across waking hours, skip when the goal is met), meals (from Today Plan times), fasting window opens/closes, workout (preferred time from onboarding), steps nudge at 18:00 if under 50% of goal, bedtime, weekly check-in, streak protection at 21:00 if nothing logged today.
- Quiet hours (default 23:00-07:00) and a max of 6 notifications per day.
- Copy: short, warm, Egyptian Arabic + English, never guilt-tripping. Include deep links to the right screen.
- Android 13+: ask notification permission only after the user turns on a reminder (explain first). iOS: same.
- Reschedule everything when the plan, diet program, language or timezone changes.
- Tests for the scheduler (quiet hours, daily cap, skip when goal met).
flutter analyze → 0 errors. git add -A && git commit -m "feat(reminders): smart local notifications". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.
