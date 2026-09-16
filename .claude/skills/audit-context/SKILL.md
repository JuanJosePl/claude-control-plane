---
name: audit-context
description: Detecta divergencias entre PROJECT_STATE, context packs, DECISION_REGISTRY y memory — fuente única vs fuentes derivadas.
user-invocable: true
---

# /audit-context — Auditoría de Contexto

Detecta divergencias entre las fuentes de verdad del proyecto.

## Jerarquía de verdad (PROJECT_STATE manda)

```
PROJECT_STATE.md (operacional)
  └── .claude/context/CURRENT_STATE.md (mirror)
  └── .claude/context/DECISIONS.md (mirror de DECISION_REGISTRY.md)
  └── memory/ (conocimiento persistente — no estado)
```

## Checks

### 1. CURRENT_PHASE
- Leer `PROJECT_STATE.md` → campo CURRENT_PHASE.
- Leer `.claude/context/CURRENT_STATE.md` → buscar CURRENT_PHASE.
- ¿Coinciden? Si no → CONFLICT.

### 2. PHASE_STATUS
- Mismo check entre PROJECT_STATE y CURRENT_STATE.md.

### 3. ACTIVE_DECISIONS
- Leer `PROJECT_STATE.md` → ACTIVE_DECISIONS.
- Leer `DECISION_REGISTRY.md` → extraer todos los IDs en estado APROBADA.
- ¿Coinciden? Si hay en REGISTRY pero no en STATE → MISSING. Si hay en STATE pero no en REGISTRY → ORPHAN.

### 4. LAST_GIT_CHECKPOINT
- Leer hash de PROJECT_STATE.
- Ejecutar `git cat-file -e {hash} && echo exists || echo missing`.
- ¿Existe en git? Si no → STALE.

### 5. Context packs vs CLAUDE.md
- Verificar que las reglas de CLAUDE.md no contradicen las context packs (comparación de secciones clave de seguridad).

## Formato de salida

```
=== /audit-context — {fecha} ===

CURRENT_PHASE:    PROJECT_STATE={N} · CURRENT_STATE={N}  ✔/CONFLICT
PHASE_STATUS:     PROJECT_STATE={S} · CURRENT_STATE={S}  ✔/CONFLICT
ACTIVE_DECISIONS: {N en STATE} · {N en REGISTRY}  ✔/MISSING:{list}/ORPHAN:{list}
GIT_CHECKPOINT:   {hash} → {exists/missing in git}  ✔/STALE

RESULTADO: {SINCRONIZADO | DIVERGENCIAS: lista}
```

Si hay CONFLICT o MISSING → recomendar qué archivo actualizar (PROJECT_STATE manda, los mirrors se actualizan para seguirlo).
