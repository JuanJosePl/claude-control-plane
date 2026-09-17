# REGRESSION_REGISTRY

> Regresiones reproducibles que demuestran que un control sigue funcionando.

## Schema

```text
## REG-001 — {regresion en una linea}
- **Incident:** INC-001
- **Test/Eval:** {ruta y comando}
- **Baseline Outcome:** ACCEPTED | BLOCKED
- **Control Outcome:** BLOCKED | ACCEPTED
- **Last Verified:** YYYY-MM-DD
- **Evidence:** EV-NNN
- **Status:** ACTIVE | RETIRED
```

## Regressions

## REG-001 — TaskCompleted blocks completion without evidence
- **Incident:** INC-001
- **Test/Eval:** `evals/incidents/INC-001-task-completed-evidence.sh`
- **Baseline Outcome:** ACCEPTED
- **Control Outcome:** BLOCKED
- **Last Verified:** 2026-09-17
- **Evidence:** EV-006
- **Status:** ACTIVE
