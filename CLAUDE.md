@AGENTS.md

## Task Board
Board: 1
Owner: ai4laws
Project: Legal Skills MCP

## Claude Code
- **Board.** The org board above uses an `Owner` field (Roy / Lapidot / Shared); act only on your
  lane and don't flip another's status. Manage it with the `/projects` skill.
- **Per-person local context.** `@~/lsmcp-local.md` (imported below) — each machine keeps its own.
- **Memory is local scratch only** — machine/person-specific (toolchain quirks, file/key *locations*
  not values, pairing state). Durable shared facts go in the **server** repo
  `ai4laws/legal-skills-mcp`: current-state in its `docs/`, decisions in its `docs/adr/`. This repo
  is public and content-free, so nothing durable or sensitive lives here.
- **Skills.** Invoke `/prompt-engineering` before writing CLAUDE.md / AGENTS.md / system-prompts; use
  `/projects` for board operations.

@~/lsmcp-local.md
