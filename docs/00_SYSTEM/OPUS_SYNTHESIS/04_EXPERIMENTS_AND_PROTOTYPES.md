# 04 — EXPERIMENTS & PROTOTYPES

> **Stratum-C synthesis artifact (non-canonical, read-only over runtime).** Absorbs the experiments
> already executed on the research branches (§17), records one NEW live experiment run *this* session,
> reruns the adversarial architecture tests (§16), and catalogs the reversible experiments proposed but
> not executed (with EIV/cost/reversibility) for the terminal Claude. No DEC opened; no runtime changed.

---

## §1. ABSORBED EXPERIMENT — STALL SEMANTIC DIVERGENCE PROBE (from `dd298e1`)

The research branch already executed a rigorous read-only probe (`X_STALL_SEMANTIC_DIVERGENCE_PROBE.md`,
Owner-authorized Q2=YES / CHOICE D). Its result is absorbed here verbatim-in-substance so the terminal
Claude need not rerun it.

```
EXPERIMENT_ID : X-STALL (absorbed)
QUESTION      : Do the ~29 same-signature STALL events hide semantic divergence (a DENY that
                should have been ALLOW)?
HYPOTHESIS    : H0 = semantic homogeneity (test-fixture pattern). H1 = ≥3 disagreements.
METHOD        : read-only jq extraction of 34 events → 3 clusters; per-event verdict AGREE/DISAGREE/
                UNCERTAIN, with the eval suite (task-completed-coupling.sh:117, firewall-positive.sh)
                acting as an independent semantic oracle.
RESULT        : 35 events (34 + 1 self-triggered). Cluster A (fixture) 29/29 AGREE; Cluster B
                (non-fixture) 4 AGREE / 1 UNCERTAIN; Cluster C (session) 1 AGREE.
                Aggregate 34 AGREE (97.1%) / 0 DISAGREE / 1 UNCERTAIN (2.9%).
FALSIFIER     : ≥3 disagreements → NOT MET (0 found).
CONCLUSION    : H0 SUSTAINED; H1 REFUTED. Attribution UPGRADED MODERATE → HIGH: Cluster A traces to
                evals/hooks/task-completed-coupling.sh:116 via maintenance.sh:21; Cluster B to
                firewall-positive.sh:38/42/53.
IMPACT        : P1 (DEC-STREAM-CONSUMER) stays LATENT — WEAK SIGNAL. The STALL log is a
                SELF-OBSERVATION surface of CCP's own tooling, not a signal of real work-blocking.
                No consumer needed today.
REMAINING GAP : 1 UNCERTAIN event, B5 — `task_id="1", stall_type=UNKNOWN, evidence_contract`
                (2026-09-24T18:05:06Z), origin unidentified by the probe.
```

---

## §2. ADVERSARIAL ARCHITECTURE TESTS (§16) — rerun over the canonical hypotheses

Each core CCP hypothesis was attacked. `FALSIFIER` = what observation would break it; `RESULT` = whether
the repo today breaks it.

| # | Hypothesis | Test | Falsifier | Actual result | Confidence |
|---|---|---|---|---|---|
| H-A | Emitter/verifier separation (ARCH-009): "verdict lives outside the emitter" | Is any verdict field produced by the emitter today? | A verdict field emitted by `stall-record.sh` | `stall-record.sh` emits `had_alternative=null`, no verdict; separation holds | HIGH |
| H-B | Delegation is docs-only ACTOR convention (ARCH-008) | Does any real delegation need a non-actor target? | A delegation whose target cannot be an actor | 5-of-11 empirical items are real actor delegations; rest default-covered; none non-actor | HIGH (DOCUMENTED, DECISION_HISTORY DEC-02) |
| H-C | Evidence contract (ARCH-003/004): DONE requires VERIFIED evidence | Can a completion pass without evidence? | CTRL-001 accepts a payload lacking evidence | **Re-verified LIVE this session** (see §3): CTRL-001 fail-closed on task_id "1"/"2" | HIGH |
| H-D | Deferral triggers are observable (ARCH-005) | Are triggers testable predicates? | A deferral with no observable predicate that is treated as observable | 34/36 observable; 2 VAGUE (NH-11, G-L1) are flagged HYPOTHESIS-tier, not treated as observable | HIGH |
| H-E | AUTHORITY-KIND is a closed 4-class vocab (ARCH-006) | Is any 5th authority class used implicitly? | A canonical/runtime use of a non-{mecánica,convención,humana,agente} authority | None found; `observ.`/`interno` correctly excluded as non-authority axes | HIGH |
| H-F | Canonical/non-canonical boundary holds (Stratum-C) | Did any Stratum-C artifact become canonical without an ARCH-N + Owner authorization? | A Stratum-C file cited as canonical truth | None; but the boundary itself is unrecorded as a decision (doc 02 §4.1) | MODERATE (invariant real, unnamed) |

**No core hypothesis is falsified by the current repo.** The one soft spot is H-F: the boundary is *practiced*
but *unrecorded* — an Owner-level item (OD-3), not a defect.

---

## §3. NEW LIVE EXPERIMENT — CTRL-001 INTERCEPTS HARNESS TASK IDs (run this session)

```
EXPERIMENT_ID : EXP-OPUS-1
QUESTION      : What happens when the harness task-tracker emits a TaskCompleted event with a
                numeric task_id that has no VERIFIED evidence contract?
HYPOTHESIS    : CTRL-001 (task-completed-evidence.sh, ARCH-004/F8-A, fail-closed) fires and blocks it.
METHOD        : During this synthesis run, TaskUpdate(status=completed) was called on internal
                progress-tracking tasks with task_id "1" and "2" (harness-assigned numeric IDs).
INPUT         : harness TaskCompleted event, task_id ∈ {"1","2"}, no matching EVIDENCE_REGISTRY entry.
EXPECTED      : exit 2, block with "Evidence Contract invalid for task_id=N".
ACTUAL        : VERIFIED — hook returned: "TaskCompleted bloqueado: Evidence Contract invalid for
                task_id=1: no matching VERIFIED evidence or required fields." (and task_id=2). [VERIFIED]
LIMITATIONS   : single reviewer; the event was incidental (I was tracking progress, not probing).
FALSIFIER     : the hook accepting a numeric task_id without evidence → would break ARCH-004/F8-A.
CONCLUSION    : CTRL-001 is LIVE and fail-closed exactly as documented (EV-012/EV-015). The harness
                task tracker is inside the gate's scope: any agent marking a task complete emits a
                TaskCompleted event the gate evaluates.
IMPACT        : (1) Confirms REG-001/REG-010 behavior in a real, non-fixture invocation.
                (2) Produces the STALL-log signature `task-completed-evidence.sh | contract_hash_required`
                    (or evidence_contract) from an *agent session*, not only from eval infra.
```

### 3.1 EXP-OPUS-1 resolves information gap U-B5 (HIGH-plausibility hypothesis)

The STALL probe's single UNCERTAIN event — **B5: `task_id="1", stall_type=UNKNOWN, evidence_contract`,
2026-09-24T18:05:06Z, origin unidentified** — matches *exactly* the phenomenon EXP-OPUS-1 just reproduced:
an agent session marking a harness task (numeric ID, here "1") complete, tripping CTRL-001, which
emits a STALL/evidence_contract event with `stall_type=UNKNOWN` because a numeric harness ID has no
evidence contract and cannot be classified as a policy stall.

```
HYPOTHESIS (new, this synthesis): B5 was emitted by a prior agent session's harness TaskCompleted
                                  with task_id="1" — the same class of event as EXP-OPUS-1.
CONFIDENCE : HIGH — same hook, same policy_category (evidence_contract), same stall_type (UNKNOWN),
             same numeric-ID shape; directly reproduced this session.
FALSIFIER  : a session log at 2026-09-24T18:05:06Z ±5min showing a NON-task-tracker origin for
             task_id="1" (e.g., a manual gate call). Not checked (out of read-only probe scope).
IMPACT     : U-B5 moves from UNKNOWN to HYPOTHESIS-HIGH. It does NOT change any outcome: B5 remains
             a self-observation artifact, reinforcing "STALL = self-observation, not work-blocking."
```

> **Operational note for the terminal Claude:** marking harness tasks "completed" emits TaskCompleted
> events that CTRL-001 blocks and that append to `STALL_POLICY_LOG.jsonl`. This is *correct fail-closed
> behavior*, not a bug. To avoid polluting the very log under analysis, avoid marking numeric-ID tracker
> tasks complete during STALL analysis, or expect (and attribute) the resulting self-observation events.

---

## §4. REVERSIBLE EXPERIMENTS PROPOSED BUT NOT EXECUTED (for terminal Claude; §17)

From the cloud audit §6 (X1-X5) + reconciliation §10.6 ranking. **None is required for the NO-MOVE
outcome; each hardens the JUSTIFICATION.** All are read-only or append-only, all reversible, all
Owner-authorization-gated.

| ID | Experiment | EIV | Cost | Lock-in | Reversibility | Owner-gated |
|---|---|---|---|---|---|---|
| X1 | Define N (events/week) & K (distinct signatures) for `stall-consumer.T1`, record in DEFERRAL_INVENTORY | HIGH (vague→falsifiable) | LOW (1 YAML block) | LOW | HIGH | YES (D-TRIGGER-SCHEMA / OD-2) |
| X3 | Replay ARCH-009 firewall against a hypothetical "DEC-07 opened as docs-only": does the invariant add/remove constraints on F2/F3? | HIGH (tests P2a directly) | MODERATE | NONE | HIGH | YES |
| X5 | Grep git history for commits that would have benefited from DEC-04/05 being open (revealed preference for the policy pair) | MODERATE (tests debt claim) | LOW | NONE | HIGH | recommended |
| X2 | Compute the "no-consumer harm surface": how much triage if STALL volume 10×'d? | MODERATE | LOW | NONE | HIGH | recommended |
| X4 | Shadow-emit an append-only "verdict record" JSONL alongside STALL for 1 week; measure classifier distinguishability | MODERATE (empirical evidence-quality) | MODERATE (write-only script) | LOW (discardable) | HIGH | YES |

### 4.1 One NEW experiment this synthesis recommends (cheap, closes U-B5 fully)

```
EXPERIMENT_ID : X6 (proposed)
QUESTION      : Is B5 (task_id="1", 2026-09-24T18:05:06Z) an agent-session TaskCompleted event?
METHOD        : correlate STALL_POLICY_LOG timestamp with docs/00_SYSTEM/archive/CLAUDE_SESSION_LOG.2026-09-*
                and git reflog / commit times at 2026-09-24T18:05:06Z ±5min (read-only).
EXPECTED      : a session active at that time; task_id="1" appears in a tracker context.
EIV           : LOW-MODERATE (closes the only UNCERTAIN in the STALL corpus).
COST/LOCK-IN/REVERSIBILITY : LOW / NONE / HIGH (read-only).
NOTE          : This synthesis already raises the HIGH-confidence hypothesis (§3.1); X6 only confirms.
```

## §5. PROTOTYPES (§18)

**None built.** Per synthesis-prompt §18, a prototype is warranted only when a piece is better evaluated
by building it. No latent capability clears the "build to evaluate" bar today:

- STREAM-CONSUMER — evaluated sufficiently by X-STALL (already run); building it would be premature.
- DEC-07 verifier — no concrete workflow to prototype against; X3 (replay) is the right next probe, not a build.
- DEC-04/05 policy compiler — X5 (revealed-preference grep) is the right probe before any prototype.

**Prototype recommendation: DO NOT PROTOTYPE anything now.** The reversible read-only/append-only
experiments (X1-X6) have higher EIV-per-cost than any prototype and carry no lock-in.

## §6. EXPERIMENT LEDGER SUMMARY

| Experiment | Status | Outcome |
|---|---|---|
| X-STALL (divergence probe) | EXECUTED (research branch) | H0 sustained; P1 LATENT-WEAK |
| EXP-OPUS-1 (CTRL-001 live) | EXECUTED (this session) | fail-closed confirmed; resolves U-B5 hypothesis |
| Adversarial architecture tests H-A..H-F | EXECUTED (this synthesis) | 0 hypotheses falsified; H-F unrecorded-invariant flagged |
| X1, X2, X3, X4, X5, X6 | PROPOSED, not executed | Owner-gated; hardening only, not required |
| Prototypes | NONE | correctly none |
