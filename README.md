# Claude Control Plane

Engineering Control Plane para Claude Code. Convierte cualquier proyecto en un sistema
observable, reversible, seguro y predecible al trabajar con agentes de IA.

En lugar de depender de prompts sueltos o memoria volátil, este repo instala una infraestructura
de 5 capas (Context, State, Memory, Control, Execution) que guía a Claude Code desde el arranque
hasta el cierre de cada sesión. El principio de diseño es simple: **BENEFICIO > COMPLEJIDAD** en
cada componente. Si algo no aporta control real, no va aquí.

## Instalación rápida

```bash
git clone https://github.com/tu-usuario/claude-control-plane.git
cd claude-control-plane
bash install.sh /ruta/a/mi-proyecto
```

El instalador copia hooks, skills, agentes, reglas, context packs y templates de estado a tu
proyecto. No modifica tu código de producción.

## Qué incluye

| Componente | Cantidad | Para qué sirve |
|---|---|---|
| Hooks | 9 | Automatización, seguridad (P0), logging y recuperación de contexto |
| Skills de proceso/verificación | 11 | Comandos operativos como `/estado`, `/gate`, `/doctor`, `/recovery` |
| Agent templates | 4 | Roles parametrizados: researcher, architect, implementer, security-auditor |
| Rules | 4 | Reglas globales de seguridad, git, no-go y compliance |
| Context packs | 6 | Templates auto-documentados: CORE, BUSINESS, NO_GO, SECURITY_RULES, CURRENT_STATE, DECISIONS |
| Templates raíz | 4 | `CLAUDE.md`, `PROJECT_STATE.md`, `DECISION_REGISTRY.md`, `ARTIFACT_MANIFEST.md` |
| `settings.json` | 1 | Permisos, hooks y configuración de seguridad lista para adaptar |

## Setup en 8 pasos

Después de correr `install.sh`:

1. Edita `CLAUDE.md` en la raíz del proyecto y completa las secciones marcadas con `{{}}`.
2. Edita `.claude/context/CORE.md` con la identidad técnica real del proyecto.
3. Edita `.claude/context/BUSINESS.md` con la apuesta comercial y restricciones.
4. Edita `.claude/context/NO_GO.md` con los anti-patrones específicos del proyecto.
5. Edita `.claude/context/SECURITY_RULES.md` con los controles de seguridad reales.
6. Ajusta el allow-list de Bash en `.claude/settings.json` según tu stack.
7. Borra los bloques `<!-- INSTRUCCIONES -->` de cada archivo.
8. Ejecuta `/doctor` en Claude Code para verificar que todo está conectado.

## Comandos del control plane

| Comando | Cuándo usarlo |
|---|---|
| `/estado` | Ver fase actual, bloqueantes, decisiones activas y últimas actividades |
| `/gate` | Verificar que la fase actual puede cerrarse |
| `/cerrar-fase` | Cerrar fase, actualizar estado y crear commit estructurado |
| `/checkpoint` | Crear un commit de seguridad manual en cualquier momento |
| `/doctor` | Health check completo del control plane |
| `/audit-config` | Verificar que `settings.json` cumple el esquema esperado |
| `/audit-context` | Detectar divergencias entre fuentes de verdad |
| `/evidence` | Registrar evidencia con trazabilidad |
| `/adr` | Registrar una decisión arquitectónica |
| `/no-go` | Verificar si una acción viola anti-patrones |
| `/recovery E-{N}` | Ejecutar protocolo de recuperación para errores conocidos |

## Arquitectura

```
CLAUDE CODE — Engineering Control Plane
│
├── CONTEXT LAYER        (qué sabe Claude)
│   ├── CLAUDE.md            → instrucciones permanentes del proyecto
│   ├── .claude/rules/       → reglas modulares globales
│   └── .claude/context/     → context packs curados por rol
│
├── STATE LAYER          (dónde está el proyecto)
│   ├── PROJECT_STATE.md     → estado operativo (fuente única)
│   ├── DECISION_REGISTRY.md → decisiones estructuradas
│   ├── ARTIFACT_MANIFEST.md → entregables por fase
│   └── EVIDENCE_REGISTRY.md → investigaciones con trazabilidad
│
├── MEMORY LAYER         (conocimiento persistente)
│   └── memory/*.md          → NO duplica state ni context packs
│
├── CONTROL LAYER        (enforcement)
│   ├── .claude/hooks/       → P0 FAIL_CLOSED + P1/P2 FAIL_OPEN
│   └── .claude/settings.json→ permisos, hooks, skill overrides
│
├── EXECUTION LAYER      (quién ejecuta)
│   ├── .claude/agents/      → roles especializados
│   ├── .claude/skills/      → context skills + process skills
│   └── slash commands       → skills user-invocable
│
└── VERIFICATION LAYER   (garantías)
    ├── Phase gates (/gate, /cerrar-fase)
    ├── Quality/Security gates (hooks P0, security-auditor)
    └── Recovery (/doctor, /recovery, SessionStart compact)
```

## Archivos a personalizar

| Archivo | Qué contiene | Tiempo estimado |
|---|---|---|
| `CLAUDE.md` | Instrucciones raíz del proyecto para Claude Code | 10 min |
| `.claude/context/CORE.md` | Stack, módulos, convenciones, fuentes de verdad | 15 min |
| `.claude/context/BUSINESS.md` | Apuesta comercial, prioridades, restricciones legales | 15 min |
| `.claude/context/NO_GO.md` | Anti-patrones permanentes del proyecto | 10 min |
| `.claude/context/SECURITY_RULES.md` | Controles de acceso, auth, validación de inputs | 15 min |
| `.claude/settings.json` | Permisos de Bash y wiring de hooks | 10 min |
| `DECISION_REGISTRY.md` | Decisiones tomadas con evidencia y reversibilidad | ongoing |
| `ARTIFACT_MANIFEST.md` | Entregables esperados por fase | ongoing |

## Cómo funciona el engranaje

1. **Arranque de sesión**: `SessionStart` dispara `session-start-startup.sh` (o `session-start-compact.sh`
   si la sesión se recupera de una compactación). El hook lee `PROJECT_STATE.md` y lo inyecta como
   contexto adicional.
2. **Cada comando Bash o Write/Edit**: `PreToolUse` ejecuta `bash-firewall.sh` y `secret-guard.sh`
   para bloquear comandos destructivos o escritura de secretos.
3. **Subagentes**: `SubagentStart` inyecta el estado actual; el frontmatter de cada agente carga las
   context skills apropiadas (`context-core`, `context-security`, etc.).
4. **Cierre de sesión**: `Stop` y `SubagentStop` registran actividad en `CLAUDE_SESSION_LOG.md`.
5. **Compactación**: `PreCompact` hace snapshot de `PROJECT_STATE.md` antes de comprimir contexto.
6. **Comandos operativos**: `/estado`, `/gate`, `/cerrar-fase`, `/doctor`, etc., son skills que leen
   y actualizan las fuentes de verdad.

## Limitaciones conocidas

Este control plane asume ciertos comportamientos de Claude Code que debes verificar en tu versión:

1. `SubagentStart.additionalContext` llega efectivamente al subagente (CP-004).
2. El campo `skills:` en el frontmatter de un agente carga las skills indicadas.
3. Los hooks `PreToolUse` reciben suficiente información para bloquear con `exit 2`.
4. Los matchers separados de `SessionStart` (`startup|resume|fork` vs `compact|clear`) se disparan correctamente.
5. El hook `ConfigChange` se activa al modificar `.claude/settings.json` o configuración de proyecto.

Si alguna no se cumple, ajusta el wiring en `settings.json` o elimina el componente dependiente.

---

*Claude Control Plane v1.0 — Engineering infrastructure for Claude Code*
