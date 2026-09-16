---
name: estado
description: Muestra el estado operativo completo del proyecto (fase, bloqueantes, decisiones activas, últimas entradas de log).
user-invocable: true
---

# /estado — Estado Operativo

Lee y presenta en formato compacto:

1. **PROJECT_STATE.md** (fuente única) — campos: CURRENT_PHASE, PHASE_STATUS, CURRENT_OBJECTIVE, BLOCKERS, ACTIVE_DECISIONS, LAST_GIT_CHECKPOINT, NEXT_ALLOWED_PHASE, IMPLEMENTATION_READY.
2. **CLAUDE_SESSION_LOG.md** — últimas 5 entradas (`tail -n 40` o las últimas secciones `## YYYY-MM-DD`).
3. **ARTIFACT_MANIFEST.md** — estado de entregables de la fase actual (líneas con ✔/⏳/✗).

## Formato de salida

```
=== ESTADO OPERATIVO — {fecha} ===

FASE:        {CURRENT_PHASE} · {PHASE_STATUS}
OBJETIVO:    {CURRENT_OBJECTIVE}
BLOQUEANTES: {BLOCKERS o NINGUNO}
DECISIONES:  {ACTIVE_DECISIONS}
CHECKPOINT:  {LAST_GIT_CHECKPOINT}

ENTREGABLES FASE {N}:
  ✔ ...
  ⏳ ...
  ✗ ...

ÚLTIMAS ACTIVIDADES:
  {últimas 3–5 entradas del log}
```

Si PROJECT_STATE.md no existe → reportar "CRÍTICO: PROJECT_STATE.md ausente — ejecutar /recovery E-1".
