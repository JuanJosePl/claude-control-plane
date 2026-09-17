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
