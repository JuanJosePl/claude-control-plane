#!/bin/bash
# session-start-compact (P1 · FAIL_OPEN) — recuperación post-compactación: contexto MÁS denso.
# Matcher esperado: compact|clear.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$PROJ/PROJECT_STATE.md"
DEC="$PROJ/.claude/context/DECISIONS.md"
LOG="$PROJ/docs/00_SYSTEM/CLAUDE_SESSION_LOG.md"
HASH_FILE="$PROJ/.claude/backups/PROJECT_STATE.critical.sha256"

STATE_TXT=$( [ -f "$STATE" ] && grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS|LAST_GIT_CHECKPOINT|NEXT_ALLOWED_PHASE|ACTIVE_DECISIONS|IMPLEMENTATION_READY):' "$STATE" || echo "PROJECT_STATE.md ausente")
DEC_TXT=$( [ -f "$DEC" ] && sed -n '1,40p' "$DEC" || echo "(sin DECISIONS pack)")
LOG_TXT=$( [ -f "$LOG" ] && grep -E '^## ' "$LOG" | tail -3 || echo "(sin log)")

CRITICAL=$( [ -f "$STATE" ] && grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS|LAST_GIT_CHECKPOINT):' "$STATE" || echo "sin estado")
if command -v sha256sum >/dev/null 2>&1 && [ -f "$HASH_FILE" ]; then
  CURRENT_DIGEST="$(printf '%s\n' "$CRITICAL" | sha256sum)"
  CURRENT_HASH="sha256:${CURRENT_DIGEST%% *}"
  EXPECTED_HASH="$(tr -d '[:space:]' < "$HASH_FILE")"
  if [ "$CURRENT_HASH" = "$EXPECTED_HASH" ]; then
    STATE_INTEGRITY="PASS"
  else
    STATE_INTEGRITY="DRIFT_DETECTED (expected=${EXPECTED_HASH} current=${CURRENT_HASH})"
  fi
else
  STATE_INTEGRITY="UNKNOWN (critical hash unavailable)"
fi

CTX="=== RECUPERACIÓN POST-COMPACTACIÓN ===
El historial fue comprimido. Estado operativo (PROJECT_STATE.md manda):
${STATE_TXT}

Decisiones activas (resumen):
${DEC_TXT}

Últimas entradas de sesión:
${LOG_TXT}

STATE_INTEGRITY: ${STATE_INTEGRITY}

Usa /estado para confirmar y continúa desde LAST_GIT_CHECKPOINT. No preguntes 'dónde estábamos': está arriba."

if command -v jq >/dev/null 2>&1; then
  jq -n --arg ctx "$CTX" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
else
  printf '%s\n' "$CTX"
fi
exit 0
