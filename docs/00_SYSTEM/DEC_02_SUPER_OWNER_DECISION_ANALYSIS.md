# DEC-02 SUPER OWNER DECISION ANALYSIS

```text
ANALYSIS_ID          : DEC-02-SUPER-OWNER-DECISION
DECISION_UNDER_TEST  : DEC-02 D-DELEG (final pre-choice architectural analysis)
STATUS               : COMPLETE (analytical) · NON-CANONICAL
CANONICAL            : NO (Stratum-C)
OWNER_CHOICE         : NOT MADE
IMPLEMENTATION_AUTH  : NONE
CHECKPOINT           : NONE
SOURCE_HEAD          : e529359
AUDIT_CHAIN          : DEC_02_TARGET_SEMANTICS_AUDIT.md (1,445 lines)
                       → DEC_02_TARGET_SEMANTICS_RECONCILIATION.md (987 lines)
                       → DEC_02_DELEGATION_GROUND_TRUTH_AUDIT.md (786 lines)
                       → DEC_02_OWNER_CHOICE_PACKAGE.md (573 lines)
DATE                 : 2026-09-28
AUTHOR               : Claude Opus 4.7 (decision analyst, non-decisor)
```

> **Mission (§4)**. Answer: *which DEC-02 decision maximizes architectural
> value, future optionality, reversibility, and governance clarity while
> minimizing lock-in, complexity, and decision debt, given current evidence
> and remaining uncertainty?* This is not a fifth audit; it is a
> decision-scientific synthesis attacking even the accumulated technical
> default (R1 + K-A).
>
> **Non-negotiables (§32)**. No canonical modification; no runtime
> authorization; no CAPABILITY reopening; no closing DEC-02; no
> checkpoint; no implementation.
>
> **Heuristic estimates**. Percentages in this document are `HEURISTIC
> ARCHITECTURAL ESTIMATES` explaining relative weight, not empirical
> probabilities. Each is stated with its driver.

---

## 1. Executive Thesis

**Provisional technical default (before attack)**: `R1 + K-A` with V/Q/P
deferred.

**Executive finding after attack**: the choice reduces to a two-path
frontier, and *which path is right depends on Owner preference more than
on new evidence*:

- **Path α — R0-D0 with tight ARCH-005 triggers** — lowest-regret path
  under status-quo evidence (0 delegation records, 0 delegation incidents,
  no declared S2/S3 scaling in horizon). Zero governance discipline load.
  Reopens automatically on trigger.
- **Path β — R1 + K-A** — lowest-regret path if the Owner has *implicit
  intent* to open DEC-07 F2/F3 within the 6–12-month horizon, or values
  documented governance ahead of an incident. Adds modest convention-
  authority discipline.

Neither path commits to CAPABILITY, `compound`, `stable_role`, or runtime
enforcement. Both are HIGH-reversibility. The prior chain's "R1+K-A
preferred-by-evidence" language was defensible but under-weighted the
information-value of *waiting for a trigger* vs. *acting on absence of
evidence*.

Final delivery to Owner:
- A **technical default** = Path β (R1 + K-A, V/Q/P deferred).
- An **equally defensible alternative** = Path α (R0-D0 with declared
  triggers).
- **Owner-preference-sensitive**: choice depends on §26 profile (A/B/C).

DEC-02 remains `OPEN`. Nothing in this document decides.

---

## 2. Current Evidence State

Consolidated from the prior four artifacts. No new investigation.

**Established** `[VERIFIED]`:
- AUTHORITY_KIND VOCAB-A = `{mecánica, convención, humana, agente}`;
  closed by ARCH-006 §3; `agente` and `humana` are authority-holder
  classes.
- Two disjoint artifact spaces: `.claude/agents/` (5 files) and
  `.claude/skills/` (~23 dirs) at HEAD `e529359`.
- K2 as written flattens both spaces into one path field.
- CAPABILITY: zero occurrences in `AUTHORITY_KIND.md`,
  `DECISION_REGISTRY.md`, `EVIDENCE_REGISTRY.md`; absent from PRIM-1..7.
- Zero canonical delegation records (grep on registries → 0 hits).
- Zero incidents attributed to implicit delegation.
- Six-sense delegation model (revised gate §4).

**Derived** `[HIGH confidence, DERIVED]`:
- Target = actor (ground-truth §6).
- Skills = scope elements, not target types (ground-truth §8).
- 5-of-11 = default-covered procedure invocations, 5-of-11 = real
  actor-shaped delegations, 1-of-11 = workflow (ground-truth §3.2).
- MODEL-A (ACTOR-ONLY, 7 fields) is the minimum evidence-grounded
  target schema.

**Speculative / deferred**:
- CAPABILITY (H4) — `NOT PRESENT`, `NOT REFUTED`, `SPECULATIVE`.
- `compound`, `stable_role`, `authorized_invoker` — `PROPOSED`, no
  corpus evidence.
- Harness-primitive-as-agent — collapses distinct categories.

**Not observed but assumed by prior chain**:
- Owner scaling to S2/S3 (`UNKNOWN`).
- DEC-07 F2/F3 horizon (`UNKNOWN`).
- Whether reviewer discipline to consult entries can be sustained
  (`UNKNOWN`).

---

## 3. Central Thesis Attack

**Thesis under attack**: `R1 + K-A` is preferred-by-evidence.

### 3.1 R0-D0 steelman

- 0 canonical delegation records exist. R1 documents something the CCP
  has never needed to document before.
- 0 incidents attributed to implicit delegation. Governance failure has
  zero observed rate.
- ARCH-005 pattern (from DEC-11) is a live, tested mechanism for
  deferring with observable triggers.
- R0-D0 costs nothing until a trigger fires; R1 costs discipline
  forever.
- **Verdict**: R0-D0 is not the losing option; it is the null hypothesis
  that R1 has to overcome — and the evidence for overcoming it is
  entirely *projected*, not *observed*.

### 3.2 R1 is documenting the unmaterial

- K3-D-OWNER-DEFAULT operates today without documented delegation
  entries. The system functions. Documentation is `convención`; it does
  not enable a mechanism.
- If R1 is chosen but no entries are ever authored, R1's convention
  drifts into an unread artifact — the exact fragility K3-D-DEFERRAL-
  LIFECYCLE names.
- **Verdict**: R1 without a live use case is *pre-optimization* of
  governance.

### 3.3 K-A may be premature schema

- Even conceding target = actor, the schema commits to `actor_kind`,
  `scope`, `activation`, `revocation`, `provenance` — five fields
  authored ahead of any real entry.
- The first real delegation would reveal what the schema needs.
  Committing schema before entry is speculative.
- **Verdict**: K-A is semantically right; committing the schema without
  a pilot entry is *schema-first-instead-of-evidence-first*.

### 3.4 K-B may preserve future need K-A loses

- If, at 12 months, the Owner discovers a legitimate reason to record
  per-skill invocation authority (e.g., a subagent authorized to invoke
  only `/no-go` but not `/cerrar-fase`), K-A would need a migration
  adding `type` + `authorized_invoker`. K-B pre-empts that migration.
- **Verdict**: K-B's extra complexity is not free preemption; it also
  legitimizes skill-as-target, which the ground-truth audit found
  unsupported. K-B is `PLAUSIBLE` but its added complexity is not
  currently justified.

### 3.5 The real decision may not be R/K yet

- A minimum-cost information-gathering step: **write one draft
  delegation entry** (Stratum-C, unpublished) for `code-reviewer`. If
  drafting reveals K-A insufficient, revise. If it works, R1+K-A is
  vindicated.
- **Verdict**: this is EXP-DEC02-SEM from the prior audit §22. The
  Owner may prefer to run it before choosing.

### 3.6 Attack outcome

The thesis `R1 + K-A` survives, but weakened. The stronger honest
statement is: **R0-D0 and R1+K-A are both defensible; the choice
between them is preference-driven under status-quo evidence.**

---

## 4. R Deep Analysis

Framework per §7.

### 4.1 R0-D0 (DEFER with ARCH-005 trigger)

| Field | Value |
|---|---|
| Current evidence | 0 records, 0 incidents; ARCH-005 pattern available (DEC-11 checkpoint `cd0511c`) |
| Benefit | Zero commitment; preserves optionality; no new discipline load |
| Complexity | LOW — one deferral entry with `trigger:` blocks |
| Organizational effect | None immediate |
| Architectural effect | None immediate; K3-D-OWNER-DEFAULT continues |
| Info gained | Whether triggers fire in the horizon |
| Info lost | The signal that would come from a live entry pilot |
| Lock-in | NONE |
| Reversibility | HIGH |
| Migration cost (if R0 → R1 later) | LOW (same schema surface waits) |
| Downstream | DEC-07 F2/F3 (if opened) falls back to implicit delegation |
| Failure mode | Trigger fires and Owner is not present to react promptly |
| 6-month scenario | Most likely: no trigger; R0-D0 quietly holds. Less likely: DEC-07 opens and R0 becomes painful |
| 12-month scenario | Trigger becomes more likely as CCP matures; reopening cost still LOW |

**Heuristic estimates** (all `ARCHITECTURAL ESTIMATE`):

- P(technically appropriate) ≈ **70%** — driven by 0 evidence of need
  for R1 and the ARCH-005 precedent's fitness.
- P(low regret) ≈ **75%** — driven by HIGH reversibility.
- P(requires reversal within 12 months) ≈ **25–35%** — driven by
  uncertainty over DEC-07 F2/F3 horizon.
- P(creates useful information) ≈ **30%** — mostly passive; information
  comes from the trigger, not from R0-D0 itself.
- P(creates unnecessary governance) ≈ **5%** — a single deferral entry
  is not governance overhead.

### 4.2 R0-D1 (RETIRE)

| Field | Value |
|---|---|
| Current evidence | Same as R0-D0 |
| Benefit | Minimal governance surface; explicit design intent |
| Complexity | LOW |
| Organizational effect | Sets `permanent default` as an accepted pattern (precedent-lock-in flag) |
| Architectural effect | Documents K3-D-OWNER-DEFAULT as permanent |
| Info gained | None |
| Info lost | Same as R0-D0 plus future optionality |
| Lock-in | MED (organizational; cultural) |
| Reversibility | Technical HIGH, cultural MED |
| Migration cost | MED (would require reopening with justification) |
| Downstream | Same fallback behavior as R0-D0 |
| Failure mode | Owner later decides R1 was correct; cultural backtrack required |
| 6-month scenario | Same as R0-D0 but harder to walk back |
| 12-month scenario | If DEC-07 F2/F3 opens under implicit delegation, RETIRE becomes retroactively awkward |

**Heuristic estimates**:

- P(technically appropriate) ≈ **35%** — driven by lack of information
  vs. permanent commitment.
- P(low regret) ≈ **50%** — the retirement holds if no scaling ever
  happens; regret climbs otherwise.
- P(requires reversal within 12 months) ≈ **30–40%**.
- P(creates useful information) ≈ **10%**.
- P(creates unnecessary governance) ≈ **20%** — the retirement itself
  is a documentation act; if never referenced, it becomes dust.

### 4.3 R1 (DOCS-ONLY)

| Field | Value |
|---|---|
| Current evidence | Two artifact spaces exist; six-sense model available; convention-authority tooling (deferrals, gates) is proven |
| Benefit | S2/S3/S4/S6 delegation senses gain a documented record; DEC-07 F2/F3 gains a governance anchor |
| Complexity | LOW-MED (adds one convention artifact + reviewer discipline) |
| Organizational effect | Reviewer + Owner adopt discipline to consult entries before despachar |
| Architectural effect | K3-D-OWNER-DEFAULT documented but not mechanically removed |
| Info gained | First live delegation entry reveals actual schema fit |
| Info lost | Optionality of "not yet" |
| Lock-in | LOW (convention only) |
| Reversibility | HIGH |
| Migration cost | LOW (revert of gate; convention discipline unwinds naturally) |
| Downstream | DEC-07 F2/F3 (if opened) can reference the entries; ARCH-006 pressure zero |
| Failure mode | Entries drift stale relative to real practice; the "unread convention" fragility |
| 6-month scenario | If DEC-07 F2/F3 opens, R1 pays off; if not, R1 sits mostly unused |
| 12-month scenario | Depends on whether ≥1 real entry is ever authored |

**Heuristic estimates**:

- P(technically appropriate) ≈ **65%** — driven by prospective DEC-07
  benefit and by two-space observation supporting a documented model.
- P(low regret) ≈ **60%** — reversibility is HIGH but the discipline
  load creates small ongoing regret if unused.
- P(requires reversal within 12 months) ≈ **15%** — reversal is cheap
  but *reason to reverse* is rare.
- P(creates useful information) ≈ **65%** — first entry pilot informs
  V/Q/P and DEC-07 formulation.
- P(creates unnecessary governance) ≈ **25%** — if no entries are
  authored, R1 is orphaned governance.

---

## 5. K Deep Analysis

Only relevant if R = R1.

### 5.1 K-A ACTOR-ARTIFACT (MODEL-A)

- Semantic target = actor (`agente` or `humana`).
- Fits 5 of 11 items natively (A1..A5 real delegations).
- Excludes 5 of 11 items as default-covered — correctly per
  ground-truth §3.1.
- Excludes W1 workflow — correctly.
- Fields: `delegator`, `delegatee.{actor_kind, actor_ref}`, `scope`,
  `activation`, `revocation`, `provenance`.
- Handles harness primitives as `UNKNOWN` residual (`actor_kind:
  harness-primitive-UNKNOWN`).
- **Confidence**: HIGH (85%) as the minimum evidence-grounded schema
  under R1.

### 5.2 K-B TYPED ARTIFACT-REFERENCE (MODEL-3)

- Adds `type: agent | skill`; skill entries require `authorized_invoker`
  repair.
- Preserves skill-as-target expressibility that K-A rejects.
- Real future need it might preserve: per-skill invocation authority
  records (e.g., "subagent X may invoke only `/no-go`").
- Would that future need actually materialize? `UNKNOWN`. The ground-
  truth audit found no observed case; it does not find future cases
  impossible.
- Classification per §10: **`PLAUSIBLE`** future need; **`PREMATURE`**
  today; not `OVERENGINEERED` in the technical sense.
- Migration cost if K-A→K-B later: adding `type` and `authorized_invoker`
  to entries; low if entries are few.

### 5.3 K-C CURRENT K2 AS-IS

- Uses K2's flattened path form.
- Semantically incorrect per ground-truth §8 (a skill has no authority
  holder; K2 targets it as if it did).
- **But**: if the Owner intends *never* to author skill-shaped entries
  in practice, K-C's flattening is harmless in practice.
- Classification: **temporarily viable if entries stay agent-shaped in
  practice; MED lock-in on retrofit if skill-shaped entries appear**.

### 5.4 K-D ACTION_TYPE (K1)

- Uses an 11-item vocabulary with documented 5-5-1 heterogeneity.
- Even if not the target-shape, the vocabulary itself could be useful
  for scope-classification (a *label* on entries).
- Classification: **not the target model, but the vocabulary could live
  as a scope-classification field under K-A** if the Owner later wants
  it. Reject as target; consider as scope descriptor if useful later.

---

## 6. K-A Minimum Model Audit

Per §9, attack K-A even further.

- **"ACTOR-ONLY" enough?** For the observed 11-case inventory, YES —
  ground-truth §5 confirms every observed delegation is actor-shaped.
- **`actor_kind` necessary?** `MODERATE-YES`. Without it, `actor_ref`
  parsing must infer the kind from path prefix. Explicit `actor_kind`
  helps reviewer readability and handles the harness-primitive residual
  honestly.
- **`actor_ref` enough?** For semantic identity, `NO` — `actor_ref` is
  a *location* (path). Semantic identity is the *role* the actor
  performs. The audit chain calls this out (ground-truth §12): the
  reference is not the semantic object; the semantic object is the
  role. Whether the entry carries a separate `role_label` field is a
  choice — MODEL-A does not include one, treating role as implicit in
  the actor artifact's content.
- **`scope` too heavy?** Prose scope can carry ambiguity. A structured
  scope (e.g., `authorized_actions: [<list>]`) would be more auditable
  but pre-commits to a taxonomy — the exact anti-pattern the audit chain
  avoided. Prose is the honest choice today.
- **Hidden fields?** No — the schema in §5 (Owner Choice Package) has
  seven fields, each justified in ground-truth §15.
- **`harness-primitive-UNKNOWN` legitimate?** It is a documented gap,
  not an invented category. Prefer over pretending harness primitives
  are agent artifacts.
- **`humana` relevant now?** At S1, no real human delegatee beyond
  Owner. `humana` supports future S2 without adding fields — harmless
  future-facing coverage.

**Minimum true model** = MODEL-A as specified. No fields to remove; no
fields to add.

---

## 7. K-B Audit (Deep)

Per §10.

- **Real future need it preserves**: per-skill invocation authorization
  records. Scenario: DEC-07 F2 opens with an LLM verifier authorized
  only to invoke `/gate`. Under K-A that becomes a scope-prose statement
  on the LLM-verifier's delegation entry. Under K-B it becomes a
  separate skill-shaped entry.
- **Would K-A migration cost be high?** LOW — adding a `type` field
  after the fact is a small schema evolution.
- **Does K-B solve a problem K-A cannot?** Marginally — K-B provides
  first-class per-skill entries; K-A provides only entries whose scope
  includes skills.
- **Does K-B encode a future-CCP semantic distinction?** Only if the
  CCP develops per-skill authority as an object. That is speculative.
- **Classification**: `PLAUSIBLE` future need; `PREMATURE` today. Not
  wrong; just not currently earned by evidence.

---

## 8. K-C / K-D Audit

- **K-C**: keep the flattened K2 form. Temptation is *low commitment*:
  if entries never turn out to need distinction, K-C ties nothing. But
  entries that *do* need distinction later will require retrofit —
  MED lock-in. **Verdict**: viable only under an Owner intent to
  author no skill-shaped entries.
- **K-D**: ACTION_TYPE as target. Rejected as target semantics per
  ground-truth §5–§6. Consider only as a scope-classification field.
  **Verdict**: not a target model; may live as an optional entry field
  under K-A if the Owner later wants classification.

---

## 9. V / Q / P Timing Analysis

Per §12.

| Dim | VoI | Regret if now | Regret if deferred | Migration cost | Downstream dep | Verdict |
|---|---|---|---|---|---|---|
| V | MED | Small (picking wrong policy before entries) | Small (revealed by first entry) | LOW | K choice constrains V | **DECIDE LATER** |
| Q | LOW-MED | Small | Small (no live revocation to trigger) | LOW | None binding | **DECIDE LATER** |
| P | LOW | Small (P0 vs P1 with no real entries yet) | Small (first entry = de-facto pilot) | LOW | None binding | **DECIDE LATER** |

**All three MAY DEFER without contaminating K.** The V/Q/P decisions
are downstream of K choice AND downstream of the first real entry
being authored.

---

## 10. Sequencing Analysis

Per §13.

Candidate sequences:

- **S-α: R → observe (with R0)** — no K/V/Q/P chosen until trigger fires.
- **S-β: R → K → V/Q/P** — full commitment in one gate.
- **S-γ: R → K → pilot → V/Q/P** — commit R and K, then a pilot entry
  informs V/Q/P.
- **S-δ: R → pilot draft → K** — draft an entry, let the draft inform K.

| Sequence | Info gain | Lock-in | Reversibility | Coupling | Owner load |
|---|---|---|---|---|---|
| S-α | Low | None | HIGH | None | Minimum |
| S-β | Medium | LOW | HIGH | K-only | High (three decisions) |
| S-γ | High | LOW | HIGH | K then V/Q/P | Medium |
| S-δ | High | None (pilot draft is Stratum-C) | HIGH | None until closure | Medium |

**S-α and S-γ are the frontier.** S-β over-commits without evidence.
S-δ is EXP-DEC02-SEM from prior audit — attractive if the Owner is
willing to spend one session drafting before choosing.

**Recommendation-space**: pick S-α if valuing pure optionality; S-γ if
wanting movement with information gathering; S-δ if willing to run a
pre-choice experiment.

---

## 11. Expected Regret

Per §14.

| Path | Expected regret | P(low) | P(med) | P(high) | Drivers |
|---|---|---|---|---|---|
| R0-D0 | LOW | 70% | 25% | 5% | Reversibility HIGH; DEC-07 horizon `UNKNOWN` |
| R0-D1 | MED | 45% | 45% | 10% | Cultural precedent + retirement stickiness |
| R1 + K-A | LOW-MED | 55% | 40% | 5% | Convention discipline load; low probability of R1 turning wrong |
| R1 + K-B | MED | 40% | 45% | 15% | Extra fields; premature skill-target commitment |
| R1 + K-C | MED-HIGH | 30% | 45% | 25% | Retrofit debt; ARCH-007-family risk |
| R1 + K-D | HIGH | 20% | 40% | 40% | Vocabulary lock-in; strong-family analogy to ARCH-007 |

**Reading**: R0-D0 and R1+K-A are both `LOW`/`LOW-MED` regret. R0-D1,
R1+K-C, R1+K-D climb.

---

## 12. Decision Matrix

Descriptive only. Not a scoreboard.

| Dimension | R0-D0 | R0-D1 | R1+K-A | R1+K-B | R1+K-C | R1+K-D |
|---|---|---|---|---|---|---|
| Evidence alignment | HIGH (null) | MED | HIGH | MED-HIGH | LOW-MED | LOW |
| Semantic correctness | N/A | N/A | HIGH | HIGH (over-inclusive) | LOW (flattens) | LOW (heterogeneous) |
| Immediate value | LOW | LOW | MED | MED | LOW | LOW |
| Complexity | LOW | LOW | LOW-MED | MED | LOW | MED |
| Lock-in | NONE | MED (cult.) | LOW | LOW-MED | MED | MED-HIGH |
| Reversibility | HIGH | HIGH tech / MED cult | HIGH | HIGH | MED | LOW-MED |
| Optionality | HIGH | LOW | MED-HIGH | MED | LOW-MED | LOW |
| Future migration cost | LOW | MED | LOW | LOW | MED | MED-HIGH |
| Governance clarity | LOW (deferred) | HIGH (explicit permanence) | MED-HIGH | MED-HIGH | LOW | MED |
| DEC-07 F2/F3 compat | LOW (falls back to implicit) | LOW | HIGH | HIGH | MED | LOW |
| 6-month robustness | HIGH | HIGH | MED-HIGH | MED | MED | LOW-MED |
| 12-month robustness | MED-HIGH | MED | MED-HIGH | MED | LOW-MED | LOW |

**Frontier** (no dominance defeat): R0-D0 and R1+K-A. All others
dominated on ≥3 dimensions by one of the frontier options.

---

## 13. 3 / 6 / 12 / 24-Month Projections

Per §16. All estimates `HEURISTIC ARCHITECTURAL ESTIMATE`.

### 13.1 R0-D0 projections

| Horizon | P(assumption holds) | P(new requirement) | P(schema migration) | P(capability pressure) | P(runtime pressure) | P(delegation incident) | P(reopen) |
|---|---|---|---|---|---|---|---|
| 3 mo | 90% | 15% | 5% | 3% | 3% | 3% | 15% |
| 6 mo | 75% | 25% | 10% | 5% | 5% | 8% | 25% |
| 12 mo | 55% | 40% | 20% | 10% | 10% | 15% | 40% |
| 24 mo | 35% | 55% | 30% | 20% | 15% | 25% | 55% |

Drivers: as CCP matures, more subagents get despachados; the probability
that Owner-only mediation becomes painful climbs.

### 13.2 R1+K-A projections

| Horizon | P(schema unchanged) | P(new field needed) | P(K-A → K-B migration) | P(capability pressure) | P(runtime pressure) | P(entries drift stale) | P(reopen) |
|---|---|---|---|---|---|---|---|
| 3 mo | 95% | 5% | 3% | 3% | 3% | 5% | 5% |
| 6 mo | 85% | 15% | 8% | 5% | 5% | 15% | 15% |
| 12 mo | 70% | 25% | 15% | 10% | 8% | 30% | 25% |
| 24 mo | 50% | 40% | 25% | 20% | 12% | 45% | 40% |

Drivers: schema is small and fit; drift risk is the primary regret
vector.

### 13.3 R1+K-B projections

Similar shape to K-A but with slightly lower P(K→K migration) since K-B
pre-empts the K-A→K-B move. Slightly higher P(entries drift stale)
because extra fields = extra maintenance surface.

---

## 14. Six-Month Reset Test

Per §17. "We were wrong 6 months ago." For each frontier path:

### 14.1 R0-D0 wrong

- What went wrong: a delegation incident occurred and the CCP had no
  documented reference.
- What to undo: nothing to undo — R0-D0 was a `defer` decision, not an
  action.
- Artifacts changed: the R0-D0 deferral entry.
- Semantic model: intact (MODEL-A is not committed).
- Governance: no cultural debt.
- Downstream contamination: none — no downstream decisions built on
  R0-D0.

**Recovery cost: LOW.**

### 14.2 R1+K-A wrong

- What went wrong: authored entries drifted stale; or the schema turned
  out to need extra fields; or Owner discovered a non-actor target.
- What to undo: revert the gate document; disavow the entries; migrate
  or delete.
- Artifacts changed: the gate document + any entries authored.
- Semantic model: intact conceptually; discarded operationally.
- Governance: minor cultural debt (a documented convention was
  discontinued).
- Downstream contamination: DEC-07 F2/F3, if opened during the six
  months, would need to re-anchor.

**Recovery cost: LOW-MEDIUM.**

### 14.3 R1+K-C wrong

- What went wrong: entries accumulated with silent category mixing
  (ARCH-007 family failure).
- What to undo: cleanup pass over each entry to add `type` label; may
  require retro-classification.
- Artifacts changed: every entry.
- Semantic model: was already muddled.
- Governance: retrofit debt.
- Downstream contamination: DEC-07 references would need re-anchoring.

**Recovery cost: MEDIUM.**

### 14.4 R0-D1 wrong

- What went wrong: an incident or DEC-07 F2/F3 required documented
  delegation, which R0-D1 had said would never exist.
- What to undo: cultural walkback of the "permanent default" precedent
  plus a new decision to open a delegation model.
- Artifacts changed: R0-D1 record; DEC-02 reopening; possibly related
  governance-precedent references.
- Governance: cultural debt around the "permanent default" pattern.

**Recovery cost: MEDIUM (technical LOW, cultural HIGH).**

---

## 15. Worst-Case Analysis

Per §18.

- **R0-D0 worst case**: trigger fires and Owner does not react;
  ambiguity accumulates without documented governance. Recovery: open
  DEC-02 with R1. Nothing irreversible.
- **R1+K-A worst case**: entries drift stale; reviewer discipline
  fails; the convention artifact becomes an orphan. Recovery: revert
  entries; declare R0-D0 retroactively. Nothing irreversible.
- **R1+K-B worst case**: skill-shaped entries proliferate; skill-target
  reasoning becomes ingrained; a future decision struggles to unwind
  the concept. Recovery: MED; cultural walkback plus schema evolution.
- **R0-D1 worst case**: cultural lock-in around "permanent default";
  future reopening carries organizational drag. Recovery: MED.
- **R1+K-C worst case**: ARCH-007-family retrofit debt after entries
  accumulate. Recovery: MED.
- **R1+K-D worst case**: heterogeneous vocabulary reproduces DEC-01's
  failure mode. Recovery: MED-HIGH; per ARCH-007 precedent, retire and
  re-shape.

**No option produces true irreversibility.** The worst case in every
path is *reversible with effort*, not a permanent commitment.

---

## 16. Best-Case Analysis

Per §19. What actual evidence would need to appear.

- **R0-D0 best case**: no trigger fires; no incident; DEC-07 stays F1
  or defers; the CCP remains at S1. Preconditions: Owner does not scale
  to S2/S3; no third-party contributors; incidents remain zero.
- **R1+K-A best case**: 1–3 real delegation entries authored;
  DEC-07 F2 opens and references K-A entries cleanly; reviewer
  discipline holds. Preconditions: DEC-07 F2 in horizon; Owner uses
  entries at least a few times per month.
- **R1+K-B best case**: same as K-A + a per-skill entry proves
  useful. Preconditions: an actual per-skill authority case emerges.
- **R0-D1 best case**: no delegation ever becomes needed; the CCP
  operates permanently at K3-D-OWNER-DEFAULT. Preconditions: strict
  S1 operation forever.

---

## 17. Adversarial Reversal

Per §20.

- **What would make R0-D0 more rational than R1+K-A?**
  - Owner declares no S2/S3 scaling in the 12-month horizon.
  - Owner declares DEC-07 will stay F1 for the horizon.
  - Owner assigns no bandwidth to authoring delegation entries in the
    near term.
  - Owner values pure optionality over documented governance.

- **What would make R1+K-B more rational than R1+K-A?**
  - Owner declares intent to author ≥2 skill-shaped delegation entries.
  - A subagent authorization scoped to a specific skill invocation
    (not a full role) becomes desired.
  - The audit chain's ground-truth finding on skills is disputed with
    new evidence (unlikely).

- **What would make R1+K-D more rational than R1+K-A?**
  - Owner accepts the ARCH-007 heterogeneity risk consciously in
    exchange for a familiar taxonomy.
  - (No architectural reason surfaces.)

- **What would make CAPABILITY warrant reopening?**
  - Any of the triggers in §21.

---

## 18. CAPABILITY Long-Horizon Test

Per §21. **No reopening. Define observable threshold.**

**CAPABILITY REENTRY THRESHOLD**:

- **T-CAP-1**: two or more real delegation entries share a stable role
  across an implementation change (e.g., swapping the code-reviewer
  agent from V1 to V2) and the swap requires editing both entries.
- **T-CAP-2**: bulk-edit pattern: an implementation replacement forces
  edits across ≥3 entries in a single change.
- **T-CAP-3**: DEC-07 F2/F3 or DEC-REVIEWER-VERDICT concretely requires
  implementation-independent identity that MODEL-A cannot express in
  scope prose.
- **T-CAP-4**: an existing canonical CCP artifact begins referring to
  "capability" as a first-class object.
- **T-CAP-5**: PRIM excavation (or an equivalent independent audit)
  identifies CAPABILITY as a latent primitive.

Observability: T-CAP-1..3 are trigger events observable in git history.
T-CAP-4..5 are observable via canonical registry inspection.

If **any** trigger fires, CAPABILITY becomes reopening-eligible under a
future gate — not under DEC-02.

**Confidence** that no trigger fires in the 6-month horizon:
`MODERATE-HIGH` (65%). Driver: current CCP has no observed
implementation-churn pattern requiring capability abstraction.

---

## 19. Downstream Decision Impact

Per §22. Coupling classification:

| Downstream | R0-D0 | R0-D1 | R1+K-A | R1+K-B |
|---|---|---|---|---|
| DEC-07 F1 | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT |
| DEC-07 F2/F3 | INDIRECT (falls back to implicit) | INDIRECT | SOFT-INFORMING | SOFT-INFORMING |
| DEC-07 F4 | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT |
| DEC-04 D-CANONICAL | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT |
| DEC-05 D-MOTOR | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT |
| DEC-08 D-INSTR | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT |
| DEC-REVIEWER-VERDICT | INDIRECT | INDIRECT | SOFT-INFORMING | SOFT-INFORMING |
| DEC-STREAM-CONSUMER | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT |
| ARCH-005 | Uses ARCH-005 pattern (for R0-D0) | INDEPENDENT | INDEPENDENT | INDEPENDENT |
| ARCH-006 | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT (VOCAB-A used, not modified) |
| ARCH-007 | INDEPENDENT | INDEPENDENT | INDEPENDENT | INDEPENDENT (avoids the pattern) |

Shadow-risk flags:

- **R1+K-C** (dropped from primary frontier): SHADOW-RISK on ARCH-007
  precedent.
- **R1+K-D**: SHADOW-RISK on ARCH-007 precedent (STRONG family).
- **CAPABILITY** (if adopted): SHADOW-RISK on ARCH-006 (pressure to
  extend VOCAB-A) and on DEC-07/DEC-REVIEWER-VERDICT scoping.

None of the frontier options (R0-D0, R1+K-A, R1+K-B) carries shadow
risk to any downstream.

---

## 20. Owner Authority Test

Per §23.

- **What the evidence suggests**: R0-D0 and R1+K-A are the two
  defensible paths; both LOW/LOW-MED regret; both HIGH reversibility.
  Neither is dominated by the other.
- **What the Owner may prefer**: depends on §26 profile.
- **What the Owner must choose**: R (representation). If R = R1, also
  K.
- **What the Owner may defer**: V, Q, P (all `MAY DEFER` per §9).
  Also: CAPABILITY (deferred by triggers §18).

---

## 21. Technical Recommendation

Given current evidence, the path with the strongest evidence /
optionality / reversibility profile is **not unique**: it is the
**frontier of R0-D0 and R1+K-A**, with the choice between them
preference-driven.

**Provisional technical default (if a single answer is demanded)**:
**R1 + K-A with V/Q/P deferred**. Reason: it makes movement, gains
information via the first authored entry, and preserves optionality
via HIGH reversibility. But this is not dominant over R0-D0; it merely
edges ahead on `information gain` at the cost of `discipline load`.

**What would change this recommendation**:

- Owner declares no S2/S3 scaling in the 12-month horizon → R0-D0
  becomes preferred.
- Owner declares DEC-07 F2/F3 in the 3-month horizon → R1+K-A becomes
  strongly preferred.
- Owner is willing to run EXP-DEC02-SEM (draft one entry) before
  choosing → run the experiment; the draft will resolve residual
  ambiguity.

**This is a technical recommendation, not an Owner Choice.**

---

## 22. Recommended Default Package

```
R = R1  (docs-only)
K = K-A (ACTOR-ARTIFACT / MODEL-A)
V = DEFER  (V/Q/P not required in this gate)
Q = DEFER
P = DEFER

TECHNICAL DEFAULT ≠ OWNER DECISION
```

Alternative defensible package:

```
R = R0-D0 (DEFER with ARCH-005 triggers)
K = N/A
V = N/A
Q = N/A
P = N/A

Triggers to declare on the R0-D0 entry:
  T-1: DEC-07 F2/F3 opens
  T-2: First delegation incident recorded in INCIDENT_REGISTRY
  T-3: Owner declares S2/S3 scaling
```

---

## 23. Owner Profile Simulation

Per §26.

- **Owner A — maximizes simplicity**. Would pick **R0-D0** (defer with
  triggers). Rationale: no discipline load; explicit reopening path;
  cheapest today.
- **Owner B — maximizes future optionality**. Would pick **R1 + K-A**
  with V/Q/P deferred. Rationale: gets a governance anchor in place
  without over-committing V/Q/P; DEC-07 F2/F3 has an anchor if it
  opens.
- **Owner C — maximizes immediate governance clarity**. Would pick
  **R1 + K-A** with V and Q also decided (V1 open-bounded + Q2 in-
  entry predicate). Rationale: full commitment to a documented pattern;
  reviewer discipline established with a clear vocabulary and
  revocation semantics.

**Reading**: preference dominates. The evidence does not force a
choice.

---

## 24. Decision Sensitivity

Per §27.

**High-sensitivity variables** (small change flips preference):

1. **DEC-07 F2/F3 horizon**. Imminent → R1+K-A gains value sharply.
   Not in horizon → R0-D0 gains value.
2. **Owner scaling intent (S1/S2/S3)**. S1 forever → R0-D1 becomes
   viable; S2/S3 imminent → R1 becomes strongly preferred.
3. **Owner tolerance for discipline load**. Low → R0-D0; high → R1.
4. **First authored entry outcome (if S-γ/S-δ pursued)**. If drafting
   an entry reveals K-A gaps → K-B climbs.
5. **Presence of a delegation incident**. Any incident → R0-D0 no
   longer viable; R1 required.

**Low-sensitivity variables**:

1. **Number of skills currently authored (~23)**. Number is stable;
   changing it does not shift the target-model choice.
2. **AUTHORITY_KIND vocab**. Closed under ARCH-006; no expected change.
3. **ARCH-007 precedent applicability**. STRONG analogy already
   factored in; further evidence for the analogy does not shift.

---

## 25. Reopening Triggers

Per §28. Consolidated with observable predicates.

- **R0 → R1**: (a) delegation incident recorded in INCIDENT_REGISTRY;
  (b) DEC-07 F2/F3 opens; (c) Owner declares S2/S3 scaling with
  named contributor.
- **K-A → K-B**: Owner authors an entry whose scope declares per-skill
  invocation authority for a specific skill, and the entry-prose
  scope is materially less legible than a `type: skill` entry would be.
- **K-A → CAPABILITY**: any of §18 T-CAP-1..5 triggers fires.
- **K-A → K3**: an evidence-grounded target shape not covered by
  K-A/K-B/K-C/K-D emerges (e.g., an artifact of a new class becomes a
  delegation target).
- **CAPABILITY reentry**: T-CAP-1..5 per §18.

Each trigger is observable via git history, registry inspection, or
Owner declaration. No introspective or preference-based triggers.

---

## 26. Final Owner Card

```
DEC-02 OWNER DECISION

PRIMARY QUESTION:
Should CCP make its implicit delegation pattern explicit as a
convención governance object now, or defer under ARCH-005 with
observable triggers?

TECHNICAL DEFAULT:
R = R1, K = K-A (ACTOR-ARTIFACT / MODEL-A), V/Q/P = DEFER.

ALTERNATIVE PATH:
R = R0-D0 with declared triggers (DEC-07 F2/F3 opens, incident
recorded, S2/S3 declared). No K/V/Q/P.

WHY:
Both paths are frontier: LOW / LOW-MED expected regret, HIGH
reversibility. R1+K-A gains information (first entry pilot);
R0-D0 preserves pure optionality. Choice depends on Owner
priorities (§23 profiles).

MAIN RISK (R1+K-A):
Convention artifact drifts stale if no entries are authored.
Reviewer discipline load created without immediate use case.

MAIN RISK (R0-D0):
Trigger fires and Owner is slow to react, causing an interval
of undocumented governance.

MAIN LOCK-IN:
None material. All frontier paths are HIGH reversibility.

WHAT CAN BE DEFERRED:
V, Q, P (all MAY DEFER regardless of R/K choice).

WHAT MUST NOT BE DECIDED:
CAPABILITY layer, `compound`, `stable_role`, `authorized_invoker`,
runtime enforcement, AUTHORITY_KIND modification, DEC-01
resurrection, DEC-07 opening, any DEC-04/05/03/08 content.

REVERSAL PATH:
- R1+K-A → R0: `git revert` gate document; discontinue entries.
- R0-D0 → R1: reopen DEC-02 gate; author entries.
Both are single-session operations.

REOPEN TRIGGERS:
- Delegation incident recorded.
- DEC-07 F2/F3 opens.
- Owner declares S2/S3 scaling.
- CAPABILITY threshold T-CAP-1..5 fires (§18).
- Skill-shaped per-skill entry becomes materially useful (K-B trigger).
```

---

## 27. Audit-Chain Integrity Check

Per §31.

1. **Did any unsupported claim survive?** No. `compound`, `stable_role`,
   `authorized_invoker`, capability-as-current-object have all been
   moved to `PROPOSED / DEFERRED` and not smuggled back.
2. **Did any old assumption silently become fact?** No. The
   "5-of-11 = default-covered" claim was corrected from "Owner
   actions" wording in the reconciliation to precise phrasing in the
   ground-truth audit and carried through to this document unchanged.
3. **Did any option disappear without evidence?** CAPABILITY was
   deferred, not deleted; K-B, K-C, K-D remain on the Owner surface;
   R0-D1 remains available. No option silently dropped.
4. **Did any new field appear?** No. This document proposes no new
   fields for MODEL-A. Everything is either §22 default or §11
   deferral.
5. **Did any future abstraction become current?** No. Every future
   trigger is observable and gated (§25).
6. **Did we accidentally decide for Owner?** No. §21 explicitly
   provides both frontier paths and states the Owner-preference
   sensitivity in §23.

**Audit-chain integrity: `INTACT`.**

---

## 28. Final Readiness

```
DEC-02 SUPER DECISION READINESS
-------------------------------

SEMANTIC MODEL:
MODEL-A (ACTOR-ONLY), 7 fields, DERIVED from ground-truth §15.
Confidence HIGH (85%). No smuggled fields.

R DECISION:
FRONTIER — R0-D0 and R1 both defensible; R0-D1 dominated on regret.
Owner-preference-sensitive.

K DECISION:
Conditional on R = R1. Frontier — K-A preferred technical default;
K-B `PLAUSIBLE` if per-skill authorization emerges as Owner intent;
K-C temporary-viable; K-D dominated by ARCH-007-family risk.

V:
DEFER (§9). Downstream of K choice and first authored entry.

Q:
DEFER (§9). No live revocation to trigger the choice.

P:
DEFER (§9). First entry is a de-facto pilot regardless.

TECHNICAL DEFAULT:
R = R1, K = K-A, V/Q/P = DEFER. Alternative defensible package:
R = R0-D0 with declared triggers.

OWNER CHOICE:
PENDING.

TECHNICAL RECOMMENDATION:
The frontier is {R0-D0, R1+K-A}, not a single dominant path. The
provisional technical default is R1+K-A when a single answer is
demanded; this reflects a slight preference for information gain
over pure optionality. R0-D0 is equally defensible and preferred
under an Owner priority of pure optionality or simplicity.
Neither locks in significantly; both are HIGH-reversibility.

MAIN UNCERTAINTY:
Owner scaling horizon (S1/S2/S3) and DEC-07 F2/F3 timing.
Neither is resolvable from CCP evidence; both are Owner-knowable.
Deciding either uncertainty reshapes the R/K choice materially.

MAIN REVERSAL PATH:
Either frontier path reverses in a single session via git revert of
the gate document. R1+K-A entries (if authored) can be discontinued
without downstream damage. R0-D0 can be reopened by a new gate
whenever a trigger fires.

MAIN REOPEN TRIGGER:
Any of: (a) delegation incident recorded in INCIDENT_REGISTRY;
(b) DEC-07 F2/F3 opens; (c) Owner declares S2/S3 scaling; (d)
CAPABILITY threshold T-CAP-1..5 (§18) fires; (e) skill-shaped
per-skill entry becomes materially useful.

CANONICAL CHANGE:
NONE.

RUNTIME AUTHORIZATION:
NONE.

DEC-02:
READY FOR OWNER CHOICE.
```

---

## 29. Non-Modification Attestation

This analysis did not modify:

- The four prior audit-chain artifacts (preserved verbatim).
- `AUTHORITY_KIND.md`, `DECISION_REGISTRY.md`, `DECISION_HISTORY.md`,
  `EVIDENCE_REGISTRY.md`.
- `DEC-02_D-DELEG_DECISION_GATE_REVISED.md`, `DEC-02_D-DELEG_OPENED.md`.
- `MASTER_HANDOFF.md`, `DECISION_SPACE_PREPARED.md`.
- `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md`.
- `.claude/*` (any subtree).

`Stratum-C`, non-canonical. Persistence at Owner discretion.

**END — DEC-02 SUPER OWNER DECISION ANALYSIS — awaiting Owner Choice.**
