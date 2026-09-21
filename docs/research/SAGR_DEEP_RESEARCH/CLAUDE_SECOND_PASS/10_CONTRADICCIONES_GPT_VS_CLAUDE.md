# 10 — Contradicciones GPT vs Claude

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Alcance:** identificar dónde el análisis de GPT-5.6 Luna y el análisis independiente de esta segunda pasada divergen.

---

## 1. Método de identificación

Para cada área de divergencia se documenta:
- La afirmación de GPT
- La posición de esta segunda pasada
- La evidencia que las distingue
- El veredicto de resolución (quién tiene razón o si hay empate epistémico)

---

## 2. Divergencias identificadas

### DIV-01 — Completitud del espacio de búsqueda de GPT

**GPT dice:** La investigación cubrió los dominios relevantes con >25 búsquedas. Los huecos son de síntesis, no de cobertura.

**Esta segunda pasada dice:** Hay 4 papers relevantes no documentados (ReflectiChain, 2604.07833, Irreversibility Budget, TRACES) y un estándar de industria no documentado (ACS mayo 2026). Al menos uno de ellos (2604.07833 — "Harnessing Embodied Agents") es directamente relevante para la pregunta central de SAGR.

**Resolución:** Esta segunda pasada tiene razón en señalar omisiones específicas. Sin embargo, la conclusión central de GPT ("policy-constrained recovery no existe como producto") no cambia con los hallazgos nuevos — 2604.07833 es investigación académica, no producto. La cobertura de GPT era suficiente para la conclusión, pero no exhaustiva para el estado del arte.

**Veredicto:** EMPATE EPISTÉMICO — la conclusión de GPT es correcta; la cobertura era incompleta en papers. [OBSERVED]

---

### DIV-02 — Severidad del riesgo de bypass en SAGR

**GPT dice:** "El default correcto para incertidumbre es HARD_STOP, no fail forward" (NOTAS_COMERCIAL_ECONOMIA §6). Tono: precaución, no bloqueo.

**Esta segunda pasada dice (NH-02):** La verificación de no-bypass puede ser no resoluble en el caso general, lo que haría SAGR inaplicable en contextos de alta seguridad. Tono: potencialmente bloqueante.

**Resolución:** GPT fue más cauteloso pero no llegó al límite de decir "puede ser no resoluble." Esta segunda pasada es más pesimista. La diferencia de énfasis es real: GPT prioriza la precaución operativa; Claude prioriza el problema teórico de verificación.

**Veredicto:** DIVERGENCIA REAL. La posición de esta segunda pasada es más conservadora y está respaldada por la ausencia de cualquier protocolo de non-bypass verification en la literatura. La precaución de GPT es correcta pero puede ser insuficiente para contextos de alta seguridad. [INFERRED]

---

### DIV-03 — Viabilidad de SAGR como feature interna del CCP

**GPT no abordó** directamente la pregunta de si SAGR tiene sentido como feature interna del CCP antes de ser un producto.

**Esta segunda pasada dice (NH-05):** Implementar SAGR internamente en el CCP tiene ROI más claro que construirlo como producto. NOTAS_RECONSTRUCCION_REPOSITORIO §4 confirma que el CCP ya tiene 6 de los ~12 componentes necesarios.

**Resolución:** GPT se concentró en la pregunta de producto/mercado (lo que pedía el dossier original). Esta segunda pasada abre la pregunta pragmática de uso interno. No hay contradicción factual — solo diferencia de scope.

**Veredicto:** DIFERENCIA DE SCOPE, no contradicción. Ambas posiciones son compatibles. [INFERRED]

---

### DIV-04 — Novedad de SAGR

**GPT dice (NOTAS_SISTEMAS_CLASICOS):** "SAGR no introduce nuevas primitivas en sentido amplio."

**Esta segunda pasada dice (08_NUEVAS_PRIMITIVAS.md):** SAGR tiene dos primitivas con novedad en contexto de agentes LLM: (1) semantic_classify_recovery y (2) generate_policy_compliant_alternative_with_nonbypass_verification.

**Resolución:** No son contradictorias sino de distinto nivel de análisis. GPT dice "en sentido amplio" (el patrón conceptual existe en otros dominios). Esta segunda pasada dice "en el dominio específico de agentes LLM con policy compliance semántico" hay novedad aplicada. Ambas son correctas en su scope.

**Veredicto:** PSEUDO-CONTRADICCIÓN — diferencia de nivel de abstracción. La verdad completa es: SAGR no introduce nuevas primitivas fundamentales, pero sí introduce dos nuevas instancias de primitivas conocidas en un dominio específico donde la implementación es no-trivial. [INFERRED]

---

### DIV-05 — Absorción por proveedores

**GPT dice:** Riesgo de absorción ALTO para partes commodity (checkpoint, retry, observability) y MEDIO/BAJO para la parte de política.

**Esta segunda pasada dice (NH-03):** Los proveedores absorberán governance básica pero NO la generación de alternativas policy-compliant. El conflicto de interés (el proveedor no debería "razonar alrededor" de las políticas del cliente) es una barrera estructural.

**Resolución:** Ambos dicen lo mismo — la parte de política tiene menor riesgo de absorción. Esta segunda pasada añade el mecanismo causal (conflicto de interés), que es un argumento adicional no presente en GPT.

**Veredicto:** ACUERDO SUBSTANCIAL. Esta segunda pasada refuerza y explica la posición de GPT. [INFERRED]

---

## 3. Resumen de divergencias

| DIV | Tipo | Resolución |
|---|---|---|
| DIV-01 | Cobertura de búsqueda | Empate: GPT suficiente para conclusión, incompleto en papers |
| DIV-02 | Severidad del riesgo de bypass | Divergencia real: esta pasada más conservadora y respaldada |
| DIV-03 | Scope (interno vs producto) | Diferencia de scope, compatible |
| DIV-04 | Novedad de SAGR | Pseudo-contradicción: diferente nivel de abstracción |
| DIV-05 | Absorción por proveedores | Acuerdo substancial; esta pasada añade mecanismo causal |

**Conclusión:** No hay contradicciones factuales irreconciliables entre el análisis de GPT y el de esta segunda pasada. Las divergencias son de énfasis, scope y nivel de abstracción. La conclusión central (SAGR es plausible técnicamente, no demostrado comercialmente, con riesgos de seguridad que requieren protocolo explícito) es compartida.
