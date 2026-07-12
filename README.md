<p align="center">
  <img src="assets/judaro-logo.png" alt="Judaro" width="88" height="88">
</p>

# Judaro — Legal Skills client plugin (AI4LAW)

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
- `skills/judaro-feedback/` — the `/judaro-feedback` skill: a one-step way to report a problem or send
  feedback (see **Feedback** below).
- `personalization.example.md` — optional local customization (stays on your machine).

## Install — individual user (default)

1. **Ask AI4LAW to provision your account.** Access is by invitation — AI4LAW registers your
   email and the packages (legal domains) you're entitled to. You'll sign in with that same email.

2. **Install the plugin** in Claude Code:
   ```text
   /plugin marketplace add ai4laws/legal-skills-plugin
   /plugin install judaro@ai4law-legal-skills
   ```

3. **Restart Claude Code** so the connector loads (approve the `judaro` server if prompted).

4. **Connect — sign in once.** Run `/mcp`, select **`judaro`**, and choose
   **Authenticate**. A browser window opens — sign in with your AI4LAW-registered email and
   approve access. (Claude may also offer to connect automatically the first time you ask a
   legal question.) The login is remembered, so you only do this once per machine.

5. **Verify it worked:** ask, in plain language, *"List the legal domains available to me"*
   (or in Hebrew, *"אילו תחומי משפט זמינים לי?"*). A list of domains means you're connected.
   A "not provisioned" or authorization error usually means your account isn't set up yet, or
   you signed in with a different email than the one AI4LAW registered — contact AI4LAW.

6. *(optional)* `cp personalization.example.md personalization.md` and fill in firm/style
   preferences — they stay on your machine.

## Install — for an organization

> For a single user, use **Install — individual user** above. This section is for admins
> deploying Judaro across a whole organization.

Team and Enterprise admins distribute the plugin from the **Claude admin console** (organization
settings → plugins) — not with slash commands. When you add a marketplace via **GitHub syncing**,
Claude requires the repo to be **private/internal**. Since this repo is public, create a **private
copy** of it and point the admin console at that.

1. **Make a private copy.** [Duplicate this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository)
   into a private repo your organization owns. A mirror push does it:
   ```bash
   git clone --bare https://github.com/ai4laws/judaro-plugin.git
   cd judaro-plugin.git
   git push --mirror https://github.com/YOUR-ORG/YOUR-PRIVATE-COPY.git
   ```
   Then make one edit in your copy: org GitHub-sync rejects a relative-path plugin source, so set the
   plugin `source` in `.claude-plugin/marketplace.json` to an **object** pointing at your copy:
   ```json
   "source": { "source": "github", "repo": "YOUR-ORG/YOUR-PRIVATE-COPY", "ref": "main" }
   ```
2. **Add it as a marketplace.** In the admin console, add a custom marketplace via **GitHub sync**
   pointing at `YOUR-ORG/YOUR-PRIVATE-COPY`, then choose how the `judaro` plugin rolls out —
   *Installed by default*, *Available for install*, *Not available*, or *Required* (Enterprise).
   See [Manage plugins for your organization](https://support.claude.com/en/articles/13837433-manage-plugins-for-your-organization).
3. **Enable the connector for the team.** Installing the plugin does **not** activate its MCP
   connector. In **Organization settings → Connectors**, enable the Judaro connector (*"Add connector
   to the team"*) — an **Owner / Primary-Owner-only** action that makes it **available org-wide**.
   Each member still signs in individually (steps 4–5 above) before using it. See
   [Authorize MCP connectors for your organization](https://support.claude.com/en/articles/15537633-authorize-mcp-connectors-for-your-entire-organization).
4. **Stay current.** This connector changes rarely; to pull updates, sync your private copy from this
   public repo, then re-sync in the admin console:
   ```bash
   git remote add upstream https://github.com/ai4laws/judaro-plugin.git   # one-time
   git fetch upstream && git merge upstream/main && git push origin main
   ```

Entitlements are unchanged: each user signs in with their AI4LAW email and sees only what their
account is entitled to.

**Use the plugin, not a bare connector.** You *could* add `https://mcp.judaro.com/mcp` as a
standalone custom connector, but installing the **plugin** is the recommended path: it bundles the
connector together with the **legal-skill-selector** sub-agent and config, set up automatically and
versioned together. A standalone connector exposes only the raw MCP tools, without the selector agent.

## Use
- Ask for any Israeli-legal task (Hebrew or English). The **legal-skill-selector** agent
  browses the catalog by domain and returns the best-matching skill IDs.
- The main agent loads one with `get_skill("<id>")` and follows its instructions, which name
  the exact `get_playbook` / `get_knowledge` / `get_reference` / `download_file` calls for the
  supporting material.
- You only ever see skills your account is entitled to.

## Feedback (beta)
Judaro is in **beta** — please tell us whenever a result is wrong, outdated, missing, or just not
what you expected. It takes a moment and directly improves what you get.
- Run **`/judaro-feedback`** any time, or just say (in Hebrew or English) that an answer was wrong
  or that you want to report something — Claude will summarize the issue with you and hand you a
  **pre-filled** link to a short form: your approved summary, the skill involved and your
  registered email are already filled in, so you just review, adjust, and send.
- The server also reminds you of this when you load a skill or hit an access error, so the option
  is always at hand without nagging.
- **Privacy:** feedback never includes your client/matter details unless you explicitly add them,
  and nothing is sent automatically — you always review and submit the form yourself.

## Privacy
The server is **read-only** content delivery. Your matter/client data never leaves your
machine — keep it in local working files and in `personalization.md`, not on the server.
Signing in shares only your verified email (used to look up your entitlements); no matter
data is ever sent to the server.
