---
name: cerrar-fase
description: Protocolo de cierre de fase (10 pasos): gate, actualizar estado, checkpoint git, commit estructurado.
user-invocable: true
---

# /cerrar-fase — Protocolo de Cierre de Fase

**Invocar sólo después de que /gate pase.** Nunca cerrar sin gate aprobado.

## Protocolo (10 pasos)

1. **Ejecutar /gate** — confirmar GATE PASADO. Si no pasa → DETENER.
2. **Actualizar ARTIFACT_MANIFEST.md** — marcar todos los entregables de la fase como ✔.
3. **Actualizar PROJECT_STATE.md**:
   - `CURRENT_PHASE` → N (mismo, sólo si completando)
   - `PHASE_STATUS` → COMPLETE
   - `NEXT_ALLOWED_PHASE` → N+1
   - `LAST_GIT_CHECKPOINT` → (se actualizará en paso 7)
4. **Actualizar .claude/context/CURRENT_STATE.md** — reflejar el nuevo estado.
5. **Actualizar ARTIFACT_MANIFEST.md** — añadir sección FASE N+1 si no existe con ⏳ iniciales.
6. **Registrar en DECISION_REGISTRY.md** — cualquier decisión tomada durante la fase que no esté registrada.
7. **git add** de todos los archivos modificados en la fase (verificar con `git status` primero).
8. **git commit** con formato `[FASE-N] docs: cierre FASE N — {resumen de 1 línea}`  
   Incluir en el body: entregables completados, decisiones tomadas, next phase.
9. **Actualizar PROJECT_STATE.md** → `LAST_GIT_CHECKPOINT` = hash del commit recién creado.
10. **Confirmar** → mostrar resumen: hash, fase cerrada, fase siguiente desbloqueada.

## Formato de commit (paso 8)

```
[FASE-N] docs: cierre FASE N — {descripción breve}

Entregables: {lista de archivos/docs clave}
Decisiones: {P0X, ARCH-XXX si aplica}
Siguiente: FASE N+1 desbloqueada
```

**NO hacer git push** — eso requiere confirmación explícita del usuario.
