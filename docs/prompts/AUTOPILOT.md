# Vireo autopilot (managed by Claude)

Each step: open a NEW Antigravity conversation (Gemini 3.8 Flash) and send:
"Read docs/prompts/<FILE> and do exactly what it says."
A step is done when its commit appears in git log. Then Claude reviews and starts the next.

| # | File | Commit message starts with | Status |
|---|------|----------------------------|--------|
| 1 | NEXT.md (10 languages) | feat(l10n) | done 19:46 (language_picker_test skipped: hangs) |
| 2 | P10_reminders.md | feat(reminders) | done 20:30 (13 scheduler tests, 193 tests pass) |
| 3 | P11_progress.md | feat(progress) | done 21:11 |
| 4 | P13_onboarding.md | feat(onboarding) | done 21:38 |
| 4b | P11b_fat_equivalent.md | feat(energy) | done 22:16 (10 tests) |
| 5 | P12_subscriptions.md | feat(subscription) | done 22:53 |
| 6 | P14_social.md | feat(social) | done 23:00 (4 tests) |
| 7 | P15_sync.md | feat(sync) | running (started 23:01) |
| 8 | P16_quality.md | chore(quality) | queued |
| 9 | P17_store.md | chore(store) | queued |
| 10 | Phase 18 release | — | STOP: needs the owner (keystore, applicationId, push) |
