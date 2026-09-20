# CLAUDE CONTROL PLANE — FIELD VALIDATION PACKET

**Date:** 2026-09-20
**Baseline:** repository HEAD `035a573` (post-AIGIS teardown).
**Purpose:** Owner-initiated real-world evidence collection kit. Consolidates the ZB-17 highest-information-action into an actionable hand-off. **Nothing in this document is a customer conversation. No interview has been conducted.**

## Absolute constraint — read first

- No interviews have taken place. This packet exists to enable the owner to conduct them.
- No content in this file may be treated as customer evidence. If a `CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_LOG.md` is later created and populated by the owner, each row in that log must be a real, timestamped interaction with a real person outside this repository.
- Claude (this assistant) cannot execute outreach. This assistant cannot contact humans on behalf of the owner, cannot send emails, cannot make calls, cannot post on LinkedIn, cannot chat, and cannot follow up.
- Any interview log that lacks a dated `Round N conducted YYYY-MM-DD` header and a real person's role/company class is not evidence.
- Prohibited under any circumstance: synthetic personas, composite quotes, inferred willingness-to-pay, fabricated procurement, or an interview record that Claude generated instead of the owner transcribing.

If the owner is not ready to conduct real outreach, do nothing with this packet. The current evidence state (recorded in the market report and audit) remains valid.

---

## 1. What this packet contains and does not contain

- **Contains:** targeting criteria, opening lines, refined behavioral question sequences (Wedge C auditor variant + operator variant), interview record template pointers, and anti-fabrication clauses.
- **Does not contain:** target names, target contact details, target companies, or any implication that specific individuals have been approached. Naming specific people is the owner's action, not Claude's.

The Customer Discovery Protocol (`CLAUDE_CONTROL_PLANE_CUSTOMER_DISCOVERY_PROTOCOL.md`) remains the fuller instrument. This packet is a **short overlay** capturing the specific behavioral-question refinements introduced by the Field Validation Gate master prompt (H3, H4, assurance-vs-control, root-problem chain).

## 2. Highest-information single action (per ZB-17)

**A single 30-minute behavioral conversation with an AIUC-1 accredited auditor**, applying the Wedge-C variant below, framed around evidence-inspection workflow — **not around Claude Control Plane as a product.**

The auditor is a warm-intro path because AIUC-1 has publicly named its first accredited auditor. The specific outreach target and contact route is the owner's decision. Claude will not fabricate a contact.

Positive Level-2 signal ("we spend engineering / auditor hours on exactly this evidence-inspection problem") would elevate Wedge C. Negative Level-0 signal ("we do this in Notion and accept the cost") would eliminate Wedge C and refocus on Wedge A (standards) or Wedge D (methodology publication).

## 3. Target classes (unchanged from prior artifacts)

- **Primary for Wedge C — Auditor variant:** AIUC-1 accredited auditor practices; ISO 42001 audit practitioners; SOC 2 practitioners adding AI-scope audits.
- **Primary for Wedge H1/H2/H3 — Operator variant:** Platform Engineering / AI Platform / AppSec / SRE leaders at organizations already using Microsoft Agent 365, Salesforce Agent Fabric, Boomi Agent Control Plane, GitHub Enterprise AI Controls, OpenHands Enterprise, or an internal build.

Any specific target identification is owner-initiated.

## 4. Opening line — operator variant

Verbatim, delivered by the owner:

> *"I'm studying how engineering organizations verify and govern work produced by AI coding agents. I'm not selling a product. I'm trying to understand how this actually works in practice."*

## 5. Opening line — auditor variant (Wedge C)

Verbatim, delivered by the owner:

> *"I'm studying how AI-assisted engineering evidence is currently inspected during security, compliance, or AI-governance audits. I'm not selling software; I'm trying to understand the workflow."*

## 6. Operator question sequence (Wedge H1/H2/H3/H4)

Use the master prompt §6 sequence verbatim as the primary set. In addition, if the interviewee has not independently raised the incident-loop topic by Question 15, ask the H3 direct-test set from master prompt §15:

- *"When an AI-agent incident happens, how does your organization make sure the resulting lesson becomes a durable automated regression or control?"*
- *"Does that process have a machine-readable representation?"*
- *"If not, why?"*
- *"How often does the same class of failure recur?"*
- *"Who owns prevention of recurrence?"*
- *"What system records the control?"*
- *"What would happen if the control silently stopped working?"*

And the H4 direct-test set from master prompt §16:

- *"How do you know your AI-agent governance controls continue working after your agent provider changes?"*
- *"Do you run regression tests against your governance layer?"*
- *"What happens when a provider changes a hook, model behavior, permission system, or execution environment?"*
- *"How do you detect governance drift?"*

## 7. Assurance-vs-Control direct test (master prompt §17)

Regardless of variant, at some point elicit:

- *"Which do you actually pay to solve — preventing the agent from doing something unsafe, or producing trustworthy evidence that the required process/outcome happened?"*
- *"Which one causes more operational pain?"*
- *"Who owns each?"*
- *"Which one has budget?"*

## 8. Root-problem chain elicitation (master prompt §14)

Do not assume the evidence-gate is the root problem. During the interview, listen for which of the 13 candidate root problems the interviewee's own language matches:

```
A bad task specification
B poor acceptance criteria
C weak tests
D excessive permissions
E insufficient sandboxing
F poor observability
G poor review
H ambiguous ownership
I incorrect completion claim
J inability to prove completion
K inability to audit agent behavior
L inability to convert incidents into durable controls
M something else
```

Record the causal chain the interviewee actually describes, in their language.

## 9. Interview record format

Use the master prompt §25 fields verbatim. Record each interview outside the repository (see §10 below). Only anonymized aggregate summaries may be added to a future `CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_LOG.md`.

## 10. Data-handling rules

- **Store raw interview notes outside this repository.** The shared `docs/research/` directory must never contain identifying information about real interview subjects.
- **Anonymize before publishing.** Roles + company class (e.g., "Platform Engineering lead at fintech 500-2,000 engineers") are OK; names, employers, email addresses, LinkedIn URLs are not.
- **Recording:** opt-in only; if recording is refused, take timestamped notes.
- **Consent language example** (owner adapts): *"I keep a private notes file for these conversations. Only anonymized aggregate findings would go into a public research write-up. Nothing you say attaches to your name or company."*
- **Retention:** owner's choice, outside this repository.

## 11. Anti-fabrication contract

Every claim in a future field-validation log must be traceable to:

- a real timestamped interaction,
- with a real person,
- outside this repository's version control,
- that the owner (or explicitly-authorized owner delegate) actually conducted.

Any log entry lacking that provenance must be labeled **`INSTRUMENT DRAFT — NOT A REAL INTERACTION`** or removed.

Claude cannot verify the provenance of any future log entry. That verification is the owner's discipline.

## 12. Level classification (master prompt §8)

Every interview evidence claim in a future log must carry a level:

```
L0 = abstract opinion
L1 = generic pain recognition
L2 = independently described real incident or recurring job
L3 = repeated operational pain with meaningful consequences
L4 = active workaround, internal project, or evaluated solution
L5 = concrete pilot / evaluation / procurement
L6 = budget discussion or explicit purchase intent
L7 = payment / paid pilot / signed customer
```

## 13. Sample-size guidance (master prompt §5)

Round 1: **3–5 real interviews**. Do not scale.

Per-role convergence: a behavioral pattern is **evidenced within a role** only after ≥3 independent interviews within that role describe the same behavior in their own words.

Stop sooner if:

- two consecutive interviews produce no new information;
- a real budget/workaround/evaluation signal appears (Level 4+) and can be recorded;
- the proposed job is repeatedly rejected as adequately solved.

## 14. What to bring back from Round 1

A `CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_LOG.md` with, per interview, the master prompt §25 fields filled in. Nothing more. No strategic-thesis rewrite, no product roadmap, no wedge selection — just the observed facts.

## 15. What NOT to bring back from Round 1

- A product design.
- A pricing hypothesis.
- A PMF claim.
- An F10 opening request.
- Any change to CCP runtime files.
- A "customer validated the thesis" statement (per master prompt §26).

## 16. Owner-only checklist before contacting anyone

- [ ] Owner has decided which target class (Wedge C auditor / Wedge H1-H4 operator) to start with.
- [ ] Owner has identified at least one specific real person (name and role) and a real path of contact.
- [ ] Owner has read this packet and the Customer Discovery Protocol.
- [ ] Owner accepts that Claude will not generate, simulate, or fabricate any interview content.
- [ ] Owner has a private notes-storage location outside this repository.
- [ ] Owner is ready to invest the owner-time (approximately 60–90 minutes per interview including outreach + conducting + note capture).

If any box is unchecked, do not start Round 1.

## 17. Explicit non-claims

- **No interview has been conducted at the time of this file's creation.** If this line ever appears without an accompanying `CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_LOG.md` (with a real `Round 1 conducted YYYY-MM-DD` header), then no field validation has occurred and no evidence has been generated.
- No customer has validated the thesis.
- No buyer has been found.
- No willingness-to-pay has been demonstrated.
- No pilot has been requested.
- No F10 has been opened.
- No runtime file has been modified.
- No engineering has been authorized.

**End of Field Validation Packet.**
