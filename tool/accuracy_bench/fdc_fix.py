"""P35c: apply the audited USDA fdc_id fixes to assets/food_db/foods.json.

- REPOINT: wrong fdc_id -> correct SR Legacy record; per_100g adopted from the
  cited record (kcal/protein/carbs/fat/fiber) so description AND values match.
- LOCAL: Egyptian/regional dish or no true USDA equivalent -> source becomes
  "Egyptian Food Composition Database" (no fdc_id), matching the 184 existing
  local entries.
- UNVERIFIED: USDA-plausible value but no verifiable SR Legacy record ->
  fdc_id dropped, listed in the audit report.
- ADOPT_ONLY: keep the (correct) fdc_id, adopt the record's values.
- Adds the P35c missing common foods with sourced values and household units.

Every REPOINT/ADOPT fdc_id below was verified against the official USDA
SR Legacy 2018-04 dump (tool/accuracy_bench/sr_legacy_index.json), except
2705856 (FNDDS "Beef, bacon, cooked") verified via the FDC API 2026-10-16.
"""
import json, io, sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

PATH = 'assets/food_db/foods.json'
EGY = 'Egyptian Food Composition Database'
USDA = 'USDA FoodData Central'

# food_id -> new fdc_id (per_100g adopted from the record)
REPOINT = {
    'pita_bread': 174915,            # Bread, pita, white, enriched
    'brown_rice_cooked': 169704,     # Rice, brown, long-grain, cooked
    'bulgur_cooked': 170287,         # Bulgur, cooked
    'cornflakes': 174648,            # Cereals RTE, RALSTON Corn Flakes
    'foul_medames': 173753,          # Broadbeans (fava), cooked, boiled
    'falafel': 172455,               # Falafel, home-prepared
    'hummus': 172454,                # Hummus, home prepared
    'black_beans_cooked': 175237,    # Beans, black, cooked, boiled
    'egg_fried': 173423,             # Egg, whole, cooked, fried
    'chicken_breast_grilled': 171477,  # Chicken breast meat only, roasted
    'chicken_thigh_cooked': 173625,  # Chicken thigh meat and skin, roasted
    'chicken_fried': 171460,         # Chicken light meat+skin, fried, flour
    'beef_lean_raw': 168607,         # Beef, brisket, separable lean only, raw
    'beef_grilled': 168720,          # Beef, top loin, cooked, grilled
    'lamb_cooked': 172544,           # Lamb, ground, cooked, broiled
    'fish_tilapia_cooked': 175177,   # Fish, tilapia, cooked, dry heat
    'fish_tuna_canned': 171986,      # Tuna, light, canned in water, drained
    'fish_salmon_cooked': 175168,    # Salmon, Atlantic, farmed, cooked
    'turkey_breast': 174516,         # Turkey breast meat only, cooked, roasted
    'milk_whole': 171265,            # Milk, whole, 3.25%
    'milk_skim': 171269,             # Milk, nonfat, with added vit A/D
    'yogurt_plain': 171284,          # Yogurt, plain, whole milk
    'mozzarella': 170845,            # Cheese, mozzarella, whole milk
    'ghee': 171314,                  # Butter, clarified (ghee)
    'sunflower_oil': 171017,         # Oil, sunflower, linoleic
    'tahini': 170189,                # Sesame butter, tahini, roasted kernels
    'okra_cooked': 169261,           # Okra, cooked, boiled
    'tomato_raw': 170457,            # Tomatoes, red, ripe, raw
    'cucumber': 168409,              # Cucumber, with peel, raw
    'potato_fried': 170721,          # McDONALD'S, french fries
    'eggplant_cooked': 169229,       # Eggplant, cooked, boiled
    'zucchini_cooked': 169292,       # Zucchini, cooked, boiled
    'spinach_cooked': 168463,        # Spinach, cooked, boiled
    'cabbage_raw': 169975,           # Cabbage, raw
    'lettuce': 169249,               # Lettuce, green leaf, raw
    'pepper_green': 170427,          # Peppers, sweet, green, raw
    'corn_cooked': 169999,           # Corn, sweet, yellow, cooked, boiled
    'watermelon': 167765,            # Watermelon, raw
    'lemon': 167746,                 # Lemons, raw, without peel
    'pumpkin_seeds': 170556,         # Pumpkin/squash seed kernels, dried
    'ice_cream_vanilla': 167575,     # Ice creams, vanilla
    'chocolate_dark': 170273,        # Chocolate, dark, 70-85% cacao
    'tea_black_brewed': 173227,      # Tea, black, brewed, tap water
    'coffee_brewed': 171890,         # Coffee, brewed, tap water
    'karkade': 171946,               # Tea, hibiscus, brewed
    'cola': 174852,                  # Beverages, carbonated, cola, regular
    'energy_drink': 174108,          # Beverages, Energy drink, Citrus
    'almond_milk': 174832,           # Beverages, almond milk, unsweetened
    'quinoa_cooked': 168917,         # Quinoa, cooked
    'barley_cooked': 170285,         # Barley, pearled, cooked
    'chips_potato': 170649,          # Snacks, potato chips, plain, unsalted
    'whey_protein': 173180,          # Protein powder whey based
    'protein_bar': 173158,           # Formulated Bar, SOUTH BEACH protein bar
    'turkey_pastrami': 172927,       # Pastrami, turkey
    'beef_pastrami': 170204,         # Beef, cured, pastrami
    'mortadella': 174573,            # Mortadella, beef, pork
    'hotdog': 171634,                # Frankfurter, meat and poultry, grilled
    'sausage': 170606,               # Sausage, beef, cured, cooked, smoked
    'zabadi_flavored': 170889,       # Yogurt, fruit, low fat
    'cream_whipping': 170859,        # Cream, fluid, heavy whipping
    'milk_powder': 170876,           # Milk, dry, whole
    'evaporated_milk': 172194,       # Milk, canned, evaporated
    'condensed_milk': 171275,        # Milk, canned, condensed, sweetened
    'bread_whole_wheat': 172688,     # Bread, whole-wheat, commercially prepared
    'rice_cake': 167966,             # Snacks, rice cracker brown rice, plain
    'toast_white': 174924,           # Bread, white, commercially prepared
    'bagel': 174899,                 # Bagels, plain, enriched
    'english_muffin': 175063,        # English muffins, plain, enriched
    'hash_brown': 170036,            # Potatoes, hash brown, home-prepared
    'bacon_cooked': 167914,          # Pork, cured, bacon, cooked, baked
    'ham': 167871,                   # Pork, cured, ham, extra lean, roasted
    'salami': 172947,                # Salami (hard), OSCAR MAYER
    'anchovy': 174183,               # Anchovy, european, canned in oil
    'lobster_cooked': 174209,        # Lobster, northern, cooked, moist heat
    'squid_cooked': 174223,          # Squid, mixed species (raw; see report)
    'octopus_cooked': 174249,        # Octopus, common, cooked, moist heat
    'mushroom_raw': 169251,          # Mushrooms, white, raw
    'green_beans_cooked': 169141,    # Beans, snap, green, cooked, boiled
    'turnip_cooked': 170058,         # Turnips, cooked, boiled
    'radish': 169276,                # Radishes, raw
    'parsley': 170416,               # Parsley, fresh
    'cilantro': 169997,              # Coriander (cilantro) leaves, raw
    'mint': 173475,                  # Spearmint, fresh
    'pancake': 175009,               # Pancakes, plain, prepared from recipe
    'croissant': 174987,             # Croissants, butter
    'jam_strawberry': 168758,        # Toppings, strawberry
    'ketchup': 168556,               # Catsup
    'mustard': 172234,               # Mustard, prepared, yellow
    'vinegar': 172237,               # Vinegar, distilled
    'garlic_bread': 167939,          # Garlic bread, frozen
    'sour_cream': 171257,            # Cream, sour, cultured
    'ricotta': 170851,               # Cheese, ricotta, whole milk
    'parmesan': 170848,              # Cheese, parmesan, hard
    'liver_pate': 172930,            # Pate, liver, not specified, canned
    'asparagus_cooked': 168390,      # Asparagus, cooked, boiled
    'artichoke_cooked': 168386,      # Artichokes, cooked, boiled
    'celery': 169988,                # Celery, raw
    'broccoli_cooked': 169967,       # Broccoli, cooked, boiled
    'cauliflower_cooked': 170397,    # Cauliflower, cooked, boiled
    'pizza_cheese': 170317,          # Pizza, cheese topping, regular crust
    'burger_beef': 170693,           # Fast foods, hamburger, single, plain
    'nutella': 168000,               # Chocolate-flavored hazelnut spread
}

# keep the (already correct) fdc_id, adopt the record's values
ADOPT_ONLY = {
    'dumyati_cheese': 173420,        # Cheese, feta (Domiati ~ feta)
    'rumi_cheese': 173414,           # Cheese, cheddar (Rumi ~ cheddar)
    'tortilla_flour': 167535,        # Tortillas, flour, shelf stable
}

# Egyptian/regional dishes (or no true USDA equivalent): local source, no fdc_id
LOCAL = [
    'baladi_bread', 'thareed', 'molokhia_cooked', 'molokhia_with_rice',
    'molokhia_soup', 'mahshi_mix', 'okara_stew', 'koshari', 'foul_sandwich',
    'taameya_sandwich', 'shawarma_chicken', 'hawawshi', 'macarona_beshamel',
    'machboos_rice', 'harees', 'luqaimat', 'samosa', 'kibbeh', 'tabbouleh',
    'fattoush', 'baba_ganoush', 'mutabal', 'warak_enab', 'ful_nabet', 'besara',
    'keshk', 'freekeh_cooked', 'basbousa', 'kunafa', 'baklava', 'om_ali',
    'rice_pudding', 'halawa', 'labneh', 'skim_labneh', 'ayran',
    'sugarcane_juice', 'sahlab', 'biscuit_plain', 'cake_plain', 'lasagna',
    'pasta_carbonara', 'nasi_rice_spiced', 'vermicelli_rice', 'lentil_soup',
    'chicken_soup', 'vegetable_soup', 'smoothie_banana', 'eggplant_fried',
    'onion_fried', 'broth_chicken',
]

# USDA-plausible value, but no verifiable SR Legacy id: drop fdc_id (see report)
UNVERIFIED = ['chicken_breast_raw', 'oat_milk']

NEW_FOODS = [
    {
        "id": "samoli_bread",
        "name_ar": "صامولي",
        "name_en": "samoli bread",
        "aliases": ["صامولي ساب", "ساب", "خبز صامولي", "samoli"],
        "per_100g": {"kcal": 266, "protein": 8.8, "carbs": 49.4, "fat": 3.3, "fiber": 2.7},
        "state": "baked",
        "common_portions": [
            {"name_ar": "رغيف ساب", "name_en": "1 small roll (50g)", "grams": 50},
            {"name_ar": "رغيف كبير", "name_en": "1 large roll (100g)", "grams": 100},
        ],
        "source": {"name": USDA, "fdc_id": 174924},  # Bread, white, commercially prepared
        "household_units": [
            {"unit_id": "samoli_roll_small", "grams": 50, "label_ar": "رغيف صامولي ساب", "label_en": "Small samoli roll"},
            {"unit_id": "samoli_roll_large", "grams": 100, "label_ar": "رغيف صامولي كبير", "label_en": "Large samoli roll"},
        ],
    },
    {
        "id": "beef_bacon",
        "name_ar": "بيكن بقري",
        "name_en": "beef bacon",
        "aliases": ["بيكن", "بيكون بقري", "beef bacon"],
        "per_100g": {"kcal": 449, "protein": 31.3, "carbs": 1.4, "fat": 34.4, "fiber": 0},
        "state": "cooked",
        "common_portions": [
            {"name_ar": "شريحة", "name_en": "1 slice (15g)", "grams": 15},
            {"name_ar": "شريحتان", "name_en": "2 slices (30g)", "grams": 30},
        ],
        "source": {"name": USDA, "fdc_id": 2705856},  # FNDDS: Beef, bacon, cooked
        "household_units": [
            {"unit_id": "beef_bacon_slice", "grams": 15, "label_ar": "شريحة بيكن بقري", "label_en": "Beef bacon slice"},
        ],
    },
    {
        "id": "turkey_bacon",
        "name_ar": "بيكن ديك رومي",
        "name_en": "turkey bacon",
        "aliases": ["بيكن ديك رومي", "بيكون ديك رومي", "turkey bacon"],
        "per_100g": {"kcal": 368, "protein": 29.5, "carbs": 4.2, "fat": 25.9, "fiber": 0},
        "state": "cooked",
        "common_portions": [
            {"name_ar": "شريحة", "name_en": "1 slice (15g)", "grams": 15},
            {"name_ar": "شريحتان", "name_en": "2 slices (30g)", "grams": 30},
        ],
        "source": {"name": USDA, "fdc_id": 171639},  # Bacon, turkey, microwaved
        "household_units": [
            {"unit_id": "turkey_bacon_slice", "grams": 15, "label_ar": "شريحة بيكن ديك رومي", "label_en": "Turkey bacon slice"},
        ],
    },
    {
        "id": "ranch_sauce",
        "name_ar": "صوص رانش",
        "name_en": "ranch dressing",
        "aliases": ["رانش", "دريسنج رانش", "ranch"],
        "per_100g": {"kcal": 430, "protein": 1.3, "carbs": 5.9, "fat": 44.5, "fiber": 0},
        "state": "prepared",
        "common_portions": [
            {"name_ar": "ملعقة كبيرة", "name_en": "1 tbsp (15g)", "grams": 15},
            {"name_ar": "ملعقتان", "name_en": "2 tbsp (30g)", "grams": 30},
        ],
        "source": {"name": USDA, "fdc_id": 173592},  # Salad dressing, ranch, regular
        "household_units": [
            {"unit_id": "ranch_tbsp", "grams": 15, "label_ar": "ملعقة كبيرة رانش", "label_en": "Ranch tbsp"},
        ],
    },
    {
        "id": "baked_potato",
        "name_ar": "بطاطس مشوية",
        "name_en": "baked potato",
        "aliases": ["بطاطس مشوية", "بطاطس فرن", "jacket potato"],
        "per_100g": {"kcal": 93, "protein": 2.5, "carbs": 21.2, "fat": 0.1, "fiber": 2.2},
        "state": "baked",
        "common_portions": [
            {"name_ar": "ثمرة صغيرة", "name_en": "1 small (100g)", "grams": 100},
            {"name_ar": "ثمرة متوسطة", "name_en": "1 medium (150g)", "grams": 150},
            {"name_ar": "ثمرة كبيرة", "name_en": "1 large (200g)", "grams": 200},
        ],
        "source": {"name": USDA, "fdc_id": 170093},  # Potatoes, baked, flesh and skin
        "household_units": [
            {"unit_id": "baked_potato_medium", "grams": 150, "label_ar": "بطاطس مشوية متوسطة", "label_en": "Medium baked potato"},
        ],
    },
    {
        "id": "baladi_halawa_sandwich",
        "name_ar": "رغيف بلدي محشي حلاوة",
        "name_en": "baladi loaf with halawa",
        "aliases": ["رغيف محشي حلاوة", "ساندوتش حلاوة", "بلدي محشي حلاوة"],
        # composite: 75% baladi bread (266) + 25% halawa (469)
        "per_100g": {"kcal": 317, "protein": 9.8, "carbs": 50.8, "fat": 8.8, "fiber": 4.4},
        "state": "prepared",
        "common_portions": [
            {"name_ar": "رغيف صغير محشي", "name_en": "small (80g: 60g loaf + 20g halawa)", "grams": 80},
            {"name_ar": "رغيف وسط محشي", "name_en": "medium (120g: 90g loaf + 30g halawa)", "grams": 120},
        ],
        "source": {"name": EGY},
        "household_units": [
            {"unit_id": "baladi_halawa_small", "grams": 80, "label_ar": "رغيف صغير محشي حلاوة", "label_en": "Small halawa-filled loaf"},
            {"unit_id": "baladi_halawa_medium", "grams": 120, "label_ar": "رغيف وسط محشي حلاوة", "label_en": "Medium halawa-filled loaf"},
        ],
    },
    {
        "id": "baladi_cheese_sandwich",
        "name_ar": "رغيف بلدي محشي جبنة",
        "name_en": "baladi loaf with white cheese",
        "aliases": ["رغيف محشي جبنة", "ساندوتش جبنة بلدي", "بلدي محشي جبنة"],
        # composite: 75% baladi bread (266) + 25% rumi cheese (380)
        "per_100g": {"kcal": 295, "protein": 12.9, "carbs": 39.5, "fat": 9.8, "fiber": 3.4},
        "state": "prepared",
        "common_portions": [
            {"name_ar": "رغيف صغير محشي", "name_en": "small (80g: 60g loaf + 20g cheese)", "grams": 80},
            {"name_ar": "رغيف وسط محشي", "name_en": "medium (120g: 90g loaf + 30g cheese)", "grams": 120},
        ],
        "source": {"name": EGY},
        "household_units": [
            {"unit_id": "baladi_cheese_small", "grams": 80, "label_ar": "رغيف صغير محشي جبنة", "label_en": "Small cheese-filled loaf"},
            {"unit_id": "baladi_cheese_medium", "grams": 120, "label_ar": "رغيف وسط محشي جبنة", "label_en": "Medium cheese-filled loaf"},
        ],
    },
]

d = json.load(open(PATH, encoding='utf-8'))
idx = json.load(open('tool/accuracy_bench/sr_legacy_index.json', encoding='utf-8'))
foods = d['foods']
by_id = {f['id']: f for f in foods}

def adopt(f, fdc):
    desc, vals = idx[str(fdc)]
    if not vals or 'kcal' not in vals:
        raise SystemExit(f'no values for {fdc}')
    for k in ('kcal', 'protein', 'carbs', 'fat', 'fiber'):
        if k in vals:
            f['per_100g'][k] = vals[k]

changed = {'repoint': 0, 'adopt': 0, 'local': 0, 'unverified': 0}
for fid, fdc in {**REPOINT, **ADOPT_ONLY}.items():
    f = by_id[fid]
    f['source'] = {'name': USDA, 'fdc_id': fdc}
    adopt(f, fdc)
    changed['adopt'] += 1
changed['repoint'] = len(REPOINT)

for fid in LOCAL:
    by_id[fid]['source'] = {'name': EGY}
    changed['local'] += 1

for fid in UNVERIFIED:
    by_id[fid]['source'] = {'name': USDA}
    changed['unverified'] += 1

# صامولي is now a standalone food; drop the alias from pita so exact matches win
by_id['pita_bread']['aliases'] = [a for a in by_id['pita_bread']['aliases'] if a != 'صامولي']

existing = set(by_id)
for nf in NEW_FOODS:
    if nf['id'] in existing:
        raise SystemExit(f"duplicate id {nf['id']}")
    foods.append(nf)

d['version'] = 2
json.dump(d, open(PATH, 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
print(changed, '| new foods:', len(NEW_FOODS), '| total:', len(foods))
