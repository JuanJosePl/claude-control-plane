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
                    post-implementation audit PASS. Checkpointed at commit
                    473759c (2026-09-27, Owner authorization).
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

---

## DECISION LEARNING — DEC-01

- DATE            : 2026-09-27
- CHOICE          : E (SPLIT + DEFER) — E1 (type-taxonomy) DEFERRED con §23
                    triggers observables (dec01.T1..T6, combine ANY);
                    E2 (gate-mapping), E3 (auth_holder-mapping),
                    E4 (precedent-index) RETIRED con RESOLVED_BY explícito.
- CONTRACT        : DECISION_REGISTRY.md · ARCH-007
- EXPECTED        : Docs-only bookkeeping. DEC-01 monolítico histórico retirado
                    del decision graph activo y reemplazado por veredictos
                    particionados. E1 continúa observable vía DEFERRED entry
                    con 6 triggers YAML compatibles con DEFERRAL_POLICY.md.
                    E2/E3/E4 explícitamente resueltos por fuentes canónicas
                    existentes: `.claude/rules/git-policy.md` (types),
                    `docs/00_SYSTEM/AUTHORITY_KIND.md` (authority),
                    DECISION_REGISTRY + DECISION_HISTORY + git log
                    (precedents). No file creation, no runtime, no hooks, no
                    rules, no settings changes. ARCH-006 precedent AB5
                    preservado; ARCH-005 procedural pattern aplicado al
                    DEFER de E1. Reversibilidad ALTA (`git revert` docs-only).
- UNKNOWN AT TIME : (a) Si EXP-D01-01 mostrará frecuencia real de consulta
                    multi-fuente por reviewer humano (INFO-GAP-D01-1);
                    (b) Si DEC-02 futura elegirá `change_type` como key
                    primaria del registry, lo que invalidaría la revalidación
                    SOFT/ENABLER hecha en el gate §14 (INFO-GAP-D01-2);
                    (c) Trayectoria empírica de diversidad de tipos de commit
                    a 6-12 meses (INFO-GAP-D01-3);
                    (d) Impacto de un eventual escalamiento S2/S3 sobre
                    discoverability de tipos (INFO-GAP-D01-6);
                    (e) Si el gap "convención `[RESEARCH]` vs git-policy.md
                    8 tipos" es incidente material (INFO-GAP-D01-4);
                    (f) Preferencia Owner futura sobre quick-win documental
                    A2 vs coste semántico (INFO-GAP-D01-5).
- TRIGGER SET     : combine: ANY of —
                    (dec01.T1) EVENT: EXP-D01-01 ≥10 casos/mes de consulta
                       multi-fuente por reviewer humano al clasificar cambios;
                    (dec01.T2) EVENT: DEC-02 se abre requiriendo `change_type`
                       como key primaria (no cubierta por AUTHORITY_KIND);
                    (dec01.T3) COUNT: ≥3 tipos de commit nuevos fuera
                       `.claude/rules/git-policy.md` en 3 meses;
                    (dec01.T4) EVENT: incidente material atribuido a ausencia
                       de D-CATALOG documentado en INCIDENT_REGISTRY.md;
                    (dec01.T5) EVENT: Owner planea S2/S3 escalamiento
                       (≥2 humanos activos) con onboarding uniforme;
                    (dec01.T6) LINK: ARCH-006 T3 activa (DEC-02 requiere
                       referencia canónica adicional a AUTHORITY-KIND).
- IMPLEMENTATION  : 2026-09-27 — docs-only bookkeeping ejecutado. Sin creación
                    de filesystem. Modificaciones: DECISION_REGISTRY.md
                    (append ARCH-007 entry), docs/00_SYSTEM/DECISION_HISTORY.md
                    (append this entry), PROJECT_STATE.md
                    (RESOLVED_OWNER_DECISIONS + DEFERRED YAML block
                    `dec01` + CURRENT_OBJECTIVE + ACTIVE_DECISIONS updates).
                    Conformance V-CATALOG-1..12 PENDING para verificación
                    in-session post-persist; checkpoint autorización SEPARATED.
- IMPLEMENTATION_LOCATION : DECISION_REGISTRY.md (ARCH-007) +
                    docs/00_SYSTEM/DECISION_HISTORY.md +
                    PROJECT_STATE.md (docs-only bookkeeping)
- IN-FLIGHT LESSON: (framing genealogy) Este gate reveló un anti-patrón: la
                    formulación histórica de DEC-01 se heredó a través de al
                    menos 3 documentos (MASTER_HANDOFF §7.1/§13.1,
                    DECISION_SPACE_PREPARED §4.1, PIECE_AND_IDEA_PUZZLE_AUDIT
                    §5A) sin que ninguno atacara la hipótesis subyacente de
                    que "catalog" era una entidad semánticamente coherente.
                    El ataque tardío (esta sesión) reveló que 3 de 4 columnas
                    ya tenían source-of-truth canónico (git-policy.md,
                    hooks/rules, DECISION_REGISTRY+HISTORY) y que la 4ª
                    (`auth_holder`) estaba PROHIBIDA por ARCH-006 §6. Lección:
                    cada decisión heredada de niveles anteriores del análisis
                    requiere ataque de homogeneidad y consumer analysis antes
                    de asumir su formulación monolítica.
- IN-FLIGHT LESSON: (SPLIT + DEFER pattern) SPLIT + DEFER particiona una
                    decisión monolítica en veredictos separados sin fragmentar
                    el registro decisional. E1 queda observable vía DEFERRED
                    entry canónica; E2/E3/E4 RESOLVED_BY con puntero explícito
                    a fuente. Esta forma de cierre es compatible con
                    reactivación selectiva (solo E1 puede reactivarse por
                    trigger; E2/E3/E4 no pueden reactivarse sin cambio de
                    framing porque su función ya está satisfecha en otro
                    artefacto canónico). Lección: RETIRE con RESOLVED_BY
                    explícito (puntero a fuente-de-verdad efectiva) es más
                    informativo para el futuro maintainer que RETIRE
                    silencioso; deja legible el decision graph y previene
                    re-descubrimiento del mismo objeto bajo otro nombre.
- IN-FLIGHT LESSON: (ARCH-006 propagation gap) DECISION_SPACE_PREPARED §4.1
                    (2026-09-25) preparó DEC-01 sin incorporar ARCH-006
                    (2026-09-26/27). La formulación A2 con columna
                    `auth_holder` habría entrado en tensión activa con
                    ARCH-006 §6 T4 (piece → authority mapping). El gate detectó
                    la propagación pendiente y la resolvió en el ataque §10.3
                    y §14. Lección: decisiones nuevas (ARCH-006) requieren
                    audit de propagación sobre el decision space pendiente
                    antes del siguiente Owner Choice; sin ese audit, el
                    framing heredado puede violar precedentes activos.
- LESSON          : no long-term lesson yet (empirical validation begins with
                    first trigger evaluation — earliest window: EXP-D01-01
                    resultados a 30-60 días; latest: dec01.T5 al S2/S3
                    planning).
