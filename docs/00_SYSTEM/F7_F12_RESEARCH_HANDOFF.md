# F7–F12 RESEARCH HANDOFF — Claude Control Plane

**Fecha:** 2026-09-18
**Baseline commit:** `b6e8fd0` (working tree con 6 docs mod + 4 untracked, todos benignos)
**Estado:** RESEARCH · AUDIT · RECONCILIATION · NO IMPLEMENTATION
**Alcance:** post-F6 · post-roadmap (2026-09-17) · post-behavioral-audit (2026-09-18)
**Regla suprema:** `BENEFIT > COMPLEXITY` · `EVIDENCE > CLAIM` · `TRUTH > OPTIMISM`
**Preserva:** POST_F6_AUDIT_REPORT · BEHAVIORAL_RELIABILITY_AUDIT · MASTER_EVOLUTION_ROADMAP · EV-001…EV-008 · INC-001/CTRL-001/REG-001 · F1–F6 status.

> **Contrato de este documento:** consolidacion de investigacion que reconcilia el runtime actual
> contra el roadmap propuesto (2026-09-17) y el audit adversarial (2026-09-18). Sirve como
> INPUT CONTRACT para la proxima ejecucion de implementacion. No autoriza cambios de runtime.
> Ningun hook, skill, agent, registry, wiring o permiso se modifica durante esta ejecucion.

---

## A. EXECUTIVE SYSTEM DIAGNOSIS

**Salud del sistema (dimensiones ampliadas):**

| Dimension | Score | Evidencia |
|---|---|---|
| Healthy (checks pass) | ✔ | `maintenance.sh 9/9 PASS`, `state=PASS drift=DETECTED`, `INC-001 PASS` (2026-09-18) |
| Behaviorally resilient | ✘ | F-LOOP-01 confirmado en runtime `.claude/hooks/stop-logger.sh:16` |
| Idempotent | ✘ | Stop hook + rotacion no idempotentes |
| Non-looping | ✘ | F-LOOP-01: 9 turnos consumidos en sesion previa |
| Low-noise | ✘ | F-LOOP-01 · F-ROTATION-01 · fantasmas SubagentStop |
| Recoverable | ✔ | git + snapshot precompact + skill `/recovery` |
| Evidence-trustworthy | ✘ | F-FALSE_PASS-01 confirmado en `task-completed-evidence.sh:42` |

**4 de 7 dimensiones fallan.** Todas corregibles con ~50 LOC bash + 5 fixtures + 1 ADR. F1–F6
permanecen INTACTAS bajo el estandar clasico (`maintenance PASS`).

**Diagnostico:** el sistema es estructuralmente correcto (arquitectura + fases + evidencia
historica), pero tiene 5 defectos comportamentales P1 con reproducer 100% que erosionan la
garantia real de sus mecanismos. La cobertura de F7 propuesta (roadmap) resuelve solo 2 de 5
P1 comportamentales. **Se requiere reconciliar F7 con F7a antes de habilitar implementacion.**

---

## B. BASELINE (G0 · VERIFIED)

**Comandos ejecutados esta sesion (2026-09-18 12:47):**

```
bash evals/maintenance.sh          → 9/9 PASS
bash evals/state/state-integrity.sh → unchanged=PASS drift=DETECTED
bash evals/incidents/INC-001-*.sh   → without_control=UNPROTECTED with_control=BLOCKED
```

**Git state:**
- Branch: `main` (up-to-date con origin)
- HEAD: `b6e8fd0 docs(context): add canonical Claude bootstrap instructions`
- Working tree: 6 docs modificados (`.claude/skills/recovery/SKILL.md`, `PROJECT_STATE.md`,
  `README.md`, `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`, `docs/CONTROL_PLANE_HANDBOOK.md`,
  `docs/MASTER_IMPLEMENTATION_PLAN.md`) + 4 untracked benignos
  (`BEHAVIORAL_RELIABILITY_AUDIT.md`, `POST_F6_AUDIT_REPORT.md`, `archive/`,
  `MASTER_EVOLUTION_ROADMAP.md`).

**Runtime inventory:**
- 10 hooks (`.claude/hooks/`) `+x` — listados en §C.
- 5 agentes (`.claude/agents/`) con tool limits.
- 22 skills (`.claude/skills/`) — 6 context + 16 process.
- 4 rules (`.claude/rules/`).
- 6 context packs (`.claude/context/`).
- 5 registries canonicos (evidence · incident · control · regression · decision) + `PROJECT_STATE`
  + `ARTIFACT_MANIFEST`.
- 1 CI workflow (`.github/workflows/control-plane.yml`).
- 8 evidencias VERIFIED (EV-001…EV-008) + 1 schema.
- 3 decisiones activas (ARCH-001 · ARCH-002 · ARCH-003).
- 1 incidente cerrado con control + regresion (INC-001 · CTRL-001 · REG-001).

**PROJECT_STATE:**
- `CURRENT_PHASE: 6 · PHASE_STATUS: COMPLETE`.
- `LAST_COMPLETED_PHASE: 6 (2026-09-17)`.
- `LAST_AUDIT: 2026-09-18 · LAST_BEHAVIORAL_AUDIT: 2026-09-18`.
- `NEXT_ALLOWED_PHASE: NONE · IMPLEMENTATION_READY: true`.

**Baseline resultado:** GREEN bajo standard `maintenance PASS`. AMBER bajo standard extendido
(behavioral resilience). Research puede continuar sin bloqueo.

---

## C. RUNTIME INVENTORY (G1 · VERIFIED)

### C.1 Hooks (10)

| Hook | Evento | Matcher | Criticidad | Fail mode | Status |
|---|---|---|---|---|---|
| `bash-firewall.sh` | PreToolUse | `Bash` | P0 | FAIL_CLOSED | ✔ Activo · **BUGS: F-BYPASS-01/02/03** |
| `secret-guard.sh` | PreToolUse | `Write\|Edit` | P0 | FAIL_CLOSED | ✔ Activo · sin bugs confirmados |
| `task-completed-evidence.sh` | TaskCompleted | (any) | P0 | FAIL_CLOSED | ✔ Activo · **BUG: F-FALSE_PASS-01** |
| `subagent-context.sh` | SubagentStart | `*` | P1 | FAIL_OPEN | ✔ Activo · sin bugs |
| `subagent-stop-logger.sh` | SubagentStop | `*` | P2 | FAIL_OPEN | ✔ Activo · **BUGS: F-ROTATION-01, F-DATA-01, fantasmas** |
| `session-start-startup.sh` | SessionStart | `startup\|resume\|fork` | P1 | FAIL_OPEN | ✔ Activo · sin bugs |
| `session-start-compact.sh` | SessionStart | `compact\|clear` | P1 | FAIL_OPEN | ✔ Activo · sin bugs |
| `pre-compact-snapshot.sh` | PreCompact | `manual\|auto` | P1 | FAIL_OPEN | ✔ Activo · sin bugs |
| `config-change-logger.sh` | ConfigChange | `*` | P2 | FAIL_OPEN | ✔ Activo · sin bugs |
| `stop-logger.sh` | Stop | `*` | P2 | FAIL_OPEN | ✔ Activo · **BUG: F-LOOP-01** |

### C.2 Agents (5)

| Agent | Rol | Tools permitidos | Notas |
|---|---|---|---|
| `architect` | Diseño de modulos | `Read, Glob, Grep, Write, Edit` | Write limitado a docs/context |
| `code-reviewer` | Revision independiente | `Read, Glob, Grep` | Sin razonamiento del implementer |
| `implementer` | Implementacion codigo | `Read, Glob, Grep, Write, Edit, Bash` | Full stack |
| `researcher` | Investigacion web | `Read, Glob, Grep, WebSearch, WebFetch` | Sin Write producto |
| `security-auditor` | OWASP audit | `Read, Glob, Grep` | Solo lectura |

### C.3 Skills (22)

- **Context (6):** `context-business`, `context-core`, `context-current-state`,
  `context-decisions`, `context-no-go`, `context-security`. Cargados por SubagentStart.
- **Verification (7):** `audit-config`, `audit-context`, `doctor`, `gate`, `evidence`,
  `no-go`, `recovery`.
- **Workflow (5):** `code-review-and-quality`, `constraint-driven-development`,
  `doubt-driven-development`, `test-driven-development`, `incident`.
- **Operational (4):** `adr`, `cerrar-fase`, `checkpoint`, `estado`.

### C.4 Registries y estado canonico

| Fuente | Tipo | Entradas reales | Estado |
|---|---|---|---|
| `PROJECT_STATE.md` | State | 1 | ✔ Fresh (LAST_AUDIT 2026-09-18) |
| `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | Evidence | 8 + schema | ✔ Intacta |
| `INCIDENT_REGISTRY.md` | Incident | 1 + schema | ✔ INC-001 CLOSED |
| `CONTROL_REGISTRY.md` | Control | 1 + schema | ✔ CTRL-001 ACTIVE |
| `REGRESSION_REGISTRY.md` | Regression | 1 + schema | ✔ REG-001 ACTIVE |
| `DECISION_REGISTRY.md` | Decision | 3 (ARCH-001/002/003) | ✔ Consistente con context/DECISIONS.md |
| `ARTIFACT_MANIFEST.md` | Deliverables | 6 fases ✔ | ✔ Sincronizado |

### C.5 CI

- `.github/workflows/control-plane.yml` corre `evals/maintenance.sh`. Determinista, sin
  autenticacion LLM. Confirmado runtime PASS.

### C.6 Session log

- `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`: **246 lineas** (>30 threshold pero sin truncar —
  confirma F-ROTATION-01a).
- `docs/00_SYSTEM/archive/CLAUDE_SESSION_LOG.2026-09.md` presente (rotacion parcial
  activada).

---

## D. ACTUAL RUNTIME GRAPH (G1 · VERIFIED)

```text
USER INTENT
   |
   v
CLAUDE (main agent)  ← SubagentStart → context packs por rol → SubagentStop → log
   |
   +--- PreToolUse ---+
   |                  |
   |         Bash → bash-firewall.sh   [P0 FAIL_CLOSED]
   |         Write/Edit → secret-guard.sh [P0 FAIL_CLOSED]
   |
   v
TOOL EXEC (bash / Write / Edit / Read / etc.)
   |
   v
ARTIFACT (code / doc / registry entry)
   |
   +--- (opcional humano) → `/evidence` skill → EVIDENCE_REGISTRY entry
   |
   v
TASK MARKED completed  → TaskCompleted → task-completed-evidence.sh [P0 FAIL_CLOSED]
   |                                       └── awk match task_id + VERIFIED + hashes
   v
GATE (PASS / BLOCK)
   |
   +--- PreCompact → pre-compact-snapshot.sh → hash critico + backup
   |
   +--- SessionStart:compact → session-start-compact.sh → verify hash → PASS|DRIFT
   |
   +--- Stop → stop-logger.sh → si PROJECT_STATE mtime != hoy → additionalContext (LOOP if repeated)
   |
   +--- ConfigChange → config-change-logger.sh → log
   |
   v
NEXT ACTION / SESSION END
```

**Trust boundaries identificados:**
1. Main agent puede editar `.claude/hooks/*.sh` (secret-guard bloquea solo strings de secret,
   no debilitamiento estructural del hook). Riesgo F-SELFMOD-01 P2.
2. Main agent puede editar `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` (revision humana es la
   ultima linea). Riesgo G-N4/G-N5 documentado DEFER.
3. Fixtures escritos por el mismo equipo que las skills → mitigado por `code-reviewer` con
   fresh-context. Riesgo residual bajo.

**Ordering assumptions:** PreCompact debe ejecutar antes que SessionStart:compact (garantizado
por runtime Claude Code). install.sh copia hooks antes de settings.json.

**Race opportunities:** solo teoricas (SubagentStop concurrente); no observadas en runtime
single-user.

---

## E. BEHAVIORAL RELIABILITY FINDINGS (G2 · REFERENCE BEHAVIORAL_RELIABILITY_AUDIT.md)

**Fuente canonica:** `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md` (2026-09-18, 39 secciones,
780 lineas). Este handoff **no duplica** su contenido; lo referencia con verdicts actualizados.

**Hallazgos (11):**

| ID | Categoria | Severity | Reproduccion (esta sesion) | Fix bundle |
|---|---|---|---|---|
| G-B1 / F-LOOP-01 | LOOP | P1 | ✔ VERIFIED — código en `stop-logger.sh:16` sin lectura de `stop_hook_active` | A (anti-loop) |
| G-B2 / F-BYPASS-01 | SECURITY | P1 | ✔ VERIFIED — `bash-firewall.sh:26` literales `grep -qF` no toleran doble espacio | B (firewall) |
| G-B3 / F-BYPASS-02 | SECURITY | P1 | ✔ VERIFIED — `bash-firewall.sh:29` `"DROP TABLE"` `grep -qF` case-sensitive | B (firewall) |
| G-B4 / F-BYPASS-03 | SECURITY | P1 | ✔ VERIFIED — `bash-firewall.sh:42-44` regex no cubre `source \| . \| eval` de `.env` | B (firewall) |
| G-B5 / F-FALSE_PASS-01 | EVIDENCE | P1 | ✔ VERIFIED — `task-completed-evidence.sh:42` matches `task_id` solo, sin coupling a la tarea actual | C (evidence coupling) |
| G-B6 / F-FALSE_BLOCK-01 | INTERACTION | P2 | ✔ VERIFIED — fixtures propios del firewall/secret-guard son bloqueados por los mismos hooks | — (no fix, mitigar via install) |
| G-B7 / F-INSTALL-01 | INSTALL | P2 | ✔ VERIFIED — install.sh reinstala settings.json incondicionalmente | E (install idempotency) |
| G-B8 / F-ROTATION-01 | NOISE + STATE | P2 | ✔ VERIFIED — `subagent-stop-logger.sh:31` usa `cp` no `mv`; archive mensual sobreescribe | D (rotation) |
| G-B9 / F-DATA-01 | DATA | P3 | ✔ VERIFIED — jq idiom `.agent_type // "subagent"` no cubre string vacio | — (cosmetico) |
| G-B10 / F-SELFMOD-01 | SECURITY | P2 (mitigado) | Teorico · git diff humano mitiga | DEFER |
| G-B11 / Fantasmas SubagentStop | STATE + SESSION | P3 | Suspected · sin causa determinada | Investigar |

**Total nuevo (relative al roadmap 2026-09-17):** 11 hallazgos comportamentales. 5 P1 son
nuevos respecto al gap register post-F6 (G-B1…G-B5) o **expanden** gaps existentes:
- G-B5 expande G-V1/G-Bob-2 (evidence gate erosion) con caso reproducible mas grave.
- G-B2/G-B3/G-B4 son gaps de seguridad activa nuevos, no cubiertos por G-T1 (fixtures positivos).

**Ningun bug erosiona F1–F6 evidence historica.** EV-001…EV-008 permanecen VERIFIED (verificado
por maintenance PASS post-audit).

**Clasificacion de finding:**
- FACT (10): G-B1 a G-B8 + G-B9 confirmados en runtime esta sesion.
- SUSPECTED (1): G-B11 fantasmas — requiere reproduccion determinista.

---

## F. STOP / LOOP / REENTRANCY FINDINGS

**F-LOOP-01 es el bug mas critico observado empiricamente esta sesion.** Reproducido en la
sesion previa: 9 turnos consumidos por el mismo recordatorio. Root cause: `stop-logger.sh:16`
compara `date -r $STATE` contra `date +%Y-%m-%d` sin leer `stop_hook_active` del payload JSON.

**Otros loops candidatos investigados:**
- SubagentStart → SubagentStop → SubagentStart: no observado (runtime no auto-relanza).
- PostToolUseFailure → retry → PostToolUseFailure: N/A (no configurado, G-L1 DEFER).
- ConfigChange → hook modifica settings → ConfigChange: teorico, no observado.

**Conclusion:** F-LOOP-01 es el unico loop reproducible. Rate limiting via `stop_hook_active` es
el fix documental estandar (~4 LOC).

---

## G. SECURITY / TRUST FINDINGS (G3)

### G.1 Bypasses del bash-firewall (P1 · nuevos)

| ID | Vector | Evidencia |
|---|---|---|
| F-BYPASS-01 | `rm  -rf  /` (doble espacio) | `bash-firewall.sh:26` `grep -qF -- "rm -rf /"` no matchea espacios variables |
| F-BYPASS-02 | `drop table users` (lowercase) | `bash-firewall.sh:29` `"DROP TABLE"` con `grep -qF` (case-sensitive) |
| F-BYPASS-03 | `source .env` o `. .env` | `bash-firewall.sh:42` regex `(cat\|less\|more\|head\|tail\|bat)` no cubre `source \| . \| eval \| read \| exec` |

**Impacto real:** un agente adversarial (o error inocente) puede ejecutar comandos destructivos
o exfiltrar `.env` con estos patrones. Sin evidencia de explotacion. Bypass real.

### G.2 Evidence gate erosion (G-B5 · P1 · nuevo)

`task-completed-evidence.sh:42` matches `task_id` solo. Cualquier tarea NUEVA puede citar
`task_id=F1-foundation-2026-09-16` (historico VERIFIED) para pasar el gate. **Confirma y
expande G-V1/G-Bob-2 del roadmap.**

### G.3 Trust boundary preservada

- `secret-guard` bloquea secretos textuales pero **no** el debilitamiento estructural del hook
  (F-SELFMOD-01 P2 mitigado por revision humana).
- Fixtures escritos por el mismo equipo → mitigado por `code-reviewer` fresh-context (EV-005).

### G.4 MCP / prompt injection

- No usamos MCP → no aplicable.
- Prompt injection defense estructural: DEFER (roadmap §13).

---

## H. EVIDENCE INTEGRITY FINDINGS

**Debilidades confirmadas:**

1. **Hash no recomputado** (`task-completed-evidence.sh:44-45`): valida formato sha256, no
   coincidencia con artefacto real. Editar registry + editar artefacto pasa.
2. **Timestamp sin freshness** (`task-completed-evidence.sh:50`): un timestamp de hace un año
   sigue aceptado.
3. **Coupling roto** (G-B5): `task_id` historico reusable ad infinitum.
4. **Reviewer sin identidad** (`task-completed-evidence.sh:47`): `Reviewer: PASS` es texto libre.
5. **Provenance sin traza a input**: `GENERATED` no vincula a run/fixture especifico.

**Fortalezas confirmadas:**

- Contract hash consistente en toda la evidencia (EV-001…EV-008 comparten `contract_hash` sha256
  cuando aplica).
- Provenance semantica explicita (5 valores).
- Reviewer PASS registrado para riesgo medium+.

**Freshness policy:** NO EXISTE. Confirma G-V1/G-Bob-2 P1 del roadmap.

---

## I. EVIDENCE LINEAGE / FRESHNESS FINDINGS

**Traza actual (evidencia F1–F6):**
```
TASK (task_id)
  ↓
ARTIFACT (con Artifact Hash sha256)
  ↓
TEST/EVAL (execution real, GENERATED)
  ↓
EVIDENCE (Contract Hash sha256, Reviewer, Timestamp, Provenance)
  ↓
REGISTRY (append-only por convention, no por enforcement)
  ↓
STATE (PROJECT_STATE.md · LAST_COMPLETED_PHASE)
```

**Rerun semantics NO DEFINIDA:** un rerun de Tier 3 genera nuevo `session_id` en el JSON de
resultado, pero maintenance NO verifica que sea nuevo. Confirma G-Bob-2.

**Invalidation rules NO DEFINIDAS:** cambios a source/test/evaluator/prompt/config no
invalidan evidencia previa. La reincorporacion de un `contract_hash` obsoleto pasa.

**Recomendacion (post-implementacion F7):** `maintenance.sh` verifica:
- `session_id` no reutilizado entre corridas Tier 3 consecutivas.
- `timestamp` no anterior a N dias configurables (default 30).

**No invalidation TTL sofisticado** — dependency-based es suficiente.

---

## J. TASK CONTRACT FINDINGS

**Gap G-D3 (P1) confirmado:** `TaskCompleted` no distingue:
- CONTRACTUAL TASK (fase, evidencia contractual EV-NNN)
- INTERNAL TODO (scaffolding, checklist item, subtarea de tracker)

**Consecuencia:** 11 subtareas scaffolding requerian 11 EV-NNN artificiales → borradas via
tracker delete. Documentado en Handbook §12.

**Formal Task Contract:** NO NECESARIO como codigo. Convention documental via ADR-004 es
suficiente. Cero implementacion. Ver §31.2 del roadmap.

**Campos minimos que necesitaria un Task Contract si se formalizara:**
- `task_id` (unico por sesion) — hoy no unico.
- `risk_level` — hoy sirve.
- `contract_hash` — hoy existe en registry, no en payload TaskCompleted.
- `contractual: true/false` — hoy no existe.

**Recomendacion:** ADR-004 documenta convention. No cambia hook. Cero LOC.

---

## K. EXECUTION IDENTITY FINDINGS

**Identidad actual:** solo `task_id` (usado como pivot para el gate). No hay:
- `session_id` en el payload TaskCompleted (Tier 3 lo tiene interno)
- `run_id`, `attempt_id`, `evaluation_id`, `evidence_id`, `artifact_id`, `checkpoint_id`

**Colisiones posibles:**
- Task IDs pueden repetirse entre fases (no hay uniqueness enforcement).
- `session_id` de Tier 3 NO verificado por freshness (G-Bob-2).

**Modelo minimo requerido:**
- `task_id` unico por tarea contractual (marca temporal + hash).
- `session_id` unico por corrida CLI autenticada.
- `evidence_id` (`EV-NNN`) unico secuencial.

**Fix propuesto:** post-F7, task_id incluye marca temporal (`F7-evidence-integrity-2026-XX-XX-<hash>`).
Convention via ADR-004. Cero cambio de codigo hoy.

---

## L. STATE MACHINE FINDINGS

**Estados observados en runtime:**

```text
PROJECT_STATE:  PLANNING → EXECUTING → COMPLETE (por fase)
INCIDENT:       OPEN → INVESTIGATING → REGRESSION_ADDED → CLOSED
CONTROL:        PROPOSED → ACTIVE (post CTRL-001)
REGRESSION:     PROPOSED → ACTIVE (post REG-001)
EVIDENCE:       PROPOSED → VERIFIED (o BLOCKED, REJECTED)
```

**Transiciones formalizadas:** documentadas en registries. Sin state machine explicita en
codigo (todos los estados son campos de texto Markdown validados por convention).

**Illegal transitions detectadas:** ninguna. Se validan por convention documentada.

**Missing transitions:** ROLLED_BACK, RECOVERING, ABORTED, SUPERSEDED existen conceptualmente
(Handbook §12) pero no aparecen en registries hoy. Documental, no operacional.

**Dead states:** ninguno.

**Loops:** F-LOOP-01 en Stop hook es un pseudo-loop en el sentido de que el runtime re-invoca
al asistente indefinidamente. No es un dead state en state machine.

---

## M. SCOPE / SIDE-EFFECT / RISK FINDINGS

**Scope drift historico:** documentado en session (S232) — 11 subtareas scaffolding
requerian EV-NNN → borradas (correcto). No hubo drift no autorizado.

**Side effects actuales por hook:**

| Hook | Side effect class | Reversible |
|---|---|---|
| `bash-firewall.sh` | READ_ONLY (block only) | N/A |
| `secret-guard.sh` | READ_ONLY (block only) | N/A |
| `task-completed-evidence.sh` | READ_ONLY (block only) | N/A |
| `subagent-context.sh` | READ_ONLY (inject context) | N/A |
| `subagent-stop-logger.sh` | LOCAL_MUTATION (log append + cp archive) | ✔ git |
| `session-start-*.sh` | READ_ONLY | N/A |
| `pre-compact-snapshot.sh` | LOCAL_MUTATION (backup) | ✔ git |
| `config-change-logger.sh` | LOCAL_MUTATION (log append) | ✔ git |
| `stop-logger.sh` | READ_ONLY (emit context) | N/A |

**Ningun hook es DESTRUCTIVE o IRREVERSIBLE.** Todos los cambios de estado son locales +
trackeables por git.

**Escalation risk:** `install.sh` reinstala settings.json incondicionalmente (F-INSTALL-01).
Es LOCAL_MUTATION reversible, pero silenciosa. P2.

---

## N. EXCEPTION / BYPASS FINDINGS

**Overrides / bypass identificados:**

- **DRY_RUN=true** en `bash-firewall.sh`: no bloquea, solo imprime. Solo utilizable via env
  override (no accesible desde el agente por PreToolUse). Riesgo bajo.
- **`permissions.ask`** para `git push`, `rm *`: requiere human approval en runtime. Log
  no automatizado.
- **Firewall bypass real (P1):** F-BYPASS-01/02/03 no son overrides autorizados; son
  vulnerabilidades.
- **Evidence gate bypass real (P1):** F-FALSE_PASS-01 no es override autorizado;
  es coupling roto.

**El modelo NO puede grantear bypass autonomo.** Todos los bypass requieren edit humano de
settings o hooks (mitigado por revision humana + git diff). G-N4/G-N5 DEFER.

---

## O. ROLLBACK / RECOVERY FINDINGS

**Mecanismos disponibles:**
- `git revert` per-commit.
- `LAST_GIT_CHECKPOINT` en PROJECT_STATE.
- `pre-compact-snapshot.sh` → `.claude/backups/PROJECT_STATE.precompact.md` + hash critico.
- `/recovery` skill (9 escenarios en Handbook §12).
- Rollback especifico de controles en `CONTROL_REGISTRY.md:29` (documentado, no ejecutado — G-S1
  P2).

**Rollback NUNCA ejecutado:** G-S1 P2 (roadmap). Un rollback documentado sin smoke tiene el
mismo riesgo que un test que nunca corre.

**Rollback escape ambiguo:** G-S2 P2 (`sed '/^[[:space:]]*\\/\\//d'` en CTRL-001 — riesgo de
copy-paste fail).

**Recovery escenarios (E-1…E-9):** documentados, no testeados. Aceptable como guidance.

---

## P. HUMAN-CHECKPOINT FINDINGS

**Human waits observados:**
- `permissions.ask` para `git push`, `rm *`.
- Owner decision go/no-go para F7, F7a, ADR-004.

**F-LOOP-01 se dispara cuando el humano espera decision sin actualizar PROJECT_STATE.md.** Sin
distincion entre "sesion nueva sin update" vs "waiting for approval". Confirma que el hook
Stop necesita reconocer estado explicito de wait.

**Fix conceptual (F7a):** el hook debe leer un archivo/campo `.claude/state/waiting` (o
similar) antes de emitir reminder. NO IMPLEMENTAR.

---

## Q. INCIDENT / REGRESSION / ESCAPED DEFECT FINDINGS

**Ciclo INC-001 → CTRL-001 → REG-001:**
- Verificado end-to-end via `evals/incidents/INC-001-task-completed-evidence.sh`.
- `without_control=UNPROTECTED / with_control=BLOCKED` reproducible.
- Reviewer PASS (EV-006).
- Rollback documentado (no ejecutado — G-S1).

**Escaped defects (bugs de F-LOOP-01, F-BYPASS-01/02/03, F-FALSE_PASS-01):** son escaped
defects reales — pasaron todos los controles existentes y fueron descubiertos solo por
adversarial testing (BEHAVIORAL_RELIABILITY_AUDIT). **Confirman que el ciclo `/incident` funciona
por diseño para incidentes reactivos, pero no cubre proactive defect discovery.** OK — no
requiere fix.

**Regresion budget:** 1 sample (REG-001). G-T2 DEFER (roadmap). Correcto no fabricar.

---

## R. EVALUATION FINDINGS

**Tier 1 (structural):** `evals/skills/validate.sh` — baseline explicito, `bash -n` en hooks.
Pasa.

**Tier 2 (routing):** `evals/skills/fixtures.json` — 4 skills, positive/negative/collision. Pasa.

**Tier 3 (behavioral):** `evals/skills/results/F3-tier3-run-*.json` — 2 corridas CLI
autenticadas con firma normalizada identica. **GAP:** snapshot editable (G-V1 P1) + sin freshness
(G-Bob-2 P1). Confirma F7 propuesto.

**Evaluator drift:** `validate.sh` sin regresion propia; `bash -n` en maintenance mitiga
parcialmente.

**Overfitting:** fixtures y skills escritos por el mismo equipo → mitigado por
`code-reviewer` fresh-context.

---

## S. TESTING FINDINGS

**Coberturas actuales:**
- Unit: N/A (todo bash + convention).
- Integration: `evals/maintenance.sh` (9 checks).
- Regression: `evals/incidents/INC-001-*.sh` (1 sample).
- Structural: `evals/skills/validate.sh`.
- Behavioral: Tier 3 F3.
- State integrity: `evals/state/state-integrity.sh`.

**GAP CONFIRMADO:** **firewall/secret-guard sin fixture positivo dedicado** (G-T1 P1 roadmap +
G-B2/G-B3/G-B4 P1 comportamentales).

**Property-based / fuzzing / mutation:** DEFER (roadmap §16.3). Solo si bypass documentado
recurrente.

---

## T. CONTEXT / SKILL / AGENT / RULE FINDINGS

**Context bloat:** ninguno. Cada pack responde una pregunta especifica.

**Duplicacion:** MASTER_PLAN ↔ POST_F6_AUDIT ↔ EVOLUTION_ROADMAP ↔ BEHAVIORAL_RELIABILITY_AUDIT
tiene overlap intencional (scope temporal distinto). **Este handoff consolida referencias sin
duplicar contenido.**

**Skill lifecycle:** documentado en roadmap §24. Ninguna candidata a retiro. Ninguna nueva
justificada por bugs behavioral (todos requieren hook fixes, no skills).

**Agent tool limits:** correctos, verificados.

**Rules:** 4 rules globales (security · git-policy · no-go · compliance). Adecuadas.

---

## U. ORCHESTRATION FINDINGS

**Modelo:** main agent + subagents por rol. SubagentStart inyecta packs. SubagentStop loguea.
Correcto.

**Anti-patrones detectados:** ninguno. Ver roadmap §18.

**Recomendacion:** sin cambio.

---

## V. NOISE / TOKEN / COST FINDINGS

**Ruido cuantificado (audit 2026-09-18):**
- F-LOOP-01: 5–10k tokens desperdiciados en sesion previa.
- F-ROTATION-01: session log crece indefinidamente (246 lineas, threshold 30).
- Fantasmas SubagentStop: 5 entradas espurias observadas.

**Total estimado:** 7–12k tokens perdidos por bugs de comportamiento por sesion afectada. Escala
con dias sin `/checkpoint`.

**Duplicacion de context:** no detectada. Cada pack tiene rol distinto.

---

## W. INSTALLATION / UPGRADE / MIGRATION FINDINGS

**F-INSTALL-01 (P2 · nuevo):** `install.sh` reinstala `settings.json` incondicionalmente.
Sobrescribe personalizacion del usuario.

**Path canonico de evidencia:** unico (`docs/00_SYSTEM/EVIDENCE_REGISTRY.md`); hook
task-completed-evidence.sh:6 usa la ruta canonica.

**Templates root preservados:** correcto (check `[ ! -f "$TARGET/$f" ]`).

**Migration:** no aplica (v1.0 · CONFIG_SCHEMA_VERSION 1). Ver `PROJECT_STATE.md`.

---

## X. EXTERNAL RESEARCH (G5 · REFERENCE ROADMAP §6)

**Fuente canonica:** `docs/MASTER_EVOLUTION_ROADMAP.md §6 SOURCE / EVIDENCE REGISTER`.
Investigacion externa realizada 2026-09-17. **Este handoff NO reejecuta la investigacion externa;
la referencia sin duplicar.**

**Sintesis (confidence HIGH):**
- **Claude Code hooks:** 20 eventos disponibles; usamos 10. Ninguno de los 10 sobrantes tiene
  evidencia de necesidad hoy.
- **GitHub Spec Kit:** overlap ALTO con nuestro Master Plan; REUSE conceptualmente, no CLI.
- **obra/superpowers:** overlap ALTO con nuestras skills; co-existencia con lo instalado por
  el usuario; no importar al repo.
- **anthropic-skills:** overlap BAJO (docs/pdf/xlsx/pptx); REUSE bajo demanda.
- **OpenTelemetry GenAI:** DEFER (single-user, sin agregador).
- **MCP tool poisoning (CVE-2025-54136, MCPTox 2025-2026):** DOCUMENT como no-go boundary; sin
  MCP hoy.
- **Mutation testing (Stryker/mutmut):** DEFER (shell no soportado).
- **Property-based / fuzzing / metamorphic:** NO ADOPT sin evidencia.
- **LiteLLM / cross-provider:** OUT OF SCOPE (ARCH-001).

**Regla derivada:** ningun mecanismo nuevo se construye si nativo Claude / externo maduro /
existente en el sistema lo cubre. **Todos los bug fixes propuestos son local: no requieren
integracion externa.**

---

## Y. EXTERNAL REUSE MATRIX (REFERENCE ROADMAP §8)

**Fuente canonica:** `docs/MASTER_EVOLUTION_ROADMAP.md §8 REUSE / INTEGRATION MATRIX`. Este
handoff NO duplica la tabla; confirma que para los 11 bugs behavioral, **ningun proyecto externo
maduro provee fix directo** (shell / project-local hooks). Fix propuesto es 100% local.

---

## Z. FRIEND F7-F12 RECOVERY (G6 · CRITICAL FINDING)

**HALLAZGO IMPORTANTE — VERIDICO:**

**El repositorio NO contiene ningun "friend audit F7-F12".** No existe documento historico,
git history, o registro que defina F8, F9, F10, F11, F12. Se busco:

- `docs/` recursivo → ningun F8/F9/F10/F11/F12.
- `git log` → 7 commits totales; ningun commit relacionado a F7+.
- `docs/00_SYSTEM/` → 4 documentos (EVIDENCE_REGISTRY, CLAUDE_SESSION_LOG,
  POST_F6_AUDIT_REPORT, BEHAVIORAL_RELIABILITY_AUDIT) — ninguno referencia F8+.
- `docs/MASTER_EVOLUTION_ROADMAP.md` — propone SOLO **F7** (Evidence Integrity Hardening) +
  ADR-004 (Task Semantics). Ver §31.1 y §31.2.
- `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md` — propone **F7 Extended** o **F7a**
  (Behavioral Fixes bundle). Ver §36 y §39.

**Material historico presente relacionado a "fases futuras":**

| Origen | ID / Nombre | Estado |
|---|---|---|
| MASTER_EVOLUTION_ROADMAP §31.1 | F7 — Evidence Integrity Hardening | PROPOSED, no iniciado |
| MASTER_EVOLUTION_ROADMAP §31.2 | ADR-004 — Task Tracking Semantics | PROPOSED (documental) |
| BEHAVIORAL_RELIABILITY_AUDIT §36 | F7 Extended o F7a — Behavioral Fixes | PROPOSED, no iniciado |

**Clasificacion honesta:**
- **F7:** PROPUESTO (dos variantes candidatas).
- **F8, F9, F10, F11, F12:** **NO EXISTEN** en este repositorio.

**No fabricar F8-F12.** Cualquier friend audit external que mencione F8-F12 no fue provisto en
este repositorio y **UNKNOWN** es la unica clasificacion valida para su contenido.

**Recomendacion:** el prompt referencia "friend F7-F12" que este repo no contiene. Si el owner
tiene un friend audit externo (fuera del repo, correo, chat, otro sistema), debe adjuntarlo
antes de ejecutar reconciliacion F7-F12. **Sin ese material, la reconciliacion se limita a las
dos variantes de F7 propuestas.**

---

## AA. F7-F12 RECONCILIATION (G7)

**Dado que solo F7 tiene material historico, la reconciliacion se limita a F7 vs F7a:**

| # | Origen | Alcance | Bugs cubiertos | Coste | Decision candidata |
|---|---|---|---|---|---|
| Variante A | Roadmap §31.1 F7 (Evidence Integrity) | Freshness Tier 3 · fixtures positivos firewall/secret-guard | G-V1, G-Bob-2, G-T1 | ~30 LOC + 2 fixtures | Cierra 3 de 5 P1 originales del roadmap |
| Variante B | Behavioral Audit §36 F7a (Behavioral Fixes) | Anti-loop Stop hook · firewall regex tolerance · SQL case-insensitive · .env source coverage · evidence coupling · install idempotency · rotation fix | G-B1 a G-B8 (~50 LOC total) | ~50 LOC + convention change | Cierra 5 P1 + 3 P2 comportamentales |
| Variante C | F7 Extended (A + B) | Todo lo anterior | 8 P1 + 3 P2 | ~80 LOC + 5 fixtures + 1 ADR | Cierra maxima superficie con evidencia P1 |

**Overlap A ↔ B:** G-T1 (fixtures positivos firewall/secret-guard). Ambos lo cubren.

**Dependencies:**
- A no depende de B.
- B no depende de A.
- Ambos son aditivos sobre F1–F6.
- Ambos son revertibles con `git revert`.

**Regla evidence-based:** los 5 P1 nuevos de la behavioral audit (G-B1 a G-B5) tienen reproducer
100% en runtime esta sesion. Los 3 P1 originales del roadmap (G-V1/G-Bob-2/G-T1) tambien.

**Decision candidata:** **Variante C (F7 Extended)** cierra la maxima superficie con evidencia P1
demostrada. La complejidad total (~80 LOC + 5 fixtures + 1 ADR) es baja. Owner decide.

**No forzar Variante C:** Variantes A y B son ambas validas. La eleccion depende del apetito
del owner y de la seriedad del riesgo F-BYPASS y F-FALSE_PASS.

---

## AB. CAPABILITY CONSERVATION

| Capacidad historica | Fuente | Estado en handoff | Rationale |
|---|---|---|---|
| F7 Evidence Integrity | Roadmap §31.1 | COVERED (Variante A) | Cierra G-V1/G-Bob-2/G-T1 |
| F7a Behavioral Fixes | Behavioral Audit §36 | COVERED (Variante B) | Cierra 5 P1 + 3 P2 comportamentales |
| ADR-004 Task Semantics | Roadmap §31.2 | COVERED (documental) | Sin fase; documentacion |
| G-D3 Task Semantics gap | POST_F6 §C | COVERED (ADR-004) | Convention documental |
| G-S1 Rollback smoke | POST_F6 §C | DOCUMENTED (P2) | Handbook dry-run |
| G-S2 Heredoc rollback | POST_F6 §C | DOCUMENTED (P2) | Reformato en registry |
| G-Bob-1 Fixtures header | POST_F6 §C | DOCUMENTED (P2) | Comentario 1-line |
| G-A1 Placeholder packs | POST_F6 §C | DOCUMENTED (P2) | Nota README |
| G-T2 2do incidente | POST_F6 §C | DEFER | Esperar organico |
| G-M1 Mutation regex | POST_F6 §C | DEFER | Sin bypass documentado historico |
| G-L1 PostToolUseFailure | POST_F6 §C | DEFER | Disciplina humana suficiente |
| G-N1 Revalidacion manual | Roadmap §9 | DOCUMENTED (P2) | Cadencia Handbook |
| G-N2 Retention session log | Roadmap §9 | DOCUMENTED (P2) | Retention Handbook |
| G-N3 Artifact hash recompute | Roadmap §11.3 | DEFER | Beneficio marginal |
| G-N4 Hook fingerprint | Roadmap §12.3 | DEFER | Sin debilitamiento historico |
| G-N5 Registry append-only | Roadmap §12.3 | DEFER | Sin history rewrite historico |
| G-B10 Self-mod | Behavioral §35 | DEFER | Revision humana mitiga |
| G-B11 Fantasmas SubagentStop | Behavioral §35 | UNKNOWN | Reproducir primero |

**No hay capabilities historicas huerfanas.** Todas tienen destino explicito.

---

## AC. MASTER INVARIANTS (G9)

Derivados de la investigacion, ordenados por criticidad:

- **I1 (P1):** Un stop hook idempotente NO debe reemitir el mismo `additionalContext` cuando
  `stop_hook_active=true`. **ROTO (F-LOOP-01).**
- **I2 (P1):** El bash-firewall debe bloquear patrones destructivos independientemente de
  espacios y case. **ROTO (F-BYPASS-01, F-BYPASS-02).**
- **I3 (P1):** El bash-firewall debe cubrir todas las formas comunes de leer `.env` (source,
  `.`, eval, exec, read). **ROTO (F-BYPASS-03).**
- **I4 (P1):** El evidence gate debe verificar que la evidencia corresponde a la tarea en
  curso, no solo a un `task_id` historico. **ROTO (F-FALSE_PASS-01).**
- **I5 (P1):** Un rerun de Tier 3 no debe pasar maintenance con `session_id` reutilizado o
  timestamp obsoleto. **ROTO (G-V1/G-Bob-2).**
- **I6 (P1):** Fixtures positivos deben existir para bash-firewall y secret-guard. **ROTO
  (G-T1).**
- **I7 (P2):** El session log no debe crecer indefinidamente. **ROTO (F-ROTATION-01a).**
- **I8 (P2):** El archive del session log no debe sobreescribirse intra-mes. **ROTO
  (F-ROTATION-01b).**
- **I9 (P2):** La reinstalacion no debe sobreescribir la personalizacion del usuario en
  `settings.json`. **ROTO (F-INSTALL-01).**
- **I10 (VERDE):** Historical evidence (EV-001…EV-008) must not mutate. **PASS.**
- **I11 (VERDE):** F6 status COMPLETE cannot regress silently. **PASS.**
- **I12 (VERDE):** `maintenance.sh` PASS es prerequisito para cerrar cualquier fase. **PASS.**
- **I13 (VERDE):** Compact must preserve state hash. **PASS.**
- **I14 (P2 · DEFER):** Historical incidents/controls/regressions must not be fabricated.
  **PASS por convention.**
- **I15 (P2 · DEFER):** Model cannot silently weaken its own verifier. **PARCIAL** (revision
  humana mitiga; G-N4/G-N5 DEFER).

**6 invariantes P1 rotos · 3 P2 rotos · 6 VERDE.** Todos corregibles con Variante C (F7
Extended).

---

## AD. INVARIANTS → CONTROLS MAPPING

| Invariante | Control actual | Gap | Control propuesto | Fix bundle |
|---|---|---|---|---|
| I1 Stop idempotency | ninguno | LEE FALLA `stop_hook_active` | Read + return early | Bundle A |
| I2 Firewall space-tolerance | grep -qF literales | espacios variables | regex space-tolerant | Bundle B |
| I3 Firewall SQL case | grep -qF | case-sensitive | grep -iF o regex `[Dd][Rr][Oo][Pp]` | Bundle B |
| I3 .env comprehensive | regex parcial | source/./eval no cubierto | extender regex | Bundle B |
| I4 Evidence coupling | task_id match | historico reusable | contract_hash match + timestamp coupling | Bundle C |
| I5 Tier 3 freshness | ninguno | snapshot editable | maintenance verifica session_id + ts | Bundle A (F7 base) |
| I6 Positive fixtures | ninguno | solo negative INC-001 | 2 fixtures bloqueantes | Bundle A (F7 base) |
| I7 Log truncation | rotation cp | cp no trunca | mv en vez de cp | Bundle D |
| I8 Archive granularity | mensual | overwrite intra-mes | daily archive path | Bundle D |
| I9 Install idempotency | overwrite | silencioso | detect + prompt | Bundle E |
| I10-I13 | git + evidence + maintenance | — | preservar | — |
| I14 | convention | — | preservar (ADR-004) | ADR |
| I15 | revision humana | debilitamiento no detectado | DEFER (G-N4) | DEFER |

**Fix total estimado (Variante C):** ~80 LOC bash + 5 fixtures + 1 ADR-004. Reviewer PASS
requerido para riesgo medium (todos los bundles son medium por tocar hooks P0 + evidence gate).

---

## AE. ARCHITECTURAL SYNTHESIS

**La arquitectura NO cambia.** Ver DESIGN.md + roadmap §4 y §30. Cambios propuestos son:

1. Hardening de hooks P0 existentes (bash-firewall, task-completed-evidence, stop-logger).
2. Extension de `maintenance.sh` con 3 checks nuevos (evidence_freshness, firewall_positive,
   secret_guard_positive).
3. Fix idempotency de `subagent-stop-logger.sh` (rotation) e `install.sh` (settings).
4. ADR-004 documenta task semantics sin cambio de codigo.
5. Cero nuevos hooks. Cero nuevos skills. Cero nuevos agents. Cero nuevos registries.

**Distintividad preservada:** Evidence gate + State integrity + Incident 3-registry + Fresh
context reviewer + BENEFIT>COMPLEXITY (ver roadmap §29).

---

## AF. WHAT NOT TO BUILD

**Consolidado de roadmap §28:**

- Segundo state/memory/evidence/incident system.
- Plugin manager propio.
- Custom eval framework, test runner propio, dashboard.
- Custom orchestration engine, vector database, policy engine (OPA).
- Agent swarm, Gherkin pipeline, retrieval sofisticado.
- Model routing propio, cross-provider fallback.
- Prompt firewall separado, formal proof system.
- Blockchain evidence, sigstore, PGP para evidence.
- Merkle tree o append-only distribuido.
- Global mutation testing (shell no soportado).
- OTel GenAI (sin agregador).
- Constitucional AI critic (fresh reviewer ya existe).
- Sofisticado plan/act loop (Master Plan basta).

**Regla:** cada nuevo componente debe pasar §26 AI Theater Audit del roadmap. Sin evidencia
concreta de riesgo reducido, no se construye.

---

## AG. FINAL F7 — Evidence Integrity Hardening (Variante A)

**Objetivo:** cerrar G-V1/G-Bob-2/G-T1 sin infraestructura pesada.

**Scope (in):**
1. `maintenance.sh` verifica cada Tier 3 result: `session_id` no reutilizado; `timestamp` no
   anterior a `evidence_freshness_days` (default 30).
2. `evals/hooks/firewall-positive.sh` (nuevo).
3. `evals/hooks/secret-guard-positive.sh` (nuevo).
4. `maintenance.sh` corre ambos fixtures.
5. Docs actualizadas.

**Scope (out):** todos los items DEFER (G-M1, G-L1, G-D3 codigo, G-N3, G-N4, G-N5).

**Dependencies:** F6 PASS (satisfecho). `jq`, `sha256sum`, `bash -n` (satisfechos).

**Change budget:** ~30 LOC bash + 2 fixture files + 1 config field en `REGRESSION_BUDGET.json`.

**Side-effect budget:** LOCAL_MUTATION reversible via `git revert`.

**Positive tests:**
- `maintenance.sh` PASS con Tier 3 result fresh.
- `firewall-positive.sh` bloquea payload malicioso.

**Negative tests:**
- Debilitar regex del firewall → `firewall-positive.sh` FAIL → maintenance FAIL.
- Editar `session_id` en Tier 3 result → maintenance FAIL.

**Adversarial tests:**
- Reusar `session_id` de corrida anterior → maintenance FAIL.
- Copiar Tier 3 result + editar contract_hash → maintenance FAIL (hash no coincide).

**Regression tests:** REG-002 (`firewall_positive`), REG-003 (`secret_guard_positive`),
REG-004 (`evidence_freshness`).

**Evidence contract:** EV-009 con hashes + reviewer PASS + provenance GENERATED.

**Rollback:** `git revert <F7-commit>`. Preserva EV-001…EV-008 y INC-001/CTRL-001/REG-001.

**Human checkpoint:** owner aprueba explicitamente antes de iniciar.

**Metrics:** `maintenance.sh` < 5s wall time; 0 regresiones existentes.

**GO/NO-GO:** owner decide.

---

## AH. FINAL F7a — Behavioral Fixes (Variante B, alternativa a AG)

**Objetivo:** cerrar G-B1/G-B2/G-B3/G-B4/G-B5 sin ampliar infraestructura.

**Scope (in) — 5 bundles:**

**Bundle A (Anti-loop, G-B1):**
- `stop-logger.sh` lee `stop_hook_active` del payload; si `true`, exit 0 sin emitir.
- Coste: ~4 LOC bash.

**Bundle B (Firewall hardening, G-B2/G-B3/G-B4):**
- Reemplazar literales `grep -qF` por regex space-tolerant.
- Cambiar SQL keywords a `grep -iF` o regex case-insensitive.
- Extender regex `.env` para cubrir `source | . | eval | exec | read`.
- Coste: ~15 LOC bash modificados.

**Bundle C (Evidence coupling, G-B5):**
- `task-completed-evidence.sh` recibe tambien `contract_hash` en payload y verifica igualdad con
  registry.
- Convention documental: `task_id` incluye marca temporal (`<fase>-<slug>-YYYY-MM-DD-<hash>`).
- Coste: ~10 LOC bash + ADR-004.

**Bundle D (Rotation, F-ROTATION-01):**
- `subagent-stop-logger.sh`: `mv` en vez de `cp`; rotate por dia (`.claude/archive/CLAUDE_SESSION_LOG.YYYY-MM-DD.md`).
- Coste: ~5 LOC bash.

**Bundle E (Install idempotency, F-INSTALL-01):**
- `install.sh` detecta `.claude/settings.json` existente; prompt de confirmacion; `--force` para
  no interactivo.
- Coste: ~10 LOC bash + docs.

**Scope (out):** F7 base (freshness + fixtures positivos, cubierto por Variante A) — a menos que
se elija Variante C.

**Dependencies:** F6 PASS (satisfecho); Variante A NO requerida.

**Change budget:** ~50 LOC bash + 1 ADR + docs.

**Side-effect budget:** LOCAL_MUTATION reversible via `git revert`.

**Positive tests:** cada bundle tiene fixture positivo y negativo.

**Negative tests:**
- Bundle A: fixture con `stop_hook_active=false` → emit reminder (verifica no rompio caso base).
- Bundle B: fixture con doble espacio → BLOCK (era PASS).
- Bundle C: fixture con task_id historico + payload contract_hash distinto → BLOCK.
- Bundle D: fixture 100 entradas → log <30 tras rotation.
- Bundle E: reinstall sobre settings.json modificado → no overwrite sin confirm.

**Regression tests:** REG-005 (anti-loop), REG-006 (firewall regex), REG-007 (evidence
coupling), REG-008 (rotation), REG-009 (install idempotency).

**Evidence contract:** EV-010 (Bundle A), EV-011 (Bundle B), EV-012 (Bundle C), EV-013 (Bundle
D), EV-014 (Bundle E). Cada uno con reviewer PASS + provenance GENERATED.

**Rollback:** `git revert <bundle-N-commit>` por bundle o `git revert <F7a-merge>` completo.

**Human checkpoint:** owner aprueba cada bundle (o F7a completa).

**Metrics:** `maintenance.sh` PASS; 0 regresiones en EV-001…EV-008; +5 fixtures positivos.

**GO/NO-GO:** owner decide.

---

## AI. FINAL F7 EXTENDED (Variante C = AG ∪ AH)

**Objetivo:** cerrar maximo superficie de bugs P1 conocidos.

**Scope:** union de AG y AH sin duplicar (G-T1 lo cierran ambos; se ejecuta una vez).

**Change budget:** ~80 LOC + 5 fixtures + 1 ADR + config field.

**Recomendacion tecnica del BEHAVIORAL_RELIABILITY_AUDIT §39.4:** camino A (F7 Extended). Alta
homogeneidad (todos son hook fixes). Owner decide.

---

## AJ. FINAL F8 — NO DEFINIDO / UNKNOWN

**Estado:** el repositorio no contiene material historico F8. Ninguna investigacion recomienda
F8 en este momento. **RESEARCH REQUIRED** antes de proponer F8.

**Candidatos teoricos (fuera de scope de este handoff):**
- OTel GenAI si aparece multi-proyecto (roadmap §6.5, §19).
- MCP allowlist si se adopta MCP (roadmap §6.6).
- G-M1 mutation regex si aparece bypass documentado (roadmap §6.7).
- G-L1 PostToolUseFailure si aparece fallo tool sin registrar.
- G-N3/N4/N5 si aparece tampering documentado.

**Ninguno tiene evidencia hoy.** Sin evidencia, NO SE PROPONE.

---

## AK. FINAL F9 — NO DEFINIDO / UNKNOWN

Mismo diagnostico que F8. Sin material historico. Sin evidencia de necesidad.

---

## AL. FINAL F10 — NO DEFINIDO / UNKNOWN

Mismo.

---

## AM. FINAL F11 — NO DEFINIDO / UNKNOWN

Mismo.

---

## AN. FINAL F12 — NO DEFINIDO / UNKNOWN

Mismo.

**Conclusion honesta:** F8–F12 son placeholders vacios en este momento. **Cualquier fase mas alla
de F7 requiere: (a) evidencia concreta de riesgo documentado, (b) approval del owner, (c) research
adicional.** No se fabrican fases sin evidencia.

---

## AO. DEPENDENCY DAG

```text
F6 PASS (baseline verificado)
    |
    +--> ADR-004 Task Tracking Semantics (documental, sin fase)
    |
    +--> F7 Variante A (Evidence Integrity)      ─┐
    +--> F7 Variante B (Behavioral Fixes)         ├── Variante C (union, recomendada)
    +--> F7 Variante C (F7 Extended)             ─┘
             |
             +--> EV-009 (freshness + fixtures positivos, si A)
             +--> EV-010…EV-014 (5 bundles, si B)
             +--> ambos si C
             +--> REG-002…REG-009 (2 a 7 regresiones nuevas)

[FUERA DEL GRAFO — DEFER hasta evidencia]
G-T2, G-M1, G-L1, G-N3, G-N4, G-N5, F8, F9, F10, F11, F12
```

**Independencia:** Variantes A y B son independientes; ambas pueden ejecutarse en paralelo o en
serie sin bloquear una a la otra.

**No hay circular deps. No hay hidden deps.** Todo aditivo sobre F1–F6.

---

## AP. IMPLEMENTATION ORDER (candidato · owner decide)

Si el owner elige Variante C (F7 Extended, recomendado):

1. **ADR-004** (documental, sin gate) — establece convention task semantics.
2. **Bundle A (Anti-loop)** — resuelve dolor operativo inmediato (F-LOOP-01).
3. **Bundle B (Firewall)** — resuelve bypasses de seguridad P1.
4. **Freshness check + fixtures positivos** (variante A) — cierra G-V1/G-Bob-2/G-T1.
5. **Bundle C (Evidence coupling)** — cierra F-FALSE_PASS-01 (depende de ADR-004).
6. **Bundle D (Rotation)** — resuelve ruido de log.
7. **Bundle E (Install)** — mejora UX reinstall.
8. **EV-009…EV-014** — evidencia con reviewer PASS.
9. **`/gate`** para F7 (o F7 Extended).
10. **`/cerrar-fase`** + checkpoint git.

**Rationale:** empieza con lo mas visible (loop) y lo mas critico en seguridad (firewall). Deja
lo cosmetico al final (rotation, install).

**Alternativa:** ejecutar Variante A sola primero (owner conservador) y luego evaluar Variante B
como F7a.

---

## AQ. PHASE ACCEPTANCE CONTRACTS

**Aplicable a F7 (cualquier variante):**

- **INPUT CONTRACT:** F6 PASS (verificado por maintenance 9/9) · working tree limpio (o con
  cambios docs de esta sesion resueltos por commit + checkpoint).
- **SCOPE CONTRACT:** solo archivos listados en Variante elegida. Cualquier cambio fuera de
  scope → STOP + reassess.
- **OUTPUT CONTRACT:** `maintenance.sh` PASS (10/10 si Variante A · 12/12 si Variante C).
- **EVIDENCE CONTRACT:** EV-009 (Variante A) o EV-009…EV-014 (Variante C), todas VERIFIED con
  hashes + reviewer PASS + provenance GENERATED.
- **VERIFICATION CONTRACT:** deterministic tests + negative tests + adversarial tests +
  fresh-context reviewer (medium+ risk).
- **ROLLBACK CONTRACT:** `git revert` per commit; preserva EV-001…EV-008 y INC-001/CTRL-001/REG-001.
- **DOCUMENTATION CONTRACT:** Master Plan §5 nueva fase, Handbook §12 update, POST_F7_AUDIT_REPORT
  (nuevo doc, no sobreescribir POST_F6).
- **REGRESSION CONTRACT:** REG-002 a REG-009 vinculados a incidentes preventivos (permitido
  cuando gap tiene evidencia documentada).
- **ADVERSARIAL ATTACK CONTRACT:** cada bundle debe tener al menos un test que confirme el bug
  original antes del fix y bloqueo tras el fix.

**Un cambio es COMPLETO solo cuando los 9 contratos concuerdan.**

---

## AR. VERIFICATION STRATEGY

Por nivel de riesgo (roadmap §14):

- **Bundle A (medium):** V1 static + V2 unit fixture + V3 integration maintenance + V6 behavioral
  + V10 fresh reviewer.
- **Bundle B (high — toca seguridad):** V1 + V2 + V3 + V4 contract (regex) + V6 + V7 adversarial
  + V10.
- **Bundle C (high — toca evidence gate):** todos los anteriores + V11 integrity (hash coupling).
- **Bundles D, E (medium):** V1 + V2 + V3 + V10.

**Fresh reviewer requerido para todos los bundles medium+/high.** El `code-reviewer` agent
recibe solo contrato + artefacto, no el razonamiento del implementer.

---

## AS. ROLLBACK / RECOVERY STRATEGY

Por bundle:
1. `git revert <bundle-N-commit>` → restaura hook original.
2. Rerun `maintenance.sh` → confirmar PASS.
3. Actualizar PROJECT_STATE.md: `CURRENT_PHASE: 6 · PHASE_STATUS: COMPLETE` (restaurado).
4. Sin evidencia nueva creada durante rollback.
5. Documentar en Handbook §12 el rollback si se ejecuto.

Recovery adicional (si ADR-004 se aprobo):
1. Retirar convention del Handbook §12.
2. Actualizar DECISION_REGISTRY: ARCH-004 (o ADR-004) → status `SUPERSEDED`.

**Todo rollback es reversible.** git es la fuente de verdad.

---

## AT. CONTROL LIFECYCLE

Controles activos:

| Control | Estado | Review condition | Retirement condition |
|---|---|---|---|
| CTRL-001 | ACTIVE (INC-001) | Sin change desde 2026-09-17 | Retire si dependencia se retira |
| bash-firewall | ACTIVE P0 | Cada 6m review regex | Nunca (fundamental) |
| secret-guard | ACTIVE P0 | Cada 6m review patterns | Nunca (fundamental) |
| task-completed-evidence | ACTIVE P0 | Cada change de schema evidence | Nunca (fundamental) |

Post-F7 (si Variante C):
- REG-002…REG-009 activos con dependencia a bundle correspondiente.

**Retirement rules:** un control puede retirarse solo si (a) el mecanismo que protegia dejo de
existir, (b) fue reemplazado por control mas fuerte + regresion, (c) approval owner explicito.

---

## AU. CONTROL-PLANE REGRESSION RISKS

Para F7 (cualquier variante):

**Invariantes preservadas:**
- Historical evidence intact (git append-only).
- F1–F6 status COMPLETE.
- Existing controls unmodified (solo se AGREGAN validations).
- Trust boundaries unchanged.
- Permissions matrix unchanged.

**Invariantes modificadas:**
- Stop hook: se agrega lectura de `stop_hook_active` (defensiva, backwards-compatible).
- bash-firewall: se agrega tolerancia espacios + case-insensitive SQL + regex .env extendida (mas
  estricto, no menos).
- task-completed-evidence: se agrega opcional coupling `contract_hash` (fail-closed si no se
  provee).
- subagent-stop-logger: `mv` en vez de `cp` (aditivo).
- install.sh: prompt antes de overwrite (nuevo comportamiento).

**Nuevas invariantes:**
- I1–I9 activados post-F7.

**Riesgo de regresion:**
- Bundle A: null (solo lectura adicional).
- Bundle B: null (regex mas estrictos, no menos).
- Bundle C: **posible incompatibilidad con TaskCompleted calls existentes** si no incluyen
  `contract_hash` — mitigado por fail-open backwards (con warning) durante 1 fase.
- Bundle D: null (rotation mas frecuente).
- Bundle E: **posible bloqueo en reinstall no interactivo** — mitigado por `--force`.

**Ningun bundle debilita F1–F6.** Todos son aditivos o mas estrictos.

---

## AV. DEFERRED ITEMS

Consolidado (roadmap §38 + behavioral audit §35):

| Item | Trigger de reconsideracion |
|---|---|
| G-T2 (2do incidente) | Ocurrencia organica |
| G-M1 (mutation regex) | Bypass firewall documentado (F-BYPASS-01/02/03 podrian activarlo tras fix; reevaluar) |
| G-L1 (PostToolUseFailure hook) | Tool failure sin registrar |
| G-N3 (artifact recompute) | Evidence tampering documentado |
| G-N4 (hook fingerprint) | Debilitamiento silencioso documentado |
| G-N5 (registry append-only) | History rewrite documentado |
| G-B10 (Self-mod) | Debilitamiento silencioso documentado |
| G-B11 (Fantasmas SubagentStop) | Reproduccion determinista |
| OTel GenAI | Multi-proyecto activo con RCA que necesito traza |
| MCP allowlist | Adopcion MCP explicita |
| Cross-provider fallback | Provider outage cronico + necesidad demostrada |
| Vector DB memory | Cross-proyecto knowledge sharing con volumen |
| Skills externos adicionales (`brainstorming`, `systematic-debugging`) | Demanda especifica |

**Regla:** DEFER no es "algun dia"; es "no hasta que aparezca evidencia especifica".

---

## AW. REMOVED ITEMS

Ningun item se removio del roadmap historico. Todos los items registrados en POST_F6_AUDIT_REPORT
y MASTER_EVOLUTION_ROADMAP se preservan con estado explicito.

---

## AX. FUTURE RESEARCH

Areas donde investigacion adicional podria cambiar la decision (behavioral audit §38):

1. Reproduccion controlada de compact + resume post-drift (requiere sesion nueva).
2. Carga concurrente en session log (multiple subagents simultaneously).
3. Fantasmas SubagentStop: origen determinista.
4. install.sh sobre working tree modificado.
5. PostToolUseFailure comportamiento si se activara (G-L1 DEFER).
6. Interaccion PreCompact + SessionStart con state modificado durante compact.
7. Tier 3 behavioral con `session_id` reciclado (G-V1 lo cubre teoricamente; verificar).
8. Skills operativas externas (`brainstorming`, `systematic-debugging`): coste vs beneficio real.
9. Multi-proyecto: cuando aparezca, revisar ARCH-001 y evaluar OTel.

---

## AY. FINAL SELF-ATTACK

Intento de destruir la propuesta final:

- **¿Que parte ya existe?** F7 base cierra G-V1/G-Bob-2/G-T1 (ya identificados). F7a cierra
  G-B1…G-B8 (ya identificados). Nada re-inventa.
- **¿Que parte ya existe externamente?** No para shell hooks locales. Verificado en roadmap §6.
- **¿Que parte es redundante?** Overlap A ↔ B en G-T1 (fixtures positivos). Se ejecuta una vez.
- **¿Que parte no tiene enforcement?** Cambios documentales (ADR-004, G-S1, etc.) son guidance.
  Aceptado por diseño.
- **¿Que parte depende del modelo?** Cero. Todo shell + fixtures + hashes.
- **¿Que parte genera ruido?** Cero nuevos hooks. Ninguno.
- **¿Que parte es AI theater?** Ninguna sobrevive §26 roadmap.
- **¿Que parte aumenta coste sin mejorar calidad?** Cero. Cada bundle cierra un P1 con evidencia
  100% reproducible.
- **¿Que parte se puede eliminar?** F7a Bundle E (install) es UX; puede diferirse. Bundle D
  (rotation) es cosmetico; puede diferirse. Owner decide.
- **¿Que parte solo satisface preferencia arquitectonica?** Ninguna.
- **¿Que parte no tiene suficiente evidencia?** Ninguna. Cada bug tiene reproducer 100%.

**Resultado del self-attack:** el handoff sobrevive. Variante A y B son ambas defendibles.
Variante C es la mas completa. Recomendacion tecnica: **C**. Decision final: **owner**.

---

## AZ. RESEARCH-INTEGRITY CHECKLIST (G11)

- [x] actual runtime inspected
- [x] current documentation inspected
- [x] historical documentation inspected
- [x] git state inspected
- [x] F1-F6 baseline established (evidencia: maintenance 9/9 PASS)
- [x] behavioral tests performed (referenced BEHAVIORAL_RELIABILITY_AUDIT)
- [x] stop/loop behavior investigated (F-LOOP-01 confirmado)
- [x] idempotency investigated
- [x] reentrancy investigated
- [x] concurrency investigated (single-user local, no observado)
- [x] stale evidence investigated (G-V1/G-Bob-2)
- [x] rerun semantics investigated
- [x] evidence lineage investigated
- [x] evaluator integrity investigated
- [x] trust boundaries investigated
- [x] self-modification investigated (G-B10 DEFER)
- [x] task semantics investigated (G-D3 → ADR-004)
- [x] task contract necessity investigated (NO como codigo)
- [x] execution identity investigated
- [x] state machine investigated
- [x] scope drift investigated (§20 roadmap)
- [x] side effects investigated
- [x] bypass governance investigated
- [x] rollback investigated (G-S1 P2)
- [x] recovery investigated
- [x] human-wait semantics investigated (F-LOOP-01)
- [x] incident loop investigated (INC-001 verificado)
- [x] escaped defects investigated (behavioral audit)
- [x] testing strategy investigated
- [x] testing quality investigated
- [x] context investigated
- [x] skills investigated
- [x] agents investigated
- [x] rules investigated
- [x] orchestration investigated
- [x] noise investigated (F-LOOP-01, F-ROTATION-01, fantasmas)
- [x] cost investigated (~7-12k tokens/sesion perdidos)
- [x] installation investigated (F-INSTALL-01)
- [x] external research performed (roadmap §6, 2026-09-17)
- [x] external reuse evaluated (roadmap §8)
- [x] friend F7-F12 recovered → **NOT FOUND / UNKNOWN** — reportado honestamente en §Z
- [x] friend F7-F12 reconciled (limitado a F7 candidato + F7a candidato)
- [x] historical F7a findings reconciled (Bundle A-E)
- [x] capability conservation performed (§AB)
- [x] master invariants derived (§AC)
- [x] minimum architecture test performed (roadmap §44)
- [x] what-not-to-build produced (§AF)
- [x] dependency DAG produced (§AO)
- [x] phase contracts produced (§AQ)
- [x] roadmap self-attacked (§AY)
- [x] control-plane regression considered (§AU)
- [x] documentation updated where necessary (este handoff)
- [x] F6 remains historically preserved (verificado)
- [x] no unauthorized runtime implementation occurred (0 cambios)

**INTEGRITY: PASS.** Research completa.

---

# IMPLEMENTATION HANDOFF PACKAGE (G12)

```
RESEARCH_STATUS:               COMPLETE
ROADMAP_STATUS:                RECONCILED
BASELINE_COMMIT:               b6e8fd0
F6_STATUS:                     COMPLETE (evidencia EV-001…EV-008 intacta)
CURRENT_FINDINGS_COUNT:        11 behavioral + 11 roadmap gaps = 22 tracked
P0_COUNT:                      0
P1_COUNT:                      9 (5 behavioral + 4 roadmap)
P2_COUNT:                      6 (3 behavioral + 3 roadmap)
P3_COUNT:                      2 (behavioral)
DEFER_COUNT:                   9

F7_STATUS:                     READY (Variante A recomendada como minimo, Variante C recomendada como maximo)
F8_STATUS:                     NOT DEFINED / RESEARCH REQUIRED
F9_STATUS:                     NOT DEFINED / RESEARCH REQUIRED
F10_STATUS:                    NOT DEFINED / RESEARCH REQUIRED
F11_STATUS:                    NOT DEFINED / RESEARCH REQUIRED
F12_STATUS:                    NOT DEFINED / RESEARCH REQUIRED

FIRST_IMPLEMENTATION_PHASE:    F7 (Variante A: Evidence Integrity Hardening MINIMUM
                                    · Variante C: F7 Extended RECOMMENDED)
FIRST_IMPLEMENTATION_SCOPE:
  Variante A (minimo):
    - evals/maintenance.sh (extension: evidence_freshness + firewall_positive + secret_guard_positive)
    - evals/hooks/firewall-positive.sh (nuevo)
    - evals/hooks/secret-guard-positive.sh (nuevo)
    - evals/REGRESSION_BUDGET.json (nuevo field: evidence_freshness_days)
    - docs/MASTER_IMPLEMENTATION_PLAN.md (nueva §11 F7)
    - docs/CONTROL_PLANE_HANDBOOK.md (§15 update)
    - PROJECT_STATE.md (CURRENT_PHASE→7 post-cierre)

  Variante C (recomendado, agrega a A):
    - .claude/hooks/stop-logger.sh (lectura stop_hook_active)
    - .claude/hooks/bash-firewall.sh (regex space-tolerant + case-insensitive SQL + .env source cover)
    - .claude/hooks/task-completed-evidence.sh (opcional contract_hash coupling con backwards fail-open + warning)
    - .claude/hooks/subagent-stop-logger.sh (mv en vez de cp + daily archive)
    - install.sh (settings.json prompt + --force)
    - DECISION_REGISTRY.md (ARCH-004 Task Semantics)
    - .claude/context/DECISIONS.md (ARCH-004 mirror)

FIRST_IMPLEMENTATION_OUT_OF_SCOPE:
  - Mutation testing global (G-M1 DEFER)
  - PostToolUseFailure hook (G-L1 DEFER)
  - Hook integrity fingerprint (G-N4 DEFER)
  - Registry append-only (G-N5 DEFER)
  - Artifact hash recompute (G-N3 DEFER)
  - Fantasmas SubagentStop fix (G-B11 UNKNOWN)
  - Self-modification detection (G-B10 DEFER)
  - Cualquier F8-F12 (no definidos)

FIRST_IMPLEMENTATION_DEPENDENCIES:
  - F6 PASS: satisfecho
  - maintenance 9/9 PASS: satisfecho
  - jq, sha256sum, awk, bash -n: satisfechos
  - working tree limpio: pendiente (commit del pass de research + este handoff)
  - approval del owner: PENDING

FIRST_IMPLEMENTATION_ACCEPTANCE:
  Variante A:
    - maintenance 10/10 PASS (agrega evidence_freshness, firewall_positive, secret_guard_positive)
    - EV-009 VERIFIED con reviewer PASS
    - REG-002/003/004 activos y linkeados
    - EV-001…EV-008 sin cambio
    - INC-001/CTRL-001/REG-001 sin cambio
    - F6 status intact

  Variante C (adicional):
    - Bundle A: F-LOOP-01 blocked por test T3 con stop_hook_active=true → no emit
    - Bundle B: F-BYPASS-01/02/03 blocked por test con doble espacio + lowercase SQL + source .env
    - Bundle C: F-FALSE_PASS-01 blocked por test con task_id historico + contract_hash distinto
    - Bundle D: log truncado tras rotation; archive por dia sin overwrite
    - Bundle E: reinstall pregunta antes de sobrescribir settings.json
    - EV-010…EV-014 VERIFIED
    - REG-005…REG-009 activos y linkeados
    - ARCH-004 registrado en DECISION_REGISTRY

FIRST_IMPLEMENTATION_TESTS:
  Positive:
    - firewall-positive.sh (Variante A)
    - secret-guard-positive.sh (Variante A)
    - stop-hook-idempotency test (Variante C · Bundle A)
    - firewall-space-tolerance test (Variante C · Bundle B)
    - firewall-sql-case test (Variante C · Bundle B)
    - firewall-env-source test (Variante C · Bundle B)
    - task-completed-coupling test (Variante C · Bundle C)
    - rotation-truncation test (Variante C · Bundle D)
    - install-idempotency test (Variante C · Bundle E)

  Negative:
    - Debilitar regex firewall → firewall-positive FAIL
    - Editar session_id Tier 3 → maintenance FAIL
    - Reusar task_id historico con contract_hash distinto → TaskCompleted BLOCK
    - stop_hook_active=false + mtime ayer → sigue emitiendo (regresion de UX preservada)

  Adversarial:
    - `rm  -rf  /` (doble espacio) → BLOCK
    - `drop table users` (lowercase) → BLOCK
    - `source .env`, `. .env`, `eval $(cat .env)` → BLOCK
    - task_id EV-001 con tarea nueva → BLOCK
    - Reinstall sobre settings customizado → prompt

  Regression:
    - Toda evidencia EV-001…EV-008 permanece VERIFIED
    - INC-001/CTRL-001/REG-001 intactos
    - maintenance 9/9 baseline se convierte en 10+/10+ sin regresion

FIRST_IMPLEMENTATION_ADVERSARIAL_TESTS:
  - Ataque: reeditar Tier 3 result JSON con session_id nuevo → maintenance debe detectar timestamp
    obsoleto o hash mismatch.
  - Ataque: modificar EV-009 hash sin regenerar → maintenance debe detectar.
  - Ataque: llamar TaskCompleted con task_id historico + contract_hash matching → verificar
    que timestamp coupling bloquea (o backwards fail-open con warning).
  - Ataque: llamar stop-logger con `stop_hook_active=true` y mtime stale → NO emit.

FIRST_IMPLEMENTATION_EVIDENCE:
  Variante A: EV-009 (Evidence Integrity Hardening) con reviewer PASS.
  Variante C: EV-009 + EV-010 (Anti-loop) + EV-011 (Firewall) + EV-012 (Evidence coupling +
              ARCH-004) + EV-013 (Rotation) + EV-014 (Install). Cada uno con reviewer PASS +
              provenance GENERATED + contract_hash + artifact_hash + timestamp fresh.

FIRST_IMPLEMENTATION_ROLLBACK:
  Per bundle: `git revert <bundle-N-commit>`.
  Full: `git revert <F7-merge-commit>` o restaurar checkpoint `LAST_GIT_CHECKPOINT=b6e8fd0`.
  ADR-004: retirar convention del Handbook, cambiar status a SUPERSEDED en DECISION_REGISTRY.

FIRST_IMPLEMENTATION_SIDE_EFFECT_BUDGET:
  LOCAL_MUTATION reversible (max). NUNCA DESTRUCTIVE. NUNCA IRREVERSIBLE.
  No modifica evidencia historica. No modifica registries pasados. No modifica config schema
  (v1 → v1). No modifica permissions matrix. No modifica CI workflow.

FIRST_IMPLEMENTATION_CHANGE_BUDGET:
  Variante A: ~30 LOC bash + 2 fixtures + 1 config field. ~5 archivos tocados.
  Variante C: ~80 LOC bash + 5 fixtures + 1 config field + 1 ADR. ~10 archivos tocados.

DEFERRED_COUNT:                9
REJECTED_COUNT:                12 (ver §AF What Not to Build)
UNKNOWN_COUNT:                 6 (F8-F12 + G-B11 fantasmas)

NEXT_ALLOWED_ACTION:           F7 READY (Variante A o C, owner decide)
                               O alternativamente: NO IMPLEMENTATION — F7 diferida hasta approval
```

---

# FINAL STOP

**RESEARCH COMPLETO.** `EVIDENCE > CLAIM` respetado. `BENEFIT > COMPLEXITY` respetado.
`TRUTH > OPTIMISM` respetado.

Ningun cambio de runtime durante esta ejecucion. Ninguna evidencia alterada. F6 sigue COMPLETE.
INC-001/CTRL-001/REG-001 intactos. EV-001…EV-008 VERIFIED.

**Owner decide GO/NO-GO:** F7 Variante A (minimo), F7 Variante C (recomendado), o defer.

**Sin approval explicito, NO SE IMPLEMENTA.** El siguiente prompt de implementacion opera desde
este handoff.

---

## Referencias cruzadas

- `docs/MASTER_IMPLEMENTATION_PLAN.md §5-§10` — contrato F1-F6 + gap register.
- `docs/00_SYSTEM/POST_F6_AUDIT_REPORT.md §A-§G` — consolidacion post-F6 (historico, no modificar).
- `docs/MASTER_EVOLUTION_ROADMAP.md §1-§39` — evolucion propuesta + F7 candidato.
- `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md §1-§39` — 11 bugs behavioral + Bundle A-E.
- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` — EV-001…EV-008 intactas.
- `docs/CONTROL_PLANE_HANDBOOK.md §12` — TASK TRACKING SEMANTICS + recovery scenarios.
- `INCIDENT_REGISTRY.md` · `CONTROL_REGISTRY.md` · `REGRESSION_REGISTRY.md` — ciclo INC-001.
- `PROJECT_STATE.md` — estado operativo canonico.

---

**FIN DEL HANDOFF DE INVESTIGACION.** STOP.
