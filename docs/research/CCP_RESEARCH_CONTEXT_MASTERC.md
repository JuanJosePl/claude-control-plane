# CCP RESEARCH CONTEXT MASTER
## Claude Control Plane → SAGR → Assurance Research
### Context Cut Date: 21 September 2026
### Repository: `/home/juanls/Escritorio/claude-control-plane`

---

> **PURPOSE:** This file is the canonical research memory for the CCP/SAGR project. A future session reading only this file must be able to understand the full intellectual state of the project without access to the original conversation history. It is NOT a summary — it is a compressed but complete research record with provenance, corrections, contradictions, and continuation protocol.

---

## 00 EXECUTIVE ORIENTATION

### What this project is

A research and engineering project that began as an **AI Engineering Development Control Plane** (CCP) and evolved through multiple phases of technical implementation, competitive research, and deep hypothesis investigation into a broad inquiry about **what must be true for an autonomous agent to make a legitimately governed transition**.

### Where it is now

The project has reached a synthesis point after two major AI-investigator passes (GPT-5.6 Luna + Claude Code). It is NOT ready for new implementation. It is NOT ready for commercial claim. It requires a **FINAL META-AUDIT** of all produced research before any next step.

### The one-sentence summary of the research state

> We are trying to determine whether the next fundamental problem of autonomous agents is not how to execute or recover a session, but how to govern a complete trajectory toward an objective when the current route ceases to be valid — preserving state, evidence, security, authorization, context, side effects, cost, and failure memory — and whether that capability already exists under another name, is only a composition of existing primitives, or represents a genuinely new abstraction worth studying.

### Critical operational rules inherited from the project

```
BENEFIT > COMPLEXITY
EVIDENCE > CLAIM
RUNTIME > DOCUMENTATION
OBSERVED > ASSERTED
REPRODUCED > DESCRIBED
VERIFY > ASSUME
SIMPLE > CLEVER
REVERSIBLE > IRREVERSIBLE
FAIL-CLOSED > FALSE-PASS
TRUTH > OPTIMISM
FALSIFICATION > CONFIRMATION
PRIMARY SOURCE > SECONDARY SOURCE
CURRENT EVIDENCE > HISTORICAL ASSUMPTION
BOUNDED UNCERTAINTY > FAKE CERTAINTY
STALL ≠ PERMISSION TO BYPASS SAFETY
```

---

## 01 PROJECT IDENTITY

| Field | Value |
|---|---|
| Project name | Claude Control Plane (CCP) |
| Repository | `/home/juanls/Escritorio/claude-control-plane` |
| Original purpose | AI Engineering Development Control Plane |
| Current technical baseline | F1–F8 COMPLETE/FROZEN, F9 NOT JUSTIFIED, F10 NOT OPENED |
| HEAD commit at last observation | `74f7d1e` (second Claude pass); dossier anchored to `035a573` (STALE) |
| Commercial thesis | NOT SUPPORTED (standalone Claude-specific agent control plane) |
| Field validation round | ROUND 0 — 0 interviews, 0 buyer evidence, 0 WTP, 0 pilot |
| Research state | META-AUDIT PENDING |

---

## 02 RESEARCH MISSION

### Original mission

Build a control plane for AI-agent-driven software engineering with:
- security
- traceability
- quality
- verifiability
- reversibility
- context control
- state control
- reduced manual work
- reduced errors
- reuse
- productivity
- maintainability
- evolutionary capacity
- objective evidence of "done"

### Evolved mission (current)

Determine whether a unified primitive or architecture exists for **governing the continuation of an autonomous execution** when the current trajectory becomes invalid — under constraints of safety, state, evidence, cost, authorization, and failure memory.

### Meta-mission (deepest current layer)

Determine whether **continuous assurance closure across the intent–effect chain** already exists under another name, is only a partial composition, or represents a genuine open problem worth engineering.

---

## 03 CHRONOLOGICAL RECONSTRUCTION

### Phase 0 — Original CCP Vision
**Outcome:** Built the core engineering control plane concept. Established the rule: agent cannot simply say DONE without verifiable evidence.

### Phase F1 — Foundation
**Outcome:** Installable foundation with coherent state.
**Evidence artifact:** `EV-001`

### Phase F2 — Evidence Contract + TaskCompleted Hardening
**Outcome:** Evidence Contract system, hardened TaskCompleted gate.
**Evidence artifact:** `EV-002`

### Phase F3 — SDLC Lanes + Independent Verification
**Initial blocker:** Claude CLI executions used `--bare`, preventing OAuth/keychain → `Not logged in` errors.
**Resolution:** Without `--bare`, CLI authenticated correctly. Tier 3 tests passed.
**Outcome:** F3 validated.

### Phases F4–F6
**Outcome:** Developed as part of system evolution, included in historical baseline.

### Phase F7 — COMPLETE / FROZEN
**Commit:** `47874a5`
**Components added:**
- stop anti-loop
- firewall (bash-firewall.sh)
- evidence coupling
- session log rotation
- installer idempotency

### Phase F8 — COMPLETE / FROZEN
**Commit:** `2cd7953`
**Components added:**
- TaskCompleted fail-closed when contract_hash missing
- firewall fail-closed on malformed JSON
- reviewer identity convention

### Phase F9 — NOT JUSTIFIED
**Decision:** No candidate simultaneously passed: sufficient impact + insufficient control + proportional benefit + reversible scope.
**Status:** Research-only, no implementation.

### Phase F10–F12 — UNKNOWN / RESEARCH REQUIRED
**Status:** Must NOT be opened automatically. Requires explicit justification from completed meta-audit.

### Commercial Investigation Phase
**Outcome:** Discovered that "agent control plane" category is NOT empty. Found: Microsoft Agent 365, Microsoft Entra Agent ID, Salesforce Agent Fabric, Boomi Agent Control Plane, GitHub Enterprise AI Controls, Zenity, TrueFoundry, AIGIS.
**Conclusion:** `COMMERCIAL THESIS NOT SUPPORTED` for standalone Claude-specific control plane.

### AIGIS Teardown
**Repository:** `cd-aguilar/aigis-control-plane`
**Commit inspected:** `e095eb6`
**Test results:** 234 tests: 223 passed, 10 failed, 1 skipped
**Finding:** AIGIS has TaskContract, typed models, policy engine (ALLOW/DENY/REQUIRE_HUMAN), ToolRequest, sandbox (Docker, no-network, non-root, read-only), quality gates, JSON evidence bundles, SHA-256 artifacts, deterministic decision engine, circuit breakers.
**Critical conclusion:** **Evidence-gated execution was NOT unique to CCP.**

### GuardFall Incident
**Finding:** `bash-firewall.sh` blocked legitimate commands containing the substring `rm -rf ` — a false positive. Later the firewall also blocked a commit message containing the destructive pattern.
**Significance:** A security control can become a productivity problem if it cannot sufficiently differentiate context and behavior. This was one of the conceptual triggers for SAGR.

### First SAGR Research Phase
**Structure:** 17 tracks (A–Q) covering agent execution recovery, context/memory, state machines, multi-agent recovery, loop detection, control-induced stalls, cost/token efficiency, safety+recovery, SE analogues, agent harness ecosystem, academic landscape, standards, failure corpus, competitive search, business/economics, adversarial architecture review, novel composition.
**Outcome:** 22 primitives identified (P1–P22). Many existing implementations found for each.

### GPT-5.6 Luna — First Investigator
**Materials produced:**
- `NOTAS_AGENTES_ACADEMIA.md`
- `NOTAS_AUDITORIA_DOSSIER.md`
- `NOTAS_COMERCIAL_ECONOMIA.md`
- `NOTAS_CONTROL_SEGURIDAD.md`
- `NOTAS_RECONSTRUCCION_REPOSITORIO.md`
- `NOTAS_SISTEMAS_CLASICOS.md`
- **Total:** ~3,452 lines

**Important finding:** GPT did NOT produce the 30+ originally planned numbered files. It produced 6 consolidated notes. This was classified as a structural finding, not necessarily an intellectual failure.

**GPT also audited the dossier and found problems:**
- OSGuard incorrectly described
- RIR "70%" without reproducible rubric
- Baseline possibly outdated
- Claims too strong
- Confusion between evidence types
- Gaps presented too broadly

**GPT cost problem:** Delegated many subagents → consumed budget/rolling usage rapidly. New rule established: subagents only when work is genuinely independent and expected information gain justifies cost.

### Claude Code — Second Investigator
**Initial problem:** WebSearch/WebFetch reported as "deferred" — appeared unavailable. Resolution: tools needed to be loaded via ToolSearch. `DEFERRED ≠ UNAVAILABLE`.
**Second problem:** `claude-mem` quota exhausted → affected persistent memory only, NOT web access.
**Protocol established:** `ToolSearch → load WebSearch/WebFetch → test search → research`

**Materials produced:** `CLAUDE_SECOND_PASS/` — 21 files total (00 inventory + 01–20 new).

**Claude actually performed real web research** on: OSGuard, Recoverability as a System Primitive, RIR v2, AgentRewind, control-induced/policy-induced stalls, execution trajectory, Temporal, LangGraph, execution governance, recovery budget.

**Four major corrections by Claude:**
1. **OSGuard**: Not simply "fixed retry / hard stop" — real mechanism was block → feedback → revise action → re-check → retry limit.
2. **Recoverability**: Paper "Recoverability as a System Primitive" already formalizes part of governed recovery — contradicts "no formal classification exists."
3. **RIR**: "60–70% / 70%" had no reproducible rubric → **false precision**.
4. **Side-effect continuity**: Not an absolute vacuum — Living AI, Replay Agent Recorder, AgentRewind exist.

**Claude killed the hypothesis:** durable execution = semantic recovery. Temporal/DBOS/LangGraph can recover operational continuity but re-executing LLM/API calls does NOT guarantee the same semantic intention. `crash recovery ≠ intention recovery`.

**Claude's synthesis:** SAGR is no longer "recovery"; it is **governance of continuation**.

### Meta-Audit Conception
**Status at interruption:** Meta-audit was planned but NOT completed. The following files were conceived but NOT confirmed created:
- `31_GRAFO_DE_EVIDENCIA.md`
- `32_REGISTRO_DE_BUSQUEDAS.md`
- `33_MATRIZ_DE_COBERTURA_DE_INVESTIGACION.md`
- `34_AUDITORIA_ADVERSARIAL_FINAL.md`
- `35_AUDITORIA_DE_CONSISTENCIA.md`
- `36_DICCIONARIO_DEFINICIONES.md`
- `37_CERTIFICADO_DE_SATURACION.md`
- `38_AUDITORIA_FINAL_DEL_MASTER.md`

**Warning:** Second pass of Claude terminated based on its own operative criterion (files 01–20 with substantive content). This does NOT mean the complete master prompt was satisfied.

### Deep Hypothesis Evolution (ChatGPT extended research — Document 3)
This represents an extended investigative pass that went significantly deeper, discovering:
- State-Aware Runtime (Cambridge, v4)
- Argus (Microsoft Research)
- Turning Interaction History into Execution State (Ledger paper)
- Agent Safety Should Be a Runtime Contract
- CONTINUITY (Security-Context Contracts)
- AgentRewind with Safety Review mechanism
- Consequence Closure (RISU Institute)
- Projection Assurance (RISU Institute)
- Reliance Before Closure (RISU Institute)
- Proof-Carrying Agent Actions (PCAA)
- CAVA (Canonical Action Verification and Attestation)
- When AI Agents Commit (Cognitive Serializability)
- Towards Assurance Closure in AI-Native Agile
- Assurance Envelopes for Autonomous Coding Agents
- SpecBench
- RSGA (Requirements-Sufficiency-Gated Automation)
- QUARE (multi-agent requirements negotiation)
- RECODE (requirement recovery from code)
- ae-framework (Agent-Neutral Assurance Control Plane for SDLC)
- skil (vendor-neutral security/verification for AI skills)
- VERITAS OS (agent governance runtime)
- Agent-Integrated Software (transition-system semantics)
- DeepSeek Harness (event-sourced agent runtime)
- ActiveGraph / The Log is the Agent

---

## 04 CCP CURRENT REALITY

### What CCP actually does (based on evidence)

CCP converts an AI-agent development workflow into engineering infrastructure. Its core function: **the agent cannot declare DONE without verifiable evidence satisfying a contract**.

### Technical components confirmed to exist

**Hooks (`.claude/hooks/`):**
- `bash-firewall.sh` — blocks dangerous bash patterns (has GuardFall false-positive problem)
- `secret-guard.sh` — secret detection
- `task-completed-evidence.sh` — TaskCompleted gate
- Additional lifecycle hooks

**Skills (`.claude/skills/`)**

**Eval framework (`evals/`)**

**Canonical state documents:**
- `PROJECT_STATE.md`
- `CURRENT_STATE.md`
- `ARTIFACT_MANIFEST.md`
- `EVIDENCE_REGISTRY.md`
- `DECISION_REGISTRY.md`
- `INCIDENT_REGISTRY.md`
- `REGRESSION_REGISTRY.md`
- (additional control documents)

### Known architecture gaps (from project's own documentation)

- Evidence freshness: currently timestamp/session based
- Dependency-based invalidation: **NOT IMPLEMENTED**
- Structural weakening of hooks: **NOT automatically detected**
- Reviewer identity: incomplete enforcement
- Append-only evidence registry: convention only (not cryptographically enforced)
- Trust boundary: human/Git (shared environment with controllable artifacts)

### CCP learning loop

```
incident → control → regression
```

This is also described in Requirements Engineering terms as:
```
incident → hidden assumption → requirement → control → regression
```

### CCP evidence model

Provenance types documented:
- EXTRACTED
- INFERRED
- ASSUMED
- EXTERNAL
- GENERATED

### Current assessment of CCP architectural classification

CCP is primarily an **AI-native engineering assurance execution implementation**, not a new conceptual primitive. Its value lies in:
1. materializing engineering discipline in a form agents can operate
2. the incident → learning loop turning operational experience into future engineering constraints
3. phase-gate discipline and historical preservation (surviving differentiators vs AIGIS)

---

## 05 F1-F9 HISTORICAL STATE

| Phase | Status | Commit | Key Artifacts |
|---|---|---|---|
| F1 | COMPLETE/FROZEN | (historical) | EV-001 |
| F2 | COMPLETE/FROZEN | (historical) | EV-002 |
| F3 | COMPLETE/FROZEN | (historical) | Tier 3 tests pass |
| F4 | COMPLETE/FROZEN | (historical) | — |
| F5 | COMPLETE/FROZEN | (historical) | — |
| F6 | COMPLETE/FROZEN | (historical) | — |
| F7 | COMPLETE/FROZEN | `47874a5` | anti-loop, firewall, evidence coupling |
| F8 | COMPLETE/FROZEN | `2cd7953` | fail-closed TaskCompleted, fail-closed firewall |
| F9 | NOT JUSTIFIED | N/A | research only |
| F10 | NOT OPENED | N/A | blocked pending meta-audit |
| F11 | NOT OPENED | N/A | blocked |
| F12 | NOT OPENED | N/A | blocked |

**DO NOT OPEN F10 without explicit meta-audit justification.**

---

## 06 RESEARCH EVOLUTION — HYPOTHESIS TRAJECTORY

### Arc 1: Evidence Gate
**Original thesis:** Agent cannot say DONE without evidence.
**Status:** IMPLEMENTED IN F1-F8. No longer unique — AIGIS also has evidence-gated execution.

### Arc 2: AIGIS Teardown → Loss of Uniqueness
**Finding:** Evidence-gated execution is NOT unique.
**Surviving differentiators vs AIGIS:** incident→control→regression, historical preservation, phase-gate discipline.

### Arc 3: SAGR Hypothesis
**Trigger:** GuardFall — security control induced stall.
**Original SAGR:** State-Aware Governed Recovery — detect stall → recover → explore alternatives → resume.
**Status:** SAGR as a standalone primitive is dead. Components already existed individually.

### Arc 4: Governance of Continuation
**Claude's reformulation:** SAGR is not "recovery" — it is **governance of continuation**.
**Definition:** A layer deciding what the agent can do when the current path fails, without repeating, bypassing policies, destroying evidence, losing state, exploding costs, or producing false recovery.

### Arc 5: Trajectory Governance
**Next formulation:** The object being governed is not the agent but the **trajectory toward an objective**.
- Objective remains constant
- Trajectory changes
- Constraints remain
- Evidence remains
- State preserved
- Failed paths remembered
- Cost limits exploration
- Recovery verified
- Side effects not forgotten

### Arc 6: Reconciliation as More Fundamental than Recovery
**Insight from Kubernetes:** desired state → observe actual state → reconcile → act → observe.
**Reformulation:** Recovery is a special case of **reconciliation under uncertainty**.

### Arc 7: Semantic State Sufficiency
**Key insight:** The question is not "what state do we have?" but "is the state we have sufficient to make correct future decisions?"
**ResidualAuth finding:** Two authorization histories can end with the same current permissions but require different decisions after a subsequent revocation. 256-token summary resolved 0–2/16 pairs; authenticated current-state queries resolved 15–16/16.

### Arc 8: Dependency Completeness
**Formulation:** Not just "are the dependencies valid?" but "do we have ALL the dependencies that matter?"
**Cognitive Serializability:** an artifact can be unchanged in content yet no longer applicable; authority and policy can change though the document hasn't.

### Arc 9: Assurance Closure
**Current deepest formulation:** The system needs to know when its own representation of state, dependencies, evidence, and constraints sufficiently covers all factors relevant to a decision.
**Prior art found:** "Towards Assurance Closure in AI-Native Large-Scale Agile Software Development" (arXiv:2608.07317) — identifies 6 gaps, proposes C1-C6 architecture overlapping substantially with CCP.

### Arc 10: Assurance Impact Propagation (current working hypothesis)
**Formulation:** When a dependency changes, can the runtime determine which claims, obligations, evidence, permissions, and trajectories are invalidated — without unnecessarily invalidating everything else?
**Status:** Hypothesis. NOT proven novel. Strong prior art in dependency tracking, TMS, continuous assurance, assurance envelopes.

---

## 07 SAGR EVOLUTION — COMPLETE HISTORY

### SAGR v1 (Original)
**Name:** State-Aware Governed Recovery
**Components proposed:** state fingerprint, progress signal, loop detector, checkpoints, rollback, recovery classifier, recovery planner, subagents, bounded branch exploration, branch adjudication, minimum sufficient context, recovery budget, safety constraints, verification, historical learning, trajectory memory.

**Core flow:**
```
EXECUTION TRAJECTORY
→ HEALTH MONITOR
→ STALL?
→ STALL CLASSIFIER
   → HARD STOP
   → RECOVERABLE
      → RECOVERY COST
      → RECOVERY BUDGET
      → RECOVERY PLANNER
      → BOUNDED EXPLORATION
      → POLICY CHECK
      → ADJUDICATION
      → MINIMAL CONTEXT REBUILD
      → RESUME
      → VERIFICATION
```

**Critical safety principle:** STALL ≠ PERMISSION TO BYPASS SAFETY

### What SAGR v1 killed (already existing components)
The following were found to already exist in the ecosystem:
- loop detection (multiple implementations)
- checkpoint (multiple)
- rollback (multiple)
- subagent recovery
- reflection/retry
- context compaction
- state fingerprinting
- branch exploration
- basic cost-aware agent
- evidence-gated completion
- general trajectory memory
- general state-aware recovery

**Systems that cover SAGR v1 territory:** FutureAGI, loopless, Temporal, LangGraph, Claude Agent SDK, OpenAI Agents, LATS, Reflexion, RIR, ReflexGrad, AgentRewind, AgentAssay, AIGIS, OSGuard, VIGIL, AI Runtime Infrastructure.

### SAGR v2 (Claude's reformulation)
**Shift:** SAGR = governance of continuation
**Not:** "how do we recover the agent?"
**But:** "what can the agent do when it can no longer do what it originally planned?" — preserving objective, authorization, security, evidence, state, budget, verifiability.

### SAGR v3 (Deep research synthesis)
**Shift:** Not "recovery" but "re-establishing a valid transition path."
**Components:**
1. Determine why current transition ceased to be valid
2. Identify changed dependencies
3. Observe current world
4. Reconstruct sufficient state
5. Determine permitted continuation
6. Verify
7. Commit

### Current SAGR status
SAGR is a **mechanism of response** within a larger assurance system. It is not the root architecture. It is subordinate to assurance state, which is subordinate to authority, which is subordinate to obligations, which is subordinate to specification adequacy.

---

## 08 CLAIM LEDGER

### Format: CLAIM | STATUS | EVIDENCE | NOTES

---

**CLAIM-001:** Evidence-gated execution is unique to CCP.
**STATUS:** CONTRADICTED
**EVIDENCE:** AIGIS teardown (e095eb6) — 234 tests, 223 passed. AIGIS has TaskContract, policy engine, evidence bundles, SHA-256, deterministic decision engine.
**NOTES:** CCP's differentiator is incident→control→regression + historical preservation + phase-gate discipline.

---

**CLAIM-002:** Loop detection is a novel contribution.
**STATUS:** CONTRADICTED
**EVIDENCE:** Multiple existing implementations documented (loopless, FutureAGI, AgentAssay, etc.)

---

**CLAIM-003:** Checkpoint + rollback is novel.
**STATUS:** CONTRADICTED
**EVIDENCE:** Temporal, LangGraph, DBOS, and many others.

---

**CLAIM-004:** Subagent recovery is novel.
**STATUS:** CONTRADICTED
**EVIDENCE:** OpenAI Agents, Claude Agent SDK, LangGraph, etc.

---

**CLAIM-005:** State-aware recovery is novel.
**STATUS:** CONTRADICTED
**EVIDENCE:** State-Aware Runtime (Cambridge, 4 versions), AgentRewind, CONTINUUM, etc.

---

**CLAIM-006:** OSGuard implements only "fixed retry / hard stop."
**STATUS:** CORRECTED
**ORIGINAL:** First pass described OSGuard as simple.
**CORRECTION:** Real mechanism includes block → feedback → revise action → re-check → retry limit.
**SOURCE:** Claude Code web research pass.

---

**CLAIM-007:** RIR success rate is 60–70% / 70%.
**STATUS:** FALSE PRECISION
**EVIDENCE:** No reproducible rubric exists for those numbers.
**CORRECTION:** Should be marked as unverified claim.

---

**CLAIM-008:** Side-effect continuity is an absolute vacuum.
**STATUS:** WEAKENED
**EVIDENCE:** Living AI, Replay Agent Recorder, AgentRewind exist with partial implementations.

---

**CLAIM-009:** No system does recovery around blocked actions.
**STATUS:** WEAKENED
**EVIDENCE:** AgentRewind has Safety Review — blocked action → agent receives feedback → repair/continue/return to checkpoint.

---

**CLAIM-010:** Durable execution = semantic recovery.
**STATUS:** CONTRADICTED (KILLED)
**EVIDENCE:** Temporal/DBOS/LangGraph recover operational continuity but re-executing LLM/API calls does NOT guarantee same semantic intention.
**Principle established:** crash recovery ≠ intention recovery.

---

**CLAIM-011:** Policy-compliant recovery alternative generation is missing everywhere.
**STATUS:** WEAKENED / CONTRADICTED AS ABSOLUTE
**EVIDENCE:** PolicyGuide converts policies into workflow graph, maintains persistent state, reconciles open requests, produces step-specific remediation, evaluated with GPT-5.4, Claude Sonnet 4.6, Gemini 2.5 Pro. (arXiv:2608.19861)

---

**CLAIM-012:** Execution state ledger doesn't exist.
**STATUS:** CONTRADICTED
**EVIDENCE:** "Turning Interaction History into Execution State" (arXiv:2608.00808) — deterministic runtime maintaining observed/modified/attempted; reports Pass@1 improvements and 28.9–31.8% cost reduction on SWE-bench Verified.

---

**CLAIM-013:** Mission-state governance is unexplored.
**STATUS:** HEAVILY OCCUPIED
**EVIDENCE:** "Verification-Gated Agentic Mission-State Governance" (arXiv:2606.31339) — task forest, governed blackboard, execution, robot traces, resource locks, world beliefs, proposals, verification records, constraints, topology, bounded repair, deterministic verification, atomic commit.

---

**CLAIM-014:** Trajectory governance is novel.
**STATUS:** HEAVILY OCCUPIED
**EVIDENCE:** State-Aware Runtime (Cambridge, arXiv:6a80ae6b) — v4 includes canonical state, speculative state, proposals, validators, commit, rollback, compensation, handoff, audit, capability topology, 4-state authorization, single-use permissions, revalidation at dispatch, effect state machine.

---

**CLAIM-015:** "3 cases in 4 weeks → worth building SAGR internally."
**STATUS:** NOT SUPPORTED — INVALID DECISION CRITERION
**NOTES:** Claude proposed this in the second pass. No rule in the project data justifies "3 cases → build." This must be removed as a decision criterion.

---

**CLAIM-016:** generate_alternative + non_bypass_verify are the only technical blocker nobody has implemented.
**STATUS:** TOO STRONG — MUST PASS NOVELTY/ISOMORPHISM AUDIT AGAIN
**NOTES:** PolicyGuide substantially weakens this claim.

---

**CLAIM-017:** Consequence closure is novel.
**STATUS:** CONTRADICTED
**EVIDENCE:** RISU Institute Technical Note 2026-03 "Consequence Closure" — identifies consequence-relevant distinctions in state, constructs minimum sets of semantic obligations, can certify when no sufficient set exists within declared vocabulary.

---

**CLAIM-018:** Projection assurance is novel.
**STATUS:** CONTRADICTED
**EVIDENCE:** RISU Institute Technical Note 2026-04 "Projection Assurance" — studies what is lost when a complete representation is projected to a smaller one. Demonstrates surface preservation ≠ consequence preservation.

---

**CLAIM-019:** Assurance closure architecture is novel.
**STATUS:** CONTRADICTED AS CONCEPT
**EVIDENCE:** arXiv:2608.07317 "Towards Assurance Closure in AI-Native Large-Scale Agile Software Development" — defines 6 gaps, C1–C6 architecture with intent/claims/assumptions/risks/architecture/implementation/dependencies/assurance activities/evidence/provenance/defeaters/validity conditions/runtime observations.

---

**CLAIM-020:** "History spine" / event-sourced agent architecture is novel.
**STATUS:** HEAVILY OCCUPIED
**EVIDENCE:** DeepSeek Harness (Session = append-only typed event log), ActiveGraph / "The Log is the Agent" (arXiv:2605.21997), ESAA (arXiv:2602.23193), CONTINUUM (GitHub: Cyrax321/CONTINUUM).

---

**CLAIM-021:** Requirement sufficiency gating is novel.
**STATUS:** CONTRADICTED
**EVIDENCE:** RSGA (Requirements-Sufficiency-Gated Automation, RE 2026) — 10 intent dimensions, evaluated on 100 ambiguous prompts. Repository explicitly "refuses to let an AI agent start on an underspecified request."

---

**CLAIM-022:** Hidden assumption recovery from incidents is novel to CCP.
**STATUS:** OCCUPIED BY REQUIREMENTS ENGINEERING
**EVIDENCE:** Jane Cleland-Huang, RE 2026: "Recovering Hidden Assumptions in Physical AI: From Operational Incidents to Better Requirements." RECODE paper (Hanyang/Hyundai) recovers requirements from underdocumented code.

---

**CLAIM-023:** Authority adaptation based on assurance state is novel.
**STATUS:** OCCUPIED
**EVIDENCE:** "Specifying the Delegated-Autonomy Boundary" (RE 2026) — Agency Justification Record + Agentic Delegation Policy. "Towards Assurance Closure" explicitly proposes using assurance uncertainty to constrain agent authority. AURA-FCC (risk-adaptive authorization in finance).

---

**CLAIM-024:** Assurance impact propagation (change → dependency graph → stale claims → authority adjustment) is novel.
**STATUS:** HYPOTHESIS — SUBSTANTIAL PRIOR ART
**EVIDENCE:** Dependency tracking (TMS classical), continuous assurance, assurance envelopes, change-impact analysis, selective invalidation. NOT proven as a novel integrated system.

---

## 09 SOURCE LEDGER

### Verified primary sources (found during research passes)

| SRC_ID | Title | Source | URL/Reference | Type | What it supports |
|---|---|---|---|---|---|
| SRC-001 | State-Aware Runtime for Long-Horizon LLM Agents v4 | Cambridge Open Engage | 6a80ae6b810b9dcc821646ae | Paper (working) | Trajectory governance, canonical state, effect state machine |
| SRC-002 | Argus: General-Purpose Agentic Runtime | Microsoft Research | microsoft.com/en-us/research/publication/argus | Paper | Long-horizon reasoning runtime |
| SRC-003 | Turning Interaction History into Execution State | arXiv | 2608.00808 | Paper | Execution ledger, cost reduction |
| SRC-004 | Agent Safety Should Be a Runtime Contract | arXiv | 2608.11274 | Paper | trajectory-with-checkable-evidence as security unit |
| SRC-005 | CONTINUITY: Security-Context Contracts | arXiv | 2609.05269 | Paper | Security context composition |
| SRC-006 | Towards Assurance Closure | arXiv | 2608.07317 | Paper | Assurance closure architecture, 6 gaps |
| SRC-007 | Assurance Envelopes for Autonomous Coding Agents | arXiv | 2609.16302 | Paper | Minimum-cost evidence for software change |
| SRC-008 | Consequence Closure | RISU Institute | risuinstitute.org/research/technical-notes/2026-03 | Technical note | Consequence-relevant sufficiency |
| SRC-009 | Projection Assurance | RISU Institute | risuinstitute.org/research/technical-notes/2026-04 | Technical note | Semantic loss in projections |
| SRC-010 | Reliance Before Closure | RISU Institute | risuinstitute.org/research/technical-notes/2026-02 | Technical note | Assurance before full closure |
| SRC-011 | Proof-Carrying Agent Actions (PCAA) | arXiv | 2606.04104 | Paper | Model-agnostic action governance |
| SRC-012 | CAVA: Canonical Action Verification and Attestation | arXiv | 2607.13716 | Paper | Canonical action identity across runtimes |
| SRC-013 | When AI Agents Commit (Cognitive Serializability) | arXiv | 2609.20261 | Paper | Cross-plane validity, TOCTOU for agents |
| SRC-014 | AgentAssay: Token-Efficient Regression Testing | arXiv | 2603.02601 | Paper | Non-deterministic agent workflow regression |
| SRC-015 | From Agent Loops to Structured Graphs | arXiv | 2604.11378 | Paper | Structured graph vs loop, recovery protocol |
| SRC-016 | Towards Agentic Cloud Engineering | arXiv | 2609.00050 | Paper | Loop engineering, zero-trust harness |
| SRC-017 | Governance Decay | arXiv | 2606.22528 | Paper | Context compaction removes safety constraints |
| SRC-018 | ContextNest: Verifiable Context Governance | arXiv | 2607.02116 | Paper | Context versioning, provenance, checkpoints |
| SRC-019 | MemGuard | arXiv | 2608.21867 | Paper | Memory governance, verifier signal persistence |
| SRC-020 | ContrAgent | arXiv | 2609.18128 | Paper | Temporal logic contracts over agent trajectories |
| SRC-021 | Agent-BRACE | arXiv | 2605.11436 | Paper | Belief-state decoupling |
| SRC-022 | State Drift in Language-Conditioned Agents | doi.org/preprints | 10.20944/preprints202601.0910.v1 | Preprint | State drift failure mode |
| SRC-023 | Recoverability as a System Primitive | (referenced in research) | — | Paper | Formal classification of recoverability |
| SRC-024 | ResidualAuth | arXiv | 2609.08062 | Paper | Authorization state under revocable delegation |
| SRC-025 | AgentAbstain | arXiv | 2607.10059 | Paper | When agents should not act |
| SRC-026 | Self-Healing Agentic Orchestrators | arXiv | 2606.01416 | Paper | Failure classification, targeted recovery, budgets |
| SRC-027 | Engineering Reliable Commit Gates | arXiv | 2609.10969 | Paper | Common-mode evidence failure in multi-verifier systems |
| SRC-028 | Who Audits Whom | arXiv | 2609.18272 | Paper | Independence-graded audit protocol |
| SRC-029 | ae-framework | GitHub | itdojp/ae-framework | Repository | Agent-neutral assurance control plane for SDLC |
| SRC-030 | skil | GitHub | domehahn/skil | Repository | Vendor-neutral security/verification for AI skills |
| SRC-031 | VERITAS OS | GitHub | veritasfuji-japan/veritas_os | Repository | Agent governance runtime, EFFECT_UNKNOWN state |
| SRC-032 | DeepSeek Harness (Session) | GitHub | deepseek-ai/deepseek-harness | Repository | Append-only event log as canonical source |
| SRC-033 | The Log is the Agent | arXiv | 2605.21997 | Paper | Event-sourced reactive graphs |
| SRC-034 | ESAA | arXiv | 2602.23193 | Paper | Event sourcing for autonomous agents |
| SRC-035 | CONTINUUM | GitHub | Cyrax321/CONTINUUM | Repository | Semantic recovery, idempotent action ledger |
| SRC-036 | PolicyGuide | arXiv | 2608.19861 | Paper | Policy-compliant workflow, step-specific remediation |
| SRC-037 | Mnemosyne (Agentic Transaction Processing) | arXiv | 2607.00269 | Paper | Transaction processing, dependency-safe compensation |
| SRC-038 | From Version Conflicts to Decision Conflicts | arXiv | 2609.08015 | Paper | Selective revalidation, version ≠ decision conflict |
| SRC-039 | Correct Is Not Governed (Matrix) | arXiv | 2608.12761 | Paper | Provenance integrity, selective invalidation |
| SRC-040 | Agentic Shadow Infrastructure | MDPI | 2073-431X/15/8/510 | Paper | Compositional drift, shadow capabilities |
| SRC-041 | SpecBench | arXiv | 2605.30314 | Paper | Specification-level reasoning evaluation |
| SRC-042 | RSGA (Requirements-Sufficiency-Gated Automation) | RE 2026 | — | Conference paper | Requirements adequacy gating |
| SRC-043 | STALE benchmark | arXiv | 2605.06527 | Paper | Stale memory detection in LLM agents |
| SRC-044 | Truth Maintenance System (Doyle 1979) | ScienceDirect | 0004-370279900080 | Classic paper | Belief dependency tracking |
| SRC-045 | ATMS (de Kleer) | doi.org | 10.1016/0004-3702(86)90080-9 | Classic paper | Assumption-based TMS |
| SRC-046 | Self-Stabilization (Dijkstra) | UT Austin | EWD391 | Classic paper | Convergence + closure |
| SRC-047 | Towards Assurance Closure (full) | arXiv | 2608.07317 | Paper | 6 gaps + C1-C6 architecture |
| SRC-048 | Anthropic Multiagent Research | Anthropic | anthropic.com/research/multiagent-systems | Blog/Research | Correlated failures in multi-agent systems |
| SRC-049 | Approved Too Late | arXiv | 2608.26306 | Paper | Verdict staleness, TOCTOU for guardrails |
| SRC-050 | ACLE-MCP | arXiv/ArcXiv | 2609.02690 | Paper | Attested capability leases for tool use |
| SRC-051 | Human Escalation Mechanism (HEM) | IETF Datatracker | draft-sato-soos-hem | Internet-Draft | HEM_PENDING state, formal human escalation |
| SRC-052 | Action Evidence Boundary | IETF | draft-schrock-action-evidence-boundary-05 | Internet-Draft | Authorization-execution-effect binding |
| SRC-053 | Independent Determinability of Agent Actions | IETF Datatracker | draft-wadkins-agentproto-action-determinability | Internet-Draft | authorized ≠ enforced ≠ executed ≠ effected |
| SRC-054 | Agent Authority Transition Receipts | IETF | draft-watts-agent-authority-transition-receipts | Internet-Draft | Verifiable authority transitions |
| SRC-055 | Stochastic-Deterministic Boundary | arXiv | 2605.20173 | Paper | proposer → verifier → commit → reject architecture |
| SRC-056 | Reachability-Based Capability Confinement | arXiv | 2608.30041 | Paper | SkillGuard, reachable-state confinement |
| SRC-057 | Non-Atomic Tool Failures | alphaXiv | 2608.02645 | Paper | verify-before-retry, idempotency keys |
| SRC-058 | Cost-Aware Speculative Execution | arXiv | 2606.07846 | Paper | Cost-aware branching, commit barriers |
| SRC-059 | Agent-Integrated Software | (referenced) | — | Paper | Transition-system semantics, interaction contracts |
| SRC-060 | RECODE (requirement recovery from code) | (referenced) | — | Paper | 83.3% vs 47.2% omission detection |
| SRC-061 | Aborted but Not Forgotten (KV-Cache) | arXiv | 2608.15939 | Paper | KV-cache retention breaks rollback consistency |
| SRC-062 | Kubernetes controller reconciliation | Kubernetes blog | kubernetes.io/blog/2026/07/29 | Documentation | Desired vs actual state reconciliation |
| SRC-063 | Saga Pattern | Microsoft Learn | learn.microsoft.com/azure/architecture/patterns/saga | Documentation | Distributed compensation |
| SRC-064 | Event Sourcing Pattern | Microsoft Learn | learn.microsoft.com/azure/architecture/patterns/event-sourcing | Documentation | Append-only event log, state derivation |
| SRC-065 | Dynamic Assurance Cases | ScienceDirect | 0925-753525001900 | Paper | Safe autonomous systems under change |
| SRC-066 | Agentassay (behavior regression) | arXiv | 2603.02601 | Paper | Token-efficient regression |
| SRC-067 | Formal Methods Meet LLMs | arXiv | 2605.16198 | Paper | Temporal constraints, monitoring, intervention |
| SRC-068 | Causal Past Logic | arXiv | 2605.20923 | Paper | Distributed LLM workflow verification |
| SRC-069 | Decision Provenance (2018) | arXiv | 1804.05741 | Paper | Input chains, decisions, effects |
| SRC-070 | Mission-Level Runtime Assurance for ISR Swarms | arXiv | 2607.23532 | Paper | Multi-agent mission assurance |
| SRC-071 | QUARE (multi-agent requirements negotiation) | RE 2026 | — | Conference paper | Safety/efficiency/trust/green conflicts |
| SRC-072 | Specifying the Delegated-Autonomy Boundary | RE 2026 | — | Conference paper | Agency Justification Record |
| SRC-073 | Assurance-Scoped Reliability | arXiv | 2607.26953 | Paper | Capturing the state that matters |
| SRC-074 | Shields for Safe RL | Communications ACM | 3715958 | Paper | Shield, viable states |
| SRC-075 | Belief-State Engine | arXiv | 2609.10036 | Paper | POMDP-based belief state for LLM agents |
| SRC-076 | PABU | arXiv | 2602.09138 | Paper | Progress-aware belief update |
| SRC-077 | SkillSentry | arXiv | 2608.09253 | Paper | Runtime assurance for agent skills |
| SRC-078 | VP-CONTROL (commit gates) | arXiv | 2609.10969 | Paper | Common-mode evidence failure data |
| SRC-079 | Microsoft Agent Governance Toolkit | GitHub | microsoft/agent-governance-toolkit | Repository | TCB definition, policy engine |
| SRC-080 | Open Agent Specification (Oracle) | GitHub | oracle/agent-spec | Repository | Framework-agnostic agent specification |

### Sources with CONFLICT or UNCERTAINTY

| SRC_ID | Issue |
|---|---|
| OSGuard (various) | Was initially described incorrectly as simple retry/stop. Corrected by Claude Code web research. |
| RIR "70%" | No reproducible rubric. Should be treated as unverified claim, not fact. |
| RISU Institute papers (SRC-008, 009, 010) | Institutional origins require verification. URLs may be limited access. |
| AIGIS baseline | Commit e095eb6 — may have changed since inspection. |

---

## 10 RESEARCH DOMAINS COVERED

The following domains were investigated (to varying degrees) during the research:

| Domain | Coverage | Key Finding |
|---|---|---|
| Agent execution recovery | Deep | Heavily occupied. AgentRewind, LATS, Reflexion, OSGuard, etc. |
| Context continuity / memory | Deep | Heavily occupied. ContextNest, MemGuard, compaction survey. |
| State machines / workflow systems | Moderate | LangGraph, Temporal, DBOS all exist. |
| Multi-agent recovery | Moderate | Anthropic research on correlated failures. |
| Loop / stagnation detection | Deep | Occupied. Multiple implementations. |
| Control-induced stalls | Moderate | Partially confirmed as real phenomenon. |
| Cost / token efficiency | Moderate | Assurance Envelopes, speculative execution. |
| Safety + recovery | Deep | Runtime assurance, CONTINUITY, SDB. |
| Software engineering analogues | Moderate | TMS, plan repair, build systems, incremental computation. |
| Agent harness / coding agents | Moderate | Claude Code, OpenAI Agents, DeepSeek Harness. |
| Academic landscape | Deep | Wide survey of 2026 papers. |
| Standards / industrial practice | Moderate | IETF drafts, NIST, UK government publication. |
| Failure / incident corpus | Light | STALE benchmark, non-atomic tool failures. |
| Competitive / product search | Deep | ae-framework, VERITAS, skil, Microsoft Agent 365. |
| Business / economics | Light | COMMERCIAL THESIS NOT SUPPORTED. No buyer evidence. |
| Adversarial architecture review | Light | Incomplete — planned for meta-audit. |
| Novel composition | Moderate | Assurance impact propagation hypothesis. |
| Distributed systems | Moderate | Kubernetes reconciliation, Saga, event sourcing. |
| Databases | Light | Sagas, transactions referenced. |
| Operating systems | Light | Referenced but not deeply investigated. |
| Networking | Light | IETF drafts. |
| Robotics | Not covered | — |
| Control theory | Moderate | Viability, shielding, stabilization. |
| Planning | Moderate | Plan repair, open-world planning. |
| Transaction systems | Moderate | Cordon, Mnemosyne. |
| Security | Moderate | CONTINUITY, runtime governance. |
| Requirements engineering | Moderate (late) | RSGA, QUARE, RECODE, Cleland-Huang, SpecBench. |
| Economics / commercial | Light | COMMERCIAL THESIS NOT SUPPORTED. |

---

## 11 CLOSED HYPOTHESES

The following must NOT be re-investigated as potentially novel. They are closed with sufficient evidence.

### CH-001: Loop detection is novel
**CLOSED.** Multiple production implementations exist. AgentAssay, loopless, FutureAGI, built-in to LangGraph/Temporal.

### CH-002: Checkpoint is novel
**CLOSED.** Durable execution systems (Temporal, DBOS, LangGraph) are mature.

### CH-003: Rollback is novel
**CLOSED.** Transaction systems, durable execution, Saga pattern all cover this.

### CH-004: Recovery as a category is novel
**CLOSED.** Self-Healing Agentic Orchestrators (arXiv:2606.01416), AgentRewind, Reflexion, LATS — recovery is well-studied.

### CH-005: Subagent delegation for recovery is novel
**CLOSED.** Claude Agent SDK, OpenAI Agents, LangGraph multi-agent all cover this.

### CH-006: Reflection/retry is novel
**CLOSED.** Reflexion (academic), multiple production harnesses.

### CH-007: Context compaction is novel
**CLOSED.** Mature technique with significant survey literature.

### CH-008: State fingerprinting is novel
**CLOSED.** Covered in AgentAssay, behavioral fingerprinting, multiple trajectory systems.

### CH-009: General trajectory memory is novel
**CLOSED.** State-Aware Runtime (Cambridge), DeepSeek Harness, CONTINUUM.

### CH-010: Evidence-gated completion is novel
**CLOSED.** AIGIS, ae-framework, PCAA all implement variants.

### CH-011: History / event spine as source of truth is novel
**CLOSED.** DeepSeek Harness, The Log is the Agent, ESAA, CONTINUUM all use append-only event log architectures.

### CH-012: Execution state as explicit object is novel
**CLOSED.** "Turning Interaction History into Execution State" (Ledger) does exactly this.

### CH-013: Runtime governance as category is novel
**CLOSED.** Heavy literature. Microsoft Agent Governance Toolkit, runtime assurance (NASA), PCAA, CAVA, SDB.

### CH-014: Policy-constrained planning is novel
**CLOSED.** "Policy-Constrained Plan Generation" (TD Commons), OpenClaw documented approach.

### CH-015: Security-context continuity is novel
**CLOSED.** CONTINUITY (arXiv:2609.05269) explicitly addresses this.

### CH-016: Canonical action identity is novel
**CLOSED.** CAVA (arXiv:2607.13716) addresses this directly.

### CH-017: Self-healing orchestration is novel
**CLOSED.** arXiv:2606.01416 with experimental evaluation.

### CH-018: Authority binding to action is novel
**CLOSED.** Intent Token, ACLE-MCP, Action Evidence Boundary (IETF), Agent Authority Transition Receipts.

### CH-019: Temporal/freshness of authorization is novel
**CLOSED.** "Approved Too Late" (arXiv:2608.26306), stateful governance for concurrent agentic systems, IETF draft on state/policy continuity.

### CH-020: Belief-state management is novel
**CLOSED.** Agent-BRACE, Belief-State Engine, PABU — active research area.

### CH-021: Memory governance is novel
**CLOSED.** MemGuard, MemArchitect — active with implementations.

### CH-022: Continuous assurance is novel
**CLOSED.** UK government publication (21 Sep 2026), Fraunhofer (2023), arXiv:2511.14805.

### CH-023: Event sourcing for agents is novel
**CLOSED.** DeepSeek Harness, The Log is the Agent, ESAA, ActiveGraph.

### CH-024: Trajectory-level governance is novel
**CLOSED.** State-Aware Runtime v4, runtime assurance, CONTINUITY, mission-level runtime assurance.

### CH-025: Durable execution = semantic recovery
**CLOSED AS EQUIVALENCE.** Established that crash recovery ≠ intention recovery. They solve different problems.

---

## 12 SURVIVING HYPOTHESES

These have NOT been closed. They require further investigation before reaching any conclusion.

### SH-001: Assurance impact propagation
**Definition:** When a dependency of a system changes, can the runtime determine which claims, obligations, evidence, permissions, and trajectories are invalidated — without unnecessarily invalidating unrelated items?

**What exists:** Dependency tracking (TMS, build systems), continuous assurance, assurance envelopes, selective invalidation (Matrix paper).

**What survives:** The *integrated* version spanning intent → specification → obligations → assurance → authority → execution → effects → change propagation → revalidation has not been demonstrated as a working system.

**Falsifier:** Find a system that does the full chain end-to-end reproducibly.

**Status:** OPEN HYPOTHESIS — NOT proven novel.

---

### SH-002: Specification adequacy as gate
**Definition:** An agent runtime that blocks execution when the specification is insufficient — and does so based on measurable, reproducible criteria.

**What exists:** RSGA (RE 2026) implements this with 10 dimensions. This hypothesis is therefore SUBSTANTIALLY WEAKENED.

**What might survive:** RSGA covers "is there enough to start?" The harder question — "does the specification cover all factors that will matter throughout the execution?" — may still be open.

**Status:** SUBSTANTIALLY WEAKENED / residual open question about lifecycle adequacy.

---

### SH-003: Boundary completeness under open world
**Definition:** Can a system know when its own assurance model, dependency graph, and evidence fail to capture factors that could materially change the conclusion?

**What exists:** RISU Consequence Closure can determine this within a declared vocabulary. But detecting factors *outside* the declared vocabulary is harder. NASA and Dagstuhl documents acknowledge unknown unknowns are unavoidable in open-world settings.

**Status:** PHILOSOPHICALLY OPEN — may be a fundamental limit rather than a solvable engineering problem.

---

### SH-004: Decision-relevant progress as control criterion
**Definition:** A loop/stagnation detection approach based not on action count or state repetition, but on whether each action produces new information that changes decision-relevant state (goal progress, knowledge gain, assurance gain).

**What exists:** Progress signals, AgentAssay, cost-aware planning. Value of Information frameworks.

**What might survive:** A specific operationalization combining assurance state change + viable trajectory + information value — not yet found as explicit composite.

**Status:** HYPOTHESIS — not demonstrated as novel composite.

---

### SH-005: Continuous assurance closure across intent–effect chain
**Definition:** For an autonomous consequence, maintaining continuously a verifiable relation between intention, specification, obligations, evidence, authority, transition, and effect — reacting proportionally when dependencies change or the assurance boundary becomes insufficient.

**What exists:** "Towards Assurance Closure" (arXiv:2608.07317) is the closest prior art — it proposes exactly this but as a research agenda, not a completed system.

**Status:** INTEGRATIVE HYPOTHESIS — strongest candidate for continued investigation if the goal is identifying a genuine integration gap.

---

### SH-006: Semantic continuity across execution boundaries
**Definition:** An agent crossing context compaction, session restart, subagent handoff, model replacement, or provider migration maintains the same semantic obligations — not just operational continuity.

**What exists:** Partial — session continuity drafts (IETF), CONTINUUM, KV-cache rollback problem (arXiv:2608.15939 demonstrates rollback of transcript ≠ rollback of semantic state), OpenClaw semantic continuity regression report.

**Evidence for gap:** OpenClaw issue where Doctor=green, SQLite=green, gateway=green, sessions=present, yet agent behaved as if freshly created. Demonstrates structural integrity ≠ semantic continuity.

**Status:** ACTIVE OPEN QUESTION with real-world evidence of failure.

---

### SH-007: Control-induced stalls as a measurable phenomenon
**UNK-1 from original research:** Do operators actually suffer control-induced stalls at a meaningful rate?

**Status:** NOT ANSWERED — requires field validation. GuardFall incident is one data point but not a measurement.

---

### SH-008: Recovery economics (recover vs restart cost)
**UNK-9 from original research:** Is recovery actually cheaper than restart? Under what conditions?

**Status:** UNKNOWN — requires instrumentation and measurement.

---

### SH-009: Policy-induced stall proportion
**UNK-5 from original research:** What proportion of agent failures are actually policy-induced stalls vs other failure types?

**Status:** NOT ANSWERED — requires field observation.

---

## 13 DEEP MODEL

This is the current best conceptual model produced by the research. It is classified as **CURRENT SYNTHESIS**, not a proven novel architecture.

```
                 HUMAN / ORGANIZATIONAL INTENT
                            │
                            ▼
                    REQUIREMENTS / SPEC
                            │
                            ▼
                SPECIFICATION ADEQUACY
                    (RSGA-style gate)
                     │           │
               adequate        inadequate / unknown
                     │           │
                     ▼           ▼
              OBLIGATIONS      GAP / ESCALATE
                     │
                     ▼
              ASSURANCE PLAN
                     │
                     ▼
                 EVIDENCE
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       VALID       STALE     UNKNOWN
          │          │          │
          │       RE-VERIFY   ACQUIRE INFO
          │
          ▼
      AUTHORITY / SCOPE
     (adapted to assurance state)
          │
          ▼
    PROPOSED TRANSITION
     [intent + belief + policy + authority + evidence + effect]
          │
          ▼
    TRANSITION CHECK
     [sufficient? valid? viable? applicable?]
          │
          ▼
     COMMIT BOUNDARY
          │
          ▼
        EFFECT
          │
          ▼
   WORLD OBSERVATION
          │
    ┌─────┴──────┐
    ▼            ▼
CONFIRMED     UNKNOWN
    │            │
    ▼            ▼
  PROOF      RECONCILE /
    │         COMPENSATE
    ▼
ASSURANCE UPDATE
    │
    │
    ├── CHANGE DETECTED?
    │       │
    │   DEPENDENCY GRAPH
    │       │
    │   STALE CLAIMS
    │       │
    │   AUTHORITY ADJUSTMENT
    │       │
    │   TARGETED RE-VERIFICATION
    │
    ▼
HISTORY SPINE
(append-only causal record)
    │
    ├── incident → hidden assumption
    │               → requirement
    │               → obligation
    │               → control
    │               → regression
    │
    └── NEW EVALUATION CYCLE
```

### Component status in this model

| Component | Prior art strength | Implementation status |
|---|---|---|
| Specification adequacy gate | Strong (RSGA) | Exists in RE 2026 prototype |
| Obligation formation | Moderate | Partial (Assurance Closure research) |
| Assurance plan | Strong (assurance cases) | Exists classically, AI-native TBD |
| Evidence collection | Strong | Multiple implementations |
| Valid/stale/unknown tristate | Moderate (skil, Correctover) | Partial implementations |
| Authority adaptation | Moderate | Assurance Closure proposes, few implement |
| Transition check | Strong (SDB, PCAA, CAVA) | Multiple implementations |
| Effect observation | Moderate | Partial (VERITAS, CONTINUUM) |
| Unknown effect handling | Emerging | VERITAS EFFECT_UNKNOWN state |
| Reconciliation | Strong (Kubernetes, Saga) | Mature in distributed systems |
| History spine | Strong (DeepSeek, ActiveGraph) | Multiple implementations |
| Incident → learning | CCP-specific integration | Implemented in CCP F1-F8 |
| Assurance impact propagation | Hypothesis | NOT demonstrated as integrated system |

---

## 14 ASSURANCE MODEL

### What assurance means in this context

An assurance state is an object answering:
- What is being claimed?
- Under which assumptions?
- With which evidence?
- Against which risks?
- Within which scope?
- For which environment?
- At what time?
- With which dependencies?
- With what coverage?
- With which defeaters?
- Under which authority?
- What remains unknown?

### Assurance is NOT
- Presence of evidence (evidence can exist and be stale, irrelevant, or insufficient)
- Structural integrity of artifacts (structural integrity ≠ semantic integrity)
- Reviewer signing off (reviewer can share evidence with actor, violating independence)
- Runtime passing (execution success ≠ decision correctness)

### The five properties of evidence that must be distinguished
1. **INTEGRITY** — is the evidence authentic/unaltered?
2. **RELEVANCE** — does it actually speak to the claim?
3. **SUFFICIENCY** — is it enough to prove the claim?
4. **FRESHNESS** — is it still valid?
5. **COVERAGE** — does it include all relevant failure modes?
6. **INDEPENDENCE** — can it fail in the same way as the actor being evaluated?

### Common-mode evidence failure
VP-CONTROL finding: voting with multiple models over **shared evidence** approved 62.9% of unsafe proposals. Independent evidence source reduced this substantially. Model diversity ≠ evidence independence.

### Assurance levels (from project synthesis)
```
UNKNOWN → INVESTIGATE
LOW → READ-ONLY / OBSERVE
PARTIAL → LIMITED ACTION
ADEQUATE → STANDARD ACTION
STRONG → MERGE
STRONG + HUMAN → DEPLOY
```

### Assurance target correctness (key insight)
Before verifying, the question is: **Is the target itself the right target?**

"perfect assurance of a wrong obligation is still wrong assurance"

This is where specification adequacy becomes load-bearing.

---

## 15 DEPENDENCY / CHANGE PROPAGATION

### The dependency completeness problem

For a consequence to be well-governed, the set of dependencies used to justify it must be:
1. **Complete** — covering all factors that could materially change the conclusion
2. **Current** — valid at the time of commit, not just at time of planning
3. **Causally connected** — actually relevant to this specific consequence
4. **Authoritative** — from a trusted source in the appropriate trust domain

### The six types of dependency change
1. Content changed (document altered)
2. Applicability changed (document unchanged, but context no longer fits)
3. Authority changed (source no longer authoritative)
4. Temporal boundary crossed (authorization expired)
5. Execution context changed (tool, model, environment)
6. Causal chain changed (upstream dependency invalidated downstream)

### Key principle: integrity ≠ applicability
An artifact's hash being unchanged does NOT mean the authorization it represents still applies. This is demonstrated in Cognitive Serializability (arXiv:2609.20261).

### Non-monotonic change
Policy changes are not always additive. They can:
- add obligations
- remove permissions
- change the meaning of an artifact
- invalidate previously valid decisions

This means cached assurance must NOT be assumed to remain valid in the same direction after a policy change.

### The TMS connection
Classical Truth Maintenance Systems (Doyle 1979, de Kleer 1986) handled this for AI belief systems: maintain dependency relationships, retract conclusions when justifications fail. The modern agent equivalent requires applying this across requirements + policy + authority + evidence + execution effects + agent state.

---

## 16 BOUNDARY COMPLETENESS

### The fundamental problem

A system cannot control what it does not know it should be controlling.

```
LEVEL 0 — MODEL BEHAVIOR
"Did the agent reason well?"

LEVEL 1 — EXECUTION
"Did it do what it said?"

LEVEL 2 — STATE
"Does the persisted state correctly represent what happened?"

LEVEL 3 — PROVENANCE
"Do we know where each decision came from?"

LEVEL 4 — DEPENDENCY VALIDITY
"Are the premises still valid?"

LEVEL 5 — DEPENDENCY COMPLETENESS
"Did we capture ALL premises that matter?"

LEVEL 6 — COMMIT INTEGRITY
"Was the consequence exactly what was authorized?"

LEVEL 7 — SYSTEM ASSURANCE
"Can we trust the mechanism that verifies all of the above?"
```

CCP historically operated mainly at levels 2–3 and 7.

### The open-world problem
In an open-world environment, unknown unknowns are irreducible. NASA documentation and Dagstuhl expert reports acknowledge that assurance cases for autonomous systems in unpredictable environments cannot be completely watertight. The correct response is to **explicitly acknowledge unknown defeaters** rather than claim complete coverage.

### Consequence Closure (RISU)
The closest formalization found: identifies consequence-relevant state distinctions, constructs minimum obligation sets, can certify that no sufficient set exists within the declared vocabulary. Important: this works within a *declared* vocabulary. The question of whether the vocabulary itself is complete remains open.

---

## 17 EFFECT FINALITY

### The five things that must be distinguished

```
INTENT         what was desired
AUTHORIZATION  what was permitted
EXECUTION      what was physically attempted
EFFECT         what actually changed in the world
CONFIRMATION   evidence that the effect occurred
```

These are NOT the same thing. Any assurance system that conflates them will produce false confidence.

### The UNKNOWN_EFFECT state

An agent can experience:
- Tool timeout → was the tool call executed or not?
- Network error → did the operation complete?
- Partial execution → what succeeded?
- Lost acknowledgement → effect occurred but not confirmed

Systems that only model SUCCESS/FAILURE without an explicit UNKNOWN_EFFECT state are systematically incomplete. VERITAS OS already includes EFFECT_UNKNOWN as an explicit state.

### Rollback is representation-specific

Rolling back a Git commit does NOT:
- Undo external API calls
- Undo emails sent
- Undo database mutations
- Remove KV-cache state in the model server
- Remove knowledge from human operators

KV-Cache finding (arXiv:2608.15939): Even after logical transcript rollback, models can continue attending to content the application believes removed. Behavioral flips observed from KV-cache retention.

### The four operations (not one "recovery")
```
REPLAY       — reconstruct what the history says happened
ROLLBACK     — move a representation backward
FORK         — create new trajectory from a prior point
COMPENSATE   — produce new effect to counteract a prior one
```

Rollback of representation ≠ rollback of world state ≠ rollback of human knowledge.

---

## 18 SECURITY FINDINGS

### The core security invariant (never violate)
```
STALL ≠ PERMISSION TO BYPASS SAFETY
```

### Recovery planner as bypass planner (critical threat)
```
POLICY: "You cannot do A"
BAD RECOVERY: "Then do A with a different tool"
```

This is precisely what the system must not do.

**Correct flow:**
```
A blocked
→ Can mission continue without A?
   → YES → find B
            → B satisfies objective AND policy AND authorization
            → verify → continue
   → UNCERTAIN → HARD STOP
```

### GuardFall — the false positive class
The bash-firewall blocked legitimate commands containing `rm -rf ` as a substring, including a commit message. This demonstrates: a correctly motivated security control can become a productivity problem through insufficient context differentiation.

### Common-mode evidence failure
If verifier and actor share evidence, their failures are correlated. Evidence diversity has been shown to matter more than model diversity in commit gate experiments.

### Trust domain analysis

CCP's assurance guarantee is conditional on:
```
CONTROL GUARANTEE
= PROPERTY
  conditional on TRUST DOMAIN
  + OBSERVABLE SURFACE
  + DEPENDENCY MODEL
```

The current trust domain (human/Git review, shared environment) creates a surface where hook weakening or evidence modification can occur within the trust boundary. This is a known limitation, not a critical bug, but it must not be ignored.

### Compositional safety (shadow infrastructure)
Individual actions being safe does NOT guarantee composition is safe. `A authorized + B authorized + C authorized` can produce capability `X` that was never authorized. This is demonstrated empirically in Agentic Shadow Infrastructure (MDPI, 2073-431X/15/8/510).

### Authority timing: TOCTOU for agents
Authorization valid at planning time may be invalid at execution time. "Approved Too Late" (arXiv:2608.26306) and IETF draft on state/policy continuity formalize this. Authority must be validated at commit time, not just at planning time.

---

## 19 COMPETITIVE LANDSCAPE

### Agent control planes (direct CCP competitors/alternatives)

| System | Status | Key Capabilities |
|---|---|---|
| Microsoft Agent 365 | Production (500k+ agents in internal MS use) | Governance, observability, security at scale |
| Microsoft Entra Agent ID | Production | Identity for agents |
| Salesforce Agent Fabric | Production | Agent orchestration/management |
| Boomi Agent Control Plane | Product | Integration-focused |
| GitHub Enterprise AI Controls | Production | SDLC controls for AI |
| Zenity | Product | Enterprise agent security |
| TrueFoundry | Product | ML platform with agent governance |
| AIGIS | Open source | Evidence-gated execution, Docker sandbox |
| ae-framework | GitHub repo | Agent-neutral assurance control plane for SDLC |
| skil | GitHub repo | Vendor-neutral security/verification for AI skills |
| VERITAS OS | GitHub repo | Agent governance runtime with EFFECT_UNKNOWN |

### Research frameworks overlapping CCP

| System | Overlap |
|---|---|
| State-Aware Runtime (Cambridge) | Trajectory governance, effect state machine |
| CONTINUUM | Semantic recovery, idempotent ledger |
| PCAA | Proof-carrying actions |
| CAVA | Canonical action verification |
| PolicyGuide | Policy-compliant workflow remediation |
| Assurance Closure (arXiv:2608.07317) | Full assurance lifecycle framework |

### What AIGIS specifically covers (CCP's direct comparison)

AIGIS implements: TaskContract, typed models, policy engine (ALLOW/DENY/REQUIRE_HUMAN), ToolRequest, Docker sandbox (no-network, non-root, read-only), quality gates, JSON evidence bundles, SHA-256 artifacts, deterministic decision engine, circuit breakers.

CCP differentiators vs AIGIS: **incident→control→regression** (learning loop), historical preservation, phase-gate discipline.

### What ae-framework specifically claims

ae-framework declares itself an "agent-neutral assurance control plane for agent-driven SDLC" with: formal verification, CI integration, policy gates, evidence orchestration, and treatment of Claude Code/Codex/Copilot/Gemini/humans/CI as interchangeable producers.

**Critical caveat:** ae-framework notes its external pilots are still report-only/dry-run. No confirmed live external PRs. No controlled comparison executed as of last research. The claim is structural, not operationally validated.

---

## 20 COMMERCIAL REALITY

### Current commercial state
```
BUYER:           0 identified
WTP:             UNKNOWN
BUDGET:          0 confirmed
PILOTS:          0 running
CUSTOMER EVIDENCE: 0
FIELD INTERVIEWS: 0 conducted
MARKET ROUND:    ROUND 0
```

### What IS known about the market

- The category "agent control plane / agent governance" EXISTS and is rapidly filling
- Large vendors (Microsoft, Salesforce, GitHub/Microsoft) are active
- The problem of governing autonomous agent execution is recognized as real
- Requirements for observability, policy, identity, and audit are being articulated by enterprise buyers

### What is NOT known

- Whether buyers want CCP specifically vs buying from existing vendors
- Whether the incident→learning loop has economic value separate from existing tools
- Whether any user has experienced the specific problem CCP aims to solve at a level that drives purchasing
- Whether any organization would pay for the specific assurance lifecycle integration vs point solutions

### The separation that must never be collapsed

```
TECHNICAL GAP    ≠    USER PAIN
USER PAIN        ≠    BUYER
BUYER            ≠    BUDGET
BUDGET           ≠    WTP
WTP              ≠    DEAL
```

No step in this chain can be inferred from the previous one without field evidence.

### Commercial thesis status
`COMMERCIAL THESIS NOT SUPPORTED` for standalone Claude-specific agent control plane.
This conclusion is stable and should not be revised based on technical findings alone.

---

## 21 COUNTERARGUMENTS

### Against CCP uniqueness
- AIGIS covers evidence-gated execution
- ae-framework claims the exact same positioning (agent-neutral SDLC assurance control plane)
- Microsoft/Salesforce/GitHub are solving governance at scale with existing enterprise relationships
- The category is forming faster than CCP can ship

### Against assurance impact propagation as novel
- TMS (1979) handles dependency-based belief retraction
- Build systems (Riker, Zig incremental) do dependency-graph invalidation
- Continuous assurance research (arXiv:2511.14805) addresses this
- Assurance Envelopes already minimize evidence re-collection

### Against "the deep model is new"
- State-Aware Runtime v4 (Cambridge) proposes nearly the same architecture
- Argus (Microsoft Research) covers long-horizon agentic runtime
- CONTINUUM covers semantic recovery, idempotent action ledger, tamper-evident log
- Assurance Closure framework proposes the full intent→effect assurance chain

### Against recovery as the core problem
- Recovery is a mechanism, not the root abstraction
- The root is "maintaining legitimacy of transitions under change"
- That problem already has named literature (assurance closure, runtime governance, TMS)

### Against "the incident learning loop is unique"
- Requirements engineering has formalized incident→assumption→requirement for decades
- Cleland-Huang's RE 2026 work covers exactly this for autonomous systems
- The specific automation of this in CCP's format may have operational value, but the concept is not new

---

## 22 FALSIFIERS

### For assurance impact propagation
- **Falsifier:** A system already demonstrates end-to-end: change → dependency resolution → stale claims → authority adjustment → targeted re-verification — reproducibly, with published evaluation.
- **Current status:** Partial overlap found (Matrix paper, continuous assurance), but no confirmed full-chain system.

### For assurance closure as gap
- **Falsifier:** ae-framework + skil + PCAA + CAVA + VERITAS together already constitute a sufficient integrated system.
- **Current status:** Each covers a subset. Integration gap remains unconfirmed as solvable.

### For semantic continuity as gap
- **Falsifier:** An existing system demonstrates that agent semantic state (intent, obligations, authority, failed paths) survives context compaction, session restart, model replacement without semantic drift.
- **Current status:** The OpenClaw incident and KV-cache paper both demonstrate gaps. No confirmed solution.

### For specification adequacy as remaining gap
- **Falsifier:** RSGA (RE 2026) already covers this sufficiently for production use.
- **Current status:** RSGA covers "sufficient to start." Lifecycle adequacy (covering factors that matter throughout) is less clear.

### For the "incident → hidden assumption → requirement" loop
- **Falsifier:** RECODE + Cleland-Huang work already covers this in a way that CCP cannot improve upon.
- **Current status:** The human-in-the-loop version is covered. The *automated* version in a coding agent context is less clear.

### For commercial viability
- **Falsifier:** A field study finds 0 operators willing to pay for the specific problem CCP solves, OR finds they already have it covered by existing tools.
- **Current status:** NOT TESTED — Round 0.

---

## 23 UNKNOWNS

### Critical unknowns from original SAGR research (status)

| UNK | Question | Status |
|---|---|---|
| UNK-1 | Do operators actually suffer control-induced stalls? | NOT ANSWERED |
| UNK-2 | How strong/reproducible is RIR/AgentRewind? | NOT ANSWERED (RIR has false precision issue) |
| UNK-3 | Is there real demand for side-effect continuity? | NOT ANSWERED |
| UNK-4 | What does "multi-step recovery" mean in current APIs? | PARTIALLY ANSWERED (framework has support, semantics unclear) |
| UNK-5 | What proportion of failures are policy-induced stalls? | NOT ANSWERED |

### Additional unknowns from deep research

| UNK | Question |
|---|---|
| UNK-6 | Does assurance impact propagation provide measurably better outcomes than full revalidation? |
| UNK-7 | What is the cost of recovery vs restart in real production scenarios? |
| UNK-8 | Can dependency completeness be determined algorithmically in an open world? |
| UNK-9 | Is there a formal characterization of "decision-relevant progress"? |
| UNK-10 | How often does semantic continuity actually fail across execution boundaries in production? |
| UNK-11 | Does the assurance closure architecture (arXiv:2608.07317) have a working implementation? |
| UNK-12 | What is ae-framework's actual production deployment status? |
| UNK-13 | What is skil's adoption and validation status? |
| UNK-14 | Can RSGA's 10 dimensions be extended to lifecycle adequacy, not just start-time adequacy? |

---

## 24 REPRODUCTION REQUIREMENTS

The following need reproduction before claims can be treated as established:

| Item | What needs reproducing |
|---|---|
| RIR "70% / 60-70%" claim | Reproduce with explicit rubric and measurement protocol |
| OSGuard behavior | Reproduce block→feedback→revise→retry cycle independently |
| AgentRewind Safety Review | Reproduce safety-blocked action → agent receives feedback → continues |
| Common-mode evidence failure (VP-CONTROL) | Reproduce: shared evidence → high unsafe approval rate; independent evidence → lower |
| DeepSeek Harness event-sourced architecture | Verify the Session implementation actually works as documented |
| CONTINUUM | Verify 1,360 tests pass on fresh installation |
| ae-framework | Verify claims about pilot status independently |
| SpecBench GPT-5.4 result (44.4% accuracy) | Verify methodology and reproduce benchmark |

---

## 25 FIELD VALIDATION REQUIREMENTS

Cannot be answered by desk research:

- Whether operators experience control-induced stalls (interviews)
- Whether the GuardFall phenomenon is common or rare (instrumentation)
- Whether the incident→learning loop has economic value beyond current tools (customer interviews)
- Whether any organization would pay for assurance lifecycle integration (WTP study)
- The real cost of recovery vs restart in production (measurement)
- The real proportion of failures that are policy-induced (observation)
- Whether specification inadequacy is the actual bottleneck in AI-agent SDLC (operator interviews)

---

## 26 OPEN RESEARCH QUESTIONS

Listed in order of depth (deepest last):

1. Can recovery economics (recover vs restart vs abandon) be measured reproducibly in a coding agent context?

2. Is decision-relevant progress a usefully operationalizable concept, or is it too domain-specific to generalize?

3. Can the assurance model from arXiv:2608.07317 be instantiated in a form compatible with CCP's current hooks/skills/evidence architecture?

4. Does assurance impact propagation provide measurable efficiency improvements over full revalidation, in a reproducible experiment?

5. Can specification adequacy checking be extended from "adequate to start" (RSGA) to "adequate throughout execution"?

6. Does semantic continuity actually fail in CCP F1-F8 across session boundaries, and if so, how often?

7. Can dependency completeness be bounded in a useful way without full world-model closure?

8. Is there a formal relationship between decision-relevant progress and trajectory viability that would make both concepts precise?

9. Does the composition of individually valid assurance mechanisms produce end-to-end assurance, or does common-mode failure systematically undermine multi-mechanism systems?

10. What is the philosophical status of "unknown unknown defeaters" — is acknowledging the boundary sufficient, or does it undermine the entire assurance concept?

---

## 27 DO NOT RESEARCH AGAIN

These research branches are closed. Opening them again as potential innovations wastes resources.

| Topic | Reason closed | What would reopen it |
|---|---|---|
| Loop detection | Multiple production implementations | New evidence that all existing ones have a specific measurable gap not covered |
| Checkpoint/replay | Temporal, DBOS, LangGraph are mature | — |
| Rollback (generic) | Saga, event sourcing, distributed transactions | — |
| Subagent delegation | Claude SDK, OpenAI Agents | — |
| Context compaction | Mature technique | — |
| State fingerprinting | Covered in trajectory systems | — |
| Evidence-gated completion (generic) | AIGIS, ae-framework, PCAA | — |
| Event sourcing for agents | DeepSeek, ActiveGraph, ESAA, CONTINUUM | — |
| Runtime policy enforcement | Microsoft toolkit, OpenClaw, many others | — |
| Memory governance | MemGuard, MemArchitect | — |
| Durable execution = semantic recovery | Explicitly killed. Different problems. | — |
| "SAGR is the primary architecture" | Reduced to mechanism, not architecture | — |
| "Evidence-gated completion is unique" | AIGIS disproved uniqueness | — |
| "Recovery is the core problem" | Reduced to mechanism under assurance closure | — |
| "Trajectory governance is novel" | Cambridge State-Aware Runtime v4 | — |
| "No system generates policy-compliant alternatives" | PolicyGuide exists | — |
| "Execution state ledger is novel" | Ledger paper (arXiv:2608.00808) | — |
| "Mission-state governance is novel" | arXiv:2606.31339 | — |
| "Continuous assurance is novel" | UK gov pub, Fraunhofer, multiple papers | — |

---

## 28 REOPEN ONLY IF

These conditions would justify reopening a closed research branch:

- A new production deployment is found with reproducible benchmarks contradicting current findings
- A primary source contradicts a major finding (not a secondary description)
- A field study produces customer evidence that substantially changes the problem framing
- A new implementation demonstrates that a "solved" problem is NOT actually solved in the CCP context specifically
- An existing claimed implementation (ae-framework, RSGA, etc.) is found to not work as described
- The CCP context introduces a constraint not found in any existing system (e.g., Claude CLI specific, phase-gate specific, incident-learning specific)

---

## 29 CURRENT FRONTIER

The research has narrowed from "find a novel feature" to a specific integration question:

> **Does a system exist that demonstrates, end-to-end and reproducibly: intent → adequate specification → obligations → assurance → authority → transition → effect → change → impact propagation → revalidation — without trusting the agent itself, without over-invalidating on any change, without losing continuity, without hiding unknowns, without allowing stale authority, without sharing all failure modes between actor and verifier, and without cost explosion?**

### The deepest remaining question

Not "how do we control the agent?" but:

> **How does an agent know when its own representation — of the world, of its obligations, of its evidence, of its authority — is no longer sufficient to justify a consequential action?**

And its corollary: when that representation is insufficient, what is the minimum information needed to determine whether a valid continuation exists, and how should authority be adjusted in the interim?

### The key distinction that survived everything

```
AUTONOMY OF EXECUTION  ≠  AUTONOMY OF DEFINING THE GUARANTEE

The agent can be highly autonomous in HOW it works.
But NOT in deciding:
  - WHAT must be true
  - HOW we know it
  - WHAT risk is acceptable
```

This separation between execution autonomy and assurance formation is the clearest principle to survive the full research arc.

---

## 30 CURRENT RESEARCH STATUS

```
CLOSED (sufficient evidence, do not re-investigate):
  - Loop detection as novel
  - Checkpoint/rollback as novel
  - Recovery as primary architecture
  - Evidence-gated completion as unique
  - Durable execution = semantic recovery
  - Event sourcing as novel
  - Runtime policy enforcement as novel
  - SAGR as standalone primary architecture
  - Trajectory governance as novel concept
  - Many specific components (see Section 11)

OCCUPIED (prior art exists, but integration gap possible):
  - Assurance lifecycle integration
  - Specification adequacy → lifecycle (RSGA covers start-time only)
  - Semantic continuity across execution boundaries
  - Assurance impact propagation (as integrated system)
  - Authority adaptation based on assurance state

UNKNOWN / REQUIRES FIELD VALIDATION:
  - Commercial viability
  - Operator pain (control-induced stalls)
  - Willingness to pay
  - Recovery vs restart economics
  - Actual failure proportion by type

UNKNOWN / REQUIRES REPRODUCTION:
  - RIR quantitative claims
  - ae-framework production deployment status
  - RSGA lifecycle adequacy (vs start-time adequacy)
  - Common-mode evidence failure rates

PHILOSOPHICALLY OPEN (may be fundamental limits):
  - Dependency completeness in an open world
  - Unknown unknowns in assurance boundary

HYPOTHESIS (not proven novel, but not killed):
  - Assurance impact propagation as integrated system
  - Decision-relevant progress as control criterion
  - Continuous assurance closure across intent–effect chain
  - Semantic continuity as engineerable property
```

---

## 31 EXACT INTERRUPTION POINT

### What was completed
- CCP F1–F8 implemented and frozen
- F9 research-only, NOT JUSTIFIED
- Competitive analysis completed (AIGIS teardown, market survey)
- SAGR hypothesis formulated and evolved through 3 versions
- GPT-5.6 Luna first investigator pass (6 notes, ~3,452 lines)
- Claude Code second investigator pass (21 files in CLAUDE_SECOND_PASS/)
- Deep hypothesis evolution (Document 3 in source materials) — multiple extended research passes through assurance, requirements, effect finality, boundary completeness
- Current synthesis reached (assurance closure / intent–effect chain)

### What was NOT completed
- FINAL META-AUDIT (planned but not executed)
- Files 31–38 were conceived but NOT confirmed created:
  - `31_GRAFO_DE_EVIDENCIA.md`
  - `32_REGISTRO_DE_BUSQUEDAS.md`
  - `33_MATRIZ_DE_COBERTURA_DE_INVESTIGACION.md`
  - `34_AUDITORIA_ADVERSARIAL_FINAL.md`
  - `35_AUDITORIA_DE_CONSISTENCIA.md`
  - `36_DICCIONARIO_DEFINICIONES.md`
  - `37_CERTIFICADO_DE_SATURACION.md`
  - `38_AUDITORIA_FINAL_DEL_MASTER.md`
- Commercial validation: 0 interviews conducted
- Reproduction of quantitative claims: NOT done
- Adversarial architecture review: INCOMPLETE

### Document provenance for this master context
- **Document 1 (in source):** Handoff Master — summary of CCP history through second Claude pass. Reliable for project history and Claude's synthesis conclusions.
- **Document 2 (in source):** Identical to Document 1 (duplicate submitted). No additional information.
- **Document 3 (in source):** Extended deep research notes — multiple extended ChatGPT passes on assurance, requirements, effect finality, boundary completeness. Contains most of the deep hypothesis evolution. Reliability note: these represent ChatGPT research that was not independently reproduced by Claude; specific paper claims should be verified before treating as established fact.

### Warning about Document 3 sources
Document 3 contains numerous paper citations and URLs. Many appear credible (arXiv papers, IETF drafts, GitHub repositories). However:
- RISU Institute papers (risuinstitute.org) appear multiple times — verify institutional existence and paper availability independently
- Some URLs may be paywalled or have limited access
- "Academic" papers from 2026 in Document 3 were not independently verified by Claude Code in the second pass

---

## 32 NEXT SESSION PROTOCOL

A future session inheriting this context MUST:

### Step 1: Read this entire file
Do not skip sections. The claim ledger and closed hypotheses sections are particularly important to avoid wasted work.

### Step 2: Do NOT restart the investigation
The research has been done. Do not re-derive conclusions already reached.

### Step 3: Identify which of these actions is being requested
```
A. FINAL META-AUDIT — verify all produced research against coverage matrix
B. FIELD VALIDATION — conduct operator interviews
C. REPRODUCTION — reproduce specific quantitative claims
D. ADVERSARIAL AUDIT — attempt to kill surviving hypotheses
E. F10 RESEARCH — investigate specific assurance integration gap
F. COMMERCIAL VALIDATION — buyer/WTP research
G. IMPLEMENTATION — execute within F8 baseline
```

Only proceed with the specifically requested action.

### Step 4: Before any new research
State explicitly:
- Which open hypothesis this addresses
- What existing prior art has been checked
- What the falsifier is
- What would make this research redundant

### Step 5: Maintain provenance
For every new finding, record: source, URL, what it actually says vs what it's being used to support.

### Step 6: DO NOT implement anything without explicit authorization
F1–F8 are frozen. F9 is NOT JUSTIFIED. F10 is NOT OPENED.

### Step 7: Commercial vs technical distinction
Never collapse technical gap into commercial opportunity without field evidence.

---

## 33 HISTORICAL FINDINGS / CORRECTIONS

### HF-001: OSGuard capability
**Original description:** Fixed retry / hard stop mechanism.
**Correction:** Real mechanism includes block → feedback → revise action → re-check → retry limit.
**Impact:** Weakened the claim that "no system does recovery around blocked actions."
**Source:** Claude Code web research (second pass).

### HF-002: RIR quantitative claim
**Original description:** "60–70% success rate" / "70%"
**Correction:** No reproducible rubric exists. This is false precision.
**Impact:** Any claim relying on RIR quantitative performance must be marked as unverified.

### HF-003: Side-effect continuity as absolute vacuum
**Original description:** Nobody handles side-effect continuity.
**Correction:** Living AI, Replay Agent Recorder, AgentRewind have partial implementations.
**Impact:** Not an absolute gap. Partial solutions exist.

### HF-004: "generate_alternative + non_bypass_verify are the only technical blocker nobody has implemented"
**Original description:** Strong claim about uniqueness.
**Correction:** PolicyGuide substantially covers policy-compliant alternative generation.
**Impact:** This claim must be retracted or heavily qualified.

### HF-005: "3 cases in 4 weeks → build SAGR internally"
**Original description:** Claude proposed this as a decision criterion.
**Correction:** No theoretical or empirical justification for "3 cases → build." This is not a validated decision rule.
**Impact:** Must be removed as a decision criterion entirely.

### HF-006: dossier anchoring
**Finding:** The `CCP_SAGR_RESEARCH_DOSSIER.md` was anchored to commit `035a573` but HEAD was at `74f7d1e` after the second Claude pass. The dossier is therefore OUTDATED with respect to the actual repository state.
**Impact:** The dossier cannot be treated as a photograph of final state. It is a historical artifact.

### HF-007: GPT output structure
**Finding:** GPT-5.6 Luna did not produce the 30+ planned numbered artifacts. It produced 6 consolidated notes.
**Interpretation:** This was classified as a structural finding (different output format), not necessarily intellectual failure. However, some gaps in coverage may exist.

---

## 34 SOURCE INTEGRITY NOTES

### Sources requiring independent verification before reliance

| Source | Issue |
|---|---|
| RISU Institute papers (SRC-008, 009, 010) | Institutional provenance unclear. URLs (risuinstitute.org) need verification. |
| ae-framework pilot claims | Self-reported as "report-only/dry-run" — no confirmed external production use. |
| SpecBench GPT-5.4 result (44.4%) | Paper methodology needs verification before treating as a benchmark of reference. |
| RSGA (RE 2026) | Conference paper — implementation details need direct verification. |
| QUARE (RE 2026) | Same as RSGA. |
| RECODE Hanyang/Hyundai | Need to verify institutional affiliation and paper peer review status. |
| Assurance Closure 6 gaps (arXiv:2608.07317) | arXiv preprint — not peer-reviewed at last check. Important but treat as working paper. |

### Sources with HIGH confidence
- AIGIS teardown (hands-on reproduction, 234 tests run)
- Kubernetes documentation (official)
- Microsoft Saga pattern documentation (official)
- Event Sourcing pattern documentation (official)
- DeepSeek Harness (direct GitHub inspection possible)
- CONTINUITY (arXiv, inspectable)
- AgentRewind (described in research, not hands-on reproduced)

### Sources NOT found / fabrication risk
During the research process, the constraint "NEVER INVENT SOURCES" was repeatedly asserted. However, Document 3 contains many paper citations that were not verified by independent Claude Code web searches. Before citing any Document 3 source as established fact, it should be independently located.

---

## 35 MASTER CONCLUSION

### What the project found

CCP is not pursuing a novel primitive. It is pursuing an integration of governance practices that are individually well-studied but not assembled in a working system that covers the full intent→effect chain with continuous validity.

The deepest surviving insight:

> A reliable autonomous system is not one that never fails nor one that always continues. It is one that knows what must be true to continue, what evidence justifies that continuation, what remains unknown, what authority corresponds to that level of certainty, and when it must stop acting.

### What is actually valuable in CCP (surviving after full research)

1. **The incident → control → regression learning loop** — turns operational experience into future engineering constraints. The automated version in a coding agent context has not been replicated by others.

2. **Phase-gate discipline** — explicit, documented gates between phases with evidence requirements. Differentiates from AIGIS.

3. **Historical preservation** — not just current state but the history of how decisions were made.

4. **The principle: evidence ≠ assurance** — evidence can be valid but insufficient, stale, or irrelevant to the claim. CCP implicitly understood this; making it explicit is valuable.

5. **The fail-closed defaults** — TaskCompleted, firewall, etc. designed to fail safely rather than produce false passes.

### What must happen before F10

The FINAL META-AUDIT must:
- Verify complete coverage of master research prompt
- Check provenance of all major claims
- Identify remaining contradictions
- Determine whether saturation has been reached
- Produce explicit RESEARCH COMPLETE or RESEARCH INCOMPLETE verdict

Without this, F10 has no justified starting point.

---

## APPENDIX A: 22 PRIMITIVES FROM SAGR V1 (for reference)

These were identified early in the SAGR research. Most are now classified as individually existing in other systems:

| P# | Name | Current Status |
|---|---|---|
| P1 | State Fingerprint | Exists in AgentAssay, trajectory systems |
| P2 | Progress Signal | Exists in multiple systems |
| P3 | Loop Detector | Exists (multiple implementations) |
| P4 | Checkpoint | Exists (Temporal, DBOS, etc.) |
| P5 | Recovery Classifier | Partially — hard/recoverable distinction exists |
| P6 | Recovery Planner | Exists in multiple systems |
| P7 | Subagent Delegation | Exists in Claude SDK, OpenAI |
| P8 | Bounded Branch Exploration | Exists in LATS, search systems |
| P9 | Branch Adjudication | Exists in speculative execution |
| P10 | Minimum Sufficient Context | Open — specific formulation as claim-conditional |
| P11 | Recovery Cost Budget | Exists in assurance-budget, speculative execution |
| P12 | Safety Policy During Recovery | Open — integration with recovery under policy |
| P13 | Verification After Recovery | Exists in self-healing orchestrators |
| P14 | Historical Learning of Failed Paths | Open — combined with TMS-style reasoning |
| P15 | Trajectory Memory | Exists in State-Aware Runtime, DeepSeek |
| P16 | Semantic Equivalence Detector | Partially — in TMS, belief revision |
| P17 | Recovery Cost Predictor | Hypothesis — partial in speculative execution |
| P18 | Policy-Gap Analyzer | Open — PolicyGuide covers partial case |
| P19 | Second-Order Recovery Governor | Open — "recovery needs governance of its own" |
| P20 | Evidence Continuity Across Context Boundary | Open — partially in CONTINUUM |
| P21 | Stall Classification Audit Trail | Exists in assurance audit approaches |
| P22 | Provider-Agnostic Recovery Envelope | Partially — ae-framework, PCAA claim this |

---

## APPENDIX B: HYPOTHESIS EVOLUTION TIMELINE

```
CCP ORIGINAL
→ "agent cannot say DONE without evidence"
→ [AIGIS disproves uniqueness]

SAGR v1
→ "detect stall → recover → explore → resume"
→ [most components found individually in ecosystem]

SAGR v2 (Claude synthesis)
→ "governance of continuation"
→ [State-Aware Runtime, Argus occupy this space]

TRAJECTORY GOVERNANCE
→ "govern the full trajectory, not just completion"
→ [Cambridge v4, mission assurance occupy this space]

RECONCILIATION
→ "recovery is a special case of reconciliation under uncertainty"
→ [Kubernetes, Saga, runtime assurance already formalize this]

DEPENDENCY COMPLETENESS
→ "the problem is whether we have ALL relevant dependencies"
→ [Consequence Closure, TMS, open-world planning are prior art]

SEMANTIC STATE SUFFICIENCY
→ "is the state sufficient for correct future decisions?"
→ [ResidualAuth demonstrates this for authorization; belief-state research covers it]

CONTINUOUS ASSURANCE CLOSURE
→ "maintain verifiable relation: intent→spec→obligations→evidence→authority→transition→effect"
→ [arXiv:2608.07317 proposes exactly this framework as research agenda]

ASSURANCE IMPACT PROPAGATION
→ "when dependency changes, propagate only relevant invalidation"
→ [TMS, build systems, continuous assurance cover components; integrated version is open]

CURRENT FRONTIER
→ "does any system demonstrate the full chain end-to-end, reproducibly, without trusting the agent itself?"
→ [OPEN — no confirmed full-chain system found]
```

---

==================================================
CURRENT RESEARCH HANDOFF
==================================================

**STATUS:** RESEARCH ACTIVE — META-AUDIT PENDING

**ROOT PROBLEM:** How can an autonomous agent maintain a legitimately governed transition from intention through to real-world effect, under continuous change, under uncertainty, and under the constraint that the agent itself cannot be fully trusted to define what makes its own transitions legitimate?

**CURRENT BEST MODEL:** Continuous assurance closure across the intent–effect chain, with: specification adequacy gating → obligation formation → assurance planning → evidence collection → authority adaptation → transition enforcement → effect reconciliation → change impact propagation → history preservation → incident learning.

**WHAT WE THOUGHT IT WAS:** A recovery system for stuck agents (SAGR).

**WHAT IT NOW APPEARS TO BE:** A question about what must remain invariant across the lifecycle of an autonomous execution, and who has the authority to define and verify those invariants.

**WHAT IS ALREADY OCCUPIED:** Loop detection, checkpoint, rollback, durable execution, event sourcing, state-aware runtime, evidence-gated completion, trajectory governance, policy enforcement, runtime assurance, continuous assurance, belief state management, memory governance, action certification, authority binding, effect reconciliation (as individual components).

**WHAT WAS FALSE / OVERSTATED:** 
- Evidence-gated completion is unique
- SAGR is a novel primary architecture
- RIR has a validated 70% success rate
- Side-effect continuity is an absolute vacuum
- Policy-compliant alternative generation is completely missing
- "3 cases → build" is a valid decision criterion
- generate_alternative + non_bypass_verify are the only missing technical blockers

**WHAT SURVIVED:** The incident→learning loop, phase-gate discipline, historical preservation, fail-closed defaults, and the principle that evidence ≠ assurance.

**WHAT DIED:** SAGR as primary architecture. Most individual primitive claims. "Novel recovery engine" framing.

**DEEPEST OPEN HYPOTHESIS:** Can assurance impact propagation be demonstrated as an integrated system covering the full intent→effect chain with: selective invalidation on change, authority adaptation, and reproducible evaluation — without a trusted agent and without cost explosion?

**STRONGEST COUNTERARGUMENT:** ae-framework + skil + PCAA + CAVA + VERITAS together may already constitute the integration. We have not done a systematic comparison of their combined coverage against the hypothesis.

**KNOWN FALSIFIER:** A system already demonstrates the full chain end-to-end with published evaluation. Location: ae-framework + arXiv:2608.07317 combination needs to be systematically checked.

**COMMERCIAL STATUS:** ROUND 0. No buyer. No WTP. No pilot. COMMERCIAL THESIS NOT SUPPORTED for standalone product.

**FIELD VALIDATION STATUS:** 0 interviews. Required before any commercial decision.

**REPRODUCTION STATUS:** RIR claim unverified. RISU papers need institutional verification. ae-framework pilot status needs independent confirmation.

**CRITICAL UNKNOWNS:** 
1. Does ae-framework + arXiv:2608.07317 already solve the integration problem?
2. Is RISU Institute a real research institution with verifiable papers?
3. Do operators actually experience policy-induced stalls at a meaningful rate?
4. What is the actual cost of recovery vs restart in production?

**DO NOT RESEARCH AGAIN:** Loop detection, checkpoint, rollback, subagent delegation, context compaction, event sourcing, SAGR as standalone architecture, evidence-gated completion as unique primitive, "trajectory governance is novel."

**DO NOT IMPLEMENT:** F10, SAGR engine, new recovery system, new event log, new assurance architecture — until meta-audit completes and explicitly justifies a specific implementation target.

**CURRENT FRONTIER:** Whether the assurance impact propagation hypothesis survives a systematic comparison against the combined coverage of existing systems (ae-framework, PCAA, CAVA, VERITAS, arXiv:2608.07317, continuous assurance literature).

**LAST VERIFIED STATE:** F1–F8 frozen. HEAD at `74f7d1e`. Research dossier at `035a573` (STALE). CLAUDE_SECOND_PASS/ has 21 files. Meta-audit files 31–38 NOT CONFIRMED CREATED.

**EXACT INTERRUPTION POINT:** The extended deep research pass (Document 3) reached the assurance closure/impact propagation synthesis. The FINAL META-AUDIT was planned but never executed. No files 31–38 confirmed created. Session ended before auditing whether the master research prompt was fully satisfied.

**NEXT LOGICAL RESEARCH ACTION:** Execute FINAL META-AUDIT — systematically compare remaining hypotheses against ae-framework + arXiv:2608.07317 + PCAA + CAVA + VERITAS to determine whether the integration gap is real or already solved. Produce explicit RESEARCH COMPLETE or RESEARCH INCOMPLETE verdict with evidence.

==================================================
END MASTER CONTEXT
==================================================

*This file was produced on 21 September 2026 by consolidating three source documents from the CCP/SAGR research project. It represents the research state as of the last known session. All future sessions should update this file rather than the original conversation history.*
