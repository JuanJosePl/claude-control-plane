<!-- INSTRUCCIONES
DECISION REGISTRY — Fuente única de decisiones estructuradas
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UBICAR EN: raíz del proyecto (no en .claude/)
ACTUALIZADO: manualmente o vía /adr
RESUMEN ACTIVO: .claude/context/DECISIONS.md

CÓMO USAR:
  - Cada decisión tiene un ID único (P01, ARCH-001, SEC-001, etc.)
  - Estados: PROPUESTA | APROBADA | RECHAZADA | SUPERADA
  - Incluir evidencia (EV-XXX) cuando exista
  - Registrar reversibilidad y consecuencias
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BORRAR ESTE BLOQUE AL INSTALAR
-->

# DECISION REGISTRY

> Fuente única de decisiones estructuradas. Las ACTIVAS se resumen en `.claude/context/DECISIONS.md`.
> Crear/editar vía `/adr`.

---

## P01 — {{título de la decisión de producto}}
- TIPO: DIRECCIÓN · ESTADO: APROBADA · FECHA: {{YYYY-MM-DD}} · APROBADA_POR: {{nombre}}
- PREGUNTA: {{pregunta que resuelve}}
- DECISIÓN: {{respuesta}}
- ALTERNATIVAS_RECHAZADAS: {{opciones descartadas}}
- EVIDENCIA: {{EV-XXX o doc}} · RIESGOS: {{riesgo principal}}
- REVERSIBILIDAD: FÁCIL|DIFÍCIL|IRREVERSIBLE · CONSECUENCIAS: {{consecuencias}}

## ARCH-001 — {{título de decisión de arquitectura}}
- TIPO: INFRA · ESTADO: APROBADA · FECHA: {{YYYY-MM-DD}}
- DECISIÓN: {{decisión}}
- REVERSIBILIDAD: FÁCIL.
