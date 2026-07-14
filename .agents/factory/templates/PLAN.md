# PLAN — {Title}

> **Status:** Draft for review · **Last updated:** {YYYY-MM-DD}
> **Authoritative design.** The *how*. Vision/contract is [`GOAL.md`](GOAL.md); the phased
> executable roadmap is [`TECH.md`](TECH.md). Backing detail is in [`research/`](research/)
> (when `appetite: big`). Every design element traces to a GOAL R-ID.

## 1. Summary

<2–4 sentences: the approach in a nutshell and why it fits the appetite.>

## 2. Design

<The real design at the right altitude. Cover, as applicable:>

- **Archetype** (see [`../../.agents/factory/style-guide.md`](../../.agents/factory/style-guide.md)):
  userguide article · catalog entry · blog post · tutorial/workshop lesson · reference/hub. State
  the front-matter contract it implies.
- **Page structure:** the file(s) to create/edit and their heading outline; which are new vs edited.
- **Navigation placement:** exactly where in `mkdocs.yml` `nav:` each page goes (and the section
  `index.md` hub, if any). Note that breadcrumbs regenerate from nav.
- **Reuse:** which `main.py` macros and `docs/snippets/` includes to use (don't hardcode
  cluster-variable content); which existing gold-standard page to mirror.
- **Assets:** images/PDFs to add under `docs/assets/…`, and their absolute reference paths.
- **Cross-links & tags:** related pages to link to/from; tags/categories to apply.
- **Accessibility plan:** alt text, heading hierarchy, table headers, link text.

### Requirement → design map

| R-ID | Design element(s) that satisfy it |
|------|-----------------------------------|
| R1   | <page/section/nav entry/macro> |
| R2   | <…> |

## 3. Invariant gate (constitution check)

Checked against [`../../.agents/factory/invariants.md`](../../.agents/factory/invariants.md)
**before** research and **again** after this design was drafted. List every invariant this change
touches and confirm compliance (branch/deploy model, generated-content firewall, nav-is-manual,
links/assets, front-matter, macros/Jinja, build integrity, WCAG, per-cluster parallelism, HPC
accuracy).

- <invariant> — <how this design honors it>.

### Deviation justifications

Any place this design bends an invariant or adds complexity — with the simpler alternative and why
it was rejected. Empty is the goal.

| Deviation | Why needed | Simpler alternative rejected because |
|-----------|-----------|--------------------------------------|
| —         | —         | — |

## 4. Rabbit holes (resolved)

Scary unknowns that could have blown the appetite, and how research settled them (link the relevant
`research/NN-*.md`). For docs this is often HPC-accuracy verification (is this the right partition
name / Slurm flag / module?) or "how does the existing site handle X".

- <unknown> → <resolution> ([`research/NN-topic.md`](research/NN-topic.md)).

## 5. Risks & open questions

- <residual risk, mitigation, or a question that needs a human before/at drafting — e.g. an unverified
  HPC spec, a policy detail, an authoritative source to confirm>.

## 6. Verification strategy

How we will *prove* the pages are correct — this seeds each phase's `verify:` in `TECH.md`:

- **Build integrity:** `.venv/bin/mkdocs build --strict 2>&1 | python3 .agents/factory/bin/strict_check.py`
  (no new warnings vs baseline).
- **Nav:** the new page(s) appear in `mkdocs.yml` and resolve (no "not in nav" warning).
- **Render:** `mkdocs serve` and view the page(s) — layout, tabs, admonitions, macros expand.
- **Front-matter:** matches the archetype (blog `<!-- more -->` + allowed category + known author, etc.).
- **Accessibility:** images have alt text; headings descend logically.
- **HPC accuracy:** which authoritative source or gold-standard page each factual claim was checked against.

---

*Backing research (if present): [`research/00-digest.md`](research/00-digest.md).*
