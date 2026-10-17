# Vireo — handoff for a new Claude chat (2026-10-16)

Owner: Mahmoud (non-technical). Reply in Egyptian Arabic, step by step, Saudi time (UTC+3). Claude owns the product: quality, accuracy, UX, pricing and growth.

## Where things are
- Repo: N:\vireo (branch ux-v2, local only, NEVER push). Rules: AGENTS.md. Decisions: docs/PRODUCT_DECISIONS.md. Queue: docs/prompts/QUEUE_ORDER.md.
- **Runner:** N:\vireo\.runner (runner.ps1 + start_runner.bat).
  - Drop `*.task.md` files into `.runner\inbox`. The runner executes them with Cursor CLI (`agent`), one at a time.
  - Logs and status go to `.runner\done`.
  - A `PAUSE` file pauses it. `not_before.txt` holds the start time.
  - Each task checks that the previous task's commit exists, otherwise it writes `<n>_BLOCKED.txt`.

## Queued (2026-10-16 17:05)
1. 000 smoke test
2. 001 deny test (git push must be BLOCKED)
3. 002 P35c finish
4. 003 P36
5. 004 P40
6. 005 P38
7. 006 P39
8. 007 P37

## How to verify a task
Stage these files and read them (don't trust the agent's own report):
- `.runner\done\<task>.status.json` and `.log`;
- `N:\vireo\.git\logs\HEAD`;
- `docs/P*_CHANGES.md`.

## Engines
- **Cursor Pro:** $20, renewed Oct 16, on-demand off.
- **Kimi Plus:** cancelled, ends Nov 16. The 5-hour limit is tiny, so use it for chat only.
- **Antigravity:** back Oct 18.
- **Gemini Pro:** desktop app, good for reviews.

## Owner to-dos before launch
- Legal name, address and jurisdiction.
- Keystore and key.properties.
- AdMob IDs and the RevenueCat key.
- Prices from PRODUCT_DECISIONS.md set in Play Console.
- Host the legal pages.
- Closed test: 12 testers for 14 days, starting by early December, aiming at Ramadan 2027 (~Feb 8).
