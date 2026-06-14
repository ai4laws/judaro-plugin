# Legal Skills — client plugin (AI4LAW)

A **thin** Claude Code plugin that connects to the hosted AI4LAW Legal Skills MCP server.
It ships **no legal content** — every skill, playbook, knowledge doc and reference is served
from the central server based on your API key's entitlements, so updates propagate instantly
and nothing is stored locally.

This repository **is** the plugin (the canonical, client-installable home). The server lives
in a separate private repo; this one is safe to be public because access to actual content is
gated by your API key at the server, not by who can read this connector.

## What's inside
- `.mcp.json` — registers the remote MCP server (`legal-skills`) over Streamable HTTP with
  `Authorization: Bearer ${LEGAL_CANON_API_KEY}`.
- `agents/legal-skill-selector.md` — a sub-agent that finds the right skill by browsing the
  catalog (`list_domains` → `list_skills`) and hands the main agent a short shortlist to load
  with `get_skill`, instead of dumping the whole catalog into context.
- `personalization.example.md` — optional local customization (stays on your machine).

## Install (per lawyer / per machine)

1. **Get your API key** from AI4LAW. It looks like `lcsk_…` and is shown only once — store it
   safely (a password manager).

2. **Set the key as an environment variable** so Claude Code can read it at startup. The most
   reliable way is to add it to your shell profile, then open a **new** terminal:
   ```bash
   # macOS / Linux (zsh — the macOS default): append to ~/.zshrc
   echo 'export LEGAL_CANON_API_KEY="lcsk_xxxxxxxx..."' >> ~/.zshrc
   # then open a new terminal, or run: source ~/.zshrc
   ```
   On Windows (PowerShell): `setx LEGAL_CANON_API_KEY "lcsk_xxxxxxxx..."`, then open a new
   terminal.

3. **Install the plugin** in Claude Code:
   ```text
   /plugin marketplace add ai4laws/legal-skills-plugin
   /plugin install legal-skills@ai4law-legal-skills
   ```

4. **Restart Claude Code** so the MCP connector + selector agent load.

5. *(optional)* `cp personalization.example.md personalization.md` and fill in firm/style
   preferences — they stay on your machine.

## Use
- Ask for any Israeli-legal task (Hebrew or English). The **legal-skill-selector** agent
  browses the catalog by domain and returns the best-matching skill IDs.
- The main agent loads one with `get_skill("<id>")` and follows its instructions, which name
  the exact `get_playbook` / `get_knowledge` / `get_reference` / `download_file` calls for the
  supporting material.
- You only ever see skills your package entitles you to.

## Privacy
The server is **read-only** content delivery. Your matter/client data never leaves your
machine — keep it in local working files and in `personalization.md`, not on the server.
