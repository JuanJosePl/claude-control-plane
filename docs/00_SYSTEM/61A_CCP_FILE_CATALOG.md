# 61A — CCP File Catalog

**Created:** 2026-09-23  
**Purpose:** Maps every meaningful file in the repository. For the journey narrative, see 61_CCP_COMPLETE_HANDOFF.md.

---

## Legend

- **SOT** = Source of Truth (do not have a duplicate)
- **FROZEN** = no modifications permitted
- **ACTIVE** = living document, updated as work proceeds
- **RESEARCH** = research artifact, not a runtime control
- **PROTOTYPE** = experimental, not production

---

## Core Governance (Runtime Truth)

| File | Purpose | SOT? | Status | Last Changed |
|---|---|---|---|---|
| `PROJECT_STATE.md` | Phase, objective, blockers, checkpoint | SOT: operational state | ACTIVE | M007 |
| `ARTIFACT_MANIFEST.md` | Phase deliverables (✔/⏳/✗) | SOT: delivery contract | ACTIVE | F8 |
| `DECISION_REGISTRY.md` | ARCH-001..004 decisions | SOT: decisions | ACTIVE (append only) | F8-A addendum |
| `INCIDENT_REGISTRY.md` | Open/closed incidents | SOT: incidents | ACTIVE (append only) | F4 |
| `CONTROL_REGISTRY.md` | Controls linked to incidents | SOT: controls | ACTIVE (append only) | F4 |
| `REGRESSION_REGISTRY.md` | Regression fixtures by incident | SOT: regressions | ACTIVE (append only) | F4 |
| `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | 16 verified evidence entries | SOT: evidence | ACTIVE (append only) | F8 (EV-016) |

---

## Documentation

| File | Purpose | Status |
|---|---|---|
| `README.md` | Entry point; high-level description | ACTIVE |
| `docs/DESIGN.md` | Architecture layers, schemas, scope matrix | ACTIVE |
| `docs/MASTER_IMPLEMENTATION_PLAN.md` | Original contract; F0 audit; KEEP/REFACTOR/BUILD | FROZEN (reference only) |
| `docs/CONTROL_PLANE_HANDBOOK.md` | Operational handbook; §12 reviewer convention; §12 escalation path | ACTIVE |
| `docs/MASTER_EVOLUTION_ROADMAP.md` | F7 IMPLEMENTED/VERIFIED; ARCH-004 active | ACTIVE |

---

## System Documents (docs/00_SYSTEM/)

| File | Purpose | Status |
|---|---|---|
| `CCP_EXPLORATION_ENGINE.md` | Navigation mechanism for research; position, frontier, routes, movements | ACTIVE (v1.5) |
| `EVIDENCE_REGISTRY.md` | (listed above) | — |
| `CLAUDE_SESSION_LOG.md` | Per-session activity log (auto-rotated daily) | ACTIVE |
| `SESSION_HANDOFF_CURRENT.md` | Canonical current handoff (pre-M007) | SUPERSEDED by 61_* |
| `F7_F8_F9_TECHNICAL_HISTORY.md` | Technical history dossier F7/F8/F9 | FROZEN (reference) |
| `F7_FULL_AUDIT_HANDOFF.md` | F7 complete audit record | FROZEN |
| `F7_CLAIM_VS_EVIDENCE.md` | F7 claim verification matrix | FROZEN |
| `F8_CLAIM_VS_EVIDENCE.md` | F8 claim verification matrix | FROZEN |
| `F8_RESEARCH.md` | F8 research findings | FROZEN |
| `F9_RESEARCH.md` | F9 research; F9 NOT JUSTIFIED conclusion | FROZEN |
| `F9_OWNER_DECISIONS.md` | F9-D01=A..F9-D05=A record | FROZEN |
| `BEHAVIORAL_RELIABILITY_AUDIT.md` | Post-F6 behavioral audit; 11 bugs found | FROZEN |
| `POST_F6_AUDIT_REPORT.md` | Formal F6 audit consolidation | FROZEN |
| `POST_F7_AUDIT_REPORT.md` | F7 post-phase audit | FROZEN |
| `POST_F8_AUDIT_REPORT.md` | F8 post-phase audit | FROZEN |
| `CHANGE_PROVENANCE_F7.md` | File-by-file F7 change record | FROZEN |
| `CHANGE_PROVENANCE_F8.md` | File-by-file F8 change record | FROZEN |
| `F7_F12_RESEARCH_HANDOFF.md` | F7-F12 research handoff (pre-MOVEMENT era) | FROZEN |
| `CCP_COMPLETE_CONCEPTUAL_MAP.md` | Conceptual map created in M007 era | FROZEN |
| `CCP_RESEARCH_ARCHITECTURAL_KNOWLEDGE_ATLAS.md` | Research knowledge atlas | FROZEN |
| `STALL_POLICY_LOG.jsonl` | R-2 instrumentation output (3 events: 1 test, 2 FP) | ACTIVE (append only) |
| `query-log.sh` | H-01 monitoring tool (created M007) | ACTIVE |
| `MAP_COMPLETE.md` | (root) Complete narrative map | RESEARCH |
| `archive/CLAUDE_SESSION_LOG.*.md` | Archived session logs | FROZEN |

---

## Context Packs (.claude/context/)

| File | Purpose | Status |
|---|---|---|
| `CORE.md` | Project identity, stack, fundamental rules | ACTIVE |
| `CURRENT_STATE.md` | Mirror of PROJECT_STATE.md (updated by /cerrar-fase) | ACTIVE |
| `DECISIONS.md` | Compact active decisions (ARCH-001..004) | ACTIVE |
| `SECURITY_RULES.md` | Non-negotiable security constraints | ACTIVE |
| `BUSINESS.md` | Commercial constraints and legal rules | ACTIVE |
| `NO_GO.md` | Prohibited anti-patterns | ACTIVE |

---

## Hooks (.claude/hooks/)

| File | Priority | Purpose | Status |
|---|---|---|---|
| `bash-firewall.sh` | P0 | Block dangerous shell commands (fail-closed) | ACTIVE + HARDENED (F7/F8-B) |
| `secret-guard.sh` | P0 | Prevent secret exposure | ACTIVE |
| `task-completed-evidence.sh` | P0 | Evidence gate (fail-closed; contract_hash required) | ACTIVE + FAIL-CLOSED (F8-A) |
| `subagent-context.sh` | P1 | Role-based context injection at SubagentStart | ACTIVE |
| `session-start.sh` | P2 | State drift detection | ACTIVE |
| `pre-compact.sh` | P2 | Critical field hashing before compaction | ACTIVE |
| `session-log.sh` | P3 | Session activity logging | ACTIVE |
| `stall-record.sh` | P3 | STALL_POLICY event recording | ACTIVE (added M007) |
| `lib/` | — | Hook shared library functions | ACTIVE (added M007) |

---

## Agents (.claude/agents/)

| File | Role | Status |
|---|---|---|
| `researcher.md` | Research; web search; no code writes | ACTIVE |
| `architect.md` | Architecture design; writes to docs/ only | ACTIVE |
| `implementer.md` | Code implementation; limited tool access | ACTIVE |
| `code-reviewer.md` | Independent review; read-only | ACTIVE |
| `security-auditor.md` | OWASP + project rules audit; read-only | ACTIVE |

---

## Skills (.claude/skills/)

Context skills (invoked by hooks):
- context-core, context-current-state, context-decisions, context-security, context-business, context-no-go

Process/verification skills (user-invocable):
- estado, gate, cerrar-fase, doctor, recovery, evidence, incident, checkpoint, constraint-driven-development, code-review-and-quality, doubt-driven-development, test-driven-development, audit-config, audit-context, context-core, context-decisions, no-go, security-review, find-skills, adr, graphify, and others

---

## Research Documents (docs/research/)

### docs/research/CCP_FINAL_RECONCILIATION/ (primary research corpus)

| File | Movement | Purpose |
|---|---|---|
| `39_CONCILIACION_DE_INVESTIGACIONES.md` | Pre-M001 | Research reconciliation |
| `40..45_*.md` | Pre-M001 | Problem analysis, architecture, decisions |
| `46_FINAL_RECONCILIATION.md` | Pre-M001 | Final reconciliation document |
| `47_PRIOR_ART_VERIFICATION.md` | Pre-M001 | R-1: 4 prior art candidates closed |
| `48_R2_INSTRUMENTATION.md` | Pre-M001 | R-2 instrumentation design |
| `49_R2_POST_AUDIT.md` | Pre-M001 | R-2 audit |
| `50_R3_NON_BYPASS_VERIFY_DESIGN.md` | Pre-M001 | R-3 design |
| `51_R3_POST_AUDIT.md` | Pre-M001 | R-3 audit |
| `52_ROGER_HYPOTHESIS_POST_AUDIT.md` | Pre-M001 | Roger hypothesis audit |
| `53_R3_EMPIRICAL_TEST.md` | M001 | 9-case R-3 empirical test (PARTIALLY_TRACTABLE) |
| `54_MOVEMENT_002_FRONTIER_RESOLUTION.md` | M002 | Policy corpus analysis; bottleneck identification |
| `55_CDT01_NH02_RESULTS.md` | M003 | CDT-01 (87.5% SAFE); NH-02 (75-80% coverage) |
| `56_MOVEMENT_003_MASTER_FRONTIER_CLOSURE.md` | M003 | NH-04, bypass taxonomy, READY-01/02/03 structure |
| `57_MOVEMENT_004_FRONTIER_INTEGRATION.md` | M004 | NH-05/06/07/09/10; L1-C conditions; READY packages |
| `58_OWNER_DECISION_PACKAGE.md` | M005/M006 | READY-01..04 consolidated decision packages |
| `58A_NH09_SEMANTIC_VALIDATION.md` | M005 | UNK-M4-01: NH-09 = SAFE_NORMALIZATION |
| `59_PRE_AUTHORIZATION_ADVERSARIAL_GATE.md` | M006 | Adversarial audit of READY-01..04 |
| `59A_EXECUTION_REHEARSAL.md` | M006 | Exact implementation plans for READY-01..04 |
| `60_FRONTIER_BREAKOUT.md` | M007 | PAC prototype results; P1'/P2' spec; new tracks |
| `60A_IDEA_PORTFOLIO.md` | M007 | 17-idea portfolio; N=1 threshold derivation |

### docs/research/pac/ (PAC prototype)

| File | Purpose |
|---|---|
| `ccp_policies.yaml` | 13 policies in YAML format (incomplete — 25 total in corpus) |
| `pac_compiler.py` | Policy→pattern compiler; zero drift detected |
| `pac_results.md` | Compilation results and analysis |

### docs/research/ (other)

| File | Purpose |
|---|---|
| `RESEARCH_CLAUDE.md` | Initial Claude research source |
| `RESEARCH_CHATGPT.md` | Initial ChatGPT research source |
| `CCP_SAGR_RESEARCH_DOSSIER.md` | SAGR methodology dossier |
| `CCP_RESEARCH_CONTEXT_MASTER.md` | Research context master document |
| Various market validation docs | Commercial viability research (H-03; not prioritized) |

---

## Evals

| File/Dir | Purpose | Status |
|---|---|---|
| `evals/maintenance.sh` | 12-diagnostic health check (must pass 12/12) | ACTIVE |
| `evals/skills/` | Skills eval fixtures and validator | ACTIVE |
| `evals/r2/` | R-2 instrumentation test environment | RESEARCH |

---

## Infrastructure

| File | Purpose |
|---|---|
| `install.sh` | Idempotent installer (--force flag; settings validation) |
| `.claude/settings.json` | Permissions, hooks, MCP wiring |
| `.claude/settings.local.json` | Local overrides (not committed) |
| `.github/workflows/` | CI workflow |
| `templates/` | Registry templates for new projects |
| `CLAUDE.md` | Project-level instructions (load order, rules) |
| `.claude/rules/` | Moduler rules: compliance.md, security.md, git-policy.md, no-go.md |

---

## This Handoff (docs/00_SYSTEM/61*)

| File | Purpose |
|---|---|
| `61_CCP_COMPLETE_HANDOFF.md` | Complete journey narrative + onboarding guide |
| `61A_CCP_FILE_CATALOG.md` | This file: all files with purpose and status |
| `61B_CCP_JOURNEY_MAP.md` | Labyrinth/graph view of the research journey |
| `61C_CCP_DECISION_AND_AUTHORIZATION_HISTORY.md` | All decisions with full context |
| `61D_CCP_EVIDENCE_LINEAGE.md` | Evidence lineage with claim/source/limitation |
| `61G_CCP_CONTINUATION_GUIDE.md` | Exact next actions and execution guide |

---

## Dependency Graph (Simplified)

```
MASTER_IMPLEMENTATION_PLAN
      ↓ contracts
PROJECT_STATE (operational authority)
      ↓ drives
EXPLORATION ENGINE (research navigation)
      ↓ produces
MOVEMENT DOCUMENTS (53..60)
      ↓ generate
OWNER DECISION PACKAGES (58_)
      ↓ await
OWNER AUTHORIZATION
      ↓ enables
EVIDENCE + IMPLEMENTATION
      ↓ verified by
EVIDENCE REGISTRY
      ↓ checked by
MAINTENANCE SUITE
```

```
DESIGN.md → architecture authority
DECISION_REGISTRY → structural decisions
INCIDENT/CONTROL/REGRESSION REGISTRIES → incident learning chain
HOOKS → enforcement (depends on settings.json)
AGENTS → execution (context injected by subagent-context.sh)
```
