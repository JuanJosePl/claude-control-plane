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
                    scope isolation). Commit pending Owner checkpoint.
- IN-FLIGHT LESSON: Initial retrofit pass used `kind:`/`text:` and alphabetic
                    sub-suffixes (`T5.a..T5.j`) — deviation from ARCH-005
                    schema (`type:`/`predicate:`, positive-integer index).
                    Caught by post-implementation conformance audit; corrected
                    before checkpoint. Lesson recorded: contract-field names
                    are load-bearing; do not paraphrase schema during
                    execution even when the meaning seems equivalent.
- LESSON          : no long-term lesson yet (empirical validation pending —
                    see K3-D-DEFERRAL-LIFECYCLE closure criteria in ARCH-005).
