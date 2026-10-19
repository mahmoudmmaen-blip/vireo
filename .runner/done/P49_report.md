# P49 — Home restructure: one CTA, remaining-kcal hero, mascot = progress
Status: DONE

## What changed
- `meal_capture_hero_card.dart`: dominant «تصوير» CTA; other 6 actions demoted to icon-only row; last-meal uses `سعرة` / `جم بروتين` (no `22g P`); title up to 2 lines
- `calories_today_mascot_card.dart`: hero = فاضل remaining (`≈` + large number); eaten is secondary line; wave (120) or classic ring is the only calorie progress; macro chips with big numbers + thin goal bars
- `home_dashboard_body.dart`: week strip promoted to primary fold; week always starts Saturday; today uses filled accent circle

## Gate results
- analyze: pass (0 errors; 1 warning + ~32 infos pre-existing)
- test: pass (`test/features/home` + `audit_p36_home_mascot_test` — 26 passed, 3 skipped). Full-suite `ux_capture_*` timeouts are pre-existing / unrelated
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓

## Manual steps for the user
- افتح الهوم بالعربي RTL: تأكد إن «تصوير» أكبر زر، وفاضل السعرات أكبر رقم في كارت السعرات، والماسكوت هو شريط التقدم
- صوّر وجبة من الهوم — المفروض نقرتين بس (تصوير → كاميرا)

## Follow-ups suggested
- P50 theme tokens (015)
- P53 weekly charts (016)
- P54 meal component chips (017)
- P55 AAB size audit (018)
