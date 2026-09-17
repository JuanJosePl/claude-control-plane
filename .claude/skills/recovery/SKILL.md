---
name: recovery
description: Protocolo de recuperación para los 9 escenarios de fallo del Control Plane (E-1 a E-9).
user-invocable: true
---

# /recovery — Protocolos de Recuperación

Referencia completa en `docs/00_SYSTEM/10_RECOVERY_PROTOCOLS.md`.

## Uso

```
/recovery E-{N}
```

## Escenarios

| Código | Escenario | Severidad |
|--------|-----------|-----------|
| E-1 | PROJECT_STATE.md corrupto o ausente | CRÍTICO |
| E-2 | Hook P0 bloqueando incorrectamente (falso positivo) | ALTO |
| E-3 | Context packs desincronizados | MEDIO |
| E-4 | Subagente sin contexto (SubagentStart hook falla) | MEDIO |
| E-5 | Session log corrompido o demasiado grande | BAJO |
| E-6 | settings.json inválido (Claude no arranca) | CRÍTICO |
| E-7 | git checkpoint perdido / hash inválido | ALTO |
| E-8 | Secret guard falso positivo bloqueando escritura | ALTO |
| E-9 | Compactación sin snapshot previo | MEDIO |

## Protocolos rápidos

**E-1 (PROJECT_STATE ausente):**
```bash
cp .claude/backups/PROJECT_STATE.precompact.md PROJECT_STATE.md
# Si no hay backup: reconstruir desde git log + ARTIFACT_MANIFEST
```

**E-2 (bash-firewall falso positivo):**
```bash
DRY_RUN=true .claude/hooks/bash-firewall.sh  # ver qué patrón matchea
# Ajustar patrón específico en bash-firewall.sh; NO desactivar el hook completo
```

**E-3 (context packs desincronizados):**
- Ejecutar `/audit-context` para identificar divergencias.
- Actualizar el mirror (CURRENT_STATE.md) para que siga PROJECT_STATE.md.

**E-4 (subagente sin contexto):**
- Verificar que `subagent-context.sh` tiene `+x` y que settings.json lo referencia en SubagentStart.
- Verificar que el payload del hook identifica el rol y que el contexto inyectado contiene los packs esperados.

**E-5 (session log):**
```bash
cp docs/00_SYSTEM/CLAUDE_SESSION_LOG.md docs/00_SYSTEM/archive/CLAUDE_SESSION_LOG.$(date +%Y-%m).md
echo "# CLAUDE_SESSION_LOG" > docs/00_SYSTEM/CLAUDE_SESSION_LOG.md
```

**E-6 (settings.json inválido):**
```bash
# Validar JSON:
jq . .claude/settings.json
# Si inválido, restaurar backup:
cp .claude/backups/20260915-165133/settings.json .claude/settings.json
```

**E-7 (git checkpoint perdido):**
```bash
git log --oneline -10  # identificar el commit más reciente relevante
# Actualizar PROJECT_STATE.md → LAST_GIT_CHECKPOINT con el hash correcto
```

**E-8 (secret-guard falso positivo):**
```bash
# El hook lee .tool_input.content — verificar si el archivo realmente contiene secretos
# Si es falso positivo: ajustar el patrón en secret-guard.sh (ampliar lista de placeholders)
```

**E-9 (compactación sin snapshot):**
```bash
# El backup no existe en .claude/backups/PROJECT_STATE.precompact.md
# Reconstruir PROJECT_STATE desde git: git show HEAD:PROJECT_STATE.md
# O desde context/CURRENT_STATE.md si está actualizado
```

Para detalles completos de cada protocolo: `docs/00_SYSTEM/10_RECOVERY_PROTOCOLS.md`.
