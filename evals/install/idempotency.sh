#!/bin/bash
# Installer fixture: user settings survive reinstall unless --force or confirmation is supplied.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE="$(mktemp -d /tmp/claude-control-plane-install-XXXXXX)"
trap 'rm -rf "$FIXTURE"' EXIT

TARGET="$FIXTURE/project"
PARTIAL="$FIXTURE/partial"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

run_install() {
  local target="$1"
  local force="$2"
  if [ "$force" = true ]; then
    printf '%s\n' 'fixture-project' 'other' | bash "$ROOT/install.sh" "$target" --force > "$FIXTURE/install.out" 2> "$FIXTURE/install.err"
  else
    printf '%s\n' 'fixture-project' 'other' | bash "$ROOT/install.sh" "$target" > "$FIXTURE/install.out" 2> "$FIXTURE/install.err"
  fi
  INSTALL_RC=$?
}

has_custom_setting() {
  jq -e '.permissions.allow | index("Bash(user-custom *)") != null' "$TARGET/.claude/settings.json" >/dev/null 2>&1
}

run_install "$TARGET" false
test "$INSTALL_RC" -eq 0 || fail 'clean install failed'
jq empty "$TARGET/.claude/settings.json" || fail 'clean install produced invalid settings'

jq '.permissions.allow += ["Bash(user-custom *)"]' "$TARGET/.claude/settings.json" > "$FIXTURE/custom.json"
mv "$FIXTURE/custom.json" "$TARGET/.claude/settings.json"
has_custom_setting || fail 'fixture failed to add user setting'

run_install "$TARGET" false
test "$INSTALL_RC" -eq 0 || fail 'non-interactive reinstall failed'
has_custom_setting || fail 'non-interactive reinstall overwrote user settings'

printf '%s\n' 'fixture-project' 'other' 'n' | script -qec "bash \"$ROOT/install.sh\" \"$TARGET\"" "$FIXTURE/interactive.log" >/dev/null 2>&1
has_custom_setting || fail 'interactive decline did not preserve user settings'

run_install "$TARGET" true
test "$INSTALL_RC" -eq 0 || fail 'forced reinstall failed'
if has_custom_setting; then
  fail 'forced reinstall did not replace settings'
fi

mkdir -p "$PARTIAL/.claude"
run_install "$PARTIAL" false
test "$INSTALL_RC" -eq 0 || fail 'partial install recovery failed'
test -f "$PARTIAL/.claude/settings.json" || fail 'partial install did not restore settings'

printf '%s\n' 'install_idempotency=PASS'
