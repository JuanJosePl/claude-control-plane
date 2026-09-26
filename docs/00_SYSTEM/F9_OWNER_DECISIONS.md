# F9 Owner Decision Record - Claude Control Plane

**Status:** `F9 OWNER DECISION GATE = CLOSED`
**Decision date:** 2026-09-20
**Owner:** human/@owner
**Baseline HEAD at closure:** `05c78ac151ed80e7ef8218541e2fce42cd221730`
**F9 research reference:** `docs/00_SYSTEM/F9_RESEARCH.md` (commit `bfe03b7`)
**F8 closure checkpoint:** `2cd7953`
**F7 checkpoint:** `47874a5`

> This document is documentation-only. It records the owner's resolution of the
> five decision surfaces opened by `F9_RESEARCH.md §14`. It does not authorize
> runtime, hook, fixture, evidence, regression, agent, skill, rule, dependency,
> registry or architectural changes.

---

## 1. Purpose

`F9_RESEARCH.md §14` opened five decisions (F9-D01..F9-D05) for owner review.
The research concluded `F9 NOT JUSTIFIED` and defined `IMPLEMENTATION_AUTHORIZED
= NO`. This record closes the owner decision gate with the values the owner
selected on 2026-09-20 and records the reactivation triggers each decision
defines.

The record does not reopen F7, F8, or the F9 research conclusion. It does not
create a new phase, a new registry, a new control, or a new architectural
concept. It does not modify any historical evidence or regression entry.

---

## 2. Owner Decision Record

```text
F9-D01 = A     Keep F9 implementation closed
F9-D02 = B     Defer native Claude Code evidence until concrete trigger
F9-D03 = B     Keep documentary candidates deferred
F9-D04 = B     Require external requirement trigger for integrity work
F9-D05 = A     Keep F10-F12 UNKNOWN / RESEARCH REQUIRED
```

---

## 3. Decision Details

### F9-D01 = A - Keep F9 implementation closed

**Question closed:** Should any F9 runtime implementation be authorized after
the research?

**Resolution:** No F9 runtime implementation is authorized. F7 and F8 runtime,
evidence, regressions, checkpoints and reports remain frozen. No deferred
candidate is promoted to implementation.

**Consequences:**

- `F9_IMPLEMENTATION = NOT AUTHORIZED / NOT PERFORMED` stands as the current
  authoritative state.
- Any future implementation must start from a new, concrete, evidenced
  problem with an explicit contract, reversible scope, tests, evidence,
  regression and independent review before code.
- Current controls (`bash-firewall.sh`, `secret-guard.sh`,
  `task-completed-evidence.sh`, deterministic fixtures, maintenance suite,
  Git + reviewer trust boundary) remain the declared enforcement surface.

**Reactivation triggers (not authorizations):**

- A reproducible incident that a current control does not cover.
- A firewall bypass that survives F8 fixtures.
- A tool failure demonstrably lost by the manual `/incident open` workflow.
- A deterministic native reproduction of the G-B11 phantom `SubagentStop`
  entries.
- Any of the triggers listed under F9-D02 or F9-D04 producing evidence that
  crosses a phase threshold.

<!-- deferral-triggers:
scope: f9
deferral: d01
combine: ANY
note: |
  Source bullet 5 ("Any of the triggers listed under F9-D02 or F9-D04
  producing evidence that crosses a phase threshold") is a compound: a set of
  ten alternative LINK targets, each gated by the additional condition
  "producing evidence that crosses a phase threshold". Per DEFERRAL_POLICY.md
  §5.1, each split is assigned the next positive integer; the condition is
  preserved verbatim in every LINK trigger's predicate. Yielding T5..T14 for
  the ten F9-D02+F9-D04 targets.
triggers:
  - id: f9.d01.T1
    type: EVENT
    predicate: "A reproducible incident that a current control does not cover."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 1"
  - id: f9.d01.T2
    type: EVENT
    predicate: "A firewall bypass that survives F8 fixtures."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 2"
  - id: f9.d01.T3
    type: EVENT
    predicate: "A tool failure demonstrably lost by the manual /incident open workflow."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 3"
  - id: f9.d01.T4
    type: EVENT
    predicate: "A deterministic native reproduction of the G-B11 phantom SubagentStop entries."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 4"
  - id: f9.d01.T5
    type: LINK
    predicate: "F9-D02 T1 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 1/10)"
    link: f9.d02.T1
  - id: f9.d01.T6
    type: LINK
    predicate: "F9-D02 T2 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 2/10)"
    link: f9.d02.T2
  - id: f9.d01.T7
    type: LINK
    predicate: "F9-D02 T3 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 3/10)"
    link: f9.d02.T3
  - id: f9.d01.T8
    type: LINK
    predicate: "F9-D02 T4 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 4/10)"
    link: f9.d02.T4
  - id: f9.d01.T9
    type: LINK
    predicate: "F9-D04 T1 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 5/10)"
    link: f9.d04.T1
  - id: f9.d01.T10
    type: LINK
    predicate: "F9-D04 T2 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 6/10)"
    link: f9.d04.T2
  - id: f9.d01.T11
    type: LINK
    predicate: "F9-D04 T3 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 7/10)"
    link: f9.d04.T3
  - id: f9.d01.T12
    type: LINK
    predicate: "F9-D04 T4 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 8/10)"
    link: f9.d04.T4
  - id: f9.d01.T13
    type: LINK
    predicate: "F9-D04 T5 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 9/10)"
    link: f9.d04.T5
  - id: f9.d01.T14
    type: LINK
    predicate: "F9-D04 T6 producing evidence that crosses a phase threshold."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D01 · Reactivation triggers bullet 5 (split 10/10)"
    link: f9.d04.T6
-->

### F9-D02 = B - Defer native Claude Code evidence

**Question closed:** When should native Claude Code lifecycle evidence be
obtained?

**Resolution:** No native-runtime probe is executed now. The label

```text
NATIVE CLAUDE CODE LIFECYCLE = NOT VERIFIED
```

remains a knowledge boundary, not a runtime defect claim. The absence of
native evidence is accepted; no reinterpretation to `BROKEN` is authorized.

**Consequences:**

- No disposable environment is spun up now.
- OpenCode-executed scripts and fixtures remain the current verification
  surface, labelled `SCRIPT VERIFIED`.
- `F9_RESEARCH.md §9` remains the reference method if a future trigger
  authorizes a native probe.

**Reactivation triggers:**

- Deterministic recurrence of the G-B11 phantom `SubagentStop` events.
- A tool failure demonstrably lost by the manual incident workflow.
- A native integration decision that depends on dispatcher, matcher,
  ordering, payload shape, or re-entry facts.
- Any other reproducible problem whose resolution requires native lifecycle
  evidence.

<!-- deferral-triggers:
scope: f9
deferral: d02
combine: ANY
triggers:
  - id: f9.d02.T1
    type: EVENT
    predicate: "Deterministic recurrence of the G-B11 phantom SubagentStop events."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D02 · Reactivation triggers bullet 1"
  - id: f9.d02.T2
    type: EVENT
    predicate: "A tool failure demonstrably lost by the manual incident workflow."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D02 · Reactivation triggers bullet 2"
  - id: f9.d02.T3
    type: CONDITION
    predicate: "A native integration decision that depends on dispatcher, matcher, ordering, payload shape, or re-entry facts."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D02 · Reactivation triggers bullet 3"
  - id: f9.d02.T4
    type: CONDITION
    predicate: "Any other reproducible problem whose resolution requires native lifecycle evidence."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D02 · Reactivation triggers bullet 4"
-->

### F9-D03 = B - Keep documentary candidates deferred

**Question closed:** How should the documentary candidates G-S1, G-S2,
G-Bob-1, G-A1, G-N1 and G-N2 be handled now?

**Resolution:** Keep deferred:

```text
G-S1     Rollback smoke test
G-S2     Rollback command clarity
G-Bob-1  Fixture acceptance labelling
G-A1     Placeholder context packs (installer template semantics preserved)
G-N1     Manual runtime revalidation cadence
G-N2     Session-log retention policy
```

No micro-tasks are opened now. The roadmap is not "cleaned" as an activity
of its own. Historical rationale remains preserved in
`F9_RESEARCH.md §6.8-§6.13`, `POST_F6_AUDIT_REPORT.md`,
`MASTER_EVOLUTION_ROADMAP.md` and `F7_F8_F9_TECHNICAL_HISTORY.md §25`.

**Reactivation triggers (per item):**

- G-S1 / G-S2: a real rollback that fails, or an owner-approved recovery
  validation micro-task.
- G-Bob-1: an evaluator or maintainer misread caused by the missing
  semantic header.
- G-A1: a maintainer confusing the control-plane installer template with a
  configured project pack.
- G-N1: a drift or stale system detected because a manual revalidation
  cadence was missed.
- G-N2: a real disk-usage, retention or consumer requirement.

<!-- deferral-triggers:
scope: f9
deferral: d03
note: "Six sub-items; each carries its own triggers per source prose. IDs use <deferral-id>.<sub-slug>.T<index> per DEFERRAL_POLICY.md §4."
sub-items:
  - deferral: d03.gs1
    combine: ANY
    triggers:
      - id: f9.d03.gs1.T1
        type: EVENT
        predicate: "A real rollback that fails."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-S1/G-S2 (split OR-branch 1)"
      - id: f9.d03.gs1.T2
        type: EVENT
        predicate: "An owner-approved recovery validation micro-task."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-S1/G-S2 (split OR-branch 2)"
  - deferral: d03.gs2
    combine: ANY
    triggers:
      - id: f9.d03.gs2.T1
        type: EVENT
        predicate: "A real rollback that fails."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-S1/G-S2 (split OR-branch 1)"
      - id: f9.d03.gs2.T2
        type: EVENT
        predicate: "An owner-approved recovery validation micro-task."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-S1/G-S2 (split OR-branch 2)"
  - deferral: d03.gbob1
    combine: null
    triggers:
      - id: f9.d03.gbob1.T1
        type: EVENT
        predicate: "An evaluator or maintainer misread caused by the missing semantic header."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-Bob-1"
  - deferral: d03.ga1
    combine: null
    triggers:
      - id: f9.d03.ga1.T1
        type: EVENT
        predicate: "A maintainer confusing the control-plane installer template with a configured project pack."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-A1"
  - deferral: d03.gn1
    combine: null
    triggers:
      - id: f9.d03.gn1.T1
        type: CONDITION
        predicate: "A drift or stale system detected because a manual revalidation cadence was missed."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-N1"
  - deferral: d03.gn2
    combine: null
    triggers:
      - id: f9.d03.gn2.T1
        type: EVENT
        predicate: "A real disk-usage, retention or consumer requirement."
        provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D03 · Reactivation triggers, item G-N2"
-->

### F9-D04 = B - External requirement trigger for integrity work

**Question closed:** What trigger should be required before revisiting
artifact-hash recomputation (A-05), hook self-modification detection
(A-07/G-N4/G-B10), or registry append-only enforcement (G-N5)?

**Resolution:** No implementation of A-05, A-07, G-N5 or equivalent
trust-boundary expansions is authorized now. The current Git + human
reviewer trust boundary remains the declared enforcement surface at this
scale.

These controls may be reconsidered only when an explicit, verifiable
external requirement exists.

**Reactivation triggers:**

- External audit.
- Compliance obligation.
- Contractual requirement.
- Explicit customer requirement.
- Owner-approved expansion of the trust boundary.
- Organizational change that makes the current boundary insufficient.

**Constraint on any future reactivation:**

An external trigger does not authorize implementation automatically. It
authorizes research first, which must establish threat model, missing
control, and proportional scope before any code, contract, or new phase is
opened.

<!-- deferral-triggers:
scope: f9
deferral: d04
combine: ANY
constraint: "An external trigger authorizes RESEARCH first, not implementation. Threat model, missing control, and proportional scope must be established before any code, contract, or new phase is opened."
constraint-provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D04 · Constraint on any future reactivation"
triggers:
  - id: f9.d04.T1
    type: EVENT
    predicate: "External audit."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D04 · Reactivation triggers bullet 1"
  - id: f9.d04.T2
    type: EVENT
    predicate: "Compliance obligation."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D04 · Reactivation triggers bullet 2"
  - id: f9.d04.T3
    type: EVENT
    predicate: "Contractual requirement."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D04 · Reactivation triggers bullet 3"
  - id: f9.d04.T4
    type: EVENT
    predicate: "Explicit customer requirement."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D04 · Reactivation triggers bullet 4"
  - id: f9.d04.T5
    type: EVENT
    predicate: "Owner-approved expansion of the trust boundary."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D04 · Reactivation triggers bullet 5"
  - id: f9.d04.T6
    type: CONDITION
    predicate: "Organizational change that makes the current boundary insufficient."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D04 · Reactivation triggers bullet 6"
-->

### F9-D05 = A - Keep F10-F12 unknown

**Question closed:** Should F10-F12 remain undefined until new evidence
appears?

**Resolution:** Keep them unknown and research-required:

```text
F10 = UNKNOWN / NOT STARTED
F11 = UNKNOWN / NOT STARTED
F12 = UNKNOWN / NOT STARTED
```

No phase contracts are defined pre-emptively from roadmap themes. No
assumption is made that the next necessity must be named F10.

**Consequences:**

- If a future problem crosses a phase threshold, the naming decision is
  taken at that point: it may be `F10`, `F9-b`, a dedicated `ADR`, a
  micro-phase, or another structure depending on the actual size and shape
  of the problem.
- Nothing in this record commits to any particular future phase count,
  scope or naming.

**Reactivation triggers:**

- A concrete, evidenced problem that requires runtime work at phase scale.
- An external requirement (per F9-D04) that brings its own
  problem+evidence contract.

<!-- deferral-triggers:
scope: f9
deferral: d05
combine: ANY
note: |
  Source bullet 2 ("An external requirement (per F9-D04) that brings its own
  problem+evidence contract") is a compound: a set of six alternative LINK
  targets (F9-D04 T1..T6), each gated by the additional condition "brings its
  own problem+evidence contract". Per DEFERRAL_POLICY.md §5.1, each split is
  assigned the next positive integer; the condition is preserved verbatim in
  every LINK trigger's predicate. Yielding T2..T7 for the six F9-D04 targets.
triggers:
  - id: f9.d05.T1
    type: EVENT
    predicate: "A concrete, evidenced problem that requires runtime work at phase scale."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D05 · Reactivation triggers bullet 1"
  - id: f9.d05.T2
    type: LINK
    predicate: "An external requirement (F9-D04 T1) that brings its own problem+evidence contract."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D05 · Reactivation triggers bullet 2 (split 1/6)"
    link: f9.d04.T1
  - id: f9.d05.T3
    type: LINK
    predicate: "An external requirement (F9-D04 T2) that brings its own problem+evidence contract."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D05 · Reactivation triggers bullet 2 (split 2/6)"
    link: f9.d04.T2
  - id: f9.d05.T4
    type: LINK
    predicate: "An external requirement (F9-D04 T3) that brings its own problem+evidence contract."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D05 · Reactivation triggers bullet 2 (split 3/6)"
    link: f9.d04.T3
  - id: f9.d05.T5
    type: LINK
    predicate: "An external requirement (F9-D04 T4) that brings its own problem+evidence contract."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D05 · Reactivation triggers bullet 2 (split 4/6)"
    link: f9.d04.T4
  - id: f9.d05.T6
    type: LINK
    predicate: "An external requirement (F9-D04 T5) that brings its own problem+evidence contract."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D05 · Reactivation triggers bullet 2 (split 5/6)"
    link: f9.d04.T5
  - id: f9.d05.T7
    type: LINK
    predicate: "An external requirement (F9-D04 T6) that brings its own problem+evidence contract."
    provenance: "docs/00_SYSTEM/F9_OWNER_DECISIONS.md §3.F9-D05 · Reactivation triggers bullet 2 (split 6/6)"
    link: f9.d04.T6
-->

---

## 4. Scope Of This Record

**Authorized by this record:**

- Documentation of the five owner decisions.
- Update of `PROJECT_STATE.md`, its compact mirror `.claude/context/CURRENT_STATE.md`,
  and `docs/00_SYSTEM/SESSION_HANDOFF_CURRENT.md` to reflect the closed
  gate.
- Creation of this record file.

**Not authorized by this record:**

- Any runtime, hook, fixture, evidence, regression, agent, skill, rule,
  dependency, registry, or architecture change.
- F9 implementation.
- Opening of F10 or any successor phase.
- Immediate native-runtime research.
- Reinterpretation of `NOT_VERIFIED` as `BROKEN`.
- Modification of F7 or F8 historical artifacts.
- Modification of `F9_RESEARCH.md` beyond references to this record.
- Any scope expansion.

---

## 5. Historical Preservation

The following remain frozen and unchanged by this record:

- F7 runtime, evidence (EV-001..EV-014), regressions (REG-001..REG-009),
  checkpoint `47874a5`, reports and audits.
- F8 runtime, evidence (EV-015, EV-016), regressions (REG-010, REG-011),
  closure checkpoint `2cd7953`, post-audit, claim-vs-evidence and
  provenance documents.
- The F9 research conclusion (`F9 NOT JUSTIFIED`) and the research
  document `F9_RESEARCH.md` at commit `bfe03b7`.
- The reconciliation commit `05c78ac` and the technical history dossier at
  commit `9a52875`.

Historical evidence hash for EV-001..EV-014 remains
`sha256:23325ab6...` and is not recomputed or altered.

---

## 6. Verification At Closure

- `git status` reported CLEAN before edits related to this record.
- HEAD before this record: `05c78ac151ed80e7ef8218541e2fce42cd221730`.
- Runtime files touched by this record: **none**.
- Hook files touched by this record: **none**.
- Fixture files touched by this record: **none**.
- Evidence or regression entries added by this record: **none**.
- Registries added by this record: **none**.
- Architecture concepts added by this record: **none**.

Change classification for every path modified in this closure:

```text
DOCUMENTATION ONLY
```

---

## 7. Resulting Project State

```text
F7                       = COMPLETE / FROZEN
F8                       = COMPLETE / FROZEN
F9 RESEARCH              = COMPLETE
F9 DECISION              = F9 NOT JUSTIFIED
F9 IMPLEMENTATION        = NOT AUTHORIZED / NOT PERFORMED
F9 OWNER DECISION GATE   = CLOSED (2026-09-20)
NATIVE CLAUDE CODE       = NOT VERIFIED
F10-F12                  = UNKNOWN / NOT STARTED
WORKTREE                 = CLEAN (post-closure commit)
NEXT ACTION              = NEW OWNER-DRIVEN PROJECT DECISION ONLY
```

---

**END F9 OWNER DECISION RECORD**
