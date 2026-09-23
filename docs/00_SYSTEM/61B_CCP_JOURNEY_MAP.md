# 61B — CCP Journey Map: The Labyrinth

**Created:** 2026-09-23  
**Purpose:** Graph view of the research journey — not a straight line. Shows every path taken, abandoned, blocked, deferred, refuted, or reformulated.

---

## Top-Level Problem Graph

```
ORIGINAL PROBLEM
  "Can Claude Code's work be made auditable, reversible, and evidence-gated?"
        ↓
  F1-F8: SOLVED (foundation, evidence, hooks, incident learning, maintenance)
        ↓
  NEW PROBLEM (emerged from F8)
  "What happens when an agent hits a policy block and has a viable alternative?"
        ↓
  LABYRINTH-1: Policy-Aware Continuation with Non-Bypass Verification
        ↓
  THREE COMPOUNDING BLOCKS:
  ├── B-1: Independence (proposer = verifier → not independent)
  ├── B-2: Policy explicitness (vague policies → UNKNOWN)
  └── B-3: Usefulness threshold undefined (owner preregistration required)
        ↓
  MOVEMENTS 001–007: Systematic labyrinth exploration
        ↓
  CURRENT POSITION: Partially resolved; owner gates blocking implementation
```

---

## The Research Labyrinth

### Entry Point

```
F9 RESEARCH (2026-09-18/19)
  Question: Is non-bypass verification needed? If so, what research first?
  Result: F9 NOT JUSTIFIED — research before implementation
  Owner gate: F9-D01=A (closed; no implementation)
  
  Opened: R-2 (instrumentation), R-3 (protocol design), 5 owner decision surfaces
```

---

### Branch Map

```
LABYRINTH START
      │
      ├── R-1: PRIOR ART SEARCH [CLOSED/RESOLVED]
      │   Question: Does any existing system solve this?
      │   Investigated: VERITAS OS, Temporal/DBOS/LangGraph, State-Aware Runtime v4,
      │                 arXiv:2606.31339, ae-framework
      │   Result: None close the residual. All closed as non-solutions.
      │   Status: CLOSED (47_PRIOR_ART_VERIFICATION.md)
      │
      ├── R-2: STALL_POLICY INSTRUMENTATION [COMPLETE; ENVIRONMENT_BLOCK]
      │   Question: How often do stall events occur with viable alternatives?
      │   Result: Instrumentation operational (STALL_POLICY_LOG).
      │            3 events total: 1 test, 2 PAC-EF-02 FPs. Zero genuine bypasses.
      │   Block: No production environment. H-01 = UNKNOWN.
      │   Status: COMPLETE / BLOCKED by environment
      │
      └── R-3: NON-BYPASS VERIFY PROTOCOL [EMPIRICAL TEST COMPLETE; IMPLEMENTATION NOT AUTHORIZED]
          Design: AUDITED_CONFIRMED (50_/51_)
          Empirical test: 9/9 cases correct (M001)
          Status: PARTIALLY_TRACTABLE (design level)
          Block: Authorization gate (F9-D01=A)
```

---

### Movement 001: R-3 Empirical Test

```
MOVEMENT 001
  Question: Does R-3 actually discriminate safe from unsafe alternatives?
  
  PATH TAKEN:
    9 synthetic test cases → all 9 correctly classified
    C-01: SAFE in explicit-policy domain (falsified "UNKNOWN always dominates")
  
  PATH AVOIDED:
    Claiming design correctness as production readiness
  
  SURPRISE: The assumption "UNKNOWN dominates" was an artifact of test design in
            earlier sessions. R-3 works for explicit-policy cases.
  
  OPENED: Three specific blockers for LABYRINTH-1 (B-1/B-2/B-3)
  CLOSED: R-3 conceptual incoherence concern
  
  NEW FRONTIER: Which of the three blockers is the PRIMARY one?
  CREATED: CCP Exploration Engine (docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md)
```

---

### Movement 002: Frontier Resolution

```
MOVEMENT 002
  Question: Which blocker is primary? Is policy explicitness the problem?
  
  BRANCHES EXPLORED:
  
  ├── ROUTE-POLICY: Is B-2 (policy explicitness) the primary blocker?
  │   Method: Analyze all 25 CCP policies against R-3 criteria
  │   Result: 20/24 actionable = EXPLICIT (83%). 4 PARTIAL with repair paths.
  │           RCE test: SAFE=6, UNKNOWN=1, UNSAFE=1 (75% SAFE rate).
  │   HIGH UNKNOWN RATE IN M001 = artifact of test case design, NOT CCP property.
  │   Status: CLOSED / NOT PRIMARY BLOCKER
  │
  ├── ROUTE-INDEP: Is B-1 (independence) solvable?
  │   Finding: R-3 uses "person" not "model." Context isolation via subagents
  │            satisfies the written requirement. 6/7 dimensions achievable.
  │            Model isolation (dim 7) not required.
  │   CDT-02: empirical test designed but NOT EXECUTED (requires new agent auth)
  │   Status: PARTIALLY_RESOLVED; CDT-02 remains DEFERRED (NOT_AUTHORIZED)
  │
  ├── ROUTE-B: Is hypothesis B (refuse + escalate) sufficient?
  │   Method: 5-scenario evaluation against known stall classes
  │   Result: SUFFICIENT for STA-01/03/04; NEEDS_MORE for STA-02; DELAYED for STA-05
  │   Finding: B is CONDITIONALLY_SUFFICIENT at current scale.
  │            B's weakness = information quality in complex cases (STA-02)
  │   Status: CLOSED / CONDITIONALLY_SUFFICIENT
  │
  └── ROUTE-ROGER: Is the Roger Hypothesis a new capability?
      Method: Concrete falsification test on CCP's artifact+registry system
      Finding: CCP already handles Roger's proposed "causal history preservation"
               scenario. Roger = formalization of CCP's implicit model.
      Status: CLOSED / REFORMULATION_CONFIRMED
  
  PRIMARY BLOCKER IDENTIFIED:
    Authorization gate (F9-D01=A) + H-01 materiality (field data needed)
    NOT policy explicitness. NOT model independence.
  
  SELF-CORRECTION: High UNKNOWN rate in M001 was our own test design flaw.
```

---

### Movement 003: Master Frontier Closure

```
MOVEMENT 003
  Question: What is the policy repair SAFE rate? What is the bypass coverage?
  
  CDT-01: Policy repair effectiveness
    Baseline: 75% SAFE (pre-repair, 8 scenarios)
    Post-repair: 87.5% SAFE (7/8 scenarios)
    Result: CONFIRMED. Repairs work.
  
  NH-02: bash-firewall semantic bypass coverage
    4 patterns cover ~75-80% practical bypass surface
    Status: PARTIALLY_SUPPORTED
  
  NH-04: P1'+P2'+P3 corpus coverage
    Covers 6/15 corpus. ${VAR} gap identified. P4 inadvisable (FP risk).
    Status: PARTIALLY_SUPPORTED
  
  BYPASS TAXONOMY DISCOVERED:
    4 upper families: Observation, Transformation, Storage, Transport
    6-level detection spectrum (L0..L5)
    Aliasing: bypasses ALL regex patterns → requires session taint tracking
    (This is a known gap; accepted for current context)
  
  DEAD END AVOIDED: P4 (word-boundary pattern) was shown inadvisable due to
                    high false positive risk. Not implemented.
  
  OPENED: READY-01/02/03 decision package structure
```

---

### Movement 004: Integration + Decision Readiness

```
MOVEMENT 004
  Question: NH-05/06/07 results? What are the L1-C conditions? What do decision packages look like?
  
  NH-05 (shlex normalization):
    Finding: shlex is a tokenizer, not an AST. It does not solve the ${VAR} gap.
    Status: PARTIALLY_SUPPORTED
  
  NH-06 (policy precedence):
    Finding: No active conflicts. CONFLICT-04 = missing spec, not precedence issue.
    Status: PARTIALLY_SUPPORTED
  
  NH-07 (enhanced denial messages):
    Finding: Closes information gap for STA-02. Is NOT an AC-03 substitute.
    Status: SUPPORTED (information gap; not judgment gap)
  
  NH-09 (NEW — 2 sed normalizations):
    Insight: Double-quote removal + brace normalization achieves Level-1 coverage
    Zero dependencies. LOW complexity.
    Status: SUPPORTED analytically (design level)
  
  NH-10 (NEW — escalation path):
    Finding: Handbook addition only. No authorization needed.
    Status: CONFIRMED — execute immediately
  
  L1-C: 5 conditions specified for LABYRINTH-1 exit.
  READY-01/02/03/04: structured as owner decision packages.
```

---

### Movement 005: NH-10 Implementation + Owner Package

```
MOVEMENT 005
  Question: Can NH-10 be implemented now? Is NH-09 semantically safe?
  
  NH-10: IMPLEMENTED
    Added §12 to CONTROL_PLANE_HANDBOOK
    5 scenarios validated
    L1-C Condition 3 SATISFIED
  
  UNK-M4-01: RESOLVED
    20-command corpus; 14 categories
    Double-quote removal = SAFE_NORMALIZATION
    4 limitations documented
    INVARIANT: COMMAND_NORM cannot be set to wrong value (execution path analysis)
  
  CONFLICT-04: RESOLVED (NH-10 closes the process gap)
  
  NH-11 (NEW): HYPOTHESIS
    Single-quote normalization (extend NH-09 step 1)
    NOT AUTHORIZED — logged for future consideration
  
  Owner decision package: CONSOLIDATED (58_OWNER_DECISION_PACKAGE.md)
  TRUE FRONTIER: 5 questions, all requiring owner input or real usage
```

---

### Movement 006: Pre-Authorization Adversarial Gate

```
MOVEMENT 006
  Question: Can READY-01/02/03/04 be broken before authorization?
  
  METHOD: 17-track adversarial audit
  
  CORRECTIONS MADE (important; these are historical facts):
  
  Finding A (HIGH): READY-01 was misclassified as "documentation-only"
    Original: "just documenting existing policy intent"
    Corrected: 3 of 4 repairs ADD NEW CONSTRAINTS to current rules
    Implication: Requires owner authorization for policy changes, not just doc edits
  
  Finding B (MEDIUM): READY-03 N threshold undefined
    Added: "REQUIRED OWNER INPUT" field; owner must define N
    Implication: Can't accept READY-03 without N
  
  Finding C (LOW): READY-03 RISK: MEDIUM was wrong
    Corrected: RISK: UNKNOWN (insufficient evidence for MEDIUM classification)
  
  Finding D (LOW): READY-02 dual-variable architecture note
    Added: Note about COMMAND/COMMAND_NORM invariant preservation requirement
  
  Finding E: UNK-M4-01 dangling entry cleaned (already RESOLVED in M005)
  
  NH-09 INVARIANT: CONFIRMED independently
    Variable lifecycle trace: COMMAND_NORM cannot be set before sed operations run.
  
  STOP CONDITION: "No authorized research remains."
  
  MOVEMENT 007 CHALLENGE: "That's correct for the previous path. New routes exist."
```

---

### Movement 007: Frontier Breakout

```
MOVEMENT 007
  Challenge to M006: Is "research should stop" the final conclusion?
  
  8 ASSUMPTIONS ATTACKED:
  
  B1: "bash-firewall is the right architecture"
    Verdict: APPROPRIATE NOW; INSUFFICIENT FOR PRODUCTION SCALE
    (Not wrong — just scoped)
  
  B2: "Regex is the right enforcement primitive"
    Verdict: CORRECT FOR SYNTACTIC; WRONG FOR SEMANTIC
    (Known limitation; accepted for current context)
  
  B3: "READY-01/02 are independent decisions"
    Verdict: PARTIALLY CONFIRMED — THE SPLIT IS AN ARCHITECTURE ARTIFACT
    PAC experiment proves: single YAML source collapses both decisions.
  
  B4: "State model is complete"
    Verdict: FUNCTIONAL BUT INCOMPLETE for operational monitoring
    Gap: no security posture score, policy coverage %, known FP rate, L1-C trend
  
  B5: "H-01 requires field data"
    Verdict: PARTIALLY WRONG — N=1 threshold derivable analytically
    N=1 = any event with had_alternative≠null is informative
  
  B6: "FPs are an unknown problem"
    Verdict: WRONG — new FP class PAC-EF-02 discovered experimentally
    PATTERN_NAME_IN_LITERAL: commit messages referencing dangerous pattern names trigger firewall
  
  B7: "PAC is theoretical"
    Verdict: WRONG — prototype built; compiler functional; zero drift
  
  B8: "HRQS is future work"
    Verdict: WRONG — HRQS checklist is executable NOW (documentation-only)
  
  PAC EXPERIMENT:
    Built: ccp_policies.yaml (13 policies), pac_compiler.py
    Finding: Zero drift between YAML policy intent and derived patterns
    Discovery: PAC-EF-02 false positive class (experimental result, not design claim)
    Status: PROTOTYPE / SUPPORTED / NOT PRODUCTION (authorization required)
  
  3 EXECUTION TRACKS AUTHORIZED NOW:
    1. HRQS checklist (handbook §13)
    2. PAC corpus completion (research artifact)
    3. query-log.sh (ALREADY CREATED)
  
  NEW FRONTIER:
    OWNER DECISION GATE → N DEFINITION → H-01 MONITORING
    + HRQS (executable now)
    + PAC corpus (executable now)
```

---

## Paths Not Taken

| Path | Why Not Taken | Status |
|---|---|---|
| VERITAS OS as R-3 solution | Refusal terminal; no alternative generation | CLOSED/REFUTED |
| Temporal/DBOS as R-3 solution | Cover crashes, not policy-blocked continuation | CLOSED/REFUTED |
| LangGraph as R-3 solution | Same: covers failures, not semantic bypass verification | CLOSED/REFUTED |
| State-Aware Runtime v4 | Conceptual paper; no published implementation | CLOSED/REFUTED |
| arXiv:2606.31339 | Multi-robot structured domain; not open-ended | CLOSED/REFUTED |
| ae-framework | Dry-run only; no alternative generation | CLOSED/REFUTED |
| P4 (word-boundary regex) | High FP risk demonstrated analytically | DEAD_END |
| NH-11 immediately | Not authorized; hypothesis status only | DEFERRED |
| CDT-02 (blind verifier test) | Requires new agent; not authorized (F9-D01=A) | BLOCKED |
| AC-03 (subagent verifier) | Requires new agent; not authorized | BLOCKED |
| Integrity controls A-05/A-07/G-N5 | Requires external trigger (F9-D04=B) | DEFERRED |
| Production PAC adoption | Architecture change; requires authorization | BLOCKED (needs READY) |

---

## Paths Blocked

| Path | Block | Unblock Condition |
|---|---|---|
| H-01 field data | No production environment | Real usage |
| P1'/P2' production FP rate | No production environment | Real usage |
| CDT-02 | F9-D01=A | Reproducible incident or explicit auth |
| AC-03 | F9-D01=A | Same |
| F10-F12 | F9-D05=A | Concrete problem with evidence crossing phase threshold |
| Native Claude Code lifecycle | F9-D02=B | Deterministic G-B11 recurrence or native integration decision |

---

## Paths Deferred

| Path | Why Deferred | Reactivation |
|---|---|---|
| Commercial viability (H-03) | Not prioritized; would require market validation track | Owner decision to pursue |
| NH-11 (single-quote normalization) | Hypothesis; no authorization | Authorize NH-11 research |
| SAGR as recovery | CCP architecture handles it | Concrete incident CCP can't cover |
| Semantic policy representation | Requires prior ROUTE-POLICY analysis | (Done; ROUTE-POLICY resolved; next step = AC-02) |

---

## Paths Reformulated

| Original | New Formulation | Why |
|---|---|---|
| "Roger is a new capability" | "Roger is a formalization of CCP's existing model" | Concrete scenario test showed CCP already handles it |
| "High UNKNOWN rate is a CCP problem" | "High UNKNOWN was our test design flaw" | M001 synthetic cases were biased; CCP is 83% EXPLICIT |
| "READY-01 is documentation-only" | "READY-01 adds new constraints" | M006 adversarial audit found 3/4 repairs add new rules |
| "READY-03 risk is MEDIUM" | "READY-03 risk is UNKNOWN" | Evidence insufficient for MEDIUM classification |
| "N requires field data" | "N=1 derivable analytically" | M007 showed any had_alternative event is informative |

---

## State Machine History (Key Transitions)

| Item | From | Event | To |
|---|---|---|---|
| R-3 protocol coherence | HYPOTHESIS | M001: 9/9 cases correct | PARTIALLY_TRACTABLE |
| Policy explicitness blocker | HYPOTHESIS | M002: 83% explicit | NOT_PRIMARY_BLOCKER |
| Roger Hypothesis | INDETERMINED | M002: falsification test | REFORMULATION_CONFIRMED |
| CDT-01 | HYPOTHESIS | M003: 87.5% SAFE rate | CONFIRMED |
| NH-09 | HYPOTHESIS | M004: design analysis | SUPPORTED (design) |
| NH-10 | HYPOTHESIS | M005: handbook addition | IMPLEMENTED |
| UNK-M4-01 | OPEN | M005: 20-cmd corpus | RESOLVED (SAFE_NORMALIZATION) |
| CONFLICT-04 | OPEN | M005: NH-10 closes gap | RESOLVED |
| L1-C Condition 3 | UNSATISFIED | M005: NH-10 | SATISFIED |
| READY-01 classification | DOCUMENTATION_ONLY | M006: adversarial audit | CONSTRAINT_ADDING |
| READY-03 risk | MEDIUM | M006: adversarial audit | UNKNOWN |
| PAC | HYPOTHESIS | M007: prototype built | PROTOTYPE_SUPPORTED |
| PAC-EF-02 | UNKNOWN | M007: experiment | NEW_FP_CLASS_DISCOVERED |
| HRQS gap | UNKNOWN | M007: identified | NOW_EXECUTABLE |
