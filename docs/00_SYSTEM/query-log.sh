#!/bin/bash
# query-log.sh — STALL_POLICY_LOG query tool
# READ-ONLY: This script only reads STALL_POLICY_LOG.jsonl; modifies nothing.
# Purpose: Make H-01 monitoring operational; count real bypass events vs test events.
# Usage: bash docs/00_SYSTEM/query-log.sh [--json | --summary | --h01]
# MOVEMENT 007 — Authorized: read-only documentation tool (not a hook; not in .claude/)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${STALL_POLICY_LOG_PATH:-${SCRIPT_DIR}/STALL_POLICY_LOG.jsonl}"
MODE="${1:---summary}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "No STALL_POLICY_LOG found at: $LOG_FILE" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq required for log parsing" >&2
  exit 1
fi

count_total() {
  jq -s 'length' "$LOG_FILE"
}

count_by_hook() {
  jq -r '.source_hook' "$LOG_FILE" | sort | uniq -c | sort -rn
}

count_by_policy() {
  jq -r '.policy_category' "$LOG_FILE" | sort | uniq -c | sort -rn
}

count_firewall_denies() {
  jq -s '[.[] | select(.source_hook == "bash-firewall.sh" and .decision == "DENY")] | length' "$LOG_FILE"
}

count_task_gate_denies() {
  jq -s '[.[] | select(.source_hook == "task-completed-evidence.sh" and .decision == "DENY")] | length' "$LOG_FILE"
}

# H-01: real firewall bypass events (excludes test events based on known test action hashes)
# TEST_HASH: The known test action from rm -rf / test in maintenance.sh
count_h01_real() {
  # Known test event hash from maintenance suite (rm -rf / test)
  local TEST_HASH="2a16f855290ec17b976d87f856c6ee3058cf2fd6d6d5ceee49b3616f137da948"
  jq -s --arg th "$TEST_HASH" \
    '[.[] | select(.source_hook == "bash-firewall.sh" and .decision == "DENY" and .action_hash != $th)] | length' \
    "$LOG_FILE"
}

count_h01_test() {
  local TEST_HASH="2a16f855290ec17b976d87f856c6ee3058cf2fd6d6d5ceee49b3616f137da948"
  jq -s --arg th "$TEST_HASH" \
    '[.[] | select(.source_hook == "bash-firewall.sh" and .decision == "DENY" and .action_hash == $th)] | length' \
    "$LOG_FILE"
}

last_event_date() {
  jq -r '.timestamp' "$LOG_FILE" | sort | tail -1
}

# H-01 threshold check
check_threshold() {
  local n="${H01_THRESHOLD:-1}"
  local real_count
  real_count=$(count_h01_real)
  if [[ $real_count -ge $n ]]; then
    echo "TRIGGER-1 ACTIVE: H-01 real events ($real_count) >= N ($n)"
    echo "ACTION: Investigate — LABYRINTH-1 should be REOPENED per READY-03 acceptance"
  else
    echo "TRIGGER-1 INACTIVE: H-01 real events ($real_count) < N ($n)"
    echo "STATUS: Within accepted threshold — LABYRINTH-1 remains CONDITIONALLY_CLOSED"
  fi
}

case "$MODE" in
  --summary)
    echo "=== STALL_POLICY_LOG Summary ==="
    echo "Log file: $LOG_FILE"
    echo "Last event: $(last_event_date)"
    echo ""
    echo "Total events:          $(count_total)"
    echo "Firewall DENY:         $(count_firewall_denies)"
    echo "Task gate DENY:        $(count_task_gate_denies)"
    echo ""
    echo "H-01 real events:      $(count_h01_real)"
    echo "H-01 test events:      $(count_h01_test)"
    echo ""
    echo "--- H-01 Threshold Check (N=${H01_THRESHOLD:-1}) ---"
    check_threshold
    echo ""
    echo "--- Events by Policy Category ---"
    count_by_policy
    ;;
  --h01)
    echo "=== H-01 Status ==="
    echo "Real events (non-test): $(count_h01_real)"
    echo "Test events:            $(count_h01_test)"
    check_threshold
    ;;
  --json)
    jq -s '.' "$LOG_FILE"
    ;;
  --recent)
    echo "=== Last 5 events ==="
    tail -5 "$LOG_FILE" | jq -r '"\(.timestamp) [\(.source_hook)] \(.decision): \(.policy_category)"'
    ;;
  --help)
    echo "Usage: $0 [--summary | --h01 | --json | --recent | --help]"
    echo "  --summary  Full summary with H-01 threshold check (default)"
    echo "  --h01      H-01 real event count and threshold status"
    echo "  --json     All events as JSON array"
    echo "  --recent   Last 5 events"
    echo ""
    echo "Environment variables:"
    echo "  H01_THRESHOLD=N     Set H-01 reactivation threshold (default: 1)"
    echo "  STALL_POLICY_LOG_PATH  Override log file path"
    ;;
  *)
    echo "Unknown mode: $MODE. Use --help for usage." >&2
    exit 1
    ;;
esac
