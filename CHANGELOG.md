# Changelog

Notable changes to the Legal Skills client plugin. See `git log` for full history.

To update: in Claude Code run `/plugin marketplace update ai4law-legal-skills`
then `/plugin update legal-skills@ai4law-legal-skills` (or use the `/plugin` → Installed → Update menu).

## 0.3.0 — 2026-06-18
### Changed
- Standardized the MCP connector name `legal-skills-oauth` → **`legal-skills`**. In `/mcp` the connector now appears as `legal-skills`.

### Action required for existing users
- **Reconnect once.** Renaming the connector clears the saved OAuth login. After updating, run `/mcp`, select **`legal-skills`**, choose **Authenticate**, and sign in with your AI4LAW-registered email. One time per machine.

## 0.2.0
- Switched to the keyless OAuth connector (WorkOS AuthKit "Connect") as the connection method; retired the `/legal-skills-login` key command.
