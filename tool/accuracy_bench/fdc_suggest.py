"""Suggest correct SR Legacy records for foods.json entries whose fdc_id is wrong.
Dumps top-N candidates per entry for human review. Read-only."""
import json, io, sys, os, re, difflib

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
TMP = os.environ.get('TMP_WIN', r'C:/Users/FUTURE/AppData/Local/Temp')

sr = json.load(open(os.path.join(TMP, 'FoodData_Central_sr_legacy_food_json_2018-04.json'), encoding='utf-8'))
key = [k for k in sr if isinstance(sr[k], list)][0]

NUTR = {'208': 'kcal', '203': 'protein', '204': 'fat', '205': 'carbs', '291': 'fiber'}
index = {}
for f in sr[key]:
    vals = {}
    for fn in f.get('foodNutrients', []):
        n = fn.get('nutrient', {})
        if n.get('number') in NUTR and fn.get('amount') is not None:
            vals[NUTR[n['number']]] = round(fn['amount'], 1)
    index[f['fdcId']] = (f.get('description'), vals)
json.dump({str(k): v for k, v in index.items()}, open('tool/accuracy_bench/sr_legacy_index.json', 'w', encoding='utf-8'), ensure_ascii=False)

def norm(s):
    s = s.lower()
    s = re.sub(r'[^a-z ]', ' ', s)
    return re.sub(r'\s+', ' ', s).strip()

descs = {fdc: norm(d) for fdc, (d, v) in index.items()}
words = {}
for fdc, d in descs.items():
    for w in d.split():
        words.setdefault(w, []).append(fdc)

STOP = {'cooked', 'raw', 'fresh', 'without', 'with', 'salt', 'dry', 'mature', 'seeds', 'all',
        'types', 'ready', 'to', 'and', 'or', 'the', 'in', 'from', 'plain', 'fat', 'lean'}

def candidates(name_en, topn=6):
    toks = [t for t in norm(name_en).split() if t not in STOP]
    scores = {}
    for t in set(toks):
        for fdc in words.get(t, []):
            scores[fdc] = scores.get(fdc, 0) + 1
    ranked = sorted(scores, key=lambda f: -scores[f])[:40]
    best = sorted(ranked, key=lambda f: -difflib.SequenceMatcher(None, norm(name_en), descs[f]).ratio())[:topn]
    return [(fdc, index[fdc][0], index[fdc][1]) for fdc in best]

foods = json.load(open('assets/food_db/foods.json', encoding='utf-8'))['foods']
out = io.open('tool/accuracy_bench/fdc_candidates.txt', 'w', encoding='utf-8')
for f in foods:
    src = f.get('source') or {}
    fdc = src.get('fdc_id')
    if not fdc:
        continue
    desc, vals = index.get(fdc, ('<NOT FOUND>', {}))
    out.write(f"== {f['id']} | {f['name_en']} | ours kcal={f['per_100g']['kcal']} | current {fdc} = {desc} {vals.get('kcal')}\n")
    for cfdc, cdesc, cvals in candidates(f['name_en']):
        out.write(f"   {cfdc}  {cdesc}  {cvals}\n")
out.close()
print('wrote candidates for', sum(1 for f in foods if (f.get('source') or {}).get('fdc_id')), 'entries')
