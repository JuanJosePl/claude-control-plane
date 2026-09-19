# MASTER EVOLUTION ROADMAP — Claude Control Plane

**Fecha:** 2026-09-17
**Version:** 2.0 (behavioral audit anexado 2026-09-18)
**Estado:** RESEARCH · DESIGN · NOT IMPLEMENTED
**Alcance:** evolucion posterior a F6 (POST-FINAL-AUDIT)
**Regla suprema:** `BENEFIT > COMPLEXITY`
**Preserva:** `docs/00_SYSTEM/POST_F6_AUDIT_REPORT.md` sin modificacion; F1-F6 sin re-litigar.

> **ANEXO 2026-09-18:** `docs/00_SYSTEM/BEHAVIORAL_RELIABILITY_AUDIT.md` agrega 11 bugs de
> comportamiento (5 P1, 4 P2, 2 P3) descubiertos por testing adversarial post-roadmap. Los
> hallazgos F-LOOP-01, F-BYPASS-01/02/03 y F-FALSE_PASS-01 elevan el scope propuesto de F7 y
> justifican considerar un **F7 Extended** o un **F7a Behavioral Fixes**. Ver §35 y §36 del
> audit.

> Documento canonico de evolucion. Complementa —no sustituye— `docs/MASTER_IMPLEMENTATION_PLAN.md`
> (contrato historico F1-F6) ni `docs/00_SYSTEM/POST_F6_AUDIT_REPORT.md` (consolidacion post-F6).
> Todo componente propuesto aqui esta en estado `PROPOSED` hasta que un owner apruebe una fase y
> registre EV-NNN correspondiente.

---

## 1. EXECUTIVE SUMMARY

El Claude Control Plane cerro F1-F6 con maintenance 9/9 PASS, evidencia EV-001…EV-008 verificada y
cero infraestructura duplicada. La pregunta que este roadmap responde no es "que mas construimos",
sino "que evolucion aporta valor real que el sistema actual no obtiene y que no este resuelto ya
por Claude Code, un proyecto abierto maduro o un estandar existente".

**Hallazgos rectores:**

1. **La mayor parte del ecosistema externo ya provee lo que se sospechaba faltar.** GitHub Spec Kit
   cubre spec-driven; obra/superpowers cubre skills operativas; OpenTelemetry GenAI cubre trazas;
   Stryker/mutmut cubren mutation en lenguajes soportados (no shell). Reutilizar > reinventar.
2. **El unico gap con evidencia concreta de riesgo silencioso es la integridad de evidence.**
   G-V1/G-Bob-2 (Tier 3 editable + sin politica de rerun) son P1 tecnicos, no P0 operativos.
3. **El unico gap con evidencia concreta de fricción operativa es TASK TRACKING SEMANTICS.**
   G-D3 requiere ADR (decision), no implementacion; hasta que se decida la semantica, cualquier
   codigo seria prematuro.
4. **Todos los P2 son documentales o de forma, no de substancia.** No justifican una fase propia.
5. **Los DEFER son correctos.** Fabricar incidentes, mutar regex sin bypass demostrado o abrir
   incidentes automaticamente son teatro exactamente del tipo que la auditoria bloquea.

**Recomendacion global:** una unica fase acotada (F7 — Evidence Integrity Hardening) que resuelve
G-V1/G-Bob-2/G-T1 sin infraestructura pesada, mas un ADR (no una fase) para G-D3. Todo lo demas es
DEFER, DOCUMENT o REUSE-EXTERNAL. Ningun P0. Ninguna urgencia.

**Estado post-roadmap:** F7 candidata queda formalmente propuesta con acceptance/rollback/evidence
criteria. La decision go/no-go corresponde al owner del proyecto, no a este documento.

---

## 2. VERIFIED BASELINE

### 2.1 Runtime revalidado el 2026-09-17

| Check | Resultado | Fuente |
|---|---|---|
| `evals/maintenance.sh` | 9/9 PASS (schema · installer · hooks · skills · incidents · state · evidence · docs · regression_budget) | Ejecucion directa esta sesion |
| `evals/state/state-integrity.sh` | `unchanged=PASS drift=DETECTED` | Ejecucion directa esta sesion |
| `evals/incidents/INC-001-*.sh` | `without_control=UNPROTECTED with_control=BLOCKED` | Ejecucion directa esta sesion |
| `/doctor` (10 checks) | PASS previa | POST_F6_AUDIT_REPORT §A |
| Working tree | 6 archivos docs modificados + 1 nuevo (POST_F6_AUDIT_REPORT) + 1 archive benigno | `git status --short` |
| Ultimo commit | `b6e8fd0 docs(context): add canonical Claude bootstrap instructions` | `git log --oneline -10` |

### 2.2 Inventario runtime

- **10 hooks** ejecutables en `.claude/hooks/` (`bash-firewall`, `secret-guard`, `task-completed-evidence`, `subagent-context`, `subagent-stop-logger`, `session-start-startup`, `session-start-compact`, `pre-compact-snapshot`, `config-change-logger`, `stop-logger`).
- **5 agentes** con tool limits (`architect`, `code-reviewer`, `implementer`, `researcher`, `security-auditor`).
- **22 skills** (6 context + 16 operacionales/verificacion).
- **4 rules** globales (`compliance`, `git-policy`, `no-go`, `security`).
- **6 context packs** (`CORE`, `CURRENT_STATE`, `DECISIONS`, `BUSINESS`, `SECURITY_RULES`, `NO_GO`).
- **1 CI workflow** (`.github/workflows/control-plane.yml`) que ejecuta `evals/maintenance.sh`.
- **1 incidente / control / regresion** (`INC-001` / `CTRL-001` / `REG-001`).
- **8 entradas de evidencia** VERIFIED (`EV-001`…`EV-008`); mas 1 schema.

### 2.3 Baseline vs POST_F6_AUDIT_REPORT

Coincide. Ninguna divergencia. El informe post-F6 sigue siendo canonico para su periodo. Cambios
documentales de la sesion actual (working tree) son intencionales para persistir la auditoria y
no alteran el runtime.

---

## 3. POST-F6 CONSOLIDATED STATE

Resumen (detalle canonico en `docs/00_SYSTEM/POST_F6_AUDIT_REPORT.md`):

| Categoria | Count | Estado |
|---|---|---|
| Fases completadas | F1-F6 | PASS con evidencia |
| Gaps P1 | 4 | G-V1, G-Bob-2, G-T1, G-D3 |
| Gaps P2 | 4 | G-S1, G-S2, G-Bob-1, G-A1 |
| Gaps DEFER | 3 | G-T2, G-M1, G-L1 |
| Gaps P0 | 0 | — |
| Fases pendientes | 0 | Ninguna aprobada |
| Fases candidatas | 1 | F7 Evidence Integrity Hardening (no iniciada) |

**Cambios documentales desde POST_F6_AUDIT_REPORT (esta sesion):** ninguno adicional al propio
informe y a los pointers ya existentes en Master Plan §10 y README. Este roadmap es la sexta pieza
documental (POST_F6_AUDIT es la quinta segun secuencia).

---

## 4. CURRENT ARCHITECTURE

```text
                          HUMAN
                            |
                            v
                        INTENT
                            |
                            v
   +----------------------------------------------+
   | CONTEXT LAYER   (que sabe el agente)         |
   |   CLAUDE.md · rules · context packs · skills |
   +---------------------+------------------------+
                         |
                         v
   +----------------------------------------------+
   | STATE LAYER     (donde esta el proyecto)     |
   |   PROJECT_STATE · DECISION · ARTIFACT ·      |
   |   EVIDENCE · INCIDENT · CONTROL · REGRESSION |
   +---------------------+------------------------+
                         |
                         v
   +----------------------------------------------+
   | CONTROL LAYER   (que se puede bloquear)      |
   |   settings.json · permissions · hooks P0/P1  |
   +---------------------+------------------------+
                         |
                         v
   +----------------------------------------------+
   | EXECUTION LAYER (quien ejecuta y con que)    |
   |   agents (5) · skills (22) · main agent      |
   +---------------------+------------------------+
                         |
                         v
   +----------------------------------------------+
   | VERIFICATION    (como se decide PASS/BLOCK)  |
   |   TaskCompleted · gate · reviewer · evals    |
   +---------------------+------------------------+
                         |
             +-----------+-----------+
             |                       |
           BLOCK                    PASS
             |                       |
             v                       v
        RECOVERY               EVIDENCE + LEARN
```

**Fuentes unicas:** `PROJECT_STATE.md` (estado), `DECISION_REGISTRY.md` (decisiones),
`ARTIFACT_MANIFEST.md` (entregables), `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` (evidencia),
`INCIDENT_REGISTRY.md` (incidentes), `CONTROL_REGISTRY.md` (controles), `REGRESSION_REGISTRY.md`
(regresiones). Espejos permitidos: `.claude/context/CURRENT_STATE.md`, `.claude/context/DECISIONS.md`.

**Enforcement layers activos:** L0 guidance (rules/CLAUDE.md) → L1 context (packs) → L2 workflow
(skills) → L3 permissions (settings.json allow/ask/deny) → L4 deterministic (maintenance suite) →
L5 blocking hook (bash-firewall, secret-guard, task-completed-evidence) → L6 independent review
(code-reviewer) → L8 human gate (documentado, no automatizado).

---

## 5. CURRENT CAPABILITY MATRIX

Semantica: `EXISTS` (esta en el runtime) · `ENFORCED` (bloquea real) · `VERIFIED` (existe evidencia)
· `EXTERNAL` (equivalente en un proyecto externo maduro) · `OVERLAP` (nuestro vs externo).

| # | Capability | Exists | Enforced | Verified | External equivalent | Overlap | True gap |
|---|---|---|---|---|---|---|---|
| 1 | Context packs por rol | ✔ | Guidance | EV-001 | Superpowers skill packs | Parcial | Ninguno |
| 2 | Estado operativo unico | ✔ | Guidance | EV-001 | Spec Kit constitution | Parcial | Ninguno |
| 3 | Memoria persistente cross-sesion | Parcial (memory/) | Guidance | — | claude-mem, obra | Alto | Semantica local |
| 4 | Permisos allow/ask/deny | ✔ | ✔ | Runtime | Nativo Claude Code | Total | Ninguno |
| 5 | Bash firewall | ✔ | ✔ L5 | Runtime | superpowers `dangerously-safe` skills, Aptible MCP gateway | Parcial | Sin fixture positivo (G-T1) |
| 6 | Secret guard | ✔ | ✔ L5 | Runtime | Trufflehog/Gitleaks, secret-guard patterns | Parcial | Sin fixture positivo (G-T1) |
| 7 | Evidence gate (TaskCompleted) | ✔ | ✔ L5 | EV-002/006 | Ninguno equivalente | Bajo | Snapshot editable (G-V1/G-Bob-2) |
| 8 | Independent code review | ✔ | Skill | EV-005 | Superpowers `requesting-code-review` | Alto | Ninguno |
| 9 | TDD lane | ✔ | Skill | EV-005 | Superpowers `test-driven-development` | Alto | Ninguno |
| 10 | Doubt-driven verification | ✔ | Skill | EV-005 | Superpowers `receiving-code-review` | Alto | Ninguno |
| 11 | Constraint-driven | ✔ | Skill | EV-005 | Ninguno amplio | Bajo | Ninguno |
| 12 | Incident learning loop | ✔ | Skill + registries | EV-006 | Ninguno completo (partial en SRE ecosystems) | Bajo | Rollback sin smoke (G-S1) |
| 13 | State integrity (hash/drift) | ✔ | Hook L1 | EV-007 | Ninguno equivalente | Bajo | Ninguno |
| 14 | Provenance semantics | ✔ | Schema | EV-007 | OTel GenAI + Trustdesc | Parcial | Ninguno |
| 15 | Deterministic maintenance | ✔ | CI | EV-008 | Superpowers eval suite parcial | Parcial | Ninguno |
| 16 | Regression budget | ✔ | Schema | EV-008 | Stryker score threshold (lenguaje) | Bajo | 1 solo sample (G-T2) |
| 17 | Task tracking semantics | Parcial | Documented gap | — | Spec Kit tasks · Claude Code TaskCreated/TaskCompleted nativos | Alto | G-D3 requiere ADR |
| 18 | Observability (traces) | ✘ | — | — | OpenTelemetry GenAI | Total | No hay evidencia de que se necesite |
| 19 | Mutation testing regex | ✘ | — | — | Stryker (JS/TS/.NET), mutmut (Python) — no cubre .sh | Bajo | G-M1 DEFER |
| 20 | Property-based tests para hooks | ✘ | — | — | Hypothesis, fast-check | Alto | No hay evidencia |
| 21 | Prompt injection defense (MCP) | Parcial (firewall bloquea) | — | — | MCP gateway, tool-description sanitization | Bajo | No usamos MCP hoy |
| 22 | Rollback smoke tests | ✘ | — | — | Ninguno canonico | Bajo | G-S1 |
| 23 | Documentation drift detection | ✔ | maintenance `docs=PASS` | EV-008 | mkdocs-linkcheck | Parcial | Ninguno |
| 24 | Recovery scenarios (E-1…E-9) | ✔ | Skill | Handbook §12 | — | — | Documentado, sin test automatico |
| 25 | Multi-agent orchestration | Parcial (main + subagents) | Nativo | EV-001 | Superpowers subagent-driven | Parcial | Ninguno |
| 26 | Worktree isolation | Nativo Claude Code | Nativo | — | Nativo | Total | Ninguno |
| 27 | Skill lifecycle governance | Documentado (Master Plan) | Guidance | — | Superpowers `writing-skills` | Alto | Ninguno |
| 28 | Cost / token telemetry | ✘ | — | — | OTel GenAI + LiteLLM | Total | No hay evidencia de necesidad |
| 29 | Cross-provider fallback | ✘ | — | — | LiteLLM, OpenRouter | Total | Fuera de alcance |
| 30 | Model routing | ✘ (fijado en agents) | — | — | Nativo Claude Code | Parcial | Ninguno |
| 31 | Configuration drift detection | Parcial (config-change-logger) | Log | — | Terraform drift · git-hooks | Bajo | Ninguno |
| 32 | Trust boundary declaration | Documentado | Guidance | — | Ninguno canonico | — | Ninguno |
| 33 | Self-modification guardrail | Parcial (firewall) | ✔ | — | Ninguno amplio | Bajo | Ninguno |
| 34 | Session log archive | ✔ (rotation) | Log | — | — | — | Ninguno |
| 35 | Tier 3 behavioral eval | ✔ | Snapshot | EV-005 | Superpowers behavioral fixtures | Parcial | G-V1/G-Bob-2 |

**Lectura:** de 35 capabilities, 27 existen con enforcement (77%), 8 no existen. De esas 8, solo 2
tienen evidencia de riesgo: `Tier 3 snapshot editable` (G-V1) y `Rollback smoke` (G-S1, P2). Las 6
restantes carecen de evidencia de necesidad → no justifican construccion.

---

## 6. EXTERNAL LANDSCAPE

Ecosistema investigado 2026-09-17. Cada entrada incluye tipo, autoridad, madurez, overlap con
nuestro sistema y decision de reutilizacion.

### 6.1 Anthropic / Claude Code nativos

- **Hooks:** eventos actualmente disponibles incluyen `SessionStart`, `SessionEnd`, `UserPromptSubmit`,
  `PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `PermissionRequest`, `Stop`, `FileChanged`,
  `CwdChanged`, `ConfigChange`, `SubagentStart`, `SubagentStop`, `TaskCreated`, `TaskCompleted`,
  `TeammateIdle`, `PreCompact`, `PostCompact`, `WorktreeCreate`, `WorktreeRemove`. Usamos 10;
  ninguno de los 10 sobrantes tiene evidencia de riesgo que justifique adopcion inmediata.
- **Skills:** ya usamos el patron nativo (frontmatter + SKILL.md). Ningun cambio necesario.
- **Subagents / TaskCreated / TaskCompleted:** nativos. `TaskCompleted` es el gate que ya explotamos.
- **PermissionRequest:** hook nuevo relevante si algun dia queremos loguear todas las requests
  humanas (observabilidad, no enforcement).

### 6.2 GitHub Spec Kit

- **Autoridad:** GitHub oficial (`github/spec-kit`).
- **Proposito:** spec-driven development (Specify → Plan → Tasks → Implement → Converge).
- **Integracion Claude Code:** soportada oficialmente.
- **Overlap con nuestro sistema:** ALTO (nuestro Master Plan es contrato, ArtifactManifest es
  entregables, `PROJECT_STATE.md` es constitution equivalente).
- **Decision:** **REUSE conceptualmente** para la semantica task/spec, no adoptar el CLI. Nuestro
  `MASTER_IMPLEMENTATION_PLAN.md` + `ARTIFACT_MANIFEST.md` ya cumplen el rol; agregar el CLI
  duplicaria fuentes de verdad.

### 6.3 obra/superpowers

- **Autoridad:** Jesse Vincent · Prime Radiant · MIT · ~237k stars.
- **Proposito:** framework de skills operativas + metodologia de desarrollo agentico.
- **Skills relevantes:** `test-driven-development`, `receiving-code-review`, `requesting-code-review`,
  `systematic-debugging`, `verification-before-completion`, `brainstorming`, `writing-plans`,
  `executing-plans`, `subagent-driven-development`, `writing-skills`, `using-git-worktrees`, otros.
- **Overlap:** ALTO. Muchas de sus skills tienen equivalente propio (`/test-driven-development`,
  `/code-review-and-quality`, `/doubt-driven-development`, `/constraint-driven-development`).
- **Decision:** **REUSE por co-existencia**. El usuario ya tiene superpowers instalado en su
  entorno (visible en el listado de skills). No importar el framework al repo; permitir que el
  operador humano use ambos.

### 6.4 anthropic-skills / anthropics/claude-code

- **Autoridad:** Anthropic oficial.
- **Skills relevantes:** `docs`, `pdf`, `pptx`, `xlsx`, `skill-creator`, `docx`.
- **Overlap:** BAJO. Son skills de output/formato, no de proceso.
- **Decision:** **NO IMPORT**. Cuando un flujo del control plane necesite emitir docx/pdf,
  invocar la skill nativa; no crear una propia.

### 6.5 OpenTelemetry GenAI Semantic Conventions

- **Autoridad:** CNCF · SIG GenAI activo desde 2024-04.
- **Estado:** GenAI y MCP semantic conventions en `Development` (no `Stable`).
- **Adoptado por:** Google Cloud, AWS, Azure, Datadog, MLflow.
- **Atributos:** `gen_ai.request.model`, `gen_ai.usage.input_tokens`, `gen_ai.usage.output_tokens`,
  `gen_ai.response.finish_reasons`, spans `invoke_agent`, `execute_tool`.
- **Overlap con nuestro sistema:** BAJO. Nuestro `CLAUDE_SESSION_LOG.md` captura eventos textuales
  no estructurados; provenance semantica esta en evidencia.
- **Decision:** **DEFER**. La observabilidad estructurada tiene sentido cuando hay multiples
  agentes en produccion o multiples proveedores. Un solo usuario con Claude Code no genera
  demanda medible. Si en el futuro un incidente demuestra que la falta de traza estructurada
  bloqueo un RCA, se reconsidera.

### 6.6 MCP tool poisoning (CVE-2025-54136, MCPTox 2025-2026)

- **Autoridad:** Truefoundry, Aptible, ITECS, Microsoft Security, papers arXiv 2604.07536, 2606.06387, 2606.20922, 2604.11790.
- **Amenaza:** tool description poisoning · confused deputy · runtime tool surface manipulation.
- **Escala 2026:** ~200k instancias MCP vulnerables documentadas; ASR >60% en benchmarks
  publicos.
- **Defensas:** allowlisting de tools, identity binding, runtime monitoring, human-in-loop.
- **Overlap con nuestro sistema:** BAJO — actualmente no usamos MCP en el control plane. El
  `bash-firewall` no protege contra MCP tool poisoning (fuera de su surface).
- **Decision:** **DOCUMENT como no-go boundary**. Si el proyecto adopta MCP, F8+ debera evaluar
  esquema de allowlist. Hoy no aplica.

### 6.7 Mutation testing

- **Stryker:** JS/TS/.NET/Scala. Regex mutations soportadas en Stryker.NET.
- **mutmut:** Python. No cubre shell.
- **Cobertura shell:** ninguna herramienta madura muta `.sh`. La logica de decision en shell
  escapa el regimen de mutation testing estandar.
- **Overlap con G-M1:** el gap G-M1 propone mutar patrones regex del firewall; ninguna herramienta
  externa lo hace nativamente. Requeriria implementacion bespoke.
- **Decision:** **DEFER (G-M1 confirmado como DEFER).** Solo se justifica si un incidente
  documenta bypass silencioso.

### 6.8 Property-based / metamorphic / fuzzing

- **Hypothesis (Python), fast-check (JS), QuickCheck (Haskell):** maduros para funciones puras.
- **Aplicabilidad a hooks bash:** limitada; requiere adapter que exponga hooks como funciones.
- **Overlap:** BAJO. Beneficio marginal frente a fixtures deterministas explicitos.
- **Decision:** **NO ADOPT** salvo evidencia de incidente por variacion de input no cubierta.

### 6.9 Uncle Bob Acceptance Pipeline / TDD ciclo cerrado

- **Autoridad:** guidance principled, no herramienta.
- **Overlap:** ALTO — nuestro contrato `RED → GREEN → REFACTOR → EVIDENCE` es exactamente el
  espiritu.
- **Decision:** **KEEP conceptualmente**, sin adopcion adicional de herramienta.

### 6.10 Fuentes no adoptadas y razones

| Fuente | Razon |
|---|---|
| LiteLLM cross-provider | Fuera de alcance; ARCH-001 fija stack a Claude |
| LangGraph / LangChain | Overhead alto vs Claude Code nativo |
| CrewAI / AutoGen | Orquestacion multi-agente que no necesitamos hoy |
| Guardrails.ai | Foco output validation; nuestro evidence gate es distinto |
| Rebuff / promptfoo | Adversarial testing; util si algun dia se integran evals de prompts |
| Vector DBs para memoria | ARCH-001: instalacion por proyecto; no necesitamos indice global |

---

## 7. SOURCE / EVIDENCE REGISTER

Cada fuente externa relevante consultada esta sesion.

| # | Source | Type | Date verified | Authority | Claim used | Confidence |
|---|---|---|---|---|---|---|
| S1 | github/spec-kit | Repo oficial | 2026-09-17 | GitHub | Spec-driven process Specify→Plan→Tasks→Implement→Converge | HIGH |
| S2 | obra/superpowers | Repo · marketplace | 2026-09-17 | Jesse Vincent · Anthropic marketplace | Skills framework ~237k stars, MIT, v6.0.3 | HIGH |
| S3 | Anthropic Claude Code docs (hooks) | Docs oficiales | 2026-09-17 | Anthropic | Events lifecycle: SessionStart, SubagentStart, TaskCompleted, PostToolUseFailure, PermissionRequest, PreCompact | HIGH |
| S4 | Truefoundry · Aptible · ITECS blog + arXiv 2604.07536/2606.06387/2606.20922/2604.11790 | Blog + paper | 2026-09-17 | Multiple | MCP tool poisoning; MCPTox ASR >60%; defensas | HIGH |
| S5 | OpenTelemetry GenAI SIG · MLflow docs · Uptrace · Greptime | Standards | 2026-09-17 | CNCF | GenAI semantic conventions status Development | HIGH |
| S6 | Stryker Mutator docs · mutmut · qaskills | Docs/Blog | 2026-09-17 | Multiple | Mutation testing no cubre shell | HIGH |
| S7 | POST_F6_AUDIT_REPORT.md | Interno canonico | 2026-09-17 | Control Plane | Baseline post-F6 verificado | HIGH |
| S8 | evals/maintenance.sh execution | Runtime | 2026-09-17 | Direct | 9/9 PASS actual | HIGH |
| S9 | Microsoft Security blog 2026-06-30 | Blog | 2026-09-17 | Microsoft | AI agents moving from reading to acting; defense-in-depth | MEDIUM |
| S10 | Master Implementation Plan §5-§10 | Interno canonico | 2026-09-17 | Control Plane | Contrato F1-F6 + gap register | HIGH |

**Provenance clasification:**
- EXTRACTED (S3, S7, S8, S10): runtime u official docs.
- INFERRED (S2, S4, S5, S6): de multiples fuentes concurrentes.
- EXTERNAL (S1, S9): fuentes de terceros verificadas.
- No hay entradas ASSUMED o GENERATED con impacto en decisiones.

---

## 8. REUSE / INTEGRATION MATRIX ("Do Not Rebuild")

| Capability | External solution | Native Claude | Current system | Decision |
|---|---|---|---|---|
| Hook lifecycle | — | Nativo | Usado | KEEP |
| Permissions matrix | — | Nativo | Usado | KEEP |
| Subagent orchestration | Superpowers subagent-driven | Nativo | Usado | KEEP |
| Worktree isolation | — | Nativo | No forzado hoy | REUSE-NATIVE cuando se necesite |
| Skills packaging | Superpowers, anthropic-skills | Nativo | Usado | KEEP |
| Spec/contract-driven | Spec Kit | — | MASTER_IMPLEMENTATION_PLAN | KEEP local; NO importar Spec Kit CLI |
| TDD workflow | Superpowers `test-driven-development` | — | Skill propia | KEEP local (co-existencia con external) |
| Code review workflow | Superpowers `receiving/requesting-code-review` | — | Skill propia | KEEP local (co-existencia) |
| Systematic debugging | Superpowers `systematic-debugging` | — | No existe local | ADOPT-VIA-EXTERNAL cuando aparezca demanda |
| Brainstorming | Superpowers `brainstorming` | — | No existe local | ADOPT-VIA-EXTERNAL cuando aparezca demanda |
| Docs/pdf/xlsx/pptx generation | anthropic-skills | — | — | REUSE-EXTERNAL bajo demanda |
| Telemetry / traces | OTel GenAI | — | Log textual | DEFER |
| Mutation testing | Stryker/mutmut (no shell) | — | — | DEFER (G-M1) |
| Property-based tests | Hypothesis/fast-check | — | — | NO ADOPT |
| Cross-provider routing | LiteLLM | — | — | OUT OF SCOPE |
| Prompt injection defense (MCP) | Aptible gateway | — | Firewall no cubre MCP | DEFER (only if MCP adopted) |
| Secret scanning | Trufflehog/Gitleaks | — | secret-guard hook | KEEP (hook complementario, no reemplazable por scanner offline) |
| Config drift | Terraform drift · git hooks | — | config-change-logger | KEEP |
| Documentation link check | mkdocs-linkcheck | — | maintenance `docs=PASS` | KEEP |

**Regla derivada:** ningun mecanismo nuevo se construye si un mecanismo nativo, externo maduro o
existente en el sistema lo cubre. Excepciones deben registrarse como ADR con evidencia.

---

## 9. TRUE GAP REGISTER (post-integracion externa)

Gaps confirmados tras aplicar la matriz de reuso. Los IDs coinciden con POST_F6_AUDIT_REPORT
donde aplica; se agregan gaps nuevos con prefijo `G-N`.

| ID | Problem | Evidence | Coverage | External | Overlap | Priority | Decision |
|---|---|---|---|---|---|---|---|
| G-V1 | Tier 3 snapshot editable | `evals/skills/results/*.json` sin freshness/session_id | contract_hash sha256 | Superpowers behavioral fixtures parcial | Bajo | P1 | Bundle F7 |
| G-Bob-2 | Sin politica rerun Tier 3 | Master Plan §5 F3 sin expiracion | Ninguna | Ninguna | Nulo | P1 | Bundle F7 |
| G-T1 | Firewall/secret-guard sin fixture positivo | INC-001 solo cubre TaskCompleted | `bash -n` | Superpowers eval suites parcial | Bajo | P1 | Bundle F7 |
| G-D3 | TASK TRACKING SEMANTICS ambigua | Sesion S232: 11 subtareas sin cerrar | Documentado Handbook §12 | Nativo `TaskCreated`/`TaskCompleted` refuerza el gap | Bajo | P1 | **ADR (no fase)** |
| G-S1 | Rollback documentado sin smoke | `CONTROL_REGISTRY.md:29` | Comandos docs | Ninguno | Nulo | P2 | Documentar en `/incident close` |
| G-S2 | Escape ambiguo en rollback (`sed` con `\\/\\/`) | `CONTROL_REGISTRY.md:29` | Ninguna | Ninguno | Nulo | P2 | Reformatear heredoc |
| G-Bob-1 | `fixtures.json` sin cabecera acceptance | `evals/skills/fixtures.json` | Handbook describe | Ninguno | Nulo | P2 | 1-line comment |
| G-A1 | Context packs propios con `{{}}` | `.claude/context/*.md` | Master Plan explicito | Ninguno | Nulo | P2 | Nota README |
| G-T2 | 1 sola regresion en el registro | `REGRESSION_REGISTRY.md` | `/incident` funciona | Ninguno | Nulo | DEFER | Esperar 2do incidente |
| G-M1 | Sin mutation regex firewall | Ninguna suite muta patrones | `bash -n` | Stryker no cubre shell | Nulo | DEFER | Solo si bypass demostrado |
| G-L1 | Apertura de incidentes manual | Master Plan §5 F4 justifica | Disciplina humana | Nativo `PostToolUseFailure` disponible | Alto (nativo existe) | DEFER | Reconsiderar si disciplina falla |
| G-N1 | Runtime revalidation manual | Hoy /doctor requiere iniciativa humana | Skill existe | Superpowers `verification-before-completion` | Alto | P2 | Documentar cadencia, no automatizar |
| G-N2 | Session log rotation sin retention policy | Archive dir aparece sin regla clara | Existe rotation | Ninguno | Nulo | P2 | Documentar politica breve |

**Total post-integracion:** 4 P1 (mismo count que POST_F6) + 4 P2 originales + 2 P2 nuevos (G-N1,
G-N2) + 3 DEFER. Ningun P0. Ninguna urgencia introducida por la investigacion externa.

**Cambios respecto al gap register anterior:**
- Se confirma que G-L1 tiene solucion nativa (`PostToolUseFailure`) — la decision DEFER se
  refuerza porque adoptarla requiere disciplina en su uso.
- Se agrega G-N1 (revalidacion manual) y G-N2 (retention) como P2 documentales.

---

## 10. TASK SEMANTICS (analisis + propuesta de ADR)

### 10.1 Problema

El hook `TaskCompleted` se dispara para cualquier `TaskUpdate → completed`, incluyendo subtareas
scaffolding del tracker. Consecuencia: cerrar 11 subtareas de auditoria requerian 11 entradas
`VERIFIED` con hashes — teatro.

### 10.2 Modelo propuesto (no implementado)

```text
USER INTENT
    |
    v
CONTRACTUAL TASK       <-- unica que pasa por Evidence Gate
    |
    v
INTERNAL SUBTASK       <-- scaffolding; NO requiere EV-NNN
    |
    v
ARTIFACT               <-- producto tangible
    |
    v
EVIDENCE               <-- vinculada a CONTRACTUAL TASK (no a subtareas)
    |
    v
GATE
```

### 10.3 Alternativas evaluadas

| Alternativa | Coste | Riesgo | Descartada porque |
|---|---|---|---|
| A. Tag `contractual: true/false` en el JSON del TaskCompleted | Bajo (schema change) | Bajo | Requiere disciplina para taggear; teatro potencial |
| B. Distinguir por presencia de `task_id` en registry (si no existe entry, no exigir) | Muy bajo | Medio | Silencioso; oculta contratos olvidados |
| C. Hook fail-open para `subtask=true`, fail-closed para `contractual=true` | Medio | Bajo | Requiere convention explicita |
| D. Ignorar TaskUpdate scaffolding en el hook (grep de patron) | Bajo | Alto | Fragil; heuristico |
| E. **ADR: definir contrato de tarea antes de tocar codigo** | Nulo (documento) | Nulo | **Recomendada.** |

### 10.4 Recomendacion

**ADR-004 (propuesto):** "Task Tracking Semantics". El hook `TaskCompleted` sigue validando por
`task_id`. Antes de ejecutar una tarea que pasara por el gate, el operador humano decide si es
`contractual` (requiere EV-NNN) o `internal` (no lo requiere, y por tanto no se marca
`completed`, se marca `deleted`). Convention documentada en Handbook §12. Sin cambio de hook.

**Beneficio:** cero cambio de codigo. Elimina fricción. Preserva enforcement contra evidence
theater. Coste operativo: recordar la distincion (documentada).

**No implementar** hasta que un owner apruebe el ADR. Este roadmap no crea el ADR; lo propone.

---

## 11. EVIDENCE ARCHITECTURE

### 11.1 Estado actual

Una entrada verifica: `task_id`, `Status: VERIFIED`, `Artifact Hash: sha256:...` (formato
verificado, no comparado contra el artifact real), `Contract Hash: sha256:...` (idem),
`Checks: tests=PASS static=PASS security={PASS|NOT_REQUIRED}`, `Reviewer: PASS|NOT_REQUIRED`,
`Exceptions: NONE|APPROVED:...`, `Timestamp: ISO-8601`, `Provenance:
EXTRACTED|INFERRED|ASSUMED|EXTERNAL|GENERATED`.

### 11.2 Debilidades demostradas

1. **Hash no recomputado:** `TaskCompleted` valida presencia y formato del hash, no que el hash
   coincida con el artefacto actual. Editar el registry + editar el artefacto pasa.
2. **Timestamp sin freshness policy:** un timestamp de hace un año seguiria siendo aceptado.
3. **Reviewer sin identidad:** `Reviewer: PASS` es texto libre; no vincula a un actor identificable.
4. **Provenance sin traza a input:** `GENERATED` no dice generado por que run o con que fixture.

### 11.3 Propuestas (bundle F7)

**11.3.a Freshness check (G-V1/G-Bob-2):**

- `maintenance.sh` extiende `evidence` check para leer cada `Tier 3` result JSON y verificar:
  - `session_id` no reutilizado entre runs consecutivos (fresh CLI invocation);
  - `timestamp` no anterior a N dias (default 30, configurable en `REGRESSION_BUDGET.json`).
- Rechazo si algun run Tier 3 rompe estos invariantes.

**11.3.b Artifact hash recompute (opcional, coste medio):**

- `maintenance.sh` recomputa `sha256sum` del artefacto declarado en `Affects:` y compara con
  `Artifact Hash:`. Rechazo si difieren.
- **Descartado en F7** — coste de implementacion vs beneficio marginal. Se registra como
  `G-N3 (proposed)` DEFER.

**11.3.c Reviewer identidad:**

- Documentar convention: `Reviewer: PASS (code-reviewer@fresh-context)` o
  `Reviewer: PASS (human/@owner)`. Sin cambio de codigo. Sin schema break.
- **F7 lo incluye como documentacion, no como enforcement.**

### 11.4 Fuera de F7

- Firma criptografica de evidence (PGP, ed25519) — coste alto, beneficio marginal.
- Merkle tree o append-only log — sobrediseño para el volumen actual.
- Blockchain evidence — teatro puro; explicitamente NO.

---

## 12. TRUST BOUNDARY

### 12.1 Superficie confiable actual

| Componente | Modificable por el agente | Verificable independientemente | Riesgo |
|---|---|---|---|
| `.claude/hooks/*.sh` | Si (Write/Edit permitido salvo secret-guard) | Solo por revision humana | Medio |
| `.claude/settings.json` | Si (mismo) | `jq empty` + revision humana | Medio |
| `evals/maintenance.sh` | Si | Solo por revision humana | Medio |
| `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` | Si | Solo por hash recompute (no hoy) | Medio |
| `evals/skills/results/*.json` | Si | Freshness check (F7 propuesto) | Medio (G-V1) |
| `PROJECT_STATE.md` | Si | Hash critico en PreCompact | Bajo |
| `.claude/backups/PROJECT_STATE.critical.sha256` | Si | — | Bajo |
| Registries incidents/control/regression | Si | Documentacion cross-linkeada | Bajo |

### 12.2 Pregunta central

**"Puede el agente modificar el mecanismo que lo verifica?"** Respuesta actual: **si**, con las
siguientes excepciones:

- `bash-firewall.sh` y `secret-guard.sh` bloquean cambios que introduzcan patrones destructivos o
  secretos, pero **no** bloquean cambios al propio hook.
- El operador humano es la ultima linea de defensa. Ningun mecanismo hoy detecta debilitamiento
  silencioso de hooks P0.

### 12.3 Propuestas

**No implementadas.** Registradas para trazabilidad:

- **G-N4 (proposed) — Hook integrity fingerprint:** `maintenance.sh` compara sha256 de hooks P0
  contra baseline en `evals/REGRESSION_BUDGET.json`. Cualquier cambio requiere actualizar el
  baseline explicitamente. Decision: **DEFER** hasta que aparezca incidente de debilitamiento.
- **G-N5 (proposed) — Registry append-only via git-hook pre-commit:** rechaza edicion de EV-NNN
  ya VERIFIED sin flag `--allow-history-rewrite`. Decision: **DEFER** por coste vs beneficio.

**F7 no toca trust boundary.** Se mantiene la revision humana como control principal.

---

## 13. SECURITY MODEL

### 13.1 Amenazas mapeadas

| Threat | Cobertura actual | External reference | Gap |
|---|---|---|---|
| Command injection (bash) | `bash-firewall` L5 fail-closed | OWASP ASVS · secure coding | Sin fixture positivo (G-T1) |
| Secret exfiltration (Write/Edit) | `secret-guard` L5 fail-closed | Trufflehog · Gitleaks | Sin fixture positivo (G-T1) |
| Destructive rm/mkfs | `bash-firewall` literales | — | Ninguno |
| Supply chain `curl \| bash` | `bash-firewall` regex | — | Ninguno |
| Read of `.env`/`.pem`/`.key` | `permissions.deny` + `bash-firewall` | — | Ninguno |
| Prompt injection (agent input) | Guidance (rules) + evidence gate | Rebuff · guardrails | No enforcement estructural |
| Indirect prompt injection (file contents) | Guidance | Aptible MCP gateway | No enforcement (no MCP hoy) |
| Tool poisoning (MCP) | N/A (no MCP) | MCPTox benchmark | N/A |
| Confused deputy | Permissions matrix | Microsoft security blog | Parcial |
| Model self-modification | `bash-firewall` bloquea rm de hooks parcialmente | — | Parcial (ver §12) |
| Evidence tampering | Ninguno estructural | Merkle logs · sigstore | G-V1/G-Bob-2 |
| Timing attack en hooks | N/A | — | N/A |
| Fixture gaming | Fixtures escritos por humano | Superpowers behavioral | Parcial |

### 13.2 Decisiones

- **Prompt injection defense estructural:** DEFER. El control plane no expone endpoints publicos;
  las entradas son del operador humano. Si en el futuro el sistema procesa contenido web o
  archivos no confiables como input directo, se reconsidera.
- **MCP:** NO ADOPTAR sin evaluacion previa de allowlist. Documentar como no-go boundary.
- **Rate limiting:** N/A (single-user local).

### 13.3 Regla de seguridad recomendada

"Ninguna capacidad de seguridad nueva se agrega sin un incidente que documente el riesgo real." La
prevencion sin evidencia acumula complejidad; la deteccion post-incidente convierte evidencia real
en control (ciclo `/incident`).

---

## 14. VERIFICATION MODEL

### 14.1 Niveles (risk-adaptive)

| Level | Trigger | Mechanism |
|---|---|---|
| V1 STATIC | Toda tarea | `bash -n`, `jq empty`, syntax |
| V2 UNIT | Feature/bugfix | Test propio del cambio |
| V3 INTEGRATION | Cambios cross-module | Suite deterministic (maintenance) |
| V4 CONTRACT | Cambios de contrato/schema | Fixtures + acceptance criteria |
| V5 STRUCTURAL | Skills/hooks/agents | Tier 1 structural |
| V6 BEHAVIORAL | Skills invocables | Tier 3 (behavioral, con freshness post-F7) |
| V7 ADVERSARIAL | Alto riesgo | Doubt-driven skill + reviewer fresh-context |
| V8 MUTATION | Regex del firewall | DEFER (G-M1) |
| V9 ACCEPTANCE | Fase cerrada | `/gate` + evidence gate |
| V10 INDEPENDENT | Medium/high risk | `code-reviewer` agent con contexto fresco |
| V11 INTEGRITY | Cambios de mecanismo | Hash comparison (DEFER §12) |

### 14.2 Regla de routing por riesgo

- Micro (typo, docs): V1
- Normal (feature pequeña): V1 + V2 + V3
- Medium (multi-file, comportamiento): V1-V5 + V10
- High (auth, permisos, security): V1-V7 + V10
- Irreversible: todo lo anterior + humano V8 (§10 no-go)

**Ningun cambio requiere todos los niveles.** Sobre-verificacion es tan costosa como
sub-verificacion.

---

## 15. EVALUATION MODEL

### 15.1 Tiers actuales

- **Tier 1 Structural:** frontmatter, descriptions, routing markers. Ejecutado por
  `evals/skills/validate.sh`. Baseline explicito.
- **Tier 2 Routing:** positive/negative/collision fixtures en `evals/skills/fixtures.json`.
- **Tier 3 Behavioral:** ejecucion autenticada del CLI Claude contra fixtures; resultados en
  `evals/skills/results/F3-tier3-run-*.json`. **GAP:** editable (G-V1).

### 15.2 Overfitting/gaming risks

- **Fixture gaming:** los fixtures son escritos por el mismo equipo que las skills. Un fixture
  laxo hace pasar una skill laxa. Mitigacion: reviewer fresh-context revisa fixtures + skill.
- **Evaluator drift:** `validate.sh` no ha cambiado desde F3. Si se muta, no hay regresion que lo
  detecte. Mitigacion parcial: `bash -n` en maintenance.
- **Contamination:** el mismo modelo genera evidence y consumo evidence. Mitigacion: hashes +
  reviewer.

### 15.3 Propuestas F7

Solo G-V1/G-Bob-2 (§11.3.a). Sin nuevos tiers.

---

## 16. TESTING STRATEGY

### 16.1 Actual

- **Regression fixtures:** `evals/incidents/INC-001-*.sh` (1).
- **Structural:** `evals/skills/validate.sh`.
- **State integrity:** `evals/state/state-integrity.sh`.
- **Maintenance suite:** `evals/maintenance.sh` (9 checks).
- **CI:** `.github/workflows/control-plane.yml` corre maintenance.

### 16.2 Estrategias externas evaluadas

| Estrategia | Cost | Signal | Cuando adoptar | Cuando NO |
|---|---|---|---|---|
| Golden fixtures | Bajo | Alto | Baseline por skill/hook | Ya usado |
| Negative fixtures | Bajo | Alto | Verificar rechazos | Falta positive dedicado (G-T1) |
| Property-based | Alto | Medio | Funciones puras | Hooks bash - no aplica |
| Metamorphic | Medio | Medio | Transformaciones | No aplica hoy |
| Fuzzing | Alto | Bajo (para regex conocida) | Superficie amplia | No aplica |
| Mutation testing | Alto | Alto | Regex critico si tests son laxos | Shell no soportado → DEFER |
| Differential | Medio | Alto | Multi-implementation | No aplica |
| Contract tests | Bajo | Alto | Cambios de contrato | Ya usado en fixtures |

### 16.3 Propuesta

**F7 agrega:** un unico fixture positivo dedicado por hook P0 (bash-firewall, secret-guard), con
patrones extraidos de las regex actuales. Coste bajo; cierra G-T1.

**Fuera de F7:** todo lo demas.

---

## 17. CONTEXT ENGINEERING

### 17.1 Auditoria de contexto

- `CLAUDE.md` root: 40 lineas · reglas operativas + orden de lectura. **OK, sin duplicacion.**
- `.claude/rules/*.md`: 4 archivos · ≤50 lineas c/u. **OK.**
- `.claude/context/*.md`: 6 packs · promedio ~40 lineas. **OK.**
- `SubagentStart.additionalContext`: inyecta packs por rol. **OK.**
- `SessionStart.compact.additionalContext`: recuperacion densa. **OK.**

### 17.2 Antipatrones detectados

- **`.claude/context/CURRENT_STATE.md`:** placeholder `{{}}` residuales (G-A1). No confunde al
  usuario porque el mirror es explicito, pero suma ruido.
- **Duplicacion Master Plan ↔ POST_F6_AUDIT_REPORT ↔ este roadmap:** intencional; cada uno tiene
  scope temporal distinto. Reconciliar riesgo: revisado y clasificado en §25.

### 17.3 Regla propuesta

**"Minimum sufficient context"** — no minimizar tokens sacrificando correctness. Cada pack existe
para responder una pregunta especifica (identidad, estado, decisiones, seguridad, negocio,
no-go). Si un pack no responde su pregunta, se retira o se reescribe; no se acumula.

**Sin cambio.** Estado actual satisface la regla.

---

## 18. ORCHESTRATION

### 18.1 Modelo actual

- **Main agent:** coordina. Recibe intent humano. Ejecuta o delega.
- **Subagents:** invocados via `Agent()` (fork si necesita compartir contexto; especializado si
  no).
- **SubagentStart hook:** inyecta context packs por rol; los agentes no pueden confiar en
  frontmatter `skills:`.
- **SubagentStop hook:** logging observabilidad.
- **TaskCompleted hook:** gate por tarea contractual.

### 18.2 Reglas propuestas (documentales)

| Situacion | Decision |
|---|---|
| Tarea unica, contexto local | Main agent |
| Investigacion open-ended con output no reusable | Fork |
| Task 100% independiente que necesita contexto fresco (revisor, security) | Fresh subagent |
| Multiples tareas independientes | Parallel forks/subagents (una sola llamada) |
| Cadena dependiente | Sequential main agent (no orchestrator externo) |
| Trust boundary (implementer no revisa su propio trabajo) | Fresh `code-reviewer` subagent |

### 18.3 Anti-patrones documentados

- No parallelizar cuando hay dependencias.
- No spawnar >2 subagents si el output cabe en el main agent.
- No confiar en handoff entre agents; el main agent mantiene el contrato.

**Sin cambio de codigo.** Documentacion actual (Handbook §9) cubre.

---

## 19. OBSERVABILITY

### 19.1 Estado actual

- **Session log:** `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md` (textual, rotado por
  `subagent-stop-logger.sh`).
- **Config change log:** `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md` (mismo archivo, entradas de
  `config-change-logger.sh`).
- **Evidence provenance:** semantica explicita (`EXTRACTED|INFERRED|ASSUMED|EXTERNAL|GENERATED`).
- **State snapshot:** `.claude/backups/PROJECT_STATE.precompact.md` + hash critico.
- **Runtime traces:** ninguno estructurado.

### 19.2 OpenTelemetry GenAI status

CNCF SIG activo, conventions en `Development`. Adoptado por Google/AWS/Azure/Datadog. **Fuera de
alcance actual** porque:

1. Single-user local; no hay agregador que consuma traces.
2. Coste de instrumentacion supera valor sin platform de observabilidad.
3. Ningun incidente hasta hoy quedo sin resolver por falta de traza.

### 19.3 Regla

**"Observability solo con evidencia de demanda."** Si un incidente demuestra que la falta de
traza estructurada bloqueo un RCA, se reconsidera con OTel GenAI como referencia.

---

## 20. RECOVERY / ROLLBACK

### 20.1 Mecanismos actuales

- **Git checkpoint:** `LAST_GIT_CHECKPOINT` en `PROJECT_STATE.md`.
- **PreCompact snapshot:** copia state antes de compactar; hash critico.
- **`.claude/backups/`:** snapshots automaticos de state.
- **`/recovery` skill:** 9 escenarios documentados en Handbook §12.
- **`git revert`:** rollback per-commit.
- **Rollback especifico de controles:** en `CONTROL_REGISTRY.md` (documentado, no probado — G-S1).

### 20.2 Gap real

**G-S1 (P2):** rollback nunca ejecutado puede fallar cuando importa. Un rollback documentado sin
smoke test tiene el mismo riesgo que un test que nunca corre.

**Propuesta (fuera de F7):** al cerrar un incidente con `/incident close`, ejecutar dry-run
opcional del rollback. Documentado en la skill; no requiere cambio de hook.

### 20.3 Externals

Ningun proyecto externo maduro provee rollback smoke automatico para hooks/skills/agents. Se
mantiene documentacion propia.

---

## 21. LEARNING LOOP

### 21.1 Ciclo actual

```text
INCIDENT (INC-NNN) → RCA (5 Whys) → MISSING CONTROL (missing_test/hook/rule/skill/eval)
    → CONTROL (CTRL-NNN) → REGRESSION (REG-NNN) → VERIFY → CLOSE (con enlaces)
```

**Verificado por:** `INC-001 / CTRL-001 / REG-001` cierran el loop. `EV-006` prueba enforcement.

### 21.2 Sostenibilidad

**1 incidente registrado en 6 meses de operacion.** Bajo por ahora; el volumen determinara si el
framework escala. **No fabricar incidentes** (DEFER G-T2, DEFER G-M1, DEFER G-L1).

### 21.3 Automatizacion

**G-L1 (`PostToolUseFailure` hook):** nativo, disponible. **DEFER** porque:

- Automatizar apertura de incidentes puede cubrir errores reales con ruido.
- Disciplina humana + `/incident open` explicito preserva la señal.

Si en algun momento un incidente demuestra que un fallo tool paso sin registrarse, se reconsidera.

---

## 22. ANTI-NOISE ARCHITECTURE

### 22.1 Principios activos

- **NOOP BY DEFAULT** — hooks P2/P3 fail-open, silenciosos en operacion normal.
- **QUIET SUCCESS** — maintenance imprime `PASS` una vez por check, sin verbosity.
- **LOUD FAILURE** — hooks P0 imprimen razon exacta al bloquear.
- **SINGLE SOURCE** — 1 registry por tipo; espejos declarados.
- **DEDUP** — session log rotado; no logs concurrentes en el mismo evento.
- **PROGRESSIVE DISCLOSURE** — CLAUDE.md → mapa; MASTER_PLAN → contrato; HANDBOOK → detalle.
- **ACTIONABLE ERRORS** — cada bloqueo dice cual campo falto y por que.

### 22.2 Ruido detectado

- **`CLAUDE_SESSION_LOG.md` acumula entradas mundanas** (subagent stops, config touches). La
  rotacion mitiga; ninguna evidencia que sea consumida por nadie salvo forensics.
- **Session-start compact repite estado que ya esta en PROJECT_STATE.md.** Coste bajo; beneficio
  post-compactacion alto.

**Sin cambio.** El sistema pasa el test anti-ruido.

---

## 23. WORKFLOW CATALOG

Workflows soportados hoy con su lane minima:

| Workflow | Skill/Agent | Verification | Evidence |
|---|---|---|---|
| Intent → Plan | `/estado` + Master Plan | V1-V3 | Documentado |
| Requirements | Master Plan + ARTIFACT_MANIFEST | V4 | Master Plan sec por fase |
| Feature/bugfix | `/test-driven-development` | V1-V6 | EV-NNN VERIFIED |
| Multi-file | + `/code-review-and-quality` | + V10 | + Reviewer PASS |
| Auth/security | + `/constraint-driven-development` + `security-auditor` | + V7 | + Reviewer PASS + humano |
| Doubt/decision | `/doubt-driven-development` | V7 | ADR-NNN + EV-NNN |
| Incident | `/incident` | V3 + V10 | INC-NNN + CTRL-NNN + REG-NNN + EV-NNN |
| Docs | Direct edit | V1 | Sin EV-NNN (unless part of contractual task) |
| Recovery | `/recovery` (E-1…E-9) | V1 | Escenario ejecutado |
| Maintenance | `evals/maintenance.sh` | V3 | CI green |
| Phase close | `/cerrar-fase` | V9 | EV-NNN + gate PASS |
| Checkpoint | `/checkpoint` | V1 | LAST_GIT_CHECKPOINT actualizado |
| Skill lifecycle | Master Plan §5-6 | V5 | Fase que la introduce |

**Convergencia:** cada workflow tiene una `Definition of Done` explicita (Handbook §16). Sin
workflow "abierto" que dependa del criterio del agente.

**Anti-patron:** convertir todo workflow en skill. Skills empaquetan procesos repetibles. Los
one-shot van directo a codigo/docs con la verificacion adecuada.

---

## 24. SKILL LIFECYCLE

### 24.1 Fases documentadas

`INTRODUCE → VERIFY (Tier 1/2/3) → OBSERVE → MAINTAIN → DEPRECATE → REMOVE`.

### 24.2 Regla propuesta

Una nueva skill debe justificar:

- **PROBLEM:** que problema recurrente resuelve?
- **EVIDENCE:** cuantas veces ha aparecido en incident/session log?
- **ALTERNATIVES:** existe una skill externa (Superpowers/anthropic-skills) que ya lo cubre?
- **BENEFIT:** que trabajo elimina o que riesgo reduce?
- **COMPLEXITY:** cuanto codigo/docs suma?
- **VERIFICATION:** Tier 1/2/3 minimos que probaran su comportamiento.
- **ROLLBACK:** como se retira sin dejar refs colgantes?

**Sin cambio hoy.** Regla documentada en Master Plan §5 F3.

### 24.3 Auditoria de skills existentes

22 skills. Ninguna candidata a retiro. `context-*` skills son mandatorios por diseño (context
injection). Skills operativas se usan segun rol/workflow.

---

## 25. DOCUMENTATION SYSTEM

### 25.1 Documentos canonicos

| Documento | Rol | Cuando editarlo |
|---|---|---|
| `README.md` | Navegacion | Cambia estado publico |
| `CLAUDE.md` | Bootstrap agente | Reglas operativas cambian |
| `docs/MASTER_IMPLEMENTATION_PLAN.md` | Contrato historico F1-F6 + gap register | Consolidacion de fase |
| `docs/DESIGN.md` | Arquitectura | Cambio de capa/regla arquitectonica |
| `docs/CONTROL_PLANE_HANDBOOK.md` | Manual operativo | Nuevo caso de uso o gap operativo |
| `docs/00_SYSTEM/POST_F6_AUDIT_REPORT.md` | Consolidacion historica post-F6 | INMUTABLE tras aprobar |
| `docs/MASTER_EVOLUTION_ROADMAP.md` | Este doc — evolucion futura | Nueva evidencia externa o gap real |
| `PROJECT_STATE.md` | Estado operativo | Cada fase / checkpoint / auditoria |
| Registries (`DECISION`, `INCIDENT`, `CONTROL`, `REGRESSION`) | Estado permanente | Evento correspondiente |

### 25.2 Regla anti-drift

1. Ningun claim en docs sin cobertura runtime.
2. `POST_F6_AUDIT_REPORT.md` es historico: **no se sobrescribe**. Nueva informacion → nuevo
   documento (este roadmap).
3. Pointers cross-document en vez de duplicacion.
4. `evals/maintenance.sh docs=PASS` bloquea contadores obsoletos.

### 25.3 Cambios que aplicare a docs existentes

- `PROJECT_STATE.md`: agregar linea `LAST_ROADMAP: 2026-09-17` (o campo equivalente).
- `README.md`: link al roadmap en la seccion de documentacion.
- `docs/MASTER_IMPLEMENTATION_PLAN.md`: pointer breve al roadmap en §10.

**No modificar:** POST_F6_AUDIT_REPORT (historico), DESIGN (no cambia arquitectura), Handbook (no
cambia operacion actual), ARTIFACT_MANIFEST (F7 no esta iniciada).

---

## 26. AI THEATER AUDIT

Deteccion de "activity without value":

| Candidate | Aparenta valor porque | Valor real | Riesgo | Decision |
|---|---|---|---|---|
| Automatizar apertura de incidentes (G-L1) | Parece "learning loop cerrado" | Bajo — puede tapar señal | Alto (ruido) | DEFER |
| Fabricar 2do incidente (G-T2) | Framework "validado" con >1 sample | Nulo — fabricado | Alto (evidence theater) | DEFER |
| Mutation testing sin bypass demostrado (G-M1) | "Higher assurance" | Marginal | Coste alto | DEFER |
| Dashboards de metricas | Observability | Nulo sin decisiones | Ruido | NO BUILD |
| Cross-provider fallback | "Resiliency" | Nulo (single provider por diseño) | Complejidad | NO BUILD |
| Vector DB memory | "Memoria semantica" | Marginal para 1 proyecto | Coste alto | NO BUILD |
| Custom orchestration engine | "Agent teams" | Nulo (main agent basta) | Complejidad | NO BUILD |
| Policy engine externo | "Formal enforcement" | Bajo (permissions basta) | Complejidad | NO BUILD |
| Blockchain evidence | "Tamper-proof" | Nulo | Teatro | NO BUILD |
| Constitucional AI critic | "Adversarial review" | Existe (`code-reviewer` fresh) | Duplicacion | NO BUILD |
| Sofisticado plan/act loop | "Planning" | Bajo (Master Plan basta) | Complejidad | NO BUILD |

**Regla:** todo mecanismo del control plane debe responder "que riesgo observable reduce" con
evidencia concreta. Un mecanismo sin evidencia es teatro.

---

## 27. COMPLEXITY MODEL

### 27.1 Contadores actuales

- Hooks: 10
- Skills: 22 (6 context + 16 process)
- Agents: 5
- Rules: 4
- Context packs: 6
- Registries: 5 canonicos (evidence, decision, artifact, incident, control, regression) + 1 state
- CI steps: 1 (maintenance)
- Dependencies: `jq`, `bash`, `sha256sum`, `awk`, `rg` (via ripgrep)

### 27.2 Presupuesto

**Regla propuesta:** cada nueva pieza debe declarar:

- **WHAT IT REPLACES:** un mecanismo actual, o `NONE` si es aditivo.
- **WHAT IT PREVENTS:** un riesgo con evidencia (INC-NNN o gap del roadmap).
- **WHAT IT SAVES:** trabajo humano medible.
- **WHAT IT COSTS:** LOC, docs, maintenance overhead.
- **WHAT BREAKS IF REMOVED:** convergencia si no lo eliminas rompe algo real.

**F7 pasa la regla:** agrega ~30 LOC a `maintenance.sh` (freshness check + 2 fixtures positivos),
cierra G-V1/G-Bob-2/G-T1 con evidencia concreta, coste runtime ~0.2s adicional.

---

## 28. WHAT NOT TO BUILD

Blacklist razonada. **Ninguno de estos entra al roadmap.**

| Item | Aparenta atractivo porque | Por que NO | Cuando reconsiderar |
|---|---|---|---|
| Segundo state system | "Redundancy" | Contradice ARCH-001 unica fuente | Nunca |
| Segundo memory system (vector DB) | "Semantic recall" | Coste + un proyecto no lo necesita | Multi-proyecto shared knowledge |
| Segundo evidence registry | "Distributed" | Contradice ARCH-003 | Nunca |
| Segundo incident registry | "Multi-team" | Single team | Multi-team explicito |
| Plugin manager propio | "Extensibility" | Claude Code lo trae nativo | Nunca |
| Custom eval framework | "Custom" | maintenance.sh + fixtures basta | Escala 100x |
| Test runner propio | — | `bash` + `jq` + `sha256sum` es suficiente | Nunca |
| Generic researcher agent | "Investigacion" | Solapa con Fork + WebSearch | Ya existe |
| Generic read-files skill | "Utility" | Read tool lo cubre | Nunca |
| Custom dashboard | "Visibility" | Sin consumidor | Multi-usuario/produccion |
| Custom orchestration engine | "Multi-agent" | Main agent basta | Multi-team distribuido |
| Vector database | "Similarity search" | No hay use case | Cross-proyecto knowledge |
| Policy engine (OPA/Rego) | "Formal" | Permissions + hooks bastan | Regulatory audit externo |
| Agent swarm | "Parallelism" | Overhead > beneficio | Tarea >100 subtareas independientes |
| Gherkin pipeline | "BDD" | Duplica contract semantics | Stakeholders no tecnicos requieren BDD |
| Sofisticado retrieval | "RAG" | Contexto local suficiente | Cross-repo grounding |
| Model routing propio | "Optimization" | Nativo Claude Code | Nunca |
| Cross-provider fallback | "Resilience" | ARCH-001 fija a Claude | Provider outage cronico |
| Prompt firewall separado | "Injection defense" | bash-firewall + guidance basta | MCP adoption |
| Formal proof system | "Correctness" | Coste supera valor | Safety-critical explicito |

**Cada uno de estos aumenta complejidad sin evidencia de beneficio.** Ninguno se construye.

---

## 29. ARCHITECTURAL DISTINCTIVENESS

### 29.1 Lo que NO es distintivo

- Usa hooks — todos los sistemas serios lo hacen.
- Usa skills — Superpowers, anthropic-skills, otros lo hacen.
- Usa agents — nativo Claude Code.
- Usa evals — practica estandar.
- Tiene un CI — obvio.

### 29.2 Lo que SI es distintivo (verificado)

1. **Evidence gate como contrato canonico** (`docs/00_SYSTEM/EVIDENCE_REGISTRY.md` + hook
   `TaskCompleted`): ningun sistema externo maduro tiene un equivalente que bloquee tarea sin
   entrada VERIFIED con hashes + reviewer + provenance.
2. **State integrity via hash critico + PreCompact snapshot:** unico mecanismo verificable de
   drift-detection post-compactacion en el ecosistema Claude Code que conocemos.
3. **3-registry incident learning (INC/CTRL/REG) con acceptance test:** el ciclo esta cerrado con
   un test que demuestra `without_control=UNPROTECTED / with_control=BLOCKED`. Ningun framework
   externo obliga a esta linkage.
4. **Deterministic maintenance suite sin LLM auth:** el CI puede correr sin token pagado. La
   mayoria de eval frameworks externos requieren LLM online.
5. **Trust boundary + fresh-context reviewer para riesgo medio/alto:** el `code-reviewer` NO
   recibe el razonamiento del implementer. Diseño explicito, no accidental.
6. **`BENEFIT > COMPLEXITY` como regla dura:** documentada, aplicada consistentemente. Bloquea
   AI theater.

### 29.3 Clasificacion

| Elemento | Common | External | Integrated | Adapted | Custom | Genuinely distinct |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Hooks | ✔ | | | | | |
| Skills | ✔ | | | | | |
| Agents | ✔ | | | | | |
| Permissions | ✔ | | | | | |
| Rules | ✔ | | | | | |
| Evidence gate | | | | ✔ | | ✔ |
| State integrity hash | | | | | ✔ | ✔ |
| Incident 3-registry | | | | | ✔ | ✔ |
| Deterministic maintenance | | | | ✔ | | ✔ |
| Fresh-context reviewer | | | | ✔ | | ✔ |
| BENEFIT>COMPLEXITY rule | | | | | ✔ | ✔ |

**Distintividad real:** 6 elementos. Todos verificables por evidencia (EV-001…EV-008 + POST_F6).

---

## 30. TARGET ARCHITECTURE

**No cambia respecto de §4.** El objetivo no es "cambiar la arquitectura", es "reforzar la
integridad de sus mecanismos existentes en las esquinas identificadas".

Cambios pequeños esperados:

1. `maintenance.sh` agrega `evidence_freshness=PASS` (post-F7).
2. `maintenance.sh` agrega `firewall_positive=PASS` y `secret_guard_positive=PASS` (post-F7).
3. `REGRESSION_BUDGET.json` documenta `evidence_freshness_days` (default 30, configurable).
4. `docs/CONTROL_PLANE_HANDBOOK.md §12` agrega convention para task tracking semantics (via
   ADR-004 aprobado, no en F7).

Sin nuevos hooks. Sin nuevos agents. Sin nuevos skills. Sin nuevos registries.

---

## 31. MASTER ROADMAP

### 31.1 F7 — Evidence Integrity Hardening (IMPLEMENTED / VERIFIED)

**CURRENT STATUS:** F7 Extended implemented and verified on 2026-09-18. This current status
supersedes the proposal text below without rewriting its historical rationale.
**CURRENT SCOPE:** Variante C: freshness and positive fixtures plus Bundles A-E (anti-loop,
firewall, evidence coupling, rotation and installer idempotency) and ARCH-004.
**CURRENT EVIDENCE:** EV-009 a EV-014, all `VERIFIED`, with `Reviewer: PASS` and
`Provenance: GENERATED`. REG-002 a REG-009 are ACTIVE.
**CURRENT VERIFICATION:** `bash evals/maintenance.sh` 12/12 PASS; INC-001, state integrity,
Tier 1/2/3, adversarial fixtures and `bash -n` PASS. Fresh independent review: PASS.
**CURRENT LIMITATION:** only repository scripts were invoked. Native Claude Code lifecycle hooks are
NOT_VERIFIED in OpenCode and remain UNKNOWN.
**ROLLBACK:** revert the bundle commits individually or revert the complete F7 commit range. EV-001
a EV-008 and INC-001/CTRL-001/REG-001 are preserved.
**BUDGET DECISION:** owner accepted the evidence-driven variance of 591 additions, 17 deletions
and 7 fixture files; no new runtime component or external dependency was introduced.

#### Historical proposal (superseded by the F7 Extended implementation)

**PHASE ID:** F7
**NAME:** Evidence Integrity Hardening
**OBJECTIVE:** cerrar G-V1/G-Bob-2/G-T1 sin infraestructura pesada.

**PROBLEM:** Tier 3 behavioral es snapshot editable; sin politica de rerun; firewall/secret-guard
sin fixture positivo dedicado.

**EVIDENCE:** `evals/skills/results/F3-tier3-run-*.json` sin verificacion de freshness;
`INC-001-*.sh` solo cubre TaskCompleted; POST_F6_AUDIT_REPORT §C.

**WHY NOW:** los 3 gaps son P1, tecnicos, con cobertura parcial. Reducen riesgo demostrable
(bypass silencioso). Coste bajo.

**CURRENT COVERAGE:** `contract_hash sha256` en Tier 3; `bash -n` en hooks; ningun fixture
positivo dedicado.

**EXTERNAL SOLUTION:** Superpowers behavioral fixtures cubre parcialmente; ningun proyecto cubre
freshness check para behavioral evals autenticadas por CLI.

**INTEGRATION STRATEGY:** todo local. Extension de `evals/maintenance.sh`. No adopcion de
frameworks externos.

**SCOPE (in):**

1. `maintenance.sh` verifica que cada resultado Tier 3 tiene `session_id` no reutilizado y
   `timestamp` no anterior a `evidence_freshness_days` (config en `REGRESSION_BUDGET.json`,
   default 30).
2. `evals/hooks/firewall-positive.sh` (nuevo): fixture positivo que invoca `bash-firewall.sh`
   con payloads que deben ser bloqueados (rm -rf /, secreto en argumento, curl|bash, DROP TABLE).
   Espera exit code 2 + patron reason en stderr.
3. `evals/hooks/secret-guard-positive.sh` (nuevo): fixture positivo que invoca `secret-guard.sh`
   con payloads que deben ser bloqueados (PEM private key, sk-XXX, JWT). Espera exit code 2 +
   patron.
4. `maintenance.sh` corre ambos fixtures.
5. Documentacion actualizada en Handbook §15 y Master Plan §5 F7.

**SCOPE (out):**

- Mutation testing global (G-M1 DEFER).
- Automatizacion apertura incidentes (G-L1 DEFER).
- Task tracking semantics (G-D3 → ADR aparte).
- Artifact hash recompute (G-N3 DEFER).
- Hook integrity fingerprint (G-N4 DEFER).
- Registry append-only (G-N5 DEFER).

**DEPENDENCIES:** F6 PASS (satisfecho); `jq`, `sha256sum`, `bash -n` (satisfecho).

**BENEFIT:** cierra 3 gaps P1. Reduce riesgo de bypass silencioso.

**COMPLEXITY:** ~30-50 LOC bash agregado a maintenance + 2 archivos fixture nuevos + 1 config
field en `REGRESSION_BUDGET.json`. Docs update coherente.

**RISK:** bajo. Cambios aditivos; no toca hooks P0; no cambia contratos existentes.

**ACCEPTANCE CRITERIA:**

- `maintenance.sh` rechaza Tier 3 con `session_id` reutilizado o `timestamp` obsoleto.
- Fixture positivo firewall rechaza si `bash-firewall.sh` retorna 0 ante payload malicioso.
- Fixture positivo secret-guard idem.
- `maintenance.sh` sigue 10/10 PASS (era 9/9; agrega `evidence_freshness` y colapsa `hooks` en
  `hooks_static + hooks_positive`).
- Ninguna regresion en EV-001…EV-008.

**NEGATIVE TESTS:**

- Debilitar una regex del firewall → fixture positivo falla → maintenance rechaza.
- Editar un `session_id` en Tier 3 result → maintenance rechaza.

**EVIDENCE CRITERIA:** EV-009 con hashes + reviewer PASS + provenance GENERATED.

**REGRESSION CRITERIA:** REG-002 `firewall_positive`, REG-003 `secret_guard_positive`, REG-004
`evidence_freshness`. Todos vinculados a INC-001 no aplica; se abren como preventive controls sin
INC previo (permitido cuando gap tiene evidencia documentada).

**ROLLBACK:** `git revert <F7-commit>`. Preserva EV-001…EV-008 y INC-001/CTRL-001/REG-001.

**HUMAN CHECKPOINT:** aprobacion explicita del owner antes de iniciar. F7 es opcional; el
sistema es sostenible sin ella.

**METRICS:**

- `maintenance.sh` sigue < 5s wall time.
- 0 regresiones en checks existentes.
- 3 nuevas evidencias positivas registradas.

**GO/NO-GO:** owner. Este roadmap propone; no ejecuta.

### 31.2 ADR-004 — Task Tracking Semantics (IMPLEMENTED / DOCUMENTED)

**No es una fase.** Es una decision documental registrada en `DECISION_REGISTRY.md` como ARCH-004
con convention aplicada desde su aprobacion. Ver §10.

- **PROBLEM:** hook `TaskCompleted` trata subtareas scaffolding como contractuales.
- **DECISION:** convention documentada; subtareas scaffolding se marcan `deleted`, no
  `completed`; solo tareas `contractual` pasan por el gate.
- **EVIDENCE:** F7_F12_RESEARCH_HANDOFF.md sections J/AI; EV-012.
- **ROLLBACK:** trivial (retirar convention del Handbook).

### 31.3 F8 — Fail-Closed Closure (IMPLEMENTED / VERIFIED)

**CURRENT STATUS:** F8 implementada y verificada el 2026-09-19. F8-A cierra A-03, F8-B cierra A-04,
A-06 queda documentado como convencion y ARCH-004 fue enmendado in-place.
**CURRENT EVIDENCE:** EV-015/EV-016, con REG-010/REG-011 activos. EV-001..EV-014 y REG-001..REG-009
permanecen historicos e intactos.
**CURRENT VERIFICATION:** maintenance 12/12 PASS; INC-001, state integrity, Tier 1/2/3, fixtures F7/F8,
boundary adversarial, `bash -n` e independent fresh review round 3 PASS.
**CURRENT LIMITATION:** OpenCode no verifica el lifecycle nativo de Claude Code; permanece NOT_VERIFIED.
**ROLLBACK:** revert de los commits F8 por bundle; no se reescribe evidencia historica.
**SCOPE DECISION:** A-05, A-07, G-M1, G-L1, G-N4/N5 y demas items DEFER permanecen diferidos.

### 31.4 Post-F8: F9-F12 UNKNOWN / RESEARCH REQUIRED

F9/F10/F11/F12 no estan definidas ni implementadas. Los items DEFER siguen DEFER hasta que aparezca
evidencia concreta que los reactive:

- **G-T2:** un 2do incidente real.
- **G-M1:** un bypass documentado.
- **G-L1:** un fallo tool que paso sin registrarse.
- **G-N3-N5:** un incidente de tampering de evidencia o hooks.

### 31.5 Documental (no fases)

- **G-S1:** dry-run rollback documentado en Handbook.
- **G-S2:** heredoc en `CONTROL_REGISTRY.md`.
- **G-Bob-1:** comentario acceptance en `fixtures.json`.
- **G-A1:** nota en README.
- **G-N1:** cadencia de revalidacion en Handbook (`/doctor` mensual, `maintenance` en cada
  cambio).
- **G-N2:** politica de retention del session log en Handbook.

Todos son cambios documentales, no fases. Pueden aplicarse individualmente sin gate; cada uno
requiere update de docs y `evals/maintenance.sh docs=PASS`.

---

## 32. PHASE DEPENDENCY GRAPH

```text
F6 PASS (baseline)
    |
    +--> ADR-004 Task Tracking Semantics (documental, sin fase)
    |
    +--> F7 Evidence Integrity Hardening (opcional)
             |
             +--> Bundle G-V1 + G-Bob-2 (freshness check)
             |
             +--> Bundle G-T1 (fixtures positivos)
             |
             +--> Evidence EV-009 + REG-002/003/004

[Fuera del grafo — DEFER]
G-T2 (2do incidente organico) ---.
G-M1 (mutation regex)            |--- Reactivables solo con evidencia
G-L1 (PostToolUseFailure)        |
G-N3 (artifact recompute)        |
G-N4 (hook fingerprint)          |
G-N5 (registry append-only)     -'
```

No hay circular dependencies. No hay hidden deps. F7 es completamente aditiva.

---

## 33. PHASE ACCEPTANCE MODEL

Toda fase (incluida F7) sigue el mismo contrato:

```text
RESEARCH → DESIGN GATE → IMPLEMENT → TEST → NEGATIVE TEST → INDEPENDENT VERIFY
    → EVIDENCE → MAINTENANCE → DOCUMENT → GATE
```

**Definicion de DONE (unificada):**

- Implementation exists (files + wiring).
- Deterministic tests PASS.
- Negative test PASS (mecanismo rechaza payload malicioso).
- Independent check (reviewer fresh-context) PASS para riesgo medium/high/critical.
- Evidence VERIFIED con hashes.
- `evals/maintenance.sh` PASS.
- Documentation coherente con runtime.
- Gate `/gate` PASS.

**Rechazar automaticamente:**

- "Claude dijo que funciona".
- "Snapshot editable existe".
- "Documento existe pero test no".
- "Test positivo existe pero no negativo".

---

## 34. MIGRATION STRATEGY

**Para F7 (si se aprueba):**

1. Crear rama feature `f7-evidence-integrity`.
2. Implementar sin modificar `PROJECT_STATE.md`.
3. Ejecutar `maintenance.sh` local con backup del baseline.
4. Registrar EV-009 con hashes.
5. Independent review (`code-reviewer` fresh) contra contrato F7.
6. Merge a main solo si reviewer PASS.
7. Actualizar `PROJECT_STATE.md`: `CURRENT_PHASE: 7`, `PHASE_STATUS: COMPLETE`, `EV-009` en
   completed phases.
8. Cerrar checkpoint git via `/checkpoint`.
9. `POST_F7_AUDIT_REPORT.md` (nuevo documento, no sobreescribir POST_F6).

**Para ADR-004:**

1. Ejecutar `/adr` skill.
2. Agregar entrada a `DECISION_REGISTRY.md`.
3. Actualizar `.claude/context/DECISIONS.md`.
4. Actualizar `docs/CONTROL_PLANE_HANDBOOK.md §12`.
5. Sin cambio de hook. Sin gate.

**Para cambios documentales (G-S1 etc):**

1. Editar archivo(s) afectado(s).
2. `evals/maintenance.sh docs=PASS`.
3. Sin EV-NNN individual (cambio documental no contractual, per ADR-004).

---

## 35. FUTURE GOVERNANCE

### 35.1 Regla para nuevos componentes

Todo hook/skill/agent/rule/registry propuesto debe presentar:

- PROBLEM concreto con evidencia (INC-NNN o entrada del gap register).
- ALTERNATIVES (nativo Claude / externo maduro / existente en el sistema).
- BENEFIT medible.
- COMPLEXITY declarada.
- VERIFICATION (Tier 1/2/3 aplicables).
- ROLLBACK ejecutable.
- OWNER identificado.
- LIFECYCLE (INTRODUCE/VERIFY/OBSERVE/MAINTAIN/DEPRECATE/REMOVE).

### 35.2 Regla de retirada

Todo componente debe poder retirarse. Un componente que no se puede retirar sin romper el
sistema es una obligacion, no una capacidad.

### 35.3 Regla de dependency

Ninguna dependencia externa (framework, plugin, MCP) se agrega sin ADR aprobado + evaluacion de
riesgo (§13) + estrategia de fallback.

---

## 36. METRICS

**Metricas de salud del control plane** (medibles hoy):

| Metrica | Valor actual | Target |
|---|---|---|
| `maintenance.sh` PASS rate | 9/9 | 100% siempre |
| Time to run maintenance | ~1-2s | < 5s |
| Evidencias VERIFIED | 8 | ≥ 1 por fase |
| Incidentes cerrados con regresion | 1/1 | 100% |
| Documentos que citan runtime real | 100% | 100% |
| Gaps P0 abiertos | 0 | 0 |
| Skills sin Tier 1 | 0 | 0 |
| Hooks sin `bash -n` PASS | 0 | 0 |

**Metricas anti-teatro:**

- Componentes con evidencia de necesidad: 100% de los 27 activos.
- Componentes sin evidencia: 0.
- Fases iniciadas sin approval: 0.
- Evidencias fabricadas: 0.

**Metricas fuera del alcance:**

- Cost/token per session — no medido; sin evidencia de necesidad.
- Response latency del agente — nativo Claude Code, no del control plane.
- Cross-provider comparison — fuera de scope.

---

## 37. OPEN QUESTIONS

Preguntas que no se resuelven en este roadmap y requieren decision futura:

1. **¿F7 debe iniciarse?** Owner decide. Sistema sostenible sin ella.
2. **¿ADR-004 se aprueba con la convention propuesta?** Owner decide semantica.
3. **¿Se adopta OTel GenAI si aparece multi-proyecto?** Reconsiderar cuando haya evidencia.
4. **¿Cuando reactivar G-M1 (mutation)?** Solo tras bypass documentado.
5. **¿Se abren skills adicionales de superpowers (`brainstorming`, `systematic-debugging`) como
   entry-point local?** Coste bajo; DEFER hasta que aparezca demanda.
6. **¿Se establece cadence formal de `/doctor` (mensual, trimestral)?** Documental; se propone
   mensual en Handbook.
7. **¿Se preserva el `docs/00_SYSTEM/archive/` como historial permanente o se rota a >90 dias?**
   Documental; se propone retention 90 dias.

---

## 38. DEFERRED ITEMS

Todos los items marcados DEFER en §9, mas:

| Item | Trigger de reconsideracion |
|---|---|
| G-T2 (2do incidente) | Ocurrencia organica |
| G-M1 (mutation regex) | Bypass firewall documentado |
| G-L1 (PostToolUseFailure hook) | Tool failure sin registrar |
| G-N3 (artifact recompute) | Evidence tampering documentado |
| G-N4 (hook fingerprint) | Debilitamiento silencioso documentado |
| G-N5 (registry append-only) | History rewrite documentado |
| OTel GenAI | Multi-proyecto activo con RCA que necesito traza |
| MCP allowlist | Adopcion MCP explicita |
| Cross-provider fallback | Provider outage cronico + necesidad demostrada |
| Vector DB memory | Cross-proyecto knowledge sharing con volumen |
| Skills externos adicionales | Demanda especifica |

**Regla:** un DEFER no es un "algun dia"; es un "no hasta que aparezca evidencia especifica".
Sin evidencia, permanece DEFER indefinidamente.

---

## 39. FINAL GO / NO-GO

### 39.1 GO (recomendado)

- **F7 — Evidence Integrity Hardening:** cumple todas las condiciones GO (problema demostrado,
  gap real, solucion externa insuficiente, beneficio medible, alcance limitado, verificacion
  objetiva, rollback razonable, maintenance razonable). **Decision final: owner.**
- **ADR-004 — Task Tracking Semantics:** cumple; cero implementacion; documental. **Decision
  final: owner.**
- **Cambios documentales G-S1/G-S2/G-Bob-1/G-A1/G-N1/G-N2:** cumplen; documentales, puntuales.

### 39.2 NO-GO (recomendado)

- **G-T2 fabricar 2do incidente:** evidencia insuficiente (no incidente real); riesgo de teatro.
- **G-M1 mutation testing:** beneficio ambiguo (parcialmente cubierto por G-T1); complejidad
  desproporcionada (shell no soportado por herramientas maduras).
- **G-L1 automatizacion incidentes:** riesgo de ruido supera beneficio; disciplina humana
  demostro suficiencia (INC-001 abierto correctamente).
- **OTel GenAI:** solucion existente (log textual) adecuada para escala actual; complejidad
  desproporcionada para single-user.
- **MCP defense structural:** sin adopcion MCP; complejidad prematura.
- **Todos los items §28 "What Not to Build":** verification imposible o beneficio nulo o
  overlap total con nativo Claude.

### 39.3 SELF-ATTACK del roadmap

**Intento de destruccion:**

- ¿Que parte ya existe? — F7 es aditivo sobre lo existente; no reconstruye nada.
- ¿Que parte ya existe externamente? — Nada de F7 esta cubierto externamente para shell.
- ¿Que parte es redundante? — Ninguna; cada bullet cierra un gap identificado.
- ¿Que parte no tiene enforcement? — Los cambios documentales son guidance por diseño;
  aceptados como tales.
- ¿Que parte depende demasiado del modelo? — Ninguna; todo es shell + fixtures + hashes.
- ¿Que parte genera ruido? — Ninguna nueva; F7 mantiene `QUIET SUCCESS`.
- ¿Que parte es AI theater? — Ninguna sobrevive el test §26.
- ¿Que parte aumenta coste sin mejorar calidad? — Ninguna; los 3 gaps P1 tienen valor de
  reduccion de riesgo medible.
- ¿Que parte se puede eliminar? — F7 completa es opcional (§39.1).
- ¿Que parte solamente satisface preferencia arquitectonica? — Ninguna; todas responden a gaps
  documentados en POST_F6_AUDIT_REPORT.
- ¿Que parte no tiene suficiente evidencia? — Ninguna; cada gap cita fuente concreta.

**Resultado del self-attack:** el roadmap sobrevive. F7 se mantiene como recomendacion GO. Los
DEFER se mantienen. Los NO-BUILD se mantienen.

### 39.4 Confirmaciones finales

- ✔ POST_F6_AUDIT_REPORT preservado (sin modificacion).
- ✔ Evidencia historica preservada (EV-001…EV-008 verificadas via maintenance).
- ✔ F6 no alterada (`PHASE_STATUS: COMPLETE` intacto).
- ✔ Ninguna fase futura implementada (F7 propuesta, no iniciada).
- ✔ Ningun gate relajado (`TaskCompleted` intacto).
- ✔ Ninguna evidencia fabricada (0 nuevas entradas VERIFIED en esta sesion).
- ✔ Ninguna infraestructura duplicada (0 hooks/skills/agents/registries nuevos).
- ✔ Ningun internal TODO convertido en contractual task (roadmap es documental).

---

## Referencias externas consultadas (2026-09-17)

- Anthropic Claude Code — hooks reference (code.claude.com/docs/en/hooks).
- GitHub Spec Kit — github.com/github/spec-kit; github.github.com/spec-kit/.
- obra/superpowers — github.com/obra/superpowers.
- MCP tool poisoning — Truefoundry, Aptible, ITECS, Microsoft Security, arXiv 2604.07536,
  2606.06387, 2606.20922, 2604.11790.
- OpenTelemetry GenAI SIG — opentelemetry.io/blog/2026/genai-observability/; MLflow docs;
  Uptrace; Greptime.
- Stryker Mutator — stryker-mutator.io/docs; qaskills mutation-testing guides.
- mutmut — github.com/boxed/mutmut.
- Microsoft Security blog 2026-06-30 — AI agents defense.

## Referencias internas canonicas

- `docs/MASTER_IMPLEMENTATION_PLAN.md §5-§10` (contrato F1-F6 + gap register).
- `docs/00_SYSTEM/POST_F6_AUDIT_REPORT.md §A-§G` (consolidacion post-F6).
- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` (EV-001…EV-008 intactas).
- `docs/DESIGN.md` (arquitectura de capas y ADRs).
- `docs/CONTROL_PLANE_HANDBOOK.md` (manual operativo).
- `DECISION_REGISTRY.md` (ARCH-001, ARCH-002, ARCH-003).
- `INCIDENT_REGISTRY.md`, `CONTROL_REGISTRY.md`, `REGRESSION_REGISTRY.md` (ciclo INC-001).

---

**FIN DEL ROADMAP.** `BENEFIT > COMPLEXITY` respetado. Ninguna fase implementada. Ninguna
evidencia alterada. Owner decide GO/NO-GO de F7 y ADR-004.
