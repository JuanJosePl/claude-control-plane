# 34 — Auditoría Adversarial Final

**Fecha:** 2026-09-21
**Auditor:** Claude Sonnet 4.6 (meta-auditoría)
**Conclusión auditada:** "SAGR — reformulado como governance de la continuación — es una composición no implementada de primitivas conocidas con un bloqueante técnico real en generate_alternative policy-constrained para agentes de tasks abiertos, y un bloqueante operacional en la frecuencia desconocida de stalls en producción."

---

## Perspectiva 1: Investigador académico

**Argumento destructor:**
OSGuard (2606.15034) + Recoverability (2609.13672) + PolicyGuide (2608.19861) ya resuelven juntos lo que SAGR propone. PolicyGuide compila políticas en workflow graphs y guía hacia rutas compliant. Recoverability formaliza HARD STOP vs RECOVERABLE STOP. OSGuard implementa retry con feedback. La composición ya existe.

**Contraargumento:**
PolicyGuide opera sobre workflow graphs pre-compilados de dominios estructurados (aerolíneas, retail, telecomunicaciones). Los agentes de coding/investigación/razonamiento operan sobre espacios de acción no estructurados donde no existe un workflow graph compilable. Recoverability formaliza el framework pero no implementa generate_alternative. OSGuard limita a 2 reintentos sin generación real de alternativas nuevas. La composición existe para workflows; no existe para agentes de tasks abiertos.

**Veredicto:** DEBILITADA. La crítica señala un problema real: la distinción structured/open-ended debe articularse más claramente. La conclusión sobrevive con esta limitación explícita.

---

## Perspectiva 2: Ingeniero de sistemas distribuidos

**Argumento destructor:**
Saga + Temporal + compensating transactions resuelve el caso. Cuando una acción falla (bloqueada por política), la saga ejecuta la compensating transaction. Temporal persiste el estado. El resultado es equivalente a SAGR con tecnología probada en producción.

**Contraargumento:**
Saga + Temporal resuelven la compensación de efectos ya ocurridos. SAGR resuelve la generación de una acción alternativa que logre el objetivo original sin haber ejecutado la acción bloqueada. Son problemas distintos en orden temporal: Saga actúa después del intento; SAGR actúa antes de intentar la alternativa incorrecta. Temporal explícitamente documenta que su replay re-ejecuta LLM calls con posibles resultados distintos — no garantiza equivalencia semántica. Ningún documento de Temporal describe generate_alternative bajo política.

**Veredicto:** DESTRUIDA. El argumento confunde compensación post-facto con governance pre-alternativa.

---

## Perspectiva 3: Ingeniero de reliability

**Argumento destructor:**
Budget cap + restart es suficiente y más simple. Si un agente gasta más de X tokens sin progreso, reiniciarlo es más confiable que intentar recovery. La recuperación añade complejidad y puede empeorar el estado.

**Contraargumento:**
Budget cap + restart es correcto para stalls por loop o degradación de contexto. Es insuficiente para STALL_POLICY donde hay una alternativa viable: reiniciar desde cero pierde todo el trabajo de contexto, evidencia y trayectoria acumulados. El costo de restart en una sesión de agente de largo horizonte puede ser prohibitivo. La investigación de recovery (RIR, Recoverability, AgentRewind) existe precisamente porque el problema de restart-vs-recover tiene un caso económico claro cuando la trayectoria es valiosa. Sin embargo, el ingeniero de reliability tiene razón en que muchos stalls no son STALL_POLICY y para ellos restart es suficiente — SAGR solo vale para el subconjunto policy-induced con alternativa viable.

**Veredicto:** DEBILITADA para el caso general. Fortalecida para el caso específico de STALL_POLICY con trayectoria valiosa. La conclusión debe articular el scope más claramente.

---

## Perspectiva 4: Ingeniero de seguridad

**Argumento destructor:**
El recovery puede convertirse en un vector de bypass. Si SAGR genera una alternativa A' que logra el mismo efecto que la acción bloqueada A_blocked, el sistema de seguridad ha sido circunvalado. No existe ningún mecanismo de non_bypass_verify implementado. Por tanto, SAGR introduce un riesgo de seguridad nuevo que no existía antes. No construir SAGR es más seguro que construirlo mal.

**Contraargumento:**
El argumento es correcto y es el bloqueante de seguridad más importante identificado. La investigación lo registra como bloqueante real (J-03). La respuesta no es "SAGR es seguro" sino: (1) la governance de continuación existe en una forma u otra — si SAGR no la implementa, el agente la implementará ad hoc sin auditoría; (2) un SAGR explícito con non_bypass_verify incompleto es más auditable que la alternativa implícita; (3) la solución requiere que non_bypass_verify sea condición necesaria antes del despliegue, no una feature opcional.

**Veredicto:** FORTALECIDA en la dimensión del riesgo. El argumento destructor es el más sólido de los 8 y debe permanecer como bloqueante explícito. La conclusión no puede declararse lista para implementación sin non_bypass_verify.

---

## Perspectiva 5: Arquitecto de workflows

**Argumento destructor:**
LangGraph + checkpoints + guards + conditional edges cubre el caso. Se puede modelar STALL_POLICY como un conditional edge que redirige el agente a un subgrafo de recovery. La governance de continuación es simplemente un grafo bien diseñado.

**Contraargumento:**
LangGraph permite modelar recovery explícito SI el diseñador del workflow conoce de antemano los puntos de fallo y las alternativas posibles. Para agentes de tasks abiertos esto no es posible: el espacio de acciones es indefinido y las alternativas no son enumerables a priori. LangGraph no tiene un mecanismo de generate_alternative en runtime para acciones no previstas en el diseño del grafo. Los checkpoints de LangGraph no incluyen policy-aware verification de las alternativas. El argumento es válido para workflows estructurados; no es válido para agentes de tasks abiertos.

**Veredicto:** DESTRUIDA para el mismo dominio que PolicyGuide. Sobrevive para agentes open-ended.

---

## Perspectiva 6: Investigador de planning

**Argumento destructor:**
MCTS + dead-end detection + constraint propagation hace lo mismo. Planning automático bajo restricciones es un campo maduro. Un agente puede modelar STALL_POLICY como un dead-end y usar MCTS para explorar alternativas. El problema ya está resuelto en planning.

**Contraargumento:**
Planning automático clásico requiere: (1) un modelo del mundo formal y completo, (2) espacio de acciones finito y enumerado, (3) función de costo bien definida. Los agentes LLM de tasks abiertos tienen un modelo del mundo implícito en el LLM, espacios de acción casi ilimitados, y funciones de costo no formalizadas. La transferencia de MCTS a agentes LLM es un área de investigación activa (varios papers de sept-2026 la exploran) pero no produce un solve directo. Además, el invariante de seguridad (A' ≠ bypass de A_blocked) no existe en planning clásico donde no hay un policy engine.

**Veredicto:** DEBILITADA. El argumento señala una dirección de investigación válida. "Recovery as search" es una formulación prometedora pero no un solve completo para el caso específico de policy-constrained recovery con non_bypass_verify.

---

## Perspectiva 7: Proveedor de infraestructura

**Argumento destructor:**
Anthropic puede añadir governance de continuación como feature de Claude Code o la API de Agents en 6–12 meses. El retorno de inversión de SAGR como proyecto independiente desaparece si el proveedor absorbe la feature.

**Contraargumento:**
El juicio J-04 (de la segunda pasada) argumenta un conflicto de interés estructural: el proveedor no debería razonar alrededor de las políticas de autorización del cliente porque el proveedor no conoce esas políticas ni tiene autoridad para interpretarlas. La governance de continuación bajo políticas del cliente es fundamentalmente una función del operador, no del proveedor. Sin embargo, el argumento de absorción es válido para el componente de detección de stalls (Anthropic puede añadir loop detection fácilmente). La parte genuinamente no absorbible es la que involucra las políticas específicas del operador. Esto limita SAGR a una implementación del operador, no a un producto vendido al proveedor.

**Veredicto:** DEBILITADA para el componente de detección. SOBREVIVE para el componente de governance bajo política del operador.

---

## Perspectiva 8: Escéptico comercial

**Argumento destructor:**
No hay ningún buyer identificado con presupuesto real. La investigación no encontró WTP, no hay entrevistas, no hay piloto, no hay contrato. Sin buyer, SAGR es investigación básica. Y para el CCP específicamente, el owner es un solo usuario — no hay escala.

**Contraargumento:**
El argumento es correcto para el caso de SAGR como producto comercial independiente. Para el caso de SAGR como herramienta interna del CCP, la pregunta de buyer no aplica — el owner es tanto el desarrollador como el único usuario. La decisión es de ROI personal: ¿vale la pena implementar SAGR para mejorar mi propio workflow? Esa decisión depende de H-01 (frecuencia de stalls). Para el caso comercial, el escéptico tiene razón: sin evidencia de buyer, SAGR no tiene justificación de producto.

**Veredicto:** FORTALECIDA para el caso comercial (no hay producto). SOBREVIVE para el caso de herramienta interna, sujeto a H-01.

---

## Resumen de veredictos

| Perspectiva | Veredicto | Implicación |
|-------------|-----------|-------------|
| Investigador académico | DEBILITADA | Aclarar structured vs open-ended agent domain |
| Ingeniero distribuido | DESTRUIDA | Saga/Temporal no es el mismo problema |
| Ingeniero de reliability | DEBILITADA | SAGR scope = STALL_POLICY con trayectoria valiosa; no el caso general |
| Ingeniero de seguridad | FORTALECIDA (riesgo) | non_bypass_verify es condición necesaria, no opcional |
| Arquitecto de workflows | DESTRUIDA (para workflows) | Sobrevive para agentes open-ended |
| Investigador de planning | DEBILITADA | "Recovery as search" es válido pero incompleto |
| Proveedor de infraestructura | DEBILITADA (detección) | Governance bajo política del operador no absorbible |
| Escéptico comercial | FORTALECIDA (sin buyer) | SAGR = herramienta interna, no producto, sujeto a H-01 |

**Conclusión de la auditoría adversarial:** La conclusión central sobrevive, pero con scope más estrecho de lo articulado originalmente. Los refinamientos obligatorios son: (1) limitar explícitamente a agentes open-ended; (2) non_bypass_verify como condición necesaria; (3) diferenciar caso herramienta interna vs producto.
