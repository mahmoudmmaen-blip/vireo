import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

BREAKFAST_AR = "شوفان بالبروتين"
CHICKEN_AR = "طبق دجاج بالأرز والخضار"
TAG_AR = "\u0628\u0631\u0648\u062a\u064a\u0646 \u0639\u0627\u0644\u064a"


def fix_meal_plan() -> None:
    path = ROOT / "lib/data/repositories/meal_plan_repository.dart"
    text = path.read_text(encoding="utf-8")
    text = re.sub(
        r"'Protein Oats Bowl', '[^']+'",
        f"'Protein Oats Bowl', '{BREAKFAST_AR}'",
        text,
    )
    path.write_text(text, encoding="utf-8")


def fix_nutrition() -> None:
    path = ROOT / "lib/data/repositories/nutrition_repository.dart"
    text = path.read_text(encoding="utf-8")
    text = re.sub(
        r"titleAr: '[^']+',\n        prepTimeMinutes: 20,\n        goalTag: RecipeGoalTag.highProtein",
        f"titleAr: '{CHICKEN_AR}',\n        prepTimeMinutes: 20,\n        goalTag: RecipeGoalTag.highProtein",
        text,
    )
    path.write_text(text, encoding="utf-8")


def fix_arb() -> None:
    path = ROOT / "lib/core/l10n/app_ar.arb"
    text = path.read_text(encoding="utf-8")
    text = re.sub(
        r'"nutritionTagHighProtein": "[^"]+"',
        f'"nutritionTagHighProtein": "{TAG_AR}"',
        text,
    )
    path.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    fix_meal_plan()
    fix_nutrition()
    fix_arb()
    print("Fixed:", BREAKFAST_AR, CHICKEN_AR, TAG_AR)
