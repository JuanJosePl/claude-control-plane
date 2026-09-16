#!/bin/bash
# config-change-logger (P1 · FAIL_OPEN) — registra cambios de configuración (ConfigChange NO bloquea).
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
LOG="$PROJ/docs/00_SYSTEM/CLAUDE_SESSION_LOG.md"
command -v jq >/dev/null 2>&1 || exit 0
INPUT="$(cat)"
SRC=$(printf '%s' "$INPUT" | jq -r '.config_source // "?"' 2>/dev/null)
KEYS=$(printf '%s' "$INPUT" | jq -rc '.changed_keys // []' 2>/dev/null)
TS=$(date '+%Y-%m-%d %H:%M')
mkdir -p "$(dirname "$LOG")"
{
  echo ""
  echo "## ${TS}"
  echo "CONFIG CHANGE:        source=${SRC} keys=${KEYS}"
} >> "$LOG"
exit 0
