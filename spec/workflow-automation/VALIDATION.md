# VALIDATION — workflow-automation

The cluster validation log for this cycle (GOAL R15; PLAN §6). Step agents never run anything on a
cluster. The cycle's validator runs the PLAN §6 envelope against the committed snippet files and
records results here. Each validating phase's `verify:` in [`TECH.md`](TECH.md) greps for its
status line, so a phase closes only once its line reads `PASS`.

**Status line format** (one per phase, at the start of a line):

- `P<n>: PENDING — <files to run>` (written by the draft run)
- `P<n>: PASS — <YYYY-MM-DD>, <clusters>, HyperShell <version or commit>` (written by the validator)
- `P<n>: FAIL — <YYYY-MM-DD>, <what broke>` (written by the validator; the close run fixes and re-queues)

Under each phase heading, record: the build under test, image tags (P7), the account/partition/QOS
used (placeholders in the pages stay placeholders), the `sbatch --test-only` result per tab, the
checks from the PLAN §6 row, and any change the draft needs.

## Build under test

*(validator: HyperShell version or `develop` commit, install route, per cluster)*

## P2 — Baseline tools (V2)

## P3 — Workflow managers (V3)

## P4 — Guide landing page and Tier 1 (V4)

## P5 — GPU multiplexing and Tier 2 (V5)

## P6 — Tier 3 (V6)

## P7 — Tier 4 (V7, including the manual Rancher walk-through)

## Policy and network confirmations

*(RCAC staff confirmations for PLAN §5 Q4 and Q5, with date and source)*
