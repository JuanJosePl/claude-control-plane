<!-- INSTRUCCIONES
CURRENT_STATE.md — Mirror compacto del estado operativo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUIÉN LO LEE : architect, implementer
CUÁNDO       : al arrancar esos subagentes
FUENTE ÚNICA : PROJECT_STATE.md (este archivo es un mirror — PROJECT_STATE manda)
ACTUALIZADO  : por /cerrar-fase automáticamente

QUÉ PONER AQUÍ:
  ✔ Fase actual y su estado
  ✔ Qué está completo y qué está pendiente
  ✔ Control plane status (está implementado o no)
  ✔ Próximos pasos inmediatos

NO EDITAR MANUALMENTE — actualizar via /cerrar-fase o /checkpoint
Si difiere de PROJECT_STATE.md → PROJECT_STATE manda, este se actualiza.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-->

# CONTEXT PACK — CURRENT STATE

**Actualizado:** {{YYYY-MM-DD}}

## Estado de fases
```
FASE 0: {{descripción}} → {{COMPLETA / EN PROGRESO / PENDIENTE}}
FASE 1: {{descripción}} → {{estado}}
...
```

## Fase actual: {{N}} — {{nombre}}
**Objetivo:** {{qué produce esta fase}}
**Bloqueantes:** {{NONE | lista}}

## Control Plane
**Versión:** 1.0 — {{IMPLEMENTADO / EN PROGRESO}}

## Próximos pasos
1. {{acción inmediata}}
2. {{siguiente}}
