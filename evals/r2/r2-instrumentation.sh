#!/bin/bash
set -euo pipefail

ROOT="${CCP_ROOT:-/home/juanls/Escritorio/claude-control-plane}"
FIXTURE="$(mktemp -d "$ROOT/.tmp/r2/r2-tests-XXXXXX")"
trap 'rm -rf "$FIXTURE"' EXIT

FIREWALL="$ROOT/.claude/hooks/bash-firewall.sh"
TASK_HOOK="$ROOT/.claude/hooks/task-completed-evidence.sh"

run_firewall() {
  local log_path="$1"
  local command_text="$2"
  jq -nc --arg command "$command_text" '{tool_input:{command:$command}}' > "$FIXTURE/input.json"
  set +e
  STALL_POLICY_LOG_PATH="$log_path" CLAUDE_PROJECT_DIR="$ROOT" "$FIREWALL" < "$FIXTURE/input.json" > "$FIXTURE/stdout" 2> "$FIXTURE/stderr"
  FIREWALL_RC=$?
  set -e
}

run_task() {
  local log_path="$1"
  local payload="$2"
  printf '%s\n' "$payload" > "$FIXTURE/task-input.json"
  set +e
  STALL_POLICY_LOG_PATH="$log_path" CLAUDE_PROJECT_DIR="$FIXTURE" "$TASK_HOOK" < "$FIXTURE/task-input.json" > "$FIXTURE/task-stdout" 2> "$FIXTURE/task-stderr"
  TASK_RC=$?
  set -e
}

event_emitted_correctly() {
  local log_path="$FIXTURE/correct.jsonl"
  run_firewall "$log_path" 'rm -rf /'
  test "$FIREWALL_RC" -eq 2
  test "$(wc -l < "$log_path")" -eq 1
  jq -e . "$log_path" >/dev/null
}

schema_valid() {
  local log_path="$FIXTURE/correct.jsonl"
  jq -e '
    type == "object" and
    (.schema_version == "1.0") and
    (.event_id | type == "string") and
    (.timestamp | type == "string") and
    (.source_hook == "bash-firewall.sh") and
    (.decision == "DENY") and
    (.stall_type == "STALL_POLICY") and
    (.policy_category | type == "string") and
    (.action_hash | test("^[0-9a-f]{64}$")) and
    (.task_id == null or (.task_id | type == "string")) and
    (.session_id == null or (.session_id | type == "string")) and
    (.notes | type == "string") and
    (.had_alternative == null)
  ' "$log_path" >/dev/null
}

unknown_preserved() {
  local log_path="$FIXTURE/unknown.jsonl"
  mkdir -p "$FIXTURE/docs/00_SYSTEM"
  printf '%s\n' '# EVIDENCE_REGISTRY' > "$FIXTURE/docs/00_SYSTEM/EVIDENCE_REGISTRY.md"
  run_task "$log_path" '{"task_id":"r2-unknown-source","contract_hash":"sha256:9999999999999999999999999999999999999999999999999999999999999999","risk_level":"low"}'
  test "$TASK_RC" -eq 2
  jq -e 'select(.stall_type == "UNKNOWN" and .decision == "DENY")' "$log_path" >/dev/null
}

malformed_event_cannot_weaken_enforcement() {
  local invalid_target="$FIXTURE/event-target"
  mkdir -p "$invalid_target"
  run_firewall "$invalid_target" 'rm -rf /'
  test "$FIREWALL_RC" -eq 2
}

instrumentation_failure_is_fail_safe() {
  local readonly_dir="$FIXTURE/readonly"
  mkdir -p "$readonly_dir"
  chmod 500 "$readonly_dir"
  run_firewall "$readonly_dir/event.jsonl" 'rm -rf /'
  test "$FIREWALL_RC" -eq 2
  chmod 700 "$readonly_dir"
}

event_emitted_correctly
printf '%s\n' 'event_emitted_correctly=PASS'
schema_valid
printf '%s\n' 'schema_valid=PASS'
unknown_preserved
printf '%s\n' 'unknown_preserved=PASS'
malformed_event_cannot_weaken_enforcement
printf '%s\n' 'malformed_event_cannot_weaken_enforcement=PASS'
instrumentation_failure_is_fail_safe
printf '%s\n' 'instrumentation_failure_is_fail_safe=PASS'
