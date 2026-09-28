# DEC-02 TARGET SEMANTICS AUDIT

```text
AUDIT_ID           : DEC-02-TARGET-SEMANTICS
DECISION_UNDER_TEST: DEC-02 D-DELEG (target unit of a delegation entry)
STATUS             : COMPLETE (analytical) · NON-CANONICAL · OWNER-INFORMING
CANONICAL          : NO (Stratum-C analytical artifact)
OWNER_CHOICE       : NOT MADE (DEC-02 remains OPEN)
IMPLEMENTATION_AUTH: NONE
CHECKPOINT         : NONE
SOURCE_HEAD        : e529359
BASELINES          : PIECE_AND_IDEA_PUZZLE_AUDIT.md, DECISION_SPACE_PREPARED.md,
                     MASTER_HANDOFF.md, DEC-02_D-DELEG_DECISION_GATE_REVISED.md,
                     AUTHORITY_KIND.md (ARCH-006), DECISION_REGISTRY.md,
                     EVIDENCE_REGISTRY.md
DATE               : 2026-09-28
AUTHOR             : Claude Opus 4.7 (adversarial auditor, non-decisor)
```

> **Purpose**. Determine what a DEC-02 delegation entry `target` really *is*, using
> evidence from the CCP itself. Compare the five hypotheses (AGENT, SKILL,
> ARTIFACT-REFERENCE, CAPABILITY, HYBRID) rigorously, without protecting prior
> choices, without importing generic definitions, and without closing DEC-02.
>
> **Rule of the room**: `EVIDENCE > ELEGANCE`. `SEMANTIC TRUTH > IMPLEMENTATION
> CONVENIENCE`. `REVERSIBILITY > PREMATURE COMMITMENT`. `OWNER AUTHORITY >
> ARCHITECTURAL PRESUMPTION`.
>
> **Epistemic tags** (as in prior audits): `[EVIDENCE: VERIFIED]` ·
> `[EVIDENCE: DOCUMENTED]` · `[EVIDENCE: INFERENCE]` · `[EVIDENCE: HYPOTHESIS]` ·
> `[UNKNOWN]`.
>
> **Confidence** (qualitative bands): `<60% INSUFFICIENT` · `60–79% MODERATE` ·
> `80–89% HIGH` · `90–100% VERY HIGH`. Each cited number carries a stated basis;
> unbased numbers are not used.

---

## 1. Executive Finding

- **CAPABILITY does not exist as an object in the CCP corpus.** The string
  "capability/capabilities" appears **0 times** in `AUTHORITY_KIND.md`,
  `DECISION_REGISTRY.md`, and `EVIDENCE_REGISTRY.md` `[EVIDENCE: VERIFIED]`. The
  only place the word occurs in a canonical baseline is inside
  `PIECE_AND_IDEA_PUZZLE_AUDIT.md §13` as the compound noun `CONTROLLED
  CAPABILITY` — a *diagnostic grammar output*, not a first-class primitive. There
  is no `PRIM-CAPABILITY` in the primitive excavation (§11 of the AUDIT
  enumerates PRIM-1..PRIM-7 and CAPABILITY is not among them) `[EVIDENCE:
  VERIFIED]`. **H4 (CAPABILITY) is therefore `SPECULATIVE`, not `LATENT`. Adopting
  it would introduce a new ontology layer without evidence base.**

- **HYBRID (H5) inherits H4's evidence problem.** H5 = CAPABILITY +
  IMPLEMENTATION-REFERENCE. If CAPABILITY is speculative, HYBRID is speculative
  in its "capability half" and collapses in practice to the implementation-half —
  i.e., to ARTIFACT-REFERENCE. **H5 is not a fifth genuine option; it is either
  H4 with a bookkeeping suffix or H3 with rhetorical padding.** Distinction from
  H3: none defensible on current evidence.

- **AGENT alone (H1) and SKILL alone (H2) are each `INCOMPLETE`.** The CCP has
  five file-defined agents in `.claude/agents/` and roughly twenty-three
  user-invocable skills in `.claude/skills/` `[EVIDENCE: VERIFIED]`. Some
  delegations are actor-shaped (who executes: `code-reviewer`,
  `security-auditor`); others are operation-shaped (what is invoked: `/gate`,
  `/no-go`, `/cerrar-fase`). Neither hypothesis alone spans both.

- **ARTIFACT-REFERENCE (H3) is the only hypothesis with real corpus evidence, and
  the current DEC-02 K2 formulation is a defective variant of it.** K2 as
  written flattens two orthogonal artifact types (agent files under `.claude/
  agents/*.md`; skill files under `.claude/skills/*/SKILL.md`) into one key —
  reproducing the same category-mixing anti-pattern that killed DEC-01
  D-CATALOG (ARCH-007 lesson). The fix is not a new abstraction; it is to
  **split H3 into orthogonal reference spaces**: an *actor-artifact space*
  (agent-refs) and an *operation-artifact space* (skill-refs), and let a
  delegation entry declare which type its target is.

- **Preferred-by-evidence** (technical provisional conclusion, not an Owner
  choice): **H3-SPLIT** — ARTIFACT-REFERENCE with explicit orthogonal spaces —
  is the only hypothesis whose truth conditions match observed CCP semantics
  without importing a new ontology. Confidence: `HIGH` for "H4/H5 are not
  supported"; `MODERATE-HIGH` for "H3-SPLIT is the shape the Owner should
  choose among R1 options"; `HIGH` for "R0-D0 (DEFER with observable trigger)
  remains coherent if the Owner does not yet want to commit even to H3-SPLIT".

- **DEC-02 READINESS: `READY_FOR_OWNER_CHOICE` with revised option surface**.
  See §26 for the Owner space. What has changed since the revised gate: (a)
  K2 as written must be labeled `SEMANTICALLY MIXED`; (b) H4/H5 must be
  presented to the Owner explicitly as `NOT SUPPORTED BY EVIDENCE`; (c) a new
  K-value K2' (H3-SPLIT) should be surfaced. **DEC-02 remains OPEN. This
  audit does not close it, authorize runtime, or modify canonical artifacts.**

- **Minimum reversible experiment** (§22): none required to answer H4/H5 —
  they are already refuted by absence of evidence. A single-entry docs-only
  pilot under H3-SPLIT would inform K/V/Q/P without runtime authorization.

---

## 2. DEC-02 Current State

Reconstructed strictly from `DEC-02_D-DELEG_DECISION_GATE_REVISED.md` and
`DEC-02_D-DELEG_OPENED.md`. No inference beyond what those files state.

### 2.1 Identity `[EVIDENCE: VERIFIED]`

- `DECISION_ID = DEC-02`
- `DECISION_NAME = D-DELEG`
- `TITLE = Delegation Governance Model`
- `STATUS = OPEN` (opened 2026-09-27, `FINAL_AUDIT_VERDICT =
  FINAL_GATE_READY_WITH_MINOR_NOTES`, zero MATERIAL findings)
- `STRATUM = C` · `CANONICAL = NO` · `OWNER_CHOICE = PENDING` ·
  `IMPLEMENTATION_AUTH = NONE` · `CHECKPOINT = NONE`
- `SOURCE_HEAD = e529359`

### 2.2 Current formulation (revised gate §8) `[EVIDENCE: VERIFIED]`

Dimensional decision space:

```
R = R0 (implicit governance)
    ↓
    D = D0 (DEFER via ARCH-005 pattern)  OR  D = D1 (RETIRE with RESOLVED_BY)
    ↓
    No K/V/Q/P subordinate choice.

R = R1 (docs-only representation)
    ↓
    K = K1 (ACTION_TYPE)  |  K2 (SKILL / AGENT)  |  K3 (evidence-grounded,
    currently UNKNOWN)
    ↓
    V = V1 (open-bounded)  |  V2 (closed-bounded)  |  V3 (field-local)
    ↓
    Q = Q1 (new-gate revocation)  |  Q2 (in-entry predicate)
    ↓
    P = P0 (universal)  |  P1 (phased with §8.5.1 measurement)
```

### 2.3 K2 current wording `[EVIDENCE: VERIFIED]`

Revised gate §6.2 literally says:

> **K2** — keyed by SKILL / AGENT artifact. A delegation entry names the source
> artifact (`.claude/skills/<skill>/SKILL.md` or `.claude/agents/<agent>.md`)…

And §6.2's "Disadvantages" bullets already flag:

> - Cross-cutting workflows (e.g., `evidence-registration` touches skill + hook)
>   do not fit cleanly under one artifact key.
> - Harness runtime types (fork, general-purpose, etc.) have no
>   `.claude/agents/*` file; they would be `UNKNOWN` under K2.
> - "Skill invocation" and "agent responsibility" have different natures (skill
>   = user invocation; agent = despachable actor); **K2 flattens them**.

This is the seed of the audit's central finding: K2 as written **is** the
flattening anti-pattern.

### 2.4 Assumptions currently embedded

- `[ASSUMPTION]` A single-artifact key (K1 or K2) is the natural shape of a
  delegation entry.
- `[ASSUMPTION]` The five heterogeneity/gap symptoms in §6.2 are "trade-offs" of
  K2, not evidence that K2 is malformed.
- `[HYPOTHESIS]` No other key shape (K3) exists worth articulating.

### 2.5 Known dependencies / downstream effects `[EVIDENCE: DOCUMENTED]`

- `DEC-07 F2/F3` → strongly informed by DEC-02 (revised gate §16).
- `DEC-REVIEWER-VERDICT` → informed by whether DEC-02 R = R1 (revised gate §21).
- `AUTHORITY_KIND` (ARCH-006) → provides the `agente` class the target's
  `delegated_to` field references; DEC-02 does **not** modify VOCAB-A.

### 2.6 Unresolved questions carried into this audit

- **Q-CORE**: what is the *semantic target* of a DEC-02 delegation entry — an
  AGENT, a SKILL, an ARTIFACT-REFERENCE, a CAPABILITY, or a HYBRID?
- **Q-K3**: does the CCP corpus contain evidence for a K3 alternative not
  covered by K1/K2?
- **Q-HYBRID**: is HYBRID a real dual-primitive or a compromise that hides
  unresolved complexity?

`Q-CORE`, `Q-K3`, and `Q-HYBRID` are the three questions this audit answers.

---

## 3. Audit Scope

- **In scope**: the semantic shape of the delegation `target` — the object the
  entry names. Every other dimension (R, V, Q, P) is out of scope except when
  affected by the target choice.
- **Out of scope (unchanged from revised gate §1.2)**: overall agent
  architecture; verifier architecture (DEC-07); canonical policy format
  (DEC-04); derivation motor (DEC-05); lifecycle (DEC-03); D-CATALOG
  resurrection; runtime enforcement decision; DEC-07 opening sequencing.
- **Non-mission**: this audit does not close DEC-02, does not select an option,
  does not authorize implementation, does not modify canonical artifacts. If
  the Owner reads it and *still* asks a clarifying question the audit did not
  anticipate, the audit is incomplete and should be extended before Owner
  choice, not overridden by inference.

---

## 4. Definitions (operational, CCP-anchored)

Each term is defined against evidence in the CCP corpus, not against generic
software engineering usage.

### 4.1 AGENT

- **What it is (CCP)**: an actor artifact under `.claude/agents/*.md` with
  declared `tools`, `permissionMode`, and a role description. Five exist at
  HEAD `e529359` `[EVIDENCE: VERIFIED]`.
- **What it is not**: a runtime process. The Markdown file is the artifact;
  the runtime instance is spawned by harness.
- **Identity**: filename (`architect.md`, `code-reviewer.md`, …). Rename → new
  identity.
- **Lifecycle**: created / modified / deleted by git.
- **Versionable**: yes, via git.
- **Addressable**: yes, by path.
- **Has authority**: yes — indirectly, via `AUTHORITY_KIND` class `agente`
  (ARCH-006) `[EVIDENCE: VERIFIED]`.
- **Can receive scope**: yes, via `tools` list.
- **Auditable**: yes, by git blame + subagent-stop-logger.
- **Substitutable**: yes; another agent can be despachable for a similar role.
- **Exists without runtime**: yes — the `.md` file exists whether or not the
  agent is currently despachable.

### 4.2 SKILL

- **What it is (CCP)**: a procedure/operation artifact under
  `.claude/skills/<name>/SKILL.md`, user-invocable via `/`-command or
  auto-triggered by frontmatter `description`. Approximately 23 exist at HEAD
  `[EVIDENCE: VERIFIED]`.
- **What it is not**: an actor. It has no `tools:` list; it prescribes *what
  Claude should do*, not *who does it*.
- **Identity**: directory name (`no-go`, `gate`, `cerrar-fase`, …).
- **Lifecycle / versionable / addressable / auditable**: yes, via git.
- **Has authority**: not directly. A skill is a procedure; authority lives in
  whoever executes the skill (typically Claude the primary agent).
- **Can receive scope**: yes, in the sense of "which situations it triggers on".
- **Substitutable**: yes; one skill can be superseded by another.
- **Exists without runtime**: yes.

### 4.3 ARTIFACT / ARTIFACT-REFERENCE

- **What it is (CCP)**: an addressable repository object (file, directory,
  registry entry). An ARTIFACT-REFERENCE is a stable path/identifier to one.
- **CCP artifacts already used as references**: `.claude/agents/*.md`,
  `.claude/skills/*/SKILL.md`, `.claude/rules/*.md`, `docs/00_SYSTEM/*.md`,
  `EV-NNN` entries, `ARCH-NNN` entries.
- **Identity**: canonical path.
- **Authority**: none intrinsic — inherits from what class of artifact it is
  (mecánica for hooks; convención for docs; agente for agent files).
- **Auditable**: yes.
- **Substitutable**: only by rename or replacement.
- **Exists without runtime**: definitionally yes — files exist statically.

### 4.4 CAPABILITY

- **What it *would* be (per master prompt hypothesis)**: an abstract stable
  competence (e.g., "code-review capability") independent of who implements it.
- **What it is in CCP today**: **absent as a first-class object.** Confirmed by
  grep across `AUTHORITY_KIND.md`, `DECISION_REGISTRY.md`,
  `EVIDENCE_REGISTRY.md` → 0 hits `[EVIDENCE: VERIFIED]`. Confirmed by absence
  from the PRIM excavation in `PIECE_AND_IDEA_PUZZLE_AUDIT.md §11` (PRIM-1..7
  do not include CAPABILITY) `[EVIDENCE: VERIFIED]`.
- **Sole appearance**: the string `CONTROLLED CAPABILITY` in the diagnostic
  grammar of `PIECE_AND_IDEA_PUZZLE_AUDIT.md §13`. The grammar reads
  `AUTHORITY × CONTRACT × MECHANISM × EVIDENCE = CONTROLLED CAPABILITY` — the
  *output* of the grammar, not an *input primitive*. Treating this as evidence
  of a first-class capability object is a category error: it is like taking
  "successful login" as evidence of a Login primitive when the primitives are
  Identity + Credential + Session.
- **Identity, lifecycle, versionability, addressability, authority**: `[UNKNOWN]`
  — because the object does not exist in the corpus, none of these questions
  has an evidence-grounded answer. Any answer would be *proposed*, not
  *observed*.
- **Substitutable**: `[UNKNOWN]` (proposed abstraction, not existing object).
- **Exists without runtime**: `[UNKNOWN]`.

### 4.5 HYBRID

- **What it *would* be (per master prompt hypothesis)**: CAPABILITY +
  IMPLEMENTATION-REFERENCE — a two-layer structure where the capability is the
  semantic target and the artifact reference is the current implementation
  binding.
- **Presupposition**: CAPABILITY exists. When CAPABILITY does not exist
  (§4.4), HYBRID has only one real half remaining: the implementation
  reference, i.e., H3.
- **What "hybrid" is currently masking**: the intuition that a delegation
  entry needs both a *stable name* (to survive implementation churn) and a
  *concrete reference* (to be operational). This intuition is correct;
  labeling the stable half "capability" is what is not supported.

### 4.6 IMPLEMENTATION

- **What it is (CCP)**: the concrete runnable or executable artifact — the
  hook script under `.claude/hooks/*`, the skill directory, the agent
  Markdown loaded by harness.

### 4.7 DELEGATION

- **What it is (CCP)**: per revised gate §4, one of six senses (Authorization,
  Documentation, Scope description, Activation policy, Runtime permission,
  Provenance). DEC-02 R1 changes S2/S3/S4/S6 only.
- **What it operates on**: the `target` — the object being delegated to. That
  is the subject of this audit.

### 4.8 TARGET

- **What it is (this audit's operational definition)**: the field in a
  delegation entry that answers "delegated to *what*?". The candidate types
  are AGENT, SKILL, ARTIFACT-REFERENCE, CAPABILITY, HYBRID.
- **What it is not**: the delegator (Owner), the scope description, the
  activation predicate, or the revocation procedure — those are separate
  fields of the same entry.

---

## 5. Evidence Inventory

Cases collected from the primary sources listed in §0 (baselines). Every case
is tagged for evidence class. Cases were selected for their bearing on
target-shape questions; not exhaustive.

| CASE_ID | ARTIFACT | LOCATION | WHAT IT REPRESENTS | EVIDENCE |
|---|---|---|---|---|
| E-01 | `.claude/agents/` | directory listing | 5 file-defined actor artifacts (architect, code-reviewer, implementer, researcher, security-auditor) | VERIFIED |
| E-02 | `.claude/skills/` | directory listing | ~23 procedure artifacts (adr, cerrar-fase, checkpoint, doctor, gate, no-go, evidence, …) | VERIFIED |
| E-03 | `AUTHORITY_KIND.md` §3 | canonical | Four-class vocabulary: `mecánica`, `convención`, `humana`, `agente`. **No `capability` class.** | VERIFIED |
| E-04 | `PIECE_AND_IDEA_PUZZLE_AUDIT.md §11` | primitive excavation | PRIM-1..PRIM-7 enumerated; CAPABILITY absent | VERIFIED |
| E-05 | `PIECE_AND_IDEA_PUZZLE_AUDIT.md §13` | grammar section | `CONTROLLED CAPABILITY` as grammar output, not primitive | VERIFIED |
| E-06 | Revised gate §6.1 (K1) | option surface | 11 empirical ACTION_TYPE items: 5 agent-responsibilities, 5 skill-invocations, 1 workflow | VERIFIED |
| E-07 | Revised gate §6.2 (K2) | option surface | K2 flattens skill-artifact and agent-artifact into one key with 3 documented gaps | VERIFIED |
| E-08 | Revised gate §3.1 | current state | Every actor + action pair maps to one AUTHORITY_KIND class; agents use `agente`, hooks use `mecánica`, Owner uses `humana`, rules/docs use `convención` | VERIFIED |
| E-09 | Revised gate §4 | semantic model | Six delegation senses; docs-only R1 changes S2/S3/S4/S6 only, not S1/S5 | VERIFIED |
| E-10 | `INCIDENT_REGISTRY.md` | inspection | Zero incidents attributed to implicit delegation (per revised gate §12 claim 8) | DOCUMENTED |
| E-11 | ARCH-007 (DEC-01) closure | recent decision | D-CATALOG retired for heterogeneous vocabulary; lesson: mixing dimensions with different source-of-truth is a category error | VERIFIED (registry) |
| E-12 | ARCH-005 (DEC-11) | recent decision | Deferrals under HYB-FINAL-v4 pattern with `trigger:` blocks — proves ARCH-005 pattern is available for DEC-02 R0-D0 | VERIFIED |
| E-13 | ARCH-006 §6 prohibitions | canonical | No `piece → authority` mapping; no meta-authority; no VOCAB-B/C | VERIFIED |
| E-14 | Skill/agent role difference | conceptual test | Skills prescribe *procedure*; agents declare *actor + tools*. Different natures: skills answer "what to do"; agents answer "who does it" | INFERENCE (from artifact structure, not from a canonical statement) |
| E-15 | Harness runtime types (fork, Explore, Plan, …) | agent list | Not present in `.claude/agents/*.md`; would be `UNKNOWN` under K2 | VERIFIED (via revised gate §3.1) |

No case in the inventory presents CAPABILITY as an existing CCP object.

---

## 6. Existing CCP Semantic Model

This section audits what the CCP *already* implicitly says about delegation
targets, without proposing anything new.

### 6.1 Two-space observation

The CCP already carries two disjoint artifact spaces that are candidates for
delegation targets:

- **Actor-artifact space** = `.claude/agents/*.md` — five artifacts. Semantic
  type: WHO. Authority class: `agente`.
- **Operation-artifact space** = `.claude/skills/*/SKILL.md` — ~23 artifacts.
  Semantic type: WHAT. Authority class: *derived* — a skill's execution
  authority is whoever invokes it; the invoker's own class applies (usually
  `humana` for Owner-triggered skills, `agente` for subagent-triggered).

### 6.2 The heterogeneity is not accidental

K1 has 11 items with a documented 5-5-1 split (§6.1 of revised gate; E-06
here). This 5-5-1 shape is the *shadow* of the two-space observation in §6.1:
the "5 agent-responsibilities" fold back to five agent artifacts; the "5
skill-invocations" fold back to five (of the ~23) skill artifacts; the "1
workflow" (`evidence-registration`) spans both. K1's heterogeneity is
therefore a *symptom*, not a *design*.

### 6.3 The `agente` class already anchors AGENT-shaped delegation

`AUTHORITY_KIND` VOCAB-A already includes `agente`. A delegation entry keyed
by AGENT can populate `delegated_to = agente` and reference the agent file —
no new vocabulary needed.

### 6.4 SKILL delegations have no canonical `AUTHORITY_KIND` binding

There is no `skill` class in VOCAB-A. A skill invocation's authority is
inherited from the invoker. This is the structural reason K2 has to invent a
category ("`.claude/skills/*/SKILL.md` OR `.claude/agents/*.md`") — because
without the WHO/WHAT split, the entry loses its authority anchor.

### 6.5 Corollary

**The CCP's existing semantic model already distinguishes AGENT from SKILL**.
K2 collapses that distinction. That collapse is what the master prompt is
correctly asking to unwind — but the answer is not to *add* a new object
(CAPABILITY); it is to *stop erasing* an existing distinction.

---

## 7. AGENT Analysis (H1)

### 7.1 What it represents

A delegation entry whose target is an agent artifact (`.claude/agents/*.md`).

### 7.2 Problems it solves

- Anchors `delegated_to` directly to `AUTHORITY_KIND` class `agente`.
- Reuses first-class repository artifact; no new taxonomy.
- Substitution semantics: swap one agent for another under identical
  delegation identity — clean, because the identity is the *role* the entry
  targets (see §13).

### 7.3 Problems it introduces

- **Does not cover skill invocations.** `/gate`, `/no-go`, `/cerrar-fase` are
  operational delegations; none corresponds to an agent file.
- **Harness runtime types are `UNKNOWN`** — no agent file for `fork`,
  `general-purpose`, `Explore`, `Plan`, `claude`, `claude-code-guide`,
  `statusline-setup` (E-15).
- **Cross-cutting workflows** (evidence-registration) still don't fit.

### 7.4 Evidence supporting

- E-01 (agents exist as file artifacts).
- E-08 (every agent-action pair already maps to `agente` class).
- E-11 (ARCH-007 lesson: prefer first-class artifacts over invented taxonomies).

### 7.5 Contradictions

- H1 alone leaves ~half of the observed 11-item ACTION_TYPE inventory
  unmapped. It cannot be the *whole* semantic model.

### 7.6 Lock-in

- Semantic: `LOW`. Agents are stable artifacts.
- Governance: `LOW`. Already in AUTHORITY_KIND.
- Migration: `LOW`. Reversible.

### 7.7 Verdict for H1

**`INCOMPLETE`**. Necessary but not sufficient. Should not be the *only*
target shape.

---

## 8. SKILL Analysis (H2)

### 8.1 What it represents

A delegation entry whose target is a skill artifact
(`.claude/skills/*/SKILL.md`).

### 8.2 Problems it solves

- Anchors delegation to the *operation* being authorized (matching the ~5
  skill-invocation items in the 11-item inventory).
- Clean first-class artifact reference; git-auditable.

### 8.3 Problems it introduces

- **No `skill` class in AUTHORITY_KIND.** A skill's authority is inherited from
  its invoker; a delegation entry keyed by skill needs a separate `authorized_
  for_invocation_by = <agente | humana>` field. That's an admission that H2
  alone doesn't close the semantic contract.
- **Does not cover agent responsibilities.** `code-review` as a
  responsibility of the `code-reviewer` agent is not naturally a skill.

### 8.4 Evidence supporting

- E-02 (skills exist as artifacts).
- E-06 (5 of 11 empirical items are skill invocations).

### 8.5 Contradictions

- H2 alone leaves the actor-shaped half of the inventory unmapped and forces
  invention of an auxiliary "invoker" field.

### 8.6 Verdict for H2

**`INCOMPLETE`**. Symmetric to H1. Should not be the only target shape.

---

## 9. ARTIFACT-REFERENCE Analysis (H3)

### 9.1 What it represents

A delegation entry whose target is *any* first-class repository artifact,
referenced by canonical path. Two sub-variants must be distinguished:

- **H3-FLAT (current K2)**: `target = path` where path is *either* a
  `.claude/agents/*.md` file *or* a `.claude/skills/*/SKILL.md` file, with no
  type label on the entry.
- **H3-SPLIT**: `target = { type: agent | skill, ref: <path> }` — the entry
  declares which artifact-space it is targeting.

### 9.2 Problems H3-FLAT solves

- Unified surface: one field, one shape.

### 9.3 Problems H3-FLAT introduces

- **Category flattening**: skill and agent have different natures (§4). One
  key erases that distinction — reproducing the ARCH-007 D-CATALOG pattern
  (E-11).
- **Ambiguous authority binding**: an entry could point to a skill; the
  authority is not derivable from the path alone.
- **Cross-cutting workflows unresolved**: `evidence-registration` still fits
  nowhere clean.

### 9.4 Problems H3-SPLIT solves

- Preserves the WHO/WHAT distinction (§6.1) that the CCP already carries.
- Preserves clean binding: agent-type entries anchor to `agente`; skill-type
  entries carry an explicit `authorized_invoker` field, using existing
  AUTHORITY_KIND classes.
- Handles the harness-runtime-types case explicitly: entries can be typed
  `agent` with `ref = <harness-type>` and a note that the artifact is
  harness-provided rather than file-defined. This is a documented `UNKNOWN`,
  not a silent gap.
- Handles cross-cutting workflows by permitting an entry with `type = compound`
  and a list of refs — a documented compound is honest; K2's silent
  flattening is not.

### 9.5 Problems H3-SPLIT introduces

- Two-space entries are slightly more verbose than one-space entries.
- Requires the Owner to consciously choose which space an entry lives in — but
  this is a *feature*: the choice is exactly the category-mixing point
  ARCH-007 said not to bury.

### 9.6 Evidence supporting

- E-01 + E-02 (both artifact spaces exist).
- E-08 (existing `agente` class supports agent-side entries).
- E-11 (ARCH-007 explicitly rewards structural clarity over surface unity).

### 9.7 Lock-in

- Semantic: `LOW` (H3-SPLIT) / `MODERATE` (H3-FLAT — creates future refactor
  debt).
- Governance: `LOW`.
- Migration between H3-FLAT and H3-SPLIT: `LOW`; adding the `type:` field is a
  local schema evolution.

### 9.8 Verdict for H3

- **H3-FLAT: `NOT RECOMMENDED`** — reproduces ARCH-007 anti-pattern.
- **H3-SPLIT: `PREFERRED-BY-EVIDENCE`** among R1 options — the only hypothesis
  whose truth conditions match observed CCP semantics without importing a new
  ontology.

---

## 10. CAPABILITY Analysis (H4)

### 10.1 What it *would* represent

A stable abstract competence (e.g., "code-review capability", "policy-
enforcement capability") named by the delegation entry. The concrete artifact
(agent or skill) would be a *binding* of the capability, not the target
itself.

### 10.2 Problems it *would* solve

- Substitution over implementation: swap the LLM verifier under "code-review
  capability" without editing every entry that references it.
- Stable naming under implementation churn.

### 10.3 Problems it introduces

- **No corpus evidence.** 0 occurrences in canonical registries (§1, E-03,
  E-04). Only `CONTROLLED CAPABILITY` appears once, and only as a *grammar
  output* (§4.4, E-05), not as a primitive.
- **New ontology layer**: requires a `CAPABILITY_REGISTRY.md` (or equivalent),
  invents the object, chooses its naming discipline, and then binds
  implementations to it. That is exactly the "new abstraction without
  evidence" red flag the master prompt §32 warns against.
- **Overlaps with AGENT and SKILL identity**: if "code-review capability" is
  named, does deleting the `code-reviewer` agent revoke it? The answer is not
  derivable from evidence.
- **Doubles the auditable object count** without solving any observed
  problem. The two audited problems (workflow bottleneck, DEC-07 F2/F3
  quality) are addressed by H3-SPLIT without a capability layer.

### 10.4 Existence audit (per master prompt §9)

| Test | Result | Basis |
|---|---|---|
| EXPLICIT in CCP? | **NO** | 0 occurrences in canonical registries |
| IMPLICIT (used unnamed)? | **WEAK** | Compound noun in one grammar sentence |
| LATENT (multiple pieces presuppose it)? | **NO** | PRIM-1..7 do not list it; the AUDIT went looking for latent primitives and did not find CAPABILITY |
| DERIVED (emergent from combinations)? | **POSSIBLY** — but only as a *grammar output*, not as an object needing materialization |
| SPECULATIVE (proposed without evidence)? | **YES** — this is where it sits |
| NOT PRESENT (contradicted)? | Not contradicted, but not present |

**Final classification: `SPECULATIVE`.**

### 10.5 Lock-in

- Semantic: `HIGH` — introduces a new class of object; downstream decisions
  (DEC-07 vocab, DEC-REVIEWER-VERDICT scope) start referencing it.
- Governance: `HIGH` — Owner must maintain a capability naming discipline
  forever.
- Migration back: `HIGH` — once entries reference capabilities, unwinding
  requires editing every entry.

### 10.6 Verdict for H4

**`NOT SUPPORTED BY EVIDENCE`**. Adopting H4 would violate `EVIDENCE > ELEGANCE`
and `SEMANTIC TRUTH > IMPLEMENTATION CONVENIENCE`. It should be presented to
the Owner explicitly as speculative, not as a peer option to H3-SPLIT.

---

## 11. HYBRID Analysis (H5)

### 11.1 What it *would* represent

Two-layer: capability (stable, semantic) + implementation-reference
(concrete, current binding). A delegation entry names both.

### 11.2 Structural dependence on H4

If CAPABILITY (H4) is speculative, then HYBRID's "capability half" is
speculative, and HYBRID reduces to its "implementation-reference half" — i.e.,
to H3.

### 11.3 Consequence

There is no defensible daylight between H5 and H3 when H4 is out.

- If Owner is drawn to H5 because it "hedges" between capability and
  reference, that is really a preference for H3-SPLIT with better naming
  discipline (see §22 on how to satisfy that intuition without adopting H4).
- If Owner is drawn to H5 because "capabilities feel more architectural", that
  is a red-flag per master prompt §32 checkbox 6 (introducing a new
  abstraction without evidence) and checkbox 10 (hiding unresolved ambiguity
  inside HYBRID).

### 11.4 Verdict for H5

**`NOT A DISTINCT OPTION`** given current evidence. Present it to the Owner
transparently: "H5 collapses to H3 under evidence; if you want the intuition
'stable name + concrete binding', that is achievable within H3-SPLIT via a
`stable_role` label alongside the artifact reference — without inventing a
CAPABILITY object."

---

## 12. Implementation Substitution Test

Test (per master prompt §10): does the meaning of *authority, scope,
provenance, revocation, auditability, governance* stay stable when the
implementation behind the target changes?

Two concrete substitution cases:

- **Case A**: swap `code-reviewer` agent Markdown from LLM verifier V1 to V2
  (same file, edited content).
- **Case B**: replace `code-reviewer` agent with a different agent named
  `review-arbiter` intended to do the same work.

| Model | Case A | Case B | Notes |
|---|---|---|---|
| H1 AGENT | STABLE | UNSTABLE | H1 identity = filename; Case B changes filename, so it's a *different delegation*. Not a bug — just a property. |
| H2 SKILL | STABLE (if role modeled as a skill) | UNSTABLE if agent-shaped role | Symmetric limitation. |
| H3-FLAT | STABLE | UNSTABLE | Same as H1/H2. |
| H3-SPLIT | STABLE (Case A within type; Case B is explicit re-authorization) | PARTIALLY STABLE — the `type` and `stable_role` label survive; only the `ref` changes | Best behavior of the evidence-grounded models. |
| H4 CAPABILITY | STABLE by construction | STABLE by construction — this is H4's marketed feature | But the stability is only present *if* the CAPABILITY object exists (§10.4). If it doesn't, this stability is a promise, not a property. |
| H5 HYBRID | STABLE if H4 half real; else same as H3 | STABLE if H4 half real; else same as H3 | Collapses to H3 under evidence. |

**Reading**. H4's substitution-stability is real *only in the world where
CAPABILITY is materialized*. In today's CCP it is not. H3-SPLIT with an
optional `stable_role: <label>` field captures the same substitution intuition
without inventing an object.

---

## 13. Identity Test

For each hypothesis: what is the stable identity? What can change without
changing identity? What change destroys identity?

| Model | Stable identity | Preserves identity | Destroys identity |
|---|---|---|---|
| H1 AGENT | Agent filename | Editing tools:, permissionMode, description | Rename or delete file |
| H2 SKILL | Skill directory name | Editing SKILL.md body | Rename or delete directory |
| H3-FLAT | Artifact path | Editing content | Rename or type-change |
| H3-SPLIT | `(type, ref)` pair, optionally + `stable_role` label | Editing artifact content | Changing `type` (semantic move); changing `ref` if no `stable_role`; changing `stable_role` if declared |
| H4 CAPABILITY | Capability name (proposed) | Swap implementation binding | Renaming or retiring capability — but this is untested, since CAPABILITY does not exist |
| H5 HYBRID | Capability half if real; else artifact ref | Swap implementation | Retire capability — same untested claim |

Identity discipline is best served by **H3-SPLIT**, because its identity is
composed of *observable* components (type, ref, optional label). H4/H5
identity is *proposed* rather than observable.

---

## 14. Governance Test

For each model, does it change any of {AUTHORITY, SCOPE, ACTIVATION,
FALLBACK, PROVENANCE, REVOCATION, VERSION, AUDIT} in a way that requires
runtime enforcement?

| Model | AUTHORITY | SCOPE | ACTIVATION | FALLBACK | PROVENANCE | REVOCATION | VERSION | AUDIT | Requires runtime? |
|---|---|---|---|---|---|---|---|---|---|
| H1 | `agente` inherited | tools: on agent | activation predicate on entry | agent-fallback in entry | git + subagent-stop | new gate (Q1) or in-entry (Q2) | git | git blame | NO |
| H2 | Invoker-derived | skill-scope | entry | invoker-fallback | git | Q1/Q2 | git | git blame | NO |
| H3-FLAT | Ambiguous (see §9.3) | entry | entry | entry | git | Q1/Q2 | git | git blame | NO — but ambiguity is a governance defect, not a runtime one |
| H3-SPLIT | Type-derived (agente or invoker) | entry | entry | entry | git | Q1/Q2 | git | git blame | NO |
| H4 | Would require a new authority-binding rule (proposed) | entry | entry | entry | new registry + git | new revocation semantics | new registry + git | new registry + git | NO by construction, but only if capability naming stays convention-level; the *shape* invites runtime enforcement, which is an anti-goal (revised gate §7.2) |
| H5 | Same as H4 for the capability half; H3 for the impl half | Same | Same | Same | Same | Same | Same | Same | NO by construction, same caveat as H4 |

**Critical governance property** (revised gate §4.4): a docs-only R1
mechanism is `convención` authority, not `mecánica`. All five models can be
implemented docs-only. But **H4/H5 are the two models whose *shape* invites
future runtime authorization** — because once a "capability" is named, the
next question is "does the runtime check whether the invoker holds this
capability?" That question does not naturally arise with H3-SPLIT.

**Conclusion**: H4/H5 introduce governance-layer creep even if not adopted
with runtime.

---

## 15. Scope / Authority / Provenance / Revocation Test

Per revised gate §4 semantic model, R1 changes S2/S3/S4/S6 only. For each
model:

| Model | S2 (Doc) | S3 (Scope) | S4 (Activation) | S6 (Provenance) | Notes |
|---|---|---|---|---|---|
| H1 | Clean | Clean via `tools:` | ARCH-005 pattern | git | Native fit for AUTHORITY_KIND `agente` |
| H2 | Clean | Skill-scope | ARCH-005 | git | Needs auxiliary `invoker` field |
| H3-FLAT | Ambiguous type | Muddled scope | ARCH-005 | git | Ambiguity contaminates S2 |
| H3-SPLIT | Clean per type | Type-aware scope | ARCH-005 | git | Best fit |
| H4 | Requires new discipline | Requires new discipline | ARCH-005 | git + capability registry | New discipline is the tell |
| H5 | Same as H4/H3 depending on half | Same | ARCH-005 | Same | Collapses to H3 under evidence |

---

## 16. Versioning / Evolution Test

Master prompt §15. Simulate `V1 → V2` for each layer.

- **Agent A → Agent B** (agent artifact evolves): H1/H3-SPLIT handle
  natively; H4 requires editing binding.
- **Skill A → Skill B**: H2/H3-SPLIT handle natively; H4 requires binding
  edit.
- **Capability A → Capability B**: H4/H5 handle *within* the capability layer;
  H1/H2/H3 do not have a capability layer, so the question is undefined —
  which is fine, because CAPABILITY is not an existing object (§10).

Which layer absorbs change?

| Change type | Best absorbed by |
|---|---|
| Agent implementation edit | Artifact layer (H1/H3-SPLIT) |
| Skill implementation edit | Artifact layer (H2/H3-SPLIT) |
| Role rename | Optional `stable_role` label in H3-SPLIT; H4 in a world where H4 exists |
| Whole authority policy change | Governance layer (out of DEC-02 scope) |
| Runtime enforcement introduction | Future decision (out of DEC-02 scope) |

**Reading**. The only change type that H4 handles better than H3-SPLIT is
"role rename with implementation continuity". That change can be modeled in
H3-SPLIT by declaring the `stable_role` label. Cost: one extra optional field
on the entry. Benefit vs H4: no new ontology.

---

## 17. Composition Test

For each model, does target compose cleanly with the other fields on a
delegation entry (scope, policy, activation predicate, evidence contract,
verification, review, fallback, chaining, revocation)?

| Model | Composes cleanly | Composes with translation | Creates ambiguity | Creates coupling |
|---|---|---|---|---|
| H1 | With `agente` authority, tools scope | Skill invocations don't fit | Cross-cutting workflows | Low |
| H2 | With invoker + skill scope | Actor responsibilities don't fit | Same | Low |
| H3-FLAT | Nominally | Everything needs a type inference | Everywhere | Latent |
| H3-SPLIT | Yes, type-directed composition | Compound workflows via `type: compound` | Minimal | Low |
| H4 | Requires a binding step for every compose | High | High if binding stale | Introduces a registry coupling |
| H5 | Same as H4 for capability half | Same | Same | Same |

---

## 18. Lock-in Analysis

Per master prompt §16. Qualitative scale bands (0–20 very low; 21–40 low;
41–60 moderate; 61–80 high; 81–100 very high). These are **architectural
heuristics**, not measurements.

| Model | Initial | Migration | Future coupling | Semantic | Impl | Governance | Runtime | Recovery difficulty | Basis |
|---|---|---|---|---|---|---|---|---|---|
| H1 AGENT | 15 | 20 | 25 | 20 | 15 | 20 | 10 | 15 | Reuses existing artifact; no new taxonomy |
| H2 SKILL | 15 | 25 | 30 | 25 | 20 | 30 | 10 | 20 | Needs auxiliary invoker field |
| H3-FLAT | 20 | 40 | 45 | 55 | 20 | 50 | 15 | 35 | Ambiguity propagates; ARCH-007 pattern risk |
| H3-SPLIT | 25 | 25 | 30 | 25 | 20 | 25 | 15 | 20 | Slight verbosity; clean semantics |
| H4 CAPABILITY | 55 | 70 | 75 | 75 | 55 | 65 | 50 | 70 | New ontology; discipline required forever; runtime creep tendency |
| H5 HYBRID | 60 | 70 | 75 | 75 | 60 | 65 | 55 | 75 | Inherits H4 problems; adds surface area |

Reasoning:
- H1/H2 low because they reuse existing artifacts and existing authority
  classes.
- H3-FLAT climbs on semantic lock-in because ambiguity, once encoded in
  entries, is expensive to unwind (ARCH-007 D-CATALOG cleanup cost is the
  precedent).
- H3-SPLIT stays low because the `type:` field is small, honest, and
  reversible.
- H4/H5 climb across all dimensions because a new ontology forever changes
  the mental model of the CCP and invites downstream absorption (DEC-07
  vocab, DEC-REVIEWER-VERDICT scope) that would be hard to undo.

---

## 19. Value of Information

Per master prompt §17. For each uncertainty:

| Uncertainty | Impact if wrong | Probability of uncertainty | Cost of discovering later | VoI band | Resolve now? |
|---|---|---|---|---|---|
| Whether CAPABILITY exists in CCP | HIGH (drives H4/H5 acceptance) | LOW-MEDIUM after this audit | HIGH (would spread through downstream decisions) | HIGH | RESOLVED (§4.4, §10) — answer is NO |
| Whether skills and agents are semantically distinct | HIGH (drives K2 vs K2') | LOW after §6 | MEDIUM | HIGH | RESOLVED — YES |
| Whether harness runtime types need entries | MEDIUM | MEDIUM | LOW-MEDIUM | MEDIUM | DEFER — first entries under R1 will show; not blocking Owner choice |
| Whether cross-cutting workflows (evidence-registration) need compound entries | MEDIUM | MEDIUM | LOW | MEDIUM | DEFER — same |
| Whether DEC-07 F2 is imminent | HIGH (would sharpen R1 urgency) | UNKNOWN | Owner-knowable | HIGH | Ask Owner directly (Q4 in §26) |
| Whether an incident will emerge attributable to implicit delegation | HIGH (would move R0 → R1 automatically) | LOW today | MEDIUM | LOW-MEDIUM today | Watch INCIDENT_REGISTRY; not resolvable proactively |

Nothing on this list requires resolving before Owner choice, given that the
two HIGH-VoI uncertainties are resolved *within* this audit.

---

## 20. Adversarial Counter-Audit

Per master prompt §18. Attempt to destroy each surviving hypothesis.

### 20.1 ATTACK H3-SPLIT

- **Attack**: "the `type` field is an invented category — what stops it from
  drifting like DEC-01 D-CATALOG?"
  - **Response**: `type` has exactly two observed values from existing CCP
    artifact spaces (`agent`, `skill`) plus one explicit compound label.
    Every value is grounded in a directory that exists at HEAD. Drift is
    checked by "any value not corresponding to a real directory is invalid at
    entry time" — no runtime enforcement required, and the check is a
    Markdown-audit rather than a taxonomy.
  - **Survives**: YES.

- **Attack**: "H3-SPLIT still doesn't cover harness-runtime types."
  - **Response**: correct; entries for harness types would carry `type: agent`
    with `ref: <harness-runtime-name>` and a note that no `.claude/agents/*`
    file exists — an *explicit* UNKNOWN. K2 had the same gap silently.
  - **Survives**: YES with documented residual.

- **Attack**: "H3-SPLIT is basically K2 with an extra field — why not stay
  with K2?"
  - **Response**: because the extra field is exactly the semantic
    distinction K2 flattens. The audit's whole finding is that flattening is
    the defect. Adding one label is the minimum surgical fix.
  - **Survives**: YES.

### 20.2 ATTACK H4 CAPABILITY

- **Attack**: "the master prompt claims CAPABILITY may be latent — did the
  audit look hard enough?"
  - **Response**: PRIM excavation in `PIECE_AND_IDEA_PUZZLE_AUDIT.md §11`
    was explicitly a *primitive-discovery* pass. It found PRIM-1
    AUTHORITY-KIND, PRIM-2 CONTRACT, PRIM-3 DERIVATION, PRIM-4 LIFECYCLE,
    PRIM-5 PROVENANCE, PRIM-6 INVARIANT-TEST (partial), PRIM-7 HUMAN-SINK.
    CAPABILITY is not among them, and the audit's own methodology note said
    it *tried* to add a sixth axis and could not find one defensibly. That
    negative result is the strongest evidence available: a pass designed to
    find latent primitives did not find this one.
  - **Survives**: NO — H4 fails the "existence in corpus" test.

- **Attack**: "CAPABILITY solves implementation substitution — surely that's
  worth an abstraction."
  - **Response**: H3-SPLIT with an optional `stable_role` label solves the
    same substitution case (§12) without inventing an object. If the Owner
    later observes multiple entries needing the same `stable_role` and
    finds themselves re-typing it, then a capability object earns
    materialization — but that trigger has not fired.
  - **Survives**: NO.

### 20.3 ATTACK H5 HYBRID

- **Attack**: "HYBRID hedges — surely more coverage is safer."
  - **Response**: HYBRID's "safety" is illusory when its capability half has
    no corpus base. What HYBRID actually does is preserve unresolved
    complexity behind a two-layer surface. Master prompt §32 checkbox 10
    warns against this.
  - **Survives**: NO.

### 20.4 ATTACK H1/H2 (single-shape models)

- **Attack**: "half-coverage is worse than K2's full-coverage flat model."
  - **Response**: agreed. That is why the audit's verdict is not H1 or H2
    alone; it is H3-SPLIT (which covers both spaces with type discipline).

### 20.5 Survivors after adversarial pass

- **H3-SPLIT survives.**
- **H1 alone / H2 alone do not survive as complete answers** (they survive as
  sub-cases of H3-SPLIT).
- **H4 / H5 do not survive** the corpus-existence test.

---

## 21. Falsifiers

Master prompt §19 requires ≥3 falsifiers per surviving hypothesis, split
across observable-now / observable-during-pilot / observable-future-runtime.

### 21.1 H3-SPLIT falsifiers

- **F-H3S.1 (now)**: an ACTION_TYPE emerges that maps naturally to neither
  agent-space nor skill-space and cannot be honestly modeled as `type:
  compound`. Would falsify the two-space closure claim.
- **F-H3S.2 (pilot)**: the pilot entry (say, for `code-review`) needs to
  reference more than one artifact simultaneously *and* the compound form
  produces persistent reviewer confusion.
- **F-H3S.3 (future runtime)**: if runtime enforcement is later introduced,
  the type-directed authority binding proves to be systematically wrong for
  ≥1 real case, forcing a re-shape.

### 21.2 H4 falsifiers (were H4 accepted)

- **F-H4.1 (now)**: no such falsifier is available because H4 has no observed
  facts to contradict — which itself is evidence that it is speculative.
- **F-H4.2 (pilot)**: two capability entries turn out to be indistinguishable
  from each other or from their artifact bindings — the capability layer
  adds no information.
- **F-H4.3 (future runtime)**: the capability layer requires a runtime
  authorization mechanism to be useful, which would violate DEC-02's
  docs-only scope (revised gate §7.2).

### 21.3 R0-D0 falsifiers (for completeness — R0 is also a survivor)

- Copied from revised gate §13.1: F-R0D0.1 (repeated ambiguity), F-R0D0.2
  (trigger fires), F-R0D0.3 (DEC-07 opens under F2/F3 requiring a delegation
  reference).

---

## 22. Minimum Reversible Experiment

Per master prompt §23. Design an experiment that maximally informs H3-SPLIT
without closing DEC-02, without runtime, and without changing production
behavior.

### 22.1 Experiment `EXP-DEC02-SEM`

- **Objective**: verify that a single H3-SPLIT delegation entry can express
  one agent-shaped delegation (`code-review`) and one skill-shaped delegation
  (`/gate`) coherently, and that the difference is observable to a reviewer
  reading the entries cold.
- **Corpus**: two draft entries authored in a Stratum-C scratch file (not
  committed to canonical registries).
- **Procedure**:
  1. Draft entry A: `type: agent`, `ref: .claude/agents/code-reviewer.md`,
     `stable_role: code-review-verdict-emitter`, `scope:`, `activation:`,
     `revocation:`, `provenance:`.
  2. Draft entry B: `type: skill`, `ref: .claude/skills/gate/SKILL.md`,
     `stable_role: phase-gate-check`, `authorized_invoker: humana`, `scope:`,
     `activation:`, `revocation:`, `provenance:`.
  3. Present both entries to a fresh reviewer (or a cold-context re-read)
     without prior context.
  4. Ask: "which is an actor-side delegation and which is an operation-side
     delegation? What does each authorize? What does each not authorize?"
- **Expected observation**: reviewer distinguishes the two without prompting;
  scope statements are answerable in one reading.
- **Success condition**: reviewer describes the WHO/WHAT split correctly and
  identifies at least one authority-class difference (`agente` vs
  invoker-derived).
- **Failure condition**: reviewer conflates the two, or misidentifies who
  authorizes what.
- **Evidence artifact**: annotated scratch file + reviewer's written
  interpretation (Stratum-C).

### 22.2 What the experiment does not do

- Does not authorize runtime.
- Does not commit anything to canonical registries.
- Does not modify PROJECT_STATE, DECISION_REGISTRY, AUTHORITY_KIND.
- Does not close DEC-02.
- Does not select an R/K/V/Q/P combination.

### 22.3 Cost / duration

- Cost: authoring two entries + one cold reviewer interpretation.
- Duration: single session.
- Reversibility: trivial — scratch file is discarded.

---

## 23. Comparative Matrix

Rows are descriptive assessments, not scores. `H3-F` = H3-FLAT, `H3-S` =
H3-SPLIT.

| Criterion | AGENT (H1) | SKILL (H2) | H3-FLAT | H3-SPLIT | CAPABILITY (H4) | HYBRID (H5) |
|---|---|---|---|---|---|---|
| Semantic stability | HIGH within actor-space | HIGH within op-space | MED — ambiguous | HIGH | Undefined (no object) | Inherits H4 |
| Implementation independence | MED | MED | MED | MED (with stable_role: HIGH) | HIGH by construction, but only if H4 real | Same |
| Governance fit | HIGH via `agente` | MED (needs invoker) | LOW (ambiguous binding) | HIGH | LOW (invites runtime creep) | LOW |
| Authority compatibility | Native `agente` | Invoker-derived | Ambiguous | Type-derived, native | New authority discipline required | Same |
| Scope compatibility | via tools: | via skill body | Muddled | Clean per type | New discipline | Same |
| Provenance | git | git | git | git | git + new registry | git + new registry |
| Revocation | Q1/Q2 | Q1/Q2 | Q1/Q2 | Q1/Q2 | Q1/Q2 + capability semantics | Same |
| Versioning | git | git | git | git | git + capability lifecycle | Same |
| Auditability | HIGH | HIGH | MED (ambiguous type) | HIGH | Requires new registry maintenance | Same |
| Composability | With actor-side | With op-side | Latent ambiguity | Type-directed | Binding step everywhere | Same |
| Reversibility | HIGH | HIGH | MED | HIGH | LOW-MED | LOW-MED |
| Lock-in | LOW | LOW | MED | LOW | HIGH | HIGH |
| Complexity (Owner-facing) | LOW (partial coverage) | LOW (partial coverage) | LOW (misleadingly) | LOW-MED | HIGH | HIGH |
| Future evolution | Fits agent additions | Fits skill additions | Absorbs both awkwardly | Fits both natively | New object to maintain | Same |
| Evidence strength | HIGH for actor-side only | HIGH for op-side only | MED — anti-pattern precedent | HIGH — matches corpus | NONE for existence | NONE for existence of capability half |

**Descriptive reading**: H3-SPLIT dominates on evidence-anchored criteria.
H4/H5 dominate only on criteria whose ground truth is proposed rather than
observed. The matrix is not a score; it is a description.

---

## 24. 3 / 6 / 12-Month Projections

Per master prompt §21. Effects of each choice at horizons; inferred where
noted.

### 24.1 NOW

- H1/H2 alone: partial coverage; every third entry needs a workaround.
- H3-FLAT: entries land, category-mixing accumulates silently.
- H3-SPLIT: entries land with slight verbosity; auditable from day one.
- H4/H5: cannot land coherently — the object being referenced does not exist.

### 24.2 3 MONTHS `[INFERENCE]`

- H1/H2: half-coverage begins to hurt as multi-space workflows appear.
- H3-FLAT: heterogeneity has grown; a "clean-up refactor" is starting to be
  named.
- H3-SPLIT: reviewer discipline established; adding entries is routine.
- H4/H5: a `CAPABILITY_REGISTRY.md` has been drafted; the Owner has had to
  invent 3–5 capability names and their relations to artifacts. Debt begins.

### 24.3 6 MONTHS `[INFERENCE]`

- H3-FLAT: category mixing has produced at least one ambiguous entry that
  reviewers disagree on. ARCH-007-style cleanup discussion emerges.
- H3-SPLIT: cross-cutting workflows have been modeled as `type: compound` two
  or three times; the pattern is settled.
- H4/H5: DEC-07 F2/F3 opens; the capability layer either matures into a real
  binding discipline (making runtime enforcement tempting → creeps into
  §7.2-violating territory) or falls into disuse.

### 24.4 12 MONTHS `[INFERENCE]`

- H3-SPLIT: stable governance object; DEC-04/DEC-05/DEC-08 unaffected;
  DEC-REVIEWER-VERDICT references entries directly.
- H4/H5: either the capability layer has proven load-bearing (unlikely on
  today's evidence) or the CCP has an unused ontology layer that has to be
  retired.

---

## 25. Impact on DEC-02 / DEC-04 / DEC-05 (and neighbors)

Per master prompt §22-bis.

### 25.1 DEC-02 direct

- **H3-SPLIT** cleanly closes the "target ambiguity" concern without changing
  R/V/Q/P mechanics.
- **H4/H5** introduce a new governance layer that DEC-02's revised gate §7.2
  explicitly warns against absorbing.

### 25.2 DEC-04 D-CANONICAL

- Independent (revised gate §12 claim 18). No target-shape choice affects
  canonical policy format.
- Weak coupling: if H4 were adopted, DEC-04 might feel pressure to model
  policy-family-as-capability. That is exactly the kind of shadow-path
  contamination the master prompt §22-bis asks to flag. **Flag raised.**

### 25.3 DEC-05 D-MOTOR

- Independent. No coupling under any hypothesis.

### 25.4 DEC-07 D-VERIFICADOR

- **H3-SPLIT** provides `code-reviewer.md`-shaped delegation entries that
  DEC-07 F2/F3 can reference verbatim as authorization anchors.
- **H4** would provide "verify-code capability" bindings — cleaner surface
  language but no corpus base.
- **DEC-07 F1 and F4** are independent of DEC-02 target shape.

### 25.5 DEC-REVIEWER-VERDICT

- Governed by an existing 6-layer emission structure (EXP-D §10.3).
- **H3-SPLIT** references the reviewer-agent artifact directly; verdict emission
  path is unchanged.
- **H4** would introduce a "reviewer capability" layer whose binding to the
  6-layer structure is not obvious. Complexity risk.

### 25.6 DEC-STREAM-CONSUMER

- Independent under any hypothesis.

### 25.7 ARCH-005, ARCH-006, ARCH-007

- ARCH-005: unaffected by target shape; ARCH-005 provides the deferral trigger
  pattern for R0-D0 regardless.
- ARCH-006: **H4/H5 create latent pressure on AUTHORITY_KIND.** If capabilities
  become named authority-holders, VOCAB-A comes under revisionist pressure,
  which ARCH-006 §6 prohibits without formal reopening. This is a
  precedent-lock-in risk H3-SPLIT does not carry.
- ARCH-007: **H3-FLAT reproduces the ARCH-007 anti-pattern.** ARCH-007's
  lesson (heterogeneous vocabularies are a category error) is directly
  applicable.

### 25.8 Shadow-path summary

- H4/H5 shadow-paths: pressure on ARCH-006 vocab, pressure toward runtime
  enforcement, contamination of DEC-04/DEC-07/DEC-REVIEWER-VERDICT with a
  capability layer that has no evidence base.
- H3-FLAT shadow-path: ARCH-007-style cleanup debt.
- H3-SPLIT shadow-path: minimal — small verbosity, honest UNKNOWNs for
  harness-runtime types.

---

## 26. Owner Decision Space

The audit does not select an option. The following is the *revised* Owner
decision surface with the hypotheses this audit examined mapped into the
existing DEC-02 dimensional structure.

### 26.1 Owner Question (revised)

> **Which shape best represents the semantic target of a DEC-02 delegation
> entry, given that CAPABILITY is not present in the CCP corpus and that
> SKILL and AGENT are two orthogonal artifact spaces already?**

### 26.2 Options for the Owner

- **Option A — R0-D0 (DEFER with observable trigger)**
  - Meaning: no explicit delegation representation; DEC-02 deferred under
    ARCH-005 pattern with `trigger:` blocks (e.g., "first material incident
    attributed to implicit delegation" and "DEC-07 F2/F3 opens").
  - Evidence: E-10 (no incidents), E-12 (ARCH-005 pattern available).
  - Benefit: zero lock-in; preserves optionality.
  - Risk: `convención`-authority ambiguity persists; workflow bottleneck
    unaddressed at the documentation layer.
  - Reversibility: HIGH.
  - What it enables: keeping the semantic question open until a triggering
    observation.
  - What it constrains: DEC-07 F2/F3, if opened before the trigger, must fall
    back to implicit delegation.
  - Conditions that would change: an incident, or DEC-07 F2/F3 opens.

- **Option B — R0-D1 (RETIRE)**
  - Meaning: accept K3-D-OWNER-DEFAULT as permanent documented default; no
    delegation object materialized.
  - Evidence: E-10 (no incidents).
  - Benefit: minimal governance surface.
  - Risk: locks the bottleneck as design intent; culturally hard to reverse.
  - Reversibility: technically HIGH, culturally MEDIUM.
  - What it enables: simplicity.
  - What it constrains: everything downstream that would benefit from a
    delegation reference.

- **Option C — R1 with H3-SPLIT (K2', preferred-by-evidence)**
  - Meaning: docs-only delegation entries with an explicit `type: agent |
    skill | compound` field, first-class artifact references, optional
    `stable_role` label, and existing AUTHORITY_KIND classes for
    authority binding.
  - Evidence: E-01, E-02, E-06, E-07, E-08, E-11.
  - Benefit: matches corpus semantics without new ontology; anti-mirrors
    ARCH-007 lesson.
  - Risk: slight verbosity; requires reviewer discipline to consult entries.
  - Reversibility: HIGH.
  - What it enables: DEC-07 F2/F3 governance anchor; cleaner
    DEC-REVIEWER-VERDICT surface; ARCH-005-pattern activation/revocation
    natively.
  - What it constrains: nothing outside DEC-02 scope; does not force
    runtime.
  - Conditions that would change: a K3 alternative surfaces with real corpus
    evidence.

- **Option D — R1 with H3-FLAT (K2 as currently written)**
  - Meaning: current K2 wording — one path field, skill or agent.
  - Evidence: E-07 (the flag is in the option itself).
  - Benefit: minimum drafting cost.
  - Risk: reproduces ARCH-007 D-CATALOG anti-pattern; heterogeneity
    accumulates silently.
  - Reversibility: MEDIUM — retrofitting `type:` field to existing entries
    later is a schema evolution, tolerable but not free.
  - What it enables: fast start.
  - What it constrains: future clarity.
  - Conditions that would change: retrofit becomes urgent when an ambiguous
    entry emerges.

- **Option E — R1 with H1 alone**
  - Meaning: delegation entries only for actor-shaped delegations
    (agent-space); skill-shaped delegations remain implicit.
  - Evidence: E-01, E-06.
  - Benefit: cleanest for actor-side.
  - Risk: half-coverage; skill delegations require separate treatment or
    live as UNKNOWN.
  - Reversibility: HIGH.
  - What it enables: agent-focused governance.
  - What it constrains: skill-space delegations.

- **Option F — R1 with H2 alone**
  - Symmetric to Option E on the skill side. Same trade-offs.

- **Option G — R1 with H4 (CAPABILITY) or H5 (HYBRID)**
  - Meaning: introduce CAPABILITY as a governance object; delegation entries
    reference capabilities and (in H5) their concrete artifact bindings.
  - Evidence: **NONE for the existence of CAPABILITY in the CCP corpus (§10.4).**
  - Benefit (proposed): substitution stability under implementation churn.
  - Risk: introduces a new ontology layer without evidence base; creates
    downstream pressure on ARCH-006, DEC-07, DEC-REVIEWER-VERDICT; invites
    runtime authorization drift.
  - Reversibility: LOW-MEDIUM once entries reference capabilities.
  - What it enables: a proposed abstraction stability that Option C
    approximates via `stable_role` labels.
  - What it constrains: many neighboring decisions.
  - **Owner note**: this audit's technical provisional conclusion labels G as
    `NOT SUPPORTED BY EVIDENCE`. The Owner may still choose G — the choice is
    Owner authority — but should be aware that the underlying object does not
    exist in the corpus today.

### 26.3 Preferred-by-evidence (technical provisional conclusion)

**Option C (R1 with H3-SPLIT)** is preferred-by-evidence among R1 options.
**Option A (R0-D0)** is a fully coherent alternative if the Owner does not
yet want to commit to any R1 shape. **Option G (H4/H5)** is presented for
completeness but flagged as unsupported by corpus evidence.

This provisional conclusion is **not** an Owner choice.

### 26.4 What the Owner must decide

- Whether to move on DEC-02 target shape now (Options C, D, E, F) or defer
  (Option A) or retire (Option B).
- If moving now, which shape.
- If choosing R1, whether to also commit at this gate to V/Q/P sub-choices
  (per revised gate §18) or hold them for a follow-up.

### 26.5 What the Owner must NOT decide here

- DEC-07 opening (§16 of revised gate).
- Runtime enforcement (§7.2 of revised gate).
- Any DEC-04/05/03/08/12/STREAM-CONSUMER content.
- AUTHORITY_KIND modification.

---

## 27. Conditions That Would Change the Analysis

- **A corpus-evidence bearing on CAPABILITY appears.** If a canonical
  artifact (not this audit, not the diagnostic grammar) starts referring to
  capabilities as first-class objects, H4 would need re-audit.
- **A DEC-07 F2/F3 formulation is authored** that concretely benefits from a
  capability layer beyond what H3-SPLIT provides. Would move H4 from
  `speculative` toward `latent`.
- **A material delegation incident occurs.** Would move R0-D0/D1 toward R1
  automatically.
- **A new artifact space appears** alongside `.claude/agents/` and
  `.claude/skills/` (for example, a `.claude/workflows/`), turning the
  two-space closure into three-space. H3-SPLIT accommodates trivially; H1/H2
  do not.
- **The Owner declares S2/S3 scaling imminent.** Would raise the value of
  documented delegation, favoring Options C over A.

---

## 28. Final Audit Verdict

- **What is established**
  - `AUTHORITY_KIND` provides `agente` as an existing class native to actor-
    shaped delegation (E-03, E-08). `HIGH`.
  - Skills and agents are two orthogonal first-class artifact spaces in the
    CCP (E-01, E-02, §4.1–4.2). `HIGH`.
  - K2 as currently written flattens two semantic categories (E-07). `HIGH`.
  - CAPABILITY does not exist as a first-class object in the CCP corpus
    (§4.4, E-03, E-04, E-05). `HIGH`.
  - PRIM excavation found no CAPABILITY primitive (E-04). `HIGH`.
  - H3-FLAT reproduces the ARCH-007 anti-pattern (E-11). `HIGH`.

- **What is probable**
  - H3-SPLIT covers observed CCP semantics with minimal ontology and low
    lock-in. `HIGH` (evidence-anchored across §7–§18).
  - H4 adopted would generate ARCH-006 vocab pressure and DEC-07 shadow-path
    contamination. `MODERATE-HIGH` (inference from architectural coupling).
  - R0-D0 remains coherent as a defer with ARCH-005 pattern. `HIGH`.

- **What remains uncertain**
  - Whether harness-runtime types will need entries under Option C. Would be
    handled as `UNKNOWN` residuals; not a blocker. `LOW-MEDIUM` risk.
  - Whether cross-cutting workflows will need `type: compound` beyond
    evidence-registration. `LOW-MEDIUM`.
  - Whether the Owner is planning S2/S3 scaling in the DEC-02 horizon.
    `[UNKNOWN]`.

- **What is not supported**
  - H4 CAPABILITY existence in current CCP. `HIGH` on the negative.
  - H5 HYBRID as a distinct option beyond H3 under current evidence. `HIGH`
    on the collapse.

- **What must be decided by the Owner**
  - The Owner Question in §26.1: which target shape (Options A–G).
  - Whether to run EXP-DEC02-SEM (§22) before choosing among C/D/E/F.

- **What can be deferred**
  - V/Q/P sub-choices under any R1 option, if the Owner wants to close the
    R and K dimensions first.
  - The compound-entry pattern under Option C, until a case actually appears.

**DEC-02 READINESS: `READY_FOR_OWNER_CHOICE`.**

Rationale: the two HIGH-VoI uncertainties (whether CAPABILITY exists in the
corpus; whether SKILL/AGENT are semantically distinct) are both resolved
within this audit. All remaining uncertainties are either LOW-VoI or Owner-
knowable. The revised option surface (§26.2) is defensible.

---

## 29. Open Questions

Preserved as `[UNKNOWN]` rather than answered by inference.

- **OQ-1**: does the Owner plan S2/S3 scaling within the next two horizons?
  Affects Option-C urgency.
- **OQ-2**: is DEC-07 F2/F3 in the Owner's near-term horizon?
  Affects Option-A viability.
- **OQ-3**: does the harness runtime provide a canonical way to reference
  runtime-only types (fork, Explore, Plan) that a delegation entry could use
  instead of `UNKNOWN` residuals?
- **OQ-4**: are there any candidate K3 shapes that this audit did not
  consider because they don't appear in the primary sources?
- **OQ-5**: is EXP-DEC02-SEM (§22) worth running before Owner choice, or
  only after?

None of the OQ items block Owner choice.

---

## 30. Evidence References

Traceable claims by anchor.

- **AUTHORITY_KIND VOCAB-A** — `docs/00_SYSTEM/AUTHORITY_KIND.md`, ARCH-006
  (grep confirmed 0 hits for capability/capabilities in that file).
- **PRIM excavation** — `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md §11`
  (PRIM-1 AUTHORITY-KIND, PRIM-2 CONTRACT, PRIM-3 DERIVATION, PRIM-4
  LIFECYCLE, PRIM-5 PROVENANCE, PRIM-6 INVARIANT-TEST, PRIM-7 HUMAN-SINK).
- **Diagnostic grammar** — `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md §13`
  (`AUTHORITY × CONTRACT × MECHANISM × EVIDENCE = CONTROLLED CAPABILITY`).
- **Two-space observation** — `.claude/agents/` (5 files) and
  `.claude/skills/` (~23 directories) at HEAD `e529359`.
- **11-item ACTION_TYPE heterogeneity** —
  `docs/00_SYSTEM/DEC-02_D-DELEG_DECISION_GATE_REVISED.md §6.1`.
- **K2 wording and gap flags** — `§6.2` same file.
- **Six delegation senses** — `§4` same file.
- **Governance loop per stage** — `§10.2` same file.
- **Evidence matrix and DEC-02 orthogonality claim** — `§12` claim 18 same
  file.
- **ARCH-005 pattern availability** — DEC-11 checkpoint `cd0511c`.
- **ARCH-006 VOCAB-A closed** — DEC-AUTH-BOUNDARY checkpoint `473759c`.
- **ARCH-007 lesson** — DEC-01 D-CATALOG closure `e529359`.
- **DEC-02 formulability without D-CATALOG** — `EXP_A_EXP_D_RESULTS_
  POST_ARCH007.md`.
- **Reviewer-verdict 6-layer coverage** — same file, §10.

---

## 31. Anti-Bias Check

Per master prompt §32. Answered explicitly.

- **Did we assume CAPABILITY before proving it exists?** No — CAPABILITY was
  tested for existence in §4.4 and §10.4 and failed the corpus-evidence
  test.
- **Did we conflate semantic target with implementation reference?** No — §22
  proposes `stable_role` as a *label* on H3-SPLIT entries precisely to
  separate the substitution intuition from the reference itself.
- **Did we conflate AGENT with SKILL?** No — §4.1–4.2 keeps them distinct;
  §6 grounds the distinction in corpus.
- **Did we accidentally authorize runtime?** No — the audit repeatedly
  restates docs-only; §14 explicitly flags H4/H5 as *inviting* runtime creep
  and warns against it.
- **Did we accidentally close DEC-02?** No — §26.5 preserves Owner choice;
  §28 declares `READY_FOR_OWNER_CHOICE`, not `CLOSED`.
- **Did we introduce a new abstraction without evidence?** No — H3-SPLIT is
  a refinement of an already-observed distinction, not a new object; H4/H5
  are explicitly labeled speculative.
- **Did we optimize elegance over reversibility?** No — H3-SPLIT was chosen
  precisely on reversibility grounds.
- **Did we miss an existing CCP primitive that already solves this?** Not to
  our knowledge — §6 audits the existing model; §11 references PRIM-1..7.
- **Did we mistake serialization for semantics?** No — §24 explicitly
  discusses ARTIFACT-REFERENCE as an addressing mechanism versus a semantic
  claim.
- **Did we leave an unresolved ambiguity hidden inside HYBRID?** No — §11
  explicitly unpacks HYBRID and shows it collapses.

---

## 32. Confidence Summary

- **CAPABILITY not present in CCP corpus**: `VERY HIGH` (90–100%). Basis:
  grep across three canonical registries returned zero hits; PRIM
  excavation missed it; only appearance is a grammar output.
- **H4/H5 not supported by evidence**: `HIGH` (80–89%). Basis: the above
  plus §10.3–10.4 audit.
- **H3-SPLIT preferred-by-evidence among R1 options**: `HIGH` (80–89%).
  Basis: §6, §9, §12, §13, §15, §17, §18, §23 all converge.
- **R0-D0 (DEFER with observable trigger) remains coherent**: `HIGH` (80–89%).
  Basis: E-10 (no incidents), E-12 (ARCH-005 pattern), §21.3 falsifiers.
- **DEC-02 READY_FOR_OWNER_CHOICE**: `HIGH` (80–89%). Basis: two HIGH-VoI
  uncertainties resolved; residuals are Owner-knowable.

---

## 33. Non-Modification Attestation

This audit did not modify:

- `docs/00_SYSTEM/AUTHORITY_KIND.md`
- `docs/00_SYSTEM/DECISION_REGISTRY.md`
- `docs/00_SYSTEM/DECISION_HISTORY.md`
- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`
- `docs/00_SYSTEM/DEC-02_D-DELEG_DECISION_GATE_REVISED.md`
- `docs/00_SYSTEM/DEC-02_D-DELEG_OPENED.md`
- `docs/00_SYSTEM/MASTER_HANDOFF.md`
- `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md`
- `PROJECT_STATE.md`
- `ARTIFACT_MANIFEST.md`
- `.claude/*` (any subtree)

This audit is a **Stratum-C, non-canonical** analytical artifact. Its
persistence is at Owner discretion.

---

**END — DEC-02 TARGET SEMANTICS AUDIT — awaiting Owner Choice on §26.**
