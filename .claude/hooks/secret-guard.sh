#!/bin/bash
# secret-guard (P0 · FAIL_CLOSED) — impide escribir secretos vía Write/Edit.
# Bloqueo: exit 2 + stderr. Permite placeholders obvios. DRY_RUN=true simula.
set -uo pipefail

INPUT="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  echo "BLOQUEADO (fail-closed): jq no disponible, no se puede auditar el contenido." >&2
  exit 2
fi

# Contenido según herramienta: Write.content · Edit.new_string
CONTENT="$(printf '%s' "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // ""' 2>/dev/null || echo "")"
FILE="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")"
[ -z "$CONTENT" ] && exit 0

block() {
  echo "BLOQUEADO por secret-guard (P0): posible secreto en $FILE — $1" >&2
  echo "Usa variables de entorno, no valores reales. Placeholders válidos: CHANGE_ME, <your-...>, example." >&2
  [ "${DRY_RUN:-false}" = "true" ] && { echo "[DRY_RUN] se habría bloqueado"; exit 0; }
  exit 2
}

# Excepción: placeholders obvios en el contenido → permitir
if printf '%s' "$CONTENT" | grep -qiE 'CHANGE_ME|<your-|example|dummy|placeholder|xxxx+'; then
  # sólo eximir si NO hay además un patrón de clave privada real
  if ! printf '%s' "$CONTENT" | grep -qE 'BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY'; then
    exit 0
  fi
fi

declare -A REGEX=(
  ["clave privada PEM"]='-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
  ["API key estilo sk-"]='sk-[A-Za-z0-9]{20,}'
  ["token Bearer"]='Bearer +[A-Za-z0-9._-]{20,}'
  ["AWS access key id"]='AKIA[0-9A-Z]{16}'
  ["JWT"]='eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'
  ["asignación de secreto con valor"]='[A-Z_]*(SECRET|PASSWORD|TOKEN|APIKEY|API_KEY)[[:space:]]*[:=][[:space:]]*["'"'"']?[^[:space:]"'"'"']{8,}'
)
for reason in "${!REGEX[@]}"; do
  printf '%s' "$CONTENT" | grep -qE -- "${REGEX[$reason]}" && block "$reason"
done

exit 0
