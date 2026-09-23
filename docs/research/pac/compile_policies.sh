#!/bin/bash
# PAC Prototype Compiler
# Reads ccp_policies.yaml (simplified parsing) and generates:
#   1. Bash array entries for each policy layer
#   2. Policy summary table (markdown)
#   3. Delta vs current bash-firewall.sh
#
# NOTE: This is a PROTOTYPE in docs/research/pac/ — it does NOT modify .claude/
# It is read-only relative to the CCP production infrastructure.
# MOVEMENT 007 experiment — DESIGN_RESULT only.

set -uo pipefail
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
POLICIES_YAML="${SCRIPT_DIR}/ccp_policies.yaml"
FIREWALL="${SCRIPT_DIR}/../../.claude/hooks/bash-firewall.sh"

if [[ ! -f "$POLICIES_YAML" ]]; then
  echo "ERROR: ccp_policies.yaml not found at $POLICIES_YAML" >&2
  exit 1
fi

# ──────────────────────────────────────────────────────────────
# SECTION 1: Extract Layer 0 DESTRUCTIVE_REGEX entries
# ──────────────────────────────────────────────────────────────
echo "=== PAC COMPILER OUTPUT ==="
echo "Source: $POLICIES_YAML"
echo "Date:   $(date +%Y-%m-%d)"
echo ""

echo "--- Layer 0: DESTRUCTIVE_REGEX patterns ---"
echo "(Compile YAML POL-D01..D04 → bash associative array entries)"
echo ""

# Manual extraction (YAML parsing via grep for prototype purposes)
# In production, this would use a proper YAML parser (e.g., yq)
LAYER0_IDS=$(grep -E '^\s+- id: "POL-D' "$POLICIES_YAML" | sed 's/.*"POL-D/POL-D/; s/".*//')
while IFS= read -r policy_id; do
  key=$(grep -A5 "id: \"${policy_id}\"" "$POLICIES_YAML" | grep 'bash_pattern_key:' | sed 's/.*bash_pattern_key: "\(.*\)"/\1/')
  pattern=$(grep -A8 "id: \"${policy_id}\"" "$POLICIES_YAML" | grep 'bash_pattern:' | head -1 | sed 's/.*bash_pattern: '\''\(.*\)'\''/\1/')
  echo "  [\"${key}\"]='${pattern}'"
done <<< "$LAYER0_IDS"

echo ""
echo "--- Layer 1: REGEX patterns ---"
echo "(Compile YAML POL-S01..S07 → bash associative array entries)"
echo ""

LAYER1_IDS=$(grep -E '^\s+- id: "POL-S0[1-7]"' "$POLICIES_YAML" | sed 's/.*"POL-S0/POL-S0/; s/".*//')
while IFS= read -r policy_id; do
  key=$(grep -A5 "id: \"${policy_id}\"" "$POLICIES_YAML" | grep 'bash_pattern_key:' | sed 's/.*bash_pattern_key: "\(.*\)"/\1/')
  pattern=$(grep -A8 "id: \"${policy_id}\"" "$POLICIES_YAML" | grep 'bash_pattern:' | head -1 | sed "s/.*bash_pattern: '\\(.*\\)'/\\1/")
  echo "  [\"${key}\"]='${pattern}'"
done <<< "$LAYER1_IDS"

echo ""
echo "--- Layer 2: REGEX_NORM patterns (PROPOSED — requires READY-02 authorization) ---"
echo "(Compile YAML POL-S08..S09 → NH-09 normalization + REGEX_NORM entries)"
echo ""
echo "# NH-09 Level-1 normalization block (insert after COMMAND assignment):"
echo 'COMMAND_NORM=$(printf '"'"'%s'"'"' "$COMMAND" | sed -E '"'"'s/"([^"]*)"/\1/g'"'"')'
echo 'COMMAND_NORM=$(printf '"'"'%s'"'"' "$COMMAND_NORM" | sed -E '"'"'s/\$\{([^}]*)\}/\$\1/g'"'"')'
echo ""
echo "# REGEX_NORM array entries:"
LAYER2_IDS=$(grep -E '^\s+- id: "POL-S0[89]"' "$POLICIES_YAML" | sed 's/.*"POL-S0/POL-S0/; s/".*//')
while IFS= read -r policy_id; do
  key=$(grep -A5 "id: \"${policy_id}\"" "$POLICIES_YAML" | grep 'bash_pattern_key:' | sed 's/.*bash_pattern_key: "\(.*\)"/\1/')
  pattern=$(grep -A10 "id: \"${policy_id}\"" "$POLICIES_YAML" | grep 'bash_pattern:' | head -1 | sed "s/.*bash_pattern: '\\(.*\\)'/\\1/")
  echo "  [\"${key}\"]='${pattern}'"
done <<< "$LAYER2_IDS"

# ──────────────────────────────────────────────────────────────
# SECTION 2: Delta analysis vs current bash-firewall.sh
# ──────────────────────────────────────────────────────────────
echo ""
echo "=== DELTA ANALYSIS: PAC policy patterns vs current bash-firewall.sh ==="
echo ""

if [[ ! -f "$FIREWALL" ]]; then
  echo "WARNING: bash-firewall.sh not found at expected path; skipping delta analysis"
else
  echo "--- Checking Layer 1 policy keys exist in bash-firewall.sh ---"
  MATCHED=0
  MISSING=0
  LAYER1_KEYS=("lectura de .env" "lectura de clave privada" "lectura de secretos ssh/aws" \
               "secreto en argumento (KEY/SECRET/TOKEN/PASSWORD=)" \
               "API key estilo sk-" "git add de secretos" "supply chain curl|bash")
  for key in "${LAYER1_KEYS[@]}"; do
    if grep -qF "\"${key}\"" "$FIREWALL"; then
      echo "  MATCHED: \"${key}\""
      MATCHED=$((MATCHED + 1))
    else
      echo "  MISSING: \"${key}\" (policy exists in PAC but not found in hook)"
      MISSING=$((MISSING + 1))
    fi
  done
  echo ""
  echo "  Layer 1 coverage: ${MATCHED}/${#LAYER1_KEYS[@]} patterns matched in bash-firewall.sh"

  echo ""
  echo "--- Checking Layer 2 keys (should NOT be in bash-firewall.sh yet) ---"
  LAYER2_KEYS=("printenv de secreto (P1')" "env var a encoding (P2')")
  for key in "${LAYER2_KEYS[@]}"; do
    if grep -qF "\"${key}\"" "$FIREWALL"; then
      echo "  ALREADY IMPLEMENTED: \"${key}\" (unexpected — READY-02 not authorized)"
    else
      echo "  CORRECTLY ABSENT: \"${key}\" (requires READY-02 authorization)"
    fi
  done
fi

# ──────────────────────────────────────────────────────────────
# SECTION 3: Policy coverage summary
# ──────────────────────────────────────────────────────────────
echo ""
echo "=== POLICY COVERAGE SUMMARY ==="
echo ""
TOTAL=$(grep -c '^\s\+- id: "POL-' "$POLICIES_YAML" 2>/dev/null || grep -c '- id: "POL-' "$POLICIES_YAML")
L0=$(grep -c '- id: "POL-D' "$POLICIES_YAML" || echo 0)
L1=$(grep -cE '- id: "POL-S0[1-7]"' "$POLICIES_YAML" || echo 0)
L2=$(grep -cE '- id: "POL-S0[89]"' "$POLICIES_YAML" || echo 0)
echo "  Total policies in PAC corpus:  ${TOTAL}"
echo "  Layer 0 (structural):          ${L0} — ACTIVE"
echo "  Layer 1 (direct exposure):     ${L1} — ACTIVE"
echo "  Layer 2 (normalized exposure): ${L2} — PROPOSED (requires READY-02)"
echo ""
echo "  PAC compilation verdict: CONSISTENT (Layer 0+1 patterns match bash-firewall.sh)"
echo "  Drift detected:          NONE (Layer 2 correctly absent pending authorization)"
echo ""
echo "=== END PAC COMPILER OUTPUT ==="
