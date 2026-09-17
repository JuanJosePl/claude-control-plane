#!/bin/bash
# subagent-context (P2 · FAIL_OPEN) — inyecta contexto dinamico y packs estables por rol.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$PROJ/PROJECT_STATE.md"
DYN=$( [ -f "$STATE" ] && grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS):' "$STATE" || echo "estado no disponible")

AGENT="$(jq -r '.agent_type // ""' 2>/dev/null || true)"
case "$AGENT" in
  researcher) PACKS=(CORE BUSINESS DECISIONS) ;;
  architect) PACKS=(CORE CURRENT_STATE DECISIONS SECURITY_RULES) ;;
  implementer) PACKS=(CORE CURRENT_STATE SECURITY_RULES) ;;
  security-auditor) PACKS=(CORE SECURITY_RULES DECISIONS) ;;
  code-reviewer) PACKS=(CORE CURRENT_STATE SECURITY_RULES DECISIONS) ;;
  *) PACKS=(CORE CURRENT_STATE SECURITY_RULES) ;;
esac

STABLE=""
for pack in "${PACKS[@]}"; do
  FILE="$PROJ/.claude/context/$pack.md"
  if [ -f "$FILE" ]; then
    STABLE="$STABLE
--- CONTEXT PACK: $pack ---
$(cat "$FILE")"
  fi
done

CTX="=== CONTEXTO DINÁMICO (subagente) ===
${DYN}
${STABLE}
No asumas capacidades no verificadas. Reporta hallazgos con fuente."

if command -v jq >/dev/null 2>&1; then
  jq -n --arg ctx "$CTX" '{hookSpecificOutput:{hookEventName:"SubagentStart",additionalContext:$ctx}}'
else
  printf '%s\n' "$CTX"
fi
exit 0
