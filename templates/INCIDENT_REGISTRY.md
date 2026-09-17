<!-- INSTRUCCIONES
INCIDENT REGISTRY — Registro de fallos que deben convertirse en controles.
UBICAR EN: raíz del proyecto.
CONSUMIDO POR: /incident y /recovery.
BORRAR ESTE BLOQUE AL INSTALAR.
-->

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

_No hay incidentes registrados._
