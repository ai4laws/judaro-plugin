---
name: judaro-feedback
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
2. **Draft the report for them.** In one or two sentences capture: *what they asked*, *what
   Judaro returned*, and *why it was wrong / unexpected*. If they said what they expected
   instead, keep that as its own sentence — it has its own form field. Show the draft and let
   them edit it; the approved text is what you will pre-fill into the form.
3. **Hand over ONE pre-filled link — always as a Markdown link.** Build the most complete URL
   you can (next section) and present it as a short Hebrew link, e.g.
   *[📝 פתיחת טופס המשוב — הפרטים כבר מולאו](https://docs.google.com/forms/…)*.
   **Never paste the long raw URL into the chat** — it is unreadable and easy to corrupt.
4. Mention they can attach a screenshot or short recording link in the form, and edit
   anything before sending.

## Building the pre-filled link
The form accepts pre-filled answers as URL query parameters: `&entry.<id>=<URL-encoded value>`.
Fill every field you can from the conversation; omit what you don't know.

**Base URL — prefer the server's link.** If any Judaro tool result earlier in this conversation
included `feedback.report_url`, start from it: the server already filled the skill, the
environment context, and the user's **verified registered email** (which you cannot see
yourself). Append only parameters it does not already contain — never repeat one. If its
pre-filled skill is not the one this report is about, build from scratch instead. No server
link in context? Build from:
`https://docs.google.com/forms/d/e/1FAIpQLSfC6AL0CqzIMIe3cPzGYLQQ9dLfHFD3N-S1hqSX-tpkXgh83A/viewform?usp=pp_url`

| Form field | Parameter | Fill with |
| --- | --- | --- |
| מה קרה? תארו בקצרה | `entry.1917472074` | the approved summary from step 2 (1–3 short sentences) |
| מה ציפיתם שיקרה? | `entry.381623323` | what the user expected, if they said |
| סוג הפנייה | `entry.809966430` | exactly one of: `תשובה שגויה / לא מדויקת` · `מידע חסר או לא מעודכן` · `קישור / קובץ / מסמך שלא עובד` · `הצעה לשיפור` · `בעיה טכנית / תקלה` · `אחר` — must match verbatim; omit if unsure |
| תחום / מיומנות רלוונטיים | `entry.771276114` | the Judaro skill/domain involved (e.g. the `get_skill` id) |
| דחיפות | `entry.656931816` | only if the user clearly indicated: `קריטי` · `בינוני` · `קל` |
| אימייל רישום ל-Judaro | `entry.2137988038` | the registered email — see below |
| הקשר טכני (נא לא למחוק) | `entry.1756426537` | `Judaro beta` — only when building from scratch |

**Registered email — what you can and cannot know.** You have no access to the email the
connector authenticated with (it lives in the client's transport layer, outside your context).
In order of trust:
1. an earlier `report_url` in this conversation — it carries the verified address URL-encoded
   in its `entry.2137988038=` parameter; reuse that value;
2. an email address the user stated themselves;
3. the user's account email, if your platform context exposes one — a best guess only (a
   Claude login can differ from the Judaro registration); fine to pre-fill, they can fix it.

Never invent or guess beyond these — otherwise leave the field for the user to type.

URL-encode every value (Hebrew included — UTF-8 percent-encoding). A long URL is fine; the
Markdown link hides it.

## Rules (important)
- **Privacy first.** Never put the user's client/matter details into the link or the summary
  unless they explicitly approve the exact wording. Judaro never receives matter data
  automatically — the server is read-only and sees only what your account is entitled to.
- **Pre-fill only text the user has seen.** Free-text answers you pre-fill must be the
  approved step-2 draft. The link itself transmits nothing — the form is sent only when the
  user reviews and submits it.
- **Never submit anything yourself.** You prepare; the user reviews and sends.
- If `$ARGUMENTS` is provided, treat it as the user's description of the problem and fold it
  into the summary.
- Keep it to one short, friendly exchange — don't interrogate, don't repeat the offer every turn.
