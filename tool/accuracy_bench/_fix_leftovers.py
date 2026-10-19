"""One-shot: fix nutella + tortilla_flour leftovers from P35c."""
import json
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

PATH = 'assets/food_db/foods.json'
idx = json.load(open('tool/accuracy_bench/sr_legacy_index.json', encoding='utf-8'))
d = json.load(open(PATH, encoding='utf-8'))
by_id = {f['id']: f for f in d['foods']}


def adopt(f, fdc):
    desc, vals = idx[str(fdc)]
    for k in ('kcal', 'protein', 'carbs', 'fat', 'fiber'):
        if k in vals:
            f['per_100g'][k] = vals[k]
    print(f"{f['id']}: -> {fdc} {desc} {vals}")


f = by_id['nutella']
f['source'] = {'name': 'USDA FoodData Central', 'fdc_id': 168000}
adopt(f, 168000)

f = by_id['tortilla_flour']
f['source'] = {'name': 'USDA FoodData Central', 'fdc_id': 167535}
adopt(f, 167535)

print('beef_bacon source:', by_id['beef_bacon']['source'], by_id['beef_bacon']['per_100g'])

json.dump(d, open(PATH, 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
print('saved')
