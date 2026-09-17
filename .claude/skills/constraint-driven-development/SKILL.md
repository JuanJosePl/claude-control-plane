---
name: constraint-driven-development
description: Define y verifica CONSTRAINTS.md para impedir que una implementación gane en apariencia silenciando checks, degradando tests o cruzando límites del proyecto.
user-invocable: true
---

# /constraint-driven-development — Desarrollo bajo restricciones

## Activación

Usar antes de features, migraciones, cambios de infraestructura, seguridad o cualquier tarea con
restricciones no negociables. Para un cambio trivial, registrar por qué no aplica.

## Flujo

1. Leer `CLAUDE.md`, `.claude/rules/`, context packs relevantes y fuentes de verdad del proyecto.
2. Crear o actualizar `CONSTRAINTS.md` con restricciones verificables, propietario y fuente.
3. Separar restricciones en `MUST`, `MUST NOT`, `MAY` y `DEFERRED`; no esconder decisiones ambiguas.
4. Definir para cada restricción un check observable y el resultado esperado.
5. Implementar sin cambiar restricciones para hacer pasar el check.
6. Revisar el diff buscando bypasses: `skip`, `ignore`, assertions debilitadas, thresholds menores,
   guards eliminados, permisos ampliados o validaciones convertidas en warnings.
7. Ejecutar los checks y registrar cualquier excepción con motivo, alcance, expiración y aprobador.
8. Vincular `CONSTRAINTS.md` y sus resultados a la evidencia VERIFIED del `task_id`.

## Tabla mínima de CONSTRAINTS.md

| ID | Tipo | Restricción | Check | Fuente | Estado |
|---|---|---|---|---|---|
| C-001 | MUST | ... | comando o inspección | archivo:línea | PASS |

## Anti-gaming

- No eliminar un test para obtener verde.
- No añadir `skip`, `todo`, `ignore`, `ts-ignore` o equivalente sin excepción explícita.
- No reducir coverage, mutation o lint thresholds como parte incidental del cambio.
- No convertir un bloqueo en logging para evitar el gate.
- No ampliar permisos o trust boundaries sin decisión registrada.

## Trust boundary

El agente puede proponer restricciones y checks. Las restricciones de seguridad, permisos, hooks P0
y trust boundaries requieren aprobación humana antes de modificarse.

## Convergencia

Cada MUST tiene un check PASS, no hay bypasses nuevos, las excepciones están aprobadas y la evidencia
de la tarea referencia el snapshot de restricciones.
