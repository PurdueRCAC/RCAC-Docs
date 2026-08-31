# Harness change log — the factory improving itself

Cross-job institutional memory for the self-improvement loop. `/docs-harness` appends a row here for
every finding it **applies** or **rejects**, so fixes don't thrash and rejected findings don't keep
coming back. Humans may annotate freely. **Newest first.**

- Per-job *raw observations* live in each `spec/{slug}/META.md` (written by the skills' meta-note step).
- This file is the *decisions* ledger across jobs — read it before applying a finding, to catch a
  proposed fix that would **revert** a recent deliberate change or repeat a **rejected** one.

| date | finding | job (META) | action | target | note |
|------|---------|-----------|--------|--------|------|
| 2026-07-15 | initial hardening pass (build-gate ERRORs, uv/.venv standardization, weaker/non-Claude robustness, verbatim-include pattern) | agentic-ai-docs (test-drive) | applied (manual, pre-loop) | `.agents/**`, `AGENTS.md` | Applied by hand during the factory test-drive before `/docs-harness` existed; recorded for provenance. Commits `58f49733`..`804f0bd3`. |
