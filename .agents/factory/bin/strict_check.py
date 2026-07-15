#!/usr/bin/env python3
"""Gate a `mkdocs build --strict` log against the known-warning baseline.

`mkdocs build --strict` promotes build WARNINGs (broken internal links, missing
targets, nav orphans) to hard errors. Because CI builds with `--verbose` (not
`--strict`), those warnings ship silently — so the factory runs `--strict`
itself as its build-integrity gate. This script blocks only on warnings that are
NOT already recorded in the baseline, i.e. regressions the current change
introduced. Pre-existing warnings are known debt tracked in the baseline file.

Usage (run from the repo root, with the project env active):
    .venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py
    # or from a captured log:
    python3 .agents/factory/bin/strict_check.py build.log

Options:
    --baseline PATH   baseline file (default: .agents/factory/strict-baseline.txt)

Exit codes:
    0  no new warnings beyond the baseline (PASS)
    1  new warning(s) attributable to this change (STOP)
    2  usage / I/O error (e.g. missing baseline file)
"""
from __future__ import annotations

# Standard libs
import argparse
import re
import sys
from pathlib import Path

# Public interface
__all__ = ["main", "extract_warnings", "load_baseline"]

# A mkdocs strict warning line looks like: "WARNING -  <message>".
_WARNING_RE = re.compile(r"^WARNING\s*-\s*(?P<msg>.*\S)\s*$")


def extract_warnings(text: str) -> set[str]:
    """Return the set of normalized WARNING messages found in a build log."""
    out: set[str] = set()
    for line in text.splitlines():
        m = _WARNING_RE.match(line)
        if m:
            out.add(m.group("msg").strip())
    return out


def load_baseline(path: Path) -> set[str]:
    """Return the set of baseline warning messages (ignoring '#' and blanks)."""
    out: set[str] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        out.add(stripped)
    return out


def main(argv: list[str]) -> int:
    default_baseline = Path(__file__).resolve().parent.parent / "strict-baseline.txt"
    ap = argparse.ArgumentParser(description="Gate a mkdocs --strict log against the warning baseline.")
    ap.add_argument("log", nargs="?", help="build log file (default: read stdin)")
    ap.add_argument("--baseline", default=str(default_baseline), help="baseline file path")
    args = ap.parse_args(argv)

    baseline_path = Path(args.baseline)
    try:
        baseline = load_baseline(baseline_path)
    except OSError as exc:
        print(f"cannot read baseline {baseline_path}: {exc}", file=sys.stderr)
        return 2

    try:
        text = Path(args.log).read_text(encoding="utf-8") if args.log else sys.stdin.read()
    except OSError as exc:
        print(f"cannot read log {args.log}: {exc}", file=sys.stderr)
        return 2

    found = extract_warnings(text)
    new = sorted(found - baseline)
    fixed = sorted(baseline - found)

    if new:
        print(f"FAIL: {len(new)} new mkdocs --strict warning(s) introduced by this change:")
        for msg in new:
            print(f"  + {msg}")
        print(
            "\nFix the broken link/target/nav, or (if intentional and pre-existing) "
            "record it in .agents/factory/strict-baseline.txt with justification."
        )
        return 1

    print(f"PASS: no new --strict warnings ({len(found)} present, all in baseline of {len(baseline)}).")
    if fixed:
        print(
            f"Note: {len(fixed)} baseline warning(s) no longer appear — consider deleting "
            "them from strict-baseline.txt so the debt count only shrinks:"
        )
        for msg in fixed:
            print(f"  - {msg}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
