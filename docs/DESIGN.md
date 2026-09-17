# DESIGN — Claude Control Plane

> Diseño de arquitectura del Engineering Control Plane. Todo se somete al gate
> **BENEFICIO > COMPLEJIDAD**.

---

## 1. Separación de responsabilidades (capas)

```
CLAUDE CODE — Engineering Control Plane
│
├── CONTEXT LAYER        (qué sabe Claude)
│   ├── CLAUDE.md            → instrucciones permanentes ≤200 líneas (guidance)
│   ├── .claude/rules/       → reglas modulares (globales o path-scoped)
│   └── .claude/context/     → context packs curados (≤150 líneas c/u)
│
├── STATE LAYER          (dónde está el proyecto) — FUENTE ÚNICA por tipo
│   ├── PROJECT_STATE.md     → estado OPERATIVO (fase, objetivo, bloqueadores)
│   ├── DECISION_REGISTRY.md → decisiones estructuradas
│   ├── ARTIFACT_MANIFEST.md → entregables esperados por fase
│   └── docs/00_SYSTEM/EVIDENCE_REGISTRY.md → evidencia de cambios con trazabilidad
│
├── MEMORY LAYER         (conocimiento persistente entre sesiones)
│   └── memory/*.md          → NO duplica context packs ni PROJECT_STATE
│
├── CONTROL LAYER        (enforcement)
│   ├── .claude/hooks/       → hooks (P0 seguridad … P3 logging)
│   └── .claude/settings.json→ permissions, hooks
│
├── EXECUTION LAYER      (quién ejecuta)
│   ├── .claude/agents/      → roles (researcher/architect/implementer/security-auditor)
│   ├── .claude/skills/      → context skills + process/verification skills
│   └── (slash commands = skills user-invocable)
│
└── VERIFICATION LAYER   (garantías)
    ├── Phase gates (/gate, /cerrar-fase)
    ├── Quality/Security gates (hooks P0, security-auditor)
    └── Recovery (/doctor, /recovery, SessionStart compact)
```

### Jerarquía de fuentes de verdad

| Tipo de información | Fuente única | NO vive en |
|---|---|---|
| Estado operativo (fase, objetivo, bloqueadores, checkpoint) | `PROJECT_STATE.md` | CLAUDE.md, memory |
| Decisiones (por qué, alternativas, reversibilidad) | `DECISION_REGISTRY.md` | memory (sólo resumen linkeado) |
| Conocimiento persistente (quién es el equipo, stack) | `memory/*.md` | PROJECT_STATE |
| Contexto curado por rol (para subagentes) | `.claude/context/*` (= skills) | body de agentes |
| Reglas permanentes / instrucciones | `CLAUDE.md` + `.claude/rules/` | duplicado en agentes |
| Entregables por fase | `ARTIFACT_MANIFEST.md` | skills (sólo referencia) |

Regla: **si dos lugares describen el mismo estado, uno está mal.**

---

## 2. Context Pack System

```
.claude/context/
├── CORE.md           → qué es el proyecto, stack, reglas fundamentales
├── CURRENT_STATE.md  → fase, objetivo, bloqueadores, último checkpoint (espejo compacto de PROJECT_STATE)
├── DECISIONS.md      → registro compacto de decisiones ACTIVAS
├── SECURITY_RULES.md → restricciones no negociables
├── BUSINESS.md       → apuesta, restricciones comerciales y legales
└── NO_GO.md          → anti-patrones prohibidos permanentemente
```

Reglas de diseño:
- Cada pack **≤150 líneas**.
- Cada pack **existe también como skill** `context-<pack>` (`user-invocable: false`) para carga
  manual y auditoria. `SubagentStart` inyecta el pack por rol; no se depende de `skills:` en agent
  frontmatter porque ese campo no tiene contrato runtime verificado.
- `CURRENT_STATE.md` es un **espejo derivado** de `PROJECT_STATE.md` (lo actualiza `/cerrar-fase`),
  no una segunda fuente: PROJECT_STATE manda; si divergen, `/audit-context` marca CONFLICT.

---

## 3. PROJECT_STATE.md — esquema (fuente única de estado operativo)

```markdown
# PROJECT STATE
CURRENT_PHASE:          N
PHASE_STATUS:           IN_PROGRESS | COMPLETE | BLOCKED
PHASE_STARTED:          YYYY-MM-DD
CURRENT_OBJECTIVE:      [una frase]
LAST_COMPLETED_PHASE:   N-1 (YYYY-MM-DD)
BLOCKERS:               [lista | NONE]
ACTIVE_DECISIONS:       [IDs]
PENDING_DECISIONS:      [IDs que requieren decisión humana]
LAST_GIT_CHECKPOINT:    [hash]
LAST_AUDIT:             YYYY-MM-DD
NEXT_ALLOWED_PHASE:     N+1 [BLOCKED | READY]
IMPLEMENTATION_READY:   true|false
CONTROL_PLANE_VERSION:  1.0
CONFIG_SCHEMA_VERSION:  1
```

Consumidores: SessionStart hook (inyecta), `/estado`, `/gate`, `/cerrar-fase`, `/doctor`, PreCompact.

---

## 4. DECISION_REGISTRY.md — esquema de registro

```
ID:        [P01 | ARCH-001 | SEC-001 | DB-001 | LEGAL-001 | CONFIG-001]
TIPO:      DIRECCIÓN | TÉCNICA | SEGURIDAD | PRODUCTO | LEGAL | INFRA | CONFIG
ESTADO:    PROPUESTA | APROBADA | RECHAZADA | SUPERADA
FECHA / APROBADA_POR:
PREGUNTA / DECISIÓN / ALTERNATIVAS_RECHAZADAS:
EVIDENCIA: (IDs de EVIDENCE_REGISTRY)
RIESGOS / REVERSIBILIDAD: FÁCIL|DIFÍCIL|IRREVERSIBLE / CONSECUENCIAS:
```

---

## 5. EVIDENCE_REGISTRY.md

`docs/00_SYSTEM/EVIDENCE_REGISTRY.md`: `EV-ID | TASK_ID | CLAIM | SOURCE | DATE | STATUS | AFFECTS |
ARTIFACT_HASH | CONTRACT_HASH | CHECKS | REVIEWER | EXCEPTIONS | TIMESTAMP`.
TaskCompleted acepta solo `VERIFIED` con hashes `sha256`, tests/static PASS, reviewer valido,
exceptions NONE o APPROVED, timestamp ISO-8601 y `Provenance` explicita.

---

## 6. ARTIFACT_MANIFEST.md

Por fase: entregables esperados / existentes / faltantes. Consumido por `/gate` y `/cerrar-fase`
para verificación automática (no declarar COMPLETE sin todos los entregables).

---

## 7. Scope Control — Matriz de ámbitos

Precedencia settings (mayor→menor): Managed → CLI `--settings` → local → project → user.

| Componente | Global (~/.claude) | Usuario | Proyecto (.claude) | Local (.local) | Agente | Task | Blast radius |
|---|---|---|---|---|---|---|---|
| settings.json | ✔ (user) | ✔ | ✔ | ✔ | — | — | user=TODOS los proyectos; project=equipo |
| CLAUDE.md | ✔ | ✔ | ✔ | — | — | — | global=todos; project=repo |
| rules/ | — | — | ✔ | — | — | — | repo (o path-scoped) |
| agents/ | (no existe) | — | ✔ | — | ✔ | — | repo |
| skills/ | ✔ | — | ✔ | — | carga por hook/uso explicito | — | repo / global |
| hooks/ | ✔ (via settings) | ✔ | ✔ | ✔ | — | — | según scope de settings |

Reglas: `deny`/`ask` aplican inmediato; `allow` esperan trust. Las listas se combinan entre scopes.

**Decisión de scope del control plane:** todo se implementa a **nivel PROYECTO** (`.claude/`), salvo
configuraciones globales deliberadas que tienen blast radius global.

---

## 8. Blast Radius — protocolo para cambios

```
CAMBIO → ¿alcance? (1 archivo | 1 agente | proyecto | TODOS los proyectos)
       → RIESGO → ¿ROLLBACK disponible? → ejecutar sólo si sí
```

| Cambio | Alcance | Rollback |
|---|---|---|
| `.claude/*` (hooks, agents, skills, rules) | proyecto | `git checkout HEAD .claude/` |
| `PROJECT_STATE.md` etc. | proyecto | git |
| `~/.claude/settings.json` | **GLOBAL** | backup previo del archivo + git no aplica |
| `~/.claude/CLAUDE.md` | **GLOBAL** | no tocar |

Regla: ningún cambio en `~/.claude/*` sin backup explícito a `.claude/backups/` primero.

---

## 9. Policy Engine (conceptual)

```
PERMISSION (¿la herramienta está permitida?) ≠ POLICY (¿debe usarse EN ESTE CONTEXTO?)

Entrada:  AGENTE + FASE + ACCIÓN + RECURSO + RIESGO
Salida:   ALLOW | ASK | DENY
```

Implementación por capas (de la más fuerte a la más débil):
1. **PERMISSION** — `permissions.deny/ask/allow` + `tools/disallowedTools` por agente (enforcement duro).
2. **POLICY contextual** — hooks PreToolUse según fase/recurso (p.ej. bloquear escritura fuera de `docs/` para un researcher).
3. **GUIDANCE** — CLAUDE.md/rules (recordatorio, puede perderse en contexto largo).

Ejemplo: researcher tiene `disallowedTools: [Write, Edit, Bash]` (PERMISSION) → ni siquiera llega
a POLICY. security-auditor sólo lectura. implementer puede Bash pero bash-firewall (POLICY P0) filtra.

---

## 10. Fail-safe por defecto

- Cuando Claude no puede verificar algo → estado **`UNKNOWN`**, nunca "probably fine".
- Hooks de seguridad (P0) → **FAIL_CLOSED**. Hooks de automatización/logging (P2/P3) → **FAIL_OPEN**.
- `/gate` ante duda → **BLOCKED** (no permite avanzar).
- `/doctor` ante componente no verificable → **WARNING** o **ERROR**, no HEALTHY.

---

## 11. Mapa de decisiones de arquitectura de referencia

| ID propuesto | Decisión |
|---|---|
| ARCH-001 | `PROJECT_STATE.md` como fuente única de estado operativo |
| ARCH-002 | Context packs = skills `user-invocable:false`, bootstrap por `SubagentStart.additionalContext` |
| ARCH-003 | Enforcement crítico en hooks P0 (no sólo CLAUDE.md) |
| ARCH-004 | SessionStart con matchers separados startup/resume vs compact |
| ARCH-005 | Todo a nivel proyecto salvo corrección puntual de configuración global (con backup) |
