# SAGR: notas comerciales y económicas

**Fecha de investigación:** 2026-09-21  
**Alcance:** realidad competitiva, económica y de compra de State-Aware Governed Recovery (SAGR).  
**Entrada principal:** `docs/research/CCP_SAGR_RESEARCH_DOSSIER.md` (21-09-2026).  
**Restricción respetada:** investigación documental solamente. No se modificó runtime, `.claude/`, `evals/`, `install.sh`, `PROJECT_STATE.md` ni ningún registry. Este archivo es el único artefacto nuevo de esta pasada.

## 0. Veredicto ejecutivo

### Veredicto corto

SAGR es **técnicamente plausible como composición**, pero **no está validado como producto comprable independiente**. El mercado ya compra por separado las capas que generan la mayor parte del valor observable:

1. **Continuidad de ejecución:** Temporal, Restate, DBOS, AWS Lambda Durable Functions, Azure Durable Task, LangGraph e Inngest.
2. **Loop limits, presupuesto y permisos:** SDKs de Anthropic/OpenAI, Codex, Claude Code, Cursor, GitHub Copilot, AgentCore, guardrails y gateways.
3. **Observabilidad/evaluación/gobernanza:** LangSmith, Fiddler, Zenity, TrueFoundry, AWS AgentCore, Azure Foundry, Google Agent Platform y GitHub Enterprise AI Controls.
4. **Respuesta a incidentes y corrección:** PagerDuty, Rootly, incident.io, FireHydrant, Sentry Seer y Datadog Bits.

La parte que sigue sin equivalente comercial claramente documentado es estrecha: **clasificar un bloqueo de política como recuperable sin relajar la política, generar una ruta alternativa que preserve la intención autorizada, explorarla con límite y verificarla antes de continuar**. Esa ausencia es un hallazgo de cobertura, no evidencia de demanda ni de viabilidad de seguridad.

### Estado por afirmación

| Afirmación | Estado al 21-09-2026 | Qué sí demuestra la evidencia | Qué no demuestra |
|---|---|---|---|
| Los workflows durables resuelven crash, timeout, espera y reanudación | **SOPORTADA** | Existen SDKs, servicios gestionados, precios, changelogs y referencias de producción | No resuelven por sí solos estancamiento semántico ni una política que bloquea la acción correcta |
| La detección de loops y el hard stop existen | **SOPORTADA COMO FEATURE** | `max_turns`, `max_budget`, circuit breakers, loops y alertas en varios runtimes | “Efectivo” en producción para todos los workloads no fue probado independientemente |
| Checkpoint, replay, fork y time travel existen | **SOPORTADA** | Temporal, Restate, DBOS, LangGraph, AWS, Azure y proveedores cloud | Replay puede repetir LLM/API/side effects; no equivale a recuperación semántica segura |
| Observabilidad de agentes es una categoría comercial | **SOPORTADA** | Precios, tiers, clientes, trazas, evaluaciones y gateways | La observabilidad no es recuperación; ver la causa no cambia automáticamente el estado |
| Guardrails pueden bloquear o transformar tool calls | **SOPORTADA** | Hooks, tool guardrails, Cedar/policies, rails de ejecución y gateways | El bloqueo normalmente termina o devuelve error; no planifica una alternativa autorizada |
| Recuperación semántica bajo política existe como producto | **NO ENCONTRADA EN LA BÚSQUEDA ACOTADA** | No apareció en docs oficiales, pricing o casos de los productos revisados | No prueba ausencia en sistemas internos, features privadas o productos no indexados |
| SAGR tiene comprador, presupuesto y WTP propios | **NO HAY EVIDENCIA** | Hay compradores para runtime, seguridad, observabilidad y operaciones | Ningún cliente o contrato público paga por “state-aware governed recovery” como categoría |
| El incidente prueba WTP | **FALSA INFERENCIA** | Un incidente prueba dolor y severidad potencial | No prueba quién compra, qué presupuesto usa, cuánto paga ni si compra recovery |
| La capa SAGR será absorbida por proveedores | **RIESGO ALTO EN LO COMMODITY; MEDIO/BAJO EN LA PARTE DE POLÍTICA** | AWS, Azure, Google, OpenAI, Anthropic y GitHub ya integran partes | La parte de reinterpretar un bloqueo de seguridad tiene conflicto de interés y riesgo de bypass |

### Respuesta a “¿recovery es realmente comprable?”

- **Sí, cuando se vende como durable execution o incident automation.** Hay compradores claros, presupuesto existente y precios públicos o contratos enterprise.
- **Sí, cuando se vende como observabilidad, seguridad o control de agentes.** El comprador compra visibilidad, prevención, auditoría, identidad y cumplimiento; recovery es una capacidad secundaria.
- **No demostrado como producto separado para el recovery semántico propuesto.** La compra exigiría primero demostrar frecuencia, coste y resultado de los stalls recuperables.
- **La forma económicamente más creíble sería una feature o integración dentro del runtime/gateway existente**, no un control plane horizontal que pida instalarse entre todos los proveedores.

## 1. Cómo leer la evidencia

### Escala de evidencia

El dossier mezcla correctamente algunos niveles, pero esta investigación los mantiene separados:

| Nivel | Etiqueta | Significado | Ejemplo |
|---|---|---|---|
| 0 | CONCEPTO | Idea o paper sin implementación verificable | “Recovery cost vs restart” como hipótesis |
| 1 | FEATURE | Una función documentada en un producto o SDK | `max_turns`, `fork`, `PreToolUse` |
| 2 | SDK/OSS | Código instalable, repositorio y release | `langgraph-checkpoint`, DBOS Transact, Claude Agent SDK |
| 3 | PRODUCTO | Servicio comercial, tier, endpoint o control plane | Temporal Cloud, LangSmith, AgentCore |
| 4 | PRODUCCIÓN | El proveedor declara uso real en producción o capacidad operacional | Temporal declara OpenAI/Block; Restate declara banco tier 1 |
| 5 | CLIENTE | Cliente nombrado, caso de uso y resultado o cita | DBOS/Yutori, PagerDuty/Datadog, LangChain/Klarna |
| 6 | PRESUPUESTO | Precio publicado, PO/invoice, tier procurement o categoría presupuestaria | Temporal Business desde $500/mes; incident.io $19/usuario |
| 7 | WTP | Pago real por el comportamiento exacto, renovación o expansión | **No encontrado para SAGR** |

**Regla:** una página de pricing prueba que el proveedor intenta monetizar una categoría; no prueba que un cliente pagó por el comportamiento exacto. Un logo o una cifra de uso del proveedor prueba, como máximo, claim de producción si no hay validación independiente.

### Taxonomía operativa de la capacidad propuesta

SAGR no es un comportamiento único. Separa ocho jobs:

1. **Detectar:** repetición exacta, oscilación, estancamiento semántico, explosión de contexto o gasto.
2. **Clasificar:** `HARD_STOP`, `RECOVERABLE_STOP` o informativo.
3. **Persistir:** checkpoint de estado, historial, side effects y restricciones.
4. **Reanudar:** replay, retry, resume desde checkpoint o fork.
5. **Explorar:** producir alternativas acotadas y adjudicarlas.
6. **Gobernar:** comprobar que cada alternativa sigue siendo autorizada.
7. **Decidir coste:** comparar recovery, restart y stop.
8. **Verificar/aprender:** comprobar progreso, registrar el stall y convertir el resultado en una regresión o control.

La mayor parte de 1, 3, 4, 7 parcial y 8 operativo ya existe en productos separados. La parte más singular es 2 + 5 + 6, pero también es la parte con mayor riesgo de seguridad y menor evidencia económica.

## 2. Mapa exacto de comportamientos

| Comportamiento de SAGR | Quién lo resuelve hoy | Forma real | Límite relevante |
|---|---|---|---|
| Repetición de tool call o turnos | Claude Agent SDK, OpenAI Agents SDK, AIGIS, ACP, circuit breakers de aplicación | `max_turns`, `max_budget_usd`, límites de concurrencia, deny/stop, alertas | Stop, no reparación; el SDK puede devolver error de límite |
| Loop de workflow por error transitorio | Temporal, Restate, DBOS, AWS Durable, Azure Durable, Inngest | Retry con backoff, replay de resultados, durable steps | Un error de lógica o un loop semántico puede reintentarse indefinidamente o hasta límite |
| Stagnación semántica | Herramientas de evaluación/observabilidad: LangSmith, Fiddler, AgentCore Evaluations, Foundry, FutureAGI en el dossier | Traces, evaluators, clustering, métricas, alertas | Detectar que “no progresa” no produce automáticamente una ruta correcta |
| Crash del proceso | Temporal, Restate, DBOS, AWS, Azure, LangGraph, Inngest, Foundry preview | Checkpoint/replay, lease recovery, resume/fork | Es recuperación de ejecución, no de intención |
| Espera larga, human-in-the-loop | Temporal, Restate, AWS waits/callbacks, Azure timers, LangGraph interrupts, Inngest `waitForEvent` | Estado persistente y reanudación | El humano o la aplicación debe decidir qué hacer; no genera política nueva |
| Context window crece | Claude Code compaction/PreCompact, OpenAI sessions/compaction, LangGraph checkpoints, Foundry/AgentCore memory | Resumen, sesiones, memoria, estado externo | La compactación puede perder detalles; side effects e idempotencia siguen siendo responsabilidad de la app |
| Side effect duplicado al reanudar | Temporal/Restate/DBOS/AWS/Azure/LangGraph mediante idempotencia, watermark o pasos durables | Deduplicación o diseño idempotente | Ninguno conoce automáticamente todos los side effects de una aplicación arbitraria |
| Bloqueo de tool antes de ejecutar | Claude hooks/permissions, OpenAI tool guardrails/approvals, Bedrock Guardrails, NeMo execution rails, AgentCore Policy, Fiddler, Zenity, ACP, Codex permission profiles | Allow/deny/ask/defer, redacción, modificación o approval | El default seguro es denegar; no se debe “razonar alrededor” del control |
| Bloqueo de política que podría ser recuperable | **No encontrado como producto explícito** | En la práctica: devolver error, pedir aprobación, cambiar prompt manualmente, reiniciar | La frecuencia real del caso no está medida |
| Generar alternativa que preserve objetivo y política | Handoff/subagent, retry manual, LangGraph fork, OpenAI/Claude subagents, Rootly/Seer para diagnóstico | El desarrollador diseña la ruta; el agente puede proponer texto | No existe evidencia de que el sistema verifique formalmente que la alternativa no es un bypass |
| Exploración de ramas acotadas | LangGraph time travel/fork, agent frameworks, OpenHands parallel tasks, subagents | Fork/branch/worktree, varios agentes, límites | Explorar no equivale a adjudicar seguridad ni coste |
| Adjudicación por progreso/coste/policy | Evals, human approval, value functions en investigación, Fiddler/Foundry/AgentCore evaluators | Score, evaluación o humano | No hay un estándar de “mejor rama segura” en producción pública |
| Presupuesto de ejecución | Claude `max_budget_usd`, ACP, GitHub AI credits, Codex credits, AgentCore/AWS cost controls, LangSmith/TrueFoundry gateways | Cap, meter, alert, stop | Generalmente cubre todo el run, no un presupuesto de recovery separado |
| Recovery vs restart | Restart manual, stop/retry, budget cap | Decisión humana o fija | No se encontró un predictor público que compare coste esperado de recovery y restart |
| Verificar completion | CI, tests, PR review, LangSmith evals, Foundry evals, CCP evidence gate | Test/evaluation/human review | Es distinto de verificar que una recuperación semántica no dañó estado |
| Incidente a acción | PagerDuty, Rootly, incident.io, FireHydrant, Sentry Seer, Datadog Bits | Alert, RCA, runbook, PR, postmortem, follow-up | No convierte automáticamente la RCA en una nueva policy de agente |
| Aprender del fallo | LangSmith Engine/evals, incident.io/Rootly/PagerDuty postmortems, registros internos | Dataset, cluster, action item, regression suite manual | Aprendizaje cross-run y cross-tenant depende del cliente; no es SAGR por defecto |

**Lectura económica:** los jobs caros ya tienen categorías presupuestarias. La combinación propuesta no tiene todavía una línea presupuestaria reconocible.

## 3. Durable workflows: quién resuelve la continuidad

### 3.1 Temporal

**Qué es:** plataforma de durable execution con SDKs open source para Go, Java, TypeScript, Python y .NET, más Temporal Cloud gestionado. La documentación describe historial de eventos append-only, replay y continuación desde el último evento persistido. [D01]

**Resuelve exactamente:** crash, timeout, retry de Activity, timer, señal, human approval, visibilidad de cada workflow, replay y rewind. Temporal Cloud añadió en 2026 HA GA, OpenMetrics GA, Worker Versioning GA, audit log API/UI GA, custom roles preview, external storage preview y Serverless Workers para Lambda/Cloud Run preview. [D02][D03]

**No resuelve:** si el workflow está lógicamente equivocado, si el agente se estanca sin crash, si una denegación de política debe interpretarse como recuperable, o qué nueva acción es segura. Un workflow puede ser perfectamente durable y repetir una mala decisión de modelo de forma durable.

**Producción/cliente:** Temporal declaró en febrero de 2026 a OpenAI, ADP, Yum! Brands y Block como usuarios de producción; también reportó 9.1T de acciones de vida, 1.86T en compañías AI-native, picos de 150k+ acciones/s y crecimiento de ingresos/uso. Es evidencia de proveedor y clientes nombrados, no auditoría independiente. [D04]

**Presupuesto/precio:** Developer sin fee base más 10% de consumo; Business desde el mayor entre $500/mes o 10% del consumo; Enterprise y Mission Critical anuales. Actions desde $50 por millón, Active Storage $0.042/GBh y Retained Storage $0.00105/GBh. [D02]

**Comprador/WTP:** Platform Engineering, backend infrastructure, payments, financial operations y AI platform. WTP del durable workflow está demostrado por la existencia de Cloud, commitments, Marketplace y clientes de misión crítica. WTP de SAGR no está demostrado.

**Switching cost:** alto. Hay que mover lógica a Workflow/Activity, desplegar workers, respetar determinism y operar o comprar el servicio. Una vez que hay event history y workflows duraderos, el coste de salida aumenta.

**Conclusión:** Temporal absorbe la parte de SAGR que es continuidad de ejecución y la monetiza muy bien. No es competidor directo de policy-compliant recovery; es el lugar más probable donde esa feature acabaría integrada.

### 3.2 Restate

**Qué es:** runtime durable para services, workflows, RPC, keyed state, messaging y queues. Su documentación dice que guarda resultados en un journal, reejecuta el handler y salta acciones ya completadas. SDKs oficiales: TypeScript, Java/Kotlin, Python, Go y Rust. [R01]

**Resuelve exactamente:** durable steps, state consistente, retries, timers, workflows, pause/resume/restart, observabilidad de invocations y control de concurrencia. La documentación de errores indica que el default son retries infinitos con exponential backoff y que `TerminalError` detiene esos retries. [R05]

**No resuelve:** detección de stagnation semántica, clasificación de una policy block, adjudicación de ramas ni side-effect semantics universales. Su default de retries infinitos es evidencia negativa contra la idea de que durable execution por sí sola evita loops de coste.

**Producción/cliente:** Restate declaró uso en AI workflows, payments, crypto trades y el account/credit-card stack de un banco tier 1; publicó casos/citas de Rhize y Cinder, y su sitio lista KPMG, Unkey, Fortis y otros. [R02][R06]

**Versiones/changelog:** servidor 1.7.0 preparado en junio de 2026; SDK TypeScript 1.17.0 publicado el 31-08-2026; Restate Cloud 1.4 fue anunciado con apertura pública el 30-09-2025. [R04]

**Presupuesto/precio:** free tier público de 50k actions/mes sin tarjeta; Cloud usage-based. BYOC, anunciado el 07-07-2026, declara producción a más de 100k durable actions/s y modelos de $5k/mes de licencia más $1-2k de infraestructura para 1k actions/s de capacidad, frente a estimaciones de $32k/mes de Temporal para 1.2B acciones. Son cifras del proveedor y no son comparación financiera independiente. [R02][R03]

**Comprador/WTP:** platform/backend teams que necesitan baja latencia, serverless y control del coste por acción. Los casos y tiers indican compra de durable runtime, no de governed recovery.

**Conclusión:** Restate es sustituto directo de la capa “replay + state + retry” y, por sus controles de pause/resume/restart, reduce el espacio de un recovery product separado.

### 3.3 DBOS

**Qué es:** DBOS Transact es una librería open source que persiste inputs y outputs de workflow/steps en Postgres; DBOS Conductor es el control plane para monitorizar, versionar, forkar, replay y recuperar workflows. [B01]

**Resuelve exactamente:** recuperación tras crash del executor, distributed recovery, queues con flow control, workflow versioning/patching, fork desde un step, dashboard, OpenMetrics, alerting y MCP de troubleshooting. Conductor detecta un executor muerto y pide a otro que recupere el workflow. [B02]

**No resuelve:** una policy-aware recovery planner ni una métrica de semantic progress. Su documentación exige determinism e idempotent steps; eso deja claro que el side-effect ledger es responsabilidad del desarrollador.

**Integración agente:** DBOS documenta integraciones con OpenAI Agents SDK y Pydantic AI; su página de marzo de 2026 enumera también MCP server, workflow lineage y custom alerting. [B03]

**Producción/cliente:** el sitio presenta Yutori como “large-scale durable agentic AI”, además de customer stories para Bristol Myers Squibb, Dosu y Soria; son casos publicados por DBOS. [B02]

**Precio/presupuesto:** Transact es free forever; Pro $99/mes con 1M checkpoints; Teams $499/mes con 10M; Enterprise custom, self-hosted Conductor, air-gapped y SSO/SAML. [B02]

**Comprador/WTP:** startup/individual para Pro; platform teams para Teams; enterprise regulated/air-gapped para custom. El precio convierte recovery/observability en compra clara. No hay señal de pago por la capa semántica.

**Switching cost:** menor que Temporal si ya existe Postgres, pero genera dependencia en decorators, schema y determinism. El propio material de DBOS presenta su arquitectura como alternativa de menor complejidad a Temporal; es claim competitivo, no benchmark neutral. [B04]

**Conclusión:** DBOS es particularmente importante para la tesis: empaqueta distributed recovery, observability y fork en $99/$499. El argumento “nadie resuelve recovery como producto” no resiste; el argumento más estrecho “nadie resuelve policy-aware semantic recovery” sí permanece no encontrado.

### 3.4 AWS Lambda Durable Functions

**Qué es:** feature nativa de Lambda para workflows de hasta un año, con durable operations, checkpoints, waits, callbacks, map/parallel/child contexts y replay. SDK oficial para JavaScript/TypeScript, Python y Java. [A01]

**Resuelve exactamente:** checkpoint automático, retries configurables, pause sin pagar compute mientras espera, callbacks y resume tras interrupción. AWS distingue durable functions de Step Functions: código secuencial dentro de Lambda frente a servicio de orquestación gráfico. [A01]

**No resuelve:** semantic progress, policy classification, alternative generation o verification de intención. El SDK exige determinism: todo I/O, tiempo, random y llamadas no deterministas deben estar dentro de una durable operation. [A03]

**Precio:** se pagan invocations/GB-seconds normales, durable operations, data written y data retained. La página de pricing muestra un ejemplo de 1M claims/mes con 32M GB-s, 4M durable operations, 104GB escritos y 72.8GB-month retenidos por un total ilustrativo de **$490.46/mes** antes de otros componentes. [A02]

**Producción/cliente:** AWS documenta use cases de pagos, órdenes, claims, human review y AI workflows; eso es product evidence, no un customer case específico de SAGR. La disponibilidad se amplió a 16 regiones el 22-04-2026 y Java llegó a GA el 21-04-2026. [A03]

**Comprador/WTP:** AWS customer que ya paga Lambda/Bedrock y prefiere no comprar un orquestador externo. Provider absorption risk: **muy alto** para crash recovery y budget primitives.

**Conclusión:** AWS convierte el checkpoint en coste marginal dentro del cloud bill. Un recovery plane externo tendría que demostrar valor semántico que Lambda deliberadamente no promete.

### 3.5 Azure Durable Functions y Microsoft Foundry

**Durable Functions:** Azure Durable Functions mantiene state, checkpoints, retries y recovery; Durable Task Scheduler es el backend recomendado, con SKU Dedicated por capacidad y Consumption en preview por acciones. [AZ01][AZ02]

**Foundry hosted agents:** la documentación de julio-agosto de 2026 introduce long-running agent resilience, leases, durable work identity, persisted inputs, handler reentry, stream replay y recuperación desde checkpoints. La documentación es explícita: el runtime no preserva todos los estados intermedios ni side effects; la aplicación debe proveer idempotency keys, watermarks y checkpoints. [AZ03][AZ04]

**Evidencia negativa especialmente relevante:** la función es preview, sin SLA y Microsoft no recomienda previews para producción. El runtime reentra desde el principio, no hace deterministic replay, no es workflow orchestration y no almacena por sí solo grandes artefactos. [AZ03]

**Conclusión:** Azure ya está incorporando exactamente el vocabulario de “recovery long-running agent”, pero mantiene la frontera correcta: runtime metadata no es recuperación semántica. Esto debilita el claim de que el espacio no será absorbido y, al mismo tiempo, deja una brecha de aplicación, no de plataforma genérica.

### 3.6 LangGraph y LangSmith

**LangGraph SDK/OSS:** checkpointer + `thread_id` habilitan durable execution; modos `async`, `sync` y `exit` permiten trade-off entre coste y durabilidad. Interrupts guardan state para human-in-the-loop. Time travel ofrece replay y fork desde checkpoints. [LG01][LG02]

**Límite formal:** replay reejecuta nodos posteriores, incluyendo LLM calls, API requests e interrupts; pueden producir resultados diferentes. La documentación exige envolver side effects en tasks y hacer operaciones idempotentes. Esto es una refutación directa a “checkpoint = estado correcto para reanudar”. [LG02]

**Producto:** LangSmith Deployment ofrece serverless/dedicated deployments, state/memory APIs, traces, evals, sandboxes, gateway, Engine y Fleet. Pricing público: Developer $0, Plus $39/seat, Enterprise custom; $1.50/LCU y $1.00/LSU; Engine estima 5-30 LCUs por ejecución. [LS01]

**Producción/cliente:** LangChain publica historias de Klarna, Uber, Elastic, AppFolio, Cisco, Salesforce, PagerDuty y otras; su página `built-with-langgraph` declara 100M+ traces mensuales, 6k+ teams y 40+ customer stories. Son claims de proveedor/casos publicados, no auditoría independiente. [LG03]

**Conclusión:** LangGraph reduce la novedad de fork, context recovery, evaluation y branch exploration. LangSmith incluso comercializa clustering de fallos y evals para evitar recurrencia. Lo que no prueba es policy-constrained recovery.

### 3.7 Inngest como sustituto de menor fricción

Inngest vende durable execution, retries, queues, concurrency, throttling, tracing y AI agents como steps en TypeScript, Python y Go. Pricing: Hobby $0 con 50k executions; Pro desde $99/mes con 1M executions, trazas y 7 días; Enterprise custom con SAML/RBAC/audit y 90 días. Publica clientes SoundCloud, Fey y GitBook. [IN01]

**Lectura:** para muchos equipos el workaround “workflow duradero simple + observabilidad” cuesta $0 o $99, no un nuevo control plane. Inngest no hace semantic recovery, pero compite con cualquier pitch que empiece por “hay que hacer retries, checkpoints y budget controls”.

## 4. Agent runtimes, observabilidad y governance

### 4.1 Agent runtimes y SDKs

| Sistema | Tipo | Feature verificable | Producción/cliente | Precio/presupuesto | Qué deja fuera de SAGR |
|---|---|---|---|---|---|
| OpenAI Agents SDK | SDK OSS | Agents, tools, handoffs, sessions, input/output/tool guardrails, hooks, max turns y tracing. Integra Dapr, Temporal, Restate y DBOS para durable execution | SDK oficial; no customer evidence del SDK por sí solo | No license fee separado; paga modelo/API, enterprise se compra como plataforma OpenAI | Guardrail tripwire y `MaxTurnsExceeded` paran; no recovery planner policy-aware |
| Claude Agent SDK | SDK/librería oficial | Agent loop, hooks, permissions, subagents, sessions, fork/resume, `max_turns`, `max_budget_usd`, file checkpointing, SessionStore | Python SDK changelog actual consultado: 0.2.156, bundled CLI 2.1.276; repositorio público con 8.1k stars; stars no equivalen a producción | Enterprise $20/seat/mes más uso API; Team $20 standard/$100 premium anual; Pro $17 anualizado/$20 mensual; Managed Agents $0.08/session-hour más tokens | Hook deny y budget stop; compaction/resume no garantiza side-effect continuity; no policy alternative |
| LangGraph | OSS SDK/framework | Checkpoints, interrupts, fork, replay, memory, graph state | LangChain publica múltiples clientes enterprise y métricas de uso; vendor evidence | OSS; LangSmith Developer $0, Plus $39 seat, Enterprise custom; LCU/LSU usage | Replay puede repetir API/LLM; branch no adjudica safety |
| OpenAI Codex CLI | Harness/CLI | Sandbox/permission profiles, filesystem/network policies, Git checkpoints, resume, subagents, cloud worktrees y review | Official CLI 0.143.0 en docs al consultar; Codex cloud y CLI son productos activos | Free; Plus $20; Pro desde $100; Business $20/user/mes anual; Enterprise custom; API key usage-based | Es control del harness y continuidad de sesión, no formal policy-recovery |
| OpenHands Agent Canvas/SDK | Harness + server + automation | Local/cloud/self-hosted backends; workspaces, agent server, automations/schedules/webhooks, budget management, ACP agents | OSS repo OpenHands v1.20.0 (17-09-2026), 88.7k stars; OpenHands Cloud/Enterprise comerciales; stars no prueban WTP | Cloud/Enterprise custom o tiers no públicos en la evidencia consultada | Multiplica agentes y automatizaciones; no muestra formal recovery classifier ni safe alternative adjudication |
| AWS Bedrock AgentCore | Cloud product | Managed harness/runtime, isolated microVM, memory, identity, gateway, observability, evaluations, optimization, deterministic Policy intercepting each tool call, registry | Producto oficial cloud; customer contracts/precios no públicos en esta pasada | Consumption, no upfront/minimum según docs; los componentes cloud y model usage se facturan aparte | Gran absorción de runtime, identity, policy, eval y memory; no claim de SAGR semantics |
| Microsoft Foundry Agent Service | Cloud product/preview | Hosted agent runtime, OTEL external-agent registration, monitoring, evals, long-running recovery, replay, human approval | Docs oficiales; resilience y external agents en preview y explícitamente no recomendados para producción | Azure consumption; exact price depends resources/App Insights/model | El propio docs dice app responsibility for progress, side effects and idempotency |
| Google Gemini Enterprise Agent Platform | Cloud product | Managed Agent Runtime, sessions, Memory Bank, traces/logging/metrics, eval/feedback, Agent Gateway, identity/policies, anomaly detection | Docs oficiales actualizados 21-09-2026; customer/WTP específico no identificado | Cloud consumption; pricing page oficial enlazada, no cifra única comparable | Provider already covers context, governance, eval and runtime; no safe recovery planner public |

### 4.2 Observability/governance products

| Producto | Qué compra el cliente | Precio público/evidencia | Producción y cliente | Relación con SAGR |
|---|---|---|---|---|
| LangSmith | Traces, evals, deployment, Engine, sandboxes, LLM gateway, fleet | $0 Developer; $39/seat Plus; $1.50/LCU, $1/LSU; Enterprise custom | Casos publicados: Klarna, Uber, PagerDuty, Salesforce, Cisco, etc. | Resuelve ver, evaluar, clusterizar y proponer fixes; no ejecuta una policy-constrained recovery automáticamente |
| Fiddler AI Control Plane | Observability, continuous eval, inline policy enforcement, governance, spend, OTel, coding agents | Landing anuncia Free, Developer $0.002/trace, Enterprise custom; pricing/feature claims del proveedor | Customer logos/cases Nielsen, Mastercard, healthcare payer; proveedor declara Fortune 100 use | Competidor directo en control/observability. Su propuesta bloquea/redacta y registra, pero no documenta checkpoint/replay ni recovery planner |
| Zenity | Discovery, posture, identity, permission risk, runtime intent-aware detection and response | Enterprise contract; Series C $125M (03-08-2026), $180M total claim | Zenity afirma Fortune 500/Global 2000 y SoftBank; CISO security WTP adjacent, no price público | Resuelve governance/security del agente a escala; no vende continuidad de ejecución |
| Agentic Control Plane | Runtime tool-call authorization, audit/cost/latency, agent identity, budget caps, shadow mode, agent-proposed rules | Free 5 initiating agents; Team $100/mes/25; Scale $1,000/mes/250; Enterprise custom | Producto live; 1,081,788 policy decisions al 09-09-2026 y 45/48 benchmark son claims propios | Competidor directo de authorization. Importante: propone una regla después de un deny y espera confirmación humana; no genera una ruta alternativa ni hace rollback |
| TrueFoundry/TrueForge | AI/MCP/Agent Gateway, identity, RBAC, policies, spend, tracing, on-prem/VPC/air-gapped | Pricing enterprise/custom en página revisada; dossier anterior reportó Pro $25/user, no se revalidó aquí | La página enumera clientes/metrics y live sandbox; claims del vendor | Absorbe gateway, identity, cost, audit y runtime. No evidence de semantic recovery |
| GitHub Enterprise AI Controls | Central AI admin, agent session activity, audit log with `actor_is_agent`, MCP allowlist preview, custom agent definitions | Product embedded in GitHub Enterprise/Copilot; enterprise price not exposed in retrieved official page | GA 26-02-2026; third-party agent coverage and 24h cloud session activity | Provider-native control plane narrows standalone governance market; no evidence gate or checkpoint |

## 5. Coding-agent harnesses

### Claude Code / Claude Agent SDK

La documentación oficial describe el mismo loop de Claude Code como SDK: prompt -> tool call -> result -> nuevo turn hasta respuesta sin tools. Existen `max_turns` y `max_budget_usd`; un límite produce `error_max_turns` o `error_max_budget_usd`, no un plan de recuperación. [ANT05]

Hooks cubren `PreToolUse`, `PostToolUse`, `PostToolUseFailure`, `SubagentStart/Stop`, `PreCompact`, `Stop`, `TaskCompleted` y más. `PreToolUse` puede bloquear o modificar input; `TaskCompleted` puede exigir tests. [ANT02]

Sessions permiten continue/resume/fork y `SessionStore` para reanudar entre hosts; file checkpointing puede restaurar archivos, pero la documentación advierte que las sesiones preservan la conversación y no el filesystem automáticamente. [ANT03]

Permissions se evalúan hooks -> deny -> ask -> mode -> allow -> callback. Un hook deny gana; `allowed_tools` no restringe por sí solo `bypassPermissions`; controles mal configurados pueden ser ilusorios. [ANT04]

**Conclusión comercial:** Anthropic ya vende el runtime y los mecanismos que un cliente de desarrollo necesita. Un producto externo solo puede justificar coste por gobernanza multi-provider, auditoría, policy distribution o evidence beyond Claude.

### OpenAI Codex CLI/cloud

Codex CLI ofrece local loop, `/permissions`, sandbox profiles, filesystem/network allow/deny, Git checkpoints, `codex resume`, subagents y cloud tasks en entornos aislados. La documentación actual muestra CLI 0.143.0. [OAI06]

Pricing oficial de Codex: Free; Plus $20/mes; Pro desde $100; Business $20/user/mes anual o $25 mensual; Enterprise/Edu custom. API key es usage-based. Codex cloud permite paralelizar tareas en entornos reproducibles y revisar diffs/PRs. [OAI05][OAI07]

**Límite:** sandbox y permission profile previenen acciones; resume reabre una conversación o tarea. Nada de eso prueba que una policy denial sea recuperable o que el siguiente path preserve la autorización.

### Cursor

Cursor ofrece Agent, MCPs, skills, hooks, cloud agents, automations y Bugbot. Pricing oficial consultado: Individual $20/mes; Teams $40/user/mes; Enterprise custom con pooled usage, invoice/PO, SCIM, repository/model/MCP controls, auto-run/browser/network controls, audit logs, service accounts y AI code tracking API. [CU01]

**Cliente/comprador:** developer seat, team manager o enterprise platform/security. **WTP:** precio y enterprise procurement visibles; no WTP específico de recovery. Cursor es sustituto de local harness y provider-native governance, no durable workflow server.

### GitHub Copilot

GitHub AI Controls and agent control plane llegó a GA el 26-02-2026. Incluye AI admin role/workspace, `actor_is_agent`, audit log, agent session activity, third-party agent discovery y enterprise custom agent definitions. MCP allowlists seguían preview. [GH01]

La página oficial de planes consultada muestra para individuos Free, Pro $10, Pro+ $39 y Max $100; para empresa el pricing se negocia en GitHub Enterprise/Copilot Business/Enterprise y no se debe inventar una cifra a partir del plan individual. Pro incluye cloud agent/code review y terceros; Pro+ añade audit logs. [GH02]

**Conclusión:** GitHub ya ocupa la palabra “agent control plane” y distribuye el control dentro del sistema de repos, issues, PRs y enterprise admin. El switching cost de un control plane externo aumenta porque el comprador ya tiene identidad, audit y policy en el sistema de trabajo.

### OpenHands

OpenHands separa Agent Canvas, Software Agent SDK, Agent Server, Automation Server y Cloud/Enterprise. Canvas puede ejecutar OpenHands, Claude Code, Codex y otros backends ACP; automations corren por schedule/webhook y el cliente puede self-hostear en Docker/VM/cloud. [OH01]

OpenHands v1.20.0 fue publicado el 17-09-2026; el repo principal muestra 88.7k stars y 11.7k forks. El release incluye perfiles de agentes, selección de secretos, automatizaciones y mejoras de control. [OH02]

**Evidencia:** es un harness/automation control center con distribución enorme y oferta comercial. No es evidencia de que haya implementado SAGR, pero elimina la premisa de que todos los equipos deben construir su propio harness.

## 6. Guardrails: quién bloquea y qué significa el bloqueo

| Sistema | Punto de control | Exactitud del comportamiento | Evidencia económica | Límite para SAGR |
|---|---|---|---|---|
| AWS Bedrock Guardrails | Input/output de FM, denied topics, PII, prompt attack, grounding, automated reasoning, ApplyGuardrail API | Bloquea, filtra o enmascara; no es workflow state | Pay-per-use dentro de Bedrock; pricing por filtro/uso, no una licencia SAGR | Evalúa contenido/model response, no decide cómo continuar un workflow bloqueado |
| NVIDIA NeMo Guardrails 0.24.1 | Input, dialog, retrieval, execution/tool input-output y output rails; Python SDK/server/Kubernetes microservice | Open source Apache 2.0; rails pueden reject/alter/validate tools | Library gratis; producto/infra NVIDIA puede tener coste, no cifra SAGR | La propia docs dice que built-ins pueden no servir para producción; no adjudica recovery |
| Guardrails AI | Input/output Guards, validators Hub, structured output, server | OSS Python + validators; remote hosted inferencing fue discontinuado con cutoff planificado 25-08-2026 | OSS/Hub; no se encontró precio enterprise verificable en esta pasada | Un validator dice “fail”; no crea checkpoint ni alternativa |
| OpenAI Agents SDK | Input/output/tool guardrails, tripwires, approvals; blocking mode evita que el agente empiece | Tool guardrails pueden skip/replace/raise; built-in execution tools no pasan por esa pipeline | SDK sin fee separado; model/API usage | `MaxTurnsExceeded`, tripwire y approval son stop/deny, no semantic recovery |
| Claude hooks/permissions | PreToolUse, deny/ask/defer/updatedInput, PostToolUse, TaskCompleted | Muy flexible y local al agente/proyecto | Incluido en Claude/SDK/API según plan | Policy engine es del runtime; no hay recovery classifier |
| Codex permission profiles | Filesystem/network profile, sandbox, deny/allow, auto-review | Deterministic local boundary si proxy/sandbox está activo | Incluido en Codex plan o API | El docs advierte que network domain rules no restringen si el proxy no está activo; enforcement misconfigured remains risk |
| Fiddler | Inline request/response policy, PII/PHI/secrets, evals, OTel | Pre-execution/request-path enforcement y audit | Developer $0.002/trace; Enterprise custom; customers claimed | “Block before action” sí; “find safe alternative” no |
| Zenity | Posture, identity, permissions, intent-aware runtime defense | Permite/modifica/bloquea acción antes de ocurrir según claim del proveedor | Enterprise custom; $125M Series C | Security/governance buyer, no workflow recovery |
| ACP | Tool-call authorization, shadow mode, budget cap, approvals, agent-proposed scoped policy | Runtime authorization multi-provider; no code changes claimed | Free 5 agents; $100/$1,000; Enterprise custom | Closest commercial neighbor, but rule proposal is not policy-compliant alternative generation |

**Punto de seguridad:** un planner que recibe “la policy bloqueó esto” y busca otro camino para lograr exactamente el mismo resultado puede ser un bypass asistido. El default correcto para incertidumbre es `HARD_STOP`, no “fail forward”. Esto reduce el valor económico de automatizar recovery y eleva el coste de validación, sandboxing y responsabilidad.

## 7. Recovery/checkpoint: qué se compra realmente

### Producto vs feature vs SDK

| Capa | Ejemplo | Lo que se instala/compra | Quién opera | Señal de mercado |
|---|---|---|---|---|
| Feature nativa | Lambda Durable, Foundry recovery preview, Claude resume | Se activa dentro de un proveedor | Cloud/provider | Absorción alta, switching bajo si ya estás dentro |
| SDK/OSS | Temporal SDK, DBOS Transact, LangGraph checkpointer, NeMo | Código + responsabilidad de operación | Equipo de plataforma | Discovery fuerte; precio cero no prueba WTP |
| Producto gestionado | Temporal Cloud, DBOS Conductor, Restate Cloud, LangSmith Deployment, Inngest | Servicio, SLA, retention, support, console | Vendor | Pricing y buyer claros |
| Recovery semántico | SAGR policy-aware planner | No hay SKU claramente observado | Tendría que operar sobre cada app/policy | WTP desconocido |
| Incident automation | PagerDuty/Rootly/incident.io/Sentry/Datadog | Respuesta, RCA, runbook, PR y postmortem | SRE/DevOps | Categoría madura y comprable |

### Lo que la evidencia niega

1. **Checkpoint no es rollback seguro de mundo externo.** LangGraph, Azure y AWS exigen idempotencia, watermarks o encapsular I/O; los workflows no conocen todos los side effects.
2. **Replay no es “continuar con el mismo significado”.** LangGraph dice que LLM/API calls posteriores se ejecutan de nuevo y pueden variar; Azure dice que recovery reentra desde el principio y no es deterministic replay.
3. **Retry no es progress.** Restate documenta retries infinitos por defecto; un error semántico puede convertirse en gasto durable.
4. **Observability no es enforcement.** LangSmith/Fiddler/Foundry/Datadog muestran y evalúan; solo los gateways/policies bloquean, y el bloqueo no determina una alternativa.
5. **Incident RCA no es policy learning.** PagerDuty/Rootly/Seer generan timeline, root cause, runbook, PR o follow-up. El equipo decide si lo convierte en una regla/regresión.

### Lo que sí es una compra estable

- Temporal Cloud / DBOS Conductor / Restate Cloud / Inngest: disponibilidad, durabilidad, operación y coste predecible.
- LangSmith/Fiddler/Foundry/AgentCore: traces, evals, deployments, audit y control de calidad.
- Zenity/TrueFoundry/ACP/Fiddler: identity, policy, tool-call authorization, spend y audit.
- PagerDuty/Rootly/incident.io/FireHydrant: incident lifecycle, on-call, runbooks, RCA, postmortems y automation.

## 8. Incident automation y el supuesto “incident -> control -> regression”

### PagerDuty

PagerDuty AIOps publicita reducción de alert noise, root-cause context, event orchestration, runbook automation, post-incident review, SRE Agent y PagerDuty Advance. Pricing público: Professional $25/user/mes anualizado, Business $49, Enterprise custom; AIOps desde aproximadamente $699/$799 mensual según página; Advance desde $415/mes anual con AI actions. [PD01][PD02]

Tiene 30,000 compañías declaradas, 750+ integrations y clientes/casos como Datadog, Zoom, Spotify, TUI y Australian Bank. [PD02]

**Qué resuelve:** incident detection, alert grouping, triage, responder mobilization, diagnostics/remediation, postmortem y follow-up.  
**Qué no resuelve:** no es un runtime de agentes; una acción de postmortem no cambia automáticamente una policy de Claude/Codex ni instala un checkpoint.

### Rootly

Rootly AI SRE analiza código, telemetry, deploys, commits y past incidents; ofrece probable root cause con evidence/confidence, remediation steps/PRs, similar incidents, automated retrospectives y action items. La página dice explícitamente que no auto-remedia sin human sign-off. Pricing: Incident Response Essentials $20/user/mes; On-call Essentials $20/user/mes; AI SRE contact us; Enterprise custom. [RT01][RT02]

Publica clientes como Replit, DoorDash, Figma, Nvidia, Mistral, Webflow y Wealthsimple. Son customer claims del proveedor. [RT02]

**Relevancia:** Rootly es evidencia de que “diagnose + propose fix + learn from incident” ya es vendible. También demuestra el límite: el mercado exige aprobación humana antes de que un agente de incidentes modifique sistemas.

### incident.io

Pricing público: Basic $0; Team $19/user/mes mensual o $15 anual; Pro $25; Enterprise custom; on-call $20/user. Pro añade root cause analysis, autonomous agent, Nexus data sources, Scribe y postmortem AI. [I01]

**Relevancia:** incident.io monetiza el registro, coordinación, RCA y mejora continua, pero no el recovery de una sesión de agente en ejecución.

### FireHydrant

Pricing público: Free; Pro $25/responder/mes anual; Enterprise custom. Enterprise añade FireHydrant AI para summaries, transcripts, triage, retros y follow-ups, además de runbooks, audit logs y SCIM. [FH01]

**Relevancia:** compra por responder/incident workflow, no por policy-aware recovery.

### Sentry Seer

Seer investiga issues con telemetry, traza root cause en codebase, redacta fixes/PRs, se integra con Claude, Copilot, Cursor, Slack y MCP, y puede montar workflows issue -> diagnose -> PR. Pricing oficial: $40 por active contributor/mes en planes Team/Business/Enterprise. [SE01]

**Relevancia:** desplaza aún más la frontera de “un agente que detecta un fallo y propone/fabrica un fix”. No ofrece un durable workflow de ejecución del agente ni una clasificación formal de policy stop.

### Datadog Bits AI

Bits Investigation actúa como AI SRE: investiga alerts, encuentra root cause, sugiere remediation, genera summaries/postmortems e integra Slack, Teams, Jira, ServiceNow y GitHub. Bits Code genera fixes/tests grounded en observability data; Bits Agent Builder orquesta agentes y más de 2,000 acciones. [DD01]

**Relevancia:** el presupuesto de observability ya puede financiar investigación y remediation. Cualquier SAGR comercial debe demostrar que resuelve algo que Datadog/PagerDuty/Sentry no pueden observar o automatizar.

## 9. Economía: precios, presupuesto y WTP

### Precios observables por categoría

| Categoría | Proveedor/producto | Precio público consultado | Unidad de compra | Qué evidencia de WTP permite |
|---|---|---:|---|---|
| Durable execution | Temporal Cloud | $0 Developer; $500 Business mínimo; $50/M Actions inicial | consumo + plan + storage/support | WTP por durabilidad/operación |
| Durable execution | DBOS Conductor | $99 Pro; $499 Teams; Enterprise custom | checkpoints/mes + seats/support | WTP por checkpoint, recovery y control plane |
| Durable execution | Inngest | $0 Hobby; $99 Pro; Enterprise custom | executions, concurrency, traces | WTP por workflow y observability |
| Durable execution | Restate | Free 50k actions; BYOC custom/capacity | actions o capacidad en VPC | WTP por runtime/infra; BYOC claims no contract amounts |
| Cloud durable | AWS Lambda Durable | Usage Lambda + $8/M operations + data written/retained en ejemplo oficial | cloud bill | Absorción: el recovery se factura dentro del proveedor |
| Agent observability | LangSmith | $0 Developer; $39 Plus; $1.50/LCU; $1/LSU; Enterprise custom | seats + traces + compute/storage | WTP por traces/evals/deployment |
| Agent control | Agentic Control Plane | $0/5 agents; $100/25; $1,000/250; Enterprise custom | initiating agents | WTP de runtime authorization; pago real de clientes no público |
| Agent control | Fiddler | Free; Developer $0.002/trace; Enterprise custom | traces + enterprise controls | WTP de observability/enforcement, no SAGR |
| Agent security | Zenity | Enterprise custom | contrato CISO/security | WTP alto para governance/security, no recovery |
| Agent gateway | TrueFoundry | Custom en la página revisada | gateway/enterprise deployment | WTP platform/security; precio anterior del dossier no revalidado |
| Coding harness | Claude Team/Enterprise | $20 standard/$100 premium; Enterprise $20 seat + API usage | seats + usage | WTP por agent access/control/enterprise |
| Coding harness | Cursor | $20 individual; $40 Teams; Enterprise custom | seats + model usage | WTP por agent IDE, admin y controls |
| Coding harness | Copilot | $10 Pro; $39 Pro+; $100 Max; business/enterprise custom | seats + AI credits | WTP por agent coding + embedded governance |
| Coding harness | Codex | $20 Plus; $100 Pro; $20 Business anual; Enterprise custom | seats/credits/API | WTP por coding agent, cloud and admin |
| Incident | PagerDuty | $25 Professional; $49 Business; Enterprise custom; add-ons | users + events/AI actions | WTP claro por incident response |
| Incident | incident.io | $0; $19 Team; $25 Pro; Enterprise custom | seats + on-call | WTP claro por incident lifecycle |
| Incident | Rootly | $20/user Incident Response; $20/user On-call; AI SRE custom | users + AI/SRE | WTP por incident/RCA |
| Incident | FireHydrant | $0; $25/responder Pro; Enterprise custom | responders/alerts | WTP por incident management |
| Debugging | Sentry Seer | $40/active contributor | active contributors | WTP por production debugging and PR fixes |

### Presupuesto por comprador

| Comprador real | Presupuesto que ya existe | Job que compra | ¿Compraría SAGR? |
|---|---|---|---|
| Developer individual | $10-$100/mes para coding agent | Productivity, coding, local safety | Solo si no añade fricción y evita un coste inmediato; WTP para producto separado bajo |
| Engineering manager/CTO | Tooling/DevEx, reliability | Menos rework, faster delivery, fewer incidents | Puede patrocinar un piloto, pero no hay evidencia de categoría |
| Platform/AI platform | Infrastructure, developer platform, runtime | Fleet deployment, budgets, identity, durable execution, observability | Comprador más plausible para una feature integrada; buy si fleet, build si project-local |
| SRE/DevOps | Incident management, observability, automation | MTTR, alert noise, runbooks, postmortems | Ya compra PagerDuty/Rootly/Datadog; SAGR debe conectar con esa cadena |
| AppSec/CISO | Security, IAM, GRC, compliance | Prevent risky tool actions, audit, agent identity, policy | Tiene presupuesto, pero el job es security/prevention, no recovery semántico |
| FinOps | Cloud/AI spend | Caps, routing, budget leakage | Puede comprar spend controls; recovery vs restart necesita ahorro medido |
| Compliance/auditor | GRC/audit services | Evidence retention, accountability, traceability | No se observó que exija recovery; compra evidencia, no planner |

### Pain, frequency, severity

| Fallo | Frecuencia pública | Severidad | Workaround actual | Economics |
|---|---|---|---|---|
| Crash/timeout durante workflow largo | Alta en workflows largos; la existencia de toda la categoría lo confirma | Alta si se pierde progreso | Durable runtime/retry/checkpoint | Ya es comprable y presupuestable |
| Loop exacto/budget spiral | Real y potencialmente catastrófico; incidentes publicados no dan denominador | Alta | max turns, budget cap, kill/restart, alerts | Se compra control/observability; no prueba SAGR recovery |
| Context overflow/compaction | Real, pero incidencia general no cuantificada públicamente | Media-alta | compact, resume, restart, pass files/state | Provider/framework puede absorberlo |
| Side effect duplicate | Frecuencia desconocida; alta en payments/DB/API | Muy alta | idempotency keys, watermark, sagas, durable steps | Se compra reliability/compliance de la aplicación |
| Policy-induced stall | Evidencia pública escasa; un issue no es prevalencia | Media o alta según task | hard stop, human approval, manual alternative, restart | WTP no demostrado; riesgo de security bypass |
| RCA y recurrence | Muy frecuente en operaciones maduras | Alta por MTTR/repeat incidents | PagerDuty/Rootly/incident.io/Sentry/Datadog | Categoría comercial madura |

### Build vs buy

**Build gana** cuando:

- solo hay un repositorio, un proveedor y pocos agentes;
- la policy depende de secretos, paths, tests y side effects internos;
- el coste de instalar un gateway y mantener adapters supera el coste de un script/hook;
- el recovery es un caso de negocio específico y no reusable.

**Buy gana** cuando:

- hay decenas/cientos de agentes, proveedores y repos;
- identity, RBAC, retention, audit export, SIEM, SSO, support y SLA importan;
- el runtime es crítico y el equipo no quiere operar Cassandra/Elastic/Postgres/queues/worker fleets;
- el coste de un incidente o de un budget runaway es mayor que el contrato.

**SAGR standalone pierde** si requiere a la vez:

- instrumentar Claude, Codex, Cursor, OpenHands, LangGraph, OpenAI SDK y cloud runtimes;
- entender policies distintas por cliente;
- guardar transcript, tool inputs, side effects y evidence;
- decidir semánticamente qué significa “misma intención”;
- asumir liability por una alternativa que el control original habría bloqueado.

### Switching cost

| Capa | Coste de cambiar | Por qué |
|---|---|---|
| Coding seat | Bajo-medio | El usuario puede cambiar de plan/harness; las instrucciones y plugins sí crean fricción |
| Observability | Medio-alto | Ingesta histórica, dashboards, eval datasets, alerts, SSO y workflows |
| Durable workflow | Alto | State/event histories, worker model, deterministic constraints, migrations |
| Guardrail/gateway | Alto | Cada tool/API/identity/secret y policy debe ser re-integrado; riesgo de bypass |
| Incident platform | Alto | On-call schedules, integrations, incident history, postmortems, organizational habit |
| SAGR semántico | Potencialmente muy alto | Cada cliente debe codificar qué es progreso, side effect, autorización y éxito; esto es custom engineering, no commodity |

## 10. Evidencia de producción, cliente y pago

### Lo que sí está probado razonablemente

- **Temporal:** producto SaaS, pricing, changelog y clientes nombrados en producción. Nivel máximo público: producción/cliente + presupuesto; no contratos individuales.
- **Restate:** producto público, free tier, BYOC, releases frecuentes, casos de banco/Rhize/Cinder/KPMG. Nivel público: producción/cliente + precio parcial.
- **DBOS:** OSS + Conductor con $99/$499/custom y Yutori/BMS/Soria stories. Nivel público: producto/cliente + precio.
- **LangSmith:** pricing, deployment/eval/Engine, múltiples customer stories y métricas de uso que son vendor claims.
- **Fiddler/Zenity/TrueFoundry:** enterprise products, pricing custom, named logos/funding/case studies. Nivel: categoría y producto; no prueba que los clientes compren el comportamiento SAGR.
- **PagerDuty/Rootly/incident.io/FireHydrant/Sentry:** precios y clientes/product usage; WTP de incident management sí es observable.

### Lo que no está probado

- ningún contrato o renewal público por policy-aware recovery;
- ningún cliente que diga que pagó para convertir una deny en una alternativa segura;
- ninguna tasa de “recoverable stalls” en una flota real;
- ningún estudio que compare coste de recovery SAGR frente a restart con la misma task;
- ningún benchmark reproducido que pruebe que la alternativa generada conserva policy, side effects y goal;
- ningún sistema público que mantenga un failed-path registry semántico y lo use para evitar una repetición sin incrementar riesgo;
- ningún cliente externo que valide el control plane de este repositorio.

## 11. Auditoría de claims del dossier SAGR

### Claims que resisten, con redacción precisa

1. **“Durable execution existe profundamente.”** Resiste. Temporal, Restate, DBOS, AWS, Azure, LangGraph e Inngest lo documentan y lo monetizan.
2. **“Loop detection, caps y hard stop existen.”** Resiste como feature. No debe llamarse “solved” en sentido semántico universal.
3. **“La composición exacta policy-block classifier + safe alternative + bounded exploration no fue encontrada.”** Resiste como `NOT FOUND IN BOUNDED SEARCH`, no como ausencia del mercado.
4. **“La seguridad de un recovery planner es la objeción principal.”** Resiste. Buscar otro camino para el mismo objetivo puede ser bypass.
5. **“El comprador de SAGR es desconocido.”** Resiste y sigue siendo el hallazgo comercial central.
6. **“Crash recovery no equivale a semantic recovery.”** Resiste y está reforzado por Azure/LangGraph/AWS.
7. **“Provider absorption risk is high for commodity primitives.”** Resiste y se ha fortalecido: AgentCore, Foundry, Google Agent Platform, GitHub AI Controls y SDKs cubren más superficie.

### Claims que deben degradarse o corregirse

| Claim del dossier | Corrección exigida por evidencia nueva |
|---|---|
| “OpenAI Agents API GA ships multi-step recovery” | **NO VERIFICADO EN DOCUMENTACIÓN OFICIAL CONSULTADA.** La documentación oficial sí muestra sessions, sandbox, guardrails, tracing, max turns, subagents y durable integrations; no se encontró una especificación oficial que defina “multi-step recovery” como policy-block recovery. |
| “No production system maintains context recovery layers 4 and 6” | **Demasiado amplio.** Claude SessionStore, Azure Foundry recovery, AWS AgentCore Memory, Google Memory Bank y LangGraph persistence mantienen partes de memory/state/recovery. Lo no encontrado es el conjunto side-effect ledger + minimum sufficient context + policy-aware recovery, no cada capa por separado. |
| “No system has recovery cost vs restart” | **NOT FOUND, no ausencia probada.** ACP, LangSmith, AgentCore, GitHub AI credits y Codex/Claude budget controls ya miden o limitan coste. Lo no encontrado es una decisión adaptativa y explícita de expected recovery cost versus restart cost. |
| “Side-effect continuity is an unsolved commercial gap” | **Parcialmente correcto.** Sigue siendo responsabilidad de la app, pero AWS/Azure/LangGraph/DBOS documentan watermarks, idempotency y checkpoints; no es una idea no abordada, sino una responsabilidad no automatizada de forma universal. |
| “SAGR broadly is novel” | **Contradicho.** Checkpoint, replay, fork, subagents, memory, evals, loops y budget controls son ampliamente existentes. Solo queda una composición estrecha de policy-constrained recovery. |
| “Recovery products do not exist” | **Falso si se entiende recovery de ejecución.** DBOS Conductor, Restate, Temporal, AWS, Azure, LangGraph e Inngest son productos/SDKs de recovery. Solo el recovery semántico gobernado queda `NOT FOUND`. |
| “Incident -> control -> regression is absent in commercial products” | **Demasiado absoluto.** PagerDuty/Rootly/incident.io/FireHydrant/Sentry/Datadog y LangSmith venden postmortem, follow-up, evals, clusters y fixes. No se encontró el bucle exacto append-only y policy-aware del dossier; debe afirmarse como `not found as first-class primitive`, no como inexistente. |
| “Provider controls mostly stop but do not observe/recover” | **Incompleto.** AgentCore, Foundry, Google Agent Platform, GitHub, Fiddler y TrueFoundry ya combinan runtime, observability, governance, identity y evaluation; siguen sin demostrar semantic recovery. |
| “SAGR could save money by early detection” | **Hipótesis no demostrada.** La detección temprana ahorra en algunos loops; branch exploration, evaluator calls y false recovery pueden costar más. No hay tasa de éxito ni ROI específico. |
| “RIR covers 60-70%” | **No usar como hecho comercial.** Es una afirmación académica reciente no reproducida en esta investigación. Puede permanecer como hipótesis de literatura, no como cobertura de producto/producción. |
| “Open-source competitors are only prototypes” | **No generalizar.** NeMo Guardrails, LangGraph, OpenHands, DBOS Transact y Temporal OSS tienen repositorios, releases y adopción sustancial; OSS no prueba producción pagada, pero tampoco prototipo trivial. |

### Falsificación más fuerte contra la oportunidad

El caso contra SAGR no es “ya existe un producto con ese nombre”. Es este:

1. El cliente puede comprar Temporal/DBOS/Restate para durability.
2. Puede comprar AgentCore/Foundry/Google/LangSmith/Fiddler/Zenity/TrueFoundry para observability/governance.
3. Puede comprar PagerDuty/Rootly/Sentry/Datadog para incident automation.
4. Puede usar un hook o un workflow pequeño para unirlos.
5. Si el stall está bloqueado por seguridad, el comportamiento correcto puede ser **no recuperarlo**.
6. Por tanto, el valor incremental de un recovery planner no está probado y su peor error es un bypass de control.

## 12. Juicio económico final

### Clasificación por capacidad

| Capacidad propuesta | Técnica | Producto | Cliente/presupuesto | WTP SAGR | Veredicto comercial |
|---|---|---|---|---|---|
| Detectar loops y frenar | Alta | Commoditizada | Platform/FinOps ya compra caps/observability | No específico | No diferenciador |
| Checkpoint/replay/resume | Alta | Madura | Platform/infra compra runtime | Sí, pero ya capturado por Temporal/DBOS/etc. | No oportunidad standalone |
| Context reconstruction | Media | Parcial en SDKs/cloud | Platform/AI infra | No medido | Feature de runtime o app |
| Side-effect ledger universal | Media-baja | No universal | Regulated app/platform | Potencial, pero no validado | Mejor wedge técnico, no WTP probado |
| HARD vs RECOVERABLE policy stop | Conceptualmente clara, operacionalmente difícil | No observada como primitive | CISO/Platform | Desconocido | Problema potencial, no producto validado |
| Generate policy-compliant alternative | Riesgo alto | No observada | Ningún buyer claro | No probado | Mantener como investigación, no prometer |
| Recovery budget separado | Fácil como cap, difícil como economics | No observada como SKU | FinOps/platform | Bajo; provider absorbable | No standalone |
| Branch exploration + adjudication | Existe como fork/subagents/evals | Parcial | AI platform/research | No probado | Integración, no categoría |
| Stall audit trail | Fácil con telemetry/incident tools | Ya parcialmente vendida | SRE/GRC | Posible como add-on | Solo si se integra al control existente |
| Incident -> durable regression | Parcial y manual | Incident/observability vendors | SRE/Platform | WTP por incident tooling, no por SAGR | Diferenciación metodológica no validada |

### ¿Quién pagaría, cuándo y por qué?

El único escenario con hipótesis de compra razonable es una organización que cumple simultáneamente:

- agentes unattended o long-running en producción;
- side effects externos no triviales;
- más de un provider/framework;
- una política que bloquea trabajo legítimo con frecuencia medible;
- coste de restart/review mayor que el coste de recovery;
- un owner de Platform/AI Infrastructure dispuesto a operar un sistema nuevo;
- aprobación de AppSec/CISO para que el sistema no convierta recovery en bypass.

Ese segmento existe como posibilidad, pero ningún source revisado demuestra su tamaño, frecuencia ni WTP. La recomendación analítica no es “construir”; es mantener el estado **COMMERCIAL UNKNOWN** hasta obtener logs de una flota o entrevistas reales.

### Build vs buy para el proyecto actual

- Para el control plane local de este repositorio, **build es más barato** que comprar Temporal/AgentCore/Fiddler: el sistema ya es local, Git-bound y de un solo proyecto.
- Para convertirlo en producto fleet, **buy/integrate gana**: identity, multi-provider adapters, retention, SSO, support, cloud deployment, audit export y SLA no están presentes.
- Crear un SAGR independiente para reemplazar durable workflow, guardrails, observability e incident response sería económicamente irracional: competiría con varios presupuestos simultáneamente y tendría que igualar sus integraciones.
- El mercado muestra un patrón claro: las piezas de reliability se venden como runtime, las de governance como security/platform y las de incident como SRE. SAGR no tiene aún una categoría de procurement propia.

## 13. Conclusión accionable de investigación

### Lo que se puede afirmar

1. SAGR **no es conceptualmente vacío**, pero tampoco es una categoría nueva amplia.
2. La novedad técnica defendible es **policy-constrained recovery con verificación y límites**, no “recovery” en general.
3. La parte defendible es también la más peligrosa y la menos automatizable sin un modelo formal de autorización.
4. La compra de durable execution, observability, governance e incident automation es real y tiene precios, compradores y clientes.
5. Esa realidad aumenta provider absorption y reduce el espacio de un standalone product.
6. El dossier debe usar `NOT FOUND IN BOUNDED SEARCH`, `COMMERCIAL UNKNOWN` y `WTP NOT ESTABLISHED` con más frecuencia que `ABSENT` o `SOLVED`.

### Lo que no se debe afirmar

- que un incidente caro valida una arquitectura de recovery;
- que un paper reciente es evidencia de producción;
- que un free/open-source SDK demuestra WTP;
- que un vendor logo demuestra uso del comportamiento exacto;
- que un guardrail block es un error recuperable;
- que una alternativa que alcanza el mismo objetivo después de un deny es segura;
- que no existe un sistema interno de un hyperscaler porque no se encontró documentación pública.

### Evidencia que aún cambiaría el veredicto

1. Logs anonimizados de 30-60 días que separen crash, tool failure, loop, context loss, policy block y budget spiral.
2. Para cada policy block: si era hard stop correcto, si el operador reinició, cuánto costó y si existía una alternativa autorizada.
3. Experimento con baseline: restart vs recovery, coste de tokens/latencia, tasa de éxito, false recovery, policy violation y side-effect duplication.
4. Tres o más entrevistas por rol con Platform/AppSec/SRE que describan el mismo job sin ser inducidas.
5. Un design partner que permita medir una integración dentro de Temporal/DBOS/LangGraph/AgentCore, no un producto abstracto.
6. Evidencia de presupuesto: evaluación formal, piloto pagado, PO o renovación. “Lo probaría” no es WTP.

**Veredicto final:** `TECHNICALLY PARTIALLY SUPPORTED · COMPOSITION NOVELTY NARROW · COMMERCIAL PRODUCT NOT SUPPORTED · BUYER UNKNOWN · WTP UNKNOWN · PROVIDER ABSORPTION HIGH FOR COMMODITY / MEDIUM-LOW FOR POLICY-CONSTRAINED RECOVERY · RUNTIME UNCHANGED`.

## 14. Fuentes primarias consultadas

**Fecha de consulta de las URLs sin fecha editorial explícita:** 2026-09-21.  
**Convención:** “vendor claim” significa que el dato proviene del propio proveedor; no se presenta como auditoría independiente.

### Dossier y contexto local

- [CCP SAGR Research Dossier](../CCP_SAGR_RESEARCH_DOSSIER.md), 2026-09-21. Claims y unknowns de partida; no es fuente externa.
- [Market Validation Report](./CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md), 2026-09-20. Buyer/WTP previos y límites de trazabilidad.
- [Market Sources Appendix](./CLAUDE_CONTROL_PLANE_MARKET_SOURCES.md), retrieval 2026-09-20. URLs y correcciones de claims previos.

### Durable execution y checkpoints

- [Temporal docs](https://docs.temporal.io/), documentación vigente; event history, replay, durable execution y SDKs.
- [Temporal Cloud pricing](https://docs.temporal.io/cloud/pricing), pricing vigente; acciones, storage, support plans y commitments.
- [Temporal Cloud changelog](https://temporal.io/change-log/product-area/cloud), entries 2026: HA, OpenMetrics, Worker Versioning, audit logs, external storage.
- [Temporal production/customer evidence](https://temporal.io/blog/temporal-raises-usd300m-series-d-at-a-usd5b-valuation), 2026-02-17; vendor claim sobre OpenAI, ADP, Yum! Brands, Block y métricas.
- [Restate docs](https://docs.restate.dev/), durable execution, journal, state, retries, workflows y SDKs.
- [Restate Cloud public](https://restate.dev/blog/announcing-restate-cloud-public), 2025-09-30; free tier y customer/production claims.
- [Restate BYOC](https://restate.dev/blog/announcing-restate-byoc), 2026-07-07; pricing model y >100k actions/s vendor claim.
- [Restate releases](https://github.com/restatedev/restate/releases) y [TypeScript SDK releases](https://github.com/restatedev/sdk-typescript/releases), consultados 2026-09-21; v1.7.0/v1.17.0.
- [DBOS architecture](https://docs.dbos.dev/architecture), checkpoints, Postgres, recovery, determinism/idempotency.
- [DBOS pricing](https://www.dbos.dev/dbos-pricing), $99/$499/custom, Conductor and Yutori story.
- [DBOS March 2026 features](https://www.dbos.dev/blog/dbos-new-features-march-2026), OpenAI Agents integration, MCP, alerting and Conductor.
- [AWS Lambda Durable Functions](https://docs.aws.amazon.com/lambda/latest/dg/durable-functions.html), checkpoints, replay, steps, waits, up to one year.
- [AWS Lambda pricing](https://aws.amazon.com/lambda/pricing), durable operations/data retention and official example.
- [AWS Durable Execution SDK guide](https://docs.aws.amazon.com/durable-execution), TypeScript/Python/Java SDK, testing and determinism.
- [AWS Lambda Durable Functions region expansion](https://aws.amazon.com/about-aws/whats-new/2026/04/lambda-durable-functions-16-new-regions), 2026-04-22.
- [Azure Durable Functions overview](https://learn.microsoft.com/en-us/azure/azure-functions/durable-functions/durable-functions-overview), updated 2026-06-02.
- [Azure Durable Task Scheduler billing](https://learn.microsoft.com/en-us/azure/azure-functions/durable-functions/durable-functions-billing), updated 2026-04-23/28; Dedicated/Consumption semantics.
- [Foundry long-running resilience](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/long-running-agent-resilience), 2026-07-30, updated 2026-09-10; preview boundaries and app responsibility.
- [Foundry recovery after crash](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/recover-long-running-work), 2026-08-05, updated 2026-08-19; checkpoints, watermarks and preview.
- [LangGraph durable execution](https://docs.langchain.com/oss/python/langgraph/durable-execution), checkpointers, durability modes and idempotency.
- [LangGraph time travel](https://docs.langchain.com/oss/python/langgraph/use-time-travel), replay/fork semantics and re-executed LLM/API calls.
- [LangSmith pricing](https://www.langchain.com/pricing), current Developer/Plus/Enterprise, LCU/LSU, Engine and deployment pricing.
- [LangChain production/customer page](https://www.langchain.com/built-with-langgraph), vendor customer metrics and stories.
- [Inngest pricing](https://www.inngest.com/pricing), current Hobby/Pro/Enterprise, executions, traces, customer stories.

### Agent SDKs, cloud runtimes y governance

- [OpenAI Agents SDK agents](https://openai.github.io/openai-agents-python/agents), agents, tools, handoffs, hooks, sessions and guardrails.
- [OpenAI Agents SDK guardrails](https://openai.github.io/openai-agents-python/guardrails), input/output/tool guardrails, blocking, tripwires and unsupported built-in tool pipeline.
- [OpenAI Agents SDK tracing](https://openai.github.io/openai-agents-python/tracing), trace/span model, sensitive data and ZDR limitation.
- [OpenAI Agents SDK running agents](https://openai.github.io/openai-agents-python/running_agents), max turns, sessions and Temporal/Restate/DBOS integrations.
- [Anthropic Agent SDK overview](https://code.claude.com/docs/en/agent-sdk/overview), SDK vs CLI vs managed agents.
- [Anthropic Agent SDK hooks](https://code.claude.com/docs/en/agent-sdk/hooks), hook events, allow/deny/modify, versions and timeouts.
- [Anthropic Agent SDK sessions](https://code.claude.com/docs/en/agent-sdk/sessions), resume/fork/session store/file checkpointing.
- [Anthropic Agent SDK permissions](https://code.claude.com/docs/en/agent-sdk/permissions), evaluation order and modes.
- [Anthropic Agent SDK agent loop](https://code.claude.com/docs/en/agent-sdk/agent-loop), turns, budget, compaction and result subtypes.
- [Claude Agent SDK Python changelog](https://github.com/anthropics/claude-agent-sdk-python/blob/main/CHANGELOG.md), current top entry 0.2.156 / bundled CLI 2.1.276 at retrieval.
- [Anthropic pricing](https://www.anthropic.com/pricing), Team/Enterprise/Managed Agents/API rates.
- [OpenAI Codex CLI](https://developers.openai.com/codex/cli), current CLI 0.143.0 shown in docs, local loop, resume, subagents and Git checkpoints.
- [OpenAI Codex permissions](https://developers.openai.com/codex/permissions), filesystem/network permission profiles and proxy caveat.
- [OpenAI Codex cloud](https://developers.openai.com/codex/cloud), isolated environments, parallel tasks, logs and review.
- [OpenAI Codex pricing](https://developers.openai.com/codex/pricing), Free/Plus/Pro/Business/Enterprise and API key pricing.
- [GitHub Enterprise AI Controls GA](https://github.blog/changelog/2026-02-26-enterprise-ai-controls-agent-control-plane-now-generally-available/), 2026-02-26.
- [GitHub Copilot plans](https://github.com/features/copilot/plans), current individual price and feature matrix.
- [Cursor pricing](https://cursor.com/pricing), current Individual/Teams/Enterprise features and price.
- [OpenHands docs](https://docs.openhands.dev/), Agent Canvas, SDK, Agent Server, Automation, Cloud and Enterprise.
- [OpenHands repository/releases](https://github.com/OpenHands/OpenHands/releases), v1.20.0 on 2026-09-17; v1.19.0 on 2026-09-16.
- [AWS Bedrock AgentCore overview](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html), runtime, memory, policy, observability, evaluations, registry and consumption pricing model.
- [Microsoft Foundry external agents](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/register-external-agent), 2026-08-17, updated 2026-09-14; OTEL tracing/evaluation preview.
- [Microsoft Foundry monitoring](https://learn.microsoft.com/en-us/azure/foundry/observability/how-to/how-to-monitor-agents-dashboard), 2026-09-03, updated 2026-09-11; token/latency/success/evals.
- [Google Gemini Enterprise Agent Platform scale](https://docs.cloud.google.com/gemini-enterprise-agent-platform/scale), updated 2026-09-21; runtime, sessions, memory, evals, governance, Agent Gateway and security.
- [Fiddler AI Control Plane](https://www.fiddler.ai/control-plane), current product, customer claims, inline enforcement and $0.002/trace Developer pricing claim.
- [Zenity platform](https://zenity.io/), current security/governance product and customer claims.
- [Zenity Series C](https://zenity.io/company-overview/newsroom/company-news/zenity-raises-125-million-to-secure-the-era-of-1-billion-ai-agents), 2026-08-03; funding and Fortune 500 claims.
- [Agentic Control Plane](https://agenticcontrolplane.com/), current product, integrations, vendor usage claim and pricing.
- [TrueFoundry](https://www.truefoundry.com/), current AI/MCP/Agent Gateway, TrueForge, observability and enterprise claims.

### Guardrails

- [Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html), content/topic/PII/grounding/reasoning filters and ApplyGuardrail API.
- [Amazon Bedrock pricing](https://aws.amazon.com/bedrock/pricing/), model and guardrail usage pricing page.
- [NVIDIA NeMo Guardrails docs](https://docs.nvidia.com/nemo/guardrails/latest/), SDK/microservice, execution rails, tool calls and deployment.
- [NVIDIA NeMo Guardrails repository](https://github.com/NVIDIA-NeMo/Guardrails), Apache 2.0, latest released version 0.24.1 and changelog/community telemetry.
- [Guardrails AI docs](https://www.guardrailsai.com/docs), input/output guards and Hub validators.
- [Guardrails AI repository](https://github.com/guardrails-ai/guardrails), OSS, 7.4k stars, remote inferencing discontinuation notice dated 2026-07-06.

### Incident automation and production operations

- [PagerDuty AIOps](https://www.pagerduty.com/platform/aiops/), AIOps, event orchestration, triage, automation and customer claims.
- [PagerDuty pricing](https://www.pagerduty.com/pricing/incident-management/), plan prices, AIOps/Advance/runbook automation and 30,000-company claim.
- [incident.io pricing](https://incident.io/pricing), current Basic/Team/Pro/Enterprise and AI/RCA features.
- [incident.io docs](https://docs.incident.io/), incident, on-call, workflow, RCA and postmortem product surface.
- [Rootly pricing](https://rootly.com/pricing), Incident Response/On-call/AI SRE pricing and enterprise features.
- [Rootly AI SRE](https://rootly.com/ai-sre), RCA, evidence, remediation suggestions, human sign-off and customer claims.
- [FireHydrant pricing](https://www.firehydrant.com/pricing/), Free/Pro/Enterprise, runbooks, AI, retrospectives and audit.
- [Sentry Seer](https://sentry.io/product/seer/), production telemetry to RCA/PR, integrations and $40/active contributor.
- [Datadog Bits AI](https://www.datadoghq.com/product/ai/bits-ai-agents/), AI SRE, remediation, code fixes, agent builder and 2,000 actions.

## 15. Nota de cierre metodológica

Esta investigación no ejecutó los productos, no hizo entrevistas, no vio contratos y no verificó de forma independiente los claims de customer logos, usage counters, benchmarks, funding o ROI. Las conclusiones sobre producción y clientes están etiquetadas como claims oficiales cuando proceden del proveedor. La ausencia de una feature se formula como `NO ENCONTRADA EN LA DOCUMENTACIÓN/PRICING/REPOSITORY REVISADOS`, nunca como prueba de que no existe en código privado o en un tier no accesible.

**Resultado documental:** la investigación amplía y corrige el dossier, pero no abre una fase de implementación ni cambia el runtime.
