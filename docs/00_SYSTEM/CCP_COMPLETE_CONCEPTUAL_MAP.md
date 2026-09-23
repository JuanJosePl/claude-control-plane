# CCP_COMPLETE_CONCEPTUAL_MAP

> **Document type:** Read-only conceptual map — describes the system as it exists.  
> **Source of truth hierarchy:** actual runtime/source code > current state > audited artifact > research artifact > historical document > hypothesis  
> **Status tags used throughout:**
> - `[IMPLEMENTED]` — verifiable in current source code / runtime
> - `[DESIGNED]` — architecture document exists; no runtime implementation
> - `[RESEARCH]` — research artifact exists; not a system property
> - `[HYPOTHESIS]` — speculative or untested claim
> - `[HISTORICAL]` — was true in an earlier phase; superseded
> - `[OPEN]` — unresolved question or gap
> - `[UNKNOWN]` — insufficient evidence to classify
> - `[NOT AUTHORIZED]` — explicitly prohibited by owner decision or gate
>
> **Hard constraint:** This document maps concepts. It does not implement, authorize, or enable anything.  
> **Generated:** 2026-09-22 | **Phase:** F8 COMPLETE | **F9:** NOT JUSTIFIED | **F10-F12:** UNKNOWN

---

## TABLE OF CONTENTS

1. [Executive Overview](#1-executive-overview)
2. [What CCP Is](#2-what-ccp-is)
3. [Why CCP Exists](#3-why-ccp-exists)
4. [Core Principles](#4-core-principles)
5. [Current System Boundary](#5-current-system-boundary)
6. [Repository Topology](#6-repository-topology)
7. [Complete File Inventory](#7-complete-file-inventory)
8. [Architecture Layers](#8-architecture-layers)
9. [Layer Model](#9-layer-model)
10. [Component Model](#10-component-model)
11. [Hook Architecture](#11-hook-architecture)
12. [Skill Architecture](#12-skill-architecture)
13. [Registry Architecture](#13-registry-architecture)
14. [State Model](#14-state-model)
15. [Data and Entity Model](#15-data-and-entity-model)
16. [Evidence Model](#16-evidence-model)
17. [DONE / TaskCompleted Model](#17-done--taskcompleted-model)
18. [Firewall Model](#18-firewall-model)
19. [Security Model](#19-security-model)
20. [Authority Model](#20-authority-model)
21. [Trust Boundaries](#21-trust-boundaries)
22. [Dependency Model](#22-dependency-model)
23. [History and Reversibility Model](#23-history-and-reversibility-model)
24. [Incident to Control to Regression Loop](#24-incident-to-control-to-regression-loop)
25. [R2 Observation Model](#25-r2-observation-model)
26. [R3 Non-Bypass-Verify Design](#26-r3-non-bypass-verify-design)
27. [Research Artifacts 39-52](#27-research-artifacts-3952)
28. [Hypothesis Evolution](#28-hypothesis-evolution)
29. [Killed Hypotheses](#29-killed-hypotheses)
30. [Surviving Concepts](#30-surviving-concepts)
31. [Roger Hypothesis](#31-roger-hypothesis)
32. [Open Questions](#32-open-questions)
33. [F1-F8 State](#33-f1f8-state)
34. [F9 / F10 State](#34-f9--f10-state)
35. [Tests and Evaluation Model](#35-tests-and-evaluation-model)
36. [Audit Model](#36-audit-model)
37. [Control to Threat Matrix](#37-control-to-threat-matrix)
38. [Component to Function to File Matrix](#38-component-to-function-to-file-matrix)
39. [File to Meaning Matrix](#39-file-to-meaning-matrix)
40. [Concept to Reality Matrix](#40-concept-to-reality-matrix)
41. [End-to-End Flows A-H](#41-end-to-end-flows-ah)
42. [New Engineer Orientation](#42-new-engineer-orientation)
43. [Rebuild Conceptual Model](#43-rebuild-conceptual-model)
44. [Known Gaps](#44-known-gaps)
45. [Known Unknowns](#45-known-unknowns)
46. [Frozen Boundaries](#46-frozen-boundaries)
47. [Final System Blueprint](#47-final-system-blueprint)
48. [Current Truth State](#48-current-truth-state)

---

## 1. Executive Overview

**[IMPLEMENTED]** The Claude Control Plane (CCP) is a governance and observability layer for AI-agent-driven software development. It is deployed as a `.claude/` directory tree inside any target repository and is activated by Claude Code's native hook system.

CCP enforces three guarantees:

| Guarantee | Mechanism | Status |
|-----------|-----------|--------|
| Evidence before task completion | `task-completed-evidence.sh` (P0, fail-closed) | `[IMPLEMENTED]` |
| No destructive / secret commands | `bash-firewall.sh` + `secret-guard.sh` (P0, fail-closed) | `[IMPLEMENTED]` |
| Reproducible session context | 6 context packs + startup hook | `[IMPLEMENTED]` |

CCP is self-describing: it was built using the same methodology it imposes. It is also distributable: `install.sh` deploys it to any target project.

**Current frozen state:** F8 COMPLETE. F9 research closed (NOT JUSTIFIED). F10-F12 UNKNOWN / NOT AUTHORIZED.

**Lines of code vs. governance weight:** The CCP is approximately 2,000 lines of bash + markdown. Its governance weight — defined by the evidence contract, incident learning loop, and phase-gate methodology — is the primary product.

---

## 2. What CCP Is

**[IMPLEMENTED]** CCP is meta-infrastructure: infrastructure that governs the infrastructure that builds product.

| Dimension | Description |
|-----------|-------------|
| **What it installs** | `.claude/` directory with hooks, skills, agents, rules, context packs |
| **What it enforces** | Evidence gate on task completion; firewall on bash commands; secret guard on file writes |
| **What it provides** | Operational state (PROJECT_STATE.md); decision audit trail (DECISION_REGISTRY.md); incident learning loop |
| **What it does NOT do** | Write product code; manage deployments; interface with databases; send messages externally |
| **What it cannot do** | Enforce its own hooks without Claude Code's native hook dispatch; verify native Claude Code lifecycle (UNKNOWN) |

CCP is both a **specific instance** (the `claude-control-plane` repository itself, which has been through F0-F8) and a **distributable template** (the `install.sh` script deploys a structurally identical setup to a target project).

The context packs (`CORE.md`, `BUSINESS.md`, etc.) that exist in this repository contain template placeholders (`{{PROJECT_NAME}}`, etc.) — they are designed for target deployments, not for CCP itself.

---

## 3. Why CCP Exists

**[HISTORICAL -> IMPLEMENTED]** The need emerged from an incident:

> **INC-001:** Task completion was not enforcement-gated before Phase F2. Claude could mark a task done without providing verifiable evidence. The root cause was a missing test for the evidence hook. The control response was CTRL-001 (task-completed-evidence.sh). The regression suite expanded to 11 tests.

Beyond INC-001, CCP addresses a class of systematic risks in AI-agent development:

1. **Invisible progress** — AI agents report completion without verifiable output
2. **Secret exposure** — AI agents generate or write secrets into files
3. **Destructive commands** — AI agents issue destructive filesystem or database commands
4. **Context drift** — After session compaction, agents resume without current state
5. **Decision fog** — Architectural decisions made verbally in chat, never recorded
6. **Phase creep** — New phases opened before previous ones are verified closed

CCP's response to each:

| Risk | CCP Control | Classification |
|------|-------------|----------------|
| Invisible progress | task-completed-evidence.sh + EVIDENCE_REGISTRY | `[IMPLEMENTED]` |
| Secret exposure | secret-guard.sh + permissions.deny | `[IMPLEMENTED]` |
| Destructive commands | bash-firewall.sh + permissions.ask | `[IMPLEMENTED]` |
| Context drift | session-start-startup.sh + context packs | `[IMPLEMENTED]` |
| Decision fog | DECISION_REGISTRY.md + /evidence skill | `[IMPLEMENTED]` |
| Phase creep | PROJECT_STATE.md + /gate skill | `[IMPLEMENTED]` |

---

## 4. Core Principles

**[IMPLEMENTED]** These principles are present in the implemented system, not merely aspirational.

### 4.1 Fail-Closed Security
P0 hooks exit 2 (block) on any failure, including tool unavailability, malformed input, and missing required files. Security is never degraded silently.

### 4.2 Single Sources of Truth
| Domain | File | Type |
|--------|------|------|
| Operational state | `PROJECT_STATE.md` | Single source of truth |
| Decisions | `DECISION_REGISTRY.md` | Single source of truth |
| Evidence | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | Single source of truth |
| Deliverables | `ARTIFACT_MANIFEST.md` | Single source of truth |

### 4.3 Evidence Before Completion
No CONTRACTUAL TASK may be marked completed without a VERIFIED evidence entry in EVIDENCE_REGISTRY.md with: `task_id`, `artifact_hash` (sha256: + 64 hex), `contract_hash` (sha256: + 64 hex), passing checks, reviewer, non-fabricated exceptions, and ISO-8601 timestamp.

### 4.4 Audit Cycle
Every change follows: `AUDIT -> IMPLEMENT -> TEST -> VERIFY -> EVIDENCE -> GATE`

### 4.5 No Fabrication
Claims that cannot be verified are marked `UNKNOWN` or `BLOCKED`. They are never assumed to be true.

### 4.6 Scope Isolation
CCP installs at the `.claude/` level of a project. It does not modify global Claude Code configuration or the user's shell environment.

### 4.7 Logging Failure Does Not Equal Security Bypass `[IMPLEMENTED]`
The R2 observation helper is called with `|| true`. Security decisions are finalized before the log call. A logging failure cannot weaken security enforcement.

---

## 5. Current System Boundary

**[IMPLEMENTED]** What is in scope and what is not:

### In Scope (Implemented)
- `.claude/hooks/` — 10 hook scripts (11 including stall-record.sh library)
- `.claude/skills/` — 28 skill files
- `.claude/agents/` — 5 agent definitions
- `.claude/rules/` — 4 rule files (compliance, security, git-policy, no-go)
- `.claude/context/` — 6 context pack templates
- `.claude/settings.json` — hook wiring and permissions
- `docs/00_SYSTEM/` — operational registries and evidence
- `DECISION_REGISTRY.md`, `CONTROL_REGISTRY.md`, `INCIDENT_REGISTRY.md`, `REGRESSION_REGISTRY.md` — learning loop
- `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md` — phase-gate state
- `evals/maintenance.sh` — 12-check deterministic evaluation suite
- `.github/workflows/control-plane.yml` — CI gate
- `install.sh` — deployment script

### Out of Scope (Not Implemented / Not Authorized)
- Product code for any specific application
- Database schemas, APIs, or network services
- External webhook integrations
- SAGR (State-Aware Governance of Resumption) — `[RESEARCH]` / `[NOT AUTHORIZED]` for F10
- Non-bypass verification runtime — `[DESIGNED]` (R3); `[NOT AUTHORIZED]` for implementation
- F10, F11, F12 — `[UNKNOWN]` / `[NOT AUTHORIZED]`

---

## 6. Repository Topology

**[IMPLEMENTED]** Verified by direct file system inspection.

```
claude-control-plane/
|-- .claude/
|   |-- agents/               5 agent definitions
|   |-- backups/              State snapshots (pre-compact)
|   |-- context/              6 context pack templates
|   |-- hooks/
|   |   |-- lib/              stall-record.sh (R2 helper)
|   |   |-- bash-firewall.sh
|   |   |-- config-change-logger.sh
|   |   |-- pre-compact-snapshot.sh
|   |   |-- secret-guard.sh
|   |   |-- session-start-compact.sh
|   |   |-- session-start-startup.sh
|   |   |-- stop-logger.sh
|   |   |-- subagent-context.sh
|   |   |-- subagent-stop-logger.sh
|   |   `-- task-completed-evidence.sh
|   |-- rules/                4 rule files
|   |-- skills/               28 skill files
|   `-- settings.json
|-- .github/
|   `-- workflows/
|       `-- control-plane.yml
|-- .history/                 Timestamped snapshots of research artifact evolution
|-- docs/
|   |-- 00_SYSTEM/
|   |   |-- CLAUDE_SESSION_LOG.md
|   |   |-- EVIDENCE_REGISTRY.md
|   |   |-- F9_OWNER_DECISIONS.md
|   |   |-- POST_F8_AUDIT_REPORT.md
|   |   |-- STALL_POLICY_LOG.jsonl
|   |   `-- CCP_COMPLETE_CONCEPTUAL_MAP.md (this file)
|   |-- research/
|   |   |-- CCP_FINAL_RECONCILIATION/  (artifacts 42-52)
|   |   `-- CCP_RESEARCH_CONTEXT_MASTERC.md
|   |-- CONTROL_PLANE_HANDBOOK.md
|   |-- DESIGN.md
|   `-- MASTER_IMPLEMENTATION_PLAN.md
|-- evals/
|   |-- benchmarks/
|   |-- hooks/
|   |-- incidents/
|   |-- install/
|   |-- r2/                   R2 test harness
|   |-- skills/
|   |-- state/
|   `-- maintenance.sh
|-- templates/                Registry and config templates
|-- ARTIFACT_MANIFEST.md
|-- CONTROL_REGISTRY.md
|-- DECISION_REGISTRY.md
|-- INCIDENT_REGISTRY.md
|-- MAP_COMPLETE.md           Narrative journey document (renamed from research.md)
|-- PROJECT_STATE.md
|-- REGRESSION_REGISTRY.md
`-- install.sh
```

---

## 7. Complete File Inventory

**[IMPLEMENTED]** All files verified present at time of mapping.

### 7.1 Hook Files (`.claude/hooks/`)

| File | Priority | Fail Mode | Event |
|------|----------|-----------|-------|
| `bash-firewall.sh` | P0 | FAIL_CLOSED (exit 2) | PreToolUse: Bash |
| `secret-guard.sh` | P0 | FAIL_CLOSED (exit 2) | PreToolUse: Write or Edit |
| `task-completed-evidence.sh` | P0 | FAIL_CLOSED (exit 2) | TaskCompleted |
| `session-start-startup.sh` | P1 | FAIL_OPEN (exit 0) | SessionStart: startup, resume, fork |
| `session-start-compact.sh` | P1 | FAIL_OPEN (exit 0) | SessionStart: compact, clear |
| `config-change-logger.sh` | P1 | FAIL_OPEN (exit 0) | ConfigChange |
| `pre-compact-snapshot.sh` | P1 | FAIL_OPEN (exit 0) | PreCompact |
| `subagent-context.sh` | P2 | FAIL_OPEN (exit 0) | SubagentStart |
| `subagent-stop-logger.sh` | P2 | FAIL_OPEN (exit 0) | SubagentStop |
| `stop-logger.sh` | P2 | FAIL_OPEN (exit 0) | Stop |
| `lib/stall-record.sh` | — | Non-gating (|| true) | Helper; sourced by P0 hooks |

### 7.2 Context Packs (`.claude/context/`)

| File | Audience | Status |
|------|----------|--------|
| `CORE.md` | All agents | `[IMPLEMENTED]` — contains template placeholders for target project |
| `CURRENT_STATE.md` | Architect, Implementer, Code-Reviewer | `[IMPLEMENTED]` — mirrors PROJECT_STATE |
| `DECISIONS.md` | Researcher, Architect, Security-Auditor | `[IMPLEMENTED]` — compact mirror of ARCH-001..ARCH-004 |
| `SECURITY_RULES.md` | Architect, Implementer, Security-Auditor, Code-Reviewer | `[IMPLEMENTED]` — universal rules; project sections template |
| `BUSINESS.md` | Researcher | `[IMPLEMENTED]` — entirely template placeholders |
| `NO_GO.md` | All | `[IMPLEMENTED]` — universal anti-patterns; project sections template |

### 7.3 Agent Definitions (`.claude/agents/`)

| File | Model | Key Tools | Key Restrictions |
|------|-------|-----------|-----------------|
| `architect.md` | claude-opus | Read, Glob, Grep, Write, Edit | No Bash, no WebSearch; permissionMode=plan |
| `researcher.md` | claude-sonnet | Read, Glob, Grep, WebSearch, WebFetch | No Write, no Edit, no Bash |
| `implementer.md` | claude-sonnet | Read, Glob, Grep, Write, Edit, Bash | No WebSearch; permissionMode=acceptEdits |
| `code-reviewer.md` | claude-sonnet | Read, Glob, Grep only | Read-only; fresh context; reports PASS or BLOCKED |
| `security-auditor.md` | claude-sonnet | Read, Glob, Grep only | Read-only |

### 7.4 Rule Files (`.claude/rules/`)

| File | Scope | Key Contents |
|------|-------|-------------|
| `compliance.md` | Global | Consent records; no review gating; opt-in required |
| `security.md` | Global | No secrets in code; parameterized queries; UNKNOWN on doubt |
| `git-policy.md` | Global | Phase-prefixed commits; no push without confirmation; no secrets staged |
| `no-go.md` | Global | Anti-patterns mirror; no cross-tenant; no fabrication |

### 7.5 Registry Files

| File | Entries | Purpose |
|------|---------|---------|
| `DECISION_REGISTRY.md` | ARCH-001..ARCH-004 + F8-A | Architectural decisions with rationale |
| `CONTROL_REGISTRY.md` | CTRL-001 | Active enforcement controls |
| `INCIDENT_REGISTRY.md` | INC-001 | Resolved incidents with root cause and control link |
| `REGRESSION_REGISTRY.md` | REG-001..REG-011 | 11 active regression tests |
| `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | EV-001..EV-016 | Verified task completion evidence |

### 7.6 Key Operational Files

| File | Role |
|------|------|
| `PROJECT_STATE.md` | Single source of operational truth |
| `ARTIFACT_MANIFEST.md` | Phase delivery checklist |
| `docs/DESIGN.md` | Authoritative architecture document |
| `docs/MASTER_IMPLEMENTATION_PLAN.md` | Contract for phase execution |
| `docs/CONTROL_PLANE_HANDBOOK.md` | Operational manual |
| `install.sh` | Deployment script |
| `evals/maintenance.sh` | 12-check evaluation suite |
| `.github/workflows/control-plane.yml` | CI gate |
| `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | R2 observation log |
| `MAP_COMPLETE.md` | Narrative journey document |

### 7.7 Research Artifacts (`docs/research/CCP_FINAL_RECONCILIATION/`)

Artifacts 42-52 (see Section 27 for full detail).

---

## 8. Architecture Layers

**[IMPLEMENTED]** The 6-layer architecture is defined in `docs/DESIGN.md` and verifiable in the implemented system.

```
+--------------------------------------------------+
|  L6: VERIFICATION                                 |
|  Evidence Registry, Maintenance Suite, CI         |
+--------------------------------------------------+
|  L5: EXECUTION                                    |
|  Hooks (P0/P1/P2), Skills, Agents                |
+--------------------------------------------------+
|  L4: CONTROL                                      |
|  Registries, Phase Gate, Audit Cycle              |
+--------------------------------------------------+
|  L3: MEMORY                                       |
|  SESSION_LOG, backups, STALL_POLICY_LOG           |
+--------------------------------------------------+
|  L2: STATE                                        |
|  PROJECT_STATE.md, ARTIFACT_MANIFEST.md           |
+--------------------------------------------------+
|  L1: CONTEXT                                      |
|  Context Packs, Settings.json, Rules              |
+--------------------------------------------------+
```

Note on classification:
- The 6-layer model is `[IMPLEMENTED]` in structure.
- The formal naming ("L1: CONTEXT", etc.) appears in DESIGN.md `[DESIGNED]`.
- The actual implementations of each layer are verified in source code `[IMPLEMENTED]`.

---

## 9. Layer Model

**[IMPLEMENTED]** Detail per layer.

### L1: CONTEXT
Files: `.claude/context/*.md`, `.claude/rules/*.md`, `.claude/settings.json`  
Purpose: Establishes what the agent knows before doing anything.  
Delivery: `SubagentStart` hook injects role-specific context packs. `SessionStart` hook injects current state.  
Key invariant: Context packs are read-only during a session; agents receive them, not modify them.

### L2: STATE
Files: `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md`  
Purpose: Records what phase the project is in, what the current objective is, and what blockers exist.  
Key invariant: PROJECT_STATE.md is the single source of truth for operational state. No phase may open without the previous having PASS status.

### L3: MEMORY
Files: `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`, `.claude/backups/`, `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`  
Purpose: Records session activity, preserves state across compaction, records observation events.  
Key invariant: Logs are append-only. Backups are created before compaction, verified after.

### L4: CONTROL
Files: `DECISION_REGISTRY.md`, `CONTROL_REGISTRY.md`, `INCIDENT_REGISTRY.md`, `REGRESSION_REGISTRY.md`  
Purpose: Governance audit trail. Decisions, controls, incidents, and regressions are first-class entities.  
Key invariant: Controls trace to incidents; regressions trace to controls; decisions trace to rationale.

### L5: EXECUTION
Files: `.claude/hooks/*.sh`, `.claude/skills/`, `.claude/agents/`  
Purpose: The actual enforcement and capability layer.  
Key invariant: P0 hooks are fail-closed. P1/P2 hooks are fail-open. Skills and agents cannot override P0 hooks.

### L6: VERIFICATION
Files: `evals/maintenance.sh`, `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`, `.github/workflows/control-plane.yml`  
Purpose: Deterministic verification that the system is correct.  
Key invariant: Maintenance suite must pass before closing any phase. Evidence entries require VERIFIED status.

---

## 10. Component Model

**[IMPLEMENTED]** Components and their relationships.

```
[PROJECT_STATE.md] <--reads-- [session-start-startup.sh]
        |                              |
        |                              v
        |                    [Agent Session Context]
        |
        v
[ARTIFACT_MANIFEST.md] <--gates-- [/gate skill]
        |
        v
[EVIDENCE_REGISTRY.md] <--validates-- [task-completed-evidence.sh]
        |
        ^
[/evidence skill] --writes--> [EVIDENCE_REGISTRY.md]
        |
[DECISION_REGISTRY.md] <--mirrors-- [DECISIONS context pack]
        |
[INCIDENT_REGISTRY.md] --> [CONTROL_REGISTRY.md] --> [REGRESSION_REGISTRY.md]
                                    |
                        [task-completed-evidence.sh]
                        [bash-firewall.sh]
                        [secret-guard.sh]
```

---

## 11. Hook Architecture

**[IMPLEMENTED]** All 10 hooks (+ 1 library) verified in `.claude/settings.json` and source files.

### 11.1 Hook Wiring (settings.json)

```json
"hooks": {
  "SessionStart": [
    {"matcher": "startup|resume|fork", "hooks": ["session-start-startup.sh"]},
    {"matcher": "compact|clear",       "hooks": ["session-start-compact.sh"]}
  ],
  "PreToolUse": [
    {"matcher": "Bash",        "hooks": ["bash-firewall.sh"]},
    {"matcher": "Write|Edit",  "hooks": ["secret-guard.sh"]}
  ],
  "SubagentStart": [{"hooks": ["subagent-context.sh"]}],
  "SubagentStop":  [{"hooks": ["subagent-stop-logger.sh"]}],
  "Stop":          [{"hooks": ["stop-logger.sh"]}],
  "PreCompact":    [{"hooks": ["pre-compact-snapshot.sh"]}],
  "ConfigChange":  [{"hooks": ["config-change-logger.sh"]}],
  "TaskCompleted": [{"hooks": ["task-completed-evidence.sh"]}]
}
```

### 11.2 bash-firewall.sh (P0, FAIL_CLOSED)

**Purpose:** Block destructive bash commands before execution.  
**Trigger:** PreToolUse on any Bash tool call.  
**Input:** JSON on stdin with `.tool_input.command`.

**Block conditions (exit 2):**
1. Null bytes in stdin
2. `jq` not available
3. Input is not valid single JSON
4. Command matches DESTRUCTIVE_REGEX: `rm -rf /`, `dd if=/dev/zero`, `mkfs.*`, fork bomb, `chmod 777 /`, `chown -R`, `DROP TABLE/DATABASE`, `TRUNCATE TABLE`, `write /dev/sda`
5. Command matches REGEX patterns: secret file reads (.env, .pem, .key), private key reads (~/.ssh, ~/.aws/credentials), `git add` of secret files, curl-pipe-bash supply-chain pattern

**R2 instrumentation:** On pattern match, calls `stall_record_event || true` before exit 2. Security invariant: event logging is non-gating.

**DRY_RUN mode:** `DRY_RUN=true` simulates blocking without actual exit 2 (for testing).

**Flow:**
```
stdin JSON -> null-byte check -> jq parse -> extract .tool_input.command
  -> DESTRUCTIVE_REGEX check -> REGEX check
  -> [MATCH]: stall_record_event || true -> exit 2 (BLOCK)
  -> [NO MATCH]: exit 0 (ALLOW)
```

### 11.3 secret-guard.sh (P0, FAIL_CLOSED)

**Purpose:** Prevent secrets from being written to files.  
**Trigger:** PreToolUse on Write or Edit tool calls.  
**Input:** JSON on stdin with `.tool_input.content` or `.tool_input.new_string`.

**Allow conditions (exit 0):**
- Placeholder patterns: CHANGE_ME, `<your-...>`, example, dummy, placeholder, xxxx+ — unless PEM key is also present

**Block conditions (exit 2):**
- PEM private key header pattern
- API key pattern (sk- prefix + 20+ alphanumeric characters)
- Bearer token header pattern
- AWS access key pattern (AKIA prefix + 16 uppercase alphanumeric characters)
- JWT pattern
- Assignment of SECRET, PASSWORD, TOKEN, or APIKEY with literal values of 8 or more characters

### 11.4 task-completed-evidence.sh (P0, FAIL_CLOSED)

**Purpose:** Enforce evidence contract before TaskCompleted event is accepted.  
**Trigger:** TaskCompleted (no matcher — fires on every task completion).  
**Input:** JSON on stdin with `task_id`, `contract_hash`, `risk_level`.

**Validation steps (AWK scan of EVIDENCE_REGISTRY.md):**
1. `task_id` must be present and non-empty
2. `contract_hash` must be present and start with `sha256:` (FAIL_CLOSED per F8-A addendum — absence exits 2)
3. Status field: must be `VERIFIED`
4. `artifact_hash`: must match `sha256:` + exactly 64 hex chars; must not be all zeros
5. `contract_hash` in registry must match the one provided by caller
6. Checks field: `tests=PASS`, `static=PASS`, `security=PASS` or `NOT_REQUIRED`
7. Reviewer: `PASS` or `NOT_REQUIRED`; medium/high/critical risk requires explicit reviewer PASS
8. Exceptions: `NONE` or `APPROVED:`
9. Timestamp: ISO-8601 format

**R2 instrumentation:** On any denial, calls `stall_record_event || true` before exit 2.

**Flow:**
```
stdin JSON -> extract task_id, contract_hash, risk_level
  -> contract_hash absent? -> exit 2 (BLOCK, STALL_POLICY)
  -> AWK scan EVIDENCE_REGISTRY.md
  -> Status != VERIFIED? -> exit 2
  -> artifact_hash invalid? -> exit 2
  -> contract_hash mismatch? -> exit 2
  -> checks fail? -> exit 2
  -> reviewer missing for medium+? -> exit 2
  -> exceptions invalid? -> exit 2
  -> timestamp invalid? -> exit 2
  -> ALL PASS: exit 0 (ALLOW)
```

### 11.5 session-start-startup.sh (P1, FAIL_OPEN)

**Purpose:** Inject current operational state into new/resumed sessions.  
**Trigger:** SessionStart with `startup|resume|fork` matcher.

**Extracted fields from PROJECT_STATE.md:**
- `CURRENT_PHASE`, `PHASE_STATUS`, `CURRENT_OBJECTIVE`, `BLOCKERS`
- `LAST_GIT_CHECKPOINT`, `NEXT_ALLOWED_PHASE`, `ACTIVE_DECISIONS`

**Output:** `hookSpecificOutput.additionalContext` JSON with all fields.

### 11.6 session-start-compact.sh (P1, FAIL_OPEN)

**Purpose:** Post-compaction state integrity verification.  
**Trigger:** SessionStart with `compact|clear` matcher.

**Process:**
1. Read PROJECT_STATE.md critical fields
2. Compute sha256 of critical fields
3. Compare to `.claude/backups/PROJECT_STATE.critical.sha256`
4. Report `STATE_INTEGRITY=PASS` or `STATE_INTEGRITY=DRIFT_DETECTED`

### 11.7 pre-compact-snapshot.sh (P1, FAIL_OPEN)

**Purpose:** Preserve state before context compaction.  
**Trigger:** PreCompact event.

**Process:**
1. Copy PROJECT_STATE.md to `.claude/backups/PROJECT_STATE.precompact.md`
2. Compute sha256 of critical fields
3. Write hash to `.claude/backups/PROJECT_STATE.critical.sha256`

### 11.8 stop-logger.sh (P2, FAIL_OPEN)

**Purpose:** Log session end activity; remind about PROJECT_STATE updates.  
**Trigger:** Stop event.

**Features:**
- `stop_hook_active` idempotency guard
- Logs `last_assistant_message` (first 200 chars)
- If PROJECT_STATE not modified today, emits reminder via additionalContext

### 11.9 subagent-context.sh (P2, FAIL_OPEN)

**Purpose:** Inject role-appropriate context packs into subagents at start.  
**Trigger:** SubagentStart.

**Context pack mapping:**
| agent_type | Context Packs |
|------------|--------------|
| researcher | CORE, BUSINESS, DECISIONS |
| architect | CORE, CURRENT_STATE, DECISIONS, SECURITY_RULES |
| implementer | CORE, CURRENT_STATE, SECURITY_RULES |
| security-auditor | CORE, SECURITY_RULES, DECISIONS |
| code-reviewer | CORE, CURRENT_STATE, SECURITY_RULES, DECISIONS |
| default | CORE, CURRENT_STATE, SECURITY_RULES |

### 11.10 subagent-stop-logger.sh (P2, FAIL_OPEN)

**Purpose:** Log subagent activity when they stop.  
**Trigger:** SubagentStop.

**Features:**
- Logs `agent_type`, `agent_id`, `last_assistant_message` (first 300 chars)
- Idempotency check by `agent_id`
- Rotation: when SESSION_LOG exceeds 30 entries, archives to `archive/CLAUDE_SESSION_LOG.YYYY-MM-DD.md`

### 11.11 config-change-logger.sh (P1, FAIL_OPEN)

**Purpose:** Track configuration changes in session log.  
**Trigger:** ConfigChange.  
**Logs:** `config_source`, `changed_keys`

### 11.12 stall-record.sh (Library, non-gating)

**[IMPLEMENTED]** R2 observation helper. Not a hook; sourced by P0 hooks.

**Function:** `stall_record_event(source_hook, decision, stall_type, policy_category, action, task_id, session_id, notes)`

**Output:** Single JSONL line to `STALL_POLICY_LOG.jsonl`

**Key properties:**
- Uses `sha256sum` for `action_hash` — raw action not stored
- `had_alternative` always `null` — never inferred
- Requires `CLAUDE_PROJECT_DIR` or `STALL_POLICY_LOG_PATH`; no fallback to current directory
- Called with `|| true` — never gates security decisions

---

## 12. Skill Architecture

**[IMPLEMENTED]** 28 skill files in `.claude/skills/`. Skills are markdown files with instructions that Claude follows. They are not executable scripts; they are prompt-layer instructions invoked via the `/skill-name` command pattern.

### 12.1 Control Plane Operational Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `evidence` | `/evidence` | Creates/validates EVIDENCE_REGISTRY entries |
| `gate` | `/gate` | Phase-gate check; verifies all gate criteria before advancing |
| `cerrar-fase` | `/cerrar-fase` | Closes current phase; creates git checkpoint |
| `estado` | `/estado` | Shows full current operational state |
| `doctor` | `/doctor` | Health check; runs maintenance suite |
| `incident` | `/incident` | Initiates incident learning workflow |
| `recovery` | `/recovery` | 9 recovery scenarios for common failure modes |
| `checkpoint` | `/checkpoint` | Creates git checkpoint; updates LAST_GIT_CHECKPOINT |

### 12.2 Context Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `context-current-state` | `/context-current-state` | Loads CURRENT_STATE context pack |
| `context-core` | `/context-core` | Loads CORE context pack |
| `context-decisions` | `/context-decisions` | Loads DECISIONS context pack |
| `context-security` | `/context-security` | Loads SECURITY_RULES context pack |
| `context-business` | `/context-business` | Loads BUSINESS context pack |
| `context-no-go` | `/context-no-go` | Loads NO_GO context pack |

### 12.3 Process Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `no-go` | `/no-go` | Verifies against NO_GO anti-patterns |
| `brainstorming` | `/brainstorming` | Structured brainstorm before implementation |
| `systematic-debugging` | `/systematic-debugging` | Structured debug workflow |
| `audit` | `/audit` | Structured audit workflow |

### 12.4 Additional Skills

Remaining skills cover: task management, git workflows, code review, security auditing, deployment flows, and research processes. Full listing in `.claude/skills/` directory (28 total).

### 12.5 Skill Invocation Mechanism

Skills are loaded at the prompt layer. The `SubagentStart` hook via `subagent-context.sh` does NOT load skills — it loads context packs. Skills must be explicitly invoked by the operator via `/skill-name`. The `skills:` frontmatter field in agent definitions is not a verified runtime loading mechanism `[UNKNOWN]` for native Claude Code.

---

## 13. Registry Architecture

**[IMPLEMENTED]** Four operational registries + one evidence registry.

### 13.1 DECISION_REGISTRY.md

**Schema fields:** ID, Title, Status, Date, Rationale, Implications, Alternatives Rejected, Supersedes

**Active entries:**
| ID | Decision | Status |
|----|----------|--------|
| ARCH-001 | Scope at .claude/ project level; no global config modification | APPROVED |
| ARCH-002 | SubagentStart.additionalContext for context loading (not skills: frontmatter) | APPROVED |
| ARCH-003 | Canonical evidence path = `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | APPROVED |
| ARCH-004 | Only CONTRACTUAL TASKs require EV-NNN evidence; TODOs/SUBTASKs/RESEARCH NOTEs do not | APPROVED |
| ARCH-004/F8-A | `contract_hash` is mandatory and fail-closed; absence exits 2 | APPROVED addendum |

### 13.2 CONTROL_REGISTRY.md

**Active entries:**
| ID | Control | Type | Enforcement Level | Source | Path |
|----|---------|------|------------------|--------|------|
| CTRL-001 | TaskCompleted requires VERIFIED evidence | hook | L5 | INC-001 | task-completed-evidence.sh |

### 13.3 INCIDENT_REGISTRY.md

**Entries:**
| ID | Description | Severity | Status | Control | Regression |
|----|-------------|----------|--------|---------|-----------|
| INC-001 | Task completion not enforcement-gated pre-F2 | P1 | CLOSED | CTRL-001 | REG-001 |

### 13.4 REGRESSION_REGISTRY.md

**11 active regressions:**
| ID | Tests For | Status |
|----|-----------|--------|
| REG-001 | TaskCompleted without VERIFIED evidence is blocked | ACTIVE |
| REG-002 | bash-firewall blocks known destructive pattern (positive test) | ACTIVE |
| REG-003 | secret-guard blocks known secret pattern (positive test) | ACTIVE |
| REG-004 | Context pack freshness (Tier3 check) | ACTIVE |
| REG-005 | stop-logger idempotency guard works | ACTIVE |
| REG-006 | Firewall regex mutations do not weaken coverage | ACTIVE |
| REG-007 | Contract hash mismatch is blocked | ACTIVE |
| REG-008 | SESSION_LOG rotation triggers at threshold | ACTIVE |
| REG-009 | install.sh is idempotent (re-run does not break existing config) | ACTIVE |
| REG-010 | Absent contract_hash is blocked (F8-A) | ACTIVE |
| REG-011 | Malformed firewall JSON is blocked (fail-closed) | ACTIVE |

### 13.5 EVIDENCE_REGISTRY.md

**[IMPLEMENTED]** 16 VERIFIED entries (EV-001 through EV-016).

**Schema:** Task ID, Date, Claim, Source, Provenance, Confidence, Status, Affects, Artifact Hash (sha256:64hex), Contract Hash (sha256:64hex), Checks, Reviewer, Exceptions, Timestamp, Notes

**Classification:** All 16 entries: Status=VERIFIED, Provenance=GENERATED, Confidence=HIGH, Exceptions=NONE.

**Coverage:** One EV per phase (F1-F8) plus supplementary entries for controls, regressions, and specific hook validations.

---

## 14. State Model

**[IMPLEMENTED]** PROJECT_STATE.md is the single source of operational truth.

### 14.1 PROJECT_STATE.md Schema

```
CURRENT_PHASE:          <integer>
PHASE_STATUS:           <ACTIVE|COMPLETE|BLOCKED>
CURRENT_OBJECTIVE:      <text>
BLOCKERS:               <NONE|text>
ACTIVE_DECISIONS:       <comma-separated IDs>
LAST_GIT_CHECKPOINT:    <git hash>
NEXT_ALLOWED_PHASE:     <phase number|None auto>
IMPLEMENTATION_READY:   <true|false>
CONTROL_PLANE_VERSION:  <semver>
```

### 14.2 Current State (Verified)

```
CURRENT_PHASE:          8
PHASE_STATUS:           COMPLETE
CURRENT_OBJECTIVE:      F8 cerrada, F9 investigada (F9 NOT JUSTIFIED),
                        F9 owner decision gate CERRADO (D01=A..D05=A/B)
BLOCKERS:               NONE
ACTIVE_DECISIONS:       ARCH-001, ARCH-002, ARCH-003, ARCH-004
LAST_GIT_CHECKPOINT:    3336bd6
NEXT_ALLOWED_PHASE:     None auto; owner-driven decision required
IMPLEMENTATION_READY:   false
CONTROL_PLANE_VERSION:  1.0
```

### 14.3 State Transition Model

```
Phase N ACTIVE
    |
    v (all gate criteria met)
Phase N COMPLETE --> git checkpoint --> EVIDENCE entry
    |
    v (owner decision + new gate criteria)
Phase N+1 ACTIVE  [NOT CURRENTLY AUTHORIZED]
```

**Current:** Frozen at Phase 8 COMPLETE. No automatic next phase. Owner decision required.

### 14.4 Phase Gate Criteria

Per MASTER_IMPLEMENTATION_PLAN.md, each phase requires 5 items:
1. All tasks completed with VERIFIED evidence
2. Regression suite passes
3. Maintenance suite (evals/maintenance.sh) passes
4. git checkpoint created
5. Phase status set to COMPLETE in PROJECT_STATE.md

---

## 15. Data and Entity Model

**[IMPLEMENTED]** First-class data entities in CCP.

### 15.1 Evidence Entry (EV-NNN)

```
entity EvidenceEntry {
  task_id:        string          // CONTRACTUAL TASK identifier
  date:           ISO-8601 date
  claim:          string          // What was verified
  source:         file path
  provenance:     EXTRACTED|INFERRED|ASSUMED|EXTERNAL|GENERATED
  confidence:     LOW|MEDIUM|HIGH
  status:         VERIFIED|PENDING|REJECTED
  affects:        list of components
  artifact_hash:  sha256:<64 hex> // Not all zeros
  contract_hash:  sha256:<64 hex> // Must match caller
  checks: {
    tests:    PASS|FAIL|NOT_REQUIRED
    static:   PASS|FAIL|NOT_REQUIRED
    security: PASS|FAIL|NOT_REQUIRED
  }
  reviewer:       PASS|NOT_REQUIRED|<name>
  exceptions:     NONE|APPROVED:<reason>
  timestamp:      ISO-8601 datetime
  notes:          string
}
```

### 15.2 Decision (ARCH-NNN)

```
entity Decision {
  id:           ARCH-NNN
  title:        string
  status:       PROPOSED|APPROVED|REJECTED|SUPERSEDED
  date:         ISO-8601 date
  rationale:    string
  implications: list
  alternatives: list
  supersedes:   ARCH-NNN | null
}
```

### 15.3 Incident (INC-NNN)

```
entity Incident {
  id:          INC-NNN
  description: string
  severity:    P0|P1|P2|P3
  status:      OPEN|CLOSED
  root_cause:  string
  control:     CTRL-NNN
  regression:  REG-NNN
}
```

### 15.4 Control (CTRL-NNN)

```
entity Control {
  id:          CTRL-NNN
  description: string
  type:        hook|process|rule
  enforcement: L1..L6
  source:      INC-NNN
  path:        file path
  status:      ACTIVE|RETIRED
  rollback:    documented procedure
}
```

### 15.5 Regression Test (REG-NNN)

```
entity RegressionTest {
  id:        REG-NNN
  tests_for: string
  control:   CTRL-NNN | null
  status:    ACTIVE|RETIRED
  eval_file: path in evals/
}
```

### 15.6 Stall Event (R2)

```
entity StallEvent {
  schema_version:  "1.0"
  event_id:        string
  timestamp:       ISO-8601 UTC
  source_hook:     string
  decision:        "DENY"
  stall_type:      STALL_POLICY|STALL_ERROR|UNKNOWN
  policy_category: string
  action_hash:     sha256 hex | "UNKNOWN"
  task_id:         string | null
  session_id:      string | null
  notes:           string
  had_alternative: null   // always null; never inferred
}
```

---

## 16. Evidence Model

**[IMPLEMENTED]** The evidence contract is the central enforcement mechanism of CCP.

### 16.1 Evidence Classification

```
CONTRACTUAL TASK   -> requires EV-NNN (VERIFIED) before TaskCompleted
INTERNAL TODO      -> no individual EV-NNN required
SUBTASK            -> no individual EV-NNN required
RESEARCH NOTE      -> no individual EV-NNN required
```

Source: ARCH-004 (DECISION_REGISTRY.md)

### 16.2 Evidence Creation Flow

```
1. Complete task work
2. Compute artifact_hash: sha256 of primary artifact
3. Obtain contract_hash from task contract document
4. Run checks: tests, static analysis, security scan
5. Get reviewer sign-off if medium/high/critical risk
6. Create EV-NNN entry in EVIDENCE_REGISTRY.md
7. Set Status = VERIFIED
8. Record all fields; non-NONE exceptions must have APPROVED: prefix
```

### 16.3 Evidence Validation Flow (task-completed-evidence.sh)

```
caller provides: task_id, contract_hash, risk_level
hook validates: all 9 criteria in AWK scan
result: exit 0 (pass) or exit 2 (block with stall event)
```

### 16.4 Provenance Classification

| Provenance | Meaning |
|------------|---------|
| EXTRACTED | Directly read from source file |
| INFERRED | Derived from source but not explicitly stated |
| ASSUMED | No source; working assumption |
| EXTERNAL | From outside the repository |
| GENERATED | Created during the task itself |

**All 16 EV entries:** Provenance = GENERATED (created as part of implementing the system).

---

## 17. DONE / TaskCompleted Model

**[IMPLEMENTED]** The TaskCompleted lifecycle is enforced by a P0 hook.

### 17.1 TaskCompleted Contract

A task may only be marked "done" if:
- It is classified as a CONTRACTUAL TASK (per ARCH-004)
- A VERIFIED evidence entry exists in EVIDENCE_REGISTRY.md
- That entry has a `contract_hash` matching the task contract
- That entry has non-zero `artifact_hash`
- That entry passes all applicable checks
- That entry has reviewer PASS for medium/high/critical risk
- Timestamp is valid ISO-8601

### 17.2 What "VERIFIED" Means

`Status=VERIFIED` in EVIDENCE_REGISTRY.md means: at the time of recording, a human-reviewed or auditor-confirmed judgment was made that the evidence meets all contract criteria. It does NOT mean: automated production verification, cryptographic proof of authorship, or runtime safety guarantee.

**Trust boundary note:** The git repository is declared as the trust boundary. Evidence entries are not cryptographically signed. A human reviewer (declared; not enforced cryptographically) is the final authority. `[DESIGNED]` for future: cryptographic signing. `[UNKNOWN]` for implementation timeline.

### 17.3 Non-Contractual Tasks

TODOs, subtasks, and research notes DO NOT require EV entries. They may be tracked in PROJECT_STATE.md, SESSION_LOG, or task comments. They are not evidence-gated.

---

## 18. Firewall Model

**[IMPLEMENTED]** bash-firewall.sh provides two pattern tiers.

### 18.1 DESTRUCTIVE_REGEX Patterns (Case-sensitive; broad)

| Pattern Category | Risk |
|-----------------|------|
| Recursive root filesystem delete | Filesystem destruction |
| dd if=/dev/zero | Disk overwrite |
| mkfs.* (filesystem format) | Filesystem format |
| Fork bomb pattern | Process exhaustion |
| chmod 777 / (root permission escalation) | Broad permission escalation |
| chown -R (recursive ownership change) | Recursive ownership change |
| DROP TABLE / DROP DATABASE | Database destruction |
| TRUNCATE TABLE | Data loss |
| write /dev/sda (raw disk write) | Raw disk write |

### 18.2 REGEX Patterns (Secret / supply-chain)

| Pattern Category | Risk |
|-----------------|------|
| .env file reads | Secret exposure |
| .pem, .key file reads | Private key exposure |
| ~/.ssh/* reads | SSH key exposure |
| ~/.aws/credentials reads | AWS credential exposure |
| git add of secret-typed files | Accidental secret commit |
| curl-pipe-bash or wget-pipe-bash | Supply chain attack |

### 18.3 Permissions Model (settings.json)

```json
"permissions": {
  "allow": ["git *", "ls *", "find *", "grep *", "cat *", "..."],
  "ask":   ["git push*", "rm *"],
  "deny":  [".env", "*.pem", "*.key", "*.pfx", "~/.ssh/*", "~/.aws/credentials"]
}
```

`deny` in permissions prevents the bash-firewall from even seeing those file access attempts — they are blocked at the permissions layer before hook execution.

### 18.4 Firewall Bypass Resistance

The firewall is case-tolerant for SQL patterns (DROP TABLE / drop table both blocked). The regex suite is protected by REG-002 (positive test) and REG-006 (mutation test) in the regression suite.

---

## 19. Security Model

**[IMPLEMENTED]** Three-layer security architecture.

### Layer 1: Permissions (settings.json)
Pre-execution: deny list prevents file access before any hook runs.

### Layer 2: P0 Hooks (fail-closed)
Execution-time: bash-firewall.sh and secret-guard.sh block at command/write level.

### Layer 3: Evidence Contract (task-completed-evidence.sh)
Post-execution: prevents task completion without verified evidence.

### 19.1 Security Invariants

1. **FAIL_CLOSED:** All P0 hooks exit 2 on any failure mode, including tool unavailability
2. **Logging failure does not equal security bypass:** R2 observation is `|| true`; security decision is pre-committed
3. **No secrets in code:** Secret patterns blocked at write time (secret-guard.sh)
4. **Evidence cannot be fabricated:** contract_hash must match; artifact_hash must be non-zero 64-char hex
5. **No cross-tenant access:** Rule in SECURITY_RULES.md and NO_GO.md (specific enforcement mechanism is project-defined)

### 19.2 Known Security Limitations `[OPEN]`

- Native Claude Code lifecycle is not verified — hooks are script-verified only `[UNKNOWN]`
- Trust boundary is git + human reviewer — not cryptographically enforced `[DESIGNED for future]`
- `task_id` and `session_id` may be null in R2 events when not provided by the runtime `[OPEN]`
- `secret-guard.sh` does not instrument R2 events (only bash-firewall and task-completed-evidence do) `[OPEN]`

---

## 20. Authority Model

**[IMPLEMENTED]** Who has what authority in CCP.

| Actor | Authority | Mechanism |
|-------|-----------|-----------|
| Owner (human) | Full authority over all phases and decisions | Direct file modification; git commits |
| Claude Code agent | Execute within hook constraints | Hooks enforce boundaries |
| P0 hooks | Block any command matching policy | Exit 2 in PreToolUse / TaskCompleted |
| P1/P2 hooks | Observe and inject context | Exit 0 always |
| Skills | Provide structured workflows | Prompt-layer instructions; cannot override hooks |
| Subagents | Execute within their tool scope + context packs | SubagentStart injects context; tool restrictions in agent definition |

### 20.1 Decision Authority

All owner decisions are recorded in DECISION_REGISTRY.md. An agent cannot approve its own decisions. A decision approved by an agent (rather than the human owner) has reduced authority.

### 20.2 Phase Authority

No phase may open without explicit owner decision per `NEXT_ALLOWED_PHASE` in PROJECT_STATE.md. Current state: `NEXT_ALLOWED_PHASE=None auto`.

---

## 21. Trust Boundaries

**[IMPLEMENTED / DESIGNED]** Trust boundaries define what CCP considers authoritative.

### 21.1 Declared Trust Boundaries (DESIGN.md)

1. **Git repository + human reviewer** — primary trust boundary
2. **EVIDENCE_REGISTRY.md** — authoritative evidence store
3. **PROJECT_STATE.md** — authoritative operational state
4. **settings.json** — authoritative hook configuration

### 21.2 What Is NOT In the Trust Boundary

- Agent-generated summaries of completed work (require evidence entry)
- In-session reasoning (not persisted beyond SESSION_LOG)
- Context pack content (template placeholders for target projects, not CCP)
- R2 observation events (observation, not verification)

### 21.3 Trust Boundary Gaps `[OPEN]`

- Cryptographic signing of evidence entries: `[DESIGNED]` in DESIGN.md; `[NOT IMPLEMENTED]`
- Native Claude Code lifecycle verification: `[UNKNOWN]` — hooks are script-verified only
- Cross-session state integrity: `[IMPLEMENTED]` via pre-compact-snapshot + session-start-compact but hash comparison depends on file not being modified externally

---

## 22. Dependency Model

**[IMPLEMENTED]** Internal dependencies verified in source.

### 22.1 Hard Dependencies (Fail-Closed on Absence)

| Component | Requires | On Absence |
|-----------|---------|------------|
| bash-firewall.sh | `jq` | exit 2 (BLOCK) |
| bash-firewall.sh | Valid JSON on stdin | exit 2 (BLOCK) |
| task-completed-evidence.sh | `jq` | exit 2 (BLOCK) |
| task-completed-evidence.sh | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | exit 2 (BLOCK) |
| task-completed-evidence.sh | `contract_hash` in payload | exit 2 (BLOCK, F8-A) |
| stall-record.sh | `CLAUDE_PROJECT_DIR` or `STALL_POLICY_LOG_PATH` | no event emitted (non-gating) |

### 22.2 Soft Dependencies (Fail-Open on Absence)

| Component | Requires | On Absence |
|-----------|---------|------------|
| session-start-startup.sh | PROJECT_STATE.md readable | exits 0, no context |
| session-start-compact.sh | `.claude/backups/PROJECT_STATE.critical.sha256` | exits 0, no comparison |
| subagent-context.sh | Context pack files readable | exits 0, no packs injected |

### 22.3 External Dependencies

| Dependency | Type | Required By |
|------------|------|------------|
| `jq` | System binary | bash-firewall.sh, task-completed-evidence.sh (P0, fail-closed) |
| `sha256sum` | System binary | stall-record.sh (non-gating) |
| Claude Code | Runtime | All hooks (native lifecycle `[UNKNOWN]` for hooks) |
| GitHub Actions | CI | control-plane.yml (runs maintenance.sh on push/PR) |

---

## 23. History and Reversibility Model

**[IMPLEMENTED]** CCP maintains multiple forms of history.

### 23.1 Git History

Primary history mechanism. Every phase closure creates a git checkpoint. `LAST_GIT_CHECKPOINT` in PROJECT_STATE.md points to the verified-complete commit.

**Current checkpoint:** `3336bd6`

### 23.2 .history/ Directory

Contains timestamped snapshots of research artifact evolution. Documents how research artifacts changed across investigation passes. `[IMPLEMENTED]` — present in repository.

### 23.3 Pre-Compact Backups

`pre-compact-snapshot.sh` saves `PROJECT_STATE.precompact.md` and `PROJECT_STATE.critical.sha256` before every context compaction. `session-start-compact.sh` verifies integrity on resume.

### 23.4 SESSION_LOG

Append-only log of session activity. Rotated at 30 entries to archive. Not a reversibility mechanism; an observability mechanism.

### 23.5 R2 Rollback Procedure `[IMPLEMENTED]`

Documented in `48_R2_INSTRUMENTATION.md`. To rollback R2:
1. Restore `bash-firewall.sh` from `R2_BASELINE_HEAD=4ede92f`
2. Restore `task-completed-evidence.sh` from same baseline
3. Remove R2 files: `stall-record.sh`, `STALL_POLICY_LOG.jsonl`, `r2-instrumentation.sh`, `48_R2_INSTRUMENTATION.md`
4. Re-run maintenance suite to verify

---

## 24. Incident to Control to Regression Loop

**[IMPLEMENTED]** The learning loop is the primary quality mechanism of CCP.

```
INCIDENT observed (INC-NNN)
    |
    v root cause analysis
CONTROL designed and implemented (CTRL-NNN)
    |
    v regression designed to catch recurrence
REGRESSION TEST added (REG-NNN)
    |
    v included in maintenance.sh
DETERMINISTIC CHECK in CI (evals/maintenance.sh)
```

### 24.1 Current Loop State

**One closed loop:**
- INC-001 (task completion not gated) -> CTRL-001 (task-completed-evidence.sh) -> REG-001..REG-011 (11 tests)
- Severity: P1 | Status: CLOSED

**No open incidents** as of F8 COMPLETE.

### 24.2 Loop Trigger Conditions

A new incident should be opened when:
- A security or governance control is bypassed in practice
- A regression test reveals unexpected behavior
- An audit finds a gap between designed and implemented behavior
- The maintenance suite reveals a new failure mode

### 24.3 Loop Invariants

- Every CTRL must trace to an INC
- Every REG must trace to a CTRL (or be preventive with documented rationale)
- A CLOSED INC with no CTRL means the risk is accepted with documentation
- A CTRL with no REG test is incomplete

---

## 25. R2 Observation Model

**[IMPLEMENTED + AUDITED]** R2 is the observation/instrumentation layer for policy decisions.

### 25.1 What R2 Is

R2 is the minimum viable instrumentation of the CCP that records when policy-related decisions are made by existing P0 hooks, without changing security behavior.

**Files created by R2:**
- `.claude/hooks/lib/stall-record.sh` — helper library
- `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` — observation log
- `evals/r2/r2-instrumentation.sh` — test harness
- `docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md` — evidence artifact

**Files modified by R2:**
- `.claude/hooks/bash-firewall.sh` — sourced stall-record.sh; block() calls stall_record_event
- `.claude/hooks/task-completed-evidence.sh` — sourced stall-record.sh; block() calls stall_record_event

### 25.2 What R2 Does NOT Do

R2 does NOT:
- Measure STALL_POLICY frequency
- Collect field data
- Simulate observation windows
- Implement recovery
- Generate alternatives
- Implement non-bypass verification
- Implement SAGR
- Constitute justification for F10
- Change any security exit codes

### 25.3 Current Observation State

One event in `STALL_POLICY_LOG.jsonl` (as of 2026-09-22):

```
schema_version:  "1.0"
event_id:        "r2-bash-firewall.sh-2026-09-22T03:53:06Z-107886"
timestamp:       "2026-09-22T03:53:06Z"
source_hook:     "bash-firewall.sh"
decision:        "DENY"
stall_type:      "STALL_POLICY"
policy_category: "patron destructivo/DB: 'rm -rf root'"
action_hash:     "2a16f855..." (sha256 of original command)
task_id:         null
session_id:      null
notes:           "policy predicate matched"
had_alternative: null
```

This event was created during R2 audit testing, not during normal production operation.

### 25.4 R2 Security Invariant

```bash
DECISION=2          # set before log call
stall_record_event ... || true
exit "$DECISION"    # unchanged
```

Logging failure cannot change the exit code. Security behavior is identical before and after R2.

**Verification:** Maintenance suite 12/12 PASS before and after R2. Hook exit codes identical.

---

## 26. R3 Non-Bypass-Verify Design

**[DESIGNED + AUDITED]** R3 is a formal design document only. No runtime implementation exists or is authorized.

### 26.1 What R3 Is

R3 (`50_R3_NON_BYPASS_VERIFY_DESIGN.md`) is a formal design and falsifiability protocol for a hypothetical `non_bypass_verify` function that would verify whether a proposed alternative to a blocked action is genuinely non-bypassing.

### 26.2 The Problem R3 Addresses

When an agent's action is blocked by a P0 hook, two responses are possible:
1. **Stall:** The agent stops and reports the block (current behavior)
2. **Alternative:** The agent proposes a different action to achieve the same goal

The question: *How can a system verify that a proposed alternative is genuinely non-bypassing (i.e., doesn't achieve the prohibited outcome via a different path)?*

This is the residual open problem documented in `42_PROBLEMA_RESIDUAL.md`.

### 26.3 R3 Design Elements

**Core invariant:** STALL does not equal PERMISSION TO BYPASS SAFETY

**Output states:**
- `SAFE` — alternative is verified non-bypassing
- `UNSAFE` — alternative bypasses the original policy
- `UNKNOWN` — cannot be determined

**Key rule:** `UNKNOWN` cannot be promoted to `SAFE`. Safety is not the default.

**Input contract:** 10 evidence items required for any verification decision. No silent gap-filling.

**Threat model covers:**
1. Semantic bypass (same goal, different method)
2. Indirect bypass (bypass via side effect)
3. Hidden side effects
4. Authority freshness (stale verification)
5. Common-mode failure (verifier shares assumptions with proposer)

**Independence requirement:** Verifier must be independent of proposer (no shared model, context, or training pathway that might share the bypass strategy).

### 26.4 R3 Status

| Property | Value |
|----------|-------|
| Document | `[DESIGNED]` — exists as formal design |
| Implementation | `[NOT AUTHORIZED]` — no F10; no runtime code |
| Audit | `[AUDITED]` — independently audited; classified AUDITED_CONFIRMED |
| Cases executed | 0 — no case has been run through the protocol |
| Gap closure | `[OPEN]` — residual problem survives R3 as design |

---

## 27. Research Artifacts 3952

**[RESEARCH]** All items in this section are research artifacts. They describe findings, not implemented system properties.

### 27.1 Artifact Inventory

The research program is documented in `docs/research/CCP_FINAL_RECONCILIATION/`. Artifacts are numbered 39-52 (not all numbers correspond to files in this directory; some numbers refer to phases of the broader research program).

### 27.2 Reconciliation Artifacts (CCP_FINAL_RECONCILIATION/)

| Artifact | Title | Status |
|----------|-------|--------|
| 42 | Residual Problem: Policy-Aware Continuation with Non-Bypass Verification | `[RESEARCH]` — open |
| 45 | Decision de Implementacion Preliminar | `[RESEARCH]` — gates applied |
| 47 | Prior Art Verification (R-1) | `[RESEARCH]` — 4 candidates evaluated |
| 48 | R-2 Instrumentation | `[IMPLEMENTED + AUDITED]` |
| 50 | R-3 Non-Bypass-Verify Design | `[DESIGNED + AUDITED]` |
| 52 | Roger Hypothesis Post-Audit | `[RESEARCH + AUDITED]` |

### 27.3 Artifact 42: Residual Problem

**Finding:** The problem of policy-aware continuation with non-bypass verification for open-ended agents is a residual open research question. No prior art closes it. No CCP implementation addresses it.

| Property | Classification |
|----------|---------------|
| Novelty | `[HYPOTHESIS OPEN]` |
| Utility | `[HYPOTHESIS OPEN]` |
| Security gate | `[BLOCKING]` — cannot implement without closing this |
| CCP fit | `[PARTIAL]` |
| Commercial | `[UNKNOWN]` |

### 27.4 Artifact 45: Implementation Decision

**Decision:** REQUIRES REPRODUCTION + FIELD VALIDATION before any implementation.

**Authorized:**
- R-1 (prior art verification)
- R-2 (minimum viable instrumentation)
- R-3 (conditional — formal design + falsifiability protocol)
- R-4 (conditional — reproduction study if R-3 completes)

**NOT authorized:**
- F10 or any new phase
- Modifying F1-F8
- New hooks, skills, agents, or registries

### 27.5 Artifact 47: Prior Art Verification (R-1)

**Four candidates evaluated:**

| Candidate | Description | Closes Gap? |
|-----------|-------------|-------------|
| State-Aware Runtime (Cambridge) | Conceptual framework only; no implementation | NO |
| arXiv:2606.31339 | Structured multi-robot; not open-ended agents | NO |
| ae-framework | SDLC pipelines; dry-run only | NO |
| VERITAS OS | Regulated pipelines; refusal terminal; no alternative generation | NO |

**Result:** Residual SURVIVES R-1. No prior art closes the gap.

### 27.6 Broader Research Context

`docs/research/CCP_RESEARCH_CONTEXT_MASTERC.md` — Consolidation of two independent research investigations:
1. ChatGPT/Web corpus investigation (2+ years)
2. Claude/Cowork corpus investigation

Combined into a single master context document. This document is `[RESEARCH]` — it records the research journey, not system properties.

---

## 28. Hypothesis Evolution

**[RESEARCH -> HISTORICAL -> HYPOTHESIS]** How key concepts evolved through the research program.

### 28.1 SAGR Evolution

| Stage | Concept | Status |
|-------|---------|--------|
| Early | "State-aware agents should be able to resume after a policy block" | `[HYPOTHESIS]` |
| Mid | "SAGR as a formal framework for governance of resumption" | `[RESEARCH]` |
| Late | "SAGR requires: residual gap closure, field validation, non-bypass verification" | `[RESEARCH]` |
| Current | SAGR is a research framing; not an architecture; not authorized for F10 | `[RESEARCH]` |

### 28.2 Non-Bypass Verification Evolution

| Stage | Concept | Status |
|-------|---------|--------|
| Early | "Agents should verify their alternative actions are safe" | `[HYPOTHESIS]` |
| Mid | "This requires a formal verification protocol" | `[DESIGNED in R3]` |
| Current | "The verification problem is open; R3 provides protocol design; no implementation authorized" | `[DESIGNED + OPEN]` |

### 28.3 Evidence Gate Evolution

| Stage | Concept | Status |
|-------|---------|--------|
| Pre-F2 | No evidence gate | `[HISTORICAL]` |
| F2 | task-completed-evidence.sh implemented | `[IMPLEMENTED]` |
| F8 | contract_hash made mandatory; absence exits 2 (F8-A) | `[IMPLEMENTED]` |

---

## 29. Killed Hypotheses

**[HISTORICAL]** Hypotheses that were tested and found not to hold or not to be useful.

### 29.1 "Prior Art Closes the Residual Gap"

**Hypothesis:** One of the identified prior art candidates would close the policy-aware continuation gap.  
**Test:** R-1 verification against 4 candidates.  
**Result:** All 4 candidates evaluated; none closes the gap. Residual survives.  
**Status:** `[KILLED — R1 VERIFICATION]`

### 29.2 "F9 Can Be Justified with Current Evidence"

**Hypothesis:** After F1-F8, sufficient evidence exists to open F9 without additional research.  
**Test:** F9 research program (SAGR two-pass investigation, reconciliation, owner decisions).  
**Result:** F9 NOT JUSTIFIED. Owner decision gate closed with D01=A (keep F9 closed).  
**Status:** `[KILLED — OWNER DECISION]`

### 29.3 "skills: Frontmatter Is a Reliable Context Injection Mechanism"

**Hypothesis:** The `skills:` field in agent `.md` frontmatter reliably injects skills at agent start in Claude Code's native runtime.  
**Test:** Audit of actual runtime behavior.  
**Result:** Mechanism is `[UNKNOWN]` for native Claude Code. ARCH-002 adopted SubagentStart.additionalContext instead.  
**Status:** `[KILLED — ARCH-002 SUPERSEDES]`

---

## 30. Surviving Concepts

**[IMPLEMENTED / DESIGNED / RESEARCH]** Concepts that have survived the full research and implementation program and remain valid.

### 30.1 Evidence-Before-Completion (IMPLEMENTED)

The core governance innovation: no task can be marked done without verifiable evidence. Survived F0-F8 and all audits. The contract_hash mechanism (F8-A) strengthened it further.

### 30.2 Fail-Closed Security (IMPLEMENTED)

P0 hooks that exit 2 on any failure, including tool unavailability and malformed input. Validated by 11 regression tests and CI.

### 30.3 Single Sources of Truth (IMPLEMENTED)

Four canonical files, each authoritative for its domain. No duplication without declared mirroring.

### 30.4 Phase-Gate Methodology (IMPLEMENTED)

Phases open only when previous phases have PASS status. AUDIT -> IMPLEMENT -> TEST -> VERIFY -> EVIDENCE -> GATE cycle.

### 30.5 Incident to Control to Regression Learning Loop (IMPLEMENTED)

Systematic response to incidents. Every incident produces a control. Every control produces regression tests. Tests are included in maintenance.sh and CI.

### 30.6 Observation Before Implementation (RESEARCH)

The principle that field observation (R2) should precede architectural decisions (F10+). Embedded in the F9 owner decision gate (D02=B, D04=B).

### 30.7 Non-Bypass Verification as a Design Problem (DESIGNED)

The recognition that verifying alternative actions is a distinct and non-trivial problem requiring formal design (R3). This framing survives as a design artifact and open research question.

---

## 31. Roger Hypothesis

**[RESEARCH + AUDITED]** Classification: INDETERMINED (dominant tendency: REFORMULATION)

### 31.1 What the Roger Hypothesis Is

The Roger Hypothesis is a research framing for the idea that AI agents might demonstrate "delta" behavior — changes in reasoning patterns — when operating under policy constraints, as distinct from simply stopping or bypassing.

### 31.2 Three Candidate Deltas (All HYPOTHESIS Grade)

| Delta | Description | Status |
|-------|-------------|--------|
| Delta A | Reactivation with causal preservation — agent resumes after block while maintaining causal chain | `[HYPOTHESIS]` |
| Delta B | Native representation generation — agent generates alternative representations without explicit instructions | `[HYPOTHESIS]` |
| Delta C | Intra-trajectory representational feedback — agent uses internal representation state to modify trajectory | `[HYPOTHESIS]` |

### 31.3 Audit Findings

From `52_ROGER_HYPOTHESIS_POST_AUDIT.md`:
- Audit status: `AUDITED_CONFIRMED`
- Global classification: `INDETERMINED`
- Dominant tendency: `REFORMULATION` (not genuine novelty)
- No genuinely new element demonstrated
- No implementation authorized

### 31.4 What Roger Does NOT Authorize

- Converting Roger to architecture: `[NOT AUTHORIZED]`
- Using Roger to justify F10: `[NOT AUTHORIZED]`
- Treating Roger as a production safety property: `[NOT AUTHORIZED]`
- Implementing Delta A, B, or C: `[NOT AUTHORIZED]`

### 31.5 Why Roger Matters (Research Value Only)

Roger frames the question of whether policy-blocked agents exhibit systematic alternative-generation behavior at the representation level, rather than random noise or simple failure. This framing is relevant to future research on non-bypass verification (R3). It is not a validated finding.

---

## 32. Open Questions

**[OPEN]** Genuine unknowns in the current system.

### 32.1 Runtime Unknowns

| Question | Status |
|----------|--------|
| Do CCP hooks fire reliably in native Claude Code lifecycle? | `[UNKNOWN]` — script-verified only |
| Do `task_id` and `session_id` appear in hook payloads in native runtime? | `[UNKNOWN]` |
| Does `SubagentStart` fire before the subagent receives any context? | `[UNKNOWN]` for native Claude Code |

### 32.2 Field Observation Unknowns

| Question | Status |
|----------|--------|
| At what frequency do policy blocks occur in normal operation? | `[UNKNOWN]` — R2 has 1 test event |
| What proportion of blocked actions have viable non-bypassing alternatives? | `[UNKNOWN]` — `had_alternative` always null |
| Does a policy block translate to a user-perceived stall in practice? | `[UNKNOWN]` |

### 32.3 Research Unknowns

| Question | Status |
|----------|--------|
| Does the non-bypass verification problem have a tractable solution? | `[OPEN]` |
| Does Roger's reformulation tendency have empirical support? | `[HYPOTHESIS OPEN]` |
| Would SAGR provide measurable governance improvement over current CCP? | `[HYPOTHESIS OPEN]` |

### 32.4 Architecture Unknowns

| Question | Status |
|----------|--------|
| What would F10's scope be if ever authorized? | `[UNKNOWN]` — owner decision required |
| Should evidence entries be cryptographically signed? | `[DESIGNED]` in DESIGN.md; `[OPEN]` for implementation decision |
| Is the current regression test coverage sufficient for F9+ scenarios? | `[OPEN]` |

---

## 33. F1F8 State

**[IMPLEMENTED]** All phases F1-F8 are COMPLETE and FROZEN.

### 33.1 Phase Summary

| Phase | Scope | Status | Evidence |
|-------|-------|--------|---------|
| F0 | Baseline audit: identified 7 broken dependencies; classified existing files KEEP/BUILD/DEFER | `[HISTORICAL]` | Documented in MASTER_IMPLEMENTATION_PLAN |
| F1 | Core infrastructure: `.claude/` structure, initial hooks skeleton, settings.json | `[COMPLETE]` | EV-001 |
| F2 | Evidence gate: task-completed-evidence.sh + EVIDENCE_REGISTRY.md | `[COMPLETE]` | EV-002 |
| F3 | Security hooks: bash-firewall.sh, secret-guard.sh | `[COMPLETE]` | EV-003..EV-004 |
| F4 | Context system: context packs, session-start hooks, subagent-context | `[COMPLETE]` | EV-005..EV-006 |
| F5 | Registry system: DECISION, CONTROL, INCIDENT, REGRESSION registries | `[COMPLETE]` | EV-007..EV-008 |
| F6 | Skills and agents: 28 skills, 5 agent definitions | `[COMPLETE]` | EV-009..EV-010 |
| F7 | Evaluation suite: evals/maintenance.sh, 12 checks, CI workflow | `[COMPLETE]` | EV-011..EV-012 |
| F8 | Hardening: contract_hash mandatory (F8-A), JSON firewall, reviewer convention | `[COMPLETE]` | EV-013..EV-016 |

### 33.2 F8 Specific Changes (F8-A)

F8 hardened the evidence contract:
- `contract_hash` absence exits 2 (was fail-open before F8-A)
- Firewall regex extended for case-tolerant SQL patterns
- Reviewer convention formalized

`POST_F8_AUDIT_REPORT.md` documents the F8 closure audit findings.

### 33.3 Freeze Invariants

F1-F8 are frozen. They may not be modified except:
- Security bug fixes (owner authorized)
- Regression test additions that don't change existing behavior

The F9 research program explicitly did not modify F1-F8 artifacts.

---

## 34. F9 / F10 State

**[RESEARCH / NOT AUTHORIZED]**

### 34.1 F9 State

F9 was the phase proposed to implement SAGR (State-Aware Governance of Resumption/Continuation).

**Research conclusion:** F9 NOT JUSTIFIED.

**Owner decision gate:** CLOSED 2026-09-20.

**Five owner decisions (F9_OWNER_DECISIONS.md):**

| Decision | Chosen | Meaning |
|----------|--------|---------|
| F9-D01 | A | Keep F9 closed; do not reopen based on current evidence |
| F9-D02 | B | Defer native Claude Code evidence (do not block on it) |
| F9-D03 | B | Defer documentary candidates |
| F9-D04 | B | External trigger for integrity work (wait for production observation) |
| F9-D05 | A | F10-F12 remain UNKNOWN |

**F9 reactivation conditions:** Not specified. F9 gate is CLOSED. A new owner-driven project decision is required to reopen any phase.

### 34.2 F10 State

**Classification:** `[UNKNOWN]` / `[NOT AUTHORIZED]`

F10 would be the first implementation phase after F9 research. It is:
- Not scoped
- Not designed
- Not authorized
- Not blocked on any specific gate (it simply does not exist yet)

**What F10 is NOT:** F10 is not "implementing SAGR." It is not "implementing non-bypass verification." F10's scope, if it ever exists, would require a new owner decision.

### 34.3 F11, F12 State

**Classification:** `[UNKNOWN]`

No scope, no design, no authorization. Status mirrors F10.

---

## 35. Tests and Evaluation Model

**[IMPLEMENTED]** `evals/maintenance.sh` is the primary evaluation mechanism.

### 35.1 Maintenance Suite (12 Checks)

| Check | What It Tests |
|-------|--------------|
| 1. jq available | System dependency present |
| 2. settings.json valid | JSON parse succeeds |
| 3. Regression budget valid | All REG entries have valid format |
| 4. install.sh syntax | Bash syntax check |
| 5. hooks/*.sh syntax | All hook scripts parse correctly |
| 6. Stop-hook idempotency | stop-logger does not double-fire |
| 7. Session-log rotation | Rotation triggers at threshold |
| 8. Skills validate | All skill files present and non-empty |
| 9. INC-001 regression | task-completed-evidence blocks without evidence |
| 10. Task-completed coupling | Hook is wired in settings.json |
| 11. State integrity | PROJECT_STATE.md has required fields |
| 12. Evidence freshness | All EV entries have recent timestamps |
| 12b. Firewall positive | bash-firewall blocks known destructive command |
| 12c. Secret-guard positive | secret-guard blocks known credential pattern |

Note: 12 named checks; some have sub-checks (evidence provenance count == artifact_hash count == EV entry count; docs reference check for stale strings).

### 35.2 R2 Harness (`evals/r2/r2-instrumentation.sh`)

5 checks specifically for R2 instrumentation:
1. `event_emitted_correctly=PASS`
2. `schema_valid=PASS`
3. `unknown_preserved=PASS`
4. `malformed_event_cannot_weaken_enforcement=PASS`
5. `instrumentation_failure_is_fail_safe=PASS`

### 35.3 CI Gate (`.github/workflows/control-plane.yml`)

Runs on every push and pull request:
1. Install `jq`
2. Run `bash evals/maintenance.sh`

### 35.4 Other Eval Directories

| Directory | Purpose |
|-----------|---------|
| `evals/benchmarks/` | Performance baseline captures |
| `evals/hooks/` | Hook-specific test payloads |
| `evals/incidents/` | Incident regression tests (INC-001 specific) |
| `evals/install/` | Install script idempotency tests |
| `evals/skills/` | Skill invocation validation |
| `evals/state/` | State integrity tests |

---

## 36. Audit Model

**[IMPLEMENTED]** CCP has multiple audit mechanisms.

### 36.1 Audit Cycle (per Phase)

```
AUDIT  -> inspect current state vs. designed state
IMPLEMENT -> make changes
TEST   -> run regression suite + specific tests
VERIFY -> maintenance.sh passes
EVIDENCE -> create EV-NNN entry
GATE   -> close phase; create git checkpoint
```

### 36.2 Independent Audits (R-series)

| Audit | Subject | Method | Result |
|-------|---------|--------|--------|
| R-1 | Prior art verification | 4 candidates against gap-closure criteria | Residual survives |
| R-2 | Instrumentation | Script-level verification of exit codes, JSONL schema, security invariant | AUDITED_CONFIRMED |
| R-3 | Non-bypass-verify design | Design completeness and falsifiability | AUDITED_CONFIRMED |
| Roger | Delta hypothesis | Independent audit of 3 candidate deltas | AUDITED_CONFIRMED, INDETERMINED |

### 36.3 Audit Classification

Each audit produces one of:
- `AUDITED_CONFIRMED` — audit completed; findings match claimed properties
- `AUDITED_EXCEPTION` — audit completed with exceptions noted
- `AUDIT_PENDING` — not yet audited
- `AUDIT_FAILED` — audit found material discrepancies

### 36.4 What Audit Does NOT Mean

- `AUDITED_CONFIRMED` is not a production safety guarantee
- Audit is not proof of correctness
- Script-level verification is not native Claude Code lifecycle verification

---

## 37. Control to Threat Matrix

**[IMPLEMENTED]** Map of controls to the threats they address.

| Threat | Control | Mechanism | Status |
|--------|---------|-----------|--------|
| Task completion without evidence | CTRL-001 | task-completed-evidence.sh (P0, fail-closed) | `[IMPLEMENTED]` |
| Destructive bash commands | (bash-firewall control) | bash-firewall.sh (P0, fail-closed) | `[IMPLEMENTED]` |
| Secret write to file | (secret-guard control) | secret-guard.sh (P0, fail-closed) | `[IMPLEMENTED]` |
| Secret in env files | permissions.deny | settings.json deny list | `[IMPLEMENTED]` |
| Phase creep | /gate skill + PROJECT_STATE | Manual gate check + state file | `[IMPLEMENTED]` |
| Decision fog | DECISION_REGISTRY | Structured decision records | `[IMPLEMENTED]` |
| Context drift after compaction | pre-compact + session-start-compact | Hash comparison | `[IMPLEMENTED]` |
| Supply chain attack | bash-firewall.sh | REGEX pattern match | `[IMPLEMENTED]` |
| Evidence hash fabrication | task-completed-evidence.sh | Non-zero 64-hex validation | `[IMPLEMENTED]` |
| Contract hash bypass | task-completed-evidence.sh (F8-A) | Absence exits 2 | `[IMPLEMENTED]` |
| Cross-tenant access | SECURITY_RULES.md + NO_GO.md | Rule layer (no P0 enforcement for generic case) | `[DESIGNED]` — project-specific |
| Policy bypass via alternative action | (none implemented) | R3 formal design exists | `[DESIGNED]` — R3; `[NOT AUTHORIZED]` for implementation |
| Stall without visibility | R2 instrumentation | STALL_POLICY_LOG.jsonl | `[IMPLEMENTED]` — observation only |

---

## 38. Component to Function to File Matrix

**[IMPLEMENTED]**

| Component | Primary Function | Primary File |
|-----------|-----------------|-------------|
| Evidence Gate | Block task completion without evidence | `.claude/hooks/task-completed-evidence.sh` |
| Bash Firewall | Block destructive commands | `.claude/hooks/bash-firewall.sh` |
| Secret Guard | Block secret writes | `.claude/hooks/secret-guard.sh` |
| State Injector | Inject current state at session start | `.claude/hooks/session-start-startup.sh` |
| Compaction Guard | Preserve and verify state across compaction | `.claude/hooks/pre-compact-snapshot.sh` + `session-start-compact.sh` |
| Context Injector | Inject role-specific context packs to subagents | `.claude/hooks/subagent-context.sh` |
| Activity Logger | Log session and subagent activity | `.claude/hooks/stop-logger.sh` + `subagent-stop-logger.sh` |
| Config Tracker | Track config changes | `.claude/hooks/config-change-logger.sh` |
| Stall Observer | Record policy denial events | `.claude/hooks/lib/stall-record.sh` |
| Phase Gate | Verify phase completion criteria | `.claude/skills/gate/` |
| Evidence Creator | Structured evidence entry workflow | `.claude/skills/evidence/` |
| Phase Closer | Close phases with checkpoint | `.claude/skills/cerrar-fase/` |
| State Reporter | Show current operational state | `.claude/skills/estado/` |
| Health Checker | Run maintenance suite | `.claude/skills/doctor/` |
| Incident Processor | Incident learning workflow | `.claude/skills/incident/` |
| Recovery Handler | 9 recovery scenarios | `.claude/skills/recovery/` |
| Architect Agent | System design (read+write; no bash) | `.claude/agents/architect.md` |
| Researcher Agent | Web research (no write) | `.claude/agents/researcher.md` |
| Implementer Agent | Code implementation (full access) | `.claude/agents/implementer.md` |
| Code Reviewer Agent | Independent review (read-only) | `.claude/agents/code-reviewer.md` |
| Security Auditor Agent | Security review (read-only) | `.claude/agents/security-auditor.md` |

---

## 39. File to Meaning Matrix

**[IMPLEMENTED]**

| File | Meaning |
|------|---------|
| `PROJECT_STATE.md` | Current phase, objective, blockers — single operational source of truth |
| `ARTIFACT_MANIFEST.md` | What was delivered in each phase — phase-gate delivery checklist |
| `DECISION_REGISTRY.md` | Why architectural choices were made — decision audit trail |
| `CONTROL_REGISTRY.md` | What controls are active and why — enforcement audit trail |
| `INCIDENT_REGISTRY.md` | What went wrong and what was learned — incident record |
| `REGRESSION_REGISTRY.md` | What is tested to prevent regression — test registry |
| `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | Verified task completion evidence — evidence audit trail |
| `docs/DESIGN.md` | How the system is architected — authoritative design document |
| `docs/MASTER_IMPLEMENTATION_PLAN.md` | How phases are contracted and executed — implementation contract |
| `docs/CONTROL_PLANE_HANDBOOK.md` | How to operate the system day-to-day — operational manual |
| `.claude/settings.json` | Which hooks fire on which events — runtime hook configuration |
| `.claude/hooks/bash-firewall.sh` | What bash commands are blocked — firewall policy |
| `.claude/hooks/secret-guard.sh` | What write operations are blocked — secret policy |
| `.claude/hooks/task-completed-evidence.sh` | What constitutes valid task completion — evidence contract |
| `.claude/hooks/lib/stall-record.sh` | How policy decisions are observed — R2 observation helper |
| `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | What policy decisions have been recorded — R2 observation log |
| `docs/00_SYSTEM/F9_OWNER_DECISIONS.md` | What was decided about F9 — owner decision record |
| `docs/00_SYSTEM/POST_F8_AUDIT_REPORT.md` | What F8 closure found — audit report |
| `MAP_COMPLETE.md` | Narrative history of CCP development — journey document (renamed from research.md) |
| `evals/maintenance.sh` | Whether the system is currently correct — health evaluation |
| `.github/workflows/control-plane.yml` | Whether CI enforces health — continuous integration gate |
| `install.sh` | How to deploy CCP to a new project — installation script |
| `docs/research/CCP_FINAL_RECONCILIATION/` | What research was done on SAGR/F9 — research archive |

---

## 40. Concept to Reality Matrix

**[CRITICAL]** Do not transform a concept in one column into a property of an adjacent column.

| Concept | Documentation | Implementation | Runtime Enforcement |
|---------|---------------|----------------|---------------------|
| Evidence-before-completion | DESIGN.md, MASTER_IMPLEMENTATION_PLAN | task-completed-evidence.sh | `[IMPLEMENTED]` via P0 hook |
| Phase-gate methodology | MASTER_IMPLEMENTATION_PLAN | PROJECT_STATE.md + /gate skill | `[IMPLEMENTED]` — manual gate |
| Fail-closed security | DESIGN.md | P0 hook exit codes | `[IMPLEMENTED]` — script-verified; `[UNKNOWN]` for native CC lifecycle |
| SAGR | Research artifacts | Not implemented | `[NOT AUTHORIZED]` |
| Non-bypass verification | R3 design document | Not implemented | `[NOT AUTHORIZED]` |
| Roger hypothesis deltas | 52_ROGER_POST_AUDIT | Not implemented | `[NOT AUTHORIZED]` |
| Cryptographic evidence signing | DESIGN.md (future) | Not implemented | `[NOT AUTHORIZED]` |
| Context packs for target project | `.claude/context/*.md` | Template files with placeholders | `[IMPLEMENTED]` — templates only; placeholders not filled for target |
| R2 observation | 48_R2_INSTRUMENTATION | stall-record.sh + bash-firewall + task-completed-evidence | `[IMPLEMENTED]` — observation only; not analysis |
| F10 | UNKNOWN | Not scoped | `[NOT AUTHORIZED]` |

---

## 41. End-to-End Flows AH

**[IMPLEMENTED]** These flows describe the actual behavior of the implemented system.

### Flow A: New Session Start

```
User opens Claude Code in CCP directory
    |
    v SessionStart event (startup)
session-start-startup.sh fires (P1, fail-open)
    | reads PROJECT_STATE.md
    | extracts: phase, objective, blockers, decisions, checkpoint
    | outputs: additionalContext JSON
    v
Claude agent session begins with operational context injected
    | knows: current phase is 8, F9 NOT JUSTIFIED, no active blockers
    v
Agent responds to user with informed context
```

### Flow B: Post-Compaction Resume

```
Context compaction occurs (session grows large)
    |
    v PreCompact event
pre-compact-snapshot.sh fires (P1, fail-open)
    | copies PROJECT_STATE.md to .claude/backups/PROJECT_STATE.precompact.md
    | computes sha256 of critical fields
    | writes hash to .claude/backups/PROJECT_STATE.critical.sha256
    v
Compaction occurs; context summary replaces history
    |
    v SessionStart event (compact)
session-start-compact.sh fires (P1, fail-open)
    | reads current PROJECT_STATE.md
    | computes sha256 of critical fields
    | compares to stored hash
    | reports: STATE_INTEGRITY=PASS or DRIFT_DETECTED
    v
Agent resumes with integrity report in context
```

### Flow C: Destructive Command Attempt

```
Agent attempts: bash("rm -rf /important/data")
    |
    v PreToolUse: Bash event
bash-firewall.sh fires (P0, fail-closed)
    | reads JSON from stdin
    | checks for null bytes -> OK
    | parses JSON with jq -> OK
    | extracts .tool_input.command
    | checks DESTRUCTIVE_REGEX -> MATCH
    |
    +-- stall_record_event(bash-firewall.sh, DENY, STALL_POLICY, ...) || true
    |   -> writes JSONL event to STALL_POLICY_LOG.jsonl
    |
    `-- exit 2

Bash tool call BLOCKED
Agent receives block response; cannot execute command
```

### Flow D: Secret Write Attempt

```
Agent attempts to write a file containing a literal API credential
    |
    v PreToolUse: Write event
secret-guard.sh fires (P0, fail-closed)
    | reads JSON from stdin
    | extracts .tool_input.content
    | checks credential patterns -> MATCH (e.g., API key or PEM header)
    |
    `-- exit 2

Write tool call BLOCKED
Agent receives block response; cannot write credential to file
```

### Flow E: Task Completion Attempt (Valid)

```
Agent signals TaskCompleted with task_id="TASK-42", contract_hash="sha256:abc..."
    |
    v TaskCompleted event
task-completed-evidence.sh fires (P0, fail-closed)
    | reads JSON from stdin
    | extracts task_id, contract_hash, risk_level
    | contract_hash present -> continues (F8-A check passes)
    | AWK scans EVIDENCE_REGISTRY.md
    | finds entry for TASK-42
    | Status = VERIFIED -> OK
    | artifact_hash = sha256:<64 non-zero hex> -> OK
    | contract_hash matches -> OK
    | checks: tests=PASS, static=PASS, security=PASS -> OK
    | reviewer = PASS -> OK
    | exceptions = NONE -> OK
    | timestamp = valid ISO-8601 -> OK
    |
    `-- exit 0

Task completion ACCEPTED
```

### Flow F: Task Completion Attempt (Invalid — Missing Evidence)

```
Agent signals TaskCompleted with task_id="TASK-99", contract_hash="sha256:xyz..."
    |
    v TaskCompleted event
task-completed-evidence.sh fires (P0, fail-closed)
    | reads JSON from stdin
    | extracts task_id, contract_hash
    | AWK scans EVIDENCE_REGISTRY.md
    | no entry for TASK-99 found
    | Status != VERIFIED
    |
    +-- stall_record_event(task-completed-evidence.sh, DENY, UNKNOWN, ...) || true
    |   -> writes JSONL event to STALL_POLICY_LOG.jsonl
    |
    `-- exit 2

Task completion BLOCKED
Agent cannot mark task done; must create evidence entry first
```

### Flow G: Subagent Launch

```
User (or orchestrator agent) spawns architect subagent
    |
    v SubagentStart event
subagent-context.sh fires (P2, fail-open)
    | reads agent_type = "architect"
    | looks up context pack mapping:
    |   architect -> CORE, CURRENT_STATE, DECISIONS, SECURITY_RULES
    | reads each context pack file
    | outputs: additionalContext with all 4 packs
    v
Architect subagent starts with injected context:
    - Knows current phase and objectives (CURRENT_STATE)
    - Knows active architectural decisions (DECISIONS)
    - Knows security rules (SECURITY_RULES)
    - Knows project fundamentals (CORE)
```

### Flow H: Phase Closure

```
Owner decides phase is complete
    |
    v Owner invokes /cerrar-fase skill
/cerrar-fase loads and executes skill instructions
    | 1. Verifies all CONTRACTUAL TASKs have VERIFIED evidence
    | 2. Runs maintenance suite (evals/maintenance.sh)
    | 3. Verifies regression suite passes
    | 4. Updates PROJECT_STATE.md:
    |    - PHASE_STATUS = COMPLETE
    |    - NEXT_ALLOWED_PHASE = (next phase or None auto)
    | 5. Creates git commit with [FASE-N] prefix
    | 6. Updates LAST_GIT_CHECKPOINT
    v
Phase N frozen; PROJECT_STATE reflects completion
```

---

## 42. New Engineer Orientation

**[INFORMATIONAL]** For someone encountering CCP for the first time.

### 42.1 Start Here

1. Read `README.md` — quick start and what CCP is
2. Read `PROJECT_STATE.md` — current operational state
3. Read `docs/CONTROL_PLANE_HANDBOOK.md` — operational manual
4. Run `bash evals/maintenance.sh` — verify system health

### 42.2 Key Mental Model

CCP is a **governance layer**, not a product. It doesn't build features; it enforces how features are built. Think of it as a combination of:
- Git hooks (but managed and documented)
- An evidence audit trail (for AI-generated work)
- A phase-gate project management system
- An incident learning loop

### 42.3 The Most Important Thing

**You cannot mark a task "done" without evidence.** This is enforced by a P0 hook that cannot be bypassed. If you try, the task completion is blocked. You must create an evidence entry in `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` first.

### 42.4 What You Can Do

- Read any file (all files are readable)
- Run read-only commands (ls, grep, cat, find, git status/log)
- Invoke skills (/estado, /evidence, /gate, /doctor, /checkpoint)
- Create evidence entries for your work
- Open incidents when you find governance failures

### 42.5 What You Cannot Do Without Owner Authorization

- Open new phases (F9+)
- Modify F1-F8 artifacts
- Modify R2, R3, or Roger research artifacts
- Push to the remote repository (requires confirmation)
- Delete files (requires confirmation)
- Write credentials to files (blocked by P0 hook)
- Issue destructive bash commands (blocked by P0 hook)

### 42.6 Skill Quick Reference

| Need | Skill |
|------|-------|
| Current state? | `/estado` |
| Create evidence? | `/evidence` |
| Check phase gate? | `/gate` |
| Health check? | `/doctor` |
| Create checkpoint? | `/checkpoint` |
| Close a phase? | `/cerrar-fase` |
| Incident occurred? | `/incident` |
| Need to recover? | `/recovery` |

---

## 43. Rebuild Conceptual Model

**[INFORMATIONAL]** If you needed to rebuild CCP from scratch, these are the conceptual components in order of dependency.

### 43.1 Layer 0: Prerequisites

1. A git repository for the target project
2. Claude Code installed with native hook support
3. `jq` installed on the host system

### 43.2 Layer 1: Evidence Contract (First Principle)

The evidence contract is the foundational innovation. Without it, there is no verifiable governance. Build `task-completed-evidence.sh` first. Define the EVIDENCE_REGISTRY schema. Define what "VERIFIED" means.

### 43.3 Layer 2: Security Hooks

Add `bash-firewall.sh` and `secret-guard.sh`. These are independent of the evidence contract and can be developed in parallel. Define the permissions model.

### 43.4 Layer 3: State Model

Define `PROJECT_STATE.md` schema. Build `session-start-startup.sh` to inject it. Build `pre-compact-snapshot.sh` and `session-start-compact.sh` to protect it.

### 43.5 Layer 4: Registry System

Build `DECISION_REGISTRY.md`, `CONTROL_REGISTRY.md`, `INCIDENT_REGISTRY.md`, `REGRESSION_REGISTRY.md`. Trace INC-001 -> CTRL-001 -> REG-001 as the first complete learning loop.

### 43.6 Layer 5: Context System

Build the 6 context packs. Build `subagent-context.sh` to inject them. Build role-specific agent definitions.

### 43.7 Layer 6: Skills and Evaluation

Build operational skills (/evidence, /gate, /cerrar-fase, /estado, /doctor). Build `evals/maintenance.sh`. Wire CI.

### 43.8 Layer 7: Observation (R2)

Build `stall-record.sh` library. Instrument P0 hooks with non-gating observation calls. Build `STALL_POLICY_LOG.jsonl`.

---

## 44. Known Gaps

**[OPEN]** Gaps between designed behavior and implemented behavior.

### 44.1 Native Claude Code Lifecycle Unverified

**Gap:** All hook behavior is script-verified using bash invocations. Whether hooks fire correctly in the native Claude Code event dispatch is `[UNKNOWN]`.  
**Impact:** The entire hook architecture assumes native lifecycle fidelity.  
**Mitigation:** Script-level tests cover logic correctness. Field observation (R2) would detect hooks not firing.

### 44.2 Context Packs Are Templates

**Gap:** The 6 context packs in `.claude/context/` contain template placeholders designed for target deployments, not for CCP itself.  
**Impact:** When CCP is used as the target (not just as a template), context packs may not reflect the actual project.  
**Mitigation:** `CURRENT_STATE.md` and `DECISIONS.md` are partially filled with CCP-specific data.

### 44.3 Cross-Tenant Isolation is Rule-Only

**Gap:** The NO_GO.md rule says "no cross-tenant access without verified tenant_id." No P0 hook enforces this at the bash/write level.  
**Impact:** Relying on rule compliance rather than enforcement.  
**Mitigation:** Rule is in both NO_GO.md and SECURITY_RULES.md. Actual enforcement is project-specific.

### 44.4 Evidence Cryptographic Integrity

**Gap:** Evidence entries are SHA-256 hash strings, but there is no cryptographic signature verifying who created them or that they haven't been modified.  
**Impact:** A party with file write access could modify an evidence entry.  
**Mitigation:** Git history provides tamper evidence for committed files. Future enhancement designed.

### 44.5 No Secret-Guard R2 Instrumentation

**Gap:** `secret-guard.sh` is not instrumented with R2 observation. Only bash-firewall and task-completed-evidence emit stall events.  
**Impact:** Write-block events are not observable via STALL_POLICY_LOG.  
**Mitigation:** The R2 contract explicitly limits to two hooks for minimum viable instrumentation.

---

## 45. Known Unknowns

**[UNKNOWN]** Things CCP does not know about itself.

| Unknown | Domain | Impact |
|---------|--------|--------|
| Native hook dispatch fidelity | Runtime | High — entire hook architecture depends on this |
| Actual policy block frequency in operation | Observability | Medium — R2 has only 1 test event |
| Whether `task_id` appears in TaskCompleted payloads | Runtime | Medium — null in current log event |
| Whether `had_alternative` ever has a non-null value in practice | Research | Medium — always null in R2 |
| Whether secret-guard is triggered in normal operation | Observability | Medium — no R2 instrumentation |
| Whether compaction state drift ever occurs in practice | Reliability | Low — no observed DRIFT_DETECTED |
| Maintenance suite performance at scale | Performance | Low — currently instantaneous |
| Hook execution order when multiple hooks match same event | Runtime | Low — currently only one hook per event type |

---

## 46. Frozen Boundaries

**[NOT AUTHORIZED]** What is explicitly frozen and cannot change without a new owner decision.

### 46.1 Frozen Artifacts (No Modification Permitted)

| Artifact | Frozen Since |
|----------|-------------|
| `EVIDENCE_REGISTRY.md` (EV-001..EV-016) | F8 COMPLETE |
| `DECISION_REGISTRY.md` (ARCH-001..ARCH-004) | F8 COMPLETE |
| `CONTROL_REGISTRY.md` (CTRL-001) | F8 COMPLETE |
| `INCIDENT_REGISTRY.md` (INC-001) | F8 COMPLETE |
| `REGRESSION_REGISTRY.md` (REG-001..REG-011) | F8 COMPLETE |
| All hook implementations (F1-F8) | F8 COMPLETE |
| `docs/research/CCP_FINAL_RECONCILIATION/` (all artifacts) | Research closed |
| `docs/research/CCP_RESEARCH_CONTEXT_MASTERC.md` | Research closed |
| R2 implementation (unless rollback authorized) | R2 COMPLETE |
| R3 design document | R3 COMPLETE |

### 46.2 Frozen State

| State | Current Value | Can Change? |
|-------|--------------|------------|
| CURRENT_PHASE | 8 | Not without owner decision |
| PHASE_STATUS | COMPLETE | Not without owner decision |
| NEXT_ALLOWED_PHASE | None auto | Not without owner decision |
| F9 gate | CLOSED | Not without owner decision |
| IMPLEMENTATION_READY | false | Not without F9 reopening |

### 46.3 Explicitly Prohibited Actions

- Opening F9, F10, F11, F12
- Modifying hook security behavior
- Adding new hooks, skills, agents, or registries (without owner decision)
- Implementing SAGR
- Implementing non-bypass verification (R3)
- Converting Roger hypothesis to architecture
- Fabricating evidence entries
- Making commits (in the context of this mapping task)

---

## 47. Final System Blueprint

**[IMPLEMENTED]** The system as it exists today, in one view.

```
=====================================================================
  CLAUDE CONTROL PLANE  |  v1.0  |  F8 COMPLETE
=====================================================================

GOVERNANCE LAYER
  PROJECT_STATE.md --------- single operational truth
  DECISION_REGISTRY.md ----- architectural decision log
  CONTROL_REGISTRY.md ------ enforcement control log
  INCIDENT_REGISTRY.md ----- incident learning log
  REGRESSION_REGISTRY.md --- regression test registry

EVIDENCE LAYER
  EVIDENCE_REGISTRY.md ---- 16 verified task evidence entries
  task-completed-evidence.sh -- P0 gate on TaskCompleted

SECURITY LAYER
  bash-firewall.sh -------- P0 gate on Bash (destructive/secrets)
  secret-guard.sh --------- P0 gate on Write/Edit (secrets)
  permissions.deny -------- Platform-level file access deny list

CONTEXT LAYER
  6 context packs --------- role-specific knowledge injection
  subagent-context.sh ----- SubagentStart hook; injects packs

STATE PROTECTION LAYER
  pre-compact-snapshot.sh -- PreCompact hash preservation
  session-start-compact.sh - Post-compaction integrity check
  session-start-startup.sh - State injection at session start

OBSERVATION LAYER (R2)
  stall-record.sh --------- non-gating event helper
  STALL_POLICY_LOG.jsonl -- 1 observed event (test)

OPERATIONAL SKILLS
  /evidence /gate /cerrar-fase /estado /doctor /incident /recovery
  + 20 additional skills

AGENT PERSONAS
  architect | researcher | implementer | code-reviewer | security-auditor

EVALUATION
  evals/maintenance.sh ---- 12 deterministic checks
  evals/r2/ --------------- R2 harness (5 checks)
  .github/workflows/ ------ CI on push/PR

INSTALLATION
  install.sh -------------- deploys CCP to target project

=====================================================================

RESEARCH ARCHIVE (not system properties)
  42: Residual problem (OPEN)
  47: R-1 prior art verification (4 candidates, all NO)
  48: R-2 instrumentation (IMPLEMENTED + AUDITED)
  50: R-3 non-bypass-verify design (DESIGNED + AUDITED)
  52: Roger hypothesis post-audit (RESEARCH + AUDITED, INDETERMINED)

FROZEN / NOT AUTHORIZED
  F9: NOT JUSTIFIED (gate CLOSED)
  F10-F12: UNKNOWN / NOT AUTHORIZED
  SAGR: NOT AUTHORIZED
  Non-bypass verification runtime: NOT AUTHORIZED

=====================================================================
```

---

## 48. Current Truth State

**[VERIFIED]** The ground truth of CCP as of 2026-09-22, derived solely from repository source.

### 48.1 Phase State

```
CURRENT_PHASE:        8
PHASE_STATUS:         COMPLETE
F9_STATUS:            NOT JUSTIFIED (gate CLOSED 2026-09-20)
F10_STATUS:           UNKNOWN / NOT AUTHORIZED
IMPLEMENTATION_READY: false
```

### 48.2 Control Plane Version

```
CONTROL_PLANE_VERSION: 1.0
LAST_GIT_CHECKPOINT:   3336bd6
```

### 48.3 Hook State

| Hook | Wired | Verified | Exit on Failure |
|------|-------|---------|----------------|
| bash-firewall.sh | YES | Script-level | exit 2 (BLOCK) |
| secret-guard.sh | YES | Script-level | exit 2 (BLOCK) |
| task-completed-evidence.sh | YES | Script-level | exit 2 (BLOCK) |
| session-start-startup.sh | YES | Script-level | exit 0 |
| session-start-compact.sh | YES | Script-level | exit 0 |
| pre-compact-snapshot.sh | YES | Script-level | exit 0 |
| stop-logger.sh | YES | Script-level | exit 0 |
| subagent-context.sh | YES | Script-level | exit 0 |
| subagent-stop-logger.sh | YES | Script-level | exit 0 |
| config-change-logger.sh | YES | Script-level | exit 0 |
| stall-record.sh (lib) | sourced by P0 | Script-level | non-gating |

**Native Claude Code lifecycle:** `[UNKNOWN]` for all hooks

### 48.4 Evidence State

- 16 VERIFIED entries (EV-001..EV-016)
- All entries: Status=VERIFIED, Provenance=GENERATED, Confidence=HIGH
- All entries: sha256: artifact_hash (non-zero, 64 hex)
- All entries: sha256: contract_hash
- All entries: Exceptions=NONE

### 48.5 Maintenance State

Last known state: 12/12 PASS (from R2 post-change verification 2026-09-22)

### 48.6 Research State

| Research Item | Status |
|--------------|--------|
| R-1 (prior art) | EXECUTED — no gap closure |
| R-2 (instrumentation) | EXECUTED + AUDITED |
| R-3 (formal design) | DESIGNED + AUDITED |
| Roger hypothesis | AUDITED + INDETERMINED |
| Residual problem (art. 42) | OPEN |

### 48.7 Outstanding Uncommitted Changes

As of session start, git status showed:
- Modified: `.claude/hooks/bash-firewall.sh`, `.claude/hooks/task-completed-evidence.sh` (R2 changes)
- Modified: `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`
- Untracked: `.claude/hooks/lib/` (stall-record.sh), `MAP_COMPLETE.md`, `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`, `docs/research/CCP_FINAL_RECONCILIATION/`, `docs/research/CCP_RESEARCH_CONTEXT_MASTERC.md`, `evals/r2/`

These represent R2 work and research artifacts that have not been committed.

---

## GENERATION METADATA

```
MAP STATUS:              COMPLETE
DOCUMENT:                docs/00_SYSTEM/CCP_COMPLETE_CONCEPTUAL_MAP.md
FILES MODIFIED:          0 (this document only, new file)
RUNTIME MODIFIED:        NO
F1-F8 MODIFIED:          NO
R2 MODIFIED:             NO
R3 MODIFIED:             NO
NEW PHASE:               NO
IMPLEMENTATION:          NONE
COMMIT:                  NO

TOTAL FILES INVENTORIED: 60+ (all major paths documented)
TOTAL COMPONENTS MAPPED: 21 (see Component Model section 10)
TOTAL HOOKS MAPPED:      11 (10 + stall-record.sh library)
TOTAL SKILLS MAPPED:     28
TOTAL REGISTRIES MAPPED: 5 (DECISION, CONTROL, INCIDENT, REGRESSION, EVIDENCE)
TOTAL END-TO-END FLOWS:  8 (Flows A-H)

MAIN UNKNOWN:            Native Claude Code lifecycle verification
                         (hooks are script-verified only; native dispatch unconfirmed)

FINAL STATE: CCP CONCEPTUAL MAP COMPLETE -- NO IMPLEMENTATION PERFORMED
```

---

*End of CCP_COMPLETE_CONCEPTUAL_MAP.md*
