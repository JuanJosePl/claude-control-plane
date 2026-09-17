# Claude Control Plane — Master Implementation Plan

**Estado:** EJECUCION COMPLETADA — F1-F6 PASS
**Fecha de auditoria:** 2026-09-16
**Alcance:** `RESEARCH_CLAUDE.md`, `RESEARCH_CHATGPT.md`, repositorio actual y P0 implementado en working tree.

## 0. Regla de ejecucion

Este documento es el contrato antes de implementar nuevas fases. No se ejecuta ninguna fase
posterior hasta validar este plan. Cada fase debe producir evidencia verificable antes de abrir la
siguiente:

1. diff acotado y lista de archivos.
2. checks automatizados reproducibles.
3. entrada en `EVIDENCE_REGISTRY.md` asociada a `task_id`.
4. actualizacion de `PROJECT_STATE.md` y `ARTIFACT_MANIFEST.md`.
5. veredicto `PASS` o `BLOCKED` con logs.

No se acepta una afirmacion conversacional de completitud.

## 1. Auditoria factual

### 1.1 Baseline del repositorio

| Area | Estado real auditado | Consecuencia |
|---|---|---|
| Git | 3 commits; working tree con cambios P0 y varios archivos no trackeados | No existe baseline limpio para atribuir todos los cambios |
| Hooks | 10 scripts en `.claude/hooks/`; 9 historicos + `task-completed-evidence.sh` | README aun declara 9 |
| Settings | JSON valido en working tree; `HEAD` contiene comentarios `//` invalidos | P0.1 depende de un cambio local aun no consolidado |
| Skills | 22 directorios: 6 context, 11 historicas y 5 nuevas | README aun declara 11 skills |
| Agents | 4 templates | No existe reviewer independiente ni test engineer |
| Rules | 4 reglas | Son guidance; no tienen enforcement estructural propio |
| Context packs | 6 packs con placeholders de instalacion | No representan aun un proyecto configurado |
| Estado | `PROJECT_STATE.md` existe localmente y es minimo; `CURRENT_STATE.md` sigue con placeholders | Estado y mirror no son consistentes |
| Registros | `DECISION_REGISTRY.md`, `ARTIFACT_MANIFEST.md` y `EVIDENCE_REGISTRY.md` no estan presentes en el root auditado | Skills y docs referencian fuentes ausentes |
| Incidentes | `INCIDENT_REGISTRY.md` y template creados, sin incidentes | Registro existe, pero no hay control/regression registry |
| Tests | No existe directorio `tests/` ni suite del control plane | No hay regresion automatizada para installer, hooks o skills |
| Docs | Research y `DESIGN.md` existen; README no refleja P0 | Documentacion de arquitectura y runtime diverge |

### 1.2 P0 realmente implementado

#### P0.1 — settings JSON

- `install.sh` valida la fuente con `jq` y la reserializa antes de instalar (`install.sh:40-49`).
- El archivo fuente de `HEAD` sigue siendo invalido por comentarios; el working tree los removio.
- La correccion no esta completa hasta que el archivo fuente valido y el instalador formen un
  mismo estado versionado.
- Validacion realizada: `bash -n install.sh`, `jq empty`, instalacion en directorio temporal.

#### P0.2 — TaskCompleted Evidence gate

- Hook creado: `.claude/hooks/task-completed-evidence.sh`.
- Wiring creado en `.claude/settings.json:130-141` sin matcher, coherente con TaskCompleted.
- Bloquea con `exit 2` si falta `jq`, registry, JSON valido, `task_id` o entrada `Status: VERIFIED`.
- Busca primero `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` y luego `EVIDENCE_REGISTRY.md` en root.
- La skill `/evidence` escribe instrucciones para `Task ID` y `Status`, pero no crea ni valida el
  registry de forma automatica.
- Riesgo: el gate valida texto Markdown por coincidencia, no un schema/hash/checks/reviewer signature.
- Validacion realizada: caso BLOCK con task desconocida y caso PASS con entrada VERIFIED.

#### P0.3 — skills SDLC

Existen cinco nuevas skills locales: las cuatro solicitadas y `/incident`. Las cuatro de workflow
contienen trigger, flujo, anti-racionalizaciones, trust boundary y convergencia. No tienen evals
Tier 1/2/3, fixtures ni tests de routing.

#### P0.4 — incident learning

- `/incident` existe y define `OPEN -> ... -> CLOSED`.
- `INCIDENT_REGISTRY.md` y `templates/INCIDENT_REGISTRY.md` existen.
- `install.sh` copia el template.
- No existen `CONTROL_REGISTRY.md`, `REGRESSION_REGISTRY.md`, hook `PostToolUseFailure` ni gate que
  impida cerrar un incidente sin regresion.

### 1.3 Dependencias rotas detectadas

1. `install.sh` copia `.claude/context/*.md`, pero no copia `.claude/skills/context-*`; los agentes
   instalados pueden referenciar skills que no existen en el proyecto destino.
2. Los agents usan `skills:` en frontmatter (`.claude/agents/*.md:9`), pero ambas investigaciones
   indican que Claude Code no documenta ese campo como mecanismo estandar de carga.
3. `/doctor` espera 9 hooks y no incluye `task-completed-evidence.sh`; `/audit-config` no exige
   `TaskCompleted` y exige `PostToolUse`, que no esta configurado.
4. `/evidence` declara `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`, mientras el hook permite tambien el
   root y el template de incidentes vive en root.
5. `README.md` declara 9 hooks, 11 skills y 4 templates raiz, pero el estado actual tiene 10 hooks,
   16 process/context skills instalables y un template raiz adicional.
6. `recovery` referencia `docs/00_SYSTEM/10_RECOVERY_PROTOCOLS.md`, archivo no presente en el
   baseline auditado.
7. `PROJECT_STATE.md` local no contiene todos los campos definidos en `docs/DESIGN.md:78-96`, y
   `CURRENT_STATE.md` continua siendo un template no sincronizado.

## 2. Clasificacion de arquitectura

### KEEP

- Separacion Context / State / Memory / Control / Execution / Verification.
- Alcance por proyecto en `.claude/` y no modificacion de producto destino.
- `PROJECT_STATE.md` como fuente unica de estado operativo.
- Reglas de fail-closed para `bash-firewall`, `secret-guard` y el evidence gate.
- Hooks existentes de seguridad, SessionStart, PreCompact y logging, con su distincion P0/P1/P2.
- Permisos `allow / ask / deny` y proteccion de secretos.
- Skills operativas existentes (`/estado`, `/gate`, `/cerrar-fase`, `/doctor`, `/recovery`, etc.).
- Adopcion selectiva de los cuatro workflows, no instalacion completa de un framework externo.

### REFACTOR

- `install.sh`: fuente valida, copia de context skills, registry de evidencia, templates y smoke test.
- `settings.json`: schema, wiring y contrato de eventos; mantener JSON estricto.
- Evidence gate: pasar de coincidencia Markdown a contrato estructurado versionado y trazable.
- `/evidence`: unica ruta y schema compatible con el hook.
- `/doctor` y `/audit-config`: inventario generado desde el wiring real, sin contadores hard-coded.
- `/audit-context`: comprobar existencia de todas las fuentes antes de comparar mirrors.
- Agentes: retirar la dependencia de `skills:` como enforcement y usar mecanismo documentado de
  bootstrap/context injection; conservar el campo solo si una prueba de runtime lo demuestra.
- README y DESIGN: reconciliar cantidades, rutas, niveles de enforcement y estado real.

### INTEGRATE

- Contrato Evidence-based Definition of Done de ambas investigaciones.
- Taxonomia L0-L8 como lenguaje de riesgo, no como hook para cada regla.
- TDD, code review, doubt y constraints como lanes seleccionadas por riesgo.
- Incident -> Root Cause -> Missing Control -> Regression -> Verify -> Accept.
- Provenance `EXTRACTED / INFERRED / ASSUMED / EXTERNAL / GENERATED` en evidencia.
- Evals de skills con Tier 1 estructural, Tier 2 routing y Tier 3 comportamiento.

### REMOVE

- Comentarios `//` dentro de JSON.
- Conteos hard-coded y afirmaciones de capacidades no verificadas en README, `/doctor` y
  `/audit-config`.
- Dependencia arquitectonica de `skills:` si el runtime test no prueba que carga skills.
- Rutas de registry duplicadas; se elegira una fuente unica.
- Todo future hook o skill que no elimine un riesgo demostrable.
- Instalacion completa de `agent-skills`, Superpowers, Spec Kit o un plugin manager propio.

### BUILD

- Suite de tests del control plane.
- Evidence registry canonico y schema validable.
- Contract checks para TaskCompleted, installer y settings.
- Reviewer independiente o mecanismo equivalente de fresh context para cambios que lo requieran.
- `CONTROL_REGISTRY.md` y `REGRESSION_REGISTRY.md` cuando se ejecute la fase de incident learning.
- Fixtures y evals de routing/behavior para las skills nuevas.
- Integridad de estado: snapshot, hash de campos criticos y deteccion de drift.

## 3. Enforcement y ownership

| Nivel | Mecanismo actual | Estado | Accion del plan |
|---|---|---|---|
| L0 | README, CLAUDE template, rules | Existe | Reducir duplicacion y claims no verificados |
| L1 | Context packs | Existe como template | Instalar y validar ownership/source of truth |
| L2 | Skills | Existe | Agregar evals y routing por riesgo |
| L3 | permissions en settings | Existe | Validar schema y no ampliar allow-list por defecto |
| L4 | tests/lint/schema/mutation | Parcial; no suite del plane | Construir checks deterministas minimos |
| L5 | bash-firewall, secret-guard, TaskCompleted | Existe | Hardening y tests de fail-closed/fail-open |
| L6 | reviewer fresh-context | No existe | Construir solo para riesgo medium/high/critical |
| L7 | cross-model | No existe | Fuera del baseline; solo demanda posterior |
| L8 | gates humanos documentados | Guidance | Formalizar para hooks, permisos, security y cambios irreversibles |

Regla: low risk usa L1-L4; medium usa L4 + review cuando aporte; high usa L4-L6; cambios
irreversibles o de trust boundary requieren L8.

## 4. Estado, evidencia y fuentes de verdad

### Fuentes canonicas propuestas

| Dato | Fuente unica | Mirrors permitidos |
|---|---|---|
| Estado operativo | `PROJECT_STATE.md` | `.claude/context/CURRENT_STATE.md` |
| Decisiones | `DECISION_REGISTRY.md` | `.claude/context/DECISIONS.md` |
| Entregables | `ARTIFACT_MANIFEST.md` | ninguno |
| Evidence de cambios | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | ninguno |
| Incidentes | `INCIDENT_REGISTRY.md` | ninguno |
| Controles derivados | `CONTROL_REGISTRY.md` | ninguno |
| Regresiones | `REGRESSION_REGISTRY.md` | ninguno |

La fase de fundacion debe crear las fuentes ausentes antes de exigirlas desde hooks. Un hook no
debe aceptar dos ubicaciones ambiguas indefinidamente.

### Evidence Contract minimo

Cada entrada debe contener `evidence_id`, `task_id`, `artifact_hash`, `contract_hash`, checks
ejecutados, reviewer status, exceptions, timestamp y provenance. `VERIFIED` solo es valido si los
checks requeridos del nivel de riesgo pasan y no hay excepciones sin aprobacion.

## 5. Fases de implementacion

### Fase 0 — Baseline y contrato

**Objetivo:** congelar el inventario real y aprobar este plan.
**Entradas:** research, repo, P0 working tree.
**Salidas:** este documento, decision de rutas canonicas, matriz de riesgo y lista de archivos.

**Gate:** plan validado; ninguna implementacion nueva antes de este gate.

### Fase 1 — Fundacion instalable y estado coherente

**Resultado actual:** PASS — EV-001 — F2 permanece pendiente y no fue implementada.

**Objetivo:** que una instalacion limpia produzca exactamente la arquitectura documentada.

**Trabajo:**

- Consolidar `settings.json` valido en la fuente versionada.
- Hacer que `install.sh` copie context skills y todos los templates necesarios.
- Crear `PROJECT_STATE`, `DECISION_REGISTRY`, `ARTIFACT_MANIFEST` y evidence registry canonicos.
- Resolver la ruta unica de evidencia.
- Reconciliar `/doctor`, `/audit-config`, `/audit-context`, README y DESIGN con el wiring real.
- Resolver la carga de contexto de agentes con prueba de runtime o retirar la dependencia.

**Evidence:** instalacion en proyecto temporal, manifest de archivos, `jq`, schema checks y diff.
**Dependencias:** Fase 0.
**No hacer:** agregar nuevos hooks o skills.

### Fase 2 — Evidence Contract y TaskCompleted hardening

**Resultado actual:** PASS — EV-002 — F3 no fue implementada antes de cerrar F2.

**Objetivo:** que `done` dependa de evidencia verificable y no de texto libre.

**Trabajo:**

- Definir schema canonico de evidence y validador determinista.
- Actualizar `/evidence` para producir exactamente ese schema.
- Hacer que TaskCompleted valide `task_id`, entry, hash, checks, reviewer y exceptions segun riesgo.
- Agregar matriz de casos: missing registry, malformed JSON, unknown task, stale evidence, PASS y
  exception no aprobada.
- Documentar recovery para falsos positivos sin desactivar el hook.

**Evidence:** logs BLOCK/PASS, fixture matrix, hash de artifact y entrada VERIFIED.
**Dependencias:** Fase 1.
**Gate:** fail-closed ante incertidumbre; no aceptar evidence stale.

### Fase 3 — SDLC lanes y verificacion independiente

**Resultado actual:** PASS — EV-005 — Tier 1/2 PASS y dos corridas Tier 3 autenticadas con firma normalizada identica.

**Objetivo:** convertir las cuatro skills en workflows medibles, no solo Markdown orientativo.

**Trabajo:**

- Validar frontmatter y descripciones de routing.
- Crear positive, negative y collision fixtures para cada skill.
- Crear behavioral fixtures para RED/GREEN, findings de review, dudas y bypasses.
- Definir risk routing para elegir una o varias lanes sin imponer agentes innecesarios.
- Añadir reviewer fresh-context solo donde el riesgo lo justifique.
- Integrar la salida de cada lane con el Evidence Contract.

**Evidence:** Tier 1 structural, Tier 2 routing, Tier 3 behavioral y reporte de varianza.
**Dependencias:** Fases 1 y 2.
**No hacer:** mutation gate global arbitrario de 80%; usar sampling por riesgo.

### Fase 4 — Incident learning cerrado

**Resultado actual:** PASS — EV-006 — INC-001 CLOSED, CTRL-001 ACTIVE, REG-001 ACTIVE, fixture y review independiente PASS.

**Objetivo:** que un incidente produzca proteccion contra regresion.

**Trabajo:**

- Validar y estabilizar `/incident` y `INCIDENT_REGISTRY.md`.
- Crear `CONTROL_REGISTRY.md` y `REGRESSION_REGISTRY.md` solo ahora, porque dependen del schema
  de evidence y de los checks de Fase 2.
- Formalizar 5 Whys, reproducer pre-fix, control proposal, regression y close gate.
- Integrar fallos capturados cuando exista un evento reactivo apropiado; no tratar PostToolUseFailure
  como bloqueo.
- Exigir aprobacion humana para hooks P0, permissions, security rules y trust boundaries.

**Evidence:** un incidente fixture que falla sin control, pasa con control y queda CLOSED con links.
**Dependencias:** Fases 1-3.
**Gate:** ningun P0/P1 se cierra sin regresion.

### Fase 5 — Integridad de estado y provenance

**Resultado actual:** PASS — EV-007 — hash critico, drift fixture, provenance y smoke test PASS.

**Objetivo:** detectar drift entre snapshots, mirrors, decisiones y evidencia.

**Trabajo:**

- Hash de campos criticos en PreCompact/PostCompact o equivalente verificable.
- Ownership explicito de STATE vs MEMORY vs CONTEXT vs EVIDENCE.
- Provenance en evidence y research.
- `/doctor` como smoke test reproducible del harness.

**Evidence:** drift fixture, hash mismatch detectado y recovery documentado.
**Dependencias:** Fases 1-4.

### Fase 6 — Evals y mantenimiento

**Resultado actual:** PASS — EV-008 — maintenance suite, CI workflow, regression budget y baseline comparable PASS.

**Objetivo:** evitar regresiones del propio control plane.

**Trabajo:**

- CI para schema, installer, hooks, skills y docs references.
- Benchmark de pass rate, tiempo, tokens y varianza.
- Regression budget para cambios al harness.
- Auditoria periodica de evidence para evitar evidence theater.

**Evidence:** reporte CI y baseline comparable entre commits.
**Dependencias:** todas las fases anteriores.

## 6. Matriz de dependencias

```text
F0 Plan validado
  -> F1 fuentes canonicas + instalacion + wiring auditado
      -> F2 evidence contract + TaskCompleted
          -> F3 skills + risk routing + independent review
              -> F4 incident -> control -> regression
                  -> F5 state integrity + provenance
                      -> F6 evals + CI + maintenance
```

Bloqueos duros:

- F2 no arranca sin registry canonico y schema de evidencia.
- F3 no declara una skill operativa sin evals y evidencia.
- F4 no cierra incidentes sin regression test/eval.
- F5 no crea otra fuente de estado.
- F6 no acepta una mejora que reduzca el regression budget.

## 7. Criterio de aceptacion global

El plan se considera materializado solo cuando:

- una instalacion limpia produce archivos, permisos y wiring coherentes;
- todos los hooks configurados aparecen en auditoria automatica;
- un TaskCompleted sin evidencia bloquea y uno con contrato valido pasa;
- las cuatro skills tienen evals estructurales, routing y comportamiento;
- un incidente fixture produce control y regresion verificables;
- mirrors y estado detectan drift;
- cada fase tiene evidence entry con `task_id` y hashes;
- no existen rutas duplicadas ni claims de capacidades no probadas;
- el CI reproduce los checks sin depender de contexto conversacional.

## 8. Items explicitamente fuera del plan inicial

- Instalar todos los plugins externos.
- Construir un plugin manager propio.
- Agent Teams como dependencia del core.
- Dashboard de observabilidad antes de medir demanda.
- Cross-provider fallback.
- Mutation testing global sin baseline de coste y riesgo.
- Nuevos hooks solo por completar el catalogo de eventos.
