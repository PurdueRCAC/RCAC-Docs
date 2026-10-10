<!-- This directory is generated. Do not hand-edit. -->
# Generated: agentic-AI per-cluster context

Everything under `docs/snippets/agentic-ai/<cluster>/agents.d/` is **generated** by
`tools/generate_agent_context.py` from the per-cluster data model in
`tools/agent_context/clusters/<cluster>.yml` and the shared templates in
`tools/agent_context/templates/agents.d/`.

**Do not edit the generated files** (the five topic files and the assembled `AGENTS.md`)
directly; your changes will be overwritten on the next run. Edit the cluster YAML (facts) or
a template (shared prose) and regenerate:

```bash
.venv/bin/python tools/generate_agent_context.py
```

Each generated file carries an inline `<!-- ... -->` marker naming the generator.

The generator deep-merges each cluster YAML onto `DEFAULTS` in the script (the campus-cluster
commands, scratch variable, support contact, container runtime). A cluster YAML overrides
only what differs, and a `null` switches that line off, so the context never names a command
the cluster does not have.

To add a cluster: create `tools/agent_context/clusters/<cluster>.yml`, regenerate, add a
`using_ai_agents.md` chapter under `docs/userguides/<cluster>/`, wire it into `mkdocs.yml`
`nav:`, list it in the cluster's `index.md`, and regenerate breadcrumbs
(`.venv/bin/python tools/generate_breadcrumbs.py`). Encode only facts the cluster's own user
guide confirms; leave uncertain values `null` (the templates tell the agent to check them
live) rather than guessing.
