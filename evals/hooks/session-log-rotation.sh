#!/bin/bash
# Session log rotation fixture: rotate without overwriting same-day archives.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOGGER="$ROOT/.claude/hooks/subagent-stop-logger.sh"
FIXTURE="$(mktemp -d /tmp/claude-control-plane-rotation-XXXXXX)"
trap 'rm -rf "$FIXTURE"' EXIT

LOG="$FIXTURE/docs/00_SYSTEM/CLAUDE_SESSION_LOG.md"
ARCHIVE_DIR="$FIXTURE/docs/00_SYSTEM/archive"
mkdir -p "$(dirname "$LOG")"

seed_log() {
  local count="$1"
  : > "$LOG"
  local index
  for index in $(printf '%s\n' {1..40}); do
    [ "$index" -le "$count" ] || break
    printf '\n## seed-%s\ncontenido\n' "$index" >> "$LOG"
  done
}

run_logger() {
  local agent_id="$1"
  printf '%s\n' "{\"agent_type\":\"rotation-test\",\"agent_id\":\"$agent_id\",\"last_assistant_message\":\"rotation\"}" | CLAUDE_PROJECT_DIR="$FIXTURE" "$LOGGER"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

seed_log 5
run_logger 'below-threshold'
test -f "$LOG" || fail 'below-threshold log disappeared'
test ! -d "$ARCHIVE_DIR" || fail 'below-threshold run created an archive'

seed_log 30
run_logger 'rotation-one'
DAILY_ARCHIVE="$ARCHIVE_DIR/CLAUDE_SESSION_LOG.$(date +%Y-%m-%d).md"
test ! -f "$LOG" || fail 'rotation did not move the active log'
test -f "$DAILY_ARCHIVE" || fail 'daily archive was not created'
grep -F 'agent_id:rotation-one' "$DAILY_ARCHIVE" >/dev/null || fail 'first archive lost its entry'

seed_log 30
run_logger 'rotation-two'
SECOND_ARCHIVE="$ARCHIVE_DIR/CLAUDE_SESSION_LOG.$(date +%Y-%m-%d).2.md"
test -f "$DAILY_ARCHIVE" || fail 'first archive was overwritten'
test -f "$SECOND_ARCHIVE" || fail 'same-day second archive was not created'
grep -F 'agent_id:rotation-one' "$DAILY_ARCHIVE" >/dev/null || fail 'first archive content changed'
grep -F 'agent_id:rotation-two' "$SECOND_ARCHIVE" >/dev/null || fail 'second archive lost its entry'

shopt -s nullglob
ARCHIVES=("$ARCHIVE_DIR"/CLAUDE_SESSION_LOG.*.md)
ARCHIVE_COUNT="${#ARCHIVES[@]}"
test "$ARCHIVE_COUNT" -eq 2 || fail "unexpected archive count: $ARCHIVE_COUNT"

printf '%s\n' 'session_log_rotation=PASS'
