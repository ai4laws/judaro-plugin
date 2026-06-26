# Judaro — Legal Skills client plugin

A **thin** Claude Code plugin that connects to the hosted AI4LAW Legal Skills MCP server. It ships
**no legal content** — every skill, playbook, knowledge doc and reference is served from the central
server based on your account's entitlements. **This repo is the plugin's canonical home** (not the
server repo). Install/use detail: `README.md`.

## Layout
- `.mcp.json` — registers the hosted server (HTTP). Connecting is **keyless** (browser OAuth
  "Connect"; no key to paste). Default URL: `${LSMCP_SERVER_URL:-https://mcp.judaro.com/mcp}`.
- `.claude-plugin/{plugin.json,marketplace.json}` — plugin + marketplace manifests.
- `agents/legal-skill-selector.md` — sub-agent that browses the catalog (`list_domains` →
  `list_skills`) and returns a shortlist for the main agent to load with `get_skill`.
- `personalization.example.md` — optional local customization (copy to `personalization.md`).

## Invariants
- **This repo is PUBLIC and content-free.** It must never receive server internals, legal content, or
  secrets — entitlements are enforced at the server by your authenticated account (OAuth login or an
  `lcsk_` key), not by who can read this connector. That is what makes a public connector safe.
- **Matter/client data and `personalization.md` stay local** (`.gitignore` enforces) — never commit
  them, and nothing matter-related goes to the server.

## Targeting a different server
The connector reads `LSMCP_SERVER_URL`, falling back to production. Override it (shell env, project
`.env`, or `~/.claude/settings.json` `env`) to point at dev (`…contaboserver.net:8443/mcp`) or
staging for a session — see README's "Advanced: targeting a different server". Claude Code expands
`${VAR}` / `${VAR:-default}` in the `.mcp.json` **`url`** field (expansion works there; the known
substitution bug is headers-only — CC #51581 / #6204).

## Cross-repo
The server is the private repo `ai4laws/legal-skills-mcp` — authoritative for content, architecture,
and **decisions (its `docs/adr/`)**. Record durable, shared facts there, not here.
