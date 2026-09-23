# 61 — CCP Complete Handoff: The Full Journey

**Created:** 2026-09-23  
**Authority:** This document is a canonical continuity checkpoint. It does not supersede PROJECT_STATE.md, EVIDENCE_REGISTRY.md, or DECISION_REGISTRY.md as operational sources of truth. It reconstructs the journey so a new AI/session can enter without losing history.  
**Status:** Active continuity layer — Phase A of Master Execution Prompt

---

## Part I — What CCP Is

### 1.1 The Core Idea

The **Claude Control Plane (CCP)** is an engineering governance infrastructure for Claude Code. It is not a product, not a chatbot, and not an AI framework. It is the set of controls, contracts, and verification mechanisms that make Claude Code's work auditable, reversible, and trustworthy.

The founding principle (and it was stated early and never abandoned):

```
BENEFIT > COMPLEXITY
```

No hook, registry, skill, agent, or architecture component exists unless it eliminates a demonstrated risk. The system is deliberately minimal.

### 1.2 What CCP Actually Does Today

```
OWNER / DEVELOPER
      ↓
CLAUDE CODE TAKES AN ACTION
      ↓
HOOK INTERCEPTS (P0 security, P1 verification, P2 state, P3 logging)
      ↓
bash-firewall.sh — blocks dangerous shell commands (fail-closed)
secret-guard.sh  — blocks secret exposure
task-completed-evidence.sh — blocks DONE without verified evidence contract
      ↓
IF BLOCKED → STALL_POLICY logged → human review
IF ALLOWED → action executes → evidence created
      ↓
EVIDENCE REGISTRY (EV-NNN entries with hash, reviewer, provenance)
      ↓
PHASE GATE (no phase advances without PASS evidence)
      ↓
PROJECT_STATE.md updated
```

The research layer (MOVEMENT 001-007) investigates whether the blocked-continuation path (LABYRINTH-1) can be automated safely. It has not yet been implemented.

### 1.3 What CCP Is Now (After the Full Journey)

CCP is best understood as:

```
EXECUTION CONTROL + EVIDENCE INFRASTRUCTURE + GOVERNANCE RESEARCH ENGINE
```

- **Execution control:** hooks that fail-closed prevent irreversible or dangerous actions
- **Evidence infrastructure:** every significant change has a structured, verifiable evidence entry
- **Governance research engine:** systematic exploration of the frontier between "human must review" and "agent can verify safely"

It is not yet an "AI governance platform" in a commercial sense. It is a well-engineered single-developer control plane with a research track that explores the hardest remaining problem: what should happen when an agent hits a policy block and has an alternative?

---

## Part II — The Build Journey (F1–F8)

### 2.1 Timeline Summary

| Phase | Status | Key Deliverable | Evidence | Date |
|---|---|---|---|---|
| F0 | PASS | Master Implementation Plan, research audit | — | 2026-09-16 |
| F1 | PASS | Installable foundation, canonical registries | EV-001 | 2026-09-16 |
| F2 | PASS | Evidence contract + TaskCompleted gate | EV-002 | 2026-09-16 |
| F3 | PASS | SDLC lanes, Tier 1/2/3 evals | EV-005 | 2026-09-17 |
| F4 | PASS | Incident learning: INCIDENT/CONTROL/REGRESSION registries | EV-006 | 2026-09-17 |
| F5 | PASS | State integrity: hash + drift detection in PreCompact/SessionStart | EV-007 | 2026-09-17 |
| F6 | PASS | Evals + maintenance suite (evals/maintenance.sh) | EV-008 | 2026-09-17 |
| F7 | VERIFIED | Evidence integrity, behavioral reliability, anti-loop, firewall hardening | EV-009..EV-014 | 2026-09-18 |
| F8 | VERIFIED | contract_hash fail-closed, JSON firewall hardening, reviewer convention | EV-015, EV-016 | 2026-09-19 |

### 2.2 F1 — Foundation

**Problem:** No clean installable baseline. settings.json had invalid comments. SubagentStart had no verified context injection mechanism. Evidence registry absent.

**Solution:** 
- install.sh validates and serializes settings.json
- Canonical registries in docs/00_SYSTEM/
- SubagentStart injects context packs by role (ARCH-002: no dependency on unverified `skills:` field)
- ARCH-001: everything at project scope (.claude/), not global

**Result:** EV-001. Clean smoke test. F1 = PASS / FROZEN at e39...

### 2.3 F2 — Evidence Contract

**Problem:** TaskCompleted hook validated text by regex match on Markdown. Easy to bypass or accidentally satisfy.

**Solution:**
- Structured evidence contract with: task_id, claim, source, provenance, confidence, status, artifact_hash, contract_hash, checks, reviewer, exceptions, timestamp
- Hook blocks with exit 2 if any field missing or invalid
- ARCH-003: evidence canonical path = docs/00_SYSTEM/EVIDENCE_REGISTRY.md

**Result:** EV-002. F2 = PASS.

### 2.4 F3–F4 — SDLC Lanes + Incident Learning

**F3:** Established four SDLC workflow skills (TDD, code-review, constraint-driven, doubt-driven) with Tier 1/2/3 evals. Tier 3 was initially blocked by unauthenticated CLI (EV-003, EV-004 = BLOCKED), then passed when authenticated (EV-005).

**F4:** Incident learning framework. Three-registry linkage: INCIDENT_REGISTRY → CONTROL_REGISTRY → REGRESSION_REGISTRY. Every incident requires: RCA + missing control + regression fixture that proves the control works.

### 2.5 F5–F6 — State Integrity + Maintenance

**F5:** PreCompact hook hashes critical PROJECT_STATE fields. SessionStart detects drift. This is why `STATE_INTEGRITY: DRIFT_DETECTED` appears in session starts when PROJECT_STATE was modified outside of a checkpoint commit.

**F6:** evals/maintenance.sh — deterministic 12-diagnostic health check. Must pass 12/12 before closing any phase. Git CI workflow added.

### 2.6 F7 — Evidence Integrity + Behavioral Reliability

**Background:** Post-F6 behavioral audit (2026-09-18) discovered 11 bugs via adversarial testing. F7 addressed them systematically.

**Key changes:**
- Stop anti-loop: prevents infinite verification cycles
- Firewall hardened: tolerates spaces/case variations; positional pattern anchoring
- Freshness check: Tier 3 eval freshness window (30 days)
- secret-guard positive fixture
- ARCH-004 introduced: CONTRACTUAL TASK vs. SUBTASK vs. RESEARCH NOTE semantics; task_id coupling
- Session log daily rotation (reversible)
- Installer idempotent with --force flag

**Result:** EV-009 through EV-014. REG-002 through REG-009. Independent review PASS. 12/12 maintenance.

### 2.7 F8 — Closing Deferred F7 Gaps

**Background:** F7 research identified two deferred security gaps (A-03: contract_hash optional; A-04: malformed JSON payloads pass firewall).

**Changes:**
- F8-A: contract_hash MANDATORY (fail-closed). ARCH-004 addendum: "omission blocks with exit 2."
- F8-B: bash-firewall.sh rejects NUL bytes and non-single firewall payloads
- A-06: reviewer identity convention documented in CONTROL_PLANE_HANDBOOK §12

**Result:** EV-015, EV-016. REG-010, REG-011. F8 = COMPLETE / VERIFIED / FROZEN at 2cd7953.

---

## Part III — The Research Journey (F9 + Movements)

### 3.1 The Research Question

After F8, the project reached a stable working system. The remaining question was:

> Can an agent safely continue past a policy block, using a verified alternative — without bypassing the policy's intent?

This is **LABYRINTH-1**: Policy-Aware Continuation with Non-Bypass Verification. It has three compounding blocks:
- **B-1:** Independence (same model proposes AND verifies = not independent)
- **B-2:** Policy explicitness (vague policies collapse to UNKNOWN)
- **B-3:** Usefulness threshold undefined (owner preregistration required)

The research journey (F9 → M001 → M007) explored whether any path through this labyrinth exists.

### 3.2 F9 Research (2026-09-18 to 2026-09-19)

**Conclusion:** `F9 NOT JUSTIFIED` — research was needed before any implementation.

The F9 research identified:
- R-2: STALL_POLICY instrumentation (implemented)
- R-3: Protocol design for non-bypass verification (designed, not implemented)
- Five owner decision surfaces (F9-D01..F9-D05)

**F9 Owner Decision Gate (2026-09-20, CLOSED):**
- F9-D01 = A: Keep F9 implementation closed
- F9-D02 = B: Defer native Claude Code evidence until concrete trigger
- F9-D03 = B: Keep documentary candidates deferred
- F9-D04 = B: Require external trigger for integrity work
- F9-D05 = A: Keep F10-F12 UNKNOWN / NOT STARTED

### 3.3 The Research Phase (M001–M007)

After F9 closed, the project entered an autonomous research phase. Seven movements were executed, each producing evidence-backed reclassifications.

---

## Part IV — Movement History

### MOVEMENT 001 — R-3 Empirical Test + CCP Exploration Engine

**Date:** 2026-09-23  
**Question:** Does the R-3 non-bypass verification protocol actually work? Can it discriminate safe alternatives from bypasses?

**What was expected:** The protocol might fail for UNKNOWN-heavy cases.

**What happened:** 9/9 synthetic test cases correctly classified. C-01 produced SAFE in the explicit-policy domain. "UNKNOWN always dominates" falsified.

**Created:** 
- docs/research/CCP_FINAL_RECONCILIATION/53_R3_EMPIRICAL_TEST.md
- docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md (navigation mechanism for research)

**Result:** R-3 = PARTIALLY_TRACTABLE (design level). Exploration Engine operational.

**New frontier:** Three specific blockers identified for LABYRINTH-1. Which is the PRIMARY one?

---

### MOVEMENT 002 — Frontier Resolution Expedition

**Date:** 2026-09-23  
**Question:** Which of the three blockers (B-1 independence, B-2 explicitness, B-3 usefulness) is actually the primary obstacle?

**What happened:**
- Policy corpus: 25 policies → 20 EXPLICIT (83%), 4 PARTIAL, 1 META. B-2 is NOT primary.
- Independence: R-3 uses "person" not "model." Context isolation via subagents satisfies the written requirement. B-1 is resolvable in principle (CDT-02 still needed).
- Hypothesis B (refuse + escalate): CONDITIONALLY_SUFFICIENT at current CCP scale for 3/5 stall classes.
- Roger Hypothesis: REFORMULATION_CONFIRMED. CCP's existing artifact+registry system already handles the proposed pattern. Roger ≠ new capability.

**Surprise:** The high UNKNOWN rate in MOVEMENT 001 was an artifact of test case design, not a CCP-wide property. This was a self-correction.

**Result:** PRIMARY BOTTLENECK = Authorization gate (F9-D01=A) + H-01 materiality (unknown stall frequency)

**Closed:** ROUTE-POLICY, ROUTE-B, ROUTE-ROGER (all resolved)

---

### MOVEMENT 003 — Master Frontier Closure Expedition

**Date:** 2026-09-23  
**Question:** CDT-01 (policy repair SAFE rate), NH-02 (semantic bypass coverage), NH-04 (P1'+P2'+P3 corpus coverage)

**Results:**
- CDT-01: SAFE rate 87.5% after policy repair (vs. 75% baseline). CONFIRMED.
- NH-02: PARTIALLY_SUPPORTED. 4 patterns cover ~75-80% practical bypass surface.
- NH-04: PARTIALLY_SUPPORTED. P1'+P2'+P3 cover 6/15 corpus. ${VAR} gap. P4 inadvisable (FP risk).
- Bypass taxonomy: 4 upper families (Observation, Transformation, Storage, Transport). 6-level detection spectrum. Aliasing bypasses ALL proposed patterns.
- READY-01/02/03 decision packages identified and structured.

---

### MOVEMENT 004 — Frontier Integration + Decision Readiness

**Date:** 2026-09-23  
**Question:** NH-05/06/07 results; L1-C conditions; minimum viable owner decision packages

**Results:**
- NH-05: PARTIALLY_SUPPORTED — shlex is tokenizer not AST; ${VAR} needs separate regex
- NH-06: PARTIALLY_SUPPORTED — no active policy conflicts; CONFLICT-04 = missing spec, not precedence conflict
- NH-07: SUPPORTED — enhanced denial messages close information gap for STA-02; ≠ AC-03
- NH-09 (NEW): SUPPORTED — 2 sed normalizations achieve Level-1 coverage; zero dependencies; LOW complexity
- NH-10 (NEW): CONFIRMED — escalation path = handbook addition only; no auth needed
- L1-C: 5 conditions specified; minimal/practical/strong closure distinguished
- READY-01/02/03 fully structured as owner decision documents

---

### MOVEMENT 005 — NH-10 Implementation + UNK-M4-01 + Owner Package

**Date:** 2026-09-23  
**Question:** Is NH-10 safe to implement now? What is the exact status of NH-09's semantic safety?

**Results:**
- NH-10: IMPLEMENTED (handbook §12 escalation path added)
- UNK-M4-01: RESOLVED — double-quote removal is SAFE_NORMALIZATION; 4 limitations documented
- CONFLICT-04: RESOLVED — NH-10 closes the process gap
- L1-C Condition 3: SATISFIED (1/5 conditions met)
- NH-11: HYPOTHESIS — single-quote normalization; NOT AUTHORIZED
- READY-01/02/03/04: consolidated in 58_OWNER_DECISION_PACKAGE.md

---

### MOVEMENT 006 — Pre-Authorization Adversarial Gate

**Date:** 2026-09-23  
**Question:** Can READY-01/02/03/04 be broken before owner authorization? Are they correctly scoped?

**Method:** Systematic adversarial audit of all four decision packages across 17 tracks (source audit, independent invariant verification, cross-decision interactions, branch simulation, authorization audit, hidden dependencies, etc.)

**Findings:**
- Finding A (HIGH): READY-01 misclassified as "documentation-only." 3 of 4 policy repairs add NEW constraints/exceptions to existing rules — not just editorial clarification. Decision question reframed.
- Finding B (MEDIUM): READY-03 N threshold undefined. "REQUIRED OWNER INPUT" field added.
- Finding C (LOW): READY-03 RISK: MEDIUM → corrected to RISK: UNKNOWN
- Finding D (LOW): READY-02 dual-variable architecture note added
- Finding E (ADMIN): UNK-M4-01 dangling OPEN entry cleaned

**NH-09 INVARIANT:** CONFIRMED. COMMAND_NORM cannot be executed because the two sed operations run on the COMMAND variable before COMMAND_NORM is set. COMMAND_NORM = COMMAND at the start of the conditional block. The invariant holds.

**Conclusion:** "Research should stop. Owner decisions are the correct next action."

---

### MOVEMENT 007 — Frontier Breakout + Autonomous Advancement

**Date:** 2026-09-23  
**Question:** Is M006's "research should stop" conclusion correct, OR does a new formulation create a route forward?

**Challenge to M006:** The conclusion is correct for the PREVIOUS research path. It does NOT mean no new routes exist. MOVEMENT 007 attacks 8 CCP assumptions and explores new formulations.

**Assumptions attacked:**
- B1: "Bash-firewall is the right architecture" → APPROPRIATE FOR CURRENT CONTEXT; INSUFFICIENT FOR PRODUCTION SCALE
- B2: "Regex is the right enforcement primitive" → CORRECT FOR SYNTACTIC ATTACKS; WRONG FOR SEMANTIC
- B3: "READY-01/READY-02 are independent" → PARTIALLY CONFIRMED: the split is an architecture artifact
- B4: "Current state model is complete" → FUNCTIONAL BUT INCOMPLETE for operational monitoring
- B5: "H-01 materiality requires field data" → N=1 can be derived analytically (confirmed)
- B6: "False positives are an unknown problem" → NEW FP CLASS discovered experimentally (PAC-EF-02)
- B7: "PAC is only a theoretical direction" → Prototype built; works; compiler functional
- B8: "HRQS gap is future work" → HRQS checklist is executable NOW (documentation-only)

**PAC Prototype (Policy-as-Code):**
- 13 policies extracted from rules/*.md and documented in YAML
- Compiler built (pac_compiler.py) that translates policy YAML to bash patterns
- Zero semantic drift detected: each derived pattern matches the corresponding manual pattern
- BREAKOUT CANDIDATE: B1 (PAC) identified because it collapses READY-01/02 into one decision

**New FP Class Discovered — PAC-EF-02 (PATTERN_NAME_IN_LITERAL):**
- During the PAC experiment, a command that references a dangerous pattern's name as a literal identifier (e.g., `git commit -m "fix: bypass for testing"`) triggered the word "bypass" in the commit message → caught by a firewall pattern designed to catch `--bypass` flags
- This is a REAL false positive class, not a theoretical concern
- Current H-01 count = 2, BOTH are PAC-EF-02 false positives from this experiment

**H-01 Monitoring Tool:**
- query-log.sh created and operational (docs/00_SYSTEM/query-log.sh)
- N=1 threshold recommended analytically: any STALL_POLICY event with had_alternative≠null is immediately informative

**Created:** 17-idea portfolio (60A_IDEA_PORTFOLIO.md), PAC prototype (docs/research/pac/), P1'/P2' exact regex specification (§C2), 60_FRONTIER_BREAKOUT.md

**Result:** Broader frontier than M006. Three parallel execution tracks identified:
1. HRQS checklist (authorized, documentation-only)
2. PAC corpus completion (authorized, research artifact)
3. query-log.sh H-01 monitoring (ALREADY CREATED)

---

## Part V — Architecture Evolution

### 5.1 Hooks (Control Layer)

| Hook | When added | Problem it solves | Status |
|---|---|---|---|
| bash-firewall.sh | F1/P0 | Block dangerous shell commands | ACTIVE; hardened in F7/F8 |
| secret-guard.sh | F1/P0 | Prevent secret exposure | ACTIVE |
| task-completed-evidence.sh | F1/P0 | Block DONE without evidence | ACTIVE; fail-closed in F8 |
| subagent-context.sh | F1 | Inject context packs by role | ACTIVE |
| session-start.sh | F5 | Detect state drift on startup | ACTIVE |
| pre-compact.sh | F5 | Hash critical state fields before compaction | ACTIVE |
| session-log.sh | F7 | Log session activity with rotation | ACTIVE |
| stall-record.sh | M007 | Record STALL_POLICY events to log | ACTIVE |

The hook architecture is **fail-closed**: if a hook fails or returns unexpected exit code, the action is blocked. This is a deliberate safety choice.

### 5.2 Security Evolution

```
bash-firewall.sh (F1):
  → Simple pattern matching, reject known dangerous commands
  
F7 hardening:
  → Tolerates whitespace/case variations
  → Positional anchoring (no mid-word matches)
  
F8-B hardening:
  → Rejects NUL bytes
  → Rejects non-single payloads
  
NH-09 normalization (M004, READY-02):
  → PROPOSED: 2 sed operations normalize double-quotes and braces before pattern matching
  → NOT YET AUTHORIZED (READY-02 gate)
  
PAC architecture (M007, research):
  → Policy-as-Code: single YAML source of truth for both policy text and enforcement regex
  → Compiler auto-derives patterns from policy intent
  → PROTOTYPE ONLY; not production
```

**R-2 Instrumentation:** STALL_POLICY_LOG (docs/00_SYSTEM/STALL_POLICY_LOG.jsonl). 3 events total:
- 1 test event (rm -rf / maintenance test)
- 2 PAC-EF-02 false positives (M007 experiment)
- 0 genuine bypass events observed

**R-3 Non-Bypass Verification:** Protocol designed and empirically validated. 9/9 synthetic cases correctly classified. PARTIALLY_TRACTABLE. Not implemented (authorization gate).

### 5.3 Evidence Infrastructure

The evidence contract evolved across phases:
- F1: Structure defined (fields, schema)
- F2: Hook enforcement (blocks on missing fields)
- F7: ARCH-004 — task semantics; coupling of task_id + contract_hash
- F8-A: contract_hash MANDATORY (was optional in F7 transition)

All 16 evidence entries (EV-001..EV-016) are in docs/00_SYSTEM/EVIDENCE_REGISTRY.md.

### 5.4 CCP Exploration Engine

Created in MOVEMENT 001. This is the navigation mechanism for research — not a product feature. It maintains:
- Current position (§2)
- Current frontier (§3)
- Movement model vocabulary (§4)
- Active labyrinths (§5)
- Available routes (§6)
- Closed routes (§7)
- Reopen conditions (§8)
- Unexplored space (§9)
- Active experiments (§10)
- Movement results (§11+)
- Permanent movement history (§17)

**Key invariant:** A session that ends without a reclassification produced documentation, not movement.

### 5.5 PAC (Policy-as-Code) — Prototype Status

```
STATUS: PROTOTYPE — SUPPORTED — NOT PRODUCTION ADOPTION
CORPUS: 13 of 25+ policies extracted to YAML (INCOMPLETE)
COMPILER: Functional (pac_compiler.py in docs/research/pac/)
DRIFT: Zero detected between YAML policy intent and derived patterns
PRODUCTION MIGRATION: NOT AUTHORIZED (requires owner decision)
KEY FINDING: PAC would collapse READY-01/02 into a single decision
NEW DISCOVERY: PAC-EF-02 false positive class discovered during prototype
```

---

## Part VI — Security Posture Journey

### 6.1 Controls by Risk Level

| Control | Type | Level | Status |
|---|---|---|---|
| bash-firewall.sh | Preventive | P0 | ACTIVE + HARDENED |
| secret-guard.sh | Preventive | P0 | ACTIVE |
| task-completed-evidence.sh | Process | P0 | ACTIVE + FAIL-CLOSED |
| NH-09 normalization | Preventive | READY-02 gate | PROPOSED |
| non-bypass verifier (AC-03) | Verification | NOT AUTHORIZED | DEFERRED |
| Enhanced denial messages (AC-01) | Information | READY-04 gate | PROPOSED |
| Policy repair (AC-02) | Policy | READY-01 gate | PROPOSED |
| CDT-02 blind verifier test | Test | NOT AUTHORIZED | DEFERRED |

### 6.2 Known Gaps (Accepted)

| Gap | Why accepted | Condition to reopen |
|---|---|---|
| Variable aliasing bypasses all patterns | Single-developer; human-in-loop | Production scale or adversarial context |
| Semantic bypasses (heredoc, single-quotes) | NH-09 covers double-quotes only | Authorized NH-11 or similar |
| Cross-session context contamination | R-3 independence at design level | CDT-02 empirical test (needs auth) |
| Production FP rate unknown | Requires real usage | H-01 field data |

---

## Part VII — Owner Decision History

### 7.1 F9 Owner Decisions (Closed 2026-09-20)

| ID | Question | Decision | Consequence |
|---|---|---|---|
| F9-D01 | Authorize F9 implementation? | A — Keep closed | No runtime changes. Reactivation = reproducible incident. |
| F9-D02 | Get native Claude Code evidence now? | B — Defer | NATIVE_CLAUDE_CODE = NOT_VERIFIED. Not BROKEN. |
| F9-D03 | Promote documentary candidates? | B — Keep deferred | AC-03, AC-01, P3, CDT-02 remain deferred. |
| F9-D04 | Start integrity controls now? | B — Wait for external trigger | A-05, A-07, G-N5 deferred until audit/compliance/customer trigger. |
| F9-D05 | Open F10-F12? | A — Keep UNKNOWN | No scope definition until concrete problem with evidence. |

### 7.2 READY Decisions (Pending — not yet authorized)

| ID | What it authorizes | Current status | Key note |
|---|---|---|---|
| READY-01 | Policy disambiguation (AC-02) | OWNER_DECISION_READY | NOT "documentation-only": 3 of 4 repairs add new constraints (M006 correction) |
| READY-02 | NH-09 normalization + P1'/P2' patterns | OWNER_DECISION_READY | Requires maintaining COMMAND/COMMAND_NORM invariant |
| READY-03 | L1-C minimal closure (labyrinth exit condition B) | OWNER_DECISION_READY | RISK: UNKNOWN (not MEDIUM — M006 correction). Requires owner N threshold definition. |
| READY-04 | Enhanced-B message format (AC-01) | OWNER_DECISION_READY | ELEVATED URGENCY (M007): FP classification requires enhanced messages |

---

## Part VIII — Current Frontier

### 8.1 What Is Known (Closed)

- F1-F8 architecture: IMPLEMENTED + VERIFIED
- R-3 protocol coherence: EMPIRICALLY VALIDATED (9/9 cases)
- Policy explicitness: 83% EXPLICIT; 4 PARTIAL with repair paths identified
- Hypothesis B sufficiency: CONDITIONALLY_SUFFICIENT at current scale
- Roger Hypothesis: REFORMULATION (not new capability)
- NH-10 escalation path: IMPLEMENTED (handbook §12)
- NH-09 invariant: CONFIRMED (COMMAND_NORM cannot be set to wrong value)
- L1-C Condition 3: SATISFIED
- PAC feasibility: PROTOTYPE DEMONSTRATES ZERO DRIFT

### 8.2 What Blocks (Owner Gates)

- READY-01: Policy repairs need owner authorization (they add constraints, not just text)
- READY-02: NH-09 normalization + P1'/P2' hook changes need authorization
- READY-03: L1-C closure needs N threshold definition from owner
- READY-04: Enhanced denial messages need authorization (ELEVATED URGENCY)

### 8.3 What Blocks (Environment)

- H-01 stall frequency: needs real production usage; cannot be measured synthetically
- P1'/P2' production FP rate: needs real usage
- CDT-02 blind verifier: needs new agent authorization

### 8.4 Now-Executable (No Authorization Needed)

1. **HRQS checklist** — Human Review Quality Standard: adds §13 to CONTROL_PLANE_HANDBOOK; documentation-only
2. **PAC corpus completion** — extend docs/research/pac/ccp_policies.yaml with remaining patterns; research artifact
3. **query-log.sh** — H-01 monitoring tool: ALREADY CREATED at docs/00_SYSTEM/query-log.sh

---

## Part IX — What CCP Has Learned

1. **Policy/enforcement drift is real.** Having a policy in rules/*.md does not mean the firewall enforces it. PAC experiment confirmed: 25 policies exist; only ~13 were manually traceable to firewall patterns at prototype time.

2. **UNKNOWN discipline matters.** Claiming "probably safe" when evidence is insufficient produces false confidence. The project maintained UNKNOWN discipline throughout — never promoted a claim beyond its evidence.

3. **Evidence vs. assurance.** A VERIFIED evidence entry does not mean "safe." It means "we tested what we said we'd test, and it passed." The scope of the test is always bounded. This distinction prevented over-claiming.

4. **Recovery ≠ semantic recovery.** R-3 distinguishes between recovering from a failure (resuming work) and verifying that a proposed recovery is semantically non-bypassing. These are different problems with different solutions.

5. **Authorization is an architectural boundary.** F9-D01=A is not a bureaucratic gate. It is the recognition that implementing new controls changes what the system does, and that change requires human judgment. IMPLEMENTATION_READY: false is a correct architectural state.

6. **Human review limitations shape the design.** Hypothesis B (refuse + escalate to human) is conditionally sufficient because human reviewers can resolve most stall scenarios. HRQS identifies that the quality of the human review question matters. Better denial messages improve the human review path.

7. **Synthetic experiments have bounded value.** 9 synthetic cases validated R-3 coherence but cannot tell you if the labyrinth is material. H-01 requires real usage. This distinction was maintained consistently.

8. **False positives are a research output, not just a risk.** PAC-EF-02 was discovered during a prototype experiment. The experiment was not designed to find FPs. The finding emerged from execution. Empirical work produces unexpected results; maintaining the distinction DESIGN_RESULT vs. EXPERIMENTAL_RESULT captured this correctly.

9. **Research formulation effects the frontier.** MOVEMENT 007's challenge to MOVEMENT 006 was about formulation: "stop" was correct for the previous path, not for all paths. Reformulating the question opened 3 new authorized tracks.

10. **Architecture-induced decision duplication.** READY-01/02 exist as two separate decisions because the architecture has two representations of policy. PAC collapses them. The architecture created the split; architecture change eliminates it.

---

## Part X — "Why Didn't We Do X?" FAQ

**Q: Why wasn't AC-03 implemented?**  
A: AC-03 (subagent verifier) requires a new agent definition file. F9-D01=A explicitly prohibits new agent definitions without a new authorization cycle. CDT-02 (the test for AC-03) requires the same authorization.

**Q: Why wasn't CDT-02 executed?**  
A: Same as above. CDT-02 requires a blind subagent verifier, which requires a new agent file — not authorized per F9-D01=A.

**Q: Why weren't READY-02 changes implemented?**  
A: READY-02 modifies bash-firewall.sh. Any hook modification is a runtime change requiring explicit authorization. The decision package is ready but owner has not yet authorized.

**Q: Why wasn't P3 added?**  
A: P3 (single-quote normalization = NH-11) is a HYPOTHESIS, not a confirmed improvement. NH-02 showed 4 patterns cover ~75-80% of practical bypass surface; P4 was shown inadvisable due to FP risk. P3 wasn't evaluated yet and isn't authorized.

**Q: Why wasn't regex immediately replaced with something better?**  
A: BENEFIT > COMPLEXITY. For a single-developer dev control plane with human-in-the-loop, regex is appropriate. PAC is the direction for improvement but requires authorization. No replacement was justified by current evidence.

**Q: Why wasn't PAC adopted in production?**  
A: The PAC prototype demonstrates feasibility (zero drift, functional compiler). Production adoption changes the enforcement architecture — that requires owner authorization (READY-01/02 collapsed into one PAC decision). The prototype status was maintained correctly throughout.

**Q: Why wasn't H-01 inferred from synthetic experiments?**  
A: Because synthetic experiments cannot tell you how often a production agent hits a policy block with a viable alternative. The instrumentation (R-2) exists. The events must accumulate from real usage. Analytically, N=1 was derived as the materiality threshold — but the actual count requires real usage.

**Q: Why are historical files frozen?**  
A: F7 is frozen at 47874a5. F8 at 2cd7953. Freezing means: no retroactive changes to completed, verified work. The chain of evidence must remain intact. A future change creates a new evidence entry, not a retroactive modification.

**Q: Why are some changes behind authorization gates?**  
A: Because implementing controls changes what Claude Code can and cannot do. That boundary is the owner's to define. The research determines what would be beneficial; the owner determines what is authorized.

---

## Part XI — New AI Onboarding Guide

### What to Read First

1. `PROJECT_STATE.md` — current phase, objective, blockers, checkpoint
2. `docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md` — complete research state and frontier
3. `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` — 16 verified evidence entries
4. This document (61_CCP_COMPLETE_HANDOFF.md) — complete journey
5. `61C_CCP_DECISION_AND_AUTHORIZATION_HISTORY.md` — all decisions
6. `docs/00_SYSTEM/F9_OWNER_DECISIONS.md` — the five gating decisions

### What to Read Second

7. `docs/DESIGN.md` — architecture layers
8. `docs/CONTROL_PLANE_HANDBOOK.md` — operational handbook
9. `DECISION_REGISTRY.md` — ARCH-001..004
10. `docs/research/CCP_FINAL_RECONCILIATION/58_OWNER_DECISION_PACKAGE.md` — READY-01..04

### What to Read Third (As Needed)

11. `docs/MASTER_IMPLEMENTATION_PLAN.md` — the original contract
12. `docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md` — detailed technical history
13. `docs/research/CCP_FINAL_RECONCILIATION/59_PRE_AUTHORIZATION_ADVERSARIAL_GATE.md` — M006 adversarial audit
14. `docs/research/CCP_FINAL_RECONCILIATION/60_FRONTIER_BREAKOUT.md` — M007 results

### Do NOT Touch

- `.claude/hooks/bash-firewall.sh` — without passing F8-B fixtures
- `.claude/hooks/task-completed-evidence.sh` — without passing F2 + F8-A fixtures
- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` — never modify historical entries; only append
- Any F7/F8 frozen commits (47874a5, 2cd7953)
- `PROJECT_STATE.md` LAST_GIT_CHECKPOINT without running /checkpoint

### Can Modify (Authorized NOW)

- `docs/CONTROL_PLANE_HANDBOOK.md` — documentation additions (like HRQS §13)
- `docs/research/pac/ccp_policies.yaml` — extend PAC corpus (research artifact)
- `docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md` — update after a movement
- New research documents in `docs/research/CCP_FINAL_RECONCILIATION/`

### Requires Owner (Authorization Gate)

- Any change to `.claude/hooks/` 
- Any change to `.claude/settings.json` permissions
- Any new agent definition file
- READY-01: policy text modifications
- READY-02: NH-09 normalization + P1'/P2' patterns
- READY-03: L1-C closure implementation
- READY-04: enhanced denial message format

### Invariants to Preserve

1. **NH-09 invariant:** COMMAND_NORM must not be set before the sed operations run. Any hook modification must preserve this.
2. **contract_hash:** Mandatory in all CONTRACTUAL TASK evidence entries. Never optional.
3. **UNKNOWN discipline:** Never promote a claim beyond its evidence. "UNKNOWN" is a valid, correct state.
4. **Fail-closed:** If a hook fails or returns unexpectedly, the action is blocked. This is architectural.
5. **Evidence provenance:** EXTRACTED/INFERRED/ASSUMED/EXTERNAL/GENERATED — always explicit.

### Dead Ends (Do Not Repeat)

- Do not re-investigate Roger Hypothesis — REFORMULATION_CONFIRMED
- Do not re-investigate policy explicitness as primary blocker — 83% EXPLICIT; B-2 is NOT primary
- Do not re-investigate hypothesis B sufficiency — CONDITIONALLY_SUFFICIENT at current scale
- Do not investigate VERITAS OS / LangGraph / DBOS / State-Aware Runtime v4 as R-3 solutions — all closed in R-1
- Do not claim AC-03 is immediately implementable — requires F9-D01=A reactivation
- Do not claim the firewall is the wrong architecture for current context — APPROPRIATE FOR CURRENT SCALE

---

## Part XII — Summary State

```
WHAT IS BUILT AND VERIFIED:
  F1-F8: 10 hooks, 28+ skills, 5 agents, 6 context packs
  16 evidence entries (EV-001..EV-016)
  10 regression fixtures (REG-002..REG-011)
  Maintenance suite: 12/12 PASS

WHAT IS RESEARCHED BUT NOT IMPLEMENTED:
  R-3 non-bypass verification protocol
  PAC (Policy-as-Code)
  AC-03 subagent verifier
  NH-09 normalization
  Enhanced-B denial messages

WHAT AWAITS OWNER DECISION:
  READY-01 (policy repairs)
  READY-02 (normalization + patterns)
  READY-03 (L1-C closure + N threshold)
  READY-04 (enhanced messages)

WHAT AWAITS REAL USAGE:
  H-01 stall frequency
  P1'/P2' production FP rate
  Production bypass frequency

WHAT IS DEFERRED INDEFINITELY:
  F10-F12 (F9-D05=A)
  CDT-02 (F9-D01=A)
  AC-03 (F9-D01=A)
  Integrity controls A-05/A-07/G-N5 (F9-D04=B)
  Native Claude Code lifecycle evidence (F9-D02=B)

WHAT IS EXECUTABLE NOW (NO AUTHORIZATION NEEDED):
  HRQS checklist (handbook §13)
  PAC corpus completion (research)
  query-log.sh already created
```

---

*Handoff created by Claude Sonnet 4.6 on 2026-09-23 as Phase A of Master Execution Prompt.*  
*Authority for operational state: PROJECT_STATE.md*  
*Authority for evidence: EVIDENCE_REGISTRY.md*  
*Authority for decisions: DECISION_REGISTRY.md + F9_OWNER_DECISIONS.md*
