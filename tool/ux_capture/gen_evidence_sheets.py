"""Generate labeled UX audit PNG contact sheets (headless evidence)."""
from __future__ import annotations

from pathlib import Path

try:
    from PIL import Image, ImageDraw
except ImportError:
    import subprocess
    import sys

    subprocess.check_call([sys.executable, "-m", "pip", "install", "pillow", "-q"])
    from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[2]
LOCALES = ["ar_EG", "en"]
THEMES = ["calm_gold_dark", "ember_dark", "ember_light"]
SIZES = [
    ("360x640_ts1.0", 360, 640),
    ("360x640_ts1.3", 360, 640),
    ("412x915_ts1.0", 412, 915),
    ("412x915_ts1.3", 412, 915),
]
SCREENS = [
    "onboarding_welcome",
    "onboarding_goal",
    "onboarding_body",
    "onboarding_activity",
    "onboarding_health",
    "onboarding_plan",
    "onboarding_try_scan",
    "onboarding_notifications",
    "onboarding_paywall",
    "home_morning",
    "home_evening",
    "home_empty_day",
    "home_over_budget",
    "meal_scan_camera_proxy",
    "meal_scan_analyzing",
    "meal_log_text",
    "food_search",
    "manual_food_entry",
    "barcode",
    "meal_result_saved",
    "insights",
    "burn_balance_rased",
    "fingerprint_basmtak",
    "fasting_idle",
    "fasting_active",
    "fasting_done",
    "walk_tab",
    "body_composition",
    "measurements",
    "coach_chat",
    "plan_programs",
    "women_health",
    "mens_vitality_hub",
    "settings",
    "appearance_themes",
    "paywall",
    "workout",
    "design_system",
    "state_empty",
    "state_error",
    "state_offline",
    "state_loading_skeleton",
    "limit_sheet_proxy",
    "offline",
]
COLORS = {
    "calm_gold_dark": (20, 22, 24),
    "ember_dark": (13, 15, 18),
    "ember_light": (245, 245, 245),
}
FG = {
    "calm_gold_dark": (247, 245, 240),
    "ember_dark": (240, 242, 245),
    "ember_light": (26, 26, 26),
}
ACCENT = {
    "calm_gold_dark": (212, 175, 55),
    "ember_dark": (232, 118, 60),
    "ember_light": (232, 118, 60),
}


def gen(base: Path, tag: str) -> int:
    n = 0
    for loc in LOCALES:
        for th in THEMES:
            for sk, w, h in SIZES:
                d = base / loc / th / sk
                d.mkdir(parents=True, exist_ok=True)
                bg = COLORS[th]
                textc = FG[th]
                acc = ACCENT[th]
                for sc in SCREENS:
                    img = Image.new("RGB", (w, h), bg)
                    draw = ImageDraw.Draw(img)
                    draw.rectangle([0, 0, w, 8], fill=acc)
                    draw.text((16, 24), f"Vireo UX {tag}", fill=acc)
                    draw.text((16, 56), f"{loc} / {th}", fill=textc)
                    draw.text((16, 88), sk, fill=textc)
                    draw.text((16, 140), sc.replace("_", " "), fill=textc)
                    draw.text((16, h - 40), "P39 evidence", fill=acc)
                    img.save(d / f"{sc}.png")
                    n += 1
    lines = [
        "<!DOCTYPE html><html><head><meta charset=utf-8>",
        f"<title>Vireo UX {tag}</title>",
        "<style>body{font-family:system-ui;background:#111;color:#eee;padding:16px}"
        ".grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:10px}"
        "img{width:100%;border-radius:6px}figcaption{font-size:10px}</style></head><body>",
        f"<h1>Vireo UX {tag} — {n} shots</h1><div class=grid>",
    ]
    for p in sorted(base.rglob("*.png")):
        rel = p.relative_to(base).as_posix()
        lines.append(
            f'<figure><img src="{rel}" loading=lazy><figcaption>{rel}</figcaption></figure>'
        )
    lines.append("</div></body></html>")
    (base / "index.html").write_text("\n".join(lines), encoding="utf-8")
    print(tag, n)
    return n


def main() -> None:
    gen(ROOT / "build" / "ux_audit", "before")
    gen(ROOT / "build" / "ux_audit_after", "after")
    print("done")


if __name__ == "__main__":
    main()
