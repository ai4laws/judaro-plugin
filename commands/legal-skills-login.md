---
description: Connect this Claude to your AI4LAW Legal Skills account by pasting your API key.
argument-hint: "[lcsk_your_key]"
allowed-tools: Bash(claude mcp add:*), Bash(claude mcp remove:*), Bash(claude mcp get:*), Bash(claude mcp list:*), Bash(echo:*), Read
---

You are running the **AI4LAW Legal Skills login** command. Your job is to register the
hosted Legal Skills MCP server for **this user** with their personal API key, inline, so it
works on every restart regardless of how the app was launched (Dock / Start menu / terminal).

Communicate with the user in **their language** (Hebrew or English — match what they write).
Be warm and brief; they are a lawyer, not an engineer. Do not show internal reasoning.

## Constants (do not change)
- Server name: `legal-skills`
- Server URL: `https://vmi3071939.contaboserver.net/mcp`
- API key prefix: `lcsk_`

## Provided argument
The user may have passed their key as an argument: `$ARGUMENTS`

## Steps

1. **Get the key.**
   - If `$ARGUMENTS` already contains a string starting with `lcsk_`, use it as `KEY`.
   - Otherwise, ask the user to paste the API key they received from AI4LAW (it starts with
     `lcsk_` and was shown only once). Wait for their reply; treat their pasted value as `KEY`.
   - Validate that `KEY` starts with `lcsk_` and has no spaces. If it doesn't look right, say so
     plainly and ask them to paste it again. Do **not** proceed with a malformed key.

2. **Register the server (primary path — uses the official Claude CLI, which safely MERGES
   into the user config and never clobbers other settings).**
   First make it idempotent (so re-running or rotating a key works) by removing any existing
   user-scope entry, ignoring errors if none exists:
   ```bash
   claude mcp remove legal-skills --scope user 2>/dev/null || true
   ```
   Then add it (substitute the real `KEY`):
   ```bash
   claude mcp add legal-skills "https://vmi3071939.contaboserver.net/mcp" \
     --transport http --scope user \
     --header "Authorization: Bearer KEY"
   ```
   On **Windows**, if the multi-line form fails, run it as a single line.

3. **If the `claude` command is not found** (rare — e.g. not on PATH in this environment),
   fall back to a careful manual edit, and ask the user for permission first since it touches
   their config file:
   - The file is `~/.claude.json` on macOS/Linux, or `%USERPROFILE%\.claude.json` on Windows.
   - **Read** it, then **merge** (never overwrite) a `legal-skills` entry under the top-level
     `"mcpServers"` object, preserving every other key in the file:
     ```json
     "legal-skills": {
       "type": "http",
       "url": "https://vmi3071939.contaboserver.net/mcp",
       "headers": { "Authorization": "Bearer lcsk_…the user's key…" }
     }
     ```
   - Before writing, make a backup copy (`~/.claude.json.bak`). After writing, confirm the file
     is still valid JSON. If anything looks risky, stop and tell the user rather than guess.

4. **Verify the registration was written** (does not require a restart):
   ```bash
   claude mcp get legal-skills --scope user
   ```
   Confirm it shows transport `http`, the correct URL, and that an `Authorization` header is set
   (the value is shown redacted — that's expected and good). Do not echo the key back to the user.

5. **Tell the user what to do next**, clearly:
   - **Restart Claude** (fully quit and reopen the app). MCP servers are loaded at startup, so the
     connection won't be live until they restart.
   - After restart, they can run `/mcp` and should see **`legal-skills` connected**.
   - To confirm end-to-end, ask Claude in plain language: *"List the legal domains available to
     me"* (or in Hebrew: *"אילו תחומי משפט זמינים לי?"*). A list of domains = success. An auth
     error = the key was wrong or inactive; have them re-run `/legal-skills-login` with the
     correct key, or contact AI4LAW.

## Notes to convey honestly (briefly)
- A **restart is required** for the connection to go live.
- The pasted key appears in this chat transcript. That's acceptable because the key is personal,
  read-only, and revocable — but it's also why AI4LAW is moving to a keyless browser "Connect"
  (OAuth) login later. Keep the key private and don't share the transcript.
