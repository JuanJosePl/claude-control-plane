---
name: incident
description: Abre, analiza y cierra incidentes convirtiendo cada fallo relevante en una regresión y un control verificable; úsala ante bugs repetidos, fallos de gates o brechas del control plane.
user-invocable: true
---

# /incident — Incident → Control

## Uso

```text
/incident open
/incident close INC-001
```

## Cuándo abrir

Abrir un incidente cuando un fallo llega a producción, rompe un gate, revela una regresión, expone
un bypass de seguridad o demuestra que una regla del control plane no protegía el riesgo esperado.
No abrirlo para un error tipográfico ya cubierto por una regresión existente.

## Flujo obligatorio

1. **Freeze:** conservar síntoma, contexto, timestamp, comando y artifact/log relevante; no editar la
   evidencia original.
2. **Reproduce:** crear un reproducer mínimo y registrar cómo falla antes del fix.
3. **RCA:** aplicar 5 Whys hasta identificar la causa y el control ausente o ineficaz.
4. **Classify:** `missing_test`, `missing_hook`, `missing_rule`, `missing_skill` o `missing_eval`.
5. **Propose:** describir el control y su enforcement level; no modificar silenciosamente controles P0,
   permisos, reglas de seguridad o trust boundaries.
6. **Regress:** añadir un test/eval que falla sin el control y pasa con él.
7. **Verify:** ejecutar la regresión, checks afectados y revisión independiente.
8. **Link:** registrar el control en `CONTROL_REGISTRY.md` y la regresión en `REGRESSION_REGISTRY.md`.
9. **Close:** completar el registro solo cuando exista control, regresión y evidencia VERIFIED.

## Campos obligatorios

Ver `INCIDENT_REGISTRY.md`, `CONTROL_REGISTRY.md` y `REGRESSION_REGISTRY.md`. Todo incidente abierto
debe tener severity, symptom, reproducer, root_cause, missing_control, owner y status. Un incidente
P0/P1 no puede cerrarse sin regresión y control vinculado.

## Estados

`OPEN` → `ANALYZING` → `CONTROL_PROPOSED` → `CONTROL_IMPLEMENTED` → `VERIFIED` → `CLOSED`.

Si la propuesta se rechaza, usar `REJECTED` con la razón y conservar el reproducer.

## Trust boundary

El agente puede abrir incidentes y proponer controles. Requiere aprobación humana todo cambio a hooks
P0, permisos, reglas de seguridad, trust boundaries o controles irreversibles.

## Convergencia

La regresión falla sin el control, pasa con el control, la evidencia queda registrada y el incidente
puede cerrarse sin depender de una afirmación conversacional.
