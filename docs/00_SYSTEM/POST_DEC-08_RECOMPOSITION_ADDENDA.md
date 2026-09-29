# POST-DEC-08 RECOMPOSITION — CANONICAL/ANALYTICAL CORRECTION ADDENDA

> **Stratum-C analytical addenda (non-canonical, untracked).** Not an Owner Decision.
> Not an implementation authorization. Not a checkpoint. Not a merge instruction.
> Not a DEC opening. Read-only over canonical files.
>
> Fecha: 2026-09-29. Rama: `research/post-dec08-recomposition`. Autor: Claude
> (correction recorder, no decisor).
>
> Autorizado por Owner (`Q1 = YES` — CHOICE B, 2026-09-29 GMT-5): registrar como
> Stratum-C addenda las cinco correcciones B1..B5 identificadas por
> `docs/00_SYSTEM/POST_DEC08_CROSS_AUDIT_RECONCILIATION.md` con evidencia HIGH-band.
>
> Restricciones honradas: **no modifica** `DECISION_REGISTRY.md`, `PROJECT_STATE.md`,
> `DECISION_HISTORY.md`, `DEFERRAL_INVENTORY.md`, `F9_OWNER_DECISIONS.md`, ni ARCH-N
> text. No merge. No checkpoint. Cero ARCH-N assigned. Cero EV-NNN emitted.
> Cero triggers formalizados. Cero DEC abierta o reabierta.

---

## Related artifacts (frozen, not modified)

- LOCAL — `docs/00_SYSTEM/POST_DEC-08_DECISION_SPACE_RECOMPOSITION.md` (commit
  `28f13ee` on `research/post-dec08-recomposition`, 597 líneas).
- CLOUD — `docs/00_SYSTEM/CLOUD_ADVERSARIAL_AUDIT_POST_DEC08.md` (commit `40d9290`
  on `research/post-dec08-adversarial-audit`, 864 líneas; read via `git show`, not
  merged into working tree).
- RECON — `docs/00_SYSTEM/POST_DEC08_CROSS_AUDIT_RECONCILIATION.md` (untracked,
  774 líneas, this branch).

**Provenance of each correction:** RECON §2, §3, §4, §5, §1.

**Purpose of this addenda:** record corrections without editing frozen artifacts.
Any future reader who reaches the LOCAL recomposition should also read this file
and apply the corrections in place mentally. LOCAL is preserved verbatim as a
snapshot; this addenda is the correction layer.

---

## B1. Correction — P2a (DEC-07 D-VERIFICADOR) and P2b (DEC-REVIEWER-VERDICT)

### B1.1 What LOCAL says (verbatim, §1.4 P2a row and P2b row)

> "P2a (DEC-07 D-VERIFICADOR) | ARCH-009 §11.2 explicitly names DEC-07 as
> inheritor of 'verdict outside emitter' invariant. ARCH-008 (DEC-02 R1+K-A+MINIMUM)
> governs delegation but does not open verifier design. | No trigger. ARCH-009 line
> 'REOPENING TRIGGERS = NONE. Owner Choice B closes DEC-08; it does not defer' +
> F9-D01=A 'keep F9 implementation closed' holds. | **OPTION**: no concrete
> verifier workflow being planned … | **ABSORB via F9-D01=A + ARCH-009 inheritance**:
> opens on concrete verifier workflow need, not automatic"

Same absorption path used for P2b.

### B1.2 What the evidence actually shows

Independent probe from RECON §2 (reproducible via `grep 'F9-D01'
docs/00_SYSTEM/F9_OWNER_DECISIONS.md`):

- F9_OWNER_DECISIONS.md line 46-60: **"F9-D01 = A — Keep F9 implementation closed.
  Question closed: Should any F9 runtime implementation be authorized after…
  Resolution: No F9 runtime implementation is authorized."**
- Scope word "**implementation**" appears in the question, resolution, and reactivation
  triggers of F9-D01. Nothing in F9-D01 text closes a *decision space*.
- ARCH-005/006/007/008/009 all were opened, analyzed, and closed as *docs-only
  bookkeeping* without any F9 runtime authorization. `F9-D01=A` did not prevent
  any of them. DEC-07 could be opened under the same pattern.
- ARCH-009 §11.4 verbatim: "CCP does not decide here … (c) DEC-07 D-VERIFICADOR
  verifier design". Inheritance is a *constraint on future opening*, not a *closure*.
- `grep DEC-07 docs/00_SYSTEM/DEFERRAL_INVENTORY.md` → 0 matches; DEC-07 is NOT
  in any deferral entry.

### B1.3 Corrected classification

| Field | LOCAL says | Corrected reading |
|---|---|---|
| Status of P2a (DEC-07) | ABSORBED | **LATENT — NO ABSORPTION.** No deferral entry. Verdict-outside-emitter invariant inherits *if* opened; inheritance ≠ closure. |
| Status of P2b (DEC-REVIEWER-VERDICT) | ABSORBED | **LATENT — NO ABSORPTION.** Same category error as P2a; DEC-REVIEWER-VERDICT marked NEW/independent in DECISION_SPACE_PREPARED §98 (RECON §2.2 E10). |
| Trigger for P2a | None; opens on concrete verifier workflow | **UNDEFINED PREDICATE.** No formal trigger in DEFERRAL_INVENTORY. `verifier-workflow.T1` suggested in LOCAL §5.1 is not adopted (see B4). |
| Trigger for P2b | Same as P2a | Same: undefined predicate. |
| Outcome (no-open-today) | Sustained | Sustained. No signal fires. |

### B1.4 Confidence band

RECON classifies B1 as **CONFIRMED HIGH** (direct verbatim source; category error
distinction is textual, not interpretive).

---

## B2. Correction — P3 (DEC-04 D-CANONICAL + DEC-05 D-MOTOR)

### B2.1 What LOCAL says (verbatim, §1.4 P3 row)

> "P3 (DEC-04 D-CANONICAL / DEC-05 D-MOTOR) | Not covered by any ARCH-N. Related
> to P-PY / P-PC / DEV-CONTRACT primitives which are RESEARCH-tier per PIECE_AND_IDEA
> §2. | F9-D03=B 'Keep documentary candidates deferred (6 sub-items)' + F9-D04
> external trigger cover this class | **OPTION**: F9-D03 posture explicitly parks
> documentary candidates until external trigger | **ABSORB via F9-D03=B + F9-D04
> trigger cluster**"

### B2.2 What the evidence actually shows

F9_OWNER_DECISIONS.md lines 213-224 enumerate F9-D03=B's six documentary sub-items
verbatim:

| ID | Content |
|---|---|
| G-S1 | Rollback smoke test |
| G-S2 | Rollback command clarity |
| G-Bob-1 | (semantic-header content per audit) |
| G-A1 | Placeholder context packs (installer template semantics preserved) |
| G-N1 | Manual runtime revalidation cadence |
| G-N2 | Session-log retention policy |

DEC-04 problem framing (DECISION_SPACE_PREPARED §5, §73, §112): "canonical policy
source — which policy artifact is authoritative — VALID + IRREDUCIBLE (terna)".

DEC-05 problem framing (idem, §113): "policy compiler — how canonical policy is
compiled to enforcement — VALID + IRREDUCIBLE (terna)".

**Semantic mapping (RECON §3.3):** none of G-S1/G-S2/G-Bob-1/G-A1/G-N1/G-N2 touches
canonical policy source selection or compiler design. F9-D04 external triggers
(audit, compliance, customer, trust-boundary) are equally orthogonal to policy
derivation semantics.

### B2.3 Corrected classification

| Field | LOCAL says | Corrected reading |
|---|---|---|
| Status of P3 as pair | ABSORBED | **LATENT PAIR — NO ABSORPTION.** `DEC-04 ⋈ DEC-05` binary irreducibility remains (see B3 for the triad correction). |
| Absorbed by F9-D03? | Yes | **NO.** Zero conceptual overlap with G-S1..G-N2. |
| Absorbed by F9-D04? | Implicit yes | **NO.** F9-D04 external triggers orthogonal to policy derivation. |
| Trigger for DEC-04 / DEC-05 | F9-D03 / F9-D04 | **UNDEFINED PREDICATE.** No formal DEFERRAL_INVENTORY entry for the pair. PIECE_AND_IDEA IDEA-1 maturity ('ESTRUCTURAL, no implementable hasta autorización') is a state, not a predicate. |
| Outcome (no-open-today) | Sustained | Sustained. No documentary trigger has fired; no external requirement; no IDEA-1 concrete need surfaced. |

### B2.4 Confidence band

RECON classifies B2 as **CONFIRMED HIGH** (verbatim enumeration of G-S1..G-N2;
conceptual disjunction with DEC-04/DEC-05 is direct).

---

## B3. Historical annotation — DECISION_SPACE_PREPARED §48 irreducible triad

### B3.1 What DECISION_SPACE_PREPARED §48 says (verbatim, frozen — not modified)

> "Terna irreductible confirmada: DEC-04 (canónica) + DEC-05 (motor) + DEC-02
> (delegación) = `GOVERNED DERIVATION`. No son separables; el AUDIT §23 lo
> estableció y esta preparación lo mantiene. Deben decidirse como paquete o al menos
> en secuencia inmediata."

### B3.2 What ARCH-008 (DEC-02 R1+K-A+MINIMUM) actually did

Reproducible via `grep 'DEC-02\|R1\|MINIMUM' docs/00_SYSTEM/DECISION_HISTORY.md`
(RECON §4.2):

- **CHOICE**: R1 (docs-only representation) + K-A + MINIMUM SCHEMA (3 semantically
  required fields). No presumption of DEC-04 open. Minimum schema explicitly defers
  4 fields; no policy corpus required.
- **EXPECTED**: "Docs-only governance convention… No runtime enforcement introduced.
  No AUTHORITY_KIND / VOCAB-A modification. No CAPABILITY registry." Explicit
  non-coupling to policy-source or compiler decisions.
- **TRIGGER SET** (`arch08.T1..T6`): incident, DEC-07 opening, S2/S3 scaling,
  non-actor target, per-skill authority, CAPABILITY threshold. **None mentions
  DEC-04 or DEC-05.**
- **IN-FLIGHT LESSON** (5-of-11 default-covered): "the pivot that made MODEL-A
  [minimum] work" — the chosen R1 shape *intentionally decoupled* delegation from
  any policy substrate.

### B3.3 Corrected historical framing

| Claim | Status after ARCH-008 |
|---|---|
| `DEC-02 + DEC-04 + DEC-05 = irreducible triad` | **HISTORICALLY STALE.** ARCH-008's R1+MINIMUM decoupled DEC-02 from the pair by design. |
| `Deben decidirse como paquete o al menos en secuencia inmediata` | **NO LONGER TRUE.** DEC-02 already went first (ARCH-008, 2026-09-28); the pair `{DEC-04, DEC-05}` remains coupled between themselves but orthogonal to DEC-02 after ARCH-008. |
| Correct binary structure | `DEC-04 ⋈ DEC-05` (canonical-source must precede compiler). DEC-02 orthogonal. |
| Where to record this | **Here (Stratum-C addenda), not in DECISION_SPACE_PREPARED §48.** The historical text is preserved verbatim as a snapshot of pre-ARCH-008 analysis. |

### B3.4 Confidence band

RECON classifies B3 as **CONFIRMED MODERATE-HIGH** (based on ARCH-008 semantic
probe; MODERATE-HIGH rather than HIGH because §48's `AUDIT §23` referent was not
independently re-verified in RECON).

### B3.5 What this correction does NOT do

- Does NOT retract §48 in `DECISION_SPACE_PREPARED.md` (that file frozen).
- Does NOT open DEC-04 or DEC-05 (they remain LATENT — see B2).
- Does NOT create a new deferral entry (that would be Choice C, WAIT per Q3).
- Does NOT reactivate DEC-02 (ARCH-008 CHECKPOINTED, closed).

---

## B4. Provenance annotation — LOCAL §5.1 novel triggers

### B4.1 What LOCAL §5.1 says (verbatim)

> "Novel candidate triggers (not canonical; suggested for future policy):
> · `stall-consumer.T1` = STALL_POLICY_LOG event volume crosses N events / week
>   or K distinct signatures.
> · `verifier-workflow.T1` = Owner-planned workflow requires post-tool semantic
>   verification beyond ARCH-004/ARCH-008.
> · `reviewer-verdict.T1` = concrete workflow requires asymmetric-verdict emission
>   with governance consequence."

### B4.2 What the evidence shows

- `grep 'stall-consumer\|verifier-workflow\|reviewer-verdict' docs/00_SYSTEM/DEFERRAL_INVENTORY.md`
  → 0 matches. None of the three triggers exist in the canonical inventory.
- Neither `ARCH-005 (DEC-11 HYB-FINAL-v4)` nor `ARCH-006 (VOCAB-A)` defines a path
  for admitting *new trigger classes* to the deferral inventory. ARCH-005 defines
  how existing entries carry `predicate:` / `provenance:` / `combine:`; ARCH-006
  governs authority-kind vocabulary.
- Per RECON §5.4 and §8.3, all three triggers have **undefined predicates** (N, K,
  window, threshold, reset condition, firing action are all unspecified).

### B4.3 Provenance annotation

The three triggers surfaced in LOCAL §5.1 are: (a) *suggested* — not adopted;
(b) *provenanced to the LOCAL artifact*; (c) *not tied to any Owner authorization
event in this repo*; (d) *not adoptable without either (i) an Owner-authorized
D-TRIGGER-SCHEMA decision, or (ii) formalization under the ARCH-005 pattern
(Owner-authored trigger entry with defined predicate + provenance)*.

This addenda **does not adopt** any of the three triggers. Their adoption is
gated on `Q3 = WAIT` — pending the outcome of CHOICE D (see companion file
`X_STALL_SEMANTIC_DIVERGENCE_PROBE.md`).

### B4.4 Confidence band

RECON classifies B4 as **CONFIRMED** (self-verification against LOCAL text +
inventory grep).

---

## B5. As-of stamp discipline correction

### B5.1 What LOCAL §1.2 (Δ4) says (verbatim)

> "STALL corpus growing | 27 events at 2026-09-28 19:15 UTC; 22/27 = 81.5% share
> signature `(F1-foundation-2026-09-16, contract_hash_required)`. Test-fixture-pattern
> hypothesis (HIGH repetition, MODERATE attribution) per Kernel §6.2.3."

### B5.2 Fact vs snapshot

- The `27 events @ 2026-09-28 19:15 UTC` value is *inherited* from `DEC_08_DECISION_KERNEL.md §0`
  without live re-probing at LOCAL write time (2026-09-29).
- Real-time re-probe during RECON: **34 events @ 2026-09-29T04:35:07Z**
  (last event) — a growth of +7 over the LOCAL write window.
- Real-time re-probe during THIS addenda: **35 events** (see B5.4 below — this
  session accidentally emitted +1 via bash-firewall enforcing `DROP DATABASE`
  pattern on a search grep).

### B5.3 Corrected discipline (for future recompositions, not for LOCAL edit)

Any future recomposition citing `STALL_POLICY_LOG.jsonl` should:

1. Include an explicit `as-of` timestamp captured at the moment of read.
2. Record both raw event count AND signature distribution AND distinct
   `(source_hook, policy_category)` count at that moment.
3. Note that `STALL_POLICY_LOG.jsonl` is *append-only* (per DEC-08 Kernel INV-2)
   and therefore snapshot values monotonically increase; comparisons across
   recompositions must be time-indexed.
4. Distinguish clearly between (a) events from `evals/hooks/task-completed-coupling.sh`
   line 116 (fixture emitter that intentionally writes to canonical log), (b)
   events from `evals/hooks/firewall-positive.sh` (which does not redirect
   `CLAUDE_PROJECT_DIR` and therefore emits to canonical log when run against
   canonical root), and (c) events from real production hook enforcement.
   RECON §5 and probe D characterize this cleanly.

### B5.4 Live meta-observation (recorded for future audit)

During probe D preparation in this session (2026-09-29 GMT-5), a grep command
containing the literal pattern `'DROP DATABASE'` was correctly intercepted by
`.claude/hooks/bash-firewall.sh` and produced a fresh STALL_POLICY_LOG entry.
Before that grep: 34 events. After: 35 events. This reinforces the finding
that the STALL log is a self-observation surface for CCP's own tooling
(including agent sessions using the tooling), not an independent signal of
real work-blocking.

### B5.5 Confidence band

RECON classifies B5 as **CONFIRMED HIGH** (direct file probe reproducible via
`wc -l` at any time).

---

## §C. Summary of corrections (single reference table)

| # | Concerns | LOCAL claim | Corrected | Confidence | Modifies canonical? |
|---|---|---|---|---|---|
| B1 | P2a / P2b | ABSORBED via F9-D01=A | LATENT — NO ABSORPTION | HIGH | NO |
| B2 | P3 (DEC-04 + DEC-05) | ABSORBED via F9-D03=B / F9-D04 | LATENT PAIR — NO ABSORPTION | HIGH | NO |
| B3 | Triad | (silent inheritance from §48) | Historically stale post-ARCH-008; correct structure is DEC-04 ⋈ DEC-05 binary; DEC-02 orthogonal | MODERATE-HIGH | NO |
| B4 | Novel triggers §5.1 | (suggested for future policy) | Not adopted; unformalized; gated on Q3 outcome | CONFIRMED | NO |
| B5 | STALL @27 events | Inherited value | Time-indexed to 34→35 events; as-of discipline required for future | HIGH | NO |

All corrections are *record-level annotations*. None re-open a DEC, none add a
canonical trigger, none modify a canonical file.

**Outcome overall**: **`NO-MOVE SUSTAINED WITH CONDITIONS`** (RECON §9.3) —
unchanged by this addenda; the corrections update rationale and record framing,
not the outcome.

---

## §D. Non-Modification Attestation

This artifact did NOT modify:

- `PROJECT_STATE.md`
- `DECISION_REGISTRY.md`
- `docs/00_SYSTEM/DECISION_HISTORY.md`
- `docs/00_SYSTEM/AUTHORITY_KIND.md`
- `docs/00_SYSTEM/MASTER_HANDOFF.md`
- `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md` (frozen; §48 preserved verbatim)
- `docs/00_SYSTEM/POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md`
- `docs/00_SYSTEM/POST_DEC-08_DECISION_SPACE_RECOMPOSITION.md` (LOCAL frozen at
  commit `28f13ee`; corrections layered here, not applied in-place)
- `docs/00_SYSTEM/CLOUD_ADVERSARIAL_AUDIT_POST_DEC08.md` (frozen at commit
  `40d9290`; read-only)
- `docs/00_SYSTEM/POST_DEC08_CROSS_AUDIT_RECONCILIATION.md` (untracked, frozen)
- `docs/00_SYSTEM/DEC_08_DECISION_KERNEL.md`
- `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md`
- `docs/00_SYSTEM/DEFERRAL_POLICY.md` / `DEFERRAL_INVENTORY.md`
- `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`
- `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` (read-only; +1 accidental event via
  bash-firewall interception logged in B5.4 — that is hook-emitted, not
  addenda-emitted)
- `ARTIFACT_MANIFEST.md`
- `.claude/**/*` (rules, hooks, agents, skills)
- `evals/**/*`
- `INCIDENT_REGISTRY.md`

Runtime authorization requested: **NONE.**
Owner decisions taken: **NONE.**
DEC opened / re-opened: **NONE.**
Canonical merges: **NONE.**
Checkpoints executed: **NONE.**
ARCH-N assigned: **NONE.**
Triggers formalized: **NONE.**
Analytical artifacts created this session: **1** (this file) + companion
`X_STALL_SEMANTIC_DIVERGENCE_PROBE.md` produced under CHOICE D.

---

## §E. Structured markers emitted

```text
ADDENDA_MARK: authorized_by=Owner_Q1=YES scope=CHOICE_B
ADDENDA_MARK: source=POST_DEC08_CROSS_AUDIT_RECONCILIATION.md
ADDENDA_MARK: corrections_recorded=5 (B1..B5)
ADDENDA_MARK: canonical_writes=0
ADDENDA_MARK: dec_opened=0
ADDENDA_MARK: dec_reopened=0
ADDENDA_MARK: triggers_formalized=0
ADDENDA_MARK: arch_n_assigned=0
ADDENDA_MARK: ev_nnn_emitted=0
ADDENDA_MARK: merge_executed=NO
ADDENDA_MARK: checkpoint_executed=NO
ADDENDA_MARK: outcome=NO-MOVE_SUSTAINED_WITH_CONDITIONS
```

STOP.
