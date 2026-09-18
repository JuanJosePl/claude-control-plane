#!/bin/bash
# Positive secret-guard fixture: real-looking secrets must block; placeholders allow.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GUARD="$ROOT/.claude/hooks/secret-guard.sh"
FIXTURE="$(mktemp -d /tmp/claude-control-plane-secret-XXXXXX)"
trap 'rm -rf "$FIXTURE"' EXIT

run_guard() {
  local content="$1"
  jq -nc --arg content "$content" '{tool_input:{file_path:"fixture.txt",content:$content}}' > "$FIXTURE/input.json"
  "$GUARD" < "$FIXTURE/input.json" > "$FIXTURE/stdout" 2> "$FIXTURE/stderr"
  GUARD_RC=$?
  GUARD_ERR="$(<"$FIXTURE/stderr")"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

expect_block() {
  local description="$1"
  local content="$2"
  run_guard "$content"
  test "$GUARD_RC" -eq 2 || fail "expected BLOCK for $description (rc=$GUARD_RC)"
  printf '%s' "$GUARD_ERR" | grep -F 'BLOQUEADO' >/dev/null || fail "missing block reason for $description"
}

expect_allow() {
  local description="$1"
  local content="$2"
  run_guard "$content"
  test "$GUARD_RC" -eq 0 || fail "expected ALLOW for $description (rc=$GUARD_RC)"
}

expect_block 'PEM private key' $'-----BEGIN PRIVATE KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A\n-----END PRIVATE KEY-----'
expect_block 'sk API key' 'sk-abcdef1234567890abcdef'
expect_block 'JWT' 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.SflKxwRJSMeKKF2QT4fwpw'
expect_block 'AWS access key' 'AKIAJ7K3MNPQ2R4T6W8Z'
expect_block 'secret assignment' 'SESSION_TOKEN=J9kLm2Qv7Xr4P8s1'

expect_allow 'explicit placeholder' 'API_TOKEN=CHANGE_ME'
expect_allow 'documentation example' 'Use API_TOKEN=example in local development.'
expect_allow 'ordinary content' 'This file contains no credentials.'

printf '%s\n' 'secret_guard_positive=PASS'
