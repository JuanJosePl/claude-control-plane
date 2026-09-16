#!/bin/bash
# subagent-context (P2 · FAIL_OPEN) — inyecta contexto DINÁMICO al subagente (fase + restricciones).
# El contexto ESTABLE por rol llega por el campo skills: del agente. Verificar CP-004 que esto llega.
set -uo pipefail
PROJ="${CLAUDE_PROJECT_DIR:-$(pwd)}"
STATE="$PROJ/PROJECT_STATE.md"
DYN=$( [ -f "$STATE" ] && grep -E '^(CURRENT_PHASE|PHASE_STATUS|CURRENT_OBJECTIVE|BLOCKERS):' "$STATE" || echo "estado no disponible")

CTX="=== CONTEXTO DINÁMICO (subagente) ===
${DYN}
Recuerda: tenant_id + RLS; no secrets en código; parameterized queries; opt-in Ley 1581.
Tu contexto estable de rol está en tus skills (context-*). Reporta hallazgos con fuente."

if command -v jq >/dev/null 2>&1; then
  jq -n --arg ctx "$CTX" '{hookSpecificOutput:{hookEventName:"SubagentStart",additionalContext:$ctx}}'
else
  printf '%s\n' "$CTX"
fi
exit 0
