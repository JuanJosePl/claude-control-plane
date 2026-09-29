# DEC-08 DECISION KERNEL

> **Stratum-C analytical artifact (untracked, non-canonical).** Not an Owner Decision.
> Not an implementation authorization. Not a checkpoint.
> Fecha: 2026-09-28. Autor: Claude (analyst, no decisor). Ceiling: ≤ 1 artefacto.
> Producido por: `CCP_DEC-08_MASTER_PROMPT_v3.md` (Move 1).
>
> Reglas heredadas: DETERMINAR ≠ CORREGIR · RECOMENDAR ≠ DECIDIR · OPEN ≠ OWNER_CHOSEN.

---

## §0. Preflight State (Phase 1A observations, VERIFIED)

**Repository state:**

- `git branch --show-current` = `claude/happy-bell-tg54h1` [VERIFIED]
- `HEAD` = `2f55412` ("docs: add CCP decision and prompt engineering artifacts")
  [VERIFIED via `git log --oneline -10`]
- Prompt declared `CANONICAL_HEAD_ORIGIN: a9beb22` (ARCH-008 sync). **Delta**: HEAD advanced 1 commit
  past `a9beb22` with the addition of this Kernel's supporting analytical artifacts (the master
  prompts v1/v2/v3 and other CCP artifacts) as untracked/staged docs. Delta is inert: no ARCH state
  changed.
- Canonical status of ARCH-005/006/007/008: unchanged, CHECKPOINTED, per PROJECT_STATE.md line 8.
- ARCH-008 (DEC-02) CONFORMANCE_PASS 12/12 (2026-09-28); LAST_GIT_CHECKPOINT = `5dfd65a` in PROJECT_STATE.

**STALL corpus (as of 2026-09-28 19:15 UTC):**

| Field | Value | Verification |
|---|---|---|
| Total events | 27 | `wc -l STALL_POLICY_LOG.jsonl` [VERIFIED] |
| Date range | 2026-09-22T03:53 → 2026-09-28T19:15 (≈6 days active) | jq -r .timestamp [VERIFIED] |
| `stall_type` distribution | 26 STALL_POLICY + 1 UNKNOWN | jq distribution [VERIFIED] |
| `policy_category` distribution | 22 contract_hash_required, 2 supply chain, 1 rm -rf, 1 DROP DATABASE, 1 evidence_contract | jq distribution [VERIFIED] |
| `source_hook` | 4 bash-firewall.sh + 23 task-completed-evidence.sh | jq distribution [VERIFIED] |
| `decision` | 27 DENY (0 ALLOW, 0 UNKNOWN) | jq distribution [VERIFIED] |
| `had_alternative` | 27/27 null (hardcoded at `stall-record.sh:46`) | line 46 read directly [VERIFIED] |
| `session_id` | 27/27 null ("" → null conversion at `stall-record.sh:46`) | jq check [VERIFIED] |
| `task_id` | 4/27 null (bash-firewall calls with ""), 23/27 populated | jq check [VERIFIED] |
| `verdict` field | ABSENT (0/27 present) | `jq 'has("verdict")'` [VERIFIED] |
| Unique event signatures | 6 unique (action_hash, task_id, policy_category) tuples | jq uniq -c [VERIFIED] |
| Repeat rate | 22/27 events share ONE signature = `(F1-foundation-2026-09-16, contract_hash_required)` = 81.5% | derivation from above [VERIFIED] |

**Consumers of STALL_POLICY_LOG (canonical, non-analytical):**

- `docs/00_SYSTEM/query-log.sh` — MOVEMENT 007 authorized READ-ONLY tool; reads `source_hook`,
  `policy_category`, `action_hash`, `timestamp`. Does **NOT** read `verdict`, `session_id`, or
  `had_alternative` (grep [VERIFIED]).
- `evals/r2/r2-instrumentation.sh` — test harness invariant assertions; **asserts** `had_alternative == null`
  and `session_id (null or string)`, does not consume values [VERIFIED at lines 48, 64].
- No other canonical consumer.

**Callers of `stall_record_event`:**

- `.claude/hooks/bash-firewall.sh:36`
- `.claude/hooks/task-completed-evidence.sh:24`

**Prompt-injection scan:** all 27 `notes` fields contain one of two hook-authored strings
("policy predicate matched" or "classification is conservative; alternative is not inferred"). No
instruction-like content. No `<command>`, no policy directives, no shell fragments. Clean.

**Prior DEC-08 artifacts inspected:**

- `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md §4.7` — original G1/G2/G3 space with 65% G2 confidence
  conditional on DEC-11 previa (now satisfied but insufficient — see §1).
- `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md §5B` — P-STREAM-CONSUMER identified as
  IMPLICIT-MISSING; "obligatoria si DEC-08 G2/G3 se aprueba" (line 242).
- `docs/00_SYSTEM/POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md §7` — DEC-08 ↔ DEC-STREAM-CONSUMER =
  MUTUAL-ILLUMINATION (line 370); DEC-11 → DEC-08 = ABSORBED (line 371).
- `docs/00_SYSTEM/MASTER_HANDOFF.md` — extensive DEC-08 material (>50 refs); confirms F9-D01=A blocks G2.

---

## §1. Meta-Gate Verdict (Phase 1B)

### 1B.1 Draft (six meta-gate answers)

| Q | Draft answer | Tag |
|---|---|---|
| Q1 Problem validity | STALL emits `had_alternative:null` + `session_id:null` + no `verdict` field; 3 UNKNOWNs (U-01, U-02, READY-03 empirical) depend on this data being observable | [VERIFIED] |
| Q2 Decision-vs-detail | Decision: G1/G2/G3 differ in semantics, lock-in, F9-D01 gate posture | [INFERENCE] |
| Q3 Scope | BOUNDARY-AMBIGUOUS: DEC-08 framed as "schema completion", but no consumer of the disputed fields exists | [VERIFIED] |
| Q4 Unit-of-decision | Atomic unit = schema shape; but decision *value* ≈ 0 without consumer (MUTUAL with DEC-STREAM-CONSUMER) | [INFERENCE] |
| Q5 Formulation attack | Assumption "we need U-01/U-02/READY-03 observability now" not supported by evidence (no incident, no consumer, 82% harness noise) → verdict candidate DEFER | [VERIFIED] |
| Q6 Anti-anchoring | Legacy assumption "DEC-11 closed unblocks G2" is false: DEC-11/ARCH-005 formalizes deferral policy but does not reopen F9-D01=A | [VERIFIED via PROJECT_STATE line 8] |

### 1B.2 Verification questions (2 per Q, draft-independent)

- **VQ1a** Is there any canonical consumer of `verdict`/`session_id` real/`had_alternative` real today?
- **VQ1b** How many unique event signatures exist and how many are harness noise?
- **VQ2a** Does a "close without decision" option exist that is outcome-equivalent to G1/G2/G3?
- **VQ2b** Do G1/G2/G3 differ in observable consequences post-decision?
- **VQ3a** Which components semantically depend on extended STALL schema, and how many?
- **VQ3b** Can DEC-STREAM-CONSUMER be decided without DEC-08, and vice versa?
- **VQ4a** Does schema-only change (no consumer) create information or write-only bytes?
- **VQ4b** Is the atomic "schema" decision reversible independent of "consumer" decision?
- **VQ5a** Is there any INCIDENT_REGISTRY entry attributable to STALL schema partial?
- **VQ5b** What is the base rate of material policy events (non-harness) in the log?
- **VQ6a** Is F9-D01=A currently active? Has its trigger fired?
- **VQ6b** Does DEC-11/ARCH-005 resolution modify the F9-D01 gate?

### 1B.3 Verification execution (independent findings)

- **VQ1a → NO.** `query-log.sh` reads {source_hook, policy_category, action_hash, timestamp}
  only. `r2-instrumentation.sh` asserts `had_alternative == null` (as invariant) and
  `session_id (null|string)` (as type-check). Neither *consumes* the value; the null assertion is
  a **schema-enforcement invariant**, not a value dependency. No verdict field consumer exists.
  [VERIFIED via grep -rE 'verdict|had_alternative|\.session_id']
- **VQ1b → 6 unique signatures in 27 events; 22/27 = 81.5% is one signature.** Prompt cited
  historical 82% harness noise; current data confirms and slightly exceeds it. [VERIFIED]
- **VQ2a → YES.** G1 (do nothing) is outcome-equivalent to "not deciding". A canonical DEFER with
  triggers dominates G1 by explicitness (see §3).
- **VQ2b → YES but small.** G1: no change. G2: 27 rows still have historical nulls; future rows
  get real values + a `verdict` enum; consumers must handle mixed. G3: parallel log requires its
  own consumer.
- **VQ3a → ZERO canonical dependents today.** Analytical writing (K3, MASTER_HANDOFF) references
  the need but no code path breaks or is impaired by missing fields.
- **VQ3b → BOTH decidable independently.** POST_ARCH-007 §7 reclassified DEC-08 ↔ DEC-STREAM-CONSUMER
  as MUTUAL-ILLUMINATION (not HARD in either direction).
- **VQ4a → Write-only bytes.** With no consumer, populated values are informationally void.
- **VQ4b → Semantically low.** Once `verdict` is an enum, changing it later requires consumer
  coordination. Technically the field is removable (JSONL default null), but the enum choice locks
  future verifier interpretation.
- **VQ5a → NO EVIDENCE.** `INCIDENT_REGISTRY.md` not found in repo or contains no STALL entries
  [VERIFIED via file existence check + grep].
- **VQ5b → ≈1 material event/day.** 6 unique signatures over 6 days; even generously ~1 material
  event/day. 22 of 27 are one duplicate task pattern (F1-foundation-2026-09-16 tests).
- **VQ6a → F9-D01=A ACTIVE (CLOSED).** PROJECT_STATE line 8:
  `F9-D01=A, F9-D02=B, F9-D03=B, F9-D04=B, F9-D05=A ... F9_OWNER_DECISION_GATE: CLOSED`.
  F9-D01 canonical trigger has not fired [VERIFIED].
- **VQ6b → NO.** DEC-11/ARCH-005 (deferral policy) doesn't touch F9-D01 semantics; it just
  formalizes how deferrals record triggers. G2 (modify stall-record.sh) still crosses F9-D01.

### 1B.4 Final verdict (integration)

Where verification contradicts or refines the draft:

- Q1 refined: the *underlying* problem is not "schema partial" but "no consumer + no observed harm".
- Q3 confirmed BOUNDARY-AMBIGUOUS and strengthens to **MIS-SCOPED as isolated schema decision**.
- Q5 verdict DEFER strengthened by (a) no incident, (b) 81.5% harness noise (matches historical),
  (c) F9-D01=A still active.

**VERDICT: DEFER**

```
DECISION_MARK: verdict verdict=DEFER confidence=HIGH driver="No canonical consumer for verdict/session_id/had_alternative; INCIDENT_REGISTRY empty; 81.5% harness noise; F9-D01=A blocks G2; schema-only commit is write-only lock-in"
```

Verbalized confidence: **HIGH**.
Driver: five independently verified findings converge (no consumer, no incident, harness-dominant
base rate, F9-D01 active, fact/judgment separation §2.3).
Falsifier: any of `arch09.T1..T5` below (§5) firing.

Alternative verdict considered: **REFORMULATE** (G4). Rejected as *primary* meta-verdict because
DEFER is a strictly less committing move that preserves REFORMULATE as an available Owner Choice
without foreclosing it. Owner may explicitly choose REFORMULATE at Move 2 (surfaced in §6).

`UNCERTAINTY_MARK: claim="F9-D01=A blocks G2 today" band=HIGH source=[VERIFIED:PROJECT_STATE.md:8]`
`UNCERTAINTY_MARK: claim="No canonical consumer of disputed fields" band=HIGH source=[VERIFIED:query-log.sh,r2-instrumentation.sh grep]`
`UNCERTAINTY_MARK: claim="81.5% harness noise (22/27 same signature)" band=HIGH source=[VERIFIED:jq uniq -c]`

---

## §2. Architectural Truth (Phase 1C, Skeleton-of-Thought)

### 1C.SKELETON

1. Invariants — {emission subordinate; append-only; schema_version required; canonical consumer requirement UNPROVEN}.
2. Source of truth — {`session_id` NOWHERE; `had_alternative` NOWHERE; hypothetical `verdict` NOWHERE inside emitter}.
3. Fact/observation/derivation/judgment chain — {emitter carries facts+classifications; `verdict` is a judgment, belongs elsewhere}.
4. Boundary placement — {emitter has classification info but LACKS authority to judge its own decision}.
5. State/event/transition model — {STALL entry = pure event; adding `verdict` mixes event+judgment}.
6. Null semantics — {monosemantic today; adding populated `null` alongside real values loses monosemy}.

### 2.1 Invariants (PROVEN NECESSARY only)

- **INV-1**: STALL emission MUST be subordinate to caller decision (no side effects on flow).
  [VERIFIED: `stall-record.sh:2` comment + `|| true` in callers]
- **INV-2**: STALL log MUST be append-only JSONL.
  [VERIFIED: `stall-record.sh:47` uses `>>`; `query-log.sh` is READ-ONLY]
- **INV-3**: Every row MUST carry `schema_version`.
  [VERIFIED: `stall-record.sh:35`; `r2-instrumentation.sh` asserts]

Invariants NOT proven (INSUFFICIENT EVIDENCE): "canonical consumer required" is unproven; runtime
does not fail without a consumer.

### 2.2 Source of truth per field (compact)

- **VERIFIED source-of-truth exists** for: `schema_version` (constant), `event_id` (derived),
  `timestamp` (system clock), `source_hook` (script identity), `decision`/`stall_type`/`policy_category`
  (hook classification), `action_hash` (sha256), `task_id`, `notes` (hook-authored).
- **NOWHERE (source-of-truth not observed)**: `session_id` (payload doesn't carry it),
  `had_alternative` (no verifier upstream), hypothetical `verdict` (emitter lacks authority).

### 2.3 Fact / observation / derivation / judgment placement

- **Facts**: `event_id`, `timestamp`, `action_hash`, raw input.
- **Observations**: `source_hook`, `decision`.
- **Derivations**: `stall_type`, `policy_category` (hook classifications).
- **Judgments**: **NONE currently**. Hook does not judge correctness of its own classification;
  it does not have that authority.

**Architectural finding**: `verdict:` is a judgment field. Placing it in the emitter conflates
fact-emitter and judgment-holder. Judgments belong in a separate layer — a verifier record
that references the STALL event by `event_id`. Related decisions: DEC-07 D-VERIFICADOR, DEC-REVIEWER-VERDICT.

### 2.4 Boundary placement

Who has *information + authority* to write `verdict`?

- The emitting hook: has classification, LACKS authority (self-verification anti-pattern).
- A verifier subagent (per DEC-07 or DEC-REVIEWER-VERDICT): has authority IF authorized.
- Human reviewer (per HRQS): has authority, currently interfaces via `query-log.sh` (read only).

Correct boundary: `verdict` semantics belong to a **verifier layer external to `stall-record.sh`**.

### 2.5 State / event / transition model

- STALL entry = **event** (immutable fact-record of a moment).
- G2 mixes event + judgment → semantic drift.
- G3 shadow = parallel event log (same shape, no judgment).
- G4 (emergent) = separate verdict layer.

Cleanest model: STALL_POLICY_LOG stays event-only. Judgments live elsewhere.

### 2.6 Null semantics

Today: `null` is monosemantic ("hardcoded/converted; no meaning intended"). Safe because no consumer
distinguishes.

If populated with mixed nulls + reals: `null` gains three possible meanings ("unavailable" /
"actively-null" / "consumer-should-treat-as-default") → ambiguity.

Distinction would have decision value ONLY IF a consumer needs it. Currently: NO CONSUMER →
distinction is speculative.

```
DECISION_MARK: invariant_proven name="INV-1 subordinate emission" evidence=[VERIFIED:stall-record.sh:2,task-completed-evidence.sh:32]
DECISION_MARK: invariant_proven name="INV-2 append-only" evidence=[VERIFIED:stall-record.sh:47,query-log.sh:3]
DECISION_MARK: invariant_proven name="INV-3 schema_version required" evidence=[VERIFIED:r2-instrumentation.sh assertions]
```

### 2.7 Architectural finding (Phase 1C.INTEGRITY)

Architectural truth constrains the option surface:

1. G2 violates fact/judgment separation (§2.3).
2. G2's populated `session_id`/`had_alternative` lack a truth source (§2.2).
3. G3 avoids the fact/judgment mix but produces write-only bytes without consumer (§2.1).
4. G1 preserves invariants but leaves the question implicit.

An option **absent from the historical G1/G2/G3 space** emerges from Phase 1C:

- **G4 — REFORMULATE**: keep `STALL_POLICY_LOG` as event-only; move `verdict` semantics into a
  future **verifier layer** (DEC-07 or DEC-REVIEWER-VERDICT). Preserves fact/judgment separation.

---

## §3. Real Option Surface (Phase 1D, dominance applied)

**Historical options G1/G2/G3 tested against Phase 1C truth.**

Two eliminated by dominance:

```
DECISION_MARK: option_eliminated id=G1 reason="Dominated by G-DEFER: outcome-equivalent status quo but without observable reopen trigger"
DECISION_MARK: option_eliminated id=G2 reason="Crosses F9-D01=A active gate; violates fact/judgment separation §2.3; no consumer; semantic lock-in on verdict enum"
DECISION_MARK: option_eliminated id=G3 reason="Shadow captures same 81.5% harness noise; no consumer justifies cost; can be reintroduced later if consumer emerges"
```

**Two surviving architectural branches:**

### 3.1 Option A — G-DEFER (canonical DEFER)

- **MEANING**: DEC-08 stays a valid decision but has no observable trigger firing today. Owner explicitly parks it.
- **SCHEMA CONSEQUENCE**: none. `stall-record.sh` unchanged.
- **IMPLEMENTATION CONSEQUENCE**: none.
- **BOUNDARY CONSEQUENCE**: fact/judgment separation preserved by not changing anything.
- **EVIDENCE SUPPORTING**: §1B verdict + all Phase 1C findings.
- **REVERSIBILITY**: HIGH. Owner reopens when any `arch09.T*` trigger fires.
- **LOCK-IN**: NONE.
- **PATH DEPENDENCE**: preserves DEC-STREAM-CONSUMER, DEC-07, DEC-REVIEWER-VERDICT freedom.
- **OPTION VALUE**: preserves REFORMULATE as a later possibility.
- **CONFIDENCE**: HIGH. Driver: minimum irreversible move; no lock-in; explicit triggers.
- **FALSIFIER**: any material change in evidence (see §5).

### 3.2 Option B — G4-REFORMULATE (dissolve DEC-08 as isolated schema decision)

- **MEANING**: DEC-08 as "STALL schema completion" is dissolved. The `verdict` semantic is delegated
  to whichever future decision materializes a verifier layer (DEC-07 D-VERIFICADOR or DEC-REVIEWER-VERDICT).
  STALL_POLICY_LOG stays event-only. `stall-record.sh` unchanged.
- **SCHEMA CONSEQUENCE**: none in STALL_POLICY_LOG; deferred to verifier decision.
- **IMPLEMENTATION CONSEQUENCE**: none now. Any future verifier writes its own record referencing
  STALL `event_id`.
- **BOUNDARY CONSEQUENCE**: restores fact/judgment separation architecturally (§2.3).
- **EVIDENCE SUPPORTING**: §1C.3 fact/judgment separation; §2.4 boundary argument; §2.7 emergence.
- **REVERSIBILITY**: HIGH (RETIRE is documentary; can be reversed by opening a new schema decision).
- **LOCK-IN**: LOW. Locks in "verdict lives outside emitter", which is an invariant Owner probably
  agrees with under scrutiny.
- **PATH DEPENDENCE**: forces DEC-07 / DEC-REVIEWER-VERDICT to be the natural home for verdict schema.
- **OPTION VALUE**: HIGH — preserves architectural integrity, dissolves a mis-scoped decision.
- **CONFIDENCE**: MODERATE-HIGH. Driver: architectural argument sound; but adds framing complexity
  (Owner may prefer simplicity of DEFER).
- **FALSIFIER**: emergence of a use case where an *emitter*-side verdict is architecturally correct
  (e.g., self-evident classification with no external verifier).

### 3.3 Dominance test summary

Neither A nor B dominates the other:

- A (DEFER) is the minimum-irreversible-move winner; preserves all optionality including B.
- B (REFORMULATE) is the architectural-integrity winner; makes an explicit semantic commitment
  that the emitter does not hold the verdict.

**They differ in kind**: A keeps DEC-08 alive as a parked decision; B retires DEC-08 as a decision
and folds verdict into a downstream one. Both are honest.

```
DECISION_MARK: dominance_test winner=none loser=none reason="A and B are architectural branches; A minimizes irreversible move, B commits to fact/judgment separation. Owner must choose."
```

---

## §4. Value-of-Information

**Uncertainties that can change Owner Choice:**

- U-A: Does Owner intend to open DEC-07 D-VERIFICADOR or DEC-REVIEWER-VERDICT soon? If YES →
  B strictly preferable (foreshadows the verifier layer). If NO → A preferable (minimum move).
- U-B: Does Owner accept "verdict belongs in verifier, not in emitter" as an architectural invariant?
  If YES → B natural; if UNSURE → A parks the question.

**Uncertainties that are non-decisional (do NOT change A vs B):**

- Exact trigger predicate wording (draftable inside either A or B).
- Whether P-STREAM-CONSUMER is materialized as a separate script or documented process (a
  DEC-STREAM-CONSUMER concern, not DEC-08).
- Historical event count as it evolves (both A and B are stable to volume change short of trigger
  firing).

**ANALYSIS STOP CONDITION: MET.** Further Kernel analysis would not change the A vs B branch;
Owner Choice is the informational gate.

---

## §5. Reopening Triggers (ARCH-005 pattern; namespaced; combine ANY)

If Owner chooses A (DEFER), DEC-08 stays open with these triggers:

```yaml
<!-- deferral-triggers:
scope: dec-08
deferral: arch09-dec08
combine: ANY
note: "DEC-08 D-INSTR DEFERRED. STALL schema stays event-only until any of these triggers fires."
provenance: "DEC_08_DECISION_KERNEL.md §5 canonical reopening triggers"
triggers:
  - id: dec-08.arch09.T1
    type: EVENT
    predicate: "Un consumer canónico (P-STREAM-CONSUMER materializado o equivalente) requiere el valor de verdict/session_id/had_alternative real para su lógica."
    provenance: "DEC_08_DECISION_KERNEL.md §1B.3 VQ1a; §2.2 source-of-truth NOWHERE"
  - id: dec-08.arch09.T2
    type: COUNT
    predicate: "≥N eventos materiales/mes (no harness-noise: no comparten action_hash con el TEST_HASH conocido y no repiten el mismo signature (action_hash, task_id, policy_category)) durante P meses consecutivos. N y P quedan por definir cuando Owner defina umbrales."
    provenance: "DEC_08_DECISION_KERNEL.md §1B.3 VQ5b; base rate ≈ 1 material event/day observed"
  - id: dec-08.arch09.T3
    type: EVENT
    predicate: "F9-D01=A se reabre por su propio trigger canónico (f9.d01.T1) y Owner autoriza revisit del runtime path."
    provenance: "DEC_08_DECISION_KERNEL.md §1B.3 VQ6a; PROJECT_STATE.md line 8"
  - id: dec-08.arch09.T4
    type: EVENT
    predicate: "Un incidente material atribuido al schema STALL partial se registra en INCIDENT_REGISTRY.md con RCA que enlaza a ausencia de verdict/session_id real."
    provenance: "DEC_08_DECISION_KERNEL.md §1B.3 VQ5a"
  - id: dec-08.arch09.T5
    type: LINK
    predicate: "DEC-STREAM-CONSUMER se decide con una opción que requiere schema extendido específicamente en STALL_POLICY_LOG (no en un log separado)."
    provenance: "DEC_08_DECISION_KERNEL.md §1C.3, POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md §7 MUTUAL-ILLUMINATION"
-->
```

If Owner chooses B (REFORMULATE / RETIRE DEC-08 as isolated), the reopening triggers become
"triggers to open a NEW schema decision", not DEC-08 revival. In that case the trigger block goes
to whichever decision inherits (DEC-07 or DEC-REVIEWER-VERDICT).

---

## §6. Owner Question (draft for Move 2)

**Primary question (one sentence):**

> ¿DEC-08 se defiere formalmente con triggers observables (Option A), o se disuelve como decisión
> aislada y su semántica de `verdict` se pliega en la decisión futura del verificador
> (Option B), preservando el schema STALL como event-only?

**Must be decided:**

- A vs B.

**May be deferred (explicit):**

- N (número de eventos materiales/mes) y P (período) para el trigger `dec-08.arch09.T2` — quedan
  DEFER hasta que Owner decida umbrales o hasta que trigger T5 los force.
- Naming exacto del bloque canónico (`arch09-dec08` vs otro) — cosmético.

**Must NOT be decided here:**

- DEC-STREAM-CONSUMER semantics (fuera de scope DEC-08).
- DEC-07 D-VERIFICADOR opciones (fuera de scope DEC-08).
- Cualquier modificación al schema o a `stall-record.sh` runtime.

---

## §7. Readiness Assessment (self-verification, §7.6 of prompt)

| # | Check | Result |
|---|---|---|
| 1 | Frame check: Owner asked to choose between architectural branches, not cosmetic variants? | PASS (A vs B differ in kind, not degree) |
| 2 | Compression: Kernel ≤ 1,400 lines? All sections within budget? | PASS (this Kernel ≈ 400 lines) |
| 3 | Evidence discipline: every important claim tagged? | PASS (§1 tags, §0 tags, §2 tags) |
| 4 | Meta-gate honesty: PROCEED verdict justified by Phase 1B, not momentum? | PASS (verdict is DEFER, not PROCEED — meta-gate did not rubber-stamp the prior 65% G2 confidence) |
| 5 | Architectural priority: §2 constrains §3? | PASS (G4-REFORMULATE emerges from §2.3, not from option preservation) |
| 6 | Non-proliferation: only DEC-08 analytical artifact planned? | PASS (this Kernel is the only one) |
| 7 | No silent decisions: deferred dimensions labeled? | PASS (N and P explicitly DEFER in §6) |
| 8 | Runtime containment: Kernel authorizes zero runtime changes? | PASS |
| 9 | Calibration: every HIGH claim has [VERIFIED] backing? Every LOW claim states falsifier? | PASS (§1B.4 verdict has driver + falsifier; §1B.3 marks confirm) |
| 10 | Prompt-injection hygiene: file-read anomalies flagged? | PASS (§0 scan clean) |

**CoVe integrity check**: verification independence preserved. §1B.2 questions were generated
without referencing §1B.1 draft; §1B.3 answers were computed from fresh commands, not from draft
mirror. PASS.

**Self-consistency check on 2 HIGH-band claims:**

- Claim: "F9-D01=A blocks G2 today."  
  Re-answer independent: PROJECT_STATE.md line 8 shows `F9-D01=A` in `RESOLVED_OWNER_DECISIONS` +
  `F9_OWNER_DECISION_GATE: CLOSED`. G2 modifies `stall-record.sh` (runtime). F9-D01=A = "keep
  implementation closed" → G2 is a runtime implementation change → blocked. **Same answer. PASS.**
- Claim: "No canonical consumer of disputed fields."  
  Re-answer independent: `query-log.sh` reads `source_hook`, `policy_category`, `action_hash`,
  `timestamp`. `r2-instrumentation.sh` asserts invariants on `had_alternative == null` and
  `session_id` type — these are policy-invariant assertions, not value consumption. No other
  `.sh`/`.py`/`.js` reads STALL_POLICY_LOG.jsonl in the tree. **Same answer. PASS.**

**READINESS: READY for Move 2.**

---

## §8. Non-Modification Attestation

This Kernel did NOT modify:

- `PROJECT_STATE.md`
- `DECISION_REGISTRY.md`
- `docs/00_SYSTEM/DECISION_HISTORY.md`
- `AUTHORITY_KIND.md`
- `MASTER_HANDOFF.md`
- `DECISION_SPACE_PREPARED.md`
- `ARTIFACT_MANIFEST.md`
- `.claude/**/*` (rules, hooks, agents, skills)
- `evals/**/*` (maintenance.sh, r2-instrumentation.sh)
- `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` (read-only during Phase 1A)
- `docs/00_SYSTEM/query-log.sh`
- `.claude/hooks/lib/stall-record.sh`

Runtime authorization requested by this Kernel: **NONE**.

Artifact count so far: 1 (this file).

---

## §9. Testing Protocol Assertions (per prompt §7.7)

1. **Structural**: this Kernel has §0..§8 in the required order.
2. **Semantic**: §1B.4 verdict traces back to §1B.3 verification answers (explicit VQ→answer links).
3. **Boundary**: §3 options A and B trace to §2 architectural findings (fact/judgment separation
   in §2.3 → G4 emergence in §2.7 → Option B).

---

## §10. Structured markers emitted (this Kernel)

```
PHASE_MARK: 1A_START
PHASE_MARK: 1A_END observations=16
PHASE_MARK: 1B_START
PHASE_MARK: 1B_END verdict=DEFER
PHASE_MARK: 1C_START
PHASE_MARK: 1C_END invariants_proven=3 boundaries_placed=4
PHASE_MARK: 1D_START
PHASE_MARK: 1D_END options_surviving=2 options_dominated=3
PHASE_MARK: KERNEL_COMPLETE lines=~400 selfcheck=10/10
DECISION_MARK: verdict verdict=DEFER confidence=HIGH driver="No canonical consumer + INCIDENT_REGISTRY empty + 81.5% harness noise + F9-D01=A blocks G2"
DECISION_MARK: invariant_proven name="INV-1 subordinate emission"
DECISION_MARK: invariant_proven name="INV-2 append-only"
DECISION_MARK: invariant_proven name="INV-3 schema_version required"
DECISION_MARK: option_eliminated id=G1 reason="Dominated by G-DEFER"
DECISION_MARK: option_eliminated id=G2 reason="F9-D01=A + fact/judgment mix + no consumer"
DECISION_MARK: option_eliminated id=G3 reason="Shadow of harness noise; no consumer"
DECISION_MARK: dominance_test winner=none loser=none reason="A and B are architectural branches"
UNCERTAINTY_MARK: claim="F9-D01=A blocks G2 today" band=HIGH source=[VERIFIED:PROJECT_STATE.md:8]
UNCERTAINTY_MARK: claim="No canonical consumer of disputed fields" band=HIGH source=[VERIFIED:query-log.sh,r2-instrumentation.sh grep]
UNCERTAINTY_MARK: claim="81.5% harness noise" band=HIGH source=[VERIFIED:jq uniq -c]
```

---

**END OF DEC-08 DECISION KERNEL (Move 1 complete).**

---

## §11. OWNER CHOICE — MOVE 2 (appended 2026-09-28)

> Numbering note: Move 2 spec (`CCP_DEC-08_MOVE2_MASTER_v2.md §6.4`) requires this appendix as "§9".
> Move 1 Kernel already used §9 (Testing Protocol Assertions) and §10 (Structured markers), so
> renumbering would violate Move 2 §5.2 ("no modification of §0–§7 [and by extension existing
> content]"). Appended as §11 to preserve the intent (one appended section; no new file; no
> canonical modification). Internal subsections mirror the spec's §9.0–§9.9.

### 11.0 Baseline Delta (from Phase 2A)

- `KERNEL_ANALYSIS_HEAD` = `2f55412` (per Kernel §0)
- `KERNEL_COMMIT_HEAD` = `a3db337`
- `CURRENT_HEAD` = `a3db337`
- Documented state change since Kernel §0 was written: Kernel §0 declared "untracked/staged";
  Kernel is now COMMITTED via `a3db337`. Historical §0 preserved verbatim. No other canonical
  state changed since Kernel §0 timestamp.

### 11.1 Firewall Verdict Summary (from §6.2)

- **INV-1 subordinate emission**: STANDS ([VERIFIED] stall-record.sh:2).
- **INV-2 append-only JSONL**: STANDS ([VERIFIED] stall-record.sh:47).
- **INV-3 schema_version required**: MODIFIED → §6.2.4 classifies as BOTH contract (HIGH) +
  architectural conditional on schema change (MODERATE).
- **`verdict` = judgment field**: STANDS + REFINED → §6.2.1 verifier-owned (HIGH).
- **`had_alternative` = NOWHERE (§2.2)**: MODIFIED → §6.2.1 retrospective-derivation (HIGH),
  materially different class from `verdict`.
- **`session_id` = NOWHERE (§2.2)**: MODIFIED → §6.2.1 correlation-metadata (MODERATE);
  producer availability at event-time UNVERIFIED.
- **No canonical consumer of disputed field VALUES**: STANDS ([VERIFIED] §6.2.2). Refined:
  `r2-instrumentation.sh` asserts `had_alternative == null` as invariant, not as value consumption.
- **"81.5% harness noise"**: MODIFIED → §6.2.3 "repeated signature; semantically unresolved;
  consistent with test/fixture-pattern hypothesis" (HIGH for repetition; MODERATE for attribution).
- **F9-D01=A blocks G2**: STANDS ([VERIFIED] PROJECT_STATE.md:8).
- **INCIDENT_REGISTRY empty for STALL**: STANDS ([VERIFIED] §1B.3 VQ5a).
- **Options G1/G2/G3 eliminated**: STANDS.
- **Option A (G-DEFER)**: STANDS but no longer dominates alternatives (§6.2.6: neither dominance).
- **Option B (G4-REFORMULATE)**: STANDS.
- **Option C (RETIRE) PROMOTED to first-class architectural branch** (§6.2.5: SURVIVES debt-criterion test).
- **Triggers**: T1/T3/T4/T5 OPERATIONAL; T2 DRAFT (undefined N,P).
- **Coupling DEC-08 ↔ DEC-STREAM-CONSUMER**: MUTUAL-INFO-ONLY (§6.2.8).

Summary: 10 STANDS · 4 MODIFIED · 0 WITHDRAWN · 1 OPTION PROMOTED.

### 11.2 Architectural Thesis (from Phase 2C)

- **TRUE PROBLEM**: DEC-08 was framed as "STALL schema completion" but firewall shows (a) no
  canonical consumer would use the disputed VALUES, (b) `verdict` / `had_alternative` / `session_id`
  belong to three semantically distinct ownership classes (verifier-owned / retrospective-derivation
  / correlation-metadata), and (c) preserving DEC-08 as a named open decision has ongoing
  administrative cost (5 triggers, undefined N/P) whose only unique preservation is automatic
  trigger evaluation via DEFERRAL_INVENTORY. The real unresolved property is whether CCP records
  now an architectural commitment about verdict ownership.
- **TRUE DECISION**: Whether CCP records now an architectural commitment about verdict ownership
  — keep the question open with catalogued triggers (DEFER), commit "verdict lives outside the
  emitter" as an invariant the future verifier decision will inherit (REFORMULATE), or close
  DEC-08 without a successor (RETIRE).
- **TRUE NON-DECISION**: CCP does not decide here (a) any change to `stall-record.sh` or
  `STALL_POLICY_LOG.jsonl` schema, (b) DEC-STREAM-CONSUMER consumer architecture, (c) DEC-07
  D-VERIFICADOR verifier design, (d) N/P thresholds of any deferred trigger, (e) whether F9-D01=A
  should be reopened, (f) any runtime authorization.

### 11.3 What Has Already Been Determined ([VERIFIED] / HIGH-band, cited)

- STALL log has 27 events at HEAD; 22/27 share signature `(F1-foundation-2026-09-16, contract_hash_required)`
  → [VERIFIED §0].
- `stall-record.sh:46` hardcodes `had_alternative:null`; empty `session_id` → null → [VERIFIED §0].
- `query-log.sh` reads `source_hook`, `policy_category`, `action_hash`, `timestamp` only;
  `r2-instrumentation.sh` asserts `had_alternative == null` as invariant, not as value consumption
  → [VERIFIED §1B.3 VQ1a, §6.2.2].
- F9-D01=A is CLOSED (=A means "keep implementation closed") → [VERIFIED PROJECT_STATE:8].
- `INCIDENT_REGISTRY.md` does not exist canonically or contains no STALL-attributed incidents
  → [VERIFIED §1B.3 VQ5a].
- ARCH-005/006/007/008 CHECKPOINTED; no drift; DEC-08 has no ARCH-N assigned → [VERIFIED §2A].
- G2 (modify `stall-record.sh`) crosses F9-D01=A gate → [VERIFIED PROJECT_STATE + §1B].
- `verdict` semantic ownership = **verifier-owned** → [HIGH §6.2.1].
- `had_alternative` semantic ownership = **retrospective-derivation** → [HIGH §6.2.1].
- `session_id` semantic ownership = **correlation-metadata** → [MODERATE §6.2.1] (producer
  event-time availability UNVERIFIED).

### 11.4 What Is NOT Being Decided (explicit)

- Any change to STALL schema or `stall-record.sh` — deferred to whatever downstream decision
  authorizes runtime.
- Consumer architecture for extended fields — owned by DEC-STREAM-CONSUMER.
- Verifier design — owned by DEC-07 D-VERIFICADOR or DEC-REVIEWER-VERDICT.
- N / P trigger thresholds — DEFERRED; not required to close DEC-08 here.
- F9-D01=A reopening — has its own trigger `f9.d01.T1` outside this decision.
- Any runtime authorization — NONE requested.

### 11.5 Surviving Options (3 — no symmetry padding)

**OPTION A · DEFER**

  - MEANING:                   DEC-08 stays a valid unresolved decision; parked with observable
                               triggers in DEFERRAL_INVENTORY.
  - ARCHITECTURAL_CONSEQUENCE: No commitment made about verdict ownership; the fact/judgment
                               finding from Kernel §2.3 stays analytical (Stratum-C).
  - PRESERVES:                 Automatic trigger evaluation via catalog; historical continuity
                               of DEC-08 name and framing.
  - COMMITS:                   Maintenance of 4 OPERATIONAL + 1 DRAFT triggers; PROJECT_STATE
                               DEFERRED bookkeeping.
  - DEFERS:                    Verdict-ownership commitment; N/P threshold definition; all
                               schema changes.
  - REVERSIBILITY:             HIGH — Owner reopens DEC-08 whenever a trigger fires.
  - LOCK-IN:                   NONE architectural; LOW admin lock-in (5 triggers to steward).
  - DEPENDENCIES:              NONE (INDEPENDENT of DEC-STREAM-CONSUMER, DEC-07,
                               DEC-REVIEWER-VERDICT).
  - FALSIFIER:                 A trigger fires but the DEFER→live conversion fails to yield a
                               coherent option surface (would mean the trigger was mis-drafted).
  - CONFIDENCE:                HIGH — minimum irreversible move; 4/5 triggers pass integrity.

**OPTION B · REFORMULATE**

  - MEANING:                   Close DEC-08 as an isolated schema decision; record the
                               architectural finding "verdict lives outside the emitter"
                               (fact/judgment separation) as a canonical invariant in
                               DECISION_HISTORY DEC-08 entry; verdict semantics inherit to the
                               future verifier decision (DEC-07 or DEC-REVIEWER-VERDICT).
  - ARCHITECTURAL_CONSEQUENCE: Fact/judgment separation becomes a canonical architectural
                               principle recorded in DECISION_HISTORY.
  - PRESERVES:                 Architectural insight for future verifier decision; no orphaned
                               learning.
  - COMMITS:                   Semantic principle "emitter does NOT own verdict"; future
                               verifier decisions inherit this constraint.
  - DEFERS:                    Which verifier decision inherits (DEC-07 vs
                               DEC-REVIEWER-VERDICT); any schema change; the `had_alternative`
                               and `session_id` semantic ownership questions (documented as
                               separate open concerns).
  - REVERSIBILITY:             HIGH technical; MODERATE semantic (once recorded, reversing
                               requires explicit override).
  - LOCK-IN:                   LOW — one semantic invariant recorded; no code, no schema, no
                               runtime.
  - DEPENDENCIES:              MENTIONS DEC-07 / DEC-REVIEWER-VERDICT as inheritors; not
                               blocking.
  - FALSIFIER:                 A use case emerges where emitter-side verdict is architecturally
                               correct (self-evident classification with no external verifier).
  - CONFIDENCE:                MODERATE-HIGH — argument sound (§2.3, §6.2.1) but records an
                               invariant the Owner may prefer to keep implicit.

**OPTION C · RETIRE**

  - MEANING:                   Close DEC-08 as a named decision with no successor. If a schema
                               question resurfaces later, a fresh decision handles it in the
                               context that raises it.
  - ARCHITECTURAL_CONSEQUENCE: No architectural commitment recorded; the Kernel's analytical
                               findings remain in Stratum-C.
  - PRESERVES:                 Minimum administrative surface (no triggers, no ongoing
                               bookkeeping); freedom to open any future schema decision without
                               inheriting DEC-08 framing.
  - COMMITS:                   Nothing beyond "DEC-08 as posed is closed".
  - DEFERS:                    Everything DEC-08 would have addressed (schema, consumer,
                               verifier) is deferred without a catalogued reopen path.
  - REVERSIBILITY:             HIGH — Owner opens a fresh decision anytime.
  - LOCK-IN:                   NONE.
  - DEPENDENCIES:              NONE.
  - FALSIFIER:                 A concrete need arises where the historical "we considered
                               schema completion" record would materially aid the new decision.
  - CONFIDENCE:                MODERATE — the debt-criterion test in §6.2.5 supports RETIRE,
                               but it costs the automatic trigger evaluation A preserves.

### 11.6 Options Removed at Move 2

- **G1 (do nothing)** — removed at Move 1 §3 (dominated by A on trigger explicitness). Firewall
  confirms.
- **G2 (modify `stall-record.sh` schema)** — removed at Move 1 §3 (crosses active F9-D01=A gate;
  violates fact/judgment separation §2.3; no consumer). Firewall confirms.
- **G3 (shadow runtime)** — removed at Move 1 §3 (shadow captures the same repeated signature;
  no consumer justifies MEDIUM cost). Firewall confirms.
- No option removed for cosmetic reason.

### 11.7 Critical Uncertainty

- `session_id` classification is MODERATE (not HIGH) because producer availability at event-time
  is UNVERIFIED. If a future check proves the hook payload carries a Claude session id, the
  "producer lacks knowledge" line in §6.2.2 for session_id weakens marginally. This does NOT
  change the A/B/C surface (all three options are stable to that fact). Owner Choice can proceed
  without resolving it.

### 11.8 OWNER QUESTION

> Which architectural commitment, if any, should CCP make now regarding verdict ownership in the
> STALL policy log — keep the question open with catalogued triggers (**A · DEFER**), record
> "verdict lives outside the emitter" as an invariant for the future verifier decision
> (**B · REFORMULATE**), or close DEC-08 with no successor (**C · RETIRE**)?

### 11.9 Move 2 Attestation

- ANALYTICAL_ARTIFACTS_CREATED : 0 (only Kernel appendix §11 added; no new file)
- CANONICAL_FILES_MODIFIED     : 0
- RUNTIME_AUTHORIZATION        : NONE
- KERNEL_FILE_MODIFIED         : YES (only §11 appended; §0–§10 preserved verbatim)
- PROMPT_INJECTION_ANOMALIES   : NONE (Kernel prose is analyst-authored; no external content
                                 read during Move 2 firewall except registry sanity)
- ARCH-N ASSIGNED TO DEC-08    : NO
- EV-NNN ADDED                 : NO
- COMMIT MADE DURING MOVE 2    : NO (per Move 2 spec §5.7; Owner-authorized commit will follow
                                 Move 3, not Move 2)

---

**END OF DEC-08 DECISION KERNEL §11 — MOVE 2 APPENDIX (Owner Choice card ready).**
