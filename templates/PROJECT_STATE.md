<!--
PROJECT_STATE.md — Fuente única del estado operativo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UBICAR EN: raíz del proyecto (no en .claude/)
ACTUALIZADO: por /checkpoint, /cerrar-fase, o manualmente
LO INYECTA: SessionStart hook al inicio de cada sesión

CAMPOS OBLIGATORIOS: todos los de abajo
NEXT_ALLOWED_PHASE: cambiar cuando se cierra una fase
IMPLEMENTATION_READY: true cuando el control plane está configurado
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BORRAR ESTE BLOQUE AL INSTALAR
-->

# PROJECT STATE

> Fuente única del estado OPERATIVO. La inyecta SessionStart; la consumen /estado, /gate,
> /cerrar-fase, /doctor y PreCompact. Si otro archivo describe el estado y difiere, ESTE manda.

CURRENT_PHASE:          0
PHASE_STATUS:           IN_PROGRESS
PHASE_STARTED:          {{YYYY-MM-DD}}
CURRENT_OBJECTIVE:      {{qué se está haciendo ahora}}
LAST_COMPLETED_PHASE:   NONE
BLOCKERS:               NONE
ACTIVE_DECISIONS:       NONE
PENDING_DECISIONS:      NONE
LAST_GIT_CHECKPOINT:    NONE
LAST_AUDIT:             {{YYYY-MM-DD}}
NEXT_ALLOWED_PHASE:     0 READY
IMPLEMENTATION_READY:   false
CONTROL_PLANE_VERSION:  1.0
CONFIG_SCHEMA_VERSION:  1

## Notas
- Control Plane instalado desde: https://github.com/{{tu-usuario}}/claude-control-plane
