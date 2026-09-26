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
- **ARCH-004:** Solo las CONTRACTUAL TASK pasan por Evidence Gate; TODOs, SUBTASKs y RESEARCH NOTE no requieren EV-NNN individual. Tras F8-A, `contract_hash` es obligatorio, debe coincidir con la evidencia VERIFIED y su ausencia bloquea.

## Governance
- **ARCH-005:** Deferrals Owner-authorized llevan bloque YAML in-document con vocab {EVENT, CONDITION, COUNT, DATE, LINK}, IDs `<scope>.<deferral-id>.T<index>`, `combine: ANY` sólo si prosa fuente documenta alternativa, y `provenance:`. NH-11/G-L1 (HYPOTHESIS-tier) fuera del requisito. Normalización ≠ cambio semántico ≠ reapertura. No registry, no runtime, no maintenance.sh. IMPL_PENDING (2026-09-26).
