# INCIDENT_REGISTRY

> Cada incidente relevante debe producir una regresión y un control verificable.

## Schema

```text
## INC-001 — {síntoma en una línea}
- **Date:** YYYY-MM-DD
- **Severity:** P0 | P1 | P2 | P3
- **Status:** OPEN | ANALYZING | CONTROL_PROPOSED | CONTROL_IMPLEMENTED | VERIFIED | CLOSED | REJECTED
- **Owner:** {persona o agente}
- **Symptom:** {qué ocurrió}
- **Context:** {sesión, commit, entorno o tarea}
- **Reproducer:** {test, comando o artifact reproducible}
- **Root cause:** {causa raíz}
- **Missing control:** missing_test | missing_hook | missing_rule | missing_skill | missing_eval
- **Control:** {control_id, archivo y descripción}
- **Regression:** {test/eval que falla sin el control}
- **Evidence:** {EV-NNN o referencia verificable}
- **Notes:** {decisiones, excepciones y aprobación humana}
```

## Incidents

## INC-001 — Completion evidence was not enforced by the pre-F2 gate
- **Date:** 2026-09-17
- **Severity:** P1
- **Status:** CLOSED
- **Owner:** control-plane
- **Symptom:** A completion payload could be accepted without a task-specific verified evidence contract even when the registry existed.
- **Context:** F2 evidence-gate hardening and F4 incident-learning audit.
- **Reproducer:** `evals/incidents/INC-001-task-completed-evidence.sh` — same payload is unprotected without the control and blocked with it.
- **Root cause:** missing_test; the original gate had no regression fixture for missing evidence.
- **Missing control:** missing_test
- **Control:** CTRL-001 — existing TaskCompleted evidence gate at L5.
- **Regression:** REG-001 — `evals/incidents/INC-001-task-completed-evidence.sh`.
- **Evidence:** EV-002, EV-006
- **Notes:** Control reuse preferred over a new hook. Rollback: `git show e679b46:.claude/settings.json | sed '/^[[:space:]]*\\/\\//d' > .claude/settings.json && rm .claude/hooks/task-completed-evidence.sh && jq empty .claude/settings.json`; the prior commit does not contain the added hook. P0 hook changes require human approval.
