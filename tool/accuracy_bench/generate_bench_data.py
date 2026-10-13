import csv
import json

# Load databases
with open('assets/food_db/foods.json', encoding='utf-8') as f:
    eg_db = {x['id']: x for x in json.load(f)['foods']}

with open('assets/food_db/usda_foods.json', encoding='utf-8') as f:
    usda_db = {x['id']: x for x in json.load(f)['foods']}

combined = {**eg_db, **usda_db}

def make_meal(meal_id, category, name, components):
    total_true_kcal = 0.0
    items = []
    for food_id, grams in components:
        if food_id not in combined:
            raise ValueError(f"Food ID '{food_id}' not found in databases!")
        food = combined[food_id]
        kcal_per_100 = food['per_100g']['kcal']
        item_kcal = (grams * kcal_per_100) / 100.0
        total_true_kcal += item_kcal
        name_ar = food.get('name_ar', '')
        name_en = food.get('name_en', '')
        items.append((name_ar or name_en, grams, food_id))

    return {
        "id": meal_id,
        "category": category,
        "name": name,
        "items": items,
        "true_kcal": round(total_true_kcal)
    }

MEALS = [
    # ── 45 EGYPTIAN & ARAB REFERENCE MEALS ──
    make_meal("eg_01", "egyptian", "كشري مصري بالحمص وصلصة الطماطم", [
        ("koshari", 350),
        ("marinara_tomato_sauce", 50),
        ("chickpeas_cooked", 40),
    ]),
    make_meal("eg_02", "egyptian", "فول مدمس بزيت الزيتون وعيش بلدي", [
        ("foul_medames", 200),
        ("olive_oil", 14),
        ("baladi_bread", 100),
    ]),
    make_meal("eg_03", "egyptian", "طعمية مقلية وعيش بلدي وسلطة وطحينة", [
        ("falafel", 100),
        ("baladi_bread", 100),
        ("tabbouleh_salad", 100),
        ("tahini", 25),
    ]),
    make_meal("eg_04", "egyptian", "مكرونة بشاميل باللحم المفروم", [
        ("macarona_bechamel", 300),
        ("tabbouleh_salad", 100),
    ]),
    make_meal("eg_05", "egyptian", "صدور دجاج مشوية مع أرز أبيض وسلطة", [
        ("chicken_breast_grilled", 200),
        ("white_rice_cooked", 200),
        ("tabbouleh_salad", 100),
    ]),
    make_meal("eg_06", "egyptian", "ملوخية بالأرز والدجاج المشوي", [
        ("molokhia_cooked", 250),
        ("white_rice_cooked", 200),
        ("whole_chicken_roasted", 150),
    ]),
    make_meal("eg_07", "egyptian", "محشي مشكل مصري مع فراخ مشوية", [
        ("mahshi_mix", 350),
        ("chicken_breast_grilled", 150),
    ]),
    make_meal("eg_08", "egyptian", "حواوشي بلدي مع سلطة وطحينة", [
        ("hawawshi", 220),
        ("tahini", 30),
        ("tabbouleh_salad", 80),
    ]),
    make_meal("eg_09", "egyptian", "فتة مصرية باللحم الضاني", [
        ("fatta_egyptian", 300),
        ("lamb_cooked", 120),
    ]),
    make_meal("eg_10", "egyptian", "شاورما دجاج مع خبز عربي وثومية", [
        ("shawarma_chicken", 200),
        ("pita_bread", 80),
        ("toum_garlic_sauce", 30),
    ]),
    make_meal("eg_11", "egyptian", "كبدة إسكندراني مع عيش فينو وطحينة", [
        ("liver_beef_cooked", 180),
        ("eish_fino", 100),
        ("tahini", 25),
    ]),
    make_meal("eg_12", "egyptian", "سمك بلطي مقلي مع أرز وسلطة", [
        ("fish_tilapia_cooked", 200),
        ("white_rice_cooked", 200),
        ("tabbouleh_salad", 100),
    ]),
    make_meal("eg_13", "egyptian", "كفتة مشوية على الفحم مع عيش بلدي وسلطة", [
        ("kofta", 200),
        ("baladi_bread", 100),
        ("tabbouleh_salad", 100),
        ("tahini", 25),
    ]),
    make_meal("eg_14", "egyptian", "شوربة عدس أصفر مع عيش بلدي", [
        ("lentil_soup", 300),
        ("baladi_bread", 60),
    ]),
    make_meal("eg_15", "egyptian", "جبنة قريش بالطماطم وزيت الزيتون والعيش", [
        ("cottage_cheese", 150),
        ("tomato_raw", 100),
        ("olive_oil", 10),
        ("baladi_bread", 80),
    ]),
    make_meal("eg_16", "egyptian", "شكشوكة بيض مع عيش بلدي وزيت زيتون", [
        ("egg_omelette", 150),
        ("tomato_raw", 80),
        ("baladi_bread", 100),
        ("olive_oil", 8),
    ]),
    make_meal("eg_17", "egyptian", "لحم بقري مشوي مع أرز وكوسة مطبوخة", [
        ("beef_grilled", 200),
        ("white_rice_cooked", 200),
        ("zucchini_cooked", 120),
    ]),
    make_meal("eg_18", "egyptian", "فراخ مقلية بانيه مع مكرونة بصلصة الطماطم", [
        ("chicken_fried", 180),
        ("pasta_cooked", 200),
        ("marinara_tomato_sauce", 60),
    ]),
    make_meal("eg_19", "egyptian", "شيش طاووق مع أرز وسلطة", [
        ("chicken_breast_grilled", 220),
        ("white_rice_cooked", 200),
        ("tabbouleh_salad", 100),
    ]),
    make_meal("eg_20", "egyptian", "مسقعة بالباذنجان واللحم البقري مع عيش", [
        ("eggplant_raw", 200),
        ("marinara_tomato_sauce", 100),
        ("beef_grilled", 100),
        ("baladi_bread", 100),
    ]),
    make_meal("eg_21", "egyptian", "فول بالسجق والعيش البلدي", [
        ("foul_medames", 200),
        ("beef_grilled", 80),
        ("baladi_bread", 100),
    ]),
    make_meal("eg_22", "egyptian", "بيض مقلي بالجبن الرومي والزيتون", [
        ("egg_fried", 120),
        ("rumi_cheese", 40),
        ("olives_black_ripe", 20),
        ("baladi_bread", 80),
    ]),
    make_meal("eg_23", "egyptian", "بامية باللحمة وأرز مصري", [
        ("okra_cooked", 180),
        ("beef_grilled", 120),
        ("marinara_tomato_sauce", 80),
        ("white_rice_cooked", 200),
    ]),
    make_meal("eg_24", "egyptian", "أرز باللبن مع اللوز", [
        ("rice_pudding", 220),
        ("almonds_raw", 15),
    ]),
    make_meal("eg_25", "egyptian", "أم علي بالمكسرات والحليب", [
        ("om_ali", 200),
    ]),
    make_meal("eg_26", "egyptian", "بسبوسة مصرية بالسمن", [
        ("basbousa", 120),
    ]),
    make_meal("eg_27", "egyptian", "كنافة بالقشطة والشربات", [
        ("kunafa", 150),
    ]),
    make_meal("eg_28", "egyptian", "فطير مشلتت بالعسل الأسود والطحينة", [
        ("feteer_meshaltet", 180),
        ("asal_aswad_black_honey", 40),
        ("tahini", 20),
    ]),
    make_meal("eg_29", "egyptian", "سلطة بابا غنوج بالباذنجان المشوي والعيش", [
        ("baba_ghanoush_plain", 150),
        ("baladi_bread", 80),
    ]),
    make_meal("eg_30", "egyptian", "حمص بالطحينة وزيت الزيتون والخبز", [
        ("hummus", 150),
        ("olive_oil", 10),
        ("pita_bread", 60),
    ]),
    make_meal("eg_31", "egyptian", "عصير قصب مصري طازج", [
        ("sugarcane_juice", 300),
    ]),
    make_meal("eg_32", "egyptian", "عصير مانجو طبيعي", [
        ("mango", 250),
    ]),
    make_meal("eg_33", "egyptian", "شاي أحمر كشري بملعقتين سكر", [
        ("tea_black_brewed", 200),
        ("sugar_white_granulated", 12),
    ]),
    make_meal("eg_34", "egyptian", "شاي بحليب كامل الدسم وملعقة سكر", [
        ("milk_whole_3_25", 100),
        ("tea_black_brewed", 100),
        ("sugar_white_granulated", 6),
    ]),
    make_meal("eg_35", "egyptian", "قهوة تركي مظبوط", [
        ("coffee_brewed", 70),
        ("sugar_white_granulated", 6),
    ]),
    make_meal("eg_36", "egyptian", "كركديه مثلج محلى", [
        ("karkadeh_sweetened", 250),
    ]),
    make_meal("eg_37", "egyptian", "ساندوتش كبدة إسكندراني فينو بطحينة", [
        ("liver_beef_cooked", 90),
        ("eish_fino", 60),
        ("tahini", 15),
    ]),
    make_meal("eg_38", "egyptian", "شوربة كوارع مصرية بالليمون", [
        ("kaware_soup", 300),
    ]),
    make_meal("eg_39", "egyptian", "ساندوتش حلاوة طحينية فينو", [
        ("halawa", 60),
        ("eish_fino", 60),
    ]),
    make_meal("eg_40", "egyptian", "ساندوتش بطاطس محمرة فينو مع كاتشب", [
        ("mcdonalds_french_fries", 100),
        ("eish_fino", 60),
        ("ketchup", 20),
    ]),
    make_meal("eg_41", "egyptian", "شوربة دجاج بالخضار", [
        ("chicken_soup", 250),
        ("chicken_breast_grilled", 80),
    ]),
    make_meal("eg_42", "egyptian", "طاجن خضار مشكل باللحم وأرز", [
        ("zucchini_cooked", 120),
        ("green_beans_cooked", 80),
        ("beef_grilled", 100),
        ("marinara_tomato_sauce", 60),
        ("white_rice_cooked", 180),
    ]),
    make_meal("eg_43", "egyptian", "أرز بسمتي بالمكسرات وكفتة", [
        ("white_rice_cooked", 200),
        ("almonds_raw", 15),
        ("raisins_seedless", 15),
        ("kofta", 150),
    ]),
    make_meal("eg_44", "egyptian", "سمك مشوي بالردة مع عيش وسلطة", [
        ("fish_tilapia_cooked", 220),
        ("baladi_bread", 80),
        ("tabbouleh_salad", 100),
    ]),
    make_meal("eg_45", "egyptian", "حمام محشي فريك وسلطة خضراء", [
        ("chicken_breast_grilled", 220),
        ("bulgur_cooked", 120),
        ("tabbouleh_salad", 100),
    ]),

    # ── 25 GENERIC / WESTERN REFERENCE MEALS ──
    make_meal("gen_01", "generic", "شوفان مطبوخ بالحليب والموز وزبدة الفول السوداني", [
        ("oatmeal_cooked_water", 180),
        ("milk_whole_3_25", 150),
        ("banana", 100),
        ("peanut_butter_smooth", 20),
    ]),
    make_meal("gen_02", "generic", "بيضتان مسلوقتان وتوست أسمر وأفوكادو", [
        ("egg_boiled", 100),
        ("toast_white", 60),
        ("avocado", 50),
    ]),
    make_meal("gen_03", "generic", "سلطة يونانية بالجبن الفيتا والزيتون وزيت زيتون", [
        ("greek_salad_feta_olives", 250),
        ("olive_oil", 10),
    ]),
    make_meal("gen_04", "generic", "ستيك سلمون مشوي مع بروكلي وبطاطا حلوة", [
        ("fish_salmon_cooked", 180),
        ("broccoli_steamed", 120),
        ("sweet_potato_baked", 150),
    ]),
    make_meal("gen_05", "generic", "مكرونة بصوص اللحم البولونيز والجبن", [
        ("pasta_white_cooked", 200),
        ("bolognese_meat_sauce", 150),
        ("parmesan_grated", 15),
    ]),
    make_meal("gen_06", "generic", "بيتزا مارجريتا بالجبن الموزاريلا", [
        ("pizza_cheese", 250),
    ]),
    make_meal("gen_07", "generic", "برجر لحم بقري مع خبز وجبن شيدر", [
        ("burger_beef", 150),
        ("cheddar_cheese", 25),
        ("lettuce", 40),
    ]),
    make_meal("gen_08", "generic", "بطاطس مقلية فرنش فرايز مع كاتشب", [
        ("mcdonalds_french_fries", 150),
        ("ketchup", 30),
    ]),
    make_meal("gen_09", "generic", "سلطة سيزر بالدجاج المشوي", [
        ("caesar_salad_grilled_chicken", 280),
    ]),
    make_meal("gen_10", "generic", "ستيك لحم بقري مشوي مع خضار سوتيه وزبدة", [
        ("beef_grilled", 220),
        ("zucchini_cooked", 80),
        ("broccoli_steamed", 70),
        ("butter_salted", 10),
    ]),
    make_meal("gen_11", "generic", "زبادي يوناني بالعسل والتوت واللوز", [
        ("yogurt_greek", 170),
        ("honey", 20),
        ("blueberries_raw", 50),
        ("almonds_raw", 20),
    ]),
    make_meal("gen_12", "generic", "ساندوتش تونة بالمايونيز والتوست", [
        ("fish_tuna_canned", 120),
        ("mayonnaise_regular", 20),
        ("toast_white", 60),
    ]),
    make_meal("gen_13", "generic", "ساندوتش تركي رومي مدخن وجبن سويسري وتوست", [
        ("turkey_breast", 90),
        ("cheddar_cheese", 30),
        ("toast_white", 60),
    ]),
    make_meal("gen_14", "generic", "شوربة دجاج بالخضار والمشروم", [
        ("chicken_soup", 280),
        ("mushrooms_white_raw", 50),
    ]),
    make_meal("gen_15", "generic", "مكرونة ألفريدو بالكريمة والدجاج المشوي", [
        ("pasta_white_cooked", 220),
        ("chicken_breast_grilled", 120),
        ("alfredo_cream_sauce", 60),
    ]),
    make_meal("gen_16", "generic", "فاهيتا دجاج مع خضار مشكل وجبن شيدر", [
        ("chicken_breast_grilled", 180),
        ("zucchini_cooked", 100),
        ("cheddar_cheese", 25),
    ]),
    make_meal("gen_17", "generic", "بان كيك بالعسل والزبدة", [
        ("pancake_plain", 150),
        ("honey", 30),
        ("butter_salted", 12),
    ]),
    make_meal("gen_18", "generic", "كرواسون بالزبدة مع كابتشينو", [
        ("croissant", 70),
        ("cappuccino_whole_milk", 200),
    ]),
    make_meal("gen_19", "generic", "أرز أبيض مع سمك سلمون مطبوخ وصويا صوص", [
        ("white_rice_cooked", 200),
        ("fish_salmon_cooked", 150),
        ("soy_sauce", 15),
    ]),
    make_meal("gen_20", "generic", "تاكو لحم مفروم مع صلصة وصلصة طماطم وجبن", [
        ("beef_grilled", 120),
        ("marinara_tomato_sauce", 40),
        ("cheddar_cheese", 30),
    ]),
    make_meal("gen_21", "generic", "سلطة كينوا بالخضار والأفوكادو وزيت زيتون", [
        ("quinoa_salad_vegetables", 200),
        ("avocado", 50),
        ("olive_oil", 10),
    ]),
    make_meal("gen_22", "generic", "ناجتس دجاج مقلية مع صوص باربيكيو", [
        ("albaik_nuggets_10pc", 120),
        ("barbecue_bbq_sauce", 30),
    ]),
    make_meal("gen_23", "generic", "شوربة خضار مشكلة بجبن شيدر", [
        ("vegetable_soup", 260),
        ("cheddar_cheese", 25),
    ]),
    make_meal("gen_24", "generic", "كعك مع قهوة بالحليب كامل الدسم", [
        ("cake_plain", 75),
        ("latte_whole_milk", 250),
    ]),
    make_meal("gen_25", "generic", "كيك شوكولاتة مع آيس كريم فانيليا", [
        ("cake_plain", 90),
        ("ice_cream_vanilla", 75),
    ]),
]

with open("tool/accuracy_bench/reference_meals.csv", "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["meal_id", "category", "meal_name", "items_spec", "true_kcal"])
    for m in MEALS:
        spec = "|".join([f"{name}:{grams}:{tag}" for (name, grams, tag) in m["items"]])
        writer.writerow([m["id"], m["category"], m["name"], spec, m["true_kcal"]])

print(f"Generated {len(MEALS)} verified reference meals in tool/accuracy_bench/reference_meals.csv")
