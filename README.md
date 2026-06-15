# Legal Skills — client plugin (AI4LAW)

A **thin** Claude Code plugin that connects to the hosted AI4LAW Legal Skills MCP server.
It ships **no legal content** — every skill, playbook, knowledge doc and reference is served
from the central server based on your API key's entitlements, so updates propagate instantly
and nothing is stored locally.

This repository **is** the plugin (the canonical, client-installable home). The server lives
in a separate private repo; this one is safe to be public because access to actual content is
gated by your API key at the server, not by who can read this connector.

## What's inside
- `commands/legal-skills-login.md` — the **`/legal-skills-login`** slash command. You paste your
  API key once and it registers the hosted server for you, inline, in your user config — no
  terminal, no environment variables, same on Windows and macOS.
- `agents/legal-skill-selector.md` — a sub-agent that finds the right skill by browsing the
  catalog (`list_domains` → `list_skills`) and hands the main agent a short shortlist to load
  with `get_skill`, instead of dumping the whole catalog into context.
- `personalization.example.md` — optional local customization (stays on your machine).

The plugin no longer ships an `.mcp.json`: registering the server (with your personal key) is
what `/legal-skills-login` does, which avoids the fragile environment-variable setup the earlier
version relied on.

## Install (per lawyer / per machine)

1. **Get your API key** from AI4LAW. It looks like `lcsk_…` and is shown only once — store it
   safely (a password manager).

2. **Install the plugin** in Claude Code:
   ```text
   /plugin marketplace add ai4laws/legal-skills-plugin
   /plugin install legal-skills@ai4law-legal-skills
   ```

3. **Connect your account** — run the login command and paste your key when asked:
   ```text
   /legal-skills-login
   ```
   (If you prefer, you can pass it directly: `/legal-skills-login lcsk_xxxxxxxx...`.)
   If `/legal-skills-login` isn't recognized immediately after install, restart Claude Code once
   and run it again.

4. **Restart Claude Code** so the connection goes live (MCP servers load at startup).

5. **Verify it worked:** run `/mcp` — you should see **`legal-skills` connected**. Then ask, in
   plain language, *"List the legal domains available to me"* (or in Hebrew,
   *"אילו תחומי משפט זמינים לי?"*). A list of domains means you're connected. An authentication
   error means the key was wrong or inactive — re-run `/legal-skills-login` with the correct key,
   or contact AI4LAW.

6. *(optional)* `cp personalization.example.md personalization.md` and fill in firm/style
   preferences — they stay on your machine.

### Rotating or changing your key
Just run `/legal-skills-login` again with the new key and restart — it safely replaces the old
registration.

## Use
- Ask for any Israeli-legal task (Hebrew or English). The **legal-skill-selector** agent
  browses the catalog by domain and returns the best-matching skill IDs.
- The main agent loads one with `get_skill("<id>")` and follows its instructions, which name
  the exact `get_playbook` / `get_knowledge` / `get_reference` / `download_file` calls for the
  supporting material.
- You only ever see skills your package entitles you to.

## A note on the key in the transcript
Because you paste the key into the chat, it appears in that conversation's transcript. The key is
personal, read-only and revocable, so this is acceptable as a stopgap — but it's also why AI4LAW
is moving to a keyless, browser-based "Connect" (OAuth) login, after which this command is retired.
Keep your key private and don't share the transcript.

## Privacy
The server is **read-only** content delivery. Your matter/client data never leaves your
machine — keep it in local working files and in `personalization.md`, not on the server.
