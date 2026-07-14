# EARS for documentation acceptance criteria

**EARS** (Easy Approach to Requirements Syntax) is a lightweight controlled-natural-language
convention for writing acceptance criteria that are **testable and low-ambiguity**. Used by
`docs-feature` to shape the `GOAL.md` acceptance criteria (the `R#` IDs).

## Philosophy — nudge, don't hard-enforce

EARS reduces ambiguity but doesn't eliminate it; forcing it onto exploratory or purely
descriptive requirements makes them stilted. Prefer EARS where it clarifies; fall back to
plain, unambiguous prose where EARS would be contrived. **Every criterion still gets a
stable `R#` ID.**

## Generic template

> **While** \<optional precondition/state>, **when** \<optional trigger>, the \<subject>
> **shall** \<observable outcome>.

For documentation, keep the pieces concrete:

- `<subject>` is a real part of the site — a page, a nav entry, a table, a code block, a
  macro/snippet, the search index, the build.
- `<outcome>` is **observable**: the page renders, the link resolves, the nav contains the
  entry, the table lists the right values, `mkdocs build --strict` stays clean, an image
  has alt text. If the reviewer cannot check it by rendering the site or reading the diff,
  it is too vague.

## The six patterns

| Pattern | Keyword | Form |
|---|---|---|
| **Ubiquitous** | *(none)* | The \<subject> shall \<outcome>. |
| **State-driven** | `While` | While \<state>, the \<subject> shall \<outcome>. |
| **Event-driven** | `When` | When \<trigger>, the \<subject> shall \<outcome>. |
| **Optional-feature** | `Where` | Where \<feature is included>, the \<subject> shall \<outcome>. |
| **Unwanted-behavior** | `If … Then` | If \<unwanted condition>, then the \<subject> shall \<outcome>. |
| **Complex** | combo | While \<state>, when \<trigger>, the \<subject> shall \<outcome>. |

## Documentation-flavored examples (R-ID + pattern)

- **R1 (event):** *When* a reader opens the Gautschi "Running Jobs" page, the page *shall*
  show a complete, copy-pasteable `#SBATCH` batch-script example for the `cpu` partition.
- **R2 (ubiquitous):** The new tutorial *shall* appear under Workshops in `mkdocs.yml`
  `nav:` and resolve from the Workshops hub without a `--strict` nav warning.
- **R3 (state):** *While* viewed on the Gautschi guide, every SSH instruction *shall* be
  rendered from the shared `ssh_keys_snippet(resource)` macro (no hardcoded hostname).
- **R4 (unwanted):** *If* a reader follows any internal link added by this change, *then*
  `mkdocs build --strict` *shall* report no new broken-link warning for it.
- **R5 (optional-feature):** *Where* the page includes screenshots, each image *shall*
  carry descriptive `alt` text and use an absolute `/assets/images/...` path.
- **R6 (ubiquitous):** The Negishi partition table *shall* list sub-clusters A, B, and G
  with their correct core-per-node counts.

## Anti-patterns

- **Untestable adjectives** ("clear", "comprehensive", "user-friendly") — replace with an
  observable condition (a specific section exists, a specific value is listed).
- **Multiple requirements on one line** — split so each has its own `R#` and pass/fail.
- **Specifying the *how* (which macro, which file) in a criterion** — that is design; it
  belongs in `PLAN.md`, not `GOAL.md`. The criterion states the reader-facing outcome.
