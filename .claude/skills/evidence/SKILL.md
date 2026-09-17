---
name: evidence
description: Registra una nueva entrada de evidencia en EVIDENCE_REGISTRY.md con formato EV-XXX estructurado.
user-invocable: true
---

# /evidence — Registrar Evidencia

Añade una entrada trazable a la unica fuente canonica `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.

## Uso

```
/evidence
Task ID: <task_id de Claude Code>
Claim: <lo que se afirma>
Source: <URL, doc, experimento>
Provenance: EXTRACTED | INFERRED | ASSUMED | EXTERNAL | GENERATED
Confidence: HIGH | MEDIUM | LOW | HIPÓTESIS
Affects: <decisiones o componentes afectados>
Artifact Hash: sha256:<64 hex chars>
Contract Hash: sha256:<64 hex chars>
Checks: tests=PASS; static=PASS; security=NOT_REQUIRED
Reviewer: PASS | NOT_REQUIRED
Exceptions: NONE | APPROVED: <aprobador y motivo>
Timestamp: <ISO-8601>
```

## Pasos

1. Leer `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` → obtener último número (EV-XXX).
2. Calcular siguiente: EV-{N+1:03d}.
3. Añadir entrada al final del archivo:

```markdown
## EV-{NNN} — {claim en una línea}
- **Task ID:** {task_id de Claude Code}
- **Date:** {YYYY-MM-DD}
- **Claim:** {texto completo}
- **Source:** {fuente}
- **Provenance:** {EXTRACTED|INFERRED|ASSUMED|EXTERNAL|GENERATED}
- **Confidence:** {HIGH|MEDIUM|LOW|HIPÓTESIS}
- **Status:** VERIFIED | BLOCKED | PROPOSED | REJECTED
- **Affects:** {ARCH-XXX, HOOK-XXX, etc.}
- **Artifact Hash:** sha256:{64 hex chars}
- **Contract Hash:** sha256:{64 hex chars}
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS | NOT_REQUIRED
- **Exceptions:** NONE | APPROVED: {aprobador y motivo}
- **Timestamp:** {ISO-8601}
- **Notes:** {observaciones adicionales si las hay}
```

4. Confirmar: "EV-{NNN} registrado en docs/00_SYSTEM/EVIDENCE_REGISTRY.md".

Si el archivo no existe, bloquear y ejecutar primero la instalacion o restaurar el template canonico.
