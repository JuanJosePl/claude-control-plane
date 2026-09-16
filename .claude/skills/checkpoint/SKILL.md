---
name: checkpoint
description: Crea un checkpoint git manual con formato estándar y actualiza LAST_GIT_CHECKPOINT en PROJECT_STATE.
user-invocable: true
---

# /checkpoint — Checkpoint Git Manual

Crear un commit de seguridad en cualquier momento (no sólo al cerrar fase).

## Pasos

1. Ejecutar `git status` — revisar qué hay staged/unstaged.
2. Si hay cambios en archivos de secretos (`.env`, `*.pem`, `*.key`) → **DETENER y reportar**.
3. `git add` de los archivos relevantes al trabajo actual (NO `git add -A` a ciegas).
4. Crear commit con formato:
   ```
   [CONFIG] checkpoint: {descripción breve del estado actual}
   
   Fase: {CURRENT_PHASE} · {PHASE_STATUS}
   Archivos: {lista resumida}
   ```
5. Capturar el hash del commit (`git rev-parse --short HEAD`).
6. Actualizar `PROJECT_STATE.md` → campo `LAST_GIT_CHECKPOINT` con el hash.
7. Confirmar: "Checkpoint creado: {hash} — PROJECT_STATE actualizado."

**NO hacer git push** — requiere confirmación explícita del usuario (`Bash(git push*)` está en ask).
