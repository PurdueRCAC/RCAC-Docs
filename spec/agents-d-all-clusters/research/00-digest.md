# Research digest — agents-d-all-clusters

Five briefs, written 2026-10-09. Bell (`02`) was researched and then dropped from scope by the
GOAL amendment of the same day; its brief is kept for the record.

| Brief | Topic | Bottom line |
|---|---|---|
| [`01-anvil-facts.md`](01-anvil-facts.md) | Anvil data model + template audit | Anvil differs most. `mybalance` not `slist`; `$SCRATCH`/`$PROJECT` under `/anvil`; no `findscratch`, Depot, `hsi`/`htar`; no user QOS, SU charging instead; ACCESS Help Desk, not rcac-help. Facts the guide leaves open were confirmed by RCAC staff (GOAL amendment). |
| [`02-bell-facts.md`](02-bell-facts.md) | Bell (out of scope) | Retained for reference only. |
| [`03-scholar-facts.md`](03-scholar-facts.md) | Scholar data model + template audit | Account `scholar`; QOS `normal`/`long`/`debug`, no `standby`; `spark-*` partitions are aarch64 and need `modtree/spark`; OS of x86 nodes not stated; home is Scholar-only; no charging or balances documented. |
| [`04-generator-and-pages.md`](04-generator-and-pages.md) | Generator, settings-referencing pages, chapters, baseline | Regeneration is byte-identical today. Remove the settings outputs and parameterize the templates through generator defaults so the existing three stay identical except for intended changes. 27-row page inventory. No redirect plugin, so the stub stays in place. Strict baseline: 0 warnings. |
| [`05-optin-mcp-prose.md`](05-optin-mcp-prose.md) | Per-harness opt-in, `rcac-mcp` behavior, prose audit | Verified one-time hookups for all four CLIs. Gemini's `@import` cannot reach `/etc`, so it needs a symlink plus a setting. Warp has no file hookup. `rcac-mcp` exposes `rcac://context` on demand and does not inject it. About 50 flowery lines and 21 lines made false by the policy change, each with a rewrite. |

## Cross-cutting findings

1. **The templates assume campus-cluster conventions.** `slist`, `sfeatures`, `findscratch`,
   `$RCAC_SCRATCH`, the `standby` QOS, Depot, Fortress via `hsi`, rcac-help and the Purdue
   AUP line are written as literals. Anvil breaks most of them and Scholar breaks the QOS and
   charging lines. Generator defaults equal to today's literals, overridable per cluster, fix
   this without touching the existing three YAMLs.
2. **`purgelist` is undocumented everywhere** and is dropped (GOAL amendment).
3. **The on-cluster delivery story was never built.** No symlinks to harness filenames exist.
   The pages must describe the user opt-in instead (R6).
4. **`rcac-mcp` offers, it does not inject.** Pages must say the agent (or user) reads the
   `rcac://context` resource. The duplicate-content behavior is an `rcac-mcp` matter outside
   this job.
5. **The docs-server registration snippets live only in the settings templates.** Move them
   into `mcp_servers.md` before deleting the templates.
