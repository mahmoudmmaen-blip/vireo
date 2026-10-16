"""Verify every source.fdc_id in assets/food_db/foods.json against USDA.

Prefer the official SR Legacy JSON dump (2018-04) when present under TMP_WIN;
otherwise use the bundled index tool/accuracy_bench/sr_legacy_index.json.
Non-SR ids (Foundation / FNDDS) verified via FDC API are listed in `extra`.
"""
import json
import io
import sys
import os
from collections import Counter

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
TMP = os.environ.get('TMP_WIN', r'C:/Users/FUTURE/AppData/Local/Temp')
DUMP = os.path.join(TMP, 'FoodData_Central_sr_legacy_food_json_2018-04.json')
INDEX_PATH = 'tool/accuracy_bench/sr_legacy_index.json'

# Non-SR-Legacy ids verified via FDC API (fdc.nal.usda.gov, 2026-10-16)
extra = {
    790085: ('Flour, whole wheat, unenriched', 370.0, 'Foundation/API'),
    790179: ('FLOUR, RICE, WHITE (ORGANIC)', None, 'Foundation/API'),
    2705856: ('Beef, bacon, cooked', 449.0, 'FNDDS/API'),
}


def load_index():
    if os.path.exists(DUMP):
        sr = json.load(open(DUMP, encoding='utf-8'))
        foods_key = [k for k in sr if isinstance(sr[k], list)][0]
        index = {}
        for f in sr[foods_key]:
            kcal = None
            for fn in f.get('foodNutrients', []):
                if fn.get('nutrient', {}).get('number') == '208':
                    kcal = fn.get('amount')
            index[f['fdcId']] = (f.get('description'), kcal)
        print('SR Legacy records (dump):', len(index))
        return index
    raw = json.load(open(INDEX_PATH, encoding='utf-8'))
    index = {}
    for fid, (desc, vals) in raw.items():
        index[int(fid)] = (desc, vals.get('kcal') if isinstance(vals, dict) else None)
    print('SR Legacy records (bundled index):', len(index))
    return index


index = load_index()
foods = json.load(open('assets/food_db/foods.json', encoding='utf-8'))['foods']
results = []
for f in foods:
    src = f.get('source') or {}
    fdc = src.get('fdc_id')
    if not fdc:
        continue
    if fdc in index:
        desc, kcal = index[fdc]
        src_name = 'SR Legacy'
    elif fdc in extra:
        desc, kcal, src_name = extra[fdc]
    else:
        results.append(('ID_NOT_FOUND', f['id'], fdc, f['name_en'],
                        f['per_100g']['kcal'], None, None, None))
        continue
    mine = f['per_100g']['kcal']
    if kcal is None:
        results.append(('NO_KCAL_IN_REF', f['id'], fdc, f['name_en'],
                        mine, desc, None, src_name))
        continue
    dev = abs(mine - kcal) / kcal * 100 if kcal else (0 if mine == 0 else 999)
    status = 'OK' if dev <= 5 else 'KCAL_MISMATCH'
    results.append((status, f['id'], fdc, f['name_en'], mine, desc,
                    round(dev, 1), src_name))

print(Counter(r[0] for r in results))
for r in results:
    print('\t'.join(str(x) for x in r))
