#!/bin/bash
# F5 smoke test: snapshot critical state, verify unchanged state, detect drift.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d /tmp/claude-control-plane-state-XXXXXX)"
trap 'rm -rf "$FIXTURE"' EXIT
mkdir -p "$FIXTURE/.claude/hooks" "$FIXTURE/.claude/backups" "$FIXTURE/docs/00_SYSTEM"
cp "$ROOT/.claude/hooks/pre-compact-snapshot.sh" "$FIXTURE/.claude/hooks/"
cp "$ROOT/.claude/hooks/session-start-compact.sh" "$FIXTURE/.claude/hooks/"
chmod +x "$FIXTURE/.claude/hooks/"*.sh
printf '%s\n' \
  'CURRENT_PHASE:          5' \
  'PHASE_STATUS:           IN_PROGRESS' \
  'CURRENT_OBJECTIVE:      state integrity' \
  'BLOCKERS:               NONE' \
  'LAST_GIT_CHECKPOINT:    e679b46' > "$FIXTURE/PROJECT_STATE.md"

PRECOMPACT=$(CLAUDE_PROJECT_DIR="$FIXTURE" "$FIXTURE/.claude/hooks/pre-compact-snapshot.sh")
printf '%s' "$PRECOMPACT" | jq -e '.hookSpecificOutput.additionalContext | contains("Critical state hash: sha256:")' >/dev/null
test -s "$FIXTURE/.claude/backups/PROJECT_STATE.critical.sha256"

UNCHANGED=$(CLAUDE_PROJECT_DIR="$FIXTURE" "$FIXTURE/.claude/hooks/session-start-compact.sh")
printf '%s' "$UNCHANGED" | jq -e '.hookSpecificOutput.additionalContext | contains("STATE_INTEGRITY: PASS")' >/dev/null

sed -i 's/BLOCKERS:               NONE/BLOCKERS:               DRIFTED/' "$FIXTURE/PROJECT_STATE.md"
DRIFTED=$(CLAUDE_PROJECT_DIR="$FIXTURE" "$FIXTURE/.claude/hooks/session-start-compact.sh")
printf '%s' "$DRIFTED" | jq -e '.hookSpecificOutput.additionalContext | contains("STATE_INTEGRITY: DRIFT_DETECTED")' >/dev/null

printf '%s\n' 'unchanged=PASS' 'drift=DETECTED' 'F5 state integrity PASS'
