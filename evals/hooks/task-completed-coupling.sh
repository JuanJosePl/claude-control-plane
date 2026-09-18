#!/bin/bash
# Evidence coupling fixture: a supplied contract_hash must match the task evidence.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HOOK="$ROOT/.claude/hooks/task-completed-evidence.sh"
FIXTURE="$(mktemp -d /tmp/claude-control-plane-coupling-XXXXXX)"
trap 'rm -rf "$FIXTURE"' EXIT

mkdir -p "$FIXTURE/docs/00_SYSTEM"
cat > "$FIXTURE/docs/00_SYSTEM/EVIDENCE_REGISTRY.md" <<'EOF'
# EVIDENCE_REGISTRY

## EV-900 — current contractual task
- **Task ID:** F7-current-2026-09-18-abcd
- **Date:** 2026-09-18
- **Claim:** Current task evidence is valid.
- **Source:** F7 coupling fixture
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** F7
- **Artifact Hash:** sha256:1111111111111111111111111111111111111111111111111111111111111111
- **Contract Hash:** sha256:2222222222222222222222222222222222222222222222222222222222222222
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-18T12:00:00Z

## EV-901 — historical contractual task
- **Task ID:** F1-historical-2026-09-16-efgh
- **Date:** 2026-09-16
- **Claim:** Historical task evidence remains immutable.
- **Source:** F1 historical evidence
- **Provenance:** GENERATED
- **Confidence:** HIGH
- **Status:** VERIFIED
- **Affects:** F1
- **Artifact Hash:** sha256:3333333333333333333333333333333333333333333333333333333333333333
- **Contract Hash:** sha256:4444444444444444444444444444444444444444444444444444444444444444
- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED
- **Reviewer:** PASS
- **Exceptions:** NONE
- **Timestamp:** 2026-09-16T23:59:00Z
EOF

run_gate_at() {
  local project="$1"
  local payload="$2"
  printf '%s\n' "$payload" > "$FIXTURE/input.json"
  CLAUDE_PROJECT_DIR="$project" "$HOOK" < "$FIXTURE/input.json" > "$FIXTURE/stdout" 2> "$FIXTURE/stderr"
  GATE_RC=$?
  GATE_OUT="$(<"$FIXTURE/stdout")"
  GATE_ERR="$(<"$FIXTURE/stderr")"
}

run_gate() {
  run_gate_at "$FIXTURE" "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

expect_allow() {
  local description="$1"
  local payload="$2"
  run_gate "$payload"
  test "$GATE_RC" -eq 0 || fail "expected ALLOW for $description (rc=$GATE_RC): $GATE_ERR"
}

expect_block() {
  local description="$1"
  local payload="$2"
  run_gate "$payload"
  test "$GATE_RC" -eq 2 || fail "expected BLOCK for $description (rc=$GATE_RC)"
  printf '%s' "$GATE_ERR" | grep -F 'Evidence Contract invalid' >/dev/null || fail "missing block reason for $description"
}

expect_malformed() {
  run_gate 'not-json'
  test "$GATE_RC" -eq 2 || fail "malformed payload was not blocked (rc=$GATE_RC)"
  printf '%s' "$GATE_ERR" | grep -F 'JSON' >/dev/null || fail 'malformed payload reason was not reported'
}

expect_invalid_contract_hash() {
  local payload="$1"
  run_gate "$payload"
  test "$GATE_RC" -eq 2 || fail "invalid contract_hash was not blocked (rc=$GATE_RC)"
  printf '%s' "$GATE_ERR" | grep -F 'contract_hash' >/dev/null || fail 'invalid contract_hash reason was not reported'
}

expect_invalid_evidence() {
  local invalid_project="$FIXTURE/invalid"
  local task_suffix="$1"
  local status="$2"
  mkdir -p "$invalid_project/docs/00_SYSTEM"
  printf '%s\n' '# EVIDENCE_REGISTRY' "## EV-902 — invalid evidence $task_suffix" "- **Task ID:** F7-invalid-2026-09-18-$task_suffix" "- **Status:** $status" '- **Artifact Hash:** sha256:1111111111111111111111111111111111111111111111111111111111111111' '- **Contract Hash:** sha256:2222222222222222222222222222222222222222222222222222222222222222' '- **Checks:** tests=PASS; static=PASS; security=NOT_REQUIRED' '- **Reviewer:** NOT_REQUIRED' '- **Exceptions:** NONE' '- **Timestamp:** 2026-09-18T12:00:00Z' > "$invalid_project/docs/00_SYSTEM/EVIDENCE_REGISTRY.md"
  run_gate_at "$invalid_project" "{\"task_id\":\"F7-invalid-2026-09-18-$task_suffix\",\"contract_hash\":\"sha256:2222222222222222222222222222222222222222222222222222222222222222\",\"risk_level\":\"low\"}"
  test "$GATE_RC" -eq 2 || fail "invalid evidence was not blocked (rc=$GATE_RC)"
}

CURRENT_HASH='sha256:2222222222222222222222222222222222222222222222222222222222222222'
expect_allow 'matching contract hash' "{\"task_id\":\"F7-current-2026-09-18-abcd\",\"contract_hash\":\"$CURRENT_HASH\",\"risk_level\":\"low\"}"
expect_allow 'matching bare contract hash' '{"task_id":"F7-current-2026-09-18-abcd","contract_hash":"2222222222222222222222222222222222222222222222222222222222222222","risk_level":"low"}'
expect_invalid_contract_hash '{"task_id":"F7-current-2026-09-18-abcd","contract_hash":"","risk_level":"low"}'
expect_invalid_contract_hash '{"task_id":"F7-current-2026-09-18-abcd","contract_hash":null,"risk_level":"low"}'
expect_block 'mismatched contract hash' '{"task_id":"F7-current-2026-09-18-abcd","contract_hash":"sha256:9999999999999999999999999999999999999999999999999999999999999999","risk_level":"low"}'
expect_block 'historical task with current contract' '{"task_id":"F1-historical-2026-09-16-efgh","contract_hash":"sha256:2222222222222222222222222222222222222222222222222222222222222222","risk_level":"low"}'
expect_block 'nonexistent task' '{"task_id":"F7-missing-2026-09-18-zzzz","contract_hash":"sha256:2222222222222222222222222222222222222222222222222222222222222222","risk_level":"low"}'
expect_malformed
expect_invalid_evidence 'ijkl' 'VERIFIED_BOGUS'
expect_invalid_evidence 'mnop' 'VERIFIED extra'

run_gate '{"task_id":"F7-current-2026-09-18-abcd","risk_level":"low"}'
test "$GATE_RC" -eq 0 || fail 'transitional payload without contract_hash was blocked'
printf '%s' "$GATE_ERR" | grep -F 'contract_hash' >/dev/null || fail 'missing transitional contract_hash warning'

printf '%s\n' 'task_completed_coupling=PASS'
