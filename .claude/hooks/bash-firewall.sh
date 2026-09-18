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

# --- Patrones destructivos (regex tolerante a espacios y case SQL) ---
declare -A DESTRUCTIVE_REGEX=(
  ["rm -rf root"]='rm[[:space:]]+-rf[[:space:]]+/'
  ["rm -rf home"]='rm[[:space:]]+-rf[[:space:]]+(~|\$HOME)'
  ["dd zero device"]='dd[[:space:]]+if=/dev/zero'
  ["mkfs"]='mkfs'
  ["fork bomb"]=':[[:space:]]*\(\)[[:space:]]*\{[[:space:]]*:[[:space:]]*\|[[:space:]]*:[[:space:]]*&[[:space:]]*\}[[:space:]]*;[[:space:]]*:'
  ["chmod root"]='chmod[[:space:]]+-R[[:space:]]+777[[:space:]]+/'
  ["chown recursive"]='chown[[:space:]]+-R'
  ["write system disk"]='>[[:space:]]*/dev/sda'
  ["DROP TABLE"]='[Dd][Rr][Oo][Pp][[:space:]]+[Tt][Aa][Bb][Ll][Ee]'
  ["DROP DATABASE"]='[Dd][Rr][Oo][Pp][[:space:]]+[Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee]'
  ["TRUNCATE TABLE"]='[Tt][Rr][Uu][Nn][Cc][Aa][Tt][Ee][[:space:]]+[Tt][Aa][Bb][Ll][Ee]'
)
for reason in "${!DESTRUCTIVE_REGEX[@]}"; do
  printf '%s' "$COMMAND" | grep -qE -- "${DESTRUCTIVE_REGEX[$reason]}" && block "patrón destructivo/DB: '$reason'"
done

# --- Patrones regex (grep -E) ---
declare -A REGEX=(
  ["rm -rf con variable de home"]='rm +-rf +("?\$HOME"?|~)'
  ["secreto en argumento (KEY/SECRET/TOKEN/PASSWORD=)"]='(^|[^A-Za-z_])[A-Z_]*(KEY|SECRET|TOKEN|PASSWORD)='
  ["API key estilo sk-"]='sk-[A-Za-z0-9]{20,}'
  ["token Bearer"]='Bearer +[A-Za-z0-9._-]{20,}'
  ["AWS access key id"]='AKIA[0-9A-Z]{16}'
  ["lectura de .env"]='(cat|less|more|head|tail|bat|source|exec)[[:space:]]+[^|;&]*\.env([^A-Za-z0-9]|$)|(^|[[:space:];&|])\.[[:space:]]+[^|;&]*\.env([^A-Za-z0-9]|$)|read[[:space:]]+[^|;&]*<[[:space:]]*\.env|exec[[:space:]]*<[[:space:]]*\.env|\$\([[:space:]]*<[[:space:]]*[^|;&]*\.env([^A-Za-z0-9]|$)|eval[[:space:]]+[^|;&]*\.env([^A-Za-z0-9]|$)|<[[:space:]]*[^|;&]*\.env([^A-Za-z0-9]|$)'
  ["lectura de clave privada"]='(cat|less|more|head|tail|bat) +[^|;&]*\.(pem|key|pfx)([^A-Za-z0-9]|$)'
  ["lectura de secretos ssh/aws"]='(cat|less|more|head|tail) +[^|;&]*(\.ssh/|\.aws/credentials)'
  ["git add de secretos"]='git +add +[^|;&]*(\.env|\.pem|\.key|\.pfx|secrets/|credentials/)'
  ["supply chain curl|bash"]='(curl|wget)[^|]*\|[[:space:]]*(ba)?sh'
)
for reason in "${!REGEX[@]}"; do
  printf '%s' "$COMMAND" | grep -qE -- "${REGEX[$reason]}" && block "$reason"
done

exit 0
