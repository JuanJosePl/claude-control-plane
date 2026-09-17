---
name: test-driven-development
description: Implementa cambios verificables mediante contrato, test RED, implementación mínima GREEN y regresión; úsala para features, bugs y cambios de comportamiento.
user-invocable: true
---

# /test-driven-development — TDD verificable

## Activación

Usar para features, bugs, cambios de comportamiento y cualquier modificación con criterio de
aceptación. No usar para cambios puramente documentales, renombres sin comportamiento o ajustes de
formato.

## Flujo obligatorio

1. Extraer el contrato: comportamiento esperado, entradas, salidas, errores e invariantes.
2. Diseñar el caso mínimo que falsaría la implementación incorrecta.
3. Escribir el test antes de producción y ejecutarlo en estado RED.
4. Registrar la causa de fallo esperada; un test que nunca falló no demuestra el contrato.
5. Implementar la solución mínima sin debilitar el test.
6. Ejecutar el mismo test en GREEN y después la suite relevante.
7. Revisar que no haya skips, assertions eliminadas, mocks que eviten el comportamiento real o
   umbrales reducidos para obtener verde.
8. Registrar evidencia vinculada al `task_id` con `/evidence` y `Status: VERIFIED`.

## Artefactos

- Test RED con su salida de fallo esperada.
- Implementación mínima.
- Resultado GREEN y suite relevante.
- Entrada en `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.

## Gate

No declarar la tarea completa si falta el test RED documentado, el test GREEN o la evidencia
verificada. El hook `TaskCompleted` es el bloqueo final; esta skill no lo sustituye.

## Anti-racionalizaciones

| Excusa | Respuesta |
|---|---|
| "El cambio es demasiado pequeño para test" | Si cambia comportamiento, el caso mínimo sigue siendo necesario. |
| "El test pasará desde el principio" | Ajusta el caso para demostrar que detecta la ausencia del comportamiento. |
| "Añadiré el test después" | Sin RED no existe evidencia de que el test cubra el contrato. |
| "Bajar el umbral es solo temporal" | Restaurar el umbral forma parte del mismo cambio o el gate falla. |

## Trust boundary

El agente puede crear y ejecutar tests. No puede declarar evidencia VERIFIED sin adjuntar resultados
observables ni marcar excepciones como resueltas sin aprobación explícita.

## Convergencia

Contrato cubierto por un test que falló por la razón esperada, implementación GREEN, suite relevante
verde y evidencia registrada para el `task_id`.
