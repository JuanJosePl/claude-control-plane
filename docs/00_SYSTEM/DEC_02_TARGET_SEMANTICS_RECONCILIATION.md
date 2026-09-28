# DEC-02 TARGET SEMANTICS RECONCILIATION

```text
AUDIT_ID           : DEC-02-TARGET-SEMANTICS-RECONCILIATION
DECISION_UNDER_TEST: DEC-02 D-DELEG (target unit of a delegation entry)
STATUS             : COMPLETE (meta-analytical) · NON-CANONICAL · OWNER-INFORMING
CANONICAL          : NO (Stratum-C reconciliation artifact)
OWNER_CHOICE       : NOT MADE
IMPLEMENTATION_AUTH: NONE
CHECKPOINT         : NONE
SOURCE_HEAD        : e529359
BASELINES          : DEC_02_TARGET_SEMANTICS_AUDIT.md (prior audit, under attack)
                     DEC-02_D-DELEG_DECISION_GATE_REVISED.md
                     DEC-02_D-DELEG_OPENED.md
                     AUTHORITY_KIND.md (ARCH-006)
                     DECISION_REGISTRY.md
                     EVIDENCE_REGISTRY.md
                     PIECE_AND_IDEA_PUZZLE_AUDIT.md
                     DECISION_SPACE_PREPARED.md
                     MASTER_HANDOFF.md
PRIOR_AUDIT_ARTIFACT: docs/00_SYSTEM/DEC_02_TARGET_SEMANTICS_AUDIT.md
                     (preserved verbatim; NOT deleted; NOT overwritten)
DATE               : 2026-09-28
AUTHOR             : Claude Opus 4.7 (adversarial meta-auditor)
```

> **Purpose**. Adversarially audit the prior document
> `DEC_02_TARGET_SEMANTICS_AUDIT.md`. Determine which of its claims are
> directly demonstrated by CCP evidence, which are inferences the author
> smuggled in as facts, and which are new design proposals dressed as
> conclusions. Reconcile the surviving model with the DEC-02 revised gate so
> the Owner is not asked to choose among options that still contain invented
> abstractions.
>
> **Rules** (from meta-audit §21): no closing DEC-02; no runtime authorization;
> no CAPABILITY registry; no new ontology without evidence; absence ≠
> automatic refutation; no compound-as-patch without evidence; no calling
> harness runtime types "agents" without proof; no modification of Owner
> decision surface without stating exactly what changed; no deletion of prior
> audit.
>
> **Epistemic tags**: `VERIFIED` · `DOCUMENTED` · `INFERENCE` · `HYPOTHESIS` ·
> `PROPOSED` · `UNKNOWN`. Confidence bands: `INSUFFICIENT <60%` ·
> `MODERATE 60–79%` · `HIGH 80–89%` · `VERY HIGH 90–100%`.

---

## 1. Reconciliation Objective

Answer, with adversarial rigor rather than deference to the prior audit:

> Is the prior audit's conclusion `H3-SPLIT = preferred-by-evidence`
> genuinely demonstrated, or did the prior audit introduce a mini-architecture
> inside H3-SPLIT (`type`, `compound`, `stable_role`, `authorized_invoker`)
> that has no more evidence base than the CAPABILITY it rejected?

Downstream: reconcile whatever survives with the revised gate so the Owner
choice is clean.

---

## 2. Source Audit Being Challenged

`docs/00_SYSTEM/DEC_02_TARGET_SEMANTICS_AUDIT.md` (2026-09-28, 1,445 lines).

The prior audit's headline claims:

- **P-C1**. `CAPABILITY (H4) is NOT SUPPORTED BY EVIDENCE`.
- **P-C2**. `HYBRID (H5) collapses to H3 under evidence`.
- **P-C3**. `H1 AGENT alone is INCOMPLETE`. `H2 SKILL alone is INCOMPLETE`.
- **P-C4**. `H3-FLAT (current K2) reproduces the ARCH-007 D-CATALOG
  anti-pattern`.
- **P-C5**. `H3-SPLIT is PREFERRED-BY-EVIDENCE among R1 options`.
- **P-C6**. `DEC-02 READINESS = READY_FOR_OWNER_CHOICE`.
- **P-C7**. The audit **introduces** four new schema components inside
  H3-SPLIT: (a) `type: agent | skill | compound` field; (b) `compound`
  target type; (c) optional `stable_role` label; (d) optional
  `authorized_invoker` field.

Each of these seven claims is now under attack.

---

## 3. Claims That Survive

### 3.1 P-C1 (partially) — CAPABILITY is not a first-class primitive in CCP

**Survives with scope narrowed.** What is genuinely established:

- The string `capability/capabilities` is absent from `AUTHORITY_KIND.md`,
  `DECISION_REGISTRY.md`, `EVIDENCE_REGISTRY.md` `[VERIFIED]`.
- PRIM excavation in `PIECE_AND_IDEA_PUZZLE_AUDIT.md §11` enumerated
  PRIM-1..PRIM-7 and CAPABILITY was not among them, despite the excavation
  being explicitly a *primitive-discovery* pass `[VERIFIED]`.
- CAPABILITY appears in the corpus only as the grammar output `CONTROLLED
  CAPABILITY` in `PIECE_AND_IDEA_PUZZLE_AUDIT.md §13` `[VERIFIED]`.

But see §6 for the classification correction: the prior audit slid from these
facts to a stronger claim ("not supported by evidence") that the facts do not
support.

Confidence: `VERY HIGH` for the narrow claim (not first-class).
Confidence: `HIGH` for the corrected classification (§6).

### 3.2 P-C4 (partially) — K2 mixes two artifact spaces

**Survives, with the analogy weakened.** The observable fact:

- `.claude/agents/*.md` (5 files) and `.claude/skills/*/SKILL.md` (~23
  directories) are two disjoint artifact spaces with different natures
  `[VERIFIED]`.
- K2 as written flattens both into a single `path` field with no type label
  `[VERIFIED]` — this is the actual defect.

See §13 for the ARCH-007 analogy audit: the analogy is weaker than the prior
audit claimed.

Confidence: `HIGH` for the flattening defect; `MODERATE` for the ARCH-007
precedent strength (§13).

### 3.3 The dimensional structure of R × K × V × Q × P (from the revised gate)

**Survives unchanged.** This is the revised gate's own structure and was not
invented by the prior audit. Reconciliation uses it directly (§17).

### 3.4 The six-sense semantic model of "delegation"

**Survives unchanged.** From revised gate §4. The prior audit did not modify
it, and the meta-audit does not disturb it.

---

## 4. Claims That Must Be Downgraded

### 4.1 P-C1 — "CAPABILITY refuted / not supported by evidence"

**Downgrade.** See §6. The prior audit's wording was epistemically imprecise
and conflated *absence of materialization* with *refutation*.

### 4.2 P-C4 — "K2 reproduces the ARCH-007 anti-pattern"

**Downgrade.** See §13. ARCH-007 was heterogeneous *vocabulary* (multiple
linguistic categories inside one label); K2 is heterogeneous *artifact space*
(two distinct directory trees under one path field). Related family of
defect, not the same defect. Classification: STRONG ANALOGY, not DIRECT
PRECEDENT.

### 4.3 P-C5 — "H3-SPLIT is PREFERRED-BY-EVIDENCE"

**Downgrade sharply.** H3-SPLIT as the prior audit defined it is not a
neutral evidence-anchored construct; it is a proposed design containing
components that are themselves not evidence-anchored (§7–§10). See §12 for
the corrected classification of this recommendation: it is an
`ARCHITECTURAL INFERENCE` at best, not a `DIRECTLY DEMONSTRATED`
conclusion.

### 4.4 P-C6 — "READY_FOR_OWNER_CHOICE"

**Downgrade to `READY WITH RECONCILIATION`.** See §18. The prior audit's
option surface (7 options mixing R/K/hypothesis levels) is not clean and
contains proposals labeled as analysis. Reconciliation is required before
Owner reads.

### 4.5 P-C3 — "H1 alone / H2 alone are INCOMPLETE"

**Downgrade — this may be wrong.** The prior audit assumed the 11-item
ACTION_TYPE inventory (revised gate §6.1) is all real delegations needing
target coverage. That assumption is not audited. See §14: five of the eleven
items may not be delegations at all. If they are not, **H1 AGENT alone may
actually be sufficient**, and the prior audit's rejection of H1 as
"incomplete" is a category error.

---

## 5. Claims That Fail

### 5.1 P-C7(b) — `compound` as a target type

**FAILS.** No evidence in the CCP corpus supports `compound` as a
target-type category. The single motivating example (`evidence-registration`
crossing skill + hook) can be modeled as *two* delegation entries or as a
workflow-level artifact, without inventing a compound target type. See §8.

### 5.2 P-C7(c) — `stable_role` label

**FAILS.** `stable_role` appears nowhere in the CCP. It was introduced by
the prior audit in §12 (substitution test) and §22 (experiment). It is a
new construct rather than an observed or derived object. See §9.

### 5.3 P-C7(d) — `authorized_invoker` field

**FAILS conditionally.** This field was introduced specifically to make the
SKILL half of H3-SPLIT work — a repair to fit a target type that may not
belong in the model at all (§14). If skills are removed from the delegation
target space, `authorized_invoker` is unnecessary. See §10.

### 5.4 Harness-runtime types being modeled as `type: agent`

**FAILS.** The prior audit's proposal to represent `fork`, `Explore`, `Plan`
under `type: agent` with `ref: <harness-runtime-name>` collapses a distinct
category (harness primitive) into an artifact category (agent file) purely
to close the model. Unsupported. See §11.

---

## 6. CAPABILITY Reclassification

The prior audit repeatedly used phrases equivalent to "CAPABILITY is refuted"
or "not supported by evidence" and assigned `HIGH` confidence. Applying the
distinction the meta-audit demands:

| Category | Definition | Apply to CAPABILITY? |
|---|---|---|
| NOT PRESENT | Object does not exist as first-class primitive in the corpus | **YES** `[VERIFIED]` |
| NOT OBSERVED | No direct observation available | **YES** `[VERIFIED]` |
| NOT EXPLICIT | May be implicitly used but never named | Partially — appears once as grammar output `CONTROLLED CAPABILITY` |
| NOT SUPPORTED BY EVIDENCE | Evidence base is empty for or against | **YES** (correct scope) |
| CONTRADICTED | Positive evidence against | **NO** — nothing in the corpus contradicts the possibility of a capability layer emerging |
| REFUTED | Definitively falsified | **NO** — absence ≠ falsification |

**Corrected classification**:

> **CAPABILITY = `NOT PRESENT` as a first-class primitive; `NOT SUPPORTED BY
> EVIDENCE` for materialization now; NOT `REFUTED`; NOT `CONTRADICTED`. Its
> promotion would be premature given the absence of a demonstrable need. It
> remains `SPECULATIVE`.**

Confidence: `HIGH` (85%). Basis: grep confirms non-presence; PRIM excavation
confirms non-latency; absence of contradictory evidence prevents stronger
verdict.

**Consequence for the Owner surface**: CAPABILITY is not off the table
forever. It is off the table *until a materialization trigger fires*. See
§19 for the trigger set.

---

## 7. H3-SPLIT Component Audit

The prior audit's H3-SPLIT proposal has four schema components. Audit each
against corpus evidence.

### 7.1 `type: agent | skill`

**Classification: `DERIVED` (evidence-grounded from directory structure).**

- `.claude/agents/` and `.claude/skills/` are two observed directories with
  different frontmatter conventions `[VERIFIED]`.
- The CCP does not call these "types" anywhere in canonical registries. The
  word "type" applied to them is the auditor's derivation from directory
  structure.
- The derivation is legitimate (the CCP files agents and skills separately;
  the two spaces have different content shapes) but it is a *derivation*, not
  an *observation*.

Verdict: keeping the `type` distinction is defensible as a `DERIVED`
concept.

### 7.2 `type: compound`

**Classification: `PROPOSED` — no corpus evidence.**

Fails the audit. See §8.

### 7.3 `stable_role` label

**Classification: `PROPOSED` — no corpus evidence.**

Fails the audit. See §9.

### 7.4 `authorized_invoker` field

**Classification: `PROPOSED` (repair to make SKILL fit).**

Conditionally fails. See §10.

### 7.5 Summary of H3-SPLIT component status

| Component | Prior audit's placement | Correct classification | Keep in current model? |
|---|---|---|---|
| `type: agent \| skill` | central | `DERIVED` | YES (minimal, evidence-grounded) |
| `type: compound` | central | `PROPOSED` (no evidence) | NO — defer as FUTURE OPTION |
| `stable_role` | optional | `PROPOSED` (new construct) | NO — defer as FUTURE OPTION |
| `authorized_invoker` | optional | `PROPOSED` (repair) | NO under corrected model (§14) |

**Corollary**: **H3-SPLIT stripped of unsupported components reduces to a
minimum change of `add explicit type label to K2`**. That is a
one-line schema evolution, not a mini-architecture.

---

## 8. `compound` Audit

The prior audit motivated `type: compound` with the single example of
`evidence-registration` — a workflow that touches skill + hook.

### 8.1 Is `compound` observed?

- `[VERIFIED]` `.claude/skills/evidence/` exists as a skill.
- `[VERIFIED]` `.claude/hooks/*` contain the gate hook (`evidence-gate.sh` or
  equivalent).
- `[VERIFIED]` No CCP artifact packages "the two together as a single
  compound object". The workflow is emergent from independent artifacts, not
  represented as one.

Classification: **`compound` is `PROPOSED`, `NOT OBSERVED`, `NOT DERIVED`.**

### 8.2 Alternatives that do not invent `compound`

- **Multiple delegation entries.** `evidence-registration` decomposes into
  (a) a skill delegation "invoker may run `/evidence`" and (b) a mechanical
  hook (not a delegation — hooks are `mecánica` not `agente`). Actually most
  of the "compound" is the hook side, which is not a delegation subject at
  all.
- **Workflow-level artifact** (future decision, not DEC-02).
- **Composition as a relation, not a target.** A delegation entry can carry
  a `related_entries: [ID1, ID2]` field for workflows spanning multiple
  entries — but that is `PROPOSED`, and DEC-02 does not need to decide it.
- **Defer.** The single motivating example does not force the model.
- **UNKNOWN.** Leave the case explicitly unmodeled rather than papering
  over.

### 8.3 Verdict

**Remove `compound` from the current model.** If a real compound need
emerges, revisit under a future gate.

---

## 9. `stable_role` Audit

### 9.1 Is `stable_role` observed?

- `[VERIFIED]` grep across `docs/00_SYSTEM/*.md` for "stable_role" returns
  hits only inside `DEC_02_TARGET_SEMANTICS_AUDIT.md` — i.e., the prior
  audit *introduces* the concept.
- No canonical artifact uses "stable_role", "semantic role", or an
  equivalent phrase for a delegation-entry field.

Classification: **`stable_role` is `PROPOSED` by the prior audit.**

### 9.2 Does it belong in DEC-02?

The substitution intuition it serves (Case A/B in prior audit §12) is real —
an agent can be renamed while its role continues. But:

- The substitution problem has **not been observed** in CCP practice
  `[VERIFIED via INCIDENT_REGISTRY = 0 delegation incidents]`.
- Adding `stable_role` now is preemptive design for a symptom that hasn't
  manifested.
- If it becomes needed, it can be added by an entry-schema evolution
  (reversible).

### 9.3 Does it invade future decisions?

Yes — a "semantic role" concept blurs the boundary with DEC-07
D-VERIFICADOR (which reasons about roles) and with DEC-REVIEWER-VERDICT.
Introducing it here would preempt those decisions.

### 9.4 Verdict

**Remove `stable_role` from the current model. Move to FUTURE OPTION** —
triggered by "multiple delegation entries need to survive coordinated
agent renames".

---

## 10. `authorized_invoker` Audit

### 10.1 Origin

Introduced in the prior audit specifically to give skill-shaped entries an
authority anchor, because AUTHORITY_KIND has `agente` but no `skill` class.

### 10.2 Classification

**Native, derived, proposed, or unnecessary?**

- If SKILL is a legitimate delegation target: `authorized_invoker` is
  **`DERIVED`** — the authority anchor is not native to a skill artifact so
  the entry must carry it.
- If SKILL is not a legitimate delegation target (see §14): `authorized_
  invoker` is **`UNNECESSARY`** — it repairs a shape that shouldn't exist.

The classification therefore hinges on §14.

### 10.3 Verdict

**Conditional.** Retire `authorized_invoker` if the corrected model in §14
holds (skills as scope-descriptors, not targets). If a future gate keeps
skill-shaped targets, revisit.

---

## 11. Harness Runtime Audit

The prior audit proposed modeling harness-runtime types (`fork`,
`general-purpose`, `Explore`, `Plan`, `claude`, `claude-code-guide`,
`statusline-setup`) as `type: agent` with `ref: <runtime-name>`.

### 11.1 Distinction

| Category | Definition | Observable evidence |
|---|---|---|
| AGENT ARTIFACT | File under `.claude/agents/*.md` | 5 present `[VERIFIED]` |
| RUNTIME ACTOR | Instance dispatched at runtime with declared tool inventory | 12 total per revised gate §3.1 |
| HARNESS PRIMITIVE | Runtime type provided by harness with no artifact backing | 7 present `[VERIFIED]` — the ones listed above |
| IMPLEMENTATION | Concrete code running behind an actor | Fully harness-managed |

The prior audit conflates AGENT ARTIFACT with HARNESS PRIMITIVE by
proposing they share the same `type: agent` bucket.

### 11.2 Consequences of the conflation

- Loses a documented gap. Harness primitives have no file to reference, no
  git history for their content, no reviewer-writable tool declarations.
- Weakens the audit's own critique of K2 (K2 was faulted for flattening two
  categories; the prior audit's fix flattens another two).

### 11.3 Verdict

**UNSUPPORTED.** Correct treatment: harness primitives are `UNKNOWN`
residuals at the artifact-reference layer. A delegation entry that would
name a harness primitive should say so explicitly (`ref_kind:
harness-primitive`, `artifact: NONE`) rather than pretending it is an
agent artifact.

If the Owner wants harness primitives inside the model, that is a distinct
decision, not something to smuggle into DEC-02.

---

## 12. Semantic Object vs Reference vs Implementation

Master prompt §7 requires clean separation of:

- **SEMANTIC OBJECT** — what the target *is*
- **IDENTITY** — how it stays the same across changes
- **ADDRESS / REFERENCE** — how you locate it
- **IMPLEMENTATION** — the concrete runnable thing

### 12.1 Prior audit's implicit answers

- Semantic object = artifact
- Identity = artifact path
- Reference = same
- Implementation = same

This collapses three layers into one — which is precisely the confusion
`ARTIFACT-REFERENCE` as a "semantic answer" hides.

### 12.2 Corrected layered view

For the AGENT case:

- SEMANTIC OBJECT = the *actor* (a role like "code-reviewer") — an ontological
  entity, not the same as its file
- IDENTITY = the actor's name (which the file *addresses*)
- REFERENCE = the artifact path (`.claude/agents/code-reviewer.md`)
- IMPLEMENTATION = the harness-loaded runtime instance

For the SKILL case, the layered view is different:

- SEMANTIC OBJECT = **not the skill; the skill is a *procedure*, not a
  target**. What is being delegated (if anything) is an *invoker's authority
  to invoke the skill*.
- IDENTITY = the invoker (an actor) — not the skill
- REFERENCE = the invoker's artifact + the skill artifact (two references)
- IMPLEMENTATION = the invocation event at runtime

This layered view exposes the prior audit's central mistake: **it treated
"ARTIFACT-REFERENCE" as a semantic answer when it is only a reference
answer**. The actual semantic target across both cases turns out to be *the
actor*.

### 12.3 Consequence

The corrected semantic model of a DEC-02 target is:

- The target of a delegation is the **actor** authorized (agent or human).
- The scope of what the actor is authorized to do can reference **operations**
  (agent-responsibilities, skill-invocations, workflows), but these are scope
  contents, not target types.
- The reference layer is the artifact path.

This is closer to H1 AGENT than to H3-SPLIT — with the extension that the
"actor" can also be humana or (via §11 residual) harness-primitive-UNKNOWN.

---

## 13. ARCH-007 Precedent Audit

The prior audit invoked ARCH-007 (DEC-01 D-CATALOG closure) as precedent
against K2-FLAT.

### 13.1 What ARCH-007 actually was

`[VERIFIED via DECISION_REGISTRY]` DEC-01 D-CATALOG proposed a unified
`change_type` vocabulary spanning:

- feat / fix / refactor (VCS-verb category)
- docs / config / infra (subsystem-target category)
- decision / security (semantic-category)

These are **three distinct linguistic taxonomies** collapsed into one
label. ARCH-007 SPLIT+DEFER accepted the split, deferred E1 (type-taxonomy),
retired E2/E3/E4.

### 13.2 What K2 actually is

`[VERIFIED]` K2 has **two artifact spaces** (`.claude/agents/`,
`.claude/skills/`) collapsed into one `path` field. Each space contains
homogeneous items; the heterogeneity is *between the spaces*, not *within a
space*.

### 13.3 Classification

| Analogy strength | Applies to K2? |
|---|---|
| DIRECT PRECEDENT | NO — the mixing is not identical (linguistic categories vs artifact directories) |
| STRONG ANALOGY | YES — both produce a target field whose interpretation depends on inspecting the value |
| WEAK ANALOGY | Also defensible — the two failure modes are related but not the same |
| NOT APPLICABLE | NO — some family resemblance exists |

**Corrected classification: `STRONG ANALOGY` (not `DIRECT PRECEDENT`).**

### 13.4 Consequence

The Owner should be told: K2's flattening resembles the ARCH-007 problem in
family but not in identity. That still argues for a type-labeled fix — just
not with the rhetorical force the prior audit implied.

---

## 14. Minimal Evidence-Grounded Target Model

Compare six candidate models. Only what corpus evidence supports.

### 14.1 The candidates

| Model | Target shape | Corpus support |
|---|---|---|
| MODEL-0 | AGENT ONLY (targets are actors from `.claude/agents/*.md` + humana + harness-UNKNOWN residual). Skills and workflows are *scope contents*, not target types. | HIGH |
| MODEL-1 | SKILL ONLY | LOW (skills are procedures, not actors — see §12) |
| MODEL-2 | AGENT OR SKILL (two target types, one field) | MED — this is H3-FLAT/K2 |
| MODEL-3 | TYPED ARTIFACT-REFERENCE (`type: agent` \| `type: skill`, no `compound`, no `stable_role`, no `authorized_invoker`) | MED — cleaner than MODEL-2 but still treats skills as targets |
| MODEL-4 | SEMANTIC TARGET (actor) + REFERENCE (artifact) + SCOPE (may reference skills/actions) — decoupled | HIGH but more surface area |
| MODEL-5 | CAPABILITY | NOT SUPPORTED (§6) |

### 14.2 Test: does the 11-item ACTION_TYPE inventory (revised gate §6.1) require SKILL as a target type?

The 11 items break down (revised gate §6.1) as:

- **5 agent-responsibilities** (`code-review`, `implementation`,
  `research-external`, `architecture-analysis`, `security-audit`) — each
  maps naturally to a `.claude/agents/*.md` file. Target = actor.
- **5 skill-invocations** (`no-go`, `gate`, `cerrar-fase`, `adr`,
  `incident`) — each is a user-invocable skill. **Who invokes these? The
  Owner (or a human reviewer)** `[INFERENCE from CCP workflow]`. There is
  no evidence in the corpus that anyone *other* than the Owner routinely
  invokes them. They are default Owner actions.
- **1 workflow** (`evidence-registration`) — combines skill invocation with
  hook enforcement. The hook side is `mecánica`, not a delegation subject.
  The skill side is Owner-invoked.

**Reading**: 5 of the 11 items ("skill invocations") are *not real
delegations* — they are default Owner actions that could be documented as
"Owner performs by default". The remaining 6 items reduce to:

- 5 agent-responsibilities → MODEL-0 covers.
- 1 workflow → MODEL-0 covers with a scope note ("scope: invocation of
  `/evidence` + response to gate hook").

**MODEL-0 (AGENT ONLY, with scope) is sufficient for the observed
inventory.** Confidence: `HIGH` (80%). Basis: 11-item decomposition; absence
of counter-examples.

### 14.3 What MODEL-0 looks like

A delegation entry has:

```
delegation_id: <opaque>
delegated_to:  <actor-ref>         # agent artifact path, or "humana:<person>", or UNKNOWN:harness-primitive
scope:         <free-form description of what the actor is authorized to do>
activation:    <predicate>
revocation:    <predicate or "gate-reopening">
provenance:    <git commit + gate reference>
```

No `type` field is strictly required (the actor-ref carries its kind
implicitly via the path prefix). But an explicit `actor_kind: agent |
human | harness-primitive` field makes reviewer reading cheaper and
handles the harness-UNKNOWN residual honestly.

### 14.4 Comparison to prior audit's H3-SPLIT

- H3-SPLIT: 4 schema components (`type` with 3 values, `stable_role`,
  `authorized_invoker`, `ref`) with `compound` and `stable_role` and
  `authorized_invoker` all `PROPOSED`.
- MODEL-0: 1 target field (actor-ref) + optional `actor_kind` label + scope
  as prose.

**MODEL-0 is the minimum evidence-grounded model.**

### 14.5 Confidence

- MODEL-0 sufficient for the observed inventory: `HIGH` (80–85%). Depends on
  the correctness of the "5 skill invocations are Owner-default" reading.
- MODEL-3 as a valid alternative if the Owner *does* want skill-invocation
  authority documented per skill: `MODERATE` (65%).
- MODEL-5 CAPABILITY: `NOT SUPPORTED` unless a re-entry trigger fires (§19).

---

## 15. Deferred / Future Abstractions

Move here everything the prior audit put in the current model without
evidence. None of these are refuted; each is triggered.

| Deferred item | Origin | Reactivation trigger |
|---|---|---|
| `compound` target type | prior audit §22 | 2+ real delegation entries need to reference multiple artifacts *simultaneously* with no cleaner decomposition |
| `stable_role` label | prior audit §12 | Multiple entries need to survive coordinated agent renames with implementation continuity |
| `authorized_invoker` field | prior audit §22 | Owner selects a model where skill-shaped entries are first-class targets |
| CAPABILITY layer | master prompt hypothesis | Any of §19 triggers fires |
| Harness-primitive-as-agent modeling | prior audit §22 | Owner explicitly requests harness primitives inside DEC-02 scope |
| Composition-as-relation field (`related_entries`) | this reconciliation §8.2 | Cross-entry workflow modeling becomes routine |

All are `PROPOSED` today, not `REFUTED`.

---

## 16. DEC-02 Gate Reconciliation

### 16.1 What the revised gate §6 currently says

```
K1  = ACTION_TYPE (with heterogeneity caveat)
K2  = SKILL / AGENT artifact  ← the defective flat form
K3  = evidence-grounded alternative (currently UNKNOWN)
```

### 16.2 What the meta-audit produces

Two levels of change, in priority order.

**Change A (minimal-surgical)** — replace K2's wording so it stops flattening
without introducing new fields:

```
CURRENT:
K2 = SKILL / AGENT artifact

REPLACEMENT (Change A):
K2 = ACTOR-ARTIFACT
     - target field references .claude/agents/*.md OR humana:<person>
     - skill invocations documented separately (scope-of-actor), not as
       target types
     - harness primitives handled as explicit UNKNOWN residual
     - no `compound`, no `stable_role`, no `authorized_invoker` in the
       current model (§15 defers them)
```

**Change B (Owner-optional preservation of skill-shape)** — if the Owner
insists that skill-invocation authority must be documented per skill:

```
REPLACEMENT (Change B):
K2 = TYPED ARTIFACT-REFERENCE
     - target field carries `type: agent | skill`
     - `type: agent` entries use AUTHORITY_KIND `agente` natively
     - `type: skill` entries carry `authorized_invoker`
     - no `compound`, no `stable_role` in the current model
```

**Neither Change reactivates DEC-01 D-CATALOG. Neither introduces runtime
enforcement. Neither modifies AUTHORITY_KIND. Both are reversible.**

### 16.3 Why (evidence)

- MODEL-0 correspondence to Change A: 11-item decomposition (§14.2).
- MODEL-3 correspondence to Change B: two-space observation (§7.1).
- Absence of corpus evidence for `compound` / `stable_role` /
  `authorized_invoker` (as required components): §7–§10.

### 16.4 Minimal schema for Change A

```
delegation_id  : DELEG-<NNN>
delegated_to   :
  actor_kind   : agent | humana | harness-primitive-UNKNOWN
  actor_ref    : <path or identifier>
scope          : <prose>
activation     : <predicate>
revocation     : <predicate | "gate-reopening">
provenance     : { gate: <ID>, head: <sha>, commit: <sha> }
```

### 16.5 Migration

- No canonical migration required. DEC-02 has zero existing delegation
  entries at HEAD `e529359` `[VERIFIED via absence of DELEGATION_REGISTRY.md
  or equivalent]`. The reconciliation is fully forward-only.

### 16.6 Reversibility

- Change A reversible with `git revert` of the gate document.
- Change B reversible identically.
- Neither commits the Owner to Change B if Change A is chosen first.

### 16.7 Owner impact

- Change A: minimum cognitive load; matches observed CCP semantics.
- Change B: slightly more schema surface; useful only if skill-invocation
  authority becomes something the Owner wants to record per skill.

---

## 17. Owner Decision Surface

Reconstructed dimensionally, per meta-audit §10.

```
DEC-02 OWNER QUESTION
─────────────────────
Should the CCP make its implicit delegation pattern explicit as a
documented governance object? If yes, along which axes?

DIMENSION R — Representation
  R0-D0  DEFER with observable trigger (ARCH-005 pattern)   STATUS: OPEN
  R0-D1  RETIRE with RESOLVED_BY                             STATUS: OPEN
  R1     docs-only representation                            STATUS: OPEN
  (runtime enforcement is NOT a DEC-02 option — separate future decision)

DIMENSION K — Target Key       [only if R = R1]
  K-A  ACTOR-ARTIFACT (MODEL-0 / Change A)                  STATUS: OPEN
       — target = actor; skills are scope, not target
       — evidence-anchored to the 11-item decomposition
  K-B  TYPED ARTIFACT-REFERENCE (MODEL-3 / Change B)        STATUS: OPEN
       — target = (type: agent | skill, ref); skills are targets
       — supports skill-per-skill invocation records
  K-C  K2 AS-IS (current wording)                           STATUS: OPEN
       — flattened two-space form; MEDIUM lock-in
  K-D  K1 ACTION_TYPE                                       STATUS: OPEN
       — heterogeneous vocabulary; STRONG analogy to ARCH-007
  K-E  K3 (evidence-grounded alternative)                   STATUS: DEFERRED
       — currently UNKNOWN

DIMENSION V — Vocabulary       [only if R = R1]
  V1  open-bounded with attestation rule                    STATUS: OPEN
  V2  closed-bounded (VOCAB-A-analog)                       STATUS: OPEN
      — precedent lock-in flag: second closed vocab in CCP
  V3  field-local                                           STATUS: OPEN

DIMENSION Q — Revocation       [only if R = R1]
  Q1  new-gate revocation                                   STATUS: OPEN
  Q2  in-entry predicate + procedure                        STATUS: OPEN

DIMENSION P — Rollout          [only if R = R1]
  P0  universal at gate opening                             STATUS: OPEN
  P1  phased pilot with measurement objective (§8.5.1)      STATUS: OPEN

DEFERRED (§15) — not in this gate:
  compound target type
  stable_role label
  authorized_invoker (unless K-B chosen)
  CAPABILITY / HYBRID (see §19 for reopening triggers)
  harness-primitive-as-agent modeling
```

**Owner must decide now**: R.
**Owner must decide if R = R1**: K (from K-A / K-B / K-C / K-D).
**Owner may defer**: V, Q, P (all are downstream of K choice; a Change-A
gate can commit K without committing V/Q/P if the Owner wishes).
**Owner must not decide here**: DEC-07 opening; runtime enforcement;
AUTHORITY_KIND modification; anything in §15 deferrals.

### 17.1 Preferred-by-evidence (technical provisional)

If the Owner chooses R = R1, **K-A (ACTOR-ARTIFACT / MODEL-0)** is
`preferred-by-evidence` — it matches the 11-item decomposition and requires
no proposed fields.

**K-B (MODEL-3)** is defensible if the Owner explicitly wants
skill-per-skill authority records.

**K-C** is the current K2 wording (accept flattening).
**K-D** is K1 with heterogeneity caveat.

This provisional preference is `ARCHITECTURAL INFERENCE`, not
`DIRECTLY DEMONSTRATED`, and it is not an Owner choice.

---

## 18. Readiness Assessment

Objective criteria, per meta-audit §11.

| Criterion | Status |
|---|---|
| Semantic ambiguity resolved (target = actor, per §12) | YES |
| Option surface canonical (dimensional, no hypothesis-level mixing) | YES (§17) |
| No hidden invented abstractions in current model | YES (§15 deferrals separated) |
| Downstream coupling understood (DEC-07 / DEC-REVIEWER-VERDICT / ARCH-006) | YES (from prior audit §25, preserved) |
| Reversible path exists | YES (§16.6) |
| Owner question stable | YES (§17) |
| Gate aligned (K2 reconciled to Change A or B) | REQUIRES ACTION — Owner or reviewer must acknowledge the K2 reconciliation before Owner Choice |

**Verdict**: **`READY WITH RECONCILIATION`**. What must be reconciled before
the Owner reads:

1. **Present the corrected CAPABILITY classification** (§6) — `SPECULATIVE`,
   not `REFUTED`. This affects how the Owner reads Option G in the prior
   audit's surface.
2. **Present the K2 wording change** (§16) — either Change A (K-A) or
   Change B (K-B); do not leave K2 in its flattening form as a "default"
   Owner might silently inherit.
3. **Present the §15 deferrals explicitly** so the Owner is aware that
   `compound`, `stable_role`, `authorized_invoker`, CAPABILITY,
   harness-primitive-modeling are FUTURE OPTIONS, not current fields.
4. **Present the 5-of-11 finding** (§14.2) so the Owner knows that the
   "skill invocation" half of the observed inventory may not be delegations
   at all.

Only (1)–(4) need reconciling. None requires canonical modification.

---

## 19. Falsifiers / Reopening Triggers

For each deferral in §15, define the trigger.

### 19.1 Reopen CAPABILITY (H4)

- **T-H4.1**: two or more delegation entries share a stable semantic
  identity across implementation churn (same responsibility, different
  agents), and the churn produces observable maintenance cost.
- **T-H4.2**: an implementation replacement requires bulk edits across ≥3
  delegation entries in a single change.
- **T-H4.3**: an existing CCP artifact begins representing "capability" as
  a first-class object (registry, schema field, etc.).
- **T-H4.4**: a downstream decision (DEC-07 F2/F3, DEC-REVIEWER-VERDICT)
  concretely requires implementation-independent identity beyond what
  MODEL-0 or MODEL-3 provides.
- **T-H4.5**: `PIECE_AND_IDEA_PUZZLE_AUDIT §11` (or an equivalent excavation)
  independently identifies CAPABILITY as a latent primitive.

### 19.2 Reopen `compound`

- **T-comp.1**: two or more real delegation entries need to name multiple
  artifacts simultaneously without a decomposition into separate entries.
- **T-comp.2**: workflow-level artifacts appear in the CCP that need
  first-class delegation coverage.

### 19.3 Reopen `stable_role`

- **T-role.1**: an agent rename requires editing ≥2 delegation entries in
  a coordinated way.
- **T-role.2**: an Owner-declared naming discipline emerges (independent
  of DEC-02).

### 19.4 Reopen harness-primitive modeling

- **T-harn.1**: an Owner-authored delegation entry needs to reference a
  harness runtime type and the `UNKNOWN` residual becomes operationally
  painful.

### 19.5 K-A → K-B (upgrade)

- **T-K-B.1**: Owner decides skill-invocation authority needs to be
  documented per skill (Owner choice, not a technical trigger).

---

## 20. Final Reconciliation Verdict

```
DEC-02 TARGET MODEL
-------------------
CURRENT EVIDENCE SUPPORTS:
  MODEL-0 (ACTOR-ARTIFACT / Change A) as the minimum evidence-grounded
  target model. MODEL-3 (TYPED ARTIFACT-REFERENCE / Change B) as an
  Owner-optional refinement if skill-per-skill authority is desired.
  Both are R1 options. R0-D0 and R0-D1 remain coherent as Owner choices.

CAPABILITY:
  NOT PRESENT as first-class primitive (VERIFIED).
  NOT REFUTED (absence of evidence ≠ falsification).
  Correct epistemic classification = SPECULATIVE.
  Reopening triggers documented in §19.1.

H3-SPLIT:
  As the prior audit defined it (with `compound`, `stable_role`,
  `authorized_invoker`): NOT SUPPORTED — its components are PROPOSED,
  not observed or derived.
  Stripped of unsupported components: converges to MODEL-3 (Change B).

NEW FIELDS INTRODUCED BY PRIOR AUDIT:
  - `type: agent | skill | compound`
  - `type: compound`  ← unsupported
  - `stable_role`      ← unsupported
  - `authorized_invoker` ← conditional; unnecessary under MODEL-0

FIELDS REQUIRED NOW:
  MODEL-0 (Change A):
    - delegated_to.actor_kind
    - delegated_to.actor_ref
    - scope
    - activation
    - revocation
    - provenance

FIELDS DEFERRED:
  - compound target type
  - stable_role
  - authorized_invoker (unless K-B chosen)
  - harness-primitive-as-agent modeling
  - CAPABILITY layer

OWNER CHOICE:
  READY WITH RECONCILIATION

CANONICAL CHANGE REQUIRED BEFORE OWNER:
  NO. All reconciliations (§17, §18) are analytical/documentary and live
  in this Stratum-C artifact. Canonical registries, AUTHORITY_KIND,
  DECISION_REGISTRY, PROJECT_STATE, MASTER_HANDOFF, DECISION_SPACE_
  PREPARED, and the DEC-02 revised gate remain unmodified.

RUNTIME AUTHORIZATION:
  NONE
```

---

## 21. Evidence References

- **Prior audit under attack** — `docs/00_SYSTEM/DEC_02_TARGET_SEMANTICS_
  AUDIT.md` (preserved, not modified).
- **CAPABILITY corpus absence** — grep across `AUTHORITY_KIND.md`,
  `DECISION_REGISTRY.md`, `EVIDENCE_REGISTRY.md` → 0 hits.
- **PRIM enumeration** — `PIECE_AND_IDEA_PUZZLE_AUDIT.md §11`
  (PRIM-1..PRIM-7; CAPABILITY absent).
- **CONTROLLED CAPABILITY grammar output** — `PIECE_AND_IDEA_PUZZLE_
  AUDIT.md §13`.
- **Two-space observation** — `.claude/agents/` (5 files) and
  `.claude/skills/` (~23 dirs) at HEAD `e529359`.
- **11-item ACTION_TYPE inventory** — `DEC-02_D-DELEG_DECISION_GATE_
  REVISED.md §6.1`.
- **K2 flattening flags** — `DEC-02_D-DELEG_DECISION_GATE_REVISED.md §6.2`.
- **Six-sense delegation model** — `DEC-02_D-DELEG_DECISION_GATE_REVISED.md
  §4`.
- **AUTHORITY_KIND VOCAB-A closed** — `AUTHORITY_KIND.md §3` (ARCH-006).
- **ARCH-007 D-CATALOG lesson** — DECISION_REGISTRY ARCH-007 entry
  (checkpoint `e529359`).
- **ARCH-005 pattern availability** — `DEFERRAL_POLICY.md` (DEC-11
  checkpoint `cd0511c`).
- **INCIDENT_REGISTRY delegation-incident absence** — inspection cited in
  revised gate §12 claim 8.
- **Zero existing DEC-02 delegation entries at HEAD** — no `DELEGATION_
  REGISTRY.md` or equivalent artifact under `docs/00_SYSTEM/`.

---

## 22. Non-Modification Attestation

This reconciliation did not modify:

- `docs/00_SYSTEM/DEC_02_TARGET_SEMANTICS_AUDIT.md` (prior audit preserved
  verbatim).
- `docs/00_SYSTEM/AUTHORITY_KIND.md`.
- `docs/00_SYSTEM/DECISION_REGISTRY.md`.
- `docs/00_SYSTEM/DECISION_HISTORY.md`.
- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
- `docs/00_SYSTEM/DEC-02_D-DELEG_DECISION_GATE_REVISED.md`.
- `docs/00_SYSTEM/DEC-02_D-DELEG_OPENED.md`.
- `docs/00_SYSTEM/MASTER_HANDOFF.md`.
- `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md`.
- `PROJECT_STATE.md`.
- `ARTIFACT_MANIFEST.md`.
- `.claude/*` (any subtree).

This artifact is `Stratum-C, non-canonical`. Its persistence is at Owner
discretion.

**END — DEC-02 TARGET SEMANTICS RECONCILIATION — awaiting Owner Choice on
§17.**
