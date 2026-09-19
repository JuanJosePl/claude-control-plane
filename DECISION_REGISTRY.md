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
