# RULE — GIT POLICY (global)

- Commits con prefijo de fase o tipo: `[FASE-N] [TIPO]: descripción` (feat, fix, docs, arch, decision, security, infra, config).
  Control plane usa `[CONFIG]`.
- Checkpoint OBLIGATORIO al cerrar fase (`/cerrar-fase`); recomendado antes de cambios grandes.
- `/checkpoint` registra el hash en `PROJECT_STATE.LAST_GIT_CHECKPOINT`.
- Antes de commitear: verificar que no hay secretos ni `.env/*.pem/*.key` staged.
- `git push` requiere confirmación (permissions.ask). Código de producto: rama por feature, nunca a main sin verificación.
- Nunca commitear secretos. Restaurar config con `git checkout HEAD .claude/`.
