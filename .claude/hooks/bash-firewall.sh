#!/bin/bash
# bash-firewall (P0 · FAIL_CLOSED) — bloquea comandos destructivos, exfiltración/lectura de
# secretos y supply chain. Bloqueo: exit 2 + stderr (canal universal en Claude Code 2.1.273).
# DRY_RUN=true imprime la decisión sin efecto. Timeout objetivo ≤3s.
set -uo pipefail

INPUT="$(cat)"

# FAIL_CLOSED: sin jq no podemos analizar → denegar.
if ! command -v jq >/dev/null 2>&1; then
  echo "BLOQUEADO (fail-closed): jq no disponible, no se puede auditar el comando." >&2
  exit 2
fi

COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")"
[ -z "$COMMAND" ] && exit 0

block() {
  echo "BLOQUEADO por bash-firewall (P0): $1" >&2
  echo "Comando: $COMMAND" >&2
  [ "${DRY_RUN:-false}" = "true" ] && { echo "[DRY_RUN] se habría bloqueado"; exit 0; }
  exit 2
}

# --- Patrones literales (grep -F) ---
LITERAL=(
  "rm -rf /" "rm -rf /*" "rm -rf ~" "rm -rf \$HOME"
  "dd if=/dev/zero" "mkfs" ":(){:|:&};:" "chmod -R 777 /" "chown -R"
  "> /dev/sda" "DROP TABLE" "DROP DATABASE" "TRUNCATE TABLE"
)
for p in "${LITERAL[@]}"; do
  printf '%s' "$COMMAND" | grep -qF -- "$p" && block "patrón destructivo/DB: '$p'"
done

# --- Patrones regex (grep -E) ---
declare -A REGEX=(
  ["rm -rf con variable de home"]='rm +-rf +("?\$HOME"?|~)'
  ["secreto en argumento (KEY/SECRET/TOKEN/PASSWORD=)"]='(^|[^A-Za-z_])[A-Z_]*(KEY|SECRET|TOKEN|PASSWORD)='
  ["API key estilo sk-"]='sk-[A-Za-z0-9]{20,}'
  ["token Bearer"]='Bearer +[A-Za-z0-9._-]{20,}'
  ["AWS access key id"]='AKIA[0-9A-Z]{16}'
  ["lectura de .env"]='(cat|less|more|head|tail|bat) +[^|;&]*\.env([^A-Za-z0-9]|$)'
  ["lectura de clave privada"]='(cat|less|more|head|tail|bat) +[^|;&]*\.(pem|key|pfx)([^A-Za-z0-9]|$)'
  ["lectura de secretos ssh/aws"]='(cat|less|more|head|tail) +[^|;&]*(\.ssh/|\.aws/credentials)'
  ["git add de secretos"]='git +add +[^|;&]*(\.env|\.pem|\.key|\.pfx|secrets/|credentials/)'
  ["supply chain curl|bash"]='(curl|wget)[^|]*\|[[:space:]]*(ba)?sh'
)
for reason in "${!REGEX[@]}"; do
  printf '%s' "$COMMAND" | grep -qE -- "${REGEX[$reason]}" && block "$reason"
done

exit 0
