1. EXECUTIVE SUMMARY

Resultado de la investigación: tu idea de un Engineering AI Development Control Plane es técnicamente viable y el ecosistema de 2026 ya valida varias de sus piezas, pero la arquitectura correcta no es “más agentes + más skills”. Es un harness verificable alrededor del coding agent, donde el agente produce artefactos y el sistema determina si esos artefactos cumplen un contrato.

Tu README describe ya una base importante: 5 capas principales, 9 hooks, 11 skills, 4 agent templates, 4 rules, 6 context packs, registros de estado y un settings.json de permisos.

La investigación anterior identificó correctamente buena parte de los gaps, pero la verificación actual obliga a corregir varias conclusiones:

TaskCompleted sí es un punto de enforcement real. Claude Code documenta que puede impedir que una tarea se marque como completada cuando el hook termina con código 2. Esto convierte el concepto “done ≠ done” en una implementación realista.
PostToolUseFailure existe, pero sirve principalmente para registrar fallos y devolver contexto correctivo; no debe tratarse como si fuera un bloqueo previo a la acción.
InstructionsLoaded y FileChanged existen, pero su valor es de auditoría/reactividad, no equivalen automáticamente a un enforcement L5.
La documentación actual de Agent Skills confirma progressive disclosure: metadata primero, el cuerpo de SKILL.md al activarse y recursos adicionales solo cuando se necesitan.
La hipótesis anterior de usar skills: en el frontmatter de un subagent como mecanismo estándar de carga no queda respaldada por la documentación actual consultada. Sí están documentados agentes en .claude/agents, skills separadas y hooks en frontmatter, pero no esa semántica específica.
Agent Teams siguen siendo experimentales y tienen limitaciones de reanudación y coordinación; no deben convertirse en el fundamento del Control Plane.
addyosmani/agent-skills sí tiene un framework de evals serio, con casos positivos/negativos y behavioral evals, y su repositorio explícitamente exige que cada nueva skill tenga estos casos y pase CI.
Mutation testing merece entrar en la arquitectura, pero no como “80% siempre”. La evidencia actual respalda que mutation score es una señal más fuerte que coverage para la capacidad de detectar fallos, y MUTGEN demuestra mejoras con feedback de mutaciones; también demuestra que mutation testing tiene coste y problemas de escalabilidad.
Spec Kit ha evolucionado considerablemente en 2026 hacia un harness extensible de workflows y procesos, no solo una metodología de specs. Esto lo vuelve relevante como referencia arquitectónica, aunque no significa que debas instalarlo completo.
GRASP respalda directamente tu Learning Loop, pero con una condición muy importante: las mejoras del sistema deben entrar mediante una regresión controlada, no por acumulación automática de instrucciones.
Tesis final

La arquitectura objetivo que recomendaría es:

HUMAN INTENT
     ↓
REQUIREMENT / SPEC
     ↓
PLAN
     ↓
EXECUTION
     ↓
DETERMINISTIC VALIDATION
     ↓
INDEPENDENT REVIEW (solo cuando aporta)
     ↓
EVIDENCE
     ↓
GATE
   ↙   ↘
FAIL   PASS
 ↓       ↓
RECOVER  SHIP
   \     /
    LEARN
      ↓
REGRESSION + CONTROL + EVAL

Pero haría un cambio fundamental respecto al diseño previo:

Verification debe ser una arquitectura de capas, no una pila fija de agentes.

Un feature pequeño no necesita cuatro agentes. Un cambio de autenticación sí puede requerir varios verificadores. El sistema debe seleccionar verificaciones según riesgo, reversibilidad y coste.

EVIDENCE: documentación oficial + OSS + research académico.
CONFIDENCE: alta.

2. CURRENT SYSTEM AUDIT
2.1 Estado real que puedo afirmar

El README es explícito respecto a lo que el sistema pretende instalar: hooks, skills, agents, rules, context packs, templates y settings.

También documenta claramente el ciclo operativo:

SessionStart recupera estado.
PreToolUse protege Bash y escritura.
SubagentStart inyecta estado.
Stop y SubagentStop registran actividad.
PreCompact crea snapshot.
los comandos operativos actualizan las fuentes de verdad.
Matriz actualizada
Capacidad	Existe	Calidad	Gap principal	Prioridad
Context	Sí	Alta	Budget medido y gobernado	P1
State	Sí	Alta	Integridad/verificación del snapshot	P1
Memory	Parcial	Media	Política fuerte de ownership	P2
Hooks	Sí	Alta	Mejor selección, no necesariamente más	P1
Permissions	Sí	Alta	Integrar con policy model	P1
Security	Sí	Alta	Threat model + prompt injection	P1
Agents	Sí	Media	Reviewer/verification roles	P1
Skills	Sí	Media	Workflows SDLC faltantes	P1
Rules	Sí	Media	Enforcement level explícito	P0
Testing	Parcial/No documentado	Baja	Harness verificable	P0
TDD	No documentado	Baja	Workflow + guardrails	P0
Planning	Parcial	Media	artefacto estructurado	P1
Specification	Parcial	Media	contrato formal	P1
Code review	No	Baja	reviewer independiente	P0
Debugging	Parcial	Media	reproducibility loop	P1
Observability	Parcial	Baja	métricas de control plane	P2
Performance	No	Baja	bajo demanda	P3
Documentation	Sí	Media	drift detection	P2
CI/CD	No documentado	Baja	quality gates	P1
Release	No	Baja	posterior al core	P3
Recovery	Sí	Alta	linkear incidentes	P1
Evidence	Sí	Media	schema/provenance	P0
ADR	Sí	Alta	no requiere duplicación	—
Gates	Sí	Media	gates deterministas	P0
Evals	No	0	Tier 1/2/3	P0
Orchestration	Parcial	Media-baja	patterns/risk routing	P1
Incident learning	No	0	Incident → Control	P1
Regression prevention	Parcial	Baja	registry/evals	P0
Cost control	No	0	context/model budgets	P1
Model routing	No	0	posterior al baseline	P2
Parallel execution	No	0	selectivo	P2
Worktree isolation	No	0	useful for parallel change	P2
Browser testing	No	0	only for UI/risky flows	P2
Accessibility	No	0	reference checklist	P3
Dependency management	No	0	lifecycle skill	P2
Migration	No	0	demand driven	P3
Deprecation	No	0	demand driven	P3
Data validation	Parcial	Baja	domain-specific	P1
API contracts	Parcial	Baja	explicit contract testing	P1
Infrastructure verification	Parcial	Baja	IaC-specific validators	P2
Prompt injection	No documentado	Baja	trust boundaries	P1
Context drift	Parcial	Media	automatic detection	P2
Provenance	Parcial	Media-baja	extracted/inferred/external	P1

Fuente principal: README + investigación histórica del sistema.

Limitación crítica de la auditoría

No me has adjuntado todavía el árbol real de:

.claude/
  hooks/
  agents/
  skills/
  rules/
  settings.json

por lo que no puedo afirmar que los 9 hooks, 11 skills y 4 agents del README estén actualmente implementados exactamente así. El README es intención/documentación del sistema; el master document incluso ordena explícitamente no confundir documentación histórica con estado actual.

Por eso separo:

VERIFIED FROM ATTACHED MATERIAL: arquitectura e inventario documentado.
NOT YET VERIFIED: wiring real actual de cada componente.

3. EXTERNAL LANDSCAPE
3.1 Anthropic / Claude Code

La plataforma actual tiene:

permissions con allow, ask, deny;
hooks de ciclo de vida;
skills;
subagents;
plugins;
Agent Teams experimentales.

Esto es importante porque tu arquitectura no debería reproducir infraestructura que Claude Code ya provee.

Lo que Claude Code ya resuelve bien
permission enforcement
hook lifecycle
skill discovery
subagent isolation
plugin distribution
configuration

Tu Control Plane debe agregar la política de ingeniería y verificación, no reemplazar esas primitivas.

3.2 Agent Skills

La documentación actual confirma que las skills son directorios con SKILL.md, frontmatter y recursos opcionales; el body se carga cuando la skill se usa.

Además, Claude Code ha fusionado conceptualmente comandos y skills: un comando en .claude/commands/ y una skill correspondiente pueden exponer el mismo tipo de interfaz.

Implicación: tu diseño debe reducir la cantidad de capas artificiales entre /command → skill → workflow.

3.3 addyosmani/agent-skills

El repo actual describe un lifecycle muy completo:

DEFINE
PLAN
BUILD
VERIFY
REVIEW
SHIP

y tiene un meta-skill para routing, más workflows especializados para specification, planning, implementation, testing, debugging, review, security, performance, docs, CI/CD y shipping.

Más importante todavía: el repositorio exige evals por skill y un conjunto mínimo de triggers positivos, negativos y behavioral cases; además usa CI para comprobarlo.

3.4 Superpowers

Superpowers evolucionó en 2026 hacia un modelo con más aislamiento por plan y revisión más estructurada. Su release 6.2 introdujo workspace por plan precisamente porque se había observado contaminación entre planes; la 6.3 añadió checks previos y registro explícito de conflictos.

Lección arquitectónica: el estado del workflow también puede contaminarse. Tu PROJECT_STATE.md necesita scope e identity, no solo “estado actual”.

3.5 GitHub Spec Kit

La versión actual ya no es solamente “spec → plan → tasks”. Se presenta como un harness extensible para workflows y procesos, con SDD, bug fixing, idea assessment, extensiones, presets y workflows.

Lección: el mercado está convergiendo en “workflow harness”, no en simples prompt packs.

3.6 Graphify

Graphify ofrece una capa de conocimiento estructural basada en AST local y etiqueta relaciones como EXTRACTED, INFERRED y AMBIGUOUS.

Esto encaja extremadamente bien con tu filosofía de provenance.

No recomiendo que construyas “tu propio Graphify”.

Recomiendo usar el patrón:

FACT = source-derived
INFERENCE = derived
AMBIGUOUS = unresolved
3.7 Skill-creator de Anthropic

Anthropic publica un pipeline de creación/evaluación que:

define evals.json;
registra expectations;
soporta improve/benchmark;
guarda pass rates;
registra tokens/tiempo;
detecta evaluaciones no discriminantes y alta varianza.

Esto debería ser la base de tu Skill Eval Architecture.

3.8 Mutation testing

La investigación moderna es clara en un punto: line/branch coverage no garantiza una buena capacidad de detectar defectos.

MUTGEN reporta casos donde una suite puede alcanzar 100% coverage y tener mutation score muy bajo, y propone incorporar feedback de mutaciones durante la generación de tests.

La publicación posterior del trabajo en IEEE TSE confirma la línea de investigación y su evaluación en 204 sujetos.

Meta también está experimentando industrialmente con mutation-guided testing, pero subraya que existen costes significativos: volumen de mutantes, mutantes equivalentes, computación y disminución de retornos.

Conclusión: mutation testing sí, pero selectivo.

4. RESEARCH SOURCES
Nivel A — fuente primaria / autoridad
Fuente	Tipo	Qué verifica
Claude Code Hooks	Oficial	eventos, lifecycle y blocking
Claude Code Permissions	Oficial	allow/ask/deny
Claude Code Skills	Oficial	skill lifecycle/progressive disclosure
Claude Code Plugins	Oficial	plugins/agents/skills
Claude Code Agent Teams	Oficial	modelo experimental
Anthropic Agent Skills	Oficial	skill architecture
anthropics/skills	OSS oficial	eval framework
GitHub Spec Kit	OSS oficial	spec/workflow harness

Ejemplos de evidencia: hooks y TaskCompleted ; permissions ; skills .

Nivel B — OSS de referencia
addyosmani/agent-skills.
obra/superpowers.
Graphify.
Matt Pocock skills.
Nivel C — research
GRASP.
MUTGEN.
Self-Improvements survey.
Nivel D — evidencia empírica/ensayos

Útiles para hipótesis y patterns, pero nunca sustituyen docs o benchmarks.

Contradicciones detectadas

Contradicción 1 — progressive disclosure

Fuente oficial: skill body se carga cuando se activa.
Investigación anterior: se advertía que determinadas implementaciones/casos podían consumir más contexto del esperado.

Conclusión: la arquitectura debe asumir el contrato oficial, pero medir el coste real en tu instalación. No diseñaría alrededor de una cifra fija como “8k” sin haber medido tu repo.

Contradicción 2 — enforcement

PostToolUseFailure es reactivo.
TaskCompleted sí permite bloquear la finalización.

Por tanto, no deben tratarse como equivalentes.

5. ANALYSIS DE addyosmani/agent-skills
COMPONENT: addyosmani/agent-skills

PURPOSE: cubrir el lifecycle de ingeniería como workflows reutilizables.

PROBLEM: tu sistema tiene infraestructura de control, pero menor cobertura de workflows de desarrollo.

CURRENT SYSTEM: 11 skills de proceso, context packs, commands y state.

OVERLAP: alto en infraestructura; bajo en workflows SDLC.

Lo que más aporta

El meta-routing actual cubre explícitamente:

interview
spec
plan
implementation
testing
debugging
review
security
performance
documentation
shipping

y no obliga a usar todas las skills en cada tarea.

Eso es exactamente la filosofía que tu Control Plane necesita.

Evals

El repo actual exige:

≥3 positive triggers;
≥2 negative triggers;
≥1 behavioral eval;
fixtures reales cuando corresponde.

Esto es mucho más valioso para tu arquitectura que copiar 20 SKILL.md.

Estrategias
Estrategia	Resultado
Instalar todo	Máxima cobertura inmediata, máxima colisión
Integrar selectivamente	Cobertura + preservación arquitectónica
Absorber patrones manualmente	Control máximo, mantenimiento máximo

La opción técnicamente más coherente con tu principio beneficio > complejidad es:

integración selectiva + adopción del eval framework + no copiar su arquitectura raíz.

EVIDENCE: OSS + documentación.
CONFIDENCE: alta.

6. INTEGRATION MATRIX
Componente	Existe en tu sistema	Acción
interview-me	Parcial	Adoptar/adaptar
spec-driven-development	Parcial	Adoptar
planning-and-task-breakdown	No	Adoptar
incremental-implementation	No	Adoptar
test-driven-development	No	Adoptar
code-review-and-quality	No	Adoptar
doubt-driven-development	No	Adoptar
constraint-driven-development	Parcial	Fusionar con no-go
source-driven-development	No	Adoptar
debugging-and-error-recovery	Parcial	Fusionar con /recovery
browser-testing	No	Solo lane UI
security-and-hardening	Parcial	Adoptar/adaptar
observability	Parcial	Adoptar
orchestration references	No	Adoptar
definition-of-done	Parcial	Adoptar como contrato
eval framework	No	Adoptar
Superpowers orchestration	No	Estudiar patrones
Graphify	No	Integrar opcional
Spec Kit	No	No instalar como base
Agent Teams	No	No convertir en dependencia
Skillbudget	No	Medir primero; adoptar si aporta
SonarQube	No	Integración por stack
Ralph	No	Adoptar como patrón conceptual
custom plugin manager	No	No construir
Decisión arquitectónica

Tu sistema debe convertirse en:

YOUR CONTROL PLANE
    +
selected external workflows
    +
native Claude enforcement
    +
deterministic verification

No:

YOUR CONTROL PLANE
 + agent-skills
 + superpowers
 + spec-kit
 + 20 plugins
 + 12 orchestration layers
7. GAP ANALYSIS
GAP-01 — Evidence-based Definition of Done

Problema: el agente puede declarar éxito antes de que exista evidencia suficiente.

Por qué importa: es el mayor punto de fallo del control conversacional.

Soluciones: TaskCompleted, DoD references, CI gates.

Qué hace addyosmani: proporciona un DoD y calidad de cierre.

Qué hace tu sistema: /gate, /cerrar-fase, evidence registry.

Falta: vínculo obligatorio entre task completion y evidencia.

Propuesta:

TaskCompleted
    ↓
load task contract
    ↓
verify evidence manifest
    ↓
verify required checks
    ↓
PASS / BLOCK

Coste: medio.
Beneficio: crítico.
Prioridad: P0.

EVIDENCE: docs oficial + architecture inference.
CONFIDENCE: alta.

GAP-02 — Independent Verification

Problema: autoverificación circular.

Falta: reviewer recibe solamente:

ARTIFACT
CONTRACT
EXPECTED BEHAVIOR

y nunca:

implementer reasoning
implementer claim
chat history

Propuesta: verification-reviewer fresh context.

Coste: medio.
Beneficio: alto.
Prioridad: P0/P1 según riesgo.

GAP-03 — Learning Loop

Problema: un incidente puede volver a ocurrir sin cambiar el sistema.

GRASP aporta evidencia relevante: mejorar skills funciona mejor cuando existe una acceptance gate con regression budget que cuando simplemente se acumulan instrucciones.

Propuesta:

INCIDENT
 → ROOT CAUSE
 → MISSING CONTROL
 → REGRESSION CASE
 → CONTROL
 → EVAL
 → ACCEPT / REJECT

Coste: medio.
Beneficio: compuesto.
Prioridad: P1.

GAP-04 — Skill Eval Infrastructure

Problema: skill bien escrita ≠ skill que funciona.

Falta: Tier 1/2/3 + regression.

Propuesta: adoptar estructura evals.json de Anthropic/addyosmani.

Prioridad: P0.

GAP-05 — Test Quality

Problema: coverage puede convertirse en una métrica de apariencia.

Falta: mutation testing selectivo.

Propuesta:

unit/integration
      ↓
coverage
      ↓
mutation sample
      ↓
survivors
      ↓
test strengthening

La investigación apoya mutation score como señal más fuerte de fault detection que coverage aislado.

Prioridad: P1.

GAP-06 — Provenance

Tu /evidence debe diferenciar:

EXTRACTED
INFERRED
ASSUMED
EXTERNAL
GENERATED

Graphify demuestra la utilidad de separar explícitamente extracción de inferencia.

Prioridad: P1.

GAP-07 — Context / State Integrity

Tu PROJECT_STATE.md es valioso porque actúa como fuente operativa única.

El siguiente paso no es otra memoria. Es:

snapshot
→ hash critical state
→ compaction
→ validate
→ detect drift

Prioridad: P1.

GAP-08 — Prompt Injection / Trust Boundary

El sistema debe distinguir:

TRUSTED CONTROL PLANE
TRUSTED PROJECT SOURCE
UNTRUSTED INPUT
UNTRUSTED WEB
UNTRUSTED GENERATED CONTENT

El principio debe ser:

contenido que el agente lee no obtiene autoridad simplemente por estar dentro de un archivo.

Claude Code ya ofrece permisos y hooks como primitives de control.

Prioridad: P1.

GAP-09 — Risk-based Verification

Tu arquitectura anterior era demasiado binaria:

task → muchos verificadores

La versión correcta es:

RISK
├── low → deterministic
├── medium → deterministic + review
├── high → deterministic + independent review + security
└── irreversible → human gate

Prioridad: P0 como arquitectura conceptual.

GAP-10 — Workflow State Isolation

Superpowers encontró problemas reales de contaminación entre planes y respondió haciendo el workspace específico por plan.

Tu control plane debe llevar:

workflow_id
plan_id
task_id
session_id
artifact_set

No basta con CURRENT_PHASE.

Prioridad: P1.

8. WORKFLOW CATALOG
WORKFLOW: W01 SPEC → BUILD → VERIFY → SHIP

TRIGGER: feature no trivial.

NON-TRIGGER: typo, docs simples, cambio trivial.

INPUT: intent + repo + constraints.

PRECONDITIONS: workspace limpio o snapshot explícito.

STEPS:

definir requisitos;
crear SPEC.md;
crear acceptance criteria;
crear plan;
ejecutar slices;
crear tests;
implementar;
validar determinísticamente;
revisión independiente según risk;
generar evidence;
gate;
commit/ship.

AGENTS: main + reviewers opcionales.

SKILLS: spec, planning, implementation, TDD, review.

HOOKS: PreToolUse, TaskCompleted, PostToolUseFailure.

TOOLS: test runner, linter, type checker, mutation tool.

STATE: PROJECT_STATE.md, task ledger.

ARTIFACTS: spec, plan, code, tests, evidence.

VERIFICATION: L3 + L4 + L5 + L6 cuando corresponda.

GATE: TaskCompleted + phase gate.

FAILURE: failed check, missing evidence, stale contract.

RECOVERY: rollback/checkpoint + defect loop.

HUMAN CHECKPOINT: spec/ADR/release según riesgo.

METRICS: lead time, rework rate, convergence iterations.

EVAL: Tier 1–3.

CONVERGENCE SIGNAL: evidence manifest válido + required checks green.

DoD: contrato de evidence.

WORKFLOW: W02 INCIDENT → CONTROL

TRIGGER: bug/regression/security incident.

INPUT: failure + reproducer.

STEPS:

open incident;
freeze evidence;
reproduce;
RCA;
classify missing control;
produce regression case;
implement control;
verify regression;
run skill/workflow eval;
approve;
close.

AGENTS: main + RCA/reviewer.

STATE: incident/control/regression registries.

VERIFICATION: L4 + L5 + L6.

GATE: no P0/P1 closure without regression protection.

CONVERGENCE: regression passes and control catches reintroduction.

La evidencia de GRASP respalda precisamente el principio de no aceptar una mejora de workflow sin comprobar que no regresa sobre comportamientos previamente correctos.

WORKFLOW: W03 DOUBT REVIEW

TRIGGER: decisión no trivial, cambio de alto riesgo o claim fuerte.

INPUT: contract + artifact.

STEPS:

extraer contract;
aislar artifact;
crear reviewer fresh;
reviewer intenta encontrar contradicciones;
findings;
reconcile;
rerun;
stop.

CONVERGENCE SIGNAL: no unresolved critical doubts.

WORKFLOW: W04 DEBUGGING
FAILURE
 ↓
REPRODUCE
 ↓
LOCALIZE
 ↓
HYPOTHESIS
 ↓
EXPERIMENT
 ↓
FIX
 ↓
REGRESSION
 ↓
VERIFY

DoD: bug cannot be reproduced and regression protects it.

WORKFLOW: W05 SECURITY
THREAT
 ↓
CONTROL
 ↓
IMPLEMENT
 ↓
STATIC SCAN
 ↓
ADVERSARIAL TEST
 ↓
RECHECK

Human gate: cambios de boundary, privilege, auth o irreversible.

WORKFLOW: W06 COMPACTION / RECOVERY
PRECOMPACT
 ↓
SNAPSHOT
 ↓
COMPACT
 ↓
RESUME
 ↓
VERIFY STATE INTEGRITY

Convergence: critical-state hash consistent.

9. VERIFICATION ARCHITECTURE

Esta es la pieza central de todo el sistema.

No usar un único verifier

La arquitectura debe ser:

                 ┌── deterministic ──┐
ARTIFACT ────────┼── structural ─────┤
                 ├── runtime ────────┤
                 ├── independent LLM ┤
                 └── human ─────────┘
                         ↓
                      EVIDENCE
                         ↓
                        GATE
Orden recomendado

1. Deterministic first

Lint
Type-check
Tests
Schema validation
Security scanners
Mutation sampling

2. Independent review

Solo cuando el problema tiene semántica que tooling no cubre.

3. Human

Solo cuando la decisión es:

irreversible;
de seguridad significativa;
contractual/legal;
arquitectónica de alto impacto.
Definition of Done

Yo no usaría una fórmula:

code + tests + review = done

Usaría un Evidence Contract:

{
  "artifact_hash": "...",
  "contract_hash": "...",
  "checks": {
    "tests": "pass",
    "static": "pass",
    "security": "pass"
  },
  "review": {
    "required": true,
    "status": "pass"
  },
  "exceptions": [],
  "gate": "pass"
}

TaskCompleted verifica ese contrato. Claude Code documenta precisamente que este hook puede impedir el cierre de la tarea cuando la condición de finalización no se cumple.

EVIDENCE: docs oficial + arquitectura propuesta.
CONFIDENCE: alta.

10. TDD / TESTING ARCHITECTURE
Principio

TDD no debe ser simplemente:

"escribe tests antes"

Debe convertirse en una secuencia verificable.

CONTRACT
 ↓
TEST DESIGN
 ↓
RED
 ↓
EXPECTED FAILURE
 ↓
IMPLEMENT
 ↓
GREEN
 ↓
STATIC
 ↓
MUTATION SAMPLE
 ↓
REGRESSION
Gate de TDD

No recomiendo un detector ingenuo:

if test_file_exists; then pass

porque el agente puede crear un test placebo.

Hay que comprobar:

test exists
AND
test expresses expected behavior
AND
test fails before implementation
AND
failure is relevant
Anti-gaming

Detectar:

assertions removed
test skipped
ignore directives
threshold lowered
assertTrue(true)
mock-only verification

Pero estas detecciones deben ir creciendo desde incidentes reales, no convertirse en un monstruo de regex desde el día uno.

Mutation testing

La investigación actual respalda utilizar mutation score como complemento fuerte a coverage.

Pero no establecería inicialmente:

mutation >= 80% everywhere

porque eso introduce una cifra arbitraria independiente del dominio.

Recomiendo:

P0 critical logic     → strict mutation gate
P1 core behavior      → sampled mutation
P2/P3                 → scheduled mutation

EVIDENCE: paper + industrial evidence.
CONFIDENCE: alta en el principio, media en los thresholds concretos.

11. AGENT ORCHESTRATION
Regla principal

No todo necesita orquestación.

P1 — Single agent
User → Main

Para:

cambios pequeños;
docs;
refactors simples.
P2 — Delegated subagent
Main
 ↓
Reviewer / Researcher
 ↓
Result

Para investigación acotada.

P3 — Parallel verification
           ┌→ tests
Main change├→ security
           └→ review

Solo cuando los problemas son independientes.

P4 — Sequential lifecycle
SPEC
 ↓
PLAN
 ↓
BUILD
 ↓
VERIFY
 ↓
REVIEW
 ↓
SHIP
P5 — Risk-based hybrid
SPEC
 ↓
PLAN
 ↓
EXECUTE
 ↓
┌───────────────┐
│ verify lanes  │
├───────────────┤
│ test          │
│ security      │
│ structural    │
│ reviewer      │
└───────────────┘
 ↓
GATE
Agent Teams

No deben ser la base del sistema. Claude Code los mantiene como experimentales y documenta limitaciones reales de resume y task state.

12. CONTEXT ENGINEERING

Aquí conservaría gran parte de tu arquitectura original.

Information hierarchy
CLAUDE.md
   ↓
RULES
   ↓
CONTEXT PACKS
   ↓
SKILL
   ↓
REFERENCE
   ↓
JUST-IN-TIME ARTIFACT
CLAUDE.md

Debe contener exclusivamente:

invariantes;
boundaries;
convenciones;
cómo debe funcionar el harness.

No:

tutoriales;
checklists gigantes;
documentación de dominio;
workflow completo.

Claude Code recomienda que el cuerpo de las skills se cargue cuando son relevantes, lo que permite sacar material procedimental de CLAUDE.md.

State vs Memory

Mantener:

STATE = dónde estoy
MEMORY = qué aprendí
CONTEXT = qué debo saber
EVIDENCE = qué puedo demostrar

Nunca permitir:

PROJECT_STATE
CURRENT_STATE
MEMORY
SESSION_STATE

todos representando la misma realidad.

Budget

No fijaría todavía un número universal de 8k.

Primero:

MEASURE
 ↓
BASELINE
 ↓
SET BUDGET
 ↓
CI GATE

El propio ecosistema de Anthropic ya considera tokens y tiempos como dimensiones útiles de benchmarking.

13. ENFORCEMENT MODEL

Esta taxonomía sí debe convertirse en contrato arquitectónico.

Nivel	Mecanismo	Ejemplo
L0	Instruction	CLAUDE.md
L1	Guidance	context pack
L2	Skill	TDD workflow
L3	Permission	allow/ask/deny
L4	Deterministic validation	tests/lint/mutation
L5	Blocking hook	PreToolUse / TaskCompleted
L6	Independent verification	reviewer fresh context
L7	Cross-model	segundo provider
L8	Human gate	ADR/release

Claude Code confirma que permisos y hooks son mecanismos reales de control, y que un hook exit 2 puede detener una acción.

Regla de diseño

No hacer:

everything → L5

Sí:

reversible / low risk → L1-L4
high impact → L4-L6
irreversible / critical → L5-L8

Esto reduce falsos positivos y fatiga.

Corrección importante

PostToolBatch, PostToolUseFailure e InstructionsLoaded son excelentes para observabilidad y reacción, pero no deben clasificarse automáticamente como L5. TaskCompleted sí es un candidato real a L5 porque puede impedir el cierre.

14. LEARNING LOOP
Arquitectura
INCIDENT
   ↓
EVIDENCE FREEZE
   ↓
ROOT CAUSE
   ↓
MISSING CONTROL
   ↓
REGRESSION CASE
   ↓
CONTROL PROPOSAL
   ↓
IMPLEMENT
   ↓
VERIFY
   ↓
EVAL
   ↓
ACCEPT
Registros
INCIDENT_REGISTRY
incident_id
severity
symptom
reproducer
root_cause
missing_control
status
CONTROL_REGISTRY
control_id
type
enforcement_level
source_incident
path
owner
verification
REGRESSION_REGISTRY
regression_id
incident_id
test/eval
last_verified
Regla

El agente puede:

PROPOSE control

pero no:

SILENTLY MODIFY critical controls

Cambios a:

security rules
P0 hooks
permissions
trust boundaries

deben tener gate humano.

GRASP es particularmente relevante aquí: el mecanismo que hace funcionar el self-improvement no es simplemente “escribir mejores skills”, sino aceptar propuestas solo cuando demuestran mejora neta sin violar un regression budget.

15. EVAL ARCHITECTURE
Tier 1 — Structural
SKILL.md valid
frontmatter valid
paths valid
references resolve
workflow metadata valid
Tier 2 — Trigger / Routing

Cada skill importante:

≥ 3 positive
≥ 2 negative
collision tests

Eso coincide con el quality bar actual de addyosmani.

Tier 3 — Behavioral

Ejecutar realmente:

prompt
+
fixture
+
skill
→ transcript
→ grader

El schema de Anthropic utiliza expectations[] verificables para evaluar la ejecución.

Tier 4 — Adversarial

Para:

prompt injection;
gaming;
regression;
tool misuse;
context poisoning.

No hace falta correrlo en cada commit.

Benchmark

Medir:

pass rate
time
tokens
variance
regressions

Anthropic ya incluye estos campos en su infraestructura de benchmark.

16. DOCUMENTATION SYSTEM

La documentación debe convertirse en especificación operativa, no narrativa.

Estructura
docs/
├── 00-system/
├── 10-workflows/
├── 20-skills/
├── 30-hooks/
├── 40-agents/
├── 50-rules/
├── 60-state/
├── 70-incidents/
└── 90-references/

Esta estructura coincide con la lógica documentada en tu investigación previa.

Cada workflow debe declarar
TRIGGER
NON-TRIGGER
INPUT
PRECONDITION
FLOW
PARTICIPANTS
STATE
ARTIFACTS
VERIFICATION
GATE
FAILURE
RECOVERY
TRUST BOUNDARY
CONVERGENCE
METRICS
EVAL
DEFINITION OF DONE

El campo que más falta en la documentación tradicional es:

TRUST BOUNDARY

y el segundo:

CONVERGENCE SIGNAL

17. TARGET ARCHITECTURE
                         HUMAN
                           │
                           ▼
                    ┌─────────────┐
                    │ INTENT      │
                    └──────┬──────┘
                           ▼
                    ┌─────────────┐
                    │ SPEC /      │
                    │ REQUIREMENT  │
                    └──────┬──────┘
                           ▼
                    ┌─────────────┐
                    │ PLAN        │
                    └──────┬──────┘
                           ▼
        ┌────────────────────────────────────┐
        │        CONTROL PLANE               │
        │                                    │
        │ Context   State   Policy           │
        │ Skills    Agents  Workflow Engine  │
        └────────────────┬───────────────────┘
                         ▼
                  ┌──────────────┐
                  │ EXECUTION    │
                  └──────┬───────┘
                         ▼
        ┌────────────────────────────────────┐
        │ VERIFICATION                       │
        │                                    │
        │ Static │ Tests │ Mutation │ AST   │
        │ Review │ Security │ Regression     │
        └────────────────┬───────────────────┘
                         ▼
                  ┌──────────────┐
                  │ EVIDENCE     │
                  └──────┬───────┘
                         ▼
                    ┌─────────┐
                    │  GATE   │
                    └────┬────┘
                       ↙   ↘
                    FAIL   PASS
                     ↓       ↓
                  RECOVERY  SHIP
                     │
                     ▼
                  INCIDENT
                     │
                     ▼
                    LEARN
                     │
            ┌────────┴─────────┐
            ▼                  ▼
         CONTROL              EVAL
Cambio conceptual importante

No pondría Verification simplemente después de Enforcement.

Algunas validaciones deben ocurrir antes, otras durante y otras después.

La realidad es más parecida a:

ENFORCEMENT × EXECUTION × VERIFICATION

como una malla, no una cadena lineal.

18. PRIORITIZED ROADMAP
P0 — Fundaciones de alto impacto
1. Evidence-based TaskCompleted gate

Valor: crítico
Complejidad: media
Riesgo: medio
Ahorro humano: alto
Coste tokens: bajo-medio
Mantenimiento: medio

2. Enforcement taxonomy L0-L8

Convierte la seguridad arquitectónica en lenguaje común.

3. Evals Tier 1/2

Evita crear skills “bonitas” pero no verificadas.

4. TDD + code-review + doubt-review + constraints

Integración selectiva de agent-skills.

5. Evidence schema

Introduce hash, contract reference y provenance.

P1
Incident → Control.
Regression registry.
Spec-driven workflow.
Planning workflow.
Source-driven development.
State integrity.
Mutation sampling.
Prompt injection boundaries.
Reviewer isolation.
CI integration.
P2
Browser testing.
Worktree isolation.
Model routing.
Observability aggregation.
Graphify.
FileChanged drift detection.
richer performance workflows.
P3
cross-provider fallback;
advanced autonomous loops;
advanced deprecation/migration;
full adversarial evaluation platform.
WHAT NOT TO BUILD

Esto es especialmente importante.

No construir:

Segundo State Layer

Ya tienes PROJECT_STATE.md como fuente operativa.

Skill “run tests”

Debe ser una operación de tooling/TDD, no un workflow independiente.

Agente “researcher” genérico para leer archivos

No merece una persona persistente.

Sistema propio de plugins

Claude Code ya tiene plugins/marketplaces.

Vector memory por defecto

No existe suficiente evidencia para justificar ese coste en tu caso.

Orquestador gigante

Primero single-agent + subagents + deterministic checks.

Dashboard de observability desde cero

Primero agrega los eventos existentes; construir UI propia después de demostrar demanda.

20 hooks

El objetivo no es llenar el catálogo de eventos; cada hook debe eliminar un riesgo verificable.

100 skills

Tu límite de ~20 es sensato como guardrail de complejidad, aunque no es una ley natural.

TOP OPPORTUNITIES

Usando:

Impact × Risk Reduction × Human Time Saved
-------------------------------------------
Effort × Maintenance

la mayor oportunidad estructural es:

Evidence Gate + TaskCompleted
Skill eval infrastructure
Selective adoption de agent-skills
Incident → Control
Independent verification
Enforcement taxonomy
Mutation sampling
Provenance
State integrity
Risk-based orchestration

La selección se basa en impacto operacional, capacidad de verificación y reutilización, no en sofisticación.

19. RISKS AND TRADE-OFFS
Riesgo 1 — Over-enforcement

Un hook demasiado estricto bloquea trabajo legítimo.

Mitigación:

L0/L1 first
→ L4
→ L5 only when measurable
Riesgo 2 — Verification theater

Tener:

reviewer + security reviewer + test reviewer

no garantiza diversidad.

Tres modelos que reciben el mismo contexto pueden reproducir el mismo error.

Mitigación: independencia estructural + determinismo.

Riesgo 3 — Evidence theater

Un registry lleno de:

PASS
PASS
PASS

puede ser simplemente rubber stamping.

Mitigación: auditoría aleatoria periódica de evidence + regression tests que falsifiquen controles.

Riesgo 4 — Mutation cost

La industria sigue teniendo problemas de coste, mutantes equivalentes y escala.

Mitigación: sampling y risk-based execution.

Riesgo 5 — Self-improvement que empeora el sistema

GRASP muestra precisamente este peligro: una mejora que arregla un caso puede introducir regresiones.

Por eso:

AGENT MAY PROPOSE
CONTROL PLANE DECIDES
EVAL ACCEPTS
Riesgo 6 — Dependencia de APIs experimentales

Agent Teams son todavía experimentales.

Mitigación: el core debe funcionar sin ellos.

20. AI THEATER / COMPLEXITY TRAPS
1. “Más agentes = más calidad”

Falso como principio general.

2. Reviewer leyendo reasoning del implementer

Contamina la independencia.

3. Coverage como evidencia principal

No demuestra por sí sola que la suite detecte defectos.

4. PostToolUseFailure tratado como blocking gate

No lo es; es principalmente reactivo.

5. InstructionsLoaded tratado como L5

Es un evento de observación/carga; no equivale a un bloqueo de la acción.

6. Un hook para cada regla

No.

Primero:

policy
→ deterministic check
→ existing hook
7. Memory duplication
state
+ state copy
+ memory copy
+ session copy

crea drift.

8. Evals que solo verifican que una skill “se ejecutó”

Eso evalúa routing, no calidad.

9. DoD que depende del texto “Done”

Contradice todo el objetivo de tu Control Plane.

10. Self-improvement sin regression budget

Es exactamente el fallo que GRASP intenta evitar.

11. Agent Teams como arquitectura fundamental

Demasiado pronto mientras siguen siendo experimentales.

12. Copiar addyosmani completo

Perderías la razón principal por la que existe tu Control Plane: State + Control + Evidence + Learning.

CONCLUSIÓN ARQUITECTÓNICA

Después de cruzar tu documentación con el estado actual del ecosistema, la arquitectura que considero más sólida es:

                YOUR PRODUCT
                     │
                     ▼
              ┌───────────────┐
              │ CONTROL PLANE │
              └───────┬───────┘
                      │
      ┌───────────────┼────────────────┐
      ▼               ▼                ▼
   CONTEXT           STATE           POLICY
      │               │                │
      └───────────────┼────────────────┘
                      ▼
                 WORKFLOWS
                      │
                      ▼
                 EXECUTION
                      │
             ┌────────┴────────┐
             ▼                 ▼
        DETERMINISTIC      AGENT REVIEW
         VALIDATION        (only when needed)
             │                 │
             └────────┬────────┘
                      ▼
                   EVIDENCE
                      │
                      ▼
                    GATE
                      │
                ┌─────┴─────┐
                ▼           ▼
             RECOVER       SHIP
                │
                ▼
              LEARN
                │
         ┌──────┴──────┐
         ▼             ▼
      CONTROL         EVAL

La mayor evolución de tu idea no es pasar de 11 a 20 skills.

Es pasar de:

“Claude tiene instrucciones y herramientas para desarrollar software”

a:

“Claude opera dentro de un sistema que puede demostrar qué debía hacer, qué hizo, qué fue verificado, qué quedó sin verificar, por qué se aceptó y qué impedía que una regresión volviera a ocurrir.”

Ese es el salto arquitectónico real.