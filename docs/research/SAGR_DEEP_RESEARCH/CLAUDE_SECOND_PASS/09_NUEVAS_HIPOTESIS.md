# 09 — Nuevas hipótesis

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Formato:** cada hipótesis tiene falsificador explícito y estado de evidencia actual.

---

## 1. Hipótesis que emergen de los hallazgos nuevos

### NH-01 — La detección de semantic-execution drift es el cuello de botella técnico de SAGR

**Enunciado:** Sin un detector confiable de SED (Semantic-Execution Drift), todos los demás componentes de SAGR son irrelevantes porque no saben cuándo activarse. La viabilidad de SAGR depende más de la precisión del detector que de los componentes de recovery.

**Base:** ReflectiChain (MDPI 2026) formaliza SED matemáticamente pero no reporta precisión del detector en producción. TRACES (2605.27690) aborda safety auditing sobre trayectorias pero no detección de stagnation semántica específicamente.

**Falsificador:** Si se demuestra que RCS/TI/SFI de ReflectiChain alcanza precision >90% y recall >80% en un benchmark de producción de agentes LLM, NH-01 se refuta (el cuello de botella no es el detector). Si la precisión es <70%, NH-01 se confirma.

**Estado actual:** HYPOTHESIS — no hay benchmark de precisión publicado para la detección de SED en producción. [HYPOTHESIS]

---

### NH-02 — La verificación de no-bypass es el cuello de botella de seguridad de SAGR

**Enunciado:** El componente más difícil de SAGR no es técnico sino de seguridad: demostrar que una alternativa generada automáticamente no es un bypass del policy bloqueado. Este problema puede ser no resoluble en el caso general, lo que hace que SAGR sea inaplicable en contextos de alta seguridad.

**Base:** El Futurum Group (búsqueda B-09) dice "The Hard(er) Challenge in Agent Governance Is Authorization" — la autorización es más difícil que el acceso. Harnessing Embodied Agents (2604.07833) lista "unsafe state entry" como tipo de fallo de recovery, sugiriendo que el problema existe.

**Falsificador:** Si alguien demuestra un protocolo formal de non-bypass verification con un teorema de corrección (probado matemáticamente o verificado empíricamente en un benchmark de red-teaming), NH-02 se refuta. Si nadie puede construirlo en 2 años de intentos, NH-02 se confirma.

**Estado actual:** HYPOTHESIS — no hay protocolo formal de non-bypass verification publicado. [HYPOTHESIS]

---

### NH-03 — Los proveedores de cloud absorberán la capa de governance pero NO la capa de alternativas autorizadas

**Enunciado:** AWS (AgentCore), Azure (Foundry), Google (Agent Platform), Anthropic (SDK) y OpenAI (Agents SDK) absorberán detección, checkpoint, retry y governance básica. Sin embargo, no absorberán la generación de alternativas policy-compliant porque: (1) hacerlo requiere conocer el intent de la política del cliente (que es privado), y (2) hay un conflicto de interés (el proveedor no debería "razonar alrededor" de las políticas de seguridad del cliente).

**Base:** NOTAS_COMERCIAL_ECONOMIA §0 tabla de "riesgo de absorción": "RIESGO ALTO EN LO COMMODITY; MEDIO/BAJO EN LA PARTE DE POLÍTICA." Ningún proveedor documentó una feature de alternative generation en 2026.

**Falsificador:** Si AWS/Azure/Anthropic anuncia una feature de "policy-compliant alternative generation" antes de Q2-2027, NH-03 se refuta. Si no aparece en 12 meses, NH-03 se confirma provisionalmente.

**Estado actual:** INFERRED — basado en ausencia en 2026 + razonamiento de conflicto de interés. [INFERRED]

---

### NH-04 — El problema de SAGR es más frecuente en multi-agente que en agente único

**Enunciado:** En sistemas de un solo agente, los stalls policy-constrained son raros porque el agente puede escalar al humano. En sistemas multi-agente donde los agentes se llaman entre sí, los stalls se pueden propagar (un agente bloqueado bloquea al orquestador), haciendo que la frecuencia sea materialmente mayor.

**Base:** arXiv:2609.18460 "Collective Loss of Control in LLM Agent Systems" modela la propagación de fallos en multi-agente como proceso epidémico. Esto sugiere que los stalls son más frecuentes y severos en sistemas multi-agente.

**Falsificador:** Si un estudio de frequencia de stalls compara single-agent vs multi-agent y no muestra diferencia significativa, NH-04 se refuta. Si multi-agent muestra >3x más stalls policy-constrained, NH-04 se confirma.

**Estado actual:** HYPOTHESIS — basado en analogía con sistemas distribuidos y el paper de epidemic account. [HYPOTHESIS]

---

### NH-05 — SAGR como feature interna del CCP tiene ROI positivo antes de SAGR como producto

**Enunciado:** Implementar las primitivas de SAGR como herramienta interna del Claude Control Plane (para uso propio en las sesiones de desarrollo del owner) tiene un ROI más claro que intentar construir SAGR como producto vendible. La razón: el owner del CCP ya tiene contexto completo de las políticas, el intent de las tareas y el repositorio — los tres elementos necesarios para que SAGR funcione.

**Base:** NOTAS_RECONSTRUCCION_REPOSITORIO §4 confirma que el CCP ya tiene primitivas parciales: snapshot de estado antes de compactar, detección de drift al reanudar, rollback Git, skill `/recovery` manual. Solo faltan: health monitor de trayectoria, clasificador RECOVERABLE/HARD_STOP, presupuesto separado, exploración acotada, adjudicador, side-effect ledger.

**Falsificador:** Si implementar los 6 componentes faltantes en el CCP tarda más de 40 horas de trabajo o produce más falsos positivos que stalls reales detectados en 30 días de uso, NH-05 se refuta. Si funciona bien internamente en 30 días, NH-05 se confirma como argumento para la próxima fase.

**Estado actual:** INFERRED — basado en estado del repositorio y razonamiento de aplicabilidad. [INFERRED]

---

## 2. Hipótesis heredadas de GPT que se mantienen sin cambios

Las siguientes hipótesis de NOTAS_CONTROL_SEGURIDAD §4 (H1-H18 de GPT) se consideran correctas y no se reformulan:

- H1-H5: sobre los tipos de stalls (repetición exacta, semántica, policy block, multi-agente, explosión de contexto) — CONFIRMADAS como taxonomía útil
- H9: "el mismo modelo no puede clasificar correctamente sus propios stalls" — INFERRED (respaldada por arXiv:2310.01798 sobre LLM self-correction)
- H12: "policy-constrained recovery requiere conocer el intent de la política" — INFERRED, consistente con el análisis de NH-03

---

## 3. Hipótesis que no sobrevivieron

### NH-X01 — "SAGR introduce primitivas fundamentalmente nuevas"

**Refutada por:** El análisis de `08_NUEVAS_PRIMITIVAS.md` muestra que SAGR es composición de primitivas conocidas con dos excepciones de alcance estrecho. La hipótesis de novedad fundamental no se sostiene.

### NH-X02 — "La durable execution resuelve el recovery semántico"

**Refutada por:** Temporal, DBOS, Restate, LangGraph y AWS todos documentan explícitamente que su replay es de ejecución, no de significado: LLM calls y API calls se re-ejecutan y pueden producir resultados distintos. La premisa "si persisto el estado, puedo continuar correctamente" es falsa.
