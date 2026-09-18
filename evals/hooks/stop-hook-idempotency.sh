#!/bin/bash
# Regression fixture: Stop must not re-emit its reminder after stop_hook_active=true.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d /tmp/claude-control-plane-stop-XXXXXX)"
trap 'rm -rf "$FIXTURE"' EXIT

mkdir -p "$FIXTURE/docs/00_SYSTEM"
STATE="$FIXTURE/PROJECT_STATE.md"
printf '%s\n' '# PROJECT STATE' > "$STATE"

run_hook() {
  local payload="$1"
  HOOK_OUTPUT="$(printf '%s' "$payload" | CLAUDE_PROJECT_DIR="$FIXTURE" "$ROOT/.claude/hooks/stop-logger.sh" 2>"$FIXTURE/hook.err")"
  HOOK_RC=$?
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

touch -d '2 days ago' "$STATE"
run_hook '{"stop_hook_active":false}'
test "$HOOK_RC" -eq 0 || fail 'stop_hook_active=false crashed'
printf '%s' "$HOOK_OUTPUT" | grep -F 'additionalContext' >/dev/null || fail 'normal reminder was not emitted'

run_hook '{"stop_hook_active":true}'
test "$HOOK_RC" -eq 0 || fail 'stop_hook_active=true failed'
test -z "$HOOK_OUTPUT" || fail 'active Stop hook re-emitted a reminder'

run_hook '{"last_assistant_message":"ignored","stop_hook_active":true}'
test "$HOOK_RC" -eq 0 || fail 'repeated active Stop hook failed'
test -z "$HOOK_OUTPUT" || fail 'repeated active Stop hook emitted output'

touch "$STATE"
run_hook '{"stop_hook_active":false}'
test "$HOOK_RC" -eq 0 || fail 'fresh PROJECT_STATE input failed'
test -z "$HOOK_OUTPUT" || fail 'fresh PROJECT_STATE emitted a reminder'

touch -d '2 days ago' "$STATE"
run_hook '{}'
test "$HOOK_RC" -eq 0 || fail 'missing stop_hook_active crashed'
printf '%s' "$HOOK_OUTPUT" | grep -F 'additionalContext' >/dev/null || fail 'missing stop_hook_active changed normal behavior'

run_hook 'not-json'
test "$HOOK_RC" -eq 0 || fail 'malformed input crashed the hook'

printf '%s\n' 'stop_hook_idempotency=PASS'
