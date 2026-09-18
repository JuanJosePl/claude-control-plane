#!/bin/bash
# Tier 3 evidence freshness: unique session_id and bounded result age.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RESULTS_DIR="${1:-$ROOT/evals/skills/results}"
BUDGET="${2:-$ROOT/evals/REGRESSION_BUDGET.json}"

fail() {
  printf 'evidence_freshness=FAIL: %s\n' "$1" >&2
  exit 1
}

command -v jq >/dev/null 2>&1 || fail 'jq is required'
[ -d "$RESULTS_DIR" ] || fail "missing results directory: $RESULTS_DIR"
[ -f "$BUDGET" ] || fail "missing budget file: $BUDGET"

DAYS="$(jq -r '.evidence_freshness_days // 30' "$BUDGET" 2>/dev/null)"
printf '%s' "$DAYS" | grep -qE '^[0-9]+$' || fail 'evidence_freshness_days must be an integer'
MAX_AGE=$((DAYS * 86400))
NOW="$(date +%s)"

shopt -s nullglob
RESULT_FILES=("$RESULTS_DIR"/*.json)
[ "${#RESULT_FILES[@]}" -gt 0 ] || fail 'no Tier 3 result files found'

declare -A SEEN_SESSION_IDS=()
for result in "${RESULT_FILES[@]}"; do
  jq -e . "$result" >/dev/null 2>&1 || fail "invalid JSON: $result"

  session_id="$(jq -r '.session_id // empty' "$result")"
  [ -n "$session_id" ] || fail "missing session_id: $result"
  if [ -n "${SEEN_SESSION_IDS["$session_id"]+seen}" ]; then
    fail "session_id reused: $session_id in $result and ${SEEN_SESSION_IDS["$session_id"]}"
  fi
  SEEN_SESSION_IDS["$session_id"]="$result"

  timestamp="$(jq -r '.timestamp // empty' "$result")"
  if [ -n "$timestamp" ]; then
    timestamp_epoch="$(date -d "$timestamp" +%s 2>/dev/null || true)"
    [ -n "$timestamp_epoch" ] || fail "invalid timestamp: $result"
  else
    timestamp_epoch="$(stat -c %Y "$result" 2>/dev/null || true)"
    [ -n "$timestamp_epoch" ] || fail "cannot read mtime: $result"
  fi

  age=$((NOW - timestamp_epoch))
  [ "$age" -le "$MAX_AGE" ] || fail "stale result: $result (${age}s > ${MAX_AGE}s)"
done

printf '%s\n' 'evidence_freshness=PASS'
