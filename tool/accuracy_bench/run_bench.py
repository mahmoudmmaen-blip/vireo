#!/usr/bin/env python3
"""
Vireo Calorie Accuracy Benchmark (Step B Pipeline)
Evaluates calorie estimation accuracy against ground truth recipes
for 70 reference meals (45 Egyptian/Arab, 25 Generic international).
"""

import csv
import json
import os
import sys

def normalize(text: str) -> str:
    t = text.lower().strip()
    t = t.replace('أ', 'ا').replace('إ', 'ا').replace('آ', 'ا')
    t = t.replace('ة', 'ه').replace('ى', 'ي')
    t = t.replace('-', ' ').replace('_', ' ')
    return t

class FoodDatabase:
    def __init__(self, egyptian_path="assets/food_db/foods.json", usda_path="assets/food_db/usda_foods.json"):
        with open(egyptian_path, encoding="utf-8") as f:
            egypt_data = json.load(f)
            self.egyptian_foods = egypt_data.get("foods", [])

        with open(usda_path, encoding="utf-8") as f:
            usda_data = json.load(f)
            self.usda_foods = usda_data.get("foods", [])

        # Build lookup indices
        self.eg_by_id = {f["id"]: f for f in self.egyptian_foods}
        self.usda_by_id = {f["id"]: f for f in self.usda_foods}

    def match_item(self, item_name: str, item_tag: str):
        norm_name = normalize(item_name)
        norm_tag = normalize(item_tag)

        # 1. Exact ID match in Egyptian DB
        if item_tag in self.eg_by_id:
            return self.eg_by_id[item_tag], "egyptian_db"

        # 2. Check Egyptian DB by name/aliases
        for f in self.egyptian_foods:
            f_id = normalize(f["id"])
            f_ar = normalize(f.get("name_ar", ""))
            f_en = normalize(f.get("name_en", ""))
            aliases = [normalize(a) for a in f.get("aliases", [])]

            if norm_tag == f_id or norm_name == f_ar or norm_name == f_en:
                return f, "egyptian_db"
            if norm_name in aliases or any(a in norm_name for a in aliases if len(a) > 3):
                return f, "egyptian_db"
            if norm_name in f_ar or f_ar in norm_name:
                return f, "egyptian_db"

        # 3. Check USDA DB
        if item_tag in self.usda_by_id:
            return self.usda_by_id[item_tag], "usda"

        for f in self.usda_foods:
            f_id = normalize(f["id"])
            f_ar = normalize(f.get("name_ar", ""))
            f_en = normalize(f.get("name_en", ""))
            aliases = [normalize(a) for a in f.get("aliases", [])]

            if norm_tag in f_id or norm_name == f_ar or norm_name == f_en:
                return f, "usda"
            if norm_name in aliases or any(a in norm_name for a in aliases if len(a) > 3):
                return f, "usda"
            if norm_name in f_ar or f_ar in norm_name:
                return f, "usda"

        # Fallback partial match in Egyptian DB
        for f in self.egyptian_foods:
            f_ar = normalize(f.get("name_ar", ""))
            tokens = [tok for tok in norm_name.split() if len(tok) > 2]
            if any(tok in f_ar for tok in tokens):
                return f, "egyptian_db"

        return None, "estimated"

def run_benchmark():
    db = FoodDatabase()
    csv_path = "tool/accuracy_bench/reference_meals.csv"

    if not os.path.exists(csv_path):
        print(f"Error: {csv_path} not found.")
        sys.exit(1)

    meals = []
    with open(csv_path, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            meals.append(row)

    total_ape = 0.0
    eg_ape = 0.0
    eg_count = 0
    gen_ape = 0.0
    gen_count = 0

    results = []

    for m in meals:
        meal_id = m["meal_id"]
        category = m["category"]
        name = m["meal_name"]
        spec = m["items_spec"]
        true_kcal = float(m["true_kcal"])

        items_parts = spec.split("|")
        est_kcal = 0.0
        item_details = []

        for p in items_parts:
            tokens = p.split(":")
            item_name = tokens[0]
            grams = float(tokens[1])
            tag = tokens[2] if len(tokens) > 2 else ""

            matched, source = db.match_item(item_name, tag)
            if matched:
                per100 = matched.get("per_100g", {})
                kcal_per_100 = float(per100.get("kcal", 0))
            else:
                # Conservative fallback estimate
                kcal_per_100 = 150.0
                source = "estimated"

            item_kcal = (grams * kcal_per_100) / 100.0
            est_kcal += item_kcal
            item_details.append({
                "item": item_name,
                "grams": grams,
                "source": source,
                "kcal": round(item_kcal, 1)
            })

        ape = abs(est_kcal - true_kcal) / true_kcal * 100.0
        total_ape += ape

        if category == "egyptian":
            eg_ape += ape
            eg_count += 1
        else:
            gen_ape += ape
            gen_count += 1

        results.append({
            "id": meal_id,
            "category": category,
            "name": name,
            "true_kcal": true_kcal,
            "est_kcal": round(est_kcal, 1),
            "ape": round(ape, 2),
            "items": item_details
        })

    overall_mape = total_ape / len(meals)
    egyptian_mape = eg_ape / eg_count if eg_count > 0 else 0.0
    generic_mape = gen_ape / gen_count if gen_count > 0 else 0.0

    print("=" * 70)
    print("  VIREO CALORIE ACCURACY BENCHMARK REPORT (STEP B VERIFIED DB)")
    print("=" * 70)
    print(f"Total reference meals tested: {len(meals)}")
    print(f"  • Egyptian / Arab meals:   {eg_count} meals")
    print(f"  • Generic / Western meals: {gen_count} meals")
    print("-" * 70)
    print(f"OVERALL MAPE (Mean Absolute % Error):  {overall_mape:.2f}%  (Target: < 15%)")
    print(f"Egyptian / Arab Meals MAPE:            {egyptian_mape:.2f}%")
    print(f"Generic / Western Meals MAPE:          {generic_mape:.2f}%")
    print("-" * 70)

    # Success assertion
    if overall_mape < 15.0:
        print(">>> STATUS: PASSED! Benchmark strictly satisfies target (< 15% MAPE) <<<")
    else:
        print(">>> STATUS: FAILED! Overall MAPE >= 15% <<<")
    print("=" * 70)

    return {
        "overall_mape": overall_mape,
        "egyptian_mape": egyptian_mape,
        "generic_mape": generic_mape,
        "total_meals": len(meals),
        "results": results
    }

if __name__ == "__main__":
    run_benchmark()
