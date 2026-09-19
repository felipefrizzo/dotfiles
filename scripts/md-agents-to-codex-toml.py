#!/usr/bin/env python3
"""Convert Claude Code agent markdown to Codex ~/.codex/agents/*.toml."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

READONLY = {
    "explorer",
    "companion-reviewer",
    "principal-reviewer",
    "verifier",
}

FM_RE = re.compile(r"^---\n(.*?)\n---\n(.*)\Z", re.S)


def parse_md(text: str) -> tuple[dict[str, str], str]:
    m = FM_RE.match(text)
    if not m:
        raise ValueError("missing YAML frontmatter")
    meta: dict[str, str] = {}
    for line in m.group(1).splitlines():
        if ":" not in line:
            continue
        k, v = line.split(":", 1)
        meta[k.strip()] = v.strip()
    return meta, m.group(2).strip() + "\n"


def toml_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"""', r"\"\"\"")


def convert_one(src: Path) -> str:
    meta, body = parse_md(src.read_text())
    name = meta["name"]
    desc = meta["description"]
    lines = [
        f'name = "{name}"',
        f'description = "{toml_escape(desc)}"',
        'developer_instructions = """',
        toml_escape(body).rstrip(),
        '"""',
    ]
    if name in READONLY:
        lines.append('sandbox_mode = "read-only"')
    if name == "verifier":
        lines.append('model = "gpt-5.6-luna"')
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("src", type=Path)
    p.add_argument("dest", type=Path)
    args = p.parse_args()
    args.dest.mkdir(parents=True, exist_ok=True)
    for md in sorted(args.src.glob("*.md")):
        out = args.dest / f"{md.stem}.toml"
        out.write_text(convert_one(md))
        print(out)


if __name__ == "__main__":
    main()
