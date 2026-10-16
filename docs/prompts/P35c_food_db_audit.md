Act as a senior Flutter + nutrition-data engineer on Vireo (branch ux-v2). Small task, do it before P36. Follow AGENTS.md. Never push.

1. **Full USDA fdc_id audit** of assets/food_db/foods.json. In P35b, 4 of 4 spot-checked ids were wrong.
   - For every entry with an fdc_id, verify that the description and kcal/100 g match the USDA FoodData Central SR Legacy/Foundation record (within ±5%). Use the bundled USDA subset or the official FDC data. Do not guess.
   - Fix the wrong ids and values.
   - Write tool/accuracy_bench/fdc_audit_report.md: entries checked, mismatches fixed, and entries left unverified.
2. **Add the missing standalone foods** found in the held-out analysis, with sourced values and household units: صامولي، بيكن (بقري/ديك رومي)، صوص رانش، بطاطس مشوية، رغيف بلدي محشي (حلاوة/جبن) by size. Do NOT tune against held-out answers: add them because they are common foods, then re-run the bench and report the held-out number as-is.
3. In docs/ACCURACY.md, fix the date typo "أكتوبر 2025" → "أكتوبر 2026". Add one line: "الرقم الأصدق لدقة التطبيق على أكل جديد هو نتيجة المجموعة المحجوزة".
4. Run `flutter analyze` and the bench unit tests (`--timeout 2m`).
5. `git add -A && git commit -m "fix(food-db): USDA id audit, missing common foods"`. Do not push.
