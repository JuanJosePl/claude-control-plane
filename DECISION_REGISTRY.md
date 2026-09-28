# DECISION REGISTRY

> Fuente unica de decisiones estructuradas. Las decisiones activas se resumen en
> `.claude/context/DECISIONS.md`.

## ARCH-001 — Scope de proyecto

- TIPO: INFRA
- ESTADO: APROBADA
- FECHA: 2026-09-16
- DECISION: El control plane se instala a nivel de proyecto en `.claude/`.
- EVIDENCIA: EV-001
- REVERSIBILIDAD: FACIL

## ARCH-002 — Carga de context packs

- TIPO: INFRA
- ESTADO: APROBADA
- FECHA: 2026-09-16
- DECISION: `SubagentStart.additionalContext` carga los packs por rol; no se depende de `skills:`
  en el frontmatter de agentes sin prueba de runtime.
- EVIDENCIA: EV-001
- REVERSIBILIDAD: FACIL

## ARCH-003 — Ruta canonica de evidence

- TIPO: INFRA
- ESTADO: APROBADA
- FECHA: 2026-09-16
- DECISION: Toda evidencia de cambios vive en `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
- EVIDENCIA: EV-001
- REVERSIBILIDAD: FACIL

## ARCH-004 — Task Tracking Semantics

- TIPO: PROCESS
- ESTADO: APROBADA
- FECHA: 2026-09-18
- DECISION: El trabajo se clasifica como CONTRACTUAL TASK, INTERNAL TODO / CHECKLIST, SUBTASK o RESEARCH NOTE. Solo una CONTRACTUAL TASK requiere evidencia VERIFIED y pasa por el gate TaskCompleted. Los INTERNAL TODO / CHECKLIST y SUBTASK no requieren EV-NNN individual y se marcan `deleted` al cerrar el contrato que los contiene. Una RESEARCH NOTE se registra en documentacion y no pasa por el gate. Los task_id contractuales usan `<fase>-<slug>-YYYY-MM-DD-<hash>`; el `contract_hash` del payload es opcional durante esta fase, pero si se proporciona debe coincidir con el hash del registro VERIFIED. La ausencia se permite solo de forma transicional con warning y pasa a fail-closed en la siguiente fase.
- EVIDENCIA: F7_F12_RESEARCH_HANDOFF.md sections J/AI; EV-012 al cierre de F7
- REVERSIBILIDAD: FACIL
- ADDENDUM F8-A (2026-09-19): `contract_hash` es obligatorio para toda CONTRACTUAL TASK. Su
  omision es fail-closed y bloquea TaskCompleted con `exit 2`. La advertencia transicional de F7
  queda SUPERSEDED por F8-A. El addendum no altera la distincion historica de tipos de trabajo.
- EVIDENCIA F8-A: EV-015

## ARCH-005 — Deferral Policy (DEC-11 HYB-FINAL-v4)

- TIPO: GOVERNANCE
- ESTADO: OWNER_CHOSEN (2026-09-26); IMPLEMENTATION_AUTHORIZED: YES (2026-09-26);
  IMPLEMENTATION_WORKING_TREE: EXECUTED (2026-09-26);
  CONFORMANCE_VERIFICATION: PASS (2026-09-26 · 13/13 checks V1-V13);
  COMMIT_POST_IMPLEMENTATION: DONE (cd0511c, 2026-09-26); CHECKPOINTED
- FECHA: 2026-09-26
- DECISION: Formaliza los triggers de deferrals Owner-authorized mediante bloques
  YAML estructurados in-document con vocab cerrado {EVENT, CONDITION, COUNT, DATE,
  LINK}, IDs namespaced estables (formato `<scope>.<deferral-id>.T<index>`),
  combinación explícita por bloque (`combine: ANY` sólo donde la prosa fuente
  documenta triggers alternativos), y `provenance:` en cada trigger. Principio
  rector: normalización de representación ≠ cambio semántico ≠ reapertura de
  decisión. Introduce `docs/00_SYSTEM/DEFERRAL_POLICY.md` como política canónica.
  Absorbe DEC-13 (external-triggered) como campo `trigger:`. Habilita DEC-08
  formal con precedente procedimental limpio.
- ALCANCE: docs-only. Retrofit in-situ de F9_OWNER_DECISIONS.md (F9-D01..D05),
  PROJECT_STATE.md (DEFERRED entries + notas 55-56 vía LINK-normalization),
  BEHAVIORAL_RELIABILITY_AUDIT.md (G-B10, G-N4). NH-11 y G-L1 (HYPOTHESIS-tier
  NOT AUTHORIZED) permanecen sin retrofit; documentados como gaps en
  DEFERRAL_INVENTORY.md.
- NO-GOALS: registry paralelo; runtime; hooks; maintenance.sh integration;
  revisión periódica obligatoria; lint automático; combine operators distintos
  de ANY; articulación de NH-11/G-L1; definición del predicado TRIGGER-4 (AC-03).
- EVIDENCIA: docs/00_SYSTEM/DEFERRAL_INVENTORY.md (persistido 2026-09-26 vía
  EXP-1: baseline empírica; 34/36 triggers ya observables). Contrato completo en
  el bloque §18 Owner Decision registrado en conversation log.
- REVERSIBILIDAD: FACIL (`git revert` del commit de retrofit).
- LOCK-IN: BAJO (Markdown + YAML in-document; sin runtime; sin dependencias).
- REVIEW TRIGGER: (observable, combine: ANY)
  - EVENT: LINK dangling detectado tras cambio de ID sin migración.
  - COUNT: ≥3 deferrals Owner-authorized nuevos añadidos sin trigger estructurado
    cuando el predicado observable era extraíble.
  - EVENT: apertura de DEC-08 formal invoca DEC-11 como precedente y expone
    tensión no prevista.
  - EVENT: futura política invoca "literal retrofit ≠ reapertura" y Owner
    determina misaplicación.
  - EVENT: emerge deferral cuya semántica de combinación requiere operador
    distinto de ANY (fuerza nueva decisión Owner).
- CRUZA F9-D01: NO.
- IMPLEMENTATION AUTHORIZATION: GRANTED (2026-09-26, Owner). Retrofit executed
  and conformance-verified (V1-V13 PASS). Checkpointed at commit cd0511c
  (2026-09-26).
- K3-D-DEFERRAL-LIFECYCLE STATUS: ADDRESSED (empirical validation pending;
  closure criteria in Decision Contract §K3 section).

## ARCH-006 — DEC-AUTH-BOUNDARY (PRIM-1 AUTHORITY-KIND materialization)

- TIPO: GOVERNANCE
- ESTADO: OWNER_CHOSEN (2026-09-26);
  IMPLEMENTATION_AUTHORIZED: YES (2026-09-26);
  IMPLEMENTATION: EXECUTED (2026-09-26);
  IMPLEMENTATION_LOCATION: docs/00_SYSTEM/AUTHORITY_KIND.md;
  CONFORMANCE_VERIFICATION: PASS (2026-09-26 · V-AUTH-1..V-AUTH-11 + 12/12 adversarial;
  re-verified 2026-09-27);
  CHECKPOINT: DONE (473759c, 2026-09-27); CHECKPOINTED
- FECHA: 2026-09-26
- OWNER_CHOICE: AB5 (Taxonomy + change rules only) + VOCAB-A (CLOSED vocabulary)
- OWNER_JUSTIFICATION (fielmente preservada): "Elijo AB5 porque materializa
  únicamente la primitiva AUTHORITY-KIND que ya fue identificada como estructura
  latente, formalizando sus cuatro clases canónicas y las reglas de evolución,
  pero sin introducir todavía el coste y lock-in de un mapping pieza-por-pieza
  ni acoplarla prematuramente con DEC-02. La elección sigue la regla Beneficio
  > Complejidad y mantiene una ruta reversible hacia AB2 sólo si evidencia
  futura demuestra que el mapping por pieza es necesario. Elijo VOCAB-A para
  mantener un vocabulario cerrado y evitar semantic drift; una nueva clase
  deberá justificar una reapertura formal de la decisión."
- DECISION: Materializar PRIM-1 (AUTHORITY-KIND) como objeto canónico de primer
  orden mediante (a) taxonomía cerrada de cuatro clases ATTESTED y (b) reglas
  explícitas de evolución del vocabulario. NO se materializa mapping sistemático
  pieza → autoridad (fuera de AB5); NO se acopla con DEC-02 (relación SOFT /
  ENABLER preservada, no HARD).
- VOCABULARY (CANÓNICO, CERRADO — VOCAB-A):
  `{ mecánica, convención, humana, agente }` — exactamente cuatro clases
  ATTESTED. Una clase adicional requiere reapertura formal de esta decisión.
  Clases hipotéticas (`external-service`, `compliance-authority`, `evaluator`,
  etc.) permanecen HYPOTHESIS y no son canónicas. `observ.` / `interno` NO son
  authority-kind (pertenecen a otros ejes según M011).
- ALCANCE (AB5): (a) taxonomía de las cuatro clases y (b) reglas de cambio /
  evolución del vocabulario. Sin registry pieza-por-pieza; sin runtime; sin
  hooks; sin skills; sin modificación de MASTER_HANDOFF; sin apertura de DEC-02.
- NO-GOALS: mapping enumerativo pieza → authority-kind; DELEGATION_REGISTRY;
  embebido en MASTER_HANDOFF (no muta contrato snapshot → living); coupling
  explícito con DEC-02; extensión ordinaria del vocabulario (VOCAB-B) o
  transacción Owner-controlled implícita (VOCAB-C); apertura de meta-authority
  implícita.
- RELACIÓN CON OTRAS DECISIONES:
  - DEC-02: SOFT / ENABLER (no HARD). Facilitación, no precondición.
  - DEC-12: no HARD. Formulable posteriormente.
  - DEC-11 / ARCH-005: precedente procedimental (no obligación estructural).
- REVIEW TRIGGER (observable, combine: ANY):
  - EVENT: evidencia concreta de que el mapping pieza-por-pieza es necesario
    (habilita ruta reversible AB5 → AB2 sin reapertura de la elección base).
  - EVENT: aparece una autoridad ATTESTED fuera de las cuatro clases canónicas
    (fuerza reapertura formal por VOCAB-A CLOSED).
  - EVENT: DEC-02 se abre y requiere referencia canónica a AUTHORITY-KIND que
    la taxonomía sola no puede resolver.
  - EVENT: se detecta uso implícito de una "meta-authority" en runtime, hooks o
    documentos canónicos (violación de vocabulario cerrado).
- REVERSIBILIDAD: FACIL (docs-only una vez implementado; taxonomía sin runtime
  ni lock-in; ruta AB5 → AB2 disponible bajo trigger observable).
- LOCK-IN: BAJO (sólo taxonomía + reglas de evolución; sin mapping ni
  dependencias).
- EVIDENCIA:
  - M009 (POST-CHECKPOINT DECISION-SPACE RECOMPOSITION).
  - M010 (DEC-AUTH-BOUNDARY DECISION GATE OPENED).
  - M011 (ADVERSARIAL VALIDATION → corrections applied → OWNER_GATE_READY).
  - `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md` (structural audit).
  - `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md` (option space).
- IMPLEMENTATION AUTHORIZATION GATE: GRANTED (2026-09-26, Owner). Implementation
  executed in `docs/00_SYSTEM/AUTHORITY_KIND.md` (315 lines; §1 Propósito,
  §2 Vocabulario canónico, §3 Definiciones semánticas por clase, §4 Contrato
  VOCAB-A CLOSED, §5 Reglas de evolución, §6 Prohibiciones, §7 Relación con
  otras decisiones, §8 Gaps, §9 Provenance y evidencia). Conformance V-AUTH-1
  through V-AUTH-11 PASS; 12/12 adversarial post-implementation audit PASS.
  Checkpointed at commit 473759c (2026-09-27, Owner authorization).

## ARCH-007 — DEC-01 D-CATALOG (SPLIT + DEFER)

- TIPO: GOVERNANCE
- ESTADO: OWNER_CHOSEN (2026-09-27);
  IMPLEMENTATION_AUTHORIZED: YES (2026-09-27);
  IMPLEMENTATION: EXECUTED (2026-09-27);
  IMPLEMENTATION_LOCATION: docs-only bookkeeping (DECISION_REGISTRY.md this entry
  + docs/00_SYSTEM/DECISION_HISTORY.md + PROJECT_STATE.md);
  CONFORMANCE_VERIFICATION: PENDING (V-CATALOG-1..12);
  CHECKPOINT: PENDING (Owner authorization requerida)
- FECHA: 2026-09-27
- OWNER_CHOICE: E (SPLIT + DEFER) — E1 (type-taxonomy) DEFERRED con §23 triggers;
  E2 (gate-mapping) / E3 (auth_holder-mapping) / E4 (precedent-index) RETIRED
  con `RESOLVED_BY:` explícito.
- OWNER_JUSTIFICATION (fielmente preservada): "Elijo E (SPLIT + DEFER)"
- DECISION: Cerrar DEC-01/D-CATALOG particionando el objeto histórico monolítico
  (`type × gate × auth_holder × precedent`) en cuatro sub-decisiones con
  veredictos separados:
  - **E1 (type-taxonomy)**: DEFERRED con bloque YAML de triggers observables
    (`dec01.T1..T6`, combine `ANY`) en `PROJECT_STATE.DEFERRED` per
    `docs/00_SYSTEM/DEFERRAL_POLICY.md` schema. No se materializa taxonomía hoy.
    Reactivación por evidencia empírica (EXP-D01-01, COUNT tipos nuevos),
    apertura de DEC-02 con requerimiento `change_type`-key, incidente material,
    escalamiento S2/S3, o link a ARCH-006 T3.
  - **E2 (gate-mapping)**: RETIRED. `RESOLVED_BY:` `.claude/hooks/*.sh` +
    `.claude/rules/*.md` + `.claude/settings.json` (los hooks *son* los gates;
    documento consultivo redundante).
  - **E3 (auth_holder-mapping)**: RETIRED. `RESOLVED_BY:` ARCH-006
    (`docs/00_SYSTEM/AUTHORITY_KIND.md`). Materializar mapping
    change-type → authority-kind está PROHIBIDO por ARCH-006 §6 (piece →
    authority mapping y análogos); intentarlo activaría Trigger T4 de
    ARCH-006 §5.6.
  - **E4 (precedent-index)**: RETIRED. `RESOLVED_BY:` `DECISION_REGISTRY.md`
    (ADRs estructurados) + `docs/00_SYSTEM/DECISION_HISTORY.md` (learning
    entries) + git log (provenance histórica).
- ALCANCE: docs-only. Sin creación de artefactos filesystem. Sin runtime, hooks,
  skills, agentes, rules, settings, evals. Sin modificación de `git-policy.md`,
  `AUTHORITY_KIND.md`, `DEFERRAL_POLICY.md`, `MASTER_HANDOFF.md`, `CLAUDE.md`.
- NO-GOALS: creación de `CHANGE_TYPE_TAXONOMY.md`, `CHANGE_TYPES_CATALOG.md`,
  `AUTHORITY_BOUNDARY.md`, `DELEGATION_REGISTRY.md`, o cualquier artefacto
  derivado análogo; elevación de `.claude/rules/git-policy.md` a taxonomía
  canónica; mapping change-type → authority; reapertura de ARCH-006 §5; cambio
  en F9-D01 gate closure; enforcement mecánico de tipos de cambio; alteración
  del contract snapshot de MASTER_HANDOFF; modificación de fuentes-de-verdad
  canónicas ya establecidas; introducción de EV-NNN individual (ARCH-004:
  docs-only bookkeeping no requiere).
- RELACIÓN CON OTRAS DECISIONES:
  - **DEC-02 (D-DELEG)**: **SOFT / ENABLER** (revalidada desde HARD histórico
    en `DEC-01_D-CATALOG_DECISION_GATE.md §14`). Formulable con AUTHORITY_KIND
    como taxonomía canónica única; ARCH-007 no es precondición HARD.
  - **ARCH-006 (DEC-AUTH-BOUNDARY)**: precedente estructural (patrón AB5
    taxonomy-only) y restricción activa (§6 prohibiciones aplicadas a E3;
    §5.6 Triggers T2/T4 protegidos).
  - **ARCH-005 (DEC-11 DEFERRAL_POLICY)**: precedente procedimental y
    contrato del DEFER de E1 (bloque YAML en `PROJECT_STATE.DEFERRED` per §7
    schema).
  - **ARCH-004**: docs-only bookkeeping; ARCH-007 no es CONTRACTUAL TASK; no
    requiere EV-NNN individual.
  - **DEC-12 (D-META-DOC)**: ortogonal. ARCH-007 no bloquea ni depende.
  - Sub-decisiones **DEC-STREAM-CONSUMER**, **DEC-REVIEWER-VERDICT**:
    ortogonales.
- REVIEW TRIGGER (E1 reactivación, observable, combine: ANY — canonical en
  `PROJECT_STATE.DEFERRED` dec01):
  - `dec01.T1` EVENT: EXP-D01-01 registra ≥10 casos/mes de consulta
    multi-fuente por reviewer humano.
  - `dec01.T2` EVENT: DEC-02 se abre y requiere `change_type` como key
    primaria del registry (no cubierta por AUTHORITY_KIND).
  - `dec01.T3` COUNT: ≥3 nuevos tipos de commit fuera de
    `.claude/rules/git-policy.md` en 3 meses.
  - `dec01.T4` EVENT: incidente material atribuido a ausencia de D-CATALOG
    en `INCIDENT_REGISTRY.md`.
  - `dec01.T5` EVENT: Owner planea escalamiento a S2/S3 (≥2 humanos activos)
    con requerimiento de onboarding uniforme sobre tipos de cambio.
  - `dec01.T6` LINK: ARCH-006 T3 activa (DEC-02 requiere referencia canónica
    adicional a AUTHORITY-KIND que la taxonomía sola no puede resolver).
- REVERSIBILIDAD: ALTA. `git revert` del commit docs-only restaura estado
  pre-DEC-01. Sin runtime side effects. Reset path: DEC-01 vuelve a "pending"
  con framing corregido documentado en gate.
- LOCK-IN: BAJO (docs-only; sin dependencias runtime; sin materialización de
  filesystem; retirements documentales revocables; DEFER de E1 no fija
  arquitectura).
- EVIDENCIA:
  - `docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md` (2075 líneas, 33
    secciones): evidence matrix E1-E21, homogeneity test 10/12 fails,
    terminological analysis, multi-representation analysis, consumer
    analysis, source-of-truth analysis, redundancy analysis, necessity
    test, empirical 30-commit experiment, DEC-02 dependency reclassification,
    6 alternatives, regression matrix, lock-in analysis, reversible
    experiments, 6 information gaps, falsifiers, deferral triggers,
    second-order adversarial audit, three-level perspectives, absence and
    materialization thought experiments, final decision space, confidence
    table, Owner Decision Brief, consistency checks, comparative matrix.
  - `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md` §5A (`CATALOG` GAP-piece
    heredado sin ataque; ataque adversarial ejecutado en gate).
  - `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md` §4.1 (formulación previa
    pre-ARCH-006, reformulada en gate §3 y §14).
  - `docs/00_SYSTEM/AUTHORITY_KIND.md` §6 (prohibiciones activas para E3
    resolution).
  - `.claude/rules/git-policy.md` línea 3 (source-of-truth de 8 tipos
    canónicos: `feat, fix, docs, arch, decision, security, infra, config`;
    E2 resolution baseline).
- IMPLEMENTATION AUTHORIZATION GATE: GRANTED (2026-09-27, Owner). Implementation
  executed as docs-only bookkeeping (this ARCH-007 entry + DECISION_HISTORY
  entry + PROJECT_STATE update). Conformance V-CATALOG-1..12 PENDING para
  verificación in-session post-persist. Checkpoint autorización SEPARATED (per
  patrón ARCH-006).

## ARCH-008 — DEC-02 D-DELEG (R1 + K-A + MINIMUM)

- TIPO: GOVERNANCE
- ESTADO: OWNER_CHOSEN (2026-09-28);
  IMPLEMENTATION_AUTHORIZED: YES (2026-09-28);
  IMPLEMENTATION: EXECUTED (2026-09-28);
  IMPLEMENTATION_LOCATION: docs-only bookkeeping (this ARCH-008 entry +
  docs/00_SYSTEM/DECISION_HISTORY.md · DEC-02 entry + PROJECT_STATE.md;
  per ARCH-004: docs-only bookkeeping no requiere EV-NNN individual);
  CONFORMANCE_VERIFICATION: PASS (2026-09-28 · maintenance.sh 12/12);
  CHECKPOINT: DONE (5dfd65a, 2026-09-28); CHECKPOINTED
- FECHA: 2026-09-28
- OWNER_CHOICE: R1 (docs-only representation) + K-A (ACTOR-ARTIFACT / MODEL-A) +
  MINIMUM SCHEMA (3 semantically required fields) + V=DEFER + Q=DEFER + P=DEFER +
  EXP-DEC02-SEM=SKIP.
- OWNER_JUSTIFICATION (faithfully preserved from the DEC-02 Owner Choice
  Execution prompt): Make the implicit delegation pattern explicit as a
  docs-only governance convention; the semantic target/delegatee is an ACTOR;
  the semantic minimum for the current decision is `{delegator,
  delegatee_ref, scope}`; the repository reference is the addressing
  mechanism, not the semantic target; `actor_kind`, `activation`,
  `revocation`, `provenance` are schema-level fields deferred to a later
  decision unless a canonical requirement forces them; V/Q/P are explicitly
  deferred (do not silently choose values); EXP-DEC02-SEM (shadow experiment)
  is skipped because the semantic uncertainty was sufficiently reduced by
  the six-artifact analytical chain (target semantics audit, reconciliation,
  ground-truth audit, Owner Choice Package, Super Owner Decision Analysis,
  Final Decision Integrity).
- DECISION: Materializar la delegación como objeto de gobernanza documental
  (`convención` authority per ARCH-006 VOCAB-A) con target semántico
  `ACTOR`. Un delegatee es un actor `agente` (agente file bajo
  `.claude/agents/*.md`) o `humana` (Owner, u otra persona con AUTHORITY_KIND
  `humana`); harness-primitive residuals se representan como `UNKNOWN`
  explícito. Skills, workflows y action-types NO son target types; aparecen
  únicamente como contenido de `scope`. La referencia canónica al artefacto
  es un mecanismo de direccionamiento (ruta o identificador), no la
  identidad semántica.
- SEMANTIC MINIMUM SCHEMA (canonical for this decision):
  `{ delegator, delegatee_ref, scope }`. Cada entrada de delegación registra
  como mínimo estos tres campos. Provenance del entry lives in `git` +
  documento que la contiene (metadata del artefacto, no campo intrínseco de
  MODEL-A). Los campos `actor_kind`, `activation`, `revocation`,
  `provenance-como-campo` son schema-level / DEFERABLE y no forman parte del
  contrato semántico de esta decisión.
- ALCANCE: docs-only. Sin creación de artefactos runtime, sin nuevos hooks,
  sin modificación de `.claude/*`, sin cambios a `AUTHORITY_KIND.md` (VOCAB-A
  cerrado se preserva). Sin creación forzada de una tabla `DELEGATION_
  REGISTRY.md` en este gate; entradas concretas se autorizan en decisiones
  posteriores.
- NO-GOALS (explicit not-chosen items per prompt §2):
  CAPABILITY / HYBRID target model;
  `compound` target type;
  `stable_role` label;
  `authorized_invoker` field;
  full MODEL-A schema (7 campos) como contrato semántico obligatorio;
  runtime enforcement / mechanical authorization;
  modificación de AUTHORITY_KIND / VOCAB-A;
  ACTION_TYPE como delegation target;
  skill-as-target semantics;
  harness-primitive representado como `type: agent`;
  V/Q/P silent-default assignment;
  ejecución automática de EXP-DEC02-SEM;
  apertura de DEC-07 por este acto.
- RELACIÓN CON OTRAS DECISIONES:
  - **DEC-07 (D-VERIFICADOR)**: SOFT / INFORMING para F2/F3 (ARCH-008
    provee un anclaje de gobernanza para el LLM verifier si DEC-07 F2/F3
    se abre; ninguna dependencia HARD).
  - **ARCH-006 (DEC-AUTH-BOUNDARY)**: consumidor. Los entries de
    delegación citan clases `agente` y `humana` de VOCAB-A; no modifican
    ni extienden el vocabulario. Trigger T3 de ARCH-006 §5.6 no se
    activa (K-A no requiere referencias canónicas adicionales a
    AUTHORITY-KIND más allá de las cuatro clases atestadas).
  - **ARCH-005 (DEC-11 DEFERRAL_POLICY)**: precedente procedimental para
    los triggers YAML del review-trigger set (arch08.T1..T6, combine ANY).
  - **ARCH-007 (DEC-01 D-CATALOG)**: sub-decisión E1 continúa DEFERRED;
    trigger `dec01.T2` (DEC-02 requiere `change_type` como key) NO se
    activa porque ARCH-008 elige K-A (ACTOR-ARTIFACT), no K-D
    (ACTION_TYPE). E1 permanece en su estado deferred.
  - **ARCH-004**: docs-only bookkeeping; ARCH-008 no es CONTRACTUAL TASK;
    no requiere EV-NNN individual (mismo patrón que ARCH-005/006/007;
    evidencia agregada vive en la sección EVIDENCIA de este ADR y en
    docs/00_SYSTEM/DECISION_HISTORY.md · DEC-02).
  - **DEC-04 / DEC-05 / DEC-08 / DEC-12 / DEC-STREAM-CONSUMER / DEC-REVIEWER-
    VERDICT**: ortogonales. ARCH-008 no altera su estado.
- REVIEW TRIGGER (arch08, observable, combine: ANY — canonical per
  DEFERRAL_POLICY.md §7 schema):
  - `arch08.T1` EVENT: incidente material atribuido a delegación implícita
    registrado en `INCIDENT_REGISTRY.md` (falla de gobernanza de la
    convención R1 o del baseline K3-D-OWNER-DEFAULT).
  - `arch08.T2` EVENT: DEC-07 F2/F3 se abre y requiere un anclaje de
    autorización a un delegatee que MODEL-A no puede expresar con
    `{delegator, delegatee_ref, scope}` (forzaría revisitar `actor_kind`,
    `activation` o `revocation` como campos).
  - `arch08.T3` EVENT: Owner declara escalamiento a S2/S3 (≥2 humanos
    activos) con requerimiento de delegaciones documentadas per role.
  - `arch08.T4` EVENT: un caso real de delegación surge cuyo target no es
    naturalmente un actor y no se puede modelar como scope-of-actor con
    honestidad (falsaría el hallazgo derivado "target = actor").
  - `arch08.T5` EVENT: una entrada de delegación necesita autorización
    per-skill materialmente distinta del scope-prose actual (activaría
    considerar K-A → K-B migración).
  - `arch08.T6` EVENT: cualquiera de los CAPABILITY re-entry triggers
    T-CAP-1..T-CAP-5 documentados en `DEC_02_SUPER_OWNER_DECISION_
    ANALYSIS.md §18` se dispara (T-CAP-1 stable-role churn observable,
    T-CAP-2 bulk-edit sobre ≥3 entries, T-CAP-3 DEC-07 requiere identidad
    implementación-independiente irreducible, T-CAP-4 artefacto canónico
    referencia "capability" first-class, T-CAP-5 PRIM excavation
    independiente identifica CAPABILITY como primitiva latente).
- CAPABILITY BOUNDARY (per prompt §13): CAPABILITY permanece DEFERRED.
  Clasificación epistémica: `NOT PRESENT como primitiva de primer orden en
  el corpus CCP`; `NOT REFUTED` (la ausencia no es falsificación);
  `SPECULATIVE`. Reopening solo bajo `arch08.T6` (uno o más T-CAP-* fires).
- K BOUNDARY (per prompt §14): K-B / K-C / K-D no seleccionados. Registro
  histórico preservado en la cadena analítica; no se elimina alternativa
  del decision history.
- V/Q/P BOUNDARY (per prompt §15): DEFERRED. No se elige valor silencioso.
  Gates futuros para V, Q, P permanecen posibles.
- RUNTIME BOUNDARY (per prompt §11, mandatory): R1 es `convención /
  documentation`. R1 NO autoriza runtime enforcement. S1 (runtime
  authorization) y S5 (runtime permission enforcement) permanecen fuera
  de esta decisión. Sin hooks nuevos, sin runtime checks, sin tool
  interception, sin autorización automática, sin enforcement mecánico
  nuevo.
- REVERSIBILIDAD: ALTA. `git revert` del commit de canonicalización
  restaura el estado pre-DEC-02. Sin side effects runtime. Reset path:
  DEC-02 vuelve a `OPEN` con Owner Choice pendiente.
- LOCK-IN: BAJO. Docs-only; sin dependencias runtime; sin materialización
  filesystem beyond este ADR + tres bookkeeping updates; sin mapping
  piece-authority (ARCH-006 §6 preservado); sin runtime.
- EVIDENCIA:
  - `docs/00_SYSTEM/DEC_02_TARGET_SEMANTICS_AUDIT.md` (2026-09-28, 1445
    líneas): auditoría inicial; introduce H3-SPLIT; establece CAPABILITY
    NOT PRESENT.
  - `docs/00_SYSTEM/DEC_02_TARGET_SEMANTICS_RECONCILIATION.md` (987
    líneas): meta-auditoría; corrige H3-SPLIT (remueve `compound`,
    `stable_role`, `authorized_invoker` como PROPOSED); introduce
    MODEL-A / K-A.
  - `docs/00_SYSTEM/DEC_02_DELEGATION_GROUND_TRUTH_AUDIT.md` (786 líneas):
    operational definition D-1..D-4; verifica el 5-of-11 real-delegations
    / default-covered decomposition.
  - `docs/00_SYSTEM/DEC_02_OWNER_CHOICE_PACKAGE.md` (573 líneas): superficie
    dimensional R × K × V × Q × P; §17 sequencing.
  - `docs/00_SYSTEM/DEC_02_SUPER_OWNER_DECISION_ANALYSIS.md` (1028 líneas):
    frontier {R0-D0, R1+K-A}; sensibilidad; regret; triggers CAPABILITY
    §18 (T-CAP-1..T-CAP-5).
  - `docs/00_SYSTEM/DEC_02_FINAL_DECISION_INTEGRITY.md` (490 líneas):
    integridad final; separa semantic minimum (3 campos) de schema
    breadth; surface hidden decisions.
  - `docs/00_SYSTEM/DEC-02_D-DELEG_DECISION_GATE_REVISED.md` (gate
    canónico): seis sentidos S1..S6; R × K × V × Q × P.
  - `docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006): VOCAB-A clases
    `agente` y `humana` como authority-holders consumidos.
  - `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md`: PRIM-1..PRIM-7 sin
    CAPABILITY entre primitivas identificadas.
- IMPLEMENTATION AUTHORIZATION GATE: GRANTED (2026-09-28, Owner). Owner
  Choice aplicada exactamente. Implementation ejecutada como docs-only
  bookkeeping (esta ARCH-008 entry + DECISION_HISTORY DEC-02 entry +
  PROJECT_STATE update). Conformance V-DELEG-1..V-DELEG-10
  PENDING para verificación in-session post-persist. Checkpoint
  autorización SEPARATED (per patrón ARCH-006 / ARCH-007).
- DEC-02 STATUS (post-canonicalización): CLOSED / APPROVED con Owner
  Choice R1 + K-A + MINIMUM. Gate `DEC-02_D-DELEG_OPENED.md`
  transiciona conceptualmente de `OPEN` a `CLOSED` mediante este ADR;
  el archivo del gate se preserva como historical evidence.

## ARCH-009 — DEC-08 D-INSTR (B · REFORMULATE)

- TIPO: GOVERNANCE
- ESTADO: OWNER_CHOSEN (2026-09-28);
  IMPLEMENTATION_AUTHORIZED: YES (2026-09-28);
  IMPLEMENTATION: EXECUTED (2026-09-28);
  IMPLEMENTATION_LOCATION: docs-only bookkeeping (this ARCH-009 entry +
  docs/00_SYSTEM/DECISION_HISTORY.md · DEC-08 entry + PROJECT_STATE.md;
  per ARCH-004: docs-only bookkeeping no requiere EV-NNN individual);
  CONFORMANCE_VERIFICATION: PASS (2026-09-28 · maintenance.sh 12/12);
  CHECKPOINT: PENDING (updated post-§3I sync commit)
- FECHA: 2026-09-28
- OWNER_CHOICE: B · REFORMULATE
- OWNER_JUSTIFICATION (fielmente preservada from Move 3 invocation
  prompt `CCP_DEC-08_MOVE3_MASTER_v2.md §1`): "OWNER_CHOICE: B ·
  REFORMULATE (authoritative; see §1)". Owner Choice B selecciona la
  rama arquitectónica que cierra DEC-08 como decisión aislada de
  extensión de schema y registra la invariante "STALL_POLICY_LOG es un
  registro de evento/observación y no debe usarse como fuente
  autoritativa de un juicio independiente sobre la corrección de la
  decisión de política que registra". Los conceptos `verdict`,
  `had_alternative` y `session_id`, cuya semántica fue disambiguada en
  Kernel §11 firewall §6.2.1, permanecen sin materialización runtime;
  su representación futura queda a cargo de la decisión apropiada
  (verifier layer / stream consumer / nueva DEC-N) cuando exista
  necesidad concreta. La reformulación preserva la ganancia analítica
  (event ≠ juicio independiente) sin adquirir lock-in de schema, código
  o runtime.
- DECISION: STALL_POLICY_LOG es un registro de evento/observación y no
  debe usarse como la fuente autoritativa de un juicio independiente
  sobre la corrección de la decisión de política que registra. La
  frontera entre el evento emitido por el hook (`stall-record.sh`) y
  cualquier juicio posterior sobre esa clasificación (correcto /
  incorrecto / alternativa preferible / verificación) se preserva como
  invariante arquitectónica de gobernanza (`convención` per ARCH-006
  VOCAB-A). La decisión NO materializa el layer de verificador ni
  autoriza cambios de schema; se limita a registrar que la separación
  hecho/juicio aplica a este stream.
- SEMANTIC_CLASSIFICATION (canonical outcome of Kernel §11 firewall
  §6.2.1; explicit novel field justified by disambiguation requirement):
  - `verdict`: juicio independiente (verifier-owned). NO presente en el
    schema actual de STALL_POLICY_LOG. NO se añade ahora. Representación
    futura DEFERRED a la decisión de verifier (DEC-07 D-VERIFICADOR,
    DEC-REVIEWER-VERDICT, o una nueva DEC-N cuando exista necesidad).
  - `had_alternative`: derivación retrospectiva (retrospective-derivation).
    Actualmente `null` hardcoded per `stall-record.sh:46`. NO se cambia
    el schema. Semántica futura DEFERRED.
  - `session_id`: metadatos de correlación (correlation-metadata).
    Actualmente `null` por conversión `""` → `null`. Disponibilidad de
    producer at event-time UNVERIFIED. NO se cambia el schema. Semántica
    futura DEFERRED.
  Los tres conceptos son semánticamente DISTINTOS; ARCH-009 NO los
  colapsa en una clase única.
- DEFERRED_ITEMS (explicit novel field justified by non-decision
  discipline): representación de `verdict`; schema de `verdict`;
  productor de `verdict`; identidad / mecanismo / ciclo de vida /
  almacenamiento del verifier layer; workflow de review; outcome de
  DEC-07 D-VERIFICADOR; DEC-REVIEWER-VERDICT; diseño de DEC-STREAM-
  CONSUMER; implementación de correlación por sesión; implementación
  de `had_alternative`; cualquier extensión al schema de STALL; cualquier
  cambio de comportamiento runtime; definición de umbrales `N`/`P` para
  triggers hipotéticos (los triggers de reapertura no se crean bajo B).
- ALCANCE: docs-only. Sin creación de artefactos runtime, sin nuevos
  hooks, sin modificación de `.claude/*`, sin cambios a `stall-record.sh`
  ni a ningún consumer (`query-log.sh`, `evals/r2/r2-instrumentation.sh`),
  sin cambios a `STALL_POLICY_LOG.jsonl` schema, sin creación de un
  registro `STALL_VERDICT_LOG.jsonl` (queda como opción arquitectónica
  para una decisión futura). Preserva la frontera evento / juicio
  independiente. No re-abre F9-D01. No abre DEC-07, DEC-STREAM-CONSUMER,
  ni DEC-REVIEWER-VERDICT.
- NO-GOALS (explicit not-chosen items):
  canonicalización de "verdict pertenece a DEC-07" o análogos;
  canonicalización de "el schema de STALL debe extenderse";
  canonicalización de cualquier arquitectura de verifier;
  autorización de cambio runtime en `stall-record.sh` o hooks callers;
  implementación de `verdict`, `session_id` real, o `had_alternative` real;
  reapertura de F9-D01;
  modificación de DEC-STREAM-CONSUMER, DEC-07, o DEC-REVIEWER-VERDICT;
  creación de triggers de reapertura `arch09.T*` para DEC-08 (Owner
  Choice B cierra; no defiere — futuras necesidades las abre la decisión
  apropiada al problema concreto, no una reactivación automática de
  DEC-08).
- RELACIÓN CON OTRAS DECISIONES:
  - **DEC-07 (D-VERIFICADOR)**: unchanged. La arquitectura futura del
    verifier / judgment layer permanece completamente fuera del alcance
    de DEC-08. ARCH-009 no compromete a DEC-07 con ninguna forma
    específica; si DEC-07 F2/F3 se abre en el futuro, hereda la
    invariante "verdict vive fuera del emitter" como restricción
    arquitectónica, pero NO como precondición HARD.
  - **DEC-STREAM-CONSUMER**: unchanged. No es requerida para esta
    reformulación (coupling MUTUAL-INFO-ONLY per Kernel §11 §6.2.8).
    Si se abre, decide su propia arquitectura de consumer sin heredar
    schema de DEC-08.
  - **DEC-REVIEWER-VERDICT**: unchanged. Sibling decision ortogonal.
    Si se abre, es un candidato natural para propietaria de la
    representación de `verdict`, pero ARCH-009 no lo pre-comete.
  - **F9-D01**: unchanged (=A, CLOSED). ARCH-009 preserva la clausura
    del gate; ningún trigger `f9.d01.T*` se activa por esta decisión.
  - **ARCH-008 (DEC-02 D-DELEG)**: unchanged. ARCH-009 no altera ni
    cita el schema de delegación.
  - **ARCH-007 (DEC-01 D-CATALOG)**: unchanged. Sub-decisión E1
    (type-taxonomy) permanece DEFERRED; ninguno de sus triggers
    `dec01.T*` se activa por ARCH-009.
  - **ARCH-006 (DEC-AUTH-BOUNDARY)**: consumidor. ARCH-009 declara
    la reformulación como authority `convención` per VOCAB-A. No
    modifica ni extiende el vocabulario. Trigger T3 no se activa.
  - **ARCH-005 (DEC-11 DEFERRAL_POLICY)**: precedente procedimental
    NO aplicado a esta decisión — Owner Choice B es cierre, no
    diferimiento; no se registran bloques YAML `arch09.T*`.
  - **ARCH-004**: docs-only bookkeeping; ARCH-009 no es CONTRACTUAL
    TASK; no requiere EV-NNN individual (mismo patrón que
    ARCH-005/006/007/008).
  - **DEC-04 / DEC-05 / DEC-12**: ortogonales. ARCH-009 no altera su
    estado.
- REVIEW TRIGGER: **NONE** (per Owner Choice B). DEC-08 no se
  auto-reactiva. Cualquier necesidad futura concreta se abre como
  la decisión apropiada al problema — DEC-07 D-VERIFICADOR (si emerge
  necesidad de verifier layer), DEC-STREAM-CONSUMER (si emerge
  necesidad de consumer canónico), o una nueva DEC-N (si emerge una
  necesidad no cubierta por las decisiones existentes). Esta ausencia
  de triggers `arch09.T*` es intencional y ha sido explicitada en
  Move 3 §5.3 / §12 como el patrón correcto bajo la Owner Choice B.
- REVERSIBILIDAD: ALTA. La reformulación es un statement documental
  reversible mediante una nueva ADR que altere la invariante. No hay
  implementación que desarmar. `git revert` del commit de canonicalización
  restaura el estado pre-ARCH-009 sin side effects runtime.
- LOCK-IN: BAJO. Sólo se registra una frontera semántica
  (evento ≠ juicio independiente). Sin schema, sin código, sin runtime,
  sin dependencias hard. La invariante es una restricción arquitectónica
  reversible.
- EVIDENCIA:
  - `docs/00_SYSTEM/DEC_08_DECISION_KERNEL.md` §0..§10 (Move 1 Kernel,
    Stratum-C non-canonical; provenance: HEAD `2f55412` at analysis;
    committed at `a3db337`): preflight, meta-gate CoVe, architectural
    excavation, option surface with G1/G2/G3 elimination and G-DEFER /
    G4-REFORMULATE promotion.
  - `docs/00_SYSTEM/DEC_08_DECISION_KERNEL.md` §11 (Move 2 appendix,
    committed at `54f943b`): decision integrity firewall §6.2.1–§6.2.9,
    architectural thesis rewrite (TRUE PROBLEM / TRUE DECISION / TRUE
    NON-DECISION), Owner Choice card A/B/C surface with 10-field option
    contracts, Move 2 attestation.
  - `CCP_DEC-08_MASTER_PROMPT_v3.md` (Move 1 invocation).
  - `CCP_DEC-08_MOVE2_MASTER_v2.md` (Move 2 invocation).
  - `CCP_DEC-08_MOVE3_MASTER_v2.md` (Move 3 invocation; §1 records
    Owner Choice B authoritatively).
  - Per ARCH-004 (mismo patrón que ARCH-005/006/007/008): docs-only
    bookkeeping no requiere EV-NNN individual.
- IMPLEMENTATION AUTHORIZATION: GRANTED (2026-09-28, Owner Choice B via
  Move 3 invocation prompt §1). Implementation ejecutada como docs-only
  bookkeeping (this ARCH-009 entry + DECISION_HISTORY.md DEC-08 entry +
  PROJECT_STATE.md updates). Sin ningún cambio runtime, sin modificación
  a `stall-record.sh` ni a consumers, sin nuevos hooks, sin cambios a
  `.claude/*`, sin cambios a `evals/*` (excepto ejecutar `maintenance.sh`
  como validador externo por RSI safety canon).
- DEC-08 STATUS (post-canonicalización): REFORMULATED / CLOSED con
  Owner Choice B. DEC-08 D-INSTR como decisión aislada de schema
  completion se cierra mediante ARCH-009. Ninguna decisión sucesora
  se abre por este acto; futuras necesidades se resolverán por la
  decisión apropiada al problema concreto.
