# Changelog

Notable changes to the Judaro client plugin. See `git log` for full history.

To update: in Claude Code run `/plugin marketplace update ai4law-legal-skills`
then `/plugin update judaro@ai4law-legal-skills` (or use the `/plugin` → Installed → Update menu).

## 0.5.0 — feedback command rename
### Changed
- **Renamed the feedback command `feedback` → `judaro-feedback`** — invoke **`/judaro-feedback`**. The
  old bare name collided with Claude's built-in `/feedback`, so on Claude Desktop the plugin command
  never appeared in the `/` autocomplete menu (it only worked if you typed the namespaced
  `/judaro:feedback`). The new name is collision-free and shows in the menu. Model-invocation and the
  form itself are unchanged.

## 0.4.0 — beta feedback
### Added
- **`/judaro:feedback` skill** (`skills/feedback/`) — a one-step, Hebrew-facing way to report a
  problem or send feedback. It is also model-invocable: when you say an answer was wrong/unexpected
  or ask to report something, Claude offers to summarize the issue and hand you a pre-filled link
  (preferring the server's context-tagged `feedback.report_url` when present). Nothing is ever sent
  automatically, and matter/client details are never included unless you add them. README →
  *Feedback (beta)*.

## 0.3.0 — production cutover (Judaro)
### Changed
- **Renamed to Judaro.** The plugin is now `judaro` and the MCP connector key is `judaro`
  (was `legal-skills` / `legal-skills-oauth`). **This requires a one-time re-Connect:** after
  updating, run `/mcp`, select **`judaro`**, and authenticate once.
- **Repointed to the production server `https://mcp.judaro.com/mcp`** (was the interim Contabo
  host `vmi3071939`). Still overridable per session via the `LSMCP_SERVER_URL` environment
  variable (`"url": "${LSMCP_SERVER_URL:-https://mcp.judaro.com/mcp}"`); unset it to use the
  production default. See README → *Advanced: targeting a different server*.

### Added
- Repo hardening (mirrors the server repo): `.github/workflows/ci.yml` (validates the
  connector JSON config + runs a gitleaks scan on PRs and pushes to `main`),
  `.gitleaks.toml` (default rules plus custom `lcsk_` and `sk_(test|live)_` rules for this
  public repo), and `.github/CODEOWNERS` (connector config + `.github/` owned by the
  maintainer).
