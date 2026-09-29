# 02 — DECISION & ARCHITECTURE LEDGER

> **Stratum-C synthesis artifact (non-canonical, read-only).** Reconstructs every DEC-* and ARCH-*
> per synthesis-prompt §6 (decision reconstruction) and §7 (architecture reconstruction), then builds
> the dependency / authority / state graphs (§7) and the latent-decision reclassification (§13).
> Source-of-truth: `DECISION_REGISTRY.md` (ARCH-N), `PROJECT_STATE.md`, `docs/00_SYSTEM/DECISION_HISTORY.md`,
> `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`, `docs/00_SYSTEM/DEFERRAL_INVENTORY.md`. Confidence bands as in doc 01.

---

## §1. CANONICAL ARCHITECTURE LEDGER (ARCH-001 … ARCH-009)

All nine are **APPROVED / OWNER_CHOSEN, IMPLEMENTED, and CHECKPOINTED**. All are **docs-only / low
lock-in / high reversibility**. None authorizes runtime enforcement.

| ARCH | Decision (what it fixed) | Type | Impl location | Reversibility | Lock-in | Review trigger | Checkpoint |
|---|---|---|---|---|---|---|---|
| ARCH-001 | Control plane installs at project scope `.claude/` | INFRA | `.claude/` + `install.sh` | FÁCIL | LOW | — | (F1, EV-001) |
| ARCH-002 | Context packs load via `SubagentStart.additionalContext`, not agent `skills:` frontmatter | INFRA | `.claude/hooks/subagent-context.sh` + `.claude/context/*` | FÁCIL | LOW | — | (F1, EV-001) |
| ARCH-003 | All change evidence lives in `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | INFRA | EVIDENCE_REGISTRY.md | FÁCIL | LOW | — | (F1, EV-001) |
| ARCH-004 | Task-tracking semantics: CONTRACTUAL vs INTERNAL_TODO vs SUBTASK vs RESEARCH_NOTE; only CONTRACTUAL needs VERIFIED evidence. F8-A: `contract_hash` fail-closed. | PROCESS | `.claude/hooks/task-completed-evidence.sh` | FÁCIL | LOW | — | (F7/F8, EV-012/EV-015) |
| ARCH-005 | DEC-11 HYB-FINAL-v4: deferral policy — YAML trigger blocks, closed vocab `{EVENT,CONDITION,COUNT,DATE,LINK}`, namespaced IDs, `provenance:` per trigger | GOVERNANCE | `docs/00_SYSTEM/DEFERRAL_POLICY.md` + in-situ blocks | FÁCIL (git revert) | LOW | 5 EVENTs, combine ANY | `cd0511c` |
| ARCH-006 | DEC-AUTH-BOUNDARY: materialize PRIM-1 AUTHORITY-KIND as closed 4-class taxonomy `{mecánica, convención, humana, agente}` (VOCAB-A) + evolution rules; NO piece→authority mapping | GOVERNANCE | `docs/00_SYSTEM/AUTHORITY_KIND.md` | FÁCIL | LOW | T1..T4 EVENT, combine ANY | `473759c` |
| ARCH-007 | DEC-01 D-CATALOG SPLIT+DEFER: E1 (type-taxonomy) DEFERRED (dec01.T1..T6); E2/E3/E4 RETIRED with RESOLVED_BY | GOVERNANCE | docs-only bookkeeping | ALTA | LOW | dec01.T1..T6, combine ANY | `e529359` |
| ARCH-008 | DEC-02 D-DELEG: delegation as docs-only `convención`; target = ACTOR; minimum schema `{delegator, delegatee_ref, scope}`; V/Q/P DEFER; CAPABILITY SPECULATIVE | GOVERNANCE | docs-only bookkeeping | ALTA | LOW | arch08.T1..T6, combine ANY | `5dfd65a` |
| ARCH-009 | DEC-08 D-INSTR B·REFORMULATE: invariant "STALL_POLICY_LOG is an event/observation record, not the authoritative source of an independent judgment about its own policy decision"; verdict/had_alternative/session_id semantics DEFERRED | GOVERNANCE | docs-only bookkeeping | ALTA | LOW | **NONE** (B closes, does not defer) | `bf2d22a` |

### 1.1 Per-ARCH invariants & what each did NOT change (§7)

- **ARCH-004** — established the *fact/contract* discipline (evidence-before-DONE). Did NOT create a
  new hook (reused the existing L5 gate = CTRL-001). Invariant: only CONTRACTUAL tasks pass the gate.
- **ARCH-005** — normalization ≠ semantic change ≠ reopening. Did NOT add runtime, periodic review,
  or lint. Invariant: 34/36 deferral triggers were already observable; retrofit is literal.
- **ARCH-006** — VOCAB-A is **CLOSED**: a 5th authority class requires formal reopening. Did NOT map
  pieces to authorities (that is prohibited by §6, and attempting it fires T4). Invariant: authority
  kind is a first-order object but has no registry.
- **ARCH-007** — a monolith (`type × gate × auth_holder × precedent`) split into 4 verdicts. Did NOT
  create any taxonomy file. Invariant: 3 of 4 columns already had canonical sources; the 4th
  (auth_holder) is prohibited by ARCH-006 §6.
- **ARCH-008** — "target = ACTOR" and "semantic minimum = 3 fields" derived after eliminating
  over-extensions. Did NOT force a DELEGATION_REGISTRY, add fields, or touch VOCAB-A. Invariant:
  a repo reference is an addressing mechanism, not a semantic identity.
- **ARCH-009** — "verdict lives outside the emitter." Did NOT name DEC-07 as the definitive owner,
  change the STALL schema, or create reopening triggers. Invariant: event ≠ independent judgment.

---

## §2. OWNER-GATE LEDGER (F9-D01 … F9-D05, closed 2026-09-20)

| Gate | Choice | Meaning | Trigger class (DEFERRAL_INVENTORY Cluster A) |
|---|---|---|---|
| F9-D01 | A | Keep F9 **runtime implementation** closed | 5 EVENT triggers (100% observable) |
| F9-D02 | B | Defer native Claude Code evidence | 2 EVENT + 2 CONDITION |
| F9-D03 | B | Keep 6 documentary candidates deferred (G-S1,G-S2,G-Bob-1,G-A1,G-N1,G-N2) | 5 EVENT + 1 CONDITION |
| F9-D04 | B | External-requirement trigger for integrity work (audit/compliance/customer/trust-boundary) | 5 EVENT + 1 CONDITION; **research-first, not implementation** |
| F9-D05 | A | Keep F10-F12 UNKNOWN | 1 EVENT+THRESHOLD + 1 LINK |

> **Load-bearing distinction (the audit's central correction).** F9-D01=A scopes **runtime
> implementation authorization**, not **decision space**. ARCH-005/006/007/008/009 were each opened,
> analyzed, and closed as docs-only bookkeeping *without* any F9 runtime authorization. Therefore
> "F9-D01=A" cannot *absorb* a latent decision — it only blocks its *runtime implementation*.
> [VERIFIED: F9_OWNER_DECISIONS.md:46-60; confirmed by cloud audit §2, reconciliation §2.]

---

## §3. RETIRED / ABSORBED DECISIONS

| DEC | Status | Resolved by |
|---|---|---|
| DEC-06, DEC-09, DEC-10, DEC-13 | RETIRED | absorbed / trivial / non-decision (DEC-13 external-trigger absorbed into ARCH-005 `trigger:` field) |
| DEC-01-E2 (gate-mapping) | RETIRED | `.claude/hooks/*` + `.claude/rules/*` + `settings.json` (hooks *are* the gates) |
| DEC-01-E3 (auth_holder-mapping) | RETIRED | ARCH-006 (`AUTHORITY_KIND.md`); mapping is PROHIBITED by §6 |
| DEC-01-E4 (precedent-index) | RETIRED | `DECISION_REGISTRY` + `DECISION_HISTORY` + git log |
| DEC-11 | CLOSED → ARCH-005 | Owner HYB-FINAL-v4 |
| DEC-AUTH-BOUNDARY | CLOSED → ARCH-006 | Owner AB5+VOCAB-A |
| DEC-01 | CLOSED → ARCH-007 | Owner E SPLIT+DEFER |
| DEC-02 | CLOSED → ARCH-008 | Owner R1+K-A+MINIMUM |
| DEC-08 | REFORMULATED/CLOSED → ARCH-009 | Owner B REFORMULATE |

---

## §4. LATENT DECISION LEDGER (the corrected reading — §13 recheck)

These are the historical candidate decisions that earlier documents (MASTER_HANDOFF, DECISION_SPACE_PREPARED,
PIECE_AND_IDEA, POST_ARCH-007) list as UNKNOWN/pending. The post-DEC-08 recomposition (28f13ee) tried to
mark them ABSORBED; the cloud adversarial audit (40d9290), the cross-audit reconciliation (62048e9), and
the recomposition addenda (dd298e1) **all converge** on the corrected classification: **LATENT — no
trigger fired.** None is in `DEFERRAL_INVENTORY`.

| DEC | Problem atom | Recomposition said | **Corrected (audit+recon+addenda)** | Why not ABSORBED | Observable re-open condition |
|---|---|---|---|---|---|
| DEC-07 (D-VERIFICADOR) | verifier semantic delegation (P2a) | ABSORBED via F9-D01=A + ARCH-009 inheritance | **LATENT — NO ABSORPTION** | F9-D01=A = runtime, not decision-space (category error, HIGH); ARCH-009 §11.4 explicitly does NOT decide verifier design; not in DEFERRAL_INVENTORY | Owner names a concrete post-tool verifier workflow; `arch08.T2` fires |
| DEC-REVIEWER-VERDICT | asymmetric reviewer verdict (P2b) | ABSORBED (same path) | **LATENT — NO ABSORPTION** | same category error; marked NEW/independent in DECISION_SPACE_PREPARED §98 | two-reviewer divergence event; workflow needs asymmetric-verdict emission |
| DEC-04 (D-CANONICAL) | which policy artifact is authoritative | ABSORBED via F9-D03=B + F9-D04 | **LATENT (pair) — NO ABSORPTION** | F9-D03's 6 documentary items have ZERO overlap with policy-source (scope mismatch, HIGH); F9-D04 external triggers orthogonal | external requirement; PIECE_AND_IDEA IDEA-1 concrete need |
| DEC-05 (D-MOTOR) | how policy compiles canonical→enforcement | ABSORBED (same path) | **LATENT (pair) — NO ABSORPTION** | same scope mismatch; irreducible partner of DEC-04 | same as DEC-04 (must follow it) |
| DEC-03 (D-LIFECYCLE) | document/artifact lifecycle | NO-CANDIDATE via no-signal | **LATENT — NO ABSORPTION (soft)** | "no incident observed" ≠ "no need"; no observation channel guarantees drift surfaces | lifecycle-tagged incident; IDEA-3 rollback-contract need; runtime hook lifecycle unfreezes (F9-D02/F10-F12) |
| DEC-12 (D-META-DOC) | meta-doc governance / handoff drift | NO-CANDIDATE via snapshot sufficiency | **LATENT — NO ABSORPTION (soft)** | ARCH-006 §7 snapshot policy covers only MASTER_HANDOFF, not the meta-doc class | meta-doc drift observed; PT-3 policy question |
| DEC-STREAM-CONSUMER | consumer of accumulated STALL events | ABSORBED via absence-of-need + `stall-consumer.T1` | **LATENT — WEAK SIGNAL** | `stall-consumer.T1` predicate (N,K) undefined → not honest absorption; not in DEFERRAL_INVENTORY | STALL volume/diversity crosses a *defined* threshold; any STALL-tagged incident |

**Corrected structure of the former "irreducible triad":** `DEC-02 + DEC-04 + DEC-05` (DECISION_SPACE_PREPARED
§48) is **historically stale**. ARCH-008's R1+MINIMUM decoupled DEC-02 (the 3-field minimum needs no policy
corpus). Correct residual = **binary latent pair `{DEC-04 ⋈ DEC-05}`** (canonical-source must precede its
compiler), with DEC-02 **orthogonal**. [Confidence MODERATE-HIGH; falsifier F3 (that ARCH-008 R1 presumed
DEC-04 open) NOT MET on reading DECISION_HISTORY DEC-02.]

### 4.1 Two newly-surfaced latent items (hidden-decision search, audit §7)

| Item | What it is | Class | Status |
|---|---|---|---|
| **D-TRIGGER-SCHEMA** | Who authorizes *novel* deferral triggers, under what schema/predicate discipline? Surfaced because the recomposition invented 3 triggers (`stall-consumer.T1`, `verifier-workflow.T1`, `reviewer-verdict.T1`) with undefined predicates and no adoption path. ARCH-005 governs *how existing entries carry* triggers, not admission of *new classes*. | NEW-CANDIDATE (WEAK) — LATENT | Not opening-worthy today; below convergence threshold (est. 6-8/15) |
| **Stratum-C ↔ canonical boundary** | The rule "nothing Claude writes as Stratum-C becomes canonical without Owner authorization + a canonical write path" — practiced across ARCH-005..009 but never formally decided (no ARCH-N, no falsifier). | LATENT GOVERNANCE INVARIANT (adopted by convention) | Stable & reversible; name it, don't rush it |

---

## §5. DEPENDENCY GRAPH (§7)

```
                         ARCH-001 (project scope)
                              │
        ┌─────────────────────┼─────────────────────────┐
   ARCH-002 (context load)  ARCH-003 (evidence path)  ARCH-004 (task semantics + F8-A)
        │                        │                         │
        │                        │                    CTRL-001 (TaskCompleted gate, L5)
        │                        │                         │
        └───────────── ARCH-005 (DEFERRAL_POLICY) ─────────┘
                              │  (procedural precedent for ↓)
                    ┌─────────┼──────────────┬──────────────┐
              ARCH-006      ARCH-007       ARCH-008        ARCH-009
           (AUTHORITY-KIND)(D-CATALOG)   (D-DELEG)       (D-INSTR)
                 │  \          │  (E1 DEFER uses ARCH-005) \      │
                 │   \ (§6 prohibits E3)                    \  (invariant inherited by ↓ if opened)
       consumers:│    ARCH-008 cites classes                \
       agente/humana   agente/humana                         DEC-07 / DEC-REVIEWER-VERDICT (LATENT)
```

- **SOFT/ENABLER (not HARD)** edges: ARCH-006 → ARCH-008 (delegatee kinds), ARCH-006 → ARCH-007 (E3 prohibition),
  ARCH-005 → ARCH-006/007/008 (procedural precedent), ARCH-009 → DEC-07/DEC-REVIEWER-VERDICT (invariant on opening).
- **No HARD blocking edges remain open.** Every canonical dependency is satisfied. The only edges into the
  latent set are SOFT (invariant inheritance), which do not force opening.
- **DEC-04 ⋈ DEC-05** is the single HARD internal edge among latent decisions (canonical-source precedes compiler).

## §6. AUTHORITY GRAPH (per ARCH-006 VOCAB-A)

```
humana (Owner)  ── authorizes ──▶ every ARCH-N Owner Choice, every implementation gate, every deferral trigger admission
   │
   ├─ delegates (ARCH-008 convención) ──▶ agente (.claude/agents/*.md: researcher, architect, implementer,
   │                                       code-reviewer, security-auditor) within {delegator, delegatee_ref, scope}
   │
mecánica (hooks P0/P1..) ── enforces ──▶ bash-firewall, secret-guard, task-completed-evidence (CTRL-001),
   │                                       stall-record, session/precompact/config hooks
   │
convención (docs governance) ── records ──▶ ARCH-005..009 invariants, deferral policy, delegation model
```

- **Authority collisions:** none found. `mecánica` (hooks) enforces; `convención` (docs) records;
  `humana` decides; `agente` executes within scope. Clean separation.
- **Orphaned authority:** the Stratum-C boundary invariant is exercised as `convención` but not recorded
  as one (see §4.1) — the one authority not yet named.

## §7. STATE / EVIDENCE FLOW GRAPH

```
Owner Choice ──▶ ARCH-N in DECISION_REGISTRY ──▶ DECISION_HISTORY learning entry ──▶ PROJECT_STATE update
     │                     │                                                              │
     │              EVIDENCE_REGISTRY (EV-NNN)  ◀── only CONTRACTUAL tasks (ARCH-004);   │
     │              (F1-F8 code work: EV-001..016)     docs-only ARCH-005..009 need none  │
     │                                                                                    ▼
   checkpoint (git) ◀────────────────────────────────────────────── LAST_GIT_CHECKPOINT = bf2d22a
```

- **Docs-only bookkeeping pattern (ARCH-004-derived):** ARCH-005/006/007/008/009 did NOT emit individual
  EV-NNN; their aggregated evidence lives in the ADR EVIDENCIA section + DECISION_HISTORY. Only the F1-F8
  *code* work produced EV-001..016. This is a deliberate, canonical asymmetry — governance decisions that
  change no runtime need no separate evidence entry.

---

## §8. DECISION VALIDITY SUMMARY (§6 classification)

| Decision | Validity |
|---|---|
| ARCH-001..004 | STILL VALID (foundation) |
| ARCH-005..009 | STILL VALID (governance backbone) |
| F9-D01..D05 | STILL VALID (gate closed) |
| DEC-06/09/10/13, DEC-01-E2/E3/E4 | HISTORICAL / ABSORBED |
| DEC-01-E1 | DEFERRED (observable triggers) |
| DEC-03/04/05/07/12/STREAM-CONSUMER/REVIEWER-VERDICT | **LATENT** (not ABSORBED; no trigger fired; not in DEFERRAL_INVENTORY) |
| D-TRIGGER-SCHEMA, Stratum-C boundary | LATENT (newly surfaced) |
| DESIGN.md §11 ARCH-001..005 mapping | SUPERSEDED by DECISION_REGISTRY (naming legacy; see C1) |

**No decision is REOPEN-WORTHY today.** Every latent decision awaits a concrete, observable trigger; none
has fired. This ledger does not reopen anything (synthesis-prompt §6: "No reabras decisiones automáticamente").
