#!/usr/bin/env python3
"""Replace Color(0x...) in lib/features with VBridge named tokens (P50)."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FEATURES = ROOT / "lib" / "features"
BRIDGE = "import 'package:vireo/core/theme/vireo_bridge.dart';"
PAT = re.compile(r"(?:const\s+)?Color\((0[xX][0-9A-Fa-f]+)\)")


def repl(m: re.Match[str]) -> str:
    hexv = m.group(1).upper().replace("0X", "0x")
    name = "c" + hexv[2:]
    return f"VBridge.{name}"


def main() -> None:
    changed_files = 0
    total_repl = 0
    for path in FEATURES.rglob("*.dart"):
        text = path.read_text(encoding="utf-8")
        if not PAT.search(text):
            continue
        new, n = PAT.subn(repl, text)
        if n == 0:
            continue
        if BRIDGE not in new:
            lines = new.splitlines(keepends=True)
            last_imp = 0
            for i, line in enumerate(lines):
                if line.startswith("import "):
                    last_imp = i
            lines.insert(last_imp + 1, BRIDGE + "\n")
            new = "".join(lines)
        path.write_text(new, encoding="utf-8")
        changed_files += 1
        total_repl += n
        print(f"{path.relative_to(ROOT)}: {n}")
    print(f"FILES={changed_files} REPL={total_repl}")


if __name__ == "__main__":
    main()
