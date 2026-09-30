# 05 — ARCHITECTURE RECOMPOSITION

> **Stratum-C synthesis artifact (non-canonical, read-only).** Minimum system recomposition (§22),
> ideal target vs realistic next step (§23), historical discards revisited (§14), failure-oriented
> analysis (§15), future projection (§19), value/complexity (§20), less-but-stronger (§34). Recommends;
> does not decide or implement.

---

## §1. CURRENT → TARGET (§22 minimum recomposition)

```
CURRENT (9e995a8)
   │  ARCH-001..009 closed; F9 gate closed; 0 open decisions; 0 pending runtime; 60+ verified pieces;
   │  7 LATENT decisions unrecorded in DEFERRAL_INVENTORY; large ANALYTICAL stack (unindexed);
   │  DESIGN.md §11 ARCH naming collision; STALL log = self-observation noise.
   ▼
PROBLEMATIC REDUNDANCIES / DEBTS (not defects)
   · analytical read-path is heavy (later-decision cost, MODERATE)
   · policy double-representation prose↔regex (architectural debt, MODERATE) — latent DEC-04/05
   · latent-decision status is only recorded on unmerged research branches
   · DESIGN §11 vs registry ARCH IDs read as a conflict
   ▼
ABSORB   → make THIS synthesis the single index a future decision starts from (retire the
            requirement to re-read the whole analytical stack)
CONNECT  → record the 7 LATENT decisions with observable predicates by REUSING the ARCH-005
            deferral-policy machinery (if Owner chooses OD-1 = formalize)
REMOVE   → nothing from runtime; only the *implicit* claim that the analytical stack must be
            re-read wholesale
ADD ONLY NECESSARY → zero new runtime pieces; at most documentary bookkeeping (LATENT record) +
            a DESIGN §11 clarity note
   ▼
TARGET (evidence-supported, minimal)
   Same 60+ verified pieces, same 9 ARCH decisions, PLUS:
   · a canonical (or Stratum-C, Owner's choice) record that the 7 historical candidates are LATENT
     with named observable predicates
   · DESIGN §11 marked as a superseded proposal table
   · the analytical chain archived-as-provenance behind this index
   · STALL log understood as self-observation; a *defined* consumer trigger waiting (not built)
```

**The recomposition is almost entirely subtractive-of-confusion, not additive-of-machinery.** CCP does
not need more architecture. It needs its *record* to say "LATENT, no trigger fired" instead of "ABSORBED",
and its *read-path* to be indexed rather than re-derived.

---

## §2. IDEAL TARGET vs REALISTIC NEXT STEP (§23)

### 2.1 Ideal target architecture (may be large; NOT authorized)

A fully matured CCP — *only if concrete needs arrive* — would eventually hold:
`STALL stream consumer (DEC-STREAM-CONSUMER) → post-tool verifier (DEC-07) + reviewer-verdict semantics
(DEC-REVIEWER-VERDICT) → canonical policy source + compiler (DEC-04 ⋈ DEC-05) → document/runtime lifecycle
(DEC-03) → meta-doc governance (DEC-12) → deferral-trigger admission schema (D-TRIGGER-SCHEMA) →
canonicalized Stratum-C boundary`. This is the *option space*, not a plan. Each element opens **only** on
its own observable trigger with its own concrete problem framing.

### 2.2 Realistic next step (minimal, verifiable)

**The realistic next step is documentary and small:**
1. Integrate the research chain to main as a non-canonical analytical record (doc 08), preserving provenance.
2. Record the corrected LATENT status of the 7 candidates (Owner framing OD-1).
3. Clarify DESIGN §11 naming (Class-C, doc 06 EP-C3).
4. Optionally define `stall-consumer.T1` predicate (X1) so the WEAK signal has a falsifiable threshold.

**Never conflate the target (large) with the next step (documentary).** The single most important
architectural instruction to the terminal Claude: *do not build any latent capability without a fired
trigger.*

---

## §3. HISTORICAL DISCARDS REVISITED (§14 — mandatory)

| Discarded / deferred idea | Why then | What changed since | Still invalid? | Could now be valuable? | What would reopen |
|---|---|---|---|---|---|
| DEC-01 monolithic D-CATALOG | inherited framing never attacked | ARCH-007 split it; 3/4 columns had canonical sources | invalid as monolith | E1 (type-taxonomy) sub-part could revive | dec01.T1..T6 |
| CAPABILITY as first-order primitive (DEC-02 K path) | not present in corpus; SPECULATIVE | ARCH-008 kept it NOT PRESENT / NOT REFUTED | not refuted, just absent | yes, under T-CAP-1..5 | arch08.T6 |
| Piece→authority mapping (AB2) | cost/lock-in; premature | ARCH-006 chose AB5 (taxonomy only) | invalid to force now | if per-piece authority ever needed | ARCH-006 T1 |
| DEC-13 external-trigger as own decision | trivial | absorbed into ARCH-005 `trigger:` field | invalid as separate | — | — |
| DEC-STREAM-CONSUMER | volume/diversity too low | STALL still self-observation (97.1% AGREE) | valid to keep deferred | only if defined threshold crossed | defined `stall-consumer.T1` + volume |
| DEC-04/05 policy motor | no enforceable-policy need; F9-D01 closed runtime | double-representation debt accruing (MODERATE) | valid to keep latent | yes IF drift incident or external requirement | F9-D04 external; IDEA-1 concrete need |
| DEC-07 verifier / DEC-REVIEWER-VERDICT | no concrete workflow | ARCH-009 recorded the invariant they'd inherit | valid to keep latent | yes IF a verifier/reviewer workflow is named | arch08.T2; reviewer divergence |
| G-L1 PostToolUseFailure hook | not configured; no observable trigger | still VAGUE | valid to keep deferred | yes IF a tool failure is demonstrably lost | (needs Owner-articulated predicate) |

**§14 discipline honored:** none of these is revived merely because it is "interesting." Each stays
discarded/latent until its named trigger fires. The one with *rising* pressure is DEC-04/05
(double-representation debt), and even that has no fired trigger.

---

## §4. FAILURE-ORIENTED ANALYSIS (§15)

| Failure mode | Current defense | Gap | Severity | Observability | Recovery |
|---|---|---|---|---|---|
| False completion (DONE without evidence) | CTRL-001 fail-closed (LIVE, EXP-OPUS-1) | none | — | STALL log + gate exit 2 | N/A (prevented) |
| Destructive/secret command | bash-firewall + secret-guard P0 fail-closed | none observed | — | STALL log | N/A (prevented) |
| State drift (PROJECT_STATE vs mirror) | pre-compact hash + session-start-compact DRIFT_DETECTED + `/audit-context` | detection only, not auto-repair | LOW | HIGH | `/recovery` |
| Verifier failure / reviewer disagreement | code-reviewer agent + DDD skill (manual) | no *automated* post-tool verifier | LOW today | LOW (no channel) | would need DEC-07 |
| STALL regression window unseen | none automated | no consumer to triage | LOW (probe: 0 divergence) | LOW | would need DEC-STREAM-CONSUMER |
| Policy drift (prose↔regex) | manual sync | no compiler | MODERATE (debt) | LOW | would need DEC-04/05 |
| Stratum-C leaks into canonical | convention + non-modification attestations | invariant unrecorded (no falsifier) | LOW | MODERATE | would need OD-3 |
| Context overflow | PreCompact snapshot + SessionStart compact | none observed | LOW | HIGH | recovery hooks |
| Branch/provenance drift on integration | this synthesis + doc 08 manifest | recomposition needs addenda to travel with it | LOW | HIGH | keep 4-file set intact |

**No failure mode is un-defended for a *fired* condition.** The undefended modes (verifier, stream,
policy-drift) all correspond to LATENT decisions with no fired trigger. Building defenses now = premature.

---

## §5. FUTURE PROJECTION (§19) — labeled, not asserted as fact

| Horizon | Scenario | Label | What would open |
|---|---|---|---|
| NOW | single-Owner CCP, closed backbone | VERIFIED | nothing |
| 3-6 mo | STALL volume step-function from a phase opening (F9-D05/F9-D02) | SCENARIO | DEC-STREAM-CONSUMER (with defined threshold) |
| 3-6 mo | Owner names a concrete verifier/reviewer workflow | SCENARIO | DEC-07 and/or DEC-REVIEWER-VERDICT |
| 6-12 mo | policy double-representation causes a drift incident | HYPOTHESIS | DEC-04 ⋈ DEC-05 |
| 6-12 mo | external audit/compliance/customer requirement (F9-D04) | SCENARIO | DEC-04/05, DEC-07, integrity work (research-first) |
| FUTURE SCALE | multi-user / cross-repo / external trust boundary | HYPOTHESIS | trust-boundary expansion (F9-D04 T5); D-TRIGGER-SCHEMA; possibly capability primitive |

**§19 discipline:** no future scenario is converted to a current requirement. Each is gated on an
observable trigger already catalogued (F9-D0x, arch08.Tx, dec01.Tx) or proposed (stall-consumer.T1).

---

## §6. VALUE / COMPLEXITY of the recomposition moves (§20)

| Move | Value | Complexity | Impl cost | Lock-in | Reversibility | Confidence | Basis |
|---|---|---|---|---|---|---|---|
| Record LATENT status of 7 candidates | HIGH (corrects the record; prevents future "absorbed" misreadings) | LOW | LOW (docs) | LOW | HIGH | 85% | audit+recon+addenda all agree |
| Index the analytical stack (this synthesis) | HIGH (cuts later-decision cost) | LOW | done (this doc set) | NONE | HIGH | 80% | audit §9 lock-in |
| Clarify DESIGN §11 naming | MODERATE (removes a read-as-conflict) | LOW | LOW | LOW | HIGH | 90% | doc 01 C1 |
| Define `stall-consumer.T1` predicate | MODERATE (falsifiable WEAK signal) | LOW | LOW | LOW | HIGH | 70% | audit X1 |
| Build STREAM-CONSUMER / DEC-07 / DEC-04-05 now | NEGATIVE (premature; no trigger) | HIGH | HIGH | MODERATE-HIGH | varies | 90% (that it's premature) | recomposition + audit both NO-MOVE |

**The value is in documentation and indexing, at LOW complexity. Any build move is NEGATIVE-value today.**

---

## §7. LESS-BUT-STRONGER TEST (§34)

> Can CCP get the same value with fewer pieces, docs, decisions, workflows, complexity?

**YES — in documents, NO — in machinery.**

- **Documents:** the analytical corpus (DEC_02_* 5,309 lines untracked, DEC_08_KERNEL, DECISION_SPACE_PREPARED,
  PIECE_AND_IDEA, POST_ARCH-007, MAP_COMPLETE, ATLAS/MAP/ENGINE, K3, ROOT_ANALYSIS, 5 research files) is
  provenance, not required reading. **This synthesis (10 docs) is the smaller, stronger index that
  replaces the requirement to re-read them.** A future decision reads this synthesis + the relevant ADR,
  not the whole stack.
- **Machinery:** the 11 hooks / 5 agents / 20 skills / 12 evals are all value-tested KEEP (doc 03 §3).
  Removing any loses a defense. The enforcement surface is *already* minimal — that is a strength, not a
  target for reduction.
- **Decisions:** 9 ARCH is the minimal closed backbone. The 7 latent decisions are correctly *not built*.
  Fewer would remove real governance; more would be premature.

**Conclusion:** CCP is at, or very near, its "less but stronger" equilibrium on machinery and decisions.
The only slack is documentary read-path, which this synthesis removes by indexing. Additional complexity
is *not* necessary now; where it might become necessary (policy motor, verifier, consumer) it is correctly
deferred behind observable triggers.
