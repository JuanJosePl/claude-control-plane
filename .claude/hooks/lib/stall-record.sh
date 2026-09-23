#!/bin/bash
# R-2 observation helper. Emission is subordinate to the caller's decision.

stall_record_event() {
  local source_hook="${1:-UNKNOWN}"
  local decision="${2:-UNKNOWN}"
  local stall_type="${3:-UNKNOWN}"
  local policy_category="${4:-UNKNOWN}"
  local action="${5:-}"
  local task_id="${6:-}"
  local session_id="${7:-}"
  local notes="${8:-}"
  local project="${CLAUDE_PROJECT_DIR:-}"
  local log_path="${STALL_POLICY_LOG_PATH:-}"
  local log_dir timestamp event_id action_hash digest

  if [ -z "$log_path" ]; then
    [ -n "$project" ] || return 1
    log_path="$project/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl"
  fi
  log_dir="$(dirname "$log_path")" || return 1
  mkdir -p "$log_dir" || return 1
  timestamp="$(date -u '+%Y-%m-%dT%H:%M:%SZ')" || return 1
  event_id="r2-${source_hook}-${timestamp}-$$"

  if command -v sha256sum >/dev/null 2>&1; then
    digest="$(printf '%s' "$action" | sha256sum)" || digest=""
    action_hash="${digest%% *}"
    [ -n "$action_hash" ] || action_hash="UNKNOWN"
  else
    action_hash="UNKNOWN"
  fi

  jq -nc \
    --arg schema_version "1.0" \
    --arg event_id "$event_id" \
    --arg timestamp "$timestamp" \
    --arg source_hook "$source_hook" \
    --arg decision "$decision" \
    --arg stall_type "$stall_type" \
    --arg policy_category "$policy_category" \
    --arg action_hash "$action_hash" \
    --arg task_id "$task_id" \
    --arg session_id "$session_id" \
    --arg notes "$notes" \
    '{schema_version:$schema_version,event_id:$event_id,timestamp:$timestamp,source_hook:$source_hook,decision:$decision,stall_type:$stall_type,policy_category:$policy_category,action_hash:$action_hash,task_id:(if $task_id == "" then null else $task_id end),session_id:(if $session_id == "" then null else $session_id end),notes:$notes,had_alternative:null}' \
    >> "$log_path"
}
