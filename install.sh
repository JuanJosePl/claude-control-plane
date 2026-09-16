#!/bin/bash
# install.sh — Instala Claude Control Plane en un proyecto existente

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$(pwd)}"

echo "=== Claude Control Plane — Instalador ==="
echo "Destino: $TARGET"
echo ""

# Preguntar datos del proyecto
read -p "Nombre del proyecto: " PROJECT_NAME
read -p "Stack principal (node/python/go/other): " STACK

# Crear estructura
mkdir -p "$TARGET/.claude/"{hooks,skills,agents,rules,context,backups}
mkdir -p "$TARGET/docs/00_SYSTEM"

# Copiar hooks
cp "$SCRIPT_DIR/.claude/hooks/"*.sh "$TARGET/.claude/hooks/"
chmod +x "$TARGET/.claude/hooks/"*.sh

# Copiar skills de proceso/verificación
for skill in estado gate cerrar-fase checkpoint evidence adr no-go doctor audit-config audit-context recovery; do
  mkdir -p "$TARGET/.claude/skills/$skill"
  cp "$SCRIPT_DIR/.claude/skills/$skill/SKILL.md" "$TARGET/.claude/skills/$skill/"
done

# Copiar agents
cp "$SCRIPT_DIR/.claude/agents/"*.md "$TARGET/.claude/agents/"

# Copiar rules
cp "$SCRIPT_DIR/.claude/rules/"*.md "$TARGET/.claude/rules/"

# Copiar context templates
cp "$SCRIPT_DIR/.claude/context/"*.md "$TARGET/.claude/context/"

# Copiar settings.json
cp "$SCRIPT_DIR/.claude/settings.json" "$TARGET/.claude/settings.json"

# Copiar templates de raíz (sólo si no existen)
for f in CLAUDE.md PROJECT_STATE.md DECISION_REGISTRY.md ARTIFACT_MANIFEST.md; do
  [ ! -f "$TARGET/$f" ] && cp "$SCRIPT_DIR/templates/$f" "$TARGET/$f"
done

# Reemplazar placeholders básicos
sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" "$TARGET/CLAUDE.md" "$TARGET/PROJECT_STATE.md" 2>/dev/null || true

# Crear CLAUDE_SESSION_LOG vacío
touch "$TARGET/docs/00_SYSTEM/CLAUDE_SESSION_LOG.md"

echo ""
echo "✔ Claude Control Plane instalado en $TARGET"
echo ""
echo "PRÓXIMOS PASOS:"
echo "  1. Editar $TARGET/CLAUDE.md — completar las secciones marcadas con {{}}"
echo "  2. Editar $TARGET/.claude/context/CORE.md — identidad técnica del proyecto"
echo "  3. Editar $TARGET/.claude/context/BUSINESS.md — contexto comercial"
echo "  4. Editar $TARGET/.claude/context/NO_GO.md — anti-patrones del proyecto"
echo "  5. Editar $TARGET/.claude/context/SECURITY_RULES.md — restricciones de seguridad"
echo "  6. Ajustar allow-list de Bash en .claude/settings.json según tu stack"
echo "  7. Borrar los bloques <!-- INSTRUCCIONES --> de cada archivo"
echo "  8. Ejecutar /doctor en Claude Code para verificar que todo está conectado"
