<!-- This directory is generated. Do not hand-edit. -->
# Generated: agentic-AI per-cluster context

Everything under `docs/snippets/agentic-ai/<cluster>/` is **generated** by
`tools/generate_agent_context.py` from the per-cluster data model in
`tools/agent_context/clusters/<cluster>.yml` and the shared templates in
`tools/agent_context/templates/`.

**Do not edit the generated files** — the `agents.d/*.md`, the assembled `AGENTS.md`, and
the `claude/`, `codex/`, `gemini/`, `opencode/` settings — directly; your changes will be
overwritten on the next run. Edit the cluster YAML (facts) or a template (shared prose)
and regenerate:

```bash
.venv/bin/python tools/generate_agent_context.py
```

The Markdown and TOML files each carry an inline `<!-- ... -->` / `# ...` marker naming
the generator. JSON has no comment syntax, so this file is the marker for the `*.json`
settings.

To add a cluster: create `tools/agent_context/clusters/<cluster>.yml`, regenerate, add a
`using_ai_agents.md` chapter under `docs/userguides/<cluster>/`, and wire it into
`mkdocs.yml` `nav:`. Encode only facts the cluster's own user guide confirms; leave
uncertain values `null` (the templates emit a "verify live" note) rather than guessing.
