# PROJECT STATE

> Fuente unica del estado operativo. `PROJECT_STATE.md` manda sobre sus mirrors.

CURRENT_PHASE:          8
PHASE_STATUS:           COMPLETE
PHASE_STARTED:          2026-09-19
CURRENT_OBJECTIVE:      F8 cerrada, F9 investigada (`F9 NOT JUSTIFIED`) y F9 owner decision gate CERRADO (F9-D01=A, F9-D02=B, F9-D03=B, F9-D04=B, F9-D05=A). DEC-11/ARCH-005 CHECKPOINTED (cd0511c). DEC-AUTH-BOUNDARY/ARCH-006 CHECKPOINTED (473759c, 2026-09-27). DEC-01/ARCH-007 CHECKPOINTED (e529359, 2026-09-27); E1 (type-taxonomy) DEFERRED con dec01.T1..T6; E2/E3/E4 RETIRED. DEC-02/ARCH-008 OWNER_CHOSEN=R1+K-A+MINIMUM (2026-09-28), IMPL_AUTHORIZED=YES, IMPLEMENTATION EXECUTED como docs-only bookkeeping (DECISION_REGISTRY.md ARCH-008 + docs/00_SYSTEM/DECISION_HISTORY.md DEC-02 + PROJECT_STATE.md; per ARCH-004 mismo patrón que ARCH-005/006/007: no requiere EV-NNN individual); target semántico = ACTOR; minimum schema = {delegator, delegatee_ref, scope}; V/Q/P DEFERRED; EXP-DEC02-SEM SKIP; CAPABILITY SPECULATIVE / DEFERRED; RUNTIME AUTHORIZATION NONE; reopening triggers arch08.T1..T6 (combine ANY); CONFORMANCE_PENDING (V-DELEG-1..V-DELEG-10); CHECKPOINT_PENDING; analytical support chain (Stratum-C) en docs/00_SYSTEM/DEC_02_{TARGET_SEMANTICS_AUDIT, TARGET_SEMANTICS_RECONCILIATION, DELEGATION_GROUND_TRUTH_AUDIT, OWNER_CHOICE_PACKAGE, SUPER_OWNER_DECISION_ANALYSIS, FINAL_DECISION_INTEGRITY}.md (5,309 líneas, untracked, no canonical).
LAST_COMPLETED_PHASE:   8 (2026-09-19)
BLOCKERS:               NONE (no technical blockers)
OWNER_GATES:            READY-01 (AC-02 classification), READY-02 (hook patterns),
                        READY-03 (L1-C risk acceptance + N definition), READY-04 (message format)
ENVIRONMENT_BLOCKS:     H-01 materiality (requires real usage), P1'/P2' FP rate (real usage),
                        Native Claude Code lifecycle (deferred F9-D02=B)
NOW_EXECUTABLE:         ALL COMPLETE — HRQS (done M008), PAC corpus (done M008), query-log.sh (done M007)
DEFERRED:               CDT-02 (new agent auth), AC-03 (TRIGGER-4), NH-11, F10-F12, DEC-01-E1 (type-taxonomy)
<!-- deferral-triggers:
scope: project-state
deferral: deferred-list
note: "Each DEFERRED entry has its own trigger block below. All references follow DEFERRAL_POLICY.md §4 ID convention (positive-integer index)."

sub-items:
  - deferral: cdt02
    combine: null
    triggers:
      - id: project-state.cdt02.T1
        type: EVENT
        predicate: "Owner explicitly authorizes definition of the CDT-02 blind-verifier test agent AND enables the empirical test environment required to run it."
        provenance: "PROJECT_STATE.md · DEFERRED · CDT-02 (new agent auth); docs/00_SYSTEM/DEFERRAL_INVENTORY.md §Cluster-B.CDT-02 · Trigger source lines"
    related:
      - id: f9.d01.T1
        reason: "F9-D01=A currently blocks activation of CDT-02 by keeping F9 implementation closed; reactivation of F9-D01 is a precondition context, NOT a trigger of CDT-02 itself. CDT-02 triggers on Owner authorization per its own DEFERRED entry."
        provenance: "docs/00_SYSTEM/DEFERRAL_INVENTORY.md §Cluster-B.CDT-02 · Effective trigger note"

  - deferral: ac03
    combine: null
    triggers:
      - id: project-state.ac03.T1
        type: EVENT
        predicate: "Owner explicitly authorizes activation of the AC-03 subagent-verifier component."
        provenance: "PROJECT_STATE.md · DEFERRED · AC-03 (TRIGGER-4); docs/00_SYSTEM/DEFERRAL_INVENTORY.md §Cluster-B.AC-03 · Trigger source lines"
    related:
      - id: external.trigger-4
        reason: "PROJECT_STATE historical reference to 'TRIGGER-4' points at an owner-side artifact whose predicate is not surfaced in-repo. Per ARCH-005 NO-GOALS, TRIGGER-4 predicate remains external and is NOT a canonical trigger under this policy; recorded as related for traceability only."
        provenance: "docs/00_SYSTEM/DEFERRAL_INVENTORY.md §Cluster-B.AC-03 · T-AC03.2 latent-predicate note"
      - id: f9.d01.T1
        reason: "F9-D01=A currently blocks activation of AC-03; the F9-D01 block is context, NOT an alternative trigger of AC-03."
        provenance: "docs/00_SYSTEM/DEFERRAL_INVENTORY.md §Cluster-B.AC-03 · T-AC03.1 link-note"

  - deferral: nh11
    combine: null
    triggers: null
    note: "HYPOTHESIS-tier (NOT AUTHORIZED — logged for future consideration). Exempt from mandatory retrofit per DEFERRAL_POLICY.md INV-4. No observable predicate stated in source prose."
    provenance: "docs/00_SYSTEM/61B_CCP_JOURNEY_MAP.md §NH-11 entry; docs/00_SYSTEM/DEFERRAL_INVENTORY.md §Cluster-B.NH-11"

  - deferral: f10-f12
    combine: ANY
    note: "Linkage to F9-D05 canonical triggers. F9-D05 T1 (concrete evidenced problem at phase scale) and F9-D05 T2..T7 (six external-requirement compound LINKs per F9-D04 T1..T6)."
    triggers:
      - id: project-state.f10-f12.T1
        type: LINK
        predicate: "F10-F12 naming/scope decision reactivates on F9-D05 T1 (concrete evidenced problem at phase scale)."
        provenance: "PROJECT_STATE.md · DEFERRED · F10-F12; docs/00_SYSTEM/DEFERRAL_INVENTORY.md §Cluster-B.F10-F12 · Effective trigger"
        link: f9.d05.T1
      - id: project-state.f10-f12.T2
        type: LINK
        predicate: "F10-F12 reactivates on F9-D05 T2 (external requirement per F9-D04 T1 that brings its own problem+evidence contract)."
        provenance: "PROJECT_STATE.md · DEFERRED · F10-F12 (split 1/6)"
        link: f9.d05.T2
      - id: project-state.f10-f12.T3
        type: LINK
        predicate: "F10-F12 reactivates on F9-D05 T3 (external requirement per F9-D04 T2 that brings its own problem+evidence contract)."
        provenance: "PROJECT_STATE.md · DEFERRED · F10-F12 (split 2/6)"
        link: f9.d05.T3
      - id: project-state.f10-f12.T4
        type: LINK
        predicate: "F10-F12 reactivates on F9-D05 T4 (external requirement per F9-D04 T3 that brings its own problem+evidence contract)."
        provenance: "PROJECT_STATE.md · DEFERRED · F10-F12 (split 3/6)"
        link: f9.d05.T4
      - id: project-state.f10-f12.T5
        type: LINK
        predicate: "F10-F12 reactivates on F9-D05 T5 (external requirement per F9-D04 T4 that brings its own problem+evidence contract)."
        provenance: "PROJECT_STATE.md · DEFERRED · F10-F12 (split 4/6)"
        link: f9.d05.T5
      - id: project-state.f10-f12.T6
        type: LINK
        predicate: "F10-F12 reactivates on F9-D05 T6 (external requirement per F9-D04 T5 that brings its own problem+evidence contract)."
        provenance: "PROJECT_STATE.md · DEFERRED · F10-F12 (split 5/6)"
        link: f9.d05.T6
      - id: project-state.f10-f12.T7
        type: LINK
        predicate: "F10-F12 reactivates on F9-D05 T7 (external requirement per F9-D04 T6 that brings its own problem+evidence contract)."
        provenance: "PROJECT_STATE.md · DEFERRED · F10-F12 (split 6/6)"
        link: f9.d05.T7

  - deferral: dec01
    combine: ANY
    note: "E1 sub-decision (type-taxonomy) of DEC-01/ARCH-007 (SPLIT + DEFER). Sibling sub-decisions E2 (gate-mapping), E3 (auth_holder-mapping), E4 (precedent-index) are RETIRED (see ARCH-007 DECISION with RESOLVED_BY pointers). Only E1 is observable via this deferral block. Contract: DECISION_REGISTRY.md · ARCH-007. Learning: docs/00_SYSTEM/DECISION_HISTORY.md · DEC-01."
    provenance: "PROJECT_STATE.md · DEFERRED · DEC-01-E1; docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md §23 canonical trigger definitions"
    triggers:
      - id: project-state.dec01.T1
        type: EVENT
        predicate: "EXP-D01-01 registra ≥10 casos/mes de consulta simultánea multi-fuente por reviewer humano al clasificar tipos de cambio."
        provenance: "PROJECT_STATE.md · DEFERRED · DEC-01-E1 · trigger T1; docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md §20.1 EXP-D01-01 + §23 dec01.T1"
      - id: project-state.dec01.T2
        type: EVENT
        predicate: "DEC-02 se abre y requiere `change_type` como key primaria del delegation registry (no cubierta por AUTHORITY_KIND four-class taxonomy)."
        provenance: "PROJECT_STATE.md · DEFERRED · DEC-01-E1 · trigger T2; docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md §14 DEC-02 dependency revalidation + §23 dec01.T2"
      - id: project-state.dec01.T3
        type: COUNT
        predicate: "≥3 tipos de commit nuevos fuera de la enumeración canónica de `.claude/rules/git-policy.md` observados en un período de 3 meses."
        provenance: "PROJECT_STATE.md · DEFERRED · DEC-01-E1 · trigger T3; docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md §22.1 + §23 dec01.T3"
      - id: project-state.dec01.T4
        type: EVENT
        predicate: "Incidente material atribuido a ausencia de D-CATALOG documentado en INCIDENT_REGISTRY.md con RCA que lo enlace."
        provenance: "PROJECT_STATE.md · DEFERRED · DEC-01-E1 · trigger T4; docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md §22.1 + §23 dec01.T4"
      - id: project-state.dec01.T5
        type: EVENT
        predicate: "Owner planea escalamiento a S2/S3 (≥2 humanos activos) con requerimiento de onboarding uniforme sobre tipos de cambio y sus autoridades."
        provenance: "PROJECT_STATE.md · DEFERRED · DEC-01-E1 · trigger T5; docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md §9.2 + §23 dec01.T5"
      - id: project-state.dec01.T6
        type: LINK
        predicate: "ARCH-006 Trigger T3 activa (DEC-02 se abre y requiere referencia canónica a AUTHORITY-KIND que la taxonomía sola no puede resolver)."
        provenance: "PROJECT_STATE.md · DEFERRED · DEC-01-E1 · trigger T6; docs/00_SYSTEM/AUTHORITY_KIND.md §5.6 Trigger T3; docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md §23 dec01.T6"
        link: arch06.T3

  - deferral: arch08
    combine: ANY
    note: "Review-triggers for DEC-02/ARCH-008 (R1+K-A+MINIMUM). Reopening events for the docs-only delegation convention. Contract: DECISION_REGISTRY.md · ARCH-008. Learning: docs/00_SYSTEM/DECISION_HISTORY.md · DEC-02. Note: DEC-02 itself is RESOLVED (Owner Choice applied); these are triggers for future reopening, not a deferred sub-decision. Triggers reopen the gate; they do NOT auto-decide."
    provenance: "PROJECT_STATE.md · ARCH-008 REVIEW TRIGGER; DECISION_REGISTRY.md · ARCH-008 REVIEW TRIGGER section; docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §25 canonical reopening triggers"
    triggers:
      - id: project-state.arch08.T1
        type: EVENT
        predicate: "Incidente material atribuido a delegación implícita registrado en INCIDENT_REGISTRY.md (falla de la convención R1 o del baseline K3-D-OWNER-DEFAULT)."
        provenance: "DECISION_REGISTRY.md · ARCH-008 REVIEW TRIGGER · arch08.T1; docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §25 R0→R1 trigger (a)"
      - id: project-state.arch08.T2
        type: EVENT
        predicate: "DEC-07 F2/F3 se abre y requiere un anclaje de autorización a un delegatee que MODEL-A no puede expresar con el schema mínimo {delegator, delegatee_ref, scope}."
        provenance: "DECISION_REGISTRY.md · ARCH-008 REVIEW TRIGGER · arch08.T2; docs/00_SYSTEM/DEC-02_D-DELEG_DECISION_GATE_REVISED.md §16 DEC-07 F2/F3 SOFT-INFORMING; docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §25 R0→R1 trigger (b)"
      - id: project-state.arch08.T3
        type: EVENT
        predicate: "Owner declara escalamiento a S2/S3 (≥2 humanos activos) con requerimiento de delegaciones documentadas per role."
        provenance: "DECISION_REGISTRY.md · ARCH-008 REVIEW TRIGGER · arch08.T3; docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §25 R0→R1 trigger (c)"
      - id: project-state.arch08.T4
        type: EVENT
        predicate: "Un caso real de delegación surge cuyo target no es naturalmente un actor y no se puede modelar como scope-of-actor con honestidad (falsaría el hallazgo derivado 'target = actor')."
        provenance: "DECISION_REGISTRY.md · ARCH-008 REVIEW TRIGGER · arch08.T4; docs/00_SYSTEM/DEC_02_DELEGATION_GROUND_TRUTH_AUDIT.md §12 counterexample survey; docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §25 K-A→K3 trigger"
      - id: project-state.arch08.T5
        type: EVENT
        predicate: "Una entrada de delegación necesita autorización per-skill materialmente distinta del scope-prose actual (activaría considerar K-A → K-B migración: type: skill entries con authorized_invoker)."
        provenance: "DECISION_REGISTRY.md · ARCH-008 REVIEW TRIGGER · arch08.T5; docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §25 K-A→K-B trigger"
      - id: project-state.arch08.T6
        type: EVENT
        predicate: "Cualquiera de los CAPABILITY re-entry thresholds T-CAP-1..T-CAP-5 se dispara: (T-CAP-1) ≥2 entries comparten stable-role a través de implementation churn con costo observable; (T-CAP-2) bulk-edit sobre ≥3 entries por implementation replacement; (T-CAP-3) DEC-07/DEC-REVIEWER-VERDICT requiere identidad implementación-independiente irreducible por scope prose; (T-CAP-4) artefacto canónico CCP comienza a referir 'capability' first-class; (T-CAP-5) PRIM excavation independiente identifica CAPABILITY como primitiva latente."
        provenance: "DECISION_REGISTRY.md · ARCH-008 REVIEW TRIGGER · arch08.T6; docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md §18 CAPABILITY REENTRY THRESHOLD T-CAP-1..T-CAP-5"
-->
ACTIVE_DECISIONS:       ARCH-001, ARCH-002, ARCH-003, ARCH-004, ARCH-005, ARCH-006, ARCH-007, ARCH-008
RESOLVED_OWNER_DECISIONS: F9-D01=A, F9-D02=B, F9-D03=B, F9-D04=B, F9-D05=A (2026-09-20);
                        DEC-11=HYB-FINAL-v4 (2026-09-26, OWNER_CHOSEN, IMPL_AUTHORIZED,
                        WORKING_TREE_EXECUTED, CONFORMANCE_PASS, CHECKPOINTED_cd0511c);
                        DEC-AUTH-BOUNDARY=AB5+VOCAB-A (2026-09-26, OWNER_CHOSEN,
                        IMPL_AUTHORIZED=YES, WORKING_TREE_EXECUTED,
                        CONFORMANCE_PASS, CHECKPOINTED_473759c (2026-09-27);
                        location: docs/00_SYSTEM/AUTHORITY_KIND.md);
                        DEC-01=E SPLIT+DEFER (2026-09-27, OWNER_CHOSEN,
                        IMPL_AUTHORIZED=YES, WORKING_TREE_EXECUTED,
                        CHECKPOINTED_e529359 (2026-09-27);
                        contract: DECISION_REGISTRY.md ARCH-007;
                        sub-decisions: E1 type-taxonomy DEFERRED (dec01.T1..T6),
                        E2 gate-mapping RETIRED (RESOLVED_BY hooks+rules),
                        E3 auth_holder-mapping RETIRED (RESOLVED_BY ARCH-006),
                        E4 precedent-index RETIRED (RESOLVED_BY DECISION_REGISTRY+
                        DECISION_HISTORY+git));
                        DEC-02=R1+K-A+MINIMUM (2026-09-28, OWNER_CHOSEN,
                        IMPL_AUTHORIZED=YES, WORKING_TREE_EXECUTED,
                        CONFORMANCE_PENDING (V-DELEG-1..V-DELEG-10),
                        CHECKPOINT_PENDING;
                        contract: DECISION_REGISTRY.md ARCH-008;
                        learning: docs/00_SYSTEM/DECISION_HISTORY.md DEC-02;
                        evidence: DECISION_REGISTRY.md ARCH-008 EVIDENCIA
                        section (docs-only bookkeeping pattern per ARCH-004;
                        same as ARCH-005/006/007: no EV-NNN individual);
                        semantic target = ACTOR;
                        minimum schema = {delegator, delegatee_ref, scope};
                        deferred fields = {actor_kind, activation, revocation,
                        provenance-as-field};
                        V=DEFER, Q=DEFER, P=DEFER;
                        EXP-DEC02-SEM=SKIP;
                        CAPABILITY=SPECULATIVE (NOT PRESENT, NOT REFUTED);
                        RUNTIME AUTHORIZATION=NONE;
                        reopening triggers arch08.T1..T6 combine ANY;
                        analytical chain: docs/00_SYSTEM/DEC_02_*.md (six Stratum-C
                        artifacts, 5,309 lines, untracked, non-canonical))
LAST_GIT_CHECKPOINT:    e529359
LAST_MOVEMENT:          MOVEMENT 008 (2026-09-23) — HRQS Implementation + PAC Corpus Completion + CCP Handoff;
                        HRQS checklist added to handbook §12 (PAC-EF-02 FP class documented);
                        PAC corpus complete: 23 policies (21 enforced + 2 proposed/READY-02);
                        CCP Complete Handoff committed (c41c8c9; 61_CCP_COMPLETE_HANDOFF.md + 5 supporting docs);
                        All M001-M007 research artifacts staged (31 files, 18503 insertions);
                        NOW-EXECUTABLE list fully exhausted;
                        TRUE FRONTIER: OWNER DECISION GATE (READY-01/02/03/04)
LAST_AUDIT:             2026-09-19
LAST_ROADMAP:           2026-09-19
LAST_BEHAVIORAL_AUDIT:  2026-09-18
LAST_RESEARCH_HANDOFF:  2026-09-19
LAST_F8_RESEARCH:       2026-09-18
LAST_F9_RESEARCH:       2026-09-19
LAST_F9_OWNER_DECISION: 2026-09-20
F9_RESEARCH_STATUS:     COMPLETE
F9_DECISION:            F9 NOT JUSTIFIED
F9_IMPLEMENTATION:      NOT AUTHORIZED / NOT PERFORMED
F9_OWNER_DECISION_GATE: CLOSED (2026-09-20)
NATIVE_CLAUDE_CODE:     NOT VERIFIED (deferred per F9-D02=B until concrete trigger)
NEXT_ALLOWED_PHASE:     None auto; a new owner-driven project decision is required. F10-F12 UNKNOWN / NOT STARTED.
IMPLEMENTATION_READY:   false
CONTROL_PLANE_VERSION:  1.0
CONFIG_SCHEMA_VERSION:  1

## Notas

- F1 PASS, F2 PASS, F3 PASS, F4 PASS, F5 PASS y F6 PASS; EV-008 cierra el plan inicial.
- F7 Extended IMPLEMENTED / VERIFIED: EV-009 a EV-014; REG-002 a REG-009; maintenance 12/12 PASS.
- F8 COMPLETE / VERIFIED: F8-A y F8-B fail-closed; A-06 documentado; EV-015/EV-016; REG-010/REG-011; maintenance 12/12 PASS.
- F9 RESEARCH COMPLETE (`docs/00_SYSTEM/F9_RESEARCH.md`, commit `bfe03b7`): decision `F9 NOT JUSTIFIED`; sin nueva evidencia, sin nuevas regresiones, sin cambios de runtime.
- F9 OWNER DECISION GATE CLOSED (`docs/00_SYSTEM/F9_OWNER_DECISIONS.md`, 2026-09-20): F9-D01=A (keep implementation closed), F9-D02=B (defer native evidence), F9-D03=B (keep documentary candidates deferred), F9-D04=B (external requirement trigger for integrity work), F9-D05=A (F10-F12 remain UNKNOWN); documentation-only closure, no runtime, hook, fixture, evidence, regression, agent, skill, rule, dependency, registry or architecture change.
- Dossier de referencia `docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md` agregado post-F9 (commit `9a52875`) como documentacion suplementaria; no forma parte del contrato de cambio de la investigacion F9.
- La evidencia canonica vive en `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
- `docs/MASTER_EVOLUTION_ROADMAP.md` registra F7 como IMPLEMENTED / VERIFIED y ARCH-004 como decision activa.
- `docs/00_SYSTEM/POST_F7_AUDIT_REPORT.md` conserva baseline, regresiones, rollback, limitaciones y variance de budget aceptada por el owner.
- Runtime nativo Claude Code: NOT_VERIFIED en OpenCode; investigacion nativa DEFERIDA por F9-D02=B hasta trigger concreto (recurrencia G-B11 determinista, tool failure perdido, decision de integracion nativa u otro problema reproducible). No debe reinterpretarse como `BROKEN`.
<!-- deferral-triggers:
scope: project-state
deferral: note55
combine: ANY
note: "Prose triggers duplicate F9-D02. Normalized as one LINK per canonical target per DEFERRAL_POLICY.md §7. Prose remains authoritative for context; canonical predicates live in F9-D02."
triggers:
  - id: project-state.note55.T1
    type: LINK
    predicate: "Recurrencia G-B11 determinista → F9-D02 T1 (deterministic recurrence of the G-B11 phantom SubagentStop events)."
    provenance: "PROJECT_STATE.md · Nota 55 (Runtime nativo Claude Code) · trigger phrase 1"
    link: f9.d02.T1
  - id: project-state.note55.T2
    type: LINK
    predicate: "Tool failure perdido → F9-D02 T2 (a tool failure demonstrably lost by the manual incident workflow)."
    provenance: "PROJECT_STATE.md · Nota 55 · trigger phrase 2"
    link: f9.d02.T2
  - id: project-state.note55.T3
    type: LINK
    predicate: "Decision de integracion nativa → F9-D02 T3 (native integration decision that depends on dispatcher, matcher, ordering, payload shape, or re-entry facts)."
    provenance: "PROJECT_STATE.md · Nota 55 · trigger phrase 3"
    link: f9.d02.T3
  - id: project-state.note55.T4
    type: LINK
    predicate: "Otro problema reproducible → F9-D02 T4 (any other reproducible problem whose resolution requires native lifecycle evidence)."
    provenance: "PROJECT_STATE.md · Nota 55 · trigger phrase 4"
    link: f9.d02.T4
-->
- Frontera Git + reviewer humano permanece como trust boundary declarada (F9-D04=B); A-05, A-07 y G-N5 permanecen diferidos hasta trigger externo verificable (auditoria, compliance, requerimiento contractual/cliente o expansion explicita del trust boundary), y ese trigger habilita investigacion previa, no implementacion automatica.
<!-- deferral-triggers:
scope: project-state
deferral: note56
combine: ANY
constraint: "Trigger authorizes research first, not implementation. Inherits F9-D04 constraint verbatim."
constraint-provenance: "PROJECT_STATE.md · Nota 56 · 'ese trigger habilita investigacion previa, no implementacion automatica'; mirror of f9.d04 constraint"
note: "Prose triggers duplicate F9-D04. Normalized as one LINK per canonical target per DEFERRAL_POLICY.md §7. The Spanish compound 'contractual/cliente' is split into two LINKs (contractual → F9-D04 T3; cliente → F9-D04 T4) since the source enumerates both as alternatives via the slash."
triggers:
  - id: project-state.note56.T1
    type: LINK
    predicate: "Auditoria → F9-D04 T1 (external audit)."
    provenance: "PROJECT_STATE.md · Nota 56 · trigger phrase 1"
    link: f9.d04.T1
  - id: project-state.note56.T2
    type: LINK
    predicate: "Compliance → F9-D04 T2 (compliance obligation)."
    provenance: "PROJECT_STATE.md · Nota 56 · trigger phrase 2"
    link: f9.d04.T2
  - id: project-state.note56.T3
    type: LINK
    predicate: "Requerimiento contractual/cliente (contractual branch) → F9-D04 T3 (contractual requirement)."
    provenance: "PROJECT_STATE.md · Nota 56 · trigger phrase 3 (split 1/2 of 'contractual/cliente')"
    link: f9.d04.T3
  - id: project-state.note56.T4
    type: LINK
    predicate: "Requerimiento contractual/cliente (cliente branch) → F9-D04 T4 (explicit customer requirement)."
    provenance: "PROJECT_STATE.md · Nota 56 · trigger phrase 3 (split 2/2 of 'contractual/cliente')"
    link: f9.d04.T4
  - id: project-state.note56.T5
    type: LINK
    predicate: "Expansion explicita del trust boundary → F9-D04 T5 (Owner-approved expansion of the trust boundary)."
    provenance: "PROJECT_STATE.md · Nota 56 · trigger phrase 4"
    link: f9.d04.T5
-->
- F7 permanece COMPLETE / FROZEN en `47874a5`; F8 permanece COMPLETE / FROZEN en `2cd7953`; F9 se detiene en RESEARCH COMPLETE + OWNER GATE CLOSED sin autorizacion de implementacion. F10-F12: UNKNOWN / NOT STARTED; el nombrado de la proxima fase se decidira cuando exista problema+evidencia concreto.
