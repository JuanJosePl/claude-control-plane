# DEC-02 OWNER CHOICE PACKAGE

```text
DECISION_ID          : DEC-02
DECISION_NAME        : D-DELEG (Delegation Governance Model)
STATUS               : OPEN
OWNER_CHOICE         : PENDING
IMPLEMENTATION_AUTH  : NONE
CHECKPOINT           : NONE
SOURCE_HEAD          : e529359
STRATUM              : C (analytical; non-canonical)
GATE_ARTIFACT        : DEC-02_D-DELEG_DECISION_GATE_REVISED.md
PRIOR_AUDIT_CHAIN    : DEC_02_TARGET_SEMANTICS_AUDIT.md → …_RECONCILIATION.md
                       → …_DELEGATION_GROUND_TRUTH_AUDIT.md (3,218 lines total)
DATE                 : 2026-09-28
AUTHOR               : Claude Opus 4.7 (decision architect, non-decisor)
```

> **Purpose**. Convert the three prior analytical artifacts into a single
> compact, auditable, decisional package. This document is Owner-facing. The
> Owner should be able to make the DEC-02 decision from this document alone,
> without re-reading the audits.
>
> **Non-negotiables** (from mission §1): no closing DEC-02; no canonical
> modification; no runtime authorization; no new abstractions; no reopening
> of CAPABILITY; no fresh investigation.

---

## 1. Current State

- **DEC-02** status: `OPEN`. Gate `FINAL_GATE_READY_WITH_MINOR_NOTES` per
  `DEC-02_D-DELEG_OPENED.md`; opened 2026-09-27 from HEAD `e529359`.
- **Owner Choice**: not made.
- **Implementation authorization**: none.
- **Checkpoint**: none.
- **Governing gate document**: `DEC-02_D-DELEG_DECISION_GATE_REVISED.md`
  (dimensional structure R × K × V × Q × P, six-sense delegation model).
- **Downstream dependencies** (per revised gate §16, §21): DEC-07 F2/F3
  softly informed; DEC-07 F1/F4 independent; DEC-04, DEC-05, DEC-03,
  DEC-08, DEC-12, DEC-STREAM-CONSUMER independent.
- **No prior canonical delegation record** exists (grep on
  `DECISION_REGISTRY.md` and `EVIDENCE_REGISTRY.md` for `delegation|
  delegat*` → 0 hits at HEAD `e529359`).

---

## 2. What Is Established `[VERIFIED]`

- **AUTHORITY_KIND VOCAB-A is closed** at `{mecánica, convención, humana,
  agente}`. `humana` and `agente` are the only authority-holder classes.
- **Two disjoint artifact spaces** exist under `.claude/`:
  `.claude/agents/` (5 file-defined actors) and `.claude/skills/` (~23
  procedure directories). Different natures.
- **K2 as currently written flattens these two spaces** into a single path
  field with no type label — the defect the audit chain is answering.
- **CAPABILITY is not a first-class object in the CCP corpus**: zero
  occurrences in `AUTHORITY_KIND.md`, `DECISION_REGISTRY.md`,
  `EVIDENCE_REGISTRY.md`; not among PRIM-1..PRIM-7 in the piece-and-idea
  audit. Sole appearance is the grammar output `CONTROLLED CAPABILITY` in
  `PIECE_AND_IDEA_PUZZLE_AUDIT.md §13`.
- **Zero incidents attributed to implicit delegation** in
  `INCIDENT_REGISTRY.md`.
- **Six delegation senses** (S1 Authorization, S2 Documentation, S3 Scope,
  S4 Activation, S5 Runtime permission, S6 Provenance) — revised gate §4.
  A docs-only R1 changes S2/S3/S4/S6 only.

---

## 3. What Is Inferred `[DERIVED]`

All three derivations are evidence-grounded but not verbatim in a
canonical artifact. Confidence `HIGH` (80–85%) per ground-truth audit
§14.

- **Delegation target = actor.** In every observed prospective delegation
  in the eleven-case inventory that satisfies the delegation minimum
  conditions D-1..D-4 (ground-truth §2.1), the recipient of the
  attributed authority is an actor (`agente` or `humana`).
- **Skills are scope elements, not target types.** Skills carry no
  AUTHORITY_KIND class of their own; execution authority is inherited
  from the invoker.
- **5 of 11 ACTION_TYPE items are default-covered procedure invocations,
  not delegations.** Rewording of the reconciliation's "Owner actions"
  claim, per ground-truth §14.3. The five `/no-go`, `/gate`,
  `/cerrar-fase`, `/adr`, `/incident` cases fail D-1 (no delegatee
  distinct from Owner-with-Claude-as-default) and D-4 (no distinctive
  change in the six senses).

---

## 4. What Is Deferred / Not-In-Scope `[PROPOSED · SPECULATIVE · OUT-OF-SCOPE]`

- `compound` target type — no corpus evidence; alternative decompositions
  (multiple entries, workflow-level artifact) suffice.
- `stable_role` label — no canonical CCP concept; preemptive design.
- `authorized_invoker` field — a repair to make skill-shaped targets fit;
  unnecessary under MODEL-A.
- **CAPABILITY** — `SPECULATIVE` per reconciliation §6 (`NOT PRESENT`,
  `NOT REFUTED`, not `CONTRADICTED`).
- Harness-primitive-as-agent modeling — collapses distinct categories;
  handle as `UNKNOWN` residual instead.
- Runtime enforcement (S1/S5 changes beyond convention) — explicitly out
  of DEC-02 scope per revised gate §7.2.

---

## 5. Final Semantic Model (MODEL-A — 10 lines)

```
DELEGATION
├── delegator             (default: Owner; VOCAB-A humana)
├── delegatee
│   ├── actor_kind        (agent | humana | harness-primitive-UNKNOWN)
│   └── actor_ref         (canonical path or identifier)
├── scope                 (prose; may name operations/skills/workflows)
├── activation            (predicate | despacho-event)
├── revocation            (predicate | gate-reopening)
└── provenance            ({gate_id, head_sha, commit_sha})
```

**No** `compound`, `stable_role`, `authorized_invoker`, `capability`,
`type` beyond `actor_kind`. Every field is justified by ground-truth
audit §15.

---

## 6. R — Representation

| Option | Meaning | Evidence | Benefit | Risk | Lock-in | Reversibility |
|---|---|---|---|---|---|---|
| **R0-D0** DEFER | No explicit representation; deferred via ARCH-005 trigger pattern | E-10 (0 incidents); E-12 (ARCH-005 available) | Zero commitment; preserves optionality | Bottleneck ambiguity persists at documentation layer | NONE | HIGH |
| **R0-D1** RETIRE | Accept K3-D-OWNER-DEFAULT as permanent documented default | E-10 | Minimal governance surface | Locks bottleneck as design intent; culturally hard to reverse | MED (organizational) | Tech HIGH, cultural MED |
| **R1** DOCS-ONLY | `convención` delegation entries; no runtime enforcement | E-01, E-02, E-08 | S2/S3/S4/S6 changed; consultable pattern; DEC-07 F2/F3 governance anchor | Convention dependence; discipline required | LOW | HIGH |

**Downstream consequences**:
- R0-D0: DEC-07 F2/F3, if opened, falls back to implicit delegation.
- R0-D1: same, plus a permanent-default precedent.
- R1: enables cleaner DEC-07 F2/F3 formulation; requires reviewer discipline
  to consult entries.

---

## 7. K — Target Model *(only if R = R1)*

**The central decision.** CAPABILITY is not a current option — it lives
in §11 deferrals.

### 7.1 K-A — ACTOR-ARTIFACT (MODEL-A)

- **Semantic meaning**: target = the actor (`agente` or `humana`); skills
  and workflows appear inside `scope` prose, never as targets.
- **Evidence basis**: 5 of 11 items are real actor-shaped delegations
  (A1..A5 in ground-truth §3.2); 5 are default-covered; 1 is a workflow
  spanning `mecánica` + default-covered. No non-actor target counterexample
  in observed corpus (ground-truth §12).
- **Covers**: all 5 real prospective delegations natively; harness
  primitives as `UNKNOWN` residuals; humana as future S2/S3 possibility.
- **Excludes**: per-skill invocation records; per-workflow delegation
  entries; compound targets; capability layer.
- **Complexity**: minimum — 7 fields, no `type` beyond `actor_kind`.
- **Lock-in**: LOW.
- **Reversibility**: HIGH (`git revert` of the gate document).
- **Future trigger to revisit**: RE-1..RE-4 in ground-truth §18 — any
  non-actor delegation surfacing; any skill/workflow gaining its own
  authority holder in AUTHORITY_KIND (which ARCH-006 §6 prohibits without
  formal reopening); K3-style corpus evidence for capability emerging.

**STATUS**:

```
K-A is EVIDENCE-GROUNDED / DERIVED.
NOT VERIFIED UNIVERSAL TRUTH.
Reason: the corpus contains no historical delegation records; the model
is derived from the five prospective actor-shaped cases (A1..A5 in the
observed 11-item inventory) and the semantic structure of CCP
(AUTHORITY_KIND VOCAB-A + revised gate §4 six-sense model).
```

### 7.2 K-B — TYPED ARTIFACT-REFERENCE (MODEL-3)

- **Semantic meaning**: target field carries explicit `type: agent |
  skill`; `type: agent` uses AUTHORITY_KIND `agente` natively; `type:
  skill` carries an `authorized_invoker` repair field.
- **Evidence basis**: two artifact spaces exist (`.claude/agents/`,
  `.claude/skills/`); K-B represents both as first-class targets.
- **Covers**: skill-per-skill authority records (if Owner wants that).
- **Excludes**: same as K-A for `compound` / `stable_role` / capability.
- **Complexity**: adds `type` field and `authorized_invoker`.
- **Lock-in**: LOW-MED.
- **Reversibility**: HIGH.
- **Future trigger to revisit**: Owner discovers skill-invocation
  authority no longer needs per-skill documentation → move to K-A.

### 7.3 K-C — CURRENT K2 AS-IS

- **Semantic meaning**: `.claude/skills/<skill>/SKILL.md` OR
  `.claude/agents/<agent>.md` — one path field, no type label.
- **Evidence basis**: exists in revised gate §6.2 as written.
- **Covers**: both spaces at the path level.
- **Excludes**: authority-anchor clarity; category discipline.
- **Complexity**: minimum drafting cost; deferred discipline cost.
- **Lock-in**: MED — retrofitting a `type` label after entries exist is a
  schema evolution.
- **Reversibility**: MED.
- **Future trigger to revisit**: an ambiguous entry emerges → retrofit
  urgent; the ARCH-007 D-CATALOG cleanup pattern re-appears.

### 7.4 K-D — ACTION_TYPE (K1)

- **Semantic meaning**: target = a labeled action type (from an 11-item
  or similar vocabulary).
- **Evidence basis**: revised gate §6.1 lists the 11 items with
  documented 5-5-1 heterogeneity.
- **Covers**: all 11 items nominally.
- **Excludes**: authority-anchor clarity; separates targets by artifact
  space.
- **Complexity**: introduces or reuses a taxonomy.
- **Lock-in**: MED-HIGH — the vocabulary becomes semi-canonical.
- **Reversibility**: LOW-MED.
- **Future trigger to revisit**: heterogeneity produces entries that mix
  categories (STRONG analogy to ARCH-007 D-CATALOG failure — not
  identical, but the same family).

### 7.5 K — deferred / not surfaced

- **K3** — a corpus-grounded alternative not covered by K-A..K-D.
  Currently `UNKNOWN` per revised gate §6.3.
- **CAPABILITY / HYBRID** — see §11.

---

## 8. V — Vocabulary *(only if R = R1)*

- **V1** open-bounded with attestation rule.
- **V2** closed-bounded (VOCAB-A-analog). **Flag**: sets a precedent as
  the second closed vocabulary in CCP after ARCH-006. Owner should decide
  V2 knowingly.
- **V3** field-local (each entry states its own value).

**Decision timing**: V is downstream of K. K-A (actor-only) makes V a
narrower decision (values are `agent | humana | harness-primitive-
UNKNOWN` for `actor_kind`, prose for `scope`). K-B/K-D expand the V
surface.

**MAY DEFER**. V does not have to be decided in the same gate as K. A
follow-up gate can close V once real entries begin to appear.

---

## 9. Q — Revocation *(only if R = R1)*

- **Q1** new-gate revocation — reopening the gate authors a revocation
  entry.
- **Q2** in-entry predicate — each entry declares its own revocation
  predicate + procedure.

**Decision timing**: independent of K choice. Q affects entry schema
only if an entry is being actively revoked. With zero existing entries
at HEAD, Q can be deferred.

**MAY DEFER** without contaminating K.

---

## 10. P — Rollout *(only if R = R1)*

- **P0** universal at gate opening — all entries declared together.
- **P1** phased pilot with measurement objective (revised gate §8.5.1).

**Decision timing**: independent of K. With zero existing entries, the
Owner may author one entry first (a de-facto P1 pilot without formally
declaring P1) and defer the P-dimension declaration.

**MAY DEFER**.

---

## 11. Deferred Items / Future Reopen Triggers

| Item | Why deferred | Reopening trigger | Where revisited |
|---|---|---|---|
| CAPABILITY (H4) | `SPECULATIVE`; not present in corpus | Multiple entries share stable semantic identity across implementation churn with observable cost; bulk-edit pattern on ≥3 entries; existing artifact begins representing capability first-class; DEC-07 F2/F3 requires implementation-independent identity beyond MODEL-A/K-B; PRIM excavation independently identifies CAPABILITY | Future DEC (post-DEC-02) or DEC-02 reopening |
| `compound` target type | No corpus evidence | 2+ real entries need multiple artifacts simultaneously with no cleaner decomposition; workflow-level artifacts appear needing first-class delegation coverage | DEC-02 reopening or schema evolution |
| `stable_role` label | New construct; preemptive design | Agent rename requires editing ≥2 entries coordinately; Owner declares naming discipline independent of DEC-02 | Future gate |
| `authorized_invoker` field | Conditional repair for K-B; unnecessary under K-A | Owner chooses K-B | Same gate if K-B chosen |
| Harness-primitive modeling | Collapses distinct category into agent artifact space | Owner needs to reference a harness runtime type and `UNKNOWN` residual becomes operationally painful | Future decision |
| Runtime authorization (S1/S5) | Out of DEC-02 scope per revised gate §7.2 | Owner requests mechanical enforcement | Separate future decision |
| K3 target model | No evidence-grounded alternative surfaced | New evidence for a non-actor target shape emerges | DEC-02 reopening |

---

## 12. Owner Question

> **Should CCP make its implicit delegation pattern explicit as a
> `convención` governance object, and if so, does the target of a
> delegation entry name an actor (K-A) or an artifact of one of two
> types (K-B), or is the choice deferred (R0)?**

Everything else (V, Q, P, CAPABILITY, `compound`, `stable_role`) is
either downstream of this question or deferred.

---

## 13. Owner Choice Card

```
DEC-02 OWNER CHOICE CARD

R:  ___  (R0-D0 defer | R0-D1 retire | R1 docs-only)

K:  ___  (only if R = R1)
        K-A  ACTOR-ARTIFACT (MODEL-A, preferred-by-evidence)
        K-B  TYPED ARTIFACT-REFERENCE (MODEL-3, if skill-per-skill wanted)
        K-C  CURRENT K2 AS-IS (flattened; ARCH-007-family risk)
        K-D  ACTION_TYPE (K1; heterogeneous vocabulary risk)

V:  ___  (MAY DEFER; V1 open | V2 closed | V3 field-local)
Q:  ___  (MAY DEFER; Q1 gate-reopening | Q2 in-entry predicate)
P:  ___  (MAY DEFER; P0 universal | P1 phased-pilot)
```

**CURRENT EVIDENCE**
- Two disjoint artifact spaces exist (`.claude/agents/` 5 files;
  `.claude/skills/` ~23 dirs).
- AUTHORITY_KIND VOCAB-A is `{mecánica, convención, humana, agente}` and
  closed; skills carry no authority-holder class.
- Of the 11 empirical ACTION_TYPE items, 5 are real actor-shaped
  delegations, 5 are default-covered procedure invocations, 1 is a
  workflow with no delegatee.
- Zero historical delegation records in canonical registries.
- Zero incidents attributed to implicit delegation.
- ARCH-005 pattern (from DEC-11 / `DEFERRAL_POLICY.md`) is available for
  R0-D0 with `trigger:` blocks.

**OPEN UNCERTAINTY**
- Whether Owner plans S2/S3 scaling in near horizon (affects R1 urgency).
- Whether DEC-07 F2/F3 is imminent (affects R0 viability).
- Whether harness-primitive references will need modeling (residual left
  as `UNKNOWN` under K-A; no forcing pressure today).
- Whether an incident will surface attributable to implicit delegation
  (would move R0 → R1 automatically).

**REVERSIBILITY**
- R0-D0: HIGH (nothing decided).
- R0-D1: HIGH technically, MED culturally.
- R1 K-A / K-B / K-C / K-D: HIGH — `git revert` of the gate document;
  no runtime state changes.

**LOCK-IN**
- R0-D0 / R0-D1: LOW (organizational only for D1).
- R1 K-A: LOW.
- R1 K-B: LOW-MED.
- R1 K-C: MED (retrofit debt).
- R1 K-D: MED-HIGH (vocabulary lock-in).

**WHAT CHANGES NOW** (if R = R1)
- One `convención` artifact begins existing under `docs/00_SYSTEM/`
  documenting the delegation pattern.
- S2/S3/S4/S6 delegation senses gain a documented record for the
  chosen scope.
- Owner and reviewer discipline: consult the entry before despachar.

**WHAT DOES NOT CHANGE**
- No hook is added or modified.
- No `.claude/*` runtime configuration changes.
- No AUTHORITY_KIND modification (ARCH-006 §6 prohibitions preserved).
- No DECISION_REGISTRY / EVIDENCE_REGISTRY / MASTER_HANDOFF changes.
- K3-D-OWNER-DEFAULT continues to operate mechanically; it becomes
  documented (with discipline) but not mechanically removed.

**WHAT IS EXPLICITLY NOT AUTHORIZED**
- Runtime enforcement of delegation (S1/S5).
- Creation of a CAPABILITY registry.
- Modification of AUTHORITY_KIND VOCAB-A.
- Resurrection of DEC-01 D-CATALOG.
- Opening of DEC-07 (sequencing choice; separate decision).
- Any change to DEC-04, DEC-05, DEC-03, DEC-08, DEC-12,
  DEC-STREAM-CONSUMER.

---

## 14. Conditional Decision Tree

```
IF R = R0-D0
    → no K/V/Q/P choice
    → DEC-02 closes with DEFER + observable trigger declaration
    → DEC-07 F2/F3 (if later opened) falls back to implicit delegation

IF R = R0-D1
    → no K/V/Q/P choice
    → DEC-02 closes with RETIRE + RESOLVED_BY pointer
    → K3-D-OWNER-DEFAULT accepted as permanent documented default

IF R = R1
    ↓
    CHOOSE K
    ↓
    IF K = K-A
        → MODEL-A schema (7 fields)
        → skill invocations documented in scope prose, not as targets
        → V/Q/P MAY DEFER to a follow-up gate
    IF K = K-B
        → adds `type` field and `authorized_invoker` for skill entries
        → V/Q/P MAY DEFER
    IF K = K-C
        → uses current K2 wording; accepts flattening
        → precedent-lock-in from ARCH-007-family risk
    IF K = K-D
        → uses K1 ACTION_TYPE vocabulary; heterogeneous
        → V-choice becomes materially harder

IF CAPABILITY PRESSURE EMERGES LATER
    → per §11 triggers → reopen in a future gate; not in DEC-02
```

---

## 15. Value of Information

| Uncertainty | VoI | Gain by deciding now | Loss by deciding now | Info if deferred |
|---|---|---|---|---|
| R (representation) | HIGH | Removes ambiguity about whether the delegation pattern is a governance object | Commits to convention-authority discipline (R1) or accepts bottleneck permanence (R0-D1) | Any incident attributable to implicit delegation would move R0 → R1 automatically |
| K (target model) | HIGH conditional on R=R1 | Removes K2 flattening; picks the target semantics | Commits to a target shape ahead of any actual entries | The first real delegation entry surfaces the concrete need |
| V (vocabulary) | MED | Removes ambiguity about value discipline | Slight risk of picking wrong vocabulary policy before entries exist | The vocabulary reveals itself once entries begin |
| Q (revocation) | LOW-MED | Removes revocation ambiguity | Commits before any revocation is needed | Any first revocation event demonstrates the needed semantics |
| P (rollout) | LOW | Explicit rollout plan | Commits to universal vs pilot before evidence | The first entry is a de-facto pilot regardless of P declaration |
| CAPABILITY | LOW today | Would settle an abstraction question | Would introduce speculative ontology | Any of §11 triggers would surface real evidence |

**Reading**: only R and K have HIGH VoI. V, Q, P can safely be deferred
to a follow-up gate under any R = R1 choice.

---

## 16. Reversibility / Lock-In Map

**LOW LOCK-IN** (easy to reverse):
- R0-D0.
- R1 K-A (any V/Q/P).
- V3 field-local under any K.

**MEDIUM LOCK-IN**:
- R0-D1 (organizational only; culturally hard to reverse).
- R1 K-B (schema surface slightly larger).
- R1 K-C (retrofit debt — the `type` field would eventually need adding).
- V2 closed-bounded under any K (precedent-lock-in flag).

**HIGH LOCK-IN**:
- Any accidental introduction of runtime authorization (explicitly out of
  DEC-02 scope; if it happened it would create hard lock-in — do not do).
- Any accidental introduction of CAPABILITY as a first-class object
  (would spread through DEC-07, DEC-REVIEWER-VERDICT, ARCH-006 pressure).

---

## 17. No-Surprise Check

Per mission §20.

1. **Is K-A grounded in observed CCP evidence?** YES — grounded in the
   eleven-case decomposition (5 real actor-shaped delegations, 5
   default-covered, 1 workflow) and AUTHORITY_KIND VOCAB-A (only
   `agente` and `humana` are authority-holders). Classification `DERIVED`,
   confidence HIGH.
2. **Are any new fields being smuggled into K-A?** NO — 7 fields, all
   justified. No `compound`, `stable_role`, `authorized_invoker`, `type`
   beyond `actor_kind`.
3. **Is CAPABILITY still correctly deferred?** YES — §11; reopening
   triggers preserved.
4. **Are skills correctly treated as scope/procedure?** YES — skills have
   no authority-holder class in AUTHORITY_KIND (verified); the five
   skill-invocation cases fail delegation minimum conditions D-1 and D-4.
5. **Are the five actor cases genuinely supported as delegation shapes?**
   YES — each of A1..A5 in ground-truth §3.1 satisfies D-1..D-4 and has
   a `.claude/agents/*.md` artifact `[VERIFIED]`. The delegations are
   prospective, not historical.
6. **Is any prospective claim being presented as historical fact?** NO —
   the audit chain explicitly notes that no prior canonical delegation
   record exists (grep returned 0 hits). Every entry in the eleven-case
   inventory is prospective.
7. **Does R1 accidentally authorize runtime?** NO — R1 is `convención`
   authority per revised gate §4.3; S5 (runtime permission) is
   explicitly UNCHANGED under any R1 choice per revised gate §9.2.
8. **Does choosing K-A accidentally decide DEC-04, DEC-05, or DEC-07?**
   NO — DEC-04/DEC-05 are independent per revised gate §12 claim 18;
   DEC-07 F1/F4 are independent; DEC-07 F2/F3 are `SOFT / STRONGLY-
   INFORMING` per §16 (informed, not decided).
9. **Can V/Q/P be safely deferred?** YES — §15 shows V/Q/P have LOW or
   MED VoI; §8..§10 note none are hard-coupled to K.
10. **Is the Owner question actually one decision rather than several
    hidden decisions?** The primary question in §12 asks about R and K
    (K conditional on R=R1). V/Q/P are downstream. CAPABILITY and other
    §11 items are explicitly deferred. **One primary decision surface.**

---

## 18. Final Readiness

```
DEC-02 OWNER READINESS
----------------------

SEMANTIC MODEL:
MODEL-A (ACTOR-ONLY) — 10-line schema in §5. Evidence-grounded /
DERIVED. No smuggled fields. Confidence HIGH (80–85%).

R:
READY. Three options presented: R0-D0, R0-D1, R1. Each with meaning,
evidence, benefit, risk, lock-in, reversibility, downstream.

K:
READY conditional on R = R1. Four options presented: K-A (preferred-
by-evidence), K-B, K-C, K-D. CAPABILITY correctly deferred (§11).

V:
READY (values presented) but MAY DEFER to follow-up gate; K-choice
does not require simultaneous V-choice.

Q:
READY (values presented) but MAY DEFER; no existing revocation to
trigger the choice.

P:
READY (values presented) but MAY DEFER; the first entry is a de-facto
pilot regardless of P declaration.

UNSUPPORTED ABSTRACTIONS REMOVED:
YES — `compound`, `stable_role`, `authorized_invoker` (under K-A),
capability-layer, harness-primitive-as-agent are all in §11 deferrals,
none in the current model.

HIDDEN DECISIONS:
NO — §17 checkbox 10 confirms one primary decision surface (R, then K
if R=R1); V/Q/P explicitly labeled MAY DEFER; DEC-07 sequencing,
runtime enforcement, AUTHORITY_KIND, DEC-01 resurrection all
explicitly not-in-scope.

OWNER QUESTION:
"Should CCP make its implicit delegation pattern explicit as a
convención governance object, and if so, does the target of a
delegation entry name an actor (K-A) or an artifact of one of two
types (K-B), or is the choice deferred (R0)?"

READY FOR OWNER CHOICE:
YES.

CANONICAL CHANGE:
NONE.

RUNTIME AUTHORIZATION:
NONE.
```

---

## 19. Non-Modification Attestation

This package did not modify:

- `DEC_02_TARGET_SEMANTICS_AUDIT.md`,
  `DEC_02_TARGET_SEMANTICS_RECONCILIATION.md`,
  `DEC_02_DELEGATION_GROUND_TRUTH_AUDIT.md` (prior audit chain preserved).
- `AUTHORITY_KIND.md`, `DECISION_REGISTRY.md`, `DECISION_HISTORY.md`,
  `EVIDENCE_REGISTRY.md`.
- `DEC-02_D-DELEG_DECISION_GATE_REVISED.md`, `DEC-02_D-DELEG_OPENED.md`.
- `MASTER_HANDOFF.md`, `DECISION_SPACE_PREPARED.md`.
- `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md`.
- `.claude/*` (any subtree).

`Stratum-C`, non-canonical. Persistence at Owner discretion.

**END — DEC-02 OWNER CHOICE PACKAGE — awaiting Owner Choice on §13.**
