Continue working through the Vireo roadmap WITHOUT stopping, one step after another, in this same conversation.

Queue (in this exact order):
1. docs/prompts/P14_social.md        → commit "feat(social): ..."
2. docs/prompts/P15_sync.md          → commit "feat(sync): ..."
3. docs/prompts/P16_quality.md       → commit "chore(quality): ..."
4. docs/prompts/P17_store.md         → commit "chore(store): ..."

For EACH step:
- First make sure the previous step is committed (git status clean). If P12 subscriptions is not committed yet, finish and commit it first.
- Read the step's file and do exactly what it says.
- Run flutter analyze (0 errors) and ONLY the new/affected tests with --timeout 2m. If any test hangs or times out, mark that test skip: 'TODO: hangs' and move on — never wait on a hanging test.
- Commit with the message stated in the file. Never push. Never run git reset or delete unrelated files.
- Update docs/prompts/AUTOPILOT.md: set that step's Status to "done <time>" and the next one to "running".
- Immediately start the next step. Do not end your turn between steps. Do not ask me questions — choose the best option and note it in the final summary.

STOP after P17_store.md is committed. Do NOT do Phase 18 (release) — it needs the owner (keystore, applicationId, push).
Final message: a short summary per step (what was built, tests, commit hash).
