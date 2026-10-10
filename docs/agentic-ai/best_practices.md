---
tags:
  - Agentic AI
authors:
  - glentner
---

# Best Practices & Limitations

Agents can draft submission scripts, fix build errors, and automate routine workflow steps.
They also make mistakes that look correct. This page lists practices that reduce those
mistakes and limit their cost.

## Know when you're doing research versus operations

Separate the two kinds of work you might ask an agent to do:

- **Research:** writing analysis code, exploring a dataset, prototyping a model, drafting and
  debugging a submission script. Mistakes here are usually cheap and show up quickly: the code
  doesn't compile, the plot looks wrong, the job fails fast. Agents work well here, and you
  can let them iterate.
- **Operations:** moving or deleting data, managing quota, cancelling jobs, changing
  permissions, installing software, editing shared files. Mistakes here are expensive and
  sometimes irreversible: a deleted directory, an exhausted allocation, a broken shared
  environment. Review each command before it runs, and keep destructive operations behind an
  explicit confirmation.

Give the agent more freedom for research and review every command for operations. Set your
harness's permission settings to match; each harness documents its own (see
[Harness Settings](shared_context/settings.md) for links).

## Give the agent specific context

Specific requests get better results than vague ones:

- Name the cluster, partition, account and software versions you intend to use, rather than
  letting the agent guess.
- Connect your agent to the cluster's context files (see
  [Load the context in your harness](shared_context/index.md#load-the-context-in-your-harness)). They tell it the scheduler, module system and
  partitions, so it does not have to guess them.
- Give the agent the error message, the job ID and the exact file, not a paraphrase.

Context supplied up front prevents a common failure: a well-formatted answer written for a
system RCAC does not run.

## Check the output

- **Ask for the reasoning.** When an agent proposes an `#SBATCH` line or a `module load`,
  ask it to explain the choice. The explanation often exposes a wrong assumption.
- **Check before you run.** Read a generated script before you submit it. Confirm the
  partition exists, the account is one you can charge, and the paths are real. An agent states
  a nonexistent module or an invalid partition without any sign of doubt.
- **Be careful outside your expertise.** You are least able to catch an error where you know
  the least. If you can't yet evaluate the output, treat it as a draft to learn from, not an
  answer to run.

## Let the agent check the cluster first

Let the agent check the cluster's state before it acts. Allow it to run these read-only
commands without asking:

- `myquota`: home and scratch usage and limits.
- `slist`: the accounts you can charge and their balances (`mybalance` on Anvil).
- `sfeatures`: the node and GPU features available.
- `module avail` / `module list`: what software exists and what is loaded.

You can allow these commands in your harness's permission settings so the agent runs them
without stopping to ask. An agent that checks your accounts before writing `--account=` will
not invent an account name, and one that runs `module avail` before a `module load` will not
invent a version.

## Understand the blast radius

Agents make ordinary mistakes happen faster. Cgroups, quotas, health checks, root-squash and per-user permissions still
apply to an agent acting as you. Keep these failure modes in mind:

- **Destructive commands.** An agent can run `rm -rf` on a project directory. Require
  confirmation for deletes, mass moves and permission changes, and do not run an agent in a
  mode that skips all approvals on shared systems.
- **Allocation exhaustion.** A retry loop that resubmits a failing GPU job can use up an
  allocation in hours. Always set a `--time` limit, watch your balance, and don't let an agent
  submit jobs unattended.
- **Credential and secret leakage.** Whatever an agent reads can end up in its context window,
  its logs, or a request to a model provider. Never point it at private keys, tokens or `.env`
  files, and never paste credentials into a prompt.

## Containers do not isolate an agent

Running an agent in a container does not sandbox it on RCAC clusters.

!!! warning "Apptainer is not a sandbox for agents"

    RCAC clusters use Apptainer, not Docker. RCAC's Apptainer configuration bind-mounts your
    home directory, scratch, and (where the cluster has them) Depot or project space into the
    container. Those mounts are writable, so an agent inside a container can still change or
    delete your real files. The likely failure is not a container escape but an agent changing
    files on a mount you forgot was there.

    If you need stronger isolation, run Apptainer with the bind mounts disabled, and keep your
    harness's approval settings on. Do not rely on the container alone.

The harnesses' own OS-level sandboxes (Codex's `bubblewrap`, Gemini's Docker or Podman mode,
Claude Code's namespace isolation) are often unavailable on shared login nodes. Treat your
harness's permission and approval settings as the main control, point writable work at your
scratch directory, and block `rm -rf` and `sudo`.

---

Back to [Agentic AI](index.md).
