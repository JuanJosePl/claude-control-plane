---
name: code-review-and-quality
description: Revisa un cambio contra su contrato con severidad explícita, tamaño de cambio, regresiones, seguridad y mantenibilidad antes de aceptar evidencia.
user-invocable: true
---

# /code-review-and-quality — Revisión independiente

## Activación

Usar después de implementar una feature, bugfix o cambio estructural. Para un cambio trivial de
documentación basta con validar enlaces y formato.

## Risk routing

- `LOW`: checks deterministas; reviewer opcional.
- `MEDIUM`: checks deterministas + reviewer independiente.
- `HIGH` o `CRITICAL`: checks deterministas + `code-reviewer` fresh-context + security review.
- Irreversible: además requiere gate humano.

## Entrada mínima

- Contrato o criterios de aceptación.
- Diff completo y archivos afectados.
- Resultados de tests y checks ejecutados.
- Riesgo, reversibilidad y superficies de seguridad afectadas.

## Flujo

1. Confirmar que el diff tiene el tamaño y el alcance esperados.
2. Revisar corrección: contrato, casos límite, errores y compatibilidad.
3. Revisar regresiones: consumidores, persistencia, migraciones, API y configuración.
4. Revisar seguridad: autorización, secretos, inputs, logs y superficies de confianza.
5. Revisar calidad: duplicación, complejidad, nombres, manejo de errores y tests relevantes.
6. Clasificar cada finding como `BLOCKER`, `HIGH`, `MEDIUM`, `LOW` o `NOTE`, siempre con archivo,
   línea y evidencia concreta.
7. Rechazar el cambio si existe un `BLOCKER` o `HIGH` sin resolver.
8. Registrar el resultado y vincularlo a la evidencia del `task_id`; el reviewer nunca modifica el
   artifact que está revisando.

## Formato de salida

```text
RESULTADO: PASS | BLOCKED
RIESGO: LOW | MEDIUM | HIGH | CRITICAL
FINDINGS:
- [SEVERITY] path:line — hallazgo y consecuencia
CHECKS: tests / static / security
RECOMMENDATION: aceptar, corregir o escalar
```

## Anti-patrones

- Revisar solo los archivos que el implementer menciona.
- Aceptar "los tests pasan" como revisión completa.
- Reportar una preferencia estilística como blocker.
- Hacer cambios silenciosos durante la revisión sin actualizar el diff.
- Firmar el propio cambio sin separar contrato, artifact y veredicto.

## Trust boundary

El reviewer recibe contrato, artifact y resultados; no debe usar el razonamiento privado del
implementer como evidencia. La firma de revisión no reemplaza los checks determinísticos.

## Convergencia

No quedan findings `BLOCKER` o `HIGH`, cada finding aceptado tiene justificación, y los resultados
están vinculados a una entrada VERIFIED del registro de evidencia.
