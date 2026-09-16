---
name: gate
description: Verifica que todos los entregables de la fase actual están completos antes de avanzar a la siguiente.
user-invocable: true
---

# /gate — Phase Gate

Verifica el criterio de salida de la fase actual antes de declarar DONE y avanzar.

## Pasos

1. Lee `PROJECT_STATE.md` → obtén `CURRENT_PHASE` (N).
2. Lee `ARTIFACT_MANIFEST.md` → filtra la sección `FASE {N}`.
3. Cuenta ✔ (completos), ⏳ (en progreso), ✗ (faltantes).
4. Lee `DECISION_REGISTRY.md` → verifica que no haya decisiones en estado PENDIENTE para esta fase.
5. Verifica que no haya `BLOCKERS` activos en PROJECT_STATE.

## Resultado

**GATE PASADO** si: todos los entregables = ✔ AND BLOCKERS = NONE AND no decisiones pendientes de esta fase.

```
=== GATE FASE {N} ===
Entregables: {X}/X ✔
Bloqueantes: {NONE | lista}
Decisiones pendientes: {NONE | lista}

RESULTADO: GATE PASADO ✔ — puedes ejecutar /cerrar-fase
       ó   GATE BLOQUEADO ✗ — pendientes: {lista}
```

Si GATE BLOQUEADO: listar exactamente qué falta y sugerir acciones para completarlo.
