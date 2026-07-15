---
tags:
  - Agentic AI
authors:
  - glentner
---

# Best Practices & Limitations

Agentic coding tools are genuinely useful on HPC — they draft submission scripts,
untangle build errors, and automate the tedious parts of managing a workflow. They
are also, in the words of our PEARC'26 paper, **"mostly harmless"**: powerful, but
prone to confident mistakes. Getting good results is less about the model and more
about *how you use it*. This page collects the practices that separate a productive
session from a frustrating — or costly — one.

## Know when you're doing research versus operations

Draw a line between the two very different jobs you might ask an agent to do:

- **Research** — writing analysis code, exploring a dataset, prototyping a model,
  drafting and debugging a submission script. Mistakes here are usually cheap and
  self-correcting: the code doesn't compile, the plot looks wrong, the job fails
  fast. This is where agents shine, and where you can let them iterate freely.
- **Operations** — moving or deleting data, managing quota, cancelling jobs,
  changing permissions, installing software, editing shared files. Mistakes here
  are expensive and sometimes irreversible: a deleted directory, an exhausted
  allocation, a corrupted shared environment. Slow down. Review each command before
  it runs, and keep destructive operations behind an explicit confirmation.

The same agent is trustworthy for the first and needs a short leash for the second.
Configure your harness accordingly — the
[per-harness settings](shared_context/settings.md) we publish deny the most dangerous
operations by default as a starting point.

## Engineer the context ("Tea, Earl Grey, hot")

An agent is only as good as the context it operates in. Vague requests get vague —
often wrong — answers; specific ones get useful results. Captain Picard doesn't ask
the replicator for "a drink," he asks for "Tea, Earl Grey, hot." Bring the same
specificity to your prompts:

- Name the cluster, the partition, the account, and the software versions you
  actually intend to use, rather than letting the agent guess.
- Point the agent at the authoritative source. RCAC injects cluster-specific
  context into agents automatically (see [MCP Servers](mcp_servers.md) and the shared
  [context files](shared_context/context_files.md)), so an agent connected to our
  tooling already knows Gautschi runs Slurm, uses Lmod, and has partitions named
  `cpu`/`ai`/`highmem` — it does not have to infer it from general knowledge.
- Give the agent the error message, the job ID, the exact file — not a paraphrase.

Good context supplied up front prevents the single most common failure mode on HPC:
a plausible, well-formatted answer written for a system we don't run.

## Verify: augmented, not outsourced

Use an agent to accelerate your own understanding, not to replace it. The goal is to
be **augmented, not outsourced**.

- **Ask *why*, not just *what*.** When an agent proposes an `#SBATCH` line or a
  `module load`, ask it to explain the choice. You learn something, and the
  explanation often exposes a wrong assumption.
- **Verification isn't optional — it's the core competency.** Read the generated
  script before you submit it. Confirm the partition exists, the account is one you
  can charge, the paths are real. An agent will state a nonexistent module or an
  invalid partition with total confidence.
- **Mind the expertise paradox.** These tools are most dangerous precisely where you
  know the least, because that is exactly where you cannot catch the error. If you
  can't yet evaluate the output, treat it as a draft to learn from, not an answer to
  run.

## Let the agent ground itself first

Counterintuitively, the safest agents are the ones that look before they leap.
Encourage — and permit — your agent to run **read-only sanity checks** eagerly,
before it acts, so its plan is grounded in the real state of the cluster rather than
an assumption:

- `myquota` — how much home and scratch space you actually have left.
- `slist` — which accounts you can charge, and their balances.
- `sfeatures` — the real node/GPU features available.
- `module avail` / `module list` — what software exists and what is currently
  loaded.

The per-harness [settings we publish](shared_context/settings.md) allow-list these
commands so the agent runs them without stopping to ask. An agent that checks `slist`
before writing
`--account=` will not invent an account name; one that runs `module avail` before a
`module load` will not hallucinate a version.

## Understand the blast radius

Agents don't introduce new *kinds* of risk on a well-run cluster so much as they
**accelerate the pace** at which an ordinary mistake can happen. The confinement that
already protects our systems — cgroups, quotas, health checks, root-squash,
per-user permissions — still applies to an agent acting as you. But existing
hardening has to be *respected*, not bypassed. Keep these failure modes in mind:

- **Destructive commands.** An agent can `rm -rf` a project directory in the time it
  takes to read the confirmation prompt. Require confirmation for deletes, mass
  moves, and permission changes; never run in a fully-autonomous "do not ask" mode on
  shared systems.
- **Allocation exhaustion.** A retry loop that resubmits a failing GPU job can burn
  through an allocation in hours. Always set a `--time` limit, watch `slist`, and
  don't let an agent submit jobs unattended.
- **Credential and secret leakage.** Whatever an agent reads can end up in its
  context window, its logs, or a request to a model provider. Never point it at
  private keys, tokens, or `.env` files, and never paste credentials into a prompt.

## Containers offer limited protection — this is not Docker

A common assumption is that running an agent "in a container" sandboxes it. On RCAC
clusters that assumption is wrong in an important way:

!!! warning "Apptainer is not a sandbox for agents"

    RCAC uses **Apptainer** (not Docker) for containers, and RCAC's Apptainer
    configuration **automatically bind-mounts `/home`, `/depot`, and `/scratch`**
    into the container for convenience. Those mounts are **writable**, so an agent
    running inside a container can still edit — or delete — your real files on those
    filesystems. The most likely failure is not a container escape; it is an agent
    quietly *modifying files* on a mount you forgot was there.

    If you need stronger isolation, invoke Apptainer explicitly with the bind-mounts
    disabled, and still keep the permission guardrails in place. Do not rely on the
    container alone.

The harnesses' own OS-level sandboxes (Codex's `bubblewrap`, Gemini's Docker/Podman
mode, Claude Code's namespace isolation) are frequently **unavailable on shared login
nodes** as well. Treat the **permission and approval layer as your primary control**,
point writable work at `$RCAC_SCRATCH`, and deny `rm -rf`/`sudo` outright.

---

Back to [Agentic AI](index.md).
