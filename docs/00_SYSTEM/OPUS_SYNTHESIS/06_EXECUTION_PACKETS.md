# 06 — EXECUTION PACKETS

> **Stratum-C synthesis artifact (non-canonical, read-only).** Execution-candidate discovery (§24),
> execution packets (§25), no-blind-spot falsifiers (§26), priority (§32). Answers the bridge question:
> **"What can the terminal Claude execute WITHOUT opening a new DEC?"** Nothing here is executed by this
> synthesis; these are prepared packets.

---

## §1. EXECUTION-CANDIDATE CLASSIFICATION (§24)

Every actionable item, classed A–H:

| Item | Class | Rationale |
|---|---|---|
| ARCH-001..009 governance backbone | **A — ALREADY IMPLEMENTED** | all CHECKPOINTED |
| F1-F8 runtime + evals + hooks | **A — ALREADY IMPLEMENTED** | EV-001..016 VERIFIED; maintenance 12/12 |
| Corrections B1..B5 (LATENT reclassification) | **A (on research branch)** | recorded in `POST_DEC-08_RECOMPOSITION_ADDENDA.md` under Owner Q1=YES; **not yet on main** |
| X-STALL divergence probe | **A (on research branch)** | executed under Owner Q2=YES |
| Integrate research chain to main as non-canonical analytical record | **C — SMALL DOC/BOOKKEEPING** | additive `docs/00_SYSTEM/*.md`; no DEC, no canonical-decision change; push-to-main is Owner-gated (git-policy) |
| This OPUS_SYNTHESIS index → main | **C — SMALL DOC/BOOKKEEPING** | additive docs; same gate |
| Clarify DESIGN.md §11 ARCH naming collision | **C — SMALL DOC/BOOKKEEPING** | edits a canonical doc for clarity only; reversible; recommend Owner ack |
| Confirm B5 origin (X6) | **E — REQUIRES EXPERIMENT** | read-only correlation; not required |
| Record the 7 LATENT decisions as canonical DEFERRAL_INVENTORY entries w/ predicates | **D — REQUIRES OWNER DECISION** | OD-1 (framing) + OD-2 (trigger schema); changes canonical governance |
| Define `stall-consumer.T1` / `verifier-workflow.T1` / `reviewer-verdict.T1` predicates | **D — REQUIRES OWNER DECISION** | D-TRIGGER-SCHEMA (OD-2) |
| Canonicalize the Stratum-C boundary as ARCH-N | **D — REQUIRES OWNER DECISION** | OD-3 |
| Retract/relabel DECISION_SPACE_PREPARED §48 triad claim | **D — REQUIRES OWNER DECISION** | OD-4 (framing) |
| Build STREAM-CONSUMER / DEC-07 / DEC-04-05 / DEC-03 / DEC-12 | **F — DEFERRED / D** | no fired trigger; opening any is Owner-only |
| DEC-06/09/10/13, DEC-01-E2/E3/E4 | **G — RETIRED** | resolved |
| Native Claude Code lifecycle facts | **H — UNKNOWN** | NOT_VERIFIED; deferred F9-D02=B |

> **Honest headline:** CCP is a **closed system**. There are **no Class-B (authorized-but-unbuilt
> feature)** items — every authorized thing is built. The only executable work without an Owner
> decision is **Class C (documentation/integration/bookkeeping)** and one **Class E (read-only
> experiment)**. All substantive change is **Class D (Owner-gated)** — see doc 07.

---

## §2. EXECUTION PACKETS (§25) — the Class-C / Class-E items

### EP-C1 — Integrate the post-DEC-08 research chain to main (non-canonical record)

```
EXECUTION_ID     : EP-C1
CLASS            : C (documentation/bookkeeping); PUSH gated by git-policy (main push = Owner confirm)
SOURCE_DECISION  : Owner Q1=YES (record corrections as Stratum-C addenda) + Q2=YES (STALL probe)
SOURCE_ARCH      : ARCH-005 (Stratum-C convention), ARCH-004 (docs-only bookkeeping pattern)
PROBLEM          : The post-DEC-08 analytical chain (recomposition + audit + reconciliation + addenda +
                   probe) lives on two unmerged branches + PR #3. It is finished, verified, and
                   Owner-authorized analysis, but not on main; future readers can't find it canonically.
AUTHORIZED_SCOPE : bring the 5 research files into main's docs/00_SYSTEM/ as NON-CANONICAL Stratum-C
                   analytical record; keep every non-modification attestation intact.
NON_GOALS        : NO canonical decision change; NO DEFERRAL_INVENTORY edit; NO ARCH-N; NO reopening of
                   any DEC; NO STALL/hook/runtime change; do NOT "apply" the corrections to canonical
                   files (that is OD-1, Class D).
FILES_EXPECTED   : docs/00_SYSTEM/POST_DEC-08_DECISION_SPACE_RECOMPOSITION.md,
                   POST_DEC08_CROSS_AUDIT_RECONCILIATION.md, POST_DEC-08_RECOMPOSITION_ADDENDA.md,
                   X_STALL_SEMANTIC_DIVERGENCE_PROBE.md, CLOUD_ADVERSARIAL_AUDIT_POST_DEC08.md
                   (+ this OPUS_SYNTHESIS/ set)
IMPLEMENTATION STEPS: see doc 08 (INTEGRATION_MANIFEST) — the recomposition 4-file set MUST travel
                   together; the audit references 28f13ee and must stay resolvable.
DEPENDENCIES     : none technical; OD-1 framing is independent (integration can precede or follow it)
INVARIANTS       : main stays canonically unchanged except for additive non-canonical docs; provenance
                   (author, branch, commit) preserved in each file's header.
TEST PLAN        : bash evals/maintenance.sh → expect 12/12 (docs additions must not break checks);
                   grep for accidental canonical edits (git diff main -- DECISION_REGISTRY.md
                   PROJECT_STATE.md DECISION_HISTORY.md DEFERRAL_INVENTORY.md AUTHORITY_KIND.md → empty).
VERIFICATION PLAN: git diff --stat shows only additions under docs/00_SYSTEM/; maintenance 12/12.
ROLLBACK         : git revert of the integration commit (docs-only, clean).
SUCCESS CRITERIA : 5 research files + synthesis present on main; 0 canonical-decision files changed;
                   maintenance 12/12; PR #3 closed (merged or superseded) or left open per Owner.
DONE EVIDENCE    : maintenance 12/12 output + git diff --stat + a note in DECISION_HISTORY only if
                   Owner elects (else pure docs addition, ARCH-004 docs-only = no EV-NNN).
```

### EP-C2 — Publish OPUS_SYNTHESIS as the single index

```
EXECUTION_ID     : EP-C2
CLASS            : C (documentation)
SOURCE_ARCH      : ARCH-003/004 (docs), ARCH-005 (Stratum-C)
PROBLEM          : the analytical stack is heavy to re-read (audit §9 later-decision-cost, MODERATE).
AUTHORIZED_SCOPE : keep this OPUS_SYNTHESIS/ set as the canonical entry index for any future decision;
                   optionally link it from README/handbook (Owner ack for canonical-doc link).
NON_GOALS        : deleting or rewriting the archived analytical stack; canonicalizing this synthesis
                   as a decision.
FILES_EXPECTED   : docs/00_SYSTEM/OPUS_SYNTHESIS/00..09
TEST/VERIFY      : links resolve; maintenance 12/12.
ROLLBACK         : rm the directory (docs-only).
SUCCESS CRITERIA : a future decision-opener reads 00_MASTER_INDEX → relevant ADR, not the whole stack.
DONE EVIDENCE    : the index exists and resolves.
```

### EP-C3 — Clarify DESIGN.md §11 ARCH naming collision

```
EXECUTION_ID     : EP-C3
CLASS            : C (documentation; edits a canonical doc → recommend Owner ack)
SOURCE           : doc 01 §5.2 C1
PROBLEM          : DESIGN.md §11 maps ARCH-001..005 to infra decisions with the SAME IDs the canonical
                   DECISION_REGISTRY uses for the governance arc — reads as a conflict.
AUTHORIZED_SCOPE : add a one-line note to DESIGN §11: "IDs here are the original design-time proposal
                   table; the canonical decision IDs are in DECISION_REGISTRY.md (ARCH-001..009)."
                   Do NOT renumber anything.
NON_GOALS        : renumbering ARCH IDs; changing any decision content; touching DECISION_REGISTRY.
INVARIANTS       : DECISION_REGISTRY remains the single source of decisions (DESIGN §4).
TEST/VERIFY      : maintenance 12/12; `/audit-context` no new CONFLICT.
ROLLBACK         : git revert (one-line doc change).
SUCCESS CRITERIA : DESIGN §11 no longer reads as a competing ARCH registry.
FALSIFIER (§26)  : if the DESIGN §11 IDs are actually *referenced* by a live consumer as canonical
                   decision IDs, a bare note is insufficient and a renumber discussion (Class D) is
                   needed. (No such consumer found this session.)
```

### EP-E1 — Confirm B5 STALL-event origin (X6, read-only)

```
EXECUTION_ID     : EP-E1
CLASS            : E (experiment, read-only)
SOURCE           : doc 04 §3.1 (U-B5 hypothesis, HIGH)
PROBLEM          : one STALL event (B5, task_id="1", 2026-09-24T18:05:06Z) has unconfirmed origin.
METHOD           : correlate its timestamp with docs/00_SYSTEM/archive/CLAUDE_SESSION_LOG.2026-09-*
                   and git reflog/commit times ±5min (read-only). This synthesis already hypothesizes
                   (HIGH) it is an agent-session harness TaskCompleted, matching EXP-OPUS-1.
NON_GOALS        : modifying the STALL log; opening DEC-STREAM-CONSUMER.
TEST/VERIFY      : a session/tracker context at that timestamp with a numeric task id.
ROLLBACK         : N/A (read-only).
SUCCESS CRITERIA : U-B5 moves HYPOTHESIS-HIGH → VERIFIED, or a counter-origin surfaces (falsifier).
FALSIFIER (§26)  : a non-tracker origin (manual gate call) at that timestamp would refute the
                   agent-session hypothesis (but still not change any outcome — B5 stays self-observation).
```

---

## §3. NO-BLIND-SPOT (§26)

Each packet carries a falsifier (above). The one discovery that could invalidate the *whole* Class-C
posture:

```
GLOBAL FALSIFIER: if the missing cache file CCP_COMPLETE_SYSTEM_AND_COMPETITIVE_ANALYSIS.md (absent
from the recomposition's 4/5 cache) contains a NOVEL decision atom not covered by the 7 latent + 2
newly-surfaced items, then the "closed system, only bookkeeping executable" conclusion is incomplete
and a re-recomposition (Class D/E) is warranted. [INFERENCE: the 4 present cache files (6,249 lines)
would very likely have referenced any cross-cutting atom; no proof. Owner may supply the file to close.]
```

---

## §4. EXECUTION PRIORITY (§32)

| Priority | Packet | Why |
|---|---|---|
| **P0** (prerequisite/safety) | EP-C1 integration (provenance preservation) | analysis is lost/unfindable if branches drift; low risk; enables everything downstream |
| **P1** (high leverage / low lock-in) | EP-C2 index + EP-C3 DESIGN clarity | cut later-decision cost; remove read-as-conflict; both LOW cost/lock-in |
| **P2** (useful enhancement) | EP-E1 (X6) confirm B5 | closes the one UNCERTAIN; read-only |
| **P3** (future) | anything gated on OD-1..OD-5 (doc 07) | Owner-only; no fired trigger |

**Priority note (§32):** this is operational ordering by dependency/risk/readiness, NOT a "best
architecture" score. P0 is first because provenance is perishable; everything else is optional and
Owner-gated.
