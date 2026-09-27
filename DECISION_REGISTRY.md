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
  CONFORMANCE_VERIFICATION: PASS (2026-09-26 · V-AUTH-1..V-AUTH-11 + 12/12 adversarial);
  CHECKPOINT: PENDING
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
  Checkpoint PENDING (separate Owner authorization required).
