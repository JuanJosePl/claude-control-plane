#!/bin/bash
# pre-compact-snapshot (P1 · FAIL_OPEN) — snapshot de PROJECT_STATE antes de compactar + inyección
# preservada (PreCompact preserva additionalContext, verificado en 01_OFFICIAL_RESEARCH). NO bloquea.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$PROJ/PROJECT_STATE.md"
BK="$PROJ/.claude/backups"
mkdir -p "$BK"
[ -f "$STATE" ] && cp "$STATE" "$BK/PROJECT_STATE.precompact.md" 2>/dev/null || true

CORE=$( [ -f "$STATE" ] && grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS|LAST_GIT_CHECKPOINT):' "$STATE" || echo "sin estado")
CTX="=== SNAPSHOT PRE-COMPACT (preservar) ===
${CORE}
Snapshot en .claude/backups/PROJECT_STATE.precompact.md"

if command -v jq >/dev/null 2>&1; then
  jq -n --arg c "$CTX" '{hookSpecificOutput:{hookEventName:"PreCompact",additionalContext:$c}}'
else
  printf '%s\n' "$CTX"
fi
exit 0
