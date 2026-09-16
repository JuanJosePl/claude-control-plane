#!/bin/bash
# stop-logger (P2 · FAIL_OPEN) — entrada de sesión principal + recordatorio de actualizar PROJECT_STATE.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LOG="$PROJ/docs/00_SYSTEM/CLAUDE_SESSION_LOG.md"
STATE="$PROJ/PROJECT_STATE.md"
command -v jq >/dev/null 2>&1 || exit 0
INPUT="$(cat)"
MSG=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""' 2>/dev/null | head -c 200 | tr '\n' ' ')

# Recordatorio suave si PROJECT_STATE no se tocó hoy
REMIND=""
if [ -f "$STATE" ]; then
  TODAY=$(date +%Y-%m-%d)
  MOD=$(date -r "$STATE" +%Y-%m-%d 2>/dev/null || echo "")
  [ "$MOD" != "$TODAY" ] && REMIND="Recordatorio: PROJECT_STATE.md no se actualizó hoy; usa /checkpoint o /cerrar-fase si avanzaste."
fi

if [ -n "$REMIND" ] && command -v jq >/dev/null 2>&1; then
  jq -n --arg c "$REMIND" '{hookSpecificOutput:{hookEventName:"Stop",additionalContext:$c}}'
fi
exit 0
