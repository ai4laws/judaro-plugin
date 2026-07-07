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
- `skills/judaro-feedback/SKILL.md` — the `/judaro-feedback` skill (beta feedback; also model-invocable).
  Named `judaro-feedback` (not `feedback`) so its bare command doesn't collide with Claude's built-in
  `/feedback` and stays visible in the `/` menu. Prefers the server's pre-filled `feedback.report_url`,
  else the static Google Form URL baked in here (public-safe — the form link is non-secret).
- `personalization.example.md` — optional local customization (copy to `personalization.md`).

## Invariants
- **This repo is PUBLIC and content-free.** It must never receive server internals, legal content, or
  secrets — entitlements are enforced at the server by your authenticated account (OAuth login or an
  `lcsk_` key), not by who can read this connector. That is what makes a public connector safe.
- **Matter/client data and `personalization.md` stay local** (`.gitignore` enforces) — never commit
  them, and nothing matter-related goes to the server.

## Targeting a different server
The `.mcp.json` `url` is a **literal** production URL, **not** `${LSMCP_SERVER_URL:-…}`: the claude.ai /
desktop **connector** UI pastes the `url` verbatim and does not expand `${VAR}`, so an env-var form
yields an invalid URL and breaks the org *"Add connector to the team"* step. A literal URL is the only
form that works everywhere.

To target dev/staging **in Claude Code (CLI)**, drop a project-scoped `.mcp.json` defining a `judaro`
server with the alternate `url`: project scope outranks plugin-provided servers, so it replaces the
bundled one for that project (claude.ai/desktop connectors are lowest precedence and don't affect the
CLI). This does **not** change the desktop/web **connector** — that URL is set in claude.ai org
settings. Internal dev/staging URLs + a ready snippet live in `CLAUDE.local.md` (local, not public).

## Cross-repo
The server is the private repo `ai4laws/legal-skills-mcp` — authoritative for content, architecture,
and **decisions (its `docs/adr/`)**. Record durable, shared facts there, not here.
