#!/usr/bin/env python3
"""Convert Claude Code agent markdown to OpenCode ~/.config/opencode/agents/*.md."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

MODELS = {
    "haiku": "anthropic/claude-haiku-4-5",
    "sonnet": "anthropic/claude-sonnet-4-5",
    "opus": "anthropic/claude-opus-4-5",
}

# Reviewers/explorer must not edit. Verifier/companion need bash (tests, git diff).
EDIT_DENY = {
    "explorer",
    "companion-reviewer",
    "principal-reviewer",
    "verifier",
}
BASH_DENY = {"explorer"}

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


def yaml_escape(s: str) -> str:
    if any(c in s for c in ":{}\n\"'"):
        return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'
    return s


def convert_one(src: Path) -> str:
    meta, body = parse_md(src.read_text())
    name = meta["name"]
    desc = meta["description"]
    model = MODELS.get(meta.get("model", "sonnet"), MODELS["sonnet"])
    lines = [
        "---",
        f"description: {yaml_escape(desc)}",
        "mode: subagent",
        f"model: {model}",
    ]
    if name in EDIT_DENY:
        lines.append("permission:")
        lines.append("  edit: deny")
        lines.append("  bash: deny" if name in BASH_DENY else "  bash: allow")
    lines.extend(["---", "", body.rstrip(), ""])
    return "\n".join(lines)


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("src", type=Path)
    p.add_argument("dest", type=Path)
    args = p.parse_args()
    args.dest.mkdir(parents=True, exist_ok=True)
    for md in sorted(args.src.glob("*.md")):
        out = args.dest / md.name
        out.write_text(convert_one(md))
        print(out)


if __name__ == "__main__":
    main()
