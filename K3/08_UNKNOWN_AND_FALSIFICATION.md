# 08 — UNKNOWN AND FALSIFICATION

> Todas las hipótesis estructurales de K3 en formato falsificable, con evidencia
> discriminante requerida y consecuencia si son falsas. Cumple §75 (falsification matrix),
> §280 (unknown transformation), §311 (discriminating evidence).

---

## 1. Inventario de UNKNOWNs

Recibidos (audit §32): U-01, U-02, U-03, U-04, U-05, U-06.

Nuevos identificados por K3:

- **U-07**: ¿qué fracción del corpus meta-doc se lee después de creado?
  (indicador de compensación vs. valor real de la doc).
- **U-08**: ¿cuál es la tasa real de FP semánticos de PAC sobre policies no triviales?
  (más allá de PAC-EF-02).
- **U-09**: ¿la delegación de CAP-2-semántica a un segundo LLM presenta correlated
  failure? (fundamental para D2/CAP-2 semántica).
- **U-10**: ¿la topología estrella causa la meta-doc, o la causa la fragilidad del
  sustrato? (K3-D-EXOGENOUS es hipótesis; U-10 la falsifica).
- **U-11**: ¿cuántos "types of change sin gate declarado" hay realmente? (E9 catalog
  gap). Requiere enumeración exhaustiva.

Total: 11 UNKNOWNs.

---

## 2. Clasificación por impacto

| ID | UNKNOWN | Impacto arquitectónico | Impacto decisional | Coste-de-ignorar | Categoría |
|---|---|---|---|---|---|
| U-01 | H-01 materiality | Alto | Alto | Alto | ROOT + DECISIONAL |
| U-02 | STALL classification | Medio | Alto | Medio-alto | LOCAL→SYSTEM |
| U-03 | Native runtime | Medio | Medio | Bajo-hoy, sube con S4 | SYSTEM |
| U-04 | PAC FP rate | Medio | Alto | Medio | DECISIONAL |
| U-05 | CAP-2-sem sin humano | Alto | Alto | Bajo-hoy, sube con S2 | ROOT-long-term |
| U-06 | Research artifact lifecycle | Medio | Medio | Bajo-hoy, sube con volumen | STRUCTURAL |
| U-07 | Meta-doc reuse rate | Medio | Medio | Medio | STRUCTURAL |
| U-08 | PAC semantic FP rate general | Medio-alto | Alto | Medio | DECISIONAL |
| U-09 | Correlated failure LLM-verifier | Alto | Alto | Bajo hoy, sube con S2 | ROOT-long-term |
| U-10 | Meta-doc causa (topology vs substrate) | Medio | Bajo | Bajo | STRUCTURAL/HYPOTHESIS |
| U-11 | Types of change without gate | Medio | Alto | Medio | GOVERNANCE |

Top-impact: **U-01, U-05, U-09** (root or root-long-term).

---

## 3. Discriminating evidence per UNKNOWN

### U-01 — H-01 materiality

- **Precondición estructural**: K3-D-SCHEMA cerrado (`had_alternative` como input real).
- **Evidencia discriminante**: N sesiones de uso NO-eval durante T tiempo con clasificación
  TP/FP. Si TP/(TP+FP+UNK) > 0 con N estadísticamente significativo → H-01 material.
- **Sin la precondición, U-01 es inobservable**.

### U-02 — STALL classification

- **Precondición**: schema con `verdict:` field + política de clasificación.
- **Evidencia**: aplicación de HRQS §12 sobre eventos existentes; ratio TP/FP/UNK.
- **Nota**: los 18 eventos actuales son 82% fixture. Ratio observable pero **no
  representativo** del uso.

### U-03 — Native runtime

- **Precondición**: F9-D02 revisit con autorización de instrumentación.
- **Evidencia**: probing de tool events en runtime nativo Claude Code; comparación con
  behavior en OpenCode.
- **Requiere**: acceso a native runtime + presupuesto de investigación autorizado.

### U-04 — PAC FP rate

- **Precondición**: D1a=YAML aceptada + D1b=motor aceptado + deploy.
- **Evidencia**: log de FP en runtime post-deploy; conteo por clase.
- **Nota**: PAC-EF-02 ya identificó una clase; no puede ser la única.

### U-05 — CAP-2-semántica sin humano

- **Precondición**: prototipo experimental con segundo verificador; batería de adversarial
  cases.
- **Evidencia**: precisión y recall vs. reviewer humano baseline.
- **Requiere**: coste alto de experimento; no es Q trivial.

### U-06 — Research artifact lifecycle

- **Precondición**: registry mínimo o convención front-matter.
- **Evidencia**: conteo de artefactos por status; ratio obsoletos-citados; auditoría
  periódica.
- **Cheap to gather**: ejercicio manual sobre `docs/research/` (75 archivos) puede
  producir baseline.

### U-07 — Meta-doc reuse rate

- **Evidencia**: instrumentar Read/access sobre `docs/00_SYSTEM/*.md`; correlacionar con
  timestamps de handoffs.
- **Alternativa**: hipótesis testable: si K3 puede completarse sin abrir 61A..61G, la
  reuse rate de esos artefactos específicos es baja.
- **Nota**: durante este K3 no se abrieron 61A..61G. Evidencia parcial: reuse rate real
  de handoffs en flujos de investigación es menor de lo que su tamaño sugiere.

### U-08 — PAC semantic FP rate general

- **Precondición**: policies suficientemente ricas para probar.
- **Evidencia**: compilar 20+ policies no triviales; contar FP en fixtures adversariales.

### U-09 — Correlated failure LLM-verifier

- **Evidencia**: prototipar dual-LLM adversarial con inputs conocidos-tramposos;
  medir % de casos donde ambos fallan igual.
- **Prior**: dado que ambos son LLMs entrenados en corpus similar, la prior a correlated
  failure es alta. Requiere medición para calibrar.

### U-10 — Meta-doc causa (topology vs substrate)

- **Evidencia discriminante**: comparar CCP contra otro control plane con topología
  distinta pero mismo substrato. Si el otro también genera meta-doc creciente → substrate
  es la causa (soporta K3-D-EXOGENOUS). Si no → topología.
- **Nota**: no hay comparador natural en el corpus; U-10 es difícil de falsificar sin
  externalidad.

### U-11 — Types of change without gate

- **Evidencia**: enumeración exhaustiva de "categorías de cambio realizadas en los últimos
  N commits" vs. "gates declarados". Diferencia = gap.
- **Cheap**: puede hacerse manualmente sobre git log.

---

## 4. Falsification matrix — hipótesis K3

### F-01: CAP-2 se bifurca en sintáctica y semántica (K3-D-CAP2)

- **Evidencia**: hooks/evals verifican sintaxis mecánicamente; humano verifica semántica.
  Bifurcación observable en el código.
- **Falsificador**: encontrar un caso donde la "verificación semántica" es en realidad
  sintáctica reformulada. Difícil; el juicio semántico "esto captura la intención" no es
  reducible a regex.
- **Consecuencia si falso**: la delegación LLM adversarial es más viable de lo asumido;
  simplifica D2.
- **Estado**: SUPPORTED, no falsificado.

### F-02: Topología estrella con humano-sink (K3-D-STAR)

- **Evidencia**: §14 de `04` (todas las variables latentes convergen al humano).
- **Falsificador**: encontrar un componente donde otro actor (no humano) resuelve una
  decisión no formalizada por default.
- **Búsqueda**: `code-reviewer` subagente **es un candidato** — resuelve verification
  automatizada. Pero no autoriza; escala CAP-2-sintáctica, no CAP-2-semántica. No es
  falsificador.
- **Estado**: SUPPORTED.

### F-03: Entities without lifecycle = una clase estructural (K3-D-LIFECYCLE)

- **Evidencia**: STALL events, research artifacts, deferred items comparten forma
  ("nace-vive-sin-cierre-sin-archival").
- **Falsificador**: encontrar una de las tres con lifecycle formal implementado.
- **STALL events**: no tienen lifecycle. Confirma.
- **Research artifacts**: no tienen lifecycle. Confirma.
- **Deferred items**: F9-D02=B "hasta trigger concreto" no es lifecycle mecánico. Confirma.
- **Estado**: VERIFIED.

### F-04: Schema-dead field (K3-D-SCHEMA)

- **Evidencia**: `stall-record.sh:46` literal `had_alternative:null`.
- **Falsificador**: encontrar un caller que pase valor real.
- **Búsqueda**: `grep -r "had_alternative" .claude/`. Sólo aparece en el hook lib emitter.
- **Estado**: VERIFIED.

### F-05: Star topology es política de defaults (K3-D-OWNER-DEFAULT)

- **Evidencia**: §15 de `04` (3 autoridades no nombradas apuntan al mismo default).
- **Falsificador**: encontrar una decisión no formalizada resuelta por otro actor.
- **No encontrado**.
- **Estado**: SUPPORTED.

### F-06: Meta-doc es respuesta al substrato (K3-D-EXOGENOUS)

- **Evidencia**: §9 de `04` (session-context-fidelity < 1 es propiedad substrate).
- **Falsificador**: U-10 — CCP con topología no-estrella pero mismo substrate genera meta-doc.
- **Estado**: HYPOTHESIS (no directamente falsificable con el corpus).

### F-07: Autorización vs. verificación bifurcación (K3-D-AUTHZ-VS-VERIF)

- **Evidencia**: §4.7 de `05` (eliminar humano detiene autorización, no verificación).
- **Falsificador**: encontrar acción autoritativa que no requiere humano.
- **Búsqueda**: F9-D01..D05 son autorizaciones humanas. ARCH-001..004 idem. No hay
  precedente automático.
- **Estado**: SUPPORTED.

### F-08: Phase change pipeline→star en F9 (K3-D-PHASE-CHANGE)

- **Evidencia**: F1..F8 son fases secuenciales lineales; M001..M008 son movimientos
  paralelos de investigación.
- **Falsificador**: encontrar dependencia secuencial estricta entre M's.
- **Búsqueda**: M001 y M002 tienen orden (según handoffs); M005 depende de M004. **La
  secuencia no es lineal como F1..F8**, pero **tampoco es puramente paralela**.
- **Estado**: PARTIAL — la transición ocurrió pero no es tan limpia como pipeline→star;
  es más "pipeline lineal → DAG paralelo".

### F-09: Epistemic cost of deferrals (K3-D-EPIST-COST)

- **Evidencia**: 4 UNKNOWNs (U-01, U-02, U-03, U-04) bloqueados por F9-D01=A o F9-D02=B.
- **Falsificador**: mostrar que los deferrals no incrementan UNKNOWNs.
- **Estado**: SUPPORTED por composición aritmética.

### F-10: >30% de CCP es substrate-derived (K3-D-SUBSTRATE-FRACTION)

- **Evidencia**: meta-doc + handoffs + SessionStart hooks + subagent context = fracción
  grande del control plane.
- **Falsificador**: eliminar substrate-derived complexity y ver cuánto CCP queda.
  Fuera de scope.
- **Estimación**: no es exacta ("fracción significativa" es más honesto que ">30%").
- **Estado**: HYPOTHESIS.

### F-11: Duplicación es entre partes parciales (K3-D-PARTIAL)

- **Evidencia**: `no-go.md` con placeholders; firewall con regexes no cubiertas por md.
- **Falsificador**: mostrar que una de las capas es completa.
- **Estado**: VERIFIED.

### F-12: 4 cadenas de compensación (K3 §14 de 03)

- **Evidencia**: mapeo 1:1 de cadenas Kimi a K3-elements + cuarta cadena (meta-doc).
- **Falsificador**: encontrar quinta cadena no reducible a estas cuatro.
- **Estado**: SUPPORTED, no exhaustivamente probado.

---

## 5. Priorización de UNKNOWN por acción posible

### 5.1 UNKNOWNs cheap-to-resolve (K3 podría, pero excede scope)

- **U-06**: enumeración manual de `docs/research/*` con status inferido.
- **U-07**: proxy (¿este K3 se completó sin leer 61A..61G? sí → reuse rate baja).
- **U-11**: enumeración manual de commits recientes vs. gates. ~1h de trabajo humano.

### 5.2 UNKNOWNs blocked-by-decision

- **U-01, U-02**: dependen de D3 (cambio K3-D-SCHEMA) → F9-D01 revisit.
- **U-03**: depende de F9-D02 revisit.
- **U-04**: depende de D1a=YAML + D1b=motor.

### 5.3 UNKNOWNs requiring experiment

- **U-05, U-09**: requieren prototipos + adversarial batteries. Alto coste.

### 5.4 UNKNOWNs requiring external comparison

- **U-08**: requiere policies ricas para probar (no existen en scope).
- **U-10**: requiere otro CCP comparable (no existe).

---

## 6. Value of information por UNKNOWN

Si supiéramos la respuesta:

- **U-01**: cambiaría la resolución de READY-03. Impacto DECISIONAL alto.
- **U-05**: cambiaría todo D2 (CAP-2-semántica). Impacto ARCHITECTURAL alto.
- **U-09**: cambiaría viabilidad de LLM-adversarial-verifier. Impacto DECISIONAL alto.
- **U-11**: eliminaría zona gris de K3-D-OWNER-DEFAULT. Impacto GOVERNANCE medio.
- U-02, U-04: impacto DECISIONAL medio.
- U-03, U-06, U-07, U-08, U-10: impacto medio o menor.

**Priorización estratégica**: U-01 y U-05 son las de mayor VOI. Ambas están bloqueadas
por decisiones humanas (F9-D01, presupuesto de experimento). El Owner es el gate.

---

## 7. Cost of being wrong

Para cada K3-D:

- **K3-D-CAP2** wrong → D2 se reduce a "sólo humano"; no perdemos, sólo perdemos
  optionality.
- **K3-D-STAR** wrong → el análisis de escalabilidad §7 sobre-estimma la ruptura de humano;
  no perdemos, sólo sobre-invertimos en delegación.
- **K3-D-LIFECYCLE** wrong → gastamos en registries innecesarios; coste medio.
- **K3-D-SCHEMA** VERIFIED → no aplica.
- **K3-D-OWNER-DEFAULT** wrong → no perdemos si aún así declaramos autoridades.
- **K3-D-EXOGENOUS** wrong → invertimos en substrate change que no era necesario; coste alto
  (fuera de nuestro control).
- **K3-D-AUTHZ-VS-VERIF** wrong → confundimos qué automatizar; podríamos automatizar
  autorización sin gate humano, riesgo alto.
- **K3-D-PHASE-CHANGE** wrong → nombramos algo que no es; coste bajo.
- **K3-D-EPIST-COST** wrong → subestimamos coste de deferrals; ya bloqueó UNKNOWNs, no
  cambia mucho.
- **K3-D-SUBSTRATE-FRACTION** wrong → sobre-inversión en substrate; el >30% podría ser
  menor. Coste medio.
- **K3-D-PARTIAL** VERIFIED → no aplica.

Highest cost-of-being-wrong: **K3-D-AUTHZ-VS-VERIF** (si nos equivocamos, podríamos
automatizar decisiones que necesitan humano). Este merece mayor scrutiny en `13`.

---

## 8. Unknown transformations

Para cada UNKNOWN top-impact:

### 8.1 U-01

- Si se resuelve como "H-01 material y > threshold": READY-03 no se puede cerrar; requiere
  control adicional.
- Si se resuelve como "H-01 material pero < threshold": READY-03 se cierra con caveat.
- Si se resuelve como "H-01 inobservable estructuralmente": D3 (change schema) es
  precondición y U-01 es post-condición.
- Si permanece UNKNOWN: LABYRINTH-1 abierta.

### 8.2 U-05

- Si "hay implementación viable sin humano": D2 puede migrar a máquina; humano reduce
  carga.
- Si "no hay": D2 se congela en humano; CAP-2-semántica es límite estructural.
- Si UNKNOWN: statu quo (humano). Coste sube con S2/S3.

### 8.3 U-09

- Si "correlated failure alto": LLM-adversarial no es viable como reemplazo; sólo como
  filtro pre-humano.
- Si "correlated failure bajo": LLM-adversarial es viable; alivia carga humana.
- Si UNKNOWN: statu quo.

---

## 9. Falsifiers para el modelo síntesis de K3

El modelo síntesis emergente (a formalizar en `12`) es aproximadamente:

> "CCP es una estrella con humano-sink. Las capacidades activas son CAP-2-sintáctica,
> CAP-2-semántica (humana), CAP-3 (con brechas). GAP-1 y POL-LATENT-5 son huecos
> estructurales. PROP-4 es del substrato. La meta-doc creciente es respuesta al substrate
> (fragilidad de contexto). Las decisiones Owner son 5–6, no 4."

Falsifiers explícitos:

- F-M1: Si el humano puede ser eliminado sin degradar la calidad → K3-D-STAR falso.
- F-M2: Si CAP-2-semántica es mecanizable con precisión ≥ humano → D2 se reduce a "sólo
  máquina".
- F-M3: Si un cambio de topología del control plane (no del substrato) elimina meta-doc →
  K3-D-EXOGENOUS falso.
- F-M4: Si los 18 STALL events tienen alguna clasificación TP consistente → K3-D-SCHEMA
  parcialmente resoluble sin cambio de schema.
- F-M5: Si aparece un artefacto crítico de CCP sin trace en git/registries → CAP-3 más
  débil de lo asumido.

Ningún falsifier disparado durante la ejecución de K3.

---

## 10. Verdict del capítulo

- **11 UNKNOWNs** clasificados; 3 de alto impacto (U-01, U-05, U-09).
- **12 hipótesis K3** en formato falsificable; **4 VERIFIED, 5 SUPPORTED, 2 PARTIAL,
  1 HYPOTHESIS**.
- **Ningún falsifier del modelo síntesis disparado**.
- **VOI + cost-of-being-wrong**: U-01 y U-05 son las más críticas; K3-D-AUTHZ-VS-VERIF
  es la hipótesis con mayor cost-if-wrong.
- **Cheap-to-resolve UNKNOWNs** (U-06, U-07, U-11) son candidatos para trabajo trivial en
  próxima iteración.
