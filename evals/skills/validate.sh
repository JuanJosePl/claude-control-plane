#!/bin/bash
# Tier 1/2/3 validator for the four SDLC skills. Tier 3 consumes persisted authenticated results.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURES="$ROOT/evals/skills/fixtures.json"
SKILLS=(test-driven-development code-review-and-quality doubt-driven-development constraint-driven-development)

command -v jq >/dev/null 2>&1 || { printf 'BLOCKED: jq is required\n' >&2; exit 2; }

for skill in "${SKILLS[@]}"; do
  file="$ROOT/.claude/skills/$skill/SKILL.md"
  test -f "$file" || { printf 'BLOCKED: missing %s\n' "$file" >&2; exit 1; }
  awk 'NR == 1 && $0 == "---" { found = 1 } NR == 2 && $0 ~ /^name:/ { name = 1 } NR == 3 && $0 ~ /^description:/ { description = 1 } END { exit !(found && name && description) }' "$file"
  test "$(jq -r --arg skill "$skill" '.[$skill].positive | length' "$FIXTURES")" -ge 3
  test "$(jq -r --arg skill "$skill" '.[$skill].negative | length' "$FIXTURES")" -ge 2
  test "$(jq -r --arg skill "$skill" '.[$skill].collision | length' "$FIXTURES")" -ge 1
  test "$(jq -r --arg skill "$skill" '.[$skill].behavioral | length' "$FIXTURES")" -ge 1
  while IFS= read -r marker; do
    rg -F -- "$marker" "$file" >/dev/null || { printf 'BLOCKED: %s missing marker %s\n' "$skill" "$marker" >&2; exit 1; }
  done < <(jq -r --arg skill "$skill" '.[$skill].markers[]' "$FIXTURES")
done

reviewer="$ROOT/.claude/agents/code-reviewer.md"
test -f "$reviewer"
! rg '^tools:.*(Write|Edit|Bash)' "$reviewer" >/dev/null
rg '^disallowedTools: Write, Edit, Bash, WebSearch$' "$reviewer" >/dev/null
rg -F 'contexto fresco' "$reviewer" >/dev/null

run1="$ROOT/evals/skills/results/F3-tier3-run-1.json"
run2="$ROOT/evals/skills/results/F3-tier3-run-2.json"
for result in "$run1" "$run2"; do
  test -f "$result"
  jq -e 'all([.result.tdd, .result.review, .result.doubt, .result.constraints][]; .positive_pass == true and .negative_pass == true and .collision_pass == true)' "$result" >/dev/null
done
sig1=$(jq -c '.result' "$run1")
sig2=$(jq -c '.result' "$run2")
test "$sig1" = "$sig2"

printf '%s\n' 'Tier 1 structural: PASS' 'Tier 2 routing fixtures: PASS' 'Tier 3 behavioral: PASS (two identical normalized signatures)'
