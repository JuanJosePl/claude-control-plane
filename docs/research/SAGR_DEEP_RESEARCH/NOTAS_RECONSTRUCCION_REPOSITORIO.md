# Notas de reconstrucción del repositorio para SAGR

**Fecha de inspección:** 2026-09-21  
**Repositorio objetivo:** `/home/juanls/Escritorio/claude-control-plane`  
**Rama:** `main`  
**HEAD observado:** `74f7d1e8d28f2f960a574b98df62208c4695b220` (`74f7d1e`)  
**Base remota observada:** `origin/main` en `b6e8fd0`; HEAD local está 37 commits por delante.  
**Escritura realizada por esta investigación:** únicamente este archivo.  
**Runtime, hooks, skills, evals, registries y archivos fuera de este directorio:** no modificados.

## 0. Método y autoridad

Esta nota reconstruye el repositorio a partir del contenido y del historial que existen en el
checkout, no a partir de una narrativa previa. La precedencia aplicada fue:

1. Archivos ejecutables y wiring actual (`.claude/settings.json`, hooks, `install.sh`, evals).
2. Estado Git actual, commits, diffs y modo de archivo.
3. Salidas de checks persistidas en evals y registros canónicos.
4. `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md`, `DECISION_REGISTRY.md` y registries de evidencia.
5. Auditorías y handoffs históricos, conservando su fecha y alcance.
6. Documentos de `docs/research/`, tratados como investigación con labels y limitaciones propias.
7. `docs/research/CCP_SAGR_RESEARCH_DOSSIER.md`, tratado solamente como artefacto no versionado
   que había que inspeccionar. No se usa como autoridad para establecer el estado del repositorio,
   ni para validar sus afirmaciones técnicas, comerciales o externas.

### Etiquetas de provenance usadas aquí

- **FACT:** contenido directamente visible en un archivo o en Git.
- **OBSERVED:** comportamiento registrado por un comando, fixture o auditoría; no implica que se
  haya vuelto a ejecutar en esta inspección.
- **SCRIPT VERIFIED:** script y fixture ejecutados en el entorno disponible; no prueba el dispatcher
  nativo de Claude Code.
- **CLAIM:** afirmación de un documento cuya frontera de verificación sigue aplicando.
- **UNKNOWN / NOT VERIFIED:** la evidencia disponible no permite concluir.
- **NOT REEXECUTED:** existe un resultado histórico, pero esta reconstrucción no lo repitió.
- **NOT OBSERVED IN THIS REPOSITORY:** ausencia en el árbol/wiring objetivo; no significa ausencia
  universal del mercado.

La separación entre script y runtime nativo es explícita en la documentación del sistema: el dossier
técnico distingue `SCRIPT VERIFIED` de `CLAUDE RUNTIME VERIFIED` y afirma que OpenCode no prueba
dispatcher, matchers, ordenamiento ni reentrada nativos (`docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md:715-725`).
La misma frontera aparece en el Handbook (`docs/CONTROL_PLANE_HANDBOOK.md:1005-1007`) y en el
informe F8 (`docs/00_SYSTEM/POST_F8_AUDIT_REPORT.md:122-138`).

## 1. Dictamen ejecutivo

1. El repositorio es la fuente de un **harness de control para Claude Code a nivel de proyecto**,
   no una aplicación de producto. El README lo define como un harness pequeño alrededor del agente,
   separado de un segundo agente, una colección de prompts o un plugin manager
   (`README.md:23-37`). El bootstrap confirma que `.claude/` es infraestructura de control y no
   código de negocio (`CLAUDE.md:1-5`).

2. El runtime actual está congelado en la arquitectura cerrada por F8. `PROJECT_STATE.md` informa
   fase 8 completa, F9 investigada, decisión `F9 NOT JUSTIFIED`, implementación F9 no autorizada y
   F10-F12 sin iniciar (`PROJECT_STATE.md:5-29`). El mirror compacto confirma que el gate de decisiones
   F9 está cerrado y que la siguiente acción requiere una decisión nueva del owner
   (`.claude/context/CURRENT_STATE.md:24-59`).

3. F1-F8 tienen evidencia documental y fixtures. El resultado no debe sobreinterpretarse: la suite
   prueba scripts, fixtures, hashes de campos y wiring estático; no prueba el ciclo de vida nativo
   completo de Claude Code. La evidencia F8 declara `12/12 PASS` para maintenance, pero también
   `Native Claude Code verified: NO` (`docs/00_SYSTEM/POST_F8_AUDIT_REPORT.md:56-65`, `:122-138`).

4. La investigación SAGR no existe como runtime en este repositorio. Lo que sí existe es un conjunto
   de primitivas parciales de recuperación: snapshot/hash de estado antes de compactar, detección de
   drift al reanudar, rollback Git documentado y una skill `/recovery` manual. No existe un health
   monitor de trayectoria, clasificador `RECOVERABLE STOP`/`HARD STOP`, presupuesto separado de
   recuperación, exploración acotada de ramas, adjudicador, side-effect ledger o audit trail de
   stalls en el árbol/wiring actual. Esta conclusión es una **ausencia observada en el repositorio**,
   no una afirmación de ausencia universal.

5. La evidencia de mercado no autoriza extrapolar SAGR a producto. Los protocolos de campo dicen
   expresamente que no hubo entrevistas, no existe WTP y no existe PMF (`docs/research/CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md:7-15`, `:179-188`).
   El teardown AIGIS sí es una prueba reproducible de un competidor, pero fue acotado a ese proyecto,
   a un commit y a un entorno temporal; incluso deja benchmarks y security suite sin reproducir
   (`docs/research/CLAUDE_CONTROL_PLANE_AIGIS_TEARDOWN.md:18-49`, `:104-119`).

6. El checkout ya estaba sucio antes de esta nota: `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md` estaba
   modificado y `docs/research/CCP_SAGR_RESEARCH_DOSSIER.md` estaba sin seguimiento. No se revirtieron.
   El `git diff --check` previo a esta escritura reportó whitespace final en líneas agregadas del
   session log (`CLAUDE_SESSION_LOG.md:17,23,29,41,47`); no se corrigió porque pertenece al estado
   preexistente y la solicitud prohíbe modificar fuera del directorio de salida.

## 2. Snapshot factual del checkout

### 2.1 Git y worktree

| Hecho | Resultado | Provenance |
|---|---|---|
| Repositorio | `/home/juanls/Escritorio/claude-control-plane` | `pwd`, inspección 2026-09-21 |
| Rama | `main` | `git branch --show-current`, inspección 2026-09-21 |
| HEAD | `74f7d1e` | `git rev-parse HEAD`, commit `74f7d1e` |
| Relación con origin | 0 commits detrás / 37 por delante de `origin/main` (`b6e8fd0`) | `git rev-list --left-right --count origin/main...HEAD` |
| Archivos versionados | 115 | `git ls-files`, inspección 2026-09-21 |
| Worktree antes de esta nota | `M docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`; dossier SAGR no versionado | `git status --short --untracked-files=all` |
| Dossier SAGR | No versionado; no es parte del HEAD | `git status`, `git ls-files` |
| Escritura de esta nota | Un archivo nuevo dentro de `docs/research/SAGR_DEEP_RESEARCH/` | alcance de esta tarea |

El HEAD actual es el commit de preparación de validación de campo, no el commit base declarado
por el dossier SAGR. La diferencia es material: el dossier declara baseline `035a573` en su línea 6,
pero el checkout actual contiene además `74f7d1e`. El commit `74f7d1e` es documental y explícitamente
declara que no hubo entrevistas, runtime modificado, buyer identificado, WTP, piloto ni F10
(`git show 74f7d1e`, mensaje del commit; `docs/research/CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md:1-15`).

### 2.2 Árbol y cantidades

El árbol raíz contiene `.claude/`, `.github/`, `.git/`, `docs/`, `evals/`, `templates/`, los seis
archivos de estado/registro de raíz, `install.sh`, `README.md`, `CLAUDE.md` y `.gitignore`. El mapa
documental del README coincide en lo esencial con ese árbol (`README.md:188-213`), pero sus conteos
históricos no deben usarse sin contrastar el runtime.

| Superficie | Cantidad observada | Provenance |
|---|---:|---|
| Hooks ejecutables | 10 | `.claude/hooks/`, `git ls-files` |
| Agents | 5 | `.claude/agents/`, `git ls-files` |
| Context packs | 6 | `.claude/context/`, `git ls-files` |
| Rules | 4 | `.claude/rules/`, `git ls-files` |
| Skills | 22 | `.claude/skills/*/SKILL.md`, `git ls-files` |
| Archivos de eval | 16 | `evals/`, `git ls-files` |
| Templates instalables | 8 | `templates/`, `templates/:1-8` |
| Docs de `docs/00_SYSTEM/` versionados | 19 | `git ls-files docs/00_SYSTEM/*` |
| Docs Markdown de `docs/` raíz | 4 | `git ls-files docs/*.md` |
| Research Markdown versionados | 9 | `git ls-files docs/research/*.md` |

`.gitignore` solo ignora `.history/` y `.claude/backups/` (`.gitignore:1-2`). Por tanto, el dossier
SAGR y cualquier otra salida documental que se deje en `docs/research/` aparece en el estado del
worktree salvo que se agregue explícitamente a Git.

### 2.3 Permisos y checks no mutantes

- `.claude/hooks/*.sh` y `evals/**/*.sh` están marcados ejecutables (`100755` en `git ls-files --stage`).
- `install.sh` está versionado como `100644`, pero se invoca con `bash install.sh`; el modo ejecutable
  no es requisito del flujo documentado (`README.md:39-49`).
- `jq empty .claude/settings.json` terminó sin salida y `bash -n` sobre installer, hooks y evals
  terminó sin salida: sintaxis/JSON válidos en esta inspección. Estos son checks de sintaxis, no una
  ejecución de los hooks dentro de Claude Code.
- `git diff --check` falló únicamente por trailing whitespace en el cambio preexistente del session
  log. No se ejecutó ninguna reparación automática.

## 3. Historia de implementación reconstruida

### 3.1 Secuencia de commits

| Tramo | Commits relevantes | Lectura objetiva |
|---|---|---|
| Fundación | `c39595b`, `58bdc3d`, `e679b46`, `a76d880`, `e9694db`, `04dad9c`, `b6e8fd0` | Control plane v1, templates, plan, traducción, Handbook y bootstrap |
| F7 | `37662b4` hasta `47874a5` | Hardening conductual de Stop, firewall, evidence coupling, rotación, installer y cierre documental |
| F8 | `c236b58`, `f840c71`, `0f79b68`, `92050dd`, `e25179f`, `1427fbe`, `95f1555`, `916acf7`, `2cd7953` | Investigación, dos cierres fail-closed, reviewer convention, evidencia/regresión y congelamiento |
| F9 | `bfe03b7` | Investigación documental: `F9 NOT JUSTIFIED`, sin runtime |
| Post-F9 | `9a52875`, `05c78ac`, `10a60d9` | Historia técnica, reconciliación documental y cierre de decisiones del owner |
| Investigación comercial | `0433d2c`, `07cc702`, `5980863`, `01fe762`, `035a573`, `74f7d1e` | Auditoría/closure loop, buyer/competitive protocols, reconstrucción zero-based, teardown AIGIS y Round 0 de field validation; sin runtime |

El `git show --stat` de los commits post-F9 confirma que `9a52875` solo agrega el dossier técnico,
`10a60d9` solo toca documentación/estado/mirror/handoff, y los commits de market research solo
tocan `docs/research/`. El commit `035a573` agrega el teardown AIGIS y actualiza su auditoría; el
HEAD `74f7d1e` agrega el packet de field validation y su sección de auditoría. Ninguno declara un
path de runtime modificado. Provenance: estadísticas Git de esos commits.

### 3.2 F7 y F8 como cambios reales de runtime

- F7 reutilizó componentes existentes y dejó EV-009..EV-014 y REG-002..REG-009. El historial técnico
  enumera los bundles y sus commits (`docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md:370-557`).
- F8 cambió dos hooks existentes y extendió dos fixtures: `task-completed-evidence.sh` para exigir
  `contract_hash` y `bash-firewall.sh` para payloads JSON fail-closed
  (`docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md:865-930`).
- EV-015/EV-016 y REG-010/REG-011 son los artefactos de cierre F8
  (`docs/00_SYSTEM/EVIDENCE_REGISTRY.md:260-292`, `REGRESSION_REGISTRY.md:101-117`).
- F9 y toda la investigación comercial posterior son documentación; no hay un commit posterior a
  F8 que agregue hook, skill, agent, regla, dependencia, fixture de runtime o schema SAGR.

## 4. Estado operativo, fuentes de verdad y drift

### 4.1 Fuente declarada

`CLAUDE.md` manda leer Master Plan, estado, manifest, diseño, Handbook, evidence registry y Git antes
de modificar (`CLAUDE.md:1-12`). También establece `AUDIT → IMPLEMENT → TEST → VERIFY → EVIDENCE → GATE`,
prohíbe iniciar una fase sin PASS y obliga a marcar claims no verificables como `UNKNOWN` o `BLOCKED`
(`CLAUDE.md:14-23`).

`PROJECT_STATE.md` se declara fuente única de estado (`PROJECT_STATE.md:1-4`) y contiene:

| Campo | Valor actual |
|---|---|
| `CURRENT_PHASE` | `8` |
| `PHASE_STATUS` | `COMPLETE` |
| `CURRENT_OBJECTIVE` | F8 cerrada, F9 investigada y owner gate cerrado |
| `BLOCKERS` | `NONE` |
| `ACTIVE_DECISIONS` | `ARCH-001`..`ARCH-004` |
| `LAST_GIT_CHECKPOINT` | `9a52875` |
| `F9_RESEARCH_STATUS` | `COMPLETE` |
| `F9_DECISION` | `F9 NOT JUSTIFIED` |
| `F9_IMPLEMENTATION` | `NOT AUTHORIZED / NOT PERFORMED` |
| `NEXT_ALLOWED_PHASE` | Ninguna automática; decisión nueva del owner |
| `IMPLEMENTATION_READY` | `false` |

Provenance: `PROJECT_STATE.md:5-29`.

### 4.2 Estado derivado y mirrors

`.claude/context/CURRENT_STATE.md` refleja F1-F8 completas, F9 research complete, F10-F12 unknown,
las cinco decisiones F9 y la instrucción de no abrir F10 automáticamente
(`.claude/context/CURRENT_STATE.md:24-59`). `.claude/context/DECISIONS.md` contiene los cuatro
ARCH activos y el addendum de ARCH-004 (`.claude/context/DECISIONS.md:19-29`), consistente con
`DECISION_REGISTRY.md:6-45`.

La prioridad de estado está documentada en `DESIGN.md`: `PROJECT_STATE.md` manda sobre su mirror y
los registries canónicos mandan sobre sus resúmenes (`docs/DESIGN.md:42-53`, `:79-100`).

### 4.3 Drift comprobable en el snapshot actual

1. `PROJECT_STATE.md:13` conserva `LAST_GIT_CHECKPOINT: 9a52875`, pero el HEAD observado es
   `74f7d1e`. El hash `9a52875` existe en Git, pero no es el checkpoint más reciente. Esto es un
   estado documental stale, no evidencia de corrupción de runtime.
2. `ARTIFACT_MANIFEST.md:70-83` deja F9-F12 como `UNKNOWN / RESEARCH REQUIRED` y dice que no existe
   definición/evidencia/implementación histórica de esas fases. Después existen `F9_RESEARCH.md`,
   `F9_OWNER_DECISIONS.md` y varios commits de investigación. El manifest es un registro de
   entregables por fases y no se actualizó para reflejar el cierre documental F9.
3. `SESSION_HANDOFF_CURRENT.md` contiene una instrucción histórica anterior que dice `NEXT_ALLOWED_ACTION
   = F9 RESEARCH ONLY` en `:240-255`, pero su sección 21 posterior supersede esa frase y registra que
   la siguiente acción es una decisión nueva del owner (`:355-400`). Esto debe leerse como documento
   con historial interno, no como una única línea vigente aislada.
4. `docs/DESIGN.md:199-207` conserva un mapa de ARCH-004/ARCH-005 que no coincide con el registro
   actual, donde ARCH-004 es Task Tracking Semantics (`DECISION_REGISTRY.md:34-45`). El propio F8
   dejó ese drift fuera de alcance (`POST_F8_AUDIT_REPORT.md:10-20`, `:103-110`).
5. El session log modificado registra un `CONFIG CHANGE` sin source/keys en sus líneas 50-51 y tiene
   trailing whitespace en varias líneas agregadas. No se atribuye a esta investigación.

La skill `/audit-context` define exactamente que el hash debe existir en Git y que divergencias entre

## 5. Arquitectura real

### 5.1 Capas

La separación declarada es Context, State, Memory, Control, Execution y Verification
(`docs/DESIGN.md:8-40`). En el runtime observado se materializa así:

| Capa | Implementación real | Fuerza observada |
|---|---|---|
| Context | `CLAUDE.md`, 4 rules, 6 packs, 6 context skills | Guidance e inyección por hook |
| State | `PROJECT_STATE.md`, `CURRENT_STATE.md`, manifest, decision registry | Markdown; source of truth por tipo |
| Evidence | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | Registry Markdown leído por hook |
| Control | settings, permissions y hooks | P0 bloqueante en tres hooks; resto fail-open/logging |
| Execution | 5 agents y 22 skills | Tool limits + instrucciones; no todos tienen enforcement propio |
| Verification | maintenance, fixtures, phase gate, TaskCompleted, reviewer | Determinista en scripts; runtime nativo no verificado |
| Learning | incident/control/regression registries | Un ciclo orgánico completo: INC-001 → CTRL-001 → REG-001 |

El Handbook describe la diferencia entre guidance y enforcement: reglas Markdown orientan; hooks y
permisos hacen enforcement (`docs/CONTROL_PLANE_HANDBOOK.md:281-313`). El nivel L0-L8 aparece como
taxonomía de diseño, no como metadata estructural uniforme en cada rule/skill
(`docs/DESIGN.md:171-186`).

### 5.2 Trust boundary

La frontera efectiva es Git + revisión humana/fresh-context. El artifact hash se valida por forma,
no se recomputa contra un conjunto de archivos; el reviewer es una convención documental y no una
identidad criptográfica. Esto está documentado en la explicación del evidence gate
(`docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md:605-636`) y en las limitaciones F8
(`docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md:999-1034`).

`F9_OWNER_DECISIONS.md` mantiene esa frontera a esta escala y exige un trigger externo antes de
ampliarla: auditoría, compliance, contrato, cliente, expansión explícita del trust boundary o cambio
organizativo (`docs/00_SYSTEM/F9_OWNER_DECISIONS.md:140-168`).

## 6. Runtime y wiring de hooks

### 6.1 Wiring efectivo

`.claude/settings.json` es JSON estricto y conecta ocho tipos de evento con diez scripts
(`.claude/settings.json:21-141`):

| Evento | Matcher | Script | Modo declarado |
|---|---|---|---|
| `SessionStart` | `startup\|resume\|fork` | `session-start-startup.sh` | P1 fail-open |
| `SessionStart` | `compact\|clear` | `session-start-compact.sh` | P1 fail-open |
| `PreToolUse` | `Bash` | `bash-firewall.sh` | P0 fail-closed |
| `PreToolUse` | `Write\|Edit` | `secret-guard.sh` | P0 fail-closed |
| `SubagentStart` | `*` | `subagent-context.sh` | P2 fail-open |
| `SubagentStop` | `*` | `subagent-stop-logger.sh` | P2 fail-open |
| `Stop` | `*` | `stop-logger.sh` | P2 fail-open |
| `PreCompact` | `manual\|auto` | `pre-compact-snapshot.sh` | P1 fail-open |
| `ConfigChange` | `*` | `config-change-logger.sh` | P1 fail-open |
| `TaskCompleted` | sin matcher | `task-completed-evidence.sh` | P0 fail-closed |

No hay `PostToolUse`, `PostToolUseFailure`, `PostCompact`, `FileChanged`, `PermissionRequest`,
`WorktreeCreate` ni `WorktreeRemove` cableados en este repositorio. `PostToolUseFailure` aparece en
la investigación como posibilidad diferida, pero no en el wiring actual. Provenance: settings y
`docs/research/CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md:559-573`.

Los permisos son defensa en profundidad: allow de comandos de lectura/gestión y Git, ask para
`git push` y `rm`, deny para `.env`, secrets, claves privadas, SSH y AWS credentials
(`.claude/settings.json:1-19`). La amplitud de varios `Bash(...)` allow es un hecho de configuración;
no se infiere por sí sola que sea una vulnerabilidad explotable.

### 6.2 Hooks P0

**`bash-firewall.sh`.** Lee stdin a un temporal, rechaza NUL, exige un documento JSON único y usa
`jq` para extraer `.tool_input.command` (`.claude/hooks/bash-firewall.sh:7-28`). Después aplica un
conjunto finito de regex para borrado, dispositivos, fork bomb, SQL, secretos, `.env`, claves y
`curl|bash` (`:30-70`). Si falta `jq`, bloquea (`:16-20`). Un comando vacío dentro de JSON válido
permanece permitido (`:27-28`). El diseño no es un parser de shell y no afirma cubrir obfuscación
arbitraria.

**`secret-guard.sh`.** Extrae `content`/`new_string` y `file_path`, permite contenido vacío y
placeholders salvo que contenga una private key real (`.claude/hooks/secret-guard.sh:6-31`), y
bloquea PEM, `sk-`, Bearer, AWS, JWT y asignaciones de secretos (`:33-45`).

**`task-completed-evidence.sh`.** Exige `jq`, registry, JSON válido, `task_id`, riesgo válido,
entrada `VERIFIED`, hashes no vacíos, checks, reviewer para riesgos medium+, exceptions y timestamp
(`.claude/hooks/task-completed-evidence.sh:13-71`). F8 exige que `contract_hash` esté presente y
no vacío después de la validación (`:22-29`, `:73-81`). El lookup sigue siendo textual/Markdown y
no recomputa el hash del artifact.

### 6.3 Hooks de estado y logging

- `session-start-startup.sh` extrae estado operativo y lo inyecta como `additionalContext`, sin
  bloquear (`.claude/hooks/session-start-startup.sh:1-30`).
- `pre-compact-snapshot.sh` copia `PROJECT_STATE.md`, hashea cinco campos críticos y devuelve
  `PreCompact` context (`.claude/hooks/pre-compact-snapshot.sh:1-30`).
- `session-start-compact.sh` recompone estado, decisiones, últimas entradas y compara el hash para
  producir `PASS`, `DRIFT_DETECTED` o `UNKNOWN` (`.claude/hooks/session-start-compact.sh:1-48`).
- `subagent-context.sh` selecciona packs por `agent_type`, concatena archivos y devuelve
  `additionalContext` (`.claude/hooks/subagent-context.sh:1-37`).
- `subagent-stop-logger.sh` registra agente/id/resumen, evita duplicar por `agent_id` y rota al
  superar 30 entradas (`.claude/hooks/subagent-stop-logger.sh:1-41`).
- `stop-logger.sh` no muta estado: si `stop_hook_active=true` retorna sin contexto; de lo contrario
  puede emitir un recordatorio si `PROJECT_STATE.md` no se tocó hoy
  (`.claude/hooks/stop-logger.sh:7-24`). El fix anti-loop está implementado en el checkout actual;
  el fallo histórico y su reproducer viven en la auditoría conductual (`docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md:50-105`).
- `config-change-logger.sh` solo agrega un evento al session log y es fail-open
  (`.claude/hooks/config-change-logger.sh:1-17`).

## 7. Installer y superficie instalada

`install.sh` pregunta nombre y stack, crea `.claude/{hooks,skills,agents,rules,context,backups}`,
`docs/00_SYSTEM` y `evals/incidents`, copia diez hooks y solo el fixture de incidentes
(`install.sh:20-39`). Copia 16 skills de proceso y todos los context skills
(`install.sh:41-54`), agents, rules y packs (`:56-64`), valida/reserializa settings con `jq`
(`:65-95`), copia los ocho templates raíz solo si no existen (`:97-104`) y crea el session log
(`:106-110`).

Hecho importante: el installer no copia el `evals/maintenance.sh`, los fixtures de hooks, los
resultados Tier 3, el benchmark ni el workflow CI completo; solo crea `evals/incidents` y copia su
fixture. Por tanto, el repositorio del control plane y una instalación destino no tienen la misma
superficie de verificación salvo que el usuario la distribuya por otra vía. Esto es un hecho del
installer actual, no una afirmación de que la instalación esté rota.

El installer tiene semántica idempotente para settings: compara JSON normalizado, preserva un settings
distinto no interactivo, pregunta en TTY y reemplaza solo con confirmación o `--force`
(`install.sh:74-95`). Esa conducta tiene fixture `evals/install/idempotency.sh:17-58` y EV-014
(`docs/00_SYSTEM/EVIDENCE_REGISTRY.md:243-258`).

## 8. Agents, packs, rules y skills

### 8.1 Agents

| Agent | Tools declaradas | Límite principal | Provenance |
|---|---|---|---|
| `researcher` | Read/Glob/Grep/WebSearch/WebFetch | Sin Write/Edit/Bash | `.claude/agents/researcher.md:1-35` |
| `architect` | Read/Glob/Grep/Write/Edit | Sin Bash/WebSearch; escribe docs/context | `.claude/agents/architect.md:1-39` |
| `implementer` | Read/Glob/Grep/Write/Edit/Bash | Sin WebSearch; implementación | `.claude/agents/implementer.md:1-40` |
| `security-auditor` | Read/Glob/Grep | Solo lectura; OWASP checklist | `.claude/agents/security-auditor.md:1-37` |
| `code-reviewer` | Read/Glob/Grep | Sin Write/Edit/Bash/WebSearch; contexto fresco | `.claude/agents/code-reviewer.md:1-35` |

`code-reviewer` exige reporte con archivo, línea, severidad y evidencia, y bloquea ante BLOCKER/HIGH
sin resolver (`.claude/agents/code-reviewer.md:24-35`). La existencia de este frontmatter no prueba
por sí sola que Claude Code aplique todos los límites; el `SubagentStart` hook sí inyecta packs por
rol mediante `additionalContext` (`.claude/hooks/subagent-context.sh:8-35`).

### 8.2 Context packs y rules

Los seis packs actuales son templates o mirrors: `CORE`, `CURRENT_STATE`, `DECISIONS`, `BUSINESS`,
`SECURITY_RULES`, `NO_GO`. `CORE`, `BUSINESS`, `SECURITY_RULES` y `NO_GO` contienen placeholders
porque este repositorio es fuente de instalación, no un proyecto de negocio configurado
(`.claude/context/CORE.md:1-62`, `BUSINESS.md:1-50`, `SECURITY_RULES.md:1-43`, `NO_GO.md:1-49`).
`CURRENT_STATE` y `DECISIONS` contienen material actual y se declaran mirrors
(`.claude/context/CURRENT_STATE.md:1-17`, `.claude/context/DECISIONS.md:1-16`).

Las cuatro rules (`compliance.md`, `git-policy.md`, `no-go.md`, `security.md`) son guidance. El
enforcement técnico está en settings y hooks, como reconoce `security.md:1-11`.

### 8.3 Skills

Las 22 skills se dividen en:

- Context: `context-core`, `context-current-state`, `context-decisions`, `context-business`,
  `context-security`, `context-no-go`.
- Operativas: `estado`, `gate`, `cerrar-fase`, `checkpoint`, `evidence`, `adr`, `no-go`.
- Diagnóstico/recuperación: `doctor`, `audit-config`, `audit-context`, `recovery`.
- Workflow/verificación: `test-driven-development`, `code-review-and-quality`,
  `doubt-driven-development`, `constraint-driven-development`, `incident`.

Las context skills solo instruyen leer el pack (`.claude/skills/context-core/SKILL.md:1-14`); no son
un segundo mecanismo de estado. `/gate` inspecciona manifest, decisiones y blockers
(`.claude/skills/gate/SKILL.md:7-33`); `/cerrar-fase` documenta commit y actualización de estado
(`.claude/skills/cerrar-fase/SKILL.md:7-39`); `/evidence` define el schema y la ruta canónica
(`.claude/skills/evidence/SKILL.md:7-56`); `/recovery` enumera nueve escenarios y protocolos manuales
(`.claude/skills/recovery/SKILL.md:18-88`).

Las cuatro SDLC skills con evals son solo las cuatro incluidas en `evals/skills/validate.sh`
(`validate.sh:7-21`). El resto tiene documentación, pero no existe una validación estructural
equivalente para cada skill. `validate.sh` comprueba markers y consume resultados Tier 3 persistidos
(`validate.sh:24-40`); no ejecuta una corrida nueva del agente en esta ruta.

## 9. Evals, CI y mecanismo de evidencia

### 9.1 Suite de mantenimiento

`evals/maintenance.sh`:

- exige `jq` y JSON válido de settings (`maintenance.sh:8-10`);
- valida sintaxis de installer, hooks y evals (`:12-15`);
- corre fixtures de Stop, rotación, skills, incidente, coupling, estado, freshness, firewall y
  secret guard (`:16-25`);
- compara conteos de entries, provenance y artifact hashes del evidence registry (`:27-31`);
- busca referencias obsoletas y ejecuta una instalación temporal/idempotency fixture (`:32-42`);
- imprime 12 resultados, incluyendo freshness y fixtures positivos (`:44-45`).

El CI solo ejecuta `bash evals/maintenance.sh` en Ubuntu con `jq` instalado
(`.github/workflows/control-plane.yml:1-21`). No hay una etapa que pruebe el dispatcher nativo de
Claude Code, ni autenticación Claude, ni una corrida SAGR.

### 9.2 Evals de skills y freshness

`fixtures.json` tiene por cada una de cuatro skills tres positivos, dos negativos, una colisión y
casos conductuales (`evals/skills/fixtures.json:1-58`). El Tier 3 se basa en dos JSON con sesiones
distintas y firmas normalizadas idénticas (`evals/skills/results/F3-tier3-run-1.json:1-14`,
`run-2.json:1-14`; `evals/skills/validate.sh:30-38`).

`evidence-freshness.sh` exige `session_id` único y timestamp/mtime dentro de 30 días, pero usa el
mtime si falta timestamp (`evals/skills/evidence-freshness.sh:18-49`; `evals/REGRESSION_BUDGET.json:1-12`).
La suite no convierte esto en una invalidación dependiente del código fuente, del prompt o del
artifact; la limitación está documentada en el handoff (`SESSION_HANDOFF_CURRENT.md:207-216`).

### 9.3 Incident learning

El incidente real registrado es INC-001: una completion podía aceptarse sin evidencia específica.
La causa se clasifica como `missing_test`, el control es CTRL-001 y la regresión REG-001
(`INCIDENT_REGISTRY.md:24-39`, `CONTROL_REGISTRY.md:19-29`, `REGRESSION_REGISTRY.md:18-27`).
El fixture demuestra el contraste baseline sin control versus gate activo
(`evals/incidents/INC-001-task-completed-evidence.sh:15-31`).

REG-002..REG-011 son preventivas y cubren firewall, secret guard, freshness, Stop, coupling,
rotación, installer, ausencia de contract hash y JSON malformed (`REGRESSION_REGISTRY.md:29-117`).
No hay una regresión SAGR: no existe fixture de loop semántico, policy-block, recuperación, coste de
recovery, side effects o segunda capa de retry.

### 9.4 Evidence registry

El registry canónico está en `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` (`:1-18`). Contiene EV-001..EV-016
más schema; EV-003/EV-004 quedaron BLOCKED por falta de autenticación inicial, EV-005 reemplazó ese
bloqueo histórico tras una corrida autenticada, y EV-009..EV-016 registran F7/F8
(`EVIDENCE_REGISTRY.md:20-292`).

Cada entrada tiene task id, source, provenance, confidence, status, artifact hash, contract hash,
checks, reviewer, exceptions y timestamp. El hook exige la forma de esos campos, pero no recomputa
artifact hash ni autentica la identidad del reviewer (`task-completed-evidence.sh:38-80`). Por ello
un hash con forma válida es integridad del registro, no prueba de que el archivo actual coincida.

## 10. Qué es y qué no es recuperación hoy

### 10.1 Primitivas existentes

1. **Recuperación de contexto:** PreCompact guarda snapshot/hash; SessionStart compact compara drift.
   Esto responde a continuidad de estado, no a recuperación semántica de una trayectoria
   (`pre-compact-snapshot.sh:5-29`, `session-start-compact.sh:15-47`).
2. **Rollback:** el Handbook documenta rollback por `git revert` por bundle y backups de state
   (`docs/CONTROL_PLANE_HANDBOOK.md:941-960`, `:1009-1011`). El smoke test end-to-end sigue
   diferido (`POST_F8_AUDIT_REPORT.md:112-120`).
3. **Recuperación manual:** `/recovery` enumera E-1..E-9 para state ausente/corrupto, falsos
   positivos, packs desincronizados, subagente sin contexto, log, settings, checkpoint, secret guard
   y compactación sin snapshot (`.claude/skills/recovery/SKILL.md:18-88`).
4. **Stop anti-loop:** el hook actual reconoce `stop_hook_active` y evita reemitir el recordatorio
   (`stop-logger.sh:8-10`). Es una protección de reentrada puntual, no un detector general de
   estancamiento.
5. **Budget de eval:** hay freshness y regression budget para evals, no presupuesto separado para
   intentos de recuperación durante ejecución (`REGRESSION_BUDGET.json:1-12`).

### 10.2 Capacidades SAGR no observadas en el runtime objetivo

| Capacidad SAGR | Estado en este repositorio | Evidencia |
|---|---|---|
| Fingerprint de trayectoria viva | No observado | No existe hook/skill/archivo en tree ni wiring en settings |
| Señal de progreso | No observado | No hay métrica de progreso en hooks/evals |
| Clasificador `HARD STOP`/`RECOVERABLE STOP` | No observado | No hay estado/clase/schema; recovery solo manual |
| Planner de alternativa que conserve policy | No observado | No hay componente de recovery planner |
| Branch exploration acotado | No observado | No hay orquestador ni budget de fan-out |
| Adjudicación de ramas | No observado | No hay score/comparador de trayectorias |
| Contexto mínimo de recuperación generado | No observado | Solo packs/estado/snapshot predefinidos |
| Recovery budget separado | No observado | Solo `REGRESSION_BUDGET` de evals |
| Decisión recovery versus restart | No observado | No hay métrica de coste en runtime/evals |
| Side-effect ledger fuera del contexto | No observado | Evidence registry guarda claims/hashes, no ledger de efectos externos |
| Stall audit trail | No observado | Session log registra actividad, no stalls clasificados |
| Governor de segunda orden | No observado | No existe contador/estado para loops de recovery |
| Provider-agnostic recovery envelope | No observado | ARCH-001 fija instalación project-local y Claude Code |

La ausencia se establece por inspección de árbol, settings, hooks, skills, evals y registries; no se
usa para declarar que ninguna herramienta externa lo tenga.

### 10.3 Relación con el dossier SAGR no versionado

El dossier `docs/research/CCP_SAGR_RESEARCH_DOSSIER.md` declara en sus líneas 6-11 baseline
`035a573`, propósito SAGR, F10 no abierto y limitación de single-context. Sus propias líneas 50-59
admiten que no hubo entrevistas ni reproducción live de mecanismos de recuperación; sus líneas
754-772 reiteran no runtime, no entrevistas y papers recientes no leídos en texto completo.

Por eso el dossier se clasifica como **hipótesis/documento de investigación no versionado**, no como
estado del sistema. La reconstrucción independiente sí confirma su parte negativa más básica: en el
runtime actual no hay una capa SAGR. No adopta como hechos sus cifras de incidentes, nombres de
productos, porcentajes de composición o conclusiones comerciales.

## 11. Investigación documental de `docs/research`

La solicitud no nombraba literalmente cuáles eran “los seis documentos” de research. Para evitar
selección arbitraria, se inspeccionaron los nueve Markdown versionados de `docs/research/`, además del
dossier SAGR no versionado. Las diferencias entre documento-protocolo, resultado reproducible y
claim externo se conservan.

### 11.1 Investigación histórica de arquitectura

`RESEARCH_CLAUDE.md` y `RESEARCH_CHATGPT.md` son investigaciones tempranas. Describen el sistema
con inventarios históricos de 9 hooks, 11 skills y 4 agents, no el inventario actual. Sirven para
explicar por qué se añadieron evals, evidence gate, incident loop y state integrity,
pero deben subordinarse al código y a los commits posteriores. `F9_RESEARCH.md` dice explícitamente
que esos dos documentos se usaron solo para contexto histórico y no sustituyen runtime, Git, auditoría
F8 ni registries (`docs/00_SYSTEM/F9_RESEARCH.md:109-139`).

### 11.2 Market validation report y audit

El report principal usa labels `PROJECT FACT`, `EXTERNAL FACT`, `INFERENCE` y `UNKNOWN`
(`CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md:14-25`). Su correction pass relabeló proyecciones,
fechas futuras, trazabilidad de incidentes y thresholds; el audit inicial concluyó `RESEARCH VALIDATED
WITH LIMITATIONS` y `IMPLEMENTATION AUTHORIZED: NO` (`CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md:575-630`).

Las adiciones posteriores estrechan, no fortalecen silenciosamente, la tesis:

- El cierre independiente identifica AIGIS y literatura académica como coincidencias conceptuales y
  estrecha la diferenciación evidence-gated (`CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md:1241-1265`).
- Identifica competidores adicionales y una superficie de riesgo GuardFall para el regex firewall
  (`:1267-1290`).
- El gate buyer/competitive mantiene buyer, WTP, pilot y PMF como `NOT ENOUGH EVIDENCE`
  (`:1375-1427`).
- La reconstrucción zero-based declara la tesis standalone `COMMERCIAL THESIS NOT SUPPORTED`, pero
  también deja estados alternativos sin escoger: reframing, OSS/standard, field validation e
  internal engineering value (`:1953-1964`).
- El propio report afirma que el siguiente paso legítimo está fuera del desk research: entrevista
  real, teardown reproducible o decisión documentada del owner (`:2005-2018`).

El audit aclara qué no prueba: no simula entrevistas, no prueba ausencia de competidores, no valida
la tesis estratégica y no evalúa productización (`CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md:644-650`).

### 11.3 Source appendix

`CLAUDE_CONTROL_PLANE_MARKET_SOURCES.md` es un apéndice de provenance, no una narrativa
(`CLAUDE_CONTROL_PLANE_MARKET_SOURCES.md:1-16`). Registra retrievals de 2026-09-20 con WebSearch/WebFetch,
fuentes primarias cuando existían y limitaciones de paywall/no retrieval; declara autoría
self-declared, no criptográficamente verificada (`:125-131`). No hay entrevistas en ese corpus.

### 11.4 Protocolos de campo

`CLAUDE_CONTROL_PLANE_CUSTOMER_DISCOVERY_PROTOCOL.md` es un instrumento, no un resultado. Prohíbe
personas sintéticas, outreach automatizado y claims de validación antes de entrevistas reales
(`:1-22`). Exige preguntas conductuales, notas fuera del repositorio y convergencia por rol
(`:90-169`, `:248-277`).

`CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md` confirma que Round 0 solo prepara el trabajo: no
hubo entrevistas, no hay WTP, no hay piloto ni buyer identificado (`:7-15`, `:155-188`).

`CLAUDE_CONTROL_PLANE_COMPETITIVE_TEARDOWN_PROTOCOL.md` define cómo probar versiones, planes,
entornos, escenarios y dos corridas; no contiene resultados (`:1-22`, `:60-80`, `:349-385`).

### 11.5 AIGIS: resultado reproducible, no protocolo

El teardown AIGIS sí registra una ejecución en `/tmp`, commit `e095eb6`, 234 tests colectados, 223
passed, 10 failed y 1 skipped; el benchmark live y S01-S05 no se ejecutaron
(`CLAUDE_CONTROL_PLANE_AIGIS_TEARDOWN.md:18-49`).

La comparación observada señala que AIGIS tiene modelos tipados, Decision Engine estructurado,
ToolRequest, sandbox, circuit breakers y mayor cobertura; CCP conserva identidad de reviewer, loop
INC→CTRL→REG, phase discipline e historial append-only (`:51-85`). Esto es evidencia del competidor
específico, no prueba de todo el mercado.

El teardown también documenta una observación operativa: la limpieza legítima `rm -rf /tmp/...` fue
bloqueada por la regex de `bash-firewall.sh`, y se usó una vía alternativa; el texto lo registra
como evidencia, no como autorización de fix (`:121-135`). Esta nota conserva la observación y no la
convierte en cambio de runtime.

## 12. Hechos, observaciones y desconocidos relevantes para SAGR

### 12.1 Hechos establecidos

1. El runtime tiene snapshot/hash de estado y detección de drift; no tiene recuperación semántica
   automática (`pre-compact-snapshot.sh:9-29`, `session-start-compact.sh:15-47`).
2. Existe una skill `/recovery` manual con nueve escenarios; no existe un manager de recovery
   (`.claude/skills/recovery/SKILL.md:18-88`).
3. No hay hook `PostToolUseFailure` cableado ni registro automático de fallos de herramienta
   (`.claude/settings.json:21-141`; `docs/00_SYSTEM/F9_RESEARCH.md:269-284`).
4. No hay schema de stall, recovery budget o side-effect ledger en los registries actuales
   (`EVIDENCE_REGISTRY.md:5-18`, registries de incidente/control/regresión y árbol actual).
5. El control plane tiene una sola regresión orgánica INC-001 y diez regresiones preventivas activas
   posteriores; no hay dataset de fallos de recuperación (`REGRESSION_REGISTRY.md:20-117`).
6. No hay evidencia de usuarios u operadores de SAGR en los documentos versionados. El packet de
   campo prohíbe tratarlo como evidencia (`CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md:7-15`).
7. El dossier SAGR es untracked y su baseline no coincide con HEAD actual; no es un artefacto
   canónico.

### 12.2 Observaciones registradas, no reejecutadas aquí

1. `maintenance 12/12`, fixtures F7/F8, hashes EV-015/EV-016 y AIGIS 223/234 son resultados
   registrados por commits/documentos, no reejecuciones de esta inspección. La validación no mutante
   aquí solo comprobó JSON y sintaxis.
2. El falso positivo `rm -rf` es una observación de teardown registrada en un archivo versionado;
   no se volvió a disparar el hook para evitar crear efectos fuera del directorio de salida.
3. Los claims externos del market report se aceptan como claims con provenance del appendix, no como
   hechos que esta reconstrucción haya verificado en la web.

### 12.3 Desconocidos que SAGR necesitaría resolver

| Desconocido | Por qué importa | Evidencia actual |
|---|---|---|
| Frecuencia real de loops/stalls en operadores | Sin tasa base no hay beneficio medible | Ninguna entrevista ni telemetría del repositorio |
| Frecuencia específica de policy-induced stalls | Distingue hard stop correcto de recuperación útil | Solo documentos/protocolos; no runtime SAGR |
| Si una alternativa policy-compliant puede evitar bypass | Es frontera de seguridad, no solo UX | No existe planner ni prueba adversarial |
| Coste recovery versus restart | Puede hacer que recovery empeore el problema | No hay métrica ni budget de recovery |
| Continuidad de side effects a través de compactación | Riesgo de duplicación externa | No hay side-effect ledger |
| Semántica nativa de hooks | SAGR dependería de eventos reales y payloads | `NOT VERIFIED` bajo OpenCode |
| Calidad de papers/productos SAGR citados | El dossier admite búsqueda/lectura parcial | No se reprodujeron mecanismos externos |
| Buyer, WTP, pilot | Sin esto no hay tesis comercial | `NOT ENOUGH EVIDENCE` en protocolos/report |

## 13. Contradicciones y límites que no deben borrarse

1. **Documentación histórica versus estado actual.** Master Plan, roadmap y auditorías congeladas
   describen el punto de emisión; `PROJECT_STATE` y Git describen el snapshot actual. No se deben
   “actualizar” auditorías históricas para eliminar la diferencia.
2. **`LAST_GIT_CHECKPOINT` stale.** Es un drift operativo visible, pero no prueba runtime roto.
3. **F8 verified versus native unknown.** Ambas afirmaciones son compatibles: scripts/fixtures pasan;
   Claude Code nativo no fue probado.
4. **Evidence hash versus artifact integrity.** La forma `sha256:` y el registro VERIFIED no
   garantizan que el artifact actual sea el que se hasheó.
5. **Market category versus CCP buyer.** Hay productos y gasto en gobernanza de agentes, pero eso no
   prueba buyer/WTP para este repositorio. El report separa esas categorías en su cierre
   (`CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md:508-517`, `:1387-1427`).
6. **Dossier SAGR versus autoridad.** Su propia limitación de single context/no runtime/no interviews
   impide elevar sus síntesis a hechos (`CCP_SAGR_RESEARCH_DOSSIER.md:50-59`, `:754-772`).
7. **`git diff --check`.** Las líneas con whitespace pertenecen al cambio preexistente del session
   log. Corregirlas habría alterado trabajo ajeno y violado el alcance.

## 14. Conclusión de reconstrucción

El repositorio objetivo es un control plane project-local, documentalmente rico y con enforcement
real en tres hooks P0, una suite determinista de mantenimiento y un learning loop de incidentes
demostrado una vez. F7/F8 son cambios de runtime históricos cerrados; F9 y la investigación de
mercado son documentación; el estado actual no autoriza implementación automática.

Para SAGR, el hecho técnicamente defendible es estrecho:

> El repositorio dispone de recuperación de estado y recovery manual, pero no contiene una capa
> implementada de detección de estancamiento y recuperación gobernada por estado, política, coste,
> side effects o ramas alternativas.

No es defendible, desde este checkout, afirmar que SAGR ya existe, que sus primitivas están probadas
en producción, que la composición es única en el mercado, que hay buyer o que un nuevo runtime está
justificado. El dossier SAGR puede orientar preguntas posteriores, pero no cambia `PROJECT_STATE`, no
abre F10 y no autoriza hooks, skills, registries, evals ni arquitectura.

## 15. Lista de archivos inspeccionados

### Obligatorios y estado/arquitectura

`CLAUDE.md`; `PROJECT_STATE.md`; `ARTIFACT_MANIFEST.md`; `DECISION_REGISTRY.md`; `INCIDENT_REGISTRY.md`;
`CONTROL_REGISTRY.md`; `REGRESSION_REGISTRY.md`; `README.md`; `install.sh`; `docs/MASTER_IMPLEMENTATION_PLAN.md`;
`docs/CONTROL_PLANE_HANDBOOK.md`; `docs/DESIGN.md`; `docs/MASTER_EVOLUTION_ROADMAP.md`;
`docs/00_SYSTEM/EVIDENCE_REGISTRY.md`; `docs/00_SYSTEM/F7_F8_F9_TECHNICAL_HISTORY.md`;
`docs/00_SYSTEM/F9_RESEARCH.md`; `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`;
`docs/00_SYSTEM/SESSION_HANDOFF_CURRENT.md`; `docs/00_SYSTEM/POST_F8_AUDIT_REPORT.md`;
`docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md`; `docs/00_SYSTEM/F7_F12_RESEARCH_HANDOFF.md`;
`.gitignore`; `.github/workflows/control-plane.yml`.

### Runtime, wiring y hooks

`.claude/settings.json`; `.claude/hooks/bash-firewall.sh`; `.claude/hooks/secret-guard.sh`;
`.claude/hooks/task-completed-evidence.sh`; `.claude/hooks/session-start-startup.sh`;
`.claude/hooks/session-start-compact.sh`; `.claude/hooks/subagent-context.sh`;
`.claude/hooks/subagent-stop-logger.sh`; `.claude/hooks/stop-logger.sh`;
`.claude/hooks/pre-compact-snapshot.sh`; `.claude/hooks/config-change-logger.sh`.

### Agents, context y rules

`.claude/agents/researcher.md`; `.claude/agents/architect.md`; `.claude/agents/implementer.md`;
`.claude/agents/security-auditor.md`; `.claude/agents/code-reviewer.md`;
`.claude/context/CORE.md`; `.claude/context/CURRENT_STATE.md`; `.claude/context/DECISIONS.md`;
`.claude/context/BUSINESS.md`; `.claude/context/SECURITY_RULES.md`; `.claude/context/NO_GO.md`;
`.claude/rules/compliance.md`; `.claude/rules/git-policy.md`; `.claude/rules/no-go.md`;
`.claude/rules/security.md`.

### Skills

`.claude/skills/context-core/SKILL.md`; `.claude/skills/context-current-state/SKILL.md`;
`.claude/skills/context-decisions/SKILL.md`; `.claude/skills/context-business/SKILL.md`;
`.claude/skills/context-security/SKILL.md`; `.claude/skills/context-no-go/SKILL.md`;
`.claude/skills/estado/SKILL.md`; `.claude/skills/gate/SKILL.md`;
`.claude/skills/cerrar-fase/SKILL.md`; `.claude/skills/checkpoint/SKILL.md`;
`.claude/skills/evidence/SKILL.md`; `.claude/skills/adr/SKILL.md`;
`.claude/skills/no-go/SKILL.md`; `.claude/skills/doctor/SKILL.md`;
`.claude/skills/audit-config/SKILL.md`; `.claude/skills/audit-context/SKILL.md`;
`.claude/skills/recovery/SKILL.md`; `.claude/skills/incident/SKILL.md`;
`.claude/skills/test-driven-development/SKILL.md`; `.claude/skills/code-review-and-quality/SKILL.md`;
`.claude/skills/doubt-driven-development/SKILL.md`; `.claude/skills/constraint-driven-development/SKILL.md`.

### Evals y resultados

`evals/maintenance.sh`; `evals/REGRESSION_BUDGET.json`; `evals/skills/fixtures.json`;
`evals/skills/validate.sh`; `evals/skills/evidence-freshness.sh`;
`evals/skills/results/F3-tier3-run-1.json`; `evals/skills/results/F3-tier3-run-2.json`;
`evals/benchmarks/F3-tier3-baseline.json`; `evals/incidents/INC-001-task-completed-evidence.sh`;
`evals/hooks/task-completed-coupling.sh`; `evals/hooks/firewall-positive.sh`;
`evals/hooks/secret-guard-positive.sh`; `evals/hooks/stop-hook-idempotency.sh`;
`evals/hooks/session-log-rotation.sh`; `evals/install/idempotency.sh`; `evals/state/state-integrity.sh`.

### Templates

`templates/CLAUDE.md`; `templates/PROJECT_STATE.md`; `templates/ARTIFACT_MANIFEST.md`;
`templates/DECISION_REGISTRY.md`; `templates/EVIDENCE_REGISTRY.md`; `templates/INCIDENT_REGISTRY.md`;
`templates/CONTROL_REGISTRY.md`; `templates/REGRESSION_REGISTRY.md`.

### Research versionado

`docs/research/RESEARCH_CLAUDE.md`; `docs/research/RESEARCH_CHATGPT.md`;
`docs/research/CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md`;
`docs/research/CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md`;
`docs/research/CLAUDE_CONTROL_PLANE_MARKET_SOURCES.md`;
`docs/research/CLAUDE_CONTROL_PLANE_CUSTOMER_DISCOVERY_PROTOCOL.md`;
`docs/research/CLAUDE_CONTROL_PLANE_COMPETITIVE_TEARDOWN_PROTOCOL.md`;
`docs/research/CLAUDE_CONTROL_PLANE_AIGIS_TEARDOWN.md`;
`docs/research/CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md`.

### Artefacto no versionado inspeccionado, no usado como autoridad

`docs/research/CCP_SAGR_RESEARCH_DOSSIER.md`.

### Estado preexistente inspeccionado

`docs/00_SYSTEM/CLAUDE_SESSION_LOG.md` y los directorios `.git/`, `.claude/`, `.github/`, `docs/`,
`evals/`, `templates/` mediante inventario de árbol y `git ls-files`.

## 16. Cierre de alcance

No se ejecutaron comandos que escribieran runtime, hooks, skills, evals, registries, `/tmp` del
proyecto o archivos de control. La validación local fue lectura, `jq` y `bash -n`. No se hizo commit,
push, stash ni limpieza del worktree. El único archivo producido **por esta investigación** es esta
nota dentro de la ruta solicitada.
