#!/bin/bash
# task-completed-evidence (P0 · FAIL_CLOSED) — exige evidencia verificada por task_id.
set -uo pipefail

PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
REGISTRY="$PROJ/docs/00_SYSTEM/EVIDENCE_REGISTRY.md"

block() {
  printf 'TaskCompleted bloqueado: %s\n' "$1" >&2
  exit 2
}

command -v jq >/dev/null 2>&1 || block "jq es requerido para validar el payload."
[ -f "$REGISTRY" ] || block "no existe EVIDENCE_REGISTRY.md."

INPUT="$(cat)"
jq -e . >/dev/null 2>&1 <<<"$INPUT" || block "el payload recibido no es JSON válido."

TASK_ID="$(jq -r '.task_id // empty' <<<"$INPUT")"
[ -n "$TASK_ID" ] || block "el payload no contiene task_id."

RISK_LEVEL="$(jq -r '.risk_level // .risk // "medium"' <<<"$INPUT")"
case "$RISK_LEVEL" in
  low) REQUIRE_REVIEW=0 ;;
  medium|high|critical) REQUIRE_REVIEW=1 ;;
  *) block "risk_level invalido: $RISK_LEVEL. Usa low, medium, high o critical." ;;
esac

if ! awk -v task_id="$TASK_ID" -v require_review="$REQUIRE_REVIEW" '
  /^## EV-[0-9]+[[:space:]]/ {
    in_entry = 1
    matches_task = 0
    is_verified = 0
    has_artifact_hash = 0
    has_contract_hash = 0
    has_checks = 0
    has_reviewer = 0
    has_reviewer_pass = 0
    has_exceptions = 0
    has_timestamp = 0
  }
  in_entry && index($0, "- **Task ID:** " task_id) { matches_task = 1 }
  in_entry && index($0, "- **Status:** VERIFIED") { is_verified = 1 }
  in_entry && $0 ~ /^- \*\*Artifact Hash:\*\* sha256:[0-9a-fA-F]{64}$/ && $0 !~ /sha256:0{64}$/ { has_artifact_hash = 1 }
  in_entry && $0 ~ /^- \*\*Contract Hash:\*\* sha256:[0-9a-fA-F]{64}$/ && $0 !~ /sha256:0{64}$/ { has_contract_hash = 1 }
  in_entry && $0 ~ /^- \*\*Checks:\*\* / && $0 ~ /tests=PASS/ && $0 ~ /static=PASS/ && $0 ~ /security=(PASS|NOT_REQUIRED)$/ { has_checks = 1 }
  in_entry && $0 ~ /^- \*\*Reviewer:\*\* (PASS|NOT_REQUIRED)$/ { has_reviewer = 1 }
  in_entry && $0 ~ /^- \*\*Reviewer:\*\* PASS$/ { has_reviewer_pass = 1 }
  in_entry && ($0 ~ /^- \*\*Exceptions:\*\* NONE$/ || $0 ~ /^- \*\*Exceptions:\*\* APPROVED:/) { has_exceptions = 1 }
  in_entry && $0 ~ /^- \*\*Timestamp:\*\* [0-9]{4}-[0-9]{2}-[0-9]{2}T/ { has_timestamp = 1 }
  in_entry && matches_task && is_verified && has_artifact_hash && has_contract_hash && has_checks && has_reviewer && (require_review == 0 || has_reviewer_pass) && has_exceptions && has_timestamp { found = 1 }
  END { exit(found ? 0 : 1) }
' "$REGISTRY"; then
  block "Evidence Contract invalid for task_id=$TASK_ID: no matching VERIFIED evidence or required fields."
fi

printf '%s\n' "TaskCompleted permitido: Evidence Contract VERIFIED para task_id=$TASK_ID (risk=$RISK_LEVEL)."
exit 0
