# 07 — SCALING AND PROJECTION

> Proyección 1×→10×→100× sobre agentes, políticas, proyectos, sesiones. Phase transitions
> (§26), socio-technical scaling (§320), governance decay (§322). Sin cifras inventadas.

---

## 1. Regla de proyección

- No se predicen métricas específicas.
- Se buscan **cambios cualitativos**: qué componentes escalan linealmente, cuáles
  super-linealmente, cuáles rompen.
- La evidencia base es la topología estrella (K3-D-STAR) y la lista de variables latentes
  del `04`.

---

## 2. Proyección por eje: agentes

### 2.1 1 agente (actual)

- Reviewer humano soporta la carga.
- HRQS §12 checklist opera.
- STALL log crece por evals, no por campo.

### 2.2 3–5 agentes

- Cada agente puede cerrar tareas independientemente.
- El gate GATE-BEFORE-TASK-CLOSURE opera en paralelo (sin contención mecánica).
- El reviewer humano acumula cierres a revisar.
- **Fase transition candidato**: cuando el número de cierres/día excede la
  capacidad-review/día del humano, la calidad de CAP-2-semántica degrada.
- No hay flag para detectar esa saturación (V5 reviewer-attention-budget sin instrumentación).

### 2.3 10 agentes

- Bajo topología estrella, cada agente contribuye linealmente al backlog del humano.
- **Nueva presión**: coordinación entre agentes (dos agentes editando el mismo archivo,
  proponiendo evidencia contradictoria). CCP actualmente no tiene mecanismo de
  resolución excepto el humano.
- **Nuevo requisito estructural**: la instrumentación `session_id` deja de ser opcional;
  sin ella, no puede reconstruirse quién hizo qué.

### 2.4 100 agentes

- **Ruptura**. La topología estrella colapsa: el humano no puede revisar 100 flujos.
- Alternativas:
  - Delegar CAP-2-semántica a segundo LLM adversarial (con riesgo de correlated failure).
  - Segmentar por dominio (proyectos), replicando CCP N veces (multiplica coste).
  - Cambiar arquitectura a **peer verification** (agentes se verifican entre sí bajo
    reglas mecánicas), lo cual requiere CAP-2-semántica mecanizable — actualmente
    UNKNOWN (U-05).
- **Phase transition inevitable**: no existe camino a 100 agentes bajo la arquitectura
  actual sin ruptura de la topología estrella.

---

## 3. Proyección por eje: políticas

### 3.1 1–10 políticas (actual)

- 23 policies en PAC prototype + 4 rules files. Manejable manualmente.
- Duplicación es un dolor local, no incapacitante.

### 3.2 100 políticas

- Cada política tiene entre 1–3 patrones. 300 patrones.
- La sincronización manual entre rules.md y firewall.sh **colapsa**: es humanamente
  imposible mantener sin error.
- PAC (o equivalente) deja de ser opcional; es prerrequisito.
- **Nueva presión**: interacción entre políticas (dos regex se solapan; una absorbe a la
  otra; una tiene precedence sobre la otra). Ni PAC ni el firewall actual manejan esto.

### 3.3 1000 políticas

- Interacción combinatoria: N×N pares potenciales. Sin un catálogo/DSL que declare
  prioridades, ordenamiento, y compatibilidad, el sistema **produce comportamiento no
  determinístico o no revisable**.
- **Nueva capability requerida**: `policy-interaction-model` (no existe).
- **Phase transition**: alrededor de 100–300 políticas, la estructura "regex plana"
  deja de ser suficiente y se requiere una gramática o esquema jerárquico.

---

## 4. Proyección por eje: proyectos

### 4.1 1 proyecto (actual, ARCH-001)

- El scope proyecto-only mantiene el trust boundary pequeño.
- Todos los artefactos viven en el repo.

### 4.2 10 proyectos con CCP replicado

- Cada proyecto es un CCP independiente. Consistencia entre proyectos es humana.
- Costo: 10× reviewer + 10× drift potencial en cómo cada proyecto implementa las
  mismas convenciones.
- **Nueva presión**: divergencia entre políticas de proyectos. Un cambio en la
  política canónica debe replicarse 10 veces.

### 4.3 10 proyectos con CCP compartido (fedederado)

- Un solo CCP con proyecto-scope removido → contradice ARCH-001.
- Alternativa: CCP-core compartido + CCP-project-overlays. No implementado.
- **Phase transition**: multi-proyecto requiere abandonar ARCH-001 o federar. Es una
  decisión Owner futura, no urgente.

---

## 5. Proyección por eje: sesiones LLM

### 5.1 1 sesión (típico hoy)

- SessionStart inyecta contexto.
- Meta-doc se lee en la sesión.
- Fidelidad de contexto acotada por compaction.

### 5.2 10 sesiones en secuencia

- Handoffs (61A..61G) demuestran el patrón actual.
- Cada handoff pierde información; se compensa con nueva doc.
- **La meta-doc crece como respuesta**. K3-D-EXOGENOUS predice esto.

### 5.3 100 sesiones

- La meta-doc puede exceder capacidad de contexto de una sola sesión. El SessionStart hook
  ya inyecta ~5KB; escalar a proyectos con años de historia rompe.
- Se requiere **memoria persistente selectiva** (mem-search skill, MCP), no meta-doc
  linear.
- **Phase transition**: cuando meta-doc > contexto inyectable, el sistema deja de
  auto-reproducirse por handoff.

---

## 6. Cross-projections (§321 socio-technical)

### 6.1 10 agentes × 100 políticas

- Cada agente potencialmente triggerea múltiples policies por acción.
- Explosión de eventos en STALL log.
- Sin schema completo y automated triage, el log es inutilizable.
- **Requisito conjunto**: E8 schema-complete + E5 automated triage. Ambos ausentes hoy.

### 6.2 10 proyectos × 10 agentes

- 100 flujos paralelos. Reviewer humano por proyecto o federado.
- Sin catalog de authorization scope (E9), cada proyecto reinventa gates.

### 6.3 100 sesiones × 10 movimientos por sesión

- 1000 research artifacts. Sin lifecycle (K3-D-LIFECYCLE), el corpus es inmanejable.
- **Requisito**: registry/lifecycle mínimo. Actualmente ausente.

---

## 7. Governance decay analysis (§322)

Sin trigger declarativo para diferimientos (F9-D02=B, A-05, A-07, G-N5), la deuda
epistemológica (K3-D-EPIST-COST) crece monótonamente:

```text
t0: 4 diferimientos abiertos, cada uno "hasta trigger concreto"
t1: 4 diferimientos + 2 nuevos + 0 cerrados
t2: 6 + 3 + 0
...
tN: N nuevos diferimientos, 0 cerrados
```

Sin política de expiración o revisión periódica, **el sistema acumula deferrals hasta que
todo es diferido**. Governance decay by attrition. Actualmente no observable porque la
tasa es baja (~2/año), pero **el mecanismo estructural para el decay existe**.

**Mitigación estructural**: convertir "diferido hasta trigger" en "diferido hasta X
condición mecánica o revisión trimestral". Es una decisión de proceso, no runtime.

---

## 8. Phase transitions identificadas

| # | Punto | Condición | Naturaleza |
|---|---|---|---|
| PT-1 | reviewer saturation | cierres/día > capacidad-review/día | socio-technical |
| PT-2 | policy interaction | ~100–300 policies | technical/semantic |
| PT-3 | meta-doc > context | ~100 sesiones acumuladas | substrate-technical |
| PT-4 | multi-project | 2do proyecto adopta CCP | organizational |
| PT-5 | authorization catalog gap | 3–5 nuevos tipos de change sin gate | governance |
| PT-6 | schema saturation | 10⁴+ eventos sin instrumentación | epistemic |

Cada phase transition tiene su propia mitigación:

- PT-1 → V5 instrumentación + delegación de CAP-2-semántica.
- PT-2 → gramática/DSL de policies o segmentación.
- PT-3 → memoria persistente selectiva.
- PT-4 → federación o abandono ARCH-001.
- PT-5 → catálogo declarativo (E9).
- PT-6 → K3-D-SCHEMA + E5 automated triage.

Ninguna de estas mitigaciones es urgente hoy; todas son **decisiones que el Owner
enfrentará antes de la próxima phase transition**.

---

## 9. Escenarios extremos (§66 y §174)

### 9.1 S1 — CCP sigue en escala actual

- Sin cambios: opera bien; K3-D-EPIST-COST crece lentamente.
- Decisiones READY-01..04 pueden diferirse indefinidamente.
- El sistema se convierte progresivamente en "doc + convención humana con hooks básicos".

### 9.2 S2 — CCP escala 10× en agentes

- PT-1 activa. Necesidad de instrumentación (V5).
- HRQS deja de ser suficiente; requiere automatización de triage.

### 9.3 S3 — Multi-proyecto

- PT-4 activa. Decisión Owner sobre federación vs. replicación.
- ARCH-001 revisit.

### 9.4 S4 — Cambio de proveedor LLM

- F9-D02 revisit forzado por externalidad.
- La abstracción hook-based sobrevive (bash, no Claude-specific).
- La skill/agent abstraction es más Claude-specific; requiere audit.

### 9.5 S5 — Compliance / audit externo obligatorio

- F9-D04 revisit forzado. A-05/A-07/G-N5 dejan de ser diferibles.
- El humano puede dejar de ser suficiente como trust boundary (auditor externo requiere
  provenance más rica).
- CAP-3 con brechas pasa a ser un problema.

### 9.6 S6 — Substrate cambia (LLM con memoria persistente verificable)

- Meta-doc colapsa. Handoffs innecesarios.
- El >30% de complejidad substrate-derivada (K3-D-SUBSTRATE-FRACTION) libera espacio para
  problemas antes ocultados.

---

## 10. Robustez arquitectónica bajo escenarios

Matriz simplificada:

```text
                          S1 stable  S2 10x  S3 multi  S4 provider  S5 audit  S6 substrate
CAP-2-sintáctica          OK         OK      OK        OK           OK        OK
CAP-2-semántica humana    OK         BREAK   BREAK     OK           BREAK     REDUCED
CAP-3 (with gaps)         OK         WEAKEN  WEAKEN    OK           BREAK     OK
GAP-1 (no canonical)      OK         BREAK   BREAK     OK           BREAK     OK
K3-D-SCHEMA               STAB       WEAKEN  BREAK     OK           BREAK     OK
K3-D-LIFECYCLE            STAB       WEAKEN  BREAK     OK           WEAKEN    IMPROVED
K3-D-OWNER-DEFAULT        STAB       BREAK   BREAK     OK           BREAK     OK
Meta-doc growth           STAB       WORSE   WORSE     OK           OK        RESOLVED
Star topology             STAB       BREAK   BREAK     OK           BREAK     OK
```

Observaciones:

- **S1 (stable)**: todo opera. Estado presente es un óptimo local.
- **S2 (10× agentes)**: 5 elementos rompen. Es la ruptura más probable a mediano plazo.
- **S3 (multi-proyecto)**: 5 elementos rompen. Es la ruptura más probable a largo plazo.
- **S4 (provider)**: casi todo sobrevive. CCP es provider-independent excepto en la capa
  agent/skill.
- **S5 (audit externo)**: 5 elementos rompen. Es la ruptura más probable por externalidad.
- **S6 (substrate)**: el crecimiento de meta-doc y K3-D-LIFECYCLE se resuelven o mejoran.
  Es el único escenario que **reduce** deuda estructural en lugar de agravarla.

---

## 11. Distancia arquitectónica al siguiente escenario

Estimación cualitativa de "cuánto trabajo estructural se necesita para sobrevivir a X":

- S1 → **nada** (estamos en él).
- S2 → **medio-alto**: requiere instrumentación V5, delegación CAP-2-semántica parcial,
  automated triage, catálogo de gates.
- S3 → **alto**: requiere federación de CCP, revisar ARCH-001.
- S4 → **bajo**: audit de skill/agent abstraction; el resto pasa.
- S5 → **alto**: hardening de provenance, verificación independiente formal, auditoría de
  invariantes.
- S6 → **bajo (pero exógeno)**: no requiere trabajo interno; requiere que el substrato
  evolucione.

**Insight**: la mayor distancia arquitectónica al mundo real es hacia S5 (audit externo).
Sin evidencia de externalidad regulatoria, F9-D04=B es una elección coherente. Con
evidencia, es una deuda que se cobrará caro.

---

## 12. Verdict del capítulo

- **6 phase transitions** identificadas; ninguna urgente hoy.
- **S1 (estable) es un óptimo local**; toda arquitectura alternativa es más cara.
- **S2, S3, S5** son los escenarios con mayor riesgo estructural; requieren mitigaciones
  distintas.
- **CCP es provider-independent en el 90% de su superficie** (S4 barato).
- **Sólo S6 (substrato con memoria) reduce deuda**; los demás la aumentan.
- **La deuda epistemológica K3-D-EPIST-COST y el governance decay by attrition** son las
  fuerzas más lentas pero monotónicas — sin trigger declarativo, crecen indefinidamente.
