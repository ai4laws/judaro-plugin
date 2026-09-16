#!/usr/bin/env bash
# Judaro legal-canon guardrail — PostToolUseFailure hook.
#
# Fires ONLY when a legal-skills MCP tool call failed because the Judaro server could not
# be reached (connection error / timeout) or refused the account (401/403/unauthorized).
# Those are the cases the server cannot speak to in-band, so the client injects a
# grounding reminder. Ordinary tool errors from a healthy server — `forbidden:`
# entitlements, `not found:`, `wrong tool:`, capability rejections — already carry their
# own grounding text in the error string, so this hook stays silent for them (it used to
# fire on every failure, drowning those richer messages in a generic banner).
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

# The server prefixes EVERY refusal made at the auth boundary with `unauthorized:`, so
# "unauthorized" alone does not mean "bad credential". That family splits in two, and the
# two halves need opposite advice:
#
#   1. Thin CREDENTIAL errors — `missing or invalid OAuth token`, `invalid API key`,
#      `missing or malformed Authorization: Bearer header`. The server says only that the
#      credential failed; it names no next step, so the client's sign-in instructions are
#      the useful part. -> auth branch.
#   2. LIFECYCLE / PACING refusals — the account is known and the credential is fine, but
#      access is withheld: `expired` (access period lapsed), `blocked` (moderator),
#      `disabled`, the temporary pacing pauses, the device limit. Each ALREADY carries
#      its own actionable remedy in the error text — a renewal link, hello@judaro.com,
#      "resumes automatically", "reconnect Judaro here" — and several speak to the calling
#      agent directly ("retrying will not lift the block"). Prescribing re-authentication
#      here is simply wrong (signing in again restores nothing) and it competes with the
#      server's own message. -> lifecycle branch, which defers instead of prescribing.
#
# Matched by fixed, distinctive phrases rather than by reason codes, which the wire format
# does not carry. That is sturdier than it looks: the server pins the wording of each of
# these messages precisely because support quotes them back to lawyers.
#
# Deliberately NOT matched: bare "forbidden" (the entitlement error starts `forbidden:`)
# and bare "token"/"expired" (capability rejections say `capability expired` /
# `capability.token`) — those come from a healthy server and explain themselves. Also left
# on the auth branch on purpose: `not provisioned: … has no Judaro account`, where signing
# in again IS plausibly the fix (a lawyer who authenticated with a personal address rather
# than the registered firm one).
#
# Ordering matters: lifecycle is tested FIRST, because every message it matches also
# carries the `unauthorized:` prefix that the auth branch keys on.
lifecycle_re='access period|blocked by a moderator|account inactive|temporarily paused|connected devices'
auth_re='unauthorized|authenticat|authorization|oauth|invalid[ _-]?(api[ _-]?)?key|(^|[^0-9])40[13]([^0-9]|$)'
transport_re='timed?[ -]?out|unreachable|econn|enotfound|eai_again|epipe|ehostunreach|enetunreach|connect|network|socket|fetch failed|dns|tls|ssl|gateway|service unavailable|server disconnected|(^|[^0-9])50[234]([^0-9]|$)'

shopt -s nocasematch
if [[ $err =~ $lifecycle_re ]]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUseFailure","additionalContext":"[Judaro canon] Judaro refused this call over the standing of this account with the service — not over a bad credential — so the firm-approved legal canon is unavailable for this request. Do NOT answer Israeli-legal questions from your own training knowledge and do NOT fabricate citations, statute or regulation numbers, court-rule references, checklists, deadlines, or templates. The remedy is the one the Judaro server itself gave: relay its error message to the user as it stands, keeping any link or address it contains, and do NOT replace it with sign-in or access-key advice — re-authenticating does not restore access in this situation. Do not retry the tool unless that message says access resumes on its own."}}'
elif [[ $err =~ $auth_re ]]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUseFailure","additionalContext":"[Judaro canon] The Judaro server rejected authorization for this account — the firm-approved legal canon is unavailable until access is restored. Do NOT answer Israeli-legal questions from your own training knowledge and do NOT fabricate citations, statute or regulation numbers, court-rule references, checklists, deadlines, or templates. Start from the error message the Judaro server itself returned, and relay it to the user: if it names a next step of its own — a renewal or upgrade link, an address to contact, a wait, a device to reconnect — that IS the remedy, so use it and do not substitute sign-in advice. Only when the message says no more than that the credential is missing, invalid or expired, tell the user plainly: Judaro did not accept the sign-in for this connection; please sign in to Judaro again (in Claude Code: run /mcp, choose judaro, then Authenticate; with a connector: use its Connect button), or if the firm uses an access key, check that the key is still current. Then retry the request once."}}'
elif [[ $err =~ $transport_re ]]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PostToolUseFailure","additionalContext":"[Judaro canon] The Judaro server could not be reached (the connection failed or timed out) — the firm-approved legal canon is unavailable for this request. Do NOT answer Israeli-legal questions from your own training knowledge and do NOT fabricate citations, statute or regulation numbers, court-rule references, checklists, deadlines, or templates. Tell the user plainly: the Judaro legal service is unreachable right now — usually a network problem or a brief outage; check the internet connection and try again in a moment. You may retry the tool once before reporting this."}}'
fi
exit 0
