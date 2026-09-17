---
name: doubt-driven-development
description: Somete decisiones y claims no triviales a una revisión adversarial con contexto fresco usando solo contrato y artefacto, sin contaminarla con el razonamiento del implementer.
user-invocable: true
---

# /doubt-driven-development — Revisión por duda

## Activación

Usar para claims de completitud, decisiones irreversibles, cambios de alto riesgo, áreas no
familiares o cuando verificar cueste menos que corregir una regresión.

## Flujo CLAIM → EXTRACT → DOUBT → RECONCILE → STOP

1. `CLAIM`: expresar exactamente qué se afirma terminado o correcto.
2. `EXTRACT`: separar contrato, invariantes, casos límite, artifact y evidencia observable.
3. `DOUBT`: entregar a un reviewer con contexto fresco únicamente el contrato y el artifact.
   Para riesgo `MEDIUM` o superior, usar el agente `code-reviewer` y un nuevo contexto de sesión.
4. Exigir dudas falsables con quotes de archivo/línea; no aceptar impresiones sin evidencia.
5. `RECONCILE`: corregir, responder con evidencia o escalar al humano si se rechaza una duda crítica.
6. Repetir hasta `STOP`: cero dudas críticas sin resolver y ninguna contradicción del contrato.

## Registro mínimo

```text
CLAIM: ...
CONTRACT: ...
ARTIFACT: ...
DOUBTS:
- [CRITICAL|HIGH|MEDIUM|LOW] path:line — duda falsable
RECONCILIATION: fix | rebuttal con evidencia | escalado
STOP: PASS | BLOCKED
```

## No permitido

- Mostrar al reviewer el razonamiento o la conclusión del implementer antes de revisar.
- Usar "no encontré problemas" sin indicar qué contrato se comprobó.
- Cerrar una duda crítica por autoridad o urgencia.
- Convertir la revisión en una refactorización no solicitada.

## Trust boundary

El reviewer no puede declarar PASS basándose en la conversación del implementer. El implementer
puede reconciliar findings, pero un rechazo de una duda crítica requiere evidencia o aprobación
humana.

## Convergencia

Contrato y artifact coinciden, no hay dudas críticas/high sin resolver y el resultado está incluido
en la evidencia VERIFIED de la tarea.
