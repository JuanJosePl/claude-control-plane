# DEC-02 D-DELEG — DECISION GATE (PREPARATION)

```text
DECISION_ID          : DEC-02
DECISION_NAME        : D-DELEG
TITLE                : Delegation Governance Model
STATUS               : GATE_PREPARED
STRATUM              : C
CANONICAL            : NO
OWNER_CHOICE         : NONE
IMPLEMENTATION_AUTH  : NONE
CHECKPOINT           : NONE
SOURCE_HEAD          : e529359
PREPARED_BY          : Claude Opus 4.7 (analyst, non-decisor)
PREPARATION_DATE     : 2026-09-27
BASELINE_ARTIFACTS   : docs/00_SYSTEM/DEC-02_DELEG_DRAFT_POST_ARCH007.md
                       docs/00_SYSTEM/EXP_A_EXP_D_RESULTS_POST_ARCH007.md
                       docs/00_SYSTEM/POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md
```

> **Purpose**: prepare the DEC-02 Decision Gate so the Owner can review a coherent option
> space and choose. This document does **not** decide DEC-02. It does not open the gate
> in the operational sense (persist OPEN in DECISION_REGISTRY); the Owner action opens it.
>
> **Epistemic rules**: `VERIFIED` (checked against repo state) · `DOCUMENTED` (asserted in
> registered artifacts but not re-verified here) · `INFERENCE` (deduced from partial
> evidence) · `HYPOTHESIS` (no direct evidence) · `UNKNOWN` (evidence missing) ·
> `CONTRADICTED` (evidence against).
>
> **Reading order**: §1 (question) → §7 (boundary) → §8 (options) → §17 (Owner questions)
> → §18 (choice template). The intermediate sections support those five.

---

## §1. DECISION QUESTION

**Central question**:

> **What governance mechanism, if any, should CCP use to control delegated execution
> authority across actors and capabilities?**

Equivalent formulations:

- ¿Qué contrato (si alguno) hace explícito quién puede ejercer autoridad sobre qué acción,
  bajo qué condiciones, y con qué mecanismo de reversión?
- ¿Cómo se elimina el default silencioso "todo lo no delegado defaultea a humana"
  (K3-D-OWNER-DEFAULT) sin crear nuevos registros paralelos ni cruzar F9-D01?

### 1.1 What is inside DEC-02

- Whether to make delegation explicit.
- If yes, what schema minimally captures a delegation entry.
- What fields, what vocabulary, what activation/revocation semantics.
- Whether ACTION_TYPE should be open-bounded, closed-bounded, or field-local.

### 1.2 What is outside DEC-02 (explicit non-decisions)

Per §7 formal boundary, DEC-02 must **not** decide:

- Overall agent architecture (agent inventory is fixed by `.claude/agents/*.md` + harness).
- Verifier architecture (DEC-07's territory).
- Canonical format for policy (DEC-04's territory).
- Motor de derivación (DEC-05's territory).
- Change-type taxonomy (DEC-01 monolithic RETIRED via ARCH-007; sub-decision E1 DEFERRED).
- D-CATALOG resurrection in any form.
- Runtime orchestration design.
- Generic task taxonomy (ARCH-004 already covers).
- Verification taxonomy (DEC-07's territory if it opens).
- Enforcement mechanic (F9-D01=A vigente).

**Refuse absorption**: if a proposed option grows to touch any of the above, it belongs
to a different decision and should be split off.

---

## §2. WHY THIS DECISION EXISTS

### 2.1 Observed present problem — K3-D-OWNER-DEFAULT (VERIFIED empirically)

**Claim**: every authority not explicitly delegated defaults to the Owner (`humana` per
AUTHORITY_KIND). This creates a bottleneck.

**Evidence in current repo**:

- `.claude/agents/` has 5 file-defined subagents (`architect`, `code-reviewer`,
  `implementer`, `researcher`, `security-auditor`) + 7 harness runtime types. Each has a
  declared `permissionMode` and `tools:` list, but **no artifact declares which of their
  actions are pre-authorized versus which require Owner ack per invocation**.
- `DECISION_REGISTRY.md` and `docs/00_SYSTEM/DECISION_HISTORY.md` show all Owner-Chosen
  decisions (F9-D01..D05, DEC-11, DEC-AUTH-BOUNDARY, DEC-01) are `humana` acts. **No
  entry** exists for "delegated authority already granted to subagent X for action Y".
- Empirical: MOVEMENTs 001-013 despachan subagentes repeatedly (`researcher` for market
  work, `architect` for design, `implementer` for code). Each despacho requires implicit
  Owner criterion. The **criterion for despacho** is not recorded.

**Status**: `VERIFIED` — the default-to-humana pattern is repository-observable.

### 2.2 Future capability problem — DEC-07 dependency (DOCUMENTED)

**Claim**: if DEC-07 F2 (LLM adversarial verifier) opens, it will consume a delegation
record to know which agent output is authorized to be reviewed by which verifier.

**Evidence**:

- `.claude/agents/code-reviewer.md` exists as read-only agent with defined verdict
  output schema.
- `.claude/skills/code-review-and-quality/SKILL.md` + `.claude/skills/doubt-driven-development/SKILL.md`
  define verdict semantics.
- Without DEC-02, DEC-07 F2 authorization would be implicit delegation → governance risk
  (K3-U-09 correlated failure documented in prior audits).

**Status**: `DOCUMENTED` — this is a projected dependency, not an active bug. Confidence
that DEC-07 opens is `UNKNOWN` (Owner sequencing).

### 2.3 Architectural hypothesis — delegation as first-class object (HYPOTHESIS)

**Claim**: making delegation an explicit governance object improves auditability, reduces
K3-D-OWNER-DEFAULT, and enables reviewer LLM adversarial patterns.

**Evidence**:

- Governance patterns ARCH-005 (docs-only trigger YAML) and ARCH-006 (taxonomy + closed
  vocab) show docs-only + minimal-schema-in-document works.
- No incident yet attributable to "delegation was ambiguous". So the *urgency* is
  hypothesis, not verified.

**Status**: `HYPOTHESIS` — plausible but not required by empirical incident.

### 2.4 Governance preference — Owner sequencing (UNKNOWN)

Whether DEC-02 is the correct *next* decision (vs DEC-03 lifecycle, DEC-08 STALL
instrumentation, or an experiment) is `UNKNOWN` and Owner-only.

### 2.5 What is failing today

**Uncontrolled today**:

- No revocation procedure exists for any implicit delegation.
- No traceability of "why despachar this agent for this task" beyond git commit message.
- No fallback declaration (implicit default `humana`).
- Onboarding a second human (S2/S3) would require re-deriving the implicit delegation
  each time.

**Controlled today**:

- All agent invocations pass through hooks (bash-firewall, secret-guard, task-completed-evidence).
- Reviewer verdict emission is covered (per EXP-D §12: 6 layers).
- Owner remains authoritative for every gate (F9-D01=A vigente).

**Not-yet-failing**: no verified incident attributable to delegation ambiguity.

---

## §3. CURRENT BASELINE (BEFORE state)

Documented as of HEAD `e529359`. All fields tagged with epistemic status.

### 3.1 Actors (VERIFIED)

| Actor | Source | Tools declared | permissionMode | Authority class |
|---|---|---|---|---|
| architect | `.claude/agents/architect.md` | Read, Glob, Grep, Write, Edit | plan | agente (docs-only Write) |
| code-reviewer | `.claude/agents/code-reviewer.md` | Read, Glob, Grep | default | agente (read-only verdict emitter) |
| implementer | `.claude/agents/implementer.md` | Read, Glob, Grep, Write, Edit, Bash | acceptEdits | agente (full tool scope) |
| researcher | `.claude/agents/researcher.md` | Read, Glob, Grep, WebSearch, WebFetch | default | agente (external frontier) |
| security-auditor | `.claude/agents/security-auditor.md` | Read, Glob, Grep | default | agente (read-only audit) |
| fork | harness | inherits parent | (harness) | UNKNOWN |
| general-purpose | harness | * | (harness) | UNKNOWN |
| Explore | harness | (search + read only) | (harness) | UNKNOWN |
| Plan | harness | (search + read only) | (harness) | UNKNOWN |
| claude | harness | * | (harness) | UNKNOWN |
| claude-code-guide | harness | Bash, Read, WebFetch, WebSearch | (harness) | UNKNOWN |
| statusline-setup | harness | Read, Edit | (harness) | UNKNOWN |
| Owner (juanjosepolo.dev@gmail.com) | git identity | N/A | N/A | humana |

**Note**: harness runtime types have `UNKNOWN` authority-class assignment because they
are not repository artifacts; their contract is defined by Claude Code harness, not the
CCP.

### 3.2 Authority classes (VERIFIED — ARCH-006 canonical)

Per `docs/00_SYSTEM/AUTHORITY_KIND.md` §2, VOCAB-A CLOSED:

```
{ mecánica, convención, humana, agente }
```

Cardinality exactly 4. Ordinary modification PROHIBITED. Reopening requires ARCH-006
formal procedure per §5.

### 3.3 Current delegation behavior (VERIFIED)

- **No explicit delegation record exists in the repository.**
- Owner despacha subagentes as needed; the despacho is the delegation act, but its
  parameters (scope, revocation, fallback) are implicit.
- Hooks provide mechanical enforcement (bash-firewall, secret-guard) irrespective of who
  invoked the tool.
- Evidence gate (`task-completed-evidence.sh`) enforces contract_hash mandate (per
  ARCH-004 F8-A). This is authority `mecánica`, not delegation.

### 3.4 Activation semantics (VERIFIED)

- Currently: activation is the Owner despacho itself (verbal or via `/agents`).
- No activation predicate is declared beyond Owner's momentary choice.

### 3.5 Fallback semantics (VERIFIED)

- Fallback is implicit: if a subagent output is not accepted, the work returns to Owner.
- K3-D-OWNER-DEFAULT documents this pattern.

### 3.6 Revocation semantics (VERIFIED)

- Currently: revocation is done by *not despachando* the subagent for a given task.
- No formal revocation procedure exists.

### 3.7 Scope semantics (VERIFIED)

- Scope is implicit in the agent's `tools:` and `permissionMode` fields.
- No cross-cutting `scope: "reviews of implementer output pre-commit"` type declaration
  exists.

### 3.8 Provenance semantics (VERIFIED)

- Git commit + `SubagentStop-logger.sh` provides *invocation* provenance.
- No delegation-authorization provenance exists ("Owner authorized code-reviewer for
  this class of tasks on 2026-XX-XX").

### 3.9 Verification semantics (VERIFIED — per EXP-D)

- Reviewer verdict emission is fully covered by 6 canonical layers (EVIDENCE_REGISTRY
  `Reviewer:` field mandatory + A-06 identity convention + HRQS §12 + code-reviewer agent
  verdict schema + code-review-and-quality skill + doubt-driven-development skill +
  CHANGE_PROVENANCE_F*.md Review Rounds).
- **This is decoupled from delegation**: verdict emission exists whether delegation is
  formal or implicit.

### 3.10 Human boundary (VERIFIED)

- Owner remains authoritative for every gate (F9-D01=A).
- HRQS §12 escalation to project owner is documented for `STALL_POLICY` blocks.

### 3.11 Repository boundary (VERIFIED)

- All actors observable in this repository at HEAD `e529359`.
- Harness types not observable from disk.

### 3.12 Runtime boundary (VERIFIED)

- Hooks execute as `mecánica` authority regardless of caller.
- Agents execute within their `permissionMode` scope.
- No runtime enforcement of "action X is delegable to agent Y".

### 3.13 Missing today (`UNKNOWN` or `PROBLEM`)

- Cross-session record of "which delegations are in force".
- Auditability of the delegation act itself.
- Multi-human onboarding (S2/S3 scenarios).
- Revocation event log.

---

## §4. CANONICAL AUTHORITY MODEL

`docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006) is the source of truth for authority
classes.

### 4.1 VOCAB-A (CLOSED, VERIFIED)

```
CANONICAL_CLASSES           = { mecánica, convención, humana, agente }
CARDINALITY                 = exactly 4
ORDINARY_MODIFICATION       = NOT ADMITTED
NEW_CLASS_PROCEDURE         = formal reopening of ARCH-006 with Owner Choice
IMPLICIT_META-AUTHORITY     = PROHIBITED
IMPLICIT_OWNER_TRANSACTION  = PROHIBITED
```

### 4.2 Semantic summary per class (VERIFIED, condensed from AUTHORITY_KIND.md §3)

- **mecánica**: deterministic code deciding at operation time (hooks, validators).
  Reproducible with same input.
- **convención**: normative text (rules, policies, contracts) whose binding force comes
  from the convention to read and respect it.
- **humana**: designated person acting explicitly and punctually within a gate.
- **agente**: Claude Code agent (main or subagent) operating within an authorized scope
  from a prior act of `humana` or `convención`.

### 4.3 Existing coverage assessment for DEC-02

**Question**: Is AUTHORITY_KIND sufficient as the authority dimension for DEC-02?

**Test 1** — for each of the 11 empirically-observed actions in EXP-A §4 (code-review,
implementation, research-external, architecture-analysis, security-audit,
evidence-registration, adr-registration, no-go-verification, phase-gate-verification,
phase-closure, incident-management), does `delegated_to` map to one of the 4 classes?

Result: **YES for 11/11**. Result documented in EXP-A draft §7.6 with `HIGH (85%)`
confidence.

**Test 2** — does any observed action require a fifth class?

Result: **NO**. Every combination (agent+action) maps to `mecánica` (hook enforced) or
`agente` (subagent action) or `humana` (Owner) or `convención` (rule text). No ATTESTED
instance exists outside these four.

**Test 3** — does DEC-02 require modifying AUTHORITY_KIND?

Result: **NO**. DEC-02 operates *over* AUTHORITY_KIND (it references classes; it does not
extend them). Prohibitions in AUTHORITY_KIND §6 (piece → authority mapping) do not apply
to DEC-02, because DEC-02 maps **action → authority**, not piece → authority. The
piece is not a first-class object of DEC-02.

### 4.4 Conclusion

**Status**: AUTHORITY_KIND is `VERIFIED` sufficient as the authority dimension for DEC-02.

**Risk**: if DEC-02 chooses an option that inadvertently creates a piece → authority
mapping (e.g., by enumerating agents and their permitted actions in a way that reads as
`agent-piece → authority`), Trigger T4 of ARCH-006 §5.6 would activate. This is guarded
in §7 formal boundary.

---

## §5. ACTION_TYPE BOUNDARY

**Critical section**. EXP-A §7 and the recomposition §9 established that AUTHORITY_KIND,
ACTION_TYPE, TASK_TYPE, CHANGE_TYPE, and VERIFICATION_TYPE are semantically distinct
dimensions.

### 5.1 Vocabulary status (VERIFIED, from EXP-A §9)

```
AUTHORITY_KIND      = canonical, CLOSED (ARCH-006 VOCAB-A)
ACTION_TYPE         = observed/bounded vocabulary; NO canonical source
TASK_TYPE           = separate concept (ARCH-004: CONTRACTUAL/TODO/SUBTASK/RESEARCH)
CHANGE_TYPE         = separate concept (`.claude/rules/git-policy.md`: 8 types)
VERIFICATION_TYPE   = separate concept (would be DEC-07's territory if opened)
```

**Coverage rule**: DEC-02 declares its schema **only over ACTION_TYPE** as a domain field.
It does not touch TASK_TYPE, CHANGE_TYPE, or VERIFICATION_TYPE as domain fields, though
those may appear as optional `scope` filters in individual delegation entries.

### 5.2 Observed ACTION_TYPE vocabulary (INFERENCE, from EXP-A §4)

11 actions observable in the current repository via file inspection:

```
code-review                 (agent code-reviewer.md + skill code-review-and-quality)
implementation              (agent implementer.md)
research-external           (agent researcher.md + WebSearch/WebFetch)
architecture-analysis       (agent architect.md)
security-audit              (agent security-auditor.md + OWASP checklist)
evidence-registration       (skill evidence + hook task-completed-evidence)
adr-registration            (skill adr)
no-go-verification          (skill no-go)
phase-gate-verification     (skill gate)
phase-closure               (skill cerrar-fase)
incident-management         (skill incident)
```

**Epistemic status**: `INFERENCE` — extracted from artifacts, not guaranteed exhaustive.
Harness runtime types (`fork`, `general-purpose`, `Explore`, `Plan`, `claude`,
`claude-code-guide`, `statusline-setup`) execute actions not enumerated above and could
require additional vocabulary. Their coverage is `UNKNOWN` for DEC-02 purposes.

### 5.3 The Owner-level question about ACTION_TYPE

**Question** (Q2 in §17):

> Should ACTION_TYPE be:
>
> (a) **Open-bounded** — enumerated in the gate document with the 11 observed classes and
>     a rule "new action requires evidence ATTESTED at same gate document",
>
> (b) **Closed-bounded** — formalized as VOCAB-A-analog with exactly the 11 classes,
>     reopening procedure for expansion,
>
> (c) **Field-local** — no vocabulary constraint at all; each delegation entry states its
>     own action_type as free string with local semantics.

Each maps to different DEC-02 options in §8.

**Not decided in this gate**. Owner-only.

### 5.4 Guardrails

Whichever choice the Owner picks, three guardrails are non-negotiable:

- **No new registry file** (no `ACTION_TYPES_CATALOG.md`, `ACTION_TYPES_REGISTRY.md`).
  Anti-pattern per ARCH-007 lesson.
- **No enforcement mechanic** on ACTION_TYPE unless a separate decision authorizes.
- **No mapping ACTION_TYPE → CHANGE_TYPE** as primary composite key. That would
  resurrect the DEC-01 monolithic framing.

---

## §6. DEC-02 MINIMUM BOUNDARY (candidate schema)

Reconstructed from EXP-A §5 (draft). **Marked `CANDIDATE`** because Owner may reshape,
reduce, or expand.

### 6.1 Minimum viable schema (docs-only)

```yaml
# CANDIDATE — not canonical, not persisted, not authorized
delegation_entry:
  action_type:      <string>                         # per §5 vocabulary policy
  delegated_from:   <AUTHORITY_KIND value>           # usually 'humana'
  delegated_to:     <AUTHORITY_KIND value>           # usually 'agente' or 'mecánica'
  fallback:         <AUTHORITY_KIND value>           # usually 'humana' (K3-D-OWNER-DEFAULT)
  activation:                                        # ARCH-005 vocab
    type:           EVENT | CONDITION | COUNT | DATE | LINK
    predicate:      <string>
  revocation:
    predicate:      <string>
    procedure:      <string>                         # reference to reopening or override
  scope:            <one-sentence operational description>
  provenance:       <reference to gate + entry id>
```

### 6.2 Field-by-field justification

| Field | Required? | Evidence-supported? | Derivable? | Redundant? | Decision-sensitive? | Implementation-sensitive? |
|---|---|---|---|---|---|---|
| `action_type` | YES | VERIFIED (11 observed) | NO | NO | YES (Q2) | NO if docs-only |
| `delegated_from` | YES | VERIFIED via AUTHORITY_KIND | Partial (usually humana) | NO | Minor | NO |
| `delegated_to` | YES | VERIFIED via AUTHORITY_KIND | NO | NO | YES | Minor |
| `fallback` | YES | VERIFIED via K3-D-OWNER-DEFAULT | Partial (usually humana) | NO | Minor | NO |
| `activation` | YES | VERIFIED via ARCH-005 pattern | NO | NO | YES (Q3) | Depends on option |
| `revocation` | YES | INFERENCE (no active procedure) | NO | NO | YES (Q5) | Depends on option |
| `scope` | Optional | INFERENCE | Partial (agent config) | Possibly if agent config suffices | Minor | NO |
| `provenance` | YES | VERIFIED via ARCH-004 pattern | Partial | NO | Minor | NO |

**Alternative minimalisms** (options where fewer fields are used):

- **Minimal-3**: `action_type`, `delegated_to`, `fallback`. Everything else derived or
  default.
- **Minimal-5**: add `activation` and `revocation`. Skip `scope` and `provenance` when
  the gate document itself is provenance.
- **Extended-8**: full schema above.

Each of these maps to different DEC-02 options in §8.

---

## §7. FORMAL DECISION BOUNDARY

### 7.1 DEC-02 CAN DECIDE

- Whether to make delegation explicit at all (do-nothing vs establish framework).
- Whether to adopt a docs-only entry format (schema in §6) versus another representation.
- Which of the 11 observed actions receive delegation entries (or none as a pilot).
- Whether `activation` and `revocation` use the ARCH-005 vocabulary or a variant.
- Whether ACTION_TYPE is open-bounded, closed-bounded, or field-local (§5.3).
- Whether the gate document itself is the sole persistence surface, or a separate
  section of `AUTHORITY_KIND.md` cross-references delegation.
- Whether DEC-02 triggers observable reactivation predicates in the DEFER case.

### 7.2 DEC-02 MUST NOT DECIDE

- Resurrect D-CATALOG in any form (`CHANGE_TYPES_CATALOG.md`,
  `ACTION_TYPES_CATALOG.md`, `AUTHORITY_BOUNDARY.md`, or any registry mixing dimensions).
- Modify `AUTHORITY_KIND.md` (VOCAB-A CLOSED requires ARCH-006 reopening).
- Materialize `DELEGATION_REGISTRY.md` as runtime piece (anti-pattern per ARCH-007
  lesson).
- Introduce enforcement mechanic (hooks, scripts) validating delegation entries at
  runtime.
- Cross F9-D01 (F9-D01=A vigente).
- Decide DEC-07 architecture (LLM verifier, dual-human, etc.).
- Decide DEC-04/DEC-05 (canonical/motor).
- Decide DEC-03 (lifecycle).
- Absorb DEC-STREAM-CONSUMER, DEC-REVIEWER-VERDICT, or DEC-08.
- Establish generic task, change, or verification taxonomies.

### 7.3 Anti-absorption test

If any candidate option in §8 grows to touch §7.2 items, it belongs to a different
decision and must be **split off** rather than folded into DEC-02.

---

## §8. OPTIONS

Complete option space. **No ranking. No labels like "preferred", "recommended", "best".**

### 8.1 Option B0 — NO-OP (statu quo)

- **What it authorizes**: nothing new.
- **What it forbids**: nothing new.
- **Description**: K3-D-OWNER-DEFAULT persists as the operating pattern. No documented
  delegation. Owner despacha subagents ad-hoc.
- **Assumptions**: current operating scale (S1, one human) is stable; DEC-07 will not
  open in near term; no material incident emerges from implicit delegation.
- **Dependencies**: none.
- **Benefits**: zero cost, zero lock-in, preserves optionality.
- **Cost**: none in operation; opportunity cost if DEC-07 opens or S2/S3 emerges.
- **Technical risk**: NONE (no change).
- **Governance risk**: MEDIUM — Owner bottleneck persists; onboarding second human would
  require re-deriving implicit delegations.
- **Precedent risk**: NONE.
- **Reversibility**: N/A.
- **Lock-in**: NONE.
- **Observability**: unchanged (git commit + subagent-stop logger).
- **Failure containment**: current hook stack unchanged.
- **Migration cost**: zero.
- **Future decisions affected**: DEC-07 (if opens) would face implicit delegation; DEC-03
  lifecycle would still work.

### 8.2 Option B1 — DOCS-ONLY TABLE (bounded observed)

- **What it authorizes**: creating a section in this gate document (or a follow-on gate
  document) that enumerates delegations with the §6 schema and the ACTION_TYPE bounded
  by empirically-observed vocabulary (§5.2 the 11 actions).
- **What it forbids**: new registry files, runtime enforcement, closed-vocabulary
  freezing.
- **Description**: docs-only entries; ACTION_TYPE remains OPEN-BOUNDED (new action
  requires evidence ATTESTED at same gate).
- **Assumptions**: ARCH-005 docs-only pattern is transferable to delegation; 11 actions
  are a sufficient starting inventory.
- **Dependencies**: AUTHORITY_KIND (already canonical); ARCH-005 pattern (already active).
- **Benefits**: eliminates K3-D-OWNER-DEFAULT; provides reference for reviewer to consult;
  aligned with ARCH-006 "taxonomy > registry" principle.
- **Cost**: 3-6h Owner criterion + docs write.
- **Technical risk**: NONE (docs-only).
- **Governance risk**: LOW — introduces "delegation" as governance category; vocab drift
  possible if actions grow without new gate entry.
- **Precedent risk**: LOW — establishes pattern "delegation entries can be added to gate
  by simple gate reopening".
- **Reversibility**: HIGH (`git revert`).
- **Lock-in**: LOW (semantic only; no runtime).
- **Observability**: unchanged runtime; documentary artifact readable by humans and
  agents.
- **Failure containment**: no runtime side effects.
- **Migration cost**: LOW.
- **Future decisions affected**: DEC-07 has a reference for authorizing verifiers;
  DEC-STREAM-CONSUMER unaffected; DEC-08 unaffected.

### 8.3 Option B2 — PILOT (one delegation only)

- **What it authorizes**: creating a single delegation entry (e.g., `code-review` →
  `agente` via `code-reviewer` under fresh-context invocation) as pilot, with observation
  window before expanding.
- **What it forbids**: expanding to other delegations before observation window
  concludes.
- **Description**: minimalist experiment. Test whether the schema in §6 survives real
  usage.
- **Assumptions**: 30-60 day observation window is sufficient; one pilot generalizes.
- **Dependencies**: same as B1.
- **Benefits**: information-first (patrón CASE D of recomposition §35); low commitment.
- **Cost**: 2-3h; ongoing lightweight observation.
- **Technical risk**: NONE.
- **Governance risk**: LOW — pilot might fail to generalize to other actions; some
  ambiguity between "pilot lasts X days" and "pilot is de-facto B1".
- **Precedent risk**: LOW — establishes "pilot pattern" as decision technique.
- **Reversibility**: HIGH.
- **Lock-in**: LOW.
- **Observability**: pilot outcome recorded in gate reopening or follow-on artifact.
- **Failure containment**: single pilot is small blast radius.
- **Migration cost**: LOW.
- **Future decisions affected**: same as B1 but weaker signal until observation ends.

### 8.4 Option B3 — VOCAB-A-CLOSED ACTION_TYPE

- **What it authorizes**: freezing ACTION_TYPE to the 11 observed classes exactly, with
  ARCH-006-style reopening procedure for adding a 12th.
- **What it forbids**: silent expansion of ACTION_TYPE; ad-hoc entries.
- **Description**: B1 + apply the VOCAB-A pattern from ARCH-006 to ACTION_TYPE.
- **Assumptions**: 11 actions is a stable inventory for the CCP horizon; formal reopening
  is acceptable cost for adding action 12.
- **Dependencies**: AUTHORITY_KIND (as pattern precedent, not schema dependency).
- **Benefits**: strong semantic consistency; prevents drift; consistent with ARCH-006
  precedent.
- **Cost**: 4-8h Owner criterion + docs write + reopening procedure declaration.
- **Technical risk**: NONE.
- **Governance risk**: MEDIUM — rigidity may force premature reopening if new action
  emerges; risk of "silent 12th action" going undocumented.
- **Precedent risk**: MEDIUM — establishes second closed vocabulary; second-order effect
  on other future decisions (would every taxonomy be VOCAB-A?).
- **Reversibility**: MEDIUM (reopening required for change; docs-only for revert).
- **Lock-in**: MEDIUM (semantic).
- **Observability**: same as B1.
- **Failure containment**: no runtime side effects.
- **Migration cost**: MEDIUM (if action 12 appears).
- **Future decisions affected**: sets precedent for closed-vocabulary framing across
  CCP; DEC-07 verifier vocabulary may inherit this pattern.

### 8.5 Option B4 — OPEN-BOUNDED WITH RULE

- **What it authorizes**: B1 with the rule "new action_type requires evidence ATTESTED at
  a follow-on gate document (not necessarily reopening DEC-02)".
- **What it forbids**: silent addition; use of an action_type not enumerated.
- **Description**: middle path — no closed freeze, but no silent drift either.
- **Assumptions**: gate reopening for new action is not too costly; enumeration in gate
  is sufficient formal record.
- **Dependencies**: same as B1.
- **Benefits**: flexibility + traceability; low friction for adding actions; no rigidity
  of B3.
- **Cost**: 3-6h.
- **Technical risk**: NONE.
- **Governance risk**: LOW-MEDIUM — depends on whether "evidence ATTESTED" bar is
  respected in practice.
- **Precedent risk**: LOW.
- **Reversibility**: HIGH.
- **Lock-in**: LOW.
- **Observability**: same as B1.
- **Failure containment**: no runtime side effects.
- **Migration cost**: LOW.
- **Future decisions affected**: same as B1.

### 8.6 Option B5 — B1 + DEC-07 CONCURRENT OPENING

- **What it authorizes**: B1 delegation table + simultaneously open DEC-07 (LLM
  adversarial verifier gate).
- **What it forbids**: opening DEC-07 without a delegation reference for the verifier
  agent.
- **Description**: package deal. Owner decides both delegation model and verification
  model together.
- **Assumptions**: DEC-07 is close enough to be co-decided; LLM provider dependency is
  acceptable.
- **Dependencies**: DEC-02 → DEC-07 HARD (per recomposition §11).
- **Benefits**: resolves DEC-02 → DEC-07 HARD edge in one gate cycle; avoids repeated
  Owner attention.
- **Cost**: 8-16h+ Owner criterion + docs (DEC-02 + DEC-07 gate).
- **Technical risk**: MEDIUM if DEC-07 chooses F2 (LLM provider dependency, correlated
  failure U-09).
- **Governance risk**: MEDIUM — larger scope decision means larger blast radius on
  regret.
- **Precedent risk**: HIGH — establishes pattern of packaged Owner decisions; may set
  expectation for future coupled decisions.
- **Reversibility**: MEDIUM (DEC-07 reversibility varies by chosen sub-option; DEC-02
  reversible).
- **Lock-in**: MEDIUM to HIGH (LLM provider if DEC-07 F2 selected).
- **Observability**: extended (verifier verdict emission joins reviewer verdict layer).
- **Failure containment**: MEDIUM.
- **Migration cost**: MEDIUM to HIGH.
- **Future decisions affected**: closes DEC-07 in same cycle; may inform DEC-STREAM-CONSUMER.

### 8.7 Option B6 — DEFER WITH OBSERVABLE TRIGGERS

- **What it authorizes**: registering DEC-02 in `PROJECT_STATE.DEFERRED` with YAML trigger
  block per ARCH-005 §5, along with a companion note that the gate document exists as
  Stratum-C reference.
- **What it forbids**: implicit deferral without triggers.
- **Description**: preserve optionality; specify what would reopen DEC-02.
- **Assumptions**: triggers can be observably declared; deferral is not perpetual.
- **Dependencies**: ARCH-005 pattern.
- **Benefits**: no premature commitment; low cost; preserves other work.
- **Cost**: 30 min (declare triggers).
- **Technical risk**: NONE.
- **Governance risk**: LOW — depends on trigger quality; poorly-specified triggers
  produce perpetual deferrals.
- **Precedent risk**: LOW.
- **Reversibility**: N/A.
- **Lock-in**: NONE.
- **Observability**: DEFERRED entry in PROJECT_STATE is visible.
- **Failure containment**: no runtime side effects.
- **Migration cost**: zero.
- **Future decisions affected**: DEC-07 remains HARD-blocked; DEC-STREAM-CONSUMER
  unaffected; DEC-08 unaffected.

Candidate triggers (per EXP-A draft §13; for Owner review, not for auto-persist):

```yaml
- id: dec02.T1
  type: EVENT
  predicate: "Owner enfrenta ≥3 despachos/semana con ambigüedad delegable/no-delegable observable durante 1 mes."
- id: dec02.T2
  type: EVENT
  predicate: "DEC-07 opens and requires delegation registry as reference for verifier authorization."
- id: dec02.T3
  type: COUNT
  predicate: "≥2 implicit-delegation historical incidents documented in INCIDENT_REGISTRY.md."
- id: dec02.T4
  type: EVENT
  predicate: "Owner plans scaling to S2/S3 (≥2 active humans) requiring explicit onboarding of delegation authority."
- id: dec02.T5
  type: LINK
  predicate: "ARCH-006 T3 fires (DEC-02 requires AUTHORITY_KIND reference which taxonomy alone cannot resolve)."
  link: arch06.T3
```

### 8.8 Option B7 — RETIRE (accept K3-D-OWNER-DEFAULT as permanent)

- **What it authorizes**: declaring K3-D-OWNER-DEFAULT as permanent operating pattern.
- **What it forbids**: reopening DEC-02 without a formal trigger from a future decision.
- **Description**: eliminate DEC-02 from the open decision graph. Preserve the historical
  formulation in DECISION_HISTORY with RESOLVED_BY pointer to K3-D-OWNER-DEFAULT +
  AUTHORITY_KIND (both already documented).
- **Assumptions**: Owner accepts perpetual bottleneck as design; scaling is not planned.
- **Dependencies**: none.
- **Benefits**: maximum clarity in decision graph; removes ambiguity.
- **Cost**: 30 min (register RETIRED).
- **Technical risk**: NONE.
- **Governance risk**: LOW — but establishes precedent that "some governance decisions
  are permanently accepted-as-default".
- **Precedent risk**: LOW-MEDIUM.
- **Reversibility**: HIGH (reopen via new decision if triggers appear).
- **Lock-in**: NONE (technically); MEDIUM organizationally (culture accepts bottleneck).
- **Observability**: RETIRED entry visible.
- **Failure containment**: unchanged.
- **Migration cost**: zero.
- **Future decisions affected**: DEC-07, if opened, must accept implicit delegation as
  governance model; DEC-STREAM-CONSUMER unaffected.

### 8.9 Hybrid options (only where coherent)

- **B1 + B2** (docs-only table + pilot phase): coherent. First declare schema, then run
  a single pilot before enumerating all 11. Effectively "phased B1".
- **B1 + B6** (docs-only table + explicit triggers for expansion): coherent. B1 core with
  ARCH-005-style triggers for adding entries.
- **B3 + B5**: coherent but high lock-in (closed vocab + concurrent DEC-07).
- **B2 + B5**: incoherent. Pilot cannot be concurrent with DEC-07 opening, because
  DEC-07 needs the delegation model already established.
- **B7 + anything else**: incoherent by construction.

Owner may propose additional hybrids not enumerated above.

---

## §9. BEFORE → AFTER FOR EACH OPTION

Compact matrix. For each option, the pipeline `BASELINE → OPTION → NEW BEHAVIOR → NEW
CONTROL → NEW FAILURE MODES`.

### 9.1 B0 (NO-OP)

- BASELINE: K3-D-OWNER-DEFAULT.
- OPTION IMPLEMENTED: nothing.
- NEW BEHAVIOR: unchanged.
- NEW CONTROL: none.
- NEW FAILURE MODES: none.

**Deltas**: N/A · N/A · N/A · N/A · N/A → **SAME**.

### 9.2 B1 (DOCS-ONLY TABLE)

- BASELINE: implicit delegation via despacho.
- OPTION IMPLEMENTED: gate document contains table with 11 delegation entries + schema.
- NEW BEHAVIOR: Owner and reviewer can consult table to answer "is this action
  delegated?"; delegation becomes machine-readable.
- NEW CONTROL: revocation predicate becomes explicit per entry; audit trail via git.
- NEW FAILURE MODES: table drift (entries stale relative to actual practice); table
  becomes de-facto source of truth without runtime enforcement.

**Deltas**: WIN (auditability) · WIN (revocation semantic) · SAME (runtime) · LOSS
(potential drift) · UNKNOWN (S2/S3 onboarding not tested).

### 9.3 B2 (PILOT)

- BASELINE: implicit delegation.
- OPTION IMPLEMENTED: single delegation entry (e.g., `code-review` → `agente`) +
  observation window.
- NEW BEHAVIOR: one action becomes explicit; others remain implicit.
- NEW CONTROL: pilot observation informs future decisions.
- NEW FAILURE MODES: pilot fails to generalize; pilot becomes de-facto B1 without
  formal expansion; pilot has ambiguous end condition.

**Deltas**: WIN (small info gain) · SAME (10 of 11 actions unchanged) · SAME (runtime)
· SAME (small blast radius) · UNKNOWN (pilot outcome).

### 9.4 B3 (VOCAB-A-CLOSED)

- BASELINE: implicit + no vocab constraint.
- OPTION IMPLEMENTED: 11-class CLOSED ACTION_TYPE + delegation table.
- NEW BEHAVIOR: reviewer can rely on vocab; formal reopening for expansion.
- NEW CONTROL: drift prevention.
- NEW FAILURE MODES: rigidity forces reopening when 12th action emerges; risk of "silent
  12th action" pattern.

**Deltas**: WIN (drift prevention) · WIN (semantic consistency) · SAME (runtime) · LOSS
(rigidity) · UNKNOWN (action 12 emergence rate).

### 9.5 B4 (OPEN-BOUNDED WITH RULE)

- BASELINE: implicit + no vocab constraint.
- OPTION IMPLEMENTED: 11-class OPEN-BOUNDED + "new action requires ATTESTED evidence at
  new gate entry".
- NEW BEHAVIOR: table is source of authority; expansion requires evidence.
- NEW CONTROL: soft drift protection.
- NEW FAILURE MODES: "evidence ATTESTED" bar not respected in practice; gradual drift
  through low-quality entries.

**Deltas**: WIN (auditability) · WIN (flexibility) · SAME (runtime) · POSSIBLE LOSS
(rule not enforced) · UNKNOWN (practice quality).

### 9.6 B5 (B1 + DEC-07)

- BASELINE: implicit + no verifier gate.
- OPTION IMPLEMENTED: delegation table + LLM adversarial verifier authorized under it.
- NEW BEHAVIOR: verifier operates within explicit scope; verdict emission chain grows.
- NEW CONTROL: pre-commit LLM check + Owner review workflow.
- NEW FAILURE MODES: LLM provider dependency; K3-U-09 correlated failure; jailbreak.

**Deltas**: WIN (verification depth) · SAME (delegation part) · LOSS (LLM dependency) ·
LOSS (correlated failure exposure) · UNKNOWN (LLM FP/FN rate on real corpus).

### 9.7 B6 (DEFER)

- BASELINE: implicit.
- OPTION IMPLEMENTED: DEFERRED entry with 5 triggers.
- NEW BEHAVIOR: unchanged operating.
- NEW CONTROL: reactivation predicates observable.
- NEW FAILURE MODES: perpetual deferral if triggers never fire; DEC-07 remains blocked.

**Deltas**: SAME · SAME · SAME · WIN (traceable postponement) · UNKNOWN (trigger fire
rate).

### 9.8 B7 (RETIRE)

- BASELINE: implicit.
- OPTION IMPLEMENTED: RETIRED entry + RESOLVED_BY pointer.
- NEW BEHAVIOR: unchanged operating.
- NEW CONTROL: unambiguous decision graph.
- NEW FAILURE MODES: implicit governance model accepted as permanent; DEC-07 must adapt.

**Deltas**: SAME · SAME · SAME · WIN (clarity) · LOSS (permanent bottleneck).

---

## §10. EVIDENCE MATRIX

Claims and their epistemic status. `V` VERIFIED · `D` DOCUMENTED · `I` INFERENCE ·
`H` HYPOTHESIS · `U` UNKNOWN · `C` CONTRADICTED.

| # | Claim | Evidence | Status | Confidence | Consequence |
|---|---|---|---|---:|---|
| 1 | K3-D-OWNER-DEFAULT is observable | `.claude/agents/*.md` schema + no delegation record | V | HIGH (85%) | B0 requires accepting this as permanent; B1-B5 aim to eliminate it |
| 2 | AUTHORITY_KIND VOCAB-A CLOSED is canonical | `docs/00_SYSTEM/AUTHORITY_KIND.md` ARCH-006 | V | HIGH (95%) | All options operate over these 4 classes |
| 3 | 11 empirical actions can be enumerated | agent files + skills inventory (EXP-A §4) | V | HIGH (85%) | Vocabulary for B1-B5 |
| 4 | Harness runtime types (`fork`, etc.) authority is UNKNOWN | not in `.claude/agents/`; harness contract not on disk | U | — | Guardrail: DEC-02 does not commit on their classification |
| 5 | DEC-02 → DEC-07 is HARD | recomposition §11.9 + this gate §7 | V | HIGH (80%) | B5 packages both; other options leave DEC-07 blocked |
| 6 | DEC-02 formulable without D-CATALOG | EXP-A §7.10 (10/10 falsifiers pass) | V | HIGH (85%) | All options assume no D-CATALOG resurrection |
| 7 | Reviewer verdict emission already covered by 6 layers | EXP-D §10 + A-06 + HRQS §12 | V | HIGH (85%) | DEC-02 does not need to solve verdict emission |
| 8 | No incident material attributed to implicit delegation | INCIDENT_REGISTRY.md inspection (no matches) | V | HIGH (80%) | B0 remains defensible; urgency of B1-B5 is not incident-driven |
| 9 | ARCH-005 docs-only pattern applicable to activation/revocation | `DEFERRAL_POLICY.md` schema | V | HIGH (90%) | B1, B2, B3, B4 all inherit this pattern cleanly |
| 10 | ARCH-006 taxonomy pattern applicable to ACTION_TYPE | analogous formation | I | MED-HIGH (70%) | B3 depends on this; B4 does not |
| 11 | 11 observed actions are exhaustive for CCP horizon | absence of counter-evidence | I | MED (60%) | Refutable within 6-12 months if harness runtime types added or new skills emerge |
| 12 | Piece → authority mapping is prohibited by ARCH-006 §6 | AUTHORITY_KIND.md §6 | V | HIGH (95%) | Guardrail: DEC-02 must map action → authority, not piece → authority |
| 13 | Owner scaling to S2/S3 is planned | UNKNOWN | U | — | Cannot be used to justify B1-B5 or B0 |
| 14 | LLM provider dependency introduces material lock-in | industry evidence + K3-U-09 correlated failure | D | MED-HIGH (75%) | B5 carries this cost; other options do not |
| 15 | Pilot generalizes from 1 to 10 delegations | HYPOTHESIS | H | — | B2 rests on this |
| 16 | ACTION_TYPE will remain stable at 11 for the CCP horizon | INFERENCE | I | MED (60%) | B3 rests on this |
| 17 | Owner has bandwidth for gate reopening on new action | UNKNOWN | U | — | Affects B3 vs B4 preference |
| 18 | DEC-STREAM-CONSUMER, DEC-04, DEC-08 unaffected by DEC-02 choice | recomposition §11.7 (DEC-02 orthogonal) | V | HIGH (75%) | DEC-02 does not have to couple with them |
| 19 | Executor ≠ author ≠ auditor separation is already documented | CHANGE_PROVENANCE_F8.md | V | HIGH (85%) | B1 delegation table can reference this pattern for provenance |
| 20 | Reviewer verdict schemas ready for `output_contract` | .claude/agents/code-reviewer.md + skills | V | HIGH (90%) | B1 entry for code-review has ready contract |

**Unsupported claims that could enter options**: none detected in this preparation. If a
proposed hybrid or Owner-added option depends on a claim not in the matrix, that claim
must be added with epistemic status before persistence.

---

## §11. FALSIFIERS

For each option, what observation would materially worsen it or invalidate its main
assumption.

### 11.1 B0 (NO-OP)

- **F0.1**: ≥3 documented incidents attributable to implicit delegation over 3 months.
- **F0.2**: Owner scaling to S2/S3 planning confirmed.
- **F0.3**: DEC-07 opens and requires delegation record.

### 11.2 B1 (DOCS-ONLY TABLE)

- **F1.1**: table drift detected within 3 months (entries inconsistent with actual
  practice) with no reviewer catching it.
- **F1.2**: reviewer reports table is not consulted in practice → auditability claim
  refuted.
- **F1.3**: ≥3 new actions emerge in 6 months → OPEN-BOUNDED bar not respected.

### 11.3 B2 (PILOT)

- **F2.1**: pilot outcome ambiguous after observation window → cannot generalize.
- **F2.2**: pilot succeeds trivially (all 11 delegations would follow the same pattern)
  → pilot did not buy information.
- **F2.3**: pilot fails but the failure is scope-specific → does not refute the schema
  generally.

### 11.4 B3 (VOCAB-A-CLOSED)

- **F3.1**: 12th action emerges within 3-6 months → forces immediate reopening.
- **F3.2**: harness runtime types (U1) resist classification into the 11 classes.
- **F3.3**: reopening procedure exercised twice within 12 months → rigidity cost > drift
  prevention benefit.

### 11.5 B4 (OPEN-BOUNDED WITH RULE)

- **F4.1**: "evidence ATTESTED" bar is bypassed in practice (entries added without
  evidence).
- **F4.2**: no discernible difference from B1 in outcomes → rule is inert.

### 11.6 B5 (B1 + DEC-07 concurrent)

- **F5.1**: LLM verifier FP rate > 20% on historical corpus → F2 not viable.
- **F5.2**: LLM provider outage / rate limit affects operation.
- **F5.3**: K3-U-09 correlated failure demonstrated (LLM shares implementer bias).

### 11.7 B6 (DEFER)

- **F6.1**: none of the 5 triggers fire within 6 months → deferral becomes perpetual.
- **F6.2**: DEC-07 opens under a different path → dec02.T2 fires and gate must reopen.
- **F6.3**: reviewer reports deferral is confusing (unclear whether delegation is
  authorized ad-hoc).

### 11.8 B7 (RETIRE)

- **F7.1**: material incident attributed to implicit delegation post-retire.
- **F7.2**: Owner scaling confirmed post-retire → forces reopening.

**No quantitative thresholds are invented** beyond what evidence supports. The "≥3 in N
months" figures come from ARCH-005 review-trigger pattern (`COUNT` predicates).

---

## §12. REVERSIBILITY ANALYSIS

For each option, classify: REVERSIBLE · PARTIALLY REVERSIBLE · HIGH-COST REVERSAL ·
IRREVERSIBLE.

| Option | Classification | Rollback path | Migration burden | Compatibility | Precedent created | Future architecture constrained? |
|---|---|---|---|---|---|---|
| B0 | REVERSIBLE (trivially) | N/A | zero | full | none | none |
| B1 | REVERSIBLE | `git revert` gate | LOW | full | "docs-only delegation entries" | slight; DEC-07 has reference |
| B2 | REVERSIBLE | `git revert` pilot entry | LOW | full | "pilot as decision technique" | none |
| B3 | PARTIALLY REVERSIBLE | `git revert` gate + reopening procedure | MED (reviewer retraining) | full | "second closed vocabulary in CCP" | second closed-vocab norm |
| B4 | REVERSIBLE | `git revert` gate | LOW | full | "open-bounded with rule pattern" | none |
| B5 | HIGH-COST REVERSAL | `git revert` gate + retire LLM verifier | MED-HIGH (workflow + provider disconnect) | partial (verdict layer changes) | "packaged Owner decisions" precedent | LLM provider dependency |
| B6 | REVERSIBLE | N/A (no action taken) | zero | full | none | none |
| B7 | REVERSIBLE (organizationally challenging) | new decision to reopen | LOW technically; MED culturally | full | "some decisions accepted as permanent-default" | none technically |

**Reversibility as first-class variable**: B5 has the highest reversal cost, primarily
because introducing an LLM verifier changes the reviewer workflow. B7 has low technical
cost but real cultural cost.

**No option is IRREVERSIBLE**. This is a docs-only decision universe at HEAD `e529359`.

---

## §13. LOCK-IN ANALYSIS

### 13.1 Coupling with neighboring decisions

Per recomposition §10 (edges post-ARCH-007), verified against current state.

| Neighbor | Coupling | Verified at | Notes |
|---|---|---|---|
| DEC-07 D-VERIFICADOR | **HARD** | recomposition §10 + §11 | DEC-07 F2 needs delegation record to authorize verifier |
| DEC-04 D-CANONICAL | orthogonal | recomposition §12 (irreducible triple refuted) | Delegation is over actions, not over canonical formats |
| DEC-05 D-MOTOR | orthogonal | recomposition §12 | Motor is derivation; delegation is authority |
| DEC-08 D-INSTR | orthogonal | recomposition §10 | STALL instrumentation is separate |
| DEC-03 D-LIFECYCLE | orthogonal | recomposition §14 | Lifecycle is different primitive |
| DEC-STREAM-CONSUMER | orthogonal | recomposition §19 | Consumer is orthogonal |
| DEC-REVIEWER-VERDICT | ABSORB candidate | EXP-D §12 | If DEC-07 opens, subsumed there; not a coupling with DEC-02 |
| Future runtime | POSSIBLE | HYPOTHESIS | Only B5 introduces meaningful runtime coupling |
| Future verifier | HARD via DEC-07 | recomposition §11 | Same as DEC-07 |

### 13.2 Dependency separation

```
DEC-02 → DEC-07     = HARD
DEC-04 → DEC-05     = HARD
DEC-02 is orthogonal to DEC-04/05.
```

**Re-verified at HEAD `e529359`**: `AUTHORITY_KIND.md §7` explicitly declares DEC-02
relation SOFT/ENABLER (already ARCH-006 revalidated). DEC-04/05 coupling is derivation-
motor coherence, not authority. No triple-coupling emerges from re-inspection.

### 13.3 Hidden future commitments

- B3 sets precedent for "closed vocab as governance style". Future decisions (DEC-07
  verifier vocab, DEC-08 stall categorization) may inherit implicitly.
- B5 commits to LLM provider for reviewer workflow. Migration cost non-trivial.
- B7 commits to bottleneck as permanent architecture. Culture cost non-trivial.

### 13.4 Non-coupling to guard

- **DO NOT** couple DEC-02 to DEC-04/05 via a shared "canonical format for delegation
  entries". Anti-pattern (DEC-01 monolithic).
- **DO NOT** couple DEC-02 to DEC-03 via lifecycle-of-delegations. Delegation lifecycle,
  if needed, is a subset of DEC-03; do not resolve it inside DEC-02.

---

## §14. INFORMATION VALUE

For each unresolved element: `DECIDE` · `EXPERIMENT` · `DEFER` · `ABSORB` · `RETIRE`.

| Question | Class | Rationale |
|---|---|---|
| Should delegation be explicit at all? | DECIDE (in DEC-02 gate) | Central decision |
| Should ACTION_TYPE be open, closed, or field-local? | DECIDE | Central choice Q2 |
| Should DEC-02 be packaged with DEC-07? | DECIDE | B5 vs everything else |
| Are the 11 empirical actions exhaustive? | EXPERIMENT | mini-EXP U1 (harness runtime types survey) or wait 6 months |
| Should harness runtime types have delegation entries? | DEFER | Requires harness contract inspection; not blocking DEC-02 |
| Should evidence-registration (mixed actor) be one or two entries? | EXPERIMENT or ABSORB | Small; resolve at gate-writing time |
| Should HRQS §12 escalation be modeled as activation predicate? | ABSORB | Answer within B1's activation section |
| Should executor-separation (CHANGE_PROVENANCE_F8) become universal? | RETIRE candidate or DEFER | Not scope of DEC-02 |
| Should DEC-REVIEWER-VERDICT be retired? | ABSORB (per EXP-D) | Not DEC-02's scope but noted |

**Highest information value unresolved question**: **Should DEC-02 be packaged with
DEC-07 (B5)?** This is the only choice that materially changes the CCP's runtime
posture. All others are docs-only reversible.

---

## §15. EXPERIMENTS

Evaluated per master prompt §20.

### 15.1 EXP-A — already completed

- **Status**: COMPLETE (2026-09-27).
- **Result**: DEC-02 formulable without D-CATALOG. HIGH (85%).
- **What it changed**: eliminated D-CATALOG resurrection as a concern.

### 15.2 EXP-D — already completed

- **Status**: COMPLETE (2026-09-27).
- **Result**: DEC-REVIEWER-VERDICT RETIRE candidate. HIGH (85%).
- **What it changed**: removed DEC-REVIEWER-VERDICT as a sub-decision of DEC-02 or DEC-07.

### 15.3 U1 — harness runtime types survey

- **Question**: how do `fork`, `general-purpose`, `Explore`, `Plan`, `claude`,
  `claude-code-guide`, `statusline-setup` map to AUTHORITY_KIND, and what actions do they
  execute?
- **Cost**: 1-2h reading harness documentation + Claude Code source references.
- **Information value**: MED. Determines whether the 11-action vocabulary is
  sufficient.
- **Reversibility**: N/A (research).
- **What it could change**: expand ACTION_TYPE to 12-15 if new actions emerge; refine B3
  vs B4 preference.
- **When it becomes necessary**: before choosing B3 (closed vocab). Otherwise, not
  blocking.

### 15.4 U2 — ACTION_TYPE open/closed question

- **Question**: is Owner preference OPEN-BOUNDED, CLOSED-BOUNDED, or field-local?
- **Cost**: none (Owner-only decision).
- **Information value**: HIGH. Determines choice between B1/B3/B4.
- **Reversibility**: reversible per option analysis §12.
- **What it could change**: pivots between B1 (open), B3 (closed), B4 (open-with-rule).
- **When it becomes necessary**: at gate opening.

### 15.5 U3 — mixed actor handling (evidence-registration)

- **Question**: is `evidence-registration` one delegation entry (mixed `agente +
  mecánica`) or two (agent produces + hook enforces)?
- **Cost**: minimal (documental).
- **Information value**: LOW. Consistency issue, not blocking.
- **Reversibility**: HIGH.
- **What it could change**: schema field expectations for §6.
- **When it becomes necessary**: at gate-writing time.

### 15.6 U4 — delegation gate scope (enum vs pilot)

- **Question**: does the gate enumerate all 11 delegations at once, or pilot 1 first
  (B2)?
- **Cost**: none (Owner choice).
- **Information value**: MED. B2 is information-first; B1 is decision-first.
- **When it becomes necessary**: at gate opening.

### 15.7 U5 — HRQS escalation as activation predicate

- **Question**: does HRQS §12 escalation-to-Owner count as an `activation` for a
  hypothetical "escalation-review" action delegation?
- **Cost**: 30 min (docs read).
- **Information value**: LOW-MED. Marginal case.
- **When it becomes necessary**: only if `escalation-review` is added as ACTION_TYPE
  entry.

### 15.8 U6 — executor-separation universality

- **Question**: does the executor ≠ author ≠ auditor pattern from `CHANGE_PROVENANCE_F8`
  become universal for all delegated executions?
- **Cost**: N/A (analytical, outside DEC-02 scope).
- **Information value**: LOW for DEC-02.
- **When it becomes necessary**: not for this gate.

### 15.9 Priority ordering (information value / cost)

1. **U2** (Owner choice on ACTION_TYPE openness) — required at gate opening.
2. **U1** (harness types survey) — needed only if B3 chosen.
3. **U3** (mixed actor) — small, resolve in-gate.
4. **U4** (enum vs pilot) — Owner criterion.
5. **U5**, **U6** — optional, marginal.

**Not required before opening DEC-02**: U1 (if not choosing B3), U5, U6. **Required
before opening**: U2 (Owner decides at gate).

---

## §16. DECISION CONDITIONS

Rather than recommending, the following states the conditions under which each option
becomes appropriate. **These are not evaluations of the options; they are formal
conditions for defensibility.**

### 16.1 B0 (NO-OP) is defensible when

- No material incident attributable to implicit delegation has occurred.
- Owner has no near-term S2/S3 scaling plans.
- DEC-07 opening is not scheduled or expected.
- Owner accepts K3-D-OWNER-DEFAULT as acceptable operating cost.

**Should be reconsidered when**: F0.1, F0.2, or F0.3 fires (§11.1).

### 16.2 B1 (DOCS-ONLY TABLE) is defensible when

- Owner wants delegation explicit but rejects runtime enforcement.
- 11 empirical actions are considered sufficient inventory as starting point.
- Owner accepts open-vocabulary drift risk (mitigated by review discipline).
- Governance value of auditability exceeds documentation cost.

**Should be reconsidered when**: F1.1-F1.3 fires (§11.2).

### 16.3 B2 (PILOT) is defensible when

- Owner prefers information-first (CASE D pattern from recomposition §35).
- Uncertainty about whether the §6 schema survives real use is high.
- Owner has capacity for 30-60 day observation.

**Should be reconsidered when**: F2.1-F2.3 fires (§11.3).

### 16.4 B3 (VOCAB-A-CLOSED) is defensible when

- Semantic consistency with ARCH-006 pattern is a governance value.
- Owner accepts rigidity cost.
- 11 empirical actions are considered stable inventory for CCP horizon.
- Formal reopening procedure is acceptable operational cost.

**Should be reconsidered when**: F3.1-F3.3 fires (§11.4).

### 16.5 B4 (OPEN-BOUNDED WITH RULE) is defensible when

- Owner wants documented governance without rigidity.
- Owner or reviewer will enforce "evidence ATTESTED" bar in practice.
- Uncertainty about action inventory stability is high enough that closing is premature.

**Should be reconsidered when**: F4.1-F4.2 fires (§11.5).

### 16.6 B5 (B1 + DEC-07 CONCURRENT) is defensible when

- LLM provider dependency is acceptable.
- Owner has 8-16h+ for packaged decision cycle.
- Verifier calibration data available (EXP-E per recomposition §30).
- Reviewer scaling pressure is real.

**Should be reconsidered when**: F5.1-F5.3 fires (§11.6).

### 16.7 B6 (DEFER) is defensible when

- Higher-value experiments are in flight (EXP-B drift shadow, U1).
- No immediate downstream pressure from DEC-07.
- Trigger predicates can be observably declared.

**Should be reconsidered when**: F6.1-F6.3 fires (§11.7).

### 16.8 B7 (RETIRE) is defensible when

- Owner explicitly accepts perpetual K3-D-OWNER-DEFAULT.
- No scaling plans.
- Owner prefers decision-graph minimalism over optionality.

**Should be reconsidered when**: F7.1-F7.2 fires (§11.8).

---

## §17. OWNER QUESTIONS

Smallest set of questions the Owner must actually answer.

### Q1 — Delegation scope

Does the CCP need explicit delegation governance at all?

- **A**: Yes, make delegation explicit → moves to Q2..Q7.
- **B**: No, K3-D-OWNER-DEFAULT is acceptable permanent state → **B0 or B7**.
- **C**: Not now; defer with triggers → **B6**.

### Q2 — ACTION_TYPE openness

If Q1=A, how should ACTION_TYPE be handled?

- **A**: Open-bounded (11 observed + new-with-evidence rule) → **B1 or B4**.
- **B**: Closed-bounded (11 exact, reopening for expansion) → **B3**.
- **C**: Field-local (no vocab constraint at gate level) → variant of B1 without §5.2
  enumeration.

### Q3 — Activation mechanism

If Q1=A, how do delegations activate?

- **A**: ARCH-005 vocabulary predicates (EVENT/CONDITION/COUNT/DATE/LINK).
- **B**: Free-form prose only.
- **C**: Combination (structured for major delegations; prose for minor).

### Q4 — Fallback model

If Q1=A, what is the default fallback when an activation fails or a subagent produces
unacceptable output?

- **A**: Always `humana` (Owner) — matches K3-D-OWNER-DEFAULT.
- **B**: Per-entry fallback (may vary; e.g., `mecánica` hook rejects then `humana`
  reviews).
- **C**: No formal fallback beyond "revoke the delegation".

### Q5 — Revocation model

If Q1=A, how are delegations revoked?

- **A**: New gate action (Owner reopens DEC-02 or subsequent gate to retire an entry).
- **B**: In-entry revocation predicate + procedure (per-entry semantic).
- **C**: Implicit (stop despachar; no formal record).

### Q6 — Provenance requirement

If Q1=A, is provenance required per entry?

- **A**: Yes, every entry links to its authorizing gate.
- **B**: No, gate document itself is provenance.
- **C**: Optional per entry.

### Q7 — Implementation boundary

If Q1=A, does the delegation model authorize any runtime enforcement?

- **A**: No — docs-only forever.
- **B**: No now — future decision can reopen for runtime.
- **C**: Yes — some subset of delegations get hook enforcement.

**Note on question load**: 7 questions map to a decision matrix of ~7 dimensions with
2-3 options each. This is deliberately thorough for a governance decision. If Owner
prefers fewer questions, Q3-Q6 can be defaulted to conservative baselines (Q3=A, Q4=A,
Q5=B, Q6=A) with Owner overriding as needed.

---

## §18. OWNER CHOICE TEMPLATE

**This block must remain empty.**

```text
DEC-02 OWNER DECISION

OWNER CHOICE:
[   ]

OPTION (B0..B7 or hybrid, or "custom"):
[   ]

Q1 — delegation scope:                   [   ]
Q2 — ACTION_TYPE openness:               [   ]
Q3 — activation mechanism:               [   ]
Q4 — fallback model:                     [   ]
Q5 — revocation model:                   [   ]
Q6 — provenance requirement:             [   ]
Q7 — implementation boundary:            [   ]

RATIONALE:
[   ]

CONDITIONS (must-hold, if-any-fires-reopen):
[   ]

EXPERIMENTS REQUESTED (U1..U6 or new):
[   ]

IMPLEMENTATION AUTHORIZATION:
[   ]

DEFERRAL TRIGGERS (if choice = B6):
[   ]

NOTES:
[   ]
```

**Do not populate this in the gate preparation phase.** The Owner enters values only at
gate-opening + choice event.

---

## §19. CONSEQUENCE MAP

For each option, what changes elsewhere. Classification: `D` direct · `S` second-order ·
`P` potential · `U` unknown.

### 19.1 B0

- DEC-07: NO CHANGE (`D`).
- DEC-03: NO CHANGE.
- DEC-04, DEC-05, DEC-08: NO CHANGE.
- Runtime boundary: NO CHANGE.
- Governance model: preserves K3-D-OWNER-DEFAULT explicitly.

### 19.2 B1

- DEC-07: enables cleaner gate formulation (`D`); F2 has explicit delegation reference.
- DEC-03: potential reuse of `activation` YAML pattern (`S`).
- DEC-04, DEC-05, DEC-08: no direct effect.
- Runtime boundary: unchanged (docs-only).
- Governance model: introduces explicit delegation as first-class object.

### 19.3 B2

- DEC-07: PENDING pilot outcome (`P`).
- DEC-03: no direct effect.
- Others: no direct effect.
- Runtime boundary: unchanged.
- Governance model: pilot approach becomes precedent.

### 19.4 B3

- DEC-07: verifier vocab may inherit closed-vocab pattern (`S`).
- DEC-08: STALL categorization may inherit closed-vocab pattern (`S`).
- Others: no direct effect.
- Runtime boundary: unchanged.
- Governance model: closed-vocab becomes CCP norm.

### 19.5 B4

- DEC-07: minor reference (`P`).
- Others: no direct effect.
- Runtime boundary: unchanged.
- Governance model: introduces "documented with rule" as governance style.

### 19.6 B5

- DEC-07: RESOLVED concurrently (`D`).
- DEC-REVIEWER-VERDICT: absorb into DEC-07 (as EXP-D suggested).
- DEC-STREAM-CONSUMER: potential integration if verifier emits to STALL stream (`P`).
- Runtime boundary: **CHANGES** (LLM verifier introduced).
- Governance model: packaged decisions become precedent.

### 19.7 B6

- DEC-07: REMAINS BLOCKED (`D`).
- Others: no direct effect.
- Runtime boundary: unchanged.
- Governance model: preserves optionality; ARCH-005 pattern extended.

### 19.8 B7

- DEC-07: must adapt to implicit delegation if it opens.
- Others: no direct effect.
- Runtime boundary: unchanged.
- Governance model: accepts permanent bottleneck.

---

## §20. 6-MONTH RESET TEST

If CCP discovers in 6 months that the chosen delegation model is wrong, how difficult is
reset?

### 20.1 B0

- Reset path: N/A (nothing to reset).
- Migration path: standard "open DEC-02 now" from unchanged baseline.
- Cost: zero.
- Historical implications: none.
- What survives: everything.
- What must be rewritten: nothing.

### 20.2 B1

- Reset path: `git revert` gate; declare DEC-02 reopened.
- Migration path: entries removed; K3-D-OWNER-DEFAULT restored (or replaced with another
  option).
- Cost: LOW (docs).
- Historical implications: git log preserves entries as historical reference.
- What survives: DECISION_HISTORY entry for original choice.
- What must be rewritten: gate document.

### 20.3 B2

- Reset path: `git revert` pilot entry.
- Migration path: pilot record kept as informational; new option chosen.
- Cost: LOW.
- Historical implications: pilot informs subsequent choice.
- What survives: pilot data.
- What must be rewritten: nothing beyond pilot entry.

### 20.4 B3

- Reset path: `git revert` gate + reopen for VOCAB change per ARCH-006-style procedure.
- Migration path: reviewers must relearn if vocab changes; entries with retired action
  types RESOLVED_BY new vocab.
- Cost: MED (reviewer + docs).
- Historical implications: closed-vocab precedent partially undone.
- What survives: procedure for closed-vocab reopening.
- What must be rewritten: gate + reviewer expectations.

### 20.5 B4

- Reset path: `git revert` gate.
- Migration path: same as B1.
- Cost: LOW.
- Historical implications: none.
- What survives: entries as historical reference.
- What must be rewritten: gate document.

### 20.6 B5

- Reset path: `git revert` gate + retire LLM verifier + reviewer workflow rollback.
- Migration path: LLM provider disconnected; reviewer resumes without verifier layer;
  possible re-review of past commits under new model.
- Cost: MED-HIGH.
- Historical implications: LLM verifier era is documented; some evidence entries may
  reference verifier output no longer trusted.
- What survives: verifier verdict entries as historical (may need re-verification).
- What must be rewritten: gate + verifier integration + workflow.

### 20.7 B6

- Reset path: N/A.
- Migration path: standard gate opening.
- Cost: zero.
- Historical implications: deferral entry documented.
- What survives: triggers as observed predicates.
- What must be rewritten: nothing.

### 20.8 B7

- Reset path: new decision to reopen (RETIRED status challenged).
- Migration path: DEC-02 status changes RETIRED → OPEN.
- Cost: LOW technically; MED culturally (justification for reopening required).
- Historical implications: RETIRED entry preserves reasoning.
- What survives: DECISION_HISTORY entry with RESOLVED_BY.
- What must be rewritten: DECISION_REGISTRY status.

---

## §21. ADVERSARIAL REVIEW

Self-attack of the gate preparation.

| Attack | Response |
|---|---|
| Did I hide an option? | 8 options + 3 coherent hybrids listed. Additional Owner-proposed hybrids explicitly welcomed. |
| Did I bias the Owner through wording? | Effort made in §8 to describe each option neutrally. No option is labeled "preferred". |
| Did I rank options implicitly? | Options presented in numerical order B0-B7. No sorting by desirability. §16 gives conditions, not preferences. |
| Did I call an option "simple" or "clean" without evidence? | Reviewed. Some hybrid descriptions say "coherent" — this is a technical descriptor about consistency, not desirability. |
| Did I smuggle implementation into the decision? | §7.2 explicitly bans implementation from DEC-02. No option in §8 requires implementation without separate authorization. |
| Did I revive D-CATALOG? | Explicitly banned in §7.2 and §5.4. No option requires it. |
| Did I treat ACTION_TYPE as canonical without authorization? | §5.1 marks ACTION_TYPE as "observed/bounded" NOT canonical. §5.3 is Owner-decidable. |
| Did I confuse authority with capability? | §3.1 lists actor capabilities (tools, permissionMode); §4.2 lists authority classes. Kept separate throughout. |
| Did I confuse capability with task? | ARCH-004 task types (CONTRACTUAL/TODO/SUBTASK/RESEARCH) are not folded into ACTION_TYPE (§5.1). |
| Did I confuse reviewer with verifier? | §2.2 distinguishes: reviewer verdict emission (covered by EXP-D 6 layers) vs verifier architecture (DEC-07). |
| Did I create a hidden DEC-07 decision inside DEC-02? | §7.2 explicitly bans it. B5 is a *concurrent* opening, not a folded decision — it means Owner opens both gates in the same cycle. |
| Did I use stale evidence as current evidence? | §10 evidence matrix has explicit epistemic status per claim. Historical DEC-02 formulation (pre-ARCH-006) is not used as authority. |
| Did I infer current behavior from historical commits? | Actor catalog (§3.1) is VERIFIED from current `.claude/agents/*.md`. Historical commits are inspected only for pattern examples (§2 evidence, §10 claim 19). |
| Did I convert an experiment into a requirement? | §15.9 explicitly states which experiments are required vs optional. Only U2 is required at gate opening; others are optional. |
| Did I create false precision? | Confidence percentages are qualitative estimates, not statistical. No claim to "P<0.05" or similar. |
| Did I claim confidence unsupported by sample size? | §10 confidence tags flagged where evidence is weak (claim 11, 15, 16 marked I/H with MED confidence). |

**Findings after adversarial review**: no material bias detected. Two soft caveats:

- **Caveat 1**: the enumeration order (B0-B7) may create anchoring bias toward middle
  options. Owner should feel free to pick any option, or propose a new one.
- **Caveat 2**: EXP-A + EXP-D generated the initial candidate options (B1-B7); B0 was
  added explicitly to preserve NO-OP as a legitimate choice. If Owner detects a missing
  option, this gate document should be extended.

---

## §22. GATE READINESS

Classification per master prompt §27.

**GATE-PREPARED-WITH-OPEN-QUESTIONS**.

Justification:

- 8 options + 3 coherent hybrids catalogued with complete before/after, evidence, risk,
  reversibility, lock-in.
- 20-claim evidence matrix with epistemic status.
- 8 falsifier sets for each option.
- 7-question Owner questionnaire with default fallbacks noted.
- Owner Choice template blank.
- Consequence map + reset test for all options.
- Adversarial review executed.

**Open questions requiring Owner input**:

- **Q1-Q7** (§17): the decision itself.
- **U2** (§15.4): pre-gate Owner criterion on ACTION_TYPE openness.
- **Optional pre-gate experiments** (U1 for B3, EXP-E for B5).

**Not claimed**: this is **not** "OWNER SHOULD CHOOSE B_x". The gate is prepared to
support Owner choice, whatever it may be — including B0 (do nothing) or B7 (retire).

**Distinctions preserved**:

```
GATE-PREPARED   ≠ GATE-OPEN
GATE-OPEN       ≠ OWNER-CHOSEN
OWNER-CHOSEN    ≠ IMPLEMENTED
IMPLEMENTED     ≠ VERIFIED
```

---

## §23. DECISION SPACE DELTA

### 23.1 Before EXP-A + EXP-D (POST-ARCH-007 recomposition §31 state)

```text
OPEN: DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-08, DEC-12,
      DEC-STREAM-CONSUMER, DEC-REVIEWER-VERDICT
DEC-02 status: root, formulability UNKNOWN empirically
```

### 23.2 After EXP-A + EXP-D

```text
OPEN: DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-08, DEC-12,
      DEC-STREAM-CONSUMER
DEC-02 status: FORMULABLE-CONFIDENCE-HIGH (85%) — GATE-PREPARABLE
DEC-REVIEWER-VERDICT: RETIRE candidate (RESOLVED_BY 6 layers)
```

### 23.3 Current DEC-02 gate space (this document)

```text
OPTIONS: {B0, B1, B2, B3, B4, B5, B6, B7} + coherent hybrids
DEC-02 status: GATE-PREPARED-WITH-OPEN-QUESTIONS
Owner questions: Q1..Q7 (§17)
Pre-gate experiment required: U2 (Owner criterion on ACTION_TYPE openness) if choosing
   B1/B3/B4
Pre-gate experiment optional: U1 (needed for B3 only)
```

### 23.4 Uncertainty removed

- D-CATALOG resurrection possibility: **REMOVED** (§5.4 + §7.2 guardrails).
- DEC-02 HARD-blocked-by-D-CATALOG hypothesis: **REMOVED** (EXP-A + §14 gate revalidation
  cited in evidence).
- ACTION_TYPE requires new catalog registry: **REMOVED** (§5.4 + guardrails).
- Reviewer verdict emission is a DEC-02 concern: **REMOVED** (EXP-D + §2.5).
- DEC-02 → DEC-07 HARD is preserved and reverified (§13.2).
- DEC-02 orthogonal to DEC-04/05 is preserved and reverified (§13.2).

### 23.5 Uncertainty remaining

- Owner sequencing preference (Q1-Q7): remains Owner-only.
- Harness runtime types authority classification (U1): unresolved until surveyed.
- Long-term action inventory stability: unresolved until observed longer.
- Whether B5 packaging is acceptable: depends on Owner + EXP-E outcome (not run here).
- Whether DEC-02 is the correct *next* gate to open: recomposition §35 CASE D suggests
  experiments-first was correct approach; this gate is the natural next step *if*
  Owner elects to move forward.

---

## §24. STATUS DECLARATION

- **NO Owner Choice** emitted.
- **NO IMPLEMENTATION AUTHORIZATION** emitted.
- **NO CHECKPOINT** proposed.
- **NO NEW DECISION** persisted in DECISION_REGISTRY.
- **NO EDGE OF DEPENDENCY MODIFIED** in canonical source.
- **NO RUNTIME, HOOK, SKILL, RULE, REGISTRY MODIFIED**.
- **NO `DELEGATION_REGISTRY.md`, `ACTION_TYPES_CATALOG.md`, `AUTHORITY_BOUNDARY.md`
  CREATED**.
- **NO modification of `AUTHORITY_KIND.md`, `DEFERRAL_POLICY.md`, `DECISION_REGISTRY.md`,
  `PROJECT_STATE.md`, `DECISION_HISTORY.md`, or `docs/CONTROL_PLANE_HANDBOOK.md`**.
- **NO modification of `.claude/*` (hooks, rules, agents, skills, context, settings)**.
- This artifact is **Stratum-C** untracked; its persistence beyond this session remains
  at Owner discretion.

**END — DEC-02 D-DELEG DECISION GATE PREPARATION**
