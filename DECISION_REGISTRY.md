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
  COMMIT_POST_IMPLEMENTATION: PENDING (awaiting Owner checkpoint authorization)
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
  and conformance-verified (V1-V13 PASS). Awaiting checkpoint commit.
- K3-D-DEFERRAL-LIFECYCLE STATUS: ADDRESSED (empirical validation pending;
  closure criteria in Decision Contract §K3 section).
