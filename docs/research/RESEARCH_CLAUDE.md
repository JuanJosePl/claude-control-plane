1. EXECUTIVE SUMMARY

Tesis central de la investigación: El "problema" que tu Claude Control Plane intenta resolver ya está siendo resuelto por la comunidad y por Anthropic, pero de forma fragmentada. Ningún sistema público integra las cinco capas que tú definiste (Context, State, Memory, Control, Execution) con Verificación e Incident-Learning al mismo tiempo. Los mejores repos existentes cubren 2–3 capas cada uno:

addyosmani/agent-skills cubre Context + Execution (skills) + Verification (evals de 3 niveles, únicos en el mercado) muy bien, pero no tiene State Layer ni Incident Learning, y sus hooks son mínimos.
obra/superpowers cubre Execution (workflows) y algo de Enforcement con reglas obligatorias, pero no tiene evals in-repo ni State Layer estructurado.
Kiro / GitHub Spec Kit cubren Context (specs) y Planning muy bien, pero delegan Execution en el agente sin gates fuertes.
Anthropic official skill-creator v2 aporta el patrón canónico de eval (train/test split 60/40, trigger accuracy iterativo).
Ralph Wiggum loops aportan un patrón simple pero contundente: "cuando el agente diga done, un mecanismo externo debe decir 'not yet' basándose en evidencia".
Graphify aporta un patrón crítico que casi nadie tiene: verificación estructural determinista (AST tree-sitter) con distinción explícita EXTRACTED vs INFERRED.

Descubrimiento más importante: el concepto de "in agent land, the wrapper is the product" (Nate Jones, enero 2026). Los teams que compran mejores modelos ignorando su harness están optimizando la variable equivocada. Tu Control Plane es ese harness. La pregunta correcta no es "cómo hacer un agente más grande" sino "cómo definir el contrato de done y hacerlo verificable por un mecanismo independiente".

Cinco hallazgos accionables:

Tu Control Plane ya tiene la estructura correcta, pero le faltan tres capas críticas que la comunidad ya validó: (a) framework de evals de 3 tiers al estilo agent-skills, (b) loop de "done ≠ done" al estilo Ralph, (c) verificación estructural determinista al estilo Graphify.
La cobertura de tu Skills Layer está incompleta comparada con el estándar de la industria: te faltan doubt-driven-development, constraint-driven-development, source-driven-development y browser-testing-with-devtools — cuatro workflows que hoy son estándar en agent-skills y superpowers.
Tu Context Pack architecture (CORE/BUSINESS/NO_GO/SECURITY_RULES/CURRENT_STATE/DECISIONS) es superior a lo que ofrecen agent-skills y superpowers, que dependen del CLAUDE.md monolítico. Aquí tienes ventaja, pero necesitas skillbudget (medir tokens siempre-cargados con gate en CI).
Los hooks de tu control plane son sólidos pero conservadores: tienes 9, mientras que Claude Code hoy expone 30+ eventos (PreModelSwitch, PostToolBatch, PostToolUseFailure, TaskCompleted, InstructionsLoaded, ConfigChange, WorktreeCreate, FileChanged…). Hay oportunidades P0 sin explotar.
La respuesta correcta a "¿instalar addyosmani/agent-skills?" es: integración parcial (Estrategia B) — instalar sus skills de proceso genéricos como plugin, mantener tu Context Layer y tu State Layer, absorber su framework de evals. NO instalar completo (rompe tu progressive disclosure) ni ignorar (perderías el eval framework que es único).

El riesgo mayor detectado: confundir instrucción Markdown con enforcement. Una regla en no-go.md no tiene el mismo nivel de garantía que un hook exit 2. Tu sistema mezcla ambos sin taxonomía clara. Esto se corrige en la sección 13 (Enforcement Model).

Modelo de madurez propuesto: tu sistema está entre L3 y L4 (Hooks + Gates instalados; Independent Verification parcial). Para llegar a L5 (Evals + Learning Loops + Observability) faltan tres piezas concretas listadas en el roadmap (sección 18).

Presupuesto de complejidad: después de la investigación, la respuesta correcta al principio BENEFICIO > COMPLEJIDAD es que debes RESTAR más que SUMAR. Cinco componentes de tu control plane actual probablemente son AI-theater (ver sección 20, "AI Theater"). Los tres componentes P0 que faltan cubren tres agujeros verificables. El resultado neto es un sistema más pequeño y más efectivo.

2. CURRENT SYSTEM AUDIT

Auditoría de lo que el documento Claude Control Plane describe como implementado o planeado.

2.1 Inventario objetivo
Componente	Cantidad	Estado descrito	Nivel de verificación
Hooks	9	Implementados (bash-firewall, secret-guard, session-start, subagent-context, subagent-stop-logger, stop-logger, pre-compact-snapshot, config-change-logger, session-start-compact)	Enforcement real (exit 2) para 2 de ellos; los demás son logging/context injection
Skills de proceso	11	Implementados (/estado, /gate, /cerrar-fase, /checkpoint, /evidence, /adr, /no-go, /doctor, /audit-config, /audit-context, /recovery)	Guidance + audit, no enforcement estructural
Agent templates	4	Implementados (researcher, architect, implementer, security-auditor)	Instruction
Rules	4	Implementadas (security, git-policy, no-go, compliance)	Instruction
Context packs	6	Templates auto-documentados (CORE, BUSINESS, NO_GO, SECURITY_RULES, CURRENT_STATE, DECISIONS)	Instruction + progressive disclosure
Templates raíz	4	Implementados (CLAUDE.md, PROJECT_STATE.md, DECISION_REGISTRY.md, ARTIFACT_MANIFEST.md)	State + registry
settings.json	1	Implementado con permisos por defensa en profundidad	Enforcement (permission system)
install.sh	1	Implementado	N/A
2.2 Cobertura por capacidad
Capacidad	Existe	Calidad	Solapamiento	Falta	Prioridad	Mecanismo
Context	Sí	Alta (6 packs curados)	Ninguno	Skillbudget/CI gate del tamaño siempre cargado	P1	Herramienta externa (skillbudget)
State	Sí	Alta (PROJECT_STATE.md como fuente única)	Ninguno	Snapshot verificable + hash comparable	P2	Hook PreCompact ya lo hace parcialmente
Memory	Parcial	Media (memory/*.md sin duplicar state)	Con context packs si mal implementado	Política clara + budget	P2	Rule + skill
Hooks	Sí (9/30+)	Media	Ninguno	21 hooks disponibles sin usar	Ver detalle §2.3	Añadir hooks P0 concretos
Permissions	Sí	Alta (allow/ask/deny)	Ninguno	Nada	—	—
Security	Sí	Alta (bash-firewall + secret-guard + rules)	Ninguno	Threat model documento	P2	rule + adr
Agents	Sí	Media (4 templates)	Ninguno	doubt-reviewer, code-reviewer separado	P1	Añadir 2 agentes
Skills	Sí	Media (11 proceso, 0 dominio)	Con rules si mal delimitado	doubt-driven, source-driven, constraint-driven, browser-testing	P1	Adoptar del ecosistema
Rules	Sí	Media	Con no-go/context si mal delimitado	Taxonomía enforcement claro	P0	Sección 13
Testing	No	Baja	Ninguno	Framework testing dentro del control plane	P0	Ver §10
TDD	No	Baja	Ninguno	Skill test-driven-development con enforcement	P0	Adoptar de agent-skills
Planning	Parcial	Media	Sin skill dedicado	Skill planning-and-task-breakdown	P1	Adoptar
Specification	Parcial	Media	DECISION_REGISTRY podría hacer parte	Skill spec-driven-development, SPEC.md	P1	Adoptar
Code review	No	Baja	Ninguno	Skill code-review-and-quality + agente code-reviewer	P0	Adoptar
Debugging	No	Baja	Ninguno	Skill debugging-and-error-recovery (5-step)	P1	Adoptar
Observability	Parcial	Baja (logs)	Ninguno	Métricas + traces + budget	P2	Skill + hook
Performance	No	Baja	Ninguno	Skill performance-optimization	P3	Adoptar
Documentation	Parcial	Media (docs/ + templates)	Ninguno	ADR skill funcional (ya lo tienes) + docs-drift detector	P2	Extender
CI/CD	No	Baja	Ninguno	Skill ci-cd-and-automation, eval gates	P2	Adoptar
Release	No	Baja	Ninguno	Skill shipping-and-launch, changelog	P3	Adoptar
Recovery	Sí	Alta (/recovery E-{N})	Ninguno	Registry de recovery patterns compartido	P2	Extender
Evidence	Sí	Media (/evidence)	Con ADR	Evidence policy + trazabilidad automática	P1	Extender
ADR	Sí	Alta (DECISION_REGISTRY + /adr)	Ninguno	Nada	—	—
Gates	Sí (fase)	Media (/gate, /cerrar-fase)	Ninguno	Gates de calidad automatizables	P1	Extender
Evals	No	0	Ninguno	Framework tier 1/2/3 al estilo agent-skills	P0	Adoptar
Orchestration	Parcial	Baja (4 agentes, sin patterns)	Ninguno	Patterns document + persona-no-invoca-persona	P1	Adoptar del ecosistema
Incident learning	No	0	Ninguno	INCIDENT_REGISTRY → CONTROL_REGISTRY	P1	Diseñar (sección 14)
Regression prevention	Parcial	Baja	Ninguno	Tests + evals encadenados a incidentes	P0	Sección 14
Cost control	No	0	Ninguno	Token budget para context siempre-cargado	P0	skillbudget
Model routing	No	0	Ninguno	Política de model-per-agent	P2	Rule + agent frontmatter
Parallel execution	No	0	Ninguno	Guidance de fan-out/reduce	P2	Skill + orchestration doc
Worktree isolation	No	0	Ninguno	Hook WorktreeCreate/Remove	P2	Adoptar (existe en Claude Code)
Browser testing	No	0	Ninguno	Skill browser-testing-with-devtools	P2	Adoptar
Accessibility	No	0	Ninguno	Reference checklist	P3	Adoptar
Dependency mgmt	No	0	Ninguno	Skill dependency-upgrade (parte de code-review)	P2	Adoptar
Migration	No	0	Ninguno	Skill deprecation-and-migration	P3	Adoptar
2.3 Hooks disponibles vs hooks usados

Claude Code 2026 expone 30+ eventos (documentación oficial verificada). Tu control plane usa 9. Los 5 hooks P0 que te faltan y aportan enforcement real:

PostToolUseFailure — hoy no capturas fallos; cada fallo debería alimentar el INCIDENT_REGISTRY.
PostToolBatch — dispara antes de la siguiente llamada al modelo; permite gate de coste/complejidad tras una batch de escritura.
TaskCompleted — bloquea (exit 2) si un subagente marca una tarea como completada sin evidencia. Este es el enforcement del "not yet" de Ralph, hecho bien.
InstructionsLoaded — cada vez que se carga un CLAUDE.md o .claude/rules/*.md; permite auditar el context siempre-cargado y disparar skillbudget.
PreModelSwitch — bloquea cambios de modelo no autorizados por la política.

Hooks P1 útiles: WorktreeCreate, FileChanged (para docs-drift), PermissionDenied (para señalizar bloqueos y aprender de ellos).

2.4 Hipótesis no verificadas del propio Control Plane

El documento admite 5 hipótesis. Verificación contra docs oficiales (septiembre 2026):

SubagentStart.additionalContext llega al subagente: verificado. Está documentado en hookSpecificOutput.additionalContext para SubagentStart.
Campo skills: en frontmatter carga skills indicadas: parcialmente verificado. La documentación oficial reconoce hooks de skill en frontmatter con la clave hooks:. El campo skills: para cargar skills desde un agente no es un mecanismo estándar en la documentación oficial que vi. Este es un riesgo real de tu diseño.
PreToolUse recibe info para bloquear con exit 2: verificado (documentación completa de exit-code table).
Matchers separados de SessionStart: verificado — startup|resume|clear|compact|fork.
ConfigChange se activa al modificar settings: verificado.

Acción P0: rediseñar la carga de skills en agentes si el campo skills: en frontmatter no existe. La alternativa canónica es que el agente en su prompt inicial haga Read sobre los context packs, o que un hook SubagentStart inyecte additionalContext con las skills relevantes precargadas. Esto invalida parcialmente tu Execution Layer si no lo corriges antes de ganar más deuda arquitectónica.

3. EXTERNAL LANDSCAPE
3.1 Los tres grandes frameworks de skills (validación cruzada)
addyosmani/agent-skills: 92.4k stars, 25 skills, 4 agentes, 7 references. Evals de 3 niveles en CI. Comparada por Om Mishra (experimento controlado): más rápida a código (~8 min vs ~12), más pasadas de validación (7 vs 5), tokens equivalentes. Filosofía: encode SDLC completo con adversarial guards.
obra/superpowers: 234k+ stars, autor Jesse Vincent (Prime Radiant). Filosofía: autonomía, subagent-driven development con task reviewer, brainstorming socrático obligatorio. Fuerte en TDD RED-GREEN-REFACTOR forzado, débil en evals in-repo.
Matt Pocock's skills: sharp/opinionated toolkit diario, con "grill me" loop.

Las tres comparten ADN (skills como workflow, YAML frontmatter, progressive disclosure). Se diferencian en: profundidad de reasoning (superpowers), amplitud del SDLC (agent-skills), toolkit diario (pocock).

3.2 Anthropic canonical
Claude Code hooks (30+ eventos): hooks pueden ser command, http, mcp_tool, prompt, agent. Exit code 2 = block. hookSpecificOutput.additionalContext para inyectar contexto sin ser mensaje. Matchers pueden ser regex, exact string, | list. if field usa permission rule syntax.
Agent Skills: SKILL.md con frontmatter (name + description). Progressive disclosure de 3 niveles (metadata → body → bundled resources). Descripción como routing rule, no summary.
skill-creator v2 (anthropics/skills): framework de 4 modos (Create / Eval / Improve / Benchmark). Eval pipeline con 4 sub-agents: executor, grader, comparator, analyzer. Description optimization con train/test split 60/40. Este es el estándar canónico de facto.
Subagents: contexto aislado, Task tool. Regla dura documentada: "personas no invocan personas" — antipatrón B en agent-skills. No pueden pedir aprobación al humano mid-task.
Agent Teams: experimental, deshabilitado por defecto en 2026.
Dynamic Workflows: script JS que orquesta subagents deterministicamente. agent(), parallel(), pipeline(). Fan-out → reduce → synthesize.
3.3 Spec-driven development ecosystem
GitHub Spec Kit (open source, 30+ agents compatibles): spec en 4 fases con checkpoints claros.
Kiro (AWS, VS Code fork): spec → design → tasks → implementation. "Vibe coding" solo con permiso. Puede reducir timelines de meses a semanas (caso Cardinal Blue en drug discovery).
BMAD-METHOD: expansión packs por dominio.
Tessl: spec-as-source platform, hace evals portables.
OpenSpec: alternativa que agent-skills reconoce como format-agnostic; su spec-driven-development skill acepta OpenSpec sin duplicar SPEC.md.
3.4 Verification & evals
Anthropic skill-creator v2 (canónico): eval pipeline embedded, evals.json con expectations[] graded desde transcript.
agent-skills evals framework (3 tiers):
Tier 1: structural validation.
Tier 2: deterministic trigger-and-routing (rank-1 rate ≥ 80–86%, no permitir bajar el floor).
Tier 3: behavioral (grader semántico de traza de ejecución).
superpowers evals: bash + claude -p + prompt fixtures + grader scripts.
Meta JiTTest Challenge: mutation testing como estándar para AI-generated tests. Coverage y mutation son débilmente correlacionados con detección de bugs; mutation es más confiable.
MutGen: vanilla LLM prompt = 53% mutation score en HumanEval-Java; con mutation feedback = 89.5%. Este delta es el argumento cuantitativo para no confiar en coverage.
CodeMetaAgent: metamorphic relations para diversidad de test cases.
3.5 Zero-trust verification (research)
Meta-Engineering Harnesses (2026): contract-driven adversarial verification. Un agente implementa desde el contrato, otro agente escribe tests desde el mismo contrato sin ver la implementación. Independencia estructural: separate agents, separate job payloads, separate execution queues, no shared conversation history.
AI-ZTMM (Agentic AI Zero Trust Maturity Model, 2026): extiende CISA 5-pillar a "action verification" no solo access verification. Sitúa acciones (tool invocation, privilege delegation, memory use) como unidad independiente de evaluación.
HAARF (healthcare): red-team con 6 escenarios adversariales. Sin middleware, agente ejecuta tools no autorizadas en 56-60% de casos.
3.6 Otros frameworks/plugins relevantes 2026
SonarQube plugin en marketplace oficial: PostToolUse hooks corren análisis después de cada Edit. Pre-tool secrets scanning bloquea 450+ patterns. Quality gates in-loop. Este es el modelo canónico de cómo integrar tooling externo determinista al loop del agente.
Ralph Wiggum plugin / loop: while :; do cat PROMPT.md | claude-code ; done. Concepto: brute force + persistencia. El agente no decide cuándo termina; el harness decide con base a evidencia. Concepto simple, contundente. Ver §14 Learning Loop.
Graphify (screenshot que compartiste): tree-sitter AST determinista + distinción EXTRACTED vs INFERRED. Es un verificador estructural determinista. Es el patrón "no vector index" — no embeddings, un grafo real que se recorre. Aporte clave: taxonomía honesta de qué fue leído directamente del código vs qué fue inferido.
Grill / reason-grill / Docs Guardian / TDD Guardian / LOC Guardian (xiaolai marketplace): plugins que reifican gates concretos. TDD Guardian tiene per-lane gates (unit/integration/e2e/contract) y adversarial spec review.
Context Forge (webdevtodayjason/claude-hooks): PreCompact hook para preservar reglas críticas antes del compact.
Token Shield: 3-layer optimization con Context Guardian que auto-genera handoffs cuando el transcript pasa 2MB.
skillbudget (mujin): mide el token cost siempre-cargado y falla CI si excede el budget. Un enterprise setup documentó 143k de 200k tokens (72%) quemados solo en definiciones.
3.7 Comunidad / vivencias
Ralph loops en developer circles: Geoff Huntley y otros usan brute-force loops para clonar productos comerciales (~$10/hora). El propio autor está preocupado por lo que ha creado.
Nate's Substack (enero 2026): "the wrapper is the product". Métrica que importa hoy no es first-pass success sino convergence.
Anthropic GitHub issue #14882: skills oficiales de plugin-dev consumen tokens completos al startup (5.5k tokens), no solo su frontmatter. Progressive disclosure prometido, no siempre entregado. Este es un bug real y verificado del sistema Claude Code hoy.
CLAUDE.md bloat es la queja #1 de coste: KDnuggets reporta CLAUDE.md de 5000 tokens que cobra 5000 tokens cada turno. Recomendación Anthropic: mantenerlo bajo 200 líneas.
/rewind es más barato que /compact para desandar caminos: trunca a contexto ya cacheado. Insight de la comunidad que agent-skills y superpowers no documentan aún.
AI Coding Daily (14 enero 2026): existe un video "I Tried Ralph Wiggum Plugin for Claude Code" documentando la aplicación práctica.
4. RESEARCH SOURCES

Fuentes utilizadas, con etiqueta de confiabilidad.

Nivel A — Documentación oficial (autoritativa, verificable directamente):

code.claude.com/docs/en/hooks — fuente autoritativa para la API de hooks (30+ eventos, exit codes, JSON I/O, matchers, if syntax, once, HTTP hooks, MCP tool hooks, prompt/agent hooks).
platform.claude.com/docs/en/agents-and-tools/agent-skills/overview — definición canónica de skills.
code.claude.com/docs/en/agents — documentación oficial de subagents y agent teams.
code.claude.com/docs/en/plugin-marketplaces — schema de marketplaces.
github.com/anthropics/skills (skill-creator v2) — implementación canónica del eval pipeline.
github.com/anthropics/claude-plugins-official — marketplace oficial, incluye SonarQube y skill-creator.
www.anthropic.com/engineering/effective-context-engineering-for-ai-agents — el ensayo canónico de Anthropic sobre context engineering.
www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills — el anuncio original de skills.

Nivel B — Repositorios open-source de referencia (verificables, uso amplio):

github.com/addyosmani/agent-skills (92.4k ★) — 25 skills, evals de 3 tiers, docs/comparison.md.
github.com/obra/superpowers (234k+ ★) — TDD forzado, subagent-driven, brainstorming.
github.com/Graphify-Labs/graphify — tree-sitter AST determinista, EXTRACTED vs INFERRED.
github.com/xiaolai/claude-plugin-marketplace — TDD Guardian, LOC Guardian, Docs Guardian.
github.com/webdevtodayjason/claude-hooks — Context Forge PreCompact.
github.com/BAS-More/token-shield — 3-layer token optimization.
pypi.org/project/mujin-skillbudget/ — CI gate del always-loaded context.

Nivel C — Research académica (2025–2026):

Meta-Engineering Harnesses (arxiv 2605.25665) — contract-driven adversarial verification.
MutGen (Mutation-feedback test generation) — coverage vs mutation delta cuantificado.
AI-ZTMM (Sensors, MDPI PMC13517456) — action-centric zero trust.
HAARF (medrxiv 2026) — red-team empírico de agents con y sin guardrails.
Claude Code social science reproducibility (arxiv 2606.11447) — Claude Code 93.4% task accuracy vs Codex 62.1%.
GRASP (arxiv 2605.29668) — regression-aware skill proposer, Skill Library que evoluciona con gates.
ASG-SI (arxiv 2512.23760) — Audited Skill-Graph Self-Improvement con verifiable rewards.

Nivel D — Ensayos y observación empírica (opiniones informadas, no reproducibles):

Nate's Substack (natesnewsletter): "the wrapper is the product", verification gap.
Alexop.dev: Dynamic Workflows patterns (fan-out → reduce → synthesize).
Hidekazu Konishi: 3 guías profundas cross-verificadas contra docs oficiales de Claude Code (junio 2026).
KDnuggets / Security Boulevard: token optimization prácticas.
DEV.to (jamilxt, jul 2026): comparación honesta de Superpowers vs Agent Skills vs Pocock.

Conflictos detectados y resueltos:

Anthropic hook events count: documentación oficial dice 30+; blogs comunitarios dicen "6" o "8". Confiabilidad: documentación oficial actualizada más reciente (sept 2026) tiene la lista larga; los blogs quedaron desactualizados.
Progressive disclosure realidad vs promesa: la promesa oficial es "solo metadata en startup", pero el issue #14882 verificado muestra que en la práctica hoy skills oficiales consumen sus 5.5k tokens completos. Conclusión: creer la implementación medida, no la promesa arquitectónica. Diseñar defensivamente con skillbudget.
5. ADDYOSMANI ANALYSIS
5.1 Perfil objetivo
25 skills en 6 fases del SDLC (Define / Plan / Build / Verify / Review / Ship).
4 agent personas (code-reviewer, test-engineer, security-auditor, web-performance-auditor).
7 reference checklists.
8–9 slash commands para lifecycle.
Framework de evals de 3 tiers, único en el mercado.
MIT License.
92.4k stars, 9.8k forks, mantenido con npx skills CLI que instala en 70+ agents.
5.2 Fortalezas técnicas verificadas
Framework de evals de 3 tiers integrado en CI — nadie más lo tiene in-repo. Rank-1 rate del trigger, colisiones entre skills, behavioral grading.
doubt-driven-development: CLAIM → EXTRACT → DOUBT → RECONCILE → STOP. El reviewer recibe ARTIFACT + CONTRACT, no el CLAIM ni el reasoning. Independencia estructural real. Esto es research de zero-trust plasmado en un workflow práctico.
constraint-driven-development + CONSTRAINTS.md: catch a agents "silencing checks or skipping tests to get green". Detecta @ts-ignore, eslint-disable, tests skipped, assertions stripped. Único enfoque explícito contra AI gaming que encontré en el ecosistema.
source-driven-development: DETECT → FETCH → IMPLEMENT → CITE, cada decisión de framework citada inline. Combate directo contra el problema de "training data 6-18 meses vieja".
using-agent-skills como forced entry point: meta-skill como capa de routing. La comunidad reporta que ponerlo como primera línea de CLAUDE.md fuerza el árbol de decisión antes de cualquier otro skill.
references/ compartidos (definition-of-done.md, testing-patterns.md, security-checklist.md, performance-checklist.md, accessibility-checklist.md, observability-checklist.md, orchestration-patterns.md): hoja de referencia canónica compartida entre skills.
/build auto: Plan-Once-Run-All. Genera plan y ejecuta todas las tareas con test/commit gates por tarea. Pausa on failure. Elimina human step entre tareas, no la verificación.
Adversarial guards + Common Rationalizations table: cada skill tiene tabla de excusas típicas que el agente usa para saltarse pasos, con contra-argumentos documentados. Ejemplo: "I'll add tests later" → rebutted. Este es anti-drift semántico encoded.
5.3 Debilidades comparadas con tu Control Plane
No tiene State Layer (PROJECT_STATE.md). Cada sesión empieza sin conocer la fase.
No tiene INCIDENT_REGISTRY ni Learning Loop estructurado.
No tiene bash-firewall ni secret-guard como hooks P0 FAIL_CLOSED. Depende del permission system de Claude Code, que es más blando.
CLAUDE.md monolítico contra tus context packs modulares.
No trae SessionStart hook que inyecte estado del proyecto.
portability gap (#361) con npx skills add --skill <name>: cuando instalas un skill individual no baja references/, los paths a checklists rompen.
Instalación como plugin trae 25 skills; instalación selectiva es amigable pero pierde references.
5.4 Tres estrategias de adopción con análisis comparativo
Estrategia A — Instalación directa completa

Cómo: /plugin marketplace add addyosmani/agent-skills && /plugin install agent-skills@addy-agent-skills.

Ventajas:

25 skills probadas por la comunidad de golpe.
4 agentes personas listos.
Eval framework integrado.
Actualizaciones vía plugin.

Desventajas:

Colisión con tu Skills Layer actual. spec-driven-development (ellos) vs /adr (tuyo) — solapamiento parcial.
Colisión con tu no-go.md vs sus adversarial guards (semántica distinta, misma intención).
Su CLAUDE.md raíz no es reusable ("Do not copy this repository's root AGENTS.md or CLAUDE.md into the project"), lo cual la propia docs advierte.
Su using-agent-skills meta-skill compite con tu context-core/context-business como router.
skills: en frontmatter para cargar contextos: no está en su modelo. Rompes tu progressive disclosure a nivel de agente.
Sus 25 skills siempre-cargan sus descripciones (~2.5k tokens sólo por descriptions), medible con skillbudget.

Riesgo: Alto. Rompe tu diferenciación arquitectónica.

Estrategia B — Integración parcial (RECOMENDADA técnicamente)

Cómo: adoptar como plugin solo los skills que tu control plane no tiene, mantener tu Context Layer + State Layer + hooks + rules.

Skills a integrar (10 skills concretos, en orden de prioridad P0/P1):

P0: test-driven-development, code-review-and-quality, constraint-driven-development, doubt-driven-development.
P1: spec-driven-development, planning-and-task-breakdown, source-driven-development, debugging-and-error-recovery.
P1: incremental-implementation, context-engineering (adaptado).
P2: browser-testing-with-devtools, security-and-hardening, performance-optimization, observability-and-instrumentation.

Agentes a integrar: code-reviewer, test-engineer (los otros dos solapan con los tuyos).

References a adoptar completas: orchestration-patterns.md, definition-of-done.md, security-checklist.md, testing-patterns.md.

Eval framework a adoptar entero: evals/ con Tier 1/2/3.

Ventajas:

Ganancia inmediata en 10 workflows críticos con calidad de la industria.
Mantienes tu State Layer, tus hooks P0, tu progressive disclosure de agentes.
Skillbudget mantiene el gate del context always-loaded.
Eval framework te da el gate cuantitativo que hoy te falta.

Desventajas:

Requiere mapeo entre references/ de ellos y tu context/ propio.
Requiere una "capa de traducción" en using-agent-skills para saber cuándo delegar a tu State Layer.
Mantenimiento en dos velocidades (tu control plane + su release cadence).

Riesgo: Medio. Requiere disciplina de integración, pero preserva tu arquitectura.

Estrategia C — Estudiar y absorber patrones

Cómo: no instalar; leer los 25 SKILL.md y traducir a tu estructura de skills.

Ventajas:

Control total.
No hay conflicto de nombres.
Aprendes cada patrón profundamente.

Desventajas:

Reinventar y probable divergencia de calidad.
Pierdes las actualizaciones upstream.
Eval framework: reimplementar desde cero es costoso.
No aprovechas el testing empírico que la comunidad ya hizo.

Riesgo: Bajo técnicamente, alto en time-to-value.

Comparativa final
Criterio	A: completa	B: parcial	C: absorber
Time-to-value	Alto	Medio-alto	Bajo
Preservación de tu arquitectura	Bajo	Alto	Máximo
Costo de mantenimiento	Bajo	Medio	Alto
Riesgo de colisión	Alto	Medio	Nulo
Ganancia neta de skills	25	10-14	0 (traducidos)
Ganancia de eval framework	100%	100%	0-30%
Coste tokens siempre-cargado	Alto	Medio	Controlable

Recomendación (con transparencia sobre el trade-off): B. Es la estrategia con la mejor relación beneficio/complejidad y la que preserva el principio del prompt.

6. INTEGRATION MATRIX

Matriz por componente externo (columnas explicadas en el prompt maestro).

Componente externo	Qué hace	Existe en tu sistema	Solapamiento	Aporta	Integrar	Adaptar	No integrar	Razón
addyosmani: test-driven-development	RED-GREEN-REFACTOR forzado + adversarial guards	No	0%	Skill P0	Sí	Adaptar hooks a tus P0	—	Cierra gap crítico de testing
addyosmani: code-review-and-quality	5-axis review, change sizing, severity labels	No	0%	Skill P0	Sí	Adaptar rules → tus context packs	—	Cierra gap crítico de review
addyosmani: constraint-driven-development	CONSTRAINTS.md + detección de checks silenciados	No	20% (con no-go.md)	Skill P0	Sí	Fusionar con no-go.md	—	Único mecanismo anti-gaming
addyosmani: doubt-driven-development	Fresh-context adversarial review CLAIM→EXTRACT→DOUBT	No	0%	Skill P0	Sí	Sin cambios	—	Independencia estructural
addyosmani: spec-driven-development	SPEC.md como contrato	No	20% (DECISION_REGISTRY)	Skill P1	Sí	SPEC.md como artefacto en ARTIFACT_MANIFEST	—	Contrato del "done"
addyosmani: planning-and-task-breakdown	Descomposición atómica en tasks	No	0%	Skill P1	Sí	Plug directo	—	Base para /build auto
addyosmani: source-driven-development	Cita official docs para cada framework	No	0%	Skill P1	Sí	Sin cambios	—	Anti-drift de training data
addyosmani: incremental-implementation	Thin vertical slices	No	20% (fases)	Skill P1	Sí	Alinear con tus fases	—	Ejecución segura
addyosmani: debugging-and-error-recovery	5-step triage	Parcial (/recovery)	40%	Skill P1	Sí	Fusionar con tu /recovery	—	Estructura mejor definida
addyosmani: browser-testing-with-devtools	Chrome DevTools MCP	No	0%	Skill P2	Sí	Requiere MCP setup	—	Verificación runtime
addyosmani: agent code-reviewer	Persona de review	Parcial (agents)	40%	Agent P0	Sí	Adaptar frontmatter a tu Execution Layer	—	Independencia del implementer
addyosmani: agent test-engineer	Persona de testing	No	0%	Agent P0	Sí	Sin cambios	—	Independencia estructural
addyosmani: agent security-auditor	Persona de security	Sí	90%	Agent	—	—	No (mantener tuyo)	Ya tienes uno
addyosmani: references/definition-of-done.md	Standing bar	Parcial	30%	Reference P0	Sí	Fusionar con /gate	—	Contrato objetivo
addyosmani: references/orchestration-patterns.md	Patterns + antipattern B	No	0%	Reference P0	Sí	Doc separado	—	Guía crítica multi-agent
addyosmani: evals framework	3-tier evals	No	0%	P0	Sí	Sin cambios	—	Único cuantitativo
addyosmani: using-agent-skills meta-skill	Router de skills	Parcial (context packs)	60%	—	—	Fusionar con tus context packs	—	Ya tienes el router
addyosmani: /build auto	Autonomous plan+execute	No	0%	Command P1	Sí	Adaptar a fases	—	Elimina human step entre tasks
obra/superpowers: brainstorming	Socratic interview	Parcial (/adr)	30%	Skill P1	Adaptar	—	—	/adr no es interview
obra/superpowers: writing-plans	Micro-tasks 2-5 min	No	0%	Skill P2	Adaptar	—	—	Solapa con planning-and-task-breakdown de addy
obra/superpowers: using-git-worktrees	Isolated workspace	No	0%	Skill P2 + Hook	Sí	+ hook WorktreeCreate	—	Aislamiento seguro
Graphify: /graphify	AST determinista + EXTRACTED/INFERRED	No	0%	Verificador P1	Sí	Como plugin externo	—	Único deterministic structural
skillbudget	CI gate del always-loaded context	No	0%	Herramienta P0	Sí	Añadir a install.sh	—	Gate cuantitativo de coste
skill-creator v2 (anthropics)	Framework de evals canónico	No	0%	Framework P0	Sí	Como plugin externo	—	Estándar canónico
SonarQube plugin	Quality gate en PostToolUse hook	No	0%	Plugin P2	Sí	Optional	—	Quality gate real
Context Forge (webdevtodayjason)	PreCompact hook	Parcial (pre-compact-snapshot)	60%	Hook	Adaptar	—	—	Ya lo tienes parcial
Token Shield	Auto-handoff a 2MB	No	0%	Hook P1	Sí	Puede fusionarse con tu Stop hook	—	Convergencia con Ralph
Ralph Wiggum plugin	"Not yet" enforcement	No	0%	Concepto P0	Sí (concepto)	Como hook TaskCompleted	—	Contrato de done por evidencia
Anthropic hook: PostToolUseFailure	Captura fallos	No	0%	Hook P0	Sí	Alimenta INCIDENT_REGISTRY	—	Learning loop base
Anthropic hook: TaskCompleted	Bloquea done sin evidencia	No	0%	Hook P0	Sí	Con gate a EVIDENCE_REGISTRY	—	Ralph pattern real
Anthropic hook: InstructionsLoaded	Audita contexto siempre cargado	No	0%	Hook P0	Sí	+ skillbudget	—	Prevención de bloat
Anthropic hook: PreModelSwitch	Bloquea cambio de modelo	No	0%	Hook P1	Sí	Con política	—	Cost control
7. GAP ANALYSIS

Gaps que ni addyosmani/agent-skills ni tu Control Plane resuelven bien hoy. Cada gap tiene ID.

GAP-01 — Durable cross-session memory
Problema: ninguno de los 3 frameworks grandes resuelve memory persistente y verificable entre sesiones.
Por qué importa: cada /clear, /compact o resume pierde context. Trabajos largos degradan.
Soluciones existentes: Mem0, Memori (arxiv 2603.19935), knowledge graphs (Graphify), summarize-and-reinitiate.
Comunidad: session-notes.md pattern (buildtolaunch), Token Shield handoffs, Context Forge PreCompact snapshot.
addyosmani: reconocido en su docs/comparison.md como problema no resuelto.
Tu sistema: PROJECT_STATE.md + SessionStart hook — mejor que el promedio, pero no verifica que memory no se corrompa.
Falta: MEMORY_LEDGER.md con hash de estado, checkpoint verifiable en cada compact, PostCompact hook que valide.
Propuesta: pre-compact-snapshot.sh + post-compact-verify.sh que compare hashes de campos críticos (CURRENT_PHASE, ACTIVE_DECISIONS, BLOCKERS) antes/después. Diff → alerta.
Coste: bajo. Beneficio: alto. Prioridad: P0.
GAP-02 — Definition of Done contract-based, no conversational
Problema: "done" es señal conversacional, no contrato verificable con evidencia.
Por qué importa: es la raíz de todos los falsos "listo". Ralph Wiggum es un parche brute-force.
Soluciones existentes: definition-of-done.md (addyosmani), TaskCompleted hook (Claude Code), Ralph loop.
Comunidad: Nate: "the wrapper is the product". Sourcegraph: convergence > first-pass success.
addyosmani: tiene definition-of-done.md como reference, pero cada skill valida por su cuenta.
Tu sistema: /gate y /cerrar-fase parcialmente cubren, pero no bloquean.
Falta: TaskCompleted hook que exige un EVIDENCE_REGISTRY entry firmado antes de aceptar el done.
Propuesta: sección 9 (Verification Architecture).
Coste: medio (hook + skill + registry). Beneficio: crítico. Prioridad: P0.
GAP-03 — Independent verification structural
Problema: en la práctica el mismo agente escribe código y "verifica"; auto-confirmación.
Soluciones existentes: doubt-driven-development (addyosmani); Meta-Engineering Harnesses paper (arxiv 2605.25665); Graphify.
Comunidad: dual-pool adversarial review (DEV.to 2026-07-10) exige quotes específicas para findings.
addyosmani: doubt-driven-development es lo más cerca.
Tu sistema: security-auditor existe pero no es review sistemático de código.
Falta: code-reviewer agent con context aislado + prohibición estructural de invocar al implementer + evidencia obligatoria de quotes.
Propuesta: sección 9.
Coste: medio. Beneficio: alto. Prioridad: P0.
GAP-04 — Mutation testing como estándar
Problema: coverage es débilmente correlacionado con detección de bugs; MutGen midió delta 53% → 89.5% con mutation feedback.
Soluciones existentes: Stryker (JS), PIT (Java), Meta JiTTest Challenge.
Comunidad: Meta engineering blog (sept 2025): mutation testing es el próximo estándar.
addyosmani: no lo integra explícitamente.
Tu sistema: no.
Falta: post-test hook que corre mutation sample (10 mutantes) y bloquea si mutation score < X.
Propuesta: sección 10.
Coste: medio (setup por lenguaje). Beneficio: alto. Prioridad: P1.
GAP-05 — Incident → Control (Learning Loop)
Problema: cada bug repetido es una falla del sistema, no del agente. Ningún framework tiene INCIDENT_REGISTRY → nuevo control.
Soluciones existentes: ASG-SI (arxiv 2512.23760), GRASP (arxiv 2605.29668), Adaptive Data Flywheel MAPE (arxiv 2510.27051).
addyosmani: no.
Tu sistema: no (aunque tienes /recovery E-{N}, no cierra el loop de convertir en control permanente).
Falta: skill /incident + INCIDENT_REGISTRY.md + regla que exige nuevo test/hook/rule por incidente.
Propuesta: sección 14.
Coste: medio. Beneficio: alto compuesto. Prioridad: P1.
GAP-06 — Provenance / auditabilidad de artefactos
Problema: sabes que el agente hizo A, pero no si A vino de X.md, del training data, o fue alucinado.
Soluciones existentes: Graphify (EXTRACTED vs INFERRED), source-driven-development de addyosmani.
addyosmani: source-driven-development skill.
Tu sistema: /evidence pero no distingue tipos.
Falta: cada entrada en EVIDENCE_REGISTRY debe declarar source_type: (extracted|inferred|assumed|external).
Propuesta: extender tu /evidence.
Coste: bajo. Beneficio: alto para audit y compliance. Prioridad: P1.
GAP-07 — Context drift detection
Problema: docs, CLAUDE.md y código divergen silenciosamente.
Soluciones existentes: Docs Guardian (xiaolai marketplace), tu /audit-context.
addyosmani: no explícito.
Tu sistema: /audit-context existe.
Falta: FileChanged hook que dispare re-check cuando cambia CLAUDE.md o context packs.
Propuesta: hook nuevo + gate.
Coste: bajo. Beneficio: medio. Prioridad: P2.
GAP-08 — Prompt injection / context poisoning
Problema: contenido leído desde archivos externos o URLs puede contener prompt injection.
Soluciones existentes: OWASP Agentic Top 10 (memoria poisoning, tool misuse); Anthropic docs advierten sobre framing.
addyosmani: no explícito.
Tu sistema: no.
Falta: hook PreToolUse en Read/Fetch que sanitice o marque contenido untrusted.
Coste: medio. Beneficio: crítico en dominios sensibles. Prioridad: P1 (P0 si el proyecto maneja datos sensibles).
GAP-09 — Model routing por task
Problema: correr Opus para tareas triviales quema tokens.
Soluciones existentes: MindStudio guides, Adaptive Data Flywheel (Llama 70B → 8B fine-tuned).
addyosmani: no explícito.
Tu sistema: no.
Falta: política model-per-agent en frontmatter + PreModelSwitch hook.
Coste: bajo. Beneficio: medio-alto (coste). Prioridad: P2.
GAP-10 — Reproducibility / determinism del harness mismo
Problema: dos ejecuciones del mismo prompt producen resultados distintos.
Soluciones existentes: agent-skills evals con variance analysis (5-seed).
addyosmani: reconoce el problema en su eval framework.
Tu sistema: no.
Falta: /doctor debería incluir un smoke test reproducible.
Coste: bajo. Beneficio: medio. Prioridad: P2.
GAP-11 — Observability agregada
Problema: logs individuales de sesión no permiten ver patrones (tokens por skill, tasa de bloqueo por hook, latencia por agente).
Soluciones existentes: agenttrace (marketplace oficial), OpenTelemetry con Claude Code (prompt.id en events).
addyosmani: no.
Tu sistema: solo CLAUDE_SESSION_LOG.md.
Falta: skill /metrics que agrege JSONL de hooks y presente dashboard.
Coste: medio. Beneficio: alto para toma de decisiones. Prioridad: P2.
GAP-12 — Cross-tool / cross-provider fallback
Problema: si Claude Code no está disponible, workflow rompe.
Soluciones existentes: aiskillstore native invoke (Task subagents multi-provider).
addyosmani: skills funcionan en 70+ agents pero cada uno instalado por separado.
Tu sistema: monopolista Claude Code.
Falta: adaptador OpenCode / Codex mínimo (a partir de que tus hooks son bash, es viable).
Coste: alto. Beneficio: medio (opcional). Prioridad: P3.
8. WORKFLOW CATALOG

Aquí describo los workflows relevantes con la plantilla del prompt (adaptada; algunos campos consolidados por brevedad). Se muestran tres completos como demo de la plantilla; el resto en formato compacto.

Plantilla-tipo definitiva

Sobre la plantilla del prompt propongo dos mejoras: (1) añadir Trust boundary — quién puede modificar el workflow y quién solo ejecutarlo; (2) añadir Convergence signal — señal que dice cuándo el loop debe terminar.

Workflow 01 — SPEC → BUILD → SHIP (TDD lane completo)
Problema: agente rushea a código; ambigüedad → deuda.
Objetivo: producir código que pasa evidencia objetiva contra un contrato.
Cuándo se activa: feature nueva no trivial.
Cuándo NO se activa: fix de 1 línea, docs.
Principio: contract-first + independent verification.
Flujo:
  interview-me → spec-driven-development → planning-and-task-breakdown
  → constraint-driven-development (define CONSTRAINTS.md)
  → source-driven-development (cita docs)
  → RED: test-driven-development escribe test failing
  → gate: hook TaskCompleted verifica que existe test failing
  → GREEN: incremental-implementation
  → gate: tests pass
  → doubt-driven-development (fresh-context reviewer con ARTIFACT+CONTRACT)
  → code-review-and-quality (5-axis)
  → mutation-sample (10 mutantes; score ≥ 80%)
  → security-and-hardening
  → /gate (fase)
  → /cerrar-fase → git commit atomic
Agentes: main + code-reviewer + test-engineer + security-auditor. Personas no invocan personas.
Skills: 8-10.
Hooks: PreToolUse bash-firewall, PreToolUse test-must-exist, PostToolUse formatter, PostToolBatch quality gate, TaskCompleted evidence-check.
Rules: no-go + constraint diff detector.
Inputs: intent del usuario.
Outputs: SPEC.md, CONSTRAINTS.md, código, tests, evidence entry, ADR si aplica.
Estado: PROJECT_STATE.md pasa a NEXT_ALLOWED_PHASE cuando /gate ok.
Verificaciones: (a) tests failing existían, (b) tests pass, (c) mutation ≥ 80, (d) doubt-review pass, (e) code-review pass, (f) security scan clean.
Gates: /gate (fase), TaskCompleted (por tarea), doubt-driven (por decisión).
Evidencia requerida: EVIDENCE_REGISTRY entry con source_type + hash del test failing + logs mutation + reviewer sign-off.
Failure modes: (1) agente edita test para que pase; (2) agente reduce mutación quitando assertions; (3) reviewer valida su propio código por contexto compartido.
Recovery: /recovery E-01, E-02, E-03 correspondientes.
Anti-patterns: skipping RED, self-review, coverage-only metric.
Common rationalizations: "el test es trivial, no hace falta failing"; "mutation es slow"; "el review agent y yo tenemos el mismo contexto, es fine".
Human checkpoints: aprobación de SPEC, aprobación de ADR si es irreversible, aprobación de release.
Automatización posible: 85% (interview, spec, plan, test, code, review, security, gate). Human: aprobación de SPEC y release.
Coste: alto en tokens (5-10 agentes), justificado por evidencia auditable.
Beneficio: eleva del 60% first-pass a ~93% (números coherentes con Claude Code Reproducibility paper).
Riesgos: latencia. Mitigación: paralelizar reviewer + security + mutation.
Métricas: convergence rate, tests-first compliance, mutation score, review defects/kloc.
Evals: cada skill tiene eval Tier 2 (trigger rank-1 ≥ 80%) y Tier 3 (behavioral).
Dependencias: Claude Code v2.1.195+, plugin agent-skills (parcial), tu control plane.
Integración: gate al git push.
Trust boundary: solo humanos senior editan CONSTRAINTS.md; agentes solo leen.
Convergence signal: /gate PASS + evidence firmada.
Definition of Done: contrato de gap-02 (sección 9).
Workflow 02 — INCIDENT → CONTROL (Learning Loop)
Problema: bugs recurrentes; sistema no aprende.
Objetivo: cada incidente produce control permanente que previene su regresión.
Cuándo activa: fallo en test, en producción, en review, en post-mortem.
Cuándo no: fallos triviales que ya cubre un test existente.
Principio: Incident → Root cause → Missing control → New test/hook/rule/skill/eval → Regression coverage.
Flujo:
  Failure detected (hook PostToolUseFailure captura)
  → /incident open (skill nuevo)
  → INCIDENT_REGISTRY entry con: síntoma, contexto, reproducer
  → RCA con 5 whys
  → categorización: (missing test | missing hook | missing rule | missing skill | missing eval)
  → propuesta de nuevo control
  → human review (ADR si es cambio de rule/hook)
  → implementación del control
  → regression test que reproduce el incidente antes del fix
  → CONTROL_REGISTRY entry linkeando incident_id → control_id
  → eval que verifica el control (Tier 3)
  → REGRESSION_REGISTRY snapshot
  → verify el control bloquea si se revierte
  → cerrar incident
Agentes: main + researcher (RCA) + implementer (control) + code-reviewer (verify control).
Skills: /incident, /recovery, /adr.
Hooks: PostToolUseFailure abre incident automáticamente.
Estado: INCIDENT_REGISTRY.md, CONTROL_REGISTRY.md, REGRESSION_REGISTRY.md.
Verificación: (a) regression test existe y falla sin control, (b) regression test pasa con control, (c) eval Tier 3 valida.
Evidencia: hash del reproducer, screenshot del test failing, diff del control.
Failure modes: implementar el control sin regression test → placebo control.
Recovery: si el control resulta incorrecto, revert por ADR reversal.
Anti-patterns: cerrar incident sin control; control sin eval.
Human checkpoints: aprobación del control si toca reglas P0.
Automatización posible: 60%.
Coste: bajo por incidente, alto compuesto positivamente.
Beneficio: reducción de bugs recurrentes (evidence: ASG-SI, GRASP).
Métricas: MTBI (mean time between incidents del mismo tipo), regression coverage.
Convergence signal: eval Tier 3 verde + regression suite verde.
Workflow 03 — DOUBT (independent review de decisión no-trivial)
Problema: agente confirma su propio razonamiento por sesgo de contexto.
Objetivo: someter cada decisión no-trivial a reviewer con fresh context que solo ve ARTIFACT + CONTRACT.
Cuándo activa: (a) decisión irreversible, (b) código en área no familiar, (c) claim de completitud, (d) verificación cuesta menos que debug futuro.
Cuándo no: refactor trivial, docs.
Principio: CLAIM → EXTRACT → DOUBT → RECONCILE → STOP.
Flujo:
  Main agent enuncia CLAIM explícita
  → main agent extrae CONTRACT (invariantes, tipos, casos)
  → main agent extrae ARTIFACT (código/diff/spec)
  → spawn reviewer subagent con CONTRACT+ARTIFACT (NO reasoning, NO claim visible)
  → reviewer produce lista de DOUBTS con quotes específicos
  → main reconcilia (fix o rebate con evidencia)
  → repeat hasta STOP: 0 doubts o doubts explicitamente aceptados
Agentes: main + doubt-reviewer (fresh context).
Skills: doubt-driven-development.
Hooks: SubagentStart inyecta contract sin reasoning; PreToolUse en reviewer bloquea acceso a transcript del main.
Estado: registro por decisión.
Evidencia: quotes del reviewer, rebuttal firmado, hash del artifact.
Failure modes: (a) reviewer usa contexto contaminado; (b) main convence reviewer con retórica; (c) main omite CLAIM.
Anti-patterns: reviewer y main en misma conversación; reviewer sin quotes.
Human checkpoint: si doubt es rechazado, humano confirma.
Convergence signal: 0 doubts.
Evals: Tier 3 mide detection rate en artefactos con bug inyectado.
Workflow 04–16 (formato compacto)
W04 Requirements loop: interview-me → 95% confidence → SPEC.md.
W05 Research loop: source-driven-development → cita → EVIDENCE_REGISTRY (source_type: external).
W06 Planning loop: task-breakdown atómico → verify dependencies → planning approved gate.
W07 Implementation loop: thin vertical slice → test → verify → commit; hook PreToolUse test-must-exist en Edit sobre archivos de producción.
W08 Debugging loop: reproduce → localize → reduce → fix → guard (regression); /recovery skill actual + 5-step de addyosmani fusionados.
W09 Security loop: threat → change → scan → adversarial test → remediation → re-scan.
W10 Performance loop: baseline → change → benchmark → compare → regression detect → optimize.
W11 Documentation loop: code change → detect affected docs (FileChanged hook) → update → validate examples → link check.
W12 Dependency loop: dep change → compat analysis → vuln scan → tests → lockfile verify → build. SonarQube plugin cubre pieces.
W13 Release loop: verify → changelog → version → release-validation → deploy → smoke test → rollback-ready.
W14 Compact loop: PreCompact snapshot → summarize → PostCompact verify hashes → alert on drift.
W15 Model routing loop: task classify → cost estimate → PreModelSwitch guard → fallback.
W16 Skill lifecycle: create skill → evals Tier 1/2/3 → benchmark → deploy → eval on new tasks → deprecate.

Cada uno de W04–W16 debe documentarse con la plantilla completa en tu docs/. Están todos priorizados en la sección 18.

9. VERIFICATION ARCHITECTURE
9.1 Principio rector

Verification ≠ testing. Testing es un subset de verification. Verification incluye: static checks, mutation, contract adherence, code review por agente independiente, security scan, structural verification (Graphify), evidence trail, benchmark.

Regla dura: "el agente que produce un cambio NO tiene standing para declararlo done." Esto viene de tres fuentes independientes: addyosmani doubt-driven-development, Meta-Engineering Harnesses paper, Ralph Wiggum concept.

9.2 Definition of Done contract (gap-02)

Un cambio X está DONE si y solo si existe un EVIDENCE_REGISTRY entry E_X que satisface:

E_X.artifact_hash = sha256(diff)
E_X.spec_hash = sha256(spec_at_change_time)
E_X.checks_passed = { unit_tests, integration_tests, mutation_score, static_checks,
                     security_scan, structural_check, doubt_review, code_review }
E_X.reviewer_signature = sig(code_reviewer)
E_X.exceptions = []  // toda excepción va documentada + aprobada por humano
E_X.timestamp
E_X.convergence_iterations

Un TaskCompleted hook (Claude Code v2.1.84+) bloquea con exit 2 si no existe E_X válido. Esto es Ralph implementado bien.

9.3 Diversidad de verificadores (evitar homogeneidad)

Para no repetir el sesgo del implementer, mezclar:

Determinístico: lint, type-check, mutation, structural (Graphify AST).
LLM del mismo modelo, contexto fresh: doubt-reviewer.
LLM del mismo modelo, prompt distinto: code-review-and-quality.
LLM del mismo modelo, temperatura distinta o effort distinto: research 2026 muestra que effort=low y effort=high producen decisions diversas (Anthropic effort levels).
LLM externo opcional: aiskillstore native invoke pattern (Codex, Gemini).
Human review: solo en checkpoints P0.
9.4 Cuándo aplicar cada verificador
Contexto	Determinístico	Doubt	Review	Security	Structural	Cross-model	Human
Fix trivial (<10 LOC)	✓
Feature normal	✓	✓	✓
Cambio a auth/tenant	✓	✓	✓	✓		✓	✓
Cambio a estructura	✓	✓	✓		✓		✓
Cambio irreversible	✓	✓	✓	✓	✓	✓	✓
Rule/hook del control plane	✓	✓					✓ (obligatorio)
9.5 Anti-patrones frecuentes en verificación
Reviewer con acceso al reasoning del implementer (contamina).
Coverage como métrica principal (débilmente correlacionado con detección).
Human review después de agentes cansados (fatiga → firma sin leer).
Un solo verificador para todas las capas.
Verificar en "batch grande" al final (más tarde detectado, más caro corregido).
10. TDD / TESTING ARCHITECTURE
10.1 Loop TDD ejecutable (no solo RGR)
Task (with acceptance criteria)
  → Design test (spec de invariante)
  → Write failing test (RED)
  → Hook TaskCompleted rechaza si no hay test failing en el diff
  → Watch it fail with expected reason (evidence!)
  → Minimal implementation (GREEN)
  → Watch it pass
  → Static checks + mutation sample (kill ≥ 80% mutantes de la función)
  → doubt-review (fresh context: ARTIFACT+CONTRACT)
  → code-review-and-quality (5-axis)
  → Regression check (todo el test suite)
  → Commit atomic
  → EVIDENCE entry
10.2 Enforcement con hooks

Hook PreToolUse en Edit/Write sobre archivos src/**:

bash
# tdd-guard.sh
diff=$(get_pending_diff)
target=$(get_edit_target)

if is_production_code "$target"; then
  companion_test=$(find_companion_test "$target")
  if ! test_exists_and_fails "$companion_test"; then
    echo "TDD violation: no failing test for $target. Write RED first." >&2
    exit 2
  fi
fi

Este es el mecanismo real del test-driven-development de addyosmani hecho hook, no solo Markdown. Tú tienes la infraestructura para hacerlo; ellos solo tienen la regla.

10.3 Mutation testing en el loop
Herramientas por stack: Stryker (JS/TS), PIT (Java), mutmut (Python), Cargo Mutants (Rust), Go Mutesting.
Sample rate: 10 mutantes en la función editada, no full suite (cost-effective).
Gate: mutation score < 80% dispara warning; < 60% bloquea con exit 2.
Basado en MutGen (delta 53→89.5%) y Meta JiTTest Challenge.
10.4 Property-based & metamorphic (opcional, alto valor)
CodeMetaAgent (arxiv 2511.18249): metamorphic relations para input diversity — swap, permute, distributive, incremental. Test-cases más diversos que unit tests aislados.
Property-based (Hypothesis, fast-check, QuickCheck): agente escribe properties, tooling exhausta el espacio.
Regla: property-based es opcional pero recomendado para funciones puras con contrato claro.
10.5 Cuándo no aplicar TDD estricta

Excepciones explícitas y auditadas:

Refactor puro (behavior-preserving): tests existentes deben seguir pasando; no requiere nuevo RED.
Bug fix: RED = test que reproduce el bug; luego GREEN.
Migration: tests migran con el código.
Docs: no aplica.
Infrastructure as code: TDD raro; usar contract testing (terraform plan diffs).
Tests themselves: meta-tests que validan que los tests corren; se acepta escribir sin RED previo, pero se marca evidence.source_type = "meta".

Sin excepciones documentadas, TDD guard debe bloquear.

10.6 Prevención de gaming

Detectores concretos que constraint-driven-development inspira:

Diff que reduce assertions → bloquear.
Nueva línea @ts-ignore, eslint-disable, pytest.skip, xit, @Ignore → bloquear.
Test que expresa assertTrue(True) o equivalente → bloquear.
Test con nombre pero sin assertion → bloquear.
Umbral en config (coverage, mutation, complexity) editado a la baja → bloquear.

Todos son hooks PostToolUse con diff parsing en bash o grep. Enforcement real, no guidance.

11. AGENT ORCHESTRATION
11.1 Reglas duras (de docs oficiales + comunidad)
Personas no invocan personas (addyosmani orchestration-patterns.md, antipattern B).
Subagentes no pueden pedir aprobación mid-task (Anthropic docs, AskUserQuestion no disponible).
Subagentes no pueden spawnear otros subagentes (Anthropic docs).
Contexto isolation es el feature, no el problema: un subagente conserva su context, la parent conserva el suyo. Diseñar en base a esto.
Delegar "go find out X and tell me", no "let's work on this together" (hidekazu-konishi guide).
Model-per-agent: no correr Opus para agentes triviales.
11.2 Cinco patrones canónicos
P1 — Single agent (default)
User → Main

Trivial fixes, docs, single-file changes.

P2 — Subagent delegate
Main
  ↓ (Task tool con contexto acotado)
Subagent (fresh context)
  ↓ (returns summary)
Main sintetiza

Para investigación, exploración, verificación aislada.

P3 — Parallel fan-out
Main
  ├→ code-reviewer
  ├→ security-auditor
  └→ test-engineer
  ← Main sintetiza los tres reports

Para review multi-perspectiva. No para implementación (colisiones de escritura).

P4 — Sequential pipeline
interview-me → spec → plan → build → verify → review → ship

Es el flujo lifecycle de addyosmani; se puede parametrizar con Dynamic Workflows.

P5 — Hybrid (recomendado para features)
spec → plan
  ├─ parallel: security + tests
  ├─ code
  └─ parallel: doubt + review
        ↓
      merge → gate
11.3 Cuándo NO orquestar

Uso naif que quema tokens sin valor:

Task simple con subagent que solo lee un archivo → main puede hacer directo.
Agente que "revisa" trivialmente lo que el main acaba de hacer con el mismo contexto → self-confirmation costeada.
Fan-out de 3 agentes que responden lo mismo → agrega dinero sin diversidad.
11.4 Diversidad de opiniones sin explotar el costo

Estrategias baratas para introducir independencia sin spawnear muchos agentes:

effort=low vs effort=high en el mismo modelo produce decisiones distintas (Anthropic docs de effort).
Prompts diferentes: un review con "asume que este código va a producción crítica" y otro "asume que este es un prototipo desechable" difieren.
Determinístico primero: si un linter y un security scan matan el 60% de los bugs, no necesitas un LLM.
Cross-provider opcional: aiskillstore pattern para invocar Codex/Gemini solo en gates P0.
11.5 Costos comparados (guía)

Estimación (tokens por feature típica, orientativa):

Estrategia	Coste relativo	Detection uplift
Single agent	1×	baseline
+ linter + mutation	1.1×	+20%
+ doubt-reviewer	1.6×	+15%
+ code-review-and-quality	2.0×	+8%
+ security-auditor	2.4×	+5% (crítico en dominios sensibles)
+ cross-model verifier	3.5×	+3-5%

Regla: cada capa se justifica por (severidad del error prevenido × probabilidad) > costo. Para código no crítico, single + linter + mutation es la sweet spot.

12. CONTEXT ENGINEERING
12.1 Principios canónicos (Anthropic)
"El menor conjunto de tokens de alta señal que maximice la probabilidad del resultado deseado" (definition oficial).
Progressive disclosure de 3 niveles: metadata → SKILL.md body → bundled resources.
Just-in-time loading > pre-loading todo.
Compaction preserva decisiones y estado, descarta redundancia.
12.2 Arquitectura de información propuesta (síntesis con tu Control Plane)
Ubicación	Rol	Tamaño	Load timing
CLAUDE.md (raíz)	Instrucciones permanentes proyecto	≤ 150 líneas (~2k tokens)	Every turn
.claude/rules/security.md	Reglas dura de seguridad	≤ 40 líneas	Every turn
.claude/rules/git-policy.md	Reglas git	≤ 20 líneas	Every turn
.claude/rules/no-go.md	Anti-patrones espejo compacto	≤ 30 líneas	Every turn
.claude/rules/compliance.md	Compliance por jurisdicción	≤ 30 líneas	Every turn
.claude/context/CORE.md	Identidad técnica	≤ 100 líneas	On subagent start
.claude/context/BUSINESS.md	Contexto comercial	≤ 80 líneas	On subagent start (solo researcher/architect)
.claude/context/NO_GO.md	Anti-patterns extensos	≤ 60 líneas	On subagent start
.claude/context/SECURITY_RULES.md	Controles técnicos	≤ 60 líneas	On subagent start (arch, impl, security)
.claude/context/CURRENT_STATE.md	Mirror compacto de PROJECT_STATE	≤ 40 líneas	On subagent start (arch, impl)
.claude/context/DECISIONS.md	Mirror compacto de DECISION_REGISTRY	≤ 40 líneas	On subagent start (researcher, arch, security)
.claude/skills/**/SKILL.md	Workflows	metadata siempre, body on-demand	Progressive
references/*.md	Checklists compartidas	on-demand	On skill fire
PROJECT_STATE.md	Fuente única de state	Full	On SessionStart
DECISION_REGISTRY.md	Registry completo	Full	On demand
ARTIFACT_MANIFEST.md	Entregables por fase	Full	On demand
EVIDENCE_REGISTRY.md	Evidencia por change	Full	On demand
INCIDENT_REGISTRY.md	Fallos con RCA	Full	On demand
memory/*.md	Conocimiento persistente (NO duplicar state ni context)	Total ≤ 200 líneas	On demand
12.3 Anti-patrones de context
CLAUDE.md que crece a >200 líneas: cada línea cobra cada turno.
Context packs que duplican rules: CORE.md que redice security rules.
Memory que duplica PROJECT_STATE.md: contradicción silenciosa entre fuentes.
Descripciones de skill vagas ("helps with reviews"): no trigger reliable.
Referencias circulares en context packs: leen el mismo archivo dos veces.
12.4 Presupuesto de tokens siempre cargados (skillbudget)

Instalar pipx install mujin-skillbudget y añadir a CI:

skillbudget scan --budget 8000

Regla: sistema debe fallar CI si always-loaded > 8k tokens.

Fórmula sugerida:

CLAUDE.md ≤ 2k
Rules (4 archivos) ≤ 1k
Skill descriptions (~50 palabras × N skills) ≤ 3-4k
Overhead sistema ≤ 1k
Reserva ≤ 1k
12.5 Compaction resiliente
PreCompact snapshot hashea campos críticos de PROJECT_STATE.
Compaction resume incluye instrucciones específicas (Anthropic recomienda "focus on test output and code changes" para code-heavy sessions).
PostCompact verifica que los hashes de campos críticos coinciden; si no, alerta.
12.6 Just-in-time loading al estilo Graphify

Graphify es un ejemplo de context justo-a-tiempo: en lugar de cargar todo el árbol de archivos, el agente consulta el grafo. Aplicable a:

Consulta de decisiones: /adr query "auth" en lugar de leer DECISION_REGISTRY completo.
Consulta de incidentes: /incident query "flaky test".
Consulta de artifacts: /artifact query "phase 2".

Cada uno es un skill que retorna solo las entradas relevantes.

13. ENFORCEMENT MODEL

Taxonomía de mecanismos con nivel de garantía. Este es probablemente el aporte arquitectónico más importante para tu control plane.

13.1 Niveles
Nivel	Nombre	Descripción	Garantía	Ejemplo
L0	Instruction	Texto que el modelo puede seguir o ignorar	Baja	CLAUDE.md "always X"
L1	Guidance	Texto contextual con framing suave	Baja	NO_GO.md como referencia
L2	Skill workflow	Steps que el modelo debe seguir cuando la skill activa	Media	test-driven-development skill
L3	Permission	allow/ask/deny del sistema	Alta	settings.json permissions
L4	Deterministic validation	Herramienta externa (lint, test, mutation) verifica	Alta	mutation score gate
L5	Hook block (exit 2)	Bloqueo síncrono antes de ejecución	Muy alta	bash-firewall.sh, TaskCompleted evidence gate
L6	Independent agent verification	Reviewer con contexto aislado	Alta (menor que L4 porque LLM)	doubt-reviewer
L7	Cross-model verification	Modelo distinto verifica	Muy alta (más costosa)	Codex verifica Claude
L8	Human gate	Aprobación humana explícita	Máxima	ADR + firma
13.2 Regla dura

Cada regla del control plane debe declarar su nivel en su frontmatter o header. Ejemplo:

yaml
# no-go.md
---
level: L1  # guidance
enforcement: cross-reference-with-bash-firewall  # L5 subset
---

Y al lado, el mecanismo L5 correspondiente para el subconjunto técnicamente detectable.

13.3 Cuándo subir el nivel

Regla: si una violación causa daño irreversible o seguro compliance-critico → L5 o L8. Todo lo demás puede vivir en L1–L4.

Ejemplos concretos:

Leer .env → L5 (permission + hook + skill).
Cross-tenant query → L5 (hook Bash inspector + rule).
Deprecar API pública → L8 (human gate).
Estilo de commit → L1 (guidance).
Fase gate → L5 (hook TaskCompleted + skill).
TDD → L5 (hook + skill).
Doubt review → L2 + L6.
Mutation ≥ 80% → L4 (mutation tool) + L5 (gate).
13.4 Cuidados
L5 con condiciones difíciles de expresar en bash → tenderá a falsos positivos y bypasses ad-hoc. Preferir L4 + L2 cuando la condición es semántica.
L6 sin fresh context = L2 disfrazado. La independencia estructural (contexto separado + solo ARTIFACT+CONTRACT) es lo que le da al L6 su valor.
L8 excesivo agota humanos y termina siendo rubber-stamp. Reservar para P0.
13.5 Formato para tu documentación

Cada workflow, skill, agent y rule debería declarar su nivel de enforcement. Esto elimina la ilusión de que "escribí una regla en Markdown y ahora está enforced".

14. LEARNING LOOP

Diseño del Incident → Control (respuesta al gap-05 y a tu prompt sección 12).

14.1 Ciclo formal
INCIDENT
  ├── Symptom captured (auto por PostToolUseFailure hook o manual /incident open)
  ├── Reproducer (deterministic, minimal)
  ├── RCA (5-whys)
  ├── Missing control classification:
  │   ├── Test missing? → new test
  │   ├── Static check missing? → lint rule, custom check
  │   ├── Hook missing? → new PreToolUse hook
  │   ├── Rule missing? → rule + skill enforcement
  │   ├── Skill missing? → new skill
  │   ├── Eval missing? → new eval Tier 2/3
  │   └── Human check missing? → new checkpoint
  ├── Control proposal (ADR si toca reglas P0)
  ├── Control implementation
  ├── Regression test (falla sin el control, pasa con el control)
  ├── Registry entry (INCIDENT + CONTROL linked)
  └── Verify: revert control → regression fail → confirm control catches
14.2 Estructura de registros
INCIDENT_REGISTRY.md
  I-001: <date> · symptom · reproducer_hash · rca · control_id · status
  I-002: ...

CONTROL_REGISTRY.md
  C-001: <date> · type(test|hook|rule|skill|eval) · path · enforcement_level · incident_ids

REGRESSION_REGISTRY.md
  R-001: <date> · test_path · commits_touched · last_verified
14.3 Skill /incident
yaml
---
name: incident
description: Open, classify, and close an incident that produces a new permanent control. Use when an unexpected failure occurred, when a test caught a previously silent bug, when a bug slipped into production, when a review found a defect, or when a post-mortem is needed.
level: L2
---

Steps: open → capture symptom → produce reproducer → RCA → classify missing control → propose → implement → regression → register.

14.4 Regla dura

Un incidente P0/P1 no puede cerrarse sin un CONTROL_REGISTRY entry. Enforcement: hook TaskCompleted en la skill /incident que verifica el registry.

14.5 Separación de autoridad

Un agente puede proponer un nuevo control, no editarlo. La regla security.md y los hooks P0 solo cambian con:

ADR firmado por humano.
Merge desde branch dedicado.
Signature en el commit.

Esto responde a tu punto de la sección 28 del prompt: separar "agent may propose" de "agent may modify".

14.6 Métricas
MTBI (mean time between incidents del mismo tipo).
Coverage de INCIDENT_REGISTRY por CONTROL_REGISTRY (100% deseado).
Regression run stability (last-N runs green).
Learning velocity (incidents → controls por semana).
15. EVAL ARCHITECTURE

Adopción del framework de 3 tiers de addyosmani con extensiones para tu control plane.

15.1 Tier 1 — Structural
Cada skill tiene SKILL.md válido con frontmatter (name, description).
Cada agent tiene frontmatter válido.
Cada rule declara level:.
Cada eval declara min-rank1.
CI corre linter estructural.
15.2 Tier 2 — Trigger & routing (determinístico)
Cada skill tiene evals/cases/<name>.json con:
≥ 3 positive triggers.
≥ 2 negative triggers.
≥ 1 behavioral eval.
Rank-1 rate mínimo 80% (elevar a 95% cuando la calidad mejore).
No permitir bajar el floor bajo ninguna circunstancia (regla addyosmani).
Detección de colisiones: dos skills no deben triggerer con el mismo prompt.
15.3 Tier 3 — Behavioral
evals/fixtures/<name>/ con fixtures reales.
Grader escrito por humano; puede ser LLM-based, pero grader con contexto aislado.
Formato: evals.json canónico de Anthropic skill-creator v2.
Corre en modo headless (claude -p).
15.4 Tier 4 (extensión propia) — Adversarial

Nuevo tier propuesto para tu control plane, inspired por research de red-teaming:

Prompt-injection cases: input malicioso en context externo.
Gaming cases: agente intenta silenciar checks; detectar.
Regression cases: reproducer de cada incident registrado.

Corre en CI mensual, no cada push (costo).

15.5 Variance analysis
Correr cada eval con 5 seeds distintos.
Reportar mean + std.
Alertar si std > 20% (skill inconsistente).
15.6 Description optimization loop
Adoptar el patrón de skill-creator v2: 20 queries realistic + trigger/non-trigger judgments + 5-round iteration + 60/40 train/test split + escribir best description automáticamente.
Auditar cada 3 meses o después de descripción edit.
15.7 Skill regression
Cada release de un skill mantiene snapshot de eval Tier 2/3 score.
Nueva versión debe empatar o superar.
Si empeora, block con ADR.
15.8 Estructura de archivos propuesta
.claude/
  evals/
    README.md               (metodología)
    cases/
      test-driven-development.json
      doubt-driven-development.json
      ...
    fixtures/
      test-driven-development/
        input.md
        expected.md
    tier4/
      adversarial-injection.json
      gaming-attempts.json
      regression-suite.json
  scripts/
    run-evals.js            (Tier 1+2 en CI)
    run-behavioral.sh       (Tier 3 headless)
    run-adversarial.sh      (Tier 4 mensual)
    variance-analysis.py
16. DOCUMENTATION SYSTEM
16.1 Filosofía

Documentar el sistema como mecanismo de ingeniería, no como colección de prompts. Esto es directamente lo que exigió el prompt.

Cada documento debe permitir contestar 9 preguntas mecánicas:

Qué ocurre.
Por qué ocurre.
Quién lo hace.
Qué lo dispara.
Qué puede bloquearlo.
Qué evidencia produce.
Qué pasa si falla.
Cómo se recupera.
Cómo sabemos que funcionó.
16.2 Plantilla WORKFLOW mejorada

Adoptar la plantilla de tu prompt y añadir 6 campos:

markdown
# WORKFLOW — <NOMBRE>

## Problema que resuelve
## Objetivo
## Trigger conditions (cuando se activa)
## Non-trigger conditions (cuando NO se activa)
## Principio rector
## Flujo (con diagrama)
## Participantes (agentes, humanos, sistemas)
## Skills involucradas
## Hooks involucrados
## Rules involucradas
## Inputs (fuentes, formato)
## Outputs (destinos, formato)
## Estado modificado (qué archivos del State Layer cambian)
## Artefactos producidos
## Verificaciones (mecanismos y niveles L0-L8)
## Gates (dónde puede bloquearse)
## Evidencia requerida (formato en EVIDENCE_REGISTRY)
## Failure modes conocidos
## Recovery (link a skill /recovery E-N)
## Anti-patterns (lo que se ve pero está mal)
## Common rationalizations (excusas + counter)
## Human checkpoints (obligatorios vs opcionales)
## Automatización posible (% y qué queda humano)
## Coste esperado (tokens, latencia)
## Beneficio esperado (métrica)
## Riesgos y trade-offs
## Métricas y evals (Tier 1/2/3/4)
## Dependencias
## Integración con otros workflows
## Ejemplo completo (end-to-end)
## Definition of Done (contrato)
## Trust boundary (quién puede modificar el workflow)
## Convergence signal (señal de terminación)
16.3 Cross-linking
Cada workflow linkea a los skills que usa.
Cada skill linkea a los workflows que la invocan.
Cada hook linkea a las reglas que hace cumplir.
Cada rule linkea a los mechanisms que la implementan (L0-L8).
16.4 Doc drift detector
FileChanged hook en .claude/skills/** y docs/**.
Cuando cambia un skill, verificar que los ejemplos y evals se actualizaron.
Falla si docs referencian version antigua.
16.5 Estructura propuesta de documentación
docs/
  00_SYSTEM/
    01_ARCHITECTURE.md
    02_ENFORCEMENT_MODEL.md          (sección 13)
    03_CONTEXT_ENGINEERING.md        (sección 12)
    04_WORKFLOW_TEMPLATE.md
    05_EVAL_METHODOLOGY.md
  10_WORKFLOWS/
    W01_spec-to-ship.md
    W02_incident-to-control.md
    W03_doubt.md
    ...
  20_SKILLS/
    (index generado desde .claude/skills/)
  30_HOOKS/
    (índice + explicación de cada hook)
  40_AGENTS/
    (personas + orchestration-patterns.md de addyosmani)
  50_RULES/
  60_STATE/
    STATE_MODEL.md
  70_INCIDENTS/
    (index generado desde INCIDENT_REGISTRY)
  90_REFERENCES/
    definition-of-done.md
    testing-patterns.md
    security-checklist.md
    orchestration-patterns.md
17. TARGET ARCHITECTURE

Arquitectura objetivo derivada de la investigación. No es la del prompt sección 24 tal cual: se ajusta con lo aprendido.

17.1 Diagrama de capas
┌─────────────────────────────────────────────────────────────────┐
│                       HUMAN                                     │
│  (intent • approvals P0 • ADR sign-off • incident triage)       │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ REQUIREMENTS / SPEC LAYER                                       │
│  interview-me · spec-driven-development · constraint-driven     │
│  Artifacts: SPEC.md · CONSTRAINTS.md                            │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ PLANNING LAYER                                                  │
│  planning-and-task-breakdown · source-driven-development        │
│  Artifacts: tasks/plan.md · task references                     │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ CONTEXT LAYER                                (progressive)      │
│  CLAUDE.md · rules/* · context/* (CORE/BUSINESS/NO_GO/SEC/      │
│  CURRENT_STATE/DECISIONS) · references/*                        │
│  Governed by skillbudget CI gate                                │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ STATE LAYER                                (single source)      │
│  PROJECT_STATE.md · DECISION_REGISTRY · ARTIFACT_MANIFEST ·     │
│  EVIDENCE_REGISTRY · INCIDENT_REGISTRY · CONTROL_REGISTRY ·     │
│  REGRESSION_REGISTRY · MEMORY_LEDGER                            │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ ORCHESTRATION LAYER                                             │
│  Patterns P1-P5 · Persona-no-invoke-persona                     │
│  Model routing · Effort routing                                 │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ EXECUTION LAYER                                                 │
│  ┌─────────────┐  ┌────────────┐  ┌────────────┐               │
│  │ Agents      │  │ Skills     │  │ Tools/MCPs │               │
│  │ (personas)  │  │ (workflows)│  │ (det tools)│               │
│  └─────────────┘  └────────────┘  └────────────┘               │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ ENFORCEMENT LAYER                          (L0 → L8)            │
│  Hooks (P0 FAIL_CLOSED, P1/P2 FAIL_OPEN)                       │
│  Permissions (allow/ask/deny)                                   │
│  Deterministic validators (lint, mutation, structural/AST)      │
│  Independent verification (doubt-reviewer, code-reviewer)       │
│  Cross-model (opcional)                                         │
│  Human gates (ADR, approvals)                                   │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ VERIFICATION LAYER                                              │
│  Static · Tests · Mutation · Structural(Graphify) · Doubt ·    │
│  Review · Security · Contract · Regression · Observability      │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                        GATES                                    │
│    ┌───────────┐              ┌───────────┐                    │
│    │  FAIL     │              │  PASS     │                    │
│    └─────┬─────┘              └─────┬─────┘                    │
│          ▼                          ▼                           │
│      RECOVERY                     SHIP                          │
│   (incident open)                                               │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ LEARNING LOOP                                                   │
│  Failure → RCA → Missing control → New test/hook/rule/skill/    │
│  eval → Regression coverage → Registries updated                │
└────────────────────────┬────────────────────────────────────────┘
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ EVAL ARCHITECTURE                                               │
│  Tier 1: structural (CI)                                        │
│  Tier 2: trigger/routing rank-1 ≥ 80% (CI)                     │
│  Tier 3: behavioral (headless, sample)                          │
│  Tier 4: adversarial (mensual)                                  │
│  Variance analysis · Description optimization loop              │
└─────────────────────────────────────────────────────────────────┘
17.2 Cambios respecto a tu arquitectura original
Requirements/Spec Layer aparece como capa explícita.
Enforcement Layer con taxonomía L0-L8 explícita.
Learning Loop aparece como capa (era implícita).
Eval Architecture aparece como capa.
Context Layer gobernada por skillbudget (nuevo control).
State Layer amplía a INCIDENT/CONTROL/REGRESSION/MEMORY_LEDGER.
Orchestration Layer con reglas duras explicitadas.
17.3 Qué NO es esta arquitectura
No es un sistema de "más agentes es mejor".
No es una réplica de addyosmani o superpowers; es tu Control Plane + los mecanismos que le faltan.
No es una capa que reemplaza a Claude Code; es el harness alrededor de él.
No es final: evoluciona con Learning Loop.
18. PRIORITIZED ROADMAP
18.1 P0 — Ship en 2-4 semanas

Cierran riesgos concretos verificables.

#	Item	Origen	Effort	Impacto	Justificación
1	Verificar/rediseñar carga de skills en agents (hipótesis 2 no verificada)	Auditoría §2.4	S	Crítico	Tu Execution Layer podría no funcionar como esperas
2	Instalar skillbudget con CI gate 8k tokens	GAP context	XS	Alto	Previene bloat silencioso
3	Añadir hook TaskCompleted con Evidence gate	GAP-02, Ralph	M	Crítico	Elimina "done" conversacional
4	Añadir hook PostToolUseFailure → auto-abre incident	GAP-05	S	Alto	Base del Learning Loop
5	Añadir hook InstructionsLoaded con skillbudget check	Context bloat	S	Medio	Refuerzo del gate #2
6	Skill /incident + INCIDENT_REGISTRY.md	GAP-05	M	Alto	Base del Learning Loop
7	Adoptar skill test-driven-development (Estrategia B parcial)	Cobertura §2.2	M	Alto	Cierra gap testing
8	Adoptar skill code-review-and-quality + agent code-reviewer	Cobertura §2.2	M	Alto	Verificación independiente
9	Adoptar skill doubt-driven-development	GAP-03	S	Alto	Independencia estructural
10	Adoptar skill constraint-driven-development + CONSTRAINTS.md	Anti-gaming	S	Alto	Único en el mercado
11	Documentar taxonomía enforcement L0-L8 y aplicarla	§13	S	Medio	Elimina confusión Markdown-vs-hook
12	Definir Definition of Done contract (sección 9.2)	GAP-02	S	Crítico	Contrato objetivo
18.2 P1 — Ship en 1-2 meses
#	Item	Effort	Impacto
13	Adoptar spec-driven-development + SPEC.md como artifact	M	Alto
14	Adoptar planning-and-task-breakdown	S	Medio
15	Adoptar source-driven-development	S	Alto
16	Adoptar incremental-implementation alineado a fases	S	Medio
17	Fusionar /recovery con debugging-and-error-recovery de addyosmani	S	Medio
18	Framework evals Tier 1/2 con run-evals.js (adaptado)	M	Alto
19	Mutation sampling en Post gate (Stryker/PIT/mutmut)	M	Alto
20	Skill /incident extendido a CONTROL_REGISTRY + REGRESSION_REGISTRY	M	Alto
21	Provenance en /evidence (source_type: extracted/inferred/assumed/external)	S	Alto
22	Adoptar agent test-engineer	S	Medio
23	references/orchestration-patterns.md + regla persona-no-invoca-persona	XS	Alto
24	references/definition-of-done.md como source	XS	Alto
25	Prompt injection guard (PreToolUse en Read/Fetch)	M	Crítico si dominio sensible
18.3 P2 — Ship en 2-4 meses
#	Item	Effort	Impacto
26	Adoptar browser-testing-with-devtools (MCP setup)	M	Medio
27	Framework evals Tier 3 (behavioral headless)	M	Alto
28	Docs drift detector (FileChanged hook)	S	Medio
29	Model routing por agente	S	Medio (coste)
30	Hook PreModelSwitch con política	S	Medio
31	Hook WorktreeCreate/Remove para isolation	M	Medio
32	Observability skill /metrics con JSONL aggregation	M	Alto para decisiones
33	Adoptar security-and-hardening	S	Alto en dominios sensibles
34	Adoptar performance-optimization	S	Medio
35	Adoptar observability-and-instrumentation	S	Medio
36	Integrar Graphify como plugin externo (verificador estructural)	M	Alto
37	SonarQube plugin en PostToolUse (opcional)	M	Alto quality
18.4 P3 — Nice-to-have
#	Item	Effort	Impacto
38	Cross-provider fallback (Codex/Gemini adapters)	XL	Bajo
39	Framework evals Tier 4 adversarial	L	Medio
40	Ralph-style loop opcional para tareas de convergencia larga	S	Alto en casos específicos
41	Deprecation-and-migration skill	S	Bajo (hasta necesitarlo)
18.5 WHAT NOT TO BUILD (respuesta a la sección 41 del prompt)

Componentes que no deberías construir o deberías desmontar:

Un segundo State Layer: PROJECT_STATE.md ya es fuente única. No dupliques en memory/*.md.
Un skill dedicado a "run tests": es una instrucción trivial; usa el skill test-driven-development canónico.
Un agente researcher que solo web-searchea: es un one-shot Task tool. No amerita persona.
Un skill dedicado a "leer archivos": es tool nativo.
Un compliance monster con 20 reglas: mantén ≤ 5 reglas P0 en compliance.md.
Un dashboard custom de observability desde cero: usa OpenTelemetry integration existente en Claude Code.
Un sistema de plugins propio paralelo al de Anthropic: usa el marketplace oficial.
Un sistema de memory con embeddings: Graphify demuestra que un grafo simple sin embeddings gana en QA accuracy. No metas vector store gratis.
Un skill de "brainstorming" completo si ya tienes /adr: fusiónalos.
Un CLAUDE.md de 500 líneas: crece los context packs, no CLAUDE.md.
Sistema de A/B testing de prompts a mano: usa skill-creator v2 optimization loop.
Un agente CI/CD full: hooks + skill son suficientes; el CI ya tiene GitHub Actions.
18.6 TOP OPPORTUNITIES (sección 42 del prompt)

Ranking por (Impact × RiskReduction × HumanTimeSaved) / (Effort × MaintenanceCost):

#	Oportunidad	Score
1	TaskCompleted hook con Evidence gate	10
2	Adoptar addyosmani parcial (Estrategia B): TDD + review + doubt + constraint	9.5
3	Learning Loop (Incident → Control)	8.5
4	Enforcement taxonomy L0-L8 aplicada	8
5	skillbudget con CI gate	8
6	Framework evals Tier 1/2	7.5
7	Mutation sampling en gate	7
8	Definition of Done contract	7
9	PostToolUseFailure → auto-incident	7
10	Provenance en Evidence	6
11	Prompt injection guard	6 (10 en dominios sensibles)
12	Graphify como structural verifier	5.5
13	Model routing por agente	5
14	Ralph-style loop (donde aplica)	4
15	Cross-provider fallback	2
19. RISKS AND TRADE-OFFS
19.1 Riesgos técnicos
Enforcement rigid → bloqueo de trabajo legítimo. Mitigación: cada hook L5 tiene bypass documentado con ADR firmado y expira automáticamente.
Progressive disclosure prometida ≠ entregada. Anthropic issue #14882 documenta que skills reales cargan tokens completos. Mitigación: skillbudget + medición continua.
Verification agents con contexto contaminado. Mitigación: independence estructural (SubagentStart hook inyecta contract, prohibe reasoning del main).
Ralph-style loops pueden entrar en oscilación. Mitigación: convergence signal explícito + max iteraciones + stagnation detection (Ralph MCP v2 lo hace).
Mutation testing lento en projects grandes. Mitigación: sample rate 10 mutantes; corre full mensual en CI, sample por commit.
Docs drift silenciosa. Mitigación: FileChanged hook + doc-drift detector.
Skill collisions on routing. Mitigación: Tier 2 evals de colisión (canónico addyosmani).
Cross-tenant leak en subagents que comparten contexto por error. Mitigación: hooks bloqueando queries sin tenant_id; regla P0.
Prompt injection via archivos externos leídos. Mitigación: guard en PreToolUse Read/Fetch.
Human fatigue en gates P0. Mitigación: reservar humanos solo para irreversibles + ADR.
19.2 Riesgos organizacionales
Sobre-ingeniería del harness. El propio prompt lo advierte. Regla dura: cada componente responde a "¿qué problema real resuelve, con qué evidencia?"
Auditabilidad ilusoria. Un EVIDENCE_REGISTRY puede parecer riguroso y ser rubber-stamp. Mitigación: revisión manual periódica de 5-10 entries random.
Deuda de mantenimiento del control plane. Cada regla, hook, skill es código. Sugerencia: mantén ≤ 20 skills totales, ≤ 15 hooks totales.
Silo del control plane. Si solo una persona lo entiende, es un bus factor 1. Mitigación: documentación operativa + onboarding de al menos 2 personas.
Adopción parcial que rompe garantías. Ej: ejecutas TDD skill pero ignoras Evidence gate → apariencia de rigor sin sustancia. Mitigación: gates aplican a todos o a nadie por lane.
19.3 Trade-offs concretos
Elección	Ganancia	Coste
Verify más capas	Menor tasa de bugs	Más tokens, más latencia
Hooks L5 vs rules L1	Enforcement duro	Menos flexibilidad, más falsos positivos
Model per agent	Menor costo	Complejidad de routing
Mutation testing	Detección real	5-30% más tiempo por commit
Independence estructural (doubt-reviewer aislado)	Detección real	Dos veces los tokens de review
Ralph loop	Convergencia	Coste variable, alto en algunos casos
Learning Loop	Reducción de bugs recurrentes	Overhead de RCA por incidente
19.4 Cuándo NO seguir esta arquitectura
Proyecto de 1 persona a 1 mes: overkill.
Prototipo desechable: overkill.
Script one-off: overkill.
Equipo sin cultura de review/test: no tiene tracción organizacional.

En estos casos: usa Claude Code con CLAUDE.md de 100 líneas + 2 hooks P0 + agent-skills instalado. Punto.