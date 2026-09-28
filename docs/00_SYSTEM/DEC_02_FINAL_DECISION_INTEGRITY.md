# DEC-02 FINAL DECISION INTEGRITY

```text
CHECK_ID             : DEC-02-FINAL-INTEGRITY
DECISION_UNDER_TEST  : DEC-02 D-DELEG (final pre-choice integrity review)
STATUS               : COMPLETE (integrity check) · NON-CANONICAL
CANONICAL            : NO (Stratum-C)
OWNER_CHOICE         : NOT MADE
IMPLEMENTATION_AUTH  : NONE
CHECKPOINT           : NONE
SOURCE_HEAD          : e529359
CHAIN_INPUT          : five prior Stratum-C artifacts (4,819 lines total)
DATE                 : 2026-09-28
AUTHOR               : Claude Opus 4.7 (final decision reviewer, non-decisor)
```

> **Purpose**. Not another audit. A last integrity pass over the decision
> surface, testing whether the Owner is being asked to decide only the
> semantic-required questions (representation, target semantics) or is
> being covertly asked to decide schema, rollout, revocation, and
> vocabulary at the same time. Any hidden decision must be surfaced or
> deferred.
>
> **Rules** (§11 of the mission): no canonical modification; no
> closing DEC-02; no checkpoint. Existing five-artifact chain preserved.

---

## 1. Purpose

Surface any residual defect in the Owner Choice surface before the
Owner reads. Specifically:

- Distinguish semantic decisions from schema decisions.
- Verify information-gain claims for R1 hold without covert R1
  presupposition.
- Confirm triggers are reopening events, not automatic decisions.
- Confirm reversibility across four dimensions (technical, governance,
  audit, cultural), not just `git revert`.
- Convert any unjustified point-estimates to ranges labeled as
  heuristic.
- Ensure the primary question separates "whether" from "how".

Output: `docs/00_SYSTEM/DEC_02_FINAL_DECISION_INTEGRITY.md`.

---

## 2. What Is Actually Being Decided

Two questions, in order:

- **Q-WHETHER**: should CCP make its implicit delegation pattern
  explicit as a `convención` governance object *now*?
- **Q-HOW** (conditional on Q-WHETHER = YES): what unit does a
  delegation entry name as its target?

Everything else — vocabulary policy (V), revocation semantics (Q),
rollout pattern (P), schema-field details, CAPABILITY, `compound`,
`stable_role`, `authorized_invoker`, harness-primitive modeling,
runtime enforcement — is **not** what the Owner is deciding at this
gate.

The prior chain has been rigorous about deferring most of this, but the
integrity check must confirm this cleanly.

---

## 3. Semantic Decision vs Schema Decision

The Owner Choice Package §5 presents MODEL-A as a 10-line schema.
Audit each element against the strictest classification the mission
demands.

| Element | Classification | Basis |
|---|---|---|
| `delegator` (default: Owner) | `SEMANTICALLY REQUIRED` | A delegation requires a delegator (D-1 of ground-truth §2.1). Default = Owner. |
| `delegatee.actor_kind` | `SCHEMA-LEVEL` (not required by semantics; useful for readability) | Kind can be inferred from `actor_ref` path prefix; `actor_kind` is a readability field. |
| `delegatee.actor_ref` | `SEMANTICALLY REQUIRED` | A delegation must identify *who*. |
| `scope` | `SEMANTICALLY REQUIRED` | D-3 of ground-truth §2.1 requires bounded scope. |
| `activation` | `DEFERABLE` | Activation predicate is a policy layer; it can be `implicit-at-despacho` initially. |
| `revocation` | `DEFERABLE` | No live revocation to trigger; predicate can be `gate-reopening` default. |
| `provenance` | `SCHEMA-LEVEL` | Git + gate reference; can be implicit in the containing artifact rather than an entry field. |

**Semantically minimum entry** (if the Owner wants to keep the entry
maximally lean):

```
delegation
├── delegator     (default: Owner)
├── delegatee_ref (path or identifier)
└── scope         (prose)
```

Three fields. Anything beyond is schema convenience.

**Verdict on §3**: the Owner does **NOT** need to decide MODEL-A's full
7-field schema at DEC-02. The Owner needs to decide **whether**
delegation becomes explicit (R) and **what unit** identifies the
delegatee (K). Schema breadth can be pilot-informed.

**This is the primary integrity correction of this document.** The prior
chain slid from *target semantics* into *schema commitment* without
naming the slide.

---

## 4. R Integrity Check

Test whether R-choice is cleanly separable from downstream commitments.

- **R0-D0 (DEFER)**: pure representation-level decision. No schema, no
  vocabulary, no rollout implied. `INTEGRITY: CLEAN`.
- **R0-D1 (RETIRE)**: pure representation-level decision. Same.
  `INTEGRITY: CLEAN`.
- **R1 (DOCS-ONLY)**: representation-level decision *plus* an implicit
  schema commitment if K is chosen simultaneously. **If Owner picks R1,
  the Owner is implicitly also authoring a first entry** — the schema
  emerges from that entry. `INTEGRITY: CLEAN provided the Owner
  understands R1 without a live entry is unusual`.

**Corollary**: R can be decided *before* K in principle, but R1 without
K is a documentation intent without a target model. The natural pairing
is R + K in the same session, or R0 alone.

---

## 5. K Integrity Check

Test whether K-choice is cleanly separable from V/Q/P.

- **K-A (ACTOR-ARTIFACT)**: identifies the target as an actor. Neutral
  on V (any vocabulary works for `actor_kind` values); neutral on Q;
  neutral on P. `INTEGRITY: CLEAN`.
- **K-B (TYPED ARTIFACT-REFERENCE)**: adds `type` field; forces V to
  cover `type` values (agent | skill) as at least a two-value vocabulary.
  This is a *coupled* decision: K-B implies a minimum V posture.
  `INTEGRITY: SMALL COUPLING to V`.
- **K-C (K2 AS-IS)**: no `type`; V neutral. `INTEGRITY: CLEAN`.
- **K-D (ACTION_TYPE)**: forces V to cover action-type values as a
  larger vocabulary. `INTEGRITY: COUPLED to V (heterogeneity
  question)`.

**Corollary**: K-A and K-C are cleanly separable from V/Q/P. K-B and
K-D are not — they carry an implicit V commitment.

---

## 6. V / Q / P Timing Check

For each, confirm the deferability the prior chain claimed.

| Dim | Deferable under K-A? | Deferable under K-B? | Deferable under K-C? | Deferable under K-D? |
|---|---|---|---|---|
| V | YES | Partial (K-B fixes a 2-value min vocabulary) | YES | Partial (K-D fixes a taxonomy) |
| Q | YES | YES | YES | YES |
| P | YES | YES | YES | YES |

**V is deferable cleanly only under K-A and K-C.**

**Q and P are deferable cleanly under any K.**

**Corollary**: if the Owner wants to maximize deferability of V, K-A
and K-C are the K-choices that preserve it. This is a small integrity
finding not in the Super Analysis.

---

## 7. Information-Gain Check

Prior chain claim under attack: *R1 + K-A gains information through
first authored entry*.

### 7.1 What information does R1 uniquely enable?

- **Reviewer discipline test**: whether reviewer and Owner *actually
  consult* a documented entry. Requires R1 to observe.
- **Downstream anchor for DEC-07 F2/F3**: only if DEC-07 F2/F3 opens
  during the observation window.

### 7.2 What information is obtainable WITHOUT R1?

- **Schema fit for MODEL-A**: a Stratum-C draft entry (unpublished, not
  in a canonical gate) can be authored on the scratchpad and
  interpreted by a cold reviewer. This is EXP-DEC02-SEM from the prior
  audit §22.
- **Whether K-A / K-B / K-C accommodates a given real case**: same —
  drafting reveals it.
- **Whether reviewer can distinguish agent-shaped from skill-shaped
  intent**: same — cold-reader test.

### 7.3 Consequence

The **information-gain argument for R1 collapses** for schema-fit
questions. It survives only for the *discipline-adoption* question and
the *downstream-anchor* question.

**Corrected integrity statement**: R1 gains *governance* information
(will reviewers consult it?) and *downstream* information (does it
anchor DEC-07 well?). It does not uniquely gain *schema-fit*
information — that is obtainable via a shadow experiment before R1.

The Super Analysis §22 already surfaces EXP-DEC02-SEM as the S-δ
sequence. The integrity check confirms: if the Owner prefers to buy
information cheaply, run the experiment *before* choosing R.

---

## 8. Trigger Integrity

The five reopening triggers in Super Analysis §25:

- Delegation incident recorded in INCIDENT_REGISTRY.
- DEC-07 F2/F3 opens.
- Owner declares S2/S3 scaling.
- CAPABILITY threshold T-CAP-1..5 fires.
- Skill-shaped per-skill entry becomes materially useful (K-B trigger).

**Test**: each trigger is *observable* and *reopens the gate*, not
*automatically decides*.

| Trigger | Observable? | Auto-decides? |
|---|---|---|
| Delegation incident | YES — registry entry | NO — triggers reopening; Owner still chooses |
| DEC-07 F2/F3 opens | YES — gate state change | NO |
| S2/S3 declaration | YES — Owner statement | NO |
| CAPABILITY T-CAP-1..5 | YES — registry / audit inspection | NO — triggers reopening only |
| K-B trigger | YES — Owner-declared intent | NO — reopens K choice only |

**All triggers pass integrity: they reopen the decision, they do not
substitute for Owner authority.**

Prior chain phrasing did not conflate; this is confirmed clean.

---

## 9. Reversibility Integrity

Reversibility along four dimensions, not one.

| Path | Technical | Governance | Audit / Historical | Cultural |
|---|---|---|---|---|
| R0-D0 | HIGH (`git revert` a deferral entry) | HIGH (deferral was declared with triggers; reopening is on-pattern) | HIGH (deferral is part of the audit trail — reopening is documented on it) | HIGH (no cultural commitment made) |
| R0-D1 | HIGH | MED (organizational precedent of "permanent default" persists in principle) | MED (retirement is recorded; walkback needs a new decision) | MED (the "permanent default" pattern is a cultural artifact) |
| R1+K-A | HIGH (`git revert` of gate document; discontinue entries) | MED-HIGH (convention adopted; discontinuation is a governance act) | HIGH (all changes in git; entries are individually revertable) | MED (reviewer discipline retraining if entries were consulted routinely) |
| R1+K-B | HIGH | MED-HIGH | HIGH | MED |
| R1+K-C | MED (retrofit debt if entries accumulate; git revert incomplete because K-C's shape carries into every entry) | MED | MED (retrofit visible in git but scattered) | MED |
| R1+K-D | MED-LOW (vocabulary-lock-in retrofit) | MED-LOW | MED | MED-LOW |

**Integrity finding**: R0-D0 and R1+K-A are HIGH across all four
dimensions. R0-D1 has cultural friction. R1+K-C and R1+K-D drop on
technical + audit dimensions due to schema debt.

**No path is IRREVERSIBLE**. But the multi-dimensional view sharpens
which paths are truly reversible vs. reversible-in-principle-but-with-
friction.

---

## 10. Percentage Integrity

The Super Analysis uses point-percentages in §7 (R Deep Analysis),
§11 (Expected Regret), and §13 (Projections). Audit each cluster:

### 10.1 §7 point estimates (R Deep Analysis)

- P(technically appropriate), P(low regret), P(reversal-in-12mo),
  P(useful info), P(unnecessary governance) — five per option.

**Verdict**: each has a stated driver. Retain as HEURISTIC
ARCHITECTURAL ESTIMATE. **Recommendation for Owner presentation**:
convert critical numbers to ranges (e.g., "P(reversal-in-12mo) ≈
25–35%" instead of "25–35%" already-ranged for R0-D0 — good; other
numbers should follow the same treatment).

### 10.2 §11 Expected Regret

- Point-percentages for P(low), P(med), P(high) per option.

**Verdict**: retain the qualitative bands (LOW / LOW-MED / MED /
MED-HIGH / HIGH). The point percentages are directional; label them
`HEURISTIC ARCHITECTURAL ESTIMATE` and add ± 10% implicit uncertainty.

### 10.3 §13 Projections

- Point-percentages across 3 / 6 / 12 / 24 month horizons.

**Verdict**: retain, but Owner presentation should say "these are
architectural estimates, not empirical probabilities". Ranges are
already implicit in the drift trends; do not sharpen further.

**Overall integrity**: percentages have stated drivers; none is a
disguised assertion. Labels are already used ("HEURISTIC
ARCHITECTURAL ESTIMATE"). **Recommend**: on Owner presentation,
lead with the qualitative bands; use point percentages only as
supporting texture.

---

## 11. Hidden Decision Scan

Look for decisions embedded in the surface that are not surfaced as
Owner-facing choices.

| Candidate hidden decision | Where it hides | Surface it? |
|---|---|---|
| Schema breadth (3-field minimum vs 7-field MODEL-A) | Owner Package §5 presents MODEL-A directly | **YES — surface it as `SCHEMA DETAILS: DEFER or DECIDE`** |
| Whether to run EXP-DEC02-SEM before choosing | Super Analysis §10 (S-δ sequence) | **YES — surface it as an explicit pre-choice option** |
| Whether R1 without any authored entry is coherent | Not explicitly surfaced | **YES — explicit note** |
| Whether K-B implies a minimum V vocabulary | §5 above finds coupling | **YES — noted here** |
| Whether harness primitives require any Owner input at all | Reconciliation §11 leaves as `UNKNOWN` residual | **NO — correctly deferred** |
| CAPABILITY reentry | Explicit in §18 of Super Analysis | Correctly deferred |
| Runtime authorization | Explicit not-in-scope | Correctly deferred |

**Two hidden decisions surfaced by this integrity check**:

1. **Schema breadth** (3-field minimum vs 7-field MODEL-A) — the Owner
   should decide whether the gate commits to the full MODEL-A schema
   or authorizes a leaner "3-field minimum + evolve" pattern.
2. **Pre-choice experiment** (EXP-DEC02-SEM) — the Owner should decide
   whether to run this before choosing R/K, or proceed to R/K directly.

Both are noted in the final Owner Card (§14) as explicit choices.

---

## 12. Final Owner Decision Surface

### Level 1 — Owner decides now

- **R**: R0-D0 | R0-D1 | R1
- **K** *(only if R = R1)*: K-A | K-B | K-C | K-D
- **Schema breadth** *(only if R = R1)*: DEFER (3-field minimum, evolve
  with first entry) | DECIDE (adopt full MODEL-A now)
- **Pre-choice experiment**: RUN (EXP-DEC02-SEM before finalizing R/K)
  | SKIP

### Level 2 — Deferrable in this gate

- V (vocabulary policy)
- Q (revocation semantics)
- P (rollout pattern)
- Schema-field details beyond the minimum
- CAPABILITY (H4)
- `compound`, `stable_role`, `authorized_invoker`
- Harness-primitive modeling
- Runtime enforcement

**Level 2 items are not the Owner's responsibility at this gate.**

---

## 13. Technical Position

Classification per §10 of mission.

- **EVIDENCE-GROUNDED**:
  - The 5-of-11 real-delegation decomposition (ground-truth §3.2).
  - Absence of CAPABILITY from CCP corpus.
  - Absence of prior delegation records in canonical registries.
- **ARCHITECTURAL INFERENCE**:
  - MODEL-A as the minimum evidence-grounded schema.
  - R1+K-A as the technical default when a single answer is demanded.
  - R0-D0's frontier-parity with R1+K-A.
  - Percentage estimates in Super Analysis §7/§11/§13.
- **OWNER PREFERENCE**:
  - Choice between R0-D0 and R1+K-A (both frontier).
  - Whether to run EXP-DEC02-SEM before deciding.
  - Whether to commit MODEL-A schema in full or start with a 3-field
    minimum.
  - Whether to lock V (if K-B) or defer it.

No "winner" is asserted. The technical position labels each claim
truthfully.

---

## 14. Final Owner Card

```
DEC-02 FINAL OWNER CARD

DECIDE NOW:

  R = ______                     [R0-D0 | R0-D1 | R1]

  K = ______   [only if R = R1]  [K-A | K-B | K-C | K-D]

  Schema breadth = ______        [MINIMUM (3 fields, evolve) | FULL MODEL-A]
    (only if R = R1)

  Pre-choice experiment = ______ [RUN EXP-DEC02-SEM | SKIP]

MAY DEFER:

  V = DEFER (unless K-B, then implicit 2-value min)
  Q = DEFER
  P = DEFER

  Schema details beyond minimum:  DEFER
  CAPABILITY:                     DEFERRED (see §21 triggers in Super Analysis)
  `compound` / `stable_role` /
    `authorized_invoker`:         DEFERRED
  Harness-primitive modeling:     DEFERRED
  Runtime enforcement:            NOT AUTHORIZED

PRIMARY OWNER QUESTION:
  Should CCP make its implicit delegation pattern explicit as a
  convención governance object now (R = R1) or defer under ARCH-005
  triggers (R = R0)?  If R = R1, what unit identifies the target of
  a delegation entry (K)?

TECHNICAL POSITION:
  FRONTIER = { R0-D0, R1+K-A }. Neither dominates. R0-D0 preserves
  pure optionality; R1+K-A gains discipline / governance / downstream-
  anchor information but not schema-fit information (that is obtainable
  via EXP-DEC02-SEM before R1). Choice is Owner-preference-sensitive.
  Classification of the "R1+K-A preferred" language: ARCHITECTURAL
  INFERENCE, not EVIDENCE-GROUNDED verdict.

MAIN REVERSAL PATH:
  Technical HIGH across R0-D0 and R1+K-A. Governance MED-HIGH under
  R1+K-A (walking back a convention is a governance act). Audit HIGH
  (all changes in git). Cultural MED under R1 if reviewer discipline
  had begun to form; else HIGH.

MAIN REOPEN TRIGGER:
  Delegation incident recorded in INCIDENT_REGISTRY; DEC-07 F2/F3 opens;
  Owner declares S2/S3 scaling; CAPABILITY threshold T-CAP-1..5 fires;
  skill-shaped per-skill entry becomes materially useful.

OWNER CHOICE:
  PENDING

DEC-02:
  READY FOR OWNER CHOICE
```

---

## 15. Readiness

- **Semantic model integrity**: MODEL-A is DERIVED with HIGH
  confidence; the minimum semantically required entry has 3 fields
  (§3); full MODEL-A adds 4 schema-level fields (`actor_kind`,
  `activation`, `revocation`, `provenance`) that are all DEFERABLE
  in scope.
- **R integrity**: CLEAN.
- **K integrity**: CLEAN for K-A / K-C; small V-coupling for K-B /
  K-D.
- **V / Q / P timing**: deferable per §6 with the K-coupling noted.
- **Information-gain**: R1's info-gain argument narrowed to
  governance-discipline + downstream-anchor; schema-fit info is
  obtainable without R1 via EXP-DEC02-SEM.
- **Trigger integrity**: five triggers, all observable, all
  reopening-only, none auto-deciding.
- **Reversibility**: HIGH across four dimensions for frontier paths.
- **Percentage integrity**: point estimates retained as
  HEURISTIC ARCHITECTURAL ESTIMATE with drivers stated; qualitative
  bands lead the Owner presentation.
- **Hidden decisions**: two surfaced (schema breadth; pre-choice
  experiment); others correctly deferred.

**Owner Choice surface**: two Level-1 primary decisions (R, K
conditional), plus two Level-1 secondary decisions (schema breadth,
pre-choice experiment). Everything else is Level-2 deferrable.

**DEC-02 READY FOR OWNER CHOICE.**

Canonical modifications: NONE.
Runtime authorization: NONE.
Checkpoint: NONE.

---

## 16. Non-Modification Attestation

This integrity check did not modify:

- The five prior Stratum-C artifacts (all preserved).
- `AUTHORITY_KIND.md`, `DECISION_REGISTRY.md`, `DECISION_HISTORY.md`,
  `EVIDENCE_REGISTRY.md`.
- `DEC-02_D-DELEG_DECISION_GATE_REVISED.md`,
  `DEC-02_D-DELEG_OPENED.md`.
- `MASTER_HANDOFF.md`, `DECISION_SPACE_PREPARED.md`.
- `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md`.
- `.claude/*`.

Stratum-C, non-canonical. Persistence at Owner discretion.

**END — DEC-02 FINAL DECISION INTEGRITY — awaiting Owner Choice.**
