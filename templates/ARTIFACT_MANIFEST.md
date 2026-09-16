<!-- INSTRUCCIONES
ARTIFACT MANIFEST — Entregables esperados por fase
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UBICAR EN: raíz del proyecto (no en .claude/)
ACTUALIZADO: manualmente o vía /cerrar-fase
CONSUMIDO POR: /gate y /cerrar-fase

FORMATO:
  ✔ existe · ⏳ en progreso · ✗ falta
  No declarar COMPLETE sin todos los entregables marcados ✔
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BORRAR ESTE BLOQUE AL INSTALAR
-->

# ARTIFACT MANIFEST

> Entregables esperados por fase. Consumido por `/gate` y `/cerrar-fase` para verificación objetiva
> (no declarar COMPLETE sin todos los entregables). ✔ existe · ✗ falta.

## Producto

### FASE 0 — {{nombre}} → {{directorio/}}  [{{estado}}]
- {{✔/⏳/✗}} {{entregable.md}}

### FASE 1 — {{nombre}} → {{directorio/}}  [{{estado}}]
- {{✔/⏳/✗}} {{entregable.md}}

## Control Plane (infra Claude Code) → docs/00_SYSTEM/
- ✔ CLAUDE.md · ✔ PROJECT_STATE.md · ✔ DECISION_REGISTRY.md
- ✔ .claude/context/* · ✔ .claude/rules/* · ✔ .claude/agents/*
- ✔ hooks · ✔ process skills
- ⏳ EVIDENCE_REGISTRY.md · ⏳ CLAUDE_SESSION_LOG.md
