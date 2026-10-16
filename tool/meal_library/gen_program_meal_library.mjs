// Generates lib/features/diet_programs/data/program_meal_library_data.dart
//
// Usage (from repo root):  node tool/meal_library/gen_program_meal_library.mjs
//
// Every option is a list of (foodDbId, grams). Macros are SUMMED from the
// per-100 g values in assets/food_db/foods.json, so nothing is guessed.
// The script aborts if a food id does not exist in the DB.
//
// Tags:  n = no cook, b = budget, s = Ramadan suhoor, f = deep fried,
//        p = processed (jam, protein powder, pastrami, bars).

import fs from 'node:fs';

const foods = new Map(
  JSON.parse(fs.readFileSync('assets/food_db/foods.json', 'utf8')).foods.map((f) => [f.id, f]),
);

const dishes = [];
function D(slot, id, ar, en, comps, prep, hm, tags = '') {
  dishes.push({ slot, rawId: id, ar, en, comps, prep, hm, tags });
}

// ───────────────────────── BREAKFAST ─────────────────────────
const B = (...a) => D('breakfast', ...a);
B('bf_ful_zeit', 'فول بالزيت وعيش بلدي', 'Ful medames with olive oil and baladi bread', 'ful_medames_plain:180,olive_oil:7,baladi_bread:45,tomato_raw:60', 5, 'طبق فول صغير (٤ معالق كبيرة) + نص رغيف بلدي + طماطم', 'bs');
B('bf_ful_tahina', 'فول بالطحينة مع خيار ونص رغيف', 'Ful with tahini, cucumber and half a loaf', 'ful_with_tahina:170,baladi_bread:45,cucumber:80', 5, 'طبق فول بالطحينة + نص رغيف + خيار', 'b');
B('bf_ful_iskandarani', 'فول إسكندراني بعيش بلدي', 'Alexandrian ful with baladi bread', 'ful_iskandarani:200,baladi_bread:45', 5, 'طبق فول إسكندراني + نص رغيف', 'b');
B('bf_ful_egg_nobread', 'فول بالليمون وزيت الزيتون مع بيضة مسلوقة', 'Ful with lemon and olive oil plus a boiled egg', 'ful_with_olive_oil:150,egg_boiled:50,cucumber:80', 8, '٣ معالق كبيرة فول + بيضة مسلوقة + خيار (من غير عيش)', 'bs');
B('bf_taameya_baked_bread', 'طعمية مشوية في الفرن بعيش بلدي وسلطة', 'Oven-baked taameya with baladi bread and salad', 'taameya_baked_airfryer:100,baladi_bread:45,salata_khadra_masri:120', 20, '٣ أقراص طعمية مشوية + نص رغيف + طبق سلطة', 'b');
B('bf_taameya_baked_tahini', 'طعمية مشوية بدون عيش مع سلطة وطحينة', 'Baked taameya without bread, salad and tahini', 'taameya_baked_airfryer:80,tahini:10,salata_khadra_masri:150', 20, '٣ أقراص صغيرة + معلقة طحينة + طبق سلطة', 'b');
B('bf_taameya_baked_sandwich', 'ساندوتش طعمية مشوية بالسلطة والطحينة', 'Baked taameya sandwich with salad and tahini', 'taameya_baked_airfryer:90,baladi_bread:60,tomato_raw:40,lettuce:20,tahini:8', 20, 'ساندوتش في ثلثين رغيف بلدي', 'b');
B('bf_eggs_boiled_salad', 'بيضتين مسلوقتين مع خيار وطماطم بزيت الزيتون', 'Two boiled eggs with cucumber, tomato and olive oil', 'egg_boiled:100,cucumber:100,tomato_raw:100,olive_oil:8', 10, 'بيضتين مسلوقتين + خيارة + طماطمة + معلقة زيت زيتون', 'b');
B('bf_eggs3_quraish', '٣ بيضات مسلوقة مع جبنة قريش وخيار', 'Three boiled eggs with cottage cheese and cucumber', 'egg_boiled:150,gebna_quraish:100,cucumber:60,olive_oil:5', 10, '٣ بيضات + نص علبة قريش + خيار', 'b');
B('bf_eggs_eyes', 'بيض عيون بنص رغيف وطماطم', 'Fried eggs with half a loaf and tomato', 'egg_fried:100,baladi_bread:45,tomato_raw:80', 8, 'بيضتين عيون + نص رغيف بلدي + طماطم', 'b');
B('bf_omelet_veg', 'أومليت خضار بالمشروم والفلفل', 'Vegetable omelette with mushrooms and peppers', 'egg_omelette:200,mushroom_raw:60,pepper_green:40,tomato_raw:50,olive_oil:5', 12, 'أومليت من ٣ بيضات بالخضار', '');
B('bf_ejja_parsley', 'عجة بالبقدونس والبصل مع نص رغيف', 'Egyptian herb ejja with half a loaf', 'omelette_vegetables_egyptian:180,baladi_bread:45', 12, 'قطعتين عجة + نص رغيف بلدي', 'b');
B('bf_shakshouka', 'شكشوكة بيض بالطماطم ونص رغيف', 'Egg shakshuka with half a loaf', 'shakshouka_egyptian:250,baladi_bread:45', 15, 'طبق شكشوكة (بيضتين) + نص رغيف', 'b');
B('bf_quraish_tomato', 'جبنة قريش بالطماطم والخيار وزيت الزيتون', 'Cottage cheese with tomato, cucumber and olive oil', 'gebna_quraish:120,tomato_raw:80,cucumber:60,olive_oil:10', 5, 'نص علبة قريش + طماطم + خيار + معلقة زيت زيتون', 'nb');
B('bf_quraish_sandwich', 'ساندوتش جبنة قريش وخيار في عيش بلدي', 'Cottage cheese and cucumber baladi sandwich', 'baladi_bread:60,gebna_quraish:80,cucumber:50,tomato_raw:40', 5, 'ساندوتش في ثلثين رغيف بلدي', 'nb');
B('bf_white_cheese_light', 'جبنة بيضاء لايت (٣٠ جم) مع نص رغيف وخضار', 'Light white cheese portion with half a loaf and veg', 'white_cheese_egyptian:30,baladi_bread:45,cucumber:100,tomato_raw:80', 5, 'قطعة جبنة بيضاء صغيرة (٣٠ جم) + نص رغيف + خضار', 'nb');
B('bf_greek_honey_walnut', 'زبادي يوناني بالعسل والجوز', 'Greek yogurt with honey and walnuts', 'yogurt_greek:170,honey:10,walnuts:15', 3, 'علبة زبادي يوناني + معلقة صغيرة عسل + ٣ حبات جوز', 'n');
B('bf_greek_strawberry', 'زبادي يوناني بالفراولة واللوز', 'Greek yogurt with strawberries and almonds', 'yogurt_greek:200,strawberry:100,almonds:10', 3, 'علبة كبيرة زبادي يوناني + حفنة فراولة + ٨ حبات لوز', 'n');
B('bf_oats_milk_banana', 'شوفان بالحليب والموز', 'Oats with milk and banana', 'oats_dry:40,milk_skim:200,banana:60', 8, '٤ معالق كبيرة شوفان + كوباية حليب + نص موزة', '');
B('bf_oats_overnight_dates', 'شوفان بالزبادي والتمر (منقوع بالليل)', 'Overnight oats with yogurt and dates', 'oats_dry:40,yogurt_plain:150,tamr_saqei_dry:15', 3, 'برطمان صغير شوفان منقوع + ٢ تمر', 'ns');
B('bf_oats_suhoor', 'سحور: شوفان بالحليب والتمر واللوز', 'Suhoor: oats with milk, dates and almonds', 'oats_dry:45,milk_whole:200,tamr_saqei_dry:10,almonds:10', 8, 'طبق شوفان بالحليب + تمرة + حفنة لوز صغيرة', 'bs');
B('bf_feteer_light_quraish', 'فطير خفيف بجبنة قريش وخيار', 'Light feteer with cottage cheese and cucumber', 'feteer_meshaltet:70,gebna_quraish:60,cucumber:60', 10, 'نص فطيرة مشلتت صغيرة + قريش + خيار', '');
B('bf_toast_lowsugar_jam', 'توست أسمر بمربى قليل السكر وجبنة قريش', 'Wholewheat toast with low-sugar jam and cottage cheese', 'bread_whole_wheat:50,jam_strawberry:10,gebna_quraish:60', 5, 'شريحتين توست أسمر + معلقة صغيرة مربى + قريش', 'p');
B('bf_toast_tahini_honey', 'توست أسمر بالطحينة والعسل', 'Wholewheat toast with tahini and honey', 'bread_whole_wheat:50,tahini:12,honey:8', 3, 'شريحتين توست + معلقة طحينة + نص معلقة عسل', 'n');
B('bf_sandwich_egg', 'ساندوتش بيض مسلوق وخضار في عيش بلدي', 'Boiled egg and veg baladi sandwich', 'baladi_bread:60,egg_boiled:100,lettuce:20,tomato_raw:50', 10, 'ساندوتش في ثلثين رغيف بلدي', 'b');
B('bf_sandwich_tuna', 'ساندوتش تونة بالزبادي والخيار', 'Tuna and yogurt sandwich with cucumber', 'baladi_bread:60,fish_tuna_canned:70,cucumber:50,lettuce:20,yogurt_plain:30', 5, 'ساندوتش في ثلثين رغيف + نص علبة تونة', 'n');
B('bf_sandwich_turkey', 'ساندوتش بسطرمة ديك رومي وخضار', 'Turkey pastrami and veg sandwich', 'bread_whole_wheat:60,turkey_pastrami:50,tomato_raw:50,lettuce:20,cucumber:30', 5, 'ساندوتش توست أسمر + ٣ شرايح بسطرمة', 'np');
B('bf_sandwich_ful', 'ساندوتش فول بلدي بالطماطم', 'Baladi ful sandwich with tomato', 'ful_medames_plain:120,baladi_bread:70,tomato_raw:40', 5, 'ساندوتش فول في ثلثين رغيف بلدي', 'b');
B('bf_shake_banana', 'بروتين شيك بالموز والحليب', 'Protein shake with banana and milk', 'whey_protein:30,milk_skim:250,banana:60', 3, 'سكوب بروتين + كوباية حليب + نص موزة', 'np');
B('bf_shake_oats', 'بروتين شيك بالشوفان', 'Protein shake with oats', 'whey_protein:30,milk_skim:250,oats_dry:25', 3, 'سكوب بروتين + كوباية حليب + ٢ معلقة شوفان', 'np');
B('bf_shake_almond_tahini', 'بروتين شيك بلبن اللوز والطحينة', 'Protein shake with almond milk and tahini', 'whey_protein:30,almond_milk:250,tahini:15', 3, 'سكوب بروتين + كوباية لبن لوز + معلقة طحينة', 'np');
B('bf_dates_milk', '٣ تمرات وكوب لبن', 'Three dates and a glass of milk', 'tamr_saqei_dry:30,milk_whole:200', 2, '٣ تمرات صغيرة + كوباية لبن', 'nbs');
B('bf_suhoor_ful_egg_yogurt', 'سحور: فول وبيضة وزبادي مع نص رغيف', 'Suhoor: ful, egg and yogurt with half a loaf', 'ful_medames_plain:150,egg_boiled:50,yogurt_plain:120,baladi_bread:45', 8, 'طبق فول + بيضة + علبة زبادي + نص رغيف', 'bs');
B('bf_suhoor_labneh', 'سحور: لبنة قليلة الدسم بالخيار والزيتون', 'Suhoor: low-fat labneh with cucumber and olives', 'skim_labneh:100,cucumber:80,olive_pickled_kalamata:20,olive_oil:8', 3, '٣ معالق كبيرة لبنة + خيار + زيتون', 'ns');
B('bf_suhoor_eggs_dates_milk', 'سحور: بيضتين وتمرتين وكوب لبن', 'Suhoor: two eggs, two dates and milk', 'egg_boiled:100,tamr_saqei_dry:20,milk_whole:200', 10, 'بيضتين مسلوقتين + تمرتين + كوباية لبن', 'bs');
B('bf_suhoor_yogurt_cheese', 'سحور: زبادي وجبنة بيضاء وخيار مع نص رغيف', 'Suhoor: yogurt, white cheese and cucumber with bread', 'yogurt_plain:200,white_cheese_egyptian:40,cucumber:100,baladi_bread:45', 5, 'علبة زبادي + قطعة جبنة + خيار + نص رغيف', 'nbs');
B('bf_avocado_egg', 'أفوكادو مع بيضتين مسلوقتين', 'Avocado with two boiled eggs', 'avocado:100,egg_boiled:100', 10, 'نص أفوكادو كبيرة + بيضتين مسلوقتين', '');
B('bf_omelet_spinach_roumi', 'أومليت بالسبانخ والجبنة الرومي', 'Spinach and roumi cheese omelette', 'egg_omelette:130,spinach_cooked:50,gebna_roumi:25', 10, 'أومليت من بيضتين + سبانخ + شريحة رومي', '');
B('bf_eggs_pastrami', 'بيض بالبسطرمة مع خيار', 'Eggs with pastrami and cucumber', 'eggs_pastrami:150,cucumber:80', 10, 'بيضتين بالبسطرمة + خيار', 'p');
B('bf_eggs_medahraj', 'بيض مدهرج (محمّر) مع خيار', 'Browned eggs with cucumber', 'eggs_medahraj_browned:100,cucumber:100', 12, 'بيضتين مدهرج + خيار', '');
B('bf_roumi_grilled_tomato', 'جبنة رومي مشوية بالطماطم وبيضة مسلوقة', 'Grilled roumi cheese with tomato and a boiled egg', 'gebna_roumi:50,tomato_raw:100,olive_oil:5,egg_boiled:50', 10, 'شريحتين رومي + طماطم + بيضة', '');
B('bf_greek_nuts_nosugar', 'زبادي يوناني بالجوز واللوز بدون سكر', 'Greek yogurt with walnuts and almonds, no sugar', 'yogurt_greek:130,walnuts:20,almonds:5', 3, 'نص علبة زبادي يوناني + ٤ حبات جوز + لوز', 'n');
B('bf_egg_tahini_olives', 'بيضتين بالطحينة والزيتون مع خيار', 'Boiled eggs with tahini, olives and cucumber', 'egg_boiled:100,tahini:15,olive_pickled_kalamata:20,cucumber:60', 10, 'بيضتين + معلقة طحينة + زيتون + خيار', 'b');
B('bf_avocado_quraish', 'أفوكادو بجبنة قريش وزيت الزيتون', 'Avocado with cottage cheese and olive oil', 'avocado:100,gebna_quraish:80,olive_oil:5', 5, 'نص أفوكادو + ٥ معالق قريش', 'n');
B('bf_egg_cheese_tomato', 'بيض بقليل من الزبدة مع جبنة بيضاء وطماطم', 'Eggs in a little butter with white cheese and tomato', 'egg_fried:100,white_cheese_egyptian:30,tomato_raw:50', 8, 'بيضتين + قطعة جبنة بيضاء + طماطم', 'b');

B('bf_hp_eggs_quraish_toast', '٣ بيضات مسلوقة وقريش مع ربع رغيف', 'Three boiled eggs and cottage cheese with a quarter loaf', 'egg_boiled:150,gebna_quraish:100,baladi_bread:30', 10, '٣ بيضات + علبة قريش + ربع رغيف', 'b');
B('bf_hp_omelet_quraish', 'أومليت بالقريش والطماطم', 'Omelette with cottage cheese and tomato', 'egg_omelette:200,gebna_quraish:80,tomato_raw:60', 12, 'أومليت من ٣ بيضات + قريش + طماطم', 'b');
B('bf_hp_greek_whey_oats', 'زبادي يوناني بالبروتين والشوفان', 'Greek yogurt bowl with whey and oats', 'yogurt_greek:200,whey_protein:20,oats_dry:20', 4, 'علبة زبادي يوناني + نص سكوب بروتين + ٢ معلقة شوفان', 'np');
B('bf_hp_tuna_egg_sandwich', 'ساندوتش تونة وبيض في عيش بلدي', 'Tuna and egg baladi sandwich', 'baladi_bread:60,fish_tuna_canned:90,egg_boiled:50,cucumber:40', 10, 'ساندوتش في ثلثين رغيف + علبة تونة + بيضة', '');
B('bf_hp_quraish_bowl', 'طبق قريش بالفراولة واللوز', 'Cottage cheese bowl with strawberries and almonds', 'gebna_quraish:200,strawberry:100,almonds:10', 4, 'علبة قريش كبيرة + فراولة + لوز', 'n');
B('bf_hp_shakshouka_double', 'شكشوكة بيض كبيرة مع قريش', 'Large egg shakshuka with cottage cheese', 'shakshouka_egyptian:300,gebna_quraish:60', 15, 'طبق شكشوكة (٣ بيضات) + قريش', 'b');
B('bf_hp_turkey_omelet', 'أومليت بالديك الرومي والخضار', 'Turkey and veg omelette', 'egg_omelette:200,turkey_breast_roasted:50,pepper_green:40,tomato_raw:50', 12, 'أومليت من ٣ بيضات + شرايح ديك رومي', '');
B('bf_hp_roumi_mushroom_omelet', 'أومليت بالجبنة الرومي والمشروم', 'Roumi cheese and mushroom omelette', 'egg_omelette:130,gebna_roumi:25,mushroom_raw:50,olive_oil:3', 10, 'أومليت من بيضتين + مشروم', '');
B('bf_labneh_avocado', 'لبنة بالأفوكادو والخيار', 'Labneh with avocado and cucumber', 'labneh:60,avocado:80,cucumber:60', 4, '٣ معالق لبنة + نص أفوكادو + خيار', 'n');

// ───────────────────────── LUNCH ─────────────────────────
const L = (...a) => D('lunch', ...a);
L('ln_chicken_rice_salad', 'فراخ مشوية مع رز أبيض وسلطة', 'Grilled chicken with white rice and salad', 'chicken_breast_grilled:150,white_rice_cooked:150,salata_khadra_masri:150', 30, 'صدر فراخ (١٥٠ جم) + كوباية رز + طبق سلطة', '');
L('ln_chicken_sweetpotato', 'فراخ مشوية على الفحم مع بطاطا مشوية وسلطة', 'Charcoal chicken with baked sweet potato and salad', 'faraaj_mashweya:180,sweet_potato_cooked:135,salata_khadra_masri:120', 35, 'ربع فرخة + بطاطا متوسطة + سلطة', '');
L('ln_kofta_baladi_tahini', 'كفتة مشوية مع عيش بلدي وسلطة وطحينة', 'Grilled kofta with baladi bread, salad and tahini', 'kofta_mashweya:120,baladi_bread:45,salata_khadra_masri:150,tahini:10', 25, '٣ أصابع كفتة + نص رغيف + سلطة', '');
L('ln_kofta_salad', 'كفتة مشوية مع سلطة بدون عيش', 'Grilled kofta with salad, no bread', 'kofta_mashweya:140,salata_khadra_masri:90,olive_oil:5', 25, '٤ أصابع كفتة + طبق سلطة صغير', '');
L('ln_kofta_tahini_cucumber', 'كفتة مشوية بالطحينة والخيار', 'Grilled kofta with tahini and cucumber', 'kofta_mashweya:150,tahini:10,cucumber:60', 25, '٤ أصابع كفتة + معلقة طحينة + خيار', '');
L('ln_kofta_zucchini', 'كفتة مشوية مع كوسة سوتيه', 'Grilled kofta with sauteed zucchini', 'kofta_mashweya:150,zucchini_cooked:150,olive_oil:5', 30, '٤ أصابع كفتة + طبق كوسة', '');
L('ln_molokhia_chicken_rice', 'ملوخية بالفراخ مع رز أبيض', 'Molokhia with chicken and white rice', 'molokhia_with_chicken:250,white_rice_cooked:120,chicken_breast_grilled:100', 40, 'طبق ملوخية + نص كوباية رز + حتة فراخ', '');
L('ln_molokhia_shrimp', 'ملوخية بالجمبري بدون رز مع سلطة', 'Molokhia with shrimp, no rice, with salad', 'mulukhiyah_shrimp:300,salata_khadra_masri:100', 30, 'طبق ملوخية بالجمبري + سلطة', '');
L('ln_bamya_meat_rice', 'بامية باللحمة مع رز أبيض', 'Okra stew with meat and white rice', 'bamya_with_meat:250,white_rice_cooked:100', 45, 'طبق بامية باللحمة + نص كوباية رز', '');
L('ln_bolti_rice_salad', 'سمك بلطي مشوي مع رز وسلطة', 'Grilled tilapia with rice and salad', 'samak_bolti_mashwi:200,white_rice_cooked:100,salata_khadra_masri:100', 30, 'سمكة بلطي متوسطة + نص كوباية رز + سلطة', '');
L('ln_shrimp_salad', 'جمبري مشوي بالليمون مع سلطة خضراء', 'Lemon grilled shrimp with green salad', 'gambari_mashwi:200,salata_khadra_masri:90,olive_oil:8', 20, 'طبق جمبري (٢٠٠ جم) + سلطة', '');
L('ln_denise_zucchini', 'سمك دنيس مشوي مع كوسة سوتيه', 'Grilled sea bream with sauteed zucchini', 'sea_bream_denise_mashwi:250,zucchini_cooked:150,olive_oil:8', 30, 'سمكة دنيس صغيرة + طبق كوسة', '');
L('ln_seabass_broccoli', 'قاروص مشوي بزيت الزيتون مع بروكلي', 'Olive oil sea bass with broccoli', 'sea_bass_mashwi_oil_lemon:250,broccoli_cooked:150,olive_oil:8', 30, 'سمكة قاروص صغيرة + طبق بروكلي', '');
L('ln_kebda_iskandarani', 'كبدة إسكندراني مع عيش بلدي وسلطة', 'Alexandrian liver with baladi bread and salad', 'kebda_iskandarani:150,baladi_bread:45,salata_khadra_masri:100', 20, 'طبق كبدة صغير + نص رغيف + سلطة', 'b');
L('ln_liver_diet_salad', 'كبدة مشوية بدون زيت مع سلطة', 'Oil-free grilled liver with salad', 'beef_liver_grilled_diet:150,salata_khadra_masri:100,olive_oil:5', 20, 'طبق كبدة مشوية (١٥٠ جم) + سلطة', 'b');
L('ln_grape_leaves_chicken', 'ورق عنب مع فراخ مشوية', 'Stuffed grape leaves with grilled chicken', 'mahshi_waraq_enab:150,faraaj_mashweya:100', 45, '٦ أصابع ورق عنب + حتة فراخ مشوية', '');
L('ln_mahshi_kousa_yogurt', 'محشي كوسة مع زبادي لايت', 'Stuffed zucchini with light yogurt', 'mahshi_kousa:250,zabadi_diet_light:100', 60, '٥ حبات كوسة محشية + علبة زبادي', '');
L('ln_mahshi_kromb_salad', 'محشي كرنب مع سلطة', 'Stuffed cabbage with salad', 'mahshi_kromb:250,salata_khadra_masri:100', 60, '٥ لفات كرنب + سلطة', '');
L('ln_koshary_small', 'كشري (طبق صغير) مع سلطة', 'Small koshary plate with salad', 'koshary_egyptian:300,salata_khadra_masri:100', 15, 'طبق كشري صغير (٣٠٠ جم) + سلطة', 'b');
L('ln_lentils_brown_rice', 'عدس مسلوق مع رز بني وسلطة', 'Lentils with brown rice and salad', 'lentils_cooked:200,brown_rice_cooked:100,salata_khadra_masri:100', 30, 'طبق عدس + نص كوباية رز بني + سلطة', 'b');
L('ln_fasolia_chicken_rice', 'فاصوليا خضرا مع فراخ مشوية ورز', 'Green bean stew with grilled chicken and rice', 'fasolia_khadra_stew:250,chicken_breast_grilled:100,white_rice_cooked:100', 40, 'طبق فاصوليا + حتة فراخ + نص كوباية رز', '');
L('ln_fasolia_beida', 'فاصوليا بيضا بالصلصة مع سلطة ونص رغيف', 'White bean stew with salad and half a loaf', 'fasolia_beida_stew:300,salata_khadra_masri:150,baladi_bread:45', 40, 'طبق فاصوليا بيضا + سلطة + نص رغيف', 'b');
L('ln_sabanekh_rice', 'سبانخ باللحمة مع رز', 'Spinach stew with beef and rice', 'sabanekh_bel_lahma:300,white_rice_cooked:100', 40, 'طبق سبانخ باللحمة + نص كوباية رز', '');
L('ln_torly_bread', 'طاجن تورلي باللحمة مع نص رغيف', 'Meat and vegetable torly with half a loaf', 'torly_khodhar:350,baladi_bread:45', 50, 'طاجن تورلي صغير + نص رغيف', '');
L('ln_chicken_vegsoup_salad', 'فراخ مشوية مع شوربة خضار وسلطة', 'Grilled chicken with vegetable soup and salad', 'chicken_breast_grilled:150,vegetable_soup:250,salata_khadra_masri:100', 30, 'صدر فراخ + طبق شوربة خضار + سلطة', '');
L('ln_turkey_salad', 'ديك رومي مشوي مع سلطة وزيت زيتون', 'Roasted turkey with salad and olive oil', 'turkey_breast_roasted:150,salata_khadra_masri:90,olive_oil:8', 20, 'شرايح ديك رومي (١٥٠ جم) + سلطة', '');
L('ln_tuna_egg_salad', 'سلطة تونة وبيض مع زيت الزيتون', 'Tuna and egg salad with olive oil', 'fish_tuna_canned:120,salata_khadra_masri:150,olive_oil:10,egg_boiled:50', 10, 'علبة تونة + بيضة + طبق سلطة', 'n');
L('ln_tuna_avocado', 'سلطة تونة وأفوكادو بالخيار', 'Tuna and avocado salad with cucumber', 'fish_tuna_canned:100,avocado:80,cucumber:80,olive_oil:5', 10, 'علبة تونة + نص أفوكادو + خيار', 'n');
L('ln_chicken_kofta_tabbouleh', 'كفتة فراخ مشوية مع تبولة', 'Grilled chicken kofta with tabbouleh', 'grilled_kofta_chicken:150,tabbouleh_salad:120', 25, '٣ أصابع كفتة فراخ + طبق تبولة', '');
L('ln_shish_tawook', 'شيش طاووق مع سلطة ونص رغيف وثومية', 'Shish tawook with salad, bread and garlic sauce', 'shish_tawook_skewer:180,salata_khadra_masri:150,baladi_bread:45,toum_garlic_sauce:10', 30, 'سيخين شيش طاووق + سلطة + نص رغيف', '');
L('ln_kandouz_zucchini', 'لحمة كندوز مسلوقة مع كوسة', 'Boiled lean beef with zucchini', 'lahem_kandouz_maslouq:150,kousa_cooked:200,salata_khadra_masri:60', 45, 'حتة لحمة (١٥٠ جم) + طبق كوسة', '');
L('ln_qolqas_beef', 'قلقاس بالسلق واللحمة', 'Taro with chard and beef', 'qolqas_salq_taro:250,salata_khadra_masri:100', 45, 'طبق قلقاس + سلطة', '');
L('ln_besella_rice', 'بسلة بالجزر مع رز', 'Peas and carrots stew with rice', 'besella_bel_gazar:300,white_rice_cooked:100', 40, 'طبق بسلة + نص كوباية رز', 'b');
L('ln_fatta_small', 'فتة باللحمة (طبق صغير) مع سلطة', 'Small beef fatta with salad', 'fatta_egyptian:250,salata_khadra_masri:100', 40, 'طبق فتة صغير + سلطة', '');
L('ln_pasta_chicken', 'مكرونة بالصلصة الطازجة وصدر فراخ', 'Pasta with fresh tomato sauce and chicken', 'pasta_cooked:150,chicken_breast_grilled:100,tomato_raw:100,olive_oil:5', 25, 'طبق مكرونة صغير + صدر فراخ', '');
L('ln_bulgur_chicken', 'برغل بالخضار مع فراخ مشوية', 'Bulgur with grilled chicken and salad', 'bulgur_cooked:150,chicken_breast_grilled:120,salata_khadra_masri:100', 30, 'كوباية برغل + صدر فراخ + سلطة', '');
L('ln_brownrice_chicken_broccoli', 'رز بني مع فراخ مشوية وبروكلي', 'Brown rice with grilled chicken and broccoli', 'brown_rice_cooked:150,chicken_breast_grilled:130,broccoli_cooked:120', 30, 'كوباية رز بني + صدر فراخ + بروكلي', '');
L('ln_chicken_salad_yogurt', 'سلطة فراخ مشوية بصوص الزبادي', 'Grilled chicken salad with yogurt dressing', 'chicken_breast_grilled:150,lettuce:100,tomato_raw:80,cucumber:80,yogurt_plain:50,olive_oil:10', 15, 'طبق سلطة كبير + صدر فراخ', '');
L('ln_chicken_liver_baladi', 'كبدة فراخ بالبصل مع سلطة ونص رغيف', 'Chicken liver with onions, salad and half a loaf', 'chicken_liver_pan:150,salata_khadra_masri:100,baladi_bread:45', 20, 'طبق كبدة فراخ + سلطة + نص رغيف', 'b');
L('ln_kofta_dawood_rice', 'كفتة داود باشا بالصلصة مع رز', 'Dawood Basha meatballs with rice', 'kofta_dawood_basha:200,white_rice_cooked:100', 35, '٥ حبات كفتة بالصلصة + نص كوباية رز', '');
L('ln_waraq_lahma_salad', 'لحمة بالفرن في ورق القصدير مع سلطة', 'Foil-baked beef with potatoes and salad', 'waraq_lahma_oven:250,salata_khadra_masri:100', 50, 'طبق لحمة بالفرن + سلطة', '');
L('ln_lamb_chops_salad', 'ريش ضاني مشوية مع سلطة', 'Grilled lamb chops with salad', 'lahem_dani_mashwi:120,salata_khadra_masri:90,olive_oil:5', 25, '٣ ريش + سلطة', '');
L('ln_lamb_zucchini', 'لحم ضاني مشوي مع كوسة', 'Roasted lamb with zucchini', 'lamb_cooked:120,zucchini_cooked:150,olive_oil:5', 35, 'حتة لحم (١٢٠ جم) + كوسة', '');
L('ln_salmon_broccoli', 'سلمون مشوي مع بروكلي', 'Grilled salmon with broccoli', 'fish_salmon_cooked:150,broccoli_cooked:150,olive_oil:5', 25, 'شريحة سلمون + بروكلي', '');
L('ln_salmon_salad', 'سلمون مشوي مع سلطة خس بزيت الزيتون', 'Grilled salmon with lettuce salad', 'fish_salmon_cooked:150,lettuce:100,olive_oil:8', 20, 'شريحة سلمون + طبق خس', '');
L('ln_chicken_thigh_salad', 'فخاذ فراخ مشوية مع سلطة', 'Grilled chicken thighs with salad', 'chicken_thigh_cooked:180,salata_khadra_masri:80,olive_oil:5', 30, 'فخدتين فراخ + سلطة', '');
L('ln_chicken_thigh_spinach', 'فراخ بالسبانخ والجبنة الكريمي', 'Chicken thighs with spinach and cream cheese', 'chicken_thigh_cooked:150,spinach_cooked:100,cream_cheese:20', 30, 'فخدة فراخ + طبق سبانخ', '');
L('ln_chicken_roumi_salad', 'فراخ مشوية بالجبنة الرومي مع سلطة', 'Grilled chicken with roumi cheese and salad', 'faraaj_mashweya:150,gebna_roumi:30,salata_khadra_masri:60', 30, 'نص فرخة صغير + شريحة رومي + سلطة', '');
L('ln_beef_steak_zucchini', 'ستيك لحم مشوي مع كوسة سوتيه', 'Grilled beef steak with sauteed zucchini', 'beef_grilled:150,zucchini_cooked:150,olive_oil:5', 25, 'ستيك (١٥٠ جم) + طبق كوسة', '');
L('ln_mackerel_salad', 'سمك ماكريل مشوي مع سلطة', 'Grilled mackerel with salad', 'mackerel_cooked:150,salata_khadra_masri:80', 25, 'سمكة صغيرة + سلطة', '');
L('ln_sardines_salad', 'سردين بزيت الزيتون مع سلطة', 'Sardines with olive oil and salad', 'sardines_canned:120,salata_khadra_masri:80,olive_oil:8', 10, 'علبة سردين + سلطة', 'nb');
L('ln_duck_salad', 'بط مشوي مع سلطة', 'Roasted duck with salad', 'duck_maghrabi_roasted:150,salata_khadra_masri:80', 50, 'حتة بط (١٥٠ جم) + سلطة', '');

// ───────────────────────── DINNER ─────────────────────────
const N = (...a) => D('dinner', ...a);
N('dn_quraish_tomato_bread', 'جبنة قريش بالطماطم وزيت الزيتون مع نص رغيف', 'Cottage cheese with tomato, olive oil and half a loaf', 'gebna_quraish:150,tomato_raw:100,baladi_bread:45,olive_oil:5', 5, 'علبة قريش + طماطم + نص رغيف', 'nb');
N('dn_lentil_soup_salad', 'شوربة عدس بالكمون مع سلطة', 'Lentil soup with salad', 'shorbat_adas_egyptian:300,salata_khadra_masri:100,baladi_bread:30', 20, 'طبق شوربة عدس + سلطة + ربع رغيف', 'b');
N('dn_tuna_yogurt_cucumber', 'تونة بالزبادي والخيار', 'Tuna with yogurt and cucumber', 'fish_tuna_canned:100,yogurt_plain:150,cucumber:100', 5, 'علبة تونة + علبة زبادي + خيار', 'n');
N('dn_omelet_zucchini', 'أومليت بالكوسة والطماطم', 'Zucchini and tomato omelette', 'egg_omelette:150,zucchini_cooked:80,tomato_raw:60,olive_oil:5', 12, 'أومليت من ٣ بيضات + خضار', 'b');
N('dn_chicken_salad', 'فراخ مشوية مع سلطة كبيرة', 'Grilled chicken with a big salad', 'chicken_breast_grilled:150,salata_khadra_masri:150,olive_oil:5', 20, 'صدر فراخ + طبق سلطة كبير', '');
N('dn_fish_salad', 'سمك بلطي مشوي مع سلطة', 'Grilled tilapia with salad', 'samak_bolti_mashwi:200,salata_khadra_masri:120', 25, 'سمكة بلطي + سلطة', '');
N('dn_chicken_soup', 'شوربة فراخ بالخضار مع صدر فراخ مسلوق', 'Chicken vegetable soup with boiled chicken', 'chicken_soup:300,chicken_breast_grilled:100', 25, 'طبق شوربة كبير + حتة فراخ', '');
N('dn_kousa_chicken', 'كوسة بالطماطم مع فراخ مشوية', 'Zucchini in tomato with grilled chicken', 'kousa_cooked:250,chicken_breast_grilled:120', 30, 'طبق كوسة + صدر فراخ', '');
N('dn_egg_tuna_salad', 'سلطة بيض وتونة بالخس', 'Egg and tuna lettuce salad', 'egg_boiled:100,fish_tuna_canned:80,lettuce:100,tomato_raw:80,olive_oil:8', 10, 'بيضتين + نص علبة تونة + خس وطماطم', 'n');
N('dn_chicken_sandwich', 'ساندوتش صدر فراخ مشوية بالخضار', 'Grilled chicken breast sandwich with veg', 'baladi_bread:60,chicken_breast_grilled:100,lettuce:30,tomato_raw:50,yogurt_plain:30', 15, 'ساندوتش في ثلثين رغيف بلدي', '');
N('dn_eggs_cheese_olives', 'بيض مسلوق مع جبنة بيضاء وزيتون وخضار', 'Boiled eggs with white cheese, olives and veg', 'egg_boiled:100,white_cheese_egyptian:30,olive_pickled_kalamata:20,cucumber:100,tomato_raw:80', 10, 'بيضتين + جبنة + زيتون + خضار', 'b');
N('dn_molokhia_chicken_norice', 'ملوخية بالفراخ بدون رز', 'Molokhia with chicken, no rice', 'molokhia_with_chicken:300,chicken_breast_grilled:100', 30, 'طبق ملوخية + حتة فراخ', '');
N('dn_yogurt_cucumber_cheese', 'سلطة زبادي بالخيار مع جبنة بيضاء لايت', 'Yogurt cucumber salad with light white cheese', 'zabadi_diet_light:200,white_cheese_egyptian:30,cucumber:150', 5, 'علبة زبادي + خيار + جبنة صغيرة', 'nb');
N('dn_kofta_salad_yogurt', 'كفتة مشوية مع سلطة وزبادي', 'Grilled kofta with salad and yogurt', 'kofta_mashweya:120,salata_khadra_masri:120,zabadi_diet_light:100', 25, '٣ أصابع كفتة + سلطة + زبادي', '');
N('dn_shrimp_zucchini', 'جمبري بالثوم مع كوسة', 'Garlic shrimp with zucchini', 'gambari_mashwi:180,zucchini_cooked:150,olive_oil:8', 20, 'طبق جمبري + كوسة', '');
N('dn_ful_light', 'فول خفيف بالليمون مع ربع رغيف', 'Light ful with lemon and a quarter loaf', 'ful_medames_plain:150,tomato_raw:80,olive_oil:5,baladi_bread:30', 5, 'طبق فول صغير + ربع رغيف', 'bs');
N('dn_turkey_broccoli', 'ديك رومي مشوي مع بروكلي', 'Roasted turkey with broccoli', 'turkey_breast_roasted:150,broccoli_cooked:150', 25, 'شرايح ديك رومي + بروكلي', '');
N('dn_okra_salad', 'بامية بالصلصة مع سلطة', 'Okra in tomato sauce with salad', 'bamya_plain:250,salata_khadra_masri:100,baladi_bread:30', 30, 'طبق بامية + سلطة + ربع رغيف', 'b');
N('dn_spinach_eggs', 'سبانخ سوتيه ببيضتين مسلوقتين', 'Sauteed spinach with two boiled eggs', 'spinach_cooked:200,egg_boiled:100,olive_oil:8', 15, 'طبق سبانخ + بيضتين', 'b');
N('dn_cauliflower_roumi', 'قرنبيط مشوي بالجبنة الرومي وبيضة', 'Roasted cauliflower with roumi cheese and an egg', 'cauliflower_cooked:200,gebna_roumi:40,egg_boiled:50', 25, 'طبق قرنبيط + شريحة رومي + بيضة', '');
N('dn_chicken_liver_salad', 'كبدة فراخ مع سلطة', 'Chicken liver with salad', 'chicken_liver_pan:150,salata_khadra_masri:120', 20, 'طبق كبدة فراخ + سلطة', 'b');
N('dn_roumi_salad', 'جبنة رومي مع سلطة خيار وطماطم', 'Roumi cheese with cucumber and tomato salad', 'gebna_roumi:60,tomato_raw:100,cucumber:100,olive_oil:5', 5, 'شريحتين رومي + طبق سلطة', 'n');
N('dn_sardines_baladi', 'سردين بالليمون مع سلطة وربع رغيف', 'Sardines with lemon, salad and a quarter loaf', 'sardines_canned:100,salata_khadra_masri:150,baladi_bread:30', 5, 'علبة سردين + سلطة + ربع رغيف', 'nb');
N('dn_tuna_lettuce_avocado', 'لفائف خس بالتونة والأفوكادو', 'Lettuce wraps with tuna and avocado', 'fish_tuna_canned:100,lettuce:80,avocado:50', 10, '٤ أوراق خس + تونة + أفوكادو', 'n');
N('dn_fasolia_chicken', 'فاصوليا خضرا مع فراخ مشوية', 'Green beans stew with grilled chicken', 'fasolia_khadra_stew:250,chicken_breast_grilled:100', 35, 'طبق فاصوليا + صدر فراخ', '');
N('dn_mushroom_chicken', 'مشروم بالفراخ وزيت الزيتون', 'Mushrooms with chicken and olive oil', 'mushroom_raw:150,chicken_breast_grilled:130,olive_oil:8', 20, 'طبق مشروم + صدر فراخ', '');
N('dn_egg_bake_spinach', 'عجة فرن بالسبانخ والجبنة الرومي', 'Oven-baked spinach and roumi omelette', 'egg_omelette:150,spinach_cooked:100,gebna_roumi:20', 25, '٣ قطع عجة فرن', '');
N('dn_salmon_asparagus', 'سلمون مشوي مع هليون', 'Grilled salmon with asparagus', 'fish_salmon_cooked:130,asparagus_cooked:150,olive_oil:5', 25, 'شريحة سلمون + طبق هليون', '');
N('dn_pastrami_lettuce_wraps', 'لفائف خس ببسطرمة ديك رومي وقريش', 'Turkey pastrami lettuce wraps with cottage cheese', 'turkey_pastrami:80,lettuce:60,gebna_quraish:60', 8, '٤ لفائف خس', 'np');
N('dn_chicken_thigh_greenbeans', 'فخاذ فراخ مع فاصوليا خضرا', 'Chicken thighs with green beans', 'chicken_thigh_cooked:150,green_beans_cooked:120', 30, 'فخدة فراخ + طبق فاصوليا', '');
N('dn_kandouz_salad', 'لحمة كندوز مسلوقة مع سلطة', 'Boiled lean beef with salad', 'lahem_kandouz_maslouq:150,salata_khadra_masri:100,olive_oil:5', 40, 'حتة لحمة + سلطة', '');
N('dn_egg_avocado_salad', 'سلطة بيض وأفوكادو', 'Egg and avocado salad', 'egg_boiled:100,avocado:80,cucumber:80', 10, 'بيضتين + نص أفوكادو + خيار', '');
N('dn_kofta_tahini_cucumber', 'كفتة مشوية بالطحينة والخيار', 'Grilled kofta with tahini and cucumber', 'kofta_mashweya:120,cucumber:100,tahini:10', 25, '٣ أصابع كفتة + خيار + طحينة', '');
N('dn_lamb_broccoli', 'لحم ضاني مع بروكلي', 'Roasted lamb with broccoli', 'lamb_cooked:100,broccoli_cooked:120,olive_oil:5', 30, 'حتة لحم (١٠٠ جم) + بروكلي', '');
N('dn_roumi_olives_egg', 'جبنة رومي وبيضة وزيتون', 'Roumi cheese, egg and olives', 'gebna_roumi:50,egg_boiled:100,olive_pickled_kalamata:30', 10, 'شريحتين رومي + بيضتين + زيتون', 'n');
N('dn_mackerel_salad', 'ماكريل مشوي مع سلطة', 'Grilled mackerel with salad', 'mackerel_cooked:120,salata_khadra_masri:80', 25, 'سمكة صغيرة + سلطة', '');

N('dn_tuna_avocado_egg', 'تونة وأفوكادو وبيضة بزيت الزيتون', 'Tuna, avocado and egg with olive oil', 'egg_boiled:50,fish_tuna_canned:80,avocado:60,olive_oil:5', 10, 'نص علبة تونة + بيضة + ثلث أفوكادو', 'n');
N('dn_chicken_thigh_salad_tahini', 'فخاذ فراخ بسلطة خس وصوص الطحينة', 'Chicken thighs with lettuce and tahini sauce', 'chicken_thigh_cooked:120,lettuce:80,tahini:12,cucumber:60', 25, 'فخدة فراخ + سلطة + معلقة طحينة', '');

// ───────────────────────── SNACKS ─────────────────────────
const S = (...a) => D('snack', ...a);
S('sn_apple_pb', 'تفاحة بزبدة الفول السوداني', 'Apple with peanut butter', 'apple:120,peanut_butter:12', 2, 'تفاحة صغيرة + معلقة صغيرة زبدة فول سوداني', 'n');
S('sn_banana', 'موزة متوسطة', 'One medium banana', 'banana:100', 1, 'موزة متوسطة', 'nb');
S('sn_guava', 'جوافة كبيرة', 'One large guava', 'guava:150', 1, 'جوافة كبيرة', 'nb');
S('sn_orange', 'برتقالة', 'One orange', 'orange:150', 1, 'برتقالة متوسطة', 'nb');
S('sn_strawberry_yogurt', 'زبادي يوناني بالفراولة', 'Greek yogurt with strawberries', 'yogurt_greek:120,strawberry:80', 3, 'نص علبة زبادي يوناني + حفنة فراولة', 'n');
S('sn_greek_plain', 'زبادي يوناني سادة', 'Plain Greek yogurt', 'yogurt_greek:150', 1, 'علبة زبادي يوناني', 'n');
S('sn_labneh_cucumber', 'لبنة بالخيار', 'Labneh with cucumber', 'labneh:60,cucumber:100', 3, '٣ معالق لبنة + خيار', 'n');
S('sn_hummus_veg', 'حمص بالطحينة مع خيار وجزر', 'Hummus with cucumber and carrot', 'hummus:50,cucumber:80,carrot_raw:50', 4, '٣ معالق حمص + خيار وجزر', 'n');
S('sn_almonds', 'حفنة لوز', 'A small handful of almonds', 'almonds:25', 1, 'حفنة صغيرة (٢٥ جم)', 'n');
S('sn_walnuts', 'حفنة جوز', 'A small handful of walnuts', 'walnuts:25', 1, '٥ حبات جوز', 'n');
S('sn_pumpkin_seeds', 'لب قرع (بذور اليقطين)', 'Pumpkin seeds', 'pumpkin_seeds:25', 1, 'حفنة صغيرة (٢٥ جم)', 'n');
S('sn_pistachio', 'حفنة فستق', 'A small handful of pistachios', 'pistachio:25', 1, 'حفنة صغيرة (٢٥ جم)', 'n');
S('sn_egg_olives', 'بيضة مسلوقة مع زيتون', 'A boiled egg with olives', 'egg_boiled:50,olive_pickled_kalamata:30', 8, 'بيضة + ٥ حبات زيتون', '');
S('sn_two_eggs', 'بيضتين مسلوقتين', 'Two boiled eggs', 'egg_boiled:100', 8, 'بيضتين', 'b');
S('sn_tuna_oil_lemon', 'تونة بزيت الزيتون والليمون', 'Tuna with olive oil and lemon', 'fish_tuna_canned:60,olive_oil:8', 2, 'نص علبة تونة + ليمون', 'n');
S('sn_roumi_cubes', 'مكعبات جبنة رومي', 'Roumi cheese cubes', 'gebna_roumi:40', 1, '٤ مكعبات رومي', 'n');
S('sn_avocado_half', 'نص أفوكادو بالليمون', 'Half an avocado with lemon', 'avocado:80,lemon:10', 2, 'نص أفوكادو صغيرة', 'n');
S('sn_olives', 'زيتون', 'Olives', 'olive_pickled_kalamata:50', 1, '١٠ حبات زيتون', 'nb');
S('sn_karish_cucumber', 'جبنة قريش (كريش) بالخيار', 'Karish cheese with cucumber', 'karish_cheese:100,cucumber:100', 3, 'نص علبة كريش + خيار', 'nb');
S('sn_laban_rayeb', 'كوباية لبن رايب', 'A glass of laban rayeb', 'laban_rayeb_egyptian:250', 1, 'كوباية لبن رايب', 'nb');
S('sn_milk_dates', 'كوباية لبن خالي الدسم وتمرتين', 'Skim milk with two dates', 'milk_skim:250,tamr_saqei_dry:20', 2, 'كوباية لبن + تمرتين', 'nbs');
S('sn_protein_bar', 'لوح بروتين', 'A protein bar', 'protein_bar:45', 1, 'لوح بروتين (٤٥ جم)', 'np');
S('sn_popcorn', 'فشار بدون زبدة', 'Plain popcorn', 'popcorn:25', 5, 'كوباية فشار كبيرة', 'nb');
S('sn_dates_walnut', 'بلح وجوز', 'Fresh dates with a walnut', 'tamr_balah_aswad:40,walnuts:10', 2, '٣ حبات بلح + ٢ جوز', 'ns');
S('sn_turkey_roll', 'لفائف ديك رومي بالقريش والخيار', 'Turkey rolls with cottage cheese and cucumber', 'turkey_pastrami:40,cucumber:60,gebna_quraish:40', 5, '٣ شرايح ديك رومي + قريش + خيار', 'np');
S('sn_chickpeas', 'حمص الشام مسلوق بالكمون والليمون', 'Boiled chickpeas with cumin and lemon', 'chickpeas_cooked:100,lemon:10', 3, 'كوباية صغيرة حمص', 'b');
S('sn_whey_shake_small', 'بروتين شيك صغير بلبن خالي الدسم', 'Small protein shake with skim milk', 'whey_protein:30,milk_skim:200', 3, 'سكوب بروتين + كوباية لبن', 'np');
S('sn_watermelon', 'بطيخ', 'Watermelon', 'battiq_red:250', 1, 'شريحتين بطيخ', 'nb');
S('sn_cantaloupe', 'كنتالوب', 'Cantaloupe', 'kantarlob_masri:200', 2, 'طبق كنتالوب صغير', 'nb');
S('sn_pomegranate', 'رمان', 'Pomegranate', 'romman_fresh:120', 3, 'نص كوباية رمان', 'nb');
S('sn_fig_walnut', 'تينتين وجوزتين', 'Two figs and two walnuts', 'teen_barshoumi:100,walnuts:10', 2, '٢ تين + ٢ جوز', 'n');
S('sn_leb_abyad', 'لب أبيض', 'Roasted white pumpkin seeds', 'leb_abyad_pumpkin:25', 1, 'حفنة صغيرة (٢٥ جم)', 'nb');
S('sn_sweet_potato', 'بطاطا مشوية صغيرة', 'A small baked sweet potato', 'sweet_potato_cooked:120', 30, 'بطاطا صغيرة', 'b');
S('sn_corn', 'كوز درة مسلوق', 'Boiled corn', 'corn_cooked:100', 15, 'نص كوز درة', 'b');
S('sn_cream_cheese_cucumber', 'جبنة كريمي بالخيار', 'Cream cheese with cucumber', 'cream_cheese:30,cucumber:100', 2, 'معلقتين جبنة كريمي + خيار', 'n');
S('sn_tahini_cucumber', 'خيار بالطحينة', 'Cucumber with tahini', 'tahini:15,cucumber:120', 3, 'خيارتين + معلقة طحينة', 'nb');
S('sn_peanuts', 'سوداني', 'Peanuts', 'peanuts:25', 1, 'حفنة صغيرة (٢٥ جم)', 'nb');
S('sn_taameya_baked_small', 'طعمية مشوية (٢ قرص) مع خيار', 'Two baked taameya discs with cucumber', 'taameya_baked_airfryer:60,cucumber:80', 15, '٢ قرص طعمية + خيار', 'b');
S('sn_oat_yogurt', 'زبادي بالشوفان', 'Yogurt with oats', 'yogurt_plain:120,oats_dry:15', 3, 'علبة زبادي + ٢ معلقة شوفان', 'n');
S('sn_greek_almonds', 'زبادي يوناني باللوز', 'Greek yogurt with almonds', 'yogurt_greek:100,almonds:10', 2, 'نص علبة زبادي يوناني + لوز', 'n');
S('sn_greek_walnut', 'زبادي يوناني بالجوز', 'Greek yogurt with walnuts', 'yogurt_greek:120,walnuts:10', 2, 'نص علبة زبادي + ٢ جوز', 'n');
S('sn_baladi_quraish', 'ربع رغيف بلدي بجبنة قريش', 'A quarter loaf with cottage cheese', 'baladi_bread:30,gebna_quraish:50', 3, 'ربع رغيف + ٣ معالق قريش', 'nb');
S('sn_sunflower', 'لب سوري', 'Roasted sunflower seeds', 'leb_souri_sunflower:25', 1, 'حفنة صغيرة (٢٥ جم)', 'nb');
S('sn_zabadi_cucumber', 'زبادي لايت بالخيار والنعناع', 'Light yogurt with cucumber and mint', 'zabadi_diet_light:150,cucumber:80,mint:3', 3, 'علبة زبادي + خيار', 'nb');
S('sn_coffee_dates', 'قهوة تركي سادة مع تمرتين', 'Plain Turkish coffee with two dates', 'ahwa_turki_sada:60,tamr_saqei_dry:20', 5, 'فنجان قهوة سادة + تمرتين', 'ns');
S('sn_quraish_tomato', 'جبنة قريش بالطماطم', 'Cottage cheese with tomato', 'gebna_quraish:100,tomato_raw:60', 3, '٥ معالق قريش + طماطم', 'nb');
S('sn_quraish_cucumber', 'جبنة قريش بالخيار والنعناع', 'Cottage cheese with cucumber and mint', 'gebna_quraish:150,cucumber:80,mint:3', 3, 'علبة قريش + خيار', 'nb');
S('sn_sardines_small', 'سردين بالليمون', 'Sardines with lemon', 'sardines_canned:60,lemon:10', 2, 'نص علبة سردين', 'nb');
S('sn_shrimp_lemon', 'جمبري مسلوق بالليمون', 'Boiled shrimp with lemon', 'gambari_mashwi:80,lemon:10', 8, 'طبق جمبري صغير', '');
S('sn_egg_tuna', 'بيضة مسلوقة مع تونة', 'A boiled egg with tuna', 'egg_boiled:50,fish_tuna_canned:40', 8, 'بيضة + ربع علبة تونة', '');
S('sn_yogurt_cheese_mint', 'زبادي بالجبنة البيضاء والنعناع', 'Yogurt with white cheese and mint', 'yogurt_plain:150,white_cheese_egyptian:20,mint:3', 3, 'علبة زبادي + قطعة جبنة صغيرة', 'nb');

// ───────────────────────── compute ─────────────────────────
const SLOT_KEY = { breakfast: 'breakfast', lunch: 'lunch', dinner: 'dinner', snack: 'snack' };
const CAP = { breakfast: 550, lunch: 700, dinner: 600, snack: 300 };
const PMIN = { breakfast: 20, lunch: 30, dinner: 25, snack: 10 };
const CMAX = { breakfast: 30, lunch: 40, dinner: 30, snack: 12 };
const PROGRAMS = ['balancedDeficit', 'highProtein', 'intermittentFasting', 'lowCarb', 'keto', 'fastingLowCarb', 'egyptianClean'];

function fits(o, p) {
  const k = o.kcal, s = o.slot;
  const pShare = (o.p * 4) / k, fShare = (o.f * 9) / k;
  switch (p) {
    case 'balancedDeficit': return k <= CAP[s];
    case 'highProtein': return k <= CAP[s] && o.p >= PMIN[s] && pShare >= 0.25;
    case 'intermittentFasting': return k <= CAP[s] * 1.2 && pShare >= 0.2;
    case 'lowCarb': return k <= CAP[s] && o.c <= CMAX[s];
    case 'keto': return k <= CAP[s] && o.c <= (s === 'snack' ? 7 : 10) && fShare >= 0.45;
    case 'fastingLowCarb': return k <= CAP[s] * 1.2 && o.c <= CMAX[s] && pShare >= 0.2;
    case 'egyptianClean': return !o.fried && !o.processed && k <= CAP[s];
  }
}

const seen = new Set();
const opts = dishes.map((d) => {
  if (seen.has(d.rawId)) throw new Error(`dup id ${d.rawId}`);
  seen.add(d.rawId);
  let kcal = 0, p = 0, c = 0, f = 0;
  const ids = [];
  for (const part of d.comps.split(',')) {
    const [fid, g] = part.split(':');
    const food = foods.get(fid);
    if (!food) throw new Error(`Unknown food id ${fid} in ${d.rawId}`);
    const x = Number(g) / 100;
    kcal += food.per_100g.kcal * x;
    p += food.per_100g.protein * x;
    c += food.per_100g.carbs * x;
    f += food.per_100g.fat * x;
    if (!ids.includes(fid)) ids.push(fid);
  }
  const o = {
    ...d, id: d.rawId, ids,
    kcal: Math.round(kcal), p: Math.round(p * 10) / 10, c: Math.round(c * 10) / 10, f: Math.round(f * 10) / 10,
    noCook: d.tags.includes('n'), budget: d.tags.includes('b'), suhoor: d.tags.includes('s'),
    fried: d.tags.includes('f'), processed: d.tags.includes('p'),
  };
  o.highProtein = o.p >= PMIN[o.slot] && (o.p * 4) / o.kcal >= 0.25;
  return o;
});

// swaps: nearest-kcal dishes in the same slot sharing at least one program, different first food
for (const o of opts) {
  const mine = PROGRAMS.filter((p) => fits(o, p));
  const cand = opts
    .filter((x) => x !== o && x.slot === o.slot && x.ids[0] !== o.ids[0])
    .filter((x) => !x.ar.startsWith('سحور') || o.ar.startsWith('سحور'))
    .filter((x) => Math.abs(x.kcal - o.kcal) <= Math.max(60, o.kcal * 0.25))
    .filter((x) => mine.length === 0 || mine.some((p) => fits(x, p)))
    .sort((a, b) => Math.abs(a.kcal - o.kcal) - Math.abs(b.kcal - o.kcal));
  o.swaps = cand.slice(0, 3).map((x) => x.ar);
}

// report
let bad = false;
for (const p of PROGRAMS) {
  const row = {};
  for (const s of Object.keys(CAP)) {
    row[s] = opts.filter((o) => o.slot === s && fits(o, p)).length;
    if (row[s] < 15) bad = true;
  }
  console.log(p.padEnd(22), JSON.stringify(row));
}
console.log('total options', opts.length, 'noSwaps', opts.filter((o) => o.swaps.length === 0).length);

const q = (s) => `'${s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\$/g, '\\$')}'`;
const lines = [];
lines.push('// GENERATED FILE — do not edit by hand.');
lines.push('// Source: tool/meal_library/gen_program_meal_library.mjs');
lines.push('// Macros are summed from assets/food_db/foods.json (per-100 g values × grams).');
lines.push('');
lines.push("import 'package:vireo/features/diet_programs/data/program_meal_library.dart';");
lines.push('');
lines.push('const List<ProgramMealOption> kProgramMealOptions = [');
for (const o of opts) {
  lines.push('  ProgramMealOption(');
  lines.push(`    id: ${q(o.id)},`);
  lines.push(`    slot: MealSlot.${o.slot},`);
  lines.push(`    nameAr: ${q(o.ar)},`);
  lines.push(`    nameEn: ${q(o.en)},`);
  lines.push(`    foodDbIds: [${o.ids.map(q).join(', ')}],`);
  lines.push(`    kcal: ${o.kcal},`);
  lines.push(`    proteinG: ${o.p},`);
  lines.push(`    carbsG: ${o.c},`);
  lines.push(`    fatG: ${o.f},`);
  lines.push(`    prepMinutes: ${o.prep},`);
  lines.push(`    householdMeasureAr: ${q(o.hm)},`);
  lines.push(`    swaps: [${o.swaps.map(q).join(', ')}],`);
  if (o.noCook) lines.push('    noCook: true,');
  if (o.highProtein) lines.push('    highProtein: true,');
  if (o.budget) lines.push('    budget: true,');
  if (o.suhoor) lines.push('    ramadanSuhoor: true,');
  if (o.fried) lines.push('    fried: true,');
  if (o.processed) lines.push('    processed: true,');
  lines.push('  ),');
}
lines.push('];');
lines.push('');
fs.writeFileSync('lib/features/diet_programs/data/program_meal_library_data.dart', lines.join('\n'));
if (bad) { console.error('Some program×slot has < 15 options'); process.exit(1); }
