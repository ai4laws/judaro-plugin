---
name: legal-canon-guardrail
description: >
  Fail-closed grounding policy for ALL Israeli-legal work. Use whenever the task touches
  Israeli law — drafting, contracts, checklists, intake, statutes/regulations, case law,
  filing deadlines, legal analysis — or any Hebrew-language legal request (חוק, תקנה, פסיקה,
  חוזה, כתב טענות, ייפוי כוח, צוואה, מקרקעין, מיסוי). Governs what to do when the hosted
  legal-skills MCP server is unavailable, returns a permissions error, or has no matching skill.
---

# Legal Canon Guardrail

Israeli-legal work product (citations, statute/regulation numbers, court-rule references,
checklists, filing deadlines, clause templates) must be **grounded in the firm-approved
canon** delivered by the hosted Legal Skills MCP server — never in your own training
knowledge. The canon is the source of truth; your memory of Israeli law is not, and may be
outdated or simply wrong. This is a hard rule: **fail closed — do not guess.**

## The one rule
Before producing any Israeli-legal output, you must have loaded the relevant material *this
session* from the `legal-skills` MCP tools (`list_domains` → `list_skills` → `get_skill`, then
the `get_playbook` / `get_knowledge` / `get_reference` / `download_file` calls the skill names).
If you have not, you do not yet have a basis to answer.

## Three situations — what to do

**1. The server is unavailable / a tool errors / the connector is missing.**
You cannot reach the canon. Do **not** answer from your own knowledge and do **not** fabricate.
Tell the user. For example:
- EN: "I can't reach the Judaro legal canon right now (the server is unreachable or erroring),
  so I can't ground this in the firm-approved material. I won't guess Israeli law from memory.
  Let's retry once it's back, or check the connection."
- HE: "אין לי כרגע גישה למאגר המשפטי של Judaro (השרת אינו זמין או מחזיר שגיאה), ולכן אני לא
  יכול לבסס את התשובה על החומר המאושר של המשרד. לא אנחש מהזיכרון בנושא משפטי — נסה שוב כשהשירות
  יחזור, או בדוק את החיבור."

**2. The content exists but your packages do not grant it (a `forbidden:` error).**
The skill/document exists in the catalog but the account is not entitled. The server's error
names the package(s) that unlock it. Do **not** substitute your own legal knowledge. Tell the
user what is missing, that it requires a package they don't currently have, and relay the
package name(s) the server offered so they can obtain access.

**3. The canon loaded fine and a relevant skill is available.**
Proceed: follow the loaded skill's instructions, make the get_* calls it names, and ground every
legal statement in what those tools return. If no skill matches the task, say so plainly (name
the closest domain) rather than improvising legal content.

## Always
- Cite only from what the tools returned this session. If you cannot verify a citation, statute
  number, or deadline against loaded material, do not state it.
- "I couldn't ground this in the canon" is an acceptable, correct answer. Fabricated Israeli
  law is not.
