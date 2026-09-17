#!/bin/bash
# Regression fixture: the same completion payload is unprotected without the control
# and is blocked by the TaskCompleted evidence gate.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d /tmp/claude-control-plane-incident-XXXXXX)"
trap 'rm -rf "$FIXTURE"' EXIT
mkdir -p "$FIXTURE/docs/00_SYSTEM"
PAYLOAD='{"task_id":"INC-001-no-evidence","risk_level":"medium"}'

# The registry exists, but has no VERIFIED entry for this task.
printf '%s\n' '# EVIDENCE_REGISTRY' '## EV-000 — unrelated evidence' '- **Task ID:** another-task' '- **Status:** VERIFIED' > "$FIXTURE/docs/00_SYSTEM/EVIDENCE_REGISTRY.md"

# Control-free baseline: an unguarded completion consumer accepts a well-formed payload.
baseline_completion() {
  jq -e '.task_id and .risk_level' >/dev/null
}
printf '%s\n' "$PAYLOAD" | baseline_completion

# The active control must block the same payload because no evidence exists.
set +e
CONTROL_ERR="$FIXTURE/control.err"
printf '%s\n' "$PAYLOAD" | CLAUDE_PROJECT_DIR="$FIXTURE" "$ROOT/.claude/hooks/task-completed-evidence.sh" >/dev/null 2>"$CONTROL_ERR"
CONTROL_RC=$?
set -e
test "$CONTROL_RC" -eq 2
rg -F 'Evidence Contract invalid for task_id=INC-001-no-evidence' "$CONTROL_ERR" >/dev/null
rg -F 'no matching VERIFIED evidence' "$CONTROL_ERR" >/dev/null

printf '%s\n' 'without_control=UNPROTECTED' 'with_control=BLOCKED' 'REG-001 PASS'
