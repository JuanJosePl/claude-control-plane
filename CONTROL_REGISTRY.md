# CONTROL_REGISTRY

> Catalogo de controles creados como respuesta a incidentes.

## Schema

```text
## CTRL-001 — {control en una linea}
- **Type:** hook | rule | skill | test | eval
- **Enforcement:** L0 | L1 | L2 | L3 | L4 | L5 | L6 | L7 | L8
- **Source Incident:** INC-001
- **Path:** {archivo o comando}
- **Owner:** {persona o agente}
- **Verification:** REG-001 / EV-NNN
- **Status:** PROPOSED | ACTIVE | RETIRED
- **Notes:** {aprobacion y rollback}
```

## Controls

## CTRL-001 — TaskCompleted exige evidencia VERIFIED
- **Type:** hook
- **Enforcement:** L5
- **Source Incident:** INC-001
- **Path:** `.claude/hooks/task-completed-evidence.sh`
- **Owner:** control-plane
- **Verification:** REG-001 / EV-006
- **Status:** ACTIVE
- **Notes:** Rollback: `git show e679b46:.claude/settings.json | sed '/^[[:space:]]*\\/\\//d' > .claude/settings.json && rm .claude/hooks/task-completed-evidence.sh && jq empty .claude/settings.json`; the prior commit does not contain the added hook.
