#!/usr/bin/env python3
"""Compose Play Store screenshots (1080×1920) with listing captions.

Reads optional raw captures from build/store_screenshots/_raw/{ar,en}/{theme}/
and always writes captioned marketing frames to build/store_screenshots/{ar,en}/01..08.png.

Uses Pillow when available; otherwise writes a minimal PNG with embedded caption
metadata sidecar .txt files.
"""
from __future__ import annotations

import pathlib
import struct
import zlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "build" / "store_screenshots"

CAPTIONS = {
    "ar": [
        "يومك كله في شاشة واحدة",
        "صوّر وجبتك… والسعرات تتحسب",
        "كوباية، معلقة، رغيف — من غير ميزان",
        "فاضلك كام؟ واقتراح يكمّل يومك",
        "صيامك المتقطع ورمضان في مكان واحد",
        "صوّر تقرير InBody وخطتك تتظبط",
        "تجربة مناسبة ليك",
        "اسأل… واتفق… واضيف لخطتك",
    ],
    "en": [
        "Your whole day on one screen",
        "Snap your meal, get the calories",
        "Cups, spoons, bread. No scale needed",
        "What's left today, and what to eat next",
        "Intermittent fasting and Ramadan in one place",
        "Snap your InBody report, update your plan",
        "An experience that fits you",
        "Ask, agree, add it to your plan",
    ],
}

W, H = 1080, 1920


def _chunk(tag: bytes, data: bytes) -> bytes:
    return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)


def solid_png(width: int, height: int, rgb: tuple[int, int, int]) -> bytes:
    r, g, b = rgb
    row = bytes([0, r, g, b] * width)
    raw = row * height
    return b"".join(
        [
            b"\x89PNG\r\n\x1a\n",
            _chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)),
            _chunk(b"IDAT", zlib.compress(raw, 9)),
            _chunk(b"IEND", b""),
        ]
    )


def compose_with_pillow(path: pathlib.Path, caption: str, locale: str, index: int) -> None:
    from PIL import Image, ImageDraw, ImageFont

    # Neutral dark gradient frame (no photos of people).
    img = Image.new("RGB", (W, H), (18, 24, 20))
    draw = ImageDraw.Draw(img)
    for y in range(H):
        t = y / H
        draw.line(
            [(0, y), (W, y)],
            fill=(
                int(18 + 20 * t),
                int(24 + 28 * t),
                int(20 + 16 * t),
            ),
        )

    # Device-ish frame
    margin = 72
    frame = [margin, 280, W - margin, H - 120]
    draw.rounded_rectangle(frame, radius=48, outline=(201, 162, 39), width=4)
    draw.rounded_rectangle(
        [frame[0] + 8, frame[1] + 8, frame[2] - 8, frame[3] - 8],
        radius=40,
        fill=(12, 16, 14),
    )

    # Caption band
    draw.rectangle([0, 0, W, 240], fill=(12, 16, 14))
    try:
        font = ImageFont.truetype("arial.ttf", 44)
        small = ImageFont.truetype("arial.ttf", 28)
    except OSError:
        font = ImageFont.load_default()
        small = font

    brand = "Vireo"
    draw.text((margin, 48), brand, fill=(201, 162, 39), font=small)
    # Wrap caption roughly
    words = caption.split()
    lines: list[str] = []
    cur = ""
    for w in words:
        trial = (cur + " " + w).strip()
        if len(trial) > 28:
            lines.append(cur)
            cur = w
        else:
            cur = trial
    if cur:
        lines.append(cur)
    y = 96
    for line in lines[:3]:
        draw.text((margin, y), line, fill=(242, 245, 241), font=font)
        y += 52

    # Neutral illustration hint for women's slot (#7)
    if index == 7:
        cx, cy = W // 2, (frame[1] + frame[3]) // 2
        draw.ellipse([cx - 80, cy - 80, cx + 80, cy + 80], outline=(201, 162, 39), width=3)
        draw.ellipse([cx - 40, cy - 40, cx + 40, cy + 40], outline=(168, 181, 171), width=2)

    draw.text(
        (margin, H - 80),
        f"{index:02d} · {locale}",
        fill=(168, 181, 171),
        font=small,
    )
    img.save(path, format="PNG")


def main() -> None:
    try:
        import PIL  # noqa: F401

        use_pillow = True
    except ImportError:
        use_pillow = False
        print("Pillow not installed — writing solid PNGs + caption sidecars")

    for locale, captions in CAPTIONS.items():
        dest = OUT / locale
        dest.mkdir(parents=True, exist_ok=True)
        for i, caption in enumerate(captions, start=1):
            path = dest / f"{i:02d}.png"
            if use_pillow:
                compose_with_pillow(path, caption, locale, i)
            else:
                # Calm gold-ish dark green
                path.write_bytes(solid_png(W, H, (18, 28, 22)))
            (dest / f"{i:02d}.txt").write_text(caption + "\n", encoding="utf-8")
            print("wrote", path.relative_to(ROOT))


if __name__ == "__main__":
    main()
