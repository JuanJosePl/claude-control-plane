---
name: audit-config
description: Verifica que settings.json tiene la estructura correcta, permisos bien definidos y todos los hooks conectados.
user-invocable: true
---

# /audit-config — Auditoría de Configuración

Audita `.claude/settings.json` contra el esquema esperado del Control Plane.

## Checks

### 1. Permisos — allow
Verificar presencia de patrones críticos:
- `Bash(git *)`, `Read(*)`, `Glob(*)`, `Grep(*)`, `Bash(jq *)`

### 2. Permisos — ask
Verificar que `Bash(git push*)` y `Bash(rm *)` están en `ask` (no en `allow`).

### 3. Permisos — deny
Verificar protección de secretos: 8 patrones de `.env`, `secrets`, claves privadas, SSH y AWS.

### 4. Hooks — eventos presentes
Verificar que existen entradas para: SessionStart, PreToolUse, SubagentStart, SubagentStop, Stop, PreCompact, ConfigChange y TaskCompleted.

### 5. Hooks — matchers correctos
- SessionStart: matchers `startup|resume|fork` y `compact|clear` (separados).
- PreToolUse: matchers `Bash` (→ bash-firewall) y `Write|Edit` (→ secret-guard).
- TaskCompleted: sin matcher y conectado al evidence gate.
- P0 hooks (bash-firewall, secret-guard): timeout ≤ 5s.

### 6. skillOverrides
Debe existir (aunque vacío `{}`).

## Formato de salida

```
=== /audit-config — {fecha} ===

permissions.allow:  {N críticos presentes}  ✔/⚠
permissions.ask:    git push + rm  ✔/✗
permissions.deny:   {N/8 secretos protegidos}  ✔/✗
hooks.SessionStart: {matchers}  ✔/✗
hooks.PreToolUse:   Bash+Write|Edit  ✔/✗
hooks.P0 timeout:   {bash-firewall Xs · secret-guard Xs}  ✔/⚠
skillOverrides:     present  ✔/✗

RESULTADO: {OK | ISSUES: lista}
```

Si hay issues → señalar el campo exacto a corregir en settings.json.
