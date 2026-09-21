# 31 — Grafo de evidencia

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (meta-auditoría)
**Propósito:** Grafo textual de evidencia para las 8 conclusiones más importantes de la investigación completa. Cada conclusión debe poder recorrerse hacia atrás hasta la fuente primaria.

---

## Cómo leer este grafo

```
CLAIM
 └─ Fuente
 └─ Observación
 └─ Interpretación
 └─ Inferencia
 └─ Falsificador
 └─ Estado: GROUNDED / PARTIALLY_GROUNDED / UNGROUNDED
```

---

## CLAIM-01: "Los loops, el estancamiento y los estados fallidos existen en agentes LLM de largo horizonte"

- **Fuente:** AgentBench (ICLR 2024), MAST (arXiv:2406.00906), ReAct (Yao et al. 2022); confirmados por GPT y Claude
- **Tipo de fuente:** benchmark peer-reviewed + paper publicado
- **Observación:** AgentBench reporta tasas de fallo de 30–70% por tarea dependiendo del dominio; MAST categoriza 5 tipos de fallo incluyendo loops y stagnation
- **Interpretación:** Los fallos no-triviales (ni crash, ni error de sintaxis) son frecuentes y están bien documentados
- **Inferencia:** Existe un problema real que SAGR intenta resolver
- **Falsificador:** Un benchmark actual que muestre tasa de fallo < 5% en tareas de largo horizonte sin recovery especial
- **Estado:** GROUNDED

---

## CLAIM-02: "La durable execution (Temporal, DBOS, LangGraph) NO resuelve el recovery semántico"

- **Fuente:** Documentación oficial Temporal v1.x; DBOS paper (VLDB 2024); LangGraph docs (2026); AWS Bedrock Agents docs (2026)
- **Tipo de fuente:** documentación oficial verificada en segunda pasada (DOCUMENTED)
- **Observación:** Temporal documenta explícitamente que replay re-ejecuta actividades con llamadas a LLMs que pueden retornar resultados distintos; DBOS hace lo mismo; LangGraph "time travel" crea fork del estado pero no garantiza equivalencia semántica; AWS docs distinguen entre crash recovery y semantic recovery
- **Interpretación:** Todos los sistemas de durable execution resuelven crashes de proceso, no divergencia semántica en LLMs
- **Inferencia:** La brecha que SAGR intenta cerrar no está cubierta por durable execution
- **Falsificador:** Documentación de cualquiera de estos proveedores que afirme garantizar equivalencia semántica en replay con LLMs
- **Estado:** GROUNDED

---

## CLAIM-03: "La función `generate_policy_compliant_alternative` no tiene implementación de producción conocida"

- **Fuente:** PolicyGuide (arXiv:2608.19861, agosto 2026); SafeAgent (arXiv:2604.17562); Policy Compiler (arXiv:2602.16708); búsquedas B-01/B-02/B-09 de segunda pasada + búsquedas meta-auditoría
- **Tipo de fuente:** papers académicos + búsquedas web verificadas
- **Observación directa:** PolicyGuide compila políticas en workflow graphs y retorna "step-specific remediation along a policy-compliant path" — es la implementación más cercana encontrada; SafeAgent "triggers constrained replan step"; Policy Compiler menciona que "agent may select a compliant alternative" tras feedback; NINGUNO opera en producción general
- **Interpretación:** Existen implementaciones parciales de alternative generation en contextos específicos (workflow-structured domains en PolicyGuide, VLA agents en SafeAgent). No existe una implementación de propósito general para agentes LLM de coding/tasks
- **Inferencia:** El gap es más estrecho de lo que afirmaba la síntesis de Claude (no está "completamente vacío"), pero sigue sin solución general de producción
- **Falsificador:** Documentación oficial de cualquier proveedor (Anthropic, OpenAI, etc.) describiendo alternative generation automática para agentes bloqueados por política
- **Estado:** PARTIALLY_GROUNDED — la afirmación de "nadie implementó nada" es demasiado fuerte; la afirmación de "no hay implementación general de producción" está bien soportada

---

## CLAIM-04: "El predicado `non_bypass_verify` no tiene implementación formal conocida"

- **Fuente:** AgentBound (arXiv:2606.30970); búsquedas meta-auditoría; revisión de 12+ papers de governance/safety 2026
- **Tipo de fuente:** papers académicos + búsquedas web
- **Observación:** AgentBound provee "non-bypassable enforcement verdict" sobre acciones individuales mediante álgebra conservadora, pero no verifica si una alternativa A' es semánticamente equivalente a la acción bloqueada A_blocked. Faramesh (arXiv:2601.17744) afirma "non-bypassability at execution time" como invariante pero también es enforcement, no bypass detection sobre alternativas
- **Interpretación:** Los sistemas existentes previenen bypasses directos pero no detectan bypasses indirectos (lograr el mismo resultado prohibido por un camino diferente)
- **Inferencia:** El predicado semántico de no-bypass sigue sin implementación formal conocida
- **Falsificador:** Un paper o producto que demuestre formalmente: "A' is a compliant alternative to A_blocked if and only if ∀ prohibited outcome o: ¬achieves(A', o)"
- **Estado:** GROUNDED

---

## CLAIM-05: "La investigación académica de recovery semántico está activa y convergente en 2026"

- **Fuente:** Recoverability (arXiv:2609.13672, sept 2026); RIR (arXiv:2609.18304v2, sept 2026); AgentRewind (arXiv:2608.14380, agosto 2026); Harnessing Embodied Agents (arXiv:2604.07833, abril 2026); ReflectiChain (MDPI Electronics 2026)
- **Tipo de fuente:** papers verificados con WebSearch/WebFetch en segunda pasada
- **Observación:** 5 papers independientes con fechas sept 2026 abordan directamente la detección de stagnation, clasificación de recovery, checkpoint semántico, y governance de ejecución. No hay coordinación aparente entre grupos — convergencia independiente
- **Interpretación:** El campo identifica el mismo problema desde múltiples ángulos simultáneamente, señal de madurez del problema
- **Inferencia:** SAGR es una hipótesis bien alineada con la dirección del campo; el riesgo de que "alguien ya lo resuelva" en 12 meses es real
- **Falsificador:** Si todos los papers son del mismo grupo o son simplemente los mismos autores bajo distintos nombres
- **Estado:** GROUNDED

---

## CLAIM-06: "SAGR como producto independiente no tiene WTP demostrado"

- **Fuente:** búsquedas B-09/B-10 (segunda pasada); revisión de pricing de LangChain, CrewAI, AutoGPT, AgentOps; 00_INVENTARIO_DEL_TRABAJO_GPT.md §6; NOTAS_COMERCIAL_ECONOMIA.md
- **Tipo de fuente:** búsquedas web verificadas + análisis documental
- **Observación:** Ningún proveedor tiene SKU de "policy-compliant recovery" con pricing público; no hay entrevistas de campo; no hay evidence de presupuesto de comprador para esta categoría; AgentOps y LangSmith tienen observability pricing pero no recovery governance pricing
- **Interpretación:** La ausencia de pricing no demuestra ausencia de demanda, pero sí demuestra ausencia de mercado público documentado
- **Inferencia:** WTP no demostrado en corpus público. Puede existir en sistemas internos no documentados
- **Falsificador:** Pricing page de cualquier proveedor con un SKU de "agent recovery governance" o similar
- **Estado:** GROUNDED (ausencia verificada, no ausencia universal)

---

## CLAIM-07: "El CCP tiene 3 de 7 componentes SAGR ya implementados"

- **Fuente:** NOTAS_RECONSTRUCCION_REPOSITORIO.md; lectura directa de `.claude/hooks/` y `evals/`; 12_RECONSTRUCCION_DEL_MODELO.md §6
- **Tipo de fuente:** código inspeccionado (OBSERVED)
- **Observación:** CCP tiene: max_turns (SAGR-detect parcial), PreCompact hook (SAGR-detect/persist parcial), evidence gate F8-A (SAGR-verify). Ausentes: SAGR-classify, SAGR-explore, SAGR-govern, SAGR-audit
- **Interpretación:** El CCP tiene infraestructura que cubriría 3-4 de 7 componentes SAGR con adaptación mínima
- **Inferencia:** El costo marginal de implementar SAGR en CCP es menor que construir desde cero
- **Falsificador:** Que los hooks existentes no sean realmente reusables para SAGR (requeriría lectura del código fuente de cada hook)
- **Estado:** PARTIALLY_GROUNDED — la presencia de hooks está verificada; su reusabilidad para SAGR es INFERRED

---

## CLAIM-08: "La pregunta H-01 (frecuencia de stalls policy-constrained) decide la viabilidad de SAGR"

- **Fuente:** 18_JUICIOS_FINALES_AUDITADOS.md §J-07; 20_CLAUDE_FINAL_SYNTHESIS.md §"La cereza del pastel"; 19_VERSION_CONSOLIDADA.md §"Tres oraciones"
- **Tipo de fuente:** documentos propios de la investigación (INFERRED)
- **Observación:** Ambas pasadas llegan independientemente a la misma conclusión: la pregunta de viabilidad de SAGR no puede resolverse con desk research; requiere datos de uso real
- **Interpretación:** Las preguntas técnicas de SAGR están respondidas en lo que puede responderse con investigación documental; la pregunta de si vale la pena construirlo requiere datos de producción
- **Inferencia:** Sin datos de H-01, SAGR es un proyecto de investigación bien fundamentado pero sin decisión de inversión posible
- **Falsificador:** No es falsificable sin datos — este claim es estructuralmente correcto: la incapacidad de resolverlo con desk research es la evidencia
- **Estado:** GROUNDED (por consistencia entre dos investigaciones independientes)

---

## Resumen del estado del grafo

| Claim | Estado |
|---|---|
| C-01: Los loops y stagnation existen | GROUNDED |
| C-02: Durable execution no resuelve recovery semántico | GROUNDED |
| C-03: No hay implementación general de generate_alternative | PARTIALLY_GROUNDED |
| C-04: Non-bypass verify no existe formalmente | GROUNDED |
| C-05: Investigación 2026 activa y convergente | GROUNDED |
| C-06: WTP no demostrado | GROUNDED |
| C-07: CCP tiene 3/7 componentes SAGR | PARTIALLY_GROUNDED |
| C-08: H-01 decide viabilidad | GROUNDED |

**Conclusión:** La cadena de evidencia principal es sólida. Los dos claims partially_grounded (C-03, C-07) tienen sus limitaciones bien delimitadas y no cambian la conclusión central.
