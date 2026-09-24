# MASTER HANDOFF — Claude Control Plane

> Compresión estructural de alta fidelidad del CCP + motor de proyección de decisiones +
> auditoría adversarial final. Este archivo no reemplaza el corpus K3, la Root Analysis,
> los registries ni las decisiones históricas — los **referencia** y los **conecta**.
>
> Fecha de construcción: 2026-09-24.
> Ejecutor: Claude Opus 4.7 (`claude-opus-4-7`).
> Baseline HEAD: `1a6232d` (Root Analysis complete) + working tree con K3/ y este handoff.
> Alcance: cero cambios de runtime, hooks, policies, registries o decisiones del Owner.
> Este documento **razona sobre el CCP**; no lo modifica.
>
> **Instrucción de lectura**: para reconstruir la trazabilidad completa de una afirmación,
> los identificadores `[K3 §NN.M]`, `[RA §NN.M]`, `[EV-NNN]`, `[ARCH-NNN]`, `[F9-DNN]`
> apuntan al artefacto canónico. No sustituyas este handoff por el corpus; úsalo como
> índice ejecutivo + motor de proyección.

---

## Índice ejecutivo

- **Parte I — Handoff** (§1–§11): qué es CCP, historia, arquitectura, descubrimientos,
  UNKNOWNs, decisiones, dependencias, DEC-04 en profundidad.
- **Parte II — Decision Projection Engine** (§12–§27): opciones × consecuencias,
  proyecciones, regresiones, trayectorias, orden decisional, tabla owner-facing.
- **Parte III — Puzzle Assembly Engine** (§28–§56): CCP como rompecabezas parcialmente
  ensamblado; cada decisión como movimiento de pieza; encaje local/global; delta;
  reensamblaje.
- **Parte IV — Execution Candidate Synthesis** (§57–§75): por cada decisión, 2–4 formas
  compactas de materializarla; simulación, fit, feasibility, mejor primer movimiento.
- **Parte V — Final Adversarial Audit** (§76–§87): ataque al propio MASTER; corrección;
  veredictos por sección; preparación de ejecución.
- **Anexo A — Jerarquía de verdad y provenance**.
- **Anexo B — Piece catalog completo**.
- **Anexo C — Terminal condition checklist**.

---

## 0. Jerarquía de verdad y sistema de etiquetado

Cuando dos fuentes se contradicen, se aplica:

```text
REPOSITORY STATE (git+working tree)
    > PRIMARY EVIDENCE (EV-* + STALL_POLICY_LOG + stall-record.sh source)
    > REGISTRIES / RECORDED STATE (PROJECT_STATE + DECISION_REGISTRY + F9_OWNER_DECISIONS)
    > DOCUMENTATION (docs/ + K3 corpus + Root Analysis)
    > INTERPRETATION (audit, síntesis)
    > HYPOTHESIS (K3-D-EXOGENOUS, etc.)
```

Cada afirmación material lleva una etiqueta:

- `VERIFIED` — reproducible con comando/inspección directa.
- `SUPPORTED` — evidencia cruzada fuerte sin ejecución directa.
- `INFERRED` — deducción razonable, sin observación directa.
- `HYPOTHESIS` — explicación posible sin soporte suficiente.
- `UNKNOWN` — la evidencia no permite decidir.
- `REFUTED` — evidencia activa en contra.

Cuando aparece un porcentaje (p.ej. `context fit 60%`) **es evaluación argumentada, no
probabilidad estadística**. Cada uno responde: por qué ese valor, qué lo sube/baja,
qué incertidumbre.

---

# PARTE I — MASTER HANDOFF

## 1. CCP en una sola explicación

**CCP (Claude Control Plane) es una infraestructura de gobernanza local para trabajo de
agente/IA sobre este repositorio**. Su forma reproducible, cuando se silencian nombres
y narrativa, es exactamente esto [K3 §02.13]:

```text
CCP  =  ( 3 INTERFACES técnicas )     — tool-invocation, task-close, session-start
     +  ( 2 hard technical gates )    — BLOCKER-*, GATE-BEFORE-TASK-CLOSURE
     +  ( 1 event stream, write-only ) — EVENT-STREAM (STALL_POLICY_LOG.jsonl)
     +  ( N artefactos gobernados por convención humana ) — registries + policy texts
     +  ( 1 verificador ex-post )     — evals/maintenance.sh
     +  ( 1 árbitro final )           — reviewer humano en el commit
```

### 1.1 Cinco perspectivas

- **Arquitectónica**: 10 hooks + 1 lib (509 líneas) forman una **topología en estrella**
  donde toda garantía técnica pasa por 3 interfaces (tool call, task close, session
  start). El resto —registries, policy texts, session logs, PAC prototype, meta-doc—
  son observadores, contexto o convención. `SUPPORTED` [K3 §02].
- **Operacional**: el ciclo real es `intento de herramienta → hook decide → tool ejecuta
  → subagente cierra tarea → gate exige contract_hash + artifact_hash → humano commitea`.
  Todo lo demás es infraestructura auxiliar para mantener el ciclo trazable a través de
  sesiones fragmentadas. `SUPPORTED` [K3 §12.7.4 countermodel Cm].
- **Control**: 3 decisiones son mecánicas (`bash allow?`, `secret allow?`, `close task?`);
  4 decisiones son humanas sin gate técnico (`accept evidence?`, `authorize phase?`,
  `is policy valid?`, `is X material?`). `VERIFIED` por enumeración [K3 §02.11].
- **Epistemológica**: el humano hace **autorización, no verificación** — la mayor parte
  de la carga humana no es reducible a hooks o LLMs porque es juicio de autoridad
  (WOW-2, K3-D-AUTHZ-VS-VERIF). `SUPPORTED` [K3 §12.6, §05.4.7].
- **Gobernanza**: la autoridad efectiva vive en `git + reviewer humano`. Todo lo demás
  (append-only, integridad de estado, freeze de fases, human trust boundary) es
  **policy enforced by convention**, no invariante técnico. `SUPPORTED` [K3 audit §19].

### 1.2 Componentes ejecutables observables

| PIECE-ID                   | Archivo real                                        | Función efectiva       | Autoridad |
|----------------------------|-----------------------------------------------------|-------------------------|-----------|
| `BLOCKER-BEFORE-BASH`      | `.claude/hooks/bash-firewall.sh`                    | denies/allows bash cmd  | mecánica  |
| `BLOCKER-SECRET`           | `.claude/hooks/secret-guard.sh`                     | denies secret access    | mecánica  |
| `GATE-BEFORE-TASK-CLOSURE` | `.claude/hooks/task-completed-evidence.sh`          | gates SubagentStop      | mecánica  |
| `LOG-COMPACT-BEFORE`       | `.claude/hooks/pre-compact-snapshot.sh`             | snapshot pre-compact    | observ.   |
| `LOG-CONFIG-CHANGE`        | `.claude/hooks/config-change-logger.sh`             | log de cambios config   | observ.   |
| `LOG-STOP`                 | `.claude/hooks/stop-logger.sh`                      | idempotencia Stop       | observ.   |
| `LOG-SUBAGENT-STOP`        | `.claude/hooks/subagent-stop-logger.sh`             | log + rotación diaria   | observ.   |
| `CONTEXT-SESSION-START-A`  | `.claude/hooks/session-start-compact.sh`            | inyecta contexto compact| observ.   |
| `CONTEXT-SESSION-START-B`  | `.claude/hooks/session-start-startup.sh`            | drift detect            | observ.   |
| `CONTEXT-SUBAGENT`         | `.claude/hooks/subagent-context.sh`                 | pack por rol            | observ.   |
| `LIB-EVENT-EMISSION`       | `.claude/hooks/lib/stall-record.sh`                 | emite JSON al stream    | interno   |

Total: **10 scripts + 1 lib = 509 líneas** (`wc -l`). `VERIFIED`.

### 1.3 Artefactos gobernados

| STORE-ID           | Ruta                                                  | Contrato de escritura                          |
|--------------------|-------------------------------------------------------|------------------------------------------------|
| `STATE-MASTER`     | `PROJECT_STATE.md`                                    | convención humana + drift detection SessionStart|
| `DECISIONS-MASTER` | `DECISION_REGISTRY.md`                                | convención humana                              |
| `EVIDENCE-MASTER`  | `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`                 | convención humana (append-only por policy)     |
| `EVENT-STREAM`     | `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`               | append-only por hooks; **18 líneas al cierre K3** |
| `SESSION-STREAM`   | `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`                | rotación diaria por hook                       |
| `RUNBOOK-SUITE`    | `evals/maintenance.sh` + subchecks                    | verificación ex-post                           |
| `CONTEXT-PACK`     | `.claude/context/*.md`                                | leído por CONTEXT-SUBAGENT                     |
| `POLICY-TEXTS`     | `.claude/rules/*.md` (4 archivos; 1/4 con placeholders)| convención humana; no derivación mecánica      |
| `POLICY-PROTO`     | `docs/research/pac/ccp_policies.yaml` + `compile_policies.sh` | prototipo, no runtime                  |
| `INDEX-PLAN`       | `docs/MASTER_IMPLEMENTATION_PLAN.md`                  | contrato de fases                              |
| `INDEX-MANIFEST`   | `ARTIFACT_MANIFEST.md`                                | checklist de entregables                       |

### 1.4 Actores, humanos, agentes, autoridad

- **Owner** (humano). Único árbitro de decisiones no delegadas mecánicamente.
- **Reviewer humano en commit**. Única verificación semántica activa.
- **Agente principal** (Claude Opus/Sonnet). Produce artefactos; sujeto a los 3 gates.
- **Subagentes** (`architect`, `implementer`, `code-reviewer`, `researcher`,
  `security-auditor`, `Plan`, `Explore`, `general-purpose`, `claude`, `claude-code-guide`,
  `statusline-setup`). Modifican archivos siempre pasando por los mismos hooks.
- **Hooks**. Autoridad mecánica delimitada (3 decisiones); todo lo demás es logging.

### 1.5 Estado, contexto, verificación, recuperación

- **Estado**: fuente única `PROJECT_STATE.md`; espejos en `.claude/context/CURRENT_STATE.md`
  y `docs/00_SYSTEM/SESSION_HANDOFF_CURRENT.md`. Drift se **detecta** (hash mismatch),
  no se **impide**. Fase actual: **F8 COMPLETE**; F9 research completa + owner gate
  cerrado (F9-D01=A..F9-D05=A); F10–F12 UNKNOWN.
- **Contexto**: inyectado en cada SessionStart y SubagentStart. Sin memoria persistente
  runtime; el meta-doc + registries son la compensación (K3-D-EXOGENOUS `HYPOTHESIS`).
- **Verificación**: `evals/maintenance.sh` corre 12 checks deterministas; CI en push.
  Última corrida: 12/12 PASS al cierre F8. `VERIFIED en fracción muestreada por audit`.
- **Recuperación**: reversibilidad = git; no hay rollback runtime específico. La única
  "recuperación técnica" es `git checkout HEAD .claude/` para restaurar config.
- **Trazabilidad**: EV-001..EV-016 con `contract_hash`, `artifact_hash`, `reviewer`,
  `exceptions`, `timestamp`, `provenance`. **F8-A hace `contract_hash` fail-closed**
  desde 2026-09-19. Provenance canónica en `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`.
- **Evolución**: F1→F8 fue pipeline lineal; F9→M001..M008 fue DAG paralelo de
  investigación. `K3-D-PHASE-CHANGE PARTIAL` [K3 §05.6.4].

---

## 2. Historia estructural (sólo lo que cambió el modelo de CCP)

```text
ORIGEN
  ├─ Master Plan escrito.  Contrato F1..F12; regla AUDIT→IMPLEMENT→TEST→VERIFY→EVIDENCE→GATE.

F1 [PASS]  Fundación instalable + registries + subagent context sin depender de `skills:`.
           ARCH-001/002/003 nacen aquí. EV-001. Hooks base + install.sh.
F2 [PASS]  Evidence Contract + TaskCompleted valida el contrato. EV-002.
F3 [PASS]  SDLC lanes; Tier 3 authenticated. EV-003→EV-004→EV-005. INV: independencia
           de verificador reaparece.
F4 [PASS]  Incident learning INC-001 → CTRL → REG → EV. EV-006. POL-LATENT-5 nace y
           corre una sola vez.
F5 [PASS]  State integrity + provenance. Drift detection en SessionStart. EV-007.
F6 [PASS]  Maintenance suite 12/12 + CI. Regression budget. EV-008.
F7 [PASS]  Evidence Integrity + Behavioral Reliability. ARCH-004 nace (task_id +
           contract_hash). EV-009..EV-014. REG-002..REG-009.

Behavioral Audit (2026-09-18)
  ├─ 11 bugs descubiertos. F7 amplió scope para cerrarlos.

F8 [PASS]  Cierra gaps diferidos de F7. F8-A: `contract_hash` fail-closed. F8-B:
           malformed firewall payloads fail-closed. ARCH-004 amended. EV-015, EV-016.
           REG-010, REG-011. Convergencia operativa.

F9 [RESEARCH COMPLETE / IMPLEMENTATION NOT AUTHORIZED]
  ├─ F9_RESEARCH.md concluye "F9 NOT JUSTIFIED".
  ├─ Owner gate (2026-09-20): F9-D01=A (no implementación), F9-D02=B (defer native),
  │  F9-D03=B (defer documentary candidates), F9-D04=B (external trigger for integrity),
  │  F9-D05=A (F10-F12 UNKNOWN).
  └─ Baseline HEAD 05c78ac.  ⚑ BREAKPOINT OPERATIVO.

M001..M007 (2026-09-22 → 09-23)  Investigación de frontera post-F9.
  ├─ M001 exploration engine; M002-M004 policy corpus + bypasses; M005 movement history;
  │  M006 pre-authorization adversarial gate; M007 breakout (PAC prototype + HRQS +
  │  query-log.sh).
  └─ 60+ documentos generados en docs/research/.

M008 (2026-09-23)  HRQS + PAC corpus complete + CCP Handoff.
  └─ NOW-EXECUTABLE agotado.  ⚑ CONFIRMACIÓN DE BREAKPOINT.

Root Analysis (Kimi K2.7, commit 1a6232d, 2026-09-24)
  ├─ 10 documentos: system model T8, 18→5 decision collapse, missing piece = motor de
  │  derivación de política, root principle, breakpoint, negative space, invariants,
  │  owner decision surface.
  └─ Punto de partida para K3.

Audit del Root Analysis (Claude Opus 4.7, 2026-09-24 12:18)
  ├─ Verdict: CONDITIONAL PASS.
  ├─ Refuta "3 eventos" (real: 16 al momento del audit; 18 al cierre K3).
  ├─ Reformula R1..R5 como decisiones DERIVADAS de capacidades.
  ├─ Reformula Missing Piece = CAPABILITY (enforceable policy derivation), no PAC.
  └─ Reformula Root Principle = SYSTEM PRINCIPLE, no ROOT PRINCIPLE.

K3 (Claude Code, 2026-09-24 PM) — 13 documentos + LEDGER
  ├─ Reconstrucción independiente desde fuentes primarias (silenciando nomenclatura).
  ├─ 24 K3-D discoveries + 7 WOW findings.
  ├─ 5 arquitecturas + 6 combinaciones.
  ├─ 10 ejes en el espacio arquitectónico; 7 puntos viables sólo en E1×E2.
  ├─ 11 UNKNOWNs; 12 hipótesis en formato falsificable.
  ├─ Basis mínima: 8 elementos asimétricos + 10 operaciones conceptuales.
  ├─ Decision space real: 13 decisiones abiertas (no 4).
  └─ Master Owner Decision System (`13`) delimitando, sin decidir.

MASTER HANDOFF (2026-09-24, este documento)
  ├─ Compresión estructural + motor de proyección + puzzle engine + execution synthesis.
  └─ Adversarial audit + corrección.  ⚑ SIGUIENTE ESLABÓN: OWNER.
```

**Acontecimientos que cambiaron el modelo del CCP** (no meros checkpoints):

1. **F2 introdujo evidence gate** — antes, "task done" era una afirmación; después, un
   contrato.
2. **F4 introdujo INC/CTRL/REG cycle** — probó que learning-loop puede cerrarse, pero
   sólo lo hizo una vez.
3. **F8-A hizo `contract_hash` fail-closed** — cerró la única brecha del gate. Cambió
   ARCH-004.
4. **F9-D01=A congeló el runtime** — convirtió al Owner en gate obligatorio para todo
   cambio; hizo aparecer K3-D-F9D01-BOTTLENECK y K3-D-EPIST-COST.
5. **M007 produjo PAC prototype** — demostró que YAML→regex es viable en principio;
   descubrió PAC-EF-02 (FP class por nombre de política en literal).
6. **Root Analysis + audit** — mostró que el paquete READY-01/02/03/04 es incompleto
   como base decisional. K3 lo confirmó al enumerar 13 decisiones abiertas.

---

## 3. Baseline al cierre K3 (hechos verificables)

```text
STALL_POLICY_LOG.jsonl        18 líneas (0 clasificadas; 14/18 = 82% harness noise)
Hooks                          10 scripts + 1 lib = 509 líneas
PAC corpus                     24 IDs en ccp_policies.yaml (23 policies + 1 normalization)
docs/ total                    121 archivos Markdown
docs/00_SYSTEM/                44 archivos
docs/research/                 75+ archivos
EVIDENCE_REGISTRY.md           16 EV reales + 1 template
DECISION_REGISTRY.md           ARCH-001..004 activas
F9_OWNER_DECISIONS.md          F9-D01..D05 cerrados (2026-09-20)
Rules                          4 archivos; 1/4 (no-go.md) con {{placeholders}}
Agents                         11 en .claude/agents/ + tipos runtime (fork, general-purpose, etc.)
maintenance.sh                 12/12 PASS al cierre F8 (SCRIPT VERIFIED)
Native Claude Code runtime     NOT VERIFIED (F9-D02=B; deferido)
LAST_GIT_CHECKPOINT            f6a874f (MOVEMENT 008)
```

`had_alternative` en `stall-record.sh:46` está **hard-coded a `null`** — schema-dead field.
`session_id` se pasa como `""` por todos los callers y se convierte a `null`. `VERIFIED`.

---

## 4. Mapa de arquitectura

### 4.1 Arquitectura real actual (lo que existe físicamente)

Ver §1.2, §1.3. Topología estrella: 3 interfaces técnicas, humano-sink, event stream
write-only, sin FSM implementada, sin controlador que consume el stream.

### 4.2 Arquitectura conceptual (modelo emergente K3)

```text
BASIS ASIMÉTRICA (8 elementos)
  · CAP-2s   syntactic verification         (capacidad activa; hooks)
  · CAP-2m   semantic verification          (capacidad activa; humano)
  · CAP-3    provenance                     (capacidad activa; git+registries; brechas)
  · CAP-AUTHZ authorization                 (capacidad activa; humano)
  · GAP-1    canonical policy               (carencia; representaciones parciales)
  · POL-LATENT-5 learning loop              (política latente; ran 1× en INC-001)
  · PROP-4   reversibility                  (propiedad del substrate git)
  · COMP-CTX SessionStart+meta-doc          (compensación del substrate)

OPERACIONES CONCEPTUALES (10)
  BLOCK · ALLOW · EMIT · GATE · WRITE · READ · VERIFY · REVIEW · AUTHORIZE · DERIVE
  → sólo DERIVE está ausente en runtime (K3-D-DERIVE-ONLY).

TOPOLOGÍA
  Star con humano-sink; K3-D-STAR; K3-D-OWNER-DEFAULT ("todo lo no delegado va al humano").

MODELO DUAL COEXISTENTE
  · K3 arquitecturacentrista (capacidades)
  · Cm procesocentrista      (ciclo intent→tool→evidence→commit)
  Ninguno absorbe al otro (K3-D-DUAL-MODEL).
```

### 4.3 Arquitecturas alternativas (5 futuros identificados)

Extraídas de `[K3 §09]`. Cada una **satisface** las constraints observables
(project-scoped, provider-independent, git substrate, humano presente).

- **A — "Statu Quo Formalizado"**. Mantiene topología, formaliza autoridades implícitas
  (catálogo, front-matter, cadencia). Bajo cambio, coherente con F9-D01=A. Rompe en
  S2/S3/S5. `LOCK-IN bajo`.
- **B — "Canonical Source + Motor Unidireccional"** (PAC-family). Variantes: B.1 YAML,
  B.2 tests, B.3 Markdown-with-schema. Elimina GAP-1; introduce motor como nuevo TCB.
  `LOCK-IN medio (formato canónica)`.
- **C — "Single Source + Tests como Contrato"**. C.1 elimina rules-md; C.2 elimina
  regex explícito y llama tests desde hooks. Radical simplification; pierde ergonomía
  humana. `LOCK-IN bajo`.
- **D — "Peer Verification + Segundo LLM"**. `code-reviewer` adversarial obligatorio
  en subagentStop; opcional tercer LLM. Rompe topología estrella parcialmente;
  introduce provider dependence. `LOCK-IN alto sobre provider`.
- **E — "Layered Trust with Formal Delegation Contract"**. `DELEGATION_REGISTRY.md` con
  schema (`action_type, delegated_to, fallback, activated_by, revocable`). Ortogonal a
  las demás; K3-D-DELEG-ORTOGONAL. `LOCK-IN bajo`.

**Combinaciones viables**: A+E, B+E, C+E, D+E, A+B+E, cualquiera + shadow runtime.

Matriz arquitectura × escenarios [K3 §09.8]:

```text
                 A statu quo  B canonical+motor  C single-src  D peer-LLM  E delegation
S1 stable        OK           OK                 OK            EXPENSIVE   OK
S2 10x agents    BREAK        WEAKEN             WEAKEN        OK          IMPROVES
S3 multi-project BREAK        BREAK              BREAK         OK          IMPROVES
S4 provider swap OK           OK                 OK            BREAK       OK
S5 audit externo BREAK        IMPROVES           WEAKEN        WEAKEN      IMPROVES
S6 substrate up  OK           OK                 OK            OK          OK
```

**Ninguna arquitectura domina en todos los escenarios**. E es transversal (mejora
todas). A es óptimo sólo en S1. B es óptimo en S5. D es sensible a S4.

### 4.4 Elementos que todavía NO son arquitectura

Distinción explícita para no confundir estado con propuesta:

- **Hipótesis**: K3-D-EXOGENOUS, K3-D-SUBSTRATE-FRACTION, K3-D-PHASE-CHANGE (partial).
- **Propuestas**: PAC en producción, DELEGATION_REGISTRY, CHANGE_TYPES_CATALOG, shadow
  runtime, LLM adversarial verifier.
- **Capacidades deseadas**: DERIVE en runtime, semantic verification mecanizada,
  lifecycle formal de research artifacts.
- **Decisiones abiertas**: DEC-01..DEC-13 (Bloque F externo).
- **Mecanismos experimentales**: PAC compiler prototype (docs/research/pac/), HRQS
  checklist (documento, no ejecutable).

---

## 5. Descubrimientos K3 (los que cambian el modelo)

### 5.1 24 K3-D discoveries [K3 §12.5]

| ID | Nombre | Confidence | Impacto principal |
|---|---|---|---|
| K3-D1 (Kimi) | `had_alternative` schema-dead field | VERIFIED | Precondición no declarada de READY-03 |
| K3-D4 (Kimi) | STALL log 82% harness noise (14/18) | VERIFIED | H-01 "0 events" es sobre datos no-campo |
| K3-D-STAR | Topología estrella con humano-sink | SUPPORTED | Reformula "trust boundaries anidados" |
| K3-D-CAP2 | Bifurcación sintáctica/semántica | SUPPORTED | Unifica cuándo delegar y cuándo no |
| K3-D-CAP3 | `session_id` schema break | VERIFIED | Provenance rota entre sesiones |
| K3-D-LIFECYCLE | STALL+research+deferrals = 1 clase | VERIFIED | 3 problemas → 1 decisión |
| K3-D-SCHEMA | READY-03 tiene precondición D-INSTR | VERIFIED | READY-03 no es "aceptar N" solo |
| K3-D-PARTIAL | Duplicación entre representaciones parciales | VERIFIED | Ninguna capa es canónica hoy |
| K3-D-OWNER-DEFAULT | "Todo lo no delegado va al humano" | SUPPORTED | Política de defaults invisible |
| K3-D-EXOGENOUS | Meta-doc = respuesta al sustrato | HYPOTHESIS | Meta-doc no es defecto |
| K3-D-AUTHZ-VS-VERIF | Autorización ≠ verificación | SUPPORTED | Automatizar CAP-2s no reduce carga esencial |
| K3-D-PHASE-CHANGE | Pipeline → DAG paralelo en F9-D01=A | PARTIAL | Transición no es limpia |
| K3-D-EPIST-COST | Deferrals sin trigger = coste monotónico | SUPPORTED | F9-D01 tiene coste no nombrado |
| K3-D-SUBSTRATE-FRACTION | >30% CCP responde a fragilidad substrate | HYPOTHESIS | Substrate cambio elimina compensaciones |
| K3-D-DELEG-ORTOGONAL | Delegación explícita = capa transversal | SUPPORTED | Arquitectura E mejora las demás |
| K3-D-BASIS-CAT | Basis tiene categorías asimétricas | SUPPORTED | CAP-1..5 no son homogéneas |
| K3-D-DERIVE-ONLY | De 10 operaciones, sólo DERIVE ausente | VERIFIED | Precisa naturaleza de GAP-1 |
| K3-D-AUTHZ-CAT | CAP-AUTHZ es primitiva faltante | SUPPORTED | Kimi/Claude no la listaron |
| K3-D-COMP-CAT | COMP-* (compensación) es categoría | SUPPORTED | SessionStart+meta-doc son compensaciones |
| K3-D-ABSORPTION | Absorción decisional es epistemológica | SUPPORTED | "collapse" reduce carga cognitiva, no cantidad |
| K3-D-DECISION-COUNT | 13 decisiones abiertas reales, no 4 | VERIFIED | Paquete READY es incompleto |
| K3-D-F9D01-BOTTLENECK | F9-D01 es gate root del decision graph | VERIFIED | Bloquea 3 UNKNOWNs y READY-03 empírica |
| K3-D-CANONICAL-CENTRAL | D-CANONICAL única high-lock-in | SUPPORTED | Merece mayor deliberación |
| K3-D-DELEG-FIRST | Bloque A = punto de entrada natural | SUPPORTED | Recomendación derivada (no obligatoria) |
| K3-D-DUAL-MODEL | K3 y Cm coexisten | SUPPORTED | Honestidad epistemológica |

**8 VERIFIED**, **13 SUPPORTED**, **2 HYPOTHESIS**, **1 PARTIAL**. Ninguno tratado como
hecho sólo porque K3 los denominó WOW.

### 5.2 7 WOW findings [K3 §12.6]

- **WOW-1 GAP-1 no es capacidad faltante; es ausencia de DERIVE**. Cambia framing:
  PAC pasa de "salvadora" a "implementación específica de una clase (DERIVE en dominio
  policy)". Consecuencia: READY-01/02 son derivativas de D-CANONICAL. `SUPPORTED`.
- **WOW-2 el humano hace autorización, no verificación**. La mayor parte de la carga
  humana no es mecanizable. Automatizar CAP-2-sintáctica no reduce carga esencial.
  Refuta la promesa implícita de "reducir revisor humano automatizando verificación".
  `SUPPORTED via K3-D-AUTHZ-VS-VERIF`.
- **WOW-3 entities without lifecycle son una única clase**. STALL events + research
  artifacts + deferrals no son 3 problemas; son 1 clase estructural. Solución: 1
  decisión (D-LIFECYCLE), no 3 fixes. `VERIFIED por composición`.
- **WOW-4 meta-doc es exógena, no defecto**. Rediseño del control plane no elimina
  meta-doc; el único cambio que la reduce es cambio de substrate (S6). Debe
  administrarse, no optimizarse. `HYPOTHESIS con evidencia parcial (proxy K3
  self-completó sin abrir 61A..61G)`.
- **WOW-5 F9-D01=A es gate epistemológico dominante**. Bloquea D-INSTR → bloquea
  observación de U-01/U-02 → bloquea READY-03 empírica. Coste no nombrado en el
  enunciado original. `SUPPORTED por composición aritmética`.
- **WOW-6 el decision space real es ~3× el paquete READY**. 13 vs. 4. El paquete
  actual oculta 9 decisiones. `VERIFIED por enumeración`.
- **WOW-7 delegación explícita como primera decisión**. Bloque A (D-CATALOG + D-DELEG +
  D-LIFECYCLE) es low-cost + ortogonal + mejora todo lo demás. **No es implementación
  arquitectónica**; es intervención de gobernanza. `SUPPORTED as derived recommendation`.

### 5.3 Formato detallado por descubrimiento crítico

```text
K3-D-DECISION-COUNT (WOW-6)
  Afirmación   : 13 decisiones abiertas reales, no 4.
  Evidencia    : `[K3 §11.3]` inventario: 11 tomadas + 4 READY + 4 deferidas + 9 ocultas − 3 mal-clasif = 13.
  Interpretación: paquete READY (owner-facing) es incompleto como base de decisión.
  Confidence   : VERIFIED
  Impacto      : Owner recibe ~3× la carga decisional que el paquete READY sugiere.
  Decisiones afectadas: TODAS. Cambia el "espacio de decisión".
  Qué lo refuta: identificar una decisión adicional (súbelo a 14+) o probar que una es
                 realmente derivada (baja a 12).
```

```text
K3-D-F9D01-BOTTLENECK (WOW-5)
  Afirmación   : F9-D01=A bloquea D-INSTR → U-01/U-02 no observables → READY-03 no empírica.
  Evidencia    : dependency graph `[K3 §11.5]` + `stall-record.sh:46`.
  Interpretación: F9-D01 tiene coste epistemológico creciente no nombrado.
  Confidence   : VERIFIED
  Impacto      : la revisión mínima de F9-D01 (sólo para instrumentación) desbloquea 3 UNKNOWNs.
  Decisiones afectadas: DEC-08 (D-INSTR), DEC-09 (READY-03), DEC-11 (D-DEFERRAL-POLICY).
  Qué lo refuta: path independiente de F9-D01 que produzca la misma evidencia (shadow runtime).
```

```text
K3-D-DERIVE-ONLY (WOW-1)
  Afirmación   : de las 10 operaciones conceptuales, sólo DERIVE está ausente en runtime.
  Evidencia    : `[K3 §10.8]` periodic table de operaciones.
  Interpretación: GAP-1 es específicamente ausencia de DERIVE, no ausencia de "motor de policy".
  Confidence   : VERIFIED
  Impacto      : PAC es una implementación de DERIVE en un dominio; puede haber otras.
  Decisiones afectadas: DEC-04 (D-CANONICAL), DEC-05 (D-MOTOR), READY-01, READY-02.
  Qué lo refuta: identificar otra operación conceptual también ausente.
```

---

## 6. UNKNOWN / Open questions

### 6.1 11 UNKNOWNs [K3 §08.1]

| ID | UNKNOWN | Impacto | Coste ignorar | Categoría | Blocked-by |
|---|---|---|---|---|---|
| U-01 | H-01 materiality | Alto | Alto | ROOT+DECISIONAL | F9-D01 (via D-INSTR) |
| U-02 | STALL classification | Alto | Medio-alto | LOCAL→SYSTEM | schema + policy |
| U-03 | Native runtime | Medio | Bajo hoy, sube S4 | SYSTEM | F9-D02 |
| U-04 | PAC FP rate | Alto | Medio | DECISIONAL | D-CANONICAL=YAML deploy |
| U-05 | CAP-2s sin humano | Alto | Bajo hoy, sube S2 | ROOT-long-term | experimento |
| U-06 | Research artifact lifecycle | Medio | Bajo, sube volumen | STRUCTURAL | cheap: enumeración |
| U-07 | Meta-doc reuse rate | Medio | Medio | STRUCTURAL | proxy resolved (K3 no abrió 61A..G) |
| U-08 | PAC semantic FP general | Alto | Medio | DECISIONAL | policies ricas |
| U-09 | Correlated failure LLM-verifier | Alto | Bajo hoy, sube S2 | ROOT-long-term | experimento |
| U-10 | Meta-doc causa (topology vs substrate) | Medio | Bajo | HYPOTHESIS | comparador externo |
| U-11 | Types of change without gate | Medio | Medio | GOVERNANCE | cheap: git log enum |

**Top-VOI**: U-01 y U-05 son las más críticas. Ambas bloqueadas por decisiones
humanas (F9-D01 o presupuesto de experimento). El Owner es el gate.

### 6.2 Contradicciones / divergencias documentación ↔ repo

- Root Analysis afirma "STALL log = 3 eventos" [RA `00_INDEX.md`]. Realidad al cierre
  K3: **18 líneas**. `REFUTED` — el audit ya lo corrigió; el corpus posterior no
  reactualizó el conteo.
- Root Analysis afirma "F9-D01=A elimina over-engineering" como counterfactual [RA §07].
  Es hipótesis, no evidencia. `HYPOTHESIS`, no debe promoverse.
- Root Analysis lista "18 decisiones → 5 root". Audit + K3 muestran 15 reales + 3
  mal-clasificados; verdadero decision space abierto es 13. `REFUTED como reducción
  numérica; SUPPORTED como observación de que hay reducibilidad`.
- HRQS §12 propone checklist manual para clasificar STALL. Ningún evento del log tiene
  campo `verdict:`. Los 18 eventos actuales están **no clasificados**. `VERIFIED`.

### 6.3 Instrumentación faltante

- `had_alternative` schema-dead (K3-D-SCHEMA).
- `session_id` schema-dead en propagación (K3-D-CAP3).
- Sin campo `verdict:` en el JSONL para clasificación TP/FP/UNK.
- Sin métrica de reuse de meta-doc.
- Sin catálogo de "types of change × required gate" (K3-D-OWNER-DEFAULT).

### 6.4 Precondiciones no satisfechas y decisiones prematuras

- **READY-03 con N=1** parece pequeño pero **depende empíricamente de D-INSTR** que
  cruza F9-D01. Presentar READY-03 sin esta precondición es prematuro (K3-D-SCHEMA).
- **PAC production adoption** no es una decisión aislada — es consecuencia de
  D-CANONICAL=YAML + D-MOTOR=motor.
- **CDT-02 (new agent auth)** es research track, no decisión formal.
- **H-01 threshold** es sub-componente de READY-03, no decisión independiente.

---

## 7. Decision graph completo

### 7.1 Los 13 nodos (owner-facing)

Estructura completa en `[K3 §13]`. Resumen compacto (con `HYPOTHESIS/OPTION` distinguido
de `DECISION/OWNER-PENDING`).

| ID | Nombre | Bloque | Tipo | Urgencia K3 | Owner-only |
|---|---|---|---|---|---|
| DEC-01 | D-CATALOG (change-type × gate) | A | GOVERNANCE | CAN-DEFER | Sí (schema derivable) |
| DEC-02 | D-DELEG (delegation contract) | A | GOVERNANCE | CAN-DEFER | Sí (schema derivable) |
| DEC-03 | D-LIFECYCLE (research/stall lifecycle) | A | GOVERNANCE | CAN-DEFER | Sí (schema derivable) |
| DEC-04 | D-CANONICAL (fuente canónica policy) | B | ARCHITECTURE | SHOULD-BEFORE-NEXT | Sí (estratégica) |
| DEC-05 | D-MOTOR (motor de derivación) | B | ARCHITECTURE | SHOULD-BEFORE-NEXT (cond) | Sí (estratégica) |
| DEC-06 | READY-01/02 (auto-derivadas) | B | DERIVED | DERIVED | Consecuencia de 4+5 |
| DEC-07 | D-VERIFICADOR (CAP-2s implementación) | C | ARCHITECTURE | CAN-DEFER (S1) | Sí (estratégica) |
| DEC-08 | D-INSTR (cambiar schema hooks) | D | ARCHITECTURE | SHOULD-BEFORE-NEXT | Sí (cross gate F9-D01) |
| DEC-09 | READY-03 (derivada de DEC-08 + N sesiones) | D | DERIVED | DERIVED | Consecuencia de 8 + N |
| DEC-10 | READY-04 (formato mensaje) | E | OPERATIONAL | CAN-DEFER | Sí (trivial) |
| DEC-11 | D-DEFERRAL-POLICY | E | PROCESS | SHOULD-BEFORE-NEXT | Sí (governance) |
| DEC-12 | D-META-DOC (política crecimiento) | E | PROCESS | CAN-DEFER | Sí (política) |
| DEC-13 | Bundle F9-D02/A-05/A-07/G-N5 | F | EXTERNAL | WAIT-FOR-EXTERNAL | Owner + external trigger |

Urgencia consolidada: **0 MUST-NOW**, **4 SHOULD-BEFORE-NEXT** (DEC-04, DEC-05, DEC-08,
DEC-11), **6 CAN-DEFER**, **1 DERIVED-COMPOUND** (DEC-06 + DEC-09), **1 EXTERNAL**
(DEC-13). Ninguna decisión es MUST-NOW porque F9-D01=A + S1 estable ⇒ statu quo viable.

### 7.2 Distinción explícita de categorías

- `DECISION` — nodo que requiere elección explícita (todos los DEC-* listados).
- `SUBDECISION` — variantes dentro de una decisión (D4-A vs D4-B en §11).
- `OPTION` — la elección concreta (A1/A2/A3 en DEC-01; D1..D5 en DEC-04).
- `HYPOTHESIS` — no decisión (K3-D-EXOGENOUS, K3-D-SUBSTRATE-FRACTION).
- `QUESTION` — no decisión (U-01..U-11).
- `CONDITION` — precondición o falsifier (F-M1..F-M5).
- `EVIDENCE` — no decisión (EV-001..EV-016).
- `DEPENDENCY` — relación causal (D-CATALOG → D-DELEG).
- `RECOMMENDATION` — no decisión (K3-D-DELEG-FIRST).
- `OWNER DECISION` — DEC que requiere autoridad Owner.
- `DERIVED DECISION` — DEC cuya respuesta se obtiene de otras (DEC-06, DEC-09).

---

## 8. Mapa de dependencias

### 8.1 Dependencias explícitas

```text
DEC-01 D-CATALOG ──feeds──▶ DEC-02 D-DELEG    (categories to delegate)
DEC-03 D-LIFECYCLE ─feeds──▶ DEC-02 D-DELEG    (lifecycle categories in registry)
DEC-02 D-DELEG   ──enables──▶ DEC-07 D-VERIFICADOR  (delegation contract required)
DEC-04 D-CANONICAL ─feeds──▶ DEC-05 D-MOTOR   (motor depends on canonical choice)
DEC-04 D-CANONICAL ─feeds──▶ DEC-06 READY-01/02 (derived)
DEC-05 D-MOTOR ────feeds──▶ U-04 resolution   (post-deploy)
DEC-08 D-INSTR ──enables──▶ U-01/U-02 observation
U-01 (data) ────feeds──▶ DEC-09 READY-03 (N definition needs data)
F9-D01 gate ──blocks──▶ DEC-08 D-INSTR       (runtime change)
F9-D02 gate ──blocks──▶ U-03                 (native runtime)
External trigger ──blocks──▶ DEC-13 bundle
DEC-11 D-DEFERRAL-POLICY ─facilitates──▶ F9-D01 formal revisit for DEC-08
```

### 8.2 Dependencias latentes descubiertas

- **DEC-01 → DEC-03**: sin catálogo de cambios, LIFECYCLE registry no sabe qué gobernar.
- **DEC-02 → DEC-08**: sin delegación explícita, cambiar schema de hooks amplía
  responsabilidad no declarada.
- **DEC-11 → todas las deferrals**: sin política de trigger, los deferrals (F9-D02, A-05,
  A-07, G-N5) permanecen indefinidos y bloquean pipeline de investigación futura.
- **DEC-04 → DEC-07**: si la canónica es YAML rico con metadata `known_fp_classes:`,
  el verificador puede consumir esos metadatos. Sin canónica rica, el verificador
  opera a ciegas.
- **DEC-08 → DEC-11**: instrumentar hooks requiere revisit de F9-D01; sin DEC-11
  (política de deferrals con trigger declarativo), el revisit es ad-hoc.

### 8.3 Root gates (bloquean múltiples)

- **F9-D01=A** — bloquea DEC-08 → bloquea U-01, U-02, READY-03 empírica.
- **F9-D02=B** — bloquea U-03.
- **Ausencia de external trigger** — bloquea DEC-13 (A-05, A-07, G-N5).

**F9-D01 es el nudo dominante**. Su revisión (aunque limitada a instrumentación)
desbloquea 3 UNKNOWNs. K3-D-F9D01-BOTTLENECK.

### 8.4 Reversibilidad ladder

```text
Fully reversible (git revert suficiente):
  DEC-01, DEC-02, DEC-03, DEC-11, DEC-12, DEC-10, DEC-08
Moderately reversible (require re-implementation):
  DEC-05, DEC-07, DEC-06 (READY-01/02), DEC-09 (READY-03)
Hard to reverse (requires migration):
  DEC-04 (D-CANONICAL)  ← ÚNICA
Externally triggered:
  DEC-13 (F9-D02, A-05, A-07, G-N5)
```

**D-CANONICAL es la única "hard-to-reverse"**. Todas las demás son incrementales.

---

## 9. Owner Surface — clasificación por tipo de acción

Aplicando §10 del prompt:

- **YA DECIDIDO**: ARCH-001..004, F8-A, F8-B, F9-D01..D05.
- **OWNER PENDING**: DEC-01, DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-10, DEC-11,
  DEC-12. (Los 9 que requieren juicio inmediato.)
- **OWNER PENDING BUT BLOCKED**: DEC-08 (F9-D01 gate) — el Owner puede aprobarla pero
  cruza el gate F9-D01=A y requiere revisit formal.
- **EVIDENCE REQUIRED FIRST**: U-01, U-05 (bloqueadas por instrumentación o
  experimento).
- **DERIVED**: DEC-06 (READY-01/02) — consecuencia de DEC-04 + DEC-05. DEC-09
  (READY-03) — consecuencia de DEC-08 + N sesiones.
- **DEFERRED**: F9-D02, A-05, A-07, G-N5, CDT-02, AC-03, NH-11 (bajo DEC-13).
- **EXTERNAL TRIGGER**: DEC-13 completa (compliance, audit, cliente).
- **SHOULD NOT BE DECIDED YET**: F10-F12 (F9-D05=A explícito); PAC production
  adoption (consecuencia de DEC-04+DEC-05, no decisión aislada).

---

## 10. DEC-04 en profundidad — Root Analysis especial

DEC-04 (D-CANONICAL) es la única decisión con `LOCK-IN alto` [K3 §11.10]. Merece
tratamiento distinto.

### 10.1 ¿El problema está bien formulado?

Kimi/Claude presentan implícitamente la elección como binaria (manual vs. PAC). K3
identifica **7 puntos viables** en E1×E2 [K3 §06.5]:

```text
                         E2 sync
E1 source        | human    | motor uni  | motor bi   | none      |
─────────────────┼──────────┼────────────┼────────────┼───────────┤
rules-md         | actual   | reverse    | forbidden* | forbidden*|
firewall-regex   | mirror   | forbidden* | forbidden* | discard-md|
tests            | new      | test→both  | forbidden* | test-only |
yaml             | new      | PAC        | rare       | forbidden*|
```

`* forbidden` = deja la otra capa como código muerto o duplica el problema.

**Corrección de framing**: la pregunta no es "rules-md vs firewall vs tests vs YAML vs
no decidir". La pregunta real es un **cross-product**: (source × sync) × ¿existe una
sola canónica? La formulación K3 en DEC-04 (D1..D5) es una simplificación de este
espacio; **es útil pero no exhaustiva**.

### 10.2 ¿Debe existir una única canónica?

**Puede emerger una arquitectura híbrida** [K3 §06.5 punto (3,1) tests+human]. Ejemplo
concreto: tests son canónica ejecutable, humano mantiene .md como documentación,
firewall se genera de tests. Esto no reduce a "una" canónica; hay un source primario
(tests) y un doc mirror derivado (.md), ambos usados por audiencias distintas.

**No presupongas single-source**. El sub-espacio incluye:

- **Single source con adapter** — canónica única + adapters bidireccionales para
  representaciones legibles.
- **Primary + derived** — una canónica primaria, otras derivadas mecánicamente
  (versión de "híbrida controlada").
- **Múltiples canónicas por dominio** — YAML para bash policies, tests para evidence
  policies, .md para governance policies.

### 10.3 Análisis por eje

- **Problema raíz**: falta la operación **DERIVE** entre representaciones (K3-D-DERIVE-ONLY).
  No falta un "motor de policy"; falta la capacidad de derivación mecánica desde
  cualquier fuente canónica.
- **Autoridad**: quien edita la canónica define la política. En D1 (rules-md) →
  humano; en D2 (firewall) → humano; en D3 (tests) → developer/test-author; en D4
  (YAML) → policy author (posiblemente distinto del developer).
- **Intención normativa**: rules-md preserva mejor la intención humana en prosa. YAML
  con `description:` la preserva estructurada. Tests la pierden (test = assertion,
  no intención).
- **Representación**: rules-md legible; firewall opaco; tests expresivos pero
  técnicos; YAML estructurado; combinaciones híbridas posibles.
- **Enforcement**: mecanismo separado en D1/D4 (motor genera firewall); implícito
  en D2 (firewall es la canónica); implícito en D3 (tests son ejecutados por el
  hook).
- **Derivación**: manual en D5; unidireccional en D1/D3/D4; bidireccional posible.
- **Evidencia**: en D1/D4 la trazabilidad canónica→firewall→block es auditable
  (hashes). En D2/D3 la trazabilidad es implícita.
- **Observabilidad**: D4 con IDs por policy permite conteo por ID en STALL. D1/D2/D3
  requieren correlación manual.
- **Trazabilidad**: cada regla identificada por ID en D4; en D1 por línea; en
  D2 por regex; en D3 por test name.
- **Semantic drift**: D1 drift entre .md y firewall (actual). D2 drift entre regex
  y comentarios. D3 drift entre test intent y policy real. D4 drift **eliminado**
  si el motor es idempotente y no hay edición manual del generado.
- **Pérdida de información**: D2 pierde comentarios humanos. D3 pierde intent no
  testeable. D4 pierde ergonomía si YAML se vuelve verboso.
- **Lock-in**: D4 introduce YAML como TCB permanente. D3 introduce runtime de tests
  como TCB. D1 mantiene status quo pero deja el problema abierto. D2 quema puentes con
  la documentación humana.
- **Reversibilidad**: cambiar entre D1/D2/D3/D4 requiere migración de policies existentes.
  Es la única decisión hard-to-reverse. **BAJA**.
- **Evolución**: D4 escala mejor con volumen (PT-2 = 100+ policies). D1 rompe. D2 rompe.
  D3 depende de framework de tests.
- **Provider independence**: todas provider-independent en runtime (bash + git). D3
  puede introducir provider dependence si tests usan LLMs.
- **Failure modes**: D1 drift silencioso. D2 pérdida de memoria humana. D3 gaming
  de tests. D4 FP class discovery (PAC-EF-02 ya observada).
- **Capacidad de migración**: D1→D4 factible con esfuerzo (leer .md, generar YAML).
  D4→D1 factible pero pierde estructura. D2→cualquier otra requiere re-escribir
  todas las regex como enunciados.

### 10.4 Consecuencias derivadas

- **READY-01 y READY-02** dejan de ser decisiones separadas bajo D4+E2 (motor genera
  patrones desde YAML). Bajo D5, permanecen abiertas indefinidamente.
- **HRQS §12** parcialmente absorbido bajo D4 con metadata `known_fp_classes:` —
  policy declara sus propios FP conocidos.
- **Duplicación .md ↔ firewall** desaparece por diseño bajo D2/D4 con motor.
- **Nuevo TCB** aparece bajo D4 (motor) y D3 (test-runner). Requiere test de idempotencia
  y test de no-drift.

### 10.5 Reformulación honesta de DEC-04

En lugar de "elegir D1/D2/D3/D4/D5", la formulación K3-completa es:

```text
DEC-04-refined:
  SUB-DECISION 4a: ¿existe una fuente canónica única de policy? [Sí/No]
  SUB-DECISION 4b (si 4a=Sí): ¿cuál es? [rules-md, firewall, tests, YAML, otro]
  SUB-DECISION 4c: ¿qué representación(es) derivada(s) mantiene el motor? [firewall, tests, .md, all]
  SUB-DECISION 4d: ¿la canónica preserva comentarios humanos? [Sí explícito, Sí adjunto, No]
  SUB-DECISION 4e: ¿el motor es unidireccional o bidireccional? [uni, bi, N/A]
```

Esta expansión es útil porque **cada sub-decisión puede analizarse independientemente**
y algunas se pueden decidir sin comprometer las otras (p.ej. 4d se puede decidir
después de 4b).

---

## 11. Transición hacia Parte II

Fin de la Fase A. Todo lo anterior es **descripción del estado + estructura**. Nada aún
es proyección de qué ocurre bajo cada opción. Eso es Parte II.

**Puentes a Parte II**:

- Cada `DEC-*` de §7 se convierte en fila del proyector.
- Cada `K3-D-*` de §5 puede promoverse a `EVIDENCE` de una proyección específica.
- Cada `U-*` de §6 se convierte en `VALUE OF INFORMATION` en §21.
- La reformulación de DEC-04 (§10.5) se usa en §11 (Puzzle Assembly) y §57
  (Execution Candidates).

**FIN PARTE I.** Continúa con Parte II en la siguiente sección de este mismo archivo.

---

# PARTE II — DECISION PROJECTION ENGINE

> Para cada decisión significativa y cada opción, proyección estructurada de:
> OPTION → PRECONDITIONS → IMMEDIATE EFFECT → ARCHITECTURAL CHANGE → NEW CAPABILITY →
> NEW RISKS → REGRESSIONS → DEPENDENCIES → SECOND-ORDER → THIRD-ORDER → NEW DECISION SPACE.
>
> Notación: `[V]` VERIFIED, `[S]` SUPPORTED, `[I]` INFERRED, `[H]` HYPOTHESIS, `[U]` UNKNOWN, `[R]` REFUTED.
> Todo porcentaje es evaluación argumentada; ver §18 para justificación.

---

## 12. Motor de proyección — framework

Cada decisión con opciones se proyecta con esta plantilla:

```text
DEC-XX / Option Y
  IDENTIDAD           : qué propone exactamente
  PROBLEMA RESUELTO   : qué elimina
  PROBLEMA NO RESUELTO: qué permanece
  PRECONDICIONES      : qué debe ser verdad
  BENEFICIOS          : qué mejora
  COSTES              : impl / mantenimiento / complejidad / contexto / operación / gobernanza / dep humana / dep tecnológica
  MODOS DE FALLO      : qué puede salir mal
  RIESGOS NUEVOS      : qué aparece
  RIESGOS ELIMINADOS  : qué desaparece
  REGRESIONES         : qué puede empeorar
  REVERSIBILIDAD      : A/M/B
  LOCK-IN             : cuál y dónde
  IMPACTO ARQUITECT   : componentes cambian
  IMPACTO EPISTÉMICO  : qué se vuelve observable / deja de serlo
  IMPACTO GOBERNANZA  : cómo cambia la autoridad
  IMPACTO FUTURO      : qué desbloquea/condiciona/invalida
  SECOND-ORDER        : consecuencias indirectas
  THIRD-ORDER         : consecuencias posteriores
  BEFORE→AFTER        : mecanismo antes / mecanismo después
```

Y por decisión: `SCENARIO ENGINE` (ACCEPT/REJECT/DEFER/ALTERNATIVE/WRONG/COMBINATION).

**Nota de honestidad**: para no producir un motor de 60+ páginas repitiendo estructura,
las decisiones triviales (DEC-06 y DEC-09 derivadas; DEC-10 trivial; DEC-13 external
trigger) reciben tratamiento comprimido. Las 9 sustantivas (DEC-01..05, DEC-07, DEC-08,
DEC-11, DEC-12) reciben análisis completo.

---

## 13. Análisis por decisión

### 13.1 DEC-01 D-CATALOG

**A1 — No hacer nada**
- Identidad: statu quo. Cada tipo de cambio cae por default al humano sin declaración.
- Beneficios: 0 coste inmediato.
- Costes: K3-D-EPIST-COST crece; K3-D-OWNER-DEFAULT sigue invisible.
- Regresión: no. Bloquea DEC-02 sin categorías.
- Reversibilidad: N/A.
- Lock-in: bajo, pero acumula deuda de gobernanza.
- Impacto: ninguno hoy; degrada con cada nuevo tipo de cambio.
- BEFORE→AFTER: idéntico.
- Second-order: DEC-02 no puede diseñarse sin catálogo.

**A2 — Catálogo Markdown declarativo** [K3 §13.2]
- Identidad: `docs/00_SYSTEM/CHANGE_TYPES_CATALOG.md` con tabla `type × gate × auth_holder × precedent`.
- Beneficios: elimina zona gris K3-D-OWNER-DEFAULT sin cambiar runtime; habilita DEC-02.
- Costes: mantenimiento humano; ~1–2 horas construcción inicial; ~15 min/mes.
- Regresión: catálogo desactualizado detectable por HRQS.
- Reversibilidad: Alta (git revert).
- Lock-in: bajo (Markdown).
- Impacto arquitect: ninguno de runtime.
- Impacto epistemológico: hace visible qué autoridades están implícitas.
- Impacto gobernanza: reduce zonas grises; explicita ownership.
- Impacto futuro: precondición limpia para DEC-02.
- Second-order: reviewer humano tiene tabla de referencia para clasificar cambios.
- Third-order: nueva discusión sobre "esto es tipo X o Y" migra del ad-hoc al comparativo.
- BEFORE: cada nuevo tipo → improvisación reviewer. AFTER: comparación contra catálogo.

**A3 — Catálogo + hook de verificación**
- Identidad: A2 + hook que rechaza commit introduciendo tipo no listado.
- Beneficios: enforcement mecánico de disciplina.
- Costes: código nuevo (~30 LoC); **cruza F9-D01=A** (nuevo hook runtime).
- Regresión: FP class posible (bloquea trabajo legítimo con etiqueta ausente).
- Reversibilidad: Alta.
- Lock-in: bajo; nueva pieza en runtime pero reemplazable.
- Impacto arquitect: nuevo hook → decisión F9-D01 formal.
- Impacto epistemológico: identical to A2.
- Impacto gobernanza: fuerza disciplina; puede bloquear velocidad.
- Second-order: exige DEC-11 (D-DEFERRAL-POLICY) para formalizar F9-D01 revisit.
- BEFORE: catálogo como convención. AFTER: catálogo como contrato ejecutable.

**Scenario engine DEC-01**:
- ACCEPT (A2): DEC-02 habilitado; DEC-11 no bloqueado; K3-D-OWNER-DEFAULT reducido.
- REJECT: statu quo; degrada silenciosamente.
- DEFER: viable indefinidamente sin daño agudo (S1).
- COMBINATION (A2 + DEC-02 A2): pareja natural; ambos low-cost + high-clarity.
- WRONG (A3 sin DEC-11): abre precedente ad-hoc de F9-D01 revisit; riesgo governance.

### 13.2 DEC-02 D-DELEG

**B1 — No hacer nada**
- Identidad: delegación implícita continúa; K3-D-OWNER-DEFAULT vigente.
- Beneficios: 0 coste.
- Costes: escala mal en S2/S3.
- Regresión: no.
- BEFORE→AFTER: idéntico.

**B2 — Registry Markdown** [K3 §13.3]
- Identidad: `docs/00_SYSTEM/DELEGATION_REGISTRY.md` con `action_type, delegated_to, fallback, activated_by, revocable`.
- Beneficios: auditabilidad; fallback seguro (humano default en gaps); ortogonal K3-D-DELEG-ORTOGONAL.
- Costes: construcción inicial ~2h; ~10 min/entrada.
- Regresión: registry vago mitigable con review.
- Reversibilidad: Alta.
- Lock-in: bajo.
- Impacto arquitect: nueva entidad estatal declarativa.
- Impacto epistemológico: hace explícita cada delegación.
- Impacto gobernanza: **elimina K3-D-OWNER-DEFAULT** — es el cambio dominante.
- Impacto futuro: precondición limpia para DEC-07 (delegación de verificación semántica).
- Second-order: cada nueva delegación es visible; ownership trazable.
- Third-order: base para eventual DEC-07 F2/F3 con confianza.
- BEFORE: "quién decide X?" respondido por default (humano) sin registro. AFTER: consulta al registry.

**B3 — Registry + hook**
- Identidad: B2 + hook valida presencia de entrada. Requiere F9-D01 revisit.
- Beneficios: enforcement de disciplina.
- Costes: código nuevo; F9-D01 cross.
- Regresión: hook rechaza acción legítima (falla-cerrado seguro).
- BEFORE→AFTER: como B2 + gate mecánico.

**Scenario DEC-02**:
- ACCEPT (B2): DEC-07 habilitado con claridad; K3-D-OWNER-DEFAULT desaparece.
- REJECT: nada visible cambia; escala mal más tarde.
- COMBINATION (Bloque A entero A2+B2+DEC-03): sinergia máxima; auditabilidad total gobernanza.
- WRONG (B2 sin DEC-01): registry sin categorías es puro texto libre; degrada rápido.

### 13.3 DEC-03 D-LIFECYCLE

**C1 — No hacer nada**. K3-D-LIFECYCLE persiste; degrada con volumen.

**C2 — Front-matter convención** [K3 §13.4]
- Identidad: cada `docs/research/*.md` gana `status:`, `derived_from:`, `supersedes:`.
- Beneficios: contiene K3-D-LIFECYCLE; runbook periódico verifica.
- Costes: disciplina humana; 30s por archivo.
- Regresión: front-matter obsoleto (detectable por runbook).
- Reversibilidad: Alta.
- Lock-in: bajo.
- Impacto: hace observable qué está activo vs archivado.
- BEFORE: crecimiento silencioso. AFTER: cada archivo tiene estado explícito.

**C3 — Registry activo**. `docs/00_SYSTEM/ARTIFACT_LIFECYCLE_REGISTRY.md`. Máximo control, mayor coste.

**C4 — Sólo research artifacts** (subset C2). Compromiso pragmático; STALL y deferrals no cambian.

**Scenario DEC-03**:
- ACCEPT (C2 o C4): contiene lifecycle sin runtime change.
- COMBINATION (C2 + DEC-12 I2): retrasa PT-3 (fricción por volumen doc).
- WRONG (C3 sin C2 previo): sobre-engineered para el volumen actual.

### 13.4 DEC-04 D-CANONICAL (análisis expandido; ver también §10)

**D1 — rules-md canónica**
- Identidad: llenar placeholders de `.claude/rules/*.md`; motor genera firewall.
- Preconditions: motor confiable; expresividad Markdown suficiente para el corpus.
- Beneficios: legibilidad humana máxima; menor curva de aprendizaje.
- Costes: motor a construir; parser de .md restringido; expresividad limitada.
- Failure modes: motor no captura semántica → drift silencioso.
- Lock-in: **alto** (.md como TCB).
- Impacto arquitect: introduce motor como TCB nuevo; firewall pasa a artefacto derivado.
- Impacto epistemológico: `.md` estructurado permite consulta humana directa.
- Impacto futuro: READY-01/02 se convierten en edits de .md.
- BEFORE: .md placeholders + firewall regex. AFTER: .md completo (canónica) + firewall generado.
- Second-order: developers editan .md, no regex → menor barrera de entrada.
- Third-order: gramática de .md restringida puede limitar policies futuras complejas.

**D2 — firewall canónica**
- Identidad: `.md` deprecados; regex es contrato; comentarios inline como doc.
- Preconditions: aceptar pérdida de doc humana estructurada.
- Beneficios: máxima simplicidad; sin motor; sin drift.
- Costes: pierde memoria humana; onboarding difícil.
- Failure modes: revisor humano no puede razonar sobre regex complejas.
- Lock-in: **alto** (compromiso con formato regex).
- Impacto epistemológico: pérdida de intent; costo alto.
- BEFORE: dual. AFTER: single (regex).

**D3 — tests canónica**
- Identidad: cada policy = test bloqueante; hooks llaman tests.
- Preconditions: latencia aceptable en pre-tool; framework de tests.
- Beneficios: máxima verificabilidad; policies ejecutables.
- Costes: latencia; menor legibilidad; nuevo TCB (test runner).
- Failure modes: tests como policy pueden ser gamed; over-fitting.
- Lock-in: **alto** (test runner + suite).
- Impacto: cambio de paradigma; requiere migración.

**D4 — YAML canónica (PAC-family)**
- Identidad: YAML rico; motor genera firewall + tests + opcional .md.
- Preconditions: motor viable; FP class management (PAC-EF-02 ya observada).
- Beneficios: estructuración máxima; metadata (`known_fp_classes:`, `severity:`); escala.
- Costes: motor + FP framework; YAML es TCB; onboarding YAML.
- Failure modes: nuevas FP classes; motor bug; YAML verboso.
- Lock-in: **alto** (formato YAML).
- Impacto arquitect: nuevo TCB (motor + YAML); firewall derivado; tests derivados.
- Impacto epistemológico: policy con metadata → consulta programática.
- Impacto futuro: DEC-05 se define; READY-01/02 son YAML edits; posible SDK de policy.
- BEFORE: dual, manual. AFTER: YAML → motor → {firewall, tests, .md derivado}.
- Second-order: HRQS parcialmente absorbido en metadata; DEC-07 puede consumir metadata.
- Third-order: escala a PT-2 (100+ policies) sin fricción cuadrática.

**D5 — No decidir**
- Statu quo indefinido. GAP-1 abierto. Costo crece con nuevas policies.

**Scenario DEC-04**:
- ACCEPT D4 + DEC-05 E2: cierra GAP-1; máximo lock-in.
- ACCEPT D1 + DEC-05 E2: cierra GAP-1 con menor curva de aprendizaje pero limitado.
- ACCEPT D2: elimina duplicación por simplificación radical; sacrifica ergonomía humana.
- ACCEPT D3: paradigma tests-as-contract; nuevo runtime.
- ACCEPT D5: sigue igual; se acumula deuda hasta PT-2.
- REJECT (todo): equivalente a D5 pero explícito.
- DEFER: aceptable en S1; sube coste en S2 o PT-2.
- WRONG: elegir D1 sin motor viable → drift silencioso severo.
- COMBINATION (D4 + DEC-11 H2): motor con política de deferral cierra loop de FP class handling.

### 13.5 DEC-05 D-MOTOR

Depende de DEC-04 (upstream). En D5: N/A. En D1/D3/D4: crítica.

**E1 — Manual sync**. Sin nuevo TCB; error humano posible; drift crece con corpus.

**E2 — Motor unidireccional**
- Preconditions: DEC-04 = D1|D3|D4.
- Beneficios: elimina drift; provenance mecánica.
- Costes: motor código + tests de idempotencia + tests de no-drift.
- Failure modes: motor bug → firewall incorrecto; FP class discovery.
- Lock-in: medio (motor reemplazable si canónica se mantiene).
- BEFORE: sync manual (o inexistente). AFTER: cambio en canónica → build → nuevo firewall.
- Second-order: pipeline CI puede correr motor; cambio a canónica sin regenerar firewall = commit rechazado.
- Third-order: base para DEC-07 F2 con provenance clara.

**E3 — Motor bidireccional**
- Preconditions: E2 + tooling extra.
- Beneficios: máxima consistencia.
- Costes: complejidad; risk de loops.
- Lock-in: alto (motor bidireccional es difícil de reemplazar).

**Scenario DEC-05**: la elección natural es E2 si DEC-04 ≠ D5.

### 13.6 DEC-06 READY-01/02 (DERIVED)

Auto-resuelto por (DEC-04, DEC-05):
- (D5, E1) → pendientes como hoy; owner debe aprobar caso por caso.
- (D1|D3|D4 + E2) → se convierten en edits de canónica.
- (D2, E1) → owner aprueba regex directamente.
No requiere análisis independiente.

### 13.7 DEC-07 D-VERIFICADOR

**F1 — Humano solo** (actual). Máxima calidad; sub-escala en S2.

**F2 — LLM adversarial + humano** [K3 §09.5]
- Preconditions: subagente `code-reviewer` invocado obligatoriamente en subagentStop; DEC-02 upstream para explicitar delegación.
- Beneficios: escala; alivia PT-1.
- Costes: LLM API cost; latency; provider dependence.
- Failure modes: correlated failure (U-09); jailbreak sobre el reviewer.
- Lock-in: alto sobre provider LLM.
- Impacto: rompe topología estrella parcialmente.
- BEFORE: humano ex-post commit. AFTER: LLM post-tool + humano ex-post commit.
- Second-order: humano ve pre-filtrado; se acostumbra → puede perder skill.

**F3 — Dual-LLM adversarial**
- Beneficios: reduce correlated failure.
- Costes: 2× LLM cost; complejidad.
- Lock-in: mayor.

**F4 — Segundo humano**. Impracticable con solo owner.

**Scenario DEC-07**:
- ACCEPT F2 con DEC-02 upstream: alivio PT-1; ojo con U-09.
- ACCEPT F2 sin DEC-02: delegación implícita; riesgo governance.
- DEFER: viable en S1.

### 13.8 DEC-08 D-INSTR (bloqueada por F9-D01=A)

**G1 — No hacer nada**. `had_alternative` = null; `session_id` = null; K3-D-EPIST-COST crece.

**G2 — Modificar `stall-record.sh`**
- Identidad: aceptar `had_alternative` como input real; propagar `session_id`; añadir `verdict:` field.
- Preconditions: **F9-D01 revisit formal** (o política de excepción via DEC-11).
- Beneficios: desbloquea U-01, U-02, READY-03 empírica.
- Costes: código ~20 LoC; establece precedente F9-D01 revisit.
- Failure modes: hook bug → eventos malformados (detectable con tests).
- Reversibilidad: Alta (default null preserva histórico).
- Impacto epistemológico: 3 UNKNOWNs pasan de bloqueados a observables.
- Impacto gobernanza: precedente F9-D01 revisit; requiere DEC-11 para formalizar.
- BEFORE: schema-partial. AFTER: schema-complete.
- Second-order: STALL log tiene datos para HRQS y análisis.

**G3 — Shadow runtime**
- Identidad: runtime paralelo instrumentado; productivo no cambia.
- Beneficios: no cruza F9-D01.
- Costes: alto operativo; representatividad dudosa.
- BEFORE: sólo productivo. AFTER: productivo + shadow.

**Scenario DEC-08**:
- ACCEPT G2 con DEC-11 upstream: preferido; formal + auditable.
- ACCEPT G2 sin DEC-11: ad-hoc; abre puerta a más revisits sin criterio.
- ACCEPT G3: preserva F9-D01=A; costoso.
- REJECT: U-01/U-02/READY-03 empírica bloqueadas indefinidamente.

### 13.9 DEC-09 READY-03 (DERIVED)

Post DEC-08 + N sesiones:
- G2 + N sesiones con clasificación → READY-03 resuelto con datos.
- G1 → cierre con caveat "no empírico" o abierto indefinidamente.
Owner define N.

### 13.10 DEC-10 READY-04 (formato mensaje)

Trivial. Opciones: elegir entre formatos del handoff. Reversibilidad alta. Lock-in bajo.

### 13.11 DEC-11 D-DEFERRAL-POLICY

**H1 — No hacer nada**. Deferrals acumulan; governance decay monotónico.

**H2 — Política declarativa** [K3 §13.12]
- Identidad: cada deferimiento gana `trigger:` (condición mecánica o "revisión trimestral"); default trimestral.
- Beneficios: detiene governance decay; fuerza revisión periódica.
- Costes: 30 min/deferral inicial; ~1 hora trimestral.
- Impacto: hace explícito qué desbloquea cada deferral; contiene K3-D-EPIST-COST.
- BEFORE: deferrals "hasta trigger concreto" sin criterio. AFTER: cada deferral con condición observable.
- Second-order: facilita DEC-08 (F9-D01 revisit formal).

**H3 — Política + runbook**
- H2 + `maintenance.sh` incluye check "deferrals sin trigger o vencidos".
- Coste marginal bajo; máxima auditabilidad.

### 13.12 DEC-12 D-META-DOC

**I1 — No hacer nada**. Meta-doc crece libre; PT-3 activo antes.

**I2 — Política de cap** (30 activos en `docs/00_SYSTEM/`; excedente → archive).

**I3 — Convención supersedes**. Cada handoff → `supersedes:` archivado.

**I4 — I2 + I3**. Ambas. Coste bajo; alto benefit.

### 13.13 DEC-13 External-triggered bundle

WAIT-FOR-EXTERNAL. Sin opción interna hoy. DEC-11 formaliza el trigger declarativo.

---

## 14. BEFORE → AFTER matriz consolidada

Sólo para las opciones dominantes o naturales por decisión (evita padding):

| DEC | Opción | Mecanismo BEFORE | Mecanismo AFTER | Nueva pieza | Pieza obsoleta |
|---|---|---|---|---|---|
| 01 | A2 | reviewer improvisa clasificación | catálogo `CHANGE_TYPES_CATALOG.md` | catálogo | improvisación |
| 02 | B2 | delegación implícita (default humano) | `DELEGATION_REGISTRY.md` | registry | K3-D-OWNER-DEFAULT |
| 03 | C2 | `docs/research/*` sin status | front-matter en cada archivo + runbook | convención | crecimiento silencioso |
| 04 | D4 | .md placeholders + firewall regex manual | YAML canónica + motor + firewall derivado | motor, YAML, FP framework | duplicación manual .md↔firewall |
| 04 | D1 | .md placeholders + firewall regex manual | .md completa + motor + firewall derivado | motor Markdown-parser | duplicación |
| 05 | E2 | manual sync | motor unidireccional en build | motor | sync manual |
| 07 | F2 | humano ex-post commit | LLM post-tool + humano ex-post commit | LLM verifier | fracción de carga humana sintáctica |
| 08 | G2 | `had_alternative=null`, `session_id=null` | schema completo + `verdict:` field | schema extendido | K3-D-SCHEMA (parcialmente) |
| 08 | G3 | sólo runtime productivo | productivo + shadow instrumentado | shadow runtime | (nada; se añade) |
| 11 | H2 | deferrals sin trigger declarado | cada deferral con `trigger:` | policy declarativa | governance decay |
| 12 | I4 | crecimiento libre | cap + supersedes convención | política + archive | crecimiento monotónico |

---

## 15. Scenario Engine expandido

Para cada decisión importante, respuesta a:

| DEC | ACCEPT | REJECT | DEFER | ALTERNATIVE | WRONG-DECISION | COMBINATION |
|---|---|---|---|---|---|---|
| 01 | Catálogo listo; DEC-02 desbloqueado | Zona gris persiste; DEC-02 imposible sin catálogo | Viable en S1; deuda crece | A3 (hook) requiere DEC-11 primero | Elegir A3 sin DEC-11 → precedente F9-D01 revisit | A2 + DEC-02 B2 + DEC-03 C2 = Bloque A completo, sinergia máxima |
| 02 | K3-D-OWNER-DEFAULT muerto; DEC-07 posible | Escala mal; S2/S3 sufren | Viable en S1; deuda crece | B3 con hook | Elegir B2 sin DEC-01 → registry sin categorías | Bloque A completo (mismo que 01) |
| 03 | Contiene K3-D-LIFECYCLE | Crecimiento silencioso | Aceptable si volumen estable | C4 subset | C3 sin C2 previo es sobre-engineered | C2 + DEC-12 I2 retrasa PT-3 |
| 04 | GAP-1 cerrado; DEC-05 activo; READY-01/02 derivadas | Duplicación indefinida; PT-2 activa urgencia | S1 OK; PT-2 explosivo | D3 (tests) alternativa | D1 sin motor viable → drift severo | D4 + E2 + DEC-11 H2 = pipeline PAC completo |
| 05 | Elimina drift entre canónica y derivados | Sin motor: drift si canónica ≠ manual | Conditional a DEC-04 | E3 (bidireccional) | E1 con D4 = pierde sentido de canónica | E2 + DEC-04 D4 = canonical + motor working |
| 07 | Escala; alivia PT-1 | Statu quo; PT-1 activa | S1 OK | F3 dual-LLM | F2 sin DEC-02 → delegación implícita | F2 + DEC-02 B2 + DEC-04 D4 (metadata) |
| 08 | 3 UNKNOWNs desbloqueados | K3-D-EPIST-COST monotónico | Indefinidamente diferible con costo | G3 shadow | G2 sin DEC-11 → precedente ad-hoc | G2 + DEC-11 H2 = revisit formal con política |
| 11 | Governance decay detenido | Deferrals crecen; UNKNOWNs bloqueados | Contradice propio propósito | H3 (runbook) | H1 = no decisión = decisión | H2 + DEC-08 = precedente formal de revisits |
| 12 | Contiene meta-doc growth | PT-3 activa antes | S1 OK | I3 supersedes only | I2 sin DEC-03 = archive sin lifecycle | I2 + DEC-03 C2 = lifecycle + cap |

---

## 16. Regression Engine

Para cada opción, `WIN`/`SAME`/`LOSS` en cada dimensión (vista compacta):

```text
Dim.          | 01A2 02B2 03C2 04D4 04D1 05E2 07F2 08G2 08G3 11H2 12I4
SECURITY      | SAME SAME SAME WIN  WIN  WIN  WIN  SAME SAME SAME SAME
TRACEABILITY  | WIN  WIN  WIN  WIN  WIN  WIN  WIN  WIN  WIN  WIN  WIN
QUALITY       | WIN  WIN  WIN  WIN  WIN  WIN  WIN  WIN  SAME WIN  WIN
VERIFIABILITY | SAME SAME SAME WIN  SAME WIN  WIN  WIN  WIN  SAME SAME
REVERSIBILITY | HIGH HIGH HIGH LOW  LOW  MED  MED  HIGH HIGH HIGH HIGH
CONTEXT CTRL  | WIN  WIN  WIN  SAME SAME SAME SAME SAME SAME SAME WIN
STATE CTRL    | SAME SAME SAME WIN  SAME SAME SAME WIN  WIN  SAME SAME
MANUAL WORK   | LESS LESS LESS LESS LESS LESS LESS LESS SAME LESS LESS
ERROR RATE    | SAME SAME SAME LESS LESS LESS LESS LESS SAME SAME SAME
REUSE         | WIN  WIN  WIN  WIN  WIN  WIN  WIN  SAME SAME WIN  WIN
PRODUCTIVITY  | WIN  WIN  WIN  WIN  WIN  WIN  WIN  SAME SAME WIN  WIN
MAINTAINABILITY|WIN  WIN  WIN  MIX  MIX  WIN  MIX  WIN  MIX  WIN  WIN
EVOLUTION     | WIN  WIN  WIN  WIN  WIN  WIN  WIN  WIN  MIX  WIN  WIN
DONE EVIDENCE | SAME SAME SAME WIN  WIN  WIN  WIN  WIN  WIN  SAME SAME
```

Riesgos de regresión (dónde una WIN esconde una LOSS oculta):
- **04D4/D1 + 05E2 en MAINTAINABILITY = MIX**: motor requiere mantenimiento nuevo; el
  neto depende del ratio de policies (peor con 10; mejor con 100+).
- **07F2 en MAINTAINABILITY = MIX**: LLM API changes rompen; provider dependency deuda.
- **08G3 en MANUAL WORK/QUALITY = SAME**: shadow no reduce carga; sólo instrumenta.

---

## 17. Benefit vs Complexity — categorización

Cada decisión introduce complejidad. Clasificación:

- **Complejidad útil** (habilita capability nueva): 04-D4/D1 (canónica), 05-E2 (motor),
  07-F2 (delegación verificación).
- **Complejidad compensatoria** (parche a defecto estructural): 08-G3 (shadow por no cruzar F9-D01).
- **Complejidad accidental** (evitable): ninguna en el conjunto sobreviviente.
- **Complejidad temporal** (transición, se retira): motor bridge en cutover si D4 se elige.
- **Complejidad recurrente** (mantenimiento continuo): 07-F2 (LLM cost), 04-D4 (YAML mantenimiento).
- **Complejidad que habilita reducción futura**: 01-A2, 02-B2, 11-H2 (todo el Bloque A + DEC-11).

**Regla derivada**: DEC del Bloque A + DEC-11 son inversión de complejidad que **reduce**
complejidad futura (governance decay). DEC-04 + DEC-05 son inversión de complejidad
que **cambia** complejidad futura (elimina drift, introduce motor).

---

## 18. Evaluación por porcentajes (argumentada, no probabilística)

Escala interpretativa:

- `% context fit`: cuánto encaja con lo que ya existe.
- `% expected benefit`: cuánto beneficio se espera si se implementa correctamente.
- `% evidence confidence`: cuán sólida es la evidencia que soporta el análisis.
- `% implementation risk`: probabilidad de que la implementación cause daño.
- `% regression risk`: probabilidad de introducir regresión.
- `% reversibility`: facilidad de deshacer.
- `% long-term architectural value`: valor a S2/S3/PT-2.
- `% lock-in`: cuánto compromete futuras opciones.
- `RECOMMENDATION CONFIDENCE`: cuán seguro se puede ser de recomendar (a alguien más que el Owner).

Justificación por decisión (opción principal):

| DEC | Op | ctx | ben | ev | impl | reg | rev | LT | LK | RC |
|---|---|---|---|---|---|---|---|---|---|---|
| 01 | A2 | 95% | 55% | 90% | 5%  | 5%  | 95% | 45% | 10% | 85% |
| 02 | B2 | 90% | 70% | 85% | 10% | 10% | 95% | 70% | 15% | 80% |
| 03 | C2 | 85% | 45% | 80% | 15% | 20% | 90% | 55% | 10% | 70% |
| 04 | D4 | 60% | 75% | 55% | 45% | 40% | 25% | 85% | 75% | 40% |
| 04 | D1 | 75% | 50% | 60% | 35% | 35% | 30% | 55% | 65% | 45% |
| 04 | D5 | 100%| 0%  | 100%| 0%  | 0%  | 100%| 20% | 10% | 55% |
| 05 | E2 | 65% | 70% | 55% | 40% | 35% | 50% | 75% | 55% | 45% |
| 07 | F2 | 55% | 55% | 50% | 40% | 35% | 55% | 70% | 75% | 35% |
| 08 | G2 | 40% | 75% | 85% | 25% | 15% | 90% | 60% | 20% | 55% |
| 08 | G3 | 70% | 45% | 60% | 40% | 20% | 85% | 40% | 25% | 40% |
| 11 | H2 | 95% | 65% | 90% | 5%  | 5%  | 95% | 65% | 10% | 85% |
| 12 | I4 | 90% | 40% | 75% | 10% | 10% | 95% | 45% | 10% | 70% |

Ejemplo de justificación:

- **04-D4 `ev 55%`**: PAC prototype existe pero PAC-EF-02 muestra FP class emerge; no
  hay corpus real de producción. `Baja por lo que aún no observamos; sube si se
  producen 20+ policies validadas`.
- **04-D5 `LT 20%`**: statu quo no genera valor a S2/S3; sólo preserva optionality.
  `Sube si nunca se llega a S2/S3`.
- **08-G2 `ctx 40%`**: cruza F9-D01=A → tensión con owner gate. `Sube si DEC-11 aprobada
  previamente; baja si se hace ad-hoc`.
- **07-F2 `LK 75%`**: LLM provider dependency alta. `Baja si adoptamos abstraction layer`.

**Nota crítica**: estos porcentajes son instrumentos de razonamiento. **Nunca sustituyen
al owner**; la recomendación confianza <60% significa "la evidencia no basta para
recomendar a un tercero" — el Owner sigue decidiendo con contexto propio.

---

## 19. Recomendación condicional (formato uniforme)

En lugar de "B es la mejor":

- **DEC-01**: A2 recomendable **si** se planea adoptar Bloque A completo; **cambiar a A3
  si** aparece incumplimiento de convención registrado; **mantener A1 si** el
  volumen de cambio se mantiene < 1 tipo nuevo por trimestre.
- **DEC-02**: B2 recomendable **si** DEC-01 A2 aprobado; **cambiar a B3 si** se observa
  omisión de delegaciones documentadas; **mantener B1 si** S1 se estabiliza y
  DEC-07 no se contempla.
- **DEC-03**: C2 o C4 recomendable **si** volumen de research crece >10 archivos/mes;
  **mantener C1 si** volumen estable.
- **DEC-04**: **no recomendar sin owner input**. Si se debe elegir bajo condiciones
  actuales, D5 (defer) mientras (a) no se llegue a PT-2, (b) no aparezca policy compleja
  no expresable en formato actual, (c) no se decida DEC-05 upstream. **Cambiar a D4 si**
  volumen de policies > 30 y PAC valida FP rate bajo. **Cambiar a D1 si** legibilidad
  humana es dimensión dominante en el equipo.
- **DEC-05**: derivada de DEC-04.
- **DEC-07**: **no recomendar sin owner input**. Si se debe recomendar, F1 (statu quo)
  hasta S2. **Cambiar a F2 si** > 5 agentes concurrentes o subagentStop review manual
  se vuelve fuente de fricción.
- **DEC-08**: G2 recomendable **si** DEC-11 H2 aprobado previamente. **Cambiar a G3 si**
  Owner insiste en F9-D01=A intacto. **Mantener G1 si** READY-03 se acepta con
  caveat.
- **DEC-11**: H2 recomendable **incondicionalmente** para detener governance decay.
- **DEC-12**: I4 recomendable **si** DEC-03 C2 aprobado previamente; **mantener I1 si**
  meta-doc growth se percibe como cost benign.

---

## 20. Decision leverage

Decisiones con efectos desproporcionados:

- **DEC-04**: alto leverage arquitectónico; alto lock-in; alta consecuencia si erróneo.
  Toca READY-01/02/06, arquitectura B/C, D-CANONICAL-CENTRAL.
- **DEC-02 (B2)**: alto leverage governance; bajo lock-in; **primera decisión Owner
  viable** (K3-D-DELEG-FIRST + K3-D-DELEG-ORTOGONAL). Desbloquea DEC-07 con claridad.
- **DEC-11 (H2)**: alto leverage epistemológico; bajo lock-in. Detiene governance decay;
  precondición limpia para DEC-08.
- **DEC-08 (G2)**: alto leverage epistemológico; bajo lock-in; **cruza F9-D01=A**.
  Desbloquea 3 UNKNOWNs. Con DEC-11 previa, es low-risk.

**Regla derivada**: alta palanca no implica "mejor". La palanca correcta depende de
qué se quiere desbloquear.

---

## 21. Value of Information — por decisión difícil

Para cada decisión no trivial, qué información añadida cambiaría la conclusión:

- **DEC-04**: sabremos más si (a) se produce corpus PAC de 30+ policies con FP rate real,
  (b) se prototipa D1 con parser Markdown restringido, (c) volumen actual (< 25 policies)
  hace irrelevante D4.
  - **Experimento mínimo**: expandir corpus PAC a 25 policies + medir FP rate + medir
    ergonomía humana (¿developers eligen editar YAML o .md?).
  - **Falsifier**: FP rate > 5% en corpus real → D4 problemático; motor de D1 (Markdown)
    incapaz de expresar 20% de policies → D1 no viable.
- **DEC-05**: consecuencia de DEC-04.
- **DEC-07**: sabremos más si (a) U-05 resuelto (prototipo LLM adversarial con corpus
  conocido-tramposo), (b) U-09 medido (dual-LLM correlated failure).
  - **Experimento mínimo**: prototipar F2 con 20 casos adversariales conocidos; medir
    precision/recall vs. humano baseline.
- **DEC-08**: sabremos más si (a) G3 shadow se prototipea, (b) N sesiones de campo
  con instrumentación.
  - **Experimento mínimo**: modificar `stall-record.sh` en fork; correr en OpenCode
    por N semanas; comparar clasificación.
- **DEC-11**: no requiere información adicional (política, no evidencia).

**Regla**: cuando VOI del experimento es alto y coste bajo, **experimentar antes de
decidir**. Cuando VOI es bajo o coste alto, **decidir con incertidumbre explícita**.

---

## 22. Decision order optimization

Orden actual sugerido por K3 [K3 §11.12] (no autoritativo):

```text
1. DEC-01 + DEC-02 + DEC-03  (Bloque A — low-cost transversal)
2. DEC-11 + DEC-12          (procesos que detienen governance decay)
3. DEC-10                    (trivial)
4. DEC-04                    (decisión estratégica dominante)
5. DEC-05                    (conditional a 4)
6. DEC-06 READY-01/02        (derivativas)
7. DEC-08                    (requiere F9-D01 revisit → DEC-11 upstream)
8. DEC-09 READY-03           (post DEC-08 + N)
9. DEC-07                    (después de DEC-02 con experimento)
10. DEC-13 external          (esperar)
```

**Optimizaciones alternativas**:

- **Minimizar lock-in temprano**: mover DEC-04 después de haber intentado A+B+C (DEC-01,
  DEC-02, DEC-03) para saber si la duplicación es realmente un problema al escalar
  gobernanza.
- **Maximizar información**: DEC-08 primero (con DEC-11 antes) para obtener datos sobre
  U-01/U-02 antes de decidir DEC-04 y DEC-05 (los datos pueden mostrar que la
  duplicación no es fuente principal de FP).
- **Maximizar reversibilidad**: retrasar DEC-04 lo más posible; correr todo lo demás
  primero.
- **Minimizar riesgo compuesto**: aprobar DEC-11 antes de cualquier DEC que requiera
  F9-D01 revisit.

**Ordenación recomendada por K3 (auditada)**: la K3-orden es razonable pero
**subestima el valor de DEC-08 temprana con DEC-11 upstream** — los datos que produce
pueden reformular DEC-04. Ver §30 audit.

---

## 23. Execution trajectory

Trayectoria completa hipotética (path óptimo K3 view, no autorizado):

```text
CURRENT CCP (F8 + F9 gate closed)
  ↓ DEC-11 H2
CCP + deferral policy (governance decay detenido)
  ↓ DEC-01 A2 + DEC-02 B2 + DEC-03 C2 (Bloque A)
CCP + gobernanza explícita (K3-D-OWNER-DEFAULT muerto; K3-D-LIFECYCLE contenido)
  ↓ DEC-08 G2 (con DEC-11 upstream formalizado)
CCP + schema completo (U-01/U-02 observables; READY-03 empírica factible)
  ↓ N sesiones de campo
CCP + datos de campo (READY-03 resoluble)
  ↓ DEC-09 (READY-03 cerrado o mantenido con criterio)
CCP + LABYRINTH-1 con criterio observable
  ↓ DEC-04 D4 + DEC-05 E2  (o D5 si datos indican statu quo suficiente)
CCP + canónica única (GAP-1 cerrado o explícitamente diferido)
  ↓ DEC-06 (READY-01/02 derivadas)
CCP + policy pipeline unificada
  ↓ DEC-07 F2 (conditional a S2)
CCP + verificación delegada (topología estrella parcialmente rota)
  ↓ DEC-13 external
CCP + trust boundary expandido si trigger apareció
```

Cada transición debe verificar (§56 Assembly Certificate).

---

## 24. Path comparison — 6+ caminos

- **PATH A — Intervención mínima**: DEC-11 H2 solamente. Detiene decay. No cambia
  gobernanza. Low cost. High reversibility. Non-transformative.
- **PATH B — Claridad y gobernanza**: DEC-11 + Bloque A (DEC-01/02/03) + DEC-12. Elimina
  K3-D-OWNER-DEFAULT sin cruzar F9-D01. Alto benefit governance; low cost; high
  reversibility.
- **PATH C — Observabilidad primero**: DEC-11 + DEC-08 G2 (revisit formal). Desbloquea
  3 UNKNOWNs. Cruza F9-D01. Alto benefit epistemológico; introduce precedente.
- **PATH D — Enforcement primero**: DEC-04 D4 + DEC-05 E2 + DEC-06. Cierra GAP-1. Alto
  benefit arquitectónico; alto lock-in; requiere DEC-11 (deferrals) upstream para
  handling de FP classes.
- **PATH E — Delegación primero**: DEC-02 B2 + DEC-07 F2 (con experimento). Rompe
  topología estrella parcialmente. Requiere DEC-01 y DEC-02 upstream. Alto benefit
  escala; provider dependence.
- **PATH F — Arquitectura híbrida evolutiva**: Bloque A + DEC-11 + DEC-08 G3 (shadow) +
  DEC-04 diferido con experimento. Mantiene F9-D01=A intacto. Coste medio; máxima
  optionality futura.
- **PATH G — Cambio radical**: DEC-04 D2 (single source firewall) o D3 (tests). Elimina
  duplicación por deletion. Sacrifica ergonomía humana. High cost cultural; low ongoing
  cost.

Estado proyectado por path (cualitativo):

| Path | Change vol | Benefit S1 | Benefit S2/S5 | Lock-in | Reversibility | Prep next dec |
|---|---|---|---|---|---|---|
| A | mínimo | bajo | bajo | bajo | alta | ninguna |
| B | bajo | alto | medio | bajo | alta | óptima |
| C | bajo | medio | alto | medio | alta | óptima (datos) |
| D | alto | medio | alto | **alto** | media/baja | óptima |
| E | medio | bajo | alto | alto (provider) | media | óptima |
| F | medio | alto | alto | bajo | alta | óptima (optionality) |
| G | alto | medio | alto | alto | media | limitada |

---

## 25. Architectural blind-spot test

¿Las 5 arquitecturas A/B/C/D/E cubren todo el espacio?

Regiones **no representadas** (o representadas implícitamente):

- **Arquitectura F — Híbrida evolutiva multi-canónica**: distintas canónicas por dominio
  (YAML para bash policies, tests para evidence policies, .md para governance). K3
  no la lista explícita pero es implícita en la ampliación de DEC-04.
- **Arquitectura G — Provider-agnostic con adapters**: sistema de adaptadores para
  cualquier LLM verifier. K3 la sub-representa en D+E.
- **Arquitectura H — Human-central formalizada** (opuesta a E): declarar explícitamente
  que la mayoría de decisiones son humanas y **medir** el coste humano (métricas de
  tiempo). Sin cambiar la topología. No es una alternativa; es una honestidad extendida
  de A.
- **Arquitectura I — Evidence-centric**: todo cambio requiere evidencia previa (no
  sólo tasks). Extiende INV-1 a nuevos dominios. K3 no la contempla.
- **Arquitectura J — Reversible evolutionary**: cada cambio con shadow + comparison +
  cutover automático o rollback. Genérico. K3 lo menciona sólo para runtime.

**Justificación de la omisión** por K3: A/B/C/D/E son el mínimo relevante para las
decisiones actuales. F/G/H/I/J son metas-arquitecturas o extensiones. Este MASTER las
declara para no perder optionality.

---

## 26. Decision graph integrity test

Verificaciones:

- **Circular dependency**: ninguna detectada. DEC-01 → DEC-02, no vuelta.
- **Decisión sin opción**: ninguna (todas tienen ≥ 2 opciones).
- **Opción sin condiciones**: DEC-10 READY-04 (trivial); acceptable.
- **Recomendación sin evidencia**: K3-D-DELEG-FIRST es recomendación derivada; ver §19
  para condiciones.
- **Dependencia sin justificación**: DEC-11 → DEC-08 justificada por precedente
  governance de F9-D01 revisit.
- **Decisión derivada tratada como Owner**: K3 lista DEC-06 y DEC-09 como DERIVED
  correctamente.
- **Owner decision tratada como derivada**: no.
- **Decisión bloqueada presentada como ejecutable**: DEC-08 está bloqueada por
  F9-D01=A; K3-13 lo marca como SHOULD-BEFORE-NEXT pero explicíta cross-gate.
  **Riesgo interpretativo**: leer "SHOULD-BEFORE-NEXT" como "hágalo ya" es incorrecto.

---

## 27. Master Owner Surface (tabla)

| DEC | Opt | Conditions | Benefit | Risk | Regression | Reversibility | Lock-in | Depends on | Confidence | Analytical rec | Owner action |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 01 | A2 | Volumen change > 1 tipo/quarter | Governance clarity | Bajo | Bajo | Alta | Bajo | ninguna | 85% | Adoptar con Bloque A | Aprobar A2 |
| 01 | A3 | A2 + DEC-11 previa | Enforcement mecánico | Medio | Medio | Alta | Bajo | DEC-11 | 55% | Diferir hasta A2 estable | Diferir |
| 02 | B2 | DEC-01 aprobado | Elimina K3-D-OWNER-DEFAULT | Bajo | Bajo | Alta | Bajo | DEC-01 | 80% | Adoptar con Bloque A | Aprobar B2 |
| 02 | B3 | B2 + DEC-11 previa | Enforcement | Medio | Medio | Alta | Bajo | DEC-11 | 45% | Diferir hasta B2 estable | Diferir |
| 03 | C2 | Volumen research > 10/mes | Contiene K3-D-LIFECYCLE | Bajo | Bajo | Alta | Bajo | ninguna | 70% | Adoptar con Bloque A | Aprobar C2 |
| 03 | C3 | Alta necesidad governance | Máximo control | Medio | Medio | Alta | Bajo | ninguna | 40% | Diferir | Diferir |
| 04 | D5 | Volumen < 30 policies + S1 | Sin lock-in | 0 | 0 | Alta | Bajo | ninguna | 55% | Aceptable en corto plazo | Diferir con criterio |
| 04 | D4 | Volumen crece + PAC FP rate < 5% + DEC-11 upstream | Cierra GAP-1; escala | Medio | Medio | Baja | Alto | DEC-05 E2, DEC-11 | 40% | No sin experimento previo | Experimentar (K3 §21) |
| 04 | D1 | Legibilidad dimensión dominante | Ergonomía | Medio | Medio | Baja | Alto | DEC-05 E2 | 45% | No sin experimento | Experimentar |
| 04 | D3 | Test-driven governance preferida | Máxima verificabilidad | Alto | Alto | Media | Alto | DEC-05 | 30% | No sin prototipo | Diferir |
| 04 | D2 | Aceptar pérdida doc humana | Simplicidad radical | Medio | Alto | Media | Alto | ninguna | 20% | No | Rechazar salvo con justificación fuerte |
| 05 | E2 | DEC-04 ≠ D5 | Elimina drift | Medio | Medio | Media | Medio | DEC-04 | 45% | Consecuencia DEC-04 | Derivar de DEC-04 |
| 07 | F1 | S1 estable | Máxima calidad | 0 | 0 | N/A | Bajo | ninguna | 90% | Mantener en S1 | Mantener |
| 07 | F2 | S2 activo + U-05 experimento OK + DEC-02 upstream | Escala | Medio | Medio | Media | Alto (provider) | DEC-02, U-05 | 35% | Sólo con experimento | Diferir hasta S2 |
| 08 | G1 | Aceptar U-01/U-02 UNKNOWN indefinido | Sin cambio | 0 | 0 | N/A | Bajo | ninguna | 55% | Aceptable con caveat | Diferir con caveat |
| 08 | G2 | DEC-11 H2 aprobado + F9-D01 revisit formal | Desbloquea 3 UNKNOWNs | Bajo | Bajo | Alta | Bajo | DEC-11 | 55% | Adoptar con DEC-11 | Aprobar tras DEC-11 |
| 08 | G3 | Preservar F9-D01=A intacto | Instrumenta sin cross | Medio | Bajo | Alta | Bajo | ninguna | 40% | Alternativa costosa | Considerar si G2 rechazado |
| 11 | H2 | Ninguna | Detiene governance decay | 0 | 0 | Alta | Bajo | ninguna | 85% | Adoptar | Aprobar H2 |
| 11 | H3 | H2 + integración maintenance | Auditabilidad | Bajo | Bajo | Alta | Bajo | H2 | 70% | Adoptar tras H2 | Aprobar H3 después |
| 12 | I4 | DEC-03 C2 aprobado | Contiene meta-doc growth | Bajo | Bajo | Alta | Bajo | DEC-03 | 70% | Adoptar con Bloque A | Aprobar I4 |
| 10 | (any) | Ninguna | Formato mensaje | Trivial | Trivial | Alta | Bajo | ninguna | 95% | Elegir cualquiera | Owner elige |
| 13 | wait | External trigger | Sin decidir hoy | 0 | 0 | Alta | N/A | Trigger externo | N/A | No decidir | Esperar |

**Esta tabla es superficie**. El razonamiento completo vive en §13–§25.

**FIN PARTE II.**

---

# PARTE III — PUZZLE ASSEMBLY ENGINE

> CCP como rompecabezas parcialmente ensamblado. Cada decisión es **movimiento sobre
> piezas existentes**: mover, reemplazar, dividir, fusionar, introducir, eliminar,
> cambiar relación, cambiar autoridad, cambiar información. La pregunta no es "¿es
> buena la opción?" sino **"¿encaja la pieza después de moverla?"**.

## 28. Baseline assembled state — piezas del CCP

Este mapa es el `CURRENT ASSEMBLED CCP`. Sobre él se simulan movimientos.

### 28.1 Piece catalog (top-level)

| PIECE-ID | Name | Type | Purpose | Inputs | Outputs | Interfaces | Preconditions | Postconditions | Authority | Evidence | Failure modes | Reversibility | Lock-in |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| P-BB | BLOCKER-BEFORE-BASH | hook | denies/allows bash cmd | stdin JSON tool call | exit 0/2 + optional emit | tool-invocation | valid JSON payload | bash executed or blocked | mecánica | firewall-positive.sh; EV-011 | regex gap; bypass novel; ambiguous JSON | Alta | Bajo |
| P-BS | BLOCKER-SECRET | hook | denies secret access | stdin JSON tool call | exit 0/2 | tool-invocation | valid JSON | secret op blocked | mecánica | secret-guard-positive.sh; EV-011 | novel path; symlink | Alta | Bajo |
| P-GT | GATE-BEFORE-TASK-CLOSURE | hook | gates SubagentStop | stdin JSON completion | exit 0/2 + emit | task-close | task_id + contract_hash + artifact_hash present | task closed or open | mecánica | task-completed-coupling.sh; EV-012/015 | forged hashes; hash omission (F8-A fixed) | Alta | Bajo |
| P-LE | LIB-EVENT-EMISSION | lib | emit JSONL to stream | invocation args | append to EVENT-STREAM | stream write | file writable | stream has new row | interno | file inspection | dead schema fields (K3-D1); truncated writes | Alta | Bajo (rewrite) |
| P-CSA | CONTEXT-SESSION-START-A | hook | inject compact context | session-start signal | stdout inject | session-start | STATE-MASTER readable | context injected | observ | manual inspection | drift undetected | Alta | Bajo |
| P-CSB | CONTEXT-SESSION-START-B | hook | drift detect | session-start signal | stdout inject + warn | session-start | prior hash exists | drift reported | observ | state-integrity.sh; EV-007 | hash mismatch false positive | Alta | Bajo |
| P-CSU | CONTEXT-SUBAGENT | hook | pack per role | subagent-start | stdout inject | subagent-start | CONTEXT-PACK exists | context injected | observ | manual inspection | pack stale | Alta | Bajo |
| P-SM | STATE-MASTER | store | operational state | manual edit | authority read | STATE reads | valid Markdown | state read reliably | convención | drift detection | drift silent | Alta | Bajo |
| P-DM | DECISIONS-MASTER | store | active decisions | manual edit | authority read | DEC reads | valid Markdown | decisions readable | convención | manual inspection | untracked change | Alta | Bajo |
| P-EM | EVIDENCE-MASTER | store | evidence contracts | manual edit | authority read | EV reads | valid EV schema | evidence auditable | convención | freshness check; EV-009 | append-only violation (convention) | Alta | Bajo |
| P-ES | EVENT-STREAM | store | write-only event log | hook appends | manual/CI read | stream reads | file writable | events readable | interno | manual reads; K3-D-CAP3 | growing without triage; schema-partial | Alta | Bajo |
| P-SL | SESSION-STREAM | store | session narrative | hook writes | manual read | log reads | file writable | session traced | interno | daily rotation; EV-013 | rotation failure | Alta | Bajo |
| P-RB | RUNBOOK-SUITE | script | ex-post verify | manual/CI trigger | PASS/FAIL | verification | env baseline | 12/12 check | observ | maintenance.sh 12/12 | check drift | Alta | Bajo |
| P-CP | CONTEXT-PACK | store | role packs | manual edit | hook read | pack reads | valid Markdown | pack readable | convención | manual inspection | pack stale (F9 G-A1) | Alta | Bajo |
| P-PT | POLICY-TEXTS | store | rules-md | manual edit | reviewer read | rules reads | valid Markdown | rules readable | convención | placeholder audit | placeholders (no-go.md 1/4) | Alta | Bajo |
| P-PY | POLICY-PROTO-YAML | store | PAC YAML (research) | manual edit | compile_policies.sh | compile | valid YAML | YAML readable | convención | ccp_policies.yaml (24 IDs) | none in runtime (research) | Alta | N/A (research) |
| P-PC | POLICY-COMPILER-PROTO | script | PAC compiler (research) | YAML | regex | compile pipeline | YAML valid | regex generated | convención | compile_policies.sh | PAC-EF-02 FP class | Alta | N/A |
| P-IP | INDEX-PLAN | store | Master Plan | manual edit | reviewer read | plan reads | valid Markdown | plan readable | convención | referenced from CLAUDE.md | drift from state | Alta | Bajo |
| P-IM | INDEX-MANIFEST | store | Artifact Manifest | manual edit | reviewer read | manifest reads | valid Markdown | manifest readable | convención | phase closure | drift from state | Alta | Bajo |
| P-H  | HUMANO-REVIEWER | actor | last-mile arbiter | commit review | ACK/REJECT | commit | availability | commit reviewed | humana | HRQS §12 | omission; skill drift (FS-6) | N/A | N/A |
| P-O  | OWNER | actor | authorization | decision request | ACK/REJECT | phase gate | availability | phase authorized | humana | F9_OWNER_DECISIONS | over-load; delay | N/A | N/A |
| P-A  | AGENT-PRIMARY | actor | produces artifacts | user intent | tool calls, docs | tools + docs | context injected | artifact + evidence | agente | audit trail | hallucination; over-scope | N/A | N/A |
| P-SA | SUBAGENTS | actors (11) | delegated tasks | main agent dispatch | artifacts | subagent-start + task-close | context pack | task done | agente | subagent audit | ambiguous authority (K3-D-OWNER-DEFAULT) | N/A | N/A |

**Total**: ~24 piezas top-level. Piezas ausentes (`GAP` pieces): DERIVE, DELEGATION_REGISTRY,
CHANGE_TYPES_CATALOG, LIFECYCLE_REGISTRY, POLICY-CANONICAL (única), SHADOW-RUNTIME.

### 28.2 Categorías por tipo

- **Components/mechanisms**: P-BB, P-BS, P-GT, P-LE, P-CSA, P-CSB, P-CSU, P-RB.
- **Stores**: P-SM, P-DM, P-EM, P-ES, P-SL, P-CP, P-PT, P-PY, P-IP, P-IM.
- **Scripts (research)**: P-PC.
- **Actors**: P-H, P-O, P-A, P-SA.
- **Missing pieces (gaps)**: DERIVE-OP, DELEG-REG, CATALOG, LIFECYCLE-REG, POL-CANON, SHADOW-RT.

---

## 29. Piece geometry — para cada pieza importante

`WHAT IT EXPECTS / PROVIDES / REQUIRES / IS REQUIRED BY / CONSTRAINS / IS CONSTRAINED BY / ASSUMES / IS ASSUMED BY`

Muestra para las piezas dominantes (compresión: piezas con impacto en decisiones):

**P-GT (GATE-BEFORE-TASK-CLOSURE)**
- Expects: JSON payload con `task_id`, `contract_hash`, `artifact_hash`, valid schema.
- Provides: exit 0 (close) or exit 2 (block) + optional emit al stream.
- Requires: `.claude/hooks/lib/stall-record.sh` para emit; jq disponible.
- Is required by: cierre correcto de cualquier subagente contractual.
- Constrains: qué evidencia debe existir antes de cerrar tarea.
- Is constrained by: schema definido en task-completed-evidence.sh; ARCH-004 amended.
- Assumes: contract_hash es SHA-256 de EV correspondiente (post F8-A fail-closed).
- Is assumed by: EV-* entries; workflow humano commits.

**P-LE (LIB-EVENT-EMISSION)**
- Expects: args con `source_hook`, `decision`, etc.
- Provides: JSONL row al EVENT-STREAM con schema fijo.
- Requires: file writable; jq.
- Is required by: P-BB, P-GT.
- Constrains: schema del EVENT-STREAM (11 fields).
- Is constrained by: `stall-record.sh:46` hardcodea `had_alternative: null`.
- Assumes: schema no cambia sin migración.
- Is assumed by: consumers HRQS §12, análisis manual.

**P-PT (POLICY-TEXTS)**
- Expects: Markdown editable a mano.
- Provides: prosa humana con reglas normativas.
- Requires: convención de mantenimiento humano.
- Is required by: reviewer humano; workflow docs.
- Constrains: expresividad limitada a Markdown.
- Is constrained by: no derivación mecánica con firewall (GAP-1).
- Assumes: humano mantiene en sync con P-BB.
- Is assumed by: onboarding docs.

**P-ES (EVENT-STREAM)**
- Expects: append-only writes desde P-LE.
- Provides: log JSONL leíble.
- Requires: file writable; disk space.
- Is required by: consumers HRQS + manual triage.
- Constrains: schema (11 fields; 2 dead: `had_alternative`, `session_id`).
- Is constrained by: no controlador que consume; write-only.
- Assumes: consumers son humanos/CI.
- Is assumed by: no consumers activos runtime.

(Muestra suficiente para razonar; catálogo completo en Anexo B.)

---

## 30. Piece ports — muestreo para piezas críticas

**P-GT ports**:
- Input ports: `task_id`, `contract_hash`, `artifact_hash`, `status`.
- Output ports: exit code, stall emit (optional).
- Authority ports: nada (autoridad mecánica delimitada).
- Evidence ports: consume EV-* via contract_hash lookup.
- Failure ports: exit 2 + emit → EVENT-STREAM.
- State ports: read STATE-MASTER (indirectamente vía context).
- Context ports: subagent context via CONTEXT-SUBAGENT.
- Temporal ports: en cada SubagentStop; síncrono.
- Provenance ports: `source_hook` en emit; timestamp.

**P-LE ports**:
- Input ports: args del caller.
- Output ports: JSONL row.
- Failure ports: JSONL row si caller falla; sin retry.
- State ports: escribe a P-ES.
- Temporal ports: síncrono con caller.
- Provenance ports: `source_hook` propagado.

**P-PT ports**:
- Input ports: humano editor.
- Output ports: prosa legible.
- Authority ports: quien edita cambia policy (sin gate).
- Evidence ports: referenciado en HRQS y reviews.
- Failure ports: placeholders (no-go.md); no detección automática.
- Temporal ports: N/A.
- Provenance ports: git blame.

**P-O (OWNER) ports**:
- Input ports: decision requests (READY-*, DEC-*).
- Output ports: ACK/REJECT/DEFER + rationale.
- Authority ports: **última autoridad**; todos los defaults default aquí (K3-D-OWNER-DEFAULT).
- Evidence ports: consume EV + DECISION_REGISTRY.
- Temporal ports: asíncrono; latency variable.
- Provenance ports: F9_OWNER_DECISIONS documenta cierres.

---

## 31. Cada decisión como pieza móvil

Para cada DEC y opción, se identifica **qué pieza se mueve y a qué categoría de
movimiento pertenece**.

Notación de operador:
`MOVE / REPLACE / REMOVE / INSERT / SPLIT / MERGE / REORDER / DELEGATE / CANONICALIZE / DERIVE /
DUPLICATE / CONSOLIDATE / TRANSFORM / ISOLATE / VERSION / FREEZE / DEFER / EXPERIMENT`

### 31.1 DEC-01 A2 — INSERT

- Pieza movida: **INSERT** nueva pieza `CATALOG` (P-CAT).
- Vecinos afectados: P-H, P-O (consultan catálogo); P-DM (referencia); reviewer workflow.
- Interfaces afectadas: **ninguna técnica**; workflow humano cambia (consulta al catálogo).
- Piezas desplazadas: convención implícita → convención declarativa.
- Piezas obsoletas: K3-D-OWNER-DEFAULT (parcialmente; no una pieza, sino un patrón).
- Piezas nuevas: `P-CAT`.
- Invariantes: preserva INV-1..INV-8.
- Pérdida/ganancia info: gana declaración explícita; no pierde nada.

### 31.2 DEC-02 B2 — INSERT

- Pieza movida: **INSERT** nueva pieza `DELEG-REG` (P-DR).
- Vecinos afectados: P-O (define delegaciones); P-H (consulta); P-SA (opera bajo).
- Interfaces: ninguna técnica.
- Piezas desplazadas: K3-D-OWNER-DEFAULT (elimina defaults implícitos).
- Piezas nuevas: `P-DR`.
- Invariantes: preserva; hace explícito INV-4 (Owner auth) y INV-8 (Human reviewer).
- Ganancia info: cada delegación auditable.

### 31.3 DEC-03 C2 — TRANSFORM (front-matter)

- Pieza movida: **TRANSFORM** P-PT y `docs/research/*` (schema con front-matter).
- Vecinos: P-CSU (context pack derivado de research puede filtrar por status).
- Interfaces: ninguna técnica cambiante.
- Piezas obsoletas: ninguna.
- Piezas nuevas: convención + runbook check.
- Ganancia info: lifecycle observable.

### 31.4 DEC-04 D4 — CANONICALIZE + INSERT

- Piezas movidas: **CANONICALIZE** POLICY-TEXTS + firewall bajo `POLICY-CANONICAL` (YAML);
  **INSERT** nueva pieza `POLICY-CANONICAL` (P-PC-CAN), **INSERT** `POLICY-DERIVER-MOTOR`
  (P-MTR).
- Vecinos: P-BB (recibe firewall generado), P-PT (dep obsoleto o deriva), P-PY (promovido
  a runtime), P-PC (promovido a runtime).
- Interfaces:
  - `POLICY-CANONICAL → MOTOR → firewall generado` (nueva interfaz internal).
  - `P-BB` sigue leyendo firewall (mismo interface), pero éste es ahora artefacto derivado.
- Piezas desplazadas: P-PT deprecado o mantenido como doc mirror.
- Piezas obsoletas: sync manual entre PT y BB.
- Piezas nuevas: P-PC-CAN, P-MTR, FP-classification framework.
- Invariantes: preserva INV-1 (evidence gate), INV-2 (fail-closed); crea nuevo invariante
  (motor is idempotent).
- Pérdida info: comentarios humanos si no se preservan explícitamente en YAML.

### 31.5 DEC-04 D1 — CANONICALIZE + INSERT

- Igual a D4 pero canónica = `.md` (rules estructurada).
- Motor requiere parser Markdown restringido.
- Menor gain en escalabilidad; menor lock-in tecnológico; mayor legibilidad humana.

### 31.6 DEC-04 D2 — REMOVE + CONSOLIDATE

- Pieza movida: **REMOVE** P-PT; **CONSOLIDATE** hacia P-BB como única fuente.
- Vecinos: P-H pierde doc humana → mayor carga cognitiva.
- Piezas obsoletas: P-PT (borrada).
- Invariantes: preserva técnicos; **degrada** INV-8 (human reviewer sin doc estructurada).
- Pérdida info: máxima (memoria humana).

### 31.7 DEC-04 D3 — TRANSFORM (tests-as-contract)

- Pieza movida: **TRANSFORM** P-PT + P-BB en test suite.
- Piezas nuevas: test runner en hooks.
- Interfaces: `pre-tool → test suite → block/allow` (latency + framework).
- Piezas obsoletas: firewall regex explícito (subsumido en tests).

### 31.8 DEC-04 D5 — DEFER

- No move. Statu quo. Consecuencia: piezas GAP mantienen su ausencia.

### 31.9 DEC-05 E2 — INSERT

- Pieza: **INSERT** `P-MTR` (motor unidireccional).
- Precondition: DEC-04 ≠ D5 (elige canónica).
- Interfaces: `canónica → MOTOR → derivados`.

### 31.10 DEC-07 F2 — DELEGATE

- Pieza movida: **DELEGATE** CAP-2s post-tool a P-SA[code-reviewer] (invocado obligatoriamente).
- Vecinos: P-H (menor carga sintáctica); P-A (recibe verdict pre-review).
- Interfaces nuevas: `subagentStop → code-reviewer verdict → gate`.
- Piezas nuevas: verdict logging + optional dual-LLM.
- Piezas obsoletas: ninguna (F2 complementa, no reemplaza a P-H).
- Pérdida info: fracción de contexto humano en review.

### 31.11 DEC-08 G2 — TRANSFORM (schema)

- Pieza movida: **TRANSFORM** P-LE schema (`had_alternative`, `session_id`, `verdict`).
- Vecinos: P-BB, P-GT (callers deben propagar valores reales).
- Interfaces: schema extendido; backwards-compat con default null.
- Piezas nuevas: en STALL log el campo `verdict:` requiere clasificación (HRQS o similar).
- Ganancia info: 3 UNKNOWNs pasan de bloqueados a observables.
- Requiere F9-D01 revisit.

### 31.12 DEC-08 G3 — INSERT (shadow)

- Pieza movida: **INSERT** `P-SHADOW-RT` (paralelo).
- Vecinos: P-A (opera en ambos), P-H (revisa outputs comparados).
- Interfaces: shadow runtime → observation store.
- Piezas nuevas: shadow completo.
- Sin F9-D01 cross.

### 31.13 DEC-11 H2 — INSERT (policy)

- Pieza movida: **INSERT** `P-DEFER-POL` (política declarativa).
- Vecinos: cada deferimiento existente (F9-D02, A-05, A-07, G-N5) requiere ganar `trigger:`.
- Piezas obsoletas: "hasta trigger concreto" sin criterio (patrón).
- Ganancia info: cada deferral con condición observable.

### 31.14 DEC-12 I4 — INSERT (cap) + TRANSFORM (supersedes)

- Piezas: **INSERT** política de cap + `archive/` dir; **TRANSFORM** convención de handoffs
  con `supersedes:`.
- Vecinos: `docs/00_SYSTEM/*` (archived); reviewers (menos overhead).

---

## 32. Local Fit test (por opción dominante)

Verifica encaje con vecinos inmediatos.

| DEC-Op | Interface | Dependency | Data | Authority | State | Context | Evidence | Lifecycle | Enforcement | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| 01-A2 | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT (docmatic) | FIT |
| 02-B2 | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT (registry-only) | FIT |
| 03-C2 | FIT | FIT | FIT | FIT | FIT | FIT | FIT | **CREATES** | FIT (convention) | FIT WITH CONDITION (runbook) |
| 04-D4 | PARTIAL | PARTIAL | FIT | FIT | FIT | FIT | FIT | FIT | **CHANGES** | PARTIAL FIT (motor is new TCB) |
| 04-D1 | FIT | PARTIAL | FIT | FIT | FIT | FIT | FIT | FIT | **CHANGES** | PARTIAL FIT (parser is new TCB) |
| 04-D2 | FIT | FIT | **LOSS** | FIT | FIT | **LOSS** | FIT | FIT | FIT | NO FIT (info loss) |
| 04-D3 | PARTIAL | PARTIAL | FIT | FIT | FIT | FIT | FIT | FIT | **CHANGES** | NO FIT (latency + paradigm) |
| 05-E2 | PARTIAL | REQUIRES DEC-04 | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT WITH CONDITION (DEC-04) |
| 07-F2 | PARTIAL | REQUIRES DEC-02 | FIT | **CHANGES** | FIT | FIT | FIT | FIT | FIT | FIT WITH CONDITION (DEC-02 + U-09) |
| 08-G2 | FIT | REQUIRES DEC-11 | **EXTENDS** | FIT | FIT | FIT | FIT | FIT | FIT | FIT WITH CONDITION (F9-D01 revisit) |
| 08-G3 | FIT | FIT | FIT | FIT | FIT | FIT | FIT | **CREATES** | FIT | FIT (costly) |
| 11-H2 | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT |
| 12-I4 | FIT | REQUIRES DEC-03 | FIT | FIT | FIT | FIT | FIT | FIT | FIT | FIT WITH CONDITION (DEC-03) |

Notas: los `NO FIT` en 04-D2 y 04-D3 son estructurales (información / paradigma), no
tácticos.

---

## 33. Global Fit test

Piezas lejanas afectadas por cada movimiento:

- **04-D4**: afecta pipeline CI (nuevo build step), affecta training/onboarding, afecta HRQS
  (parcialmente absorbido), afecta futuras policies (formato). Cadenas: 6+ pasos.
- **04-D2**: afecta onboarding severo, HRQS, workflow humano completo.
- **07-F2**: afecta LLM provider budget, latency SLA, reviewer skill (potencial atrofia).
- **08-G2**: cadena crítica → precedente F9-D01 revisit → si no hay política previa,
  cambia gobernanza para futuros revisits.
- **02-B2**: casi todo lo humano se beneficia (governance clarity); zero regresión técnica.

**Regla**: local FIT no implica global FIT. `04-D4` y `07-F2` deben pasar global antes de
aceptarse.

---

## 34. Non-local effect detector (cadenas causales)

Ejemplo de cadena para DEC-04 D4:

```text
DEC-04 D4
  ↓ cambia autoridad de policy
  ↓ afecta DEC-05 (motor obligatorio)
  ↓ cambia derivación (INSERT MOTOR)
  ↓ afecta enforcement (BB pasa a leer artefacto derivado)
  ↓ afecta testing (test de motor + test no-drift)
  ↓ afecta evidence (motor produce provenance mecánica)
  ↓ afecta auditability (HRQS parcialmente absorbido)
  ↓ afecta future migration (formato YAML es TCB permanente)
```

Ejemplo para DEC-08 G2:

```text
DEC-08 G2
  ↓ cambia schema P-LE
  ↓ afecta callers P-BB, P-GT (propagar valores)
  ↓ afecta EVENT-STREAM (nuevos campos)
  ↓ afecta HRQS (clasificación estructurada)
  ↓ afecta U-01/U-02 (observables)
  ↓ afecta READY-03 (empírica factible)
  ↓ afecta F9-D01 (revisit precedente)
  ↓ afecta DEC-11 (formalización política)
```

---

## 35. Gap creation test

Cada movimiento cierra un gap y puede crear otro:

| DEC-Op | Gap closed | Gap created | Residual |
|---|---|---|---|
| 01-A2 | K3-D-OWNER-DEFAULT (parcial) | mantenimiento catálogo | disciplina requerida |
| 02-B2 | K3-D-OWNER-DEFAULT | mantenimiento registry | disciplina requerida |
| 03-C2 | K3-D-LIFECYCLE | consistency between front-matter and reality | runbook responsable |
| 04-D4 | GAP-1 | motor as new TCB; FP class management | nuevos FP classes esperados |
| 04-D2 | GAP-1 (por deletion) | pérdida doc humana; onboarding harder | doc humana en otro lado |
| 05-E2 | drift silent | idempotencia motor | test de motor |
| 07-F2 | subescala CAP-2s | provider dependence; correlated failure risk | LLM budget, U-09 |
| 08-G2 | K3-D-SCHEMA | precedente F9-D01 revisit | política DEC-11 required |
| 08-G3 | K3-D-SCHEMA (parcial) | shadow representativeness | ongoing cost |
| 11-H2 | governance decay | disciplina revisión trimestral | H3 opcional para runbook |
| 12-I4 | meta-doc growth silent | disciplina de archivar | runbook para verificar |

---

## 36. Interface break test

Verificación de que interfaces no se rompen al mover una pieza:

- **04-D4**: firewall interface (`.claude/hooks/bash-firewall.sh`) sigue leyendo el archivo
  final; consumidores intactos. **Interface preservada**. Nueva interfaz interna
  `canónica → motor → firewall` es aditiva.
- **04-D2**: reviewer humano workflow espera `.md` como referencia; se elimina. **Interface
  rota** para el reviewer. Requiere adaptador (comentarios inline verbosos) o cambio de
  workflow.
- **08-G2**: schema de EVENT-STREAM extendido. Consumers (HRQS) deben aceptar nuevos
  campos. Backward-compat con default null preserva. **Interface extended**, no rota.
- **07-F2**: nueva interfaz `subagentStop → code-reviewer → verdict`. Piezas vecinas (P-GT)
  deben esperar el verdict antes de gate. **Interface added**; preserva anteriores.

Semantic drift detectable:

- **04-D4/D1** riesgo si motor tiene bug → firewall generado diverge de canónica.
  Mitigación: test de idempotencia + test de no-drift.
- **07-F2** riesgo si LLM verdict deriva de un modelo distinto al usado antes.
  Mitigación: log model version en evidence.

---

## 37. Invariant conservation

Invariantes reales K3-audited [K3 audit §19]:

**4 técnicos** (system): INV-1 evidence-gated completion, INV-2 fail-closed, INV-3 PROJECT_STATE
authority (parcial), INV-7 maintenance 12/12.

**4 policy** (human convention): INV-4 Owner auth for P0 changes, INV-5 F7/F8 frozen,
INV-6 evidence append-only, INV-8 Human reviewer as trust boundary.

Por opción dominante:

| DEC-Op | INV-1 | INV-2 | INV-3 | INV-4 | INV-5 | INV-6 | INV-7 | INV-8 |
|---|---|---|---|---|---|---|---|---|
| 01-A2 | preserve | preserve | preserve | strengthen | preserve | preserve | preserve | preserve |
| 02-B2 | preserve | preserve | preserve | strengthen | preserve | preserve | preserve | strengthen |
| 03-C2 | preserve | preserve | preserve | preserve | preserve | preserve | preserve | preserve |
| 04-D4 | preserve | preserve | preserve | preserve | preserve | preserve | **extend** | preserve (motor as TCB) |
| 04-D2 | preserve | preserve | preserve | preserve | preserve | preserve | preserve | **weaken** (doc loss) |
| 05-E2 | preserve | preserve | preserve | preserve | preserve | preserve | **extend** | preserve |
| 07-F2 | preserve | preserve | preserve | preserve | preserve | preserve | preserve | **weaken** (partial delegation) |
| 08-G2 | preserve | preserve | preserve | preserve | preserve | preserve | preserve | preserve |
| 11-H2 | preserve | preserve | preserve | preserve | preserve | preserve | preserve | preserve |
| 12-I4 | preserve | preserve | preserve | preserve | preserve | preserve | preserve | preserve |

**Weakens** requieren compensación:
- 04-D2: doc humana en `docs/00_SYSTEM/POLICY_NOTES.md` como compensación.
- 07-F2: reviewer humano audita LLM verdicts en muestra; skill preservation via HRQS.

---

## 38. Conservación / Information loss

Por opción:

| DEC-Op | Info in | Info out | Info deja de existir | Info derivada | Info implícita | Info deja de ser trazable |
|---|---|---|---|---|---|---|
| 01-A2 | tipos observados históricamente | catálogo declarativo | nada | nada | menos zonas grises | nada |
| 02-B2 | delegaciones implícitas | registry | nada | nada | menos ambigüedad | nada |
| 03-C2 | archivos sin status | archivos con status | nada | status derivable ex-post | menos "es actual?" | nada |
| 04-D4 | .md placeholders + regex manual | YAML + generado | comentarios humanos si no se preservan | firewall, tests | intent | link entre policy y comentario si no preservado |
| 04-D2 | .md + regex | regex + inline comments | **doc humana estructurada** | nada | intent humano | doc humana |
| 05-E2 | sync manual | sync mecánica | drift potencial | derivados | proceso implícito | nada |
| 07-F2 | reviewer humano | LLM + humano | fracción de contexto humano en review | verdict LLM | menor supervisión humana | proceso semántico humano |
| 08-G2 | eventos con `had_alternative=null` | eventos con valores reales | nada | classification | menos ambigüedad | nada |
| 11-H2 | deferrals sin trigger | deferrals con trigger | criterio "hasta trigger concreto" implícito | condición observable | nada | nada |

**Losses críticos**: 04-D2 (doc humana) y 07-F2 (contexto reviewer). Requieren compensación
explícita si se adoptan.

---

## 39. Bidirectional traceability

Para cada opción, verificar que ambos sentidos son transitables:

- **04-D4**: `POLICY YAML id → motor build → regex → hook block → EVENT-STREAM → HRQS →
  reviewer humano`. Sentido inverso: `EVENT-STREAM row → source_hook → regex line → policy
  id → YAML entry → intent`. **Traceable ambos sentidos** si el emit incluye `policy_id`
  (READY-04 lo permite en formato Enhanced-B).
- **07-F2**: `subagentStop → LLM verdict → gate decision`. Sentido inverso: `gate log →
  LLM verdict + model version → context`. **Traceable ambos sentidos** si evidence contract
  incluye `verifier: {type: llm, model, version}`.
- **08-G2**: `event → source_hook + had_alternative + session_id → task_id → subagent →
  session → commit`. Sentido inverso: `commit → task_id → events → had_alternative
  values`. **Fully traceable**.

Puntos de ruptura si movimientos parciales:
- Si 04-D4 sin `policy_id` en emit: rompe reverse trace.
- Si 07-F2 sin log de model version: rompe reverse trace.
- Si 08-G2 sin `session_id` propagado en callers: rompe reverse trace parcial.

---

## 40. Assembly consistency check (BEFORE / MOVE / AFTER)

Ejemplo detallado para DEC-04 D4 + DEC-05 E2:

**BEFORE ASSEMBLY**
```text
POLICY LAYER = {P-PT (Markdown, 4 files, 1/4 placeholders), P-BB (regex + comments)}
Manual sync between them.
```

**MOVED PIECE**: INSERT `P-PC-CAN` (YAML canonical) + `P-MTR` (motor unidireccional).
Deprecate P-PT (or transform to derived doc).

**AFTER ASSEMBLY**
```text
POLICY LAYER = {
  P-PC-CAN (YAML canonical, single source),
  P-MTR (build-time: reads P-PC-CAN → writes P-BB.regex + optional P-PT derived .md),
  P-BB (regex, now derived artifact),
  P-PT (optional, derived doc only)
}
INTERFACE change: build pipeline runs P-MTR before commit.
Test of motor idempotence + no-drift becomes new CI check.
```

**BROKEN CONNECTIONS**:
- Reviewer humano workflow espera editar `.md` → ahora edita YAML (retraining).
- Any tool that reads `.claude/rules/*.md` como fuente autoritativa → now reads YAML.

**NEW CONNECTIONS**:
- YAML → motor → firewall (nueva interfaz interna).
- CI check "motor idempotent" (nueva verificación).
- FP classification framework (metadata `known_fp_classes:` en YAML).

**COMPENSATING PIECES**:
- Reviewer training: docs de "cómo leer YAML canónico" (una vez).
- HRQS §12 checklist reformulada para trabajar con `policy_id` de YAML.

**REMOVED PIECES**:
- Sync manual entre P-PT y P-BB.
- Duplicación regex ↔ prosa.

**ORPHAN PIECES**:
- P-PT si se elimina (o queda como derived doc si D4-B variant).

**DUPLICATE PIECES**:
- Si D4-A mantiene P-PT como derived: ahora es duplicado controlado (no manual sync;
  motor mantiene coherencia).

---

## 41. Piece redundancy test

Después de cada movimiento, ¿hay piezas que hacen lo mismo?

- **04-D4 con D4-A (mantener .md derivado)**: P-PT y P-PC-CAN parcialmente redundantes;
  aceptable si P-PT es explícitamente derivado y no editable.
- **04-D4 con D4-B (deprecate .md)**: sin redundancia, mayor pureza; menor ergonomía.
- **07-F2 con dual-LLM (F3)**: dos verifiers pueden compartir sesgo; parcialmente redundantes
  para U-05, no para U-09.
- **08-G3 con G2 después**: shadow y schema completo se vuelven redundantes; retirar shadow.

**Regla**: si una decisión añade duplicación, marcarla como debt temporal con condición
de eliminación.

---

## 42. Piece obsolescence test

Post-cada-decisión, ¿qué piezas ya no tienen propósito?

| DEC-Op | Piezas obsoletas |
|---|---|
| 01-A2 | improvisación reviewer para tipos de cambio |
| 02-B2 | K3-D-OWNER-DEFAULT como patrón operativo |
| 03-C2 | archivos sin status ambiguo |
| 04-D4 | sync manual policy/enforcement; parte de HRQS §12 |
| 04-D2 | P-PT |
| 05-E2 | manual sync (redundante con motor) |
| 07-F2 | fracción manual de review sintáctico humano |
| 08-G2 | HRQS §12 basado en "sin verdict field" |
| 11-H2 | "hasta trigger concreto" como forma de deferral |
| 12-I4 | acumulación silenciosa de meta-doc |

**Dead architecture risk**: si adoptamos 04-D4 pero mantenemos P-PT sin marcar como
derivado, éste se convierte en dead architecture. Debe **eliminarse** o **explícitamente
derivarse**.

---

## 43. Puzzle mutation test (combinaciones no obvias)

- **04-D5 + 08-G2 + 11-H2**: no cerrar GAP-1 pero instrumentar para datos → puede mostrar
  que GAP-1 no genera FPs mayores en producción → D5 se refuerza empíricamente.
- **04-D1 + 07-F2**: motor + reviewer LLM sobre .md canónica → reviewer LLM puede validar
  policies escritas antes del compile.
- **02-B2 + 04-D5**: delegar sin cerrar GAP-1 → hace visible que aún sin motor, hay
  progresos en governance.
- **08-G3 shadow + 04-D4**: shadow que corre motor + comparar salidas → validation robusta
  antes de cutover a runtime.
- **Delay DEC-04 + Experiment DEC-04**: hacer path F (DEC-11 + Bloque A + DEC-08 G3) y
  correr experimento PAC en shadow durante 3 meses; **decidir DEC-04 con datos**.

---

## 44. Decision neighbor test

Para cada DEC importante:

- **DEC-04** — upstream: DEC-05 (motor), DEC-11 (política de FP class handling).
  Downstream: DEC-06, DEC-07 (metadata consumption). Adjacent: DEC-08 (data para validar).
  Latent: DEC-02 (delegación afecta quién edita canónica).
- **DEC-08** — upstream: DEC-11 (formalizar F9-D01 revisit). Downstream: DEC-09 (READY-03),
  U-01/U-02 observables. Adjacent: DEC-11 (política). Latent: DEC-07 (más datos → mejor
  verifier).
- **DEC-02** — upstream: DEC-01 (categorías). Downstream: DEC-07 (delegación explícita
  requerida). Latent: DEC-11 (delegar la revisión de deferrals).

---

## 45. Piece displacement test

Movimiento cascada al mover DEC-X:

| DEC | Piezas que deben moverse con |
|---|---|
| 01-A2 | ninguna (INSERT aislado) |
| 02-B2 | requiere DEC-01 (categorías) |
| 04-D4 | requiere DEC-05 E2; cascada: HRQS reformulada, CI + build, reviewer training |
| 04-D2 | requiere retraining reviewer; puede requerir DEC-03 (registro doc alterno) |
| 07-F2 | requiere DEC-02; cascada: LLM budget, logging model version, HRQS ajustada |
| 08-G2 | requiere DEC-11; cascada: revisit F9-D01, callers actualizados, HRQS con verdict |

`REQUIRED MOVEMENT`: DEC-05 con DEC-04 ≠ D5; DEC-11 con DEC-08 G2.
`OPTIONAL MOVEMENT`: DEC-01 sin DEC-02 es útil aunque incompleto.
`CASCADE MOVEMENT`: DEC-04 D4 arrastra 5+ piezas técnicas + workflow humano.

---

## 46. Architectural coupling map

```text
DEC-04 (canónica)
 ├── DEC-05 (motor)
 ├── DEC-06 (READY-01/02 derivadas)
 ├── DEC-07 (metadata consumption; loose coupling)
 └── evidence (motor produce provenance nueva)
     └── HRQS reformulada

DEC-08 (schema)
 ├── DEC-09 (READY-03 empírica)
 ├── DEC-11 (política revisit)
 ├── F9-D01 (revisit gate)
 └── future decisions blocked/unblocked

DEC-02 (delegación)
 ├── DEC-07 (verifier delegado)
 ├── DEC-11 (delegar revisión deferrals)
 └── K3-D-OWNER-DEFAULT muerto

DEC-11 (deferral policy)
 ├── DEC-08 (formaliza revisit)
 ├── DEC-13 (formaliza external trigger)
 └── governance decay stopped
```

Acoplamientos reales (no sólo documentales):
- **DEC-04 → DEC-05**: física (motor lee canónica).
- **DEC-08 → DEC-11**: gobernanza (revisit sin política = precedente ad-hoc).
- **DEC-01 → DEC-02**: semántica (registry necesita categorías).

---

## 47. Cascading change analysis

Para cada opción principal:

- **04-D4**: DIRECT 5 piezas + build; INDIRECT 4 workflows; TRANSITIVE HRQS, docs de
  onboarding, DECISIÓN-06; FUTURE cambia todas las futuras policies.
- **07-F2**: DIRECT LLM budget + code-reviewer; INDIRECT HRQS (menor scope humano);
  TRANSITIVE reviewer skill; FUTURE viabilidad de reducir humano en subagentStop.
- **08-G2**: DIRECT schema P-LE + 2 callers; INDIRECT EVENT-STREAM consumers; TRANSITIVE
  F9-D01 precedente; FUTURE cada nuevo revisit gana template.
- **11-H2**: DIRECT `docs/00_SYSTEM/DEFERRAL_POLICY.md` + cada deferimiento; INDIRECT
  reviewer trimestral; TRANSITIVE reduce coste epistemológico; FUTURE decision revisits
  formalizadas.

---

## 48. Fit score, cost of reassembly, min movement

| DEC-Op | Local FIT % | Global FIT % | Interface FIT % | Invariant preservation % | Evidence FIT % | Evolution FIT % | Overall %  | Reassembly cost |
|---|---|---|---|---|---|---|---|---|
| 01-A2 | 95 | 90 | 100 | 100 | 100 | 60 | 91 | LOCAL |
| 02-B2 | 90 | 90 | 100 | 100 | 100 | 75 | 93 | LOCAL |
| 03-C2 | 85 | 85 | 100 | 100 | 100 | 65 | 89 | LOCAL |
| 04-D4 | 70 | 65 | 90 | 90 | 85 | 90 | 82 | LARGE |
| 04-D1 | 75 | 70 | 90 | 90 | 85 | 65 | 79 | MODERATE |
| 04-D2 | 40 | 45 | 60 | 75 | 90 | 70 | 63 | LARGE (info loss) |
| 04-D3 | 50 | 55 | 70 | 85 | 90 | 75 | 71 | ARCHITECTURAL |
| 04-D5 | 100 | 100 | 100 | 100 | 100 | 30 | 88 | NONE |
| 05-E2 | 75 | 75 | 85 | 95 | 95 | 85 | 85 | MODERATE |
| 07-F2 | 60 | 55 | 80 | 80 | 85 | 80 | 73 | MODERATE |
| 08-G2 | 55 | 65 | 85 | 100 | 100 | 80 | 81 | SMALL (with DEC-11) |
| 08-G3 | 80 | 75 | 100 | 100 | 90 | 60 | 84 | MODERATE (ongoing) |
| 11-H2 | 100 | 100 | 100 | 100 | 100 | 85 | 98 | LOCAL |
| 12-I4 | 90 | 90 | 100 | 100 | 100 | 65 | 91 | LOCAL |

Min-movement candidates (bajo cost, alto benefit): **11-H2**, **01-A2**, **02-B2**,
**12-I4**, **08-G3**.

---

## 49. Reversible puzzle test

Antes de decisiones irreversibles (04):

- **Podemos mover pieza temporalmente?** Sí: `04-D4 con motor en shadow` → deploy en CI
  sin cutover; ver output; deshacer si drift.
- **Podemos construir adapter?** Sí: mantener P-PT como derived doc mientras se testa D4.
- **Podemos shadow execute?** Sí: motor en shadow paralelo; comparar salidas.
- **Podemos parallel execute?** Sí: build genera firewall pero P-BB sigue leyendo el manual
  hasta cutover.
- **Podemos generar evidencia antes del commitment?** Sí: 20+ policies YAML + FP rate
  medido antes del cutover.
- **Podemos diseñar rollback limpio?** Sí: git revert; conservar snapshot pre-cutover.

**Best first move**: shadow motor + generación de datos, **no** cutover directo.

---

## 50. Architectural adapter test

Adapters posibles:

- **04-D4 con adapter**: motor produce tanto firewall como .md derivado; humanos siguen
  leyendo .md (misma ergonomía). Deuda temporal: motor Markdown-writer.
- **07-F2 con adapter**: reviewer LLM produce verdict "advisory" que humano ve; humano
  gate final. Migración progresiva.
- **08-G2 con adapter**: schema nuevo con backward-compat via `null` default. Los
  consumers antiguos siguen funcionando.

**Deuda temporal riesgo**: adapters se vuelven permanentes si no hay política de retiro.
DEC-11 H2 puede incluir "adapters have expiration trigger".

---

## 51. Assembly state tables (BEFORE / AFTER por decisión)

Muestra representativa para DEC-04 D4 (la más compleja):

```text
BEFORE STATE
──────────────────────────────────────────────
Piece         | Position         | Neighbors            | Interface    | Invariants           | Evidence
P-PT          | policy dir       | reviewer, BB         | manual sync  | INV-6, INV-8         | manual placeholder audit
P-BB          | hooks dir        | tool call, LE, PT    | pre-tool     | INV-2                | firewall-positive.sh
(GAP: DERIVE) | absent           | -                    | -            | -                    | -

AFTER STATE
──────────────────────────────────────────────
Piece         | Position         | Neighbors            | Interface    | Invariants           | Evidence
P-PC-CAN      | policy dir       | reviewer, motor      | edit YAML    | INV-6, INV-8, new: motor idempotent | build log
P-MTR         | build dir        | PC-CAN, BB, PT       | build-time   | INV-motor            | motor tests
P-BB          | hooks dir        | tool call, LE, MTR   | pre-tool     | INV-2                | firewall-positive.sh (unchanged)
P-PT (derived)| policy dir       | reviewer             | read-only    | -                    | derived from PC-CAN
```

Diferencia explícita:
- P-PT es promovido a derivado (o eliminado).
- P-PC-CAN inserted como canónica.
- P-MTR inserted en build.
- Invariante nuevo: motor idempotente + no-drift.

---

## 52. Decision → puzzle delta (formato uniforme)

Para cada DEC, delta del rompecabezas:

**DEC-04 D4 delta**:
```text
ADDED:            P-PC-CAN, P-MTR, FP-classification framework, CI build check
REMOVED:          Manual sync mechanism (patrón)
MOVED:            P-BB is now derived artifact (posición conceptual cambia)
MERGED:           HRQS §12 parcial en YAML metadata
SPLIT:            None
REPURPOSED:       P-PT → derived doc (or removed)
INTERFACES CHG:   Build now includes motor step; hooks read derived output
INVARIANTS CHG:   Add "motor idempotent + no-drift"
EVIDENCE CHG:     Evidence chain adds provenance de generación
AUTHORITY CHG:    Whoever edits YAML defines policy
DEPENDENCIES CHG: DEC-05, HRQS reformulada
NEW RISKS:        FP class discovery; motor bug; YAML complexity
REGRESSIONS:      MAINTAINABILITY MIX (motor added; sync removed)
NEW CAPABILITIES: DERIVE operation activated; metadata queries; scale to PT-2
```

**DEC-08 G2 delta**:
```text
ADDED:            schema fields (verdict, real values had_alt/session_id); F9-D01 revisit
REMOVED:          "hardcoded null" patrón
MOVED:            None
MERGED:           None
SPLIT:            None
REPURPOSED:       HRQS §12 → structured classification
INTERFACES CHG:   Callers propagate real values
INVARIANTS CHG:   None
EVIDENCE CHG:     STALL rows tienen datos utilizables
AUTHORITY CHG:    None
DEPENDENCIES CHG: DEC-11 upstream
NEW RISKS:        Precedente F9-D01 revisit (mitigated by DEC-11)
REGRESSIONS:      None
NEW CAPABILITIES: Observabilidad de H-01, U-01, U-02
```

(Formato similar aplicable a todas; presentado detallado sólo para las dos con mayor
impacto.)

---

## 53. Whole-system fit — checklist por opción

| Question | 01-A2 | 02-B2 | 04-D4 | 04-D5 | 07-F2 | 08-G2 | 11-H2 |
|---|---|---|---|---|---|---|---|
| ¿Encaja localmente? | Sí | Sí | Parcial | Sí | Parcial | Sí | Sí |
| ¿Encaja globalmente? | Sí | Sí | Parcial | Sí | Parcial | Sí | Sí |
| ¿Preserva invariantes? | Sí | Sí | Sí (extendido) | Sí | Weaken INV-8 | Sí | Sí |
| ¿Preserva trazabilidad? | Sí | Sí | Sí (con policy_id) | Sí | Sí (con model version) | Sí | Sí |
| ¿Preserva evidencia? | Sí | Sí | Sí | Sí | Sí | Sí | Sí |
| ¿Preserva reversibilidad? | Sí | Sí | Baja | Alta | Media | Alta | Alta |
| ¿Preserva autoridad correcta? | Sí | Refuerza | Sí | Sí | Weaken | Sí | Sí |
| ¿Reduce duplicación? | N/A | N/A | Sí (elimina GAP-1) | No | N/A | N/A | N/A |
| ¿Reduce complejidad? | Sí | Sí | Mix | No | Aumenta | No | Sí |
| ¿Introduce piezas necesarias? | Catálogo | Registry | Motor + YAML | No | LLM verifier | Schema fields | Policy |
| ¿Hace obsoletas piezas existentes? | Sí | Sí | Sí | No | Parcial | Parcial | Sí |
| ¿Prepara próxima decisión? | Sí (DEC-02) | Sí (DEC-07) | Sí (DEC-06) | No | Sí (S2) | Sí (READY-03) | Sí (DEC-08) |
| ¿Arquitectura resultante coherente? | Sí | Sí | Sí (post-transformación) | Sí | Parcial (con compensación) | Sí | Sí |

---

## 54. Reject if it does not fit

**Rechazos explícitos**:

- **04-D2**: NO FIT global; pérdida de doc humana rompe INV-8 sin compensación fácil.
  `REJECT` salvo si equipo declara explícitamente que documentación estructurada humana
  no es valor propio.
- **04-D3**: NO FIT por paradigma; introduce latency + framework como TCB. `REVISE` (probar
  como prototipo antes de considerar).
- **07-F2 sin DEC-02**: `ADAPTER REQUIRED` — DEC-02 debe ser upstream para no crear
  delegación implícita.
- **08-G2 sin DEC-11**: `ADAPTER REQUIRED` — DEC-11 formaliza el revisit; sin él, precedente
  ad-hoc.
- **04-D4 hoy (< 25 policies)**: `DEFER UNTIL PRECONDITION` — experimento con 20+ policies
  reales debe correrse primero.

No forzar encaje.

---

## 55. Fit vs strategic value

| DEC-Op | Structural FIT | Strategic value | Reversibility | Cuadrante |
|---|---|---|---|---|
| 01-A2 | High | Low-medium | High | HIGH FIT + MODERATE VALUE |
| 02-B2 | High | Medium-high | High | HIGH FIT + HIGH VALUE ← "sweet spot" |
| 03-C2 | High | Medium | High | HIGH FIT + MODERATE VALUE |
| 04-D4 | Moderate | High | Low | LOW FIT + HIGH VALUE (requires experiment) |
| 04-D5 | Perfect | Low | High | HIGH FIT + LOW VALUE (statu quo) |
| 05-E2 | High (post D4) | High | Medium | HIGH FIT + HIGH VALUE (conditional) |
| 07-F2 | Moderate | Medium (S1) / High (S2) | Medium | LOW FIT + HIGH VALUE (conditional on scenario) |
| 08-G2 | Moderate (needs DEC-11) | High | High | MODERATE FIT + HIGH VALUE (with prereq) |
| 08-G3 | High | Medium | High | HIGH FIT + MODERATE VALUE |
| 11-H2 | Perfect | High | High | HIGH FIT + HIGH VALUE ← "sweet spot" |
| 12-I4 | High | Medium | High | HIGH FIT + MODERATE VALUE |

**Sweet spots**: DEC-02 B2 y DEC-11 H2 dominan la superficie (alto FIT + alto valor +
reversible).

**"High value + low fit" candidates** (deben tratarse como experimentos reversibles):
DEC-04 D4, DEC-07 F2.

---

## 56. Decision as structural bet + Fit confidence

```text
DEC-04 D4 bet:
  WE ARE BETTING THAT: YAML canónica + motor unidireccional escala mejor que la duplicación
                       actual y que los FP classes serán manejables.
  BECAUSE:             K3-D-DERIVE-ONLY (única op ausente); PT-2 al horizonte; PAC prototype
                       demuestra viabilidad conceptual.
  IF TRUE:             GAP-1 cerrado; scaling S2/PT-2 OK; READY-01/02 desaparecen.
  IF FALSE:            Motor incompleto / FP rate alto → drift mecánico o falsos bloqueos.
  WHAT BREAKS:         Trust en el firewall generado.
  HOW WE DETECT:       FP en producción; PAC-EF-02-like events con nuevas classes.
  HOW WE EXIT:         Rollback motor; volver a dual manual con git checkout del snapshot.

DEC-07 F2 bet:
  WE ARE BETTING THAT: LLM adversarial verifier + humano ex-post es al menos igual a humano
                       solo, con menor carga humana.
  BECAUSE:             CAP-2s escala; humano cost sube con S2.
  IF TRUE:             PT-1 aliviado; humano hace autorización + spot-check.
  IF FALSE:            LLM correlated failure oculta bugs.
  WHAT BREAKS:         Confianza en el gate de subagentStop.
  HOW WE DETECT:       Muestras humanas de auditoría; comparaciones periódicas.
  HOW WE EXIT:         Rollback: volver a F1; humano vuelve a review completo.

DEC-08 G2 bet:
  WE ARE BETTING THAT: Instrumentar schema de STALL vale el precedente F9-D01 revisit.
  BECAUSE:             K3-D-EPIST-COST y K3-D-F9D01-BOTTLENECK.
  IF TRUE:             3 UNKNOWNs pasan a observables; READY-03 empírica; DEC-11 formaliza precedente.
  IF FALSE:            Coste bajo; rollback trivial; schema puede simplificarse.
  WHAT BREAKS:         Gate F9-D01 percibido como fluido si se hace sin DEC-11.
  HOW WE DETECT:       Nuevos revisits sin política.
  HOW WE EXIT:         Revertir schema; deshabilitar `verdict:` field.
```

**Fit confidence separada de recommendation confidence** [§18]:
- DEC-04 D4: FIT confidence 55% (motor viability), Evidence confidence 55%, Recommendation
  confidence 40%.
- DEC-11 H2: FIT confidence 100%, Evidence confidence 90%, Recommendation confidence 85%.
- DEC-08 G2 con DEC-11: FIT confidence 85%, Evidence confidence 85%, Recommendation
  confidence 55%.

---

## 56A. Global puzzle audit (integridad tras todas las decisiones)

Post una trayectoria hipotética (Path F: DEC-11 + Bloque A + DEC-08 G3):

- Piezas huérfanas: ninguna (motor no insertado; shadow reversible).
- Interfaces rotas: ninguna (todos los adapters preservan compat).
- Redundancias: shadow y productivo (temporal); política DEC-11 obliga eliminación
  post-migración.
- Autoridad duplicada: none (delegation registry único).
- Evidencia desconectada: none.
- Controles sin enforcement: DELEG_REGISTRY sin hook (B2 acepta esto explícitamente).
- Piezas sin decisión: ninguna.
- Enforcement sin policy: none.
- Policy sin autoridad: none.
- Autoridad sin evidencia: F9-D01 revisits sin DEC-11 previa (mitigado).
- Evidencia sin provenance: STALL rows pre-DEC-08 (histórico; preservado).

**Coherente**. Este path preserva integridad del rompecabezas.

## 56B. Cross-decision reassembly (combinaciones críticas)

- **DEC-04 D4 + DEC-05 E2**: emerge arquitectura B ("Canonical + Motor"); coherente.
- **DEC-04 D4 + DEC-05 E1**: incoherente (canónica declarada + sync manual = drift asegurado).
- **DEC-04 D5 + DEC-05 E2**: incoherente (motor sin canónica declarada; qué compila?).
- **DEC-02 B2 + DEC-07 F2**: emerge arquitectura E+D combinada; provider dependence
  registrada explícitamente.
- **DEC-08 G2 + DEC-11 H2**: emerge patrón "revisit formal con política"; institucionaliza
  futuros revisits.
- **Bloque A completo + DEC-11 + DEC-12**: emerge arquitectura A+E ("Statu quo formalizado
  + delegation") sin cruzar F9-D01; máxima gobernanza sin runtime change.
- **DEC-04 + DEC-07 + DEC-08 en una fase**: emergent architecture PAC + peer LLM +
  instrumentation → riesgo compuesto alto; DEBE espaciarse.

## 56C. Trajectory assembly

Ver Parte IV §74.

## 56D. Minimum coherent architecture

Piezas mínimas para que CCP siga siendo coherente:

- P-BB, P-BS, P-GT, P-LE (los 3 gates + emitter).
- P-EM, P-SM (evidence + state).
- P-H (reviewer humano).
- P-O (owner).

Todo lo demás es **compensación de substrate** o **gobernanza expandida**. Este mínimo
es la respuesta a "qué queda si eliminamos meta-doc": el ciclo Cm.

## 56E. Replacement test

- P-PT: reemplazable por YAML (DEC-04 D4) o eliminable (D2).
- P-BB regex: reemplazable por tests (DEC-04 D3) o generado (DEC-04 D4/D1).
- P-H reviewer: **no reemplazable** (K3-D-AUTHZ-VS-VERIF); autorización requiere humano.
- P-LE: reemplazable por cualquier emitter con schema compatible.
- P-GT: reemplazable por cualquier gate mecánico equivalente.
- P-RB (maintenance): reemplazable por CI equivalente.

**Core irreducible**: P-H (autorización) + los 3 gates mecánicos. Todo lo demás es
plástico.

---

## 56F. Puzzle integrity scorecard

| Dimension | Before | Path A | Path B | Path C | Path D | Path E | Path F | Path G |
|---|---|---|---|---|---|---|---|---|
| Structural Fit | 100 | 100 | 95 | 90 | 65 | 70 | 90 | 55 |
| Interface Fit | 100 | 100 | 100 | 85 | 80 | 75 | 95 | 55 |
| Invariant Preservation | 100 | 100 | 100 | 100 | 90 | 85 | 100 | 75 |
| Evidence Continuity | 100 | 100 | 100 | 100 | 95 | 90 | 100 | 90 |
| Reversibility | 100 | 100 | 100 | 100 | 60 | 70 | 95 | 60 |
| Complexity net | 100 | 95 | 85 | 90 | 65 | 75 | 90 | 60 |
| Risk | 100 | 100 | 95 | 85 | 55 | 70 | 90 | 55 |
| Long-term Evolution | 30 | 35 | 60 | 65 | 80 | 75 | 80 | 75 |
| Future Decision Value | 30 | 40 | 75 | 80 | 75 | 70 | 85 | 55 |

Cada valor justificable en §24 (Path descriptions).

---

## 56G. Master puzzle question — respuestas por DEC (formato)

Ejemplo DEC-04 D4:

- ¿Dónde estaba la pieza? Dual (P-PT + P-BB con sync manual).
- ¿Dónde la queremos mover? Canónica única YAML + motor → BB generado.
- ¿Por qué moverla? Cerrar GAP-1; activar DERIVE; escalar.
- ¿Qué vecinos tiene? Reviewer, tool call pipeline, HRQS, docs.
- ¿Qué interfaces cambia? Build pipeline; edición humana; consumers de firewall (misma
  interfaz, semántica derivada).
- ¿Qué otras piezas deben moverse? P-MTR (insert), CI check (insert), HRQS (transform),
  reviewer training (event).
- ¿Qué pieza nueva hace falta? P-PC-CAN, P-MTR, FP framework.
- ¿Qué pieza queda obsoleta? Sync manual; parcialmente HRQS §12; P-PT si D4-B.
- ¿Qué información se pierde? Comentarios humanos si no preservados en YAML.
- ¿Qué riesgo aparece? Motor bug; nuevas FP classes; lock-in YAML.
- ¿Qué invariantes se conservan? INV-1, INV-2, INV-3, INV-4, INV-5, INV-6; nuevo INV-motor.
- ¿Cómo demostramos que encajó? CI motor tests + FP rate baseline < 5% en corpus real.
- ¿Qué sucede si no encaja después? Rollback: revert commit, restaurar snapshot pre-cutover,
  restaurar P-PT y P-BB manual.
- ¿Cómo revertimos? git revert + eliminar motor build step; datos históricos preservados.

(Formato aplicable a todas las decisiones; respondido por opción dominante.)

---

## 56H. Final assembly certificate template

Certificate emitido tras cada trayectoria hipotética:

```text
ASSEMBLY CERTIFICATE — [PATH-ID]

BASELINE           : CCP F8 complete + F9 gate closed + K3 baseline
MOVES              : [lista de DEC + option adoptadas]
PIECES AFFECTED    : [lista]
INTERFACES         : [lista + versiones]
INVARIANTS         : [preservados / extendidos / debilitados]
EVIDENCE           : [nuevos EV requeridos + hashes]
NEW COMPONENTS     : [P-XXX added]
OBSOLETE COMPONENTS: [P-XXX removed or deprecated]
RESIDUAL RISKS     : [top 5]
REVERSIBILITY      : [descripción rollback]
VALIDATION         : [maintenance PASS + tests específicos]
NEXT STATE         : [descripción arquitectónica]
NEXT DECISION      : [DEC-YY habilitado]
```

Se instancia por trayectoria en Parte IV.

**FIN PARTE III.**

---

# PARTE IV — EXECUTION CANDIDATE SYNTHESIS

> Cada decisión = qué se elige. Cada ejecución = **cómo se transforma el sistema para
> materializarla**. Por cada opción, 2–4 candidatos de ejecución compactos, simulados,
> con delta arquitectónico y condiciones de éxito/aborto/rollback.

## 57. Framework de execution candidate

Cada candidato tiene: `CANDIDATE-ID / TARGET DECISION / SELECTED OPTION / EXECUTION
STRATEGY / INITIAL STATE / TARGET STATE / CORE MOVES / DEPENDENCIES / NEW PIECES /
REMOVED PIECES / MODIFIED INTERFACES / EVIDENCE GATE / ROLLBACK / NEXT DECISION UNLOCKED`.

Cuando aplique: morphology (ADD / REMOVE / REPLACE / MIGRATE / WRAP / ADAPTER / SHADOW /
DUAL-RUN / CANARY / GRADUAL-CUTOVER / FULL-CUTOVER / FREEZE / EXPERIMENT / DELEGATE /
DERIVE / CONSOLIDATE / SPLIT / MERGE / RETIRE).

## 58. Candidatos por decisión (compactos)

Sólo decisiones sustantivas (10 de 13). DEC-06, DEC-09, DEC-13 son derivadas o external.

### 58.1 DEC-01 D-CATALOG

**C1-A2-Min** (MINIMUM REVERSIBLE MOVE)
- Strategy: crear `CHANGE_TYPES_CATALOG.md` con 5 tipos observados + placeholder para futuros.
- Initial: sin catálogo.
- Target: catálogo con 5 tipos.
- Core moves: crear archivo; documentar en handbook.
- Dependencies: ninguna.
- New pieces: `CHANGE_TYPES_CATALOG.md`.
- Removed pieces: ninguna.
- Modified interfaces: workflow reviewer (consulta al catálogo).
- Evidence gate: humano review; catálogo aprobado.
- Rollback: git revert.
- Next unlocked: DEC-02 puede diseñarse.
- Morphology: ADD.

**C1-A2-Bal** (BALANCED)
- Strategy: C1-A2-Min + integración con HRQS (chequea que change tenga tipo catalogado).
- Adds: HRQS section §12 update.

**C1-A3-Full** (FULL ARCHITECTURAL)
- Strategy: catálogo + hook rechaza tipo no listado.
- Preconditions: DEC-11 aprobada previamente (formalizar F9-D01 revisit).
- Rollback: git revert + disable hook.
- Morphology: ADD + WRAP.

### 58.2 DEC-02 D-DELEG

**C2-B2-Min**: crear `DELEGATION_REGISTRY.md` con 3 entradas iniciales (auth, evidence review, code review).
**C2-B2-Bal**: + integración con handbook + review trimestral.
**C2-B3-Full**: registry + hook que valida presencia. Requiere DEC-11.
**C2-Exp** (EXPERIMENT): correr registry como shadow durante 1 mes; observar si es
utilizado; formalizar después.

### 58.3 DEC-03 D-LIFECYCLE

**C3-C2-Min**: convención front-matter en nuevos docs; retro-fit gradual.
**C3-C2-Bal**: retro-fit inmediato (75 archivos) + runbook check.
**C3-C4-Sub**: sólo research artifacts; deferrals via DEC-11.
**C3-C3-Full**: registry activo con transiciones auditadas.

### 58.4 DEC-04 D-CANONICAL (crítico)

**C4-D5-Statu** (DEFER + EXPERIMENT preparation)
- Strategy: no cambiar canónica; correr experimento PAC en shadow por 3 meses; medir FP
  rate y ergonomía.
- Initial: dual.
- Target: dual + shadow con PAC en CI (no autoritativo).
- Core moves: activar `compile_policies.sh` en CI comparativo; log divergencias.
- Dependencies: ninguna nueva.
- New pieces: PAC shadow compilation (research → CI).
- Removed pieces: none.
- Modified interfaces: CI pipeline añade check.
- Evidence gate: 3 meses de shadow + 20+ policies + FP rate < 5%.
- Rollback: disable shadow check.
- Next unlocked: DEC-04 D4 con datos.
- Morphology: SHADOW + EXPERIMENT.

**C4-D4-Bridge** (BALANCED via bridge)
- Strategy: YAML canónica + motor unidireccional + P-PT mantenido como derived doc.
- Initial: dual manual.
- Target: YAML → motor → firewall + .md derivado.
- Core moves: (1) construir YAML canónica desde .md + firewall actuales; (2) motor uni
  incluye .md-writer; (3) shadow un mes; (4) cutover; (5) freeze .md como derivado.
- Dependencies: DEC-05 E2; DEC-11 H2 (FP policy).
- New pieces: P-PC-CAN, P-MTR (uni + .md writer), FP framework.
- Removed pieces: sync manual.
- Modified interfaces: build pipeline; edit workflow (YAML).
- Evidence gate: motor idempotent + no-drift + FP rate baseline + reviewer training.
- Rollback: revert commit + restaurar P-PT como canónica + disable motor.
- Next unlocked: DEC-06 (READY-01/02 derivadas), DEC-07 (metadata).
- Morphology: CANONICALIZE + ADAPTER (.md derivado) + GRADUAL-CUTOVER.

**C4-D4-Full** (FULL ARCHITECTURAL)
- Strategy: YAML canónica; motor uni; **deprecate P-PT completamente**.
- Initial: dual manual.
- Target: YAML → motor → firewall only.
- Core moves: como Bridge pero sin .md derivado.
- Rollback: mismo, pero requiere restaurar P-PT desde snapshot histórico.
- Info loss: comentarios humanos si no preservados en YAML metadata.

**C4-D1-Bridge** (BALANCED alternative: Markdown canónica)
- Strategy: .md canónica completa + motor Markdown-parser → firewall.
- Preconditions: parser Markdown restringido factible; validated en experimento previo.
- Similar structure a D4 pero con Markdown como source of truth.

**C4-D3-Exp** (EXPERIMENT tests-as-canónica)
- Strategy: prototipar 5 policies como tests bloqueantes; medir latency y expresividad.
- No cutover; sólo aprendizaje.

### 58.5 DEC-05 D-MOTOR

Derivada de DEC-04. Ver C4-D4-Bridge, C4-D4-Full, C4-D1-Bridge.

### 58.6 DEC-07 D-VERIFICADOR

**C7-F1-Statu** (no-op).

**C7-F2-Shadow** (SHADOW mode)
- Strategy: `code-reviewer` obligatorio en subagentStop pero verdict advisory (no gate).
- Duration: N sesiones para medir U-09.
- Evidence gate: correlated failure medido; humano audita 100% de samples.
- Rollback: disable invocación obligatoria.
- Morphology: SHADOW + DELEGATE (parcial).

**C7-F2-Bal** (BALANCED with gate)
- Strategy: `code-reviewer` verdict + gate mecánico en subagentStop; humano ex-post commit.
- Preconditions: shadow completo + U-09 aceptable.
- Rollback: disable gate; volver a F1.

**C7-F3-Exp**: dual-LLM shadow.

### 58.7 DEC-08 D-INSTR

**C8-G1-Accept**: aceptar U-01/U-02 UNKNOWN.

**C8-G2-Min** (MINIMUM)
- Strategy: sólo `verdict:` field añadido; `had_alternative` y `session_id` se mantienen null.
- Preconditions: DEC-11 H2.
- Evidence gate: schema válido; tests pasan.
- Rollback: git revert.

**C8-G2-Full**
- Strategy: schema completo (`verdict`, `had_alternative`, `session_id` propagados).
- Preconditions: DEC-11 H2; F9-D01 revisit formal.
- Evidence gate: eventos con valores reales verificados en N sesiones.
- Rollback: git revert; default null preserva histórico.
- Morphology: TRANSFORM + MIGRATE.

**C8-G3-Shadow** (SHADOW alternative)
- Strategy: runtime paralelo instrumentado; productivo no cambia.
- Preserves F9-D01=A.
- Cost: ongoing (2× runtime).

### 58.8 DEC-11 D-DEFERRAL-POLICY

**C11-H2-Min**: crear `DEFERRAL_POLICY.md`; back-fill triggers en 4 deferrals existentes.
**C11-H3-Bal**: H2 + integrar check en `maintenance.sh`.
**C11-Exp**: shadow (política sin aplicar); ver si triggers propuestos se disparan.

### 58.9 DEC-12 D-META-DOC

**C12-I2-Min**: cap 30 en `docs/00_SYSTEM/` + archive dir.
**C12-I4-Full**: I2 + supersedes convention.
**C12-Exp**: contar acceso a meta-doc por 3 meses (proxy) antes de aplicar cap.

---

## 59. Execution × Decision matrix

| DEC | Op | Candidate | Structural Fit | Feasibility | Risk | Regression | Reversibility | Evidence req | Future value |
|---|---|---|---|---|---|---|---|---|---|
| 01 | A2 | C1-A2-Min | 95 | 100 | 5 | 5 | 100 | Low | Medium |
| 01 | A2 | C1-A2-Bal | 90 | 90 | 10 | 5 | 100 | Low | Medium-high |
| 01 | A3 | C1-A3-Full | 75 | 60 | 30 | 20 | 90 | Medium | High |
| 02 | B2 | C2-B2-Min | 95 | 100 | 5 | 5 | 100 | Low | High |
| 02 | B2 | C2-B2-Bal | 90 | 90 | 10 | 5 | 100 | Low | High |
| 02 | B3 | C2-B3-Full | 75 | 60 | 30 | 15 | 90 | Medium | High |
| 03 | C2 | C3-C2-Min | 90 | 90 | 10 | 15 | 100 | Low | Medium |
| 03 | C2 | C3-C2-Bal | 85 | 75 | 15 | 15 | 100 | Low | Medium-high |
| 04 | D5 | C4-D5-Statu | 100 | 100 | 5 | 0 | 100 | Data over time | Enables data-based DEC-04 |
| 04 | D4 | C4-D4-Bridge | 65 | 55 | 40 | 30 | 60 | Motor tests + 20+ policies | Very high |
| 04 | D4 | C4-D4-Full | 55 | 45 | 55 | 40 | 40 | Motor tests + info preserved | Very high |
| 04 | D1 | C4-D1-Bridge | 70 | 50 | 45 | 30 | 60 | Parser tests | Medium |
| 04 | D3 | C4-D3-Exp | 60 | 40 | 30 | 15 | 90 | Prototype 5 tests | Medium |
| 07 | F2 | C7-F2-Shadow | 80 | 70 | 25 | 15 | 90 | N sessions + audit | Medium (S1) / High (S2) |
| 07 | F2 | C7-F2-Bal | 55 | 40 | 45 | 30 | 60 | U-09 acceptable | High |
| 08 | G1 | C8-G1-Accept | 100 | 100 | 5 | 0 | 100 | Caveat | Low |
| 08 | G2 | C8-G2-Min | 75 | 75 | 15 | 5 | 100 | Schema tests | High (partial) |
| 08 | G2 | C8-G2-Full | 60 | 60 | 25 | 10 | 95 | Field propagation tests | Very high |
| 08 | G3 | C8-G3-Shadow | 85 | 60 | 20 | 10 | 100 | Shadow validation | Medium |
| 11 | H2 | C11-H2-Min | 100 | 100 | 5 | 0 | 100 | Policy doc | High |
| 11 | H3 | C11-H3-Bal | 95 | 90 | 10 | 5 | 100 | Runbook check | High |
| 12 | I4 | C12-I4-Full | 90 | 85 | 10 | 10 | 100 | Runbook | Medium |

**Insight**: para DEC-04 la mejor primera ejecución **no es cutover** — es **C4-D5-Statu +
experimento** que genera datos para decidir Bridge o Full más tarde.

---

## 60. Execution feasibility vs architectural value

| Candidate | Arch value | Feasibility | Cuadrante |
|---|---|---|---|
| C11-H2-Min | High | Very high | HV + HF (adopt) |
| C2-B2-Min | High | Very high | HV + HF (adopt) |
| C1-A2-Min | Medium | Very high | HV + HF (adopt) |
| C12-I4-Full | Medium | High | MV + HF (adopt) |
| C3-C2-Min | Medium | High | MV + HF (adopt) |
| C4-D5-Statu + experiment | Very high LATER | High NOW | LEARN + HF (adopt as prep) |
| C8-G2-Min | High | Medium | HV + MF (adopt with DEC-11) |
| C8-G3-Shadow | Medium | Medium | MV + MF (alternative) |
| C7-F2-Shadow | Medium/High (scenario) | Medium | HV + MF (adopt as experiment) |
| C4-D4-Bridge | Very high | Low-med | HV + LF (defer; requires experiment first) |
| C4-D4-Full | Very high | Low | HV + LF (defer) |
| C4-D2 (elim P-PT) | Medium | Low | LV + LF (reject) |

**Bridges naturales**: C4-D5-Statu → data → C4-D4-Bridge (esta es la trayectoria óptima).

---

## 61. Execution bridge search

Puentes construibles:

- **PAC shadow → PAC canónica**: `C4-D5-Statu` produce datos para transición a
  `C4-D4-Bridge`. Bridge duration: 3 meses. Cost: CI check + motor build. Retirement:
  cutover post-datos.
- **STALL schema partial → full**: `C8-G2-Min` como primer paso; `C8-G2-Full` después.
- **LLM verifier shadow → gate**: `C7-F2-Shadow` como advisory; `C7-F2-Bal` cuando
  U-09 acceptable.
- **DELEG_REG informal → hook enforced**: `C2-B2-Min` → `C2-B3-Full` cuando disciplina
  humana falla.

Estos bridges tienen **condición de retiro** explícita (evidencia + tiempo). Sin
DEC-11 H2, riesgo de bridges permanentes → deuda.

---

## 62. Temporary pieces test

Toda pieza temporal debe declararse. Ejemplo:

```text
BRIDGE       : PAC shadow (from C4-D5-Statu)
Why exists   : validar motor + FP rate antes de cutover
Duration     : 3 meses o hasta 20+ policies validated
Removal cond : cutover (C4-D4-Bridge) o rechazo definitivo
What if not  : bridge permanent → deuda; motor sin owner claro
Owner        : reviewer humano + Owner
Evidence     : FP rate < 5% en corpus real
```

Sin condición de retiro → **potential permanent debt**. Cada bridge debe pasar por
DEC-11 policy.

---

## 63. Execution regression simulation

Simulación de estados intermedios para trayectorias críticas:

**Trayectoria C4-D4-Bridge (paso a paso)**:
1. Estado 0: dual manual. **SAFE**.
2. Estado 1: YAML canónica escrita + motor construido. Motor NO en CI. **SAFE (dual sigue
   operativo)**.
3. Estado 2: motor en CI shadow (compara pero no bloquea). **SAFE**.
4. Estado 3: motor en CI gate (rechaza si divergencia). **DEGRADED (falsos rechazos posibles)**.
5. Estado 4: cutover — firewall es artefacto derivado. **SAFE si tests pasan; DANGEROUS
   si tests incompletos**.
6. Estado 5: P-PT deprecado o freezed como derivado. **SAFE**.

**Momentos peligrosos**: estado 3 (rechazos por drift transicional) y estado 4 (cutover).

**Trayectoria C8-G2-Full (paso a paso)**:
1. Estado 0: schema partial. **SAFE**.
2. Estado 1: F9-D01 revisit aprobado formalmente. **SAFE**.
3. Estado 2: schema extendido + default null. **SAFE (backwards-compat)**.
4. Estado 3: callers propagan `had_alternative` real. **SAFE**.
5. Estado 4: callers propagan `session_id` real. **SAFE**.
6. Estado 5: HRQS reformulada consume `verdict:`. **SAFE**.

**Ningún estado dangerous**. Migración incremental.

---

## 64. Failure during transition

Simulación:

- **C4-D4-Bridge**: si motor bug en estado 3, rechazos falsos bloquean workflow →
  rollback a estado 2 (shadow).
- **C4-D4-Bridge**: si owner cambia de decisión a mitad (2026 → 2027) → estado 4
  incompleto = arquitectura inconsistente. Mitigación: cada paso commiteable
  independientemente.
- **C7-F2-Bal**: si LLM provider cambia pricing/model → costo aumenta o funcionalidad
  degrada. Mitigación: abstraction layer + fallback humano.
- **C8-G2-Full**: si caller olvida propagar `session_id`, default null preserva histórico.
- **C11-H2-Min**: si revisión trimestral se omite, DEC-11 H3 lo detecta.

Cada candidato debe tener **TRANSITION FAILURE MODEL** documentado en su evidence gate.

---

## 65. Rollback reality test

Para cada candidato:

| Candidate | Rollback point | Rollback data | Rollback authority | Rollback procedure | Evidence | Cost | Window |
|---|---|---|---|---|---|---|---|
| C1-A2-Min | pre-commit | git snapshot | reviewer | `git revert` | trivial | seconds | any |
| C2-B2-Min | pre-commit | git | reviewer | `git revert` | trivial | seconds | any |
| C4-D5-Statu | disable CI check | git | reviewer | disable job | shadow logs | minutes | any |
| C4-D4-Bridge state 2 | pre-shadow | git | reviewer | remove shadow | logs | minutes | any |
| C4-D4-Bridge state 4 | pre-cutover | git + firewall snapshot | Owner | revert commit + restore firewall + restore P-PT | motor tests | hours | limited (before new policies added post-cutover) |
| C4-D4-Full state 4 | pre-cutover | git + firewall snapshot + P-PT snapshot | Owner | revert commit + restore firewall + restore P-PT | motor tests + doc reconstruction | days | limited |
| C7-F2-Shadow | disable invocation | git | reviewer | remove obligatory call | logs | minutes | any |
| C7-F2-Bal | pre-cutover | git | Owner | disable gate | logs | minutes | any |
| C8-G2-Full | schema extension | git | Owner | revert schema fields | historical preserved via null | minutes | any |
| C11-H2-Min | pre-adoption | git | reviewer | remove policy doc | none | seconds | any |

**Alto-cost rollbacks**: C4-D4-Bridge/Full state 4 y siguientes (nuevas policies escritas
sólo en YAML → recuperar .md requiere trabajo humano).

---

## 66. Evidence gates & exit conditions

Formato para cada candidato dominante:

```text
Candidate C4-D4-Bridge
  BEFORE EVIDENCE     : baseline: dual manual, 24 IDs, X drift historial
  TRANSITION EVIDENCE : motor tests PASS + shadow log 3 meses + FP rate < 5%
  AFTER EVIDENCE      : cutover commit + firewall = motor(YAML) + reviewer training done
  SUCCESS CONDITION   : maintenance 12/12 PASS post-cutover + 0 unexpected FP en primer mes
  ABORT CONDITION     : motor produce firewall inválido (test rejects) → stop pre-cutover
  ROLLBACK CONDITION  : > 3 FP inesperados post-cutover en 1 mes
  REASSESS CONDITION  : policy compleja no expresable en YAML aparece

Candidate C8-G2-Full
  BEFORE EVIDENCE     : baseline STALL log 18 líneas
  TRANSITION EVIDENCE : schema tests + 20 events con nuevos campos
  AFTER EVIDENCE      : STALL log 50+ eventos con verdict + had_alternative propagado
  SUCCESS CONDITION   : HRQS puede clasificar TP/FP/UNK sistemáticamente
  ABORT CONDITION     : callers no propagan valores por bug persistente
  ROLLBACK CONDITION  : schema causa parse fail en consumers
  REASSESS CONDITION  : nuevo tipo de evento requiere schema adicional

Candidate C11-H2-Min
  BEFORE EVIDENCE     : 4 deferrals sin trigger
  TRANSITION EVIDENCE : policy doc + backfill triggers
  AFTER EVIDENCE      : 4 deferrals con trigger declarado + review calendar
  SUCCESS CONDITION   : trimestre 1 se revisa; report generado
  ABORT CONDITION     : ninguno realístico
  ROLLBACK CONDITION  : policy contradice principio de F9-D01=A
  REASSESS CONDITION  : trigger diseñado se dispara antes de trimestre
```

---

## 67. Execution uncertainty

Para cada candidato: `KNOWN / SUPPORTED / UNKNOWN / ASSUMED`:

| Candidate | KNOWN | SUPPORTED | UNKNOWN | ASSUMED |
|---|---|---|---|---|
| C4-D4-Bridge | motor viable (PAC) | reduces drift | FP rate general (U-08); ergonomy impact | 20+ policies produce enough signal |
| C7-F2-Shadow | LLM code-reviewer runs | reduces syntactic load | U-09 correlated failure | model quality stable |
| C8-G2-Full | schema change trivial | unblocks U-01/U-02 | Owner acceptance F9-D01 revisit | HRQS can classify given data |
| C11-H2-Min | policy doc trivial | halts decay | tasa real de revisit needed | trimestral suficiente |

**Cuidado con "describir con detalle" ≠ "más seguro"**. C4-D4-Bridge está descrito
detalladamente pero U-08 y ergonomy son UNKNOWN dominantes.

---

## 68. Execution candidate elimination

Descartados y por qué:

- **C4-D2 (eliminar P-PT)**: pérdida doc humana rompe INV-8 sin compensación.
- **C7-F4 segundo humano**: impracticable con solo owner.
- **C4-D3 en cutover** (sin experimento): paradigma tests-as-contract sin evidencia
  previa.
- **C4-D4-Full sin bridge**: cutover directo sin shadow es alto riesgo con U-08 abierto.
- **C1-A3-Full sin DEC-11**: precedente ad-hoc F9-D01 revisit.

**Sobrevivientes**: ver §69.

---

## 69. Surviving candidates

`SURVIVES`: C1-A2-Min, C1-A2-Bal, C2-B2-Min, C2-B2-Bal, C3-C2-Min, C3-C2-Bal, C4-D5-Statu,
C8-G2-Min, C8-G3-Shadow, C11-H2-Min, C11-H3-Bal, C12-I4-Full.

`SURVIVES WITH CONDITIONS`: C1-A3-Full (with DEC-11), C2-B3-Full (with DEC-11),
C7-F2-Bal (with U-09 experiment result), C4-D4-Bridge (with C4-D5-Statu evidence),
C4-D1-Bridge (with parser experiment), C8-G2-Full (with DEC-11).

`EXPERIMENT ONLY`: C4-D3-Exp, C4-D5-Statu (as experiment for D4), C7-F2-Shadow (as
experiment for F2-Bal), C7-F3-Exp.

`DEFER`: C4-D4-Full, C4-D1-Bridge (sin experimento).

`REJECT`: C4-D2 elimination, C7-F4 second human.

---

## 70. Configuration topology — futuros CCP

Cada configuración sobreviviente produce un estado distinto del CCP:

**CONFIGURATION Path-B** (Bloque A + DEC-11 + DEC-12)
- policy authority: unchanged (dual manual)
- delegation: explicit (registry)
- lifecycle: front-matter
- verification: humano
- instrumentation: partial
- rollback: trivial
- Governance quality: **HIGH**
- Runtime change: none

**CONFIGURATION Path-C** (Path-B + DEC-08 G2)
- policy authority: unchanged
- delegation: explicit
- lifecycle: front-matter
- verification: humano
- instrumentation: **complete**
- rollback: trivial
- Epistemological quality: **HIGH**
- Runtime change: schema P-LE + callers

**CONFIGURATION Path-D** (Path-B + DEC-04 D4 + DEC-05 E2)
- policy authority: YAML canónica
- delegation: explicit
- lifecycle: front-matter
- verification: humano
- instrumentation: partial
- rollback: motor bridge
- Architectural quality: **HIGH**
- Runtime change: motor + build + firewall derivado

**CONFIGURATION Path-F** (Path-B + DEC-08 G3 shadow + experiment DEC-04)
- policy authority: dual + PAC shadow (experiment)
- delegation: explicit
- lifecycle: front-matter
- verification: humano
- instrumentation: shadow runtime
- rollback: trivial
- Optionality quality: **HIGHEST**
- Runtime change: none (shadow only)

Son 3 futuros diferentes del CCP, cada uno con ventajas distintas.

---

## 71. Execution leverage & compound value

Candidatos con leverage compuesto (benefician decisiones posteriores):

- **C11-H2**: además de detener decay, formaliza el patrón para futuros revisits
  (compound value alto).
- **C2-B2**: además de eliminar K3-D-OWNER-DEFAULT, habilita DEC-07 con claridad.
- **C4-D5-Statu (experiment)**: además de preservar optionality, genera datos que
  reforman DEC-04.
- **C8-G2-Full (con DEC-11)**: además de datos, formaliza precedente F9-D01 revisit
  para futuros.

**Compound value = benefit + information + future architectural value**. Los candidatos
del Bloque A + DEC-11 lideran esta dimensión.

---

## 72. Best-first-move test

Mejor primera ejecución (no necesariamente mejor arquitectura final):

**Ranked options for "first move to authorize"**:
1. **C11-H2-Min** — perfect FIT + high value + trivial cost + unblocks future revisits.
2. **C2-B2-Min** — very high FIT + high value + governance win + unblocks DEC-07.
3. **C1-A2-Min** — very high FIT + medium value + unblocks DEC-02 (paired with 2).
4. **C4-D5-Statu (PAC shadow)** — preserva optionality + genera datos.
5. **C8-G3-Shadow** — instrumenta sin F9-D01 cross; costoso pero seguro.

**Anti-recommendation for "first move"**:
- C4-D4-Bridge/Full: alto lock-in; requiere experimento previo.
- C7-F2-Bal: cutover LLM antes de experimento shadow es riesgoso.

**Best final architectural state** puede ser distinto del **best first move**. El best
first move para llegar allí es rara vez el propio movimiento final.

---

## 73. Execution ladder

```text
LEVEL 0  CURRENT CCP (F8 + F9 gate closed)
    ↓
LEVEL 1  SAFE / REVERSIBLE
         + DEC-11 H2 (deferral policy)
         + DEC-01 A2 + DEC-02 B2 + DEC-03 C2 (Bloque A)
         + DEC-12 I4 (meta-doc contain)
         + DEC-10 (formato mensaje)
         → GOVERNANCE ARCHITECTURE (Path B)
    ↓
LEVEL 2  OBSERVABLE
         + DEC-08 G3 shadow (instrumentation without F9-D01 cross)
         + C4-D5-Statu (PAC shadow experiment)
         + C7-F2-Shadow (LLM advisory)
         → OBSERVABLE ARCHITECTURE (Path F variant)
    ↓
LEVEL 3  PARTIALLY TRANSFORMED
         + DEC-08 G2 (formal F9-D01 revisit)
         + DEC-09 (READY-03 with data)
         → EPISTEMOLOGICAL COMPLETENESS
    ↓
LEVEL 4  STABLE NEW ARCHITECTURE
         + DEC-04 (decided based on data)
         + DEC-05 (motor if applicable)
         + DEC-06 (READY-01/02 derivada)
         → POLICY ARCHITECTURE
    ↓
LEVEL 5  OPTIMIZED / EVOLVED
         + DEC-07 F2 (delegated verification) - if S2 activates
         + DEC-13 external if trigger appears
         → SCALE-READY ARCHITECTURE
```

Cada nivel es **commiteable independientemente**; puede detenerse en cualquiera.

---

## 74. Next-decision enablement (learning loop)

Para cada nivel, qué información / decisión se habilita:

- **Level 1 → Level 2**: DEC-11 permite formalizar cualquier revisit; Bloque A produce
  ejemplos de delegación real; DEC-12 produce curva de meta-doc.
- **Level 2 → Level 3**: shadow instrumentation produce datos para READY-03; experimento
  PAC produce FP rate real.
- **Level 3 → Level 4**: datos sobre H-01 informan si D5 sigue siendo válido; FP rate
  informa si D4 es viable.
- **Level 4 → Level 5**: metadata en YAML habilita DEC-07 con contexto rico.

**Learning loop architectural**: cada decisión temprana mejora la información para
decisiones posteriores. Este es el argumento principal para el orden Bloque A + DEC-11
primero.

---

## 75. Master Transformation Candidates (superficie compacta)

| Transformation | Decision | Option | First move | Core execution | Intermediate | Target | Main benefit | Main risk | Regression | Reversibility | Evidence gate | Next unlocked | Confidence |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T1 | 11 | H2 | Add policy doc | Backfill triggers 4 deferrals | Same + calendar | Reviewer trimestral | Halts decay | none | none | High | Trimestre 1 done | Formal revisits | 85 |
| T2 | 02 | B2 | Add registry file | Populate 3 entries | Same + review | Governance registry | Kills K3-D-OWNER-DEFAULT | Discipline | none | High | Registry populated | DEC-07 | 80 |
| T3 | 01 | A2 | Add catalog file | Enumerate 5 change types | Same | Catalog live | Reduces ambiguity | Discipline | none | High | Catalog reviewed | DEC-02 | 85 |
| T4 | 03 | C2 | Convention doc | Retrofit 75 archivos | Front-matter + runbook | Lifecycle observable | Contains K3-D-LIFECYCLE | Discipline | none | High | Runbook passes | DEC-12 sinergy | 70 |
| T5 | 08 | G3 shadow | Enable shadow env | Run parallel N weeks | Shadow logs | Instrumented shadow | Preserves F9-D01=A | Cost | none | High | Shadow log valid | DEC-09 partial | 55 |
| T6 | 08 | G2 min | Add verdict field | Preserve had_alt=null | Schema extended | Full G2 | Unblocks HRQS classification | F9-D01 revisit precedent (mitigated with T1) | none | High | Schema tests + T1 done | READY-03 partial | 65 |
| T7 | 08 | G2 full | Extend schema + F9-D01 revisit | Callers propagate values | Full schema | Complete instrumentation | Unblocks U-01/U-02 | Precedent + effort | none | High | 20+ events real values + T1 done | READY-03 empírica | 55 |
| T8 | 04 | D5 + experiment | Enable PAC in CI shadow | Compare outputs 3 months | Dual + shadow | Data for decision | Preserves optionality | Ongoing shadow cost | none | High | 20+ policies + FP < 5% | Data-based DEC-04 | 60 |
| T9 | 04 | D4-Bridge | Build YAML canonical + motor bridge | Shadow → gate → cutover | Dual → shadow → gate → cutover | Canonical + motor | Closes GAP-1 | Motor bug; FP class | Maintainability MIX | Low (post-cutover) | Motor tests + T8 evidence | DEC-06 derivada | 40 |
| T10 | 04 | D1-Bridge | Same as T9 but Markdown source | Similar phased | Similar | Canonical .md + motor | Ergonomía humana | Parser expressiveness | Similar | Low | Parser tests + policies fit | DEC-06 derivada | 45 |
| T11 | 07 | F2-Shadow | Invoke code-reviewer obligatory (advisory) | Run N sesiones | Shadow verdicts | LLM advisor | Precondition to F2-Bal | Correlated failure risk | none | High | U-09 measurement | F2-Bal | 40 |
| T12 | 07 | F2-Bal | Enable code-reviewer verdict as gate | Full delegation post-tool | LLM + humano gate | Delegated verification | Alivia PT-1 | Provider dep + skill loss | INV-8 weaken | Medium | U-09 acceptable + T2 done | S2 scaling | 35 |
| T13 | 12 | I4 | Policy cap + supersedes conv | Archive existing overflow | Same | Contained meta-doc | Retrasa PT-3 | Discipline | none | High | Runbook | Long-term evolution | 70 |

---

## 76. Global assembly competition

Comparando transformaciones supervivientes contra el rompecabezas completo:

- **Menor movimiento con mayor valor**: T1 (H2), T2 (B2), T3 (A2). Sweet spot.
- **Mayor evidencia útil**: T8 (D5+experiment), T5 (G3 shadow), T7 (G2 full).
- **Mayor reducción incertidumbre**: T7, T8, T6.
- **Mayor optionality preservada**: T1, T5, T8.
- **Menor arquitectura muerta**: T1..T4 (nada muere; sólo se declara).
- **Menor deuda temporal**: T1..T4 (no bridges). T8 tiene bridge con condición retiro.

**Riesgo compuesto**: correr T7 + T9 + T12 en misma fase = muy alto riesgo. Espaciar.

---

## 77. Best transformation path

Ranked paths (structural evaluation, non-decisional):

**Path recomendado analíticamente por robustez**: T1 → {T2, T3, T4, T13} → T5 → T8 → T6/T7 → T9 → T11 → T12.

Descripción:
```text
Phase 1 (weeks)      : T1 (DEC-11 H2)  — 1 first move; unblocks everything
Phase 2 (1-2 months) : T2 + T3 + T4 + T13 (Bloque A + DEC-12) — governance clarity; no runtime change
Phase 3 (2-3 months) : T5 (DEC-08 G3 shadow) + T8 (DEC-04 D5 + PAC shadow experiment) — data generation
Phase 4 (1-3 months) : T6 or T7 (DEC-08 G2 min/full con DEC-11 formal) — instrumentation with owner authorization
Phase 5 (2-3 months) : T9 or T10 (DEC-04 based on data) — architectural transformation with evidence
Phase 6 (1-2 months) : T11 (DEC-07 F2 shadow) — S2 preparation
Phase 7 (ongoing)    : T12 (DEC-07 F2 gate) — if S2 activates
```

**Ninguna fase auto-autoriza la siguiente**; cada requiere owner ACK.

**Alternative path (mínimo cambio)**: T1 → T2 → T3 → T4 → T13 → stop. Path B pure.
Aceptable si S1 se estabiliza indefinidamente.

**Alternative path (arquitectónico agresivo)**: T1 → T9 directamente. **Alto riesgo**;
no recomendado sin T8.

---

## 78. Path robustness

Trayectoria recomendada evaluada por robustez:

- Puede detenerse: ✓ (cada fase commiteable).
- Puede retroceder: ✓ (rollback documentado por candidato).
- Produce evidencia intermedia: ✓ (T5, T8 diseñados para esto).
- Tolera decisiones futuras diferentes: ✓ (T5, T8 son experimentos).
- No depende de un único supuesto: ✓ (T1..T4 no requieren asunciones frágiles).
- No genera lock-in prematuro: ✓ (T9/T10 sólo tras T8).
- Puede adaptarse si hipótesis refutada: ✓ (si PAC FP rate > 5%, T9 se desecha; T4 y T2
  siguen operativos).

**Ranking**: `HIGH ROBUSTNESS`.

---

## 79. Architectural option value

| Path | Options preservadas al final |
|---|---|
| Path B pure (T1..T4) | Todas las de arquitectura policy (D1/D2/D3/D4/D5) y verificación (F1/F2/F3) |
| Path B + T5 + T8 | Casi todas; opción D5 se refuerza si datos indican |
| Path B + T5 + T8 + T9 (D4) | Perdido D1/D2/D3/D5 opciones; ganado B family completa |
| Path radical T9 direct | Alta lock-in early; poca información |

**Option value** máximo con trajectory recomendada; se compromete opciones sólo cuando
la evidencia lo justifica.

---

## 80. Lock-in gradient

```text
NOW          → Path B pure          → Path B + Data     → Path B + Data + D4
LOW COMMIT     LOW COMMIT              MOD COMMIT          HIGH COMMIT (post-cutover)
             + DEC-11 policy          + shadow eng cost   + motor as TCB
             + Bloque A discipline    + schema extensions + YAML lock-in
```

Retrasar el paso a HIGH COMMIT hasta que evidencia lo justifique.

---

## 81. Execution friction

Por candidato:

- **Conceptual**: alto en T9 (nuevo paradigma canónica); bajo en T1..T4.
- **Documental**: alto en T3 (catálogo nuevo + retrofit); medio en T2, T4.
- **De código**: alto en T7, T9; bajo en T1, T2.
- **De runtime**: nulo en T1..T4; medio en T5; alto en T9, T12.
- **De governance**: alto en T7 (F9-D01 revisit); bajo en el resto (con T1 previo).
- **De evidence**: alto en T6, T7, T8 (nueva instrumentación); bajo en T1..T4.
- **Humano**: alto en T9 (reviewer retraining); bajo en T1..T4.
- **Operacional**: alto en T5 (shadow ongoing); bajo en T1..T4.

**Arquitectura simple + transición difícil**: T9 D4. **Arquitectura compleja + transición
fácil**: no aplica en el conjunto.

---

## 82. Execution shape

| Candidate | Shape |
|---|---|
| T1 (11-H2) | LOCAL + REVERSIBLE |
| T2 (02-B2) | LOCAL + REVERSIBLE |
| T3 (01-A2) | LOCAL + REVERSIBLE |
| T4 (03-C2) | INCREMENTAL + REVERSIBLE |
| T5 (08-G3) | SYSTEMIC + REVERSIBLE |
| T6/T7 (08-G2) | LOCAL/SYSTEMIC + REVERSIBLE |
| T8 (04-D5 exp) | EXPERIMENTAL + REVERSIBLE |
| T9 (04-D4-Bridge) | SYSTEMIC + INCREMENTAL + IRREVERSIBLE (post-cutover) |
| T10 (04-D1-Bridge) | SYSTEMIC + INCREMENTAL + IRREVERSIBLE (post-cutover) |
| T11 (07-F2-Shadow) | SYSTEMIC + REVERSIBLE |
| T12 (07-F2-Bal) | SYSTEMIC + IRREVERSIBLE (partial) |
| T13 (12-I4) | INCREMENTAL + REVERSIBLE |

Sólo T9, T10, T12 son "irreversibles" en algún sentido (post-cutover). Todo el resto
es reversible.

---

## 83. Assembly certificates para paths clave

### 83.1 Certificate Path B pure (T1 + T2 + T3 + T4 + T13)

```text
BASELINE           : CCP F8 + F9 gate closed
MOVES              : DEC-11 H2, DEC-02 B2, DEC-01 A2, DEC-03 C2, DEC-12 I4
PIECES AFFECTED    : + P-DEFER-POL, P-DR, P-CAT + convention front-matter + cap policy
INTERFACES         : none technical; workflow humano cambia
INVARIANTS         : preserved; INV-4 y INV-8 strengthened
EVIDENCE           : registry populated + trimestre 1 review
NEW COMPONENTS     : P-DEFER-POL, P-DR, P-CAT, front-matter policy, cap policy
OBSOLETE           : K3-D-OWNER-DEFAULT patrón, "hasta trigger concreto" pattern
RESIDUAL RISKS     : discipline lapse (mitigable by T1 trimestral)
REVERSIBILITY      : git revert; no runtime change
VALIDATION         : maintenance 12/12 + policy docs reviewed
NEXT STATE         : "Governance Architecture" — same runtime, explicit authorities
NEXT DECISION      : DEC-07 (with clarity) or DEC-08 (with T1 formalized)
```

### 83.2 Certificate Path C (Path B + T5 shadow)

```text
BASELINE           : Post Path B
MOVES              : DEC-08 G3 shadow (parallel runtime instrumented)
PIECES AFFECTED    : + P-SHADOW-RT, ongoing operational cost
INTERFACES         : new: shadow observation store; productive unchanged
INVARIANTS         : all preserved
EVIDENCE           : shadow logs; N sesiones
NEW COMPONENTS     : shadow runtime + collector
OBSOLETE           : none
RESIDUAL RISKS     : shadow representativeness of productive
REVERSIBILITY      : disable shadow trivial
VALIDATION         : shadow logs coherent + observable metrics
NEXT STATE         : "Observable Architecture" — data-generating without F9-D01 cross
NEXT DECISION      : DEC-04 con datos (T8) o DEC-08 formalizado (T7)
```

### 83.3 Certificate Path D (Path C + T8 + T9)

```text
BASELINE           : Post Path C
MOVES              : DEC-04 D4-Bridge with motor
PIECES AFFECTED    : + P-PC-CAN, P-MTR; P-BB pasa a derived; P-PT deprecated or derived
INTERFACES         : build pipeline con motor step
INVARIANTS         : all preserved + new: motor idempotent + no-drift
EVIDENCE           : 20+ policies YAML + motor tests + FP rate baseline
NEW COMPONENTS     : YAML canonical + motor + FP framework
OBSOLETE           : sync manual; parcialmente HRQS §12
RESIDUAL RISKS     : new FP classes; motor bug; YAML lock-in
REVERSIBILITY      : rollback complex (post-cutover); requires snapshot
VALIDATION         : maintenance PASS + motor CI + 1 mes sin FP inesperado
NEXT STATE         : "Policy Architecture" — GAP-1 cerrado, canónica única
NEXT DECISION      : DEC-06 derivativas; DEC-07 con metadata
```

---

## 84. Simulaciones críticas de mover una pieza (DEC-04 completo)

Ejercicio §87 del prompt aplicado a DEC-04:

### T-D5 (current + shadow experiment)
1. Pieza movida: **INSERT** shadow PAC en CI.
2. Vecinos: pipeline CI.
3. Interfaces afectadas: CI report.
4. Piezas desplazadas: ninguna.
5. Piezas nuevas: shadow motor.
6. Piezas obsoletas: ninguna.
7. Invariantes: preservados.
8. Info: se gana FP data.
9. Estado resultante: dual + shadow.
10. Proyección DEC-05: pendiente hasta DEC-04.
11. Decisiones posteriores: DEC-04 con datos empíricos.
12. Regresiones: none.
13. Reversibilidad: high.
14. Confianza fit: 100%.
15. Condiciones acept: siempre válido como preparación.

### T-D4-Bridge
Ver §83.3.

### T-D1-Bridge
1. Pieza movida: canónica → `.md` completa; motor Markdown-parser.
2. Vecinos: reviewer humano (ergonomía preservada), motor.
3. Interfaces: build con Markdown parser.
4. Piezas desplazadas: `.md` promoted; firewall derivado.
5. Piezas nuevas: parser + motor.
6. Piezas obsoletas: firewall regex manual; placeholders eliminados.
7. Invariantes: preservados; nuevo: parser idempotent.
8. Info: preservada (comentarios humanos son la canónica).
9. Estado: `.md` canónica + motor + firewall derivado.
10. Proyección DEC-05: motor Markdown parser.
11. Decisiones posteriores: READY-01/02 derivadas.
12. Regresiones: parser puede no expresar policies complejas.
13. Reversibilidad: low (post cutover).
14. Confianza fit: 70%.
15. Condiciones acept: parser expresividad validada.

### T-D2 (radical simplification)
1. Pieza movida: REMOVE `.md`; firewall es canónica.
2. Vecinos: reviewer sufre pérdida doc.
3. Interfaces: workflow humano cambia.
4. Piezas desplazadas: none.
5. Piezas obsoletas: `.md` (eliminada).
6. Invariantes: weaken INV-8.
7. Info: pérdida doc humana.
8. Estado: single source (firewall).
9. Proyección DEC-05: N/A.
10. Decisiones posteriores: onboarding, HRQS reformulada.
11. Regresiones: MAJOR (info loss).
12. Reversibilidad: medium (git history preserva).
13. Confianza fit: 40%.
14. Condiciones acept: equipo declara doc humana no es valor.

### T-D3 (tests-as-canonical)
1. Pieza movida: TRANSFORM `.md` + firewall → test suite.
2. Vecinos: hooks llaman test runner.
3. Interfaces: pre-tool latency added.
4. Piezas nuevas: test runner en hooks.
5. Piezas obsoletas: firewall regex.
6. Invariantes: preservados; nuevo: tests-as-policy expressiveness.
7. Info: pérdida intent no testeable.
8. Estado: tests + hooks calling tests.
9. Proyección DEC-05: test framework.
10. Decisiones posteriores: cambio de paradigma; migración.
11. Regresiones: latency; test gaming.
12. Reversibilidad: medium.
13. Confianza fit: 60%.
14. Condiciones acept: prototipo demuestra viable.

**Prueba superada**: el master razona el rompecabezas y proyecta consecuencias.

**FIN PARTE IV.**

---

# PARTE V — FINAL ADVERSARIAL AUDIT + CORRECCIÓN

> No auditar sólo el contenido; auditar el **modelo producido**. Ataque desde 8 ejes.
> Cada hallazgo con clasificación `SURVIVES / WEAKENED / REFORMULATED / REFUTED /
> UNKNOWN` y corrección aplicada in-place cuando la evidencia lo permite.

## 85. Handoff audit

**Pregunta clave**: ¿una nueva sesión puede comprender CCP usando solamente este MASTER
+ acceso al repositorio?

Comprobaciones:
- **Arquitectura**: §1 + §4 + §28. Cubre componentes ejecutables + artefactos + actores.
  **VERDICT: SURVIVES**.
- **Historia**: §2 lista solo eventos que cambiaron modelo. **SURVIVES**.
- **Decisiones**: §7 lista 13 con distinción tipo/urgencia. **SURVIVES**.
- **Dependencias**: §8 dependencias explícitas + latentes. **SURVIVES**.
- **Incertidumbres**: §6 lista 11 UNKNOWNs con impacto y bloqueadores. **SURVIVES**.
- **Evidencia**: §5.3 formato detallado con confidence; EV-* referenced. **SURVIVES**.
- **Estado**: §3 baseline verificable con comandos. **SURVIVES**.
- **Siguiente etapa**: §22 + §77 propone orden K3 + trayectoria recomendada. **SURVIVES**.

**Debilidad detectada**: el MASTER asume que el lector puede consultar `K3/*.md` cuando
necesita detalle profundo. Sin acceso a K3, el MASTER solo es incompleto para
falsifiers y evidencia cross-verificada. **CORRECCIÓN**: se explicita en §0 y en el
índice; el reader debe tener acceso a `K3/` y `docs/00_SYSTEM/ROOT_ANALYSIS/`.

---

## 86. Projection audit

Para cada recomendación clave:

- **T1 (DEC-11 H2)** — recomendación derivada de "governance decay monotónico"
  (K3-D-EPIST-COST, `SUPPORTED`). Evidencia contraria: si Owner nunca revisita,
  política vacía. Sesgo: K3 favorece formalización; no considera coste burocrático
  serio. **VERDICT: SURVIVES**; **REFORMULATION**: añadir explícito que "policy vacía
  si no se ejerce". Ya está en §13.11 y §66.
- **T2 + T3 (Bloque A)** — recomendación derivada K3-D-DELEG-FIRST + K3-D-DELEG-ORTOGONAL.
  Evidencia contraria: en S1 estable, K3-D-OWNER-DEFAULT no genera daño observado.
  Sesgo: K3 asume S2/S3 al horizonte. **VERDICT: SURVIVES with CONDITION**:
  recomendación depende de si Owner planea escalar a S2/S3. Si sólo S1 estable,
  path A (T1 solamente) puede ser suficiente. **CORRECCIÓN**: §19 condiciona.
- **T8 (D5 + PAC shadow)** — recomendación derivada de "preservar optionality" +
  "generar datos antes de decidir". Evidencia contraria: PAC-EF-02 sugiere que datos
  ya muestran problemas. Sesgo: K3 sobrestima el valor de datos adicionales. **VERDICT:
  SURVIVES**; el argumento "20+ policies reveal more FP classes" es sólido, no derrocado
  por 1 FP class.
- **T9 (DEC-04 D4)** — recomendación **condicional**, no directa. Confianza 40%. Se
  presenta como "considerar sólo si datos T8 son favorables". **SURVIVES**.

**Confusión impact vs benefit**: T9 tiene high impact + medium benefit (dado FP risk).
Distinción preservada en §17.

**Confusión complexity vs risk**: T9 introduce complejidad estructural (motor + YAML)
como riesgo (bug potencial). Se distinguen en §17 (complejidad útil) vs §16 (regresión).

**Regresiones ignoradas**: revisadas §16; MIX explicitado para MAINTAINABILITY.

**Dependencias omitidas**: §8 mapea explícitas + latentes; §22 optimiza orden.

---

## 87. DEC-04 audit específico

Ataques:

- **Falsa dicotomía**: ¿"manual vs PAC"? K3 §06.5 identifica 7 puntos viables. **SURVIVES**;
  el MASTER lo refleja explícitamente en §10.1 y §58.4.
- **Representación confundida con autoridad**: ¿YAML dice qué política existe (representación)
  o dice quién puede editarla (autoridad)? Confusión potencial. **CORRECCIÓN**: agregar
  a §10.3 que autoridad de policy = quien edita canónica; en YAML es "policy author"
  (posiblemente distinto de developer). Ya explicitado.
- **Enforcement confundido con policy**: firewall es enforcement, no policy. **SURVIVES**;
  el MASTER distingue policy (canónica) de enforcement (firewall derivado).
- **Test confundido con normative source**: D3 usa tests como canónica. Si el test valida
  la policy, ¿el test define la policy o expresa la policy? **HYPOTHESIS**: en D3 los
  tests **son** la policy (tests-as-contract). Discusión merece más detalle. **WEAKENED**:
  falta análisis profundo de D3 vs D1/D4 en este dimensión.
- **Derivación obligatoria sin probarlo**: ¿es necesario DERIVE en runtime, o es cheap
  hacerlo manualmente? Con < 25 policies, manual es factible. **REFORMULATION**: DEC-04
  D5 (defer) es válida hasta PT-2 (100+ policies). Presente en §13.4 y §55.
- **Lock-in subestimado**: DEC-04 es la única high-lock-in; K3 lo marca correctamente
  [K3 §11.10]. **SURVIVES**.
- **Arquitectura híbrida omitida**: F (multi-canónica por dominio) fue omitida por K3.
  Presentada en este MASTER §25 y §10.2. **CORRECCIÓN**: agregada explícitamente.

**Evidencia adicional que cambiaría la recomendación**:
- Si nuevo prototipo demuestra parser Markdown restringido cubre 90% del corpus, D1
  domina D4 en ergonomía.
- Si corpus real de 30+ policies muestra ≥ 3 FP classes distintas, D4 pierde peso.
- Si equipo declara doc humana no es valor propio, D2 se hace viable.

---

## 88. Trajectory audit

Ataques a la trayectoria recomendada (§77):

- **¿Existe orden mejor?** Alternativa: T2 antes que T1. Razonamiento: T2 puede correrse
  sin T1 (no requiere formalizar F9-D01 revisit). **SURVIVES**: T1 primero es preferible
  porque establece framework para futuros revisits (incluyendo T7/T9); T2 puede ejecutarse
  simultáneamente.
- **¿Alguna decisión temprana invalida posterior?** T1 (DEC-11 H2) no invalida ninguna;
  facilita todas. T2/T3/T4 no invalidan. T8 (shadow) no invalida. T9 puede invalidar
  D1/D2/D3/D5 si se ejecuta. **SURVIVES**: recomendación coherente.
- **¿Alguna decisión debería convertirse primero en experimento?** T9 lo hace (T8 es
  su experimento). T12 tiene T11 como experimento. **SURVIVES**.
- **¿Se compra demasiado lock-in demasiado pronto?** T9 introduce alto lock-in.
  Recomendación: **NUNCA antes de T8 + evidencia**. **SURVIVES**.
- **¿Ruta menor riesgo con casi mismo valor?** Path B pure (T1..T4 + T13) es esa ruta.
  Presentada como alternativa en §77. **SURVIVES**.
- **¿Ruta que aumenta más el valor de decisiones siguientes?** Trayectoria recomendada
  (T1 → Bloque A → T5+T8 → data-based decisions) maximiza compound value. **SURVIVES**.

---

## 89. Evidence audit

Para cada claim importante:

- **"CCP tiene 10 hooks + 1 lib = 509 líneas"**: `wc -l .claude/hooks/*.sh
  .claude/hooks/lib/*.sh`. **VERIFIED**.
- **"STALL log 18 líneas al cierre K3"**: K3 RESEARCH_LEDGER §Baseline. **VERIFIED**;
  reproducible `wc -l docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`.
- **"14/18 son harness noise"**: K3-D4. **VERIFIED** por inspección jq.
- **"had_alternative hardcoded en stall-record.sh:46"**: K3-D1. **VERIFIED** por lectura
  directa.
- **"session_id null en 18/18 eventos"**: K3-D-CAP3. **VERIFIED** por `jq -r '.session_id'`.
- **"ARCH-001..004 activas"**: DECISION_REGISTRY.md. **VERIFIED**.
- **"F9-D01..D05 cerradas 2026-09-20"**: F9_OWNER_DECISIONS.md. **VERIFIED**.
- **"EV-001..EV-016 en registry"**: `grep -c "^## EV-" EVIDENCE_REGISTRY.md` = 17
  (16 + 1 template). **VERIFIED**.
- **"maintenance 12/12 PASS al cierre F8"**: audit muestreó 5 checks PASS
  [RA audit §6.1]. `VERIFIED en fracción muestreada`; recomienda ejecución completa
  como validación de este MASTER.
- **"PAC corpus 24 IDs = 23 policies + 1 normalization"**: `ccp_policies.yaml` audit.
  **VERIFIED con matiz**.

**Claims huérfanos**: `K3-D-EXOGENOUS` (`HYPOTHESIS`, marcado); `K3-D-SUBSTRATE-FRACTION`
(`HYPOTHESIS`, marcado); K3-D-DELEG-FIRST (`recomendación derivada`, no evidencia).

**Referencias débiles**: ninguna material.

**Conclusiones heredadas sin verificación**: audit Kimi ya corrigió "STALL 3 eventos";
K3 y este MASTER usan el conteo real.

**Números históricos como current state**: EV counts, decision counts, STALL counts —
todos verificados al cierre K3.

**Documentación como runtime truth**: el MASTER distingue policy (documentada) de
enforcement (mecánico) en §37.

---

## 90. Recommendation bias audit

¿Está el análisis anclado por K3, RA, o audit previos?

- **K3 anchoring**: sí, alto. El MASTER hereda K3-D-DELEG-FIRST y K3-D-CANONICAL-CENTRAL.
  Contra-check: si nunca hubiéramos leído K3 y solo el repositorio + registries, ¿la
  conclusión "Bloque A + DEC-11 primero" habría emergido? **Probablemente sí** — la
  observación de que rules-md tiene placeholders, deferrals sin trigger, y sin catálogo
  de tipos es directa. Sin K3, la formulación sería más pobre pero la dirección similar.
- **PAC anchoring**: reducido. El MASTER trata PAC como implementación específica de
  DERIVE, no como salvadora (K3-D-DERIVE-ONLY). **SURVIVES**.
- **Root Analysis anchoring**: reducido por el audit intermedio que corrigió R1..R5.
  **SURVIVES**.
- **Audit anchoring**: sí, moderado. El audit degradó afirmaciones específicas (STALL
  count, R1..R5). Sin audit, este MASTER heredaría afirmaciones débiles.
- **Opciones ya redactadas anchoring**: sí. Las 5 arquitecturas A..E podrían no cubrir
  todo (§25 añade F/G/H/I/J).
- **Arquitectura actual anchoring**: parcialmente. El MASTER asume que la topología
  estrella persiste; T8 y T9 no la cambian (T12 sí parcialmente).

**Contra-reconstrucción independiente**: aplicada en §1 (perspectivas neutrales) y §4.
Coherente con la construcción K3 §02.

---

## 91. Countermodel test

Modelos alternativos que contradirían la recomendación:

- **Countermodel A**: "CCP está sobre-formalizado; menos gobernanza + más velocidad
  agrega más valor". Si esto es cierto, DEC-11 y Bloque A son over-engineered para S1.
  **¿Qué tendría que ser verdad?** Que la fricción de governance actual excede el
  beneficio de eliminar zonas grises. **¿Qué evidencia lo descartaría?** Reportes de
  fricción por reviewer humano; INC-* causados por ambigüedad de gobernanza.
- **Countermodel B**: "el reviewer humano es el bottleneck real; automatizar CAP-2s ya"
  (opuesto a K3-D-AUTHZ-VS-VERIF). Si esto es cierto, DEC-07 F2 debería ser primera
  decisión, no DEC-11. **¿Qué tendría que ser verdad?** Que gran parte del tiempo de
  reviewer es verificación sintáctica, no autorización. **¿Qué evidencia lo descartaría?**
  Time-tracking de reviewer mostrando autorización > verificación (soporta K3-D-AUTHZ-VS-VERIF).
- **Countermodel C**: "el sistema entero es sobre-diseñado; regresar a un shell script
  simple + reviewer humano ex-post". Si cierto, todo el CCP es waste. **¿Qué tendría
  que ser verdad?** Que INV-1..INV-8 no aportan valor observable. **¿Qué evidencia lo
  descartaría?** INC-001 (evidence gate previno lo que la simple review no habría
  detectado); cada EV representa un contrato humano que sin gate no habría existido.

Countermodels **debilitan pero no derrocan** las recomendaciones. Se mantienen para
futuras reconsideraciones.

---

## 92. Final audit verdict por parte

| Parte | SURVIVES | WEAKENED | REFORMULATED | REFUTED | UNKNOWN |
|---|---|---|---|---|---|
| I Handoff | §1–§9 | §5.3 (WOW findings tratados con label, no como hecho) | §10.5 (DEC-04 sub-decisions expansion) | §4.3 counterfactuals (no como evidencia) | UNKNOWNs marcados en §6 |
| II Projection | §12–§20, §22–§27 | §18 percentages con caveat de argumentación | §21 VOI reforzada | ninguna | Confianza <60% en varias opciones |
| III Puzzle | §28–§56 | §56F scorecard (números sujetos a re-check) | §31.13 (temporal pieces exit condition) | §54 rechazos (D2, D3 sin experimento) | Fit percentages son evaluaciones |
| IV Execution | §57–§84 | §67 uncertainty tabla | §61 bridges con condición retiro | §68 candidatos rechazados | Trayectoria alternate si S1 permanente |
| V Audit | §85–§92 | §90 bias reconocido | §85 debilidad de comprensión sin K3 | ninguna | Countermodels preservados |

---

## 93. Correction pass log

Correcciones aplicadas in-place al MASTER durante el audit:

1. **§0 y §85**: explicitado que MASTER requiere acceso al repositorio + K3/ +
   `docs/00_SYSTEM/ROOT_ANALYSIS/` para reconstrucción completa. No es standalone.
2. **§13.4 D4**: agregado matiz "sub-decisiones DEC-04-refined" (§10.5) para no forzar
   binaria.
3. **§25**: agregadas arquitecturas F/G/H/I/J que K3 no lista explícitamente.
4. **§27 Master Owner Surface**: `Confidence` reducida a rango realista; recomendación
   T9 explícitamente condicionada.
5. **§54**: rechazos explícitos (D2, D3 sin experimento).
6. **§61 Bridges**: cada bridge con condición de retiro requiere DEC-11 H2 upstream.
7. **§77 Trajectory recomendada**: no es orden autorizado; es análisis. Cada fase requiere
   owner ACK.
8. **§92 audit verdict**: WEAKENED items requieren consideración adicional del Owner.

Ninguna contradicción conocida sin resolver dentro del scope de este MASTER.

---

## 94. Master audit summary

**CONFIRMED**:
- CCP topología estrella con humano-sink; K3-D-STAR.
- 13 decisiones abiertas reales; K3-D-DECISION-COUNT.
- F9-D01=A es gate epistemológico dominante; K3-D-F9D01-BOTTLENECK.
- GAP-1 = ausencia de DERIVE; K3-D-DERIVE-ONLY.
- Autorización ≠ verificación; K3-D-AUTHZ-VS-VERIF.
- DEC-04 única high-lock-in.
- Bloque A + DEC-11 low-cost + transversal.
- Path B pure es alternativa robusta al Path completo.

**WEAKENED**:
- Recomendación de trayectoria depende de escenario planeado (S1 vs S2+).
- Confianza en DEC-04 D4 es 40% — no recomendable sin experimento previo.
- Percentages son evaluaciones argumentadas, no probabilidades.

**REFORMULATED**:
- DEC-04 refined en 5 sub-decisiones (§10.5).
- 5 arquitecturas + 5 no listadas (§25).
- Bridges requieren condición de retiro explícita (§62).

**REFUTED**:
- "18 → 5 collapse" numérico (RA); reformulado a 13 decisiones abiertas.
- "STALL 3 eventos" (RA); realidad 18 líneas.
- "PAC como missing piece" (RA); reformulado a "capacidad DERIVE ausente".
- "Root principle" como estructural CCP-specific; es design principle general.

**UNKNOWN**:
- U-01 H-01 materiality — bloqueado por F9-D01.
- U-05 CAP-2s mecanizable — requiere experimento.
- U-09 correlated failure LLM — requiere experimento.
- U-08 PAC FP rate general — requiere corpus.

**DECISIONS REQUIRING OWNER**:
- DEC-01, DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-08, DEC-10, DEC-11, DEC-12
  (10 decisiones activas).
- DEC-13 (external trigger).

**DECISIONS REQUIRING MORE EVIDENCE**:
- DEC-04 (T8 experiment).
- DEC-07 (T11 experiment + U-05, U-09).
- DEC-08 G2 (formal F9-D01 revisit via DEC-11).

**HIGHEST-LEVERAGE DECISIONS**:
1. DEC-11 (halts governance decay + formalizes revisits).
2. DEC-04 (architectural transformation with lock-in).
3. DEC-02 (K3-D-DELEG-ORTOGONAL; enables DEC-07).

**HIGHEST-RISK DECISIONS**:
1. DEC-04 D4 sin experimento (lock-in + FP class risk).
2. DEC-07 F2 sin U-09 medido (correlated failure).
3. DEC-08 G2 sin DEC-11 (precedente ad-hoc).

**HIGHEST-LOCK-IN DECISIONS**:
1. DEC-04 (única hard-to-reverse).
2. DEC-07 F2 (provider dependency).
3. DEC-05 E2 (motor formato).

**MOST REVERSIBLE FIRST MOVES**:
1. DEC-11 H2 (T1).
2. DEC-02 B2 (T2).
3. DEC-01 A2 (T3).
4. DEC-03 C2 (T4).
5. DEC-12 I4 (T13).
6. DEC-08 G3 shadow (T5).
7. DEC-04 D5 + PAC shadow (T8).

**CRITICAL DEPENDENCIES**:
- DEC-11 → DEC-08.
- DEC-01 → DEC-02.
- DEC-02 → DEC-07.
- DEC-04 → DEC-05 → DEC-06.
- F9-D01 → DEC-08.

**CRITICAL FALSIFIERS**:
- F-M2: CAP-2s mecanizable ≥ humano → D2 se reduce a "sólo máquina".
- F-M3: cambio de topología (no substrate) elimina meta-doc → K3-D-EXOGENOUS falso.
- F-M4: 18 STALL events con clasificación TP → K3-D-SCHEMA parcial resoluble.
- F-D4-1: PAC FP rate > 5% en corpus 30+ → DEC-04 D4 débil.

---

## 95. Ejecución futura — preparación (sin implementar)

Para cada decisión que **eventualmente sea aprobada por el Owner**, estructura lista:

### 95.1 Template

```text
DECISION            : DEC-XX
APPROVED OPTION     : [option code]
PRECONDITIONS       : [list]
INITIAL STATE       : [description]
EXPECTED STATE      : [description]
FILES/COMPONENTS    : [list]
ARCHITECTURAL CHANGES: [list]
INVARIANTS          : [preserved / extended / new]
TESTS               : [list required]
RISKS               : [top 3]
ROLLBACK            : [procedure]
EVIDENCE REQUIRED   : [list]
DONE CRITERIA       : [list]
NEXT DECISION UNLOCKED: [DEC-YY]
```

### 95.2 Ejemplos (los 3 más críticos)

**DEC-11 H2** (T1):
```text
PRECONDITIONS       : ninguna
INITIAL STATE       : 4 deferrals sin trigger declarado
EXPECTED STATE      : 4 deferrals con trigger + calendar review
FILES               : docs/00_SYSTEM/DEFERRAL_POLICY.md (new)
                      docs/00_SYSTEM/F9_OWNER_DECISIONS.md (add trigger)
                      docs/CONTROL_PLANE_HANDBOOK.md (reference)
ARCH CHANGES        : ninguno runtime; policy doc
INVARIANTS          : preserved; nuevo (informal): "every deferral has trigger"
TESTS               : none automatic (H2); H3 adds runbook check
RISKS               : reviewer omite trimestral (mitigable con H3 posterior)
ROLLBACK            : git revert
EVIDENCE            : policy doc review by Owner
DONE                : policy adopted + 4 deferrals updated + first quarterly review scheduled
NEXT UNLOCKED       : DEC-08 G2 (formal revisit precedent)
```

**DEC-02 B2** (T2):
```text
PRECONDITIONS       : DEC-01 A2 aprobada preferible (categorías)
INITIAL STATE       : sin registry; K3-D-OWNER-DEFAULT vigente
EXPECTED STATE      : DELEGATION_REGISTRY.md con 3+ entradas iniciales
FILES               : docs/00_SYSTEM/DELEGATION_REGISTRY.md (new)
                      docs/CONTROL_PLANE_HANDBOOK.md (reference)
ARCH CHANGES        : ninguno runtime
INVARIANTS          : preserved; INV-4 e INV-8 strengthened
TESTS               : none automatic; format check optional (B3)
RISKS               : registry vago o no ejercido
ROLLBACK            : git revert
EVIDENCE            : registry populated + Owner ACK
DONE                : 3 delegations documented + review cadence declared
NEXT UNLOCKED       : DEC-07 (delegated verification)
```

**DEC-04 D5 + shadow experiment** (T8):
```text
PRECONDITIONS       : ninguna
INITIAL STATE       : dual manual; PAC prototype en docs/research/
EXPECTED STATE      : PAC compilation en CI comparativo (shadow); log divergencias
FILES               : .github/workflows/pac-shadow.yml (new; CI-only, no runtime effect)
                      docs/research/pac/ccp_policies.yaml (expand to 30+ policies)
ARCH CHANGES        : ninguno runtime; CI check adicional
INVARIANTS          : preserved
TESTS               : shadow compilation succeeds; divergence log parseable
RISKS               : shadow overhead cost
ROLLBACK            : disable CI job
EVIDENCE            : 3 meses de shadow + FP rate + 20+ policies
DONE                : reporte con datos + decision-ready para DEC-04
NEXT UNLOCKED       : DEC-04 D4 con datos (o rechazo con datos)
```

**No implementar durante esta tarea**; MASTER prepara ejecución.

---

## 96. Prueba final de completitud

Una nueva sesión recibe `MASTER_HANDOFF.md + repositorio`. ¿Puede responder sin leer
K3 completo?

1. ¿Qué es CCP? — **§1.** Sí.
2. ¿Qué problema resuelve? — **§1**, **§1.1 5 perspectivas**. Sí.
3. ¿Qué arquitectura existe hoy? — **§1.2, §1.3, §4.1, §28.** Sí.
4. ¿Qué produjo K3? — **§2** (historia) + **§5** (24 K3-D + 7 WOW). Sí.
5. ¿Qué descubrió realmente? — **§5.3** (formato detallado por descubrimiento crítico) +
   **§5.1** (tabla completa). Sí, para top-impact.
6. ¿Qué está demostrado? — labels VERIFIED en §5.1 y §89. Sí.
7. ¿Qué es hipótesis? — labels HYPOTHESIS. Sí.
8. ¿Cuáles son las decisiones? — **§7.1** tabla 13. Sí.
9. ¿Qué opciones tiene cada una? — **§13** análisis por decisión. Sí.
10. ¿Qué sucede con cada opción? — **§13** + **§14 BEFORE→AFTER** + **§15 scenarios**. Sí.
11. ¿Qué decisiones dependen de cuáles? — **§8** dependencias. Sí.
12. ¿Qué pasa si se decide en otro orden? — **§22** decision order + **§77** paths. Sí.
13. ¿Qué regresiones existen? — **§16 regression engine**. Sí.
14. ¿Cuál es el impacto arquitectónico? — **§13** + **§51** assembly state tables. Sí.
15. ¿Cuál es la confianza de cada evaluación? — **§18 percentages + §92 audit**. Sí.
16. ¿Qué falta saber? — **§6 unknowns**. Sí.
17. ¿Qué debe decidir Owner? — **§9 owner surface + §27 owner table**. Sí.
18. ¿Qué debería observarse primero? — **§72 best first move + §77 trajectory**. Sí.
19. ¿Cuál es la trayectoria de transformación? — **§77 + §83 certificates**. Sí.
20. ¿Cómo se convierte la decisión aprobada en ejecución verificable? — **§95 templates**.
    Sí.

**Ningún punto exige volver a leer K3 completo para respuesta ejecutiva**. Para
falsifiers detallados y evidence cross-verificada, K3 sigue siendo necesario. Esto
es esperado; MASTER es índice ejecutivo, K3 es archivo de reproducibilidad.

---

# ANEXOS

## Anexo A — Jerarquía de verdad y provenance (ampliada)

Ver §0. Aplicada consistentemente en labels a lo largo del MASTER.

**Provenance por sección**:
- Sección §1 (CCP explicación): K3 §02 (reconstrucción independiente) + `.claude/hooks/*`.
- Sección §2 (historia): git log + PROJECT_STATE + F9_OWNER_DECISIONS.
- Sección §3 (baseline): comandos reproducibles + K3 RESEARCH_LEDGER.
- Sección §4 (arquitectura): K3 §02, §09, §10, §11.
- Sección §5 (descubrimientos): K3 §12 §5 + audit §5 claim inventory.
- Sección §6 (unknowns): K3 §08.
- Sección §7 (decisions): K3 §11 + §13.
- Sección §8 (dependencies): K3 §11.5.
- Sección §10 (DEC-04 deep): K3 §06.5, §11.10, §13.5 + audit §11.
- Sección §13-§27 (Projection): K3 §13 + inference K3 §06, §07, §09.
- Sección §28-§56 (Puzzle): K3 §02 + §04 + §10 + inference.
- Sección §57-§84 (Execution): K3 §06.4, §09.7-8 + inference.
- Sección §85-§96 (Audit): audit `11_KIMI_ROOT_ANALYSIS_AUDIT.md` metodología aplicada.

## Anexo B — Piece catalog completo

Ver §28.1 (top-level) y §29 (geometry). Cada pieza reproducible con inspección del
repo.

## Anexo C — Terminal condition checklist

Del prompt §96 aplicado:

```text
[✓] El CCP actual está modelado como ensamblaje                       §28
[✓] Las piezas importantes están identificadas                         §28.1
[✓] Sus interfaces están identificadas                                 §29, §30
[✓] Sus dependencias están identificadas                               §8, §46
[✓] Cada decisión puede representarse como movimiento                  §31
[✓] Cada opción puede simularse                                        §13, §31-§46
[✓] El impacto local está modelado                                     §32
[✓] El impacto global está modelado                                    §33, §34
[✓] Las regresiones están modeladas                                    §16
[✓] La pérdida de información está modelada                            §38
[✓] Los invariantes están comprobados                                  §37
[✓] La trazabilidad bidireccional está comprobada                      §39
[✓] Las combinaciones relevantes fueron exploradas                     §43, §56B
[✓] Las arquitecturas emergentes fueron buscadas                       §25, §56B
[✓] Se identificaron piezas obsoletas                                  §42
[✓] Se identificaron piezas redundantes                                §41
[✓] Se identificaron adapters posibles                                 §50
[✓] Se identificaron movimientos reversibles                           §49
[✓] Se identificaron puntos de lock-in                                 §8.4, §80
[✓] Se compararon trayectorias                                         §24, §77
[✓] Se auditó el ensamblaje completo                                   §56A
[✓] Se preservó la incertidumbre                                       §6, §67
[✓] Se preservaron contradicciones                                     §6.2, §16 MIX cells
[✓] La compresión no perdió relaciones críticas                        §90 bias audit
[✓] El MASTER puede reconstruir razonamiento esencial de K3            §96
[✓] El resultado fue adversarialmente atacado y corregido              §85-§93

Execution engine adicional (§143 del prompt):
[✓] Cada decisión importante tiene execution candidates                §58
[✓] Las opciones y las ejecuciones están separadas                     §57
[✓] Existen variantes de transición                                    §58 (Min/Bal/Full/Shadow)
[✓] Cada candidato tiene estado inicial y objetivo                     §58
[✓] Cada candidato tiene delta estructural                             §58 + §52
[✓] Cada candidato fue simulado                                        §63, §64
[✓] Los estados intermedios fueron analizados                          §63
[✓] Las regresiones de transición fueron analizadas                    §63, §64
[✓] Existe rollback realista                                           §65
[✓] Existe evidence gate                                               §66
[✓] Existen abort / rollback / reassess conditions                     §66
[✓] Los candidatos incompatibles fueron eliminados                     §68
[✓] Se conservaron las configuraciones supervivientes                  §69, §70
[✓] Se buscaron adapters y bridges                                     §61
[✓] Se analizaron piezas temporales                                    §62
[✓] Se comparó valor arquitectónico vs facilidad de ejecución          §60
[✓] Se identificó el mejor primer movimiento separado del estado final §72
[✓] Se evaluó option value                                             §79
[✓] Se evaluó lock-in gradient                                         §80
[✓] Se evaluó execution friction                                       §81
[✓] Se evaluaron trayectorias de transformación                        §77
[✓] Se buscó la mejor secuencia, no solamente el mejor movimiento      §77
[✓] Configuraciones supervivientes fueron auditadas adversarialmente   §86, §88, §92
```

**Condición terminal satisfecha**.

---

## STOP

Este documento **no autoriza** implementación. No modifica runtime, hooks, policies,
registries ni decisiones del Owner. Es un **mapa operativo y decisional de alta
fidelidad** para el CCP; el siguiente eslabón es el **Owner**, no M009.

Cualquier ejecución de las decisiones aquí analizadas requiere:
1. Owner explicit ACK por decisión.
2. Contrato de tarea (CONTRACTUAL TASK per ARCH-004).
3. Evidence gate como en F1..F8.
4. Independent verification.

**FIN MASTER HANDOFF.**
