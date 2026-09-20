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
