#!/usr/bin/env python3
"""Enumerate the findings in a spec's META.md as JSON.

META.md is the per-job harness-retrospective log (see
``.agents/factory/templates/META.md``). Each finding is a markdown section::

    ## F3 — verify gate passes on build ERRORs
    `origin=docs-plan severity=high category=tooling status=open target=path/to/file`
    - **What happened:** ...
    - **Recommended fix:** ...

This reader is stdlib-only (no PyYAML, no mkdocs), so it cannot break on a missing
dependency — but invoke it via ``.venv/bin/python`` like every other factory script
(the project convention; see AGENTS.md "Setup"). `/docs-harness` and `/docs-publish`
use it to enumerate/count findings instead of hand-parsing markdown (the same "scripts
own the fragile parsing" principle as ``next_phase.py``). It never mutates the file.

Usage (from the repo root)::

    .venv/bin/python .agents/factory/bin/meta_status.py spec/<slug>/META.md
    .venv/bin/python .agents/factory/bin/meta_status.py spec/<slug>/META.md --status open
    .venv/bin/python .agents/factory/bin/meta_status.py spec/<slug>/META.md --status open --severity high
    .venv/bin/python .agents/factory/bin/meta_status.py spec/<slug>/META.md F1 F3   # only these ids

Exit codes: 0 ok (even with zero findings) · 2 usage / I/O error.
A missing META.md is NOT an error — it means "no findings" (prints an empty set).
"""
from __future__ import annotations

# Standard libs
import argparse
import json
import re
import sys
from pathlib import Path

# Public interface
__all__ = ["main", "parse_findings"]

# A finding starts at a "## F<n> — <title>" heading. Accept "—", "-", or ":" as the separator.
_HEADING_RE = re.compile(r"^##\s+(?P<id>F\d+)\s*[—:-]\s*(?P<title>.*\S)\s*$", re.MULTILINE)
# key=value tokens on the attributes line. Values are non-whitespace but exclude backticks, so a
# code-span-wrapped attributes line (`origin=… target=path`) does not glue the closing ` onto target.
_KV_RE = re.compile(r"(?P<key>\w+)=(?P<val>[^\s`]+)")
_ATTR_KEYS = ("origin", "severity", "category", "status", "target")


def parse_findings(text: str) -> list[dict]:
    """Parse META.md text into a list of finding dicts (in document order).

    Example/commented-out findings inside HTML comments (``<!-- ... -->``) are
    ignored, so the template's illustrative F1 never counts as real.
    """
    # Strip HTML comments first so the template's example block is not parsed.
    text = re.sub(r"<!--.*?-->", "", text, flags=re.DOTALL)

    findings: list[dict] = []
    matches = list(_HEADING_RE.finditer(text))
    for i, m in enumerate(matches):
        start = m.end()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        body = text[start:end]

        attrs: dict[str, str] = {}
        for line in body.splitlines():
            if "status=" in line or "origin=" in line:
                attrs = {kv.group("key"): kv.group("val") for kv in _KV_RE.finditer(line)}
                break

        finding = {"id": m.group("id"), "title": m.group("title").strip()}
        for key in _ATTR_KEYS:
            finding[key] = attrs.get(key, "")
        findings.append(finding)
    return findings


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description="Enumerate findings in a spec's META.md as JSON.")
    ap.add_argument("path", help="path to spec/<slug>/META.md")
    ap.add_argument("ids", nargs="*", help="only these finding ids (e.g. F1 F3)")
    ap.add_argument("--status", help="filter by status (e.g. open)")
    ap.add_argument("--severity", help="filter by severity (e.g. high)")
    args = ap.parse_args(argv)

    path = Path(args.path)
    if not path.exists():
        # A missing META.md means "no findings recorded" — a normal, clean outcome.
        print(json.dumps({"path": str(path), "exists": False, "count": 0, "findings": []}, indent=2))
        return 0
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as exc:
        print(f"cannot read {path}: {exc}", file=sys.stderr)
        return 2

    findings = parse_findings(text)
    wanted = set(args.ids)
    selected = [
        f for f in findings
        if (not wanted or f["id"] in wanted)
        and (not args.status or f["status"] == args.status)
        and (not args.severity or f["severity"] == args.severity)
    ]
    open_high = [f for f in findings if f["status"] == "open" and f["severity"] == "high"]
    report = {
        "path": str(path),
        "exists": True,
        "count": len(selected),
        "total": len(findings),
        "open": len([f for f in findings if f["status"] == "open"]),
        "open_high": [f["id"] for f in open_high],
        "findings": selected,
    }
    print(json.dumps(report, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
