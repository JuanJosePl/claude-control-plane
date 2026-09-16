---
name: doctor
description: Health check completo del Control Plane — verifica hooks, settings, context packs, PROJECT_STATE, y permisos de archivos.
user-invocable: true
---

# /doctor — Health Check del Control Plane

Verifica que toda la infraestructura del Engineering Control Plane funciona correctamente.

## Checks (ejecutar en orden)

### 1. PROJECT_STATE.md
- ¿Existe? ¿Tiene CURRENT_PHASE, PHASE_STATUS, BLOCKERS, LAST_GIT_CHECKPOINT?
- ¿LAST_GIT_CHECKPOINT existe en git? (`git cat-file -e {hash}`)

### 2. Hooks — existencia y permisos
Verificar que cada hook existe y tiene `chmod +x`:
```
.claude/hooks/bash-firewall.sh
.claude/hooks/secret-guard.sh
.claude/hooks/session-start-startup.sh
.claude/hooks/session-start-compact.sh
.claude/hooks/subagent-context.sh
.claude/hooks/subagent-stop-logger.sh
.claude/hooks/stop-logger.sh
.claude/hooks/pre-compact-snapshot.sh
.claude/hooks/config-change-logger.sh
```

### 3. Settings.json — wiring
Leer `.claude/settings.json` y verificar que todos los hooks del paso 2 están referenciados en `hooks.*`.

### 4. Context packs — existencia
Verificar que existen:
```
.claude/context/CORE.md
.claude/context/CURRENT_STATE.md
.claude/context/DECISIONS.md
.claude/context/SECURITY_RULES.md
.claude/context/BUSINESS.md
.claude/context/NO_GO.md
```

### 5. Context skills — existencia
Verificar `.claude/skills/context-{core,current-state,decisions,security,business,no-go}/SKILL.md`.

### 6. Agentes — frontmatter
Leer cada agente y verificar que tiene `skills:` field (no contexto embebido en el body).

### 7. CLAUDE_SESSION_LOG.md
Verificar que existe `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`.

### 8. jq disponible
`which jq` — los hooks P0/P1 lo requieren.

## Formato de salida

```
=== /doctor — {fecha} ===

✔/✗ PROJECT_STATE.md      — {detalle}
✔/✗ Hook bash-firewall    — {+x / missing}
✔/✗ Hook secret-guard     — {+x / missing}
... (todos los hooks)
✔/✗ settings.json wiring  — {N/9 hooks conectados}
✔/✗ Context packs (6/6)   — {lista faltantes}
✔/✗ Context skills (6/6)  — {lista faltantes}
✔/✗ Agents skills:field   — {lista sin skills:}
✔/✗ SESSION_LOG           — {exists/missing}
✔/✗ jq                    — {path / not found}

RESUMEN: {N} checks ✔ · {M} checks ✗
```

Si hay ✗ → indicar el código de recuperación (`/recovery E-X`) si aplica.
