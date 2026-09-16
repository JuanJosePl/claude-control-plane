---
name: evidence
description: Registra una nueva entrada de evidencia en EVIDENCE_REGISTRY.md con formato EV-XXX estructurado.
user-invocable: true
---

# /evidence — Registrar Evidencia

Añade una entrada trazable a `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.

## Uso

```
/evidence
Claim: <lo que se afirma>
Source: <URL, doc, experimento>
Confidence: HIGH | MEDIUM | LOW | HIPÓTESIS
Affects: <decisiones o componentes afectados>
```

## Pasos

1. Leer `EVIDENCE_REGISTRY.md` → obtener último número (EV-XXX).
2. Calcular siguiente: EV-{N+1:03d}.
3. Añadir entrada al final del archivo:

```markdown
## EV-{NNN} — {claim en una línea}
- **Date:** {YYYY-MM-DD}
- **Claim:** {texto completo}
- **Source:** {fuente}
- **Confidence:** {HIGH|MEDIUM|LOW|HIPÓTESIS}
- **Affects:** {ARCH-XXX, HOOK-XXX, etc.}
- **Notes:** {observaciones adicionales si las hay}
```

4. Confirmar: "EV-{NNN} registrado en EVIDENCE_REGISTRY.md".

Si el archivo no existe → crearlo con header básico primero.
