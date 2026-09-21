# 11 — Reconstrucción del problema

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Pregunta:** ¿Cuál es el problema real que SAGR intenta resolver, expresado de la forma más precisa posible?

---

## 1. El problema según el dossier original

El dossier define SAGR como un sistema para "detectar estancamiento, loops, degradación de contexto, explosión de coste, stalls inducidos por control; y recuperar mediante exploración acotada, delegación a subagentes, restauración de estado, reconstrucción minimal de contexto, re-verificación."

Esta definición tiene dos problemas:
1. Es una lista de síntomas, no una definición del problema.
2. No establece qué hace SAGR que no pueda hacerse con los mecanismos existentes.

---

## 2. El problema según NOTAS_AUDITORIA_DOSSIER de GPT

GPT reformuló el problema como: "el problema fundamental es la ausencia de un contrato operativo que conecte: (1) estado usable + evidencia de soporte, (2) acción ejecutable, (3) efectos externos ocurridos, (4) límite que fuerce continuar/abstener/escalar/reiniciar."

Esta formulación es más precisa pero sigue siendo incompleta: describe el contrato pero no la pregunta que el contrato debe responder.

---

## 3. Reconstrucción desde primeros principios

### 3.1 La situación observable

Un agente está ejecutando una tarea de largo horizonte. En algún punto t, uno de estos eventos ocurre:
- E1: La siguiente acción planeada A_t es bloqueada por una política de seguridad/autorización.
- E2: Las últimas N acciones no han producido progreso observable hacia el objetivo O.
- E3: El contexto del agente ha crecido tanto que el modelo no puede procesar la historia completa.
- E4: El coste acumulado (tokens, tiempo, dinero) supera un umbral predefinido.
- E5: El agente está ejecutando acciones con side effects irreversibles sobre un estado incorrecto.

### 3.2 La pregunta que el sistema debe responder

Para cada evento Ei, el sistema necesita responder:

**¿Debe continuar? ¿Cómo?**

Más precisamente: Dado el estado S_t, el evento Ei, el objetivo O, las políticas vigentes P, los efectos ya ocurridos X, y el presupuesto restante B, ¿cuál es la acción de governance correcta en {CONTINUE(A'), PAUSE_FOR_APPROVAL, RESTART(checkpoint), ABORT, ESCALATE}?

### 3.3 Por qué los sistemas actuales no responden bien esta pregunta

| Sistema | Qué responde | Qué no responde |
|---|---|---|
| Circuit breaker / max_turns | "Ha ocurrido demasiado" → ABORT | No distingue si hay recovery viable |
| Durable execution (Temporal, DBOS) | "El proceso crasheó" → RESTART desde checkpoint | El checkpoint puede ser semánticamente inválido |
| Observability (LangSmith, Fiddler) | "El agente no está progresando" (métricas) | No decide qué hacer con esa información |
| Guardrails (ACS, OPA, Cedar) | "Esta acción específica está bloqueada" → DENY | No genera alternativas autorizadas |
| Human-in-the-loop | "Un humano puede decidir" → PAUSE_FOR_APPROVAL | Requiere un humano disponible siempre |

La gap es: **ningún sistema existente toma la decisión governance completa de forma autónoma cuando el event está en el espacio entre "continuar trivialmente" y "abortar necesariamente".**

### 3.4 El problema bien formulado

**El problema que SAGR intenta resolver:**

Dado un agente en ejecución que ha llegado a un estado de bloqueo no-trivial (no es un error de runtime, no es un crash, es un estado donde las acciones posibles están todas bloqueadas o son semánticamente inútiles), determinar de forma autónoma y verificable si existe una ruta de recovery que (1) respete todas las políticas vigentes, (2) preserve la intención del objetivo original, (3) no sea un bypass encubierto de las políticas bloqueantes, (4) tenga coste esperado menor que un restart completo, y (5) pueda ejecutarse con los efectos ya ocurridos como inputs, no como problemas.

---

## 4. Decomposición del problema en sub-problemas

El problema bien formulado se descompone en 5 sub-problemas independientes:

| Sub-problema | Nombre corto | Dificultad | Tiene solución parcial |
|---|---|---|---|
| ¿Llegamos a un estado de bloqueo no-trivial? | SP-1: Stall Detection | MEDIA | Sí (ReflexGrad, ReflectiChain, IAL-Scan) |
| ¿Puede haber recovery (RECOVERABLE vs HARD_STOP)? | SP-2: Recovery Classification | ALTA | Parcial (Recoverability 2609.13672) |
| ¿Cuál es la ruta alternativa autorizada y no-bypass? | SP-3: Alternative Generation | MUY ALTA | En investigación (2604.07833), sin producto |
| ¿El coste de recovery vale la pena? | SP-4: Recovery Economics | MEDIA | Parcial (BAGEN, Irreversibility Budget) |
| ¿La alternativa ejecutada produjo el resultado correcto? | SP-5: Recovery Verification | MEDIA | Sí (evals, test suites, evidence gates) |

**SP-3 es el bloqueante.** Sin SP-3 resuelto con suficiente precisión y seguridad, los otros sub-problemas no justifican el sistema.

---

## 5. Lo que el problema NO es

- **No es recovery de crashes.** Para eso existe durable execution.
- **No es observabilidad de agentes.** Para eso existe LangSmith/Fiddler/Datadog.
- **No es autorización de acciones.** Para eso existe OPA/Cedar/ACS.
- **No es retry de errores transitorios.** Para eso existe backoff y retry budgets.
- **No es compactación de contexto.** Para eso existe PreCompact/SessionStore.

El problema es específicamente el espacio donde las acciones posibles están bloqueadas por política y donde existe (hipotéticamente) una alternativa semánticamente equivalente que no viola la política. Este espacio puede ser vacío (HARD_STOP siempre), pequeño (raro), o suficientemente frecuente como para justificar un sistema.

---

## 6. La meta-pregunta que bloquea todo

**¿Con qué frecuencia un agente en producción llega al estado descrito en §3.4?**

Si la frecuencia es baja, el problema no justifica un sistema. Si la frecuencia es alta, SP-3 se convierte en el problema técnico central. Esta pregunta (Hueco H-01 de `04_HUECOS_DE_INVESTIGACION.md`) no puede responderse con documentación pública.

**SAGR es la respuesta correcta al problema correcto — si el problema ocurre suficientemente seguido.** [INFERRED]
