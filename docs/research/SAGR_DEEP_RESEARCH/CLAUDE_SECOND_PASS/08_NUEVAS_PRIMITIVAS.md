# 08 — Nuevas primitivas identificadas

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Pregunta central:** ¿SAGR introduce primitivas genuinamente nuevas, o es composición de primitivas conocidas?

---

## 1. Análisis de novedad primitiva

### Marco de evaluación

Una primitiva es "genuinamente nueva" si cumple tres condiciones:
1. No puede reducirse a composición trivial de primitivas existentes.
2. Tiene propiedades de comportamiento emergentes que la composición no garantiza.
3. Su ausencia crea un gap observable y verificable en la capacidad del sistema.

### Criterio de GPT

NOTAS_SISTEMAS_CLASICOS §"Conclusión" dice: "SAGR no introduce nuevas primitivas en sentido amplio — deadlock detection, watchdogs, backoff, circuit breakers, retry limits, backpressure, savepoints, WAL, MVCC, supervisors, all exist for decades."

Esta segunda pasada revisa este veredicto con los nuevos hallazgos.

---

## 2. Primitivas candidatas y evaluación

### P-CANDIDATE-01 — Clasificación semántica de recoverabilidad

**Definición propuesta:** Dada una historia de ejecución H y un evento de bloqueo E (policy deny, stall, error), determinar si existe al menos una acción A' tal que A' ≠ A (no es la acción bloqueada), A' satisface la política, y el resultado R(A') es semánticamente equivalente al objetivo O. Si existe tal A', clasificar E como RECOVERABLE; si no, clasificar como HARD_STOP.

**¿Es nueva?** Las primitivas de triage y clasificación existen. Los clasificadores de policy (OPA, Cedar) existen. Pero ningún sistema conocido formaliza la función de decisión sobre la semánticidad del objetivo (∃A': A'≠A ∧ policy(A')=allow ∧ semantic_equiv(R(A'), O)).

**Propiedad emergente:** La determinación de equivalencia semántica requiere comprensión de la intención del agente, no solo de la acción concreta. Esto es una propiedad que los clasificadores de policy actuales no tienen.

**Veredicto:** PRIMITIVA NUEVA de alcance estrecho — la función `semantic_classify_recovery(H, E, O)` no existe en sistemas actuales. [INFERRED]

---

### P-CANDIDATE-02 — Alternativa policy-compliant generada dinámicamente

**Definición propuesta:** Dado el objetivo O, la política P y el bloqueo E, generar un plan alternativo A'[] tal que: cada A'_i satisface P(A'_i) = allow, el resultado final es semánticamente equivalente a O, y el plan no es isomórfico a la ruta bloqueada (no es un bypass encubierto).

**¿Es nueva?** La generación de planes existe (planificadores, LLMs). La verificación de constraints de policy existe (OPA, Cedar). Pero la combinación de generación + verificación + anti-bypass check sobre planes semánticos no existe como primitiva en ningún sistema encontrado.

**Propiedad emergente:** Un plan puede ser correcto individualmente en cada acción y ser un bypass de facto en su conjunto. La verificación de no-bypass requiere razonamiento sobre el intent del agente y la intención de la política, no solo sobre los tipos de acciones.

**Veredicto:** PRIMITIVA NUEVA — es la combinación con no-bypass verification que no existe. [INFERRED]

---

### P-CANDIDATE-03 — Recovery budget separado y reutilizable entre runs

**Definición propuesta:** Un presupuesto de recursos (tokens, tiempo, dinero) asignado específicamente para operaciones de recovery, separado del presupuesto de ejecución normal, con la propiedad de que el consumo del recovery budget no afecta la evaluación del run principal.

**¿Es nueva?** Los presupuestos de ejecución existen. BAGEN (2606.00198) propone estimación de budget para completar tareas. Irreversibility Budget (2609.00275) propone contabilidad de irreversibilidad.

**Propiedad emergente:** El recovery budget tiene una propiedad diferente: consume recursos para intentar recuperar el valor de trabajo ya realizado (no para producir nuevo trabajo). La métrica correcta no es "cuánto queda" sino "¿el coste de recovery es menor que el valor recuperado?"

**Veredicto:** PRIMITIVA PARCIALMENTE NUEVA — el concepto de "presupuesto para recuperar valor ya creado" no existe exactamente en sistemas actuales, pero es componible desde BAGEN + Irreversibility Budget + teoría de valor esperado. [INFERRED]

---

### P-CANDIDATE-04 — Evidence-gated recovery action

**Definición propuesta:** Una acción de recovery solo se ejecuta si existe evidencia verificable de que: (1) el checkpoint de estado es válido, (2) los side effects del estado previo están debidamente registrados, y (3) la alternativa propuesta fue evaluada y aprobada por una instancia independiente. Sin evidencia suficiente, la acción por defecto es HARD_STOP.

**¿Es nueva?** La Recoverability (2609.13672) formaliza exactamente esto: "behavioral contract binds the choice to supporting evidence, execution, and independent checks." Esto es la primitiva más cercana al concepto.

**Veredicto:** PRIMITIVA EXISTENTE EN INVESTIGACIÓN — 2609.13672 la formaliza. No existe como primitiva de producto. [DOCUMENTED]

---

## 3. Mapa de primitivas P1-P22 del dossier vs análisis actualizado

El dossier original propone 22 primitivas (P1-P22). Con los nuevos hallazgos:

| Primitiva | Evaluación actualizada |
|---|---|
| P1-P10 (detección, checkpoint, replay, retry) | EXISTENTES — bien documentadas en GPT |
| P11 (side-effect ledger) | EXISTENTE EN ALPHA (AgentRewind, Living AI) |
| P12 (RECOVERABLE/HARD_STOP classifier) | NUEVA en dominio semántico — ver P-CANDIDATE-01 |
| P13 (alternative generation) | NUEVA con anti-bypass constraint — ver P-CANDIDATE-02 |
| P14 (recovery budget) | PARCIALMENTE NUEVA — ver P-CANDIDATE-03 |
| P15 (evidence-gated action) | EXISTENTE EN INVESTIGACIÓN — 2609.13672 |
| P16-P22 (audit, governance, verification) | EXISTENTES en governance frameworks + ACS |

---

## 4. Conclusión sobre novedad de SAGR

**SAGR como sistema completo** no introduce primitivas radicalmente nuevas. Es una composición de 20+ primitivas conocidas.

**SAGR tiene dos primitivas con novedad en contexto de agentes LLM:**
1. La función `semantic_classify_recovery` — clasificar si un bloqueo de policy es recuperable basándose en equivalencia semántica del objetivo.
2. La función `generate_policy_compliant_alternative_with_nonbypass_verification` — generar y verificar alternativas que no sean bypasses encubiertos.

**La novedad es local y aplicada, no fundamental:** equivale a aplicar ideas de planificación con constraints a un nuevo dominio (policy compliance en agentes LLM), con la dificultad adicional de que "equivalencia semántica" y "no-bypass" son propiedades difíciles de verificar formalmente.

**Implicación para el proyecto CCP:** Si el CCP tiene un caso de uso que requiera estas primitivas frecuentemente, vale la pena construirlas. Si los casos son raros (<1% de ejecuciones), la composición ad hoc es suficiente. Ver `04_HUECOS_DE_INVESTIGACION.md` §H-01 para la pregunta de frecuencia que bloquea esta decisión.
