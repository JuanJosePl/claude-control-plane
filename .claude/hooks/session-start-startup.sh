#!/bin/bash
# session-start-startup (P1 · FAIL_OPEN) — inyecta estado operativo al arrancar/reanudar.
# Matcher esperado: startup|resume|fork. NO usa MCP (no disponible en startup).
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$PROJ/PROJECT_STATE.md"
CUR="$PROJ/.claude/context/CURRENT_STATE.md"
BRANCH=$(git -C "$PROJ" branch --show-current 2>/dev/null || echo "sin-rama")

if [ -f "$STATE" ]; then
  CORE=$(grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS|LAST_GIT_CHECKPOINT|NEXT_ALLOWED_PHASE|ACTIVE_DECISIONS):' "$STATE" 2>/dev/null)
  CTX="=== ESTADO OPERATIVO (PROJECT_STATE.md · fuente única) ===
Rama git: ${BRANCH}
${CORE}

Comandos de control: /estado · /gate · /cerrar-fase · /checkpoint · /doctor · /recovery
Contexto de fase en .claude/context/CURRENT_STATE.md. NO trabajar el producto si la tarea es de plataforma, y viceversa."
else
  CTX="=== SIN PROJECT_STATE.md ===
Rama git: ${BRANCH}. PROJECT_STATE.md no encontrado → ejecuta /doctor y revisa docs/00_SYSTEM/.
Últimos commits:
$(git -C "$PROJ" log --oneline -3 2>/dev/null || echo '(sin commits)')"
fi

if command -v jq >/dev/null 2>&1; then
  jq -n --arg ctx "$CTX" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
else
  printf '%s\n' "$CTX"   # fallback: stdout plano también se añade como contexto
fi
exit 0
