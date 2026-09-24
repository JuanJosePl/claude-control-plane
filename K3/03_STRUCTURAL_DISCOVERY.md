# 03 — STRUCTURAL DISCOVERY

> Ataque directo a las estructuras candidatas heredadas y descubrimiento de las que
> emergen sin herencia. Este documento cumple §7 (no aceptar CAP-1..CAP-5 sin probarlo),
> §11 (ataque a hallazgos de Claude), §24 (distinción necesaria), §38 (structural survivor
> search), §72 (root basis attack).

---

## 1. Herencia recibida (§32 audit) y su estado tras la reconstrucción independiente

Del K3 INPUT CONTRACT (audit §32) heredamos como **hipótesis de trabajo**:

- 5 root capabilities candidatas: `CAP-1 enforceable specification`, `CAP-2 independent
  verification`, `CAP-3 durable provenance/traceability`, `CAP-4 reversible state`,
  `CAP-5 formalized learning loop`.
- 1 estructura latente propuesta por Claude: `enforceable traceability` como capacidad
  primitiva subyacente que unifica CAP-1, CAP-3 y CAP-5.
- 1 patrón recurrente: `independent verification` (F-FALSE_PASS-01, B-1, PI-1, CDT-02,
  AC-03).
- 1 tipo faltante: `research artifact` sin ciclo de vida.
- 1 candidata a root decision adicional: `R-LEARN` (política de "qué es incident").

De la reconstrucción independiente `02` obtenemos como **material observable**:

- 3 interfaces técnicas: `tool-invocation`, `task-close`, `session-start`.
- 2 gates duros: BLOCKER-*, GATE-BEFORE-TASK-CLOSURE.
- 1 event stream write-only.
- 1 verificador ex-post (RUNBOOK-SUITE).
- 1 árbitro final (reviewer humano).
- 3 discrepancias sustantivas con la descripción histórica.

Este documento cruza ambas fuentes y aplica el ataque estructural obligatorio.

---

## 2. Ataque a CAP-1 — "Enforceable specification"

### 2.1 ¿Qué explica?

- Duplicación `.claude/rules/*.md` ↔ `bash-firewall.sh`.
- READY-01 (nueva regla → hay que editar dos sitios).
- READY-02 (mismo).
- PAC como intento de derivación.

### 2.2 ¿Qué NO explica?

- No explica **por qué existe una fuente canónica sola** — no la hay. `.claude/rules/*.md`
  no es completa (`no-go.md` tiene `{{placeholders}}`), y `bash-firewall.sh` tiene
  regex que no aparecen en los `.md`. La reconstrucción `02 §12` mostró que no hay
  canónica.
- No explica por qué el `EVIDENCE-MASTER` requiere que el humano lo pobre después del
  gate. Eso NO es sobre policy.
- No explica por qué existe el EVENT-STREAM write-only.

### 2.3 ¿Es realmente una capacidad?

Una capacidad debe ser observable como un patrón que el sistema **debe** sostener. La
"enforceable specification" no aparece como patrón observable — aparece como una carencia
(no hay derivación mecánica desde nada). Es más preciso llamarla **"missing derivation
mechanism from a non-existent canonical source"**.

### 2.4 Test de necesidad (§20 del prompt)

- ¿Puede CCP funcionar sin CAP-1? **Sí, empíricamente**: la fase F1..F9 se completó sin
  derivación mecánica. El coste fue la duplicación y READY-01/02 pendientes.
- ¿Es CAP-1 la única solución? **No**: alternativas viables son "policy-as-tests" (los
  tests son la especificación), "policy-as-single-source" (borrar `.claude/rules/*.md`
  y aceptar `bash-firewall.sh` como fuente), o "policy-as-review" (nada mecánico, revisión
  humana como enforcement).
- ¿CAP-1 sobrevive si se elimina PAC de la conversación? Sí como carencia, no como
  capacidad activa.

### 2.5 Reformulación

CAP-1 sobrevive como **carencia estructural**, no como capacidad. Su forma correcta:

> **GAP-1**: CCP tiene dos representaciones de política *without a canonical source*, y
> la única sincronización actual es humana.

Esto es una **negación** ("no hay canónica"), no una "capacidad" ("debe haber
derivación mecánica"). El error de framing es importante: convertir la carencia en
capacidad **implícitamente decide** que la solución es un motor de derivación. La carencia,
formulada correctamente, admite al menos tres respuestas ortogonales:

- (a) declarar `.claude/rules/*.md` como canónica y **generar** el firewall (motor);
- (b) declarar `bash-firewall.sh` como canónica y **descartar** `.claude/rules/*.md`
  (deletion);
- (c) declarar los **tests de firewall** como canónica y usar los `.md` sólo como
  documentación humana (test-first).

### 2.6 Verdict

- CAP-1 → **REFORMULATED como GAP-1** ("ausencia de fuente canónica única").
- Los tres caminos (a/b/c) son insumo directo para `13_MASTER_OWNER_DECISION_SYSTEM`.

---

## 3. Ataque a CAP-2 — "Independent verification"

### 3.1 ¿Qué explica?

- F-FALSE_PASS-01 (F7 detectó que un agente puede firmar su propia evidencia).
- B-1, PI-1, CDT-02, AC-03 (todos comparten forma: proposer ≠ verifier).
- La existencia del subagente `code-reviewer`.
- La delegación al humano en el commit.

### 3.2 Diferencia con CAP-1

CAP-2 sí describe un patrón que **el sistema tiene que sostener**. La firma "proposer no
puede ser certifier" aparece en 5 fases distintas con nombres distintos. Esta recurrencia
es **estructural**, no accidental.

### 3.3 Test de subsunción (§21)

- ¿CAP-2 absorbe CAP-1? **No**. La derivación mecánica (CAP-1) no requiere que el
  derivador sea distinto del enforcer; requiere que exista una canónica.
- ¿CAP-2 absorbe CAP-3? **No**. La provenance puede existir sin verificación
  independiente (es sólo trazabilidad).
- ¿CAP-2 absorbe CAP-5? **Parcialmente**. Un incident loop puede funcionar sin verificación
  independiente si la observación es determinista; pero para clasificar un evento como
  "TP" o "FP" **sí** se requiere verificación independiente. Esto sugiere que CAP-2 es
  un **componente** de CAP-5, no un hermano.

### 3.4 Ataque a la implementación actual

La implementación actual de CAP-2 es "humano revisando el commit" + "subagente
code-reviewer". Ataque:

- **¿Es CAP-2 verificable por otro subagente?** Sí en principio; en la práctica el
  `code-reviewer` es un LLM con posibles sesgos correlacionados con el implementer.
- **¿Es CAP-2 verificable sin humano?** Depende del tipo de claim: para claims sintácticos
  (tests pasan, hooks pasan) sí; para claims semánticos (política capta intención) no.

### 3.5 Verdict

- CAP-2 → **SUPPORTED como capacidad estructural**.
- Sub-hallazgo: **hay dos formas de CAP-2**: sintáctica (verificable mecánicamente) y
  semántica (requiere humano por ahora). El colapso "una sola CAP-2" pierde información.
- Esta bifurcación sugiere que la "trust boundary humano" es la respuesta a la CAP-2
  semántica, no a la CAP-2 sintáctica. El código muestra ambas.

### 3.6 Descubrimiento: CAP-2 se bifurca

```text
CAP-2 semántica  ── requiere juicio         ── implementada por humano
CAP-2 sintáctica ── mecánicamente verifica  ── implementada por hooks/tests/evals
```

**K3-D-CAP2**: la unificación "verificación independiente = humano" es una consecuencia de
no separar CAP-2 semántica de CAP-2 sintáctica. Si se separa, se descubre que **CCP ya
tiene la sintáctica** (hooks + evals + maintenance), y sólo la semántica queda con el
humano. Esta es una distinción necesaria que ninguna investigación previa hace.

---

## 4. Ataque a CAP-3 — "Durable provenance/traceability"

### 4.1 ¿Qué explica?

- `task_id + contract_hash + artifact_hash` en el gate.
- Git checkpoints con fase-tag.
- `EVIDENCE_REGISTRY` con EV-001..EV-016 ligadas a claims.
- `DECISION_REGISTRY` con fecha, evidencia, reversibilidad.

### 4.2 Ataque

- **¿Está durable la provenance?** Depende del punto de la cadena. Los hashes viven en
  los eventos y en git; la asociación **hash ↔ artefacto** vive en git commits — persiste
  mientras el repo persista. Es "durable" en el sentido operativo.
- **¿Es completa?** No. La provenance rompe en dos puntos observados:
  - En el paso GATE→EVIDENCE_MASTER (§12 de `02`): el humano debe registrar la EV; si no
    lo hace, la task cerró pero la evidencia canónica no existe.
  - En el `EVENT-STREAM`: el evento tiene `action_hash` pero no vincula a un `task_id`
    real (14/18 comparten `F1-foundation-2026-09-16` como fixture); no hay provenance
    hacia una sesión de agente concreta.
- **¿Sobrevive a cambio de agente/proveedor?** Sí — es git + Markdown + JSONL. Es
  provider-independent.

### 4.3 Verdict

- CAP-3 → **SUPPORTED con incompletitud reconocida**. Existe, pero tiene dos "provenance
  breaks" observables (humano-mediado; fixture-vs-sesión).
- **Descubrimiento K3-D-CAP3**: la provenance de tarea de campo real no puede reconstruirse
  desde el EVENT-STREAM porque el schema no incluye `session_id` (siempre null) ni ata a
  la sesión conversacional que originó la tarea. Es un schema break, no un implementation
  break.

---

## 5. Ataque a CAP-4 — "Reversible state"

### 5.1 ¿Qué explica?

- Git como sistema de versiones para todos los artefactos del control plane.
- Ausencia de estado externo (todo vive en el repo).
- ARCH-001 (proyecto-scoped): no hay estado global.

### 5.2 Ataque

- **¿Todo estado es reversible?** El `EVIDENCE-MASTER` es append-only por convención;
  técnicamente puede editarse. Un revert de git recupera cualquier revisión. Sí,
  reversible.
- **¿A qué coste?** Un revert que afecte `PROJECT_STATE.md` requiere reconciliar con
  el `EVIDENCE_REGISTRY.md` — no es tarea mecánica; requiere humano.
- **¿La reversibilidad es sobre estado o sobre efectos?** Es sobre archivo. Los efectos
  (tools ya ejecutados, commits ya push'd) no son reversibles por el mismo mecanismo.

### 5.3 ¿Es una capacidad o un side-effect del sustrato?

Toda esta reversibilidad viene de **usar git**. No es una decisión del control plane;
es una propiedad del substrato. El control plane añade un checkpoint por fase (útil pero
no la capacidad en sí).

### 5.4 Verdict

- CAP-4 → **NOT A CAPABILITY OF CCP; is a substrate property (git)**.
- Reformulación: **PROP-4** (propiedad del sustrato) — el control plane la hereda pero
  no la produce.
- Consecuencia: **el análisis "5 root capabilities" mezcla capacidades y propiedades**.
  Este es un error de categorización que Kimi y el audit no detectan.

---

## 6. Ataque a CAP-5 — "Formalized learning loop"

### 6.1 ¿Qué explica?

- INC-001 → CTRL-001 → REG-001 → EV-006 (cadena completa observable).
- La convención de HRQS §12 del handbook.
- Los REG-002..REG-011 asociados a otras evidencias.

### 6.2 Ataque

- **¿Cuántos incidentes reales? UN INCIDENTE (INC-001).** El resto son adversarial
  fixtures (F-FALSE_PASS-01) o auto-bugs corregidos preventivamente (F7 bundle).
- **¿Existe el loop para eventos STALL?** No. Los 18 eventos actuales no están
  clasificados; ninguno tiene `had_alternative != null`; nadie ha promovido un STALL a
  INC.
- **¿Existe política operativa sobre "qué es un incident"?** No. La reconstrucción `02
  §15` confirma la ausencia.

### 6.3 ¿Es una capacidad activa o una política latente?

- **Capacidad activa** significa que el sistema opera el loop rutinariamente. No lo hace;
  operó una vez (INC-001).
- **Política latente** significa que hay una intención documentada pero sin ejecución
  regular. Esto describe mejor el estado actual.

### 6.4 Verdict

- CAP-5 → **NOT AN ACTIVE CAPABILITY; is a policy latency**.
- Reformulación: **POL-LATENT-5** — está diseñado pero sub-implementado. La única
  evidencia positiva es INC-001.
- **Descubrimiento K3-D-CAP5**: los 18 STALL events **son la evidencia empírica de que
  CAP-5 no opera** — un loop de aprendizaje que no clasifica sus propias observaciones
  no está aprendiendo. La ausencia de clasificación es diagnóstica.

---

## 7. Consecuencia: reformulación K3 de la Root Basis

Del ataque a CAP-1..CAP-5 emerge una reformulación asimétrica:

```text
CAP-1 → GAP-1 (carencia, no capacidad)
CAP-2 → BIFURCACIÓN: CAP-2-sintáctica (activa) + CAP-2-semántica (activa, humano)
CAP-3 → CAP-3 (activa, con provenance breaks)
CAP-4 → PROP-4 (substrate property, no ccp capability)
CAP-5 → POL-LATENT-5 (política latente, sub-implementada)
```

**El "minimum root basis" de K3 no es "5 capabilities". Es**:

```text
K3 MINIMUM ROOT BASIS:
  ACTIVE  : { CAP-2-sintáctica, CAP-2-semántica, CAP-3 }
  GAP     : { GAP-1 }
  LATENT  : { POL-LATENT-5 }
  SUBSTRATE PROP : { PROP-4 (from git) }
```

Esta reformulación **reduce el número de "capacidades a decidir por el Owner" de 5 a 2** —
CAP-2 se bifurca (dos decisiones distintas) y CAP-4 se elimina como decisión (es substrate).
GAP-1 sí requiere una decisión, pero es sobre **cómo cerrar la carencia**, no sobre "cómo
implementar la capacidad".

---

## 8. Ataque a `enforceable traceability` (propuesta por Claude, audit §24.1)

### 8.1 Enunciado

> "Toda acción importante deja un artefacto verificable que puede reproducir su
> justificación."

### 8.2 Test estructural

- ¿Aparece en múltiples subsistemas? Sí (5+: gate, INC-CTRL-REG-EV, STALL log, git
  checkpoints, decision registry).
- ¿Es primitiva o compuesta?
  - "enforceable" = requiere gate técnico. Ya lo tenemos en CAP-2-sintáctica.
  - "traceability" = requiere provenance. Ya lo tenemos en CAP-3.
  - "reproduce justification" = requiere derivación desde canónica (falta CAP-1) O
    revisión humana (existe).

### 8.3 Test de subsunción

- ¿Enforceable traceability = CAP-2-sintáctica ∪ CAP-3? **Aproximadamente sí**.
- El nombre "enforceable traceability" es una **etiqueta compuesta** para
  {gate + provenance}. Es útil como concepto de conversación pero no es una primitiva.

### 8.4 Verdict

- **`enforceable traceability` no es una root capability nueva; es una etiqueta
  compuesta.** No entra en la K3 minimum root basis. Se mantiene como observación
  descriptiva.

---

## 9. Descubrimiento K3 — la topología estrella

De `02 §7` y §6 aquí: el patrón "un árbitro humano central, muchos productores
paralelos, ningún verificador entre pares" es una **topología estrella**, no una
jerarquía anidada.

Consecuencias que la nomenclatura anidada no permite ver:

- **La carga del humano crece linealmente con el número de productores.** Si añadimos
  agentes, la fracción de tiempo humano dedicada a revisar sube proporcionalmente. Esto es
  un phase-transition candidate (ver `07_SCALING_AND_PROJECTION`).
- **No hay redundancia de verificación.** La única redundancia sería otro humano, que no
  existe estructuralmente.
- **La falla del humano es el single point of failure.** Ninguna nomenclatura anterior
  lo enuncia con esta agudeza.

**K3-D-STAR**: la topología real es "1 humano ← N productores autómatas ← 3 gates
técnicos". Esta descripción admite el mismo comportamiento que "trust boundaries anidados"
pero **hace visibles propiedades de escala** que la anidada oscurece.

---

## 10. Descubrimiento K3 — el defecto "entidades sin ciclo de vida"

Del audit §24.4 heredamos "research artifact" como tipo faltante. Al examinar el
código y los artefactos:

Entidades que **existen** pero **no tienen ciclo de vida gobernado**:

- **STALL events**: nacen; nunca son clasificados; nunca son cerrados; nunca son
  archivados. 14/18 son replays de un fixture obsoleto. No hay handler.
- **Research artifacts** (`docs/research/*`): nacen en un movimiento; nunca son
  promovidos a policy/incident/decision; nunca son marcados obsoletos; nunca son
  archivados.
- **Deferred items** (READY-*, F9-D02=B, A-05/07, G-N5): están "deferidos hasta trigger
  concreto"; el trigger no está declarado con una condición mecánica.

**K3-D-LIFECYCLE**: **estas tres son la misma clase estructural de defecto: entidades
sin lifecycle formal**. No son tres problemas independientes. Son manifestaciones de un
único hueco: "el control plane gobierna transiciones de tarea pero no gobierna transiciones
de artefacto". Este es un descubrimiento estructural genuino que ni Kimi ni Claude
formulan así.

Consecuencia: la solución no es "diseñar un lifecycle para research artifact"; es
**decidir si el control plane debe modelar lifecycles de artefacto** o **aceptar
explícitamente que no lo hace y externalizarlo al humano**.

---

## 11. Descubrimiento K3 — el schema-dead field

Verificado en §baseline: `had_alternative` está literalmente `:null` como constante en
`stall-record.sh:46`. `session_id` se emite `null` para todos los eventos observados.

Consecuencias:

- READY-03 asume "monitorear H-01 con umbral N". El log **no puede** ser el sensor de H-01
  con la instrumentación actual: el campo que discriminaría "hubo bypass alternativo" está
  literalmente hardcoded.
- Cualquier decisión Owner sobre READY-03 basada en "los datos del STALL log" está
  midiendo ruido de harness (14/18 son replays fixture) sobre un schema incompleto.
- **La decisión READY-03 tiene una dependencia oculta no declarada**: cambiar
  `stall-record.sh` para que `had_alternative` sea un input real y `session_id` se
  propague. Este cambio cruza el gate F9-D01 (autorización runtime).

**K3-D-SCHEMA**: la clasificación TP/FP de eventos no es un problema de análisis; es
un problema de instrumentación. Nombrarlo así **cambia el orden de las decisiones del
Owner** — READY-03 no puede resolverse antes de una decisión de instrumentación (que
requiere F9-D01 revisit).

---

## 12. Descubrimiento K3 — la duplicación es de segundo orden

Kimi observa: `.claude/rules/*.md` ↔ `bash-firewall.sh` = "duplicación". La reconstrucción
independiente `02 §12` reveló algo más específico:

- `.claude/rules/*.md` está en **estado template** (1/4 tiene `{{placeholders}}`).
- `bash-firewall.sh` tiene patrones que no aparecen en ningún `.md`.
- Ninguna capa es completa.

**La "duplicación" real no es entre dos representaciones completas; es entre dos
representaciones parciales**. No hay "sync manual"; hay "dos fuentes parciales que se
sincronizan por revisión humana ex-post". PAC lo detectó al intentar derivar patrones desde
los `.md` — descubrió que faltaban patrones en la propia canónica candidata.

**K3-D-PARTIAL**: **el problema no es la duplicación; es que ninguna de las dos capas
individualmente contiene la política completa**. Un motor de derivación no resuelve esto
sin antes decidir cuál es la fuente canónica y llenarla. Un motor sobre `no-go.md` con
placeholders derivaría una política parcial.

Este descubrimiento **debilita el caso para PAC como M009 automático**: PAC deriva desde
lo que existe, y lo que existe no es la política real.

---

## 13. Descubrimiento K3 — el árbol de decisiones tiene raíces cortadas

Kimi identifica 5 root decisions (R1..R5). La reformulación `CAP → GAP/BIFURCATION/
LATENT/PROP` implica un árbol distinto:

```text
Root operational decisions realmente pendientes (K3):

  D1a: ¿Cuál es la fuente canónica de política?  (respuesta a GAP-1)
         └── (a) rules/*.md, (b) firewall.sh regex, (c) tests, (d) YAML
  D1b: ¿Qué mecanismo mantiene la sincronización desde la canónica?  (condicional a D1a)
         └── (a) motor de derivación, (b) test-first, (c) revisión humana

  D2:  ¿Qué implementación queremos para CAP-2-semántica?  (era R1)
         └── (a) humano-git (actual), (b) segundo LLM adversarial, (c) segundo humano

  D3:  ¿Cuándo abrimos el gate F9-D01 para cambios de instrumentación?  (dependencia oculta)
         └── (a) sólo con INC nuevo, (b) trigger declarativo, (c) revisar por READY-03

  D4:  ¿Cerramos LABYRINTH-1 con la instrumentación actual o exigimos K3-D-SCHEMA primero?
         └── (a) cerrar con caveat, (b) instrumentar primero, (c) definir "materialidad" formalmente

  D5:  ¿El control plane debe modelar lifecycles de artefacto?  (respuesta a K3-D-LIFECYCLE)
         └── (a) sí, agregar registry, (b) no, delegar al humano, (c) parcial (research-only)

  D6:  ¿Ampliamos el trust boundary a runtime nativo?  (era R5, sin cambios)
```

**Cambios respecto al árbol de Kimi**:

- R3 → **D1a + D1b bifurcadas**. La decisión "cómo se representa la policy" tiene un
  ancestor no formulado: "cuál es la fuente canónica".
- R4 → **D4 con dependencia D3**. La decisión de cerrar LABYRINTH-1 no es independiente
  de la decisión sobre instrumentación.
- **D5 nueva**: sobre modelar lifecycles.
- Reordenamiento: **D3 (gate F9-D01) es upstream de D4**, no downstream. El árbol de Kimi
  las trata en paralelo.

---

## 14. Ataque a "compensation chains" (Kimi 06 §5)

Kimi observa 3 cadenas de compensación (política/verificador/campo). Aplicando la
K3 minimum root basis:

- **Cadena política**: `no derivación → duplicación → revisión humana ex-post → PAC como
  intento → HRQS como checklist manual`. Corresponde a GAP-1. Todos son parches;
  el nodo raíz es la ausencia de canónica.
- **Cadena verificador**: `no verificador semántico independiente → humano en commit →
  code-reviewer subagente → future dual-run adversarial`. Corresponde a CAP-2-semántica.
  Todos son implementaciones distintas de la misma capacidad.
- **Cadena campo**: `H-01 sin datos → had_alternative null → 14/18 replays de fixture →
  HRQS manual → query-log.sh`. Corresponde a K3-D-SCHEMA (schema-dead field).

**Descubrimiento colateral**: las 3 cadenas de Kimi mapean 1:1 a GAP-1 / CAP-2-semántica /
K3-D-SCHEMA. Sub-hallazgo: la meta-documentación creciente sobre CCP es probablemente
una **cuarta cadena de compensación**, esta vez por la ausencia de un modelo de
conocimiento (Kimi T4). Cuatro cadenas, no tres.

---

## 15. Structural survival matrix

Aplicando §75, §278:

| Estructura                       | ¿Sobrevive rename? | ¿Sobrevive provider swap? | ¿Sobrevive scale 10x? | ¿Sobrevive session restart? |
|---|---|---|---|---|
| CAP-2-sintáctica (hooks/evals)   | Sí                 | Sí (bash)                 | Sí (linear)           | Sí                          |
| CAP-2-semántica (humano)         | Sí                 | Sí                        | **Bottleneck 10x**    | Sí                          |
| CAP-3 (git+registries+events)    | Sí                 | Sí                        | Sí (log growth)       | Sí                          |
| GAP-1 (ausencia canónica)        | Sí                 | Sí                        | **Se agrava 10x**     | Sí                          |
| POL-LATENT-5 (learning loop)     | Sí                 | Sí                        | **Se agrava 10x**     | Sí                          |
| PROP-4 (git reversibility)       | Sí                 | Sí                        | Sí                    | Sí                          |
| Topología estrella               | Sí                 | Sí                        | **Rompe 10x**         | Sí                          |
| K3-D-SCHEMA (had_alternative)    | Sí                 | Sí                        | Se agrava             | Sí                          |
| K3-D-LIFECYCLE (artefactos)      | Sí                 | Sí                        | **Se agrava 10x**     | Sí                          |
| enforceable traceability (label) | Sí                 | Sí                        | Sí                    | Sí                          |
| "18→5 collapse"                  | N/A                | N/A                       | N/A                   | N/A                         |

Estructuras que **rompen o se agravan a 10× escala**: CAP-2-semántica, GAP-1,
POL-LATENT-5, topología estrella, K3-D-LIFECYCLE. Todas comparten un mecanismo:
**la única forma de escalarlas es aumentar el trabajo humano**. Esto es un
indicador de que la topología estrella no es sostenible bajo escala. Confirmado
en `07`.

---

## 16. Resumen ejecutivo del capítulo

- **CAP-1..CAP-5 heredado del audit se reformula asimétricamente**:
  CAP-1 → GAP-1; CAP-2 → bifurcada; CAP-3 → confirmada con brechas; CAP-4 → PROP-4;
  CAP-5 → POL-LATENT-5.
- **`enforceable traceability`** es una etiqueta compuesta, no una root capability.
- **Nuevos descubrimientos K3**:
  - K3-D-CAP2 (bifurcación sintáctica/semántica).
  - K3-D-CAP3 (schema break `session_id` en el event stream).
  - K3-D-STAR (topología estrella, no anidada).
  - K3-D-LIFECYCLE (3 problemas de artefacto = 1 clase estructural).
  - K3-D-SCHEMA (`had_alternative` hard-coded; READY-03 tiene dependencia oculta).
  - K3-D-PARTIAL (la "duplicación" es entre representaciones parciales).
- **El árbol de decisiones cambia**: 5 D-nodes con dependencias distintas (§13).

Todos los descubrimientos son insumo de `04_LATENT_STRUCTURES`, `10_ROOT_CAPABILITY_ANALYSIS`,
`11_ROOT_DECISION_ANALYSIS`, y `13_MASTER_OWNER_DECISION_SYSTEM`.
