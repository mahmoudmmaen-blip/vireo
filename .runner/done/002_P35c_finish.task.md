engine: agent
You are a senior engineer on the Vireo repo (branch ux-v2). Read AGENTS.md first and follow it strictly.

Task: FINISH docs/prompts/P35c_food_db_audit.md (queue item 3 in docs/prompts/QUEUE_ORDER.md).
A previous agent started it and was cut off by a quota limit before committing. Its work is UNCOMMITTED in the working tree.
1. Run `git status --short` and `git diff --stat` to see what exists (tool/accuracy_bench/fdc_audit.py, fdc_fix.py, fdc_suggest.py and data edits). Keep good work; do not redo it from scratch.
2. Known leftovers it reported: nutella and tortilla_flour fdc_ids, and beef_bacon (FNDDS id the audit script didn't know). Resolve them properly.
3. Complete every remaining requirement in P35c: tool/accuracy_bench/fdc_audit_report.md, the missing common foods (صامولي، بيكن، صوص رانش، بطاطس مشوية، رغيف بلدي محشي), the ACCURACY.md date typo (أكتوبر 2025 -> 2026) and the held-out honesty line. Re-run the accuracy bench and report TUNING / HELD-OUT / ALL exactly as measured (no tuning on held-out).
4. Run flutter analyze and the relevant tests, write docs/P35c_CHANGES.md, then ONE commit: "fix(food-db): USDA id audit, missing common foods". Never push.
Finish with the 5-line report from AGENTS.md.
