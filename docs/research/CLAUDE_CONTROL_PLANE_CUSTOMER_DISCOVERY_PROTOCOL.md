# CLAUDE CONTROL PLANE — CUSTOMER DISCOVERY PROTOCOL

**Purpose:** Instrument for real-world buyer-validation interviews. This document is a **research protocol**, not a set of results. It defines who to interview, what to ask, how to record answers, and how to interpret them. **No interview has been conducted. No synthetic personas or synthetic answers are permitted in the results file.**

**Date:** 2026-09-20
**Baseline:** applies to project state at HEAD `07cc702`; F7 / F8 / F9 all frozen; F10–F12 unknown.
**Author role:** Claude Opus 4.7 (self-declared; not cryptographically proven).
**Scope:** This protocol supersedes the V-01, V-03 and V-05 sketches in `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md §25` for the specific purpose of buyer-reality validation. It integrates the anti-leading rules the audit and closure loop identified.

**Forbidden by this protocol:**

- Automated outreach.
- Sending emails, DMs, or connection requests without explicit owner action.
- Any personally identifiable customer information stored in the repository.
- Any "persona" / synthetic customer used as if it were a real interview.
- Any claim that a live customer has validated the product prior to actually being interviewed.

**Allowed by this protocol:**

- Owner-initiated warm-intro interviews.
- Interview note-taking in a private (non-repository) location.
- Publishing only aggregate, anonymized findings back into `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md` or a dedicated `docs/research/CUSTOMER_DISCOVERY_FINDINGS.md` file **after real interviews occur**.

---

## 1. Objective

Answer, in behavioral (not opinion) terms, exactly four questions:

1. **Who owns the pain** of AI-coding-agent behavior at real organizations?
2. **What do they use today** to control it — full current stack, not idealized alternative?
3. **What exactly remains unsolved** after that stack?
4. **Who has budget** and under what category to solve what remains?

Successful discovery does **not** produce enthusiasm. It produces evidence that maps a specific role at a specific class of organization to a specific unmet job.

Explicit non-goals of this protocol:

- Selling anything.
- Establishing willingness-to-pay in the first interview.
- Getting a design partner commitment.
- Testing the Claude Control Plane implementation. Never mention the project in the first three interviews.

---

## 2. Target roles and segmentation

Interviews are grouped by role. **Cross-role generalization is forbidden until at least three interviews per role have converged on the same behavioral pattern.**

### 2.1 Platform Engineering / Developer Productivity

- **Include:** Head of Platform Engineering; Head of Developer Productivity; Head of Developer Experience; Principal Engineer on internal developer platform team.
- **Exclude:** Frontend / mobile / product engineers with no platform ownership; managers without technical involvement in agent tooling.
- **Organization filter:** 50–2,000 engineers, actively using ≥1 AI coding tool (Claude Code, Cursor, Copilot, Codex) in production ≥3 months.

### 2.2 AppSec / Security Engineering

- **Include:** AppSec engineer; Application Security Manager; Product Security Manager; Security Engineering Manager responsible for AI-tool policy.
- **Exclude:** Compliance-only roles with no operational responsibility; incident-response-only roles.
- **Organization filter:** either has a documented AI-tool policy OR has experienced an AI-tool-related security event in the past 12 months.

### 2.3 CISO / Security Leadership

- **Include:** CISO; Deputy CISO; Head of Security responsible for AI governance procurement.
- **Exclude:** Any role where AI-tool procurement is not part of remit.
- **Organization filter:** enterprise (>500 employees) OR regulated vertical (finance, health, gov, defense).

### 2.4 Engineering Management / CTO

- **Include:** VP Engineering; Head of Engineering; CTO at organizations 20–500 engineers.
- **Exclude:** Engineering managers without budget authority.

### 2.5 AI Platform / AI Infrastructure

- **Include:** Head of AI Platform; Lead ML Engineer with agent-infrastructure responsibility; AI infrastructure lead.
- **Exclude:** Data scientists with no platform / control responsibility.

### 2.6 Recruitment inclusion / exclusion criteria (all roles)

| Criterion | Include | Exclude |
|---|---|---|
| Uses at least one agentic coding tool at organizational scale | ✓ | Doesn't use, or uses only autocomplete |
| Has been in role ≥ 6 months | ✓ | Just started |
| Has direct responsibility for at least one of: policy, deployment, incident response, procurement, governance | ✓ | Advisory only |
| Willing to speak on behavioral, non-hypothetical questions | ✓ | Wants to speculate about "the future" without recent behavior |
| Has direct authority OR one degree of separation from budget owner | ✓ | Cannot describe budget flow |

---

## 3. Interview instrument

### 3.1 Structural rules

- 30-minute maximum.
- One interviewer, one interviewee. No panels.
- No slides. No demos of Claude Control Plane during the interview. **The interviewer never mentions Claude Control Plane by name in the first three interviews.**
- Recording is opt-in; if recording is refused, take timestamped notes.
- All answers stored **outside the repository** in a private location; only anonymized aggregate summaries may be added to the research artifacts.

### 3.2 Behavioral question set (open questions, non-leading)

Use "tell me about the last time" as the default construction. Skip questions that don't apply to that role.

#### A. Recent incident and behavior

- "Tell me about the last time an AI coding agent claimed a task was complete but wasn't. What happened?"
- "What did you do in the days after?"
- "Did the incident change anything about how you deploy that tool now? What specifically changed?"
- "When was the most recent time an agent did something destructive on your system? What was the operational consequence?"

#### B. Current stack

- "Walk me through exactly what controls sit between an agent-generated change and production today."
- "Which of those controls did you configure specifically because of an AI agent? Which were already there?"
- "What does your team currently do to verify that agent-completed work was actually done?"
- "Who owns each of those controls operationally? Not who set the policy — who fixes it when it breaks?"

#### C. Cost and time

- "How much engineering time does reviewing agent output consume in a typical week?"
- "How much rework did the most recent bad agent output cost you? Reviewer hours plus rework hours."
- "Have you ever paused or rolled back a rollout because of agent behavior? How long did that pause take?"

#### D. Alternatives and buy-vs-build

- "For the AI coding control layer, what did you build in-house? What did you buy? What did you decide neither was needed for?"
- "For each thing you bought, what was the last vendor you evaluated? Why did you pick or reject them?"
- "What did you almost buy but didn't? What made you not buy?"
- "What did you build in-house that you now wish you hadn't built?"

#### E. Budget flow

- "Which budget line did that last purchase come out of? (security? platform? DevEx? AI?)"
- "Who signed the PO? Who approved the RFP? Who champions renewal?"
- "How does your organization currently categorize AI-tool controls in procurement — is it a distinct line, folded into security, folded into DevEx?"

#### F. Failure of controls

- "When have your current controls fired on legitimate work? What did the developer do?"
- "How often do developers work around a control they think is too strict? What do they do instead?"
- "Have your current controls ever failed to catch something they should have caught? When?"

### 3.3 Anti-leading rules (mandatory)

**Forbidden constructions** (must not appear in any interview):

- "Would an evidence gate solve this?"
- "Would you buy a product that verifies agent completion?"
- "Would $X/user/month be reasonable?"
- "Do you think agent governance is important?"
- "Would your organization pilot such a tool?"
- Anything hypothetical that produces confirmation bias.

**Preferred behavioral substitutes** (allowed):

- "How do you currently know an agent's claim of completion is true?"
- "How does your organization budget for tooling of that class?"
- "What comparable products have you already purchased?"
- "What triggered the last purchase in that category?"
- "How did that decision get made — who signed off?"

### 3.4 Willingness-to-pay: how and when to ask

- **Never in the first 20 minutes.**
- Only after A–F have produced concrete behavioral evidence.
- Never a hypothetical dollar figure. Ask: "What comparable tools have you bought recently, and roughly what tier?" Then: "For a problem the size of the one you just described, does your org typically buy or build?"
- **Interpret responses conservatively**: an interviewee saying "sure, we'd consider it" is Level 1 (stated interest), not Level 3 (pilot).

---

## 4. Evidence capture template

Every interview produces one structured record. Records live **outside the repository** by default.

```
Interview ID:             (opaque; do not include name)
Date:                     YYYY-MM-DD
Duration:                 minutes
Role bucket:              (Platform Eng / AppSec / CISO / Eng Mgmt / AI Platform)
Company class:            (industry, size bucket, regulatory posture)
Agent stack:              (Claude Code / Cursor / Copilot / Codex / other)
Current control stack:    (comma-separated list of concrete controls in place)
Recent incident:          (short factual description; not "concern" — event)
Current workaround:       (what they actually do)
Time cost per week:       (hours; numeric or explicit "unknown")
Financial cost of most
  recent bad agent
  behavior:               (currency amount, or explicit "unknown")
Owner (operational):      (role, not person)
Owner (budget):           (role, not person)
Purchase history in
  adjacent categories:    (list vendor + last-year purchase or "none")
Alternatives considered:  (list; include reject-reason)
Trigger for last
  purchase:               (specific event or "unknown")
Buyer signal level (0-7): (see §5)
WTP signal level (0-7):   (see §5)
Bias risks noted:         (e.g. interviewee is Claude Code enthusiast)
Contradictions with
  earlier interviews:     (short cross-reference)
Owner-verbatim quote:     (one short sentence, only if it captures the pain
                           in the interviewee's own words)
```

**Prohibited fields in the shared repository copy:** name, email, employer, exact title, LinkedIn URL, geographic city. Only role bucket + company class are ever committed.

---

## 5. Buyer / WTP signal hierarchy

Apply exactly as defined in `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md §RB` and the master prompt §13.

```
LEVEL 0    Article / opinion
LEVEL 1    Stated interest
LEVEL 2    Active evaluation of a category (e.g., they've read vendor docs)
LEVEL 3    Pilot underway
LEVEL 4    Deployed implementation, no purchase yet
LEVEL 5    Procurement in flight (RFP, SOW draft)
LEVEL 6    Payment / signed contract
LEVEL 7    Renewal or seat expansion
```

**Rules:**

- Never infer a higher level than the interview evidence supports.
- Enthusiastic language ("this sounds great") is Level 1 at most.
- Description of a past purchase in the exact category is Level 6/7 evidence for **that** vendor, not for Claude Control Plane; it is Level 2 evidence for the *category*.
- WTP is a separate axis from Buyer Level. A Level 5 buyer with no established comparable is a WTP hypothesis, not a fact.

---

## 6. Bias risk register

Interviewers must record which of the following applies to each interviewee and to the interviewer themselves:

- **Enthusiast bias:** interviewee is publicly known as an AI-tool advocate.
- **Vendor-relationship bias:** interviewee works at or with a vendor in an adjacent category.
- **Owner-friendship bias:** interviewee is a warm intro from a personal contact.
- **Confirmation bias:** interviewer already believes evidence-gated completion is the answer.
- **Recency bias:** interviewee just experienced an incident and is over-indexing.
- **Prestige bias:** interviewee wants to sound sophisticated about AI governance.

At least one bias must be listed per interview; "no bias detected" is not an acceptable entry.

---

## 7. Analysis method

### 7.1 Per-role convergence rule

A behavioral pattern is considered **evidenced within a role** only after ≥3 interviews within that role independently describe the same behavior in their own words, with distinct company classes.

### 7.2 Cross-role convergence rule

A cross-role finding requires ≥3 roles each meeting §7.1.

### 7.3 Contradiction preservation

Contradictory answers between roles or interviews are recorded, not resolved by fiat. When two interviews contradict, the analysis file must state both and label as `UNRESOLVED CONTRADICTION`.

### 7.4 Anti-cherry-picking

Interview summaries in the shared repository must include:

- Number of interviews conducted per role.
- Number of interviews per role that described the pattern being reported.
- Number of interviews that contradicted it.
- Any interview excluded from analysis and why.

### 7.5 Prohibited moves

- Combining two "somewhat" answers into "yes."
- Extrapolating from one enthusiastic interview to a segment claim.
- Reporting WTP as a percentage when the sample is <10.
- Naming a "buyer" based on a single Level-1 conversation.

---

## 8. Decision rules (owner-discretionary)

These are **PROPOSED DECISION RULES — OWNER DISCRETION** (per audit CR-06). The owner may accept, adjust, or reject them.

The current state after this round of interviews may be classified as **buyer validation achieved** only if all of the following are true, with `n` = interview count per role:

- Platform Engineering role: `n ≥ 3` AND ≥ 3 of those independently describe a specific unresolved job related to agent-completion verification, self-regression, or evidence retention, without prompting.
- OR AppSec / CISO role: `n ≥ 3` AND ≥ 3 name a specific procurement gap in the coding-agent behavioral-assurance category, distinct from AISPM tools they already buy.
- AND at least one interviewee in either group cites a purchase or evaluation in the exact category (Level ≥ 2) without prompting.
- AND at least one identified budget owner (Level ≥ 5 in an adjacent category, plus a rationale that this budget would extend to coding-agent behavioral assurance).

If any row is missing, the classification remains `NOT ENOUGH EVIDENCE`.

The owner may run 5 interviews and then decide whether to continue based on qualitative signal. The 3-per-role rule is a discipline, not a mandate.

---

## 9. Reporting integrity clauses

- **No fabricated interviews.** Any finding in the shared repository must be reproducible from real timestamped notes.
- **No composite personas.** If the finding depends on stitching together multiple partial interviews, that must be labeled `COMPOSITE PATTERN — NOT A SINGLE-INTERVIEW OBSERVATION`.
- **No revenue projections.** WTP evidence at this stage does not support pricing.
- **No PMF claim.** Product-market-fit requires deployed and renewed usage, which this protocol does not measure.
- **Anonymized-first.** The shared repository must never contain identifying information.

---

## 10. Sequencing

- **Round 0 (this protocol).** Written; no interviews conducted.
- **Round 1 (owner initiates).** 3–5 warm-intro interviews across Platform Engineering + AppSec.
- **Analysis pause after Round 1.** If Round 1 does not produce ≥ 2 independent behavioral descriptions of an unmet job, stop and reconsider before recruiting further.
- **Round 2 (if Round 1 signal survives).** Bring cohort to `n ≥ 3` per role for the two most-signal roles.
- **Cross-role check.** Only after §7.1 is met per role.

The owner decides when to move between rounds. This protocol does not authorize automatic escalation.

---

## 11. Anti-infinite-loop rule

- **Maximum interviews before a decision:** the smaller of (`n=15`) or (`the round after which two consecutive interviews produce zero new patterns`), whichever comes first.
- **No re-interviewing** for the same behavioral pattern unless the interview surfaces a genuinely new question.
- **Do not extend the protocol** to cover new categories mid-round.

---

## 12. Explicit statements the protocol requires the results file to contain

Whenever a `CUSTOMER_DISCOVERY_FINDINGS.md` file is later created, it must open with these clauses verbatim:

```
Desk research can identify plausible buyers.
Desk research cannot prove customer demand.
Desk research cannot prove willingness to pay.
Desk research cannot prove product-market fit.

Interview evidence within this document is:
  behavioral, not opinion-based;
  role-anonymized and company-class-only;
  reproducible from timestamped notes outside this repository;
  aggregated only after per-role convergence rules were met.

This protocol has not been executed at the time this line is written unless
a dated "Round 1 conducted YYYY-MM-DD" header follows.
```

Absence of that header means no interviews have occurred; nothing in the file below may be presented as customer evidence.

---

## 13. Cross-links

- Report classifications this protocol targets to resolve: `BUYER = NOT ENOUGH EVIDENCE`, `WTP = NOT ENOUGH EVIDENCE`, `PILOT COMMITMENT = NOT ENOUGH EVIDENCE`, `PMF = not established`.
- Audit residual objections this protocol targets: ROB-01, ROB-02, ROB-A; and the "PARTIALLY IDENTIFIED" buyer classification in §9 of the audit.
- Source appendix rows this protocol treats as decision inputs, not proof: S-B-04 (Zenity funding), S-A-07 (AGENTS.md adoption), S-E-01 (MIT NANDA 95%). None of these is customer evidence for Claude Control Plane specifically.

---

**End of Customer Discovery Protocol.**
