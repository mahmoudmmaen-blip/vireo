#!/usr/bin/env python3
"""P55: compact content JSON assets for smaller AAB."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def round_nums(obj, nd: int = 1):
    if isinstance(obj, float):
        return round(obj, nd) if abs(obj) < 1e6 else obj
    if isinstance(obj, list):
        return [round_nums(x, nd) for x in obj]
    if isinstance(obj, dict):
        return {k: round_nums(v, nd) for k, v in obj.items()}
    return obj


def dump(path: Path, data: object) -> None:
    path.write_text(
        json.dumps(data, ensure_ascii=False, separators=(",", ":")),
        encoding="utf-8",
    )


def main() -> None:
    # 1) Cap food facts to 366 (daily rotation needs ≤366).
    facts_path = ROOT / "assets/content/food_facts.json"
    facts = json.loads(facts_path.read_text(encoding="utf-8"))
    before = facts_path.stat().st_size
    n = len(facts.get("facts", []))
    facts["facts"] = facts.get("facts", [])[:366]
    dump(facts_path, facts)
    print(
        f"food_facts: {n} -> {len(facts['facts'])} items; "
        f"{before} -> {facts_path.stat().st_size}"
    )

    # 2) Compact food DBs: fewer aliases/portions + rounded numbers.
    for rel in ("assets/food_db/foods.json", "assets/food_db/usda_foods.json"):
        path = ROOT / rel
        before = path.stat().st_size
        data = json.loads(path.read_text(encoding="utf-8"))
        for food in data.get("foods", []):
            aliases = food.get("aliases") or []
            if len(aliases) > 8:
                food["aliases"] = aliases[:8]
            portions = food.get("common_portions") or []
            if len(portions) > 6:
                food["common_portions"] = portions[:6]
            units = food.get("household_units") or []
            if len(units) > 8:
                food["household_units"] = units[:8]
        dump(path, round_nums(data, 1))
        print(f"{rel}: {before} -> {path.stat().st_size}")

    # 3) Bound tip length on swaps.
    swaps_path = ROOT / "assets/content/local_food_swaps.json"
    before = swaps_path.stat().st_size
    swaps = json.loads(swaps_path.read_text(encoding="utf-8"))
    for item in swaps.get("swaps", []):
        for key in ("tip_ar", "tip_en"):
            tip = item.get(key) or ""
            if len(tip) > 140:
                item[key] = tip[:137] + "..."
    dump(swaps_path, swaps)
    print(
        f"swaps: {before} -> {swaps_path.stat().st_size}; "
        f"count={len(swaps.get('swaps', []))}"
    )

    total = sum(
        (ROOT / p).stat().st_size
        for p in (
            "assets/food_db/usda_foods.json",
            "assets/food_db/foods.json",
            "assets/content/food_facts.json",
            "assets/content/local_food_swaps.json",
        )
    )
    print(f"total content assets now: {total / 1e6:.2f} MB")


if __name__ == "__main__":
    main()
