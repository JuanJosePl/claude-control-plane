#!/bin/bash
# Deterministic maintenance suite for the Claude Control Plane.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

command -v jq >/dev/null 2>&1 || { printf 'BLOCKED: jq missing\n' >&2; exit 2; }
jq empty .claude/settings.json
jq -e '.max_failed_suites == 0 and .max_missing_evidence == 0 and (.required_suites | length) == 4' evals/REGRESSION_BUDGET.json >/dev/null

bash -n install.sh
for file in .claude/hooks/*.sh evals/**/*.sh; do
  bash -n "$file"
done

evals/skills/validate.sh >/tmp/claude-control-plane-skills.out
evals/incidents/INC-001-task-completed-evidence.sh >/tmp/claude-control-plane-incidents.out
evals/state/state-integrity.sh >/tmp/claude-control-plane-state.out

entries=$(rg '^## EV-' docs/00_SYSTEM/EVIDENCE_REGISTRY.md | rg -v '\{claim' | wc -l)
provenance=$(rg --count --regexp '^-[[:space:]]\*\*Provenance:\*\* (EXTRACTED|INFERRED|ASSUMED|EXTERNAL|GENERATED)$' docs/00_SYSTEM/EVIDENCE_REGISTRY.md)
artifact_hashes=$(rg --count --regexp '^-[[:space:]]\*\*Artifact Hash:\*\* sha256:[0-9a-fA-F]{64}$' docs/00_SYSTEM/EVIDENCE_REGISTRY.md)
test "$entries" -eq "$provenance"
test "$entries" -eq "$artifact_hashes"
! rg 'PostToolUse|N/9|N/7|11 skills|9 hooks' README.md docs/DESIGN.md .claude install.sh templates --glob '!*.history*' >/dev/null

target=$(mktemp -d /tmp/claude-control-plane-maintenance-XXXXXX)
printf 'maintenance-test\nother\n' | bash install.sh "$target" >/tmp/claude-control-plane-install.out
jq empty "$target/.claude/settings.json"
test -f "$target/CLAUDE.md"
test -f "$target/docs/00_SYSTEM/EVIDENCE_REGISTRY.md"
test -f "$target/CONTROL_REGISTRY.md"
test -f "$target/REGRESSION_REGISTRY.md"
test -x "$target/evals/incidents/INC-001-task-completed-evidence.sh"

printf '%s\n' 'schema=PASS' 'installer=PASS' 'hooks=PASS' 'skills=PASS' 'incidents=PASS' 'state=PASS' 'evidence=PASS' 'docs=PASS' 'regression_budget=PASS'
