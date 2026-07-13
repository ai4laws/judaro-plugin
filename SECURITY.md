# Security Policy

Judaro is a thin Claude Code plugin that connects to the hosted AI4LAW Legal Skills MCP service. This one policy covers both surfaces:

- **The plugin** (this repository): the MCP connector configuration (`.mcp.json`), agents, skills, hooks, and scripts.
- **The hosted service** it connects to: `mcp.judaro.com` and its browser (OAuth) sign-in flow.

To help you scope: the plugin stores no legal content or client data locally, and the hosted service is read-only content delivery and stores no client or matter data — signing in shares only your verified email (used to look up your entitlements).

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues or discussions.**

Report privately through either channel:

- **Email (preferred):** [lapidot@ai4law.co.il](mailto:lapidot@ai4law.co.il)
- **GitHub:** use **"Report a vulnerability"** under this repository's **Security** tab (private vulnerability reporting).

Please include:

- Steps to reproduce the issue
- The affected component — the plugin (this repository) or the hosted service (`mcp.judaro.com` / sign-in flow)
- The impact you believe it has

## What to expect

- We will acknowledge your report within **3 business days** (business days are **Sunday–Thursday, Israel time**).
- We are a small team, so we can't promise fixed triage or fix timelines. We prioritize by severity, and we will keep you informed as we work on the issue.

## Testing ground rules

- Do not test against the production service using real client or matter data.
- Only test with accounts you own or are explicitly authorized to use.
- No denial-of-service testing, spam, or social engineering.
- If you gain access to data that isn't yours, stop immediately and report it — do not read further, copy, or share it.

## Safe harbor

AI4LAW and its owner will not pursue legal action against researchers who act in good faith and within this policy. In return, we ask for coordinated disclosure: give us reasonable time to remediate before publicly disclosing any details.

This safe harbor covers only systems AI4LAW operates. Third-party services used in the flow (for example, the hosted sign-in provider) have their own policies — do not test them beyond normal use.

## Supported versions

Only the **latest released version** of the plugin is supported. The plugin is a thin, evergreen client — please update to the latest version before reporting a plugin issue. The hosted service is updated continuously server-side and requires no action on your part.
