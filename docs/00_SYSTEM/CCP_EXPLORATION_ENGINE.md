# CCP Exploration Engine

> Version: 1.6 | Last updated: 2026-09-23
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

STALL_POLICY_LOG:  3 events: 1 test (rm -rf / maintenance), 2 FP from MOVEMENT 007 PAC experiment
                   H-01 real events = 2 (BOTH FALSE POSITIVES — PAC-EF-02 pattern-name-in-literal)
                   H-01 genuine bypass events = 0 (no real bypasses observed)
ROGER HYPOTHESIS:  REFORMULATION_CONFIRMED (tendency strengthened; MOVEMENT 002)

POLICY CORPUS:     25 policies identified; 20 EXPLICIT (83%), 4 PARTIAL, 1 META
INDEPENDENCE:      Context isolation via subagents = SUFFICIENT for R-3 (MOVEMENT 002)
HYPOTHESIS B:      CONDITIONALLY_SUFFICIENT at current scale (MOVEMENT 002)

PRIMARY BOTTLENECK: Authorization gate (F9-D01=A) + Materiality (H-01 unknown)

CDT-01:             COMPLETE — SAFE rate 87.5% after policy repair (vs. 75% baseline; EXPERIMENTAL)
NH-02:              COMPLETE — PARTIALLY_SUPPORTED; 4 patterns cover ~75–80% practical bypass surface
NH-03:              CONFIRMED — authorization gate is the real bottleneck
NH-04:              PARTIALLY_SUPPORTED — P1'+P2'+P3 cover 6/15 corpus; ${VAR} gap identified; P4 inadvisable (FP)
AC-02 ROI:          CONFIRMED HIGH; policy repairs validated and specified (56_MOVEMENT_003 §7)
BYPASS TAXONOMY:    4 upper families (Observation, Transformation, Storage, Transport)
STATIC BOUNDARY:    6-level detection spectrum; Level-1 tokenizer normalization is new intermediate (LOW complexity)
LABYRINTH-1 L1-C:   5 CONDITIONS SPECIFIED (57_MOVEMENT_004 §9); minimal vs. strong closure distinguished
POLICY PRECEDENCE:  NO active unresolved conflicts beyond POL-08/F9-D01=A (resolved); CONFLICT-04 is missing spec
ALIASING:           Variable aliasing bypasses ALL proposed patterns; requires session taint tracking
NH-05:              PARTIALLY_SUPPORTED — shlex is tokenizer not AST; ${VAR} needs separate regex (57_ §3)
NH-06:              PARTIALLY_SUPPORTED — no active conflicts; CONFLICT-04 = missing spec; doc forward-value (57_ §4)
NH-07:              SUPPORTED — enhanced-B closes INFORMATION GAP for STA-02; not judgment gap; ≠ AC-03 (57_ §5)
NH-09 (NEW):        SUPPORTED — 2 sed normalizations achieve Level-1 coverage; zero dependencies; LOW complexity (57_ §3.4)
NH-10 (NEW):        IMPLEMENTED — escalation path added to CONTROL_PLANE_HANDBOOK §12 (MOVEMENT 005)
UNK-M4-01:          RESOLVED — NH-09 is SAFE_NORMALIZATION; 4 limitations documented (58A §5)
CONFLICT-04:        RESOLVED — NH-10 closes the process gap; no missing spec (MOVEMENT 005)
L1-C Condition 3:   SATISFIED — escalation path documented (MOVEMENT 005)
NH-11 (NEW):        HYPOTHESIS — single-quote normalization (extend Step 1 to remove single quotes)
                    NOT ON AUTHORIZED PATH; logged for future consideration
CCP MINIMAL STACK:  Layers 0-6 defined as complete detection-to-escalation architecture (57_ §6.2)
READY PACKAGES:     READY-01/02/03/04 fully structured as owner decision documents (57_ §10; 58_ consolidated)
PAC PROTOTYPE:      COMPLETE (docs/research/pac/) — 13 policies in YAML; compiler functional; no drift detected
P1'/P2' SPEC:       RESOLVED — 59A §2.2 placeholder filled; exact regex in 60_FRONTIER_BREAKOUT.md §C2
PAC-EF-02:          NEW FINDING — false positive class "PATTERN_NAME_IN_LITERAL" discovered experimentally
N THRESHOLD:        N = 1 RECOMMENDED (analysis in 60A_IDEA_PORTFOLIO.md §A3) — but see PAC-EF-02 note
H-01 FP NOTE:       Current H-01 count = 2; BOTH are PAC experiment FPs; zero genuine bypass events
HRQS GAP:           IDENTIFIED — human review has no quality standard for evaluating blocked commands

IMPLEMENTATION_READY: false
NEXT_ALLOWED_PHASE:   Owner-driven decision required (READY-01/02/03); 3 authorized improvements available NOW
LAST_MOVEMENT:        MOVEMENT 008 (2026-09-23) — HRQS checklist added to handbook; PAC corpus completed (23 policies);
                      CCP Complete Handoff (61_*) created and committed; all M001-M007 artifacts staged
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

FRONTIER (new boundary after MOVEMENT 004)
├── [CLOSED] CDT-01: SAFE rate 87.5% — CONFIRMED
├── [CLOSED] NH-02: 4 patterns cover ~75–80% — PARTIALLY_SUPPORTED
├── [CLOSED] NH-04: P1'+P2'+P3 cover 6/15 corpus; ${VAR} gap; P4 inadvisable — PARTIALLY_SUPPORTED
├── [CLOSED] NH-05: PARTIALLY_SUPPORTED — shlex is tokenizer not AST; ${VAR} gap needs separate step
├── [CLOSED] NH-06: PARTIALLY_SUPPORTED — no active conflicts; CONFLICT-04 = missing spec, not precedence
├── [CLOSED] NH-07: SUPPORTED (information gap for STA-02) — not AC-03 substitute
├── [CLOSED] NH-09: SUPPORTED — 2 sed normalizations achieve Level-1 (zero dependencies; LOW complexity)
├── [CLOSED] NH-10: CONFIRMED — escalation path = handbook addition; no auth needed
├── [CLOSED] L1-C conditions: 5 conditions specified; minimal vs. strong distinguished (57_ §9)
├── [CLOSED] READY packages: READY-01/02/03/04 fully structured (57_ §10)
├── NH-08: Semantic bypass problem not material — HYPOTHESIS; UNFALSIFIABLE (needs H-01)
├── [CLOSED] NH-10: IMPLEMENTED (MOVEMENT 005 — handbook §12)
├── [CLOSED] UNK-M4-01: RESOLVED — SAFE_NORMALIZATION (58A §5); NH-09 INVARIANT CONFIRMED (59_)
├── [CLOSED] CONFLICT-04: RESOLVED — NH-10 closes process gap
├── CDT-02: Blind subagent verifier confirmation — DEFERRED (new agent authorization required)
└── H-01 (stall frequency): ENVIRONMENT_BLOCK — requires real usage environment

OWNER DECISION GATES (classified separately from BLOCKERS):
├── READY-01: AC-02 authorization question — OWNER_DECISION_READY
│             NOTE: repairs are NOT uniformly "documentation-only" (59_ Finding A)
│             Decision question corrected in 58_ (MOVEMENT 006)
├── READY-02: P1'+P2' + Level-1 normalization — OWNER_DECISION_READY
│             NOTE: Exact P1'/P2' regex resolved (60_FRONTIER_BREAKOUT.md §C2)
│             ENHANCED URGENCY (M007): Current H-01 FP events hard to classify without READY-04 messages
├── READY-03: LABYRINTH-1 L1-C closure — OWNER_DECISION_READY
│             NOTE: N threshold required as part of acceptance (59_ Finding B)
│             RISK label corrected to UNKNOWN in 58_ (MOVEMENT 006)
│             RECOMMENDATION: N = 1 (see 60A §A3); but be aware current H-01=2 is ALL FPs (PAC-EF-02)
└── READY-04: Enhanced-B message implementation — OWNER_DECISION_READY
              NOTE (M007): URGENCY ELEVATED — FP classification requires enhanced messages;
              PAC-EF-02 FPs would be hard to classify without enhanced denial context

NOW-EXECUTABLE (no owner authorization needed):
├── [DONE M008] HRQS: Human Review Quality Standard — checklist added to handbook §12 (STALL subsection)
├── [DONE M008] PAC corpus: Complete — 23 policies in YAML (21 enforced + 2 proposed/READY-02)
└── [DONE M007] query-log.sh: H-01 monitoring tool — CREATED (docs/00_SYSTEM/query-log.sh)

ENVIRONMENT BLOCKS:
├── H-01 materiality: requires real usage environment
├── P1'/P2' production FP rate: requires real usage
├── Production bypass frequency: requires real usage
└── Native Claude Code lifecycle: NOT_VERIFIED (deferred per F9-D02=B)

UNKNOWN (unchanged):
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
| EXP-003 | Roger Hypothesis falsification | COMPLETE (MOVEMENT 002) | REFORMULATION_CONFIRMED |
| EXP-004 | ROUTE-INDEP: subagent verifier design and test | PARTIALLY_RESOLVED (MOVEMENT 002); CDT-02 needed for empirical confirmation | Independent verifier label match or divergence |
| EXP-005 | ROUTE-POLICY: policy explicitness measurement | COMPLETE (MOVEMENT 002) | 83% EXPLICIT; 4 PARTIAL; see 54_MOVEMENT_002 |
| EXP-006 | ROUTE-B: hypothesis B human escalation evaluation | COMPLETE (MOVEMENT 002) | CONDITIONALLY_SUFFICIENT; see 54_MOVEMENT_002 §17–18 |
| EXP-007 | CDT-01: policy repair SAFE rate test | COMPLETE (2026-09-23) | 87.5% SAFE rate (vs. 75% baseline); see 55_CDT01_NH02_RESULTS.md §1 |
| EXP-008 | NH-02: bash-firewall semantic bypass coverage | COMPLETE (2026-09-23) | PARTIALLY_SUPPORTED; 4 patterns cover ~75–80%; see 55_CDT01_NH02_RESULTS.md §2 |
| EXP-009 | NH-04: P1'+P2'+P3 deep evaluation (corpus, mutations, FP, 3vs4) | COMPLETE (2026-09-23) | PARTIALLY_SUPPORTED; 6/15 corpus; ${VAR} gap; P4 inadvisable; see 56_MOVEMENT_003 §3 |
| EXP-010 | Bypass taxonomy expansion (Track B) | COMPLETE (2026-09-23) | 4-family taxonomy; 6-level detection spectrum; aliasing undetectable by regex; see 56_ §4,§5,§6 |
| EXP-011 | Policy repair adversarial validation (Track E) | COMPLETE (2026-09-23) | All repairs better; residual ambiguity in each; see 56_ §7 |
| EXP-012 | Owner gate decomposition (Track G) | COMPLETE (2026-09-23) | Minimum decision per improvement identified; READY-01/02/03 specified; see 56_ §9,§19 |
| EXP-013 | NH-05 shlex normalization test | COMPLETE (2026-09-23) | PARTIALLY_SUPPORTED; shlex is tokenizer not AST; ${VAR} needs separate regex; see 57_ §3 |
| EXP-014 | NH-06 policy precedence pair analysis | COMPLETE (2026-09-23) | PARTIALLY_SUPPORTED; no active conflicts; CONFLICT-04 = missing spec; see 57_ §4 |
| EXP-015 | NH-07 enhanced denial message design | COMPLETE (2026-09-23) | SUPPORTED (information gap); not AC-03 substitute; see 57_ §5 |
| EXP-016 | NH-09 2-regex Level-1 normalization test | COMPLETE (2026-09-23) | SUPPORTED analytically; M1.3/M2.1/M3.1 closed; zero deps; LOW complexity; see 57_ §3.4 |
| EXP-017 | NH-10 escalation path authorization scope | COMPLETE (2026-09-23) | CONFIRMED; handbook addition = permitted now; no auth needed; see 57_ §4.3 |
| EXP-018 | UNK-M4-01 double-quote removal semantic accuracy | COMPLETE (2026-09-23) | SAFE_NORMALIZATION; 4 documented limitations; invariant verified; see 58A_NH09_SEMANTIC_VALIDATION.md |
| EXP-019 | NH-10 escalation path implementation | COMPLETE (2026-09-23) | DOCUMENTATION_ONLY; §12 of handbook; 5 scenarios validated; L1-C Condition 3 SATISFIED |
| EXP-020 | HRQS checklist — human review quality standard | COMPLETE (2026-09-23) | Added as §12 subsection in CONTROL_PLANE_HANDBOOK; PAC-EF-02 FP class documented |
| EXP-021 | PAC corpus completion — all bash-firewall patterns to YAML | COMPLETE (2026-09-23) | 23 total policies (21 enforced + 2 proposed READY-02); gaps documented |

---

## §11 — Movement Results

### MOVEMENT 008 — HRQS Implementation + PAC Corpus Completion + CCP Handoff

```
ID:            MOVEMENT 008
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6
ARTIFACTS:     docs/CONTROL_PLANE_HANDBOOK.md (HRQS §12 subsection added)
               docs/research/pac/ccp_policies.yaml (23 policies — corpus complete)
               docs/00_SYSTEM/61_CCP_COMPLETE_HANDOFF.md (Phase A handoff)
               docs/00_SYSTEM/61A_CCP_FILE_CATALOG.md
               docs/00_SYSTEM/61B_CCP_JOURNEY_MAP.md
               docs/00_SYSTEM/61C_CCP_DECISION_AND_AUTHORIZATION_HISTORY.md
               docs/00_SYSTEM/61D_CCP_EVIDENCE_LINEAGE.md
               docs/00_SYSTEM/61G_CCP_CONTINUATION_GUIDE.md

START:
  MOVEMENT 007 complete. Three now-executable improvements identified.
  query-log.sh already created (M007).
  HRQS checklist: pending (documentation change; no auth needed).
  PAC corpus: 13 policies (incomplete).
  Handoff: not yet created.

QUESTION:  Execute the two remaining authorized improvements from M007.
           Create a complete continuity handoff so CCP can continue from history.

TRACKS EXECUTED:
  A — Phase A: CCP Complete Handoff (61_* documents)
      Full journey reconstruction: F1-F8 build + M001-M007 research
      File catalog, journey map, decision history, evidence lineage, continuation guide
      All M001-M007 artifacts staged (39_ through 60A_, PAC prototype, STALL_POLICY_LOG)
      Handoff commit: c41c8c9
  B — HRQS Checklist (§12 subsection in CONTROL_PLANE_HANDBOOK)
      Human Review Quality Standard with:
        - 6-step evaluation checklist
        - PAC-EF-02 class documented with diagnosis guide
        - FP classification table
        - H-01 threshold guidance (N=1 recommendation)
        - Escalation triggers for human review patterns
  C — PAC Corpus Completion
      Added 10 missing policies: POL-D05..D11, POL-S10..S12
      Total: 23 policies (21 enforced now + 2 proposed/READY-02)
      Coverage: ~90%+ of current bash-firewall.sh enforced patterns
      Remaining gaps documented in corpus_metadata

RESULT:
  HRQS: IMPLEMENTED (handbook §12 STALL subsection)
  PAC corpus: COMPLETE at 23 policies (research prototype — not production)
  Handoff: COMMITTED (c41c8c9 — 31 files, 18503 insertions)
  All M001-M007 research artifacts: STAGED AND COMMITTED
  NOW-EXECUTABLE list: EXHAUSTED (all 3 items complete)

POSITION CHANGE:
  BEFORE: HRQS pending; PAC corpus at 13 policies; handoff not created; M001-M007 untracked
  AFTER:  HRQS implemented; PAC corpus complete; handoff committed; all artifacts tracked;
          NOW-EXECUTABLE list fully exhausted

OPENED:
  Nothing new without owner authorization

CLOSED:
  EXP-020 (HRQS checklist) — COMPLETE
  EXP-021 (PAC corpus completion) — COMPLETE
  Handoff gap — CCP now has persistent memory of its own history

STOP CONDITION:
  All authorized improvements complete. No new authorized research or documentation
  change remains without owner decisions.
  TRUE FRONTIER: OWNER DECISION GATE (READY-01/02/03/04)
```

---

### MOVEMENT 006 — Pre-Authorization Adversarial Gate

```
ID:            MOVEMENT 006
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6 (this session)
ARTIFACTS:     59_PRE_AUTHORIZATION_ADVERSARIAL_GATE.md,
               59A_EXECUTION_REHEARSAL.md,
               58_OWNER_DECISION_PACKAGE.md (updated with 4 precision fixes)

START:
  READY-01/02/03/04 at OWNER_DECISION_READY.
  Adversarial audit not yet performed.
  UNK-M4-01 dangling OPEN entry in Exploration Engine.
  READY-03 N threshold undefined.

QUESTION:  Can READY-01/02/03/04 be broken before owner authorization?
           Is each decision correctly classified, scoped, and ready?
           Are all consequences fully determined?

TRACKS EXECUTED:
  A — Source file audit (PROJECT_STATE, 58_, 58A, 57_, 56_, handbook, rules)
  B — READY-01 adversarial audit (4 policy repairs; per-repair semantic scope analysis)
  C — NH-09 INVARIANT independent verification (variable lifecycle trace)
  D — READY-02 adversarial audit (ordering, FP/FN, dual-variable architecture)
  E — READY-03 adversarial audit (residual matrix, reactivation triggers, N gap)
  F — READY-04 adversarial audit (sensitive data check, exit codes, logging)
  G — Cross-decision interaction matrix
  H — Branch simulation (5 branches)
  I — Authorization audit (F9-D01=A semantics per element)
  J — Hidden dependency audit
  K — Evidence sufficiency audit
  L — Materiality audit (H-01 discipline check)
  M — Reversibility audit
  N — Premature closure audit (state machine)
  O — Second-order objection hunt
  P — Simpler closure search
  Q — True frontier reconstruction

RESULT:
  GATE RESULT: CONDITIONAL PASS — 4 required precision fixes made to 58_
  Finding A (HIGH): READY-01 misclassified; 3 of 4 repairs add new constraints/exceptions.
                    Decision question corrected in 58_; execution rehearsal updated.
  Finding B (MEDIUM): READY-03 N threshold undefined → added "REQUIRED OWNER INPUT" field to 58_.
  Finding C (LOW): READY-03 RISK: MEDIUM → corrected to RISK: UNKNOWN in 58_.
  Finding D (LOW): READY-02 dual-variable architecture note added to 59A_.
  Finding E (ADMIN): UNK-M4-01 dangling OPEN entry → cleaned in §3 (this session).
  NH-09 INVARIANT: CONFIRMED (design analysis; no execution path for COMMAND_NORM).
  STOP CONDITION: Research agenda exhausted; no high-value low-cost experiment remains;
                  no material unknown changes any decision (N requires owner input, not research).

POSITION CHANGE:
  BEFORE: READY decisions at OWNER_DECISION_READY; N undefined; READY-01 framing imprecise.
  AFTER:  Decision package adversarially audited; precision fixes applied; execution plans ready.
          Frontier simplified: OWNER DECISION GATE + N definition + H-01 monitoring.

OPENED:
  UNK-M6-01: NH-09 INVARIANT maintenance dependency (undocumented; low risk; future hook
             modifications must not execute COMMAND_NORM)

CLOSED:
  UNK-M4-01 dangling OPEN entry (admin; already RESOLVED since MOVEMENT 005)

STOP CONDITION:
  No authorized research remains. All open questions require owner input or real usage.
  TRUE FRONTIER: OWNER DECISION GATE → N definition → H-01 monitoring.
```

---

### MOVEMENT 005 — NH-10 Implementation, UNK-M4-01 Resolution, Owner Decision Package

```
ID:            MOVEMENT 005
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6 (this session)
ARTIFACTS:     58_OWNER_DECISION_PACKAGE.md, 58A_NH09_SEMANTIC_VALIDATION.md,
               CONTROL_PLANE_HANDBOOK.md §12 (new escalation subsection)

START:
  NH-10 not yet implemented (handbook unchanged per git log).
  UNK-M4-01 open (20-cmd corpus test pending).
  READY-01/02/03/04 structured but not consolidated.

QUESTION:  What is the correct classification of NH-10? Can it be implemented?
           Is NH-09 semantically safe for matching? What is the true frontier?

TRACKS EXECUTED:
  A — Initial state audit (NH-10 classification: DOCUMENTATION_ONLY → proceed)
  B — NH-10 implementation: §12 escalation path in CONTROL_PLANE_HANDBOOK
  C — NH-10 validation: 5 conceptual scenarios (ESC-01..ESC-05)
  D — UNK-M4-01: 20-command corpus across 14 categories; semantic analysis (58A)
  E — Normalization architecture boundary (RAW→NORM→TOKENIZE→AST→DATAFLOW→SEMANTIC)
  F — Second-order consequences (NH-10 effect on L1-C; CONFLICT-04 resolved)
  G — LABYRINTH-1 recheck (1/5 conditions now satisfied; minimal/practical/strong defined)
  H — Owner decision package consolidated (58_OWNER_DECISION_PACKAGE.md; 4 decisions)
  I — Decision minimization (3 scenarios; minimum viable unlock identified)
  J — Authorization map (7 items; 5 status categories)
  K — Empirical gap audit (REQUIRES_REAL_USAGE register created)
  L — Second-order research pass (NH-11 logged; CONFLICT-04 RESOLVED; no premature closures)
  M — Claim audit (no new overstatements found; all claims correctly classified)
  N — TRUE FRONTIER generated

RESULT:
  NH-10: IMPLEMENTED (DOCUMENTATION_ONLY confirmed; handbook §12 added)
  UNK-M4-01: RESOLVED — SAFE_NORMALIZATION (4 limitations documented)
  CONFLICT-04: RESOLVED — process gap closed by NH-10
  L1-C Condition 3: SATISFIED (1/5 conditions now met)
  NH-11: HYPOTHESIS (single-quote normalization; not authorized; logged)
  Owner decision package: COMPLETE (58_OWNER_DECISION_PACKAGE.md)
  TRUE FRONTIER: 5 questions (see §16)

POSITION CHANGE:
  BEFORE: NH-10 unimplemented; UNK-M4-01 open; owner package not consolidated
  AFTER:  NH-10 implemented; UNK-M4-01 resolved; L1-C advances to 1/5; owner package ready

OPENED:
  NH-11 (HYPOTHESIS — single-quote normalization; not on authorized path)

CLOSED:
  NH-10 (IMPLEMENTED — handbook addition)
  UNK-M4-01 (RESOLVED — SAFE_NORMALIZATION with 4 limitations)
  CONFLICT-04 (RESOLVED — process spec now exists)

STOP CONDITION:
  No high-value authorized experiment remains without new owner authorization.
  TRUE FRONTIER is owner decision gate (READY-01/02/03).
```

---

### MOVEMENT 004 — Frontier Integration, Closure & Decision Readiness

```
ID:            MOVEMENT 004
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6 (this session)
ARTIFACT:      57_MOVEMENT_004_FRONTIER_INTEGRATION.md

START:
  NH-05/06/07 open (all available without authorization).
  Level-1 normalization complexity unknown; CONFLICT-04 resolution path unknown;
  Enhanced-B scope vs. AC-03 unclear; L1-C conditions not fully specified;
  READY-01/02/03 structured but not in decision-package format.

QUESTION:  What are the results of NH-05/06/07? What is the minimum viable security
           stack? What conditions close L1-C? What do owner decision packages look like?

TRACKS EXECUTED:
  A — NH-05: shlex analysis; tokenizer vs. AST distinction; ${VAR} gap resolution
  B — NH-09 discovery: 2-regex alternative to shlex (zero dependencies; LOW complexity)
  C — NH-06: full policy conflict matrix; CONFLICT-04 as missing spec
  D — NH-10 discovery: escalation path = handbook documentation (no auth)
  E — NH-07: enhanced-B message format; STA-02 information vs. judgment gap
  F — Cross-track synthesis: CCP Minimal Security Stack (Layers 0-6)
  G — Second-order architecture: Level-1.5 AST cost-justified threshold analysis
  H — Residual risk reconstruction: full bypass class × detection layer matrix
  I — L1-C reassessment: 5 conditions; minimal vs. strong; reactivation triggers
  J — READY-01/02/03/04 decision packages (full structure per decision)
  K — New hypotheses (NH-09, NH-10); new unknowns (UNK-M4-01, UNK-M4-02)
  L — Claim audit: overstatements corrected throughout

RESULT:
  NH-05: PARTIALLY_SUPPORTED (shlex tokenizer not AST; ${VAR} needs separate step)
  NH-06: PARTIALLY_SUPPORTED (no active conflicts; CONFLICT-04 = missing spec)
  NH-07: SUPPORTED (information gap; not judgment gap; not AC-03 substitute)
  NH-09: SUPPORTED (2 sed = Level-1; zero deps; LOW complexity — SIMPLIFICATION FINDING)
  NH-10: CONFIRMED (handbook addition = permitted now; AVAILABLE IMMEDIATELY)
  L1-C: 5 conditions specified; minimal vs. strong closure distinguished
  CCP Minimal Security Stack: Layers 0-6 named and characterized
  READY-01/02/03/04: fully structured as owner decision documents

POSITION CHANGE:
  BEFORE: NH-05/06/07 open; Level-1 complexity uncertain; L1-C conditions vague
  AFTER:  All NH-05/06/07 resolved; Level-1 complexity is LOW (not MEDIUM);
          NH-09/10 discovered; L1-C conditions precise; all owner decisions structured;
          non-authorized research space effectively exhausted

OPENED:
  UNK-M4-01: NH-09 double-quote removal semantic accuracy
  UNK-M4-02: Level-1.5 AST cost-justification threshold
  READY-04: Enhanced-B implementation authorization (new)

CLOSED:
  NH-05 (PARTIALLY_SUPPORTED)
  NH-06 (PARTIALLY_SUPPORTED)
  NH-07 (SUPPORTED — information gap scope)
  NH-09 (SUPPORTED — new; zero-dependency Level-1)
  NH-10 (CONFIRMED — new; can be done now)
  L1-C conditions (fully specified; 5 conditions)
  READY packages (fully structured; READY-01/02/03/04)

STOP CONDITION: Non-authorized research space exhausted except:
  NH-10 implementation (~10 lines in handbook)
  UNK-M4-01 corpus test (20 commands; analytical)
  Owner decision brief formatting

NEXT FRONTIER: Owner decision gate (READY-01/02/03); NH-10 implementation; H-01 data
NEXT MOVEMENT: MOVEMENT 005 — NH-10 Documentation + Owner Decision Brief
```

---

### MOVEMENT 003 — Master Frontier Closure Expedition

```
ID:            MOVEMENT 003
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6 (this session)
ARTIFACT:      56_MOVEMENT_003_MASTER_FRONTIER_CLOSURE.md

START:
  NH-04 open; bypass taxonomy unknown; policy repair adversarial robustness unknown;
  owner gate minimum decision unknown; static-analysis intermediates unknown;
  LABYRINTH-1 alternative formulations unknown.

QUESTION:  What is the maximum research progress achievable without new authorization?

TRACKS EXECUTED:
  A — NH-04 deep (corpus 15 cases, mutation testing, FP analysis, 3-vs-4 comparison)
  B — Bypass space expansion (4 upper families; 6-level detection spectrum)
  C — Second-order bypass (aliasing chain SC-01 identified as dominant gap)
  D — Static-analysis boundary (Level-1 AST normalization as new intermediate)
  E — Policy repair adversarial validation (5-case per policy; residual identified)
  F — Policy composition / precedence (no explicit precedence document = UNK-M3-01)
  G — Owner gate decomposition (minimum decision per improvement; READY-01/02/03)
  H — Alternatives to AC-03 (X1/X2/X3 comparison; AC-03 not needed under L1-C)
  I — LABYRINTH-1 reformulations (L1-A/B/C; L1-C enables closure without AC-03)
  J — Negative space (aliasing/script not material; single-step bypasses are target class)
  K — New hypotheses (NH-05..NH-08)

RESULT:
  NH-04: PARTIALLY_SUPPORTED (covers 6/15; ${VAR} gap; P4 inadvisable)
  Bypass taxonomy: 4 families; 6-level detection spectrum resolved
  Aliasing: dominant undetectable class (requires session taint or human review)
  Shell AST normalization: NEW intermediate architecture option (NH-05 — HYPOTHESIS)
  Policy repairs: all better; residual edge case each
  Policy precedence: absent — UNK-M3-01 opened
  Minimum owner decisions: decomposed; READY-01/02/03 specified
  L1-C formulation: LABYRINTH-1 closeable without AC-03 if owner accepts residual
  NH-05, NH-06, NH-07: AVAILABLE_NOW (no authorization)
  NH-08: UNFALSIFIABLE (blocked by H-01)

POSITION CHANGE:
  BEFORE: NH-04 open; bypass taxonomy unknown; intermediates unknown; LABYRINTH-1 open
  AFTER:  NH-04 PARTIALLY_SUPPORTED; taxonomy resolved; NEW intermediate identified;
          LABYRINTH-1 has new exit path (L1-C); owner decision package ready

OPENED:
  UNK-M3-01: no explicit policy precedence document
  NH-05: shell AST normalization hypothesis
  NH-06: policy precedence document hypothesis
  NH-07: enhanced-B denial message hypothesis
  NH-08: semantic bypass not material (UNFALSIFIABLE until H-01)
  READY-01/02/03: owner decision specifications

CLOSED:
  NH-04 (PARTIALLY_SUPPORTED)
  Bypass taxonomy structure (RESOLVED as 4 families + 6-level spectrum)
  Policy repair adversarial robustness (VALIDATED — better but residual each)
  Owner gate decomposition (COMPLETE)
  LABYRINTH-1 under L1-C formulation (new exit path identified)

NEXT FRONTIER: READY-01/02/03 (owner decisions) + NH-05/06/07 (available-now tests)
NEXT MOVEMENT: MOVEMENT 004 — Available-Now Closure + Owner Decision Package
```

---

### CDT-01 + NH-02 — Policy Repair Test + Semantic Bypass Coverage

```
ID:            CDT-01 + NH-02
DATE:          2026-09-23
EXECUTOR:      Claude Sonnet 4.6 (this session)
ARTIFACT:      55_CDT01_NH02_RESULTS.md

START:
  CDT-01: Does policy repair raise SAFE rate to >85%?
  NH-02: Do 3–5 patterns cover CCP's semantic bypass domain?

QUESTION: What is the ROI and scope of incremental improvements available now?

ACTION:
  CDT-01: Drafted repair text for POL-05, POL-08, POL-10, POL-13 (4 PARTIAL policies).
          Re-evaluated RCE-05 with repaired POL-05 → UNKNOWN becomes SAFE.
          Added 3 new RCE cases (RCE-09, RCE-10, RCE-11) for remaining PARTIAL policies.
          Compared SAFE rates: baseline 75% → 87.5% (same cases) / 90.9% (extended set).
  NH-02: Enumerated 6 bypass gap classes (printenv, interpreter env, encoding pipeline,
         redirect to file, command substitution, obfuscation). Assessed bash-firewall
         and secret-guard coverage per class. Proposed 4 new patterns (P1', P2', P3, P4).
         Assessed coverage with proposed patterns. Identified hard-to-cover remainder.

RESULT:
  CDT-01: HYPOTHESIS CONFIRMED — 87.5% SAFE rate after policy repair
  NH-02: PARTIALLY_SUPPORTED — 4 patterns cover 75–80% of practical bypass surface
  AC-02 ROI: CONFIRMED HIGH (each repair = one sentence; no code change)
  NH-02 implementation: READY_FOR_TEST but requires owner authorization (F9-D01=A)
  New hypothesis NH-04 opened: P1'+P2'+P3 may be sufficient for current threat surface

POSITION CHANGE:
  BEFORE: CDT-01 and NH-02 open; bypass gap coverage unknown; policy repair ROI unquantified
  AFTER:  Policy repair fully specified (repair drafts available in §1.3 of artifact).
          Bypass gap concentrated: 3 primary classes fully coverable, 2 partially coverable.
          Authorization gate confirmed as the remaining bottleneck for all improvements.

OPENED:
  NH-04: P1'+P2'+P3 sufficiency test (10-case analysis; no code change)

CLOSED:
  CDT-01 (policy repair test)
  NH-02 (semantic bypass coverage analysis)
  UNK-M2-03 (policy repair does increase SAFE rate to >85% — CONFIRMED)

NEXT FRONTIER: Owner Scoping Decision (UNK-M2-04)
NEXT MOVEMENT: MOVEMENT 003 — Incremental Improvement Scoping
```

---

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
| NH-04 deep evaluation | Is P1'+P2'+P3 sufficient? | PARTIALLY_SUPPORTED (artifact 56) | MOVEMENT 003 COMPLETE |
| Bypass taxonomy | What is the bypass family structure? | 4 families + 6-level spectrum (artifact 56 §4,§6) | MOVEMENT 003 COMPLETE |
| Policy repair validation | Are CDT-01 repairs adversarially robust? | Better + residual each (artifact 56 §7) | MOVEMENT 003 COMPLETE |
| Owner gate decomposition | Minimum decision per improvement? | READY-01/02/03 (artifact 56 §9,§19) | MOVEMENT 003 COMPLETE |
| NH-05/06/07/09/10 | Shell normalization, precedence, enhanced-B, Level-1, escalation path | All resolved (57_MOVEMENT_004; 58A; handbook §12) | MOVEMENT 004/005 COMPLETE |
| UNK-M4-01 | NH-09 double-quote removal semantic accuracy | SAFE_NORMALIZATION (58A §5); 4 limitations documented | MOVEMENT 005 COMPLETE |
| NH-10 implementation | Escalation path in handbook | IMPLEMENTED (handbook §12) | MOVEMENT 005 COMPLETE |

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

The frontier after MOVEMENT 006 (TRUE FRONTIER):

```
KNOWN (no more research needed without new authorization):
  All NH-05/06/07/09/10 questions resolved
  UNK-M4-01 resolved (SAFE_NORMALIZATION)
  CONFLICT-04 resolved (NH-10 closes process gap)
  L1-C Condition 3 satisfied (handbook §12)
  Owner decision packages complete (58_OWNER_DECISION_PACKAGE.md)
  Non-authorized research space effectively exhausted

TRUE FRONTIER (5 questions — each requires a different kind of unblocking):

[F1] READY-03: Owner risk acceptance for LABYRINTH-1 L1-C closure
     QUESTION:  Will the owner accept the bypass residual (aliasing/heredoc/file-scripts)
                as mitigated by human review + staging for current development context?
     WHY MATTERS: Without this statement, LABYRINTH-1 never closes regardless of how much
                  is implemented. Lowest-friction decision available.
     CHEAPEST:  One owner statement (no implementation)
     AUTH:      Owner decision only; no technical change required
     DEPENDENCY: None (can be done first, independently of READY-01/02)
     CHANGES MAP: LABYRINTH-1 → CONDITIONALLY_CLOSED; research overhead stops

[F2] READY-01: AC-02 authorization classification
     QUESTION:  Is adding disambiguation text to .claude/rules/*.md a "rule change" or
                "documentation improvement" under F9-D01=A?
     WHY MATTERS: Determines whether policy repairs can be implemented immediately or
                  require a separate authorization gate
     CHEAPEST:  Binary classification by owner; repair texts are ready (55_CDT01 §1.3)
     AUTH:      Owner classification decision; no technical change until classified
     DEPENDENCY: None (independent of READY-02 and READY-03)
     CHANGES MAP: If YES → AC-02 implementable; L1-C Condition 2 satisfied

[F3] READY-02: P1'+P2' pattern + Level-1 normalization authorization
     QUESTION:  Authorize ~6 new lines in bash-firewall.sh to close printenv/encoding
                pipeline and ${VAR}/quoting bypass gaps
     WHY MATTERS: Currently, `printenv ANTHROPIC_API_KEY` is NOT blocked. This is the
                  highest-risk syntactic gap in the current firewall.
     CHEAPEST:  Owner authorization; spec and validation are complete (55_CDT01; 58A)
     AUTH:      Hook modification authorization (F9-D01=A gate)
     DEPENDENCY: None (independent of READY-01 and READY-03)
     CHANGES MAP: L1-C Condition 1 satisfied; Minimal Security Stack Layers 1+2 operational

[F4] H-01: Real usage data (stall frequency)
     QUESTION:  How often do real STALL_POLICY events occur with had_alternative ≠ null?
     WHY MATTERS: Determines materiality of the entire bypass problem.
                  If H-01 → 0, LABYRINTH-1 closes as IMMATERIAL regardless of decisions.
     CHEAPEST:  Wait for real usage (no design work can accelerate this)
     AUTH:      None needed; blocked by environment only
     DEPENDENCY: Real usage environment (no trigger exists today)
     CHANGES MAP: If H-01 < N → LABYRINTH-2 closed; possibly LABYRINTH-1 as IMMATERIAL

[F5] NH-11: Single-quote normalization (HYPOTHESIS — logged only)
     QUESTION:  Can Step 1 of NH-09 be extended to remove single quotes as well?
     WHY MATTERS: Single-quoted secrets are a pre-existing bypass gap (case 09 of 58A)
     CHEAPEST:  Analytical corpus test (~20 cases); no auth needed
     AUTH:      None for analysis; hook auth needed for implementation
     DEPENDENCY: NH-09 implementation authorization (READY-02)
     CHANGES MAP: If SAFE_NORMALIZATION → extends NH-09 coverage; new READY package needed

PERMANENTLY BLOCKED (requires real usage — not more design):
  H-01 frequency (see F4)
  AC-03 utility threshold (B3 block of LABYRINTH-1)
  Enhanced-B effectiveness (NH-07 real usage validation)
  NH-10 escalation effectiveness (real event required)

[CLOSED] NH-05/06/07/09/10: all resolved
[CLOSED] UNK-M4-01: SAFE_NORMALIZATION
[CLOSED] CONFLICT-04: RESOLVED
[CLOSED] CDT-01, NH-02, NH-04: all PARTIALLY_SUPPORTED/CONFIRMED
```

---

## §16 — Next Moves

Updated after MOVEMENT 007. Three tracks available: owner decisions (A/B/C) + now-executable improvements (D/E).
Reference: 59_PRE_AUTHORIZATION_ADVERSARIAL_GATE.md for audit details.
Reference: 59A_EXECUTION_REHEARSAL.md for exact implementation plans.
Reference: 60_FRONTIER_BREAKOUT.md for MOVEMENT 007 results and new findings.

### NEXT MOVE A — READY-03 (minimum viable, highest leverage, no code change)

```
WHAT QUESTION DOES IT ANSWER?
  "Will the owner explicitly accept the bypass residual for current context,
  closing LABYRINTH-1 under L1-C?"

COST: One owner statement (no implementation)
REFERENCE: 58_OWNER_DECISION_PACKAGE.md §READY-03 (updated MOVEMENT 006)
REQUIRED OWNER INPUT: N threshold for H-01 reactivation trigger
IMPACT: LABYRINTH-1 → CONDITIONALLY_CLOSED; research overhead stops
PRECONDITION: None
```

### NEXT MOVE B — READY-01 + READY-02 (implementation unlock, one session)

```
WHAT QUESTIONS DOES IT ANSWER?
  "Are these policy repairs 'rule change' or 'doc improvement'?" → enables policy repairs
  NOTE: MOVEMENT 006 adversarial audit found repairs are NOT uniformly doc-only.
        The owner must decide knowing 3 of 4 repairs add new constraints.
  "Authorize P1'+P2'+Level-1 normalization?" → enables firewall improvements

COST: One owner review session; implementation ~30 min if authorized
REFERENCE: 58_OWNER_DECISION_PACKAGE.md §READY-01, §READY-02; 59A_EXECUTION_REHEARSAL §1-2
IMPACT: L1-C Conditions 1+2 satisfied; Minimal Security Stack Layers 1+2 operational
PRECONDITION: Read updated READY-01 question in 58_ (corrected MOVEMENT 006)
```

### NEXT MOVE C — READY-04 (quality improvement, lower priority)

```
WHAT QUESTION DOES IT ANSWER?
  "Authorize enhanced denial message format in hooks?"

COST: One owner authorization; implementation ~20 min if authorized
REFERENCE: 58_OWNER_DECISION_PACKAGE.md §READY-04; 59A_EXECUTION_REHEARSAL §4
IMPACT: Human review quality for STA-02 improves
PRECONDITION: NH-10 (SATISFIED MOVEMENT 005)
```

### NEXT MOVE D — HRQS Checklist ✓ DONE (MOVEMENT 008)

```
STATUS: IMPLEMENTED — CONTROL_PLANE_HANDBOOK.md §12 STALL subsection
IMPACT: PAC-EF-02 FP class documented; 6-step checklist; H-01 threshold guidance
```

### NEXT MOVE E — STALL_POLICY_LOG Query Tool ✓ DONE (MOVEMENT 007)

```
STATUS: IMPLEMENTED — docs/00_SYSTEM/query-log.sh
NOTE: Current H-01 real count = 2 (both PAC-EF-02 FPs; zero genuine bypass events)
```

### PERMANENTLY BLOCKED (no authorized experiment remains)

```
NH-11 analysis: AVAILABLE NOW (no auth); but minimal value before READY-02
H-01 measurement: REQUIRES REAL USAGE ENVIRONMENT
CDT-02 blind verifier: REQUIRES NEW AGENT AUTHORIZATION
AC-03 implementation: REQUIRES F10 SCOPE GATE
PAC production adoption: REQUIRES OWNER AUTHORIZATION (architecture change)
```

---

## §17 — Movement History

Each completed movement, most recent first.

```
MOVEMENT 008
DATE:      2026-09-23
MOVE:      HRQS Implementation + PAC Corpus Completion + CCP Complete Handoff
QUESTION:  Execute all authorized now-executable improvements. Create a persistent
           memory layer (handoff) so CCP can continue from its full history.
OBSERVATION: Phase A (handoff): 6 documents, 31 files, 18503 insertions committed at c41c8c9.
             Phase B (execution): HRQS checklist added to handbook; PAC corpus extended to 23 policies.
             NOW-EXECUTABLE list fully exhausted. No new authorized improvements remain.
             CCP now has persistent memory of M001-M007 journey.
RESULT:    MOVEMENT_COMPLETE. All authorized improvements done.
           True frontier: OWNER DECISION GATE (READY-01/02/03/04).
CLASSIFICATION: MOVEMENT_COMPLETE
WHAT CHANGED:
  - docs/CONTROL_PLANE_HANDBOOK.md: HRQS §12 subsection (human review quality standard)
  - docs/research/pac/ccp_policies.yaml: corpus complete (23 policies)
  - docs/00_SYSTEM/61_*.md: 6 handoff documents (continuity layer)
  - All M001-M007 research artifacts: staged in c41c8c9
CLOSED: EXP-020 (HRQS), EXP-021 (PAC corpus), handoff gap
NEXT FRONTIER: OWNER DECISION GATE — READY-01/02/03/04

MOVEMENT 007
DATE:      2026-09-23
MOVE:      Frontier Breakout & Autonomous Advancement
QUESTION:  Is the MOVEMENT 006 conclusion ("research should stop") correct under a new
           formulation? Are there new ideas, capabilities, or architectures that move
           the project forward without violating authorization?
OBSERVATION: 8 core CCP assumptions attacked; 2 confirmed weak, 2 new findings discovered.
             PAC prototype: 13 policies encoded in YAML; compiler ran; no drift detected (PAC-EF-01).
             NEW FP CLASS: pattern-name-in-literal causes false positives (PAC-EF-02).
             PAC-EF-02 generated 2 H-01 events in this session — both false positives.
             P1'/P2' exact regex resolved (59A placeholder filled).
             N=1 recommendation derived analytically for READY-03.
             HRQS gap identified (human review quality standard missing).
             3 parallel execution tracks identified (query tool, HRQS, PAC corpus).
             READY-04 urgency elevated: FP classification harder without enhanced messages.
             17 ideas generated across 4 horizons; B1 (PAC) designated breakout candidate.
             query-log.sh created and verified operational.
RESULT:    Frontier is WIDER than MOVEMENT 006 described.
           3 now-executable improvements (query tool DONE; HRQS pending; PAC corpus pending).
           PAC architecture demonstrates future path to eliminating READY-01/READY-02 split.
CLASSIFICATION: MOVEMENT_COMPLETE
WHAT CHANGED:
  - docs/research/pac/: 3 files created (YAML corpus, compiler, results)
  - docs/research/CCP_FINAL_RECONCILIATION/60A_IDEA_PORTFOLIO.md: idea portfolio (17 ideas)
  - docs/research/CCP_FINAL_RECONCILIATION/60_FRONTIER_BREAKOUT.md: main movement artifact
  - docs/00_SYSTEM/query-log.sh: H-01 monitoring tool (OPERATIONAL)
  - CCP_EXPLORATION_ENGINE.md: §2, §3, §16, §17 updated
  - PROJECT_STATE.md: updated (LAST_MOVEMENT, STALL_POLICY_LOG note)
CLOSED: PAC-EF-01 (consistency), PAC-EF-02 (new FP class), PAC-EF-03 (feasibility)
        P1'/P2' spec placeholder (59A §2.2 resolved)
        STALL_POLICY_LOG monitoring gap (query-log.sh created)
OPENED: PAC production adoption (future; architecture change authorization needed)
        HRQS gap (documentation; authorized; pending)
        PAC corpus completion (research; authorized; pending)
        PAC-EF-02 FP class (documented; suggests READY-04 urgency elevated)
NEXT FRONTIER: Owner decisions (READY-01/02/03/04) + parallel tracks (HRQS, PAC corpus)

MOVEMENT 006
DATE:      2026-09-23
MOVE:      Pre-Authorization Adversarial Gate & Execution Rehearsal
QUESTION:  Can READY-01/02/03/04 be broken before owner authorization?
           Are all consequences fully determined? Are dependencies hidden?
OBSERVATION: GATE RESULT: CONDITIONAL PASS (4 precision fixes applied).
             Finding A: READY-01 misclassified — 3/4 repairs add new constraints/exceptions.
             Finding B: READY-03 N threshold undefined → "REQUIRED OWNER INPUT" added to 58_.
             Finding C: READY-03 RISK: MEDIUM → corrected to RISK: UNKNOWN.
             Finding D: READY-02 dual-variable architecture note added to 59A.
             Finding E: UNK-M4-01 dangling OPEN entry cleaned from §3.
             NH-09 INVARIANT independently confirmed (variable lifecycle trace).
             No blocking adversarial finding. No hidden dependency changes any decision.
             Research stop condition met: all 5 STOP criteria satisfied.
RESULT:    Decision package passes adversarial gate; execution rehearsal complete.
           TRUE FRONTIER: OWNER DECISION GATE → N definition → H-01 monitoring.
CLASSIFICATION: MOVEMENT_COMPLETE
WHAT CHANGED:
  - 58_: READY-01 question corrected; READY-03 N input required; RISK label corrected
  - 59_: Pre-authorization adversarial gate (new artifact)
  - 59A_: Execution rehearsal with dry-run plans and branch simulations (new artifact)
  - CCP_EXPLORATION_ENGINE.md: §3 frontier cleaned (UNK-M4-01 OPEN removed); MOVEMENT 006 added
  - PROJECT_STATE.md: updated
CLOSED: UNK-M4-01 dangling OPEN entry (admin)
OPENED: UNK-M6-01 (NH-09 INVARIANT maintenance dependency; low risk)

MOVEMENT 005
DATE:      2026-09-23
MOVE:      NH-10 Implementation + UNK-M4-01 Resolution + Owner Decision Package
QUESTION:  Can NH-10 be implemented? Is NH-09 semantically safe? What is the true frontier?
OBSERVATION: NH-10 classified DOCUMENTATION_ONLY → implemented in handbook §12.
             UNK-M4-01 resolved: SAFE_NORMALIZATION (20-command corpus; 4 documented limitations).
             CONFLICT-04 RESOLVED (process gap → handbook spec). L1-C Condition 3 SATISFIED.
             Owner package consolidated in 58_OWNER_DECISION_PACKAGE.md.
             NH-11 hypothesis logged (single-quote normalization; not authorized).
             No premature closures found. Claim audit clean.
RESULT:    NH-10 IMPLEMENTED; UNK-M4-01 RESOLVED; TRUE FRONTIER = owner decision gate
CLASSIFICATION: MOVEMENT_COMPLETE
WHAT CHANGED:
  - NH-10: CONFIRMED → IMPLEMENTED (handbook §12 added)
  - UNK-M4-01: OPEN → RESOLVED (SAFE_NORMALIZATION; 4 limitations)
  - CONFLICT-04: MISSING_SPEC → RESOLVED
  - L1-C Condition 3: NOT_SATISFIED → SATISFIED
  - Owner decision package: structured → consolidated in 58_OWNER_DECISION_PACKAGE.md
  - Normalization architecture boundary: precisely defined (6 levels)
CLOSED: NH-10 (implemented), UNK-M4-01 (resolved), CONFLICT-04 (resolved)
OPENED: NH-11 (hypothesis; not authorized)
NEXT FRONTIER: Owner decision gate (READY-01/02/03) — no authorized research remains
NEXT MOVE: READY-03 (minimum viable) or READY-01+READY-02 (full implementation path)
```

---

```
MOVEMENT 003
DATE:      2026-09-23
MOVE:      Master Frontier Closure Expedition (10 tracks; all available-now research exhausted)
QUESTION:  What is the maximum research progress achievable without new authorization?
OBSERVATION: NH-04 PARTIALLY_SUPPORTED; ${VAR} gap in all 3 patterns; P4 high FP (inadvisable);
             4-family bypass taxonomy + 6-level detection spectrum; variable aliasing = dominant undetectable class;
             shell AST normalization = new viable intermediate architecture; all 4 policy repairs
             validated (better + residual); CCP has no explicit policy precedence (UNK-M3-01);
             L1-C formulation opens LABYRINTH-1 exit without AC-03; owner decision package ready
RESULT:    Non-authorized research space fully traversed; READY-01/02/03 owner decisions specified;
           NH-05/06/07 available-now hypotheses opened; NH-08 opened (unfalsifiable until H-01)
CLASSIFICATION: MOVEMENT_COMPLETE
WHAT CHANGED:
  - NH-04: OPEN → PARTIALLY_SUPPORTED
  - Bypass taxonomy: unknown → 4 families + 6-level spectrum
  - Shell AST normalization: unknown → DESIGN_RESULT (viable new intermediate)
  - Policy repairs: validated but each has residual ambiguity
  - LABYRINTH-1: new exit path (L1-C) identified — does not require AC-03
  - Owner decision minimum: decomposed into READY-01/02/03
  - New unknowns: UNK-M3-01..04
CLOSED: NH-04, Track A-J analysis, owner gate decomposition, LABYRINTH-1 L1-C path
OPENED: NH-05, NH-06, NH-07, NH-08, UNK-M3-01..04, READY-01/02/03
NEXT FRONTIER: READY-01/02/03 (owner) + NH-05/06/07 (available now)
NEXT MOVE: MOVEMENT 004 (Available-Now Closure + Owner Decision Package)
```

---

```
CDT-01 + NH-02
DATE:      2026-09-23
MOVE:      Policy repair test + semantic bypass coverage analysis
QUESTION:  Does policy repair raise SAFE rate >85%? Do 3–5 patterns cover bypass domain?
HYPOTHESIS: CDT-01 → SAFE rate increases with policy repair; NH-02 → bypass domain concentrated
OBSERVATION: CDT-01 CONFIRMED (87.5%); NH-02 PARTIALLY_SUPPORTED (~75–80% coverage with 4 patterns)
RESULT:    Policy repair high ROI confirmed; bypass coverage partially achievable via pattern extension
CLASSIFICATION: CDT-01=HYPOTHESIS_CONFIRMED; NH-02=PARTIALLY_SUPPORTED
WHAT CHANGED:
  - CDT-01: SAFE rate 75% → 87.5% (same cases); 90.9% (extended 11 cases)
  - NH-02: 6 bypass gap classes identified; 4 patterns (P1',P2',P3,P4) cover ~75–80%
  - AC-02: repair drafts fully specified and ready for owner authorization
  - NH-04: new hypothesis opened (P1'+P2'+P3 may be sufficient for current threat surface)
  - UNK-M2-03: RESOLVED (policy repair does increase SAFE rate to >85%)
CLOSED:
  - CDT-01
  - NH-02
  - UNK-M2-03
OPENED:
  - NH-04 (P1'+P2'+P3 sufficiency test)
NEXT FRONTIER: Owner Scoping Decision (UNK-M2-04)
NEXT MOVE: UNK-M2-04 (requires owner input) or NH-04 (available now, low cost)
```

---

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
