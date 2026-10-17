#!/usr/bin/env python3
"""Generate self-contained legal HTML pages from docs/legal/*.md."""
from __future__ import annotations

import html
import pathlib
import re


def inline_md(text: str) -> str:
    parts = re.split(r"(\*\*.+?\*\*)", text)
    out: list[str] = []
    for p in parts:
        if p.startswith("**") and p.endswith("**") and len(p) >= 4:
            out.append("<strong>" + html.escape(p[2:-2]) + "</strong>")
        else:
            out.append(html.escape(p))
    return "".join(out)


def md_to_html(md_text: str, title: str, rtl: bool = False) -> str:
    lines = md_text.splitlines()
    body: list[str] = []
    in_ul = False
    for line in lines:
        if line.startswith("# "):
            if in_ul:
                body.append("</ul>")
                in_ul = False
            body.append(f"<h1>{html.escape(line[2:].strip())}</h1>")
        elif line.startswith("## "):
            if in_ul:
                body.append("</ul>")
                in_ul = False
            body.append(f"<h2>{html.escape(line[3:].strip())}</h2>")
        elif line.startswith("### "):
            if in_ul:
                body.append("</ul>")
                in_ul = False
            body.append(f"<h3>{html.escape(line[4:].strip())}</h3>")
        elif line.startswith("- "):
            if not in_ul:
                body.append("<ul>")
                in_ul = True
            body.append("<li>" + inline_md(line[2:].strip()) + "</li>")
        elif line.strip() == "---":
            if in_ul:
                body.append("</ul>")
                in_ul = False
            body.append("<hr/>")
        elif line.strip() == "":
            if in_ul:
                body.append("</ul>")
                in_ul = False
        else:
            if in_ul:
                body.append("</ul>")
                in_ul = False
            body.append("<p>" + inline_md(line.strip()) + "</p>")
    if in_ul:
        body.append("</ul>")

    dir_attr = ' dir="rtl"' if rtl else ""
    lang = "ar" if rtl else "en"
    return f"""<!DOCTYPE html>
<html lang="{lang}"{dir_attr}>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>{html.escape(title)}</title>
<style>
:root {{ --bg:#0f1410; --card:#1a211c; --text:#f2f5f1; --mute:#a8b5ab; --accent:#c9a227; --line:#2a342e; }}
* {{ box-sizing:border-box; }}
body {{ margin:0; font-family: system-ui, -apple-system, 'Segoe UI', Roboto, 'Noto Sans Arabic', sans-serif;
  background:linear-gradient(180deg,#0f1410,#162018); color:var(--text); line-height:1.6; }}
main {{ max-width:720px; margin:0 auto; padding:24px 18px 48px; }}
h1 {{ font-size:1.6rem; margin:0 0 12px; color:var(--accent); }}
h2 {{ font-size:1.2rem; margin:28px 0 10px; }}
h3 {{ font-size:1.05rem; margin:20px 0 8px; }}
p,li {{ color:var(--text); font-size:0.98rem; }}
ul {{ padding-inline-start:1.2rem; }}
hr {{ border:none; border-top:1px solid var(--line); margin:24px 0; }}
a {{ color:var(--accent); }}
.card {{ background:var(--card); border:1px solid var(--line); border-radius:14px; padding:18px; }}
.muted {{ color:var(--mute); font-size:0.9rem; }}
</style>
</head>
<body>
<main class="card">
{chr(10).join(body)}
</main>
</body>
</html>
"""


DELETE_HTML = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Delete your Vireo account</title>
<style>
:root { --bg:#0f1410; --card:#1a211c; --text:#f2f5f1; --mute:#a8b5ab; --accent:#c9a227; --line:#2a342e; }
body { margin:0; font-family: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
  background:linear-gradient(180deg,#0f1410,#162018); color:var(--text); line-height:1.6; }
main { max-width:720px; margin:0 auto; padding:24px 18px 48px; }
.card { background:var(--card); border:1px solid var(--line); border-radius:14px; padding:18px; }
h1 { color:var(--accent); font-size:1.6rem; }
.muted { color:var(--mute); }
.steps { list-style:none; padding:0; counter-reset:step; }
.steps li { counter-increment:step; margin:12px 0; padding:12px 14px; background:#121812;
  border-radius:12px; border:1px solid var(--line); }
.steps li::before { content: counter(step) ". "; color:var(--accent); font-weight:700; }
a { color:var(--accent); }
code { background:#121812; padding:2px 6px; border-radius:6px; }
</style>
</head>
<body>
<main class="card">
<h1>Delete your Vireo account</h1>
<p class="muted">Last updated: October 17, 2026</p>
<p>You can delete your account and all synced data from inside the app, or by emailing us.</p>
<h2>In the app (recommended)</h2>
<ol class="steps">
<li>Open <strong>Settings</strong> → <strong>About</strong> (or Account).</li>
<li>Tap <strong>Delete account</strong>.</li>
<li>Read the warning, then type the confirmation word.</li>
<li>Confirm. Vireo calls the <code>delete-account</code> edge function, permanently deletes synced data, and signs you out.</li>
</ol>
<h2>By email</h2>
<p>Email <a href="mailto:mahmoud.mma.en@gmail.com">mahmoud.mma.en@gmail.com</a> from the address on your account with subject <strong>Delete my Vireo account</strong>. We will process the request within 30 days.</p>
<p class="muted">Cycle data is stored only on your device. Uninstalling the app or clearing app data removes it locally. After account deletion, cloud-synced logs are permanently removed.</p>
</main>
</body>
</html>
"""


def main() -> None:
    root = pathlib.Path(__file__).resolve().parents[1]
    legal = root / "docs" / "legal"
    out = root / "web_legal"
    out.mkdir(exist_ok=True)

    mapping = [
        ("privacy_policy_en.md", "privacy-en.html", "Vireo Privacy Policy", False),
        ("privacy_policy_ar.md", "privacy-ar.html", "سياسة خصوصية Vireo", True),
        ("terms_of_service_en.md", "terms-en.html", "Vireo Terms of Service", False),
        ("terms_of_service_ar.md", "terms-ar.html", "شروط استخدام Vireo", True),
    ]
    for src, dest, title, rtl in mapping:
        md = (legal / src).read_text(encoding="utf-8")
        (out / dest).write_text(md_to_html(md, title, rtl), encoding="utf-8")
        print("wrote", dest)

    (out / "delete-account.html").write_text(DELETE_HTML, encoding="utf-8")
    print("wrote delete-account.html")


if __name__ == "__main__":
    main()
