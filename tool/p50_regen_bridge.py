#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FEATURES = ROOT / "lib" / "features"
OUT = ROOT / "lib" / "core" / "theme" / "vireo_bridge.dart"
PAT = re.compile(r"Color\((0[xX][0-9A-Fa-f]+)\)")


def main() -> None:
    hexes: set[str] = set()
    for path in FEATURES.rglob("*.dart"):
        for m in PAT.finditer(path.read_text(encoding="utf-8")):
            hexes.add(m.group(1).upper().replace("0X", "0x"))
    lines = [
        "import 'package:flutter/material.dart';",
        "",
        "/// Named color tokens for feature code (P50).",
        "/// Prefer [VireoColors] / [VMacro] when a semantic token exists.",
        "abstract final class VBridge {",
    ]
    for h in sorted(hexes):
        name = "c" + h[2:]
        lines.append(f"  static const Color {name} = Color({h});")
    lines.append("}")
    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"bridge colors={len(hexes)}")


if __name__ == "__main__":
    main()
