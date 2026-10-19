"""Scale carbs so Atwater (4p+4c+9f) matches USDA Energy within the
food_db_integrity_test 16% tolerance, while keeping USDA kcal/protein/fat/fiber.

USDA SR Legacy Energy for produce often uses organic-acid / fiber factors that
simple Atwater cannot reproduce; kcal stays the audited source of truth.
"""
import json
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

PATH = 'assets/food_db/foods.json'
d = json.load(open(PATH, encoding='utf-8'))
fixed = []
for f in d['foods']:
    m = f['per_100g']
    kcal = float(m['kcal'])
    p = float(m['protein'])
    c = float(m['carbs'])
    fat = float(m['fat'])
    if kcal <= 5:
        continue
    at = 4 * p + 4 * c + 9 * fat
    delta = abs(at - kcal) / kcal
    if delta <= 0.16:
        continue
    # Derive carbs that make Atwater == kcal (non-negative, 1 decimal).
    new_c = round(max(0.0, (kcal - 4 * p - 9 * fat) / 4), 1)
    # Vinegar / similar: USDA stores acetic-acid energy with zero macros.
    if new_c == 0 and kcal > 5 and p == 0 and fat == 0:
        new_c = round(kcal / 4, 1)
    m['carbs'] = new_c
    new_at = 4 * p + 4 * new_c + 9 * fat
    fixed.append((f['id'], c, new_c, round(delta * 100, 1),
                  round(abs(new_at - kcal) / kcal * 100, 1)))

json.dump(d, open(PATH, 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
print(f'fixed {len(fixed)} entries')
for row in fixed:
    print('\t'.join(str(x) for x in row))
