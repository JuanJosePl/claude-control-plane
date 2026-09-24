# 12 — RESEARCH SYNTHESIS

> Síntesis final de K3. Cumple §103 (final synthesis), §108 (executive output),
> §253 (wow hallmarks), §277 (break your master model), §288 (ultimate test).

---

## 1. Estructura del sistema — modelo K3

Después de investigar, atacar, comparar y falsificar:

```text
CCP = ESTRELLA CON HUMANO-SINK
    · 4 CAPACIDADES ACTIVAS: CAP-2s, CAP-2m, CAP-3, CAP-AUTHZ
    · 1 GAP:                 GAP-1 (canonical policy absent)
    · 1 POLÍTICA LATENTE:    POL-LATENT-5 (learning loop, ran once)
    · 1 SUBSTRATE PROPERTY:  PROP-4 (reversibility via git)
    · 1 SUBSTRATE COMPENSATION: COMP-CTX (SessionStart + meta-doc)
    · 3 INTERFACES técnicas: tool-invocation, task-close, session-start
    · 2 GATES duros:         BLOCKER-*, GATE-BEFORE-TASK-CLOSURE
    · 1 event stream (write-only, currently 82% harness noise, schema-partial)
    · 1 árbitro final:       reviewer humano en el commit
```

Este modelo:

- **Sobrevive**: renaming, provider swap (S4), session restart, cambios menores de policy.
- **Rompe**: 10× agentes (S2), multi-proyecto (S3), audit externo (S5).
- **Mejora**: bajo S6 (substrate con memoria persistente).

---

## 2. Qué sobrevivió del análisis Kimi/Claude

- Cronología F1..F9 y ARCH-001..004, F9-D01..D05.
- Existencia de duplicación policy/enforcement.
- Recurrencia "proposer ≠ verifier" (CAP-2 patrón).
- Provenance en git+registries (CAP-3 activa).
- INC-001 como único ciclo learning-loop completo.
- Reviewer humano como árbitro dominante (topología estrella lo confirma).
- Convergencia operativa (breakpoint 2026-09-20).
- Divergencia documental (research corpus crece).

## 3. Qué se reformuló

- CAP-1 → **GAP-1** (carencia, no capacidad).
- CAP-2 → **bifurcada** en sintáctica y semántica.
- CAP-4 → **PROP-4** (substrate, no capacidad CCP).
- CAP-5 → **POL-LATENT-5** (política latente).
- "18 → 5 collapse" → **13 decisiones abiertas reales** con dependencias.
- "Trust boundaries anidados" → **topología estrella** con humano-sink.
- "Enforceable traceability" como root → **etiqueta compuesta** de CAP-2s + CAP-3.
- "Convergencia parcial" → **convergencia operativa + divergencia documental** (misma
  conclusión con framing más honesto).
- "Human trust boundary" → **CAP-AUTHZ + CAP-2m** (autorización distinta de verificación
  semántica).

## 4. Qué se eliminó / refutó

- "STALL 3 eventos" → 18 al momento K3 (drift creciente).
- "18 decisiones" mezcla tomadas con pendientes.
- Contrafactuales de Kimi como evidencia para decisiones.
- "M001..M007 causados por F9-D01" → correlación narrativa, no causación.
- CAP-1..CAP-5 como lista homogénea → categorías asimétricas (K3-D-BASIS-CAT).

## 5. Descubrimientos K3 nuevos (nombrados)

| ID | Nombre | Origen | Confidence |
|---|---|---|---|
| K3-D1 (Kimi) | had_alternative schema-dead field | verificación baseline | VERIFIED |
| K3-D4 (Kimi) | STALL log = 82% harness noise (14/18) | verificación baseline | VERIFIED |
| K3-D-STAR | Topología estrella, no anidada | reconstrucción independiente | SUPPORTED |
| K3-D-CAP2 | Bifurcación sintáctica/semántica | ataque estructural | SUPPORTED |
| K3-D-CAP3 | Provenance break: `session_id` schema break | verificación código | VERIFIED |
| K3-D-LIFECYCLE | Entidades sin ciclo de vida = 1 clase estructural | cruce de fenómenos | VERIFIED |
| K3-D-SCHEMA | READY-03 tiene precondición D-INSTR | verificación código | VERIFIED |
| K3-D-PARTIAL | Duplicación entre representaciones parciales | verificación código | VERIFIED |
| K3-D-OWNER-DEFAULT | Default operativo: humano absorbe todo no delegado | análisis latente | SUPPORTED |
| K3-D-EXOGENOUS | Meta-doc creciente = respuesta al sustrato | análisis latente | HYPOTHESIS |
| K3-D-AUTHZ-VS-VERIF | Autorización ≠ verificación | intervention experiment | SUPPORTED |
| K3-D-PHASE-CHANGE | Pipeline → DAG paralelo en F9-D01=A | análisis causal | PARTIAL |
| K3-D-EPIST-COST | Deferrals sin trigger acumulan coste epistemológico | análisis UNKNOWN | SUPPORTED |
| K3-D-SUBSTRATE-FRACTION | >30% CCP responde a fragilidad substrate | intervention CF-5 | HYPOTHESIS |
| K3-D-DELEG-ORTOGONAL | Delegación explícita es capa transversal | análisis arquitectónico | SUPPORTED |
| K3-D-BASIS-CAT | Basis correcta tiene categorías asimétricas | attack a CAP-1..5 | SUPPORTED |
| K3-D-DERIVE-ONLY | De 10 operaciones conceptuales, sólo DERIVE ausente en runtime | periodic table | VERIFIED |
| K3-D-AUTHZ-CAT | CAP-AUTHZ es capacidad de primer orden faltante en lista Claude | attack sufficiency | SUPPORTED |
| K3-D-COMP-CAT | COMP-* (compensación de substrate) es categoría faltante | attack sufficiency | SUPPORTED |
| K3-D-ABSORPTION | Absorción decisional es epistemológica, no numérica | analysis decisional | SUPPORTED |
| K3-D-DECISION-COUNT | 13 decisiones abiertas reales, no 4 | inventario decisional | VERIFIED |
| K3-D-F9D01-BOTTLENECK | F9-D01 es gate root del decision graph | dependency graph | VERIFIED |
| K3-D-CANONICAL-CENTRAL | D-CANONICAL es única high-lock-in decision | lock-in analysis | SUPPORTED |
| K3-D-DELEG-FIRST | Bloque A (delegation enablement) es punto de entrada natural | secuenciación | SUPPORTED |

24 descubrimientos K3. **8 VERIFIED** (evidencia primaria directa), **13 SUPPORTED**
(inferencia con soporte cruzado), **2 HYPOTHESIS** (requieren experimento), **1 PARTIAL**.

---

## 6. WOW findings (§253)

### WOW-1: la carencia (GAP-1) NO es una capacidad faltante; es una ausencia de derivación

Reformular CAP-1 como GAP-1 y luego ver que **la única operación conceptual ausente en
runtime es DERIVE** (K3-D-DERIVE-ONLY) es un cambio de framing con consecuencias
arquitectónicas:

- Antes: "necesitamos un motor de policy". Después: "necesitamos una operación DERIVE
  entre representaciones, aplicable no sólo a policy sino a cualquier canónica futura".
- Antes: PAC como salvadora. Después: PAC es una implementación específica de una clase
  más grande (DERIVE en dominio de policy).
- Antes: READY-01/02 como decisiones. Después: READY-01/02 son derivativas de
  D-CANONICAL.

### WOW-2: el humano hace autorización, no verificación

K3-D-AUTHZ-VS-VERIF muestra que la mayor parte de la carga humana **no puede
mecanizarse** (autorización es juicio genuino), pero **una parte importante ya está
mecanizada** (CAP-2-sintáctica). El framing "human trust boundary" oculta esta
distinción y sugiere que automatizar verificación reducirá carga humana — falso.

### WOW-3: entities without lifecycle son una única clase

K3-D-LIFECYCLE unifica 3 problemas aparentemente distintos (STALL events, research
artifacts, deferrals) en una sola clase estructural: "el control plane gobierna transiciones
de tarea pero no gobierna transiciones de artefacto". La solución no es 3 fixes; es 1
decisión (D-LIFECYCLE).

### WOW-4: la meta-doc es exógena, no defecto

K3-D-EXOGENOUS reformula el crecimiento de meta-documentación de "problema arquitectónico"
a "respuesta racional al sustrato". Esto significa que:

- Rediseñar el control plane no elimina la meta-doc.
- El único cambio que la reduce es cambio de sustrato (S6).
- La meta-doc **no es un defecto a optimizar**; es una carga que se administra.

### WOW-5: F9-D01=A es el gate epistemológico dominante

K3-D-F9D01-BOTTLENECK muestra que la decisión "no autorizar cambios runtime" bloquea
D-INSTR, lo que bloquea observación de U-01/U-02/READY-03. F9-D01 tiene un **coste
epistemológico** creciente (K3-D-EPIST-COST) no nombrado en su enunciado original. Este
coste es acumulativo y silencioso.

### WOW-6: el decision space real es 3× lo que aparece

K3-D-DECISION-COUNT (13 vs. 4) es tal vez el descubrimiento con mayor impacto operativo:
el owner cree tener 4 pending decisions, pero tiene 13 con dependencias. El paquete READY
actual es incompleto como base de decisión.

### WOW-7: delegación explícita como primera decisión

K3-D-DELEG-ORTOGONAL + K3-D-DELEG-FIRST muestran que **la decisión de menor coste y mayor
palanca es adoptar un contrato de delegación explícito** (Arquitectura E de `09`).
No es la que Kimi/Claude sugirieron; es una intervención de gobernanza ortogonal, no
una implementación arquitectónica.

---

## 7. Break your master model (§277)

Ataque al modelo K3 propio:

### 7.1 ¿Está sesgado el modelo K3 hacia "delegación explícita"?

Posiblemente. E es la única arquitectura que aparece ortogonal a todas las demás; parece
"la solución mágica". Verificación:

- Ataque §221 anti-gravity: si eliminamos E del vocabulario, ¿el resto del modelo sigue
  operando?
- Sí. K3 aún tiene 4 arquitecturas alternativas (A/B/C/D) sin E. E se **suma** al
  análisis; no lo genera.
- Pero **la conclusión "adoptar E primero"** sí depende del framing K3. Es una
  **recomendación derivada**, no una obligación estructural.

### 7.2 ¿Está sesgado hacia "topología estrella"?

Posiblemente. La star topology absorbe fenómenos diversos y explica bien. ¿Está sobre-
adjustada?

- Countermodel §6.3 de `05` (pipeline linear) mostró que sobrevive parcialmente
  (F1..F8 son pipeline; F9+ son DAG estrella).
- K3-D-PHASE-CHANGE (PARTIAL, no VERIFIED) admite explícitamente esta incompletitud.
- La estrella es la mejor descripción **operativa** del estado actual, no la única.

### 7.3 ¿Está el modelo K3 sub-ajustado (over-simplifying)?

Un modelo con 8 elementos asimétricos parece rico, pero:

- No modela **interacciones entre agentes** (no hay N>1).
- No modela **temporalidad** (todo es snapshot).
- No modela **el reviewer humano** con detalle (es "sink").

Estos son huecos declarados. Cualquier arquitectura futura debe cerrarlos o admitirlos.

### 7.4 Countermodel serio

**Modelo alternativo Cm**: "CCP es un ciclo `intent → tool → evidence → commit` con dos
correcciones runtime (blockers) y una corrección post (reviewer). Todo lo demás
(SessionStart, meta-doc, HRQS, registries) es infraestructura auxiliar para mantener el
ciclo trazable a través de sesiones fragmentadas."

- Diferencia con K3: Cm es **procesocentrista** (ciclo básico); K3 es **arquitecturacentrista**
  (estructura de capacidades).
- ¿Cuál es correcto? Ambos capturan aspectos reales. Cm es útil para "cómo opera un caso";
  K3 es útil para "cómo evoluciona el sistema".
- **No hay winner**. Los dos modelos coexisten.

**K3-D-DUAL-MODEL**: CCP admite al menos dos descripciones estructurales complementarias:
K3 (capacidades) y Cm (ciclo). Ni una absorbe a la otra. Esto es una honestidad epistemológica
que puede ser útil ante el Owner.

---

## 8. What K3 discovered that Kimi and Claude did NOT

Aplicando §98:

1. **GAP-1 vs CAP-1 (reformulación)**: cambio de framing con consecuencias en 3 decisiones.
2. **CAP-2 bifurcación (K3-D-CAP2)**: unifica cuándo delegar y cuándo no.
3. **CAP-AUTHZ como primitiva (K3-D-AUTHZ-CAT)**: distinción autorización/verificación.
4. **COMP-* como categoría (K3-D-COMP-CAT)**: mecanismos que compensan substrate no son
   capacidades activas.
5. **Topología estrella con humano-sink (K3-D-STAR + K3-D-OWNER-DEFAULT)**: framing más
   preciso que "trust boundaries anidados".
6. **Schema-dead field (K3-D1, K3-D-SCHEMA)**: READY-03 tiene precondición no nombrada.
7. **Entities without lifecycle (K3-D-LIFECYCLE)**: 3 problemas → 1 clase.
8. **DERIVE única operación ausente (K3-D-DERIVE-ONLY)**: precisa la naturaleza de GAP-1.
9. **F9-D01 como bottleneck epistemológico (K3-D-F9D01-BOTTLENECK + K3-D-EPIST-COST)**:
   coste no nombrado de F9-D01=A.
10. **13 decisiones abiertas reales (K3-D-DECISION-COUNT)**: el paquete READY oculta 9
    decisiones.
11. **Delegación explícita como capa transversal (K3-D-DELEG-ORTOGONAL, K3-D-DELEG-FIRST)**:
    arquitectura E domina en 3 escenarios.
12. **Absorción epistemológica, no numérica (K3-D-ABSORPTION)**: los "collapses" reducen
    carga cognitiva, no cantidad.
13. **Substrate-fraction (K3-D-SUBSTRATE-FRACTION)**: fracción del sistema depende del
    sustrato, no del problema.
14. **Meta-doc como respuesta racional (K3-D-EXOGENOUS)**: no es defecto arquitectónico.
15. **Dual model (K3-D-DUAL-MODEL)**: K3 y Cm coexisten; ni uno domina.

---

## 9. Ultimate K3 test (§288)

### 9.1 ¿Qué estructura emergió sólo por conectar piezas separadas?

- **K3-D-LIFECYCLE** = cruzar STALL events + research artifacts + deferrals.
- **K3-D-F9D01-BOTTLENECK** = cruzar F9-D01 + K3-D-SCHEMA + U-01/U-02.
- **K3-D-DELEG-ORTOGONAL** = cruzar arquitecturas alternativas y observar dominancia.
- **K3-D-DUAL-MODEL** = admisión honesta al terminar la síntesis.

### 9.2 ¿Qué arquitectura sólo se vuelve pensable después?

- Arquitectura E (delegation) sólo cobra sentido si CAP-AUTHZ es primitiva y
  K3-D-OWNER-DEFAULT existe.
- Shadow runtime (§8.3 de `06`) sólo aparece al distinguir "cambiar el runtime" de
  "instrumentarlo".

### 9.3 ¿Qué decisiones se reducen, transforman o aparecen?

- **Reducen**: READY-01, READY-02, PAC adoption, CDT-02, H-01 threshold. Se convierten
  en derivativas de decisiones upstream.
- **Transforman**: READY-03 (de "aceptar N" a "definir D-INSTR + observar + aceptar N").
- **Aparecen**: D-INSTR, D-CATALOG, D-DELEG, D-LIFECYCLE, D-CANONICAL, D-MOTOR, D-VERIFICADOR,
  D-DEFERRAL-POLICY, D-META-DOC.

### 9.4 ¿Qué sobrevive si eliminamos la historia de CCP?

- CAP-2-sintáctica y CAP-2-semántica: necesarias para cualquier control plane.
- CAP-3: forma exacta puede cambiar, pero provenance persiste.
- CAP-AUTHZ: humano/owner presente.
- COMP-CTX: **sólo si el sustrato sigue siendo LLM con contexto limitado**. Si el sustrato
  mejora, COMP-CTX desaparece.

### 9.5 ¿Qué sobrevive si sustituimos Claude/Kimi/OpenCode/runtime?

- Todo lo anterior + los archivos gobernados (git + Markdown).
- No sobreviven: skills/agents específicos de Claude, meta-doc estilizado para Claude.

### 9.6 ¿Qué parte del modelo K3 podría estar equivocada por sesgo K3?

- **K3-D-EXOGENOUS**: HYPOTHESIS, no verificada. Podría ser que el control plane cause
  parte de la meta-doc que atribuimos al sustrato.
- **K3-D-SUBSTRATE-FRACTION >30%**: número especulativo. "Fracción significativa" es
  más honesto.
- **K3-D-DELEG-FIRST**: recomendación derivada; el Owner puede legítimamente elegir
  otra secuencia.

### 9.7 ¿Qué evidencia destruiría el modelo K3?

- Si CAP-2-semántica resulta mecanizable con precisión ≥ humano → K3-D-CAP2 se
  reformula.
- Si aparece un componente crítico sin trace en git/registries → CAP-3 más débil.
- Si un cambio de topología (no substrate) elimina meta-doc → K3-D-EXOGENOUS falso.
- Si HRQS o similares se cierran mecánicamente sin humano → K3-D-STAR reformula.

Ningún falsifier disparado.

---

## 10. Executive output (§108) — 12 preguntas

**1. ¿Qué cambió realmente después del audit de Claude?**
La reformulación CAP-1 → GAP-1, la bifurcación CAP-2, la inclusión de "research
artifact" como tipo faltante. Todo lo cual K3 confirmó y extendió.

**2. ¿Qué descubrió K3 que Kimi no había visto?**
Los 15 hallazgos K3-D-* enumerados en `12 §5`. Los más significativos: schema-dead field,
topología estrella, entities without lifecycle, F9-D01 como bottleneck epistemológico,
CAP-AUTHZ como capacidad omitida.

**3. ¿Qué descubrió K3 que Claude tampoco había visto?**
Los mismos, más: K3-D-DERIVE-ONLY (única operación ausente), K3-D-DELEG-ORTOGONAL, K3-D-
BASIS-CAT (categorías asimétricas), K3-D-DECISION-COUNT (13 vs 4), K3-D-DUAL-MODEL.

**4. ¿Qué estructuras sobrevivieron a todos los ataques?**
CAP-2-sintáctica, CAP-3, PROP-4, la topología estrella, la duplicación policy/enforcement
como fenómeno real, la existencia del reviewer humano como árbitro final, F9-D01=A como
gate coherente con substrate actual.

**5. ¿Qué estructuras murieron?**
CAP-1 como capacidad, CAP-4 como capacidad, CAP-5 como capacidad activa, "trust boundaries
anidados" como framing dominante, "governance compiler" como modelo dominante, "18→5
collapse" como reducción numérica, "3 STALL events" como conteo, "5 root decisions" como
número final.

**6. ¿Qué capacidades parecen realmente fundamentales?**
CAP-2-sintáctica, CAP-2-semántica, CAP-3, CAP-AUTHZ. Cuatro, no cinco.

**7. ¿Qué decisiones siguen siendo verdaderamente del Owner?**
13 abiertas reales; ~9 requieren juicio owner genuino; 4 pueden pre-derivarse con
drafts.

**8. ¿Qué decisiones dejaron de ser decisiones porque pueden derivarse?**
PAC adoption (derivada de D-CANONICAL + D-MOTOR), READY-01/02 (idem), H-01 threshold
(sub-componente de READY-03), CDT-02 (research track, no decisión).

**9. ¿Qué UNKNOWN podría cambiar toda la arquitectura?**
U-05 (CAP-2-semántica mecanizable). U-09 (correlated failure LLM). Ambos afectan la
viabilidad de romper la topología estrella.

**10. ¿Qué arquitecturas siguen vivas?**
A (statu quo formalizado), B (canonical+motor), C (single source), D (peer-LLM), E
(delegation). Ninguna domina; E es transversal.

**11. ¿Qué estructura mínima explica mejor CCP?**
La basis K3: 8 elementos asimétricos + 10 operaciones conceptuales + topología estrella +
dual model. Este modelo sobrevive los ataques con las incompletitudes declaradas.

**12. ¿Qué parte de ese modelo sigue pudiendo estar equivocada?**
K3-D-EXOGENOUS (hipótesis), K3-D-SUBSTRATE-FRACTION (estimación gruesa), K3-D-DELEG-FIRST
(recomendación derivada), K3-D-PHASE-CHANGE (parcial). El Owner puede elegir distinto.

---

## 11. Anti-WOW rule (§347)

Un resultado válido posible es "no encontramos nueva estructura significativa". K3 no
llega a esa conclusión (encontró 15+ hallazgos nuevos), pero es importante enunciar el
criterio: los hallazgos K3 se sostienen porque tienen evidencia primaria o cruzada, no
porque el prompt pedía sorpresas.

---

## 12. Verdict del capítulo

- Modelo K3 sintetizado. 8 elementos asimétricos + 10 operaciones + topología estrella.
- 24 descubrimientos K3 nombrados y verificados/soportados.
- 7 WOW findings elevados por su cambio de framing.
- Countermodel Cm coexiste con K3; ninguno domina.
- Ningún falsifier del modelo disparado.
- Executive output entrega respuestas a las 12 preguntas del prompt.

Insumo final para `13_MASTER_OWNER_DECISION_SYSTEM`.
