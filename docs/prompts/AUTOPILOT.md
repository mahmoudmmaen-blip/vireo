# Vireo autopilot (managed by Claude)

Each step: open a NEW Antigravity conversation (Gemini 3.8 Flash) and send:
"Read docs/prompts/<FILE> and do exactly what it says."
A step is done when its commit appears in git log. Then Claude reviews and starts the next.

| # | File | Commit message starts with | Status |
|---|------|----------------------------|--------|
| 1 | NEXT.md (10 languages) | feat(l10n) | running (started 15:50) |
| 2 | P10_reminders.md | feat(reminders) | queued |
| 3 | P11_progress.md | feat(progress) | queued |
| 4 | P13_onboarding.md | feat(onboarding) | queued |
| 5 | P12_subscriptions.md | feat(subscription) | queued |
| 6 | P14_social.md | feat(social) | queued |
| 7 | P15_sync.md | feat(sync) | queued |
| 8 | P16_quality.md | chore(quality) | queued |
| 9 | P17_store.md | chore(store) | queued |
| 10 | Phase 18 release | — | STOP: needs the owner (keystore, applicationId, push) |
