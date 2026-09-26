# DEFERRAL POLICY

> **Authority:** ARCH-005 (DEC-11 HYB-FINAL-v4, OWNER_CHOSEN 2026-09-26).
> **Nature:** Documentation-only representation policy for Owner-authorized
> deferrals. Not a runtime, not a hook, not a registry, not a maintenance
> integration.
>
> **Canonical formal decision:** see `DECISION_REGISTRY.md#ARCH-005`.
> **Empirical baseline:** see `docs/00_SYSTEM/DEFERRAL_INVENTORY.md` (EXP-1).

---

## 1. Purpose

Formalize the representation of reactivation triggers attached to
Owner-authorized deferrals so that:

1. Every existing trigger already articulated in prose becomes machine-readable
   as a literal mapping (no new predicates invented).
2. LINK relationships between deferrals are explicit and resolvable.
3. Future deferrals inherit a stable, minimal schema.

Nothing else. The policy does not enforce anything at runtime, does not create a
parallel registry, does not schedule reviews, does not lint automatically, and
does not modify the semantics of any historical decision.

---

## 2. Invariants

The following invariants apply to every retrofit and to every future deferral
using this format:

- **INV-1** — Normalization of representation is not semantic change and is
  not decision reopening. Retrofitting existing prose into a YAML block is a
  literal mapping.
- **INV-2** — The policy is docs-only. No runtime, no hooks, no skills, no
  `evals/maintenance.sh` integration, no automated lint, no mandatory periodic
  review.
- **INV-3** — This policy does not authorize implementation of any deferred
  candidate. The Owner decision gates governing each deferral remain the sole
  authorization surface.
- **INV-4** — HYPOTHESIS-tier deferrals (currently NH-11 and G-L1) are exempt
  from the mandatory retrofit. Their `deferral-triggers:` block, if present,
  MUST be `null` with an explicit note; no trigger predicate is invented.
- **INV-5** — Reversibility is `git revert` of the retrofit commit. The
  underlying documents and decisions remain intact after revert.

---

## 3. Vocabulary (Closed Set)

Only these five `type:` values are allowed. Any candidate that does not fit
one of these is not a canonical trigger and MUST be recorded under `related:`
(see §5) or left absent.

| `type`      | Meaning                                                                                     |
|-------------|---------------------------------------------------------------------------------------------|
| `EVENT`     | A specific, observable occurrence (e.g. "external audit", "reproducible G-B11 recurrence"). |
| `CONDITION` | A state or predicate testable at review time (e.g. "trust boundary insufficient").          |
| `COUNT`     | A threshold count (e.g. "N of X events observed").                                          |
| `DATE`      | A calendar date or timeout (e.g. "after 2027-01-01").                                       |
| `LINK`      | Reference to another deferral's trigger by concrete, stable ID. Observability inherited.    |

Extensions to this vocabulary require a new Owner decision.

---

## 4. ID Convention

All trigger IDs follow the namespaced form:

```
<scope>.<deferral-id>.T<index>
```

Where:

- `<scope>` is a short slug identifying the source document/cluster:
  - `f9`             → `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`
  - `project-state`  → `PROJECT_STATE.md`
  - `abrau`          → `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md`
- `<deferral-id>` is the deferral's local identifier, lowercased
  (`d01`..`d05` for F9 decisions; `note55` / `note56` for PROJECT_STATE notes;
  `cdt02`, `ac03`, `f10-f12` for DEFERRED entries; `gb10`, `gn4`, `gl1` for
  ABRAU deferrals).
- `T<index>` is a stable per-block index; **`<index>` is a positive integer
  only**. No alphabetic sub-suffixes (`T5.a`, `T5.b`, …), no ranges, no
  wildcards. When a source-prose bullet must be split into multiple canonical
  triggers (e.g. a "any of X or Y" compound), each split is assigned the next
  integer in the block.
- Sub-items of a compound deferral (e.g. F9-D03 has six independently-named
  candidates) use `<deferral-id>.<sub-slug>.T<index>` (e.g.
  `f9.d03.gs1.T1`). The sub-slug is alphabetic; the index remains a positive
  integer.

**Stability contract:** once assigned, a trigger ID is not renumbered. If a
trigger is removed (Owner decision), its ID becomes retired and MUST NOT be
reused.

---

## 5. Block Schema

A deferral's retrofit is a single HTML-comment-delimited YAML block placed
immediately after the trigger prose. The block MUST NOT modify the surrounding
prose.

```
<!-- deferral-triggers:
scope: <scope>
deferral: <deferral-id>
combine: ANY | null
triggers:
  - id: <scope>.<deferral-id>.T1
    type: EVENT | CONDITION | COUNT | DATE | LINK
    predicate: "<verbatim or lightly-normalized prose from source>"
    provenance: "<file> §<section-id> · <content-anchor>"
    link: <target-id>          # only when type = LINK
related:
  - id: <target-id-or-external-ref>
    reason: "<why this is related but NOT a trigger>"
    provenance: "<file> §<section-id> · <content-anchor>"
-->
```

### 5.1 Fields

- `scope` / `deferral` — as defined in §4.
- `combine` — combinator semantics for the trigger list:
  - `ANY` — any single trigger firing reactivates the deferral. Permitted
    **only** when the source prose explicitly documents alternative triggers
    (enumerated list, "any of", "or").
  - `null` — no combinator asserted (single trigger, or semantics not stated
    in source). Do not default to `ANY`.
  - Any other operator requires a new Owner decision (see ARCH-005 REVIEW
    TRIGGER).
- `triggers` — ordered list. Each entry:
  - `id` — namespaced per §4 (positive integer index).
  - `type` — one of §3.
  - `predicate` — verbatim or minimally-normalized prose from source. No
    new predicate invented. When a source bullet compounds a base event with
    an additional condition (e.g. "X producing Y"), the `predicate` string
    MUST retain the full source phrasing verbatim; the condition is not
    dropped by structural decomposition.
  - `provenance` — content-anchored reference to source prose. Format:
    `<file> §<section-id> · <content-anchor>`. Content anchors survive
    subsequent edits (line numbers do not). Baseline commit MAY be cited
    when disambiguation is useful (`(@<commit>)`).
  - `link` — required when `type: LINK`. MUST be a concrete, stable single
    ID (`<scope>.<deferral-id>.T<index>`). Wildcards, ranges, comma-lists,
    or bare deferral names are not allowed. When source prose references a
    set of targets ("any of the F9-D02 triggers"), the retrofit MUST expand
    into one LINK trigger per target, each with the full compound predicate
    preserved verbatim in `predicate`.
- `related` — optional. Non-canonical references (documentation pointers,
  mitigation relationships, external artifacts, unarticulated predicates).
  Each entry carries `id`, `reason`, and `provenance`. `related:` entries
  are NOT triggers and MUST NOT be used to fire reactivation. External
  artifacts use the reserved scope `external.<slug>` and MUST NOT resolve
  to a defined trigger inside this repo.

### 5.2 Null case (HYPOTHESIS-tier)

For deferrals exempt under INV-4:

```
<!-- deferral-triggers: null
scope: <scope>
deferral: <deferral-id>
note: "HYPOTHESIS-tier; no observable predicate stated. See DEFERRAL_INVENTORY.md."
-->
```

---

## 6. Retrofit Scope (ARCH-005)

Exactly three source files receive retrofit under ARCH-005:

1. `docs/00_SYSTEM/F9_OWNER_DECISIONS.md` — F9-D01..F9-D05 (Cluster A).
2. `PROJECT_STATE.md` — DEFERRED entries and Notes 55/56 (Clusters B & D).
3. `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md` — G-B10, G-N4 (Cluster C).
   G-L1 receives the null block under INV-4.

Out of scope:

- Any decision predating F9 not enumerated above.
- Any future deferral (this policy defines the format; adoption for new
  deferrals is Owner-driven at the moment they are opened).
- Any runtime, hook, skill, registry, or maintenance change.

---

## 7. LINK-Normalization

Where a document's prose duplicates triggers already articulated in a
canonical source, the retrofit MAY normalize by using per-target `LINK`
entries (one LINK trigger per canonical ID). Examples:

- `PROJECT_STATE.md` Note 55 duplicates F9-D02 triggers → normalized as
  four `LINK` triggers pointing at `f9.d02.T1..T4`.
- `PROJECT_STATE.md` Note 56 duplicates F9-D04 triggers → normalized as
  five `LINK` triggers pointing at `f9.d04.T1..T5` (T4 splits customer
  branch; see block for detail).

This is a representation choice, not a semantic change. The prose remains
intact; the YAML block asserts LINK relationships. Wildcards, ranges, or
comma-lists in a single `link:` field are not permitted (see §5.1).

---

## 8. What This Policy Does NOT Do

Explicit non-goals (mirrors ARCH-005 NO-GOALS, restated for clarity):

- **No parallel registry.** Triggers live inline with the deferral prose.
- **No runtime.** No script reads these blocks at hook time.
- **No hooks.** No P0 or P1 hook is added or modified.
- **No `evals/maintenance.sh` integration.** The maintenance suite is not
  extended to validate this schema.
- **No automatic lint.** No CI step, no pre-commit check, no scheduled scan.
- **No mandatory periodic review.** Deferrals reactivate on their own
  triggers, not on a calendar.
- **No `combine` operators other than `ANY`.** Any other combinator requires
  a new Owner decision (fires ARCH-005 REVIEW TRIGGER).
- **No articulation of NH-11 or G-L1 triggers.** Both remain HYPOTHESIS-tier.
- **No definition of AC-03 TRIGGER-4 predicate.** It remains an external
  reference in `related:`.
- **No DEC-08 opening.** ARCH-005 enables DEC-08 with clean procedural
  precedent; opening it is a separate future Owner decision.

---

## 9. Adopting for New Deferrals (Optional)

When a new Owner-authorized deferral is opened in the future, the Owner MAY
adopt this schema by placing a `deferral-triggers:` block immediately after
the deferral's prose. Adoption is not mandatory. Non-adoption is not a
defect; it is a signal that the deferral either lacks observable triggers
(HYPOTHESIS-tier) or that the Owner chose prose-only representation.

If ≥3 Owner-authorized deferrals are added without a structured block **when
the observable predicate was extractable**, ARCH-005 REVIEW TRIGGER fires
and this policy is revisited.

---

## 10. Reversibility

`git revert <retrofit-commit>` restores every source file to its pre-retrofit
state. The policy file itself (`docs/00_SYSTEM/DEFERRAL_POLICY.md`) is
independent; deleting it does not affect the underlying documents.

---

## 11. Cross-References

- `DECISION_REGISTRY.md#ARCH-005` — formal decision (canonical).
- `docs/00_SYSTEM/DEFERRAL_INVENTORY.md` — EXP-1 empirical baseline
  (14 deferrals, 34/36 observable).
- `docs/00_SYSTEM/F9_OWNER_DECISIONS.md` — F9 Owner Decision Record (Cluster A).
- `PROJECT_STATE.md` — DEFERRED entries and Notes 55/56 (Clusters B & D).
- `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md` — G-B10, G-N4, G-L1
  (Cluster C).

---

**END DEFERRAL POLICY**
