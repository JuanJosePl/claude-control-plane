# CCP — RESEARCH & ARCHITECTURAL KNOWLEDGE ATLAS

> Master knowledge atlas of the Claude Control Plane.
>
> This document reconstructs the project's research, references, ideas, decisions, architectural lineage, implementation lineage, evidence lineage, rejected paths, surviving concepts, and current knowledge state.
>
> **Classification schema used throughout:**
> `[FACT]` `[DOCUMENTED FACT]` `[AUDITED FACT]` `[INFERENCE]` `[HYPOTHESIS]` `[DESIGN]` `[IMPLEMENTED]` `[FROZEN]` `[REJECTED]` `[REFUTED]` `[HISTORICAL]` `[OPEN]` `[UNKNOWN]` `[NOT AUTHORIZED]`

---

## 1. Purpose of This Atlas

This document is a single point of reference for the complete intellectual history of the Claude Control Plane (CCP). It is intended to function simultaneously as:

- **Historical Memory** — what was thought, when, and why
- **Research Archive** — what was investigated, with what method, and what was found
- **Reference Catalog** — what external systems, papers, and patterns were studied
- **Idea Ledger** — every idea that shaped the project, whether adopted or rejected
- **Decision Ledger** — every structural decision, with its evidence and consequence
- **Architectural Lineage** — where each system component came from intellectually
- **Functional Lineage** — what capability exists, what was only designed, what was rejected
- **Knowledge Map** — what CCP knows, what remains open, what has been closed

**What this document is NOT:**
- A roadmap or implementation plan
- A proposal for future features
- A summary replacing the primary sources
- A claim of production-ready capabilities beyond what is verified

Anyone reading only this document should be able to answer, for any feature: why it exists; for any reference: why it was studied; for any idea: whether it was implemented, rejected, or left open; for any decision: what evidence motivated it; and for the system as a whole: how CCP arrived at its current state.

---

## 2. How to Read It

**Navigating forward:** §3 gives the current system truth state. §7 gives the full timeline. §9 traces F1–F8 in detail. §§13–17 cover external references. §§18–25 cover the idea lifecycle. §§26–27 cover SAGR evolution and its 22 primitives. §28 is the decision ledger. §§46–48 cover the R2/R3/Roger research programs. §§49–56 cover hypotheses, open problems, and unknowns. §§57–64 are master matrices for cross-cutting lookups.

**Classifications matter.** `[IMPLEMENTED]` means runtime code exists and was verified. `[DESIGN]` means a formal design exists but no runtime code. `[RESEARCH]` means studied only. `[HYPOTHESIS]` means proposed but not demonstrated. Never treat these as equivalent.

**Source traceability.** Each claim of substance includes a source reference in the form `(SOURCE: filename §section)` where that information was captured during corpus ingestion.

**Two investigation corpora.** The project accumulated research from two independent investigators. Corpus A refers to the ChatGPT/Web investigation (primary document: `CCP_RESEARCH_CONTEXT_MASTERC.md`). Corpus B refers to the Claude/Cowork investigation (primary documents: `CCP_RESEARCH_CONTEXT_MASTER.md` + `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/`). Where the two diverge, this atlas notes it; the reconciliation artifact (`46_FINAL_RECONCILIATION.md`) is the authoritative resolver.

---

## 3. Current CCP Truth State

**As of 2026-09-22 (post-reconciliation). Source: `PROJECT_STATE.md`, `46_FINAL_RECONCILIATION.md`.**

| Property | Value | Classification |
|---|---|---|
| Phase | 8 — COMPLETE / FROZEN | [DOCUMENTED FACT] |
| Next phase | None auto; owner decision required | [DOCUMENTED FACT] |
| F9 | NOT JUSTIFIED — research only, no implementation | [DOCUMENTED FACT] |
| F10–F12 | UNKNOWN / NOT STARTED | [DOCUMENTED FACT] |
| Commercial thesis | NOT SUPPORTED (standalone product) | [AUDITED FACT] |
| SAGR as recovery | DEAD / REFUTED | [AUDITED FACT] |
| SAGR as governance of continuation | PARTIALLY SUPPORTED (open-ended scope only) | [AUDITED FACT] |
| Evidence-gated completion | NOT UNIQUE — AIGIS reproduces it | [AUDITED FACT] |
| Incident→control→regression loop | PARTIALLY SUPPORTED — unique vs AIGIS, unvalidated commercially | [AUDITED FACT] |
| Residual technical problem | generate_alternative + non_bypass_verify for open-ended agents | [DOCUMENTED FACT] |
| R2 instrumentation | IMPLEMENTED (observation only, no security change) | [DOCUMENTED FACT] |
| R3 design | DESIGN ONLY — not implemented, not production-ready | [DOCUMENTED FACT] |
| Roger hypothesis | INDETERMINED — dominant tendency REFORMULATION | [AUDITED FACT] |
| Native Claude Code lifecycle verification | NOT VERIFIED (script-only; deferred per F9-D02=B) | [DOCUMENTED FACT] |
| Last git checkpoint | `3336bd6` (research checkpoint) / F8 frozen at `2cd7953` | [DOCUMENTED FACT] |

---

## 4. Project Origin

**[DOCUMENTED FACT — SOURCE: `CCP_RESEARCH_CONTEXT_MASTERC.md` §01, `MASTER_IMPLEMENTATION_PLAN.md` §1]**

The Claude Control Plane originated as a personal engineering infrastructure project to govern AI-agent-assisted software development. The triggering insight was that an AI agent—left unguarded—could declare a task "done" without producing verifiable evidence of completion. This gap between agent claim and verifiable reality motivated building a layer of enforcement between the agent's self-assessment and the developer's trust.

The project was not initially a commercial product. It was a personal operational discipline formalized into infrastructure: hooks that enforce evidence before completion, skills that guide workflow, registries that track decisions and incidents, and context packs that give agents structured situational awareness.

**Original problem statement (paraphrased from `MASTER_IMPLEMENTATION_PLAN.md §1.2 P0.2`):**
> An AI agent completing a coding task can produce a `TaskCompleted` signal without any evidence that the evidence contract was satisfied. The hook `task-completed-evidence.sh` was created to fail-close this gap.

The project's genesis was therefore a specific observed failure: the absence of evidence enforcement. Everything that followed—F1 through F8, the research programs, the SAGR hypothesis—extends from this root.

---

## 5. Original Mission

**[DOCUMENTED FACT — SOURCE: `CCP_RESEARCH_CONTEXT_MASTERC.md` §02]**

The original mission was:

> Build a control plane for AI-agent-driven software engineering with: security, traceability, quality, verifiability, reversibility, context control, state control, reduced manual work, reduced errors, reuse, productivity, maintainability, evolutionary capacity, and objective evidence of "done."

This mission evolved in two directions as research deepened:

**Evolved mission (post-SAGR research):**
> Determine whether a unified primitive or architecture exists for governing the continuation of an autonomous execution when the current trajectory becomes invalid — under constraints of safety, state, evidence, cost, authorization, and failure memory.

**Meta-mission (deepest current layer, from Corpus A):**
> Determine whether continuous assurance closure across the intent–effect chain already exists under another name, is only a partial composition, or represents a genuine open problem worth engineering.

The shift from "operational discipline for one developer" to "governance of continuation for open-ended agents" represents the most significant intellectual evolution of the project's identity.

---

## 6. Core Principles

**[DOCUMENTED FACT — SOURCE: `CCP_RESEARCH_CONTEXT_MASTERC.md` §00, `docs/DESIGN.md` §1]**

These principles survived the entire research program and are enforced or documented in the runtime:

| Principle | Origin | Where Enforced |
|---|---|---|
| `BENEFIT > COMPLEXITY` | Design discipline | `DESIGN.md §1`, every phase gate |
| `EVIDENCE > CLAIM` | F2 evidence contract | `task-completed-evidence.sh`, evidence schema |
| `RUNTIME > DOCUMENTATION` | Audit discipline | Operational rule: audit before trusting docs |
| `OBSERVED > ASSERTED` | Research discipline | Research provenance classification |
| `REPRODUCED > DESCRIBED` | Research quality | Source confidence system |
| `FAIL-CLOSED > FALSE-PASS` | F8 hardening | `bash-firewall.sh` F8-B, `task-completed-evidence.sh` F8-A |
| `STALL ≠ PERMISSION TO BYPASS SAFETY` | SAGR invariant | Not yet enforced in runtime; documented as inviolable invariant |
| `FALSIFICATION > CONFIRMATION` | Research discipline | Every hypothesis has a falsifier |
| `SIMPLE > CLEVER` | Design discipline | No novel mechanism unless justified by evidence |
| `REVERSIBLE > IRREVERSIBLE` | Risk model | All P0 hook changes require human approval |
| `UNKNOWN ≠ PERMISSION` | Research boundary | Explicitly documented in F9 decision |

---

## 7. Complete Historical Timeline

**[DOCUMENTED FACT — SOURCE: `CCP_RESEARCH_CONTEXT_MASTERC.md` §03, `PROJECT_STATE.md`, `MASTER_IMPLEMENTATION_PLAN.md`]**

```
ORIGINAL VISION
   Agent cannot claim DONE without verifiable evidence.
   ↓
PRE-F1 (before 2026-09-16)
   P0 work: settings.json, task-completed-evidence.sh, SDLC skills.
   Working tree not yet consolidated; JSON had // comments.
   ↓
PHASE F0 — Baseline and contract (approved)
   Master Implementation Plan validated.
   Inventory of real state vs. documented state.
   ↓
PHASE F1 — Foundation installable (2026-09-16)
   install.sh consolidated; context skills installed; canonical registries created.
   evidence: EV-001
   ↓
PHASE F2 — Evidence Contract hardened (2026-09-16)
   task-completed-evidence.sh hardened; schema; risk-aware reviewer requirements.
   evidence: EV-002
   ↓
PHASE F3 — SDLC Lanes + Independent Verification (2026-09-16/17)
   Initial blocker: --bare flag prevented OAuth; resolved without --bare.
   Tier 1/2/3 evals: PASS.
   evidence: EV-003 (BLOCKED), EV-004 (BLOCKED), EV-005 (VERIFIED)
   ↓
PHASE F4 — Incident Learning (2026-09-17)
   INC-001 created → CTRL-001 → REG-001.
   CONTROL_REGISTRY, REGRESSION_REGISTRY created.
   evidence: EV-006
   ↓
PHASE F5 — State Integrity + Provenance (2026-09-17)
   Hash of critical fields; drift detection; provenance vocabulary.
   evidence: EV-007
   ↓
PHASE F6 — Evals + Maintenance (2026-09-17)
   evals/maintenance.sh; CI workflow; regression budget.
   F6 closes original Master Plan.
   evidence: EV-008
   ↓
POST-F6 AUDIT (2026-09-17)
   POST_F6_AUDIT_REPORT.md written.
   11 gaps identified (4 P1, 4 P2, 3 DEFER).
   MASTER_EVOLUTION_ROADMAP.md proposed F7.
   ↓
PHASE F7 — Evidence Integrity + Behavioral Reliability (2026-09-18)
   Bundles A-E: stop-logger fix, bash-firewall hardening, evidence coupling,
   log rotation, installer idempotency. ARCH-004 formalized.
   evidence: EV-009 to EV-014. Regressions: REG-002 to REG-009.
   Commit: 47874a5 (FROZEN)
   ↓
F7-F12 RESEARCH HANDOFF (2026-09-18)
   Behavioral audit identified G-B6/B10/B11, A-03/A-04/A-05/A-06/A-07.
   F8 candidate scope defined.
   ↓
PHASE F8 — Fail-Closed Closure (2026-09-19)
   F8-A: contract_hash required (fail-closed). F8-B: JSON firewall hardened.
   A-06: reviewer identity convention documented.
   evidence: EV-015, EV-016. Regressions: REG-010, REG-011.
   Commit: 2cd7953 (FROZEN)
   ↓
F9 RESEARCH (2026-09-19)
   Executor: ChatGPT GPT-5.6 Luna/OpenCode.
   Question: Does any gap justify new runtime work post-F8?
   Result: F9 NOT JUSTIFIED. No candidate survived all four gates.
   ↓
COMMERCIAL / AIGIS RESEARCH (2026-09-20)
   Market Validation Report produced.
   AIGIS teardown: 234 tests (223/10/1).
   H1 (evidence-gated completion unique): NOT SUPPORTED.
   ↓
F9 OWNER DECISION GATE CLOSED (2026-09-20)
   Five decisions: F9-D01=A (no F9), F9-D02=B (defer native),
   F9-D03=B (evidence first), F9-D04=B (Git+human trust),
   F9-D05=A (keep AIGIS reference).
   ↓
SAGR DOSSIER RESEARCH (2026-09-21, GPT-5.6 Luna)
   17 tracks. 22 primitives identified (P1–P22).
   Initial conclusions: prior art heavy; SAGR = recovery (later corrected).
   6 NOTAS files produced.
   ↓
CLAUDE SECOND PASS (2026-09-21, Claude Sonnet 4.6)
   28 files (00–38). WebSearch for 10 primary claims.
   5 corrections applied (C-01 to C-05).
   Hypothesis reformulation: SAGR ≠ recovery; SAGR = governance of continuation.
   Saturation certificate: 37_CERTIFICADO_DE_SATURACION.md.
   ↓
FINAL RECONCILIATION (2026-09-21, Claude Opus 4.7)
   Documents 39–46. Two-investigator reconciliation.
   12 agreements, 5 reconcilable disagreements, 0 irreconcilable contradictions.
   Decision: REQUIRES REPRODUCTION + FIELD VALIDATION.
   ↓
R-1: PRIOR ART VERIFICATION (2026-09-21)
   Document 47. 4 candidates verified against primary sources.
   All 4 FAIL to close the residual problem.
   Residual problem SURVIVES.
   ↓
R-2: STALL_POLICY INSTRUMENTATION (2026-09-22)
   Document 48. bash-firewall + task-completed-evidence instrumented.
   stall-record.sh helper; STALL_POLICY_LOG.jsonl created (empty).
   No security behavior changed.
   ↓
R-3: NON_BYPASS_VERIFY DESIGN (2026-09-22)
   Document 50. Formal design + falsifiability protocol.
   DESIGN ONLY — not implemented, not production-ready.
   ↓
ROGER HYPOTHESIS AUDIT (2026-09-22)
   Document 52. Delta analysis of representation-level shift.
   Classification: INDETERMINED; tendency = REFORMULATION.
   ↓
CCP COMPLETE CONCEPTUAL MAP (2026-09-22)
   CCP_COMPLETE_CONCEPTUAL_MAP.md created.
   48-section system documentation.
   ↓
CCP RESEARCH & ARCHITECTURAL KNOWLEDGE ATLAS (2026-09-22)
   This document. Comprehensive intellectual history.
   ↓
CURRENT STATE (2026-09-22)
   F8 FROZEN. F9 NOT JUSTIFIED. F10-F12 UNKNOWN.
   Research program closed (desk research saturated).
   Next authorized actions: R-2 field observation (30 days) if owner decides.
```

---

## 8. CCP Evolution

**[DOCUMENTED FACT — SOURCE: `CCP_RESEARCH_CONTEXT_MASTERC.md` §00, `docs/DESIGN.md`]**

CCP evolved through three conceptual generations:

### Generation 1: Evidence-Gated Engineering (F1–F6)
The system was an enforcement layer: hooks, skills, registries, and state management that prevented an AI agent from claiming "done" without satisfying a formal evidence contract. The core innovation was operational discipline materialized as infrastructure.

**Key insight of this generation:** The agent can say DONE. The system decides whether it is true.

This insight was independently discovered by AIGIS (competitor). Both projects arrived at the same thesis verbatim. [AUDITED FACT — SOURCE: `AIGIS_TEARDOWN.md §3`]

### Generation 2: Behavioral Reliability + Incident Learning (F7–F8)
F7 closed behavioral gaps identified in post-F6 audit: stop-logger anti-loop, bash-firewall case tolerance, evidence freshness, log rotation, installer idempotency. F8 hardened fail-closed semantics: contract_hash required, JSON firewall for malformed inputs, reviewer identity convention.

The learning loop `incident → control → regression` was formalized as a first-class design pattern, with INC-001 as the canonical example. This loop is a genuine differentiator vs. AIGIS. [AUDITED FACT — SOURCE: `AIGIS_TEARDOWN.md §3 rows 69-71`]

### Generation 3: Research Phase (post-F8)
After F8, the project turned from implementation to investigation. The commercial thesis was tested (NOT SUPPORTED). SAGR was hypothesized, researched, reformulated from "recovery" to "governance of continuation," and left as PARTIALLY SUPPORTED. Two independent research passes, four audits, and a reconciliation produced the knowledge state described in this atlas.

**The evolution of the central question:**
```
Gen 1: "Can the agent complete without evidence?"       → SOLVED (hooks)
Gen 2: "Are the controls reliable and fail-closed?"     → SOLVED (F7–F8)
Gen 3: "What happens when the agent is blocked by policy
        and needs a policy-compliant alternative?"       → OPEN PROBLEM
```

---

## 9. F1–F8 Evolution

**[DOCUMENTED FACT — SOURCE: `MASTER_IMPLEMENTATION_PLAN.md §5`, `EVIDENCE_REGISTRY.md`, `PROJECT_STATE.md`]**

Each phase produced verified evidence. This section traces what was built, why, and what it closed.

### Phase F1 — Foundation Installable and State-Coherent
- **Date:** 2026-09-16
- **Problem solved:** install.sh produced invalid JSON (// comments); context skills not copied; canonical registries missing; agent `skills:` frontmatter was unverified.
- **Deliverables:** Valid settings.json; install.sh copies all skills; canonical EVIDENCE_REGISTRY, DECISION_REGISTRY, ARTIFACT_MANIFEST, PROJECT_STATE created; SubagentStart injects context packs by role.
- **Evidence:** EV-001 — VERIFIED
- **Origin of idea:** Audit of working tree vs. documented state (Master Plan §1.1)

### Phase F2 — Evidence Contract + TaskCompleted Hardening
- **Date:** 2026-09-16
- **Problem solved:** TaskCompleted could accept completion without verified evidence.
- **Deliverables:** `task-completed-evidence.sh` hardened with schema; risk-aware reviewer check; hashes, checks, exceptions, timestamp required.
- **Evidence:** EV-002 — VERIFIED

### Phase F3 — SDLC Lanes + Independent Verification
- **Date:** 2026-09-16/17
- **Problem solved:** Skills existed as guidance only; no Tier 1/2/3 evals; no behavioral fixtures.
- **Deliverables:** Tier 1 structural, Tier 2 routing, Tier 3 behavioral evals; code-reviewer agent; fixtures.
- **Blocker resolved:** `--bare` flag prevented OAuth; removing it enabled authentication. Key lesson: DEFERRED ≠ UNAVAILABLE.
- **Evidence:** EV-003 (BLOCKED), EV-004 (BLOCKED), EV-005 (VERIFIED)

### Phase F4 — Incident Learning Loop
- **Date:** 2026-09-17
- **Problem solved:** No structured path from incident to preventive control.
- **Deliverables:** INC-001 → CTRL-001 → REG-001; CONTROL_REGISTRY.md; REGRESSION_REGISTRY.md.
- **Evidence:** EV-006 — VERIFIED
- **Learning loop:** `incident → hidden assumption → requirement → control → regression`

### Phase F5 — State Integrity + Provenance
- **Date:** 2026-09-17
- **Problem solved:** No hash of critical state fields; no drift detection; no provenance vocabulary.
- **Deliverables:** Hash of PROJECT_STATE fields; drift fixture; provenance taxonomy (EXTRACTED/INFERRED/ASSUMED/EXTERNAL/GENERATED).
- **Evidence:** EV-007 — VERIFIED

### Phase F6 — Evals + Maintenance + CI
- **Date:** 2026-09-17
- **Problem solved:** No regression suite for control plane itself; no CI; no behavioral baseline.
- **Deliverables:** `evals/maintenance.sh` (12 deterministic checks); `.github/workflows/control-plane.yml`; REGRESSION_BUDGET.json.
- **Evidence:** EV-008 — VERIFIED
- **F6 closes the original Master Plan.**

### Phase F7 — Evidence Integrity + Behavioral Reliability
- **Date:** 2026-09-18 — Commit `47874a5` (FROZEN)
- **Problem solved:** Five behavioral gaps: stop-logger re-emitting reminders; firewall not case-tolerant; Tier 3 snapshots editable; evidence freshness unchecked; installer not idempotent.
- **Bundles:**
  - Bundle A: stop-logger respects stop_hook_active=true
  - Bundle B: bash-firewall tolerates spaces/case; covers .env read variants
  - Bundle C: evidence freshness check in maintenance.sh (evidence_freshness_days=30)
  - Bundle D: CLAUDE_SESSION_LOG daily rotation
  - Bundle E: settings.json idempotent reinstall with --force
  - ARCH-004: task tracking semantics formalized
- **Evidence:** EV-009 to EV-014 — VERIFIED
- **Regressions:** REG-002 to REG-009

### Phase F8 — Fail-Closed Closure
- **Date:** 2026-09-19 — Commit `2cd7953` (FROZEN)
- **Problem solved:** A-03 (contract_hash optional); A-04 (firewall passed malformed JSON); A-06 (reviewer identity undocumented).
- **Bundles:**
  - F8-A: task-completed-evidence.sh fails-closed on missing contract_hash with exit 2
  - F8-B: bash-firewall blocks empty input, whitespace-only, invalid JSON, multi-stream, NUL bytes
  - A-06: Handbook §12 documents reviewer identity convention
  - ARCH-004 addendum: contract_hash now mandatory
- **Evidence:** EV-015, EV-016 — VERIFIED
- **Regressions:** REG-010, REG-011
- **Out of scope:** A-05, A-07, F9–F12

---

## 10. Research Corpus Inventory

**[DOCUMENTED FACT — SOURCE: filesystem discovery 2026-09-22]**

### Pre-SAGR Research (market/commercial)
| File | Author | Date |
|---|---|---|
| `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md` | GPT+Claude | Sep-2026 |
| `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md` | Claude | Sep-2026 |
| `CLAUDE_CONTROL_PLANE_MARKET_SOURCES.md` | Claude | Sep-2026 |
| `CLAUDE_CONTROL_PLANE_AIGIS_TEARDOWN.md` | Claude Opus 4.7 | 2026-09-20 |
| `CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md` | Claude | Sep-2026 |
| `CLAUDE_CONTROL_PLANE_COMPETITIVE_TEARDOWN_PROTOCOL.md` | Claude | Sep-2026 |
| `CLAUDE_CONTROL_PLANE_CUSTOMER_DISCOVERY_PROTOCOL.md` | Claude | Sep-2026 |

### SAGR Research — First Pass (GPT-5.6 Luna)
| File | Content |
|---|---|
| `CCP_SAGR_RESEARCH_DOSSIER.md` | 17-track primary dossier (P1–P22 primitives) |
| `NOTAS_AGENTES_ACADEMIA.md` | Academic agent research |
| `NOTAS_AUDITORIA_DOSSIER.md` | Dossier self-audit |
| `NOTAS_COMERCIAL_ECONOMIA.md` | Commercial/economic notes |
| `NOTAS_CONTROL_SEGURIDAD.md` | Control/security notes |
| `NOTAS_RECONSTRUCCION_REPOSITORIO.md` | Repo reconstruction |
| `NOTAS_SISTEMAS_CLASICOS.md` | Classic systems analogies |

### SAGR Research — Second Pass (Claude Sonnet 4.6, 28 files)
`CLAUDE_SECOND_PASS/`: files 00–20 (new research) + 31–38 (meta-audit). Includes: inventory, GPT claims audit, GPT sources audit, coverage audit, gaps, errors/corrections, independent search, new equivalences, new primitives, new hypotheses, GPT-vs-Claude contradictions, problem reconstruction, model reconstruction, architecture reconstruction, security re-audit, economic re-audit, novelty re-audit, saturation re-audit, final verdicts, consolidated version, final synthesis, evidence graph, search log, coverage matrix, adversarial audit, consistency audit, definitions dictionary, saturation certificate, master audit.

### Final Reconciliation (Claude Opus 4.7, 14 numbered files + 2 prompts)
Documents 39–52. Reconciliation, unique findings, contradiction resolution, residual problem, proposal candidate, architectural impact, implementation decision, final reconciliation, prior art verification, R-2 instrumentation, R-2 audit, R-3 design, R-3 audit, Roger hypothesis audit, plus R2/R3 execution prompts.

### Research Consolidation
| File | Volume |
|---|---|
| `CCP_RESEARCH_CONTEXT_MASTER.md` (Corpus B) | 306 lines |
| `CCP_RESEARCH_CONTEXT_MASTERC.md` (Corpus A) | ~1,915 lines, 80 sources |

---

## 11. Research Passes

**[DOCUMENTED FACT — SOURCE: `39_CONCILIACION.md §1`, `CCP_RESEARCH_CONTEXT_MASTERC.md §03`]**

### Pass 1 — ChatGPT/Web Corpus (Corpus A)
- **Executor:** ChatGPT + Claude Web (multiple sessions)
- **Scope:** BROAD — intent→spec→obligations→assurance→authority→transition→effect→change→revalidation
- **Sources:** 80 (SRC-001..SRC-080; many without primary verification — flagged)
- **Hypotheses:** 25 CLOSED (CH-001..CH-025), 9 SURVIVING (SH-001..SH-009), 24 CLAIMS audited
- **Key findings:** 8 assurance levels, 4 recovery operations (REPLAY/ROLLBACK/FORK/COMPENSATE), assurance impact propagation as frontier
- **Limitation:** HEAD stale by 3 commits; meta-audit stated pending but already executed by Corpus B

### Pass 2 — Claude/Cowork Corpus (Corpus B)
- **Executor:** Claude Sonnet 4.6 + GPT-5.6 Luna (dossier)
- **Scope:** NARROW — SAGR/policy-aware alternative generation/non_bypass_verify for open-ended agents
- **Web searches:** 10 primary; 10/10 claims confirmed or corrected
- **Corrections applied:** 5 (C-01 to C-05)
- **Key reformulation:** SAGR ≠ recovery; SAGR = governance of continuation
- **Saturation certificate:** desk research declared saturated (37_CERTIFICADO_DE_SATURACION.md)
- **Limitation:** Single-context anchoring risk; adversarial track by same model as positive synthesis
- **Cost finding:** GPT subagent delegation consumed budget rapidly — new rule: subagents only when genuinely independent

### Pass 3 — Final Reconciliation (Claude Opus 4.7)
- **Executor:** Claude Opus 4.7
- **Scope:** Two-corpus comparison, residual formulation, R-1 verification, R-2 design, R-3 design, Roger audit
- **Result:** 12 agreements, 5 reconcilable disagreements, 0 irreconcilable contradictions
- **Decision:** REQUIRES REPRODUCTION + FIELD VALIDATION. F10 NOT OPENED.

---

## 12. Research Questions

**[SOURCE: `CCP_RESEARCH_CONTEXT_MASTER.md §7`, `42_PROBLEMA_RESIDUAL.md`, `46_FINAL_RECONCILIATION.md §K`]**

| ID | Question | Answer | Status |
|---|---|---|---|
| RQ-01 | Can agent claim DONE without evidence? | YES — enforced by F2 hook | CLOSED |
| RQ-02 | Is evidence-gated completion unique to CCP? | NO — AIGIS reproduces it verbatim | CLOSED: NOT SUPPORTED |
| RQ-03 | Does CCP have standalone commercial market? | NOT SUPPORTED — Round 0 | CLOSED: NOT SUPPORTED |
| RQ-04 | Is SAGR as recovery novel? | NO — Temporal/DBOS/LangGraph cover crash recovery | KILLED |
| RQ-05 | Is SAGR as governance of continuation novel? | PARTIALLY — structured covered; open-ended open | PARTIALLY SUPPORTED |
| RQ-06 | Does generate_alternative exist for open-ended agents? | NOT FOUND (provisional) | SUPPORTED PROVISIONAL |
| RQ-07 | Does non_bypass_verify exist as a primitive? | NOT FOUND as implementation; formalized in paper | PARTIALLY SUPPORTED |
| RQ-08 | How frequent is STALL_POLICY in CCP? | UNKNOWN — requires 30-day field observation | H-01: OPEN |
| RQ-09 | Do 4 prior art candidates close the residual? | NO — all 4 verified, none close the gap | CLOSED: gap survives |
| RQ-10 | Is non_bypass_verify designable with falsifiers? | YES — R-3 design exists | DESIGN ONLY |
| RQ-11 | Is Roger hypothesis a new capability? | NO — INDETERMINED; tendency REFORMULATION | INDETERMINED |
| RQ-12 | Is F9 justified? | NO — no candidate survived all 4 gates | CLOSED: NOT JUSTIFIED |
| RQ-13 | Is incident→control→regression unique vs. AIGIS? | YES — AIGIS lacks it | PARTIALLY SUPPORTED |
| RQ-14 | Does durable execution solve semantic recovery? | NO — LLM re-execution produces different semantics | KILLED |
| RQ-15 | What unknowns cannot be resolved by desk research? | H-01..H-04 | OPEN (requires field data) |

---

## 13. Reference Catalog

**[SOURCE: `CCP_SAGR_RESEARCH_DOSSIER.md`, `CCP_RESEARCH_CONTEXT_MASTER.md`, `47_PRIOR_ART_VERIFICATION.md`, `39_CONCILIACION.md`]**

| ID | Reference | Type | Status |
|---|---|---|---|
| REF-01 | Temporal | Framework | STUDIED — crash recovery ≠ semantic recovery |
| REF-02 | DBOS | Framework | STUDIED — same as REF-01 |
| REF-03 | LangGraph | Framework | STUDIED — closed prior art |
| REF-04 | OSGuard (arXiv:2606.15034) | Paper | STUDIED — description corrected (C-01) |
| REF-05 | Recoverability (arXiv:2609.13672) | Paper | STUDIED — formalizes classification, no generator |
| REF-06 | RIR (arXiv:2609.18304) | Paper | STUDIED — false precision corrected (C-03) |
| REF-07 | AgentRewind (arXiv:2608.14380) | Paper | STUDIED — partial side-effect prior art (C-04) |
| REF-08 | PolicyGuide (arXiv:2608.19861) | Paper | STUDIED — narrows gap to open-ended |
| REF-09 | SafeAgent (arXiv:2604.17562) | Paper | STUDIED — same as REF-08 |
| REF-10 | State-Aware Runtime (Cambridge) | Research Agenda | VERIFIED R-1 — agenda only, not implementation |
| REF-11 | Verification-Gated Mission-State (arXiv:2606.31339) | Paper | VERIFIED R-1 — structured domain only |
| REF-12 | ae-framework (itdojp) | OSS | VERIFIED R-1 — dry-run only, no alternative gen |
| REF-13 | VERITAS OS (veritasfuji-japan) | OSS | VERIFIED R-1 — beta, terminal refusal only |
| REF-14 | AIGIS (cd-aguilar) | OSS | VERIFIED LIVE — 234 tests, deeper than CCP evidence gate |
| REF-15 | Living AI (PyPI) | OSS | STUDIED — partial checkpoint/side-effect prior art |
| REF-16 | Replay Agent Recorder | OSS | STUDIED — partial side-effect prior art |
| REF-17 | Assurance Closure (arXiv:2608.07317) | Paper | STUDIED — concept, no published implementation |
| REF-18 | Irreversibility Budget (arXiv:2609.00275) | Paper | STUDIED — partial prior art P11 |
| REF-19 | BAGEN | Product | STUDIED — partial prior art P11 |
| REF-20 | ACS (May 2026 draft) | Standard | STUDIED — adoption unknown |
| REF-21 | ReflectiChain (MDPI 2026) | Paper | STUDIED — prior art P16 |
| REF-22 | TMS/ATMS (Doyle/de Kleer) | Classic System | STUDIED — conceptual prior art for invalidation |
| REF-23 | Microsoft Agent 365 | Product | STUDIED — market context |
| REF-24 | Salesforce Agent Fabric | Product | STUDIED — market context |
| REF-25 | Boomi Agent Control Plane | Product | STUDIED — market context |
| REF-26 | GitHub Enterprise AI Controls | Product | STUDIED — market context |
| REF-27 | TrueFoundry | Product | STUDIED — market context |
| REF-28 | Zenity | Product | STUDIED — market context |
| REF-29 | RSGA (RE 2026) | Paper | STUDIED — start-time specification only |
| REF-30 | RECODE (RE 2026) | Paper | STUDIED — incident→requirement analog |
| REF-31 | PCAA | Research | STUDIED — Corpus A authority binding |
| REF-32 | CAVA | Research | STUDIED — Corpus A action attestation |
| REF-33 | loopless (PyPI) | OSS | STUDIED — closed prior art (P3) |
| REF-34 | CONTINUUM (Cyrax321) | OSS | STUDIED — semantic continuity prior art |

---

## 14. Reference-by-Reference Deep Dossiers

### REF-04 — OSGuard
- **SOURCE:** arXiv:2606.15034v1. Corpus B primary verification.
- **What it actually does:** Policy block → model feedback → revise action → re-check → 2 retry limit. Reactive, not generative.
- **Historical claim (dossier):** "fixed retry budget / hard stop only"
- **Correction C-01:** Mechanism includes feedback loop; does not generate new alternatives.
- **What CCP was looking for:** Policy block classification + recovery.
- **CCP adaptation:** NONE. Conceptually relevant to SAGR P5.

### REF-05 — Recoverability as a System Primitive
- **SOURCE:** arXiv:2609.13672v1. Corpus B primary verification.
- **What it actually does:** Formalizes HARD STOP vs. RECOVERABLE STOP. Defines recovery point selection by evidence and decision.
- **Historical claim:** "no formal HARD/RECOVERABLE classification exists."
- **Correction C-02:** Classification framework exists. Does NOT implement a generator.
- **CCP adaptation:** NONE implemented. Aligns with SAGR P5 conceptually.

### REF-06 — RIR
- **SOURCE:** arXiv:2609.18304 (v1 used; v2 dated 2026-09-17 not reviewed by dossier).
- **Historical claim:** "RIR covers 60–70% of SAGR composition."
- **Correction C-03:** No rubric, no denominator — false precision. v2 existed and was not considered.
- **CCP adaptation:** NONE. Corrected claim: "substantive overlap; exact scope not quantifiable."

### REF-07 — AgentRewind
- **SOURCE:** arXiv:2608.14380. Corpus B.
- **Historical claim:** Side-effect continuity is "field empty."
- **Correction C-04:** Living AI, Replay Agent Recorder, AgentRewind show partial implementations exist.
- **CCP adaptation:** NONE. Weakened "side-effect vacuum" claim.

### REF-08 / REF-09 — PolicyGuide / SafeAgent
- **SOURCE:** arXiv:2608.19861 / arXiv:2604.17562. Corpus B.
- **Historical claim (C-05):** "generate_alternative is the only gap that nobody has implemented."
- **Correction:** PolicyGuide and SafeAgent implement alternative generation for **structured workflows**. Gap narrows to open-ended agents only.
- **CCP adaptation:** NONE. The corrected claim refines the residual problem scope.

### REF-10 — State-Aware Runtime (Cambridge)
- **R-1 verification:** Research agenda only. No implementation. Components listed in Corpus A are what the paper *proposes to study*, not what exists.
- **Consequence:** MASTERC CH-024 over-claimed. Trajectory governance remains partially open conceptually.
- **CCP gap closure:** NO.

### REF-11 — Verification-Gated Mission-State
- **R-1 verification:** Does generate alternatives + verify. But: industrial multi-robot, pre-defined task forest. Not applicable to open-ended.
- **CCP gap closure:** NO for open-ended.

### REF-12 — ae-framework
- **R-1 verification:** Closest positioning competitor. No alternative generation; no non-bypass verify; dry-run only.
- **CCP gap closure:** NO.

### REF-13 — VERITAS OS
- **R-1 verification:** Beta, terminal refusal only. No alternative generation.
- **CCP gap closure:** NO.

### REF-14 — AIGIS
- **Live teardown:** 234 tests (223/10/1). Typed immutable TaskContract; per-artifact SHA-256; formal decision engine (6-boolean formula); ToolRequest policy engine; Docker sandbox; circuit breakers; 5-item security suite.
- **What CCP does that AIGIS does not:** Incident→control→regression loop; phase-gate discipline; historical preservation of governance artifacts; reviewer identity convention.
- **Classification:** AIGIS is architecturally deeper on the evidence gate. CCP is richer on learning loop and governance history.

---

## 15. Academic Research Map

**[SOURCE: `CCP_SAGR_RESEARCH_DOSSIER.md §4`, `CLAUDE_SECOND_PASS/06_BUSQUEDA_INDEPENDIENTE.md`]**

### Fully Closed Families (do not re-investigate)
Loop detection, checkpoint/rollback, subagent delegation, context compaction, state fingerprinting, event sourcing, belief-state management, memory governance, trajectory governance (as concept), continuous assurance (as concept), authority binding, durable execution as semantic recovery.

### Partially Covered (relevant to residual)
- Alternative generation: PolicyGuide/SafeAgent cover structured; **open-ended remains open**
- Non-bypass verification: formalized in Recoverability paper; **not implemented as primitive**
- Side-effect continuity: Living AI, AgentRewind exist; **full guarantee not demonstrated**
- Assurance impact propagation (TMS/ATMS prior art): **not as integrated agent system**
- Specification adequacy lifecycle: RSGA covers start-time; **lifecycle gap remains**

### September 2026 Academic Cluster
Four independent groups published papers on governed agent recovery in September 2026:
- Recoverability as a System Primitive (arXiv:2609.13672)
- RIR (arXiv:2609.18304)
- AgentRewind (arXiv:2608.14380)
- State-Aware Runtime (Cambridge)

This convergence is a signal that the field is reaching the problem from multiple directions simultaneously. [INFERENCE — SOURCE: `20_CLAUDE_FINAL_SYNTHESIS.md`]

---

## 16. Industry / Product Research Map

**[SOURCE: `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md`, `AIGIS_TEARDOWN.md`]**

### Market Context (2025–2026, classified EXTERNAL FACT/PROJECTION)
- 84% of developers use or plan to use AI tools (Stack Overflow 2025, n=49K)
- 51% of professional developers use AI daily
- Claude Code adoption: 18% of developers (JetBrains Jan-2026); CSAT 91%, NPS 54
- AI coding market growing rapidly; agent governance is an emerging need

### Commercial Competitors
| Product | Positioning | Comparison to CCP |
|---|---|---|
| AIGIS | Evidence-gated coding agent control plane | Deeper evidence gate; lacks learning loop |
| ae-framework | Agent-neutral assurance for SDLC | Closest positioning; dry-run only |
| Microsoft Agent 365 | Enterprise agent governance | Enterprise scale; different buyer |
| GitHub Enterprise AI Controls | Code agent governance | Embedded distribution; different scope |
| Zenity | Enterprise AI security | Security posture; different buyer |

### Commercial Thesis
**NOT SUPPORTED** for standalone commercial product. Round 0: 0 interviews, 0 WTP, 0 pilot, 0 identified buyers. Category is not empty. Enterprise vendors are already building governance solutions.

---

## 17. Systems / Frameworks / Patterns Map

**[SOURCE: `CCP_SAGR_RESEARCH_DOSSIER.md`, `NOTAS_SISTEMAS_CLASICOS.md`, `CCP_RESEARCH_CONTEXT_MASTERC.md §13`]**

### Classic Systems with Analogues to CCP Problems
| System | Domain | Analogue to CCP | CCP adoption |
|---|---|---|---|
| TMS/ATMS (Doyle 1979 / de Kleer 1986) | Dependency-based belief revision | Assurance impact propagation; selective invalidation | CONCEPTUAL ONLY — no runtime adoption |
| Event sourcing (CQRS) | Distributed systems | Append-only registries; evidence as event log | INSPIRED — CCP uses append-only Markdown registries |
| Circuit breakers (Hystrix pattern) | Microservices | max_iterations, max_tool_calls | ANALOG — AIGIS implements; CCP does NOT yet |
| Dead-letter queues | Message systems | HARD STOP preservation | ANALOG — CCP uses EVIDENCE_REGISTRY for dead paths |
| Transactional outbox | Distributed data | Side-effect ledger concept | ANALOG — identified in P20; NOT implemented |
| Version-control (git) | Software engineering | Append-only history; reversibility | DIRECTLY USED — git as trust boundary |
| Savepoint (SQL) | Database transactions | Checkpoint + recovery | ANALOG — Temporal/LangGraph implement this; CCP does NOT |
| Negative cache / transposition table | Game search | Failed path memory (P14) | ANALOG — STUDIED; not adopted |

### Patterns Adopted in CCP
| Pattern | CCP implementation | Evidence |
|---|---|---|
| Fail-closed default | bash-firewall + task-completed-evidence exit 2 | EV-015, EV-016 |
| Append-only log | EVIDENCE_REGISTRY, INCIDENT_REGISTRY, CONTROL_REGISTRY | F4 design |
| Phase gate | /gate, /cerrar-fase, evidence-before-close | ARCH-001..ARCH-004 |
| Role-based context injection | SubagentStart + context packs | ARCH-002, EV-001 |
| Single source of truth | PROJECT_STATE (one file owns each state type) | DESIGN.md §1 |
| Incident→control→regression | INC-001 → CTRL-001 → REG-001 | EV-006 |

### Patterns Studied and NOT Adopted
- MCTS/LATS bounded branch exploration (P8) — no implementation authorized
- Recovery budget separate from task budget (P11) — gap identified, not addressed
- Policy-gap analyzer (P18) — SAGR concept, not implemented
- Second-order recovery governor (P19) — identified as gap, not addressed

---

## 18. Idea Catalog

**[SOURCE: `CCP_SAGR_RESEARCH_DOSSIER.md §4 P1–P22`, `CCP_RESEARCH_CONTEXT_MASTERC.md §08–§12`, `42_PROBLEMA_RESIDUAL.md`]**

This catalog covers all ideas that shaped the project, whether they were implemented, designed, or rejected.

### Group A — Evidence and Completion (Core CCP)
| Idea | Status | Where |
|---|---|---|
| Evidence-gated completion | [IMPLEMENTED] | task-completed-evidence.sh, F2 |
| Contract hash binding | [IMPLEMENTED] | F8-A, ARCH-004 addendum |
| Risk-aware reviewer requirement | [IMPLEMENTED] | Evidence schema, F2 |
| Evidence freshness check | [IMPLEMENTED] | evals/maintenance.sh, F7 Bundle C |
| Incident→control→regression loop | [IMPLEMENTED] | INC-001, CONTROL_REGISTRY, REGRESSION_REGISTRY |
| VERIFIED status before DONE | [IMPLEMENTED] | Evidence schema, hook |

### Group B — Security and Firewall
| Idea | Status | Where |
|---|---|---|
| Bash pattern firewall (fail-closed) | [IMPLEMENTED] | bash-firewall.sh, F7/F8 |
| Secret detection on write/edit | [IMPLEMENTED] | secret-guard.sh |
| JSON input validation before shell execution | [IMPLEMENTED] | F8-B |
| GuardFall class false positive problem | [DOCUMENTED FACT — NOT FIXED] | A-05 deferred per F9-D02=B |
| Structured ToolRequest policy engine | [NOT IMPLEMENTED] | AIGIS has this; CCP does not |
| Sandbox layer | [NOT IMPLEMENTED] | AIGIS has Docker sandbox; CCP has none |

### Group C — Context and State
| Idea | Status | Where |
|---|---|---|
| Context pack injection by role | [IMPLEMENTED] | subagent-context.sh, ARCH-002 |
| Single source of truth per state type | [IMPLEMENTED] | PROJECT_STATE, DECISION_REGISTRY, etc. |
| Mirror with conflict detection | [IMPLEMENTED] | CURRENT_STATE.md as derived mirror |
| State hash on PreCompact | [IMPLEMENTED] | pre-compact-snapshot.sh |
| Session log with daily rotation | [IMPLEMENTED] | stop-logger.sh, F7 Bundle D |

### Group D — SAGR / Governance of Continuation
| Idea | Status | Where |
|---|---|---|
| SAGR as "recovery" | [REFUTED] | Research pass 1+2, reconciliation |
| SAGR as "governance of continuation" | [DESIGN / PARTIALLY SUPPORTED] | CCP_RESEARCH_CONTEXT_MASTER.md §3 |
| Control-induced stall classification (P5) | [DESIGN — R-3 related] | 42_PROBLEMA_RESIDUAL.md |
| STALL_POLICY detection | [R-2 INSTRUMENTED — not field validated] | bash-firewall.sh, stall-record.sh |
| generate_alternative(S, O, P, A_blocked) | [OPEN PROBLEM — not implemented] | 42_PROBLEMA_RESIDUAL.md §4 |
| non_bypass_verify(A', A_blocked, P) | [DESIGN ONLY — R-3] | 50_R3_NON_BYPASS_VERIFY_DESIGN.md |
| Policy-gap analyzer (P18) | [HYPOTHESIS] | CCP_SAGR_RESEARCH_DOSSIER.md P18 |
| Recovery budget separate from task budget (P11) | [HYPOTHESIS] | CCP_SAGR_RESEARCH_DOSSIER.md P11 |
| Side-effect ledger across context boundary (P20) | [HYPOTHESIS] | CCP_SAGR_RESEARCH_DOSSIER.md P20 |

### Group E — Assurance (Corpus A)
| Idea | Status | Where |
|---|---|---|
| Assurance impact propagation (SH-001) | [HYPOTHESIS OPEN] | CCP_RESEARCH_CONTEXT_MASTERC.md SH-001 |
| Continuous assurance closure across intent-effect chain (SH-005) | [HYPOTHESIS OPEN] | Same |
| Specification adequacy lifecycle (SH-002 residual) | [HYPOTHESIS OPEN] | Same |
| Semantic continuity across execution boundaries (SH-006) | [HYPOTHESIS OPEN] | Same |
| Boundary completeness under open world (SH-003) | [HYPOTHESIS OPEN] | Same |

---

## 19. Idea → CCP Function Map

**[SOURCE: MASTER_IMPLEMENTATION_PLAN.md, EVIDENCE_REGISTRY.md, hooks/]**

| Idea | CCP Function | File | Phase |
|---|---|---|---|
| Agent cannot claim DONE without evidence | Evidence gate (fail-closed) | task-completed-evidence.sh | F2 |
| Contract hash prevents stale evidence binding | contract_hash required | task-completed-evidence.sh F8-A | F8 |
| Destructive commands must be blocked | Bash pattern firewall | bash-firewall.sh | F1, F7, F8 |
| Secrets must never enter code | Secret detection on write | secret-guard.sh | F1 |
| Agent context must be role-appropriate | Role-based context injection | subagent-context.sh | F1 |
| Installation must be idempotent | Installer with --force | install.sh F7 Bundle E | F7 |
| Evidence must not go stale | Freshness check in CI | evals/maintenance.sh F7 | F7 |
| Incident must produce regression | INC→CTRL→REG loop | INCIDENT_REGISTRY + evals/ | F4 |
| State must be hashed before compaction | PreCompact snapshot | pre-compact-snapshot.sh | F5 |
| Session logging must not loop | stop_hook_active guard | stop-logger.sh F7 Bundle A | F7 |
| STALL_POLICY must be observable | Observation events | stall-record.sh, R-2 | Post-F8 (R-2) |
| non_bypass_verify must be falsifiable | Formal design + test protocol | 50_R3_NON_BYPASS_VERIFY_DESIGN.md | Post-F8 (R-3) |

---

## 20. Idea → Architecture Map

**[SOURCE: docs/DESIGN.md, MASTER_IMPLEMENTATION_PLAN.md §2]**

```
EVIDENCE GATE
  │
  ├── Architectural role: L5 enforcement — fail-closed gate at TaskCompleted
  ├── Component: task-completed-evidence.sh
  ├── File: .claude/hooks/task-completed-evidence.sh
  ├── Decision: ARCH-003 (canonical evidence path), ARCH-004 (contract_hash)
  └── Status: IMPLEMENTED / FROZEN

BASH FIREWALL
  │
  ├── Architectural role: L5 security — prevent destructive commands
  ├── Component: bash-firewall.sh
  ├── File: .claude/hooks/bash-firewall.sh
  ├── Decision: F7 Bundle B, F8-B
  └── Status: IMPLEMENTED / FROZEN (known GuardFall class vulnerability deferred)

INCIDENT LEARNING LOOP
  │
  ├── Architectural role: L4 self-improvement — operational learning
  ├── Components: INC-001 → CTRL-001 → REG-001; INCIDENT/CONTROL/REGRESSION registries
  ├── Files: INCIDENT_REGISTRY.md, CONTROL_REGISTRY.md, REGRESSION_REGISTRY.md
  ├── Decision: F4 phase gate
  └── Status: IMPLEMENTED / 1 canonical example (INC-001)

CONTEXT PACK SYSTEM
  │
  ├── Architectural role: L1 guidance — role-appropriate situational awareness
  ├── Components: 6 context packs (CORE, CURRENT_STATE, DECISIONS, SECURITY_RULES, BUSINESS, NO_GO)
  ├── Files: .claude/context/*.md (also as skills)
  ├── Decision: ARCH-002 (SubagentStart injection)
  └── Status: IMPLEMENTED

STALL OBSERVATION (R-2)
  │
  ├── Architectural role: L4 measurement — frequency of STALL_POLICY events
  ├── Component: stall-record.sh helper; STALL_POLICY_LOG.jsonl
  ├── Files: .claude/hooks/lib/stall-record.sh, docs/00_SYSTEM/STALL_POLICY_LOG.jsonl
  ├── Decision: R-2 authorization (post-reconciliation)
  └── Status: IMPLEMENTED (instrumentation only; log empty; no field data yet)

NON_BYPASS_VERIFY DESIGN (R-3)
  │
  ├── Architectural role: (future) L5 policy-compliance gate for alternatives
  ├── Component: formal design only
  ├── File: docs/research/CCP_FINAL_RECONCILIATION/50_R3_NON_BYPASS_VERIFY_DESIGN.md
  ├── Decision: R-3 authorized as design+falsifiability only
  └── Status: DESIGN ONLY — NOT IMPLEMENTED — NOT PRODUCTION-READY
```

---

## 21. Idea → Implementation Lineage

**[SOURCE: MASTER_IMPLEMENTATION_PLAN.md, EVIDENCE_REGISTRY.md, git log]**

### Full lineage: Evidence-Gated Completion

```
ORIGINAL PROBLEM
  Agent can claim DONE without verified evidence
  ↓
IDEA
  Evidence contract as gate — agent cannot complete without satisfying a
  structured, verifiable evidence contract
  ↓
RESEARCH / REFERENCE
  Both CCP and AIGIS independently arrived at this pattern
  ↓
DECISION
  P0.2 in pre-F1 audit; F2 formalized schema; F8-A made contract_hash mandatory
  ↓
IMPLEMENTATION
  task-completed-evidence.sh
  ↓
TEST
  Smoke matrix: missing task, invalid risk, malformed JSON, stale PROPOSED,
  missing reviewer, unapproved exception; all BLOCK.
  ↓
EVIDENCE
  EV-002 (F2), EV-015 (F8-A)
  ↓
AUDIT
  F8 independent fresh review: PASS
  POST_F8_AUDIT_REPORT.md
  ↓
CURRENT STATUS
  [IMPLEMENTED / FROZEN] at commit 2cd7953
```

### Full lineage: Incident Learning Loop

```
ORIGINAL PROBLEM
  A completion payload could be accepted without task-specific verified evidence
  ↓
IDEA
  Incident creates hidden assumption → explicit requirement → control → regression
  ↓
RESEARCH
  Pattern inspired by Requirements Engineering (Cleland-Huang, RECODE)
  ↓
DECISION
  F4 phase gate: incident must produce regression before closing
  ↓
IMPLEMENTATION
  INC-001 → CTRL-001 → REG-001; three registries created
  ↓
TEST
  evals/incidents/INC-001-task-completed-evidence.sh
  ↓
EVIDENCE
  EV-006 (F4)
  ↓
AUDIT
  maintenance.sh INC-001 check: PASS
  ↓
CURRENT STATUS
  [IMPLEMENTED] — 1 canonical incident; learning loop operational
```

### Full lineage: bash-firewall

```
ORIGINAL PROBLEM
  Destructive shell commands (rm -rf, git reset --hard, etc.) accessible to agent
  ↓
IDEA
  Block destructive patterns before execution via PreToolUse hook
  ↓
REFERENCE
  GuardFall incident: substring match on 'rm -rf ' has false-positive class
  ↓
DECISION
  F7 Bundle B: case-tolerant, covers .env read variants
  F8-B: blocks malformed JSON/empty/whitespace/NUL before extraction
  ↓
IMPLEMENTATION
  bash-firewall.sh
  ↓
TEST
  firewall-positive.sh; adversarial variants
  ↓
EVIDENCE
  EV-009 (F7 Bundle B), EV-016 (F8-B)
  ↓
AUDIT
  POST_F8_AUDIT_REPORT.md; maintenance PASS
  ↓
CURRENT STATUS
  [IMPLEMENTED / FROZEN] — GuardFall class deferred per F9-D02=B
```

---

## 22. Non-Implemented Idea Lineage

**[SOURCE: `46_FINAL_RECONCILIATION.md §T`, `42_PROBLEMA_RESIDUAL.md`, `F9_RESEARCH.md`]**

### SAGR as Primary Architecture

```
IDEA
  SAGR — State-Aware Governed Recovery — as the root architecture for CCP continuation
  ↓
WHY CONSIDERED
  Dossier identified SAGR as the next major evolution of CCP post-F8;
  owner observed research process itself cycling through stall patterns
  ↓
RESEARCH
  17-track dossier; 22 primitives identified; all primitives have prior art
  ↓
COUNTERARGUMENT
  Recovery as category: Temporal/DBOS/LangGraph fully cover it.
  SAGR primitives decompose to existing components.
  ↓
DECISION
  SAGR as standalone architecture: NOT JUSTIFIED. SAGR as "governance of
  continuation" has residual open problem but requires field validation.
  ↓
WHY NOT IMPLEMENTED
  No field evidence of STALL_POLICY frequency; no implemented non_bypass_verify;
  4 F9 gates not passed simultaneously.
  ↓
CURRENT STATUS
  [NOT AUTHORIZED] — concept partially supported; implementation blocked
```

### Recovery Engine

```
IDEA
  A dedicated recovery engine that detects stalls and orchestrates recovery
  ↓
WHY CONSIDERED
  P3 (loop detector), P4 (checkpoint), P5 (classifier), P6 (planner) composed
  ↓
RESEARCH
  All individual components have prior art (loopless, Temporal, OSGuard, RIR)
  ↓
COUNTERARGUMENT
  As "recovery" the space is commoditized.
  ↓
DECISION
  F9 NOT JUSTIFIED. No new recovery engine authorized.
  ↓
CURRENT STATUS
  [NOT AUTHORIZED]
```

### F9 Implementation (Native Claude Code Integration)

```
IDEA
  F9 would address gaps in native Claude Code lifecycle (G-B6, G-B10, G-B11)
  ↓
WHY CONSIDERED
  F7-F12 research handoff identified unverified native behavior
  ↓
RESEARCH
  F9 research (GPT-5.6 Luna/OpenCode): no candidate simultaneously passed
  4 gates (sufficient impact + insufficient control + proportional benefit + reversible scope)
  ↓
COUNTERARGUMENT
  NOT_VERIFIED ≠ BROKEN. Native verification deferred pending concrete trigger.
  ↓
DECISION
  F9 NOT JUSTIFIED
  ↓
WHY NOT IMPLEMENTED
  No concrete trigger (G-B11 deterministic recurrence, tool failure confirmed,
  native integration decision, or reproducible problem).
  ↓
CURRENT STATUS
  [NOT AUTHORIZED] — deferred per F9-D02=B until concrete trigger
```

### Circuit Breakers

```
IDEA
  max_iterations, max_runtime_seconds, max_tool_calls per task
  ↓
WHY CONSIDERED
  AIGIS has this; real incident corpus includes $47K LangChain loop, $16–50K Claude recursion
  ↓
RESEARCH
  Multiple implementations exist (AIGIS, Claude Agent SDK, OpenAI Agents API, FutureAGI)
  ↓
COUNTERARGUMENT
  Not part of F1-F8 scope; no incident in CCP requiring it yet
  ↓
DECISION
  Out of scope for current plan
  ↓
CURRENT STATUS
  [NOT IMPLEMENTED] — AIGIS has it; CCP does not. Gap acknowledged.
```

### Assurance Impact Propagation (SH-001)

```
IDEA
  When a dependency changes, propagate the invalidity to all assurance claims that depend on it.
  Selective invalidation of evidence downstream of a changed component.
  ↓
WHY CONSIDERED
  TMS/ATMS conceptual prior art; continuous assurance literature; build systems (incremental rebuild)
  ↓
RESEARCH
  Prior art: TMS (Doyle 1979), ATMS (de Kleer 1986), Matrix paper, build systems.
  None as integrated system running for agents.
  ↓
DECISION
  HYPOTHESIS OPEN — not ready for implementation
  ↓
CURRENT STATUS
  [HYPOTHESIS] — requires design + field validation before any F10
```

---

## 23. Refuted Ideas

**[SOURCE: `46_FINAL_RECONCILIATION.md §H`, `39_CONCILIACION.md §3`]**

For each refuted idea: original claim, what killed it, what replaced it.

| ID | Original idea | Original assumption | What killed it | What replaced it |
|---|---|---|---|---|
| CH-001 | Loop detection is novel for agents | No existing loop detector | Multiple OSS tools (loopless, FutureAGI, IAL-Scan, LangGraph) | CLOSED — not re-investigate |
| CH-002/3 | Checkpoint/rollback is novel | No reliable checkpoint for agents | Temporal, DBOS, LangGraph, livingai all implement it in production | CLOSED |
| CH-004 | Recovery as category is novel | No structured agent recovery framework | Entire ecosystem of recovery tools (same above) | CLOSED |
| CH-010 | Evidence-gated completion is unique to CCP | No competitor does this | AIGIS teardown (verbatim concept match, deeper implementation) | Differentiators shifted to incident loop + phase discipline |
| CH-024 | Trajectory governance as CCP novelty | State-Aware Runtime v4 described as not covering it | R-1 verified: State-Aware Runtime is a research agenda only — CLOSED as "novel" because nobody implements it yet either | PARTIALLY RE-OPENED as "no one implements it" but CLOSED as CCP novelty claim |
| CH-025 | Durable execution = semantic recovery | Temporal/LangGraph "solve" the recovery problem | Both Corpus A and B: LLM re-execution produces different semantic output. Replay ≠ intention recovery | crash recovery ≠ intention recovery — fundamental distinction |
| SAGR v1 | SAGR is a recovery architecture | Recovery is the core problem for stuck agents | Recovery space is commoditized; Temporal/DBOS cover it | SAGR v2/v3: governance of continuation |
| H1 | Evidence-gated completion is unique | No competitor reproduces it | AIGIS reproduces it verbatim | H3 (incident loop) as surviving differentiator |
| H2 | CCP has commercial market as standalone | Problem exists + solution exists → market exists | No WTP, no buyers, no pilot identified — Round 0 | Internal tool value only confirmed |
| H5 | SAGR as recovery is novel | "Recovery" not adequately defined | Recovery fully covered by existing tools | Reformulation to governance of continuation |
| H9 | Durable execution resolves semantic recovery | Replay restores semantic intention | Temporal/DBOS explicitly document their replay re-executes LLM calls | Distinction: crash recovery ≠ semantic recovery |
| H10 | "3 cases in 4 weeks" justifies building SAGR | Owner's personal experience as valid baseline | No rubric, no denominator, no reproducible calculation | Replaced by formal instrumentation criteria (§7 of MASTER.md) |

---

## 24. Weakened Ideas

**[SOURCE: `39_CONCILIACION.md §3`, `CCP_RESEARCH_CONTEXT_MASTER.md §4`]**

Ideas that were not refuted entirely but whose original claim was shown to be too strong.

### Side-effect continuity is a field vacuum (C-04)
- **Original claim:** "No implementation exists for preserving side effects across recovery."
- **Evidence that weakened it:** Living AI (PyPI 0.4.1), Replay Agent Recorder (GitHub/Futuresis), AgentRewind (arXiv:2608.14380) all implement partial approaches.
- **Remaining valid part:** "Mature commercial guarantee of full side-effect continuity across all types of external effects does not exist." Partial implementations exist; complete solution does not.
- **Remaining uncertainty:** Whether Living AI / Replay Agent Recorder provide sufficient coverage for CCP's specific side-effect types.

### generate_alternative is uniquely missing (C-05)
- **Original claim:** "generate_alternative + non_bypass_verify are the only technical blockers that nobody has implemented."
- **Evidence that weakened it:** PolicyGuide (arXiv:2608.19861) and SafeAgent (arXiv:2604.17562) implement alternative generation for **structured workflows** with pre-compiled action graphs.
- **Remaining valid part:** For **open-ended agents** (coding, investigation, reasoning without pre-defined workflow), no public implementation exists.
- **Remaining uncertainty:** Whether State-Aware Runtime, VERITAS OS, or a future paper covers open-ended (none verified to date).

### OSGuard is "fixed retry / hard stop only" (C-01)
- **Original claim:** OSGuard only implements a fixed retry budget and then hard stops.
- **Evidence:** arXiv:2606.15034v1 shows: policy block → model feedback → action revision → re-check → 2 retries.
- **Remaining valid part:** OSGuard is reactive (feedback-driven revision), not generative (alternative synthesis from scratch). It does not generate a genuinely new policy-compliant action.
- **Remaining uncertainty:** Whether the feedback mechanism plus revision constitutes a weak form of alternative generation.

### Incident→control→regression loop is unique (H3)
- **Original claim:** This loop is unique to CCP (PARTIALLY SUPPORTED).
- **Evidence that weakened it:** Requirements Engineering (Cleland-Huang RE 2026, RECODE) covers this loop for human-driven software projects.
- **Remaining valid part:** Automation of this loop in a coding agent context remains less clear; CCP has it as a first-class runtime primitive.
- **Remaining uncertainty:** Whether AIGIS's test suite implicitly covers this; whether commercial tools have equivalent.

### State-Aware Runtime (Cambridge) closes trajectory governance (trajectory governance NOT novel)
- **Original MASTERC claim:** CH-024 "trajectory governance as novel: CLOSED because State-Aware Runtime v4 covers it."
- **Evidence:** R-1 verification shows State-Aware Runtime is a research agenda, not an implementation. CH-024 was over-closed.
- **Revised status:** Trajectory governance as a concept: no production implementation verified. As "CCP novelty": still not CCP's — because the research agenda acknowledges it as a known problem. Somewhere between CLOSED and OPEN.

---

## 25. Surviving Concepts

**[SOURCE: `46_FINAL_RECONCILIATION.md §SH`, `CCP_RESEARCH_CONTEXT_MASTER.md §H`]**

After killing 25 hypotheses (CH-001..CH-025), 9 hypotheses survived the reconciliation with varying confidence levels.

| ID | Claim | Confidence | Status |
|---|---|---|---|
| SH-001 | Assurance impact propagation is technically feasible and architecturally valuable | MEDIUM | [HYPOTHESIS] — requires design + field validation |
| SH-002 | Specification adequacy lifecycle is a real unsolved problem in requirements engineering for agent tasks | MEDIUM | [HYPOTHESIS OPEN] — related to R-3 residual |
| SH-003 | Boundary completeness under open world is unsolved for agents in open-ended environments | MEDIUM | [HYPOTHESIS OPEN] |
| SH-004 | CCP's phase gate + incident learning loop = operational continuity differentiator | HIGH (partial) | [PARTIALLY SUPPORTED] — AIGIS replicates evidence gate; incident loop confirmed unique |
| SH-005 | Continuous assurance closure requires integration across intent-effect chain, not point checks | MEDIUM | [HYPOTHESIS OPEN] |
| SH-006 | Semantic continuity across execution boundaries is unsolved at production scale | HIGH | [SUPPORTED] — Corpus A+B agree; Temporal/DBOS explicitly document replay ≠ semantic recovery |
| SH-007 | For open-ended agents, governance of continuation (not recovery) is the right framing | HIGH | [SUPPORTED] — consensus across both corpora |
| SH-008 | generate_alternative + non_bypass_verify for open-ended agents has no public implementation | HIGH (with caveat) | [SUPPORTED with R-1 verification] — caveat: structured-workflow implementations exist (arXiv:2606.31339, PolicyGuide) |
| SH-009 | The industry default (refuse + escalate) vs (propose alternative + verify) choice is architecturally significant and not yet resolved | MEDIUM | [OPEN] — R-3 must address this as hypothesis nula |

### Notes on Surviving vs. Refuted Divide

- The refuted cluster was primarily "this is novel": nearly all "novelty" claims died because the space is occupied.
- The surviving cluster is primarily "this specific variant for open-ended agents is unsolved": the narrower the claim, the more it survived.
- SH-004 partial: AIGIS co-existing makes CCP's primary claim (evidence gate uniqueness) false, but AIGIS's absence of incident loop + phase discipline means SH-004 partial claim survives.

---

## 26. SAGR Evolution

**[SOURCE: `CCP_SAGR_RESEARCH_DOSSIER.md §2`, `CCP_RESEARCH_CONTEXT_MASTER.md §1–§3`, `46_FINAL_RECONCILIATION.md §S`]**

SAGR went through three major conceptual versions.

### SAGR v1 — "Recovery" Frame (Original)
- **Meaning:** State-Aware Governed Recovery. When an agent stalls, detect the stall, classify it, select a recovery action, execute recovery, then return to main task.
- **Origin:** Owner's lived experience of 3 observation events in 4 weeks; classification schema drawn from Corpus A research.
- **Why it died:** "Recovery" as category is fully covered by Temporal/DBOS/LangGraph/livingai. The 22 SAGR primitives decompose to existing components. Corpus A and B consensus: commoditized.
- **Kill event:** CH-004 in final reconciliation; CH-001 through CH-004 (loop detect, checkpoint, rollback, recovery) all closed.

### SAGR v2 — "Governance of Continuation" (Reformulation)
- **Meaning:** Instead of "how do we recover?" ask "what can the blocked agent legitimately do next?" Focus shifts from recovery action selection to policy-compliance verification of alternatives.
- **Origin:** Research pass 2 (Claude Cowork); emerged from the question "what does SAGR do that Temporal doesn't?" Answer: Temporal handles crash recovery; SAGR would handle "agent blocked by a POLICY (not a crash), proposing an alternative, verifying the alternative doesn't bypass the policy's intent."
- **Status:** [DESIGN / PARTIALLY SUPPORTED]. Both corpora agree on framing. Two unresolved primitives remain.
- **What it introduced:** generate_alternative(S, O, P, A_blocked) and non_bypass_verify(A', A_blocked, P) as the two implementation unknowns.

### SAGR v3 — Field Validation Gate (Current)
- **Meaning:** Before implementing SAGR v2, establish empirical baseline: (1) What is the actual frequency of STALL_POLICY events? (2) Does non_bypass_verify need to handle real events or just theoretical ones?
- **Gate:** H-01 (frequency unknown), H-02 (N unknown), H-03 (classification type distribution unknown), H-04 (non_bypass_verify feasibility unresolved).
- **Actions authorized:** R-2 (instrument for frequency observation). R-3 (design non_bypass_verify with falsifiability protocol). No F10 authorized.
- **Status:** [INSTRUMENTED] — R-2 delivered; STALL_POLICY_LOG.jsonl operational but empty (no field data yet).

### SAGR Core Invariant (Preserved Across All Versions)
> **STALL ≠ PERMISSION TO BYPASS SAFETY**

This invariant is stated explicitly in every version, embedded in the R-2 security analysis ("LOGGING FAILURE != SECURITY BYPASS"), and mandated in the R-3 contract.

---

## 27. Primitive Map (22 SAGR Primitives)

**[SOURCE: `CCP_SAGR_RESEARCH_DOSSIER.md §4`, `CCP_RESEARCH_CONTEXT_MASTER.md §5`]**

| ID | Name | Prior art? | CCP adoption | Openness |
|---|---|---|---|---|
| P1 | Stall type taxonomy | PARTIAL (loopless, IAL-Scan cover subsets) | [DESIGN] — classification schema in R-2 event | CLOSED |
| P2 | State snapshot at stall | YES (Temporal, DBOS, LangGraph) | [NOT IMPLEMENTED] | CLOSED |
| P3 | Loop detector | YES (loopless, FutureAGI) | [NOT IMPLEMENTED] | CLOSED |
| P4 | Checkpoint/rollback | YES (Temporal, DBOS, livingai) | [NOT IMPLEMENTED] | CLOSED |
| P5 | Control-induced stall classifier | PARTIAL (OSGuard feedback-driven) | [DESIGN — R-3 scope] | PARTIALLY OPEN |
| P6 | Alternative action planner | PARTIAL (arXiv:2606.31339 structured; PolicyGuide structured) | [NOT IMPLEMENTED — open-ended gap] | OPEN |
| P7 | Policy constraint solver | PARTIAL (SAT solvers, formal verification) | [NOT IMPLEMENTED] | OPEN (open-ended specific) |
| P8 | MCTS-guided exploration (bounded) | YES (LATS, Dyna-Think) | [NOT IMPLEMENTED] | CLOSED |
| P9 | Failed path memory | PARTIAL (transposition tables) | [NOT IMPLEMENTED] | PARTIALLY OPEN |
| P10 | Stall broadcast to planner | NO direct prior art found | [NOT IMPLEMENTED] | OPEN |
| P11 | Separate recovery budget from task budget | PARTIAL (Temporal timeout) | [NOT IMPLEMENTED] | OPEN |
| P12 | Policy gap analyzer | NO direct prior art found | [NOT IMPLEMENTED] | OPEN |
| P13 | Permission-aware replanning | PARTIAL (OSGuard reactive replanning) | [NOT IMPLEMENTED] | PARTIALLY OPEN |
| P14 | Negative cache (failed path memory) | YES (transposition table in games) | [NOT IMPLEMENTED] | CLOSED |
| P15 | Execution trace alignment with stated intent | PARTIAL (PlanBench, STRIPS) | [NOT IMPLEMENTED] | PARTIALLY OPEN |
| P16 | Semantic equivalence verifier | NO direct prior art for LLM agents | [DESIGN — R-3 related] | OPEN |
| P17 | Non-bypass verification function | NO direct prior art for open-ended agents | [DESIGN ONLY — R-3] | OPEN |
| P18 | Policy gap detector | NO direct prior art found | [NOT IMPLEMENTED] | OPEN |
| P19 | Second-order recovery governor | NO direct prior art found | [NOT IMPLEMENTED] | OPEN |
| P20 | Side-effect ledger across context boundaries | PARTIAL (transactional outbox, livingai) | [NOT IMPLEMENTED] | PARTIALLY OPEN |
| P21 | Budget-aware agent introspection | PARTIAL (Claude Agent SDK, OpenAI Agents) | [NOT IMPLEMENTED] | CLOSED |
| P22 | Multi-agent stall coordination | NO direct prior art for open-ended multi-agent | [NOT IMPLEMENTED] | OPEN |

**Most open primitives:** P6, P7, P10, P11, P12, P16, P17, P18, P19, P22.
**Primitives in R-3 scope:** P5 (classifier), P16 (semantic equivalence), P17 (non-bypass verify).
**Primitives in R-2 scope:** P1 (taxonomy for event classification in JSONL schema).

---

## 28. Decision Ledger

**[SOURCE: `DECISION_REGISTRY.md`, `docs/MASTER_IMPLEMENTATION_PLAN.md §F0 pre-decisions`, `F9_OWNER_DECISIONS.md`]**

### Architectural Decisions (Active)
| ID | Decision | Phase | Status |
|---|---|---|---|
| ARCH-001 | Install CCP at project level, not global | Pre-F1 | ACTIVE |
| ARCH-002 | SubagentStart injects context packs by role; do NOT depend on `skills:` frontmatter | Pre-F1 | ACTIVE |
| ARCH-003 | Canonical evidence path = `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | Pre-F1 | ACTIVE |
| ARCH-004 | Task tracking: CONTRACTUAL/TODO/SUBTASK/RESEARCH NOTE distinct; CONTRACTUAL requires evidence | F2, F8-A | ACTIVE |

### F9 Owner Decisions (Gate Resolved)
| ID | Question | Answer | Implication |
|---|---|---|---|
| F9-D01 | Is STALL_POLICY_LOG.jsonl genuinely empty? | A: YES | No fabricated events authorized |
| F9-D02 | Should GuardFall false-positive be fixed now? | B: DEFER | GuardFall deferred until concrete trigger |
| F9-D03 | Should native lifecycle be investigated now? | B: DEFER | Deferred pending reproducible failure |
| F9-D04 | Should F10 architectural work begin? | B: NO | F10 NOT authorized |
| F9-D05 | Should R-2/R-3 proceed? | A: PROCEED | R-2 + R-3 authorized as design/instrumentation only |

### Implicitly Made Decisions (Pre-F1, undocumented but evidenced)
| Decision | Evidence | Phase |
|---|---|---|
| No sandbox layer (no Docker) | bash-firewall as only isolation | Pre-F1 |
| No circuit breakers (no max_iterations) | Absent from all hooks | Pre-F1 |
| Markdown as primary data format | All registries are Markdown | Pre-F1 |
| Git as versioning and trust boundary | Commit hashes in evidence | Pre-F1 |
| Fail-closed as default for P0 hooks | bash-firewall + evidence gate | F1–F2 |

---

## 29. Decision → Consequence Map

**[SOURCE: EVIDENCE_REGISTRY.md, POST_F8_AUDIT_REPORT.md, INCIDENT_REGISTRY.md, F9_RESEARCH.md]**

### ARCH-001 → Consequences
- **Positive:** CCP doesn't interfere with user's global Claude settings; can be gitignored per project.
- **Negative:** No protection on projects without CCP installed. No network effect from shared global installation.
- **Discovered impact:** Installing with `--force` was required for idempotency (F7 Bundle E).

### ARCH-002 → Consequences
- **Positive:** Context injection is explicit and auditable; each subagent gets role-appropriate context.
- **Negative:** If SubagentStart hook fails, subagents start with no context (fail-open for context).
- **Discovered impact:** `skills:` frontmatter mechanism is undefined behavior for runtime — ARCH-002 correctly avoided it.

### ARCH-003 → Consequences
- **Positive:** Single source of truth for evidence; all hooks point to same registry.
- **Negative:** `docs/00_SYSTEM/DECISION_REGISTRY.md` path listed in R-2 contract is incorrect (actual path: `DECISION_REGISTRY.md` at root). Known unknown in R-2 48_R2_INSTRUMENTATION.md §Known Unknowns.
- **Discovered impact:** Freshness check in evals/maintenance.sh can catch stale evidence.

### ARCH-004 → Consequences
- **Positive:** Prevents TODO-level tasks from polluting the evidence registry; CONTRACTUAL items rigorously tracked.
- **Negative:** F8-A addendum (contract_hash required) increases evidence schema complexity.
- **Discovered impact:** Pre-F8 evidence items lacked contract_hash; F8-A was needed to close the gap.

### FAIL-CLOSED DEFAULT → Consequences
- **Positive:** No completion bypass possible even with malformed input (F8-B).
- **Negative:** GuardFall class — false positives block legitimate commands containing destructive substrings (e.g., a test that tests `rm -rf` logic).
- **Known deferred:** F9-D02=B — GuardFall not fixed; deferred until concrete trigger.

### NO SANDBOX LAYER → Consequences
- **Positive:** Simpler installation; no Docker dependency; works in any environment.
- **Negative:** bash-firewall is the only isolation boundary; GuardFall class is unmitigated.
- **Comparison:** AIGIS has Docker sandbox; CCP explicitly does not. This is an acknowledged architectural tradeoff.

---

## 30. Contradiction Ledger

**[SOURCE: `39_CONCILIACION.md §3 Discrepancias`, `47_PRIOR_ART_VERIFICATION.md §6`]**

Contradictions between Corpus A (ChatGPT/web research) and Corpus B (Claude/cowork research), and between either corpus and verified reality.

| ID | Claim A | Claim B | Resolution |
|---|---|---|---|
| CON-001 | SAGR is a recovery architecture | SAGR = governance of continuation, not recovery | B correct. CH-004 killed. SAGR v2 adopted. |
| CON-002 | Evidence-gated completion is unique to CCP | AIGIS reproduces it verbatim and goes deeper | B correct (via AIGIS teardown). SH-004 now partial. |
| CON-003 | State-Aware Runtime v4 implements trajectory governance | State-Aware Runtime v4 is a research agenda only | Verified via R-1 primary source (Cambridge OE). A wrong. |
| CON-004 | ae-framework has live production deployments | ae-framework is dry-run only, zero live PRs | Verified via R-1 primary source (GitHub README). A wrong. |
| CON-005 | VERITAS OS has operational EFFECT_UNKNOWN | VERITAS OS is beta, fixture-backed PoC | Verified via R-1 primary source (GitHub README). A wrong. |
| CON-006 | "3 cases in 4 weeks" justifies SAGR urgency | No rubric, no denominator, no reproducible calculation | B correct. Replaced by formal instrumentation criteria. |
| CON-007 | STALL_POLICY frequency is material | STALL_POLICY frequency is unknown | B correct. H-01 is an open unknown. R-2 instruments it. |
| CON-008 | non_bypass_verify has no implementation | PolicyGuide + SafeAgent implement it for structured workflows | Partial. Both A and B missed the structured/open-ended distinction. Residual narrows to open-ended only. |
| CON-009 | Durable execution (Temporal) resolves semantic recovery | Replay re-executes LLM → different output → semantic recovery NOT solved | B correct. Both Temporal docs and SH-006 confirm replay ≠ semantic recovery. |
| CON-010 | Commercial SAGR market exists because problem + solution = market | No WTP, no buyers, no pilot from Round 0 | B correct. Commercial investigation (MASTERC §16) confirmed no market evidence. |

---

## 31. Correction Ledger

**[SOURCE: `39_CONCILIACION.md §Corrections`, `46_FINAL_RECONCILIATION.md §5-corrections`, `47_PRIOR_ART_VERIFICATION.md §6.2`]**

Five explicit corrections were applied at the reconciliation gate.

| ID | Original claim | Correction | Source |
|---|---|---|---|
| COR-001 | "State-Aware Runtime v4 has components X, Y, Z" (MASTERC over-citation) | State-Aware Runtime v4 = research agenda + conceptual taxonomy, NOT implementation. Components cited are what's proposed to study, not what's implemented. | R-1 primary WebFetch verification |
| COR-002 | ae-framework described as possible CCP prior art | ae-framework = dry-run only; zero live PRs; SDLC-specific pipelines, NOT open-ended agents | R-1 primary GitHub verification |
| COR-003 | CH-024 "trajectory governance as novel — CLOSED because State-Aware Runtime" | CH-024 must be partially re-opened. State-Aware Runtime doesn't close it; it only describes it as a known problem. Novel = concept documented as problem ≠ solved. | R-1 correction |
| COR-004 | CH-013 "runtime governance as category novel — CLOSED" | Generic runtime governance category: closed (occupied). Open-ended + policy-aware alternative generation: still open. Distinction required. | R-1 refinement |
| COR-005 | MASTERC §19 "ae-framework as prior art that closes CCP" | ae-framework is positioned similarly (agent assurance control plane) but does NOT implement generate_alternative or non_bypass_verify and does NOT handle open-ended agents. Competitor for positioning, not solver of residual. | R-1 |

---

## 32. Incident → Control → Regression Map

**[SOURCE: `INCIDENT_REGISTRY.md`, `CONTROL_REGISTRY.md`, `REGRESSION_REGISTRY.md`, `EVIDENCE_REGISTRY.md §EV-006`]**

### The Loop Mechanism
```
INCIDENT (INC-NNN)
  "Hidden assumption found during production operation"
  ↓
CONTROL (CTRL-NNN)
  "Explicit requirement written to prevent recurrence"
  ↓
REGRESSION TEST (REG-NNN)
  "Automated test that fails if the incident recurs"
  ↓
MAINTENANCE CHECK (evals/maintenance.sh)
  "Regularly run suite verifying regression still exists and passes"
```

### INC-001 (The Canonical Example)
| Layer | Entry | Content |
|---|---|---|
| INCIDENT | INC-001 | A completion payload was accepted without task-specific verified evidence |
| ROOT CAUSE | — | `task-completed-evidence.sh` did not exist pre-F2; agent could claim DONE |
| CONTROL | CTRL-001 | Explicit requirement: evidence contract with reviewer, risk, exceptions, verified status |
| REGRESSION | REG-001 | `evals/incidents/INC-001-task-completed-evidence.sh` — verifies hook exits 2 on invalid payload |
| MAINTENANCE | — | evals/maintenance.sh test #5 (incidents): runs INC-001 regression; PASS |

### Preventive Regressions (REG-002 through REG-010)
Ten additional regressions were created preventively during F4-F7 without a corresponding incident. These cover patterns that were audited and found to be latent risks.

| REG | Preventive | Coverage |
|---|---|---|
| REG-002 | Secret in code | Secret patterns blocked from write/edit |
| REG-003 | Missing reviewer | Evidence contract requires reviewer |
| REG-004 | Malformed JSON | Firewall blocks before extraction |
| REG-005 | Stale evidence | Freshness check in maintenance |
| REG-006 | Skipped evidence schema field | Required field check |
| REG-007 | Missing contract_hash | F8-A requirement |
| REG-008 | Loop prevention | stop_hook_active guard |
| REG-009 | Empty/NUL input | F8-B JSON validation |
| REG-010 | Installer idempotency | F7 Bundle E |

### Loop Properties
- **First-class primitive:** INC→CTRL→REG is a named, designed pattern in CCP — not an emergent practice.
- **Differentiator vs AIGIS:** AIGIS has a 234-test suite but lacks the incident learning loop as an architectural primitive. CCP's loop generates regressions from production observation; AIGIS's tests appear to have been written upfront.
- **Known limitation:** Only 1 canonical incident in 8 phases. Loop is operational but minimally exercised.

---

## 33. Implemented Function Catalog

**[SOURCE: `ARTIFACT_MANIFEST.md`, `EVIDENCE_REGISTRY.md`, `.claude/hooks/`, `.claude/skills/`]**

Complete catalog of every function that is implemented and verified in the current CCP runtime.

### P0 Hooks (Fail-Closed — Security Critical)
| Function | File | Evidence | Notes |
|---|---|---|---|
| Bash pattern firewall | `.claude/hooks/bash-firewall.sh` | EV-009 (F7), EV-016 (F8-B) | Blocks 20+ destructive/secret/supply-chain patterns |
| Evidence-gated completion | `.claude/hooks/task-completed-evidence.sh` | EV-002 (F2), EV-015 (F8-A) | Fail-closed; contract_hash required |
| Secret detection on write/edit | `.claude/hooks/secret-guard.sh` | EV-003 (F1) | Blocks API keys, tokens, private keys |

### P1 Hooks (Fail-Open — State Management)
| Function | File | Evidence | Notes |
|---|---|---|---|
| State injection on session start | `.claude/hooks/session-start-startup.sh` | EV-001 (F1) | Injects PROJECT_STATE into session |
| Post-compaction state recovery | `.claude/hooks/session-start-compact.sh` | EV-007 (F5) | Verifies STATE_INTEGRITY on resume |
| PreCompact state snapshot + hash | `.claude/hooks/pre-compact-snapshot.sh` | EV-007 (F5) | Snapshots critical files before compaction |
| Config change logging | `.claude/hooks/config-change-logger.sh` | EV-012 (F7) | Tracks configuration changes in session log |

### P2 Hooks (Fail-Open — Logging)
| Function | File | Evidence | Notes |
|---|---|---|---|
| Session exit logging | `.claude/hooks/stop-logger.sh` | EV-010 (F7 Bundle A) | Logs session close; prevents infinite loop |
| Role-based context injection for subagents | `.claude/hooks/subagent-context.sh` | EV-001 (F1) | Delivers context packs per SubagentStart |
| Subagent activity logging | `.claude/hooks/subagent-stop-logger.sh` | EV-013 (F7) | Logs subagent lifecycle; idempotent; 30-entry rotation |

### R-2 (Post-F8 Instrumentation — Observation Only)
| Function | File | Notes |
|---|---|---|
| STALL_POLICY observation helper | `.claude/hooks/lib/stall-record.sh` | Appends events to JSONL; non-gating (`|| true`) |
| STALL_POLICY event log | `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | Empty; operational; one test event confirmed emitting |

### Skills (Control Commands)
| Function | Skill | Notes |
|---|---|---|
| Evidence contract wizard | `.claude/skills/evidence.md` | Guided evidence creation |
| Phase gate verifier | `.claude/skills/gate.md` | Runs AUDIT→IMPLEMENT→TEST→VERIFY→EVIDENCE→GATE |
| Phase closer | `.claude/skills/cerrar-fase.md` | Checkpoint + evidence + PROJECT_STATE update |
| State inspector | `.claude/skills/estado.md` | Reads PROJECT_STATE + EVIDENCE_REGISTRY |
| Health checker | `.claude/skills/doctor.md` | 12-check maintenance suite summary |
| Incident reporter | `.claude/skills/incident.md` | Structured incident workflow |
| Recovery guide | `.claude/skills/recovery.md` | 9 recovery scenarios |

### Context Packs (Role-Based Situational Awareness)
| Pack | File | Consumer |
|---|---|---|
| CORE | `.claude/context/CORE.md` | All subagents |
| CURRENT_STATE | `.claude/context/CURRENT_STATE.md` | All subagents |
| DECISIONS | `.claude/context/DECISIONS.md` | researcher, architect, security-auditor |
| SECURITY_RULES | `.claude/context/SECURITY_RULES.md` | All subagents |
| BUSINESS | `.claude/context/BUSINESS.md` | researcher |
| NO_GO | `.claude/context/NO_GO.md` | All subagents |

### Evaluation Infrastructure
| Function | File | Notes |
|---|---|---|
| 12-check maintenance suite | `evals/maintenance.sh` | Schema, hooks, skills, incidents, state, evidence, docs, regression, freshness, firewall, secret-guard |
| R-2 harness | `evals/r2/r2-instrumentation.sh` | 5 checks for stall-record correctness |
| Incident regression | `evals/incidents/INC-001-task-completed-evidence.sh` | Canonical regression; run by maintenance |

### CI/CD
| Function | File | Notes |
|---|---|---|
| GitHub Actions workflow | `.github/workflows/control-plane.yml` | Runs evals/maintenance.sh on push/PR |

---

## 34. Non-Implemented Function Catalog

**[SOURCE: `docs/MASTER_IMPLEMENTATION_PLAN.md §Gaps`, `42_PROBLEMA_RESIDUAL.md`, `F9_RESEARCH.md`]**

### Post-F8 Research Deliverables (DESIGN ONLY — NOT RUNTIME)
| Function | Design document | Status |
|---|---|---|
| non_bypass_verify formal protocol | `50_R3_NON_BYPASS_VERIFY_DESIGN.md` | DESIGN ONLY — no code |

### Identified Gaps (F7-F12 Gap Register)
| Gap | ID | Priority | Status |
|---|---|---|---|
| GuardFall false-positive fix | G-A1 | P1 | DEFERRED (F9-D02=B) |
| Circuit breakers (max_iterations) | G-A2 | P2 | NOT AUTHORIZED |
| Sandbox layer (Docker isolation) | G-B1 | P2 | NOT AUTHORIZED |
| Checkpoint/rollback mid-task | G-B2 | P2 | NOT AUTHORIZED |
| Agent assurance propagation | G-B3 | DEFER | NOT AUTHORIZED |
| STALL_POLICY frequency baseline | G-B4 | P1 | R-2 INSTRUMENTED (data collection pending) |
| Non-bypass verify implementation | G-B5 | P1 | R-3 DESIGN ONLY |
| Native Claude lifecycle verification | G-B6 | P2 | DEFERRED (F9-D03=B) |
| Side-effect ledger | G-B7 | DEFER | NOT AUTHORIZED |
| Recovery budget governor | G-B8 | DEFER | NOT AUTHORIZED |
| Multi-agent stall coordination | G-B9 | DEFER | NOT AUTHORIZED |

### Concepts Researched but Explicitly Not Implemented
| Function | Reason not implemented | Notes |
|---|---|---|
| SAGR as recovery engine | Recovery space commoditized; no F9 gate | Both corpora agree; CH-004 killed |
| generate_alternative | Open-ended: no public implementation; SAGR v2 requires field validation | R-1 confirms no prior art closes gap |
| Policy-gap analyzer (P12) | No prior art; not in F1-F8 scope | Research note only |
| EFFECT_UNKNOWN state (from VERITAS OS) | Interesting pattern but not in CCP scope | Secondary finding from R-1 |
| Assurance impact propagation | Conceptual only; SH-001 hypothesis | TMS/ATMS prior art but not for agents |

---

## 35. Architecture Lineage

**[SOURCE: `docs/DESIGN.md`, `MASTER_IMPLEMENTATION_PLAN.md §2`, `EVIDENCE_REGISTRY.md §EV-001`]**

CCP's 6-layer architecture evolved through the following lineage:

### Layer 1 — Context (Pre-F1 → F1)
- **Origin:** Observation that agents working without project context waste turns re-deriving what they could know.
- **Design:** 6 context packs (Markdown files) injected by role via SubagentStart hook.
- **Decision:** ARCH-002 — explicit injection over `skills:` frontmatter.
- **Current state:** IMPLEMENTED; 6 packs operational.

### Layer 2 — State (F1 → F2)
- **Origin:** PROJECT_STATE.md as the single file that owns operational state. No state scattered across multiple docs.
- **Design:** YAML-like Markdown with machine-readable fields; SESSION_LOG.md as append-only log.
- **Decision:** Single source of truth principle (DESIGN.md §1).
- **Current state:** IMPLEMENTED; PROJECT_STATE.md authoritative.

### Layer 3 — Memory (F5)
- **Origin:** Context compaction problem — session state evaporates on compaction.
- **Design:** pre-compact-snapshot.sh hashes critical files; session-start-compact.sh verifies on resume.
- **Decision:** PreCompact hook in settings.json.
- **Current state:** IMPLEMENTED; hash + recovery operational.

### Layer 4 — Control (F4)
- **Origin:** Incident observation showed no feedback loop from problems to prevention.
- **Design:** Incident→Control→Regression loop as first-class primitive; three registries.
- **Decision:** F4 phase gate acceptance criteria.
- **Current state:** IMPLEMENTED; 1 canonical incident + 10 preventive regressions.

### Layer 5 — Execution (F1, F2, F7, F8)
- **Origin:** The core security problem — hooks must run before tool execution and must fail-closed.
- **Design:** P0 hooks wired in settings.json; fail-closed for bash-firewall + evidence gate; fail-open for logging hooks.
- **Decision:** Fail-closed default; bash-firewall before any shell execution.
- **Current state:** IMPLEMENTED; 3 P0 hooks + 4 P1/P2 logging hooks.

### Layer 6 — Verification (F2, F7)
- **Origin:** Evidence schema must be verifiable, not just writeable.
- **Design:** evals/maintenance.sh as 12-check verification suite; GitHub Actions CI.
- **Decision:** Evidence freshness check (maintenance); INC-001 regression test.
- **Current state:** IMPLEMENTED; CI operational; maintenance.sh 12/12 PASS.

---

## 36. File / Component Lineage

**[SOURCE: git log, EVIDENCE_REGISTRY.md, MASTER_IMPLEMENTATION_PLAN.md]**

### Core Files by Phase of Origin
| File | Phase introduced | Modified in | Notes |
|---|---|---|---|
| `.claude/settings.json` | Pre-F1 | F1, F2, F5, F7, F8 | Hook registry; 7 hooks wired |
| `.claude/hooks/bash-firewall.sh` | F1 | F7 Bundle B, F8-B, R-2 | P0 fail-closed; destructive pattern blocker |
| `.claude/hooks/secret-guard.sh` | F1 | — | P0 fail-closed; secret pattern blocker |
| `.claude/hooks/session-start-startup.sh` | F1 | — | P1 fail-open; state injection |
| `.claude/hooks/subagent-context.sh` | F1 | — | P2 fail-open; context pack injection |
| `.claude/hooks/task-completed-evidence.sh` | F2 | F8-A, R-2 | P0 fail-closed; evidence gate |
| `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | F2 | F3–F8 | Canonical evidence source; 16 entries |
| `INCIDENT_REGISTRY.md` | F4 | — | INC-001 only |
| `CONTROL_REGISTRY.md` | F4 | — | CTRL-001 only |
| `REGRESSION_REGISTRY.md` | F4 | — | REG-001 through REG-010 |
| `.claude/hooks/pre-compact-snapshot.sh` | F5 | — | P1 fail-open; PreCompact hash |
| `.claude/hooks/session-start-compact.sh` | F5 | — | P1 fail-open; post-compaction recovery |
| `evals/maintenance.sh` | F7 | F7 Bundle C | 12-check suite |
| `.claude/hooks/stop-logger.sh` | F7 Bundle A | — | P2; stop_hook_active guard |
| `.claude/hooks/subagent-stop-logger.sh` | F7 | — | P2; subagent lifecycle log |
| `.claude/hooks/config-change-logger.sh` | F7 | — | P1; config change tracking |
| `install.sh` | F7 Bundle E | — | Idempotent installer |
| `.github/workflows/control-plane.yml` | F7 | — | CI/CD gate |
| `.claude/hooks/lib/stall-record.sh` | R-2 | — | Observation helper; non-gating |
| `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | R-2 | — | Empty JSONL; operational |

---

## 37. Hook Lineage

**[SOURCE: `.claude/settings.json`, EVIDENCE_REGISTRY.md, MASTER_IMPLEMENTATION_PLAN.md]**

### Hook Configuration (settings.json) — Current
```
SessionStart   → session-start-startup.sh (P1)
               → session-start-compact.sh (P1)
               → subagent-context.sh (P2)
PreToolUse     → bash-firewall.sh (P0)
               → secret-guard.sh (P0)
PostToolUse    → config-change-logger.sh (P1)
TaskCompleted  → task-completed-evidence.sh (P0)
Stop           → stop-logger.sh (P2)
SubagentStop   → subagent-stop-logger.sh (P2)
PreCompact     → pre-compact-snapshot.sh (P1)
```

### Hook Evolution by Phase
| Phase | Hook change |
|---|---|
| F1 | bash-firewall.sh, secret-guard.sh, session-start-startup.sh, subagent-context.sh CREATED |
| F2 | task-completed-evidence.sh CREATED |
| F5 | pre-compact-snapshot.sh, session-start-compact.sh CREATED |
| F7 Bundle A | stop-logger.sh CREATED + stop_hook_active guard added |
| F7 Bundle B | bash-firewall.sh updated: case-tolerant, covers .env read variants |
| F7 Bundle D | session-start-compact.sh state integrity upgrade |
| F7 | subagent-stop-logger.sh, config-change-logger.sh CREATED |
| F8-A | task-completed-evidence.sh: contract_hash made mandatory |
| F8-B | bash-firewall.sh: blocks malformed JSON/empty/NUL before extraction |
| R-2 | bash-firewall.sh + task-completed-evidence.sh modified to source stall-record.sh |

### Hook Security Classes
| Class | Hooks | Exit behavior | Failure semantics |
|---|---|---|---|
| P0 (fail-closed) | bash-firewall, secret-guard, task-completed-evidence | exit 2 on block | Tool call blocked; task blocked |
| P1 (fail-open) | session-start-startup, session-start-compact, pre-compact-snapshot, config-change-logger | exit 0 on error | Hook silently fails; session continues |
| P2 (fail-open) | stop-logger, subagent-context, subagent-stop-logger | exit 0 on error | Hook silently fails; logging missed |

---

## 38. Skill Lineage

**[SOURCE: `.claude/skills/`, `ARTIFACT_MANIFEST.md §F3 Bundle A`, `EVIDENCE_REGISTRY.md §EV-005`]**

### Skills by Phase of Origin
| Skill | Phase | Function |
|---|---|---|
| `/evidence` | F3 | Guided evidence contract creation |
| `/gate` | F3 | Full gate verification (AUDIT→IMPLEMENT→TEST→VERIFY→EVIDENCE→GATE) |
| `/cerrar-fase` | F3 | Phase closure (checkpoint + evidence + state update) |
| `/estado` | F3 | State inspection (PROJECT_STATE + EVIDENCE_REGISTRY + health check) |
| `/doctor` | F3 | Maintenance suite summary (12-check health) |
| `/incident` | F4 | Structured incident workflow (create INC/CTRL/REG triad) |
| `/recovery` | F4 | 9 recovery scenarios |
| `/checkpoint` | F6 | Git checkpoint + PROJECT_STATE.LAST_GIT_CHECKPOINT update |
| `/no-go` | — | NO_GO pattern verification |
| `/cerrar-session` | — | Session closure workflow |

### Skill Architecture
- Skills are Markdown files in `.claude/skills/`.
- Skills are NOT loaded as runtime hooks; they are read by the agent when invoked.
- ARCH-002 decision: do NOT depend on `skills:` frontmatter as a runtime injection mechanism.
- Skills serve as instructions for the agent's behavior within a task, not as hook code.

---

## 39. Registry Lineage

**[SOURCE: `ARTIFACT_MANIFEST.md`, `DECISION_REGISTRY.md`, `INCIDENT_REGISTRY.md`, `EVIDENCE_REGISTRY.md`]**

CCP has four primary registries, each serving a distinct function in the phase gate system.

| Registry | File | Purpose | Phase | Entries |
|---|---|---|---|---|
| Evidence Registry | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | Single source of truth for phase evidence | F2 | EV-001 to EV-016 (16 entries) |
| Decision Registry | `DECISION_REGISTRY.md` | Architectural decisions + rationale | Pre-F1 | ARCH-001 to ARCH-004 (4 decisions) |
| Incident Registry | `INCIDENT_REGISTRY.md` | Production incidents | F4 | INC-001 (1 entry) |
| Control Registry | `CONTROL_REGISTRY.md` | Controls derived from incidents | F4 | CTRL-001 (1 entry) |
| Regression Registry | `REGRESSION_REGISTRY.md` | Regressions (incident + preventive) | F4 | REG-001 to REG-010 (10 entries) |

### Registry Design Properties
- All registries are Markdown files (append-only by convention).
- All registries have schema defined in corresponding template files (`.claude/templates/`).
- Evidence registry has machine-readable fields (`artifact_hash`, `contract_hash`, `status`, `risk_level`, `reviewer`).
- Registry integrity is checked by evals/maintenance.sh.

### Template Catalog
| Template | File | Purpose |
|---|---|---|
| Evidence template | `.claude/templates/EVIDENCE_TEMPLATE.md` | Evidence contract schema |
| Incident template | `.claude/templates/INCIDENT_TEMPLATE.md` | Incident report schema |
| Control template | `.claude/templates/CONTROL_TEMPLATE.md` | Control derivation schema |
| Regression template | `.claude/templates/REGRESSION_TEMPLATE.md` | Regression test schema |
| Decision template | `.claude/templates/DECISION_TEMPLATE.md` | Decision record schema |
| Artifact template | `.claude/templates/ARTIFACT_TEMPLATE.md` | Artifact delivery schema |
| Project state template | `.claude/templates/PROJECT_STATE_TEMPLATE.md` | STATE schema |
| CLAUDE.md template | `.claude/templates/CLAUDE_TEMPLATE.md` | Project instructions template |

---

## 40. State Lineage

**[SOURCE: `PROJECT_STATE.md`, `docs/DESIGN.md §L2`, `EVIDENCE_REGISTRY.md §EV-007`]**

### STATE Fields (Current Schema)
```yaml
CURRENT_PHASE:          8
PHASE_STATUS:           COMPLETE
CURRENT_OBJECTIVE:      F8 cerrada; F9 investigated + F9 NOT JUSTIFIED; F9 owner decision gate CLOSED
BLOCKERS:               NONE
ACTIVE_DECISIONS:       ARCH-001, ARCH-002, ARCH-003, ARCH-004
LAST_GIT_CHECKPOINT:    3336bd6
NEXT_ALLOWED_PHASE:     None auto; new owner-driven project decision required
IMPLEMENTATION_READY:   false
```

### State Fields by Phase of Introduction
| Field | Phase introduced | Semantics |
|---|---|---|
| CURRENT_PHASE | Pre-F1 | Integer; current phase number |
| PHASE_STATUS | Pre-F1 | IN_PROGRESS / COMPLETE / BLOCKED |
| CURRENT_OBJECTIVE | Pre-F1 | Human-readable goal for current phase |
| BLOCKERS | Pre-F1 | List of active blockers (NONE if none) |
| ACTIVE_DECISIONS | F2 | Active ARCH-NNN IDs |
| LAST_GIT_CHECKPOINT | F6 | Git commit hash of last checkpoint |
| NEXT_ALLOWED_PHASE | F6 | Explicit gate for next phase opening |
| IMPLEMENTATION_READY | Post-F8 | Boolean gating implementation authorization |

### State History
| Phase | Key state change |
|---|---|
| F0 | PROJECT_STATE.md created; CURRENT_PHASE=0 |
| F1 | Phase complete; PHASE_STATUS=COMPLETE for F1 |
| F2 | ACTIVE_DECISIONS added; ARCH-001..003 listed |
| F4 | F4 COMPLETE after INC-001 → CTRL-001 → REG-001 |
| F5 | SESSION_LOG.md started; rotation; state hash added |
| F6 | LAST_GIT_CHECKPOINT field added; /checkpoint wired |
| F8 | F8 COMPLETE; IMPLEMENTATION_READY=false; F9 NOT JUSTIFIED |
| R-2 | No state field change; PROJECT_STATE.md unchanged by R-2 |
| R-3 | No state field change; PROJECT_STATE.md unchanged by R-3 |

### State Integrity Invariant
At session-start-compact.sh run:
1. pre-compact-snapshot.sh has written SHA-256 hashes of critical files.
2. session-start-compact.sh reads the hashes and verifies current file matches snapshot.
3. If hashes match: STATE_INTEGRITY=PASS.
4. If hashes mismatch: STATE_INTEGRITY=WARN (session continues; operator notified).

---

## 41. Evidence Lineage

**[SOURCE: `EVIDENCE_REGISTRY.md`, `MASTER_IMPLEMENTATION_PLAN.md`, `POST_F8_AUDIT_REPORT.md`]**

### Evidence Schema Evolution
| Version | Change | Phase |
|---|---|---|
| v1 (F2) | schema: task_id, artifact_hash, status, risk_level, reviewer, exceptions, timestamp | F2 |
| v2 (F8-A) | contract_hash ADDED (mandatory); absence = exit 2 in hook | F8 |

### Evidence Entries by Phase
| Phase | Evidence entries | Key evidence |
|---|---|---|
| F1 | EV-001 | Session state injection operational |
| F2 | EV-002, EV-003 | Evidence gate + secret guard operational |
| F3 | EV-004, EV-005 | Skill suite operational |
| F4 | EV-006 | Incident learning loop operational |
| F5 | EV-007, EV-008 | Context compaction recovery operational |
| F6 | EV-008 | /checkpoint + state tracking operational |
| F7 | EV-009, EV-010, EV-011, EV-012, EV-013, EV-014 | F7 bundle operational |
| F8 | EV-015, EV-016 | contract_hash fail-closed; JSON firewall |

### Evidence Contract Properties
Each CONTRACTUAL TASK requires:
```
task_id: unique identifier
artifact_hash: SHA-256 of the deliverable
contract_hash: hash binding this evidence to the specific task contract
status: VERIFIED (not PROPOSED)
risk_level: LOW / MEDIUM / HIGH
reviewer: {name, role, independent: true/false}
exceptions: [] or list with rationale
timestamp: UTC ISO-8601
provenance: how the evidence was generated
```

### Evidence Properties (Current)
- **Freshness:** evals/maintenance.sh test #11 checks evidence is not stale.
- **Integrity:** contract_hash must match; mismatch = exit 2.
- **Reviewer requirement:** independent review required for HIGH risk items.
- **Exception handling:** exceptions are allowed but must have rationale; maintenance checks.

---

## 42. Security Lineage

**[SOURCE: `EVIDENCE_REGISTRY.md`, `docs/DESIGN.md §L5`, `POST_F8_AUDIT_REPORT.md`]**

### Security Architecture by Phase
| Phase | Security addition | Evidence |
|---|---|---|
| Pre-F1 | Design: fail-closed default for all P0 hooks | Architecture principle |
| F1 | bash-firewall.sh: blocks 20+ destructive patterns | EV-001, EV-003 |
| F1 | secret-guard.sh: blocks API keys, tokens, private keys on write/edit | EV-003 |
| F2 | task-completed-evidence.sh: blocks completion without verified evidence | EV-002 |
| F7 Bundle B | bash-firewall case-tolerant; .env read variants covered | EV-009 |
| F8-A | contract_hash made mandatory; stale evidence binding blocked | EV-015 |
| F8-B | bash-firewall blocks malformed/empty/NUL JSON before extraction | EV-016 |
| R-2 | Observation events added; SECURITY DECISION BEFORE logging call; LOGGING FAILURE != SECURITY BYPASS | EV in R-2 doc |

### Security Invariants (Verified by POST_F8_AUDIT_REPORT.md)
1. **Missing evidence = block.** task-completed-evidence.sh exits 2 on any evidence contract violation.
2. **Malformed input = block.** bash-firewall.sh rejects malformed JSON before attempting command extraction.
3. **Missing contract_hash = block.** F8-A addendum enforced; absence exits 2.
4. **Secret on write = block.** secret-guard.sh blocks before file is written.
5. **Logging failure ≠ security bypass.** R-2 observation is non-gating; hook exits with pre-computed decision.

### Known Security Gaps
| Gap | Classification | Status |
|---|---|---|
| GuardFall false-positive class | Known unmitigated | DEFERRED (F9-D02=B) |
| No Docker sandbox | Architectural gap vs AIGIS | NOT AUTHORIZED for F10 |
| No circuit breakers | No max_iterations / max_tool_calls | NOT AUTHORIZED |
| secret-guard.sh not instrumented for R-2 | Intentional scope limit | R-2 limitation documented |

---

## 43. Authority Lineage

**[SOURCE: `docs/DESIGN.md §source-of-truth hierarchy`, `DECISION_REGISTRY.md`, `PROJECT_STATE.md`]**

### Source-of-Truth Hierarchy (CCP Design)
```
Level 1 — Runtime behavior:
  settings.json (wired hooks)
  Hook files (.claude/hooks/*.sh)

Level 2 — Operational state:
  PROJECT_STATE.md (sole authoritative state)
  DECISION_REGISTRY.md (sole authoritative decisions)
  EVIDENCE_REGISTRY.md (sole authoritative evidence)

Level 3 — Design contracts:
  MASTER_IMPLEMENTATION_PLAN.md (phase contracts)
  DESIGN.md (architectural contracts)

Level 4 — Reference:
  docs/CONTROL_PLANE_HANDBOOK.md (operational guide)
  README.md (entry point)
```

### Conflict Resolution Rule
If two sources conflict, the higher level wins. Runtime behavior (settings.json + hooks) overrides documentation. PROJECT_STATE.md overrides any other state claim.

### Authority by Function
| Function | Authority source |
|---|---|
| Is phase N complete? | PROJECT_STATE.PHASE_STATUS |
| Is evidence EV-NNN verified? | EVIDENCE_REGISTRY.md §EV-NNN status=VERIFIED |
| Is ARCH-NNN active? | DECISION_REGISTRY.md §ARCH-NNN |
| Is git checkpoint current? | PROJECT_STATE.LAST_GIT_CHECKPOINT |
| Is hook behavior correct? | POST_F8_AUDIT_REPORT.md + evals/maintenance.sh |
| Is SAGR authorized? | PROJECT_STATE.IMPLEMENTATION_READY=false + F9 NOT JUSTIFIED |

---

## 44. Trust Boundary Lineage

**[SOURCE: `docs/DESIGN.md §L5`, `EVIDENCE_REGISTRY.md`, `security.md rules`]**

### Trust Boundaries in CCP
| Boundary | Mechanism | Notes |
|---|---|---|
| Agent → Shell | bash-firewall.sh (P0) | Every bash tool call goes through firewall |
| Agent → File write | secret-guard.sh (P0) | Every write/edit checked for secrets |
| Agent → Task completion | task-completed-evidence.sh (P0) | Every TaskCompleted checked for evidence |
| Claude session → Context | session-start hooks (P1) | State injected at session start |
| Session → Next session | pre-compact-snapshot.sh (P1) | State hashed before compaction |
| Git repository | git commit hashes | Artifact hashes anchored in git history |

### Trust Boundary Gaps
- No network boundary — CCP has no network isolation; agent can reach external URLs.
- No process isolation — no Docker sandbox; bash-firewall is the only process-level boundary.
- No tenant isolation — CCP is single-tenant by design; multi-tenant CCP not designed.

### Trust Model
CCP's trust model is: **the Claude session is trusted; the executed tools are constrained**.
- The agent is assumed to follow its system prompt and CLAUDE.md rules.
- The hooks constrain what the agent can DO, not what the agent can THINK.
- This is a governance approach (restrict execution) not a verification approach (verify intent).

---

## 45. Reversibility Lineage

**[SOURCE: `docs/DESIGN.md §reversibility`, `.claude/skills/recovery.md`, `git policy`]**

### Reversibility Properties by Layer
| Layer | Reversibility | Mechanism |
|---|---|---|
| Hook execution (P0) | IRREVERSIBLE — hook decisions cannot be undone | Evidence gate exit 2 = task blocked |
| Evidence records | APPEND-ONLY — no delete | Markdown append convention |
| Registry entries | APPEND-ONLY — no delete | Same |
| Git commits | REVERSIBLE — git revert | git as trust boundary |
| PROJECT_STATE | MUTABLE — single authoritative file | /checkpoint backs it up |
| Session log | APPEND-ONLY — daily rotation | stop-logger.sh |

### Reversibility Design Choices
- Append-only registries were chosen to make the audit trail irrevocable.
- git revert is the primary undo mechanism for committed changes.
- R-2 rollback procedure is documented in 48_R2_INSTRUMENTATION.md §Rollback.

### Recovery Scenarios (from /recovery skill)
1. Agent produced partial evidence
2. Evidence hash mismatch
3. Phase gate blocked
4. Context compaction state loss
5. Hook failure (P0 blocks legitimate command)
6. Incident discovered post-phase
7. Stale evidence
8. Incorrect reviewer
9. Secret accidentally included in code

---

## 46. R-2 Knowledge Dossier

**[SOURCE: `48_R2_INSTRUMENTATION.md`, `STALL_POLICY_LOG.jsonl`, `.claude/hooks/lib/stall-record.sh`]**

### What R-2 Is
STALL_POLICY observation instrumentation. Minimum viable implementation that records observation events when existing hooks make policy-related decisions, without changing security behavior.

### What R-2 Is NOT
- NOT a STALL_POLICY frequency measurement
- NOT field validation
- NOT recovery
- NOT SAGR
- NOT alternative generation
- NOT F10 or any architectural change
- NOT a security mechanism (fail-open, `|| true`)

### Scope
- **Instruments:** bash-firewall.sh (policy denials) + task-completed-evidence.sh (evidence denials)
- **Does NOT instrument:** secret-guard.sh (intentional limitation), other hooks
- **Event schema:** `{"schema_version","event_id","timestamp","source_hook","decision","stall_type","policy_category","action_hash","task_id","session_id","notes","had_alternative"}`
- **stall_type values:** STALL_POLICY, STALL_ERROR, UNKNOWN
- **had_alternative:** always null (instrumentation never infers it; requires human classification)

### Security Analysis
```
Security decision finalized in decision=2 BEFORE observation call
Observation call is || true (non-gating)
Hook exits with pre-computed decision
LOGGING FAILURE != SECURITY BYPASS
```

### Verification Status
- 5-test R-2 harness: all PASS
- 12-check maintenance suite: before=12/12 PASS; after=12/12 PASS; delta=equivalent
- Hook return codes: before=[0,2,0,2]; after=[0,2,0,2]; HOOK_BEHAVIOR_DIFF=equivalent

### Current State
- STALL_POLICY_LOG.jsonl: **empty** (operational; no field data yet)
- One test event confirmed emitting during harness test (to fixture path, not repo log)
- Status: `R2 EXECUTED — AUDIT PENDING`

### What R-2 Cannot Tell Us
- STALL_POLICY frequency (H-01): requires N-day observation window with real usage
- Whether any hook denial corresponds to a user-perceived stall
- Whether had_alternative=true for any event
- Whether N events justify F10 (they do not, per R-2 document)

### Known Unknowns (from R-2 doc §Known Unknowns)
- Whether native runtime supplies useful task/session identifiers to hook payloads
- Whether real operators experience policy denial at material rate
- Whether hook-level denial = user-perceived stall
- Whether human reviewer can classify generic evidence failures more precisely
- Exact production filesystem permissions for log path
- `docs/00_SYSTEM/DECISION_REGISTRY.md` path listed in R-2 contract is incorrect (actual path: `DECISION_REGISTRY.md` at root)

---

## 47. R-3 Knowledge Dossier

**[SOURCE: `50_R3_NON_BYPASS_VERIFY_DESIGN.md`]**

### What R-3 Is
Formal design + falsifiability protocol for non_bypass_verify. The R-3 deliverable is a DESIGN DOCUMENT, not a runtime implementation.

### What R-3 Is NOT
- NOT implemented
- NOT production-ready
- NOT part of CCP runtime
- NOT authorized for F10

### The Function Being Designed
```
non_bypass_verify(A', A_blocked, P) → {COMPLIANT, BYPASS, UNKNOWN}
where:
  A' = proposed alternative action
  A_blocked = the policy-blocked original action
  P = the blocking policy
```

### Core Invariant Preserved
**STALL ≠ PERMISSION TO BYPASS SAFETY**

An agent that is blocked by policy P, proposing alternative A', is NOT permitted to act until non_bypass_verify returns COMPLIANT. UNKNOWN is treated as BLOCK.

### Design Questions (from R-3 doc)
1. Is (propose alternative + verify) architecturally superior to (refuse + escalate to human)?
2. What is the minimal semantic distance check that separates compliant alternatives from bypass attempts?
3. How should P's intent be represented vs P's literal text?
4. What makes non_bypass_verify falsifiable?

### Falsifiability Protocol (R-3 Design)
The R-3 design specifies how to test non_bypass_verify:
- A set of compliant alternative pairs: (A_blocked, A', P) where A' is genuinely compliant
- A set of bypass attempt pairs: (A_blocked, A', P) where A' achieves the blocked goal by another path
- Protocol: claim precision ≥ X%, recall ≥ Y%, zero false negatives on bypass class
- If non_bypass_verify produces any false negative on bypass class: design fails; safety invariant violated

### Status
- DESIGN ONLY
- NOT IMPLEMENTED
- No runtime code exists for non_bypass_verify
- The residual problem (§§18–19 this atlas) remains open

---

## 48. Roger Knowledge Dossier

**[SOURCE: `52_ROGER_HYPOTHESIS_POST_AUDIT.md`]**

### What the Roger Hypothesis Is
The "Roger" hypothesis proposes a representation-level shift: rather than adding new runtime mechanisms, change HOW the agent represents the problem state. The hypothesis claims this representation shift would produce qualitatively different behavior without new hooks.

### Who "Roger" Is
[UNKNOWN] — the Roger label refers to an idea or framing encountered during research. The audit document does not identify a specific person. It is a named hypothesis within the research program.

### Audit Methodology
Claude Opus 4.7 audited 8 specific claims constituting the Roger hypothesis against primary sources (CCP code, research corpus, AIGIS teardown, R-1 prior art verification).

### 8 Claims and Their Verdicts
| Claim | Classification | Notes |
|---|---|---|
| Representation shift produces measurably different behavior | HYPOTHESIS | No empirical test; plausible but unverified |
| The shift is distinct from adding new hooks | HYPOTHESIS | Conceptually distinct; not falsified |
| Current CCP needs this shift | INDETERMINED | Dependent on H-01 (STALL_POLICY frequency) |
| The shift is implementable at agent prompt level | HYPOTHESIS | Prior art: chain-of-thought, reflection papers suggest plausibility |
| This closes the residual problem | REFUTED | R-1 verified no prior art closes residual; representation shift alone insufficient |
| This is novel (no prior work) | WEAKENED | CoT, ReAct, Self-Ask, Reflexion all involve representation; not novel in that sense |
| This is applicable now | INDETERMINED | Requires frequency baseline first |
| This should be prioritized before R-2/R-3 | REFUTED | R-2/R-3 provide empirical basis; Roger is speculative without baseline |

### Final Classification
```
INDETERMINED / tendency REFORMULATION
```
- Roger is not clearly a new mechanism — it tends toward reformulating the problem statement.
- Some claims refuted (closes residual, prioritize before R-2/R-3).
- Some claims are hypotheses worth testing after R-2 frequency baseline exists.
- No implementation authorized.

### 3 Candidate Deltas (from audit)
| Delta | Description | Classification |
|---|---|---|
| Delta A | Explicit state representation of "what policy blocked me" vs "what do I want to do" | HYPOTHESIS — testable after R-2 |
| Delta B | Policy intent vs policy text as separate representation fields | HYPOTHESIS — relates to R-3 P design |
| Delta C | Alternative viability as a first-class field in the agent's reasoning | HYPOTHESIS — could inform R-3 |

---

## 49. Hypothesis Ledger

**[SOURCE: `46_FINAL_RECONCILIATION.md`, `CCP_RESEARCH_CONTEXT_MASTER.md §H`, `CCP_RESEARCH_CONTEXT_MASTERC.md §CH`]**

Complete catalog of all hypotheses, both killed (CH) and surviving (SH).

### Killed Hypotheses (CH-001 to CH-025)
| ID | Hypothesis | Killed by |
|---|---|---|
| CH-001 | Loop detection is novel for agents | loopless, FutureAGI, IAL-Scan |
| CH-002 | Checkpoint for agents is novel | Temporal, DBOS, LangGraph |
| CH-003 | Rollback for agents is novel | Same + livingai |
| CH-004 | Recovery architecture is novel | All of the above + general ecosystem |
| CH-005 | CCP evidence gate is unique | AIGIS teardown (verbatim match) |
| CH-006 | Commercial market exists for SAGR standalone | Round 0: no WTP, no buyers, no pilots |
| CH-007 | "3 cases in 4 weeks" statistical basis for urgency | No rubric, no denominator, no baseline |
| CH-008 | Durable execution solves semantic recovery | Temporal/DBOS explicitly document replay ≠ semantic recovery |
| CH-009 | State-Aware Runtime is an implementation | R-1: research agenda, no empirical validation |
| CH-010 | ae-framework is CCP prior art | R-1: dry-run only, SDLC-specific, no live PRs |
| CH-011 | VERITAS OS has operational EFFECT_UNKNOWN | R-1: beta, fixture-backed PoC |
| CH-012 | Side-effect continuity is unsolved across the board | Living AI, Replay Agent Recorder, AgentRewind provide partial solutions |
| CH-013 | Runtime governance is novel as category | Concept fully occupied; structured instantiations exist |
| CH-014 | SAGR = recovery architecture | Both corpora: recovery fully commoditized; SAGR v1 killed |
| CH-015 | Trajectory governance is unique to CCP | State-Aware Runtime + others describe it (though not implement open-ended) |
| CH-016 | Policy-aware planning is unsolved broadly | arXiv:2606.31339, PolicyGuide cover structured workflows |
| CH-017 | Agent loop detection has no tooling | loopless (PyPI), IAL-Scan (GitHub) fully cover it |
| CH-018 | Checkpoint/rollback has no implementation for agents | Temporal, DBOS, LangGraph all production-grade |
| CH-019 | CCP is unique among control planes | AIGIS (agent control plane), ae-framework (SDLC control plane), VERITAS OS, Mastra all exist |
| CH-020 | Cost explosions (LangChain $47K, Claude $50K) validate SAGR urgency | They validate circuit breakers, not SAGR governance of continuation |
| CH-021 | OSGuard is "fixed retry / hard stop only" | R-1-adjacent: OSGuard implements feedback-driven revision (weak form of alternative generation) |
| CH-022 | generate_alternative has no ANY implementation | PolicyGuide + SafeAgent implement for structured workflows |
| CH-023 | arXiv:2606.31339 covers open-ended agents | R-1: industrial multi-robot structured workflows only |
| CH-024 | Trajectory governance as CCP novelty (State-Aware Runtime closes it) | R-1: State-Aware Runtime conceptual only; CLOSED but for wrong reason |
| CH-025 | Replay = semantic recovery | Both Temporal docs and corpus consensus: replay re-executes LLM → different output |

### Surviving Hypotheses (SH-001 to SH-009)
*(Full table in §25; summary here)*
| ID | Claim | Confidence |
|---|---|---|
| SH-001 | Assurance impact propagation is feasible and valuable | MEDIUM |
| SH-002 | Specification adequacy lifecycle is unsolved | MEDIUM |
| SH-003 | Boundary completeness under open world is unsolved | MEDIUM |
| SH-004 | Incident learning loop = operational differentiator (partial) | HIGH (partial) |
| SH-005 | Continuous assurance requires intent-effect chain integration | MEDIUM |
| SH-006 | Semantic continuity across execution boundaries is unsolved at scale | HIGH |
| SH-007 | Governance of continuation (not recovery) is the right framing | HIGH |
| SH-008 | generate_alternative + non_bypass_verify for open-ended agents has no public implementation | HIGH (caveat: structured exists) |
| SH-009 | Industry default (refuse+escalate vs propose+verify) is architecturally significant and unresolved | MEDIUM |

### Corpus B Hypotheses (H1–H10)
*(From CCP_RESEARCH_CONTEXT_MASTER.md)*
| ID | Claim | Status |
|---|---|---|
| H1 | Evidence-gated completion is unique | REFUTED (AIGIS) |
| H2 | Commercial market exists | REFUTED (Round 0) |
| H3 | Incident loop is differentiator | PARTIALLY SUPPORTED |
| H4 | SAGR as recovery | REFUTED |
| H5 | SAGR as governance of continuation | PARTIALLY SUPPORTED |
| H6 | Phase gate discipline is differentiator | PARTIALLY SUPPORTED |
| H7 | Cost loop incident justifies circuit breakers | WEAKENED (supports circuit breakers; not SAGR) |
| H8 | GuardFall is fixable in F9 | OPEN (deferred F9-D02=B) |
| H9 | Durable execution resolves semantic recovery | REFUTED |
| H10 | "3 cases" justifies SAGR urgency | REFUTED |

### Unresolvable Unknowns (H-01 to H-04)
| ID | Unknown | Gate to resolve |
|---|---|---|
| H-01 | What is the actual frequency of STALL_POLICY events? | R-2 observation window (N days) |
| H-02 | What is the distribution of stall types in CCP? | R-2 observation window |
| H-03 | Does generate_alternative produce genuinely policy-compliant alternatives? | R-3 + empirical test |
| H-04 | Is non_bypass_verify semantically tractable? | R-3 design + falsifiability test |

---

## 50. Hypothesis → Falsifier Map

**[SOURCE: `46_FINAL_RECONCILIATION.md §gates`, `50_R3_NON_BYPASS_VERIFY_DESIGN.md`]**

For each surviving hypothesis, what would falsify it.

| Hypothesis | Falsifier | Status |
|---|---|---|
| SH-004 (incident loop is differentiator) | If AIGIS or another system has an equivalent incident→control→regression loop as first-class primitive | NOT FALSIFIED; AIGIS teardown did not find this |
| SH-006 (semantic continuity unsolved) | If a production system demonstrates full semantic recovery (replay = identical intention) | NOT FALSIFIED; Temporal/DBOS explicitly document they don't claim this |
| SH-007 (governance of continuation framing) | If the "governance of continuation" framing produces no different design than "recovery" framing | PARTIALLY TESTABLE via R-3 design |
| SH-008 (generate_alternative gap for open-ended) | If a paper or OSS system implements policy-compliant alternative generation for open-ended agents (not structured workflows) | NOT FALSIFIED as of R-1 verification |
| SH-009 (refuse+escalate vs propose+verify unresolved) | If there is published empirical evidence that one approach is strictly superior | NOT FALSIFIED; R-3 must address this as H0 |
| H-01 (frequency unknown) | If STALL_POLICY_LOG.jsonl contains N events from an N-day real-usage window | R-2 operational; data collection pending |
| H-04 (non_bypass_verify tractable) | If non_bypass_verify returns false negative on bypass test case | R-3 protocol designed; implementation required |

---

## 51. Closed Knowledge

**[SOURCE: All research corpus files; reconciliation documents]**

Topics where research reached saturation — further investigation would yield diminishing returns.

### Loop Detection (CLOSED)
- **What's known:** Multiple OSS tools exist (loopless, FutureAGI, IAL-Scan). Pattern well-understood. No novel CCP contribution needed.
- **Why closed:** CH-001 killed. Prior art comprehensive.

### Checkpoint / Rollback (CLOSED)
- **What's known:** Temporal, DBOS, LangGraph all implement at production grade. Model fully understood.
- **Why closed:** CH-002/003 killed. Better solutions than CCP could build exist.

### Durable Execution vs. Semantic Recovery (CLOSED)
- **What's known:** Durable execution (Temporal/DBOS) = crash recovery. Semantic recovery = recovering agent intent across execution boundaries. The two are fundamentally different. Replay ≠ semantic recovery.
- **Why closed:** SH-006 is SUPPORTED — but the question "does durable execution solve semantic recovery" is CLOSED: it does not.

### Recovery as Architecture (CLOSED)
- **What's known:** The recovery architecture space (loop detect + checkpoint + rollback + retry) is fully commoditized. No novel CCP contribution.
- **Why closed:** CH-004 killed. SAGR v1 killed.

### Commercial Market for SAGR Standalone (CLOSED)
- **What's known:** Round 0 business investigation found no WTP, no identifiable buyers, no pilot interest.
- **Why closed:** CH-006 killed. Internal tool value only.

### Evidence Gate Uniqueness (CLOSED)
- **What's known:** AIGIS reproduces evidence-gated completion with deeper machinery (more fields, reviewer process, 234 tests).
- **Why closed:** CH-005 killed; CCP is not unique on this dimension.

### "3 Cases in 4 Weeks" as Statistical Baseline (CLOSED)
- **What's known:** The observation had no rubric, no denominator, no reproducible calculation. Not a valid statistical basis for urgency.
- **Why closed:** CH-007 killed. R-2 replaces anecdote with instrumentation.

---

## 52. Open Problems

**[SOURCE: `42_PROBLEMA_RESIDUAL.md`, `F9_RESEARCH.md`, surviving hypotheses]**

Problems where research is complete but implementation is blocked, or where a formal design exists but empirical work is pending.

### Open Problem 1 — The Residual Problem (Primary)
**Statement:** An agent blocked by policy P, that could achieve goal O with alternative A', must propose A' AND demonstrate A' doesn't bypass P's intent, without workflow pre-compilation.

**Why it's open:**
- No public implementation for open-ended agents (R-1 verified)
- Non-bypass verification function (P17) remains unimplemented
- generate_alternative (P6) remains unimplemented for open-ended agents

**Gate to resolve:** 
- Field baseline (H-01 from R-2) — is frequency material?
- R-3 design + falsifiability test — is non_bypass_verify tractable?
- If both: implementation proposal for F10+ review

**Current status:** R-2 operational (collecting); R-3 designed (not implemented). Residual SURVIVES as per R-1 verification.

### Open Problem 2 — STALL_POLICY Frequency (H-01)
**Statement:** What is the actual rate of policy-related agent stalls in CCP usage?

**Why it's open:** STALL_POLICY_LOG.jsonl is operational but empty. No real usage observation has occurred.

**Gate to resolve:** N-day observation window with real CCP usage.

### Open Problem 3 — GuardFall False Positives
**Statement:** bash-firewall.sh substring matching produces false positives when legitimate commands contain destructive substrings.

**Example:** A test file that tests `rm -rf` behavior would be blocked.

**Why deferred:** F9-D02=B — no concrete trigger (no reproducible production incident).

**Gate to resolve:** Reproducible incident where GuardFall blocks legitimate work.

### Open Problem 4 — Semantic Continuity
**Statement:** How do you guarantee that an agent resuming after context compaction, a crash, or a session boundary has the same semantic intention as the original session?

**Why it's open:** Replay doesn't recover intention. CCP's state snapshot/hash approach ensures state integrity, not semantic intention continuity.

**Gate to resolve:** Would require a theory of agent intention + a test for intention equivalence. No current design.

### Open Problem 5 — Assurance Impact Propagation (SH-001)
**Statement:** When a component changes, how should you propagate assurance invalidity to claims that depended on that component?

**Why it's open:** Conceptual prior art (TMS/ATMS) exists but no agent-specific implementation.

**Gate to resolve:** Design + prototype for CCP's evidence structure specifically.

---

## 53. Unknowns

**[SOURCE: `CCP_RESEARCH_CONTEXT_MASTER.md §Unknowns`, research saturation certificate, R-2 document §Known Unknowns`]**

Distinct from open problems: unknowns are questions where we don't know what we don't know, or where the answer requires information external to the research corpus.

### Unresolvable Unknowns (H-01 to H-04)
*(Full table in §49)*
- H-01: STALL_POLICY frequency — requires real usage data
- H-02: Stall type distribution — requires real usage data
- H-03: generate_alternative effectiveness — requires R-3 + empirical test
- H-04: non_bypass_verify tractability — requires R-3 design test

### R-2 Known Unknowns
- Whether native runtime supplies task/session identifiers to hook payloads
- Whether real operators experience policy denial at material rate
- Whether hook-level denial corresponds to user-perceived stall

### Structural Unknowns (UNKNOWN classification)
| Unknown | Why unresolvable by research alone |
|---|---|
| F10-F12 scope | Requires owner decision; depends on H-01 data |
| Native Claude Code lifecycle behavior in OpenCode | Not verified during R-2; script-level only |
| Exact AIGIS architecture decisions | No insider access; teardown is reverse-engineering |
| Whether Roger hypothesis has empirical basis | No test designed or run |
| Whether EFFECT_UNKNOWN (VERITAS OS) should be adopted | No use case analysis for CCP's specific context |

---

## 54. Research Saturation

**[SOURCE: `37_CERTIFICADO_DE_SATURACION.md`, `CCP_RESEARCH_CONTEXT_MASTER.md §Saturation`]**

### Saturation Declaration
**Date:** 2026-09-21 (declared in saturation certificate)
**Scope:** SAGR desk research
**Declaration:** The desk research phase is declared SATURATED.

### 11 Saturation Criteria (from certificate)
| Criterion | Evaluation | Result |
|---|---|---|
| 1. New sources produce known content | All Round 0 web searches return known patterns | MET |
| 2. All major categories covered | 17 tracks, 22 primitives, 34+ references | MET |
| 3. Prior art space verified | R-1 verification of 4 candidates | MET |
| 4. Both corpora reconciled | 39_CONCILIACION + 46_FINAL_RECONCILIATION | MET |
| 5. Residual explicitly defined | 42_PROBLEMA_RESIDUAL.md | MET |
| 6. Killed hypotheses documented | 25 killed (CH-001..CH-025) | MET |
| 7. Surviving hypotheses documented | 9 surviving (SH-001..SH-009) | MET |
| 8. Next research actions defined | R-2 + R-3 | MET |
| 9. Corrections applied | 5 corrections (COR-001..COR-005) | MET |
| 10. Implementation decision made | REQUIRES REPRODUCTION + FIELD VALIDATION | MET |
| 11. Saturation limitations documented | "Saturation does not mean certainty" | MET |

### Saturation Limitations
- Saturation applies to DESK RESEARCH, not to production evidence.
- H-01 through H-04 remain genuinely open (require empirical data, not more research).
- "Research saturated" ≠ "problem solved."
- Native Claude Code lifecycle behavior unverified (not a desk research question).

---

## 55. Lessons Learned

**[SOURCE: Research corpus, incident analysis, correction ledger, reconciliation synthesis]**

### L01 — DEFERRED ≠ UNAVAILABLE
When a tool is not in the current context but exists in the system, it is DEFERRED not ABSENT. Apply ToolSearch before assuming a capability doesn't exist. CCP itself discovered this when evals showed "hook not found" and the answer was "hook exists but path was wrong."
**Applies to:** Any situation where a mechanism seems to be missing.

### L02 — RESEARCH → IMPLEMENTATION is not automatic
The existence of a research corpus does not authorize implementation. CCP has a 38-document research program and NO SAGR implementation authorized. Evidence must satisfy 4 gates simultaneously.
**Applies to:** F10+ decisions; any "now that we know this, let's build" impulse.

### L03 — CORPUS A OVERCLAIMS SOURCES
The ChatGPT-generated corpus (Corpus A, MASTERC) systematically overstated source quality: presented research agendas as implementations, described dry-run tools as production-grade. Every Corpus A source needs primary verification before treatment as evidence.
**Applies to:** Any time a claim cites a source from Corpus A / MASTERC.

### L04 — SPECIFICITY SURVIVES, GENERALITY DIES
All 25 killed hypotheses were general ("X is novel", "Y is unsolved broadly"). All 9 surviving hypotheses are specific ("for open-ended agents without pre-compiled workflows, Z is unsolved").
**Applies to:** Claim formation; research scoping; architectural decision framing.

### L05 — INCIDENT→CONTROL→REGRESSION is a discipline, not a one-time action
INC-001 produced REG-001, but the real value is the loop as a practice: every discovered assumption becomes an explicit requirement and a regression. Without the loop, assumptions accumulate silently.
**Applies to:** Any operational system; every new incident is a learning opportunity.

### L06 — FAIL-CLOSED must be verified independently
The POST_F8_AUDIT_REPORT.md independent review found that fail-closed behavior was implemented but not initially independently verified. Audit must be independent (fresh context, no pre-existing belief).
**Applies to:** Every P0 hook change; every F8-equivalent gate.

### L07 — SECURITY DECISION BEFORE LOGGING, NOT AFTER
R-2 design correctly places the security decision (decision=2) before the observation call (|| true). If logging fails, security is unaffected. This is the correct pattern for any non-security-critical observability instrumentation.
**Applies to:** Any future instrumentation that touches P0 hooks.

### L08 — STALL ≠ PERMISSION TO BYPASS SAFETY
An agent blocked by a policy is NOT granted any additional permissions by virtue of being blocked. This invariant must be preserved in every version of SAGR design.
**Applies to:** All of R-3; all future F10+ SAGR work.

### L09 — COMMERCIAL VIABILITY requires WTP evidence, not problem evidence
CCP's research confirmed the problem (agents stall on policy) and confirmed the solution (governance of continuation). But it found no evidence of Willingness to Pay. Problem + Solution ≠ Market.
**Applies to:** Any future commercial product decision; R-3 evaluation.

### L10 — SCOPE DISCIPLINE enables phase gate trust
F1-F8 stayed within scope. R-2 stayed within instrumentation-only scope. R-3 stayed within design-only scope. Each time scope was respected, the evidence was cleaner and the gate was faster.
**Applies to:** Every task definition; every scope boundary; every "let me also fix X while I'm here" impulse.

---

## 56. Current Frontier

**[SOURCE: `42_PROBLEMA_RESIDUAL.md`, `F9_RESEARCH.md`, PROJECT_STATE.md, R-2, R-3]**

The current frontier is the boundary between what CCP has solved, what it has designed, and what remains genuinely open.

### Frontier 1 — STALL_POLICY Frequency Baseline
- **What:** Empirical observation of how often policy denials occur during normal CCP usage
- **How:** STALL_POLICY_LOG.jsonl operational; run N-day window with real CCP usage
- **Blocking:** Nothing. R-2 is ready.
- **Status:** READY TO COLLECT (owner must use CCP and let it log)

### Frontier 2 — non_bypass_verify Empirical Validation
- **What:** Test the R-3 design against synthetic (A_blocked, A', P) triples to verify tractability
- **How:** R-3 falsifiability protocol; create test cases; measure precision/recall/false negative rate
- **Blocking:** H-01 frequency data not yet collected (but can proceed independently with synthetic cases)
- **Status:** DESIGN COMPLETE; EMPIRICAL TEST NOT DONE

### Frontier 3 — GuardFall Concrete Trigger
- **What:** A reproducible incident where GuardFall blocks a legitimate command
- **How:** Observe CCP usage; report any false positive as incident
- **Blocking:** F9-D02=B gates this. No concrete trigger yet.
- **Status:** DEFERRED; gate is trigger-based

### Frontier 4 — F10 Authorization
- **What:** The next architectural phase — would require simultaneously satisfying 4 gates
- **How:** G1 (sufficient impact) + G2 (insufficient current control) + G3 (proportional benefit) + G4 (reversible scope)
- **Blocking:** H-01 unknown; H-04 unverified; F10 NOT JUSTIFIED
- **Status:** NOT AUTHORIZED; waiting for frontier 1 + 2 data

### Frontier 5 — Roger Hypothesis Empirical Test
- **What:** Test whether representation-level shifts (Delta A, B, C from §48) produce measurably different behavior
- **How:** After H-01 baseline, design test cases that probe representation vs. mechanism
- **Blocking:** No frequency baseline; no design for test
- **Status:** HYPOTHESIS; no test designed

---

## 57. Master Piece Matrix

**[SOURCE: ARTIFACT_MANIFEST.md, EVIDENCE_REGISTRY.md, research corpus]**

Complete view of every deliverable piece in the CCP system.

| # | Piece | Type | Status | Evidence | Phase |
|---|---|---|---|---|---|
| 1 | bash-firewall.sh | P0 Hook | [IMPLEMENTED / FROZEN] | EV-009, EV-016 | F1, F7, F8 |
| 2 | secret-guard.sh | P0 Hook | [IMPLEMENTED] | EV-003 | F1 |
| 3 | task-completed-evidence.sh | P0 Hook | [IMPLEMENTED / FROZEN] | EV-002, EV-015 | F2, F8 |
| 4 | session-start-startup.sh | P1 Hook | [IMPLEMENTED] | EV-001 | F1 |
| 5 | session-start-compact.sh | P1 Hook | [IMPLEMENTED] | EV-007 | F5 |
| 6 | pre-compact-snapshot.sh | P1 Hook | [IMPLEMENTED] | EV-007 | F5 |
| 7 | config-change-logger.sh | P1 Hook | [IMPLEMENTED] | EV-012 | F7 |
| 8 | stop-logger.sh | P2 Hook | [IMPLEMENTED] | EV-010 | F7 |
| 9 | subagent-context.sh | P2 Hook | [IMPLEMENTED] | EV-001 | F1 |
| 10 | subagent-stop-logger.sh | P2 Hook | [IMPLEMENTED] | EV-013 | F7 |
| 11 | stall-record.sh | Lib Helper | [IMPLEMENTED (R-2)] | 48_R2_INSTRUMENTATION | R-2 |
| 12 | settings.json | Config | [IMPLEMENTED] | EV-001 | F1+ |
| 13 | EVIDENCE_REGISTRY.md | Registry | [IMPLEMENTED] | EV-002 | F2+ |
| 14 | DECISION_REGISTRY.md | Registry | [IMPLEMENTED] | — | Pre-F1 |
| 15 | INCIDENT_REGISTRY.md | Registry | [IMPLEMENTED] | EV-006 | F4 |
| 16 | CONTROL_REGISTRY.md | Registry | [IMPLEMENTED] | EV-006 | F4 |
| 17 | REGRESSION_REGISTRY.md | Registry | [IMPLEMENTED] | EV-006 | F4 |
| 18 | PROJECT_STATE.md | State | [IMPLEMENTED] | — | Pre-F1 |
| 19 | STALL_POLICY_LOG.jsonl | Observation Log | [IMPLEMENTED (R-2)] | 48_R2_INSTRUMENTATION | R-2 |
| 20 | /evidence skill | Skill | [IMPLEMENTED] | EV-005 | F3 |
| 21 | /gate skill | Skill | [IMPLEMENTED] | EV-005 | F3 |
| 22 | /cerrar-fase skill | Skill | [IMPLEMENTED] | EV-005 | F3 |
| 23 | /estado skill | Skill | [IMPLEMENTED] | EV-005 | F3 |
| 24 | /doctor skill | Skill | [IMPLEMENTED] | EV-005 | F3 |
| 25 | /incident skill | Skill | [IMPLEMENTED] | EV-006 | F4 |
| 26 | /recovery skill | Skill | [IMPLEMENTED] | EV-006 | F4 |
| 27 | Context pack CORE | Context | [IMPLEMENTED] | EV-001 | F1 |
| 28 | Context pack CURRENT_STATE | Context | [IMPLEMENTED] | EV-001 | F1 |
| 29 | Context pack DECISIONS | Context | [IMPLEMENTED] | EV-001 | F1 |
| 30 | Context pack SECURITY_RULES | Context | [IMPLEMENTED] | EV-001 | F1 |
| 31 | Context pack BUSINESS | Context | [IMPLEMENTED] | EV-001 | F1 |
| 32 | Context pack NO_GO | Context | [IMPLEMENTED] | EV-001 | F1 |
| 33 | evals/maintenance.sh | Eval | [IMPLEMENTED] | EV-011 | F7 |
| 34 | evals/r2/r2-instrumentation.sh | Eval | [IMPLEMENTED (R-2)] | 48_R2_INSTRUMENTATION | R-2 |
| 35 | evals/incidents/INC-001-*.sh | Eval | [IMPLEMENTED] | EV-006 | F4 |
| 36 | install.sh | Installer | [IMPLEMENTED] | EV-014 | F7 |
| 37 | .github/workflows/control-plane.yml | CI/CD | [IMPLEMENTED] | — | F7 |
| 38 | MASTER_IMPLEMENTATION_PLAN.md | Design | [DOCUMENTED FACT] | — | Pre-F1 |
| 39 | docs/DESIGN.md | Design | [DOCUMENTED FACT] | — | Pre-F1 |
| 40 | POST_F8_AUDIT_REPORT.md | Audit | [AUDITED FACT] | EV-015, EV-016 | F8 |
| 41 | 42_PROBLEMA_RESIDUAL.md | Research | [DOCUMENTED FACT] | — | Post-F8 |
| 42 | 47_PRIOR_ART_VERIFICATION.md | Research (R-1) | [DOCUMENTED FACT] | — | Post-F8 |
| 43 | 48_R2_INSTRUMENTATION.md | Research (R-2) | [DOCUMENTED FACT] | — | Post-F8 |
| 44 | 50_R3_NON_BYPASS_VERIFY_DESIGN.md | Research (R-3) | [DESIGN ONLY] | — | Post-F8 |
| 45 | 52_ROGER_HYPOTHESIS_POST_AUDIT.md | Research | [DOCUMENTED FACT] | — | Post-F8 |
| 46 | non_bypass_verify() implementation | Code | [NOT IMPLEMENTED] | — | NOT AUTHORIZED |
| 47 | generate_alternative() implementation | Code | [NOT IMPLEMENTED] | — | NOT AUTHORIZED |
| 48 | SAGR recovery engine | Architecture | [NOT AUTHORIZED] | — | NOT AUTHORIZED |
| 49 | Circuit breakers | Feature | [NOT IMPLEMENTED] | — | NOT AUTHORIZED |
| 50 | Docker sandbox | Feature | [NOT IMPLEMENTED] | — | NOT AUTHORIZED |

---

## 58. Master Reference → CCP Matrix

**[SOURCE: §13 Reference Catalog, research corpus, implementation evidence]**

| REF | Source | What it contributed to CCP | Adoption type |
|---|---|---|---|
| REF-01 | AIGIS (cd-aguilar) | Evidence gate architecture; evidence schema validation; differentiator gap discovery | COMPARISON / COMPETITIVE ANALYSIS |
| REF-02 | Temporal / Durable Workflows | Demonstrated durable execution feasibility; killed "checkpoint is novel"; clarified crash recovery ≠ semantic recovery | CLARIFICATION (what CCP doesn't need to build) |
| REF-03 | LangGraph | State machine approach to agent workflows; demonstrated checkpoint/rollback available | CLARIFICATION |
| REF-04 | arXiv:2606.31339 | Mission-state governance; alternative generation for structured workflows; non-bypass via deterministic verification | CONCEPTUAL (structured workflows only — not open-ended) |
| REF-05 | State-Aware Runtime (Cambridge) | Conceptual taxonomy for state-aware agents; research agenda items | CONCEPTUAL (research agenda only; overcited by Corpus A) |
| REF-06 | OSGuard | Feedback-driven policy revision (weak alternative generation); policy constraint handling | CONCEPTUAL (reactive revision, not generative synthesis) |
| REF-07 | loopless (PyPI) | Loop detection tooling | CLARIFICATION (loop detection commoditized) |
| REF-08 | VERITAS OS (veritasfuji) | Decision governance; EFFECT_UNKNOWN state concept; refuse as terminal response | CONCEPTUAL (pattern inspiration; not adopted) |
| REF-09 | ae-framework (itdojp) | SDLC assurance control plane; dry-run quality gates | COMPARISON (positioning competitor; overcited by Corpus A) |
| REF-10 | PolicyGuide / SafeAgent | Alternative generation for structured workflows | CLARIFICATION (scope limit: structured only) |
| REF-11 | Cleland-Huang (RE 2026, RECODE) | Incident→control→regression loop in requirements engineering | CONCEPTUAL PRIOR ART for incident learning loop |
| REF-12 | TMS (Doyle 1979) / ATMS (de Kleer 1986) | Dependency-based belief revision; assurance impact propagation | CONCEPTUAL PRIOR ART for SH-001 |
| REF-13 | Temporal / DBOS documentation | Explicit: replay re-executes LLM → different output | CLARIFICATION (semantic recovery is NOT solved by replay) |
| REF-14 | LangChain $47K incident, Claude $50K incident | Cost explosion evidence; supports circuit breakers (not SAGR) | EVIDENCE (weakened CCP urgency claim) |

---

## 59. Master CCP → Origin Matrix

**[SOURCE: implementation evidence, research corpus, decision registry]**

Each CCP component mapped to the idea or reference that originated it.

| CCP Component | Origin | Type of origin |
|---|---|---|
| Evidence-gated completion | Owner observation (INC-001 precursor) + AIGIS comparison | Internal observation + competitive analysis |
| Fail-closed default | Security principle (general software security) | First principles |
| bash-firewall destructive patterns | GuardFall incident + general security hardening | Incident learning |
| bash-firewall JSON validation (F8-B) | Independent audit finding | Audit → hardening |
| contract_hash mandatory (F8-A) | Audit finding: stale evidence binding possible | Audit → hardening |
| Incident→control→regression loop | Requirements Engineering literature (Cleland-Huang) + owner design | Prior art inspiration + original design |
| Context packs by role | Software engineering principle: role-based access control | First principles adaptation |
| Single source of truth | Software design principle (master data management) | First principles |
| PreCompact state hash | Session compaction problem observation | Owner observation → design |
| STALL_POLICY_LOG.jsonl (R-2) | H-01 unknown (frequency unknown) + need for empirical baseline | Unresolved unknown → instrumentation |
| non_bypass_verify design (R-3) | Residual problem (§42) + no public prior art for open-ended | Open problem → design-first approach |
| SAGR framing (governance of continuation) | Two-corpus research reconciliation | Emergent from research synthesis |

---

## 60. Master Decision Matrix

**[SOURCE: DECISION_REGISTRY.md, F9_OWNER_DECISIONS.md, implicit decisions]**

Complete view of all decisions: active, resolved, and implicit.

| ID | Decision | Type | Phase | Status | Consequence |
|---|---|---|---|---|---|
| ARCH-001 | Project-level installation | Architectural | Pre-F1 | ACTIVE | No global protection; per-project adoption |
| ARCH-002 | SubagentStart context injection (not skills: frontmatter) | Architectural | Pre-F1 | ACTIVE | Explicit injection; undefined behavior avoided |
| ARCH-003 | Canonical evidence path = docs/00_SYSTEM/EVIDENCE_REGISTRY.md | Architectural | Pre-F1 | ACTIVE | All hooks point to same registry |
| ARCH-004 | CONTRACTUAL tasks require evidence; others do not; contract_hash mandatory | Architectural | F2, F8-A | ACTIVE | Clarity on what needs evidence; schema enforced |
| F9-D01 | STALL_POLICY_LOG.jsonl is genuinely empty | Owner gate | Post-F8 | RESOLVED=A | No fabricated events authorized |
| F9-D02 | GuardFall deferred | Owner gate | Post-F8 | RESOLVED=B | GuardFall stays unfixed until concrete trigger |
| F9-D03 | Native lifecycle verification deferred | Owner gate | Post-F8 | RESOLVED=B | Deferred until reproducible failure |
| F9-D04 | F10 not started | Owner gate | Post-F8 | RESOLVED=B | F10 NOT AUTHORIZED |
| F9-D05 | R-2 + R-3 proceed | Owner gate | Post-F8 | RESOLVED=A | R-2 + R-3 authorized; implemented |
| IMPLICIT-1 | No sandbox (no Docker) | Implicit | Pre-F1 | ACCEPTED | bash-firewall as only process boundary |
| IMPLICIT-2 | No circuit breakers | Implicit | Pre-F1 | ACCEPTED | Agent can loop; no max_iterations |
| IMPLICIT-3 | Markdown as data format | Implicit | Pre-F1 | ACCEPTED | Human-readable; no query capability |
| IMPLICIT-4 | Git as trust boundary | Implicit | Pre-F1 | ACCEPTED | Artifact hashes anchored in git |

---

## 61. Master Research → Consequence Matrix

**[SOURCE: research corpus, correction ledger, hypothesis ledger]**

| Research finding | Consequence for CCP |
|---|---|
| Recovery space is commoditized (CH-001..CH-004) | SAGR v1 killed; F9 NOT JUSTIFIED; no recovery engine authorized |
| AIGIS reproduces evidence gate (CH-005) | Differentiator shifted to incident loop + phase discipline |
| Commercial market absent (CH-006) | Internal tool value only; no commercial roadmap |
| State-Aware Runtime is research agenda only (COR-001) | CH-024 partially re-opened; trajectory governance for open-ended still open |
| ae-framework is dry-run only (COR-002) | CCP has no prior art in SDLC-specific assurance; positioning competitor not solver |
| arXiv:2606.31339 covers structured workflows only (R-1) | Residual problem narrows to open-ended agents specifically |
| EFFECT_UNKNOWN concept (VERITAS OS) | Potential future design pattern; not adopted; secondary R-1 finding |
| Refuse + escalate is industry default (R-3 observation) | SH-009: propose+verify vs refuse+escalate is unresolved; R-3 must evaluate |
| GuardFall class false positives | Known vulnerability; deferred F9-D02=B |
| STALL_POLICY frequency is H-01 unknown | R-2 authorized as instrumentation; data collection pending |
| Roger hypothesis is INDETERMINED | No implementation authorized; 3 deltas worth testing after H-01 baseline |
| Semantic recovery ≠ crash recovery (SH-006) | CCP's state hash is for crash recovery only; semantic intention continuity is open |

---

## 62. Master Implementation Matrix

**[SOURCE: ARTIFACT_MANIFEST.md, EVIDENCE_REGISTRY.md, implementation catalog §33]**

Compact view: implemented = has verified evidence + is in runtime.

| Component | Implemented | Verified | In runtime | Notes |
|---|---|---|---|---|
| bash-firewall.sh | YES | YES (EV-009, EV-016) | YES | P0 fail-closed |
| secret-guard.sh | YES | YES (EV-003) | YES | P0 fail-closed |
| task-completed-evidence.sh | YES | YES (EV-002, EV-015) | YES | P0 fail-closed |
| session-start-startup.sh | YES | YES (EV-001) | YES | P1 fail-open |
| session-start-compact.sh | YES | YES (EV-007) | YES | P1 fail-open |
| pre-compact-snapshot.sh | YES | YES (EV-007) | YES | P1 fail-open |
| stop-logger.sh | YES | YES (EV-010) | YES | P2 fail-open |
| subagent-context.sh | YES | YES (EV-001) | YES | P2 fail-open |
| stall-record.sh | YES | YES (R-2 harness) | YES (passive) | Non-gating; observation only |
| Skills suite | YES | YES (EV-005) | YES (agent-invoked) | — |
| Context packs | YES | YES (EV-001) | YES | — |
| evals/maintenance.sh | YES | YES (EV-011) | YES (CI + manual) | 12 checks |
| install.sh | YES | YES (EV-014) | YES | — |
| GitHub Actions | YES | — | YES (cloud CI) | — |

---

## 63. Master Non-Implementation Matrix

**[SOURCE: F9_RESEARCH.md, MASTER_IMPLEMENTATION_PLAN.md §Gaps, 42_PROBLEMA_RESIDUAL.md]**

Components that were researched, designed, or proposed but NOT implemented.

| Component | Design exists? | Why not implemented | Gate to authorize |
|---|---|---|---|
| non_bypass_verify() | YES (R-3 design) | DESIGN ONLY; tractability unverified | R-3 empirical test + H-01 baseline |
| generate_alternative() | NO (problem defined) | No prior art for open-ended; requires design first | R-3 design + H-01 baseline + F10 gate |
| SAGR recovery engine | NO | Recovery commoditized; governance framing still at design | R-2 data + R-3 results + F10 gate |
| Circuit breakers | NO | Not in F1-F8 scope; no incident requiring it | Concrete incident or explicit F10 authorization |
| Docker sandbox | NO | Architectural choice; bash-firewall as only boundary | Owner decision; significant scope change |
| Policy-gap analyzer (P12) | NO | No prior art; not in scope | Research + design phase |
| Side-effect ledger (P20) | NO | Partial prior art; not in scope | Research + design phase |
| Assurance impact propagation (SH-001) | NO (conceptual only) | TMS/ATMS prior art but no agent design | Design + prototype + evidence |
| EFFECT_UNKNOWN state | NO | Secondary R-1 finding; not in scope | Owner decision + design |

---

## 64. Master Knowledge Status Matrix

**[SOURCE: All preceding sections; reconciliation synthesis]**

Final status of every major knowledge domain.

| Domain | Status | Evidence | Notes |
|---|---|---|---|
| Loop detection | [CLOSED — commoditized] | Research corpus | loopless, FutureAGI, IAL-Scan |
| Checkpoint / rollback | [CLOSED — commoditized] | Research corpus | Temporal, DBOS, LangGraph |
| Evidence-gated completion | [IMPLEMENTED / FROZEN] | EV-002, EV-015 | AIGIS co-implements; not unique |
| Fail-closed default | [IMPLEMENTED / VERIFIED] | EV-009, EV-016, POST_F8_AUDIT | P0 hooks; independent audit |
| Incident learning loop | [IMPLEMENTED — PARTIAL USE] | EV-006 | 1 incident; loop operational |
| Context pack injection | [IMPLEMENTED] | EV-001 | ARCH-002; 6 packs |
| State management | [IMPLEMENTED] | EV-007 | Hash + recovery |
| Security firewall | [IMPLEMENTED / FROZEN] | EV-009, EV-016 | GuardFall class deferred |
| SAGR v1 (recovery) | [REFUTED] | Reconciliation | CH-001..CH-004, CH-014 killed |
| SAGR v2 (governance of continuation) | [DESIGN / PARTIALLY SUPPORTED] | CCP_RESEARCH_CONTEXT_MASTER | SH-007 SUPPORTED |
| SAGR v3 (field validation gate) | [INSTRUMENTED] | 48_R2_INSTRUMENTATION | R-2 delivered; data collection pending |
| generate_alternative | [OPEN — no open-ended implementation] | 47_PRIOR_ART_VERIFICATION | Structured exists; open-ended does not |
| non_bypass_verify | [DESIGN ONLY] | 50_R3_NON_BYPASS_VERIFY_DESIGN | R-3 designed; not implemented |
| STALL_POLICY frequency | [UNKNOWN] | STALL_POLICY_LOG.jsonl (empty) | H-01; R-2 operational |
| Commercial market | [REFUTED] | Round 0 investigation | No WTP, no buyers, no pilots |
| Semantic continuity | [OPEN — unsolved at scale] | SH-006 SUPPORTED | Replay ≠ semantic recovery |
| GuardFall false positives | [KNOWN / DEFERRED] | F9-D02=B | Concrete trigger needed |
| F10-F12 | [NOT AUTHORIZED] | PROJECT_STATE | Waiting for H-01 data + R-3 results |
| Roger hypothesis | [INDETERMINED / tendency REFORMULATION] | 52_ROGER_HYPOTHESIS_POST_AUDIT | 3 deltas testable after H-01 |

---

## 65. Final Knowledge Graph

**[SOURCE: All preceding sections; synthesized from complete atlas]**

A graph representation of the core knowledge topology of the Claude Control Plane.

```
                         CCP KNOWLEDGE GRAPH
══════════════════════════════════════════════════════════════════

  ┌──────────────────────────────────────────────────────────┐
  │                    CORE INVARIANTS                       │
  │  • Evidence-before-completion (verified, frozen)        │
  │  • Fail-closed for P0 hooks (verified, frozen)          │
  │  • STALL ≠ PERMISSION TO BYPASS SAFETY (invariant)      │
  │  • Single source of truth per state type (active)       │
  └──────────────────────────────────────────────────────────┘
                              │
             ┌────────────────┼────────────────┐
             ▼                ▼                ▼
  ┌────────────────┐ ┌─────────────────┐ ┌──────────────────┐
  │   IMPLEMENTED  │ │   RESEARCHED    │ │   OPEN / UNKNOWN │
  │                │ │   (NOT IMPL.)   │ │                  │
  │  bash-firewall │ │  SAGR v1 (dead) │ │  H-01 frequency  │
  │  secret-guard  │ │  SAGR v2 design │ │  H-04 nBV tractab│
  │  evidence gate │ │  R-3 nBV design │ │  GuardFall fix   │
  │  INC→CTRL→REG  │ │  Roger (indet.) │ │  F10 auth.       │
  │  context packs │ │  SH-001..SH-009 │ │  Semantic contin.│
  │  state hash    │ │  (hypotheses)   │ │  gen_alternative │
  │  R-2 observe   │ │  CH-001..CH-025 │ │                  │
  └────────────────┘ │  (25 killed)    │ └──────────────────┘
                     └─────────────────┘

══════════════════════════════════════════════════════════════════

  LINEAGE GRAPH — Core path from problem to current state

  Owner observes agent behavior problems
         │
         ▼
  F0: Bootstrap decision (install CCP at project level)
         │
         ▼
  F1: Infrastructure (firewall, state injection, context packs)
         │
         ▼
  F2: Evidence gate (fail-closed completion)
         │
         ▼
  F3: Skill suite (operational commands)
         │
         ▼
  F4: Incident loop (INC-001 → CTRL-001 → REG-001)
         │
         ▼
  F5: Context compaction recovery
         │
         ▼
  F6: Checkpoint + state tracking
         │
         ▼
  F7: Hardening, logging, CI/CD, installer
         │
         ▼
  F8: Independent audit + contract_hash + JSON firewall
         │
         ▼
  F9: Research → NOT JUSTIFIED
         │
         ▼
  Post-F8 Research: SAGR reformulation → governance of continuation
         │
         ├──► R-1: Prior art verification → residual SURVIVES
         │
         ├──► R-2: STALL_POLICY instrumentation → OPERATIONAL (empty)
         │
         └──► R-3: non_bypass_verify design → DESIGN ONLY
                          │
                          ▼
                   CURRENT FRONTIER
                   (Waiting for H-01 data)

══════════════════════════════════════════════════════════════════

  COMPETITIVE POSITION

  CCP                        AIGIS
  ─────────────────────      ──────────────────────
  Evidence gate ✓            Evidence gate ✓ (deeper)
  Incident loop ✓            Incident loop ✗
  Phase discipline ✓         Phase discipline ✗
  Governance of cont. ✓ (D)  Governance of cont. ✗
  Docker sandbox ✗           Docker sandbox ✓
  Circuit breakers ✗         Circuit breakers ✓
  Structured ToolRequest ✗   Structured ToolRequest ✓

  Legend: ✓ = implemented/present; ✗ = absent; (D) = designed only

══════════════════════════════════════════════════════════════════

  RESIDUAL PROBLEM (minimum statement)

  An agent blocked by policy P,
  that could achieve goal O with alternative A',
  must propose A' AND demonstrate A' doesn't bypass P's intent,
  WITHOUT workflow pre-compilation,
  for OPEN-ENDED agents.

  Status: SURVIVES R-1 verification. No public implementation.
  Next: R-2 baseline (frequency) → R-3 empirical test (tractability)
        → F10 authorization gate (if both pass simultaneously)

══════════════════════════════════════════════════════════════════
```

---

## 66. Current Truth State

**[SOURCE: PROJECT_STATE.md, all evidence, full atlas]**

This is the authoritative summary of what is true as of the atlas generation date (2026-09-22).

### Facts (Verified — can be demonstrated from artifacts)

| Fact | Source | Verification |
|---|---|---|
| CCP F1-F8 is complete and frozen | PROJECT_STATE.PHASE_STATUS=COMPLETE | POST_F8_AUDIT_REPORT.md |
| Three P0 hooks are operational and fail-closed | settings.json + hook files + audit | EV-009, EV-015, EV-016 |
| Evidence gate requires contract_hash since F8-A | task-completed-evidence.sh | EV-015 |
| evals/maintenance.sh passes 12/12 checks | evals/maintenance.sh | EV-011 + R-2 post-change verification |
| STALL_POLICY_LOG.jsonl is empty | wc -l STALL_POLICY_LOG.jsonl = 0 | Direct file verification |
| INC-001 → CTRL-001 → REG-001 is the only canonical incident | INCIDENT_REGISTRY.md | EV-006 |
| F9 is NOT JUSTIFIED | F9_RESEARCH.md + F9_OWNER_DECISIONS.md | PROJECT_STATE.NEXT_ALLOWED_PHASE |
| R-2 is implemented (instrumentation only; observation only) | stall-record.sh + hook modifications | 48_R2_INSTRUMENTATION.md |
| R-3 non_bypass_verify is a DESIGN ONLY (no code) | 50_R3_NON_BYPASS_VERIFY_DESIGN.md | File existence + content |
| GuardFall class is unmitigated | bash-firewall.sh + F9-D02=B | Deferred decision |
| AIGIS reproduces evidence gate architecture | AIGIS teardown (commit e095eb6, 234 tests) | 035a573 commit |
| The residual problem survives R-1 prior art verification | 47_PRIOR_ART_VERIFICATION.md | All 4 candidates fail closure criteria |

### Supported Hypotheses (Evidence exists but not definitive proof)

| Hypothesis | Support | Confidence |
|---|---|---|
| Incident learning loop is a differentiator vs AIGIS | AIGIS teardown shows no incident→control→regression primitive | HIGH (partial) |
| Governance of continuation is the right SAGR framing | Both research corpora converge on this | HIGH |
| generate_alternative for open-ended agents has no public implementation | R-1 verification: all 4 candidates fail | HIGH (with caveat: structured exists) |
| Semantic continuity across execution boundaries is unsolved at scale | Temporal/DBOS docs explicitly confirm | HIGH |

### Open (Genuinely Unknown)

| Unknown | Gate |
|---|---|
| STALL_POLICY frequency in real CCP usage | R-2 N-day observation window (operational; needs usage) |
| Whether non_bypass_verify is tractable | R-3 empirical test (design exists; test not run) |
| Whether F10 is warranted | Both H-01 and H-04 must resolve simultaneously |
| Whether Roger hypothesis has empirical basis | After H-01 baseline; no test designed |
| Whether GuardFall causes real production problems | After concrete trigger (F9-D02=B) |
| F10-F12 scope | After F10 authorization (NOT AUTHORIZED) |

### NOT True (Refuted — verified against primary sources)

| Claim | Refuted by |
|---|---|
| SAGR = recovery architecture | Both corpora; recovery commoditized |
| CCP evidence gate is unique | AIGIS teardown |
| Commercial market for SAGR standalone | Round 0: no WTP |
| State-Aware Runtime v4 implements trajectory governance | R-1: research agenda only |
| ae-framework is CCP prior art | R-1: dry-run only |
| VERITAS OS has operational EFFECT_UNKNOWN | R-1: beta PoC |
| "3 cases in 4 weeks" is a valid statistical baseline | No rubric, no denominator |
| Durable execution solves semantic recovery | Temporal/DBOS docs; consensus |
| generate_alternative has NO implementation anywhere | PolicyGuide/SafeAgent cover structured workflows |

### Operational Status (as of 2026-09-22)

```
CURRENT_PHASE:          8
PHASE_STATUS:           COMPLETE
NEXT_ALLOWED_PHASE:     None auto (owner decision required for F10)
IMPLEMENTATION_READY:   false
LAST_GIT_CHECKPOINT:    3336bd6
STALL_POLICY_LOG:       OPERATIONAL / EMPTY
NON_BYPASS_VERIFY:      DESIGN ONLY / NOT IMPLEMENTED
SAGR:                   NOT AUTHORIZED
F10-F12:                NOT AUTHORIZED
R-2:                    DELIVERED / COLLECTING (no data yet)
R-3:                    DELIVERED (design only)
MAINTENANCE:            12/12 PASS
```

---

*End of CCP Research & Architectural Knowledge Atlas*
*Generated: 2026-09-22*
*Sections: §1–§66 complete*
*Classification schema: [FACT] [DOCUMENTED FACT] [AUDITED FACT] [INFERENCE] [HYPOTHESIS] [DESIGN] [IMPLEMENTED] [FROZEN] [REJECTED] [REFUTED] [HISTORICAL] [OPEN] [UNKNOWN] [NOT AUTHORIZED]*
