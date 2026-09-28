# DEC-02 D-DELEG — DECISION GATE (REVISED)

```text
DECISION_ID          : DEC-02
DECISION_NAME        : D-DELEG
TITLE                : Delegation Governance Model
STATUS               : GATE_PREPARED_REVISED
STRATUM              : C
CANONICAL            : NO
OWNER_CHOICE         : NONE
IMPLEMENTATION_AUTH  : NONE
CHECKPOINT           : NONE
SOURCE_HEAD          : e529359
REVISION_BASIS       : docs/00_SYSTEM/DEC-02_D-DELEG_GATE_AUDIT.md
APPLIED_CORRECTIONS  : HIGH_ONLY (C-1..C-7)
PRIOR_ANALYTICAL_DRAFT : docs/00_SYSTEM/DEC-02_D-DELEG_DECISION_GATE.md (superseded analytical draft; not canonical truth)
PREPARED_BY          : Claude Opus 4.7 (analyst, non-decisor)
REVISION_DATE        : 2026-09-27
```

> **Purpose**: apply the seven HIGH-severity corrections identified by the adversarial
> audit. Preserve the valid analytical work while eliminating structural defects. The
> revised gate must be materially more accurate than the original. This document does
> **not** decide DEC-02; it does not open the gate operationally.
>
> **Epistemic scale (qualitative only)**: `HIGH` · `MED-HIGH` · `MED` · `LOW` ·
> `INSUFFICIENT`. Numeric confidence percentages are not used. Each rating carries a
> short textual reason.
>
> **Reading order for Owner**: §1 (question) → §4 (delegation semantics) → §7 (formal
> boundary) → §8 (dimensional space) → §10 (docs-only governance loop) → §18 (Owner
> questions) → §24 (change log).

---

## §1. DECISION QUESTION

**Central question**:

> **Should the CCP adopt an explicit, documented governance model for delegated
> execution authority, and if so, along which dimensions?**

Equivalent formulation:

> Should CCP make the implicit delegation pattern (K3-D-OWNER-DEFAULT + Owner-despacho
> workflow) explicitly documented as a governance object? If yes, along which axes must
> the Owner decide (key, vocabulary, revocation, rollout)?

### 1.1 What is inside DEC-02

- Whether to make the delegation pattern **explicit as a documented governance object**
  (`convención` authority) versus keeping it implicit.
- If explicit: what dimensions of the documentation (key, vocabulary, revocation).
- Whether to phase the rollout or apply universally.

### 1.2 What is outside DEC-02

DEC-02 must **not** decide:

- Overall agent architecture.
- Verifier architecture (DEC-07 territory — see §16 for the corrected relationship).
- Canonical policy format (DEC-04).
- Derivation motor (DEC-05).
- Lifecycle (DEC-03).
- Change-type taxonomy (DEC-01 RETIRED via ARCH-007; E1 DEFERRED).
- D-CATALOG resurrection in any form.
- Runtime enforcement (docs-only vs runtime is a **representation choice**, not a
  runtime authorization).
- Generic task, change, or verification taxonomy.
- Whether DEC-07 opens (sequencing choice; see §21).

**Anti-absorption rule**: if a candidate option or Owner question touches §1.2 items, it
belongs to another decision and should be split.

---

## §2. WHY THIS DECISION EXISTS

### 2.1 Observed present pattern — K3-D-OWNER-DEFAULT (VERIFIED)

**Claim**: implicit authority defaults to Owner (`humana`) unless a subagent is
explicitly despachado for a scoped task. This creates a workflow bottleneck.

**Evidence at HEAD `e529359`**:

- `.claude/agents/` has 5 file-defined subagents + 7 harness runtime types with declared
  tools and `permissionMode` but **no artifact declares which actions are
  pre-authorized versus which require Owner ack per invocation**.
- DECISION_REGISTRY records Owner-Chosen decisions as `humana` acts; no entry records
  "delegated authority already granted to agent X for action Y".
- MOVEMENTs 001-013 despachan subagents repeatedly; the criterion for each despacho is
  not recorded.

**Status**: `VERIFIED`.

### 2.2 Future capability question — DEC-07 F2/F3 informing (DOCUMENTED)

**Claim**: if DEC-07 opens with F2 (LLM adversarial verifier) or F3 (dual-LLM), a
delegation record would provide governance-quality authorization anchor for the LLM
verifier. Without one, DEC-07 F2/F3 falls back to implicit delegation — a governance
concern, not a technical block.

**Status**: `DOCUMENTED` — projected dependency, not active bug. DEC-07 F1 (humano
solo) and F4 (segundo humano) have no dependency on DEC-02.

### 2.3 Architectural hypothesis — delegation-as-object (HYPOTHESIS)

**Claim**: making the delegation pattern explicit improves auditability, reduces
K3-D-OWNER-DEFAULT observable ambiguity, and prepares DEC-07 for cleaner formulation.

**Status**: `HYPOTHESIS` — no incident yet attributed to implicit delegation.
`INCIDENT_REGISTRY.md` has zero entries matching "delegation".

### 2.4 What is failing today (`OBSERVED`)

- Cross-session record of "which delegations are in force" — **missing**.
- Auditability of the delegation act itself — **missing**.
- Formal revocation procedure — **missing**.
- S2/S3 onboarding readiness — **not tested**.

### 2.5 What is not failing today (`OBSERVED`)

- Hooks execute correctly for all agents.
- Reviewer verdict emission covered by 6 layers (per EXP-D).
- Owner remains authoritative (F9-D01=A).

### 2.6 Separation preserved

Per audit finding C-1, this section distinguishes:

- **Observed present problem** = §2.1 (workflow bottleneck).
- **Future capability problem** = §2.2 (DEC-07 F2/F3 quality).
- **Architectural hypothesis** = §2.3 (governance benefit).
- **Governance preference** = Owner's own (Q1 in §18).

These are **not merged** into a single "urgency" claim.

---

## §3. CURRENT BASELINE

All fields tagged. Where evidence is incomplete: `UNKNOWN`.

### 3.1 Actors (VERIFIED)

| Actor | Source | Tools declared | permissionMode | AUTHORITY_KIND class |
|---|---|---|---|---|
| architect | `.claude/agents/architect.md` | Read, Glob, Grep, Write, Edit | plan | `agente` |
| code-reviewer | `.claude/agents/code-reviewer.md` | Read, Glob, Grep | default | `agente` |
| implementer | `.claude/agents/implementer.md` | Read, Glob, Grep, Write, Edit, Bash | acceptEdits | `agente` |
| researcher | `.claude/agents/researcher.md` | Read, Glob, Grep, WebSearch, WebFetch | default | `agente` |
| security-auditor | `.claude/agents/security-auditor.md` | Read, Glob, Grep | default | `agente` |
| fork, general-purpose, Explore, Plan, claude, claude-code-guide, statusline-setup | harness | (varies) | (harness) | UNKNOWN |
| Owner | git identity | N/A | N/A | `humana` |
| Hooks (P0/P1) | `.claude/hooks/*` | — | — | `mecánica` |
| Rules & policies | `.claude/rules/*` + docs | — | — | `convención` |

### 3.2 Current delegation behavior (VERIFIED)

- **No explicit delegation record exists** in the repository.
- Owner despacha subagents ad-hoc; the despacho is the delegation act, parameters
  implicit.
- Activation / fallback / revocation semantics are all implicit.
- Scope is implicit in agent `tools:` and `permissionMode`.
- Provenance exists via git + subagent-stop-logger, but not delegation-authorization
  provenance.

### 3.3 What is controlled today

- Mechanical hook enforcement (`mecánica`).
- Reviewer verdict emission (6 layers per EXP-D §10.3).
- Owner authoritative for every gate (`humana`).

### 3.4 What is not controlled today

- No cross-session delegation record.
- No revocation event log.
- No auditability of despacho parameters.

---

## §4. DELEGATION SEMANTIC MODEL

*(Applies audit correction **C-1**: separate the six senses of "delegation".)*

The word "delegation" in prior artifacts conflated six distinct senses. This section
separates them explicitly. The distinction propagates throughout the rest of the gate.

### 4.1 The six senses

| # | Sense | Meaning | Where the change would live |
|---|---|---|---|
| S1 | **Authorization** | permission to act with binding effect | AUTHORITY_KIND application; runtime enforcement or Owner ack |
| S2 | **Documentation** | record of intended governance | docs-only artifact |
| S3 | **Scope description** | bounded operational domain of the delegation | docs-only artifact |
| S4 | **Activation policy** | condition under which the delegation applies | docs-only artifact (ARCH-005 pattern) |
| S5 | **Runtime permission** | mechanical ability to execute without per-despacho ack | hook / integration |
| S6 | **Provenance** | trace of who authorized when | git + gate document |

### 4.2 Effect matrix

| Sense | Changed by docs-only (R1)? | Changed by runtime enforcement (out of scope for DEC-02)? |
|---|---|---|
| S1 Authorization | **NO / CONDITIONAL** — a docs entry does not autonomously grant authority; it documents what was authorized by another mechanism | YES |
| S2 Documentation | **YES** | YES |
| S3 Scope | **YES** | YES |
| S4 Activation | **YES** | YES |
| S5 Runtime permission | **NO** — docs-only never mechanically permits invocation | YES |
| S6 Provenance | **YES** | YES |

### 4.3 Operational definition

For the purpose of DEC-02:

> **A docs-only DEC-02 mechanism is primarily a governance/convention and documentation
> mechanism (`convención` authority per AUTHORITY_KIND §3). It is NOT automatically a
> mechanical runtime authorization mechanism (`mecánica` authority) — that requires a
> separate future decision.**

### 4.4 Consequence for options

Every option in §8 must be described in terms of *which of the six senses it changes*.
This is done explicitly in §9 (Current Governance Effect) and §11 (BEFORE → AFTER).

---

## §5. AUTHORITY_KIND BOUNDARY

`docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006) is canonical for authority classes.

### 5.1 VOCAB-A CLOSED (VERIFIED)

```
CANONICAL_CLASSES     = { mecánica, convención, humana, agente }
CARDINALITY           = exactly 4
ORDINARY_MODIFICATION = NOT ADMITTED
NEW_CLASS_PROCEDURE   = formal reopening of ARCH-006
```

### 5.2 Sufficiency for DEC-02

Every observed actor + action combination in §3 maps to one of the four classes. The
mapping is not "clean 11/11" (previous overstatement) — it is: **every action-actor
pair has *some* valid authority class per the universal vocabulary**. That is trivially
true given the vocabulary is universal.

The non-trivial questions DEC-02 must decide are:

- Which (actor, action) pairs are **pre-authorized** (documented) versus require
  per-despacho ack.
- What key/vocabulary/revocation semantics apply to those pre-authorization records.

AUTHORITY_KIND does **not** answer these; it provides the class vocabulary that
delegation records reference in the `delegated_to` and `fallback` fields.

**Status**: `HIGH` confidence AUTHORITY_KIND is sufficient as the authority-class
vocabulary. Reason: 3 independent artifacts confirm (agents, rules, hooks).

### 5.3 Constraints preserved

- ARCH-006 §6 prohibitions apply: no `piece → authority` mapping, no meta-authority, no
  VOCAB-B/C.
- DEC-02 maps **action → authority-class** (indirectly, via the entry `delegated_to`
  field). This is not `piece → authority` mapping (`code-reviewer` is an actor with a
  role, not a piece being assigned authority as such).

---

## §6. DELEGATION KEY

*(Applies audit correction **C-5**: acknowledge ACTION_TYPE heterogeneity; present real
alternatives without picking one.)*

The Owner must decide **what a delegation entry is keyed by**. Three evidence-grounded
alternatives are visible in the repository. None is automatically superior.

### 6.1 K1 — keyed by ACTION_TYPE

- **Description**: a delegation entry names an `action_type` (e.g., `code-review`,
  `implementation`) and specifies who is authorized to execute it.
- **Observed candidates for ACTION_TYPE**: 11 items empirically visible.
  `code-review`, `implementation`, `research-external`, `architecture-analysis`,
  `security-audit`, `evidence-registration`, `adr-registration`,
  `no-go-verification`, `phase-gate-verification`, `phase-closure`,
  `incident-management`.
- **Heterogeneity warning** (`HIGH`): these 11 items **mix categories**:
  - 5 items are agent responsibilities (`code-review` = what code-reviewer does;
    `implementation` = what implementer does; etc.).
  - 5 items are skill invocations (`no-go`, `gate`, `cerrar-fase`, `adr`, `incident`).
  - 1 item is a cross-cutting workflow (`evidence-registration`: skill + hook enforce).
- **Risk**: this reproduces the DEC-01 D-CATALOG anti-pattern (mixing dimensions with
  different source-of-truth into one "vocabulary"). ARCH-007 lesson applies.
- **Advantages**: intuitive for reviewers reading the entry as "what is delegated"; can
  still be made coherent by grouping.
- **Disadvantages**: heterogeneity requires explicit categorization inside K1 or the
  key becomes semantically noisy.

### 6.2 K2 — keyed by SKILL / AGENT artifact

- **Description**: a delegation entry names the source artifact
  (`.claude/skills/<skill>/SKILL.md` or `.claude/agents/<agent>.md`) and specifies
  what use of that artifact is pre-authorized.
- **Observed candidates for the key**: 5 file-defined agents + ~24 skills present in
  `.claude/skills/` (grep shows ~24 skill directories inspected during audit).
- **Advantages**:
  - Direct reference to first-class repository artifacts (already canonical objects).
  - No new taxonomy required.
  - Every `.claude/skills/*/SKILL.md` and `.claude/agents/*.md` change is auditable via
    git; delegation entries inherit that provenance.
  - Handles the K1 heterogeneity by using two orthogonal artifact types (agent for
    persistent actors; skill for user-invocable operations).
- **Disadvantages**:
  - Cross-cutting workflows (e.g., `evidence-registration` touches skill + hook) do not
    fit cleanly under one artifact key.
  - Harness runtime types (fork, general-purpose, etc.) have no `.claude/agents/*`
    file; they would be `UNKNOWN` under K2.
  - "Skill invocation" and "agent responsibility" have different natures (skill = user
    invocation; agent = despachable actor); K2 flattens them.

### 6.3 K3 — evidence-grounded alternative if demonstrated necessary

- **Description**: a key not covered by K1 or K2, only introduced if repository
  evidence demonstrates neither K1 nor K2 suffices.
- **Status**: `UNKNOWN` — no concrete K3 identified in this preparation. Owner may
  propose one.
- Any K3 proposal would need to demonstrate:
  - Real repository evidence for the key concept.
  - Absence of the same anti-pattern as K1 (mixed dimensions) or K2 (cross-cutting
    workflow gap).

### 6.4 What NOT to do

Regardless of key choice:

- **Do NOT create** `ACTION_TYPES_CATALOG.md`, `ACTION_TYPES_REGISTRY.md`,
  `DELEGATION_REGISTRY.md`, `AUTHORITY_BOUNDARY.md`, or any registry file.
- **Do NOT introduce runtime enforcement** without a separate decision.
- **Do NOT map** `action_type → change_type` as a composite key (DEC-01 anti-pattern).

**Warning**: K1 without a pre-declared categorization discipline **reproduces DEC-01
D-CATALOG heterogeneity**. Owner should be aware.

**Explicit non-recommendation**: the gate does NOT declare K2 superior to K1. Both
have real trade-offs; the choice is Owner's.

---

## §7. FORMAL DECISION BOUNDARY

### 7.1 DEC-02 CAN DECIDE

- Whether to make delegation explicit at all (R0 vs R1).
- Which key to use (K1 / K2 / K3-if-demonstrated).
- Vocabulary policy for the chosen key (V1 / V2 / V3).
- Revocation semantics (Q1 / Q2).
- Rollout pattern (P0 / P1) — treated as sub-choice, not a distinct decision.
- Whether to defer or retire in the R0 branch (D0 / D1).

### 7.2 DEC-02 MUST NOT DECIDE

- Resurrect D-CATALOG.
- Modify `AUTHORITY_KIND.md`.
- Materialize any registry file as runtime piece.
- Introduce runtime enforcement (S5 in the semantic model). This is a **separate
  future decision** (per audit C-6).
- Cross F9-D01 (F9-D01=A vigente).
- Decide DEC-07 (see §16 for corrected relationship).
- Decide DEC-04/DEC-05, DEC-03, DEC-08, DEC-12, DEC-STREAM-CONSUMER.
- Absorb any neighboring decision.
- Whether to open DEC-07 concurrently — this is a **sequencing choice** (see §21).

### 7.3 Anti-absorption test

If any option in §8 grows to touch §7.2, it must be split off. The prior gate's B5
(concurrent DEC-07 opening) was such an over-absorption; it has been removed per
correction **C-3**.

---

## §8. DIMENSIONAL DECISION SPACE

*(Applies audit correction **C-6**: replace flat B0-B7 with dimensional structure.)*

The decision has ~5 real degrees of freedom (Representation × Key × Vocabulary ×
Revocation × Rollout). Flat option lists inflate cognitive load and hide the true
structure. The revised space uses conditional dimensions.

### 8.1 Dimension R — Representation

- **R0**: no explicit delegation representation (implicit governance preserved).
  - **R0-D0**: defer with observable triggers (ARCH-005 pattern).
  - **R0-D1**: retire with RESOLVED_BY pointer (accept K3-D-OWNER-DEFAULT as permanent
    documented default).
- **R1**: docs-only governance representation.
  - Requires choices in K, V, Q, P.
  - Governance effect defined per §4 (`convención` authority; documentation +
    scope + activation + provenance change; S1 authorization and S5 runtime
    permission unchanged).

**Not included** as a DEC-02 R-value:

- **Runtime enforcement** — this would change S1 (authorization) and S5 (runtime
  permission). It is a **separate future decision**, not a DEC-02 representation
  option.

### 8.2 Dimension K — Delegation Key *(only if R = R1)*

See §6 for full analysis.

- **K1**: ACTION_TYPE (with heterogeneity caveat).
- **K2**: SKILL / AGENT artifact.
- **K3**: evidence-grounded alternative (currently `UNKNOWN`).

### 8.3 Dimension V — Vocabulary Policy *(only if R = R1)*

Applies to the chosen key from §8.2.

- **V1**: open-bounded — enumerate observed values + rule "new value requires evidence
  ATTESTED at gate reopening".
- **V2**: closed-bounded — VOCAB-A-analog with fixed enumeration; new value requires
  formal reopening per ARCH-006 pattern.
- **V3**: field-local — no gate-level vocabulary; each delegation entry states its
  own value with local semantics.

### 8.4 Dimension Q — Revocation *(only if R = R1)*

- **Q1**: new gate action — revocation requires an Owner-authored gate reopening or
  supplementary gate.
- **Q2**: in-entry predicate + procedure — each delegation entry contains an
  activation predicate and a revocation predicate with an inline procedure.

### 8.5 Dimension P — Rollout *(only if R = R1)*

Treated as a rollout choice, not a distinct policy decision.

- **P0**: universal — all delegation entries declared at gate opening.
- **P1**: phased / pilot — one delegation entry first, then expansion (with explicit
  measurement objective; see §8.5.1).

### 8.5.1 Pilot measurement objective (required if P1 selected)

*(Applied from audit finding on B2 pilot; not one of the seven HIGH corrections but a
prerequisite for P1 to be a real pilot rather than delayed universal rollout.)*

If P1 is chosen, the pilot must declare at minimum:

- **Measurement variable**: e.g., "reviewer consults the entry ≥N times per despacho
  during observation".
- **Success criterion**: e.g., "entry scope covers ≥X% of actual invocations without
  contradiction".
- **Failure criterion**: e.g., "reviewer had to override the documented scope ≥Y times".
- **Observation window**: qualitative ("long enough to observe typical review
  activity"), not a fixed number of days.

Without these, P1 is equivalent to delayed P0 and should be dropped as a distinct
option.

### 8.6 Conditional structure summary

```
R = R0 (implicit governance preserved)
    ↓
    D = D0 (DEFER)  OR  D = D1 (RETIRE)
    ↓
    No K / V / Q / P choice.

R = R1 (docs-only representation)
    ↓
    K = K1 | K2 | K3-if-demonstrated
    ↓
    V = V1 | V2 | V3
    ↓
    Q = Q1 | Q2
    ↓
    P = P0 | P1 (with §8.5.1 requirements)
```

### 8.7 Permutation count

- R0 branch: 2 dispositions.
- R1 branch: `K × V × Q × P` = 3 × 3 × 2 × 2 = 36 gross combinations. But several are
  ruled out or dominated:
  - K3 requires evidence not yet identified → currently 0 effective combinations.
  - V3 (field-local) makes V-policy trivial → merges with any K.
  - Realistically ~12-18 non-degenerate combinations.

Owner is not expected to enumerate every combination. §18 asks the 4 core questions
sequentially.

### 8.8 Superseded flat options

The prior gate's `B0..B7 + hybrids` structure is retired. Mapping for reference:

- B0 → R0-D0 (deferred variant with implicit continuation).
- B1 → R1 with K1 open-bounded (V1) universal (P0) revocation-per-entry (Q2).
- B2 → R1 with the same as B1 but P1 (pilot). Now requires §8.5.1.
- B3 → R1 with K1 closed (V2).
- B4 → R1 with K1 open-with-rule (V1). Duplicate of B1 — merged.
- **B5 removed** per correction C-3 (scope violation). See §21 sequencing.
- B6 → R0-D0.
- B7 → R0-D1.

---

## §9. CURRENT GOVERNANCE EFFECT

For each dimensional choice, effects across the six delegation senses (§4).

### 9.1 R0 (implicit governance preserved)

| Sense | Effect |
|---|---|
| S1 Authorization | UNCHANGED |
| S2 Documentation | UNCHANGED |
| S3 Scope | UNCHANGED |
| S4 Activation | UNCHANGED |
| S5 Runtime permission | UNCHANGED |
| S6 Provenance | UNCHANGED |

R0 is a valid choice. It has zero governance movement.

### 9.2 R1 (docs-only representation)

| Sense | Effect |
|---|---|
| S1 Authorization | **NO / CONDITIONAL** — documentation does not autonomously delegate; Owner authority preserved unless a separate mechanism binds |
| S2 Documentation | CHANGED — delegation pattern becomes a documented governance object |
| S3 Scope | CHANGED — each entry declares scope |
| S4 Activation | CHANGED — each entry may declare activation predicate |
| S5 Runtime permission | UNCHANGED — no runtime enforcement introduced |
| S6 Provenance | CHANGED — gate document + git provide authorization provenance |

**Consequence** (correcting the previous "eliminates K3-D-OWNER-DEFAULT" overstatement,
audit correction **C-2**):

> R1 documents and makes consultable the delegation pattern. It **does not
> autonomously remove the workflow bottleneck**. Whether K3-D-OWNER-DEFAULT operates
> less in practice depends on whether Owner and reviewer adopt discipline of consulting
> the gate. That is `convención` authority (per AUTHORITY_KIND), enforced by adherence.

### 9.3 K3-D-OWNER-DEFAULT status per dimension

| Dimension choice | K3-D-OWNER-DEFAULT status |
|---|---|
| R0-D0 (DEFER) | **UNCHANGED** — deferred; no effect on default |
| R0-D1 (RETIRE) | **UNCHANGED** at workflow level; explicitly documented as permanent |
| R1 (any K/V/Q/P) | **DOCUMENTED** — pattern becomes consultable; **REDUCED** in practice only if discipline adopted; **UNCHANGED** mechanically |

**No option in the DEC-02 space "eliminates" K3-D-OWNER-DEFAULT**. Only a separate,
future runtime-enforcement decision (out of scope) could do so.

---

## §10. DOCS-ONLY GOVERNANCE LOOP

*(Applies audit correction **C-7**: explicit loop with mechanism, authority, evidence,
failure mode per stage.)*

Applicable to any R1 choice. The Owner must see this explicitly.

### 10.1 The loop

```
DECLARATION → INTERPRETATION → ACTION → OBSERVATION → DEVIATION DETECTION → CORRECTION
```

### 10.2 Per-stage analysis for R1

| Stage | Mechanism | Authority (per AUTHORITY_KIND) | Evidence | Failure mode |
|---|---|---|---|---|
| **DECLARATION** | Delegation entry added to gate document via Owner-authorized reopening | `humana` (Owner authors) + `convención` (document binds) | Gate document + git commit | Entry ambiguous or missing |
| **INTERPRETATION** | Owner and reviewer consult the gate before despachar | `convención` — adherence to documented pattern | None automated | Table not consulted; despacho proceeds under implicit delegation |
| **ACTION** | Owner despacha subagent; hooks execute mechanically | `humana` (despacho decision) + `mecánica` (hooks) + `agente` (subagent execution) | Git commit + subagent-stop-logger | Agent acts outside declared scope |
| **OBSERVATION** | Git log + subagent-stop-logger + EV registry | `mecánica` (loggers) + `convención` (EV entries) | Records present | Records not cross-referenced with delegation entry |
| **DEVIATION DETECTION** | **NONE AUTOMATIC** — a human must notice that agent output is outside declared scope | `humana` (reviewer) | Manual inspection | Deviation goes unnoticed until a downstream reviewer catches it or an incident occurs |
| **CORRECTION** | Owner reopens the gate to update the entry, or the Owner despacha again under corrected understanding | `humana` (Owner) | Gate document updated | Correction is ad-hoc if the gate is not reopened |

### 10.3 What R1 (docs-only) does NOT automatically provide

- **Automatic invocation checking**: no hook validates that a despacho matches a
  delegation entry.
- **Automatic scope checking**: no hook validates that agent output stays within
  declared scope.
- **Automatic deviation detection**: no observer detects "acted outside scope".
- **Automatic revocation**: revocation is manual (Owner reopens or ignores entry).

### 10.4 Properties the Owner is choosing knowingly

If Owner chooses R1, Owner is choosing:

- **Convention dependence** — the mechanism binds by adherence, not enforcement.
- **Human discipline dependence** — reviewer and Owner must consult the document.
- **Semantic drift risk** — entries may become stale relative to real practice.
- **Staleness risk** — no automatic freshness check.
- **Auditability benefit** — post-hoc analysis has a documented pattern to reference.

These are properties, not defects. They are the same properties every other
`convención` artifact in the CCP has (`CLAUDE.md`, `.claude/rules/*`,
`DEFERRAL_POLICY.md`). R1 places delegation under the same governance model.

---

## §11. BEFORE → AFTER (per representation choice)

### 11.1 R0 (implicit governance preserved)

- BEFORE: implicit delegation; Owner despacha ad-hoc.
- AFTER: identical.
- Delta: none.

### 11.2 R1 (docs-only, any K/V/Q/P)

- BEFORE: implicit delegation; despacho parameters not recorded; no consultable
  reference; K3-D-OWNER-DEFAULT operates.
- AFTER: delegation pattern documented as `convención` artifact; entries state key +
  scope + activation + revocation + provenance; Owner and reviewer *may* consult
  before despachar; K3-D-OWNER-DEFAULT still operates mechanically but is documented
  and (with discipline) may be reduced in practice.
- Delta: adds `convención` authority artifact; changes S2, S3, S4, S6 in the semantic
  model (§4); does NOT change S1 or S5.

### 11.3 Not analyzed here

- **Runtime enforcement** is out of DEC-02 scope. Its BEFORE → AFTER belongs in a
  separate decision.

---

## §12. EVIDENCE MATRIX

Qualitative confidence per audit correction C-8 (numeric percentages removed).

| # | Claim | Source | Status | Confidence (qualitative) | Reason |
|---|---|---|---|---|---|
| 1 | K3-D-OWNER-DEFAULT observable | `.claude/agents/*.md` + no delegation record | V | HIGH | 3 independent artifacts confirm |
| 2 | AUTHORITY_KIND VOCAB-A canonical | `AUTHORITY_KIND.md` ARCH-006 | V | HIGH | direct read |
| 3 | 11-action ACTION_TYPE vocabulary is heterogeneous | agent files + skill files | V | HIGH | direct classification per §6.1 |
| 4 | Harness runtime types authority is UNKNOWN | not in `.claude/agents/*` | U | — | evidence absent |
| 5 | DEC-07 F2/F3 benefits from DEC-02 record | recomposition + audit L | D | MED-HIGH | argument from DEC-07 formulation; refutable if DEC-07 F2 designed to accept implicit delegation |
| 6 | DEC-02 formulable without D-CATALOG | EXP-A §7.10 | V | HIGH | 10 falsifiers passed |
| 7 | Reviewer verdict emission covered by 6 layers | EXP-D §10 | V | HIGH | 6 layers verified |
| 8 | No delegation incident material | INCIDENT_REGISTRY inspection | V | HIGH | grep returned zero |
| 9 | ARCH-005 pattern applicable to activation/revocation | `DEFERRAL_POLICY.md` | V | HIGH | pattern is documented |
| 10 | K3-D-OWNER-DEFAULT is workflow default, not mechanical enforcement | audit D §5 | V | HIGH | no mechanism enforces "default humana" |
| 11 | 11 observed actions are exhaustive for CCP horizon | absence of counter-evidence | I | MED | not directly refutable but empirical only |
| 12 | Piece → authority mapping is prohibited by ARCH-006 §6 | `AUTHORITY_KIND.md` | V | HIGH | direct read |
| 13 | Owner scaling to S2/S3 planned | UNKNOWN | U | — | no evidence |
| 14 | LLM provider dependency introduces material lock-in | industry pattern | D | MED-HIGH | reasoning applies to any LLM verifier |
| 15 | Pilot generalizes from 1 to N delegations | HYPOTHESIS | H | — | untested |
| 16 | Action inventory stable at 11 for CCP horizon | INFERENCE | I | MED | susceptible to new skill/agent addition |
| 17 | Owner has bandwidth for gate reopening on new action | UNKNOWN | U | — | not known |
| 18 | DEC-02 orthogonal to DEC-04/DEC-05/DEC-03/DEC-08 | recomposition §11 + audit M | V | HIGH | independent dimensions |
| 19 | Executor ≠ author ≠ auditor pattern documented | `CHANGE_PROVENANCE_F8.md` | V | HIGH | direct read |
| 20 | Reviewer verdict schemas ready for `output_contract` reference | `.claude/agents/code-reviewer.md` + skills | V | HIGH | direct read |
| 21 | Docs-only R1 does not autonomously remove K3-D-OWNER-DEFAULT | audit D + §9-§10 | V | HIGH | semantic + governance-loop analysis |
| 22 | 11-action list mixes agent-responsibilities + skill-invocations + workflow | audit F | V | HIGH | direct classification |

Numeric percentages have been removed throughout. Qualitative reasons stated per claim.

---

## §13. FALSIFIERS

*(Applies audit correction C-9 partially: label unsupported quantitative thresholds as
`ANALYTICAL HEURISTIC` or `QUALITATIVE`. Full MEDIUM-severity threshold cleanup remains
pending.)*

For each dimension choice, what observation would materially worsen or invalidate it.

### 13.1 R0-D0 (DEFER)

- **F-R0D0.1** `QUALITATIVE`: Owner experiences repeated ambiguity in despacho
  decisions during an episode of sustained multi-agent work.
- **F-R0D0.2**: A trigger fires (per triggers declared with the DEFER).
- **F-R0D0.3**: DEC-07 opens under F2/F3 and requires a delegation reference.

### 13.2 R0-D1 (RETIRE)

- **F-R0D1.1** `QUALITATIVE`: material incident attributed to implicit delegation
  appears (recorded in INCIDENT_REGISTRY).
- **F-R0D1.2**: Owner scaling to S2/S3 confirmed.

### 13.3 R1 with K1 (ACTION_TYPE)

- **F-K1.1** `ANALYTICAL HEURISTIC`: heterogeneous vocabulary drift observed — new
  entries mix categories (agent-responsibility with skill-invocation) without
  distinction, reproducing DEC-01 D-CATALOG pattern.
- **F-K1.2** `QUALITATIVE`: reviewer reports the ACTION_TYPE key is ambiguous for a
  cross-cutting workflow.

### 13.4 R1 with K2 (SKILL / AGENT)

- **F-K2.1** `QUALITATIVE`: cross-cutting workflow (e.g., evidence-registration)
  cannot be cleanly assigned to one skill or agent; K2 becomes ambiguous.
- **F-K2.2**: harness runtime types (fork, general-purpose, etc.) require entries but
  have no `.claude/agents/*` file to reference.

### 13.5 R1 with V2 (closed vocab)

- **F-V2.1** `QUALITATIVE`: a new action/skill/agent emerges within the CCP horizon,
  forcing a reopening.
- **F-V2.2** `ANALYTICAL HEURISTIC`: reopening cost exceeds drift-prevention benefit
  after ≥1 reopening event.

### 13.6 R1 with V1 (open-bounded with rule)

- **F-V1.1** `QUALITATIVE`: "evidence ATTESTED" bar is bypassed in practice; new
  entries added without proper evidence.

### 13.7 R1 with P1 (phased)

- **F-P1.1**: pilot has no measurement objective declared per §8.5.1.
- **F-P1.2** `QUALITATIVE`: pilot outcome ambiguous after observation window (unclear
  whether the schema generalizes).

**Note**: quantitative thresholds ("≥3 in 3 months", "≥3 in 6 months", "20% FP",
etc.) used in the prior gate were labeled by the audit as unsupported. In this revised
gate they are either replaced with `QUALITATIVE` phrasing or explicitly marked
`ANALYTICAL HEURISTIC` where a rough magnitude is useful but the specific number is
not evidence-grounded. Full threshold cleanup is a pending MEDIUM-severity correction.

---

## §14. REVERSIBILITY

Qualitative classification.

| Dimension | Classification | Reset path | Migration burden |
|---|---|---|---|
| R0-D0 (DEFER) | REVERSIBLE | reopen the decision at any time | ZERO |
| R0-D1 (RETIRE) | REVERSIBLE-with-friction | new decision to reopen | LOW technically; MED culturally |
| R1 K1 V1 | REVERSIBLE | `git revert` gate + entries | LOW |
| R1 K1 V2 | PARTIALLY REVERSIBLE | `git revert` + reopening procedure per ARCH-006 pattern | MED — reviewer discipline retrain |
| R1 K2 (any V) | REVERSIBLE | `git revert` gate | LOW |
| R1 (any Q1) | REVERSIBLE | revocation via new gate action | LOW |
| R1 (any Q2) | REVERSIBLE | revocation via in-entry predicate | LOW |
| R1 P0 | REVERSIBLE | revert all entries | LOW |
| R1 P1 | REVERSIBLE | revert pilot entry | ZERO to LOW |

**No dimensional choice is IRREVERSIBLE**. This is a docs-only decision universe.

---

## §15. LOCK-IN

*(Applies audit correction C-8 partially: qualitative only.)*

| Dimension | Semantic | Governance | Technical | Precedent | Migration | Provider | Operator |
|---|---|---|---|---|---|---|---|
| R0-D0 | NONE | NONE | NONE | LOW (ARCH-005 pattern extended) | NONE | NONE | NONE |
| R0-D1 | NONE | MED (organizational — accepted permanent default) | NONE | MED-HIGH (permanent-default pattern) | LOW | NONE | LOW |
| R1 K1 V1 | LOW | LOW-MED (reviewer expected to consult) | NONE | MED (delegation-as-object pattern) | LOW | NONE | LOW |
| R1 K1 V2 | MED (closed vocab) | MED | NONE | HIGH (second closed vocab in CCP after ARCH-006) | MED | NONE | MED |
| R1 K2 (any V) | LOW | LOW-MED | NONE | LOW (skill/agent reference is already-existing pattern) | LOW | NONE | LOW |
| R1 Q1 | LOW | LOW | NONE | LOW | NONE | NONE | LOW |
| R1 Q2 | LOW-MED (per-entry semantics) | LOW-MED | NONE | LOW | LOW | NONE | LOW |
| R1 P0 | LOW | LOW | NONE | LOW | LOW | NONE | LOW |
| R1 P1 | LOW | LOW | NONE | LOW | LOW | NONE | LOW |

**Precedent lock-in note** (elevated per audit finding T-1):

- **R1 K1 V2** sets precedent for **second closed vocabulary in CCP** after
  ARCH-006 VOCAB-A. This propagation may affect DEC-07 verifier vocab (if opened),
  DEC-08 STALL categorization, and future taxonomies. Explicit choice.
- **R0-D1** sets precedent for **accepted permanent default** as decision outcome.
  Future decisions may inherit this framing.

---

## §16. DEC-07 RELATIONSHIP

*(Applies audit correction **C-4**: replace overstated HARD with precise SOFT /
STRONGLY-INFORMING, scoped to F2/F3.)*

### 16.1 Precise dependency statement

- **DEC-07 F1 (humano solo)**: **NO DEPENDENCY** on DEC-02.
- **DEC-07 F4 (segundo humano)**: **NO DEPENDENCY** on DEC-02.
- **DEC-07 F2 (LLM adversarial verifier)**: `SOFT / STRONGLY-INFORMING`. DEC-07 F2
  can be **formulated**, **prepared**, **opened**, and (with reduced governance
  quality) **implemented** without DEC-02. What DEC-02 provides is a governance-quality
  authorization anchor for the LLM verifier.
- **DEC-07 F3 (dual-LLM)**: same as F2.

### 16.2 Prerequisite types

| Type | Applies to DEC-07 F2/F3? |
|---|---|
| OPEN prerequisite (DEC-07 cannot open before DEC-02) | NO |
| FORMULATION prerequisite (DEC-07 cannot be formulated before DEC-02) | NO — PIECE_AND_IDEA_PUZZLE_AUDIT §5B already formulated DEC-07 candidates without DEC-02 |
| DESIGN prerequisite (DEC-07 design depends on DEC-02) | INFORMATIVE — design is cleaner with DEC-02 but does not depend on it |
| IMPLEMENTATION prerequisite (DEC-07 implementation quality depends on DEC-02) | **STRONGLY INFORMING** — F2/F3 implementation without DEC-02 falls back to implicit delegation, a governance-quality concern |
| VERIFICATION prerequisite (DEC-07 verification depends on DEC-02) | STRONGLY INFORMING — F2/F3 verification wants to point to an authorization record |

### 16.3 Correction summary

The prior gate's `DEC-02 → DEC-07 = HARD` is retired. Replacement:

```
DEC-02 → DEC-07 F1 / F4 = NO DEPENDENCY
DEC-02 → DEC-07 F2 / F3 = SOFT / STRONGLY-INFORMING
                          (implementation & verification quality only)
```

DEC-07 does not require DEC-02 to be closed before opening. The recomposition §11
"HARD" label was overstated; the audit L §13 corrects it.

---

## §17. DEC-04 / DEC-05 BOUNDARY

Retest orthogonality.

- **DEC-04 (canonical policy format)**: unrelated to delegation semantics. DEC-02
  schema describes delegation-entry shape, not policy-canonical-format. `NO OVERLAP`.
- **DEC-05 (derivation motor)**: unrelated. Motor is for policy derivation, not
  authority. `NO OVERLAP`.
- **DEC-03 (lifecycle)**: partial pattern overlap — both may use ARCH-005 activation
  vocabulary. This is precedent sharing, not decision coupling. `NO OVERLAP` at the
  decision level.

The previously refuted "irreducible triple" `{DEC-04, DEC-05, DEC-02}` remains
refuted (recomposition §12). Coupled cluster is `{DEC-04, DEC-05}`; DEC-02 is
orthogonal.

---

## §18. OWNER DECISION QUESTIONS

*(Applies audit correction on question inflation: reduce from 7 to 4 real questions.
Q3/Q4/Q6 defaults deferred to a later MEDIUM-severity correction — see §22 change log.)*

### Q1 — Do you want delegation made explicit at all?

- **A**: Yes → proceed to Q2, Q3, Q4 (in the R1 branch).
- **B**: No, K3-D-OWNER-DEFAULT is acceptable permanent → **R0-D1 RETIRE**.
- **C**: Not now; defer with triggers → **R0-D0 DEFER**.

### Q2 — If Q1=A, what is the delegation key?

- **K1**: keyed by ACTION_TYPE (with heterogeneity caveat per §6.1).
- **K2**: keyed by SKILL / AGENT (per §6.2).
- **K3**: evidence-grounded alternative (currently `UNKNOWN`; Owner may propose).

### Q3 — If Q1=A, what vocabulary policy?

- **V1**: open-bounded with rule for expansion.
- **V2**: closed-bounded (VOCAB-A analog; precedent lock-in per §15).
- **V3**: field-local (no gate-level vocab).

### Q4 — If Q1=A, what revocation semantics?

- **Q1-rev A** (avoid confusion with §18-Q1: call it **Rev1**): new gate action.
- **Rev2**: in-entry predicate + procedure.

### Sub-question Q5 (Rollout — only if Q1=A)

Not a first-class Owner decision; a rollout choice.

- **P0**: universal (all entries declared at gate opening).
- **P1**: phased / pilot (must satisfy §8.5.1 measurement requirements).

### Deferred questions (pending MEDIUM audit correction)

The following prior Q3/Q4/Q6 remain as *derivable defaults* rather than Owner
questions, pending a future MEDIUM-severity audit pass:

- **Activation mechanism** — default: ARCH-005 vocabulary (EVENT/CONDITION/COUNT/
  DATE/LINK). Marked `UNRESOLVED / PENDING MEDIUM CORRECTION AUDIT`.
- **Fallback** — default: `humana` always (per K3-D-OWNER-DEFAULT). Marked
  `UNRESOLVED / PENDING MEDIUM CORRECTION AUDIT`.
- **Provenance requirement** — default: gate-as-provenance (recommended per audit O).
  Marked `UNRESOLVED / PENDING MEDIUM CORRECTION AUDIT`.

These are not silently applied. Owner may override at gate opening.

### Owner Choice template

```text
DEC-02 OWNER DECISION (REVISED SPACE)

Q1 — delegation scope:                   [   ]  (A / B / C)
Q2 — delegation key (if Q1=A):           [   ]  (K1 / K2 / K3)
Q3 — vocabulary (if Q1=A):               [   ]  (V1 / V2 / V3)
Q4 — revocation (if Q1=A):               [   ]  (Rev1 / Rev2)
Rollout (if Q1=A):                       [   ]  (P0 / P1 + §8.5.1 requirements)

Deferred defaults (Owner may override):
  activation:                             [ARCH-005 vocab]  (UNRESOLVED)
  fallback:                               [humana]           (UNRESOLVED)
  provenance:                             [gate-as-provenance] (UNRESOLVED)

RATIONALE:
[   ]

CONDITIONS:
[   ]

EXPERIMENTS REQUESTED:
[   ]

IMPLEMENTATION AUTHORIZATION:
[   ]

DEFERRAL TRIGGERS (if Q1=C):
[   ]

NOTES:
[   ]
```

This block **must remain empty** during gate preparation. The Owner enters values at
gate-opening + choice event.

---

## §19. CONDITIONAL DECISION MAP

Instead of ranking options, this section states the conditions under which each
dimensional choice becomes defensible.

### 19.1 R0-D0 (DEFER) is defensible when

- Owner prefers optionality preservation.
- No material incident has appeared.
- Triggers can be observably declared.

### 19.2 R0-D1 (RETIRE) is defensible when

- Owner explicitly accepts K3-D-OWNER-DEFAULT as permanent.
- No scaling plans.
- Owner prefers decision-graph minimalism.

### 19.3 R1 K1 (ACTION_TYPE) is defensible when

- Owner accepts heterogeneous vocabulary risk (or intends to add categorization
  discipline).
- Intuitive "what is delegated" framing is preferred.

### 19.4 R1 K2 (SKILL / AGENT) is defensible when

- Owner prefers alignment with first-class repository artifacts.
- Cross-cutting workflows can be handled by adding explicit multi-artifact entries.
- Harness runtime types can remain out-of-scope or entered as `UNKNOWN`.

### 19.5 R1 V2 (closed vocab) is defensible when

- Semantic consistency with ARCH-006 pattern is a valued precedent.
- Owner accepts reopening cost for expansion.
- Second-closed-vocab precedent is acceptable.

### 19.6 R1 P1 (phased / pilot) is defensible when

- Measurement objective per §8.5.1 is declared.
- Owner prefers information-first over decision-first.

**No option is labeled "preferred", "best", or "recommended".** The Owner chooses.

---

## §20. REMAINING UNKNOWNS

- **U1** (unchanged from prior): harness runtime types (fork, general-purpose, etc.)
  authority classification. Affects only Q2=K2 with harness types entered.
- **U2** (unchanged): Owner OPEN-vs-CLOSED preference for chosen key vocabulary.
- **U3**: cross-cutting workflows (evidence-registration) — one entry or multiple?
  Owner criterion.
- **U4** (deprecated in revised space; rollout treated as sub-choice not decision).
- **U5** (unchanged): HRQS §12 escalation as `activation` predicate.
- **U6** (unchanged): executor-separation universality (out of scope).
- **U7** (revised): whether K2 handles cross-cutting workflows cleanly.
- **U8** (unchanged): DEC-04 drift-shadow experiment pending, out of scope.

### Pending audit corrections (not applied in this revision)

Per master prompt §19, this revision applied only HIGH corrections (C-1..C-7). The
following remain pending for a later audit pass:

- **MEDIUM-HIGH**: numeric confidence cleanup (partially done here for new content;
  full cleanup pending); B2 pilot measurement objective (partially addressed §8.5.1);
  Owner question load reduction (partially done — Q3/Q4/Q6 deferred as defaults);
  falsifier thresholds cleanup (partially done in §13; full cleanup pending).
- **MEDIUM**: Q5/Q6 defaults relabel; B1/B4 merge (structural merge done; policy label
  remains); B0/B7 framing clarification; AUTHORITY_KIND "11/11 clean" rewording.
- **LOW-MED**: provenance-per-entry redundancy note.

These are documented in the change log §24.

---

## §21. SEQUENCING NOTES

*(Applies audit correction **C-3**: replace B5 with sequencing note.)*

### 21.1 Concurrent DEC-07 opening

Owner may choose to open DEC-07 in the same session as DEC-02. This is a **sequencing
decision, not a DEC-02 option**. Under any DEC-02 outcome except R0-D1 (which
foreclosee DEC-07 F2/F3 quality pragmatically), Owner can open DEC-07 whenever the
DEC-07 gate is prepared.

Formally:

```
DEC-02 decision      ≠      DEC-07 decision.
DEC-02 opens         =      one gate document.
DEC-07 opens         =      a different gate document.
Concurrent opening   =      Owner sequencing choice, external to both gates.
```

### 21.2 Other sequencing considerations

- **Pilot phase-out timing** (if P1 chosen): Owner determines the observation window
  end and expansion trigger.
- **Delegation entry additions** (if V1 open-bounded): each new entry is a small
  Owner decision at gate reopening, not a full DEC-02 reopening.

### 21.3 What is NOT a sequencing note

The sequencing note is not:

- A back-door to bundle DEC-07 into DEC-02.
- An implicit recommendation to open DEC-07.
- A way to make DEC-07 F2 pre-decided.

It is a **reminder** that DEC-02 and DEC-07 are separate decisions whose opening
order the Owner controls.

---

## §22. ADVERSARIAL SELF-REVIEW

Attack the revised gate.

### 22.1 Test 1 — Can docs-only delegation still be misunderstood as runtime authorization?

- **Check**: §4.3 (operational definition) + §9.2 (governance effect) + §10.3 (loop
  does not automatically provide runtime enforcement).
- **Result**: three independent places state explicitly that R1 does not provide S1/S5.
- **Verdict**: **NO** — misunderstanding requires reader to skip three explicit
  statements. `PASS`.

### 22.2 Test 2 — Does B5 / DEC-07 packaging hide anywhere?

- **Check**: §8.8 (superseded flat options — B5 removed explicit); §7.2 (DEC-07
  excluded from CAN DECIDE); §21 (sequencing note only).
- **Result**: three independent removals.
- **Verdict**: **NO**. `PASS`.

### 22.3 Test 3 — Does any HARD DEC-02 → DEC-07 language remain?

- **Check**: §16.3 (correction summary retires HARD label); §16.1-16.2 (SOFT /
  STRONGLY-INFORMING per F2/F3 scope).
- **Result**: HARD label is explicitly retired.
- **Verdict**: **NO**. `PASS`.

### 22.4 Test 4 — Is ACTION_TYPE still presented as a canonical taxonomy?

- **Check**: §6.1 (K1 heterogeneity warning); §6.4 (do NOT create catalog); §8.8 (K2
  offered as alternative).
- **Result**: K1 is presented as heterogeneous with explicit warning; K2 is a real
  alternative.
- **Verdict**: **NO** — no canonical taxonomy claim survives. `PASS`.

### 22.5 Test 5 — Is the option space still secretly flat?

- **Check**: §8.1-§8.6 (five dimensions with conditional structure); §8.8 (flat B0-B7
  explicitly superseded).
- **Result**: dimensional structure is primary; flat mapping is historical only.
- **Verdict**: **NO**. `PASS`.

### 22.6 Test 6 — Is K3-D-OWNER-DEFAULT still described as eliminated by docs-only?

- **Check**: §9.2 (R1 effect matrix — S1 CONDITIONAL, S5 UNCHANGED); §9.3
  (K3-D-OWNER-DEFAULT status per dimension — DOCUMENTED/REDUCED-with-discipline for
  R1, UNCHANGED mechanically); §11.2 (BEFORE → AFTER for R1).
- **Result**: three explicit corrections.
- **Verdict**: **NO** — the elimination claim is retired. `PASS`.

### 22.7 Test 7 — Does the gate ask questions the evidence can answer?

- **Check**: §18 — Q3/Q4/Q6 (activation/fallback/provenance) moved to defaults with
  UNRESOLVED marker; Q1/Q2/Q3/Q4 core remain.
- **Result**: partial cleanup — 4 core questions remain; 3 deferred defaults marked.
- **Verdict**: **PARTIAL** — full cleanup deferred to MEDIUM-severity audit pass.
  `PASS with residual` (declared explicitly in §22 change log below).

### 22.8 Test 8 — Does analyst preference masquerade as Owner default?

- **Check**: §18 explicitly labels the three deferred defaults as
  `UNRESOLVED / PENDING MEDIUM CORRECTION AUDIT`.
- **Result**: analyst preferences are visible as such.
- **Verdict**: **PARTIAL** — full defaults cleanup pending. `PASS with residual`.

### 22.9 Test 9 — Does implementation detail masquerade as policy option?

- **Check**: §7.2 (runtime enforcement excluded from CAN DECIDE); §8.1 (runtime NOT
  as R value); §21 (concurrent DEC-07 is sequencing, not option).
- **Result**: three independent exclusions.
- **Verdict**: **NO**. `PASS`.

### 22.10 Test 10 — Does the revised gate accidentally recreate DEC-01 D-CATALOG?

- **Check**: §6.4 (do NOT create catalog); §6.1 (K1 heterogeneity warning explicitly
  citing DEC-01 anti-pattern); §7.2 (D-CATALOG resurrection banned).
- **Result**: three independent guards.
- **Verdict**: **NO**. `PASS`.

**Aggregate verdict**: 8 tests `PASS`, 2 tests `PASS with residual` (Q3/Q4/Q6 defaults
and analyst-preference cleanup deferred to MEDIUM-severity audit). No test fails.

---

## §23. GATE READINESS

Classification: **GATE-PREPARED-WITH-OPEN-QUESTIONS**.

### Justification

- Six HIGH corrections applied (C-1..C-7).
- Dimensional structure replaces flat options.
- Delegation semantic model explicit (six senses).
- K3-D-OWNER-DEFAULT elimination claim retired.
- B5 removed; sequencing note only.
- DEC-02 → DEC-07 HARD retired; precise SOFT/STRONGLY-INFORMING.
- ACTION_TYPE heterogeneity acknowledged; K2 alternative offered.
- Docs-only governance loop explicit.
- Numeric confidence percentages removed from all new content.
- Owner Choice template blank.

### Open

- Q3/Q4/Q6 defaults marked `UNRESOLVED / PENDING MEDIUM CORRECTION AUDIT`.
- Full quantitative threshold cleanup pending.
- U1-U8 experiments remain optional per §20.

### Distinctions preserved

```
GATE-PREPARED   ≠ GATE-OPEN
GATE-OPEN       ≠ OWNER-CHOSEN
OWNER-CHOSEN    ≠ IMPLEMENTED
IMPLEMENTED     ≠ VERIFIED

DOCUMENTATION   ≠ AUTHORIZATION
DOCUMENTATION   ≠ RUNTIME ENFORCEMENT
CONVENTION      ≠ MECHANICAL BINDING
```

---

## §24. REVISION / CHANGE LOG

### 24.1 HIGH corrections applied

| Correction | Applied? | Where | Result |
|---|---|---|---|
| **C-1 Delegation semantic separation** | YES | §4 (six senses), §9 (per-sense effects), §11 (BEFORE→AFTER per sense) | Six senses explicit; effect matrix per representation. Docs-only clearly distinguished from runtime authorization. |
| **C-2 K3-D-OWNER-DEFAULT correction** | YES | §9.2 (R1 effect matrix), §9.3 (status per dimension), §11.2 (R1 BEFORE→AFTER) | "Eliminates" language retired; "documents / makes consultable / reduced with discipline" language throughout. |
| **C-3 B5 removed** | YES | §8.8 (superseded flat options), §21 (sequencing note) | B5 removed as DEC-02 option; concurrent DEC-07 opening framed as sequencing choice external to DEC-02. |
| **C-4 DEC-02/DEC-07 dependency corrected** | YES | §16 (full section rebuilt) | HARD label retired; scoped to F2/F3 as SOFT/STRONGLY-INFORMING; NO DEPENDENCY for F1/F4. |
| **C-5 ACTION_TYPE heterogeneity** | YES | §6 (three keys K1/K2/K3), §6.1 (K1 heterogeneity warning) | Heterogeneity acknowledged with explicit DEC-01 anti-pattern citation; K2 alternative offered; K3 space open. |
| **C-6 Dimensional option structure** | YES | §8 (five dimensions with conditional structure), §8.8 (flat B0-B7 superseded), §18 (4 core Owner questions) | Flat options retired; dimensional space with conditional structure primary. Runtime enforcement explicitly moved out of R-values. |
| **C-7 Docs-only governance loop** | YES | §10 (full section: 6-stage loop, per-stage mechanism/authority/evidence/failure mode, explicit list of what R1 does NOT provide, properties Owner is choosing knowingly) | Loop explicit; deviation detection acknowledged as manual/human-dependent; convention-dependence surfaced. |

### 24.2 NOT applied in this revision

**MEDIUM-HIGH severity from prior audit**:
- Complete numeric-confidence cleanup (percentages removed in new content only; some
  legacy references may remain in cross-cited claims).
- Complete B2 pilot measurement objective (partially addressed in §8.5.1; may need
  further tightening).
- Complete Owner question reduction (Q3/Q4/Q6 moved to defaults but explicitly
  flagged UNRESOLVED).
- Complete falsifier threshold cleanup (partially done in §13; some qualitative labels
  applied but not exhaustive).

**MEDIUM severity from prior audit**:
- Q5/Q6 defaults full relabeling as ANALYST PREFERENCE.
- B1/B4 formal merge as sub-choice (structural merge done in §8.8; policy documentation
  merge pending).
- B0/B7 framing "not now" vs "not ever unless forced" (framed briefly in §19; formal
  narrative merge pending).
- AUTHORITY_KIND "11/11 clean mapping" rewording (§5.2 corrected; may need
  cross-reference cleanup).

**LOW-MED severity from prior audit**:
- Provenance-per-entry redundancy note (partially addressed in §18 defaults; formal
  provenance principle statement pending).

### 24.3 Explicit statement

```text
NOT APPLIED IN THIS REVISION:
MEDIUM-HIGH / MEDIUM / LOW-MED findings from prior audit
(docs/00_SYSTEM/DEC-02_D-DELEG_GATE_AUDIT.md §23 correction table
rows C-8..C-17).

These are documented as pending. Auditability preserved.
```

### 24.4 Traceability

- **Original gate**: `docs/00_SYSTEM/DEC-02_D-DELEG_DECISION_GATE.md` — preserved as
  **SUPERSEDED ANALYTICAL DRAFT** (not canonical truth).
- **Audit**: `docs/00_SYSTEM/DEC-02_D-DELEG_GATE_AUDIT.md` — 17 findings, verdict
  PASS_WITH_CORRECTIONS.
- **This document**: revised gate applying HIGH-only corrections.

---

## §25. STATUS DECLARATION

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
- **NO modification of `.claude/*`**.
- **NO modification of original `DEC-02_D-DELEG_DECISION_GATE.md`** (preserved as
  superseded analytical draft).
- **NO DEC-07 opened**.
- This revision is Stratum-C untracked; persistence remains at Owner discretion.

**END — DEC-02 D-DELEG DECISION GATE (REVISED)**
