# CCP Exploration Engine

> Version: 1.1 | Last updated: 2026-09-23
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
ROGER HYPOTHESIS:  REFORMULATION_CONFIRMED (tendency strengthened; MOVEMENT 002)

POLICY CORPUS:     25 policies identified; 20 EXPLICIT (83%), 4 PARTIAL, 1 META
INDEPENDENCE:      Context isolation via subagents = SUFFICIENT for R-3 (MOVEMENT 002)
HYPOTHESIS B:      CONDITIONALLY_SUFFICIENT at current scale (MOVEMENT 002)

PRIMARY BOTTLENECK: Authorization gate (F9-D01=A) + Materiality (H-01 unknown)

IMPLEMENTATION_READY: false
NEXT_ALLOWED_PHASE:   Owner-driven decision required
NEXT_MOVEMENT:        MOVEMENT 003 — Incremental Improvement Scoping
```

---

## §3 — Current Frontier

The frontier is the boundary between what is known and what is not yet resolved.

```
KNOWN (closed — additions from MOVEMENT 002)
├── F1-F8 architecture and verification
├── R-1 prior art (four candidates do not close residual)
├── R-2 instrumentation (operational, no field data)
├── R-3 design (AUDITED_CONFIRMED, 9-case empirical test COMPLETE)
├── R-3 security invariant holds (design level)
├── R-3 UNKNOWN discipline holds (design level)
├── Protocol coherence: VERIFIED (design level)
├── Independence blocker: RESOLVED (context isolation via subagents sufficient)
├── Policy explicitness: RESOLVED (83% of CCP policies explicit; 4 PARTIAL with repair paths)
├── Hypothesis B: CONDITIONALLY_SUFFICIENT at current CCP scale
├── Roger Hypothesis: REFORMULATION_CONFIRMED (not a new architecture or capability)
└── Problem formulation: more tractable reformulations identified (effect-centric, evidence-centric)

FRONTIER (new boundary after MOVEMENT 002)
├── CDT-01: Does policy repair increase R-3 SAFE rate to >85%? (available now)
├── NH-02: Do 3–5 bash-firewall extensions cover CCP semantic bypass domain? (available now)
├── UNK-M2-04: Which incremental improvements are within F9-D01=A boundary? (owner decision)
├── NH-01: Can evidence-centric mid-task tracking partially close LABYRINTH-1? (owner scoping)
├── CDT-02: Blind subagent verifier confirmation (requires agent file → F9-D01 gate)
└── H-01 (stall frequency): still blocked — requires real usage environment

UNKNOWN (unchanged)
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
STATUS:    PARTIALLY_RESOLVED (MOVEMENT 002) — CDT-02 needed for empirical confirmation

RESULT:    Independence model analyzed in depth (54_MOVEMENT_002 §13–16).

KEY FINDING: R-3's independence requirement uses "person" not "model".
             Context isolation via subagents satisfies the written requirement.
             6 of 7 independence dimensions are achievable with CCP's subagent infrastructure.
             Model isolation (dimension 7) is NOT achievable without different model providers,
             but R-3 does not require it.

COMMON-MODE FAILURE: Real risk, but mitigated by R-3's explicit UNSAFE taxonomy:
                     verification is rule-based for explicit policies → reduces judgment calls
                     where shared model priors matter most.

BLIND VERIFIER DESIGN: Protocol designed (§15). For cases with explicit policy_intent
                       and complete input contracts, blind verification produces same results
                       as non-blind verification.

REMAINING OPEN: CDT-02 (empirical test with actual subagent verifier) not yet executed.
                Requires new agent definition file → NOT_AUTHORIZED per F9-D01=A.

ARCHITECTURE: AC-03 (subagent verifier) is the implementation candidate.
              NOT AUTHORIZED under current F9-D01=A; requires owner decision for new agent.

ARTIFACT:  54_MOVEMENT_002_FRONTIER_RESOLUTION.md §13–16, §25 AC-03

REOPEN CONDITION (for CDT-02): Owner authorizes new agent definition file.
```

### ROUTE-POLICY: Measure Policy Explicitness in CCP Context

```
STATUS:    CLOSED / RESOLVED (MOVEMENT 002)

RESULT:    25-policy corpus analyzed. 20 of 24 actionable policies (83%) are EXPLICIT
           under R-3 criteria. 4 are PARTIAL with identified repair paths (one sentence
           of disambiguation each). 1 is a META-RULE governing classification behavior.

RCE TEST:  8 real-CCP scenarios: SAFE=6, UNKNOWN=1, UNSAFE=1 (75% SAFE rate).
           High UNKNOWN rate in MOVEMENT 001 was an artifact of test case design,
           not a CCP-wide property.

POLICY REPAIR: AC-02 (draft disambiguation text for 4 PARTIAL policies) identified
               as a documentation-level improvement. Each repair = one sentence.

FINDING:   CCP's policies DO support hypothesis A in the explicit-policy domain.
           Policy explicitness is NOT the primary blocker.

ARTIFACT:  54_MOVEMENT_002_FRONTIER_RESOLUTION.md §5–12

REOPEN CONDITION: Counter-evidence showing >50% PARTIAL policies in a representative
                  random sample of real CCP scenarios (not synthetic test cases).
```

### ROUTE-B: Evaluate Hypothesis B as Production Baseline

```
STATUS:    CLOSED / CONDITIONALLY_SUFFICIENT (MOVEMENT 002)

RESULT:    5-scenario evaluation complete.
           SUFFICIENT: STA-01 (secrets), STA-03 (git push), STA-04 (supply chain)
           NEEDS_MORE: STA-02 (evidence contract — information quality gap)
           DELAYED: STA-05 (phase freeze — no hook coverage; caught at review)

FINDING:   B is the CURRENT PRODUCTION PATH for hook-enforced stalls.
           B is SUFFICIENT for 3/5 hook-enforced stall classes at current CCP scale.
           B's primary weakness is information quality in complex cases (STA-02),
           not structural insufficiency. This is addressable as B+ (AC-01).

IMPLICATION: LABYRINTH-1 does not require hypothesis A for current CCP scale.
             If H-01 (stall frequency) remains low, B is the permanent production path.

AC-01:     Enhanced-B (richer denial messages) identified as improvement path.
           Requires hook schema extension → NOT_AUTHORIZED per F9-D01=A.
           Requires owner decision.

ARTIFACT:  54_MOVEMENT_002_FRONTIER_RESOLUTION.md §17–18

REOPEN CONDITION: A class of CCP stall scenarios where even richer information
                  does not enable human resolution, OR H-01 exceeds materiality threshold.
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

STATUS:    CLOSED / REFORMULATION_CONFIRMED (MOVEMENT 002)

RESULT:    Concrete falsification test executed (54_MOVEMENT_002 §19).
           CCP's existing artifact+registry system handles the "representation
           reactivation with causal history preservation" scenario that Roger proposes.
           Roger = formalization of CCP's implicit model. No new capability.
           F7 (no test distinguishing Roger): PARTIALLY SATISFIED.
           F5 ("native" has no operational definition): still technically true;
           but concrete scenario shows the distinction is immaterial for CCP.

ARTIFACT:  54_MOVEMENT_002_FRONTIER_RESOLUTION.md §19

REOPEN CONDITION: Concrete observable transition Roger performs that CCP's
                  artifact+registry model cannot.
```

---

## §7 — Closed Routes

| Route | Closed by | Reason | Reopen condition |
|---|---|---|---|
| Temporal / DBOS / LangGraph as residual solution | R-1 (47_PRIOR_ART_VERIFICATION.md) | Do not cover policy-blocked continuation; cover crashes | Evidence of policy-aware continuation feature in these systems |
| State-Aware Runtime v4 as residual solution | R-1 | Conceptual paper only; no policy-aware alternative generation | Published implementation with empirical evaluation |
| arXiv:2606.31339 as residual solution | R-1 | Structured multi-robot domain; not open-ended | Generalization to open-ended agents demonstrated |
| ae-framework as residual solution | R-1 | Dry-run only; no alternative generation | Published working implementation with policy bypass verification |
| ROUTE-POLICY (policy explicitness) | MOVEMENT 002 (54_MOVEMENT_002) | 83% of CCP policies are EXPLICIT; 4 PARTIAL have repair paths; high UNKNOWN rate in MOVEMENT 001 was artifact of test design | Counter-evidence showing >50% PARTIAL in representative sample |
| ROUTE-B (hypothesis B sufficiency) | MOVEMENT 002 (54_MOVEMENT_002) | B is CONDITIONALLY_SUFFICIENT at current scale; information quality (not structure) is the improvement target | Class of stalls where even richer information cannot enable human resolution |
| ROUTE-ROGER (Roger Hypothesis) | MOVEMENT 002 (54_MOVEMENT_002) | REFORMULATION confirmed via concrete falsification scenario; CCP artifact+registry already handles the proposed pattern | Concrete observable transition Roger performs that CCP model cannot |
| "CCP policies too vague for R-3" | MOVEMENT 002 | Falsified: 83% explicit rate established via full corpus analysis | Representative sample showing >50% PARTIAL |
| "Independence requires model isolation" | MOVEMENT 002 | R-3 uses "person" not "model"; context isolation satisfies written requirement | R-3 post-audit requiring model independence; or controlled test showing common-mode failure for rule-based explicit-policy cases |
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

### MOVEMENT 002 — Frontier Resolution Expedition

```
ID:            MOVEMENT 002
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6 (this session)
ARTIFACT:      54_MOVEMENT_002_FRONTIER_RESOLUTION.md

START:
  R-3 PARTIALLY_TRACTABLE.
  Three compounding blockers: B-1 (independence), B-2 (policy explicitness), B-3 (threshold).
  Open routes: ROUTE-POLICY, ROUTE-B, ROUTE-INDEP, ROUTE-ROGER.

QUESTION:  What is the true limiting factor for LABYRINTH-1?

ACTION:
  Full CCP policy corpus enumerated (25 policies).
  Per-policy semantic completeness analysis (EXPLICIT/PARTIAL/META).
  Policy composition and precedence analysis.
  8 real-CCP-policy RCE test cases evaluated.
  Policy ablation test to find minimum semantic core.
  Policy repair experiment for 4 PARTIAL policies.
  Independence model analysis (7 dimensions).
  Independence threat model (common-mode failure scenarios).
  Blind verifier protocol designed.
  5-scenario Hypothesis B evaluation against real CCP stall types.
  Roger Hypothesis concrete falsification test.
  Cross-domain analysis (aviation, medical, formal methods, PLC/SCADA).
  6 representation shifts and 5 problem reframings investigated.
  4 architecture candidates generated.
  Combinatorial synthesis of 3 candidate combinations.

RESULT:
  ROUTE-POLICY: RESOLVED — 83% explicit, 4 PARTIAL with repair paths
  ROUTE-B: CONDITIONALLY_SUFFICIENT at current scale
  ROUTE-ROGER: REFORMULATION_CONFIRMED
  ROUTE-INDEP: PARTIALLY_RESOLVED — CDT-02 still needed

  PRIMARY BOTTLENECK: Authorization (F9-D01=A) + Materiality (H-01 unknown)
  The architecture blockers B-1 and B-2 are substantially smaller than assessed.

POSITION CHANGE:
  BEFORE: Three equal blockers unknown in magnitude
  AFTER:  Architecture blockers partially resolved; authorization/materiality confirmed as the real gate
          LABYRINTH-1 is exitable incrementally via AC-01+AC-02 without full non_bypass_verify

OPENED:
  CDT-01: Policy repair test (available now, no auth needed)
  NH-02: Bash-firewall semantic bypass coverage analysis (available now)
  UNK-M2-04: F9-D01 boundary for incremental improvements (owner decision)
  NH-01: Evidence-centric mid-task tracking (owner scoping)
  CDT-02: Blind verifier test (requires owner decision for agent file)

CLOSED:
  ROUTE-POLICY (policies largely explicit)
  ROUTE-B (conditionally sufficient)
  ROUTE-ROGER (reformulation confirmed)
  "CCP policies too vague for R-3" (falsified)
  "Independence requires model isolation" (weakened/resolved)

NEW HYPOTHESES:
  NH-01: Evidence-centric mid-task tracking can partially close LABYRINTH-1
  NH-02: 3–5 bash-firewall extensions cover CCP semantic bypass domain
  NH-03: Authorization gate (not architecture) is the real bottleneck

NEW UNKNOWNS:
  UNK-M2-01..06 (see §11 archive artifact)

NEXT FRONTIER:  Incremental Improvement Decision Gate
NEXT MOVEMENT:  MOVEMENT 003 — Incremental Improvement Scoping
```

---

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

The frontier after MOVEMENT 002:

```
MOST SPECIFIC OPEN QUESTIONS (in priority order by information value):

[1] CDT-01: Does policy repair increase R-3 SAFE rate to >85%?
    → AVAILABLE NOW (read-only; no authorization needed)
    → Information value: HIGH (calibrates AC-03 value estimate; closes UNK-M2-03)
    → Cost: LOW (draft repair text for 4 PARTIAL policies; re-run RCE set; 45 min)

[2] NH-02: Do 3–5 bash-firewall extensions cover CCP's semantic bypass domain?
    → AVAILABLE NOW (analysis only; no code change)
    → Information value: HIGH (could close semantic bypass risk without full non_bypass_verify)
    → Cost: LOW (enumerate bypass patterns from research corpus; check coverage; 30 min)

[3] UNK-M2-04: Which incremental improvements are within F9-D01=A authorization boundary?
    → REQUIRES OWNER DECISION
    → Information value: VERY HIGH (unblocks AC-01, AC-02, NH-01, NH-02 implementation)
    → Cost: LOW (present concrete scope descriptions to owner; get yes/no per item)

[4] CDT-02: Blind subagent verifier empirical confirmation
    → REQUIRES OWNER AUTHORIZATION (new agent file → F9-D01 gate)
    → Information value: HIGH (confirms independence claim empirically)
    → Cost: MEDIUM after authorization (agent definition + 8-case test)

[5] H-01: Real stall frequency measurement
    → BLOCKED (no real usage environment; EXP-002 blocked)
    → Information value: MAXIMUM if material (could close LABYRINTH-1 as IMMATERIAL)
    → Cost: ZERO design cost; requires real usage
```

---

## §16 — Next Moves

The following moves are available now, ordered by information value per unit cost. (Updated after MOVEMENT 002.)

### NEXT MOVE A — CDT-01: Policy Repair Test (Available now)

```
WHAT QUESTION DOES IT ANSWER?
  Does disambiguating CCP's 4 PARTIAL policies increase the R-3 SAFE rate
  from 75% (current) to >85%?

WHAT UNKNOWN DOES IT REDUCE?
  UNK-M2-03: whether policy text repair is the remaining bottleneck for SAFE labels

WHAT BRANCHES DOES IT OPEN?
  If SAFE rate >85%: policy corpus is effectively complete; AC-03 has full domain coverage
  If SAFE rate stays ~75%: model uncertainty is the remaining factor; B+ may dominate

WHAT BRANCHES DOES IT CLOSE?
  If SAFE rate >85%: closes the "policy quality" as remaining uncertainty

WHAT IS THE CHEAPEST TEST?
  Draft one-sentence disambiguation for each of the 4 PARTIAL policies.
  Re-run RCE-01..08 with repaired policies. Compare SAFE rate.
  45 minutes. Read-only test (no file modification needed).

WHAT DOES IT REQUIRE?
  Draft repair text for POL-05, POL-08, POL-13; re-run RCE set

WHAT DOES IT NOT REQUIRE?
  New code, new infrastructure, owner authorization (analysis only)

WHAT RESULT WOULD CHANGE THE FRONTIER?
  "SAFE rate rises to >85% after policy repair" — confirms AC-02 has high ROI;
  makes the case for presenting AC-02 to owner for authorization.
```

### NEXT MOVE B — NH-02: Bash-Firewall Semantic Bypass Coverage (Available now)

```
WHAT QUESTION DOES IT ANSWER?
  Can 3–5 additional bash-firewall patterns cover CCP's semantic bypass domain
  without implementing a full semantic verifier?

WHAT UNKNOWN DOES IT REDUCE?
  Whether semantic bypass risk is concentrated (addressable by extension) or
  diffuse (requires general verifier)

WHAT BRANCHES DOES IT OPEN?
  If concentrated: AC-02-style hook extension is sufficient for CCP's domain
  If diffuse: AC-03 (full semantic verifier) is necessary

CHEAPEST TEST:
  Enumerate semantic bypass patterns from MOVEMENT 001 cases (C-02, C-03)
  and MOVEMENT 002 analysis. Check whether they reduce to ≤10 concrete patterns.
  30 minutes. Analysis only.

WHAT RESULT WOULD CHANGE THE FRONTIER?
  "3–5 patterns cover 90%+ of CCP's semantic bypass domain" — closes the semantic
  bypass risk without full non_bypass_verify implementation.
```

### NEXT MOVE C — Owner Scoping Decision (Requires owner input)

```
WHAT QUESTION DOES IT ANSWER?
  Which of AC-01, AC-02, NH-01, NH-02 are within the current F9-D01=A boundary?

WHY THIS IS HIGH VALUE:
  Authorization gate (F9-D01=A) is the primary blocker for all incremental improvements.
  Owner can unblock multiple improvements with one scoping decision.

WHAT TO PRESENT TO OWNER:
  AC-01: hook schema extension (probable PROHIBITED — modifies hooks)
  AC-02: rule text disambiguation (AMBIGUOUS — "rule" vs "documentation"?)
  NH-01: STALL_POLICY_LOG schema extension (probable PROHIBITED — hook-adjacent)
  NH-02: bash-firewall pattern extension (probable PROHIBITED — hook modification)
  Documentation drafts: reviewing AC-02 repair text (PERMITTED — read-only)
```

---

## §17 — Movement History

Each completed movement, most recent first.

```
MOVEMENT 002
DATE:      2026-09-23
MOVE:      Frontier Resolution Expedition (policy corpus, independence, Hypothesis B, Roger)
QUESTION:  What is the true limiting factor for LABYRINTH-1?
HYPOTHESIS: Architecture blockers (B-1, B-2) are smaller than assessed; authorization + materiality are the real gate
OBSERVATION: 83% CCP policies explicit; context isolation sufficient for R-3; B conditionally sufficient; Roger = reformulation
RESULT:    PRIMARY BOTTLENECK = Authorization gate (F9-D01=A) + Materiality (H-01 unknown)
CLASSIFICATION: LABYRINTH-1 PARTIALLY_RESOLVED at architecture level; authorization gate confirmed
WHAT CHANGED:
  - Policy explicitness: UNKNOWN → 83% EXPLICIT (4 PARTIAL with repair paths)
  - Independence (B-1): ARCHITECTURAL BLOCKER → PARTIALLY_RESOLVED (context isolation sufficient)
  - Hypothesis B: UNTESTED → CONDITIONALLY_SUFFICIENT at current scale
  - Roger Hypothesis: INDETERMINED → REFORMULATION_CONFIRMED
  - Problem formulation: more tractable reformulations identified (RF-02, RF-03, RF-04)
CLOSED ROUTES:
  - ROUTE-POLICY (resolved)
  - ROUTE-B (conditionally sufficient)
  - ROUTE-ROGER (reformulation confirmed)
  - "CCP policies too vague" falsifier
  - "Independence requires model isolation" falsifier
OPENED ROUTES:
  - CDT-01: policy repair test (available now)
  - NH-02: bash-firewall coverage analysis (available now)
  - UNK-M2-04: owner scoping decision
  - CDT-02: blind verifier test (after owner decision)
NEW HYPOTHESES:
  NH-01: evidence-centric mid-task tracking
  NH-02: 3–5 bash-firewall extensions sufficient
  NH-03: authorization is the real bottleneck
NEXT FRONTIER: Incremental Improvement Decision Gate
NEXT MOVE:     CDT-01 + NH-02 (available now, in parallel)
```

---

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
