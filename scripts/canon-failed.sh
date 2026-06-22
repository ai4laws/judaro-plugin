#!/usr/bin/env bash
# AI4LAW legal-canon guardrail — PostToolUseFailure hook.
#
# Fires when ANY legal-skills MCP tool call FAILS — the server errored OR is unreachable
# (connection refused / down). This is the one case the server itself cannot speak to (it
# is not reachable to return a rich error), so the client injects a grounding reminder.
#
# Deliberately pure bash with a STATIC message: no python3/jq (portable to Windows
# Git-Bash), no stdin parsing, nothing to escape. Drains stdin, prints one JSON object on
# stdout, exits 0. additionalContext is surfaced to the model on its next turn.
cat >/dev/null 2>&1 || true   # drain & discard the event JSON on stdin
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUseFailure","additionalContext":"[AI4LAW canon] A legal-skills tool call FAILED — the firm-approved legal canon is unavailable for this request (the server errored or is unreachable). Do NOT answer Israeli-legal questions from your own training knowledge and do NOT fabricate citations, statute or regulation numbers, court-rule references, checklists, deadlines, or templates. Tell the user plainly that the legal canon is currently unreachable (an outage or an auth/connection problem) and stop — or retry the tool. Do not work around it from memory."}}'
exit 0
