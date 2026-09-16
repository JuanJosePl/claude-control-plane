#!/bin/bash
# subagent-stop-logger (P2 · FAIL_OPEN) — registra actividad del subagente en CLAUDE_SESSION_LOG.md.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LOG="$PROJ/docs/00_SYSTEM/CLAUDE_SESSION_LOG.md"
INPUT="$(cat)"
command -v jq >/dev/null 2>&1 || exit 0

AGENT=$(printf '%s' "$INPUT" | jq -r '.agent_type // "subagent"' 2>/dev/null)
AID=$(printf '%s' "$INPUT" | jq -r '.agent_id // "?"' 2>/dev/null)
MSG=$(printf '%s' "$INPUT" | jq -r '.last_assistant_message // ""' 2>/dev/null | head -c 300 | tr '\n' ' ')
TS=$(date '+%Y-%m-%d %H:%M')

# Idempotencia: no duplicar por agent_id
[ -f "$LOG" ] && grep -q "agent_id:${AID}" "$LOG" 2>/dev/null && exit 0

mkdir -p "$(dirname "$LOG")"
{
  echo ""
  echo "## ${TS}"
  echo "SESIÓN:               subagent"
  echo "AGENTE:               ${AGENT}   (agent_id:${AID})"
  echo "RESUMEN:              ${MSG}"
  echo "RESULTADO:            (ver resumen)"
} >> "$LOG"

# Rotación a 30 entradas
COUNT=$(grep -c '^## ' "$LOG" 2>/dev/null || echo 0)
if [ "${COUNT:-0}" -gt 30 ]; then
  ARCH="$PROJ/docs/00_SYSTEM/archive/CLAUDE_SESSION_LOG.$(date +%Y-%m).md"
  mkdir -p "$(dirname "$ARCH")"; cp "$LOG" "$ARCH" 2>/dev/null || true
fi
exit 0
