# 19 — Versión consolidada de SAGR

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Propósito:** síntesis de las dos pasadas en una descripción unificada y corrección-aware de SAGR.

---

## 1. Definición consolidada

**SAGR (State-Aware Governed Recovery)** es un conjunto de primitivas de control para agentes LLM de largo horizonte que, ante un estado de bloqueo no-trivial (ni crash de runtime ni error transitorio ni límite de presupuesto simple), determina de forma verificable si existe una ruta de recovery que:

1. Respeta todas las políticas de governance vigentes
2. Preserva la intención del objetivo original
3. No es un bypass encubierto de las políticas bloqueantes
4. Tiene coste esperado menor que un restart completo
5. Genera evidencia auditable de cada decisión

---

## 2. Taxonomía de stalls que SAGR aborda

| Tipo | Síntoma observable | Acción de SAGR |
|---|---|---|
| STALL_SEMANTIC | D(t) > umbral durante N pasos (SED) | Clasifica → si RECOVERABLE, explora alternativas |
| STALL_LOOP | Acción idéntica repetida (misma semántica) | Clasifica → si RECOVERABLE, genera variante |
| STALL_POLICY | Mejor acción bloqueada por policy | Clasifica → genera A' policy-compliant |
| STALL_BUDGET | Budget insuficiente para completar | Calcula C_recovery vs C_restart → decide |
| STALL_CONTEXT | Context window saturado, compactación insuficiente | Restaura checkpoint con contexto reducido |

---

## 3. Componentes del sistema (estado de implementación al 2026-09-21)

| Componente | Función | Estado en literatura | Estado en CCP |
|---|---|---|---|
| SAGR-Detect | Detecta tipo de stall | Investigación activa (ReflectiChain, IAL-Scan, ReflexGrad) | Parcial (max_turns, PreCompact) |
| SAGR-Classify | Clasifica RECOVERABLE/HARD_STOP | Formalizado parcialmente (2609.13672) | Ausente |
| SAGR-Persist | Checkpoint + side effects log | Disponible (Temporal, DBOS, LangGraph, CCP file checkpoint) | Parcial |
| SAGR-Explore | Genera candidatos A' | Investigación (ExTS 2608.23848) | Ausente |
| SAGR-Govern | Policy check + non-bypass verify | Conceptualizado (2604.07833, ACS) | Ausente |
| SAGR-Execute | Ejecuta A' aprobado con monitoreo | Disponible (agentes normales) | Disponible |
| SAGR-Verify | Verifica completion + audit trail | Disponible (evidence gate CCP) | Disponible |

---

## 4. Gap técnico central

**La función `generate_policy_compliant_alternative(S_t, O, P, A_blocked) → A' | NONE` no tiene implementación conocida de producción.**

Los enfoques existentes más cercanos:
- Recoverability (2609.13672): decide si recovery es posible, pero no genera A'
- Harnessing Embodied Agents (2604.07833): formaliza el recovery manager con estrategias predefinidas, no generación dinámica
- ACP: propone una regla al operador humano, no genera A' autónomamente

La función requiere que el sistema entienda el intent semántico de la política bloqueante para proponer una alternativa que no viole ese intent. Esto es un problema de comprensión semántica de políticas, no solo de syntax checking.

---

## 5. Gap de seguridad central

**El predicado `non_bypass_verify(A', A_blocked, P, O) → bool` no tiene implementación formal conocida.**

Sin este predicado, cualquier sistema de SAGR puede ser explotado para facilitar bypasses. La única mitigación disponible es:
- Human approval gate para toda recovery de acciones de alto riesgo
- Restricción de SAGR a acciones de bajo impacto inicialmente
- Red-teaming extensivo de cualquier implementación antes de producción

---

## 6. Mapa de evidencia consolidada

| Afirmación | Evidencia | Nivel |
|---|---|---|
| Loops y stancamiento existen en agentes LLM | AgentBench, MAST, ReAct failures documentados | FACT |
| Recovery de crashes existe | Temporal, DBOS, AWS, Azure — verificados | FACT |
| Detección de SED tiene base formal | ReflectiChain (MDPI 2026) | DOCUMENTED |
| Recovery semántico formal existe en investigación | Recoverability (2609.13672), RIR (2609.18304), 2604.07833 | DOCUMENTED |
| Recovery semántico existe como producto | NO ENCONTRADO | FACT (ausencia verificada) |
| WTP para SAGR | NO DEMOSTRADO | FACT (ausencia verificada) |
| Risk de absorción commodity | ALTO | FACT (AWS, Azure, Anthropic absorbiendo) |
| Risk de absorción policy-aware | MEDIO/BAJO | INFERRED (conflicto de interés + ausencia 2026) |
| Non-bypass verification solucionada | NO | FACT (ausencia verificada) |
| Frecuencia de stalls policy-constrained en producción | DESCONOCIDA | UNKNOWN |

---

## 7. Posición de SAGR en el espacio de hipótesis del dossier

El dossier original propone 10 opciones (A-J). Con ambas pasadas de investigación:

| Opción | Descripción | Veredicto |
|---|---|---|
| A | Ya existe | REFUTADA — no existe como sistema integrado |
| B | Trivialmente componible | REFUTADA — SP-3 no es trivial |
| C | Parcial con comportamiento emergente | CONFIRMADA — composición válida con gaps técnicos |
| D | Formulación incorrecta del problema | REFUTADA — la formulación en §3.4 de archivo 11 es correcta |
| E | Primitivo más profundo encontrado | REFUTADA — no se encontró primitivo más profundo |
| F | Existe técnicamente, sin relevancia económica | PARCIALMENTE CONFIRMADA — plausible técnicamente, economía no demostrada |
| G | Proveedores absorberán | PARCIALMENTE CONFIRMADA — absorben partes commodity; no la parte de policy |
| H | Investigación sólida sin solución de producción | CONFIRMADA — activo en investigación; sin producto en 2026 |
| I | Oportunidad real que requiere experimento | CONFIRMADA — H-01 a H-04 requieren experimento |
| J | Hipótesis no sobrevivió | REFUTADA — la hipótesis técnica sobrevive; la comercial es UNKNOWN |

**Posición final: C + G + H + I — composición viable con gaps, absorción parcial de proveedores, base de investigación sólida, y oportunidad que requiere experimento para verificarse.**

---

## 8. Tres oraciones que resumen la investigación completa

**SAGR como problema:** Los agentes LLM en ejecución larga llegan a estados donde las acciones disponibles están todas bloqueadas por política o son semánticamente inútiles, y los sistemas actuales solo saben parar — no si existe una ruta alternativa válida.

**SAGR como solución:** Un sistema de 7 componentes (detect, classify, persist, explore, govern, execute, verify) puede automatizar la decisión de recovery cuando existe, pero el componente de generación de alternativas policy-compliant con verificación de no-bypass no tiene implementación conocida.

**SAGR como inversión:** La investigación está saturada en lo documental; la única pregunta que decide el futuro del proyecto es con qué frecuencia el owner encuentra stalls policy-constrained en su uso real del CCP — si es frecuente, vale la pena construir; si es raro, no.
