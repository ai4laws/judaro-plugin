#!/usr/bin/env bash
# AI4LAW legal-canon guardrail — PostToolUseFailure hook.
#
# Fires ONLY when a legal-skills MCP tool call failed because the Judaro server could not
# be reached (connection error / timeout) or rejected the account's authorization
# (401/403/unauthorized). Those are the cases the server cannot speak to in-band, so the
# client injects a grounding reminder. Ordinary tool errors from a healthy server —
# `forbidden:` entitlements, `not found:`, `wrong tool:`, capability rejections — already
# carry their own grounding text in the error string, so this hook stays silent for them
# (it used to fire on every failure, drowning those richer messages in a generic banner).
#
# Deliberately pure bash: no python3/jq (portable to Windows Git-Bash). Stdin is read only
# to classify the event's `error` text; the printed messages are STATIC (nothing dynamic
# is interpolated into the JSON, so nothing needs escaping). Prints one JSON object on
# stdout — or nothing — and always exits 0. additionalContext is surfaced to the model on
# its next turn.
input=$(cat 2>/dev/null) || input=""

# The failure text lives in the event's `error` field. If the field is missing (schema
# drift), classify against the whole event instead — a real outage must never be missed.
err="$input"
err_re='"error"[[:space:]]*:[[:space:]]*"(([^"\]|\\.)*)"'
if [[ $input =~ $err_re ]]; then
  err="${BASH_REMATCH[1]}"
fi

# Auth first (an HTTP 401/403 often also mentions the connection). Deliberately NOT
# matched: bare "forbidden" (the server's entitlement error starts `forbidden:`) and bare
# "token"/"expired" (capability rejections say `capability expired` / `capability.token`)
# — those come from a healthy server and explain themselves.
auth_re='unauthorized|authenticat|authorization|oauth|invalid[ _-]?(api[ _-]?)?key|(^|[^0-9])40[13]([^0-9]|$)'
transport_re='timed?[ -]?out|unreachable|econn|enotfound|eai_again|epipe|ehostunreach|enetunreach|connect|network|socket|fetch failed|dns|tls|ssl|gateway|service unavailable|server disconnected|(^|[^0-9])50[234]([^0-9]|$)'

shopt -s nocasematch
if [[ $err =~ $auth_re ]]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUseFailure","additionalContext":"[Judaro canon] The Judaro server rejected authorization for this account (the sign-in has expired or the access key is not valid) — the firm-approved legal canon is unavailable until access is restored. Do NOT answer Israeli-legal questions from your own training knowledge and do NOT fabricate citations, statute or regulation numbers, court-rule references, checklists, deadlines, or templates. Tell the user plainly: Judaro rejected the sign-in for this connection; please sign in to Judaro again (in Claude Code: run /mcp, choose judaro, then Authenticate; with a connector: use its Connect button), or if the firm uses an access key, check that the key is still current. Then retry the request."}}'
elif [[ $err =~ $transport_re ]]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUseFailure","additionalContext":"[Judaro canon] The Judaro server could not be reached (the connection failed or timed out) — the firm-approved legal canon is unavailable for this request. Do NOT answer Israeli-legal questions from your own training knowledge and do NOT fabricate citations, statute or regulation numbers, court-rule references, checklists, deadlines, or templates. Tell the user plainly: the Judaro legal service is unreachable right now — usually a network problem or a brief outage; check the internet connection and try again in a moment. You may retry the tool once before reporting this."}}'
fi
exit 0
