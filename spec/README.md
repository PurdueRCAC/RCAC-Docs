# `spec/` — documentation-factory design records

Each documentation job run through the factory (see [`../.agents/factory/methodology.md`](../.agents/factory/methodology.md))
gets a `spec/{slug}/` directory holding its committed, dated design record:

```
spec/{slug}/
  GOAL.md      # what & why — the locked contract (stable R-IDs), by /docs-feature
  PLAN.md      # the design (archetype, structure, nav, macros, a11y), by /docs-plan
  TECH.md      # the phased YAML-FSM the draft step resumes from, by /docs-plan
  REVIEW.md    # blind adversarial QA findings + verdict, by /docs-review
  research/    # read-only research briefs (big appetite only), by /docs-plan
```

These are an **immutable, point-in-time record of intent** ("build in the open"), retained on
merge like an architecture decision record — not living documents to maintain forever. The
rendered site and the source tree remain ground truth; `AGENTS.md` is the constitution.

This directory sits **outside `docs/`**, so MkDocs does not build or publish it.

The `{slug}` matches the job's branch (`feature/{slug}`, `fix/{slug}`, or `refactor/{slug}`).
Start a new job with `/docs-feature`.
