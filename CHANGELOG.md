# Changelog

Notable changes to the Legal Skills client plugin. See `git log` for full history.

To update: in Claude Code run `/plugin marketplace update ai4law-legal-skills`
then `/plugin update legal-skills@ai4law-legal-skills` (or use the `/plugin` → Installed → Update menu).

## Unreleased
### Changed
- The connector target server is now overridable per session via the `LSMCP_SERVER_URL`
  environment variable, with the production server as the default
  (`"url": "${LSMCP_SERVER_URL:-https://vmi3071939.contaboserver.net/mcp}"`). Installed
  users who set nothing are unaffected — they keep hitting the same production server.
  See README → *Advanced: targeting a different server*. No version bump: this changes
  no default, so installed plugins are not prompted to update.

### Added
- Repo hardening (mirrors the server repo): `.github/workflows/ci.yml` (validates the
  connector JSON config + runs a gitleaks scan on PRs and pushes to `main`),
  `.gitleaks.toml` (default rules plus custom `lcsk_` and `sk_(test|live)_` rules for this
  public repo), and `.github/CODEOWNERS` (connector config + `.github/` owned by the
  maintainer).
