# 07 — OWNER DECISION PACKETS

> **Stratum-C synthesis artifact (non-canonical, read-only).** Per synthesis-prompt §27: for every
> Class-D item, prepare — do NOT decide. Questions are CLOSED (选择, not open-ended). None of these is
> forced today; all outcomes are compatible with `NO-MOVE SUSTAINED WITH CONDITIONS`. The synthesis
> takes no Owner Decision (§1 authority boundary).

**None of OD-1..OD-5 needs to open a runtime workflow. All are governance/record framing choices.**

---

## OD-1 — How to record the state of the 7 latent decisions

```
DECISION_ID   : OD-1
WHY NOW       : The post-DEC-08 recomposition recorded the 7 historical candidates as ABSORBED; the
                cloud audit + reconciliation + addenda corrected this to LATENT — no trigger fired.
                The corrected reading currently lives only on unmerged research branches; canonical
                state (DEFERRAL_INVENTORY, DECISION_REGISTRY) is silent on these 7.
WHY NOT BEFORE: DEC-08 canonicalization (2026-09-28) only just closed the last gate; the recomposition
                that surfaced the classification error ran 2026-09-29.
TRIGGER       : none fired — this is a RECORD-framing choice, not a triggered decision.
NEED          : future recompositions must not re-derive "absorbed vs latent" from scratch; the
                7 latent DECs (DEC-03/04/05/07/12/STREAM-CONSUMER/REVIEWER-VERDICT) have no canonical
                home stating they are LATENT with observable re-open predicates.
OPTIONS       :
  A. FORMALIZE — add the 7 as canonical DEFERRAL_INVENTORY entries (Cluster E) with observable
     predicates, reusing the ARCH-005 schema. (Pairs with OD-2.)
  B. STRATUM-C RECORD — keep the LATENT classification as the integrated research chain + this
     synthesis index only; canonical state unchanged. (Integration = EP-C1.)
  C. STATUS-QUO — leave the branches unmerged; do nothing.
HYBRID        : A-lite — record the 7 in DEFERRAL_INVENTORY as LATENT *without* predicates yet (name
                them; defer predicate definition to OD-2).
TRADEOFFS     : A = strongest future legibility, but adds canonical governance surface + needs OD-2
                predicates; B = zero canonical change, but the record stays "analytical" and a future
                run must read the chain; C = cheapest now, highest later-decision cost + provenance risk.
REVERSIBILITY : A/A-lite HIGH (git revert docs); B HIGH; C trivially reversible (do nothing).
LOCK-IN       : A LOW; B NONE; C NONE.
EVIDENCE      : cloud audit §4/§8; reconciliation §7/§9.3; addenda B1-B3; DEFERRAL_INVENTORY (7 absent).
EXPERIMENT    : none needed.
FALSIFIERS    : if the missing cache file reveals an 8th atom, the "7" is incomplete (record must be
                extensible).
DEPENDENCIES  : OD-2 (if A/A-lite chosen, predicate discipline applies).
OWNER QUESTIONS (closed):
  Q1a: Record the 7 latent decisions as (A) canonical DEFERRAL_INVENTORY entries, (B) Stratum-C
       integrated record only, or (C) leave on unmerged branches?   [A / B / C]
  Q1b: If A, define predicates now (→OD-2) or name-only for now (A-lite)?   [now / name-only]
```

---

## OD-2 — Deferral-trigger admission schema (D-TRIGGER-SCHEMA)

```
DECISION_ID   : OD-2
WHY NOW       : The recomposition invented 3 novel triggers (stall-consumer.T1, verifier-workflow.T1,
                reviewer-verdict.T1) with undefined predicates and no adoption path. ARCH-005 governs
                how EXISTING entries carry triggers, not how NEW trigger classes are admitted.
WHY NOT BEFORE: no prior run created novel triggers outside the F9-D0x / ARCH-005 pattern.
TRIGGER       : none fired — weak latent candidate (below convergence threshold, est. 6-8/15).
NEED          : if OD-1=A, the 7 latent DECs need predicates; who authorizes a predicate, and what
                schema/discipline (N, K, window, reset, firing action) must it carry?
OPTIONS       :
  A. EXTEND ARCH-005 — add a short "novel-trigger admission" clause to DEFERRAL_POLICY (Owner
     authors predicate; must be observable; provenance required). Small amendment.
  B. NEW DECISION — open D-TRIGGER-SCHEMA as its own governance DEC.
  C. AD-HOC — keep authoring triggers case-by-case under Owner sign-off, no schema.
HYBRID        : A now (minimal clause) + revisit as B only if trigger volume grows.
TRADEOFFS     : A cheapest, reuses ARCH-005; B heaviest (a whole DEC for a weak candidate — likely
                over-build today); C simplest but repeats the "undefined predicate" problem.
REVERSIBILITY : A HIGH; B HIGH; C N/A.
LOCK-IN       : A LOW; B MODERATE; C NONE.
EVIDENCE      : cloud audit §7.1; reconciliation §8.3 (LATENT WEAK, NOT_READY).
EXPERIMENT    : X1 (define stall-consumer.T1 N/K) is the concrete first instance.
FALSIFIERS    : if ARCH-005 is later read to already cover novel-trigger admission, OD-2 is moot
                (audit falsifier F5 — not met on current reading).
OWNER QUESTIONS (closed):
  Q2: Admit novel deferral triggers via (A) a small ARCH-005 amendment, (B) a new D-TRIGGER-SCHEMA
      decision, or (C) ad-hoc Owner sign-off with no schema?   [A / B / C]
```

---

## OD-3 — Canonicalize the Stratum-C ↔ canonical boundary?

```
DECISION_ID   : OD-3
WHY NOW       : The rule "nothing Claude writes as Stratum-C becomes canonical without Owner
                authorization + a canonical write path" is exercised across ARCH-005..009 and every
                research artifact's non-modification attestation — but it has no ARCH-N, no name in
                DECISION_HISTORY, no falsifier. It is a live governance invariant adopted by convention.
WHY NOT BEFORE: it emerged as practice; no stress event forced it into the record.
TRIGGER       : none fired — stable, reversible convention.
NEED          : someday the boundary is either canonicalized OR a stress event reveals it was never
                really decided (a Stratum-C artifact mistaken for canonical).
OPTIONS       :
  A. CANONICALIZE — record it as an ARCH-N governance invariant (convención per VOCAB-A), with a
     falsifier (e.g., "a Stratum-C file cited as canonical without ARCH-N").
  B. NAME-ONLY — record it in this synthesis + DECISION_HISTORY as a known convention, no ARCH-N.
  C. LEAVE — continue by convention.
TRADEOFFS     : A strongest guarantee, small governance add; B middle; C cheapest but the invariant
                stays un-falsifiable and un-owned.
REVERSIBILITY : A HIGH; B HIGH; C N/A.
LOCK-IN       : A LOW; B NONE; C NONE.
EVIDENCE      : cloud audit §7.2; reconciliation §8.4.
EXPERIMENT    : none needed.
FALSIFIERS    : if any current control already enforces the boundary mechanically (none found), A is
                redundant.
OWNER QUESTIONS (closed):
  Q3: Record the Stratum-C boundary as (A) a canonical ARCH-N invariant, (B) a named convention in
      the synthesis/history, or (C) leave it as unwritten convention?   [A / B / C]
```

---

## OD-4 — Irreducible-triad correction framing

```
DECISION_ID   : OD-4
WHY NOW       : DECISION_SPACE_PREPARED §48 asserts DEC-02+DEC-04+DEC-05 = irreducible "GOVERNED
                DERIVATION". ARCH-008 closed DEC-02 alone via R1+MINIMUM, decoupling it. §48 is
                historically stale; the correct residual is the binary pair {DEC-04 ⋈ DEC-05}.
WHY NOT BEFORE: ARCH-008 (2026-09-28) is what decoupled it; the staleness is one day old.
TRIGGER       : none — record-framing choice. §48 file is frozen (not edited); addenda B3 records it.
NEED          : future readers of §48 must not treat the triad as still irreducible.
OPTIONS       :
  A. RELABEL — record (in DECISION_HISTORY or a canonical note) that §48 is superseded; residual =
     {DEC-04 ⋈ DEC-05}, DEC-02 orthogonal after ARCH-008.
  B. LEAVE — rely on the addenda B3 correction (Stratum-C only).
HYBRID        : integrate addenda (EP-C1) now; canonical relabel only if OD-1=A.
TRADEOFFS     : A strongest legibility; B zero canonical change.
REVERSIBILITY : both HIGH.
LOCK-IN       : both LOW/NONE.
EVIDENCE      : cloud audit §10; reconciliation §4; addenda B3 (CONFIDENCE MODERATE-HIGH; falsifier F3
                NOT MET on reading DECISION_HISTORY DEC-02).
FALSIFIERS    : if ARCH-008's R1 is shown to presume DEC-04 open (F3), the triad stands and A is wrong.
OWNER QUESTIONS (closed):
  Q4: Correct the §48 triad claim via (A) a canonical supersede note, or (B) leave the Stratum-C
      addenda correction as the record?   [A / B]
```

---

## OD-5 — B5 UNCERTAIN STALL event

```
DECISION_ID   : OD-5
WHY NOW       : The STALL probe left one UNCERTAIN event (B5, task_id="1"). This synthesis raises a
                HIGH-confidence hypothesis (EXP-OPUS-1) that it is an agent-session harness
                TaskCompleted event, matching a phenomenon reproduced live this session.
WHY NOT BEFORE: the probe was read-only and did not correlate session logs.
TRIGGER       : none — housekeeping choice.
NEED          : close the only UNCERTAIN in the STALL corpus, or accept it as isolated noise.
OPTIONS       :
  A. CONFIRM — run EP-E1 (X6, read-only session-log correlation).
  B. ACCEPT — treat B5 as isolated self-observation noise; no action.
TRADEOFFS     : A closes U-B5 fully (low cost); B saves the effort, leaves 1 UNCERTAIN.
REVERSIBILITY : both trivial.
LOCK-IN       : none.
EVIDENCE      : doc 04 §3.1; STALL probe §4.2/§7.2.
FALSIFIERS    : X6 finds a non-tracker origin → hypothesis refuted (outcome unchanged).
OWNER QUESTIONS (closed):
  Q5: Close B5 by (A) running the read-only X6 correlation, or (B) accepting it as isolated noise?
      [A / B]
```

---

## §Summary — Owner decision surface (nothing forced)

| OD | Question | Default if Owner silent | Forces a build? |
|---|---|---|---|
| OD-1 | Record 7 latent DECs: canonical / Stratum-C / leave | B (Stratum-C via EP-C1) | NO |
| OD-2 | Novel-trigger admission: ARCH-005 amend / new DEC / ad-hoc | A (small amend) — only if OD-1=A | NO |
| OD-3 | Stratum-C boundary: canonicalize / name / leave | B (name in synthesis) | NO |
| OD-4 | Triad §48: supersede note / leave | B (addenda record) | NO |
| OD-5 | B5 event: confirm / accept | A (cheap read-only) | NO |

**Every default keeps CCP at NO-MOVE.** No OD opens a runtime workflow, a new phase, or a new ARCH-N
that changes behavior. The Owner may answer all five, some, or none. The terminal Claude must NOT
pre-answer any of them (synthesis §1: OWNER DECIDES > AGENT DECIDES).
