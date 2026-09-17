<!-- INSTRUCCIONES
DECISIONS.md — Mirror compacto de decisiones activas
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUIÉN LO LEE : researcher, architect, security-auditor
CUÁNDO       : al arrancar esos subagentes
FUENTE ÚNICA : DECISION_REGISTRY.md (este archivo es un mirror compacto)
ACTUALIZADO  : manualmente cuando hay decisiones nuevas relevantes

QUÉ PONER AQUÍ:
  ✔ Sólo decisiones ACTIVAS que un agente necesita conocer para trabajar
  ✔ Formato compacto: ID · resumen · implicación
  ✔ NO las descartadas/rechazadas (van sólo en DECISION_REGISTRY.md)

CUÁNDO AGREGAR UNA DECISIÓN AQUÍ:
  "¿Cambiaría el trabajo de un agente si no supiera esta decisión?" → Si sí: va aquí.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-->

# CONTEXT PACK — DECISIONS (activas)

> Registro compacto. Detalle completo en `DECISION_REGISTRY.md`.

## Producto
- **ARCH-001:** Instalacion a nivel de proyecto — no tocar configuracion global.
- **ARCH-003:** Evidence canonica en `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.

## Arquitectura / Control Plane
- **ARCH-002:** `SubagentStart` inyecta context packs por rol — no depender de `skills:` no verificado.
