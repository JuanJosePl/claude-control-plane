#!/bin/bash
# session-start-compact (P1 · FAIL_OPEN) — recuperación post-compactación: contexto MÁS denso.
# Matcher esperado: compact|clear.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$PROJ/PROJECT_STATE.md"
DEC="$PROJ/.claude/context/DECISIONS.md"
LOG="$PROJ/docs/00_SYSTEM/CLAUDE_SESSION_LOG.md"

STATE_TXT=$( [ -f "$STATE" ] && grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS|LAST_GIT_CHECKPOINT|NEXT_ALLOWED_PHASE|ACTIVE_DECISIONS|IMPLEMENTATION_READY):' "$STATE" || echo "PROJECT_STATE.md ausente")
DEC_TXT=$( [ -f "$DEC" ] && sed -n '1,40p' "$DEC" || echo "(sin DECISIONS pack)")
LOG_TXT=$( [ -f "$LOG" ] && grep -E '^## ' "$LOG" | tail -3 || echo "(sin log)")

CTX="=== RECUPERACIÓN POST-COMPACTACIÓN ===
El historial fue comprimido. Estado operativo (PROJECT_STATE.md manda):
${STATE_TXT}

Decisiones activas (resumen):
${DEC_TXT}

Últimas entradas de sesión:
${LOG_TXT}

Usa /estado para confirmar y continúa desde LAST_GIT_CHECKPOINT. No preguntes 'dónde estábamos': está arriba."

if command -v jq >/dev/null 2>&1; then
  jq -n --arg ctx "$CTX" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
else
  printf '%s\n' "$CTX"
fi
exit 0
