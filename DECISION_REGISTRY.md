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
