#!/bin/bash
# pre-compact-snapshot (P1 · FAIL_OPEN) — snapshot + hash de PROJECT_STATE antes de compactar
# preservada (PreCompact preserva additionalContext, verificado en 01_OFFICIAL_RESEARCH). NO bloquea.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$PROJ/PROJECT_STATE.md"
BK="$PROJ/.claude/backups"
mkdir -p "$BK"
[ -f "$STATE" ] && cp "$STATE" "$BK/PROJECT_STATE.precompact.md" 2>/dev/null || true

CORE=$( [ -f "$STATE" ] && grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS|LAST_GIT_CHECKPOINT):' "$STATE" || echo "sin estado")
HASH_FILE="$BK/PROJECT_STATE.critical.sha256"
if command -v sha256sum >/dev/null 2>&1; then
  DIGEST="$(printf '%s\n' "$CORE" | sha256sum)"
  printf 'sha256:%s\n' "${DIGEST%% *}" > "$HASH_FILE"
  HASH_STATUS="sha256:${DIGEST%% *}"
else
  HASH_STATUS="UNKNOWN (sha256sum no disponible)"
fi
CTX="=== SNAPSHOT PRE-COMPACT (preservar) ===
${CORE}
Snapshot en .claude/backups/PROJECT_STATE.precompact.md
Critical state hash: ${HASH_STATUS}"

if command -v jq >/dev/null 2>&1; then
  jq -n --arg c "$CTX" '{hookSpecificOutput:{hookEventName:"PreCompact",additionalContext:$c}}'
else
  printf '%s\n' "$CTX"
fi
exit 0
