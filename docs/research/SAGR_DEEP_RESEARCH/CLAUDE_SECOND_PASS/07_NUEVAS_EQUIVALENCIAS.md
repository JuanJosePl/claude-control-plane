# 07 — Nuevas equivalencias entre SAGR y sistemas existentes

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Base:** NOTAS_SISTEMAS_CLASICOS (GPT) + hallazgos de búsqueda independiente.

---

## 1. Equivalencias ya documentadas por GPT (confirmadas)

| Componente SAGR | Equivalente clásico | Donde vive en producción |
|---|---|---|
| Loop detection | Circuit breaker (Hystrix/Resilience4j), max_turns, watchdog timer | Claude Agent SDK, Temporal, Restate |
| Checkpoint de estado | WAL/ARIES, MVCC snapshots, workflow history | Temporal, DBOS, LangGraph, AWS Durable |
| Replay de ejecución | Deterministic replay, event sourcing | Temporal, DBOS, Restate |
| Retry con backoff | Exponential backoff, retry budgets | Restate (infinite default), AWS, Azure |
| Hard stop | Circuit breaker OPEN, fail-fast | max_turns, budget cap, Kubernetes liveness probe |
| Side effect ledger | Idempotency keys (Stripe), saga compensation log | Temporal Activities, DBOS steps, watermarks |
| Recovery vs restart | ARIES redo/undo, saga forward/compensate | Frameworks de workflow, no agentes |
| Presupuesto de exploración | Bounded search (A*, MCTS con límite), retry limit | LangGraph fork, subagents |
| Verificación de completion | CI/CD test suite, acceptance criteria | TaskCompleted hook, LangSmith evals |
| Human-in-the-loop para recovery | Approval gates, two-person integrity | LangGraph interrupt, Temporal signal, ACS |

---

## 2. Nuevas equivalencias encontradas en segunda pasada

### EQ-N01 — SAGR-detect ≡ SPC (Statistical Process Control) de producción

**Equivalente:** SPC (control estadístico de proceso) — monitorea desviaciones de la media con límites de control (UCL/LCL). Cuando una métrica excede los límites, se alerta o para el proceso.

**Equivalente en SAGR:** La detección de semantic-execution drift de ReflectiChain puede formalizarse como SPC sobre la métrica SFI (Semantic Fidelity Index). Si D(t) > UCL_drift, se activa el recovery.

**Novedad relativa:** SPC es de los años 1920s (Shewhart). La novedad de SAGR-detect no es la idea de monitorear estadísticamente, sino definir la métrica correcta sobre trayectorias de lenguaje natural.

**Implicación:** El componente de detección de SAGR no es fundamentalmente nuevo; es la aplicación de control estadístico a una nueva métrica (SFI/RCS) en un nuevo dominio (agentes LLM). [INFERRED]

---

### EQ-N02 — SAGR-classify ≡ Triage en incident management

**Equivalente:** El proceso de triage en incident management (PagerDuty, OpsGenie) clasifica un alerta como: P1 (stop todo), P2 (acción inmediata) o P3 (monitorear). El triage determina si el incidente requiere escalación (HARD_STOP) o puede manejarse operacionalmente (RECOVERABLE).

**Equivalente en SAGR:** La clasificación HARD_STOP vs RECOVERABLE_STOP es análoga al triage de incidentes. La diferencia: en incident management, el triage es manual o basado en reglas simples; en SAGR, el clasificador debe operar sobre contexto semántico del agente.

**Novedad relativa:** El patrón de triage existe; el desafío es la precisión del clasificador en dominio de agentes LLM. [INFERRED]

---

### EQ-N03 — SAGR-govern ≡ RBAC con delegación de autoridad

**Equivalente:** Los sistemas de RBAC (Role-Based Access Control) definen qué roles pueden hacer qué acciones. En sistemas con delegación (AWS STS assume-role, OAuth token exchange), un rol puede solicitar temporalmente autorización adicional con justificación.

**Equivalente en SAGR:** La generación de alternativas autorizadas en SAGR es análoga a la delegación controlada: el agente propone una acción alternativa, el sistema de governance verifica que la propuesta esté dentro del scope autorizado, y decide allow/deny/modify.

**Gap específico de SAGR:** RBAC con delegación es estático (roles predefinidos). SAGR requería generación dinámica de alternativas en el momento del bloqueo — esto no tiene equivalente directo en RBAC. Harnessing Embodied Agents (2604.07833) formaliza esto como "capability admission" en tiempo de ejecución.

**Novedad relativa:** MEDIA — la delegación dinámica en tiempo de ejecución no tiene equivalente exacto en RBAC clásico. [INFERRED]

---

### EQ-N04 — SAGR-explore ≡ MCTS (Monte Carlo Tree Search) con oracle de policy

**Equivalente:** MCTS expande ramas del árbol de búsqueda de manera guiada por simulaciones. Con un oracle que evalúa si un nodo es "seguro," MCTS puede restringir la exploración a nodos válidos.

**Equivalente en SAGR:** SAGR-explore con el componente de governance es equivalent a MCTS con oracle de policy. La diferencia: las acciones en SAGR son tool calls de lenguaje natural con side effects reales (no simulaciones reversibles).

**Implicación clave:** MCTS funciona porque las simulaciones son baratas y reversibles. En SAGR, cada rama de exploración puede tener side effects irreversibles — esto hace que SAGR-explore sea fundamentalmente más costoso y riesgoso que MCTS. El Irreversibility Budget (2609.00275) aborda exactamente este límite.

**Novedad relativa:** ALTA en la dimensión de irreversibilidad. [INFERRED]

---

### EQ-N05 — SAGR-decide ≡ Expected Value Calculation en decisiones bajo incertidumbre

**Equivalente:** Teoría de decisión bayesiana: decidir continuar vs parar basándose en E[V_continuar] vs E[V_parar]. BAGEN (2606.00198) propone exactamente esto para agentes: estimar el budget esperado para completar la tarea desde el estado actual.

**Equivalente en SAGR:** La decisión recovery vs restart es un cálculo de valor esperado: E[coste_recovery × P(recovery_éxito)] vs E[coste_restart]. BAGEN proporciona la base para estimar P(recovery_éxito) y el coste esperado.

**Novedad relativa:** BAJA en el patrón de decisión; MEDIA en la aplicación a agentes LLM con contexto semántico. [DOCUMENTED]

---

### EQ-N06 — SAGR (sistema completo) ≡ Supervisor Tree de Erlang/OTP + Policy Guard

**Equivalente compuesto:** Erlang supervisors gestionan procesos hijos con estrategias one_for_one/one_for_all/rest_for_one + escalación hacia supervisors de nivel superior. El sistema de policy guard de ACS (2026) añade allow/deny/modify en checkpoints.

**Equivalente en SAGR:** SAGR es equivalente a un supervisor tree de Erlang donde:
- El supervisor monitorea la "salud" semántica del agente (SAGR-detect)
- Al detectar fallo, clasifica (SAGR-classify) → one_for_one (recovery local) o rest_for_one (restart con contexto)
- Antes de reiniciar, verifica con el policy guard que la estrategia de recovery está autorizada (SAGR-govern)
- El audit log registra cada decisión del supervisor (SAGR-verify)

**Novedad relativa:** La composición es conocida en sistemas distribuidos. La novedad de SAGR está en (1) aplicarlo a trayectorias semánticas de agentes LLM y (2) el policy guard sobre las estrategias de recovery — no sobre acciones externas. [INFERRED]

---

## 3. Equivalencias que NO existen (gaps confirmados)

| Componente SAGR | Por qué no tiene equivalente exacto |
|---|---|
| Clasificación HARD_STOP vs RECOVERABLE_STOP sobre semántica de lenguaje | Los clasificadores de policy existentes operan sobre tipos de acciones (tool calls, API endpoints), no sobre semanticidad de intención |
| Generación automática de alternativas policy-compliant | RBAC/ABAC pueden decir "this is denied"; no pueden generar "aquí hay otra forma de lograr tu objetivo sin violar la política" |
| Verificación de que la alternativa no es un bypass | No existe protocolo formal en la literatura encontrada |
| Recovery budget separado del budget de ejecución | Los presupuestos existentes son de ejecución completa; BAGEN e Irreversibility Budget se aproximan pero no lo definen así |
