# 04 — Huecos de investigación

**Fecha:** 2026-09-21
**Auditor:** Claude Sonnet 4.6 (segunda pasada)
**Alcance:** documentar qué preguntas no fueron respondidas por GPT ni por esta segunda pasada, y clasificarlas por tipo de evidencia requerida.

---

## 1. Clasificación de huecos

Los huecos se clasifican por tipo de evidencia requerida para cerrarlos:

- **EXP:** requiere experimento o implementación.
- **INTER:** requiere entrevistas con usuarios/compradores.
- **DESK:** puede cerrarse con más búsqueda documental.
- **FORMAL:** requiere formalización matemática/lógica.
- **TIEMPO:** la evidencia no existe aún; se cierra con el tiempo.

---

## 2. Huecos de alta prioridad

### H-01 — Frecuencia real de stalls policy-constrained [EXP + INTER]

**Pregunta:** ¿Con qué frecuencia un agente en producción llega a un estado donde una acción es bloqueada por política pero existe una alternativa autorizada y semánticamente equivalente?

**Por qué importa:** Si la frecuencia es baja (<1% de ejecuciones), el caso de negocio para SAGR colapsa independientemente de la viabilidad técnica.

**Lo que existe:** NOTAS_AUDITORIA_DOSSIER §9 dice "frecuencia real no medida." Las métricas de ACP (1M+ policy decisions) demuestran que el bloqueo ocurre, pero no desglosan qué fracción es potencialmente recuperable.

**Lo que falta:** (1) instrumentar un agente real con logging granular de policy denials, (2) clasificar manualmente una muestra de denials como HARD_STOP vs potencialmente RECOVERABLE_STOP, (3) medir la tasa. Sin esto, el problema puede ser de alta frecuencia o de frecuencia despreciable.

**Estado:** UNKNOWN. No cerrable sin experimento. [HYPOTHESIS]

---

### H-02 — Viabilidad del clasificador RECOVERABLE vs HARD_STOP [EXP + FORMAL]

**Pregunta:** ¿Puede un modelo de lenguaje o un clasificador determinista distinguir de forma confiable si un policy block es potencialmente recuperable con alternativas autorizadas?

**Por qué importa:** Si no es posible distinguirlos con suficiente precisión, SAGR generaría demasiados falsos positivos (intentos de recovery cuando debería parar) o falsos negativos (parar cuando hay recovery viable).

**Lo que existe:** OSGuard (2606.15034) clasifica acciones como allowed/unrelated/unsafe — pero para safety, no para recoverability. Recoverability (2609.13672) propone el contrato grant/withhold pero no reporta precisión del clasificador.

**Lo que falta:** Un benchmark específico de "¿este policy denial es recuperable?" con ground truth y métricas de precisión/recall.

**Estado:** UNKNOWN. [HYPOTHESIS]

---

### H-03 — Verificación de que la alternativa no es un bypass [EXP + FORMAL]

**Pregunta:** ¿Cómo se verifica formalmente que la alternativa generada por SAGR no es un bypass asistido de la política original?

**Por qué importa:** Este es el riesgo de seguridad más importante de SAGR. Un sistema que "ayuda al agente a encontrar otro camino" puede ser exactamente un bypass. Los revisores de seguridad rechazarán un sistema que no tenga una respuesta a esta pregunta.

**Lo que existe:** NOTAS_CONTROL_SEGURIDAD §5 identifica el riesgo. NOTAS_COMERCIAL_ECONOMIA §6 dice "el default correcto para incertidumbre es HARD_STOP, no fail forward." Pero no existe un criterio formal de "diferencia semántica suficiente para no ser bypass."

**Lo que falta:** Una definición formal de "alternativa no equivalente a bypass" + un protocolo de verificación que un evaluador de seguridad pueda aplicar.

**Estado:** UNKNOWN. Requiere trabajo de formalización. [HYPOTHESIS]

---

### H-04 — WTP y segmentación de comprador [INTER]

**Pregunta:** ¿Quién pagaría por SAGR, cuánto y bajo qué condiciones?

**Por qué importa:** Sin buyer y WTP no hay negocio, independientemente de la viabilidad técnica.

**Lo que existe:** NOTAS_COMERCIAL_ECONOMIA §9 tiene el mapa de compradores hipotéticos y el análisis de presupuestos existentes. Concluye: WTP no demostrado.

**Lo que falta:** 5-10 entrevistas con Platform Engineers, DevEx leads o SREs de organizaciones con agentes en producción. Las preguntas clave: (1) ¿Han tenido stalls policy-constrained? (2) ¿Cuánto les costó resolverlos manualmente? (3) ¿Estarían dispuestos a pagar por automatizar ese recovery? (4) ¿Bajo qué categoría presupuestaria? (5) ¿Confiarían en que el sistema no genera bypasses?

**Estado:** UNKNOWN. No cerrable sin entrevistas. [HYPOTHESIS]

---

### H-05 — Novedad real respecto a existing governance runtimes [DESK]

**Pregunta:** ¿Qué hay en "Harnessing Embodied Agents: Runtime Governance for Policy-Constrained Execution" (arXiv:2604.07833) que se solape con SAGR?

**Por qué importa:** Si este paper (no incluido por GPT) ya formaliza la gobernanza de ejecución policy-constrained, la novedad de SAGR en la literatura podría ser menor de lo estimado.

**Lo que existe:** La búsqueda web retornó este paper como relevante. No se descargó ni analizó en detalle.

**Lo que falta:** Leer el paper completo y comparar su arquitectura con los 8 jobs de SAGR.

**Estado:** INFERRED. Cerrable con búsqueda documental adicional. [INFERRED]

---

## 3. Huecos de prioridad media

### H-06 — Modelo de coste de recovery vs restart [FORMAL]

**Pregunta:** ¿En qué condiciones es recovery más barato que restart?

**Lo que existe:** NOTAS_COMERCIAL_ECONOMIA §7 lista los casos pero no desarrolla el modelo de coste. BAGEN (2606.00198) estima budget restante, pero no compara recovery vs restart.

**Lo que falta:** Un modelo simple de coste esperado: C_recovery = f(estado_checkpointado, complejidad_alternativa, riesgo_bypass) vs C_restart = f(tokens_gastados, tiempo_transcurrido, completeness_partial). Con valores hipotéticos se puede estimar cuándo SAGR tiene ROI.

**Estado:** INFERRED. Cerrable con análisis formal. [INFERRED]

---

### H-07 — Integración con sistemas de incident management [DESK]

**Pregunta:** ¿Puede SAGR integrar su evidencia de stalls con PagerDuty/Rootly/Datadog para que los postmortems generen automáticamente nuevas policies?

**Lo que existe:** NOTAS_COMERCIAL_ECONOMIA §8 describe el ciclo incident→RCA→postmortem. Sentry Seer, Datadog Bits y Rootly ya generan PRs de fixes. Pero ninguno conecta explícitamente con policies de agentes.

**Lo que falta:** Verificar si algún producto tiene una API para "convertir incidente a nueva regla de agente." GitHub AI Controls tiene `actor_is_agent` en audit logs pero no en dirección de actualizar policies.

**Estado:** INFERRED. Cerrable con búsqueda. [INFERRED]

---

### H-08 — Saturación de la búsqueda [DESK]

**Pregunta:** ¿Se han explorado todos los dominios relevantes o hay áreas no cubiertas?

**Lo que existe:** GPT declaró >25 búsquedas. Esta segunda pasada añadió 10 más. Los dominios cubiertos son extensos.

**Áreas potencialmente no cubiertas:**
- Chaos engineering y self-healing en cloud (Kubernetes Operators, Chaos Monkey)
- Sistemas de corrección automática en compiladores/IDEs (análogo a SAGR en un dominio distinto)
- Recovery en sistemas de bases de datos distribuidas con políticas de acceso (RBAC enforcement during transaction recovery)

**Estado:** INFERRED. Hay dominios análogos no explorados; se marcan como HYPOTHESIS de cobertura.

---

## 4. Huecos que NO requieren más investigación

Estos huecos se consideran cerrados con la evidencia actual:

| Hueco | Por qué está cerrado |
|---|---|
| ¿Existen primitivas de detección de loop? | Sí: circuit breakers, max_turns, ReflexGrad, RIR documentados |
| ¿Existe durable execution comercial? | Sí: Temporal, DBOS, Restate, AWS, Azure — documentados y verificados |
| ¿La recovery semántica existe como producto? | No encontrado en búsqueda primaria 2026-09-21 — límite de esta investigación |
| ¿El control-induced stall es categoría canónica? | No — verificado por búsqueda directa 2026-09-21 |
| ¿El WTP de SAGR está demostrado? | No — no encontrado en evidencia pública |

---

## 5. Veredicto de cierre de investigación

La investigación puede declararse **satisfactoriamente saturada** respecto a preguntas documentables (§H cerrados), pero permanece **abierta en los huecos que requieren experimento o entrevistas** (H-01, H-02, H-03, H-04).

La investigación no puede cerrar H-01 a H-04 con documentación pública. Estos son los huecos que separan SAGR como hipótesis de investigación de SAGR como proyecto justificado de construcción.

**Regla de decisión resultante:** Si H-01 (frecuencia) muestra <1% de ejecuciones con stalls recuperables en producción, SAGR no justifica inversión como producto independiente. Si H-01 muestra >5%, los huecos H-02 y H-03 se vuelven blocking para implementación. Si H-04 (WTP) muestra disposición a pagar, los huecos H-02 y H-03 se convierten en el trabajo técnico principal.
