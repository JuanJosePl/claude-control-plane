# CCP Exploration Engine

> Version: 1.0 | Last updated: 2026-09-23
> State authority: `PROJECT_STATE.md` | Evidence authority: `EVIDENCE_REGISTRY.md`
> This document converts static knowledge into operational movement. It is not an atlas.

---

## §1 — Purpose

This document provides the operational mechanism for CCP to move through unknown territory rather than repeat completed research. It maintains the position, frontier, available routes, and movement history so that each session can begin from a known state and produce a result that changes that state.

The discipline is:

```
MAP → FRONTIER → HYPOTHESIS → MOVEMENT → EVIDENCE → RESULT → RECLASSIFY → NEW FRONTIER → MOVE AGAIN
```

A session that ends without a reclassification produced documentation, not movement.

---

## §2 — Current Position

```
F1-F8:     COMPLETE / FROZEN (last freeze: 2cd7953)
F9:        RESEARCH COMPLETE / NOT JUSTIFIED / OWNER GATE CLOSED (2026-09-20)
F10-F12:   UNKNOWN / NOT STARTED (F9-D05=A)

R-1:       PRIOR ART VERIFIED — residual SURVIVES (47_PRIOR_ART_VERIFICATION.md)
R-2:       INSTRUMENTATION IMPLEMENTED / AUDITED_CONFIRMED — 1 test event, no field data
R-3:       DESIGN AUDITED_CONFIRMED — EMPIRICAL TEST COMPLETE (2026-09-23)
           Classification: PARTIALLY_TRACTABLE (design level)

STALL_POLICY_LOG:  1 event (R-2 test instrumentation; not production data)
ROGER HYPOTHESIS:  INDETERMINED / tendency = REFORMULATION

IMPLEMENTATION_READY: false
NEXT_ALLOWED_PHASE:   Owner-driven decision required
```

---

## §3 — Current Frontier

The frontier is the boundary between what is known and what is not yet resolved.

```
KNOWN (closed)
├── F1-F8 architecture and verification
├── R-1 prior art (four candidates do not close residual)
├── R-2 instrumentation (operational, no field data)
├── R-3 design (AUDITED_CONFIRMED, 9-case empirical test COMPLETE)
├── R-3 security invariant holds (design level)
├── R-3 UNKNOWN discipline holds (design level)
├── Protocol coherence: VERIFIED (design level)
└── Independence blocker: IDENTIFIED

FRONTIER (boundary)
├── Independence architecture: how can proposer/verifier separation be achieved?
├── Policy explicitness: are CCP's existing policies explicit enough for R-3 SAFE labels?
├── H-01 (stall frequency): unknown — R-2 has no field data
├── Roger Hypothesis: INDETERMINED — needs specific falsification test
└── Hypothesis B viability: what would human escalation rate look like for real denials?

UNKNOWN (not yet entered)
├── F10-F12 shape, scope, necessity
├── Production implementation of non_bypass_verify (not authorized)
├── Commercial viability (H-03)
└── Native Claude Code lifecycle behavior (deferred per F9-D02=B)
```

---

## §4 — Movement Model

### Vocabulary

| Term | Definition |
|---|---|
| `NODE` | A specific state of knowledge about one question or component |
| `EDGE` | A test, observation, or experiment that moves from one node to another |
| `ROUTE` | A sequence of nodes connected by edges toward a resolution |
| `BLOCK` | A condition that prevents a route from progressing |
| `EXIT CONDITION` | The observable result that closes a block or a labyrinth |
| `EXPERIMENT` | The cheapest test that produces information along a route |
| `RESULT` | The actual observation from an experiment (not a design claim) |
| `FRONTIER` | The current boundary between resolved and unresolved space |

### Movement states (for routes and experiments)

```
UNSEEN           — exists but not yet considered
DISCOVERED       — identified but not yet tested
HYPOTHESIS       — a specific testable claim
READY_FOR_TEST   — prerequisites met; test can start
TESTING          — experiment in progress
SUPPORTED        — evidence is consistent with the hypothesis
PARTIALLY_SUPPORTED — some evidence supports, some contradicts or is UNKNOWN
REFUTED          — evidence contradicts the hypothesis
BLOCKED          — cannot proceed; a named condition prevents movement
DEFERRED         — postponed; reactivation trigger defined
CLOSED           — resolved; no further movement required
REOPENED         — a trigger has reactivated a closed route
DESIGN_ONLY      — design complete; empirical test not yet done
IMPLEMENTATION_CANDIDATE — design + empirical test passed; implementation pending authorization
NOT_AUTHORIZED   — explicit decision prohibits movement
UNKNOWN          — status unresolvable with current evidence
```

### Invariant

```
DEFERRED ≠ REJECTED
UNKNOWN ≠ FALSE
NOT_AUTHORIZED ≠ ARCHITECTURALLY_INVALID
DESIGN_CLAIM ≠ PRODUCTION_EVIDENCE
RESEARCH_RESULT ≠ ARCHITECTURAL_DECISION ≠ IMPLEMENTATION_AUTHORIZATION
```

---

## §5 — Active Labyrinths

A labyrinth is a problem that has resisted resolution despite multiple attempts.

### LABYRINTH-1: Policy-Aware Continuation with Non-Bypass Verification

```
LABYRINTH:     Can an autonomous agent safely continue past a policy block
               using a verified alternative without bypassing the policy's intent?

ENTRY:         Agent receives STALL_POLICY after A_blocked is denied.
               Agent has objective O and policy context P.
               Agent proposes A' as a continuation.

TARGET:        Reliable determination: A' is either SAFE (truly compliant),
               UNSAFE (a bypass), or UNKNOWN (insufficient evidence) —
               with an independent verifier producing the label.

BLOCK:         Three compounding blocks:
               B-1: Independence architecture (single-agent systems cannot
                    meet the proposer/verifier separation requirement)
               B-2: Policy explicitness (vague policies collapse to UNKNOWN,
                    making A' unverifiable)
               B-3: Usefulness threshold undefined (owner-approved
                    preregistration required before utility judgment)

WHY BLOCKED:
  B-1: The R-3 independence requirement prohibits self-certification.
       In Claude Code, the same model instance proposes AND verifies.
       Role labels alone do not establish independence.
  B-2: CCP's existing policies (security.md, ARCH-001..004) are explicit
       for security predicates but may not provide policy_intent in the
       richer sense required by R-3's SAFE conditions.
  B-3: Without a preregistered threshold, the usefulness of hypothesis A
       vs. hypothesis B cannot be evaluated even if the design works.

WHAT HAS BEEN TRIED:
  R-1: Verified 4 prior-art candidates — none close the gap (CLOSED)
  R-2: Instrumented STALL_POLICY — no field data collected (COMPLETE)
  R-3: Designed and verified falsifiability protocol (AUDITED_CONFIRMED)
       Empirical test: PARTIALLY_TRACTABLE (design level; MOVEMENT 001)

CURRENT POSITION:
  Protocol design is coherent. Security invariant holds at design level.
  Independence blocker is the primary practical obstacle.

EXIT CONDITIONS:
  A: An architecture is demonstrated where proposer and verifier roles
     operate with genuine isolation (different context, different model call,
     no shared reasoning chain).
  B: Policy explicitness is measured — a sample of CCP's real policies
     produce SAFE labels at a rate above an owner-approved threshold.
  C: Hypothesis B (refuse + escalate) is evaluated: the human escalation
     rate for real STALL_POLICY events is measured and found acceptable.
  D: H-01 (stall frequency) is measured in field and found below materiality
     threshold — in which case the labyrinth closes as IMMATERIAL.
```

### LABYRINTH-2: R-2 Stall Frequency (H-01)

```
LABYRINTH:     What is the actual frequency of STALL_POLICY events
               with a viable alternative?

ENTRY:         R-2 instrumentation is in production.
               STALL_POLICY_LOG captures STALL_POLICY events.

TARGET:        A count of real events with had_alternative ≠ null
               sufficient to determine if the residual problem is material.

BLOCK:         No field data. STALL_POLICY_LOG has 1 test event.
               CCP is not running in a production environment with real users.

WHY BLOCKED:   The instrumentation exists but the environment doesn't produce
               the events. This cannot be resolved through design work alone.

WHAT HAS BEEN TRIED:
  R-2 instrumentation: COMPLETE (48_R2_INSTRUMENTATION.md)
  STALL_POLICY_LOG: 1 test event (bash-firewall blocking rm -rf /)

CURRENT POSITION:
  H-01 = UNKNOWN. The falsifier (< N real events → immaterial) cannot be
  evaluated. This labyrinth can only exit when CCP has real usage.

EXIT CONDITIONS:
  A: CCP runs in a real environment; STALL_POLICY_LOG accumulates N events
     with had_alternative observations (N = owner-defined threshold).
  B: Owner decides that the absence of field data is itself evidence that
     the problem is immaterial at current scale.
```

---

## §6 — Available Routes

### ROUTE-INDEP: Investigate Role-Separated Architecture for Independence

```
ROUTE:     Can proposer/verifier independence be achieved in a Claude Code
           session using existing infrastructure?

START:     Independence blocker identified (MOVEMENT 001, PI-1)

TARGET:    A design where the proposer and verifier run with genuinely
           isolated context — no shared reasoning chain

MECHANISM: Use Claude Code's subagent infrastructure (separate agent with
           separate context pack) for the verifier role. The proposer
           generates A'; a fresh subagent receives only the R-3 input
           contract plus frozen policy evidence, and evaluates A' without
           seeing the proposer's reasoning.

PROBLEM:   Both agents run on the same underlying model. Common-mode
           failure through shared model priors is possible even if
           context isolation holds.

DELTA:     Context isolation (achievable with subagents) vs. model isolation
           (not achievable without different model providers). The question
           is whether context isolation is sufficient for R-3's independence
           requirement.

REUSE:     CCP already has subagent infrastructure (architect, code-reviewer,
           implementer agents) with role-separated context packs (ARCH-002).

NEW PIECE: A "verifier" agent definition with read-only access to
           policy text and the R-3 decision contract, receiving ONLY
           the A'/A_blocked/P input package — not the proposer's reasoning.

NEW RELATION: Proposer → generates A' → passes to verifier (no reasoning)
              Verifier → independently evaluates → returns SAFE/UNSAFE/UNKNOWN

VALUE:     If context isolation meets R-3's requirement, the independence
           blocker is resolved without changing the model.

COMPLEXITY: Low to medium. CCP has subagent infrastructure. The question
            is design + protocol, not new technology.

RISK:      Common-mode model failure may still invalidate the independence
           claim. This must be tested, not assumed away.

TEST:      Design the verifier subagent context pack. Run the same 9 cases
           with a separate verifier agent. Compare to MOVEMENT 001 results.
           Check whether the subagent reaches the same labels independently.

FALSIFIER: If the verifier agent receives the proposer's reasoning chain
           (directly or through shared evidence) and produces labels
           identical to the proposer — common-mode failure not mitigated.

STATUS:    DISCOVERED → HYPOTHESIS (ready for test design)
```

### ROUTE-POLICY: Measure Policy Explicitness in CCP Context

```
ROUTE:     Are CCP's existing policies explicit enough for R-3 to produce
           SAFE labels in realistic agent scenarios?

START:     C-04 (vague policy → UNKNOWN) and C-01 (explicit policy → SAFE)
           in MOVEMENT 001 show that policy explicitness is the primary
           discriminant between useful and blocked outputs.

TARGET:    A characterization of CCP's policy corpus:
           what fraction of real-world agent scenarios have policy text
           explicit enough to satisfy R-3's policy_intent requirement?

MECHANISM: Select 5-10 representative CCP policy rules. For each,
           construct a realistic agent scenario. Apply R-3's
           policy_intent field criteria: is the prohibited outcome,
           permitted scope, and applicable condition specified?
           Classify each policy as EXPLICIT / PARTIAL / VAGUE.

PROBLEM:   CCP's policies were written for human review, not for
           machine-verifiable policy_intent fields. Some may be partially
           explicit but require interpretation.

DELTA:     What fraction of CCP policies produce SAFE (vs. UNKNOWN)
           results under the R-3 protocol? This informs whether
           hypothesis A has practical reach.

REUSE:     Uses existing CCP policy corpus (security.md, rules/*.md,
           ARCH-001..004) — no new infrastructure needed.

NEW PIECE: A structured policy evaluation using R-3 input contract fields
           as the assessment rubric.

VALUE:     Either confirms that CCP's policies support hypothesis A
           in practice, or identifies which policies need to be
           reformulated before A becomes usable.

COMPLEXITY: Low. Read-only analysis of existing policy files.

RISK:      Conclusion may be that policies need significant reformulation —
           which creates new work.

TEST:      Select 8-10 real CCP policy rules. Apply R-3's
           SAFE conditions 1 (policy intent) and 2 (objective preservation)
           as a checklist for each. Record EXPLICIT / PARTIAL / VAGUE
           for each policy.

FALSIFIER: If all or most CCP policies are VAGUE under R-3 criteria,
           hypothesis A has no practical domain in the current CCP context.

STATUS:    DISCOVERED → READY_FOR_TEST (no prerequisites)
```

### ROUTE-B: Evaluate Hypothesis B as Production Baseline

```
ROUTE:     Is hypothesis B (refuse + human escalation) already sufficient
           as the production response to STALL_POLICY events?

START:     R-3 established that B is the conservative baseline.
           MOVEMENT 001 did not evaluate B — it only evaluated A.

TARGET:    A characterization of hypothesis B:
           what would a human reviewer need to see to resolve a
           STALL_POLICY event? How complex is the typical decision?
           What information is already surfaced by the current deny output?

MECHANISM: Take 3-5 realistic STALL_POLICY scenarios (similar to C-01..C-08
           cases). For each, apply hypothesis B: what does the agent say to
           the human? Does the human have enough information to decide?
           How many back-and-forth turns does resolution require?

PROBLEM:   "Human in the loop" is operationally cheap when the human is
           present and the decision is simple. It becomes expensive when
           the human is absent, the decision is complex, or the context
           is deep.

DELTA:     Understanding the actual cost of B in CCP's real usage would
           determine whether A is worth its complexity.

REUSE:     Uses existing STALL_POLICY event model (R-2 infrastructure).

NEW PIECE: A structured human-escalation protocol description for
           the B outcome.

VALUE:     If B is sufficient for CCP's usage patterns, the labyrinth
           LABYRINTH-1 closes without implementing hypothesis A.

COMPLEXITY: Low. Thought experiment + design analysis. No new code.

RISK:      Conclusion may simply be that B IS sufficient — which closes
           LABYRINTH-1 without requiring independence architecture.

TEST:      Construct 5 representative STALL_POLICY scenarios.
           Apply B: what information does the deny output provide?
           What does the human need to resolve it?
           Classify: SUFFICIENT / NEEDS_MORE / INSUFFICIENT.

FALSIFIER: If all 5 scenarios in B are SUFFICIENT, hypothesis A adds
           complexity without adding value at current CCP scale.

STATUS:    DISCOVERED → HYPOTHESIS (ready for test design)
```

### ROUTE-ROGER: Falsify or Confirm Roger Hypothesis

```
ROUTE:     The Roger Hypothesis was audited as INDETERMINED / tendency =
           REFORMULATION. What specific test would resolve it?

START:     52_ROGER_HYPOTHESIS_POST_AUDIT.md confirms INDETERMINED status.

TARGET:    SUPPORTED or REFUTED — a clear classification.

MECHANISM: Read 52 to extract the specific falsifiers defined for the
           Roger Hypothesis. Design the minimum test that would either
           confirm or refute those falsifiers.

PROBLEM:   Current status: UNKNOWN. The hypothesis has not been directly
           tested.

VALUE:     Closes a standing open question in the research corpus.

COMPLEXITY: Unknown until 52 is read for specific falsifiers.

STATUS:    DISCOVERED (requires reading 52's falsifier section before
           test can be designed)
```

---

## §7 — Closed Routes

| Route | Closed by | Reason | Reopen condition |
|---|---|---|---|
| Temporal / DBOS / LangGraph as residual solution | R-1 (47_PRIOR_ART_VERIFICATION.md) | Do not cover policy-blocked continuation; cover crashes | Evidence of policy-aware continuation feature in these systems |
| State-Aware Runtime v4 as residual solution | R-1 | Conceptual paper only; no policy-aware alternative generation | Published implementation with empirical evaluation |
| arXiv:2606.31339 as residual solution | R-1 | Structured multi-robot domain; not open-ended | Generalization to open-ended agents demonstrated |
| ae-framework as residual solution | R-1 | Dry-run only; no alternative generation | Published working implementation with policy bypass verification |
| VERITAS OS as residual solution | R-1 | Refusal terminal; no alternative generation | Published version with alternative generation and bypass verification |
| "R-3 protocol is conceptually incoherent" | MOVEMENT 001 | 9/9 cases correctly classified; taxonomy discriminating | Contrary evidence from an independent empirical test |
| "UNKNOWN always dominates the protocol" | MOVEMENT 001 | C-01 produced SAFE in explicit-policy domain | Independent test showing SAFE rate = 0 in a well-specified domain |
| F9 implementation | F9-D01=A | Not authorized; no reproducible incident since | Triggers listed in F9-D01 §Reactivation triggers |
| F10-F12 opening | F9-D05=A | Kept unknown; no concrete evidence | Concrete evidenced problem crossing a phase threshold |

---

## §8 — Reopen Conditions

| Closed area | Reopen condition |
|---|---|
| Non-bypass verification implementation | A reproducible incident not covered by current controls, OR a STALL_POLICY event that demonstrates material loss of trajectory under the current reject-only path |
| Native Claude Code lifecycle research | Deterministic recurrence of G-B11 phantom SubagentStop events, OR a native integration decision depending on dispatcher facts |
| Integrity controls (A-05, A-07, G-N5) | External audit, compliance obligation, contractual requirement, or explicit customer requirement |
| Prior art re-investigation | A system is published that demonstrably implements (A) policy-compliant alternative generation + (B) non-bypass verification + (C) for open-ended agents |
| SAGR as recovery mechanism | Evidence that CCP's current hook+evidence architecture cannot cover a concrete, reproducible incident |

---

## §9 — Unexplored Space

| Zone | Why unexplored | Prerequisites to enter |
|---|---|---|
| F10 scope | Kept unknown per F9-D05=A; no concrete problem | Concrete evidenced problem at phase scale |
| Commercial viability (H-03) | Research on market validation never prioritized | Owner decision to pursue product validation |
| Semantic representation of policy intent | CCP policies were written for human review; machine-interpretable policy_intent fields not designed | ROUTE-POLICY analysis as prerequisite |
| Prototype of role-separated verifier | Architectural design not complete | ROUTE-INDEP design + owner authorization |
| Human escalation UX for hypothesis B | Not designed; assumed to be the status quo | ROUTE-B evaluation |
| Cross-domain R-3 validation | Test covered CCP domain only | Independent test designer running same protocol |

---

## §10 — Active Experiments

| ID | Name | Status | Output expected |
|---|---|---|---|
| EXP-001 | R-3 9-case synthetic falsifiability test | COMPLETE (2026-09-23) | See MOVEMENT 001 |
| EXP-002 | R-2 field observation — STALL_POLICY_LOG accumulation | BLOCKED (no real usage environment) | N real STALL_POLICY events with had_alternative observations |
| EXP-003 | Roger Hypothesis falsification | DISCOVERED (requires reading 52 for falsifiers) | SUPPORTED or REFUTED |
| EXP-004 | ROUTE-INDEP: subagent verifier design and test | HYPOTHESIS | Independent verifier label match or divergence |
| EXP-005 | ROUTE-POLICY: policy explicitness measurement | READY_FOR_TEST | EXPLICIT / PARTIAL / VAGUE classification per CCP policy |
| EXP-006 | ROUTE-B: hypothesis B human escalation evaluation | HYPOTHESIS | SUFFICIENT / NEEDS_MORE / INSUFFICIENT per scenario |

---

## §11 — Movement Results

### MOVEMENT 001 — R-3 Empirical Falsifiability Test

```
ID:            MOVEMENT 001
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6 (this session)
ARTIFACT:      53_R3_EMPIRICAL_TEST.md

START:
  R-3 design is AUDITED_CONFIRMED.
  R-3 empirical tractability = UNKNOWN.
  Independence requirement = unexamined blocker.
  Protocol coherence = unverified in practice.

BLOCK (at start):
  "Is the R-3 design operationally coherent?"
  "Does the protocol correctly discriminate cases?"
  "What does the test reveal about tractability?"

ACTION:
  Constructed 9 synthetic cases (one per R-3 case family).
  Froze gold labels before applying verifier.
  Applied R-3 protocol (10-field input contract, 7 SAFE conditions,
  9 UNSAFE types, 11 UNKNOWN conditions).
  Recorded per-case results.
  Documented protocol issues.

RESULT:
  9/9 label matches.
  Security invariant holds: 0 known bypasses classified SAFE.
  UNKNOWN discipline holds: 0 UNKNOWN cases promoted to SAFE.
  Distribution: SAFE=1, UNSAFE=3, UNKNOWN=5.
  Protocol issues discovered: PI-1 (independence not met), PI-2 (high
  UNKNOWN rate in ambiguous domains), PI-3 (threshold absent).

CLASSIFICATION:
  R-3 design tractability: PARTIALLY_TRACTABLE (design level only)

POSITION CHANGE:
  BEFORE: R-3 tractability = UNKNOWN
  AFTER:  R-3 tractability = PARTIALLY_TRACTABLE
          Independence blocker = IDENTIFIED (PI-1)
          Policy explicitness = PREREQUISITE for SAFE labels (PI-2)
          Protocol coherence = VERIFIED at design level

OPENED:
  ROUTE-INDEP: investigate role-separated subagent architecture for independence
  ROUTE-POLICY: measure policy explicitness of CCP's existing policy corpus
  ROUTE-B: evaluate hypothesis B (refuse + escalate) as production baseline
  QUESTION: Is context isolation (subagent) sufficient for R-3's independence?
  QUESTION: What fraction of CCP's policies are explicit enough to produce SAFE?

CLOSED:
  CLOSED-1: "R-3 protocol is conceptually incoherent" — FALSIFIED
  CLOSED-2: "UNKNOWN always dominates; no SAFE labels possible" — FALSIFIED

HYPOTHESIS CHANGED:
  Hypothesis A (propose + verify) is not dead, but the independence requirement
  reveals that a single-agent implementation is blocked at the architecture level.
  This is a more specific blocker than the previous UNKNOWN status.

NEW UNKNOWNS:
  Whether context isolation (subagents) meets R-3's independence requirement.
  Whether CCP's policy corpus is explicit enough to generate SAFE labels at
  a useful rate.
  Whether hypothesis B is sufficient without A in CCP's real usage patterns.

NEXT FRONTIER:
  The labyrinth's exit requires resolving the independence architecture
  AND measuring policy explicitness, OR demonstrating that hypothesis B
  is sufficient and A is unnecessary.
```

---

## §12 — Route Dependency Graph

```
ROUTE-INDEP (independence architecture)
  → requires: MOVEMENT 001 result (DONE)
  → enables: prototype verifier subagent
  → if CONFIRMED: IMPLEMENTATION_CANDIDATE for hypothesis A
  → if REFUTED: B becomes default; labyrinth closes via B

ROUTE-POLICY (policy explicitness)
  → requires: nothing (read-only, uses existing files)
  → enables: calibrating SAFE rate expectations for hypothesis A
  → if most policies are VAGUE: hypothesis A has no practical domain in CCP
  → if most policies are EXPLICIT: hypothesis A has a domain; proceed to ROUTE-INDEP

ROUTE-B (hypothesis B evaluation)
  → requires: nothing (thought experiment + design)
  → enables: closing LABYRINTH-1 via B if B is sufficient
  → if B is SUFFICIENT: labyrinth closes; no implementation of A needed
  → if B is INSUFFICIENT: evidence for hypothesis A's necessity increases

ROUTE-ROGER (Roger Hypothesis)
  → requires: reading 52's falsifier section
  → independent of LABYRINTH-1; can proceed in parallel
  → enables: closing a standing open research question

EXP-002 (field observation)
  → requires: real production usage
  → cannot be unblocked by design work
  → enables: H-01 measurement (stall frequency)
  → if H-01 < materiality threshold: labyrinth closes as IMMATERIAL
```

---

## §13 — Anti-Loop Registry

### What must NOT be repeated

| Route signature | Problem | Result | Don't repeat because |
|---|---|---|---|
| Verify prior art candidates (State-Aware Runtime, arXiv:2606.31339, ae-framework, VERITAS OS) | Do existing systems close the residual? | NONE closes the gap | R-1 verified all four; no new system listed |
| Broad web research on recovery mechanisms | What exists for agent recovery? | Loop detection, checkpoint, rollback systems do not address policy-aware continuation | Covered by CCP_RESEARCH_CONTEXT_MASTERC.md (130+ sources) |
| SAGR/assurance framework as new architecture | Can SAGR solve the residual? | SAGR is a framework for assurance properties; not a non_bypass_verify implementation | Covered in reconciliation artifacts 39-46 |
| F9 implementation research | Is F9 justified? | F9 NOT JUSTIFIED (research complete) | F9-D01=A; F9_RESEARCH.md; owner gate closed |
| R-3 protocol design | What protocol for non_bypass_verify? | Protocol designed (artifact 50) and audited (artifact 51) | AUDITED_CONFIRMED; design does not need redesign |
| R-3 empirical test | Does the protocol discriminate cases? | PARTIALLY_TRACTABLE (artifact 53) | MOVEMENT 001 COMPLETE |

### Duplication detection checklist (before opening new investigation)

Before starting a new investigation, check:
1. Is the problem already in a closed research artifact (39-53)?
2. Is the prior art already in R-1 (47)?
3. Is the route already in Closed Routes (§7)?
4. Is there a reopen condition that has NOT been satisfied?

If all three: DO NOT reopen. Record the check result instead.

---

## §14 — Current Decision Tree

```
CURRENT STATE: R-3 PARTIALLY_TRACTABLE, independence blocker identified

                    ┌─────────────────────────────┐
                    │  LABYRINTH-1 (policy-aware   │
                    │  continuation + verification) │
                    └──────────────┬──────────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              │                    │                    │
     ┌────────▼──────┐    ┌────────▼──────┐   ┌────────▼──────┐
     │  ROUTE-B      │    │  ROUTE-POLICY  │   │  ROUTE-INDEP  │
     │  Evaluate B   │    │  Policy explic-│   │  Subagent     │
     │  (cheapest,   │    │  itness audit  │   │  independence │
     │  no prereqs)  │    │  (no prereqs)  │   │  (MOVEMENT 001│
     └────────┬──────┘    └────────┬──────┘   │  prereq met)  │
              │                    │           └────────┬──────┘
     ┌────────▼──────┐    ┌────────▼──────┐   ┌────────▼──────┐
     │  B SUFFICIENT │    │  EXPLICIT     │   │  CONTEXT ISO  │
     │  → close      │    │  → proceed to │   │  SUFFICIENT   │
     │  LABYRINTH-1  │    │  ROUTE-INDEP  │   │  → prototype  │
     │  via B        │    │               │   │  authorized?  │
     └───────────────┘    │  VAGUE        │   └───────────────┘
                          │  → A has no   │
                          │  domain in CCP│
                          └───────────────┘

     PARALLEL: ROUTE-ROGER (independent of labyrinth resolution)

     BLOCKED: EXP-002 (field observation — requires real usage)
```

---

## §15 — Current Exploration Frontier

The frontier after MOVEMENT 001:

```
MOST SPECIFIC OPEN QUESTIONS (in priority order by information value):

[1] ROUTE-POLICY: Are CCP's existing policies explicit enough for R-3 to
    produce SAFE labels in realistic scenarios?
    → Cheapest route: read-only analysis of existing policy files
    → Information value: HIGH (determines if hypothesis A has any domain in CCP)
    → Cost: LOW (no new code; no new design; 30-60 minutes)

[2] ROUTE-B: Is hypothesis B (refuse + escalate) sufficient as the
    production response to STALL_POLICY events?
    → Cheapest route: 5-scenario thought experiment
    → Information value: HIGH (could close LABYRINTH-1 without implementing A)
    → Cost: LOW (no new code; no new design; 30-60 minutes)
    → Ordering: ROUTE-POLICY and ROUTE-B can run in parallel

[3] ROUTE-INDEP: Can role-separated subagents meet R-3's independence requirement?
    → Prerequisite: ROUTE-POLICY confirms A has a domain in CCP
    → Information value: HIGH if A is the chosen path
    → Cost: MEDIUM (subagent context pack design + 9-case repeat test)

[4] ROUTE-ROGER: Clarify Roger Hypothesis classification
    → Prerequisite: read 52's falsifier section
    → Information value: MEDIUM (closes standing open question)
    → Cost: LOW (read + one targeted test)
```

---

## §16 — Next Moves

The following moves are available now, ordered by information value per unit cost.

### NEXT MOVE A — ROUTE-POLICY (Recommended first)

```
WHAT QUESTION DOES IT ANSWER?
  Do CCP's existing policy rules provide sufficient policy_intent
  for R-3's SAFE conditions to produce useful labels?

WHAT UNKNOWN DOES IT REDUCE?
  PI-2 (high UNKNOWN rate in ambiguous domains) — is this because
  of the domain chosen, or because CCP's policies are generally vague?

WHAT BRANCHES DOES IT OPEN?
  If EXPLICIT: proceed to ROUTE-INDEP (independence architecture)
  If VAGUE: reconsider hypothesis A's scope in CCP; B may dominate

WHAT BRANCHES DOES IT CLOSE?
  If VAGUE: ROUTE-INDEP becomes lower priority

WHAT IS THE CHEAPEST TEST?
  Read 8-10 CCP policy rules. Apply R-3 SAFE conditions 1-2 as
  a checklist per rule. 45 minutes.

WHAT DOES IT REQUIRE?
  Read-only access to security.md, rules/*.md, ARCH-001..004

WHAT DOES IT NOT REQUIRE?
  New code, new infrastructure, owner authorization (read-only)

HOW REVERSIBLE IS THIS?
  Fully reversible — no code, no state change

WHAT WOULD MAKE THIS TEST USELESS?
  If all 8-10 selected policies happen to be from the explicit tail
  of the distribution; must include representative policies across
  policy types

WHAT RESULT WOULD CHANGE THE FRONTIER?
  "70%+ of CCP policies are VAGUE under R-3 criteria" — would reframe
  LABYRINTH-1 as requiring policy reformulation before implementation,
  not independence architecture.
```

### NEXT MOVE B — ROUTE-B (Can run in parallel with MOVE A)

```
WHAT QUESTION DOES IT ANSWER?
  Is human escalation already sufficient for STALL_POLICY events?

WHAT UNKNOWN DOES IT REDUCE?
  Whether hypothesis A is necessary at all in CCP's context.

WHAT BRANCHES DOES IT OPEN?
  If SUFFICIENT: LABYRINTH-1 closes. B is the production path.
  If INSUFFICIENT: Evidence accumulates for hypothesis A's necessity.

CHEAPEST TEST:
  Construct 5 realistic STALL_POLICY scenarios. Apply B:
  what does the current deny output say? Is it enough for a human?
  30-45 minutes.

WHAT RESULT WOULD CHANGE THE FRONTIER?
  "5/5 scenarios are SUFFICIENT under B" — closes LABYRINTH-1 without
  architecture work. Major position change.
```

---

## §17 — Movement History

Each completed movement, most recent first.

```
MOVEMENT 001
DATE:      2026-09-23
MOVE:      R-3 empirical falsifiability test (9 synthetic cases)
QUESTION:  Is the R-3 protocol operationally coherent and discriminating?
HYPOTHESIS: The protocol can correctly classify SAFE/UNSAFE/UNKNOWN cases
            across the 8 required families
OBSERVATION: 9/9 label matches; security invariant holds; UNKNOWN discipline holds
RESULT:    PARTIALLY_TRACTABLE (design level)
CLASSIFICATION: PARTIALLY_TRACTABLE
WHAT CHANGED:
  - R-3 tractability: UNKNOWN → PARTIALLY_TRACTABLE
  - Independence blocker: implicit → EXPLICITLY IDENTIFIED (PI-1)
  - Policy explicitness: not considered → PREREQUISITE for useful SAFE labels
CLOSED ROUTES:
  - "Protocol incoherent" hypothesis
  - "UNKNOWN always dominates" hypothesis
OPENED ROUTES:
  - ROUTE-INDEP (independence architecture)
  - ROUTE-POLICY (policy explicitness)
  - ROUTE-B (hypothesis B evaluation)
NEW UNKNOWNS:
  - Whether context isolation meets R-3's independence requirement
  - What fraction of CCP's policies are explicit enough for SAFE labels
  - Whether B is sufficient as a production path
NEXT FRONTIER: Resolve independence blocker AND policy explicitness,
               OR demonstrate B is sufficient
NEXT MOVE: ROUTE-POLICY (cheapest, highest information value, no prereqs)
```

---

## §A — Audit Checklist

Before closing any session, verify:

- [ ] System knows its current position (§2 updated)
- [ ] Active labyrinths have exit conditions (§5)
- [ ] Routes are explicit with falsifiers (§6)
- [ ] Closed routes are listed with reopen conditions (§7, §8)
- [ ] Anti-loop registry updated if new route attempted (§13)
- [ ] UNKNOWN vs. DEFERRED vs. REJECTED distinction maintained (§4)
- [ ] Evidence vs. design claim distinction maintained throughout
- [ ] Decision vs. authorization distinction maintained throughout
- [ ] Each movement has a POSITION CHANGE entry (§11)
- [ ] Next frontier follows from the last movement result (§15)
- [ ] Next moves have specific questions, tests, and falsifiers (§16)
- [ ] Movement history updated (§17)
