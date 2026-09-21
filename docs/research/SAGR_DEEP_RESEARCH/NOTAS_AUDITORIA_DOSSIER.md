# AUDITORÍA ADVERSARIAL INDEPENDIENTE DEL DOSSIER SAGR

**Documento auditado:** `docs/research/CCP_SAGR_RESEARCH_DOSSIER.md`

**Fecha de auditoría:** 2026-09-21

**Repositorio auditado:** `/home/juanls/Escritorio/claude-control-plane`

**Regla de alcance:** solo se escribió este archivo. No se modificaron hooks, settings, evaluadores, registries, `PROJECT_STATE.md`, `install.sh` ni runtime. No se ejecutaron cambios de runtime ni se abrió una fase.

**Método:** lectura completa del dossier en siete bloques; lectura de las conclusiones y auditorías previas; inspección read-only del código y del estado Git; contraste con fuentes primarias actuales, artículos arXiv, documentación oficial, issues y repositorios públicos. La síntesis final se redactó sin usar SAGR como marco conceptual.

## Veredicto ejecutivo

El dossier no es decision-grade tal como está escrito. La dirección general es razonable, pero la evidencia está mezclada en cuatro niveles incompatibles: existencia de un concepto, prototipo de investigación, paquete OSS y producto desplegado. En varios puntos el texto convierte `NOT FOUND` en una negación universal, utiliza fuentes sin URL ni identificador, atribuye a OSGuard una función que la fuente primaria no describe de ese modo y asigna a RIR una cobertura de `60–70%` sin rúbrica.

La conclusión técnica que sí sobrevive es más estrecha:

> Los agentes de larga duración pueden degradarse por loops, estado corrupto, contexto insuficiente, errores de herramienta y bloqueos de política; existen muchas piezas para detectar, limitar, guardar, reanudar y verificar, pero no se ha demostrado aquí un producto comercial general que combine todas esas piezas con generación de alternativas autorizadas y medición económica adaptativa.

La conclusión técnica que no sobrevive es:

> “No existe ningún sistema” que clasifique, limite o audite recuperación bajo política.

`Recoverability as a System Primitive`, OSGuard, AgentRewind, VIGIL, AI Runtime Infrastructure, Living AI y Replay Agent Recorder cubren partes relevantes. No prueban una solución comercial completa, pero sí impiden presentar el espacio de investigación o OSS como vacío.

La conclusión comercial previa del repositorio sí permanece sin cambio material: no hay entrevistas, piloto, presupuesto ni WTP para una oferta concreta. El dossier no produce evidencia de comprador y por tanto no puede elevar ni modificar esa clasificación.

## Hallazgos prioritarios

### 1. Baseline forense desactualizado

El dossier declara `BASELINE: Repository HEAD 035a573` en §cabecera y repite `CCP repository HEAD 035a573` en §2. El estado real leído el 2026-09-21 es:

```text
HEAD = 74f7d1e8d28f2f960a574b98df62208c4695b220
74f7d1e [RESEARCH] field validation gate — Round 0 preparation only
```

`git diff --name-only 035a573..HEAD` muestra dos cambios documentales: `CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md` y `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md`. No es evidencia de cambio de runtime, pero sí rompe la afirmación de que el dossier está anclado al HEAD actual. El dossier debía decir “baseline documental anterior” o fijar explícitamente el commit y el motivo de no incorporar los commits posteriores.

**Impacto:** material para reproducibilidad; no demuestra por sí solo un cambio de conclusión técnica.

### 2. OSGuard está descrito de forma incorrecta

El dossier presenta OSGuard como “fixed retry budget”, “terminates after N retries” y “hard stop only” (`§4 P12`, §5, §11, §L). La fuente primaria `arXiv:2606.15034v1` describe otra cosa:

- el guardrail recibe instrucción original, estado y acción propuesta;
- clasifica `allowed`, `unrelated` o `unsafe`;
- si bloquea, devuelve feedback al agente;
- el executor puede proponer una acción revisada desde el mismo estado;
- hay un máximo de dos reintentos, después del cual termina el episodio.

Fuente: [OSGuard, arXiv:2606.15034v1, §§3, 6 y 7](https://arxiv.org/html/2606.15034).

Esto no convierte OSGuard en un planner general de alternativas ni en una arquitectura de recuperación segura para producción. Sí constituye una combinación real de bloqueo de política, feedback, revisión de acción, re-chequeo y límite de reintentos. Por tanto, contradice la versión amplia del claim “no hay recuperación tras un bloqueo de política”.

### 3. Recoverability ya formaliza el núcleo de P5/P12/P13/P21

El dossier cita `Recoverability as a System Primitive` pero conserva la frase “not policy-constrained” y afirma que no existe una clasificación formal `HARD STOP vs RECOVERABLE STOP`. La fuente primaria `arXiv:2609.13672v1` define:

- selección de un punto soportado por evidencia;
- selección de una acción de recuperación permitida;
- decisión explícita `grant` o `withhold`;
- abstención automática cuando no existe una ruta válida;
- verificación independiente de restauración, autoridad y resultado;
- límites de recuperación y registro de auditoría.

Fuentes: [abstract y arXiv](https://arxiv.org/abs/2609.13672), [texto completo, §§3.3, 3.5, 4.2, 4.5 y 5](https://arxiv.org/html/2609.13672).

El artículo no genera por sí mismo el contenido de reparación y no demuestra adopción productiva. Eso mantiene abierta una laguna estricta de “generar una alternativa nueva que satisfaga una política”. Pero ya no es correcto afirmar que la clasificación o la recuperación limitada por política no están formalizadas en investigación.

### 4. La afirmación de cobertura de RIR es precisión falsa

El dossier afirma que RIR cubre `60–70%` o “70%” de la composición. No aporta una matriz de mapeo, denominador, criterio de cobertura ni cálculo reproducible. El artículo primario de RIR no afirma ese porcentaje. `arXiv:2609.18304` tiene además una versión actual `v2` del 17-09-2026, mientras el dossier usa la fecha de la versión inicial del 12/16-09-2026.

Fuente: [RIR v2, arXiv:2609.18304v2](https://arxiv.org/html/2609.18304v2).

RIR demuestra revisión adaptativa, localización de checkpoint, memoria de reflexión y presupuesto de rollback. No demuestra recuperación bajo una política de autorización de herramientas. La clasificación correcta es “solapamiento sustantivo, alcance exacto no cuantificado”, no `70%`.

### 5. Side-effect continuity no está vacía

P20 dice que no existe un producto comercial para preservar efectos externos a través de compaction. Esa versión comercial estrecha no queda resuelta; no hay evidencia de adopción o clientes. Pero el dossier también formula el gap como “no encontrado como producto” y “no existe implementación”. Hay implementaciones OSS relevantes:

- [Living AI en PyPI](https://pypi.org/pypi/livingai/json), versión `0.4.1`, con log append-only, nodos de efectos, recuperación que no reejecuta herramientas no idempotentes y omisión explícita de efectos como pagos o emails.
- [Replay Agent Recorder](https://github.com/Futuresis/replay-agent-recorder), repositorio público con `backtrack`, captura de efectos de archivos y un ledger experimental de efectos externos; se declara alpha y no restaura efectos externos de forma confiable.
- AgentRewind documenta que restaura filesystem controlado, pero no puede deshacer llamadas de red, servicios externos ni estado externo: [AgentRewind, §External Environment Recovery Boundary](https://arxiv.org/html/2608.14380v1).

La conclusión correcta es: “hay implementaciones de continuidad y no-repetición de efectos en OSS o investigación; no está demostrada su madurez comercial ni una garantía general para todos los efectos externos”.

### 6. AgentRewind debilita el vacío de “control-induced stall”

AgentRewind no solo hace checkpoint y rewind. Su paper incluye una estrategia `Safety Review` con AgentDoG: una acción insegura es rechazada, el agente recibe feedback y puede continuar reparando o decidir volver a un checkpoint. El paper también declara límites: la recuperación de estado externo está acotada y la detección de stagnation depende de validación externa.

Fuentes: [AgentRewind, arXiv:2608.14380v1](https://arxiv.org/html/2608.14380v1), [implementación pública enlazada por el paper](https://github.com/Futuresis/replay-agent-recorder).

Esto no prueba un planner de alternativas policy-compliant ni un producto de producción. Sí contradice el claim amplio de que no existe una arquitectura de recuperación que interactúe con una acción bloqueada.

### 7. OpenAI: capacidades confirmadas, fecha y semántica no confirmadas

El dossier dice que la OpenAI Agents API “GA Sept 10, 2026” trae “multi-step recovery”. La documentación oficial actual recuperada confirma:

- OpenAI gestiona sesiones, orquestación, compaction y recovery;
- existe resumption de sesiones;
- existe delegación multiagente;
- existe context compaction.

Fuentes: [Agents API overview](https://developers.openai.com/api/docs/guides/agents-api/overview), [Architecture](https://developers.openai.com/api/docs/guides/agents-api/architecture), [Quickstart](https://developers.openai.com/api/docs/guides/agents-api/quickstart).

No encontré en esas páginas una definición de “multi-step recovery” que diga que genera alternativas compatibles con un bloqueo de política. El quickstart sigue usando `beta.agents`, `OpenAI-Beta: agents=v1` y sesiones beta. Por ello la fecha GA y el alcance semántico son `NO VERIFICADOS`, no hechos confirmados.

### 8. Issue de compaction: evidencia válida, inferencia demasiado amplia

`anthropics/claude-code#24976` documenta un estado muerto cuando el contexto se agota durante trabajo paralelo: `/compact` también puede fallar y `/clear` puede perder historial, resultados de agentes y trabajo en progreso. Eso apoya “hay fallos de continuidad de contexto”. No demuestra por sí solo que se pierdan side effects del mundo externo ni que toda compaction pierda el ledger de efectos.

Fuente: [issue #24976](https://github.com/anthropics/claude-code/issues/24976), cerrada como `not planned`; documentación oficial actual de hooks y lifecycle: [Claude Code hooks](https://code.claude.com/docs/en/hooks).

### 9. Incidentes económicos sin trazabilidad suficiente

El dossier usa `$47,000`, `$16,000–$50,000`, `50x`, `5–30x` y `180K tokens/day` como soporte económico. El incidente de `$47,000` sí aparece en fuentes secundarias y en un case study de GitHub, pero no es una fuente primaria del operador:

- [Medium, CodeOrbit](https://medium.com/@theabhishek.040/our-47-000-ai-agent-production-lesson-the-reality-of-a2a-and-mcp-60c2c000d904)
- [case study de Vectara](https://github.com/vectara/awesome-agent-failures/blob/main/docs/case-studies/langchain-a2a-47k-infinite-loop.md)

En esta auditoría no apareció una fuente primaria verificable para el rango `$16K–$50K` de Claude Code, para la medición LeanOps “50x”, ni para el caso ZopDev `180K tokens/day`. El `$47K` muestra el coste de no tener límites; no demuestra que una arquitectura SAGR hubiera ahorrado ese dinero.

## Tabla de claims críticos

| ID | Claim del dossier | Ubicación | Estado independiente | Contraste y límite |
|---|---|---:|---|---|
| C-01 | El repositorio está en HEAD `035a573`. | 6, 67 | **DESACTUALIZADO** | HEAD real: `74f7d1e`; la divergencia posterior es documental, pero la línea base declarada no es la actual. |
| C-02 | Los loops de agentes son un fallo real y costoso. | 103, 115-119 | **PARCIALMENTE SOPORTADO** | IAL-Scan (`arXiv:2607.01641`) encuentra 68 fallos confirmados en 47 repos y define el problema. `$47K` solo tiene trazabilidad secundaria; el rango Claude Code no se verificó. |
| C-03 | Un bloqueo de guardrail puede provocar reintentos hasta timeout. | 105, 641 | **SOPORTADO, ALCANCE ESTRECHO** | Issue hermes #96579 lo documenta; es un issue individual, abierto, con PRs de corrección. No demuestra frecuencia de la clase. |
| C-04 | OSGuard solo corta tras un presupuesto fijo. | 204, 551, 989 | **CONTRADICHO / MAL DESCRITO** | OSGuard reevalúa propuestas bloqueadas, devuelve feedback y permite hasta dos reintentos antes de terminar. No es un planner general, pero sí es recuperación acotada bajo guardrail. |
| C-05 | No existe una clasificación formal HARD STOP/RECOVERABLE STOP. | 174-176, 642, 786 | **CONTRADICHO EN INVESTIGACIÓN; DESCONOCIDO EN PRODUCCIÓN** | Recoverability define `grant/withhold` y rutas permitidas; OSGuard define `allowed/unrelated/unsafe`. Falta probar adopción productiva general. |
| C-06 | No existe recuperación policy-compliant. | 202-204, 253-257 | **NO DEMOSTRADO; CLAIM UNIVERSAL FALSO** | OSGuard re-chequea propuestas revisadas; Recoverability liga la acción a política y evidencia; AgentRewind combina rechazo y rewind. No se encontró un planner comercial genérico que infiera alternativas completas. |
| C-07 | No existe mínimo contexto formal para recuperación. | 194-196, 255, 1077 | **CONTRADICHO EN INVESTIGACIÓN** | RIR usa `Reflection Memory`; AgentRewind usa `rewind memory`; Recoverability define `HandoffPackage`. Falta saber qué está desplegado a escala. |
| C-08 | No existe presupuesto separado de recuperación. | 198-200, 1078 | **CONTRADICHO COMO CLAIM ABSOLUTO** | RIR formaliza `B_agent` y `B_rb`; OpenAI/Anthropic tienen límites de turnos, presupuesto y sesiones. No se verificó una política comercial universal que compare recovery vs restart. |
| C-09 | RIR cubre 60-70% de SAGR. | 309, 665, 1035 | **NO SUSTENTADO / FALSA PRECISIÓN** | No hay rúbrica ni cálculo en el dossier ni en RIR; el paper no publica ese porcentaje. Solo puede afirmarse solapamiento parcial. |
| C-10 | RIR es de 12-09 y fue evaluado sin leer el texto completo. | 317, 718, 760 | **DESACTUALIZADO** | La versión primaria vigente recuperada es `v2`, 17-09-2026. La propia limitación del dossier queda superada por esta auditoría. |
| C-11 | AgentRewind solo aporta checkpoint/rewind general. | 180, 548, 578 | **PARCIAL** | Incluye Safety Review, feedback a acciones rechazadas, rewind y memoria; no incluye política general ni efectos externos reversibles. |
| C-12 | Side-effect continuity no existe como implementación. | 150, 228, 699-708 | **CONTRADICHO EN OSS; ABIERTO EN COMERCIAL** | Living AI y Replay Agent Recorder implementan ledger/replay/skip de efectos con madurez limitada; no prueban adopción ni garantía universal. |
| C-13 | Stall audit trail no existe como primitive. | 230, 257, 1082 | **NO DEMOSTRADO** | Temporal, VIGIL, Living AI y Replay registran trayectorias/eventos. No se verificó un esquema universal de “stall” tipado y portable. |
| C-14 | OpenAI GA ofrece “multi-step recovery” server-side. | 138, 545, 606, 722 | **PARCIAL / FECHA NO VERIFICADA** | Docs oficiales confirman recovery gestionado, compaction, sesiones y subagentes; no confirman el significado policy-block ni el 10-09-2026. |
| C-15 | Compaction puede perder side-effect records. | 107, 150, 646 | **PARCIALMENTE SOPORTADO** | #24976 prueba pérdida de contexto/resultados de agentes; no prueba pérdida de efectos externos. El riesgo es plausible, no medido. |
| C-16 | Loopless y Living AI son soluciones existentes. | 140-142, 540-563 | **EXISTENCIA VERIFICADA; EFICACIA NO** | PyPI confirma `loopless 0.1.1` y `livingai 0.4.1`; sus claims son de paquete/README, sin reproducción ni adopción. Living AI figura como alpha. |
| C-17 | Crash recovery/checkpoint es un problema resuelto. | 170-172, 639 | **SOPORTADO SOLO EN SENTIDO ESTRECHO** | Temporal/LangGraph tienen replay/checkpoint; no resuelven semántica, efectos externos ni autorización de reanudación. |
| C-18 | La academia converge en rollback + reflection. | 626, 840-850, 1033 | **SOBREINTERPRETADO** | Hay varios trabajos relacionados, pero cubren objetivos distintos: benchmark de seguridad, runtime, rollback, memoria, loops y testing. “Convergencia” requiere análisis sistemático, no contar papers. |
| C-19 | La investigación descubrió un gap sin equivalente nombrado. | 105, 176, 303, 569 | **CONTRADICHO EN EL NIVEL DE NOMBRE/ARQUITECTURA** | AI Runtime Infrastructure, VIGIL y Recoverability nombran y formalizan capas de runtime, recuperación y control; el gap estricto de planner policy-compliant aún es incierto. |
| C-20 | El dossier cambia la conclusión comercial. | 710, 793-797, 1134-1150 | **NO CAMBIA** | No hubo entrevistas, piloto, buyer, presupuesto ni WTP. La conclusión comercial previa `NOT SUPPORTED / NOT ENOUGH EVIDENCE` permanece. |

## Claims huérfanos y fuentes no auditables

1. El dossier declara 17 tracks, pero no conserva por track las consultas exactas, fecha/hora, corpus consultado, criterios de inclusión, lista de resultados descartados ni razón de exclusión. “THOROUGH / DEEP” en la matriz de cobertura no es una medición reproducible.
2. La mayoría de las fuentes aparecen como nombre propio sin URL, DOI, arXiv ID, commit, versión o fecha de acceso. Esto afecta FutureAGI, Zylos Research, LeanOps, Splunk, ZopDev, OSGuard, SGH, IAL-Scan, AgentAssay, ReflexGrad, VIGIL y varias guías.
3. No hay bibliografía formal del dossier. Los IDs arXiv de RIR, AgentRewind y Recoverability aparecen dispersos, pero no hay inventario fuente-claim.
4. “No commercial system”, “no system”, “nowhere” y “not implemented anywhere” no están acotados a un universo, fecha, tier, provider, repositorio o metodología de búsqueda.
5. La tabla §11 mezcla existencia, código, tests, usuarios y revenue, pero algunas filas toman existencia documentada como evidencia funcional. PyPI prueba que existe un paquete; no prueba que recupere correctamente en producción.
6. La tabla §5 marca `IMPLEMENTATION = YES` para varios sistemas sin fijar versión, commit, entorno, configuración ni haber ejecutado sus tests. Esto es incompatible con el estándar más estricto que el propio repositorio exige en el protocolo V-02.
7. El claim de `5–30x` o `50x` tokens, costos por turno y casos `$47K` no tiene una traza primaria completa. Los números deben quedar como señales anecdóticas o secundarias, no como base cuantitativa del ROI.
8. “No existe una política que clasifique policy-blocks como recoverable vs hard stop” no puede inferirse de que no se haya encontrado ese nombre. La taxonomía puede existir con otro vocabulario, como ocurre con `grant/withhold`, `allowed/unrelated/unsafe`, `Continue/Rollback` o `retry/terminate`.

## Saltos de `NOT FOUND` a `DOES NOT EXIST`

El repositorio ya tenía la regla correcta en la auditoría previa:

- `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md:314` exige `NOT FOUND (bounded search, no direct testing)`.
- `...MARKET_VALIDATION_AUDIT.md:647` dice que la auditoría no convierte `NOT FOUND` en `NOT PRESENT`.
- `...MARKET_VALIDATION_AUDIT.md:657` conserva las ausencias competitivas como `NOT FOUND` pero no `ABSENT`.
- `...MARKET_VALIDATION_AUDIT.md:718` vuelve a comprobar que no se hizo ese salto.

El dossier SAGR reabre el salto en estos pasajes:

- `§4 P5/P12`: “not implemented anywhere”.
- `§5`: “no system ensures policy compliance during recovery”.
- `§6`: “not in any system”.
- `§11`: columnas de policy-block recovery y safety during recovery con “NO solutions”.
- `§18`: P5, P12, P10, P11, P17–P22 como `NOT FOUND` sin universo de búsqueda.
- `§20`: “no current commercial product fully fills” se presenta junto a afirmaciones de ausencia técnica más amplias.

La formulación defendible sería:

> No se identificó, en las fuentes públicas consultadas hasta 2026-09-21, un producto comercial general con la combinación completa de clasificación, alternativa autorizada, límites, verificación y auditoría; existen, sin embargo, papers y OSS que cubren partes sustantivas.

## Duplicación de primitivas

La taxonomía P1–P22 tiende a convertir responsabilidades de un mismo ciclo en primitivas distintas. El riesgo es inflar novedad y superficie de producto.

| Grupo del dossier | Equivalentes observados | Lectura adversarial |
|---|---|---|
| P1 State Fingerprint + P16 Semantic Equivalence | AgentAssay behavioral fingerprint; hashes de estado; señales de trayectoria | P16 puede ser una mejora de P1, no necesariamente una primitive independiente. |
| P2 Progress Signal + P3 Loop Detector | ReflexGrad, IAL-Scan, FutureAGI, límites de frameworks | Medir progreso y detectar loop son señales distintas, pero no justifican dos productos. |
| P4 Checkpoint + P15 Trajectory Memory | Temporal, LangGraph, Living AI, Replay Agent Recorder, AgentRewind | Persistencia, replay y recuperación son capas del mismo subsistema de ejecución. |
| P5 Recovery Classifier + P12 Safety During Recovery | Recoverability `grant/withhold`; OSGuard `allowed/unrelated/unsafe`; AgentRewind Safety Review | La separación es útil como contrato, pero no prueba novedad de cada nombre. |
| P6 Recovery Planner + P14 Failed-Path Learning | Reflexion, ReflexGrad, RIR, AgentRewind rewind memory | Plan nuevo y memoria del fallo son funciones acopladas de diagnóstico/replanificación. |
| P7 Delegation + P8 Branch Exploration + P9 Adjudication | LATS, RIR, OpenAI multi-agent, AgentRewind | Es orquestación de búsqueda con una política de selección, no tres gaps autónomos. |
| P10 Minimum Context + P20 Evidence Continuity | RIR memory; AgentRewind memory; Recoverability HandoffPackage; Living AI effect ledger | El contexto mínimo y la continuidad de evidencia son un contrato de handoff/ledger. |
| P11 Recovery Budget + P19 Second-Order Governor | RIR `B_rb`; max turns; max iterations; repeated-failure termination | Un contador jerárquico puede resolver gran parte sin un predictor ni un meta-agente. |
| P13 Verification + P21 Stall Audit Trail | Recoverability evidence/audit; Temporal Event History; Living AI append-only log; VIGIL artifacts | Verificar y auditar son usos de un log con evidencia, no necesariamente primitives inéditas. |
| P22 Provider-Agnostic Envelope | Living AI, Replay Agent Recorder, LangGraph, OpenAI Agents SDK | Ya existen capas agnósticas; lo difícil es normalizar semántica y autoridad, no la envoltura. |

## Anclaje y sesgos del dossier

1. **Anclaje autobiográfico:** la experiencia del propietario de “research → objection → research → stop” se usa como analogía y evidencia de P2/P3. Es una observación útil para generar hipótesis, no evidencia de prevalencia ni de demanda.
2. **Anclaje nominal:** una vez nombrado SAGR, el corpus se organiza para encontrar sus P1–P22. No existe un paso previo que pregunte, sin ese vocabulario, cuál es el fallo fundamental o si el incidente pertenece a una clase ya conocida.
3. **Anchoring en el gap:** el dossier llega a “policy-compliant alternative generation” y luego mide los sistemas contra esa definición, aunque varios sistemas hacen algo relacionado con nombres distintos: revisar, bloquear, reintentar, replanificar, abstenerse o pedir aprobación.
4. **Anclaje en RIR:** RIR se presenta como el “closest match” y se le asigna 60–70% sin cálculo. El porcentaje parece derivado de la taxonomía del dossier, no de una métrica del paper.
5. **Anclaje por conteo de papers:** “9+ papers” y “field is converging” convierten heterogeneidad en consenso. VIGIL, ReflexGrad, IAL-Scan, OSGuard, AgentAssay, RIR y Recoverability no miden el mismo fenómeno.
6. **Anclaje comercial heredado:** el dossier conserva la conclusión `COMMERCIAL UNKNOWN / NOT SUPPORTED` del ciclo anterior. Esa continuidad es prudente y probablemente correcta, pero no debe presentarse como confirmación por el nuevo dossier: no se generó evidencia de buyer.
7. **Independencia limitada:** el dossier reconoce que el track adversarial fue escrito por el mismo contexto que produjo la síntesis positiva. La auditoría actual también es un solo contexto, pero reduce el sesgo usando fuentes primarias y una síntesis separada del vocabulario SAGR.

## Alternativas más simples

Antes de una arquitectura con classifier, planner, fan-out, adjudicator, context reconstruction, cost predictor y meta-governor, una solución mínima puede cubrir gran parte del riesgo con mecanismos deterministas:

| Fallo | Alternativa mínima | Qué no resuelve |
|---|---|---|
| Repetición exacta o reintento bloqueado | Contador por herramienta/argumento, límite global por run, timeout y escalado | Stagnation semántica compleja. |
| Bloqueo de política | Denegación estructurada con razón, lista explícita de acciones permitidas, uno o dos reintentos y luego `WITHHOLD` | No inventa una alternativa abierta; eso es una propiedad de seguridad, no una carencia accidental. |
| Coste runaway | Presupuesto pre-call de tokens/dinero/tiempo con kill switch | No estima óptimamente recovery vs restart; evita el peor caso. |
| Contexto largo | Estado externo versionado, compaction con campos invariantes y handoff pequeño | No garantiza que un resumen LLM sea correcto. |
| Efectos externos | Idempotency keys, outbox/inbox, ledger append-only y no reejecución de herramientas no idempotentes | No deshace un efecto ya confirmado. |
| Estado de workspace | Sandbox/worktree, snapshot y restore de filesystem | No restaura bases, APIs, pagos o emails fuera del sandbox. |
| Aprendizaje de fallos | Log estructurado de evento, causa, ruta, resultado y coste | No decide por sí solo la próxima acción. |
| Verificación | Check determinista independiente después de cada recuperación | No demuestra que el planner escogió la mejor ruta. |

Estas alternativas también son más fáciles de comparar experimentalmente. Una arquitectura SAGR solo justificaría su complejidad si supera a este baseline en tasa de recuperación segura, coste total, latencia, falsos `RECOVERED`, reintentos bloqueados y fricción humana.

## Contradicciones internas y con el repositorio

1. El dossier dice que OSGuard solo termina tras N reintentos, pero la fuente primaria dice que devuelve feedback y permite propuestas revisadas antes de terminar.
2. El dossier dice que Recoverability no está policy-constrained aunque el abstract exige una acción permitida y una decisión de continuar o abstenerse bajo evidencia/política.
3. El dossier dice que no hay soluciones para policy-block recovery, mientras OSGuard ofrece una recuperación acotada y AgentRewind combina guardrail rejection con rewind.
4. El dossier dice que side-effect continuity no está implementada, mientras Living AI y Replay Agent Recorder mantienen ledger/replay/skip para efectos o archivos, aunque con alcance limitado.
5. El dossier dice que no hay nombre de arquitectura, mientras `AI Runtime Infrastructure` define explícitamente una capa de ejecución con detección, recuperación y policy enforcement, y VIGIL define un runtime reflexivo de self-healing.
6. El dossier usa `RIR Sep 2026` como si una sola versión fuera estable; el arXiv actual tiene `v2` del 17-09-2026.
7. El dossier afirma que el repositorio está en `035a573`; el Git actual está en `74f7d1e`. El runtime parece no haber cambiado, pero la trazabilidad histórica sí.
8. El dossier reconoce `NOT FOUND` y ausencia de reproducción, pero en §11 y §18 presenta columnas “NO solutions” sin conservar el límite metodológico que sí aparece en la auditoría previa del repositorio.

## Log de búsquedas y contraste

| Búsqueda/fuente | Resultado | Estado usado en esta auditoría |
|---|---|---|
| Lectura `CCP_SAGR_RESEARCH_DOSSIER.md` offsets 1, 201, 401, 601, 801, 1001 | 1.186 líneas leídas completas | Base primaria del auditado. |
| `git status`, `git log`, `git rev-parse HEAD` en el repo | HEAD `74f7d1e`; `CLAUDE_SESSION_LOG.md` modificado; dossier SAGR no trackeado | Baseline actual verificado. No se revirtieron cambios ajenos. |
| `git diff --name-only 035a573..HEAD` | Dos commits/documentos posteriores; sin runtime en esa diferencia | Divergencia documental confirmada. |
| `.claude/settings.json`, hooks, `PROJECT_STATE.md`, `SESSION_HANDOFF_CURRENT.md`, registries | Hooks, evidence gate, firewall y registries confirmados; no hay runtime SAGR | Contraste local de implementación. |
| [OSGuard arXiv:2606.15034](https://arxiv.org/html/2606.15034) | Benchmark de seguridad; guardrail, feedback y dos reintentos | Contradice la descripción de “hard stop only”. |
| [Recoverability arXiv:2609.13672](https://arxiv.org/html/2609.13672) | `grant/withhold`, acción permitida, evidencia, auditoría, límites | Contradice ausencia universal de clasificación/autoridad. |
| [RIR arXiv:2609.18304v2](https://arxiv.org/html/2609.18304v2) | Review adaptativo, rollback, memoria y `B_rb`; sin policy planner | Solapamiento parcial; porcentaje 60–70 no verificable. |
| [AgentRewind arXiv:2608.14380v1](https://arxiv.org/html/2608.14380v1) | Checkpoint alineado, rewind memory, Safety Review y límites | Debilita el vacío de recuperación tras bloqueo. |
| [AI Runtime Infrastructure arXiv:2603.00495v2](https://arxiv.org/html/2603.00495) | Capa nombrada de ejecución con failure detection, recovery y policy enforcement | Contradice “no named architecture”; es research, no adopción. |
| [VIGIL arXiv:2512.07094v2](https://arxiv.org/html/2512.07094) | Runtime reflexivo externo, logs, diagnóstico, propuestas y stage gates | Equivalente parcial para auditoría/learning loop. |
| [AgentAssay arXiv:2603.02601v1](https://arxiv.org/html/2603.02601) | Behavioral fingerprints, regression gates, mutation y traces | Confirma P1/P16/P21 en testing; no live recovery. |
| [ReflexGrad arXiv:2511.14584v4](https://arxiv.org/html/2511.14584) | Progress-gated in-episode recovery y causal replanning | Confirma recuperación semántica en research, sin safety policy. |
| [IAL-Scan arXiv:2607.01641v1](https://arxiv.org/html/2607.01641) | 68 IAL confirmados en 47 repos; analiza cobertura de límites | Confirma loops como clase real; static, no runtime recovery. |
| [Anthropic Hooks](https://code.claude.com/docs/en/hooks) | Eventos actuales, `PermissionDenied.retry`, `TaskCompleted`, compaction lifecycle | Confirma primitives provider-native; no ledger de side effects probado. |
| [OpenAI Agents API overview](https://developers.openai.com/api/docs/guides/agents-api/overview) | Sesiones, compaction, recovery gestionado, multi-agent, resume | Confirma capacidades generales; no exacta semántica “policy-block recovery” ni GA date. |
| [Temporal Event History](https://docs.temporal.io/encyclopedia/event-history) | Log durable y replay después de crash | Confirma crash recovery, no recuperación semántica. |
| [LangGraph Persistence](https://docs.langchain.com/oss/python/langgraph/persistence) | Checkpointers, stores, time travel, fault tolerance, límites de retención | Confirma persistencia, no autoridad de recuperación completa. |
| [loopless PyPI JSON](https://pypi.org/pypi/loopless/json) | Versión `0.1.1`, runtime que detecta/interviene/recupera según metadata | Existencia confirmada; efectividad/adopción no. |
| [livingai PyPI JSON](https://pypi.org/pypi/livingai/json) | Versión `0.4.1`, append-only log, skip de efectos no idempotentes | Implementación OSS declarada; alpha/adopción no verificada. |
| [Replay Agent Recorder](https://github.com/Futuresis/replay-agent-recorder) | Alpha pública, backtrack, efectos de archivos, ledger externo experimental | Evidencia OSS adicional; no producto maduro. |
| [hermes-agent #96579](https://github.com/NousResearch/hermes-agent/issues/96579) | Bloqueos invisibles al contador; reintentos hasta timeout; issue abierta | Evidencia primaria de un bug, no prevalencia. |
| [hermes PR #96823](https://github.com/NousResearch/hermes-agent/pull/96823) | Corrección propuesta; discusión señala camino concurrente incompleto | El bug ya tiene mitigación en discusión; no es gap sin respuesta. |
| [Claude Code #24976](https://github.com/anthropics/claude-code/issues/24976) | Context limit dead-end; compaction puede fallar; issue `not planned` | Evidencia de continuidad de contexto, no de side effects externos. |
| ArXiv API `all:OSGuard`, `all:AgentAssay`, `all:ReflexGrad`, `all:"When Agents Do Not Stop"`, `all:"AI Runtime Infrastructure"` | IDs y abstracts recuperados | Verificación primaria de fecha/título/alcance. |
| ArXiv API `all:"From Agent Loops to Structured Graphs"` | 0 resultados | El claim queda sin identificador primario recuperado. No se convierte en inexistencia. |
| Consulta exacta `"$47,000" LangChain Analyzer Verifier` | Resultados secundarios y case study de GitHub; no operador primario | Incidente plausible, trazabilidad secundaria. |
| Consulta exacta `"$16K" "$50K" Claude Code recursive loop five hours` | No apareció una fuente primaria verificable en esta pasada | Claim no usado como cuantificación fuerte. |
| Consultas exactas `LeanOps 50x` y `ZopDev 180K tokens/day` | No apareció una fuente primaria verificable en esta pasada | Claims huérfanos. |
| Consulta oficial `site:platform.openai.com/docs "multi-step recovery"` y lectura de docs actuales | No apareció definición oficial de esa frase; docs sí dicen recovery/compaction/resume | Fecha y semántica quedan `UNKNOWN`. |

**Fallo operativo de búsqueda:** varias consultas paralelas al proveedor web devolvieron HTTP 429. No se interpretó ese error como evidencia negativa. Se sustituyeron las consultas por URLs directas, arXiv API y páginas primarias. Las consultas sin sustituto permanecen como `NO VERIFICADAS`.

## Qué evidencia cambiaría realmente la conclusión

| Conclusión actual | Evidencia que la cambiaría | Qué no bastaría |
|---|---|---|
| “Existe un problema técnico de recuperación” | Experimentos reproducibles que muestren fallos bajo tareas largas, con tasa y coste por clase | Un incidente anecdótico adicional. |
| “No hay equivalente comercial completo” | Producto público con versión/tier/documentación o teardown reproducible que una recovery policy-aware completa | Un README, funding round o claim de vendor. |
| “El gap estricto es policy-compliant alternative generation” | Código/paper que, ante un rechazo, genere alternativas, las valide contra la política y mida falsos bypasses, abstenciones y efectos | Un retry con feedback o un planner sin verificación de política. |
| “Side-effect continuity es gap comercial” | Logs de operadores que muestran duplicación/ pérdida de efectos y un piloto que reduce esos incidentes sin aumentar coste neto | Un ledger OSS sin usuarios o la posibilidad teórica de duplicación. |
| “Recovery ahorra dinero” | A/B contra restart, con coste de tokens, latencia, tasa de recuperación correcta, falsos recovered y coste de seguridad | El coste de un incidente sin recuperación. |
| “Control-induced stall es dolor de comprador” | Al menos 3 operadores independientes describen incidentes recurrentes, workaround actual, owner y presupuesto; idealmente una evaluación o piloto | Un issue público aislado o una encuesta de opinión. |
| “SAGR merece ser producto” | Buyer identificado, problema frecuente, WTP/piloto, métrica de valor y ventaja frente a controles simples | Número de papers, categoría de mercado o novedad técnica. |
| “El código actual necesita SAGR” | Incidente reproducible en CCP que el runtime actual no cubra, con contrato de cambio | Una lista de primitives interesantes o una fase futura hipotética. |

## Síntesis ciega: observaciones y fuentes, sin usar SAGR

Esta sección evita el nombre, la taxonomía y la arquitectura propuesta en el dossier. Parte solo de observaciones comprobadas.

### Observaciones

1. Los sistemas que ejecutan modelos, herramientas y actualizaciones de estado durante muchos pasos pueden no terminar, repetir una acción, crecer en contexto o continuar desde un estado ya inválido. IAL-Scan documenta el problema estructural de loops; el issue hermes documenta un caso de bloqueo contado de forma incorrecta; Claude Code #24976 documenta un estado muerto por agotamiento de contexto.
2. Hay controles básicos ampliamente disponibles: `max_turns`, `max_iterations`, timeouts, presupuestos, límites de recursión, guardrails, approvals y circuit breakers. OpenAI, Anthropic y los frameworks de workflow los documentan; esto reduce la novedad de “detectar y detener”.
3. Hay mecanismos maduros para persistir y reanudar workflows después de un crash. Temporal conserva un Event History y reproduce; LangGraph conserva checkpoints y stores; Living AI y Replay Agent Recorder ofrecen implementaciones más específicas para agentes.
4. Guardar un estado no equivale a tener permiso para continuar desde él. Recoverability demuestra esta diferencia con tests donde restauración correcta y éxito final pueden ocultar una selección de fuente no autorizada.
5. La corrección de una trayectoria y la recuperación del mundo no son la misma cosa. RIR y AgentRewind conservan memoria de intentos y restauran contexto/estado controlado; AgentRewind declara que no puede deshacer red, APIs ni estado externo.
6. El rechazo de una acción puede convertirse en otra decisión del agente. OSGuard muestra una secuencia de guardrail, feedback, propuesta revisada y límite de reintentos; AgentRewind muestra rechazo con opción de continuar o rebobinar. La seguridad depende de que cada acción revisada vuelva a ser evaluada.
7. La gestión de contexto ya es un subsistema separado: compaction, memoria selectiva, persistencia y trazas. La evidencia disponible muestra pérdidas y límites, pero no permite afirmar una tasa general de pérdida de side effects.
8. La investigación pública ya contiene runtimes externos, reflexión, fingerprints, rollback, memoria y validación. La existencia de piezas no prueba que formen un producto integrado ni que tengan usuarios.
9. El repositorio CCP actual implementa una capa local de evidencia, hooks, firewall, secret guard, registros y mantenimiento. No contiene un runtime de trayectoria que clasifique stalls, restaure estado de agente ni calcule recovery vs restart. Esa ausencia es un hecho del código local, no una afirmación sobre todo el mercado.
10. Las fuentes de mercado previas y el Field Validation Packet siguen declarando que no hubo entrevistas, buyer, WTP ni piloto. El nuevo trabajo documental no cambia ese hecho.

### Problema fundamental

El problema fundamental es la falta de un contrato operacional que conecte cuatro cosas durante una ejecución larga:

1. qué estado y qué evidencia siguen siendo utilizables;
2. qué acción puede ejecutarse desde ese estado;
3. qué efectos externos ya ocurrieron y no deben repetirse;
4. qué límite obliga a continuar, abstenerse, escalar o reiniciar.

Cuando esas relaciones están separadas, un sistema puede restaurar bytes correctos pero elegir una fuente no autorizada, bloquear una acción pero reintentarla, compactar contexto sin una contabilidad de efectos, o registrar un fallo sin detener el gasto. Este es un problema de diseño de ejecución y de evidencia. Las fuentes actuales no demuestran que sea una categoría comercial independiente.

## Clasificación final de la auditoría

| Área | Estado | Razón |
|---|---|---|
| Lectura del dossier | COMPLETA | 1.186 líneas leídas por bloques. |
| Verificación del repositorio | COMPLETA, read-only | HEAD, status, docs canónicos, settings, hooks y registries inspeccionados. |
| Evidencia de loops | SOPORTADA | IAL-Scan, issue hermes, casos secundarios. |
| Evidencia de recuperación bajo política | EXISTE EN RESEARCH/OSS | OSGuard, Recoverability, AgentRewind; alcance limitado. |
| Ausencia de producto comercial completo | NO DEMOSTRADA UNIVERSALMENTE | Búsqueda no protocolizada; solo permite “no identificado en el conjunto consultado”. |
| Ausencia de buyer/WTP | CONFIRMADA EN EL REPOSITORIO | No hubo trabajo de campo; coincide con reportes previos. |
| RIR 60–70% | RECHAZADA | Sin rúbrica ni claim primario. |
| OSGuard como hard-stop-only | RECHAZADA | Contradicha por el texto primario. |
| Side-effect continuity inexistente | REFORMULADA | Hay OSS e investigación; falta madurez comercial y cobertura de efectos externos. |
| Veredicto comercial previo | SIN CAMBIO | El dossier no añade evidencia comercial. |
| Autorización de ingeniería | NO | Esta auditoría no autoriza implementación ni fase. |

**Conclusión de cierre:** conservar la hipótesis técnica como problema abierto y estrecho, no como vacío universal ni como producto validado. Cerrar la búsqueda de escritorio salvo que aparezca una fuente primaria que cambie una fila crítica, una reproducción controlada o evidencia de operadores reales. El siguiente dato de alto valor no es otro nombre de primitive: es frecuencia observada, coste comparativo, seguridad de la recuperación y evidencia de quién pagaría por ello.
