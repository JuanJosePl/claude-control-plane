# EVIDENCE_REGISTRY

> Fuente unica canonica: `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
> Una tarea no puede cerrarse sin una entrada VERIFIED asociada a su `task_id`.

## Schema

```text
## EV-001 — {claim en una linea}
- **Task ID:** {task_id de Claude Code}
- **Date:** YYYY-MM-DD
- **Claim:** {texto completo}
- **Source:** {test, comando, documento o artifact}
- **Provenance:** EXTRACTED | INFERRED | ASSUMED | EXTERNAL | GENERATED
- **Confidence:** HIGH | MEDIUM | LOW | HIPOTESIS
- **Status:** VERIFIED | BLOCKED | PROPOSED | REJECTED
- **Affects:** {archivo, decision o control}
- **Artifact Hash:** sha256:{64 hex chars}
- **Contract Hash:** sha256:{64 hex chars}
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS | NOT_REQUIRED
- **Exceptions:** NONE | APPROVED: {aprobador y motivo}
- **Timestamp:** ISO-8601
- **Notes:** {observaciones}
```

## Evidence

_No hay evidencia registrada._
