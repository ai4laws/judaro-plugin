# Legal Skills — client plugin (AI4LAW)

A **thin** Claude Code plugin that connects to the hosted AI4LAW Legal Skills MCP server.
It ships **no legal content** — every skill, playbook, knowledge doc and reference is served
from the central server based on your account's entitlements, so updates propagate instantly
and nothing is stored locally.

This repository **is** the plugin (the canonical, client-installable home). The server lives
in a separate private repo; this one is safe to be public because access to actual content is
gated at the server by your authenticated account, not by who can read this connector.

## What's inside
- `.mcp.json` — registers the hosted Legal Skills server (HTTP). Connecting is **keyless**:
  the first time you use it, Claude opens a browser **"Connect" (OAuth)** page where you sign
  in — there is no API key to paste or store.
- `agents/legal-skill-selector.md` — a sub-agent that finds the right skill by browsing the
  catalog (`list_domains` → `list_skills`) and hands the main agent a short shortlist to load
  with `get_skill`, instead of dumping the whole catalog into context.
- `personalization.example.md` — optional local customization (stays on your machine).

## Install (per lawyer / per machine)

1. **Ask AI4LAW to provision your account.** Access is by invitation — AI4LAW registers your
   email and the packages (legal domains) you're entitled to. You'll sign in with that same email.

2. **Install the plugin** in Claude Code:
   ```text
   /plugin marketplace add ai4laws/legal-skills-plugin
   /plugin install legal-skills@ai4law-legal-skills
   ```

3. **Restart Claude Code** so the connector loads (approve the `legal-skills-oauth` server if prompted).

4. **Connect — sign in once.** Run `/mcp`, select **`legal-skills-oauth`**, and choose
   **Authenticate**. A browser window opens — sign in with your AI4LAW-registered email and
   approve access. (Claude may also offer to connect automatically the first time you ask a
   legal question.) The login is remembered, so you only do this once per machine.

5. **Verify it worked:** ask, in plain language, *"List the legal domains available to me"*
   (or in Hebrew, *"אילו תחומי משפט זמינים לי?"*). A list of domains means you're connected.
   A "not provisioned" or authorization error usually means your account isn't set up yet, or
   you signed in with a different email than the one AI4LAW registered — contact AI4LAW.

6. *(optional)* `cp personalization.example.md personalization.md` and fill in firm/style
   preferences — they stay on your machine.

## Use
- Ask for any Israeli-legal task (Hebrew or English). The **legal-skill-selector** agent
  browses the catalog by domain and returns the best-matching skill IDs.
- The main agent loads one with `get_skill("<id>")` and follows its instructions, which name
  the exact `get_playbook` / `get_knowledge` / `get_reference` / `download_file` calls for the
  supporting material.
- You only ever see skills your account is entitled to.

## Privacy
The server is **read-only** content delivery. Your matter/client data never leaves your
machine — keep it in local working files and in `personalization.md`, not on the server.
Signing in shares only your verified email (used to look up your entitlements); no matter
data is ever sent to the server.

## Advanced: targeting a different server (developers only)

> **Lawyers can ignore this section.** If you set nothing, the plugin connects to the
> AI4LAW **production** server automatically — the default URL is baked into `.mcp.json`.

The connector reads its target from the `LSMCP_SERVER_URL` environment variable, falling
back to the production server when it is unset:

```jsonc
// .mcp.json
"url": "${LSMCP_SERVER_URL:-https://vmi3071939.contaboserver.net/mcp}"
```

So `LSMCP_SERVER_URL` lets a developer point the *same* installed plugin at a staging or
dev server for a session, without editing any tracked file and without affecting other
users. Set it in any one of these places (Claude Code expands `${VAR}` / `${VAR:-default}`
in the `.mcp.json` `url` field at startup):

- **Shell, per session** — export it before launching Claude Code:
  ```bash
  export LSMCP_SERVER_URL="https://staging-mcp.judaro.com/mcp"
  claude
  ```
- **Project `.env`** — if you run Claude Code from a project whose env is loaded, add:
  ```dotenv
  LSMCP_SERVER_URL=https://staging-mcp.judaro.com/mcp
  ```
- **`~/.claude/settings.json`** `env` block — persistent across sessions for your account:
  ```jsonc
  {
    "env": {
      "LSMCP_SERVER_URL": "https://staging-mcp.judaro.com/mcp"
    }
  }
  ```

Unset it (or remove the override) to return to the production default. Restart Claude Code
after changing the value so the connector re-reads it.

**Fallbacks** if `${VAR}` expansion is unavailable on your Claude Code version: use a
**project-scoped `.mcp.json`** that hard-codes the alternate `url` (it shadows the bundled
one for that project), or hard-edit the `url` locally for a throwaway test. Do **not** commit
either change.
