# DECISION HISTORY

> Compact learning index of Owner-closed DEC-* decisions from the CCP decision
> execution workflow (Master Prompt v2.0). This file is an index; full contracts
> live in `DECISION_REGISTRY.md` (ARCH-NNN), `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`
> (F9-DNN), or dedicated ADRs per the destination declared in §19.

Format per entry:
- DATE, DEC id, choice, expected outcome (short), unknowns at time, review
  trigger (observable), lesson (or "no lesson yet").

---

## DECISION LEARNING — DEC-11

- DATE            : 2026-09-26
- CHOICE          : HYB-FINAL-v4 (H2* — semantic retrofit + controlled vocab
                    + LINK-normalization; final consistency pass)
- CONTRACT        : DECISION_REGISTRY.md · ARCH-005
- EXPECTED        : ~2h docs-only retrofit that formalizes 34/36 already-observable
                    prose triggers as YAML metadata blocks with namespaced stable
                    IDs, preserving F9 gate closure and unblocking DEC-08 formal
                    with a clean procedural precedent. NH-11 and G-L1 remain
                    hypothesis-tier gaps outside the requirement.
- UNKNOWN AT TIME : (a) Volume of new Owner-authorized deferrals over next 6-12
                    months; (b) Whether NH-11/G-L1 gaps require owner articulation
                    later; (c) TRIGGER-4 (AC-03) predicate lives in Owner-side
                    artifact outside repo.
- TRIGGER SET     : combine: ANY of — LINK dangling; ≥3 new deferrals without
                    structured trigger when extractable; DEC-08 formal opening
                    reveals tension; "literal retrofit ≠ reopening" misapplied
                    elsewhere; deferral requires combine operator other than ANY.
- IMPLEMENTATION  : 2026-09-26 — retrofit executed in working tree; 4 files
                    (1 new DEFERRAL_POLICY.md + 3 in-situ YAML blocks in
                    F9_OWNER_DECISIONS.md, PROJECT_STATE.md,
                    BEHAVIORAL_RELIABILITY_AUDIT.md). Conformance V1-V13 PASS
                    (schema, IDs, LINK resolution, semantic invariance,
                    scope isolation). Checkpointed at commit cd0511c
                    (2026-09-26).
- IN-FLIGHT LESSON: Initial retrofit pass used `kind:`/`text:` and alphabetic
                    sub-suffixes (`T5.a..T5.j`) — deviation from ARCH-005
                    schema (`type:`/`predicate:`, positive-integer index).
                    Caught by post-implementation conformance audit; corrected
                    before checkpoint. Lesson recorded: contract-field names
                    are load-bearing; do not paraphrase schema during
                    execution even when the meaning seems equivalent.
- LESSON          : no long-term lesson yet (empirical validation pending —
                    see K3-D-DEFERRAL-LIFECYCLE closure criteria in ARCH-005).

---

## DECISION LEARNING — DEC-AUTH-BOUNDARY

- DATE            : 2026-09-26
- CHOICE          : AB5 (Taxonomy + change rules only) + VOCAB-A (CLOSED
                    vocabulary of exactly four ATTESTED classes:
                    `{ mecánica, convención, humana, agente }`)
- CONTRACT        : DECISION_REGISTRY.md · ARCH-006
- EXPECTED        : Materialize PRIM-1 (AUTHORITY-KIND) as first-order canonical
                    object via taxonomy + evolution rules only. No piece-by-piece
                    authority registry. No coupling with DEC-02 (SOFT/ENABLER
                    relation preserved, not HARD). No changes to MASTER_HANDOFF
                    contract (stays snapshot). VOCAB closed to avoid semantic
                    drift; new class requires formal reopening.
- UNKNOWN AT TIME : (a) Whether future evidence will demonstrate that a
                    piece-by-piece mapping (AB2 path) is materially required;
                    (b) Whether an ATTESTED authority outside the four canonical
                    classes will emerge, forcing reopening under VOCAB-A;
                    (c) Whether opening DEC-02 will require canonical AUTHORITY-KIND
                    references that taxonomy alone cannot resolve;
                    (d) Empirical cost and lock-in of AB5 vs AB2 at scale.
- TRIGGER SET     : combine: ANY of —
                    (T1) concrete evidence that piece-by-piece mapping is needed
                         (enables reversible AB5 → AB2 path without reopening
                         base choice);
                    (T2) an ATTESTED authority appears outside the four canonical
                         classes (forces formal reopening per VOCAB-A CLOSED);
                    (T3) DEC-02 opens and requires canonical AUTHORITY-KIND
                         references that taxonomy alone cannot resolve;
                    (T4) implicit "meta-authority" detected in runtime, hooks or
                         canonical docs (violation of closed vocabulary).
- IMPLEMENTATION  : 2026-09-26 — Owner authorization granted; implementation
                    executed in `docs/00_SYSTEM/AUTHORITY_KIND.md` (new file,
                    315 lines, 9 sections). Scope conforms to AB5 exactly:
                    taxonomy + evolution rules + closed vocabulary + reopening
                    procedure. NO piece → authority mapping. NO DEC-02
                    coupling. NO MASTER_HANDOFF mutation. NO runtime / hooks /
                    skills / agents / rules / settings / evals changes.
                    Conformance V-AUTH-1..V-AUTH-11 PASS; 12/12 adversarial
                    post-implementation audit PASS. Checkpoint PENDING
                    (separate Owner authorization required).
- IMPLEMENTATION_LOCATION : docs/00_SYSTEM/AUTHORITY_KIND.md
- IN-FLIGHT LESSON: (M010→M011) M010 opened the gate; M011 adversarial
                    validation found material defects (illegitimate authority
                    classes, HARD DEC-02 relation, MASTER_HANDOFF assumed
                    living, AB5 missing, understated AB2 cost, overstated AB4
                    reversibility). All corrected before Owner Choice. Lesson:
                    adversarial validation of decision gates before Owner
                    presentation catches gate contamination that would
                    otherwise survive as decision baseline.
- IN-FLIGHT LESSON: (implementation) Initial draft cited specific piece labels
                    (P-PT for `convención`, P-A for `agente`) as isolated
                    evidence pointers; two out of four classes carried these
                    labels while the other two did not. The asymmetry created
                    a partial piece → authority mapping surface that risked
                    reading as scope-leakage toward AB2, even though the
                    citations were illustrative rather than enumerative.
                    Caught by V-AUTH-5 pre-check; rewritten to reference the
                    audit sections without carrying piece IDs into the
                    canonical taxonomy document. Lesson: in a
                    taxonomy-without-registry document, evidence citations
                    should reference the source artifact and its section, not
                    the labels that source uses for downstream pieces.
- LESSON          : no long-term lesson yet (implementation just persisted;
                    empirical validation begins with the first future event
                    that tests VOCAB-A closure or the SOFT/ENABLER relation
                    with DEC-02).
