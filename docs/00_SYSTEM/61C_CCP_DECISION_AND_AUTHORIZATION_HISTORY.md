# 61C — CCP Decision and Authorization History

**Created:** 2026-09-23  
**Purpose:** Complete record of every significant decision with full context. Operational decisions in DECISION_REGISTRY.md; owner gates in F9_OWNER_DECISIONS.md; this document provides the historical context and evolution.

---

## Part I — Architectural Decisions (ACTIVE)

### ARCH-001 — Project Scope

```
ID:      ARCH-001
TIPO:    INFRA
ESTADO:  APROBADA (2026-09-16)

DECISION: The control plane is installed at PROJECT scope (.claude/).
          No global (~/.claude/) installation.

WHY:     Global installation would affect ALL Claude Code projects, not just this one.
         BLAST RADIUS must be controlled.

WHAT IT AUTHORIZES:
  - All hooks, agents, skills, rules configured in .claude/
  - User/global scope only for deliberate global configurations

WHAT IT PROHIBITS:
  - Installing CCP infrastructure globally by default
  - Modifying global settings as part of project changes

CURRENT STATUS: Active; no change.
EVIDENCE: EV-001
```

### ARCH-002 — Context Pack Loading

```
ID:      ARCH-002
TIPO:    INFRA
ESTADO:  APROBADA (2026-09-16)

DECISION: SubagentStart.additionalContext injects context packs by role.
          No dependency on the `skills:` field in agent frontmatter.

WHY:     The `skills:` field in agent frontmatter has no documented runtime contract.
         It is not verified to cause skill loading. Using it as an enforcement mechanism
         would introduce an invisible dependency on an undocumented behavior.

WHAT IT AUTHORIZES:
  - subagent-context.sh hook to inject role-specific packs at SubagentStart
  - Context pack content in .claude/context/*.md files

WHAT IT PROHIBITS:
  - Relying on `skills:` field as the mechanism for context injection

CURRENT STATUS: Active; no change.
EVIDENCE: EV-001
```

### ARCH-003 — Canonical Evidence Path

```
ID:      ARCH-003
TIPO:    INFRA
ESTADO:  APROBADA (2026-09-16)

DECISION: ALL evidence lives in docs/00_SYSTEM/EVIDENCE_REGISTRY.md.
          No secondary evidence location.

WHY:     Having two evidence registries (root and docs/) creates confusion about
         which is authoritative.

WHAT IT AUTHORIZES:
  - docs/00_SYSTEM/EVIDENCE_REGISTRY.md as the sole evidence file
  - task-completed-evidence.sh to search exactly this path

WHAT IT PROHIBITS:
  - Creating a root EVIDENCE_REGISTRY.md with different content
  - Split evidence between locations

CURRENT STATUS: Active; no change.
EVIDENCE: EV-001
```

### ARCH-004 — Task Tracking Semantics

```
ID:      ARCH-004
TIPO:    PROCESS
ESTADO:  APROBADA (2026-09-18); AMENDED F8-A (2026-09-19)

DECISION: Work is classified as:
  - CONTRACTUAL TASK: requires VERIFIED evidence + contract_hash; passes through TaskCompleted gate
  - INTERNAL TODO / CHECKLIST: no EV-NNN required; marked deleted when containing contract closes
  - SUBTASK: no individual evidence required
  - RESEARCH NOTE: documented; does not pass through gate

WHY:     Originally: Prevents over-engineering evidence for every micro-task.
         F8-A reason: contract_hash was optional in F7 transition; this allowed evidence
         entries without hash coupling. Fail-closed was necessary to prevent hash bypass.

F8-A ADDENDUM (2026-09-19):
  contract_hash is MANDATORY for all CONTRACTUAL TASKs.
  Omission is fail-closed (exit 2 from task-completed-evidence.sh).
  The F7 transactional warning is SUPERSEDED.

WHAT IT AUTHORIZES:
  - Distinguishing task types in evidence entries
  - Non-contractual work without individual evidence entries
  - task_id format: <phase>-<slug>-YYYY-MM-DD-<hash>

WHAT IT PROHIBITS:
  - CONTRACTUAL TASK without contract_hash (since F8-A)
  - Submitting TaskCompleted with missing hash (fail-closed)

CURRENT STATUS: Active + F8-A addendum permanent.
EVIDENCE: F7_F12_RESEARCH_HANDOFF.md sections J/AI; EV-012 (F7); EV-015 (F8-A)
```

---

## Part II — F9 Owner Decisions (CLOSED 2026-09-20)

These five decisions closed the F9 owner gate. They are PERMANENT and cannot be reopened except by their stated reactivation triggers.

### F9-D01 = A — Keep F9 Implementation Closed

```
QUESTION:  Should any F9 runtime implementation be authorized after F9 research?

OPTIONS:
  A: No implementation authorized. Keep F9 closed.
  B: Authorize some F9 items.

DECISION:  A — Keep F9 implementation closed.

WHAT IT AUTHORIZES: Nothing new at runtime.
  Current controls remain the declared enforcement surface:
  bash-firewall.sh, secret-guard.sh, task-completed-evidence.sh,
  fixtures, maintenance, Git + reviewer trust boundary.

WHAT IT PROHIBITS:
  - Any runtime implementation of R-3 non-bypass verification
  - Any new agent definition file (CDT-02 is blocked by this)
  - AC-03 (subagent verifier) implementation
  - Promoting deferred candidates to implementation without new authorization cycle

WHAT IT DID NOT DECIDE:
  - Whether future research (READY-01/02/03/04) could be authorized separately
  - The shape of F10-F12

REACTIVATION TRIGGERS (not authorizations):
  - Reproducible incident that a current control does not cover
  - Firewall bypass that survives F8 fixtures
  - Tool failure demonstrably lost by manual incident workflow
  - Deterministic native reproduction of G-B11 phantom SubagentStop events

STATUS: CLOSED / PERMANENT until reactivation trigger
```

### F9-D02 = B — Defer Native Claude Code Evidence

```
QUESTION:  When should native Claude Code lifecycle evidence be obtained?

DECISION:  B — Defer until concrete trigger. NOT_VERIFIED ≠ BROKEN.

WHAT IT AUTHORIZES:
  - Accepting NOT_VERIFIED as a valid, non-defect knowledge boundary
  - OpenCode-executed scripts and fixtures as current verification surface

WHAT IT PROHIBITS:
  - Reinterpreting NATIVE CLAUDE CODE LIFECYCLE = NOT_VERIFIED as "BROKEN"
  - Spinning up a disposable native environment without trigger

REACTIVATION TRIGGERS:
  - Deterministic recurrence of G-B11 phantom SubagentStop events
  - A native integration decision depending on dispatcher facts
  - Owner decision that the verification gap is no longer acceptable

STATUS: CLOSED / DEFERRED
```

### F9-D03 = B — Keep Documentary Candidates Deferred

```
QUESTION:  Should documentary improvement candidates (NH-01, architectural notes) be promoted?

DECISION:  B — Keep deferred.

WHAT IT AUTHORIZES: Nothing new.
WHAT IT PROHIBITS: Unilateral promotion of documentary candidates to implementation.

STATUS: CLOSED / DEFERRED
```

### F9-D04 = B — Require External Trigger for Integrity Work

```
QUESTION:  Should integrity controls (A-05, A-07, G-N5) be started?

DECISION:  B — Require external trigger (audit, compliance, contractual, customer requirement).

WHAT IT AUTHORIZES: Nothing new.
WHAT IT PROHIBITS:
  - Starting A-05, A-07, G-N5 without an external trigger
  - Treating Git + reviewer trust boundary as insufficient without evidence

DEFERRED ITEMS: A-05, A-07, G-N5

REACTIVATION TRIGGERS:
  - External audit requirement
  - Compliance obligation
  - Contractual or customer requirement
  - Explicit expansion of trust boundary scope

STATUS: CLOSED / DEFERRED
```

### F9-D05 = A — Keep F10-F12 Unknown

```
QUESTION:  Should F10-F12 be defined now?

DECISION:  A — Keep UNKNOWN / NOT STARTED.

WHAT IT AUTHORIZES: Nothing new.
WHAT IT PROHIBITS: Opening F10-F12 without concrete evidence crossing a phase threshold.

WHAT IT DID NOT DECIDE:
  - What F10-F12 will contain
  - Whether they will ever be needed

REACTIVATION TRIGGER:
  - Concrete evidenced problem crossing a phase threshold

STATUS: CLOSED / DEFERRED indefinitely
```

---

## Part III — READY Decisions (Pending — Not Yet Authorized)

These four decision packages are READY for owner review. They were built across M003-M006.

### READY-01 — Policy Disambiguation (AC-02)

```
WHAT: Authorize adding one sentence of disambiguation to each of 4 PARTIAL policies:
  - POL-08: exception for explicit authorized commands (F9-D01=A created an exception)
  - POL-10: explicit scope for "significant changes"
  - POL-13: explicit when integrity verification is required

M006 CORRECTION: READY-01 was originally framed as "documentation-only."
CORRECTED: 3 of 4 repairs ADD NEW CONSTRAINTS OR EXCEPTIONS to existing rules.
This is a policy change, not just editorial clarification.

WHAT IT AUTHORIZES:
  - Modifying rules/*.md to add disambiguation sentences
  - The specific language in 59A_EXECUTION_REHEARSAL.md

WHAT IT DOES NOT AUTHORIZE:
  - Any hook modification
  - AC-03 (separate authorization)
  - New enforcement patterns (separate READY-02)

DEPENDENCIES: None (independent)

CURRENT STATUS: OWNER_DECISION_READY (pending authorization)
DOCUMENT: 58_OWNER_DECISION_PACKAGE.md §READY-01
```

### READY-02 — NH-09 Normalization + P1'/P2' Patterns

```
WHAT: Authorize adding Level-1 normalization and new firewall patterns to bash-firewall.sh:
  - NH-09: two sed operations (double-quote removal, brace normalization)
  - P1': {cmd}_{word} variant pattern (specific regex in 60_FRONTIER_BREAKOUT.md §C2)
  - P2': double-quoted variant pattern (specific regex in 60_FRONTIER_BREAKOUT.md §C2)

INVARIANT REQUIREMENT: Any modification to bash-firewall.sh must preserve the
COMMAND/COMMAND_NORM invariant. COMMAND_NORM must not be set before the sed operations run.

M006 NOTE: Dual-variable architecture (COMMAND and COMMAND_NORM) must be preserved.
           Implementation rehearsal in 59A_.

WHAT IT AUTHORIZES:
  - Modifying bash-firewall.sh to add normalization + 2 new patterns
  - The exact implementation in 59A_EXECUTION_REHEARSAL.md §2.2

WHAT IT DOES NOT AUTHORIZE:
  - NH-11 (single-quote normalization) — separate hypothesis
  - AC-03 or any new agent

DEPENDENCIES: None (independent of READY-01)

CURRENT STATUS: OWNER_DECISION_READY (pending authorization)
DOCUMENT: 58_OWNER_DECISION_PACKAGE.md §READY-02
```

### READY-03 — L1-C Minimal Closure (Labyrinth Exit Condition B)

```
WHAT: Authorize documenting the L1-C threshold (exit condition B for LABYRINTH-1):
  "If the number of real STALL_POLICY events with had_alternative≠null
   falls below N, LABYRINTH-1 closes as IMMATERIAL."

M006 CORRECTIONS:
  1. N threshold WAS UNDEFINED — added "REQUIRED OWNER INPUT" field. Owner must provide N.
  2. RISK was MEDIUM — corrected to UNKNOWN (insufficient evidence for MEDIUM).

M007 NOTE:
  - N = 1 is the analytically-derived recommendation (any event is informative)
  - Current H-01 count = 2, BOTH are PAC-EF-02 false positives
  - Genuine bypass events = 0

WHAT IT AUTHORIZES:
  - Documenting the N threshold + closure condition in appropriate registry
  - Accepting immateriality if count < N

WHAT IT DOES NOT AUTHORIZE:
  - Any implementation of hypothesis A (non-bypass verification)
  - New agent or hook changes

DEPENDENCIES:
  - Requires owner to provide N value (not defined by research alone)
  - H-01 field data needed to actually close LABYRINTH-1 (not unlocked by READY-03 alone)

CURRENT STATUS: OWNER_DECISION_READY (pending N definition from owner)
DOCUMENT: 58_OWNER_DECISION_PACKAGE.md §READY-03
```

### READY-04 — Enhanced-B Message Implementation (AC-01)

```
WHAT: Authorize updating bash-firewall.sh denial messages with structured context:
  - STALL_POLICY message format: policy ID, policy text, what was blocked, what alternatives exist
  - Human-readable denial message with enough context for accurate human review decision

M007 ELEVATED URGENCY:
  PAC-EF-02 FPs (pattern-name-in-literal class) are hard to classify WITHOUT structured
  denial messages. Enhanced messages would allow humans to quickly identify FP class.
  Current H-01 count = 2 = both FPs = classification difficult without structured context.

WHAT IT AUTHORIZES:
  - Modifying bash-firewall.sh STALL_POLICY messages to include structured context
  - The specific message format in 59A_EXECUTION_REHEARSAL.md §READY-04

WHAT IT DOES NOT AUTHORIZE:
  - Any new pattern or normalization logic (that's READY-02)
  - AC-03

DEPENDENCIES: None (independent; but synergistic with READY-02)

CURRENT STATUS: OWNER_DECISION_READY (pending authorization; ELEVATED URGENCY)
DOCUMENT: 58_OWNER_DECISION_PACKAGE.md §READY-04
```

---

## Part IV — Authorization Boundaries

### What Any AI Can Do NOW (No Authorization Needed)

```
READ:
  - Any file in the repository
  - Git log, status, diff

WRITE (documentation/research, no runtime impact):
  - docs/CONTROL_PLANE_HANDBOOK.md (add HRQS §13)
  - docs/research/pac/ccp_policies.yaml (extend PAC corpus)
  - docs/research/CCP_FINAL_RECONCILIATION/ (new research documents)
  - docs/00_SYSTEM/CCP_EXPLORATION_ENGINE.md (update after a movement)
  - New movement documents (61_*, research artifacts)
  - PROJECT_STATE.md (state updates after a movement)
  - docs/00_SYSTEM/CLAUDE_SESSION_LOG.md (session entries)

EXECUTE:
  - evals/maintenance.sh (health check)
  - Read-only git commands
  - Research experiments (document results; no .claude/ changes)
```

### What Requires Owner Authorization

```
RUNTIME CHANGES (.claude/):
  - Any modification to .claude/hooks/ files
  - Any modification to .claude/settings.json permissions
  - Any new agent definition file
  - Any new hook

POLICY CHANGES:
  - Modifying .claude/rules/ files (READY-01)
  - Adding new enforcement patterns (READY-02)

ARCHITECTURAL CHANGES:
  - F10-F12 scope definition (F9-D05=A)
  - New registry type
  - Trust boundary expansion (F9-D04=B)
```

### What Requires Real Environment

```
MEASUREMENT:
  - H-01 stall frequency (needs production usage)
  - P1'/P2' false positive rate (needs real usage)
  - CDT-02 blind verifier test (needs real usage + new agent auth)
```

### What Is Permanently Blocked (Current Authorization State)

```
F9-D01=A BLOCKS:
  - AC-03 (subagent verifier)
  - CDT-02 (blind verifier test)
  - Any new agent definition without a new authorization cycle
  - Any F9 runtime implementation

F9-D04=B BLOCKS:
  - A-05, A-07, G-N5 integrity controls (until external trigger)

F9-D05=A BLOCKS:
  - F10-F12 scope definition (until concrete evidence)
```

---

## Part V — Decision Evolution Timeline

| Date | Event | Impact |
|---|---|---|
| 2026-09-16 | F1-F6: ARCH-001..003 established | Project scope + evidence architecture |
| 2026-09-18 | ARCH-004: task semantics + contract_hash optional | Workflow semantics |
| 2026-09-18 | F7 behavioral audit: 11 bugs found | F7 scope defined |
| 2026-09-19 | F8-A: contract_hash mandatory (ARCH-004 addendum) | Fail-closed evidence |
| 2026-09-19 | F9_RESEARCH.md: F9 NOT JUSTIFIED | Research first |
| 2026-09-20 | F9 owner gate closed: F9-D01..D05 | Authorization boundaries frozen |
| 2026-09-23 | M001-M004: research path explored | READY-01/02/03/04 structured |
| 2026-09-23 | M005: NH-10 implemented | L1-C Condition 3 satisfied |
| 2026-09-23 | M006 CORRECTION: READY-01 misclassified | Policy changes ≠ docs-only |
| 2026-09-23 | M006 CORRECTION: READY-03 risk = UNKNOWN | Evidence gap acknowledged |
| 2026-09-23 | M006 CORRECTION: N undefined | Owner must provide N |
| 2026-09-23 | M007: PAC prototype built | Architecture insight; PAC-EF-02 discovered |
| 2026-09-23 | M007: HRQS gap identified | Now-executable action found |
