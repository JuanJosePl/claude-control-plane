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

---

## DECISION LEARNING — DEC-02

- DATE            : 2026-09-28
- CHOICE          : R1 (docs-only representation) + K-A (ACTOR-ARTIFACT /
                    MODEL-A) + MINIMUM SCHEMA (3 semantically required fields:
                    delegator, delegatee_ref, scope) + V=DEFER + Q=DEFER +
                    P=DEFER + EXP-DEC02-SEM=SKIP.
- CONTRACT        : DECISION_REGISTRY.md · ARCH-008
- EXPECTED        : Docs-only governance convention that documents the
                    delegation pattern with ACTOR as the semantic target.
                    Skills, workflows, and action-types are scope contents,
                    not target types. AUTHORITY_KIND classes `agente` and
                    `humana` are the delegatee kinds; harness-primitive
                    residuals stay as explicit UNKNOWN. Schema breadth is
                    minimum (3 fields) — actor_kind, activation, revocation,
                    provenance are deferable schema-level fields, not part
                    of the semantic contract. V/Q/P remain deferable to
                    later gates. No runtime enforcement introduced. No
                    AUTHORITY_KIND / VOCAB-A modification. No CAPABILITY
                    registry. CAPABILITY remains SPECULATIVE (NOT PRESENT,
                    NOT REFUTED). Reversibility HIGH across technical,
                    governance, audit, and cultural dimensions.
- UNKNOWN AT TIME : (a) Whether reviewer + Owner will sustain the discipline
                    of consulting entries before despachar (drift-stale
                    failure mode); (b) Whether DEC-07 F2/F3 will open in
                    the near horizon and materially benefit from ARCH-008
                    as governance anchor; (c) Whether any real delegation
                    entry will be authored under ARCH-008 within the
                    6–12-month horizon (the risk is "orphaned convention"
                    if no entries appear); (d) Whether the schema minimum
                    (3 fields) is sufficient once a real entry is drafted,
                    or whether the deferred fields (actor_kind, activation,
                    revocation) will become materially needed; (e) Whether
                    a case will emerge where the target is naturally
                    non-actor (would activate arch08.T4); (f) Whether a
                    CAPABILITY threshold (T-CAP-1..T-CAP-5 per Super
                    Analysis §18) will fire in the horizon.
- TRIGGER SET     : combine: ANY of —
                    (arch08.T1) EVENT: delegation-attributed incident
                       recorded in INCIDENT_REGISTRY.md;
                    (arch08.T2) EVENT: DEC-07 F2/F3 opens and requires an
                       authorization anchor MODEL-A cannot express with
                       the 3-field minimum;
                    (arch08.T3) EVENT: Owner declares S2/S3 scaling
                       (≥2 humans active) with per-role delegation
                       documentation requirement;
                    (arch08.T4) EVENT: real delegation case surfaces where
                       target cannot be honestly modeled as an actor with
                       scope prose (falsifies the derived "target = actor"
                       finding);
                    (arch08.T5) EVENT: per-skill invocation authority
                       becomes materially useful, forcing consideration of
                       K-A → K-B migration;
                    (arch08.T6) EVENT: any of the CAPABILITY re-entry
                       thresholds T-CAP-1..T-CAP-5 (per
                       DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §18) fires.
- IMPLEMENTATION  : 2026-09-28 — docs-only bookkeeping executed. Sin creación
                    de filesystem beyond one canonical ADR + two
                    bookkeeping updates. Modificaciones:
                    DECISION_REGISTRY.md (append ARCH-008 entry),
                    docs/00_SYSTEM/DECISION_HISTORY.md (this entry),
                    PROJECT_STATE.md (CURRENT_OBJECTIVE +
                    ACTIVE_DECISIONS + RESOLVED_OWNER_DECISIONS +
                    arch08.T1..T6 deferral-triggers block updates).
                    Per ARCH-004 (same pattern as ARCH-005/006/007):
                    docs-only bookkeeping no requiere EV-NNN individual;
                    aggregated evidence lives in DECISION_REGISTRY.md
                    ARCH-008 EVIDENCIA section and in this learning
                    entry. Conformance V-DELEG-1..V-DELEG-10 PENDING for
                    in-session post-persist verification. Checkpoint
                    autorización SEPARATED (per patrón ARCH-006 /
                    ARCH-007).
- IMPLEMENTATION_LOCATION : DECISION_REGISTRY.md (ARCH-008) +
                    docs/00_SYSTEM/DECISION_HISTORY.md (this entry) +
                    PROJECT_STATE.md (docs-only bookkeeping)
- IN-FLIGHT LESSON: (six-artifact analytical chain necessity) DEC-02
                    required a six-audit analytical chain (target
                    semantics → reconciliation → ground-truth → Owner
                    package → super analysis → final integrity, 5,309
                    lines total) to arrive at a decision that ultimately
                    committed only 3 semantic fields and deferred nearly
                    everything else. The lesson is not that the analysis
                    was excessive; it is that arriving at a
                    correctly-scoped minimum decision required
                    successive elimination of over-extensions
                    (H3-SPLIT's compound/stable_role/authorized_invoker),
                    over-reach (skills as targets), and premature schema
                    commitments (7-field MODEL-A vs 3-field minimum).
                    Future decisions with similar semantic-target
                    ambiguity should expect a multi-pass adversarial
                    audit chain rather than a single pass.
- IN-FLIGHT LESSON: (schema breadth as hidden decision) The Owner Choice
                    Package (§5) initially presented MODEL-A as a 7-field
                    schema; the Final Decision Integrity check (§3, §11)
                    surfaced that this covertly bundled a schema decision
                    with the semantic decision. Splitting semantic
                    minimum (delegator, delegatee_ref, scope) from schema
                    breadth (actor_kind, activation, revocation,
                    provenance-as-field) is the correct decomposition.
                    Lesson: whenever a decision presents "the model", audit
                    whether every field is semantically required or is
                    a convenience that could be deferred; hidden schema
                    decisions inflate the Owner's cognitive load
                    unnecessarily.
- IN-FLIGHT LESSON: (CAPABILITY classification precision) The initial
                    Target Semantics Audit used "NOT SUPPORTED BY
                    EVIDENCE" for CAPABILITY (H4), which the
                    Reconciliation correctly downgraded to "NOT PRESENT
                    as first-class primitive; NOT REFUTED; SPECULATIVE".
                    The distinction matters: `absence of materialization`
                    ≠ `refutation`. Future decisions about deferred
                    abstractions should carry epistemic precision — a
                    deferred concept is available for reopening under
                    triggers, not eliminated.
- IN-FLIGHT LESSON: (5-of-11 default-covered) The 11 empirical ACTION_TYPE
                    items in the revised gate §6.1 decomposed to 5 real
                    actor-shaped delegations, 5 default-covered procedure
                    invocations (Owner invokes skill; primary Claude
                    runs), and 1 workflow. The finding that 5 of 11 are
                    not delegations at all was the pivot that made MODEL-A
                    sufficient. Reconciliation's initial phrasing
                    ("Owner actions") was imprecise; ground-truth audit
                    corrected to "default-covered procedure invocations".
                    Lesson: an inventory presented as evidence for a
                    decision must be audited for whether every item
                    actually belongs to the class being decided; heuristic
                    inventories can silently include items that don't fit
                    the semantic contract under scrutiny.
- LESSON          : no long-term lesson yet (empirical validation begins
                    with first authored delegation entry, first trigger
                    firing, or DEC-07 F2/F3 opening — whichever comes
                    first).

---

## DECISION LEARNING — DEC-08

- DATE            : 2026-09-28
- CHOICE          : B · REFORMULATE — DEC-08 D-INSTR as an isolated
                    schema-completion decision is closed; canonical
                    invariant recorded: STALL_POLICY_LOG is an
                    event/observation record and must not be used as
                    the authoritative source of an independent
                    judgment about the correctness of the policy
                    decision it records. No STALL schema change; no
                    runtime authorization; no reopening triggers
                    (`arch09.T*`).
- CONTRACT        : DECISION_REGISTRY.md · ARCH-009
- EXPECTED        : Docs-only bookkeeping that records the
                    event/judgment boundary as an architectural
                    invariant (governance `convención` per ARCH-006
                    VOCAB-A). Preserves the analytical gain from Move 1
                    Kernel §2.3 (fact/judgment separation) and Move 2
                    firewall §6.2.1 (three distinct semantic ownership
                    classes for verdict / had_alternative / session_id)
                    without acquiring schema, code, or runtime lock-in.
                    Future verdict / verifier architecture is delegated
                    to the decision that owns the concrete need
                    (DEC-07 D-VERIFICADOR, DEC-REVIEWER-VERDICT, or a
                    new DEC-N). Reversibility HIGH via a new ADR.
- UNKNOWN AT TIME : (a) Whether any of DEC-07 / DEC-STREAM-CONSUMER /
                    DEC-REVIEWER-VERDICT will open in the 6–12-month
                    horizon and inherit the "verdict outside emitter"
                    invariant materially; (b) Whether the producer
                    availability of a Claude session id at hook event
                    time (session_id classification MODERATE in Kernel
                    §11 §6.2.1) will be verified by a future check —
                    the result does not change ARCH-009 but tightens
                    the correlation-metadata band; (c) Whether the
                    absence of `arch09.T*` reopening triggers will
                    prove sufficient — a concrete future need may
                    require opening a new DEC-N whose problem framing
                    is fully distinct from DEC-08's original schema-
                    completion framing; (d) Whether STALL_POLICY_LOG
                    volume growth will remain harness-noise-dominated
                    (81.5% at Move 1 preflight, 22/27 events one
                    signature) or whether material policy events at
                    volume will emerge and pressure the invariant.
- TRIGGER SET     : NONE. Owner Choice B closes DEC-08; it does not
                    defer. Future needs are resolved by the decision
                    appropriate to the problem, not by a scheduled
                    reactivation of DEC-08 D-INSTR. This absence is
                    intentional and explicit per Move 3 §5.3 / §12
                    ("B closes, does not defer, no arch09.T*").
- IMPLEMENTATION  : 2026-09-28 — docs-only bookkeeping executed.
                    Modificaciones:
                    DECISION_REGISTRY.md (append ARCH-009 entry),
                    docs/00_SYSTEM/DECISION_HISTORY.md (this entry),
                    PROJECT_STATE.md (CURRENT_OBJECTIVE +
                    RESOLVED_OWNER_DECISIONS append + ACTIVE_DECISIONS
                    updated with ARCH-009 appended, no deferral-triggers
                    block added since Owner Choice B closes DEC-08).
                    Per ARCH-004 (same pattern as ARCH-005/006/007/008):
                    docs-only bookkeeping no requiere EV-NNN individual;
                    aggregated evidence lives in DECISION_REGISTRY.md
                    ARCH-009 EVIDENCIA section and in this learning
                    entry. Conformance verification via
                    `evals/maintenance.sh` external evaluator (RSI
                    safety canon: evaluator outside the optimization
                    loop; unmodifiable). Checkpoint autorización
                    SEPARATED (per patrón ARCH-006/007/008).
- IMPLEMENTATION_LOCATION : DECISION_REGISTRY.md (ARCH-009) +
                    docs/00_SYSTEM/DECISION_HISTORY.md (this entry) +
                    PROJECT_STATE.md (docs-only bookkeeping)
- IN-FLIGHT LESSON: (three-move campaign delivered) DEC-08 was
                    delivered through the CCP three-move campaign
                    (Move 1 Discover-Compress-Architect, Move 2
                    Gate-Choose, Move 3 Canonicalize-Close). The Kernel
                    (Stratum-C, 40 KB) served as persistent state
                    across moves; each move produced exactly one
                    output (Kernel body, §11 appendix, canonical
                    ADR + history + state), with zero sibling
                    analytical files. The pattern held: architecture
                    constrained options in Move 1; firewall promoted
                    Option C (RETIRE) as first-class in Move 2 through
                    the debt-criterion test; Owner selected B in Move 3.
                    Lesson: separating meta-gate (Move 1 §1B) from
                    firewall (Move 2 §6.2) reduced pressure to force a
                    verdict too early; each pass had a bounded
                    responsibility.
- IN-FLIGHT LESSON: (fact/judgment separation preserved without
                    over-commitment) The Kernel's architectural finding
                    that verdict is a judgment field belonging outside
                    the emitter was preserved as an invariant WITHOUT
                    naming DEC-07 as the definitive owner. Move 3 spec
                    §5.3 (over-canonicalization forbidden) and §3G
                    Test B (premature DEC-07 assignment) prevented the
                    common failure mode of "we know where it goes, so
                    let's just write it". ARCH-009 records the boundary
                    (event ≠ independent judgment) without committing
                    to which future decision owns the verdict layer.
                    Lesson: reformulating a decision means capturing
                    the architectural insight while leaving the
                    downstream decisions their own scope; premature
                    assignment would have created HARD coupling
                    disguised as helpful clarification.
- IN-FLIGHT LESSON: (three distinct semantic classes disambiguated)
                    Move 1 Kernel §2.2 lumped verdict / had_alternative /
                    session_id as "NOWHERE observed". Move 2 firewall
                    §6.2.1 (CoVe factored per concept) disambiguated
                    them into three semantically distinct ownership
                    classes: verdict = verifier-owned (HIGH band),
                    had_alternative = retrospective-derivation (HIGH
                    band), session_id = correlation-metadata (MODERATE
                    band with producer availability UNVERIFIED). This
                    refinement was material: it prevented Option B from
                    forcing a single semantic class onto three distinct
                    concepts, and it made the ARCH-009 SEMANTIC_
                    CLASSIFICATION field an honest record of what is
                    and is not known. Lesson: schema fields that appear
                    schema-adjacent are not necessarily semantically
                    co-owned; CoVe factored per concept catches
                    conflation that a single-pass audit misses.
- IN-FLIGHT LESSON: (Owner Choice B chosen over A and C by architectural
                    insight preservation) Move 2 dominance recheck
                    §6.2.6 established that A / B / C are three
                    architectural branches with no pairwise dominance —
                    A wins trigger automation, B wins insight preservation,
                    C wins admin cost avoidance. The Owner's selection
                    of B trades LOW-MODERATE semantic lock-in (the
                    "verdict outside emitter" invariant) for HIGH
                    preservation of the analytical insight. This is a
                    substantive commitment, not a default. Lesson: when
                    Move 2 surfaces multiple non-dominating branches,
                    the Owner Choice communicates the priority ordering
                    (insight > admin cost > trigger automation, in this
                    case) that the analytical firewall alone cannot
                    infer.
- LESSON          : no long-term lesson yet (empirical validation
                    begins with the first future decision that
                    inherits or overrides the "verdict outside
                    emitter" invariant — DEC-07 F2/F3, DEC-REVIEWER-
                    VERDICT, or an unrelated decision; or with an
                    incident that materially tests the boundary
                    statement).
