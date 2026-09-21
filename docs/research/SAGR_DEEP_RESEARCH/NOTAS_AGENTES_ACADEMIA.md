# Evidencia primaria sobre loops, estancamiento y recuperación en agentes

**Fecha de corte:** 2026-09-21

**Objeto:** agentes LLM, coding agents, planificación, memoria/contexto, observabilidad, control de loops, rollback, replanning, branching multi-agente, señales de progreso y equivalencia semántica de estados o trayectorias.

**Restricción de ejecución:** esta investigación no modificó runtime, repositorios de agentes ni configuraciones. No se ejecutaron benchmarks con claves de proveedores ni se reclamó reproducción independiente donde no se hizo.

**Fuentes priorizadas:** papers/preprints primarios, repositorios de autores, issues y tests, documentación oficial actual, benchmarks y artefactos de reproducción. Las páginas secundarias solo se usaron para descubrir identificadores; los claims se contrastaron contra la fuente primaria.

## 0. Síntesis ejecutiva

### Veredicto corto

1. **Los loops de ejecución ya son un problema identificado y controlado parcialmente.** Existen límites de turnos, iteraciones, llamadas y tiempo; detectores exactos, detectores de ciclos, señales de estancamiento, presupuestos y tracing. Esto no equivale a una solución general de confiabilidad: la mayoría de los controles operativos terminan, advierten o devuelven el mejor estado conocido; no determinan por sí solos que una alternativa sea correcta.

2. **La reflexión y la memoria de trayectoria están bien establecidas en investigación.** ReAct mantiene trayectoria de razonamiento/acción; Reflexion transforma feedback en memoria verbal entre episodios; LATS añade búsqueda, evaluación y reflexión dentro de un árbol. Ninguno de esos trabajos demuestra por sí solo recuperación segura de efectos externos.

3. **Rollback y recuperación de trayectoria son reales, no una hipótesis futura.** GA-Rollback, AgentRewind y RIR existen como trabajos verificables. Sus contribuciones son diferentes: rollback paso a paso, checkpoint alineado de contexto/entorno y rollback selectivo con memoria de reflexión. Son papers/preprints y prototipos de investigación, no estándares de producción multi-proveedor.

4. **La señal de progreso es un cuello de botella central.** ReflexGrad usa una ventana de scores de progreso para cambiar entre refinamiento local y replanning causal; Signals y Failure-Aware Observability proponen señales baratas sobre loops, no-progreso, cambios de información, evidencia y presupuesto; otros trabajos muestran que el auto-juicio puede confundir actividad verbal con progreso real.

5. **La equivalencia semántica existe como técnica de investigación, pero no como primitiva universal de runtime.** GraphPO fusiona estados de razonamiento semánticamente similares; Otap compara grafos de ejecución con tolerancia a reordenamientos válidos; Semantic Early-Stopping compara cambios semánticos entre borradores; SDP construye estados certificados por predicados. Son soluciones de dominios concretos o de investigación y dependen de embeddings, jueces, predicados o grafos fiables.

6. **Contexto, memoria y rollback de infraestructura son capacidades diferentes.** Anthropic, OpenAI, Google ADK, LangGraph y Temporal documentan compaction, sesiones, checkpointers, rewind, replay, tracing o durable execution. Esos mecanismos resuelven continuidad, persistencia o fallo de infraestructura; no implementan automáticamente un clasificador universal `RECOVERABLE_STOP`/`HARD_STOP` ni generan alternativas que respeten la política que bloqueó una acción.

7. **El claim más defendible que sobrevive es estrecho:** en las fuentes públicas primarias revisadas no se encontró una solución integrada que combine detección semántica de estancamiento, decisión de recuperación, selección de estado, acción explícitamente autorizada por política, control de efectos externos, presupuesto de recuperación, verificación independiente y registro auditable. Esto es un resultado de búsqueda, no una prueba de inexistencia.

8. **El claim “no existe recuperación” es falso o demasiado amplio.** Hay recuperación de contexto, retry, replan, branching, rollback, replay, rewind y mejor-estado-conocido. Lo que no está demostrado públicamente es la combinación general y segura bajo políticas, efectos irreversibles y autorización dinámica.

### Qué no debe afirmarse a partir de este dossier

- No debe decirse que los loops están “resueltos”: están acotados y observables en muchos stacks, pero los loops semánticos, el autoengaño del evaluador y los efectos laterales siguen abiertos.
- No debe decirse que RIR implementa “70% de SAGR”: el paper no define SAGR ni publica esa cuantificación comparativa. La relación es cualitativa y fuerte en rollback selectivo + memoria, no una cobertura porcentual medida.
- No debe decirse que la OpenAI Agents API oficial ofrece una capacidad documentada llamada “multi-step recovery” que resuelve bloqueos de guardrails. La documentación oficial actual revisada documenta `max_turns`, sesiones, compaction, `RunState`, guardrails, handoffs y tracing; no se encontró ese claim con esa semántica.
- No debe atribuirse a OSGuard una arquitectura de recuperación por alternativas. OSGuard es un benchmark de seguridad de computer-use; su executor de evaluación usa un máximo de dos reintentos por estado, pero el paper no presenta un planificador de alternativas policy-compliant.
- No debe tratarse la ausencia de “control-induced stall” en MAST como prueba de que el fenómeno no existe. MAST clasifica fallos de sistemas multi-agente observados en su corpus; su taxonomía no pretende cubrir todos los fallos posibles.
- No debe presentarse una implementación alpha, un README o un resultado de un solo autor como evidencia de uso en producción.

## 1. Método y niveles de evidencia

### 1.1 Pregunta operativa

La búsqueda se hizo por comportamiento, no por la palabra `recovery`. Se buscaron mecanismos y síntomas equivalentes:

- repetición exacta de llamadas, ciclos A-B-A, handoff loops e infinite agentic loops;
- no-progreso, estancamiento, drift, falsa mejora, presupuesto que crece y reintento inútil;
- memoria de trayectoria, compaction, context rot, pérdida de restricciones y continuidad de efectos;
- reflection, self-critique, verbal reinforcement, causal diagnosis y replanning;
- checkpoint, replay, rewind, rollback, time travel, branch/fork, best-so-far y state restoration;
- progress score, information gain, evidence gain, trajectory efficiency y task-state validation;
- semantic similarity, state abstraction, equivalence classes, graph alignment y dependency-preserving reorderings;
- reliability, observability, tracing, failure attribution, fault localization y runtime control;
- coding agents, SWE-bench, terminal environments, workspace snapshots y file-side-effect recovery.

### 1.2 Escala usada

| Nivel | Significado | Qué permite afirmar |
|---|---|---|
| P0 | Fuente primaria verificable | El paper, repo, issue o documentación existe y contiene el comportamiento descrito |
| P1 | Artefacto público asociado | Hay código, datos, tests, logs o instrucciones de reproducción vinculados |
| P2 | Reproducción del autor | El propio artefacto muestra tests, logs o protocolo ejecutable; no implica reproducción externa |
| P3 | Reproducción independiente | Un tercero reproduce bajo condiciones comparables; no se obtuvo para los papers citados salvo que se indique |
| P4 | Producción/madurez operativa | Documentación oficial estable, API soportada o evidencia de despliegue; no equivale a validez semántica |

### 1.3 Etiquetas de madurez

- **Infraestructura madura:** Temporal; persistencia/checkpointing de LangGraph; sesiones/tracing/guardrails de SDKs oficiales.
- **Framework operativo joven:** OpenAI Agents SDK, Google ADK, Claude Agent SDK/Claude Code, todos con APIs actuales y cambios rápidos.
- **Investigación publicada:** ReAct, Reflexion, LATS, GA-Rollback, MAST, AgentBench.
- **Preprint/technical report:** RIR, AgentRewind, ReflexGrad, Recoverability, AgentAssay, IAL-Scan, OSGuard, AI Runtime Infrastructure, Signals, Otap, GraphPO, SDP.
- **OSS alpha/prototipo:** LoopGain, LoopGuard, `agent-loop-guard`, `agent-watchdog`, Replay Agent Recorder, AFM, VIGIL.

### 1.4 Regla para claims de ausencia

La fórmula usada es **“no encontrado en el corpus público primario revisado al 2026-09-21”**. No se usa “no existe” salvo para una propiedad comprobable en la documentación o código de un sistema concreto. Las implementaciones privadas, internas o no indexadas no son observables.

## 2. Taxonomía por comportamiento

| Clase de fallo | Señal observable | Respuesta existente | Límite que sigue abierto |
|---|---|---|---|
| Repetición exacta | Misma herramienta y argumentos en ventana corta | Bloqueo, warning, presupuesto | Puede ser una repetición legítima; hace falta resultado/progreso |
| Repetición con variación | Argumentos casi iguales o paráfrasis de intención | Embeddings, similitud, detectores semánticos | Umbral dependiente del dominio; riesgo de falso positivo |
| Ciclo de control | A-B-A-B, búsqueda-resumen-búsqueda, handoff cerrado | Detector de ciclos, `max_turns`, `max_iterations` | El ciclo puede cambiar texto pero conservar la misma situación efectiva |
| Resultado estancado | Misma llamada con mismo resultado vacío o error | `stagnation`, retry cap, stop/replan recomendado | Diferenciar error transitorio de callejón sin salida |
| No-progreso semántico | La interacción continúa pero no mejora el objetivo | Scores, información nueva, similitud entre borradores | El score puede ser auto-generado y no estar conectado al mundo |
| Falsa mejora | El agente declara avance, el estado externo no cambia o empeora | Evaluador externo, invariantes, trazas | Requiere oracle fuera del transcript |
| Plan equivocado | Acciones coherentes localmente, objetivo global perdido | Reflection, replanning, búsqueda | Replanning puede repetir la misma hipótesis |
| Estado contaminado | Un efecto temprano vuelve inválidas observaciones posteriores | Checkpoint + restore/rewind | Restaurar contexto no deshace API, correo, pagos o sistemas externos |
| Context drift/rot | La información crítica deja de influir después de compaction | Sessions, stores, compaction, memory | Compaction puede borrar reglas, proveniencia o ledger de efectos |
| Presupuesto espiral | Tokens, turnos o coste crecen mientras el progreso se aplana | Max budget, max turns, telemetry | Los límites detienen; no deciden si la recuperación vale más que reiniciar |
| Bloqueo de política | Guardrail rechaza una acción y el agente insiste o se detiene | Feedback de guardrail, retry acotado, escalación | No hay una semántica pública común para “otra ruta permitida” |
| Efecto lateral duplicado | Retry/replay vuelve a ejecutar una operación ya aplicada | Idempotency keys, activities, tool approvals | El runtime necesita conocer qué efecto fue realmente aplicado |
| Fallo multi-agente | Desalineación de roles, handoff cycle, verificación inconsistente | MAST, handoff limits, traces | Branching y coordinación no garantizan convergencia |

## 3. Fuentes primarias académicas y artefactos

### 3.1 Fundamentos: ReAct, Reflexion y LATS

| Trabajo | Fecha/versión | Evidencia primaria | Qué demuestra | Madurez y reproducción | Equivalencias/refutaciones |
|---|---|---|---|---|---|
| **ReAct: Synergizing Reasoning and Acting in Language Models** | arXiv v3, 2023-03-10; ICLR 2023 | [arXiv 2210.03629](https://arxiv.org/abs/2210.03629), [HTML](https://arxiv.org/html/2210.03629v3), [OpenReview](https://openreview.net/forum?id=WE_vluYUL-X) | Intercala pensamiento, acción y observación; la trayectoria sirve como memoria de trabajo y permite actualizar planes y manejar excepciones | Paper publicado; artefacto del paper; no se ejecutó aquí | No es rollback ni memoria persistente. Es la forma base de trayectoria que trabajos posteriores resumen o revisan |
| **Reflexion: Language Agents with Verbal Reinforcement Learning** | arXiv v4, 2023-10-10; NeurIPS 2023 | [arXiv 2303.11366](https://arxiv.org/abs/2303.11366), [NeurIPS](https://proceedings.neurips.cc/paper_files/paper/2023/file/1b44b878bb782e6954cd888628510e90-Paper-Conference.pdf), [repo](https://github.com/noahshinn/reflexion) | Usa evaluador, actor y self-reflection; conserva texto reflexivo y, según estrategia, la última trayectoria en memoria episódica para el siguiente trial | Publicado + repo con logs; el README advierte que reproducir todos los resultados puede ser costoso y no se reprodujo aquí | Equivale a memoria de fracaso + retry entre episodios. No restaura el estado del entorno y el paper reconoce que no hay garantía formal de éxito |
| **Language Agent Tree Search (LATS)** | arXiv v3, 2024-06-06; ICML 2024 | [arXiv 2310.04406v3](https://arxiv.org/abs/2310.04406v3), [repo oficial](https://github.com/andyz245/LanguageAgentTreeSearch), [LATS-LangGraph](https://github.com/langchain-ai/langgraph/tree/main/examples/lats) | Adapta MCTS: selección, expansión, evaluación, reflexión y backpropagation; construye múltiples trayectorias y aprovecha feedback del entorno | Paper + repo con prompts, outputs y scripts; no se ejecutó aquí por dependencias/API/entornos | Equivale a branching y adjudicación por value; asume que se puede revertir entre iteraciones. No es una política de seguridad ni un ledger de efectos externos |

**Lectura correcta de esta familia:** ReAct aporta la forma de la trayectoria; Reflexion aporta memoria verbal inter-episodio; LATS aporta búsqueda ramificada y evaluación. Llamar a los tres “recovery runtimes” mezcla niveles de abstracción.

### 3.2 Benchmarks y taxonomías

| Trabajo | Fecha/versión | Evidencia primaria | Resultado relevante | Límite de interpretación |
|---|---|---|---|---|
| **AgentBench: Evaluating LLMs as Agents** | arXiv v3, 2025-10-04; ICLR 2024; repo actualizado con AgentBench FC 2025-10-10 | [arXiv 2308.03688](https://arxiv.org/abs/2308.03688), [repo](https://github.com/THUDM/AgentBench) | 8 entornos; mide agentes en OS, DB, KG, juegos, hogar, WebShop y Web; el paper identifica mal razonamiento de largo plazo, decisión e instruction following; la edición original reporta `Task Limit Exceeded` como causa dominante | Benchmark reproducible en principio, pero exige Docker, datasets, servicios y API; no se ejecutó aquí | Es evidencia de fallos y límites de horizonte, no taxonomía de recuperación. El repo actual cambió a function calling y no debe confundirse con la edición original |
| **MAST: Why Do Multi-Agent LLM Systems Fail?** | arXiv v3, 2025-10-26; NeurIPS 2025 Datasets and Benchmarks | [arXiv 2503.13657v3](https://arxiv.org/abs/2503.13657v3), [repo/datos](https://github.com/multi-agent-systems-failure-taxonomy/MAST) | 14 modos en 3 categorías: system design/specification, inter-agent misalignment y task verification; v3 anuncia 1600+ trazas de 7 frameworks; el proceso de taxonomía usa acuerdo humano y LLM-as-judge | Publicado + dataset/código; no se reanotó ni reprodujo aquí. El README del repo todavía describe el artefacto MAD como “over 1K”, señal de deriva entre versiones; para el conteo actual se prioriza el paper v3 | No incluye una categoría dedicada llamada `control-induced stall`; esa ausencia no prueba inexistencia. Sí respalda que termination, verificación y desalineación son problemas empíricamente observables |
| **When Agents Do Not Stop: Uncovering Infinite Agentic Loops in LLM Agents** | arXiv v1, 2026-07-02 | [arXiv 2607.01641](https://arxiv.org/abs/2607.01641), [repo de artefacto](https://github.com/xinyi-hou/IAL-Scan) | Define IAL como feedback path que vuelve a disparar modelo/tool/agent/workflow sin bound efectivo; Agent IR + Agentic Loop Dependence Graph; 6.549 repos, 74 candidatos, 68 confirmados en 47 proyectos, precisión manual 91,9% según el paper | Preprint + artefacto; el repo es accesible pero no se ejecutó aquí; análisis estático, no detector semántico online | Refuta que los loops sean solo “un bug de prompt”; también muestra que el paper excluye el no-progreso puramente semántico que no puede inferirse estáticamente |
| **AgentAssay: Token-Efficient Regression Testing for Non-Deterministic AI Agent Workflows** | arXiv v1, 2026-03-03; technical report; Zenodo DOI | [arXiv 2603.02601](https://arxiv.org/abs/2603.02601), [Zenodo 10.5281/zenodo.18842011](https://doi.org/10.5281/zenodo.18842011) | Propone veredictos PASS/FAIL/INCONCLUSIVE, cobertura de herramienta/ruta/estado/boundary/model, mutación, relaciones metamórficas y behavioral fingerprints de trazas; reporta 7.605 trials y 86% de power en su evaluación | Technical report + DOI; no se verificó el repo completo ni se reprodujeron 7.605 trials | Apoya que fingerprinting y regression testing existen. Es testing offline/CI, no un detector live de recuperación; “first” es claim de autores, no hecho universal |
| **OSGuard: A Benchmark for Safety in Computer-Use Agents** | arXiv v1, 2026-06-13 | [arXiv 2606.15034](https://arxiv.org/abs/2606.15034), [HTML](https://arxiv.org/html/2606.15034v1) | Benchmark de 324 acciones y 45 variantes OSWorld; distingue allowed/unrelated/unsafe; en ejecución sin guardrail 38% de unsafe completions; con guardrail, unsafe baja a 33% y aparece 4% de retry termination | Preprint con benchmark descrito; no se ejecutó aquí | No es un recovery planner. El límite de dos retries pertenece al executor de evaluación, no a una arquitectura general de recuperación policy-compliant |

### 3.3 Rollback, rewind y recuperación de trayectoria

| Trabajo | Fecha/versión | Evidencia primaria | Mecanismo | Madurez/reproducción | Caveat crítico |
|---|---|---|---|---|---|
| **GA-Rollback: Generator-Assistant Stepwise Rollback Framework** | arXiv v4, 2025-09-26; EMNLP 2025 Main | [ACL Anthology](https://aclanthology.org/2025.emnlp-main.892/), [paper](https://aclanthology.org/2025.emnlp-main.892.pdf), [repo](https://github.com/wisper12933/GA-Rollback) | Un generator actúa; assistant revisa cada acción/observación; ante error pide rollback al prefijo anterior; añade feedback probabilístico y `Wait-Info`; `max_roll_num=6` limita reintentos | Publicado + repo con scripts para Game24/ALFWorld/WebShop; README requiere entornos, modelos y API; no se ejecutó aquí | El paper reconoce que algunos entornos no soportan rollback completo. No trata permisos externos ni garantiza que el assistant no “razone alrededor” de una política |
| **AgentRewind: Recoverable Execution for Long-Horizon LLM Agents** | arXiv v1, 2026-08-14 | [arXiv 2608.14380](https://arxiv.org/abs/2608.14380), [HTML](https://arxiv.org/html/2608.14380v1), [código](https://github.com/Futuresis/replay-agent-recorder), [MettleBench](https://github.com/Kelvin-Coffee/MettleBench) | Checkpoints alineados de contexto + entorno controlado; el agente elige rewind cuando no progresa; conserva `rewind memory`; benchmark MettleBench 82 tareas/640 criterios | Preprint + código/dataset públicos; el recorder se declara alpha; no se reprodujeron los resultados aquí | Solo restaura workspace/controlado; no deshace requests de red, servicios externos ni efectos fuera del sandbox. El propio paper dice que depende de validación externa para identificar stalls |
| **RIR: Rollback the World, Keep the Reflection** | arXiv v2, 2026-09-17 | [arXiv 2609.18304v2](https://arxiv.org/abs/2609.18304v2), [HTML](https://arxiv.org/html/2609.18304v2) | Tres decisiones: `when` review híbrido, `where` localización coarse-to-fine, `what` memoria de reflexión consistente con rollback. Mantiene objetivo, conocimiento de entorno, history y failure analysis; elimina claims branch-local invalidados | Preprint muy reciente; el paper completo es accesible; no se encontró repo/código de autores durante esta búsqueda y no hubo reproducción independiente | Es la coincidencia académica más cercana a la hipótesis SAGR, pero no incluye un clasificador de política ni alternativas garantizadas por una policy externa. El número “70%” del dossier no está en el paper |
| **Recoverability as a System Primitive** | arXiv v1, 2026-09-12 | [arXiv 2609.13672](https://arxiv.org/abs/2609.13672), [HTML](https://arxiv.org/html/2609.13672v1) | Define `recoverability` como decisión explícita sobre source + permitted recovery action o withholding; separa bytes restaurados, autoridad para continuar y éxito final; prueba con RPR-Grant/RPR-File/RPR-Authority | Preprint; runtime instances y retos deterministas descritos; no reproducción independiente aquí | Es evidencia directa contra “checkpoint = recovery”. Aun así usa políticas y trust model suministrados; no demuestra una solución abierta a cualquier política o dominio |
| **Recoverability Has a Law: ERR Measure** | arXiv v1, 2026-01-29 | [arXiv 2601.22352](https://arxiv.org/abs/2601.22352), [HTML](https://arxiv.org/html/2601.22352v1) | Formaliza Expected Recovery Regret y un surrogate Efficiency Score bajo supuestos de coste acotado, perturbación estacionaria y horizonte descontado; prueba/valida relación ERR-ES en benchmarks propios | Preprint; afirma 5 settings y Monte Carlo, pero el release prometido y la reproducción externa no fueron verificados aquí | No resuelve la selección segura de checkpoint; aporta una posible métrica de coste/eficiencia de recuperación, no un runtime gobernado |

### 3.4 ReflexGrad, progreso y replanning

| Trabajo | Fecha/versión | Evidencia primaria | Señal/mecanismo | Reproducción y límite |
|---|---|---|---|---|
| **ReflexGrad: Within-Episode Failure Recovery** | arXiv v4, 2026-05-28; workshop ICML 2026 | [arXiv 2511.14584v4](https://arxiv.org/abs/2511.14584v4), [HTML](https://arxiv.org/html/2511.14584v4), [repo](https://github.com/qpiai/reflexgrad) | Score por transición; ventana `m=5` de low-progress; router determinista FAST/SLOW/COOL; FAST TextGrad cada `k=3`; SLOW diagnóstico causal + plan; cooldown `c=5`; reporta 134 ALFWorld, 10 seeds, Qwen-3-8B 35,1→75,4 y GPT-5 46,3→88,1 | Repo incluye `REPRODUCE.md`, logs, seeds y backends; no se ejecutó aquí; resultados dependen de evaluador LLM, modelos y entorno | Es una recuperación dentro del episodio, no rollback del entorno. El “verified fix” es una salida del pipeline, no una garantía formal independiente |
| **Signals: Trajectory Sampling and Triage for Agentic Interactions** | arXiv 2604.00356 | [arXiv](https://arxiv.org/abs/2604.00356), [HTML](https://arxiv.org/html/2604.00356v1) | Señales baratas sin llamadas de modelo: misalignment, stagnation, disengagement, satisfaction, failure, loop, exhaustion; distingue stagnation discursivo de loop de control | Preprint; estudio controlado de anotación; no se reprodujo | Es observabilidad/triage, no recuperación. Su valor está en separar categorías y conservar spans trazables |
| **Early Diagnosis of Wasted Computation via Failure-Aware Observability** | arXiv 2606.01365 v2, 2026-06-15 | [arXiv](https://arxiv.org/abs/2606.01365), [HTML](https://arxiv.org/html/2606.01365v2) | Señales online de tool reliability, execution recovery, orchestration loops, evidence availability, information change y budget pressure; 165 GAIA traces y pilot de warnings | Preprint; claims cuantitativos del paper, sin reproducción aquí | Diagnostica desperdicio y puede redirigir/halt en el piloto; no presenta una semántica general de autoridad ni rollback |
| **When Do Agent Loops Mistake Stagnation for Progress?** | arXiv 2607.25152, 2026-07-27 | [arXiv](https://arxiv.org/abs/2607.25152) | Llama “progress mirage” a aceptar cambios plausibles como progreso; en 54 ciclos un frontier agent declaró mejora siempre y 56% tuvo delta real ≤0; un juez in-band aceptó 44% de regresiones | Preprint preliminar; el propio abstract lo presenta como pilot/field observation; no se reprodujo | Evidencia contra evaluar el progreso solo desde el transcript. No prueba prevalencia general ni una solución de recuperación |
| **ProgRouter** | arXiv 2608.25992 v2, 2026-08-30 | [arXiv](https://arxiv.org/abs/2608.25992v2) | Router online que elige agentes/modelos según subtask completion, progress trends, state quality, tiempo y coste | Preprint; aceptado Findings EMNLP 2026 según metadata; no se reprodujo | Replanifica/rutea modelos, no restaura estados ni evalúa autorización de acciones |

### 3.5 Equivalencia semántica de estados, trayectorias y planes

| Trabajo | Fecha/versión | Qué llama equivalencia | Uso | Límite |
|---|---|---|---|---|
| **GraphPO** | arXiv 2606.18954, 2026-06-17 | Resume estados intermedios y fusiona nodos con similitud de embeddings sobre umbral `κ`; crea clases de estados semánticamente similares | Reduce exploración redundante, comparte sufijos y señales de reward entre ramas | Investigación de RL/post-training; “equivalencia” es aproximada y dependiente de summarizer/embedding/threshold; el paper dice que el código se liberará, no se verificó un release operativo aquí |
| **Otap** | arXiv 2607.17082 v2, 2026-08-01 | Trajectory graph + unbalanced fused Gromov-Wasserstein; invariancia a reordenamientos que preservan dependencias, tolerancia de granularidad y cardinalidad | Evalúa trayectorias contra un conjunto de soluciones válidas, no contra una sola secuencia | Preprint; la estructura depende de extracción de dependencias. El propio paper reporta que su ventaja disminuye cuando el grafo se infiere de texto libre |
| **Semantic Early-Stopping (SHP)** | arXiv 2606.27009, 2026-06-25; repo | Convergencia semántica entre borradores por distancia coseno + patience; calidad separada; failsafe `MAX_ROUNDS` | Decide cuándo parar; 38% menos tokens a paridad en 60 preguntas HotpotQA para el stopper sin judge | OSS de 0 estrellas al corte, implementación reproducible declarada; no se ejecutó. La propia fuente rechaza una garantía de convergencia tipo Banach |
| **State-Centric Decision Process (SDP)** | arXiv 2605.12755, 2026-05-12 | No infiere equivalencia por embedding: construye predicados de estado que se certifican por observación; `(state, remaining plan)` define la unidad Markov bajo una hipótesis condicional | Valida progreso, localiza fallos, replantea solo el sufijo y registra cascadas de predicates | Preprint; resultados en 5 benchmarks; no reproducción aquí. La propiedad Markov depende de la hipótesis declarada, no es un hecho universal del entorno |
| **AI Planning Framework for LLM-Based Web Agents** | arXiv 2603.12710, 2026-03-13 | Usa LLM-as-judge para decidir si acciones humana/agente expresan la misma intención; propone métricas de recovery, repetitiveness, step success y partial success | Hace visible recuperación hacia hitos de una trayectoria humana | Preprint; dataset de 794 trayectorias y 812 tareas; el juez semántico añade no determinismo y sesgo; no es un equivalence detector de runtime |
| **Approximate state abstraction** | [Li et al., arXiv 1701.04113](https://arxiv.org/abs/1701.04113) | Marco clásico para tratar situaciones suficientemente similares como idénticas con garantías aproximadas en MDPs | Aporta lenguaje formal para no confundir similitud observable con equivalencia segura | No es específico de LLM agents; sirve como antecedente teórico y recordatorio de que la equivalencia requiere condiciones de transición/reward |

**Conclusión sobre equivalencia:** el concepto no es nuevo. Lo que sigue siendo difícil es una equivalencia **online, específica del objetivo, sensible a efectos externos y suficientemente conservadora para autorizar recuperación**. Similaridad de embeddings, intención verbal y equivalencia de estado no son intercambiables.

## 4. Reflexión, memoria y contexto

### 4.1 Diferencias que no deben colapsarse

| Término | Qué conserva | Qué no garantiza |
|---|---|---|
| Trayectoria ReAct | Mensajes/pensamientos/acciones/observaciones del episodio | Que la trayectoria sea correcta o que pueda revertirse |
| Memoria Reflexion | Lecciones verbales y, según configuración, último intento | Que los hechos sobrevivan a cambios de entorno o que el feedback sea correcto |
| Checkpoint | Estado serializado/reconstruible en un punto | Que ese punto sea apto para continuar |
| Store/memory | Hechos o preferencias entre sesiones | Que sean aplicables al estado actual |
| Compaction | Resumen o reducción de historia | Preservación de cada constraint, proveniencia o efecto lateral |
| Replay | Reejecución con eventos/respuestas registradas | Undo de efectos externos ya efectuados |
| Rewind/rollback | Volver a un punto anterior del estado controlado | Reversión de red, pagos, correo, APIs o procesos no capturados |
| Reflection | Diagnóstico textual/causal y propuesta | Verificación independiente de que la propuesta funciona |

### 4.2 Evidencia sobre pérdida y continuidad de contexto

| Fuente | Evidencia primaria | Estado |
|---|---|---|
| **Governance Decay** | [arXiv 2606.22528](https://arxiv.org/abs/2606.22528), [HTML v2](https://arxiv.org/html/2606.22528v2) | Mide cómo la compaction puede borrar restricciones in-context y producir violaciones; propone Constraint Pinning. Preprint; no reproducción aquí |
| **TRACE: Toward Reliable Context Compression** | [arXiv 2608.06503](https://arxiv.org/abs/2608.06503) | Evalúa compaction en boundaries con continuaciones paired cerradas sobre AppWorld; afirma degradación de pass rate/reliability con budgets menores | Work in progress según paper; no reproducción |
| **How Memory Management Impacts LLM Agents** | [ACL 2026](https://aclanthology.org/2026.acl-long.27/) | Estudia adición/eliminación de memoria y `experience-following`: memoria similar induce salidas similares; la calidad de experiencias importa | Publicado ACL; no reproducción aquí |
| **AFM** | [arXiv 2511.12712 v3](https://arxiv.org/abs/2511.12712v3), [repo](https://github.com/cruz209/AFMforLLM) | FULL/COMPRESSED/PLACEHOLDER, scoring por similitud, recencia e importancia; v3 reporta benchmark de allergy + tax policy | Technical report/OSS pequeño; el paper explicita que el resultado principal proviene de pocas ejecuciones y deja ablations/human eval para futuro |
| **VIGIL** | [arXiv 2512.07094 v2](https://arxiv.org/abs/2512.07094v2), [repo](https://github.com/cruz209/V.I.G.I.L) | Runtime externo episódico: logs, EmoBank con decay, RBT diagnosis, prompt/code proposals y stage gates; caso sintético Robin-A | Preprint + repo de 2 commits/1 star al corte; post-hoc/episódico, no intervención live; evidencia de un caso, no de producción |

### 4.3 Lo que dicen las APIs oficiales actuales

Fecha de consulta de toda esta subsección: **2026-09-21**. Las versiones se consignan solo cuando la fuente las especifica. No se debe inferir una versión exacta del paquete a partir de una página “latest”.

| Sistema | API/documentación primaria actual | Capacidad verificada | Límite semántico |
|---|---|---|---|
| **Anthropic API / Claude** | [Compaction overview](https://platform.claude.com/docs/en/build-with-claude/compaction), beta header `compact-2026-09-04`; [Claude Code hooks](https://code.claude.com/docs/en/hooks); [SDK subagents](https://code.claude.com/docs/en/agent-sdk/subagents) | Compaction on-demand y threshold; context editing; conserva turns recientes bajo opciones; hooks `PreCompact`, `PostCompact`, `SessionStart`; subagents con context isolation, `maxTurns`, memoria de agente y límites de profundidad/concurrencia/gasto | La docs no promete que un resumen preserve todos los efectos laterales o policies. No se encontró un planner de alternativas policy-compliant. “Cinco mecanismos de compaction” no es un claim verificable tal cual |
| **OpenAI Agents SDK** | [Agents](https://openai.github.io/openai-agents-python/agents/), [guardrails](https://openai.github.io/openai-agents-python/guardrails), [sessions](https://openai.github.io/openai-agents-python/sessions/), [RunState](https://openai.github.io/openai-agents-python/ref/run_state/), [tracing](https://openai.github.io/openai-agents-python/tracing/), [release v0.16.0](https://github.com/openai/openai-agents-python/releases/tag/v0.16.0) | Loop Runner hasta final output; `max_turns` (release v0.16.0 documenta default 10 y `None` para desactivarlo); tool guardrails before/after; sessions SQLite/Redis/SQLAlchemy/Mongo/Dapr/OpenAI; compaction session; `RunState` serializable para pause/resume; tracing de model/tool/handoff/guardrail | Handoffs permanecen dentro de un run; input/output guardrails no se aplican simétricamente a todos los agentes. No se encontró una feature oficial llamada “multi-step recovery” para resolver bloqueos de policy |
| **Google ADK** | [Session/State/Memory](https://google.github.io/adk-docs/sessions/), [compaction](https://google.github.io/adk-docs/context/compaction), [rewind](https://google.github.io/adk-docs/sessions/session/rewind), [LoopAgent](https://google.github.io/adk-docs/agents/workflow-agents/loop-agents/) | Session, State y Memory separados; compaction soportada en Python v1.16.0, Java v0.2.0, TypeScript v0.6.0, Kotlin v0.7.0; rewind soportado en Python v1.17.0 y Kotlin v0.3.0; LoopAgent con max iterations/escalation; TypeScript ADK 2.0 GA | Rewind no restaura app/user state ni dependencias externas; no es atómico. LoopAgent necesita max iterations o `escalate`; no decide progreso semántico por sí solo |
| **LangGraph** | [Persistence](https://docs.langchain.com/oss/python/langgraph/persistence), [interrupts](https://docs.langchain.com/oss/python/langgraph/interrupts), [graph API](https://docs.langchain.com/oss/python/langgraph/use-graph-api), [overview](https://docs.langchain.com/oss/python/langgraph/overview) | Checkpoints por super-step; `get_state`/history/time travel; Stores cross-thread; `interrupt` + `Command(resume=...)`; retry policy solo para ramas fallidas; fan-out/fan-in con `Send`; subgraphs; streaming de updates/checkpoints/tasks/debug | El nodo se reejecuta desde el inicio al reanudar; los side effects previos a `interrupt` deben ser idempotentes. La persistencia es durable execution, no semantic recovery. No hay detector universal de equivalencia semántica |
| **Temporal** | [Workflows/replay](https://docs.temporal.io/workflows.md), [error handling](https://docs.temporal.io/best-practices/error-handling), [retry policies](https://docs.temporal.io/encyclopedia/retry-policies.md), [Continue-As-New](https://docs.temporal.io/workflow-execution/continue-as-new), [Durable AI](https://docs.temporal.io/ai) | Event History, replay determinista, Activity retries, non-retryable errors, idempotency keys, Continue-As-New para histories largas, señales/approvals y agentes durable | Temporal reejecuta workflow code y reutiliza resultados de Activities; no decide si el plan semánticamente dejó de progresar. Retries pueden repetir Activities: la idempotencia es responsabilidad del usuario |
| **LangSmith** | [Observability](https://docs.langchain.com/langsmith/observability), [concepts](https://docs.langchain.com/langsmith/observability-concepts) | Runs, traces, threads, trajectories, feedback, dashboards, alerts, online evals, Engine para detectar/diagnosticar issues recurrentes | Es observabilidad/evaluación; no es por sí mismo el agente que revierte o replantea |

### 4.4 Claim de OpenAI “multi-step recovery”: resultado de auditoría

La documentación oficial actual consultada muestra:

- loop de `Runner` hasta final output, handoff o tool call;
- límite `max_turns` y excepción `MaxTurnsExceeded`;
- guardrails de input/output/tool con `tripwire`;
- sesiones persistentes y `OpenAIResponsesCompactionSession`;
- `RunState` serializable para reanudar interrupciones y aprobaciones;
- tracing detallado.

No muestra una semántica en la que el SDK, al detectar un bloqueo de guardrail, clasifique el bloqueo como recuperable, genere rutas alternativas, compare coste de recuperación con restart y verifique una nueva ruta bajo la misma política. Por tanto, el claim del dossier previo debe quedar como **no verificado / no sustentado por la documentación oficial actual**, no como capacidad disponible.

## 5. Loops, detectores y observabilidad: implementaciones públicas

| Proyecto | Estado al corte | Qué hace realmente | Qué no hace |
|---|---|---|---|
| **LoopGain** | OSS alpha; [repo](https://github.com/loopgain-ai/loopgain), 126 stars visibles al corte; Apache-2.0 | Observa un error numérico; clasifica `FAST_CONVERGE`, `CONVERGING`, `STALLING`, `OSCILLATING`, `DIVERGING`; devuelve `best_output`; rollback best-so-far; adapters para LangGraph, OpenAI Agents, Claude Agent SDK y otros; reporta 2.000 paired trials propios | Detecta convergencia, no corrección; depende del verifier/error signal; claims de benchmark son del autor y no se reprodujeron |
| **LoopGuard** | OSS alpha; [repo](https://github.com/mahimathacker/loopguard), PyPI `loopguard-runtime==0.2.1`, tests declarados; 0 stars visibles al corte | Repeated tool calls, cycles, stagnant observations, repeated failures, handoff cycles, budgets; detector semántico por embeddings opcional; decisiones `continue/warn/replan/pause/stop`; ingest offline de JSON traces | `REPLAN` y `PAUSE` son recomendaciones, no ejecución automática; documentación declara que solo interrumpe automáticamente en `STOP`; no es una prueba de producción |
| **agent-loop-guard** | OSS inicial; [repo](https://github.com/nextbridgehq/agent-loop-guard), 2 commits/8 stars visibles | Repetición exacta, ventana, mismo resultado, ciclos, errores y presupuestos; devuelve `suggestedAction=stop/change_approach`; estado persistible | Declara explícitamente que no hace retries ni backtracking; el agente debe decidir |
| **agent-watchdog** | OSS no publicado en PyPI; [repo](https://github.com/MONISMALIK1/agent-watchdog), 6 commits/0 stars visibles | Kill switch de coste, steps, repetición exacta y JSONL/webhook; 18 tests declarados | Repo pequeño; claim del incidente `$47K` aparece como contexto no verificado aquí; no recuperación |
| **IAL-Scan** | Preprint + artefacto | Análisis estático de loops de código/framework | No detecta no-progreso semántico puro, como el propio paper reconoce |
| **OpenAI tracing / LangSmith / OpenTelemetry** | APIs de observabilidad | Capturan spans, tools, turns, handoffs, guardrails, trajectories y métricas | Ver un loop no implica pararlo ni repararlo |

### Observación crítica

La evidencia contradice la tabla previa que resumía todos los detectores como “stop only”. El estado correcto es:

- límites y detectores básicos: **stop/deny**;
- detectores pequeños recientes: **warn/replan/pause como decisión o recomendación**;
- LoopGain: **best-so-far rollback** en un loop con error medible;
- papers de rollback: **restauración + reflexión/replan** en entornos controlados;
- **ninguno de esos hechos demuestra recuperación segura y general bajo política/efectos externos**.

## 6. Multi-agent branching, handoffs y adjudicación

### 6.1 Investigación

- **LATS**: branching MCTS con value/reflection; puede volver a nodos anteriores en tareas reversibles.
- **GraphPO**: fusiona estados semánticos similares en un DAG durante rollouts; es branching con equivalence classes, pero de entrenamiento/inference research, no runtime de autorización.
- **MAST**: evidencia de que la coordinación multi-agente falla por especificación, desalineación y verificación; branching no garantiza que el grupo converja.
- **AgentBench**: mide capacidad de interacción y fallos por límite de tarea; no prueba que añadir agentes mejore reliability.
- **ReflexGrad**: dos procesos con router de progreso dentro de un episodio, no múltiples agentes independientes.

### 6.2 APIs actuales

- **OpenAI Agents SDK:** manager pattern (`Agent.as_tool`) y handoffs. La documentación dice que handoffs permanecen en un run; input guardrails solo en el primer agente, output guardrails en el último, y tool guardrails para function tools. Esto es una distinción importante para no asumir que un guardrail se aplica a cada rama.
- **LangGraph:** fan-out/fan-in, `Send`, subgraphs, `max_concurrency`, checkpointers e interrupts. Solo ramas que fallan se reintentan cuando se usa retry policy; la selección de la mejor rama es lógica de aplicación.
- **Google ADK:** ParallelAgent, Sequential/Loop workflows y escalación; las docs exigen termination mechanism para LoopAgent. No hay un juez universal que compare ramas por progreso semántico.
- **Temporal:** workflows/child workflows/signals y event history permiten coordinar ramas durables; la semántica de “mejor plan” continúa siendo aplicación.

### 6.3 Equivalencia de nombres

| Nombre en una propuesta | Equivalente ya existente | Diferencia que todavía debe demostrarse |
|---|---|---|
| `explorer subagent` | nodo/branch de LATS, `Send` de LangGraph, handoff/agent-as-tool de OpenAI | contexto mínimo y aislamiento de efectos |
| `branch adjudication` | value function de LATS, score/critic, best-so-far de LoopGain | verificador externo y política de selección |
| `trajectory memory` | Event History de Temporal, checkpoints LangGraph, session stores | memoria semántica que evita reintroducir claims inválidos |
| `failed path registry` | reflection memory, LoopGuard trace/report, replay recorder | indexación por estado/política y prevención live de repetir ruta |
| `semantic state equivalence` | GraphPO classes, OTAP pseudo-metric, SDP certified state | garantía de que la equivalencia conserva acciones permitidas y efectos |

## 7. Coding agents y debugging/replay

| Sistema | Evidencia | Relevancia para loops/recovery | Estado |
|---|---|---|---|
| **SWE-agent** | [repo](https://github.com/SWE-agent/SWE-agent), [paper arXiv 2405.15793](https://arxiv.org/abs/2405.15793) | Agente de software con herramientas, trayectorias y configuración; el repo actual recomienda mini-SWE-agent | OSS maduro de investigación; no es un rollback controller |
| **mini-SWE-agent v2** | [repo](https://github.com/SWE-agent/mini-swe-agent) | Historial lineal, solo bash, cada acción independiente vía `subprocess.run`, trajectory browser; simple para inspeccionar/reproducir | Alta adopción OSS, pero la simplicidad deliberadamente no incluye branching ni semantic recovery |
| **Replay Agent Recorder** | [repo](https://github.com/Futuresis/replay-agent-recorder) | Record/replay/fork desde una llamada LLM, grafo visual, file effects y sandbox experimental; demo fake LLM offline | Alpha; solo parchea directamente OpenAI Chat Completions; no restaura procesos vivos ni efectos externos |
| **AgentRewind + MettleBench** | [paper](https://arxiv.org/abs/2608.14380), [code](https://github.com/Futuresis/replay-agent-recorder), [benchmark](https://github.com/Kelvin-Coffee/MettleBench) | El caso más directo para recovery de coding/engineering: workspace snapshots, context rewind, memory de experiencias, 82 tareas y checks deterministas | Preprint; benchmark público con workspaces descargables; no reproducción externa aquí |
| **OpenHands** | [repo](https://github.com/OpenHands/OpenHands) | Runtime/coding agent de gran adopción; la estructura actual separa frontend Agent Canvas y `software-agent-sdk`; útil como entorno de ejecución | No se usó como prueba de `StuckDetector`: la ruta/implementación actual no fue verificada en fuente primaria accesible; no atribuirle esa feature sin commit exacto |

### Resultado para coding agents

En coding agents el estado externo suele ser más observable porque el workspace, git diff y tests pueden funcionar como oracle. Eso hace viables los patrones de AgentRewind, replay, `git`/worktree y test-based progress. Pero incluso aquí:

- un test verde no demuestra que no se modificaron archivos fuera de scope;
- rollback del workspace no deshace llamadas a APIs, tickets, deploys o bases de datos;
- un contexto compacto puede perder decisiones de diseño o comandos ya ejecutados;
- un agente puede repetir un test o reabrir el mismo archivo sin que haya excepción;
- “best patch” y “best trajectory” no son lo mismo.

## 8. Reflexión y self-correction: qué está probado y qué no

### Evidencia positiva

- Reflexion mejora tareas con feedback externo o heurístico y memoria textual; el propio paper enumera como limitación depender de la capacidad de autoevaluación y no tener garantía formal.
- Self-Refine, citado y usado por GA-Rollback/ReflexGrad, muestra iteración writer-feedback-revise, pero la evidencia de mejora depende de un feedback válido.
- GA-Rollback externaliza la crítica a un assistant y agrega rollback paso a paso; sus ablations muestran que el assistant y el límite de rollbacks importan.
- RIR separa knowledge reusable de branch-local state, una distinción más precisa que “guardar toda la reflexión”.
- SDP separa `Realize` de `Validate` y `Replan`, lo que hace observable si el fallo está en acción o plan.

### Refutación necesaria

La etiqueta “self-correction” no es sinónimo de corrección real. Huang et al., **Large Language Models Cannot Self-Correct Reasoning Yet**, [arXiv 2310.01798](https://arxiv.org/abs/2310.01798), es una referencia primaria que impide asumir que una segunda pasada del mismo modelo sea un verificador fiable. La lección operacional es:

- reflexión sin feedback externo puede ser narración plausible;
- una reflexión puede conservar un hecho falso en memoria;
- un juez in-band puede premiar proceso en lugar de resultado;
- recovery debe tener un oracle o evidencia independiente cuando los efectos importan.

## 9. Estado real de claims críticos del dossier previo

Esta tabla audita los claims más relevantes del dossier previo `CCP_SAGR_RESEARCH_DOSSIER.md`. “No verificado” significa que el claim no quedó demostrado con la fuente primaria indicada; no significa que sea falso en todos los sistemas.

| Claim previo | Veredicto después de la búsqueda primaria | Evidencia/razón |
|---|---|---|
| “Loop detection es una capacidad existente” | **SÍ, con matiz** | IAL-Scan, LoopGuard, LoopGain, agent-loop-guard, SDK limits y frameworks oficiales |
| “Loop detection está solucionado” | **NO SUSTENTADO** | Los detectores tienen falsos positivos, dependen de señales y no resuelven correctness, semantic drift o side effects |
| “Los detectores solo detienen” | **REFUTADO COMO GENERALIZACIÓN** | LoopGain devuelve best-so-far/rollback; LoopGuard recomienda replan/pause; agent-loop-guard devuelve `change_approach`; otros solo paran |
| “Crash recovery/checkpointing es maduro” | **SÍ, acotado** | Temporal y LangGraph ofrecen replay/checkpoints; los docs exigen idempotencia y no revierten efectos externos automáticamente |
| “Checkpoint + rollback es novedoso” | **REFUTADO** | Temporal, LangGraph, Google ADK rewind, GA-Rollback, AgentRewind, RIR y Replay Agent Recorder |
| “Reflexión + retry es novedoso” | **REFUTADO** | Reflexion, Self-Refine, LATS y múltiples follow-ons |
| “Branch exploration/adjudication es novedoso” | **REFUTADO EN INVESTIGACIÓN** | LATS y GraphPO; APIs oficiales también exponen fan-out/handoffs, aunque no una adjudicación universal |
| “State fingerprinting es novedoso” | **REFUTADO EN INVESTIGACIÓN** | AgentAssay behavioral fingerprints; además equivalence classes de GraphPO |
| “RIR implementa 60–70% de SAGR” | **NO VERIFICADO / CUANTIFICACIÓN INVÁLIDA** | RIR no define SAGR ni publica un porcentaje de cobertura comparativa; solo se puede decir que hay solapamiento fuerte |
| “AgentRewind existe” | **VERIFICADO** | arXiv 2608.14380, repo de recorder y MettleBench enlazados por el paper |
| “GA-Rollback existe” | **VERIFICADO** | ACL Anthology EMNLP 2025 + repo con scripts y límite `max_roll_num=6` |
| “ReflexGrad existe” | **VERIFICADO** | arXiv v4 + repo con código, seeds, logs y guía de reproducción |
| “OSGuard es fixed retry budget como solución de recovery” | **REFUTADO/CONFLADO** | OSGuard es benchmark de safety; el máximo de dos retries pertenece a su executor de guarded evaluation |
| “OSGuard resuelve policy-block recovery” | **FALSO** | El paper mide guardrail local y ejecución segura; su guardrail solo rechaza y reintenta dos veces |
| “OpenAI Agents API GA ofrece multi-step recovery server-side” | **NO VERIFICADO POR DOCS OFICIALES** | Docs actuales revisadas: sessions, compaction, RunState, guardrails, handoffs, tracing, max_turns; no semántica de recovery policy-aware con ese nombre |
| “Claude Code tiene cinco mecanismos de compaction” | **NO VERIFICADO COMO COUNT** | La documentación actual enumera on-demand, threshold, context editing y opciones de retención/background/thinking; el número depende de cómo se cuenten features |
| “La compaction pierde side-effect records” | **PARCIALMENTE SUSTENTADO** | Governance Decay/TRACE muestran riesgos; docs oficiales no prometen un side-effect ledger completo; requiere benchmark por runtime |
| “No existe minimum sufficient context” | **NO ENCONTRADO COMO PRIMITIVA NOMBRADA** | RIR/AgentRewind/Reflexion tienen formas parciales; no hay definición pública común y testeable que se haya encontrado |
| “No existe recovery cost vs restart” | **NO ENCONTRADO COMO API GENERAL** | AgentAssay, LoopGain y ERR miden coste/eficiencia en dominios distintos; no se encontró un decisor runtime estándar |
| “No existe global recovery budget” | **NO ENCONTRADO COMO PRIMITIVA COMÚN** | Hay límites locales en SDKs, GA-Rollback, LoopGain y frameworks; no se verificó un presupuesto global transversal a nested recovery |
| “No existe semantic state equivalence” | **REFUTADO EN INVESTIGACIÓN** | GraphPO, Otap, semantic early stopping, SDP y planificación con semantic judge; sigue sin ser una primitiva universal de producción |
| “No existe policy-compliant alternative generation” | **NO ENCONTRADO EN CORPUS PÚBLICO, NO PRUEBA DE AUSENCIA** | Los sistemas encontrados hacen deny/retry/replan/rollback; ninguno documenta de forma explícita la construcción y verificación de una alternativa contra la misma policy |
| “Control-induced stall es una failure class establecida” | **NO COMO NOMBRE ESTÁNDAR** | El fenómeno aparece como retry after guardrail, unsafe shortcut, blocked action o termination; MAST no lo separa como clase dedicada |
| “No hay buyer evidence” | **NO EVALUADO EN ESTA investigación** | Este dossier técnico no aporta entrevistas, WTP ni datos comerciales; no debe convertir evidencia técnica en tesis de mercado |
| “Incidentes de `$47K` y `$16K–$50K` prueban SAGR” | **NO USADO COMO EVIDENCIA PRIMARIA** | En esta búsqueda no se verificaron esos importes con incident reports primarios reproducibles; a lo sumo prueban que runaway cost es plausible |

## 10. Equivalencias conceptuales y nombres que inducen error

| Nombre propuesto | Equivalencia verificable | Por qué no es idéntico |
|---|---|---|
| `state regression` | checkpoint/replay/rewind | Regression puede significar que el estado empeoró, no solo volver a un snapshot |
| `plan regression` | Reflexion/Self-Refine/SDP Replan | Un nuevo plan puede ser distinto pero semanticamente equivalente al fallido |
| `behavioral regression` | AgentAssay stochastic regression + fingerprint | AgentAssay prueba cambios entre versiones; no decide recuperación durante un run |
| `context regression` | compaction/context rot/governance decay | Compaction es una operación; regression requiere comparar comportamiento antes/después |
| `explorer subagent` | LATS node / LangGraph branch / OpenAI handoff | Un branch no hereda automáticamente el contexto mínimo ni la policy correcta |
| `adjudicator` | LATS value function / critic / OTAP metric | Score no es autoridad para ejecutar efectos |
| `trajectory memory` | Temporal Event History / LangGraph checkpoints / Reflexion memory | Event History sirve replay determinista; Reflexion sirve guidance; ninguno es equivalente a memoria semántica segura |
| `semantic state equivalence` | GraphPO embedding class / SDP certified predicate / Otap graph alignment | Similitud, certificación y equivalencia causal son propiedades diferentes |
| `recovery budget` | `max_turns`, `max_iterations`, `max_roll_num`, LoopGain cap | Un límite total no separa presupuesto productivo de presupuesto de recuperación |
| `stall classifier` | LoopGuard signals / ReflexGrad router / RIR reviewer | Un detector de patrón no es una decisión de autoridad ni un plan policy-compliant |
| `side-effect ledger` | Temporal Activity history + idempotency / replay recorder file effects | Ninguno cubre automáticamente todos los efectos externos de una aplicación |

## 11. Qué está realmente maduro

### Alto nivel de madurez

- Durable execution, event history y retry/idempotency en Temporal.
- Checkpointing, interrupt, state history y stores en LangGraph.
- Tracing/observability en OpenAI Agents SDK, LangSmith y herramientas OTel/GenAI en evolución.
- Límites básicos de ejecución (`max_turns`, `max_iterations`, budgets) en SDKs/frameworks.
- Benchmarks de capacidad como AgentBench, SWE-bench, WebArena y OSWorld.

### Madurez intermedia o experimental

- Context compaction y memory services en Anthropic, OpenAI y Google ADK: APIs reales, pero semántica de preservación depende de configuración y dominio.
- Reflection + retry y test-time search: evidencia académica sólida, coste y generalización variables.
- Coding-agent replay/rewind: AgentRewind/MettleBench y Replay Agent Recorder son relevantes, pero aún alpha/preprint.
- Detectores semánticos y progress-gated routing: public prototypes con tests/logs, no estándar inter-operable.

### No establecido como capacidad general

- Clasificación portable `HARD_STOP` versus `RECOVERABLE_STOP` para cualquier policy.
- Generación de rutas alternativas con prueba explícita de que cumplen la policy que bloqueó la ruta original.
- Equivalencia semántica de estado con garantías de preservación de acciones permitidas y efectos.
- Comparación runtime “recuperar vs reiniciar” con coste total y riesgo de side effects.
- Presupuesto global para recovery anidado que abarque agente principal, subagentes, retries y callbacks.
- Ledger universal y obligatorio de side effects atravesando compaction, replay y provider boundaries.

## 12. Implicaciones para una hipótesis SAGR

### Lo que ya es commodity o casi commodity

- `max_turns`, `max_iterations`, timeouts y budgets;
- tracing de llamadas, herramientas, handoffs y guardrails;
- checkpointers, sessions y event history;
- retry de errores transitorios y `non_retryable`;
- reflection textual entre intentos;
- fan-out/fan-in, handoffs y subagents;
- detección exacta de repetición y ciclos;
- compaction y stores básicos.

### Composición que sí tiene interés técnico

Una composición públicamente poco cubierta sería:

```text
señal de estancamiento
  -> clasificación conservadora del fallo
  -> selección de estado apoyada por evidencia
  -> selección de acción permitida desde ese estado
  -> control explícito de side effects
  -> presupuesto separado de recovery
  -> branch/replan acotado
  -> verificación externa del estado y del permiso
  -> auditoría de la decisión y del coste
```

RIR cubre una parte sustancial de `review -> restore -> retain valid knowledge`; AgentRewind cubre `aligned context/environment checkpoint -> rewind memory`; Recoverability formaliza `source + route + authority + withholding`; LoopGain/LoopGuard cubren partes de `signal -> stop/best-so-far/recommendation`. La novedad defendible, si se quisiera investigar, es la **composición bajo autoridad y efectos externos**, no cada bloque aislado.

### Riesgo de seguridad

Un recovery planner que recibe “la policy bloqueó esta acción” y se le pide “lograr el mismo resultado por otra vía” puede convertirse en un bypass. La distinción segura es:

- **reparar el plan dentro del objetivo y del alcance autorizado**, o
- **cambiar/limitar el objetivo con autorización humana**, o
- **detener**.

No es suficiente pedir al mismo LLM que explique la policy y certifique que su propia alternativa la cumple. La fuente de autoridad debe estar fuera de la narrativa que se está recuperando.

### Experimentos mínimos que separarían claims

1. **Loop sintáctico:** herramienta que retorna el mismo resultado; medir exact-repeat, cycle, stagnation y coste hasta stop.
2. **Stagnation semántico:** llamadas con argumentos distintos pero mismo objetivo/estado; comparar detector exacto, embedding, progress signal y juez externo.
3. **Falsa mejora:** agente que siempre declara progreso; oracle de estado externo; medir false acceptance.
4. **Compaction:** insertar policy/side-effect ledger temprano, compactar varias veces y probar si se conserva la restricción y la proveniencia.
5. **Rollback:** error en archivo + API externa simulada; comparar restore de workspace, context rewind y ledger de efectos.
6. **Policy block:** una acción insegura bloqueada, una alternativa segura disponible y una ruta sin alternativa; medir si el sistema distingue recovery de hard stop sin ampliar autorización.
7. **Branch adjudication:** dos ramas con progreso aparente; una mejora un artefacto verificable y otra solo produce más texto; adjudicar con oracle externo.
8. **Coste:** mismo task con recover budget separado, restart budget y global nested budget; medir coste, latencia, éxito y falsos recoveries.

## 13. Registro de fuentes primarias

### Papers/preprints y repositorios

- ReAct: [arXiv](https://arxiv.org/abs/2210.03629), [OpenReview](https://openreview.net/forum?id=WE_vluYUL-X).
- Reflexion: [arXiv](https://arxiv.org/abs/2303.11366), [NeurIPS 2023](https://proceedings.neurips.cc/paper_files/paper/2023/file/1b44b878bb782e6954cd888628510e90-Paper-Conference.pdf), [GitHub](https://github.com/noahshinn/reflexion).
- LATS: [arXiv](https://arxiv.org/abs/2310.04406v3), [GitHub](https://github.com/andyz245/LanguageAgentTreeSearch), [LangGraph example](https://github.com/langchain-ai/langgraph/tree/main/examples/lats).
- AgentBench: [arXiv](https://arxiv.org/abs/2308.03688), [GitHub](https://github.com/THUDM/AgentBench).
- MAST: [arXiv](https://arxiv.org/abs/2503.13657v3), [GitHub](https://github.com/multi-agent-systems-failure-taxonomy/MAST).
- GA-Rollback: [ACL Anthology](https://aclanthology.org/2025.emnlp-main.892/), [arXiv](https://arxiv.org/abs/2503.02519), [GitHub](https://github.com/wisper12933/GA-Rollback).
- ReflexGrad: [arXiv](https://arxiv.org/abs/2511.14584v4), [GitHub](https://github.com/qpiai/reflexgrad).
- RIR: [arXiv](https://arxiv.org/abs/2609.18304v2).
- AgentRewind: [arXiv](https://arxiv.org/abs/2608.14380v1), [recorder](https://github.com/Futuresis/replay-agent-recorder), [MettleBench](https://github.com/Kelvin-Coffee/MettleBench).
- Recoverability as a System Primitive: [arXiv](https://arxiv.org/abs/2609.13672v1).
- Recoverability Has a Law / ERR: [arXiv](https://arxiv.org/abs/2601.22352v1).
- AgentAssay: [arXiv](https://arxiv.org/abs/2603.02601v1), [Zenodo](https://doi.org/10.5281/zenodo.18842011).
- IAL-Scan: [arXiv](https://arxiv.org/abs/2607.01641v1), [artifact repository](https://github.com/xinyi-hou/IAL-Scan).
- OSGuard: [arXiv](https://arxiv.org/abs/2606.15034v1), [HTML](https://arxiv.org/html/2606.15034v1).
- Signals: [arXiv](https://arxiv.org/abs/2604.00356v1).
- Failure-Aware Observability: [arXiv](https://arxiv.org/abs/2606.01365v2).
- Progress Mirage: [arXiv](https://arxiv.org/abs/2607.25152).
- Semantic Early-Stopping/SHP: [arXiv](https://arxiv.org/abs/2606.27009v1), [GitHub](https://github.com/SahilShrivastava-Dev/semantic-halting-problem).
- GraphPO: [arXiv](https://arxiv.org/abs/2606.18954v1).
- Otap: [arXiv](https://arxiv.org/abs/2607.17082v2).
- State-Centric Decision Process: [arXiv](https://arxiv.org/abs/2605.12755v1).
- AI Planning Framework for Web Agents: [arXiv](https://arxiv.org/abs/2603.12710v1).
- AI Runtime Infrastructure: [arXiv](https://arxiv.org/abs/2603.00495v2).
- VIGIL: [arXiv](https://arxiv.org/abs/2512.07094v2), [GitHub](https://github.com/cruz209/V.I.G.I.L).
- Adaptive Focus Memory: [arXiv](https://arxiv.org/abs/2511.12712v3), [GitHub](https://github.com/cruz209/AFMforLLM).
- Governance Decay: [arXiv](https://arxiv.org/abs/2606.22528v2).
- Reliable Context Compression / TRACE: [arXiv](https://arxiv.org/abs/2608.06503v1).
- Memory management study: [ACL Anthology](https://aclanthology.org/2026.acl-long.27/).
- LLM self-correction caution: [arXiv](https://arxiv.org/abs/2310.01798).
- Approximate state abstraction: [arXiv](https://arxiv.org/abs/1701.04113).

### Runtimes, APIs y documentación oficial

- Anthropic compaction: [Platform docs](https://platform.claude.com/docs/en/build-with-claude/compaction).
- Claude Code hooks: [official reference](https://code.claude.com/docs/en/hooks).
- Claude Agent SDK subagents: [official docs](https://code.claude.com/docs/en/agent-sdk/subagents).
- OpenAI Agents SDK agents: [official docs](https://openai.github.io/openai-agents-python/agents/).
- OpenAI Agents SDK guardrails: [official docs](https://openai.github.io/openai-agents-python/guardrails).
- OpenAI Agents SDK sessions/compaction: [official docs](https://openai.github.io/openai-agents-python/sessions/).
- OpenAI Agents SDK RunState: [API reference](https://openai.github.io/openai-agents-python/ref/run_state/).
- OpenAI Agents SDK tracing: [official docs](https://openai.github.io/openai-agents-python/tracing/).
- Google ADK sessions/state/memory: [official docs](https://google.github.io/adk-docs/sessions/).
- Google ADK compaction: [official docs](https://google.github.io/adk-docs/context/compaction).
- Google ADK rewind: [official docs](https://google.github.io/adk-docs/sessions/session/rewind).
- Google ADK workflow loops: [official docs](https://google.github.io/adk-docs/agents/workflow-agents/loop-agents/).
- LangGraph overview: [official docs](https://docs.langchain.com/oss/python/langgraph/overview).
- LangGraph persistence: [official docs](https://docs.langchain.com/oss/python/langgraph/persistence).
- LangGraph interrupts: [official docs](https://docs.langchain.com/oss/python/langgraph/interrupts).
- LangGraph graph API/retries/branches: [official docs](https://docs.langchain.com/oss/python/langgraph/use-graph-api).
- Temporal workflows/replay: [official docs](https://docs.temporal.io/workflows.md).
- Temporal retries/error handling: [official docs](https://docs.temporal.io/best-practices/error-handling).
- Temporal Continue-As-New: [official docs](https://docs.temporal.io/workflow-execution/continue-as-new).
- Temporal Durable AI: [official docs](https://docs.temporal.io/ai).
- LangSmith observability: [official docs](https://docs.langchain.com/langsmith/observability).
- LangSmith traces/threads/trajectories: [official docs](https://docs.langchain.com/langsmith/observability-concepts).
- OpenTelemetry GenAI conventions: [current SDK semantic conventions](https://open-telemetry.github.io/opentelemetry-js/modules/_opentelemetry_semantic-conventions.html).

### OSS de loop detection/observabilidad

- LoopGain: [GitHub](https://github.com/loopgain-ai/loopgain).
- LoopGuard: [GitHub](https://github.com/mahimathacker/loopguard), [PyPI](https://pypi.org/project/loopguard-runtime/0.2.1/).
- agent-loop-guard: [GitHub](https://github.com/nextbridgehq/agent-loop-guard), [npm](https://www.npmjs.com/package/agent-loop-guard).
- agent-watchdog: [GitHub](https://github.com/MONISMALIK1/agent-watchdog).
- Replay Agent Recorder: [GitHub](https://github.com/Futuresis/replay-agent-recorder).
- mini-SWE-agent: [GitHub](https://github.com/SWE-agent/mini-swe-agent).
- SWE-agent: [GitHub](https://github.com/SWE-agent/SWE-agent), [paper](https://arxiv.org/abs/2405.15793).

## 14. Reproducción realizada y no realizada

### Realizado

- Verificación de existencia y metadata de papers mediante páginas arXiv/ACL/OpenReview.
- Lectura de abstracts y, para los trabajos centrales, HTML completo de ReAct/Reflexion/LATS/GA-Rollback/RIR/ReflexGrad/AgentRewind/Recoverability/OSGuard/AgentAssay/AI Runtime Infrastructure/GraphPO/Otap/SDP y documentación asociada.
- Verificación de repositorios oficiales, README, estructura de tests o instrucciones donde estaban disponibles.
- Verificación documental de las APIs oficiales de Anthropic, OpenAI Agents SDK, Google ADK, LangGraph, Temporal y LangSmith.

### No realizado

- No se ejecutaron los benchmarks de pago de Reflexion, LATS, ReflexGrad, RIR, AgentRewind, GA-Rollback u OpenAI/Anthropic.
- No se clonaron repositorios ni se ejecutaron tests en este turno.
- No se reprodujo ningún claim numérico de 2025–2026.
- No se hizo entrevista de operador, medición de buyer evidence ni prueba de producción.
- No se verificaron implementaciones privadas o internas.

### Qué significa “reproducible” en las tablas

Un repo con `tests/`, `REPRODUCE.md`, seeds o logs recibe **artefacto reproducible**, no **resultado reproducido**. Para llamar a un resultado reproducido habría que ejecutar el código, fijar versiones/modelos/datasets, registrar coste y comparar las métricas.

## 15. Conclusión final

La investigación primaria no respalda una tesis de “nadie ha pensado en recovery”. La comunidad ya tiene reflexión, memoria verbal, búsqueda ramificada, retries, checkpoints, compaction, rewind, replay, progress scoring, loop detection, observabilidad y varios prototipos de rollback.

Sí respalda una tesis más precisa:

> **La recuperación de un agente es una decisión sobre estado, acción, autoridad, evidencia y efectos, no solo una nueva llamada al modelo ni un snapshot restaurado.**

RIR, AgentRewind y Recoverability hacen visible esa dirección desde ángulos distintos. LoopGain, LoopGuard, ReflexGrad, IAL-Scan y las APIs oficiales cubren señales y controles parciales. El hueco público que permanece no es una primitiva aislada, sino una composición verificable y segura que:

- detecte no-progreso sin confundir actividad con avance;
- distinga estado guardado de estado autorizado para continuar;
- seleccione una ruta de recovery compatible con la policy vigente;
- no repita ni duplique side effects;
- limite el recovery a un presupuesto global y observable;
- verifique el estado y la autorización desde evidencia independiente;
- pueda auditar por qué continuó o por qué se detuvo.

Ese claim queda en **parcialmente apoyado técnicamente, no probado en producción y no convertido en oportunidad comercial** por esta investigación. Las afirmaciones más amplias del dossier previo deben degradarse a esa formulación.

---

**Estado del archivo:** investigación documental primaria, corte 2026-09-21. Runtime no modificado.
