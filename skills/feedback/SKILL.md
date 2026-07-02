---
name: feedback
description: >-
  Report a problem with — or send feedback about — Judaro (the hosted Israeli-legal
  skills service). Use when the user says a legal result or skill was wrong, outdated,
  missing, or not what they expected; when they seem frustrated with an answer; or when
  they explicitly want to report a bug or give feedback. Beta feedback channel.
argument-hint: "[what went wrong — optional]"
---

# Send feedback to Judaro (beta)

Judaro is in **beta**, and the team actively wants to hear when something is wrong, missing,
or surprising — that is how it improves. Make giving feedback effortless and warm, never a
chore. Speak to the user in **Hebrew** (their default), briefly.

## What to do
1. **Acknowledge in one line** (Hebrew) — thank them; this genuinely helps us and them.
   e.g. *"תודה! זה בדיוק מה שעוזר לנו לשפר את Judaro 🙏"*
2. **Offer to summarize the issue for them.** In one or two sentences capture: *what they
   asked*, *what Judaro returned*, and *why it was wrong / unexpected*. Show the draft and let
   them edit it — this is what they'll paste into the form. Keep it short and concrete.
3. **Give them the report link:**
   - If a Judaro tool result earlier in this conversation included a `feedback.report_url`,
     **use that link** — it is already pre-filled with the skill/topic and environment. Prefer it.
   - Otherwise use the form: **https://docs.google.com/forms/d/e/1FAIpQLSfC6AL0CqzIMIe3cPzGYLQQ9dLfHFD3N-S1hqSX-tpkXgh83A/viewform**
4. Mention they can also attach a screenshot or a short screen recording in the form, if useful.

## Rules (important)
- **Privacy first.** Never put the user's client/matter details into the link or the summary
  unless they explicitly approve the exact wording. Judaro never receives matter data
  automatically — the server is read-only and sees only what your account is entitled to.
- **Never submit anything yourself.** You prepare the summary and hand over the link; the user
  reviews and sends. No automatic transmission.
- If `$ARGUMENTS` is provided, treat it as the user's description of the problem and fold it into
  the summary.
- Keep it to one short, friendly exchange — don't interrogate, don't repeat the offer every turn.
