# 11 — ROOT DECISION ANALYSIS

> Reconstrucción del decision space real de CCP. Cumple §18 (excavación), §19 (decisiones
> ocultas), §20 (root capability vs. root decision), §202 (absorption test), §203 (owner
> cognitive load).

---

## 1. Método

- Se listan **todas las decisiones observables** (tomadas, pendientes, latentes, ocultas).
- Se clasifican por: `ALREADY DECIDED / CURRENTLY OPEN / DERIVED / CONDITIONAL / DEFERRED
  / UNKNOWN / NOT-A-DECISION / HISTORICAL / ARCHITECTURAL / OPERATIONAL / OWNER-ONLY`.
- Se aplican los tests: parent/child, orthogonal, dependency, absorption, missing, lock-in.

---

## 2. Inventario de decisiones (todas)

### 2.1 Ya tomadas (11)

- ARCH-001..004 (activas).
- F8-A (contract_hash obligatorio).
- F8-B (malformed firewall payloads fail-closed).
- F9-D01..D05 (owner gate closed 2026-09-20).

### 2.2 Pendientes Owner (4)

- READY-01 (AC-02 classification).
- READY-02 (hook patterns).
- READY-03 (L1-C risk acceptance + N definition).
- READY-04 (message format).

### 2.3 Deferidos "hasta trigger" (4)

- F9-D02=B → runtime nativo Claude Code.
- A-05 → append-only enforcement.
- A-07 → externally-audited firewall.
- G-N5 → integrity work independiente.

### 2.4 Mal-clasificados por Kimi como decisiones (3, per audit §8)

- PAC production adoption → **proposal**, no decision con paquete.
- CDT-02 → **research track**.
- H-01 threshold → **sub-componente de READY-03**.

### 2.5 Ocultas identificadas por K3

- **D-INSTR**: cambiar `stall-record.sh` para que `had_alternative` y `session_id` sean inputs.
  Requiere F9-D01 revisit. Precondición de READY-03 empírica (K3-D-SCHEMA).
- **D-CATALOG**: enumerar y declarar "types of change × required gate" (K3-D-OWNER-DEFAULT).
- **D-LIFECYCLE**: gobernar lifecycles de research artifact / STALL events (K3-D-LIFECYCLE).
- **D-DELEG**: adoptar contrato de delegación explícito (Arquitectura E de `09`).
- **D-CANONICAL**: elegir fuente canónica de política (rules-md / firewall / tests / yaml).
- **D-MOTOR**: mecanismo de sincronización desde canónica (condicional a D-CANONICAL).
- **D-VERIFICADOR**: implementación de CAP-2-semántica (humano / LLM adversarial /
  segundo humano).
- **D-DEFERRAL-POLICY**: definir triggers mecánicos para deferrals abiertos.
- **D-META-DOC**: política sobre crecimiento de meta-documentación (aceptación, límite,
  archival).

### 2.6 UNKNOWNs con implicación decisional

- U-01, U-02 → afectan READY-03.
- U-03 → afecta F9-D02.
- U-04 → afecta D-MOTOR.
- U-05, U-09 → afectan D-VERIFICADOR.
- U-06 → afecta D-LIFECYCLE.
- U-11 → afecta D-CATALOG.

---

## 3. Verdad sobre "18 → 5 collapse"

Kimi presenta "18 decisiones visibles → 5 root decisions". El audit lo redujo a "15 reales
+ 3 mal-clasificados". K3 los desglosa correctamente:

- **11 tomadas** (no decisiones para reducir; son estado).
- **4 READY** (pendientes formales).
- **4 deferidas** (con trigger no declarado).
- **9 ocultas** (nuevas identificadas por K3).
- **3 mal-clasificadas** por Kimi.

**Total decisiones abiertas reales**: 4 READY + 4 deferidas + 9 ocultas = **17 decisiones
abiertas**. Muchas más que las "4 READY" que aparecen en el paquete owner.

### 3.1 ¿Colapsan a un conjunto menor?

Aplicando parent-child (§21):

- READY-01 y READY-02 → derivadas de **D-CANONICAL + D-MOTOR** (si Owner elige B en `09`).
- READY-03 → precondición **D-INSTR** (para tener data empírica).
- READY-04 → independiente (formato de mensaje).
- F9-D02 → depende de trigger externo o D-INSTR upstream.
- A-05, A-07, G-N5 → derivadas de trigger externo (S5 en `07`).
- D-CATALOG, D-LIFECYCLE, D-DELEG → ortogonales entre sí, mejoras transversales.
- D-CANONICAL + D-MOTOR + D-VERIFICADOR → **3 decisiones de arquitectura** que definen
  el punto de CCP en el espacio de `06`.
- D-DEFERRAL-POLICY, D-META-DOC → decisiones de proceso.

**Colapso K3**:

```text
BLOQUE A — Delegation Enablement (ortogonales, low-cost, first)
  D-CATALOG    catálogo de tipos de cambio × gate
  D-DELEG      contrato de delegación explícito
  D-LIFECYCLE  lifecycles mínimos (research/stall)

BLOQUE B — Policy Architecture (interconectadas)
  D-CANONICAL  ¿cuál es la fuente canónica de policy?
  D-MOTOR      ¿motor de derivación?  (condicional a D-CANONICAL)
  READY-01/02  se resuelven derivativamente cuando A y B se resuelven

BLOQUE C — Verification Delegation (independiente)
  D-VERIFICADOR ¿implementación CAP-2-semántica?

BLOQUE D — Data & Instrumentation (bloqueado por F9-D01)
  D-INSTR      cambiar schema hooks (had_alternative, session_id)
  READY-03     resoluble después de D-INSTR + N sesiones campo

BLOQUE E — Format & Process (independientes)
  READY-04     formato de mensaje
  D-DEFERRAL-POLICY  triggers declarativos para deferrals abiertos
  D-META-DOC   política de crecimiento meta-doc

BLOQUE F — External-triggered (esperan externalidad)
  F9-D02, A-05, A-07, G-N5  (S5 audit externo, S3 multi-proyecto)
```

**6 bloques, 12 decisiones reales, con dependencias declaradas**. Muy distinto del
"4 READY pendientes" que el paquete owner actual sugiere.

---

## 4. Absorption test (§88 y §202)

Para cada decisión candidata, ¿qué absorbe?

### 4.1 D-CANONICAL absorbe

- READY-01 (nuevo regex → editar canónica).
- READY-02 (nuevo hook pattern → editar canónica).
- Duplicación (por diseño).
- Parte de HRQS (que ahora es checklist manual para detectar drift).

Pero **NO absorbe**: CAP-2-semántica (verificar semántica es distinto), CAP-AUTHZ
(autorizar cambio a la canónica sigue requiriendo owner).

### 4.2 D-INSTR absorbe

- Todos los datos que READY-03 necesita.
- Parte de U-01 y U-02 (los hace observables; no resuelve).
- **NO absorbe** la decisión Owner sobre N (esa es aparte, requiere data que D-INSTR genera).

### 4.3 D-DELEG absorbe

- K3-D-OWNER-DEFAULT (elimina defaults implícitos).
- Ambigüedad de autoridad sobre schema, lifecycle, gate catalog.
- Absorbe **estructuralmente** una fracción de la carga humana futura (cuando delegaciones
  se activen).
- **NO absorbe** decisiones que legítimamente son del Owner (autorización de cambio de
  policy).

### 4.4 D-CATALOG absorbe

- K3-D-OWNER-DEFAULT parcialmente.
- Ambigüedad sobre "qué gate aplica a X change".
- **NO absorbe** decisiones internas de cada gate.

### 4.5 D-LIFECYCLE absorbe

- K3-D-LIFECYCLE.
- Growth silencioso de artefactos.
- **NO absorbe** la creación de research artifacts (sigue siendo actividad del agente).

### 4.6 Regla derivada

Ninguna decisión absorbe a otra "abajo" en el árbol. Las absorciones son laterales:
cada decisión de "bloque A / bloque D" absorbe **fricción** o **ambigüedad**, no elimina
otras decisiones.

**K3-D-ABSORPTION**: los bloques A y D **no reducen el número de decisiones Owner**;
**reducen la carga de decidir** al hacer explícito el espacio. Es un beneficio
epistemológico, no reducción numérica. Este es un descubrimiento sutil que el "decision
collapse" de Kimi confunde.

---

## 5. Dependency graph

```text
D-DEFERRAL-POLICY ──independiente
D-META-DOC       ──independiente
READY-04          ──independiente
─────────────────────────────────
D-CATALOG   ──feeds──▶ D-DELEG (D-DELEG needs categories to delegate)
D-LIFECYCLE ──feeds──▶ D-DELEG (delegation registry uses lifecycle categories)
D-DELEG    ──enables──▶ D-VERIFICADOR (delegation of CAP-2-semántica requires contract)
─────────────────────────────────
D-CANONICAL ──feeds──▶ D-MOTOR    (motor depends on canonical choice)
D-CANONICAL ──feeds──▶ READY-01/02 (their answer becomes derivative)
D-MOTOR    ──feeds──▶ U-04 resolution (post-deploy)
─────────────────────────────────
D-INSTR    ──enables──▶ U-01, U-02 observation
U-01 (data) ──feeds──▶ READY-03 (N definition needs field data)
─────────────────────────────────
F9-D01 gate  ──blocks──▶ D-INSTR (runtime change requires owner)
F9-D02 gate  ──blocks──▶ U-03 (native runtime observation)
External trigger ──blocks──▶ A-05, A-07, G-N5
```

**Root gates** (nodes que bloquean múltiples decisiones):

- **F9-D01=A** bloquea D-INSTR (y por tanto READY-03 empírico, U-01, U-02).
- **F9-D02=B** bloquea U-03 (nativo).
- **Ausencia de external trigger** bloquea A-05/07, G-N5.

**F9-D01 es el nudo dominante del decision graph**. Su reevaluación (aunque sea sólo para
permitir D-INSTR) desbloquea 3 UNKNOWNs y READY-03 empírica.

---

## 6. Ownership per decisión

| ID | Tipo | Owner | Delegable a K3-post? |
|---|---|---|---|
| D-CATALOG | GOVERNANCE | Owner | Sí (mecánicamente derivable de git log) |
| D-DELEG | GOVERNANCE | Owner | Sí (schema es mecánico; contenido owner) |
| D-LIFECYCLE | GOVERNANCE | Owner | Sí (schema mecánico; policy owner) |
| D-CANONICAL | ARCHITECTURE | Owner | No (elección estratégica) |
| D-MOTOR | ARCHITECTURE | Owner | No (elección estratégica) |
| D-VERIFICADOR | ARCHITECTURE | Owner | No (elección estratégica) |
| D-INSTR | ARCHITECTURE | Owner (requiere F9-D01) | No (cross gate) |
| D-DEFERRAL-POLICY | PROCESS | Owner | Sí (Markdown, cadencia) |
| D-META-DOC | PROCESS | Owner | Sí (política) |
| READY-01 | OPERATIONAL | Owner | Derivativo si D-CANONICAL resuelto |
| READY-02 | OPERATIONAL | Owner | Derivativo si D-CANONICAL resuelto |
| READY-03 | OPERATIONAL | Owner | Precondición D-INSTR + N sesiones |
| READY-04 | OPERATIONAL | Owner | Sí (formato) |

Observaciones:

- **9 de 13 decisiones abiertas son Owner-only genuinas**. Ninguna se puede automatizar.
- **4 pueden delegarse a K3-post** en forma parcial (schema derivable; content owner).
- **READY-01, READY-02, READY-03** son operacionales pero **cambian de naturaleza según
  decisiones arquitectónicas** upstream. No son "4 preguntas simples"; son "4 preguntas
  cuya respuesta depende de decisiones no formuladas aún".

---

## 7. Owner cognitive load projection

En estado actual:

- 4 READY pendientes.
- Los deferrals son "cerrados".

En estado K3-revealed:

- 13 decisiones abiertas reales, con dependencias.
- 3 gates root que bloquean múltiples.

**El Owner enfrenta ~3× la carga decisional que el paquete READY sugiere**. Esta carga no
es nueva; siempre estuvo latente. K3 la hace visible.

### 7.1 Reducción posible

- Bloque A (D-CATALOG, D-DELEG, D-LIFECYCLE) son **decisiones de proceso** que el Owner
  puede aprobar con schema pre-derivable. Coste cognitivo bajo si se presentan como
  drafts.
- Bloque E (READY-04, D-DEFERRAL-POLICY, D-META-DOC) idem.
- Bloques B, C, D son **decisiones estratégicas** que sí requieren juicio Owner y no
  pueden reducirse sin cambiar el problema.

**Reducción neta viable**: 6–8 decisiones "de proceso" con drafts pre-derivables + 4–5
decisiones estratégicas genuinas. Cognitive load pasa de "13 decisiones cada una desde
cero" a "4–5 decisiones con juicio + 6–8 aprobaciones de drafts".

---

## 8. Missing / hidden decisions

### 8.1 D-INSTR es el missing más importante

Kimi/Claude nunca lo listaron. Aparece porque K3-D-SCHEMA (had_alternative hardcoded)
demuestra que READY-03 depende de una decisión no formulada.

### 8.2 D-DELEG es el missing más útil

Kimi/Claude no lo listaron. K3-D-DELEG-ORTOGONAL (`09 §9`) muestra que es capa transversal
sobre todo.

### 8.3 D-DEFERRAL-POLICY es el missing más lento

Sin él, deferrals crecen indefinidamente (K3 §7 governance decay).

---

## 9. Decisions NOT owner-only

De la lista Kimi, algunas eran "decisiones aparentes" que K3 rechaza como owner-only:

- **PAC adoption**: **consecuencia** de D-CANONICAL=YAML y D-MOTOR=motor. No hay decision
  puntual "adoptamos PAC"; hay dos decisiones upstream.
- **CDT-02**: research track diferido; no owner decision aún.
- **H-01 threshold**: sub-componente de READY-03; se resuelve cuando D-INSTR y datos
  existen.

Depurando la lista de Kimi por este criterio, el owner tiene menos "decisiones
independientes" que las 18 originalmente contadas.

---

## 10. Lock-in analysis per decisión

- **D-CANONICAL**: alto (cambiar canónica a otra representación es doloroso).
- **D-MOTOR**: medio (motor puede reemplazarse si la canónica se mantiene).
- **D-VERIFICADOR**: medio (cambiar de humano a LLM y viceversa es factible).
- **D-INSTR**: bajo (schema puede evolucionar; migración con default null).
- **D-DELEG, D-CATALOG, D-LIFECYCLE**: bajo (Markdown-based).
- **READY-04**: bajo (formato de mensaje).
- **D-DEFERRAL-POLICY, D-META-DOC**: bajo (proceso).
- **F9-D01 revisit**: bajo (revocable).

**High lock-in**: D-CANONICAL únicamente. Todas las demás son reversibles con coste
moderado. Esto sugiere que **la decisión con más deliberación necesaria es D-CANONICAL**.

---

## 11. Decision reversibility ladder

```text
Fully reversible (git revert es suficiente):
  D-CATALOG, D-DELEG, D-LIFECYCLE, D-DEFERRAL-POLICY, D-META-DOC,
  READY-04, D-INSTR

Moderately reversible (require re-implementation):
  D-VERIFICADOR, D-MOTOR, READY-01, READY-02, READY-03

Hard to reverse (requires migration):
  D-CANONICAL

Externally triggered:
  F9-D02, A-05, A-07, G-N5
```

**D-CANONICAL** es la única "hard-to-reverse". Todas las demás pueden abordarse
incrementalmente.

---

## 12. Recommended sequence (K3 view, no owner override)

Bajo el análisis anterior, el orden natural (por dependencias + reversibilidad) sería:

1. **D-DELEG + D-CATALOG + D-LIFECYCLE** (Bloque A) — low-cost, transversal, mejora todo lo demás.
2. **D-DEFERRAL-POLICY** + **D-META-DOC** — procesos que detienen governance decay.
3. **READY-04** — trivial.
4. **D-CANONICAL** — decisión estratégica dominante.
5. **D-MOTOR** (condicional a 4).
6. **READY-01, READY-02** (derivativas de 4+5).
7. **D-INSTR** (requiere F9-D01 revisit para instrumentación).
8. **READY-03** (post D-INSTR + N sesiones).
9. **D-VERIFICADOR** (después de D-DELEG, con experimento).
10. **F9-D02, A-05, A-07, G-N5** — esperar trigger externo.

K3 **no** propone ejecutar esta secuencia; sólo la deriva. El Owner decide qué autorizar
y en qué orden.

---

## 13. Descubrimientos del capítulo

### 13.1 K3-D-DECISION-COUNT

Las decisiones abiertas reales de CCP son **13**, no 4. El paquete READY oculta 9 decisiones
adicionales (deferrals + hidden).

### 13.2 K3-D-F9D01-BOTTLENECK

F9-D01=A es el nudo dominante del decision graph. Su revisión (aunque limitada a
D-INSTR) desbloquea 3 UNKNOWNs y READY-03 empírica.

### 13.3 K3-D-CANONICAL-CENTRAL

D-CANONICAL es la única decisión con lock-in alto. Merece la deliberación más profunda.

### 13.4 K3-D-DELEG-FIRST

Bloque A (D-DELEG + D-CATALOG + D-LIFECYCLE) es low-cost, ortogonal y mejora todo lo
demás. Es el punto de entrada natural.

### 13.5 K3-D-COGNITIVE-LOAD-REDUCTION

La carga cognitiva puede reducirse mediante drafts pre-derivables (bloques A/E) sin
absorber decisiones que legítimamente requieren juicio Owner.

---

## 14. Verdict del capítulo

- **13 decisiones abiertas** reales, no 4.
- **6 bloques** con dependencias declaradas.
- **F9-D01=A** es el gate root que bloquea Bloque D.
- **D-CANONICAL** es la única high-lock-in decision.
- **Bloque A (delegation enablement)** es low-cost + ortogonal + mejora upstream.
- **Absorption es epistemológica, no numérica** (K3-D-ABSORPTION).
- **Cognitive load puede reducirse** con drafts pre-derivables sin absorber juicio.

Insumo directo para `13_MASTER_OWNER_DECISION_SYSTEM`.
