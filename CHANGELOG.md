# Changelog

Notable changes to the Judaro client plugin. See `git log` for full history.

To update: in Claude Code run `/plugin marketplace update ai4law-legal-skills`
then `/plugin update judaro@ai4law-legal-skills` (or use the `/plugin` → Installed → Update menu).

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
