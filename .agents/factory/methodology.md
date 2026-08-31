# The documentation factory — methodology

This document explains the *why* behind the spec-driven authoring lifecycle that the
`docs-*` skills implement. The skills themselves are thin; this is the rationale a
contributor (human or agent) reads once to understand the flow. For a gentler,
narrative introduction see `getting-started.html`.

**Precedence.** When something here disagrees with a skill, the skill body is the
operating procedure — fix this file. When something here disagrees with `AGENTS.md`,
`AGENTS.md` (the constitution) wins. The rendered site and the source tree are ground
truth; the `spec/{slug}/` records are a point-in-time account of intent, not a living
source of truth to maintain forever.

## What we are adapting, and why

This is the HyperShell "software factory" (spec-driven development for a Python engine)
generalized to **documentation and training authoring**. The lifecycle is conserved;
only the domain changes. A software feature becomes a new user guide, tutorial, or blog
post; a bug fix becomes a correction or enhancement; "drive the CLI to prove it works"
becomes **"render the site and inspect it."** The invariants stop being about task
databases and TLS and become about navigation, front-matter, generated-content, HPC
technical accuracy, and accessibility.

We do this because documentation deserves the same rigor code gets: shaped intent,
a reviewable design, an auditable trail, and an independent quality gate — so an agent
can *author* material, not just edit it, and a human can trust what shipped.

## The lifecycle

One job (a `feature`, `fix`, or `refactor`) flows through five skills, on its own git
branch, with every artifact committed under `spec/{slug}/`:

```
main ──/docs-feature──▶ feature|fix|refactor/{slug}   GOAL.md         (shape: what & why, locked)
          ├──────────/docs-plan──────────▶  research/ PLAN.md TECH.md  (design + phased FSM)
          ├──────────/docs-draft─────────▶  docs/ + mkdocs.yml nav     (author one phase/loop)
          │             ▲        │
          │             └────────┘  (loop until TECH.md is done)
          ├──────────/docs-review────────▶  REVIEW.md        (blind QA: build, render, links, a11y)
          │             │
          │       changes-requested ──▶ back to /docs-draft ;  approved ──▶
          └──────────/docs-publish───────▶  PR → main   (auto-deploys to production)
```

1. **`/docs-feature`** → `GOAL.md`: the shaped, *locked* contract — problem, appetite,
   non-goals, and testable acceptance criteria with stable `R#` IDs. Shaping only; no
   deep research, no drafting.
2. **`/docs-plan`** → `research/`, `PLAN.md`, `TECH.md`: the design (page structure,
   archetype, nav placement, macros/snippets, assets, cross-links, a11y strategy) and a
   phased YAML-FSM (`TECH.md`) the drafting step resumes from.
3. **`/docs-draft`** → the actual pages + `mkdocs.yml` nav: executes one phase, runs that
   phase's `verify:` gate, makes one atomic content+state commit. Loops until done.
4. **`/docs-review`** → `REVIEW.md`: blind, adversarial QA in a clean context — a fresh
   reviewer that sees the GOAL, the diff, and the invariants but *not* the author's plan.
5. **`/docs-publish`** → a squash PR to `main`. On merge, the site auto-deploys to
   production (Geddes) within ~5 minutes — there is no staging gate, so review is the
   last line of defense.

Renamed from HyperShell: `build` → **`draft`**, because `/docs-build` collides with
`mkdocs build`, and "draft" better connotes revisable prose.

## The artifact spine

`GOAL.md → PLAN.md → TECH.md → REVIEW.md`, all anchored by stable requirement IDs
(`R1`, `R2`, …). This is the industry-standard spec-driven skeleton (cf. GitHub Spec Kit
`spec → plan → tasks`; AWS Kiro `requirements → design → tasks`). The `R#` is the
connective tissue: GOAL defines them → PLAN maps each to a design element → TECH's phases
declare which they `satisfies` → REVIEW verifies each against the rendered diff. The
committed `spec/{slug}/` folder is an immutable, dated design record ("build in the
open"), retained on merge like an ADR — not a doc to keep updating.

## Load-bearing principles

1. **`AGENTS.md` is the constitution.** Skills reference it and the curated
   `invariants.md` (a strict subset, kept in lockstep). There is no invented
   `constitution.md`.
2. **Files and git are the durable substrate.** Lifecycle state lives only in committed
   `TECH.md` frontmatter, re-read fresh each invocation via `next_phase.py`. Never rely
   on conversation memory to carry state — `docs-review` runs in a separate context, and
   `docs-draft` may resume next week on another machine.
3. **Parallelize research, never authoring.** `docs-plan` may fan out read-only research
   subagents (surveying existing pages, reference sites, HPC specifics). `docs-draft` is
   strictly single-threaded and linear — parallel authors make conflicting implicit
   decisions about voice, structure, and nav. (This factory itself was *researched* in
   parallel and *written* serially, for exactly this reason.)
4. **Blind, externally-verified review beats self-review.** The reviewer is denied the
   author's PLAN/TECH rationale and must cite evidence — a `mkdocs build --strict` run, a
   rendered page, a resolved link — not an assertion. Enforced by spawning a fresh
   subagent, not by trusting a human to `/clear`.
5. **Ceremony scales to appetite.** The worst anti-pattern is a uniform heavyweight
   process — 16 acceptance criteria for a one-line typo fix. `appetite: small` (default
   for `fix/`) skips research fan-out and collapses to a single phase; a one-sentence
   change may skip the lifecycle entirely. Rigor is a dial, not a toll.
6. **Never guess.** Ambiguity gets a literal `[NEEDS CLARIFICATION: …]` marker in
   `GOAL.md` and a question to a human — never a silent assumption. Wrong HPC
   instructions harm users.

## Shape Up, adapted

We take Shape Up's cognitive tools and drop its team rituals.

**Adopt:** *appetite* (fixed budget, variable scope — expressed as a phase/iteration cap,
since calendar weeks are meaningless at machine tempo); *shaping* (`GOAL.md` is rough,
solved, and bounded); *no-gos* (explicit exclusions); *rabbit holes* (each
`research/NN-topic.md` investigates one scary unknown); *hill* (`uphill|crest|downhill`
per phase — a stuck-uphill phase is a raised hand); *scope hammering* (nice-to-haves are
cuttable; review scope-checks against appetite); *circuit breaker* (cap draft iterations
and review bounce-backs; on trip, stop and re-shape).

**Discard:** the betting table, six-week cycles, cool-down, separate shaper/builder/QA
roles — those synchronize a human *team* and dissolve for a serial solo-plus-agent flow.

**The one place Shape Up must NOT be followed — quality is not negotiable.** Shape Up
assumes scope is always cuttable and most defects can wait. That is *false* for
documentation that people run on real clusters: a wrong `#SBATCH` flag, a partition that
doesn't exist, an inaccessible table, or a broken link that silently ships to production
is not a deferrable defect. Three concerns are marked `hammerable: false` and the reviewer
may never trim them to "fit the appetite":

- **HPC technical accuracy** — commands, flags, partition/sub-cluster names, paths, specs.
- **WCAG 2.1 content-level accessibility** — alt text, heading order, link text, tables.
- **Build integrity** — `mkdocs build --strict` introduces no new warnings (see below).

## Verify by rendering, not asserting

CI builds with `mkdocs build --verbose`, **not** `--strict` — so broken internal links and
nav orphans deploy silently today. The factory closes that gap: every phase's `verify:`
runs `mkdocs build --strict` piped through `.agents/factory/bin/strict_check.py`, which
blocks only on warnings not already in `strict-baseline.txt`. Beyond the build, verify by
*looking*: render the page (`mkdocs serve`), confirm it appears in the nav, check that
links resolve, that front-matter matches the archetype, and that images have alt text.

## Where things live

```
.agents/
  skills/docs-{feature,plan,draft,review,publish}/SKILL.md   # the five lifecycle skills
  skills/docs-harness/SKILL.md      # meta/maintenance: applies META.md findings to the factory
  factory/
    methodology.md   invariants.md   ears.md   style-guide.md   review-rubric.md
    getting-started.html            # human onboarding
    strict-baseline.txt             # known pre-existing --strict warnings
    harness-log.md                  # cross-job ledger of applied/rejected self-improvement fixes
    templates/                      # GOAL.md PLAN.md TECH.md REVIEW.md META.md skeletons
    bin/                            # next_phase.py, set_phase.py, strict_check.py, meta_status.py, _fsm.py
spec/{slug}/                        # per-job artifacts (committed, retained on merge)
  GOAL/PLAN/TECH/REVIEW.md          # the content spine (R-IDs)
  META.md                           # orthogonal: harness-retrospective findings (F-IDs) — the toolmaker's notes
AGENTS.md                           # the constitution (CLAUDE.md is a symlink to it)
```

`.claude` is a symlink to `.agents` so Claude Code discovers the skills and settings.

## Traceability chain

`GOAL.md` R-IDs → `PLAN.md` requirement→design map → `TECH.md` phase `satisfies:` →
commits → `REVIEW.md` requirement→evidence matrix → PR body. Because a merged PR squashes
per-commit history, the committed `spec/{slug}/` folder *is* the retained trace.
Provenance lives in that chain and in the commit/PR — **never** embed feature-scoped
`R#`/`P#` IDs in page content (they restart per job and collide across branches).

## The self-improvement loop (META.md + `/docs-harness`)

The factory watches its own friction and — human-gated — fixes itself. The loop is deliberately
**asymmetric: cheap to observe, deliberate to act**, so it can't become a token-sink or quietly
loosen its own guardrails.

- **Observe (every lifecycle skill, silence by default).** Each `docs-*` skill ends with a
  **meta-note step** that appends a finding to `spec/{slug}/META.md` **only** when a concrete problem
  in the *skillset itself* cost something — gated by one test: *"the instructions' fault, not mine or
  the task's?"* A merely hard task, a self-inflicted error, or a one-off content issue is **not** a
  finding. `META.md` is orthogonal to the `GOAL→…→REVIEW` content spine: it uses `F#` ids, is about
  the *toolchain*, and is **kept out of the blind reviewer's context** (it can leak author intent).
- **Surface.** `/docs-publish` reads open findings (`meta_status.py`) and adds a terse, labelled
  "🔧 Harness feedback" block to the PR body, so a human sees process friction alongside the content.
- **Act (`/docs-harness`, human-gated).** Points at a job's `META.md`, previews the recommended fix
  for each finding, and — defaulting to all but scopable to specific ids (`F1 F3`) — applies them to
  `.agents/` as atomic `[harness]` commits, recording each in the cross-job `harness-log.md`.

The safety of the loop rests on four rules, enforced in `/docs-harness`: **observer ≠ fixer**
(recording is cheap and low-stakes; the fix is authored later with fresh eyes + human review);
**never auto-weaken a `hammerable:false` gate** without an explicit human override; **fixes must
generalize** (reject overfit-to-one-job); and **no meta-on-meta** (`/docs-harness` writes no
findings). `harness-log.md` is the anti-thrash memory: a proposed fix that reverts a recent change or
repeats a rejected one is flagged, not silently re-applied. `.agents/**` edits don't trigger the prod
deploy (CI path filter), so the blast radius is the *next* job's authoring, not the live site — which
is exactly why the human gate matters.
