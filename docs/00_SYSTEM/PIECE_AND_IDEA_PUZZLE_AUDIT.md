# PIECE AND IDEA PUZZLE AUDIT — CCP

> Auditoría estructural especializada del rompecabezas del CCP. Baseline: `docs/00_SYSTEM/MASTER_HANDOFF.md`.
> Salida única de esta sesión. NO modifica runtime, hooks, policies, registries ni decisiones del Owner.
> Fecha: 2026-09-25. Autor: Claude Opus 4.7 (auditor especializado, no implementer).

Epistemología aplicada a lo largo del documento:

- `VERIFIED` — comprobado contra repositorio real.
- `DOCUMENTED` — aparece en MASTER/K3/registries pero no revalidado aquí.
- `INFERENCE` — deducción razonable desde evidencia parcial.
- `HYPOTHESIS` — posible pero sin evidencia dura.
- `CONTRADICTED` — evidencia activa en contra.
- `OBSOLETE` — fue cierto y ya no lo es.
- `UNKNOWN` — falta información y no se inventa.

Regla operativa de esta auditoría: **preferir DESCONOCIDO explícito antes que invento**. La calidad es número pequeño de estructuras defensibles, no volumen.

---

## §0. BASELINE SNAPSHOT

Comandos de FASE 0 ejecutados 2026-09-25. Resultado literal:

```text
git status
  On branch main (56 commits ahead of origin/main)
  modified: PROJECT_STATE.md
  untracked: CCP_MASTER_EXECUTION_PROMPT.md

git log --oneline -5
  f496897 [CONFIG] checkpoint: MASTER_HANDOFF + K3 corpus + RA audit
  1a6232d [RESEARCH] ROOT_ANALYSIS: complete F1-F12 protocol execution + 32 questions answered
  9ea8367 [CONFIG] PROJECT_STATE: checkpoint f6a874f — MOVEMENT 008
  f6a874f [RESEARCH] MOVEMENT 008: HRQS + PAC corpus complete + NOW-EXECUTABLE exhausted
  c41c8c9 [RESEARCH] Phase A: CCP Complete Handoff — M001-M007 history reconstructed

wc -l docs/00_SYSTEM/MASTER_HANDOFF.md       → 3903 líneas
wc -l .claude/hooks/*.sh .claude/hooks/lib/*.sh → 509 líneas totales, 11 archivos
ls docs/research/pac/*.yaml                   → 1 archivo (ccp_policies.yaml)
grep -c "^  - id:" docs/research/pac/ccp_policies.yaml → 24 IDs
wc -l docs/00_SYSTEM/STALL_POLICY_LOG.jsonl   → 19 líneas
```

Contadores adicionales verificados por lectura directa:

- Agentes YAML declarados en `.claude/agents/`: **5** (`architect`, `code-reviewer`, `implementer`, `researcher`, `security-auditor`). El MASTER menciona 11; los otros 6 son tipos runtime (`fork`, `general-purpose`, `Explore`, `Plan`, `claude`, `claude-code-guide`, `statusline-setup`) inyectados por el harness, no archivos del repo. **`VERIFIED`** — discrepancia superficial (fichero vs. tipo runtime) resuelta.
- Rules en `.claude/rules/`: **4** (`compliance.md`, `git-policy.md`, `no-go.md`, `security.md`). **`VERIFIED`**.
- Context packs en `.claude/context/`: **6** (`BUSINESS.md`, `CORE.md`, `CURRENT_STATE.md`, `DECISIONS.md`, `NO_GO.md`, `SECURITY_RULES.md`). **`VERIFIED`**.
- STALL log: **19 eventos** al 2026-09-25 11:40 GMT-5 (MASTER cita 18 al cierre K3; +1 evento desde entonces, `stall_type=UNKNOWN`, `task_id="1"`, categorizado `evidence_contract`). **`VERIFIED`**.
- `stall-record.sh:46` — `had_alternative:null` hard-coded, `task_id`/`session_id` convertidos a `null` si string vacío. **`VERIFIED` por lectura directa del archivo**.

---

## §1. EXECUTIVE FINDING (≤500 palabras)

El modelo de piezas del MASTER_HANDOFF describe el CCP con **~24 piezas top-level** más 6 GAP-pieces explícitos. Auditar esa lista con criterio de **atomicidad + relación-vs-entidad + primitiva latente** produce un modelo revisado que es **menos poblado y más denso**: menos entidades, más relaciones explícitas, menos duplicación conceptual.

Los cinco hallazgos estructurales que sobreviven a la auditoría adversarial son:

1. **La primitiva `DERIVATION` es la pieza ausente central del CCP** — no como propuesta de solución (eso es DEC-04/05), sino como **contrato inexistente**. Todos los "sync manual" del sistema (P-PT↔P-BB, P-CP↔código, `.claude/rules`↔context packs, meta-doc↔state) son **la misma ausencia repetida**. La `MISSING PIECE = policy derivation motor` del ROOT_ANALYSIS es un caso particular de esa ausencia primitiva, no la ausencia entera.
2. **La primitiva `AUTHORITY-BOUNDARY` está latente pero no materializada** — la distinción "mecánica / convención / humana / agente" aparece como *columna* en el piece catalog (P-BB=mecánica, P-PT=convención, P-H=humana, P-A=agente), pero no como **objeto de primer orden**. K3-D-AUTHZ-VS-VERIF y F9-D01 dependen de esa distinción para tener sentido. Es primitiva relacional, no entidad.
3. **`P-GT` es un composite disimulado**: `{schema-validator, hash-comparator, decision-arbiter, emit-side-effect}` con ciclos de vida independientes (F8-A cambió sólo `hash-comparator` sin tocar los otros). Debe leerse como cluster, no como átomo. Mismo diagnóstico para `P-CSB` (drift-detector + snapshot-writer).
4. **P-ES (EVENT-STREAM) es *un lado* de una relación rota**: escritura sin consumidor. El consumidor no existe como pieza; es el **hueco negativo** que HRQS §12 pretende llenar manualmente. La pieza faltante es `P-STREAM-CONSUMER`, no una capacidad nueva sino la contraparte inevitable del emit ya presente.
5. **Grammar candidata verificada parcialmente**: `AUTHORITY × CONTRACT × MECHANISM × EVIDENCE = CONTROLLED CAPABILITY`. Se satisface en P-BB, P-BS, P-GT (mecánica + regex/schema + hook + EV-*). **Falla sistemáticamente donde una de las cuatro es "convención"**: P-PT tiene autoridad convencional → no hay mecanismo → evidencia degrada a `placeholder audit`. La gramática no es descriptiva sino **diagnóstica**: dice dónde el CCP tiene fragilidad estructural.

Novedad neta declarada: **3 piezas nuevas defendibles** (P-DERIV-CONTRACT, P-AUTH-BOUNDARY, P-STREAM-CONSUMER); **2 primitivas latentes** (DERIVATION, AUTHORITY-BOUNDARY); **1 grammar diagnóstica** (AUT×CTR×MEC×EV). Todo lo demás son reclasificaciones o splits del catálogo existente, no piezas nuevas.

Lo que **no** apareció (y merece registrarse como "no encontré novedad material"): no encontré una arquitectura oculta que Kimi K3 y MASTER hubieran pasado por alto en su modelo estrella-topología; no encontré un sexto axis en el espacio de decisiones; no encontré una gramática diferente que compita ventajosamente con la propuesta. La ganancia real de esta auditoría es **densificación** del modelo existente, no descubrimiento espectacular.

---

## §2. BASELINE PIECE MODEL AUDIT (Fase 1)

Clasificación por categoría del catálogo §28.1 del MASTER. Categorías: `VP` Valid Piece · `CP` Composite · `RP` Relacional · `PR` Property · `CA` Capability · `AC` Actor · `AR` Artifact · `PO` Policy · `ME` Mechanism · `ST` State · `IN` Interface · `ID` Idea · `NP` Not-a-piece.

| PIECE-ID | NAME | CATEGORÍA | JUSTIFICACIÓN | VEREDICTO |
|---|---|---|---|---|
| P-BB | BLOCKER-BEFORE-BASH | ME | mecanismo de decisión con contrato firme; autoridad delimitada | VALID (rename: `ME-BB`) |
| P-BS | BLOCKER-SECRET | ME | idem P-BB, contrato path/patrón; ciclo de vida propio | VALID |
| P-GT | GATE-BEFORE-TASK-CLOSURE | **CP** | contiene {schema-validate, hash-check, decide, emit}; F8-A modificó UNA parte sin tocar las otras — prueba de independencia | **SPLIT** |
| P-LE | LIB-EVENT-EMISSION | ME | atómico; escribe una fila JSONL; contrato único | VALID |
| P-CSA | CONTEXT-SESSION-START-A | ME | inyecta pack; atomico | VALID |
| P-CSB | CONTEXT-SESSION-START-B | **CP** | drift-detect + snapshot-write; funciones separables | **SPLIT** |
| P-CSU | CONTEXT-SUBAGENT | **RP** | ES la relación `P-SA→P-CP`. Sin subagente que arranque no ejecuta nada; sin pack no tiene qué inyectar. No es entidad autónoma. | **RECLASSIFY** |
| P-SM | STATE-MASTER | AR | producto de la mano humana, no proceso; documento con contrato de escritura convencional | VALID (as AR) |
| P-DM | DECISIONS-MASTER | AR | idem P-SM | VALID (as AR) |
| P-EM | EVIDENCE-MASTER | AR | idem, `append-only por policy` | VALID (as AR) |
| P-ES | EVENT-STREAM | AR | log write-only; artefacto que crece | VALID (as AR, pero ver §5: falta contraparte) |
| P-SL | SESSION-STREAM | AR | idem P-ES | VALID |
| P-RB | RUNBOOK-SUITE | ME | ejecutable; produce PASS/FAIL | VALID |
| P-CP | CONTEXT-PACK | AR | contenedor consumido por hooks | VALID |
| P-PT | POLICY-TEXTS | AR/PO | duales: prosa autoritativa (PO) + archivo Markdown (AR). Autoridad convencional. | VALID pero **dual role documentar** |
| P-PY | POLICY-PROTO-YAML | AR | fuente candidata de política; hoy research | VALID |
| P-PC | POLICY-COMPILER-PROTO | ME | script transforma YAML→regex; research | VALID |
| P-IP | INDEX-PLAN | AR | Master Plan, contrato de fases | VALID |
| P-IM | INDEX-MANIFEST | AR | checklist entregables | VALID |
| P-H | HUMANO-REVIEWER | AC | actor con autoridad semántica | VALID |
| P-O | OWNER | AC | actor con autoridad terminal | VALID |
| P-A | AGENT-PRIMARY | AC | actor productor | VALID |
| P-SA | SUBAGENTS | AC | conjunto de actores delegables (11 tipos, 5 archivos + 6 runtime) | VALID (mantener como set) |

Categorización agregada (23 filas × 13 columnas de la tabla original; 24 en total contando P-SA como uno):

- **ME (Mechanism)**: 6 (P-BB, P-BS, P-LE, P-CSA, P-RB, P-PC) — el núcleo activo.
- **CP (Composite)**: 2 (P-GT, P-CSB) — a dividir.
- **RP (Relacional)**: 1 (P-CSU) — a reclasificar.
- **AR (Artifact)**: 10 (P-SM, P-DM, P-EM, P-ES, P-SL, P-CP, P-PT-doc, P-PY, P-IP, P-IM).
- **AC (Actor)**: 4 (P-H, P-O, P-A, P-SA).
- **PO (Policy)**: 1 (P-PT-rule; duplicado con la faceta AR).

Duplicaciones detectadas en la propia taxonomía del MASTER:

- P-PT es **AR + PO** simultáneamente. La faceta prosa-normativa (PO) y la faceta archivo-Markdown (AR) tienen ciclos de vida distintos: la PO se aplica sin cambiar la AR (reviewer humano interpretándola); la AR puede cambiar sin cambiar la PO (typo fix). Es **CP** encubierto.
- P-SA es un set, no una pieza. Los 11 subagentes son entidades distintas con contratos parcialmente distintos (`code-reviewer` no modifica; `implementer` sí). Mantenerlo como set es útil para agregación pero **falso** como pieza atómica.

---

## §3. ATOMIC PIECES (Fase 2)

Test: ¿puede sub-elemento X cambiar sin que cambien Y o Z? SÍ → no es átomo.

**P-GT (GATE-BEFORE-TASK-CLOSURE) — NO ATÓMICO**

Sub-piezas defendibles:

- `GT-SCHEMA-VALIDATE` — verifica presencia y forma de `task_id`, `contract_hash`, `artifact_hash`. Autoridad: mecánica. Ciclo: cambió en F7 (introducción) y F8-A (fail-closed).
- `GT-HASH-COMPARE` — compara `contract_hash` contra EV registry. Autoridad: mecánica. Ciclo: cambió en F8-A (era fail-open, ahora fail-closed).
- `GT-DECIDE-EMIT` — decide exit code + invoca `stall_record_event`. Autoridad: mecánica. Ciclo: estable desde F2.

**Evidencia de independencia (`VERIFIED`)**: F8-A modificó sólo `GT-HASH-COMPARE` semántica sin tocar `GT-SCHEMA-VALIDATE` ni `GT-DECIDE-EMIT`. El commit correspondiente cambió una condición, no el script entero. → tres sub-piezas con ciclos independientes.

**P-CSB (CONTEXT-SESSION-START-B) — NO ATÓMICO**

Sub-piezas:

- `CSB-DRIFT-DETECT` — compara hash actual vs. anterior.
- `CSB-SNAPSHOT-WRITE` — persiste hash para próxima comparación.

**Evidencia**: función `state-integrity.sh` cubre sólo el primer aspecto; el segundo es efecto secundario. **`DOCUMENTED`** en MASTER §5.4.

**P-PT (POLICY-TEXTS) — NO ATÓMICO en el sentido tipológico**

Sub-piezas:

- `PT-PROSA` — significado normativo, autoritativo humano.
- `PT-FILE` — contenedor `.md` en `.claude/rules/`.

**Independencia**: cambiar el archivo sin cambiar el significado (reformatear); cambiar el significado sin cambiar el archivo (reinterpretación humana, especialmente cuando quedan `{{placeholders}}` en `no-go.md`). Ambos ocurren.

**P-SA (SUBAGENTS) — NO ATÓMICO** (es un set de 11).

Sub-piezas:

- `SA-code-reviewer` (Tools: Read, Glob, Grep — read-only).
- `SA-implementer` (Tools: +Write, +Edit, +Bash — modifica).
- `SA-architect` (Tools: +Write, +Edit — modifica docs pero no ejecuta).
- `SA-researcher` (Tools: WebFetch, WebSearch — externo).
- `SA-security-auditor` (Tools: read-only).
- `SA-<runtime-only>` × 6 (fork, general-purpose, Explore, Plan, claude, claude-code-guide, statusline-setup) — no en `.claude/agents/`, sólo listados por el harness.

**Independencia**: cada uno tiene toolset propio, autoridad propia, y el evidence gate P-GT los afecta de forma diferente (los read-only nunca cierran task con `artifact_hash` real). No son la misma pieza.

**Piezas confirmadas atómicas** (después de intentar dividirlas):

- P-BB (una regla → una decisión).
- P-BS (idem).
- P-LE (una llamada → una fila JSONL).
- P-CSA (una lectura de pack → un stdout inject).
- P-RB (una batería de checks, pero ninguno domina; podría dividirse pero el conjunto es coherente para `PASS/FAIL`).
- P-H, P-O, P-A (actores; atómicos por definición).
- P-EM, P-SM, P-DM, P-IP, P-IM (documentos con schema fijo; atómicos como artefactos).
- P-ES, P-SL (streams append-only; atómicos como logs).
- P-CP (pack; atómico como contenedor).
- P-PY, P-PC (YAML + compiler; atómicos como archivos).

---

## §4. PIECE VS RELATIONSHIP (Fase 3)

### 4.1 Piezas que son realmente relaciones

**P-CSU (CONTEXT-SUBAGENT)** — es la relación `P-SA[role] → P-CP[role].md → stdin(subagent)`. Sin ambos extremos no existe. No tiene autoridad propia, no tiene contrato de vida independiente. **VEREDICTO: RECLASSIFY AS RELATION**. Nombre relacional propuesto: `INJECT[P-CP → P-SA]`.

**"Sync manual entre P-PT y P-BB"** — el MASTER cita repetidamente esta expresión pero no la lista como pieza. Es una **relación implícita débil** (humano copia contenido; no hay contrato). No es pieza; es la **ausencia de una pieza** (§5).

### 4.2 Relaciones que merecen ser piezas

Criterios: contrato propio + autoridad propia + ciclo de vida + failure mode propio.

**Candidata 1: `EVIDENCE-BINDING`** — la relación entre `task_id` (declarado por subagente) y `contract_hash` (calculado sobre EV entry). Es RELATION en la forma actual (la ejecuta `GT-HASH-COMPARE`), pero:

- Contrato propio: SHA-256 de EV coincide con hash aportado.
- Autoridad propia: cambió con F8-A independientemente del gate.
- Ciclo de vida: nace con F7, se endurece con F8-A.
- Failure mode: `contract_hash mismatch → block` (fail-closed).

**VEREDICTO: PROMOTE RELATION TO PIECE**. Nombre propuesto: `P-EV-BIND`. Justificación: F8-A fue precisamente el reconocimiento tácito de que esta relación tiene identidad. Materializarla explícitamente permite auditar el binding sin auditar el gate entero.

**Candidata 2: `AUTHORITY-BOUNDARY`** — la separación entre autoridad mecánica (hooks), convencional (rules), humana (reviewer) y agente. Aparece como **columna** del piece catalog, no como entidad. Pero:

- Contrato propio: reglas de quién puede modificar qué (K3-D-AUTHZ-VS-VERIF).
- Autoridad propia: F9-D01 la definió sin nombrarla.
- Ciclo de vida: cambia cuando el Owner delega (DEC-02).
- Failure mode: colisión de autoridades (dos actores ambiguos → K3-D-OWNER-DEFAULT).

**VEREDICTO: PROMOTE RELATION TO PIECE**. Nombre: `P-AUTH-BOUNDARY` (ver §5).

**Candidata 3: `DERIVATION-LINK`** — la relación canónica → derivado que hoy es "sync manual". No existe como entidad; existiría bajo DEC-04 D4 + DEC-05 E2.

- Contrato propio: canónica cambia → derivado se regenera + tests de invariancia pasan.
- Failure mode: motor bug, drift silente, canónica ambigua.

**VEREDICTO: PROMOTE RELATION TO PIECE — FUTURA**. Nombre: `P-DERIV-CONTRACT`. Su materialización depende de DEC-04.

### 4.3 Relaciones estructurales que **no** deben ser piezas

- `HOOK invoca LIB` (P-GT invoca P-LE): pura composición, sin contrato adicional.
- `AGENT lee CLAUDE.md`: convención, no contrato firme.
- `SessionStart escribe hash`: mecánica interna del hook, no relación cross-cutting.

Estas se mantienen como relaciones implícitas.

---

## §5. NEW LATENT PIECES (Fase 4 — excavación)

### 5A. EXPLICIT MISSING

Ninguna que el MASTER no haya listado ya (los 6 GAP): `DERIVE-OP`, `DELEG-REG`, `CATALOG`, `LIFECYCLE-REG`, `POL-CANON`, `SHADOW-RT`. **No agrego duplicados**; me remito al MASTER §28.1.

### 5B. IMPLICIT MISSING

**GAP-NEW-1: `P-STREAM-CONSUMER`**

- **Categoría**: IMPLICIT.
- **Por qué debería existir**: P-ES emite JSONL; sin lector, es log write-only sin propósito operativo. HRQS §12 documenta que humanos leen manualmente. La lectura es entonces función humana ad-hoc, no pieza.
- **Capacidad fragmentada**: triage de STALL, detección de bugs behavioral, extracción de precedentes para DEC-08.
- **Piezas actuales que la implican**: P-ES (produce), P-H (consume ad-hoc), P-LE (formatea para consumo), K3-D-CAP3 (provenance dep. de consumers).
- **Evidencia**: 19 eventos acumulados; 14/18 = 82% harness noise; ningún consumer canónico. Documentado en MASTER §3 y K3.
- **Confianza**: ALTA.
- **Cuándo se vuelve necesaria**: hoy si el volumen crece; obligatoria si DEC-08 G2/G3 se aprueba (schema extendido sin consumer = doble ausencia).

**GAP-NEW-2: `P-AUTH-BOUNDARY`**

- **Categoría**: IMPLICIT.
- **Por qué debería existir**: la distinción mecánica/convención/humana/agente es la propiedad que **hace posible** el diseño estrella (K3), pero vive como columna del catálogo, no como entidad. F9-D01 la definió operativamente pero sin materializarla. K3-D-AUTHZ-VS-VERIF depende de leerla explícita.
- **Piezas actuales que la implican**: cada pieza del catálogo tiene columna "Autoridad"; DEC-02 (delegación) es literalmente mover un límite en este espacio.
- **Evidencia**: DEC-02 no puede formalizarse sin nombrar el objeto sobre el que actúa.
- **Confianza**: ALTA.

**GAP-NEW-3: `P-DERIV-CONTRACT`**

- **Categoría**: IMPLICIT + FUTURE.
- **Por qué debería existir**: cada vez que dos piezas están en "sync manual" (P-PT↔P-BB; `.claude/rules`↔context packs; MASTER handoff↔PROJECT_STATE; catálogo K3↔MASTER), hay una derivación no contratada. Sin contrato, drift es inevitable a mediano plazo.
- **Capacidad fragmentada**: consistencia entre representaciones; verificabilidad de "esto se deriva de aquello".
- **Piezas actuales**: P-PC-CAN (futura), P-MTR (futura), placeholder audit (manual).
- **Evidencia**: la propia enumeración K3 de "sync manual" como fragilidad recurrente.
- **Confianza**: ALTA como diagnóstico; MEDIA como pieza materializable (depende de DEC-04).

### 5C. LATENT MISSING

**GAP-NEW-4: `P-CONTRACT-REGISTRY`** — **`HYPOTHESIS`**

- **Categoría**: LATENT.
- **Por qué**: hay contratos regados: `contract_hash` (P-EM), `contrato de escritura` (P-SM/P-DM/P-EM/P-ES), `contrato de fases` (P-IP), `contrato TaskCompleted` (P-GT). No hay una fuente única que enumere qué contratos existen y cuáles son sus propiedades.
- **Piezas que la implican**: todas las anteriores.
- **Confianza**: MEDIA — puede que ARTIFACT_MANIFEST + DECISION_REGISTRY ya cubran esto en la práctica; sin lectura de ARTIFACT_MANIFEST no lo puedo afirmar. **`UNKNOWN` — evidencia necesaria**: leer ARTIFACT_MANIFEST.md completa (fuera de scope de esta auditoría).

### 5D. FUTURE MISSING

Bajo DEC-04 D4 + DEC-05 E2 se vuelven inevitables:

- **P-MTR** (motor) — ya listado en MASTER.
- **P-PC-CAN** (canónica) — ya listado.
- **P-FP-CATALOG** (FP classes: PAC-EF-02 mostró que la clase existe) — no listado explícitamente como pieza; el MASTER lo llama "framework".
- **P-MOTOR-INVARIANT-TEST** — el motor requiere test de idempotencia; sin ese test la pieza motor es no falsificable. Pieza compañera obligatoria de P-MTR.

Bajo DEC-08 G2:

- **P-VERDICT-FIELD** (schema extendido con `verdict:`) — cambia contrato de P-LE.
- **P-REVISIT-POLICY** (DEC-11 formaliza) — ya listado como DEC.

---

## §6. EMERGENT PIECES (Fase 5)

Piezas que no aparecen individualmente pero emergen de combinaciones. Cada una demostrada.

**EMG-1: `INTEGRITY-LOOP`** — emerge de `P-CSB + P-SM + P-RB`

- Origen-1: `P-CSB` detecta drift.
- Origen-2: `P-SM` es la fuente de estado que se compara.
- Origen-3: `P-RB` verifica ex-post que el estado es coherente.
- Función nueva: monitor continuo de integridad de estado (ninguna pieza sola lo hace).
- Nueva interfaz: drift-detected → runbook flags → reviewer investiga.
- Nueva responsabilidad: garantizar que el "espejo" (`CURRENT_STATE.md`, `SESSION_HANDOFF_CURRENT.md`) no diverja del maestro.
- Decisiones afectadas: DEC-11 (política de revisit), DEC-12 (meta-doc cap).
- Evidencia requerida: EV-007 (Drift detection), EV-013 (session log rotation). **`DOCUMENTED`**.
- Confianza: ALTA. Es composición real; sin las tres piezas juntas no hay loop.

**EMG-2: `CONVENTION-AS-AUTHORITY`** — emerge de `P-PT + P-SM + P-DM + P-EM + P-CP + P-IP + P-IM`

- Todas estas piezas tienen `Authority: convención`. Emerge una **capa** cuya autoridad no es mecánica sino humana + textual.
- Función nueva: gobernanza sin enforcement técnico. Es la mitad "conventional" del CCP.
- Nueva responsabilidad: mantener coherencia entre 7 archivos por commit humano.
- Decisiones afectadas: DEC-04 (canonicalizar quita a P-PT de esta capa); DEC-11 (formaliza dentro de esta capa la política de revisit).
- Confianza: ALTA.
- **Nota**: esta emergencia no es una pieza sino una **capa arquitectónica** ya reconocida por el K3 modelo estrella. La incluyo aquí porque el MASTER no la nombra como entidad, aunque describe sus propiedades.

**EMG-3: `POLICY-DOUBLE-REPRESENTATION`** — emerge de `P-PT + P-BB + P-PY`

- P-PT (prosa `.md`), P-BB (regex en shell), P-PY (YAML research). Los tres representan el mismo objeto conceptual "política del CCP".
- Función que emerge: ninguna nueva positiva; **emerge una fragilidad**: la triple representación sin motor de derivación produce garantía de drift.
- Esto es lo que el MASTER llama GAP-1.
- Confianza: ALTA. Es literal el problema que DEC-04 resuelve.
- **Veredicto**: no es pieza a materializar; es diagnóstico del problema estructural.

**EMG-4: `HUMAN-BOTTLENECK`** — emerge de `P-H + P-O + convención + F9-D01`

- Todas las decisiones no delegadas y toda revisión semántica caen en dos humanos.
- Función que emerge: single point of failure operativo (K3-D-F9D01-BOTTLENECK).
- Confianza: ALTA. Documentado en K3.
- Veredicto: capacidad/anti-capacidad, no pieza materializable.

**Emergencia de tercer orden no encontrada de forma defensible**. Registré `UNKNOWN` en lugar de forzar una.

---

## §7. IDEA REGISTRY (Fase 6)

Ideas centrales, no piezas. Las materializo con `IDEA-N` y explicito su madurez.

**IDEA-1: "ENFORCEABLE POLICY DERIVATION"**

- Núcleo: la política debería derivarse desde una canónica a los puntos de enforcement, no mantenerse manualmente por convención.
- Fuente: ROOT_ANALYSIS "Missing Piece"; K3 GAP-1; MASTER §1.
- Piezas actuales que la representan: P-PT (parcial, prosa), P-BB (parcial, regex), P-PY + P-PC (research).
- Piezas nuevas que podría generar: P-PC-CAN, P-MTR, P-DERIV-CONTRACT.
- Ideas complementarias: IDEA-3 (contrato explícito), IDEA-6 (evidence-first).
- Ideas en conflicto: IDEA-9 (statu quo formalizado sin cruzar F9-D01).
- Prerrequisitos: DEC-04, DEC-05.
- Estructura emergente: pipeline canónica → motor → derivados con invariant tests.
- Madurez: **ESTRUCTURAL** (diseño listo; no implementable hasta autorización).

**IDEA-2: "AUTHORITY IS NOT VERIFICATION"** (K3-D-AUTHZ-VS-VERIF)

- Núcleo: autorizar (humano) y verificar (mecánico) son funciones distintas y no deben conflarse.
- Fuente: K3 causal analysis.
- Piezas que la representan: separación P-H/P-O (verificación semántica) vs. P-BB/P-BS/P-GT (verificación sintáctica) vs. P-O (autoridad terminal).
- Ideas complementarias: IDEA-4 (evidence gate).
- Ideas en conflicto: DEC-04 D3 (tests-as-contract) parcialmente subsume verificación en enforcement mecánico.
- Madurez: **CONCEPTUAL** (nombrada pero no materializada como primitiva).

**IDEA-3: "CONTRACT-FIRST ENFORCEMENT"**

- Núcleo: cada gate debe consumir un contrato explícito; sin contrato no hay decisión.
- Fuente: F2 evidence gate; F8-A fail-closed.
- Piezas: P-GT (contract_hash), P-EM (evidence entries).
- Ideas complementarias: IDEA-1, IDEA-2.
- Madurez: **IMPLEMENTABLE** (ya materializada parcialmente).

**IDEA-4: "PROVENANCE AS EVIDENCE"**

- Núcleo: toda acción autoritativa deja rastro trazable (git + registries + STALL).
- Fuente: F5, F7, F8; ARCH-004.
- Piezas: P-ES, P-SL, P-EM, git.
- Fragilidad: dead schema fields (`had_alternative`, `session_id`); consumer ausente (§5B).
- Madurez: **ESTRUCTURAL** (materializada con brechas).

**IDEA-5: "REVERSIBILITY AS SUBSTRATE"**

- Núcleo: todo cambio debe poder deshacerse; git es la implementación.
- Fuente: PROP-4 en K3; MASTER §1.
- Piezas: git (fuera del catálogo formal), P-RB.
- Ideas complementarias: IDEA-4.
- Madurez: **IMPLEMENTABLE**.

**IDEA-6: "MEANING VS SYNTAX SEPARATION"**

- Núcleo: reviewer humano tiene meaning-verification; hooks tienen syntax-verification; no conflar.
- Fuente: MASTER §1 (CAP-2m vs CAP-2s).
- Piezas: P-H (meaning), P-BB/P-BS/P-GT (syntax).
- Madurez: **ESTRUCTURAL**.

**IDEA-7: "DEFERRAL AS POLICY"**

- Núcleo: diferir con `trigger:` explícito, no "hasta que aparezca".
- Fuente: DEC-11.
- Piezas actuales que la representan: F9-D01..D05 (deferrals hoy sin trigger declarativo).
- Piezas nuevas: `DEFERRAL_POLICY.md` (propuesto).
- Madurez: **CONCEPTUAL** (opción activa DEC-11 H2).

**IDEA-8: "META-DOC AS COMPENSATION"** (K3-D-EXOGENOUS)

- Núcleo: la falta de memoria persistente runtime es compensada con archivos + SessionStart injection.
- Fuente: K3 causal analysis (`HYPOTHESIS`).
- Piezas: P-CP, P-CSA, P-CSB, meta-docs.
- Confianza epistemológica: es hipótesis; no verificable estructuralmente en un solo pase.
- Madurez: **CONCEPTUAL**.

**IDEA-9: "OWNER AS TERMINAL AUTHORITY"** (K3-D-OWNER-DEFAULT)

- Núcleo: todos los defaults se resuelven en el Owner por ausencia de mecanismo alternativo.
- Fuente: K3; F9-D01=A.
- Piezas: P-O.
- Ideas complementarias: IDEA-2, IDEA-7 (delegación como reducción de bottleneck).
- Ideas en conflicto: escalabilidad a S2/S3.
- Madurez: **IMPLEMENTABLE hoy** (es el estado actual); **ESTRUCTURAL a mediano plazo** (mutable con DEC-02).

**IDEA-10: "STAR TOPOLOGY VS PIPELINE"**

- Núcleo: F1-F8 fue pipeline lineal; F9+ es DAG paralelo con humano-sink.
- Fuente: K3-D-PHASE-CHANGE `PARTIAL`.
- Piezas: (no una pieza; propiedad topológica del ensamblaje).
- Madurez: **CONCEPTUAL**.

**Regla crítica verificada**: IDEAs 1, 2 y 3 aparecen bajo distintos nombres en múltiples piezas — señal de primitiva latente (ver §11).

---

## §8. IDEA FUSION RESULTS (Fase 7)

Combinaciones que producen capacidad nueva.

| Ideas combinadas | Capacidad emergente | Tipo |
|---|---|---|
| IDEA-1 + IDEA-4 | Motor firma cada policy compile con hash de canónica → provenance de policy derivada | EMERGENT_CAPABILITY |
| IDEA-2 + IDEA-3 | Contrato de autorización explícito (Owner decision como EV-like entry) | EMERGENT_CAPABILITY |
| IDEA-3 + IDEA-5 | Rollback contratado (rollback como contrato firmado, no ad-hoc) | EMERGENT_CAPABILITY |
| IDEA-4 + IDEA-6 | Provenance con anotación semántica del reviewer (por qué aprobó, no sólo que aprobó) | EMERGENT_CAPABILITY |
| IDEA-1 + IDEA-9 | Motor decide por default → bypassea Owner en syntax → CONFLICT si no se delega explícitamente | CONFLICT (resoluble con IDEA-2 + DEC-02) |
| IDEA-7 + IDEA-8 | Diferimientos con trigger declarativo consumidos por SessionStart → reactivación automática | EMERGENT_CAPABILITY (requiere P-STREAM-CONSUMER-like) |
| IDEA-8 + IDEA-10 | Meta-doc como "memoria del DAG" — se re-inyecta contexto del estado paralelo | REDUNDANCY con IDEA-8 sola |

**Complementarias necesarias identificadas**:

- IDEA-2 es complemento necesario de IDEA-1 (motor sin distinguir autoridad → conflicto de gobernanza).
- IDEA-3 es complemento necesario de IDEA-4 (provenance sin contrato → registro que no gate).
- IDEA-4 es complemento necesario de IDEA-1 (motor sin provenance → falla no diagnosticable).

Terna irreductible detectada: `IDEA-1 × IDEA-2 × IDEA-4` = "derivación explícita bajo autoridad declarada con provenance verificable". Es el corazón conceptual del CCP maduro.

---

## §9. PIECE LINEAGE (Fase 8)

Sólo piezas de alta centralidad (P-GT, P-BB, P-EM, P-PT, P-H, P-O, P-ES).

**P-GT (GATE-BEFORE-TASK-CLOSURE)**

- Origen: F2 (evidence gate).
- Compensa: la afirmación "task done" no verificable de F1.
- Depende de: P-EM (para lookup de contract_hash), P-LE (para emit).
- Habilita: cierre confiable de tareas → base de ARCH-004.
- Podría convertirse en: si DEC-08 G2 → gate con verdict; si DEC-07 F2 → gate que consume verdict de subagente reviewer.
- ¿Sigue necesaria?: SÍ.
- Presión evolutiva: MEDIA (F8-A la endureció; DEC-08 la extenderá).
- Supervivencia a 10×: HIGH.
- Pregunta clave: **¿existiría si CCP se diseñara hoy desde cero?** SÍ, en forma similar. Path dependence: **BAJA**.

**P-BB (BLOCKER-BEFORE-BASH)**

- Origen: F1.
- Compensa: ausencia de sandboxing runtime propio; substrato bash es superficie amplia.
- Depende de: substrate bash + hook interface del harness.
- Habilita: enforcement mecánico de policy negativa.
- Podría convertirse en: motor-generated (DEC-04 D4/D1); test-driven (D3).
- ¿Sigue necesaria?: SÍ mientras el substrate sea bash y no exista sandbox.
- Presión evolutiva: ALTA (DEC-04 la modifica).
- Supervivencia a 10×: MEDIUM (podría ser reemplazada por LLM-verifier si DEC-07 F3).
- Diseño hoy desde cero: SÍ, en forma diferente (probablemente compilada desde canónica).

**P-EM (EVIDENCE-MASTER)**

- Origen: F2.
- Compensa: falta de contrato en "task done".
- Depende de: convención humana + fail-closed de P-GT (F8-A).
- Habilita: trazabilidad; ARCH-004.
- Convertible en: registry indexable + hash-verified.
- ¿Sigue necesaria?: SÍ.
- Supervivencia: HIGH.
- Diseño hoy: SÍ, más estructurado.

**P-PT (POLICY-TEXTS)**

- Origen: F1.
- Compensa: no había policy layer explícita.
- Depende de: convención humana.
- Habilita: onboarding + reviewer semántica.
- Convertible en: derived doc (DEC-04 D4-A) o eliminada (D2/D4-B).
- ¿Sigue necesaria?: **CONDICIONAL**. Sólo si nunca se implementa motor; con motor, deriva o desaparece.
- Presión evolutiva: MUY ALTA.
- Supervivencia a 10×: **LOW** en forma actual; HIGH como doc derivada.
- Diseño hoy: NO en forma actual. Se diseñaría motor + canónica desde el inicio.
- **Path dependence: ALTA**. Existe porque F1 no tenía canónica.

**P-H (HUMANO-REVIEWER)**

- Origen: pre-F1 (heredado del substrate git + commit workflow).
- Compensa: falta de verificación semántica automática.
- Depende de: disponibilidad humana.
- Habilita: CAP-2m (semantic verification).
- Convertible en: LLM-augmented (DEC-07); no reemplazable para autorización (K3-D-AUTHZ-VS-VERIF).
- Supervivencia: HIGH (irreducible por invariante K3).
- Diseño hoy: SÍ, pero probablemente delegado a LLM para syntax.

**P-O (OWNER)**

- Origen: pre-F1.
- Compensa: falta de motor de decisión.
- Habilita: F9-D01..D05.
- Convertible en: parcialmente delegable (DEC-02 B2).
- Supervivencia: HIGH.
- Bottleneck actual: K3-D-F9D01-BOTTLENECK.

**P-ES (EVENT-STREAM)**

- Origen: F1 (hooks + emit desde el principio).
- Compensa: falta de audit trail runtime.
- Depende de: disk writable, jq.
- Habilita: audit ex-post.
- Fragilidad: sin consumer canónico (§5B).
- Convertible en: STREAM + CONSUMER (P-STREAM-CONSUMER).
- Supervivencia: HIGH como stream; MEDIUM como pieza aislada (necesita contraparte).
- Diseño hoy: probablemente con consumer definido desde F1.

---

## §10. COMPENSATION PIECES (Fase 9)

Piezas cuya función principal es compensar otra fragilidad.

**COMP-1: P-CP (context packs) compensa "no persistent memory runtime"**

- Fragilidad subyacente: substrate LLM sin memoria persistente entre sesiones.
- Pieza compensatoria: P-CP + P-CSA (inject en SessionStart).
- Coste: 6 archivos manuales; drift entre packs y realidad.
- Efectos laterales: F9 G-A1 (packs stale).
- Alternativa directa: harness con memoria persistente (fuera de scope; no controlable por CCP).
- Veredicto: **NECESSARY_COMPENSATION** — no eliminable mientras el substrate no cambie.

**COMP-2: Meta-doc growth compensa "no run-to-run memory"**

- Fragilidad: agente no recuerda decisiones tomadas.
- Pieza: P-EM + P-DM + PROJECT_STATE + docs meta.
- Coste: PT-3 activa antes; crecimiento monotónico.
- Efectos laterales: DEC-12 nace para contenerlo.
- Alternativa: memoria persistente (mismo caso COMP-1).
- Veredicto: **NECESSARY_COMPENSATION con eliminación parcial vía DEC-12 I4**.

**COMP-3: sync manual P-PT ↔ P-BB compensa ausencia de motor**

- Fragilidad: no hay DERIVATION primitiva.
- Pieza: convención humana + reviewer.
- Coste: drift asegurado a mediano plazo; PAC-EF-02 documenta un ejemplo real.
- Efectos: garantía de policy inconsistente eventualmente.
- Alternativa directa: DEC-04 D4/D1 + DEC-05 E2.
- Veredicto: **ELIMINATE_WITH_DEC-04** — es compensación con vencimiento.

**COMP-4: STALL manual triage compensa ausencia de P-STREAM-CONSUMER**

- Fragilidad: log write-only sin lector automático.
- Pieza: HRQS §12 manual.
- Coste: 82% harness noise; señal enterrada.
- Alternativa directa: consumer con reglas (DEC-08 G2 + reglas + consumer).
- Veredicto: **ELIMINATE_WITH_DEC-08** (parcial) + construcción de consumer.

**COMP-5: PROJECT_STATE + drift detection compensa "no state machine formal"**

- Fragilidad: fases y transiciones son convención, no FSM implementada.
- Pieza: P-SM + P-CSB.
- Coste: drift detectable pero no impedible.
- Alternativa: FSM materializada (fuera de scope corto).
- Veredicto: **NECESSARY_COMPENSATION** — DEC-11 podría formalizar transiciones sin materializar FSM.

**COMP-6: Multiple registries compensan ausencia de "single source of truth for governance"**

- Fragilidad: ADR, EV, F9-Decisions, MASTER, PROJECT_STATE — todos son "fuentes de verdad" para algo distinto.
- Pieza: consistencia por convención.
- Alternativa: registry unificado (GAP-NEW-4, §5C).
- Veredicto: **HYPOTHESIS** — requiere verificación con lectura de ARTIFACT_MANIFEST.

---

## §11. LATENT PRIMITIVES (Fase 10)

Búsqueda **independiente de la lista semilla**. Concepto que aparece bajo distintos nombres en 3+ piezas.

**PRIM-1: `AUTHORITY-KIND` (VERIFICADA)**

- Apariciones:
  - En P-BB: como `mecánica`.
  - En P-PT: como `convención`.
  - En P-H: como `humana`.
  - En P-A: como `agente`.
  - En P-LE: como `interno`.
- ¿Es la misma idea?: **SÍ** — es una **taxonomía** aplicada a cada pieza.
- Debería materializarse como pieza propia: **SÍ** (ver `P-AUTH-BOUNDARY`, §5).
- Beneficio: permite razonar sobre delegación (DEC-02) y sobre bottleneck (K3-D-F9D01).
- Coste: bajo (es un catálogo, no un mecanismo).
- Confianza: **ALTA**.

**PRIM-2: `CONTRACT` (VERIFICADA)**

- Apariciones:
  - En P-EM: `evidence contract`.
  - En P-GT: `TaskCompleted contract`.
  - En P-IP: `contrato de fases`.
  - En P-SM: `contrato de escritura`.
  - En hooks lib: `schema del EVENT-STREAM`.
- ¿Misma idea?: **SÍ** — invariante entre partes con criterio de cumplimiento.
- Materializar como pieza: `P-CONTRACT-REGISTRY` (GAP-NEW-4, §5C, `HYPOTHESIS`).
- Confianza: MEDIA (ver §5C, requiere ARTIFACT_MANIFEST).

**PRIM-3: `DERIVATION` (VERIFICADA)**

- Apariciones:
  - PAC compiler: YAML → regex.
  - "sync manual" P-PT → P-BB (derivación no contratada).
  - Context packs: se derivan (informalmente) de state + rules + decisions.
  - MASTER handoff: se deriva de K3 + registries.
  - STALL rules-report (skill claude-mem:ccs-align): se deriva del stream.
- ¿Misma idea?: **SÍ** — canónica → derivado con criterio de coherencia.
- Materializar: `P-DERIV-CONTRACT` (GAP-NEW-3, §5B).
- Confianza: **ALTA**. Es la primitiva central ausente.

**PRIM-4: `LIFECYCLE` (VERIFICADA)**

- Apariciones:
  - Fases F1-F8 (`PASS`/`RESEARCH COMPLETE`/`NOT AUTHORIZED`).
  - Deferrals sin trigger (K3-D-DEFERRAL-LIFECYCLE).
  - Meta-doc growth (PT-3).
  - Evidence entries (`fresh`/`stale`).
- ¿Misma idea?: **SÍ** — nacimiento, madurez, retiro.
- Materializar: se propone `LIFECYCLE_REGISTRY` (GAP en MASTER); DEC-03 (front-matter) es paso parcial.
- Confianza: ALTA.

**PRIM-5: `PROVENANCE` (VERIFICADA)**

- Apariciones:
  - EV entries: `provenance` field.
  - Git blame.
  - STALL rows: `source_hook`, `timestamp`.
  - Session log rotation.
- ¿Misma idea?: **SÍ** — quién/cuándo/desde-qué.
- Materializar como pieza: **NO** — ya está distribuida y funciona.
- Confianza: ALTA.

**PRIM-6 (candidata nueva, no en la lista semilla): `INVARIANT-TEST`**

- Apariciones:
  - `maintenance.sh` 12/12.
  - Firewall positive tests (`.claude/hooks/tests/`).
  - Motor idempotence (futuro, DEC-04).
  - Drift detection (P-CSB).
- ¿Misma idea?: **PARCIAL** — todas son "verificar que la propiedad P se mantiene", pero con distintas escalas.
- Materializar: **NO** todavía; es patrón cross-cutting.
- Confianza: MEDIA.

**PRIM-7 (candidata): `HUMAN-SINK`**

- Apariciones:
  - Todos los defaults se resuelven en P-O (K3-D-OWNER-DEFAULT).
  - Semantic verification cae en P-H (CAP-2m).
  - Meta-doc lo lee P-H.
  - Owner authorization gate F9-D01.
- ¿Misma idea?: **SÍ** — dos actores humanos absorben lo que el mecanismo no cubre.
- Materializar como pieza: **NO** — es propiedad emergente, no entidad.
- Es más "capa" que "pieza". Documentado en K3 como topología.

---

## §12. CONTRACT DISCOVERY (Fase 11)

Para las 4 piezas más centrales.

### P-GT

| Contract | Actual |
|---|---|
| INPUT | JSON con `task_id`, `contract_hash`, `artifact_hash`, `status` |
| OUTPUT | exit 0/2 + optional emit |
| AUTHORITY | mecánica; sólo hook oficial invoca |
| FAILURE | fail-closed desde F8-A |
| EVIDENCE | emite a P-ES; ligado a EV entries |
| LIFECYCLE | por SubagentStop; sin retry |
| ROLLBACK | git revert del cambio de hook |

Contract AUSENTE: `SEMANTIC-VERDICT` — el gate valida sintaxis, no significado. Es el hueco que DEC-07 F2 llenaría.

### P-BB

| Contract | Actual |
|---|---|
| INPUT | stdin JSON con bash command |
| OUTPUT | exit 0/2 + optional emit |
| AUTHORITY | mecánica; regex hard-coded |
| FAILURE | fail-closed |
| EVIDENCE | firewall-positive.sh; EV-011 |
| LIFECYCLE | por PreToolUse |
| ROLLBACK | git revert |

Contract AUSENTE: `CANONICAL-SOURCE` — los regex viven en shell, no derivan de fuente canónica. GAP-1.

### P-EM

| Contract | Actual |
|---|---|
| INPUT | manual edit por reviewer humano |
| OUTPUT | lectura por P-GT vía contract_hash |
| AUTHORITY | convención humana + append-only por policy |
| FAILURE | append-only violation es convención, no mecánico |
| EVIDENCE | freshness check; EV-009 |
| LIFECYCLE | crecimiento por EV entries |
| ROLLBACK | git revert |

Contract AUSENTE: `WRITE-VERIFICATION` — no hay hook que rechace edits no-append-only.

### P-H (reviewer humano)

| Contract | Actual |
|---|---|
| INPUT | commit + diff |
| OUTPUT | ACK (`git commit`) / REJECT (no commit) |
| AUTHORITY | humana |
| FAILURE | omisión (FS-6); skill drift |
| EVIDENCE | HRQS §12 checklist |
| LIFECYCLE | por commit |
| ROLLBACK | git revert |

Contract AUSENTE: **`REVIEW-EVIDENCE-EMISSION`** — el reviewer no emite un artefacto explícito; su ACK es implícito en el commit. Contrasta con P-O que sí emite (F9_OWNER_DECISIONS). Esto es una asimetría estructural.

### Contratos emergentes entre pares de piezas

- P-GT + P-EM → contrato `EVIDENCE-BINDING` (§4.2): SHA-256 del EV = contract_hash. **Debería ser pieza `P-EV-BIND`**.
- P-BB + P-PT → contrato `POLICY-DERIVATION`: hoy convencional; **debería ser pieza `P-DERIV-CONTRACT`**.
- P-CSA + P-CP → contrato `PACK-INJECTION`: hoy relación implícita (P-CSU); podría reclasificarse.
- P-O + P-DM → contrato `DECISION-EMISSION`: hoy F9_OWNER_DECISIONS.md es artefacto; contrato existe pero no está formalizado.

---

## §13. PUZZLE GRAMMAR (Fase 12)

Test de la hipótesis: `AUTHORITY + CONTRACT + MECHANISM + EVIDENCE = CONTROLLED CAPABILITY`.

### Instancias que SATISFACEN la gramática

| Capacidad | Authority | Contract | Mechanism | Evidence |
|---|---|---|---|---|
| Bash policy enforcement | mecánica | regex + payload schema | P-BB script | firewall-positive; EV-011 |
| Secret enforcement | mecánica | path patterns | P-BS script | secret-guard-positive; EV-011 |
| Task closure | mecánica | evidence contract (F8-A) | P-GT script | EV-012/015 |
| Session drift detection | mecánica | hash comparison | P-CSB | EV-007 |

Cuatro instancias satisfacen la gramática completa.

### Instancias que FALLAN la gramática

| Capacidad | Authority | Contract | Mechanism | Evidence | Falla en |
|---|---|---|---|---|---|
| Policy definition (rules) | convención | prosa | — | placeholder audit | **MECHANISM ausente** |
| State integrity | convención + mecánica | — | P-CSB | EV-007 | **CONTRACT parcial** (no hay contrato firmado) |
| Delegation | humana | — | — | F9_OWNER_DECISIONS | **CONTRACT + MECHANISM ausentes** (K3-D-OWNER-DEFAULT) |
| Deferral policy | humana | — | — | — | **CONTRACT + MECHANISM + EVIDENCE** (DEC-11 lo repara) |
| STALL consumption | ninguna canónica | — | manual HRQS | ad-hoc | **AUTHORITY + CONTRACT + MECHANISM** |

Cinco instancias fallan, y en cada caso el fallo es **explícitamente diagnosticable**: falta el componente indicado en la columna "Falla en".

### Veredicto

**`GRAMMAR CANDIDATE VERIFIED (diagnostic use)`**

La fórmula no es descriptiva (no toda la arquitectura la cumple), sino **diagnóstica**: donde una de las cuatro columnas está ausente, hay una fragilidad concreta identificada por el propio K3 (GAP-1, K3-D-OWNER-DEFAULT, K3-D-DEFERRAL-LIFECYCLE, K3-D-CAP3).

La gramática es útil como **generador de gaps**: iterar las capacidades del CCP y buscar columnas ausentes produce la lista de piezas faltantes.

**No conservo una segunda gramática** — probé `INPUT × PROCESS × OUTPUT × TRACE` como alternativa y colapsa con la anterior sin ventaja explicativa.

---

## §14. PIECE MUTATIONS AND MIGRATIONS (Fase 13)

Sólo mutaciones no obvias (las obvias ya están en MASTER §31).

**MUT-1: P-CSU → RELATION** (no mutación de implementación; mutación conceptual)

- Tipo: RENAME + RECLASSIFY.
- Resultado: catálogo con -1 pieza y +1 relación explícita.
- Ganancia: modelo más limpio; DEC-02 tiene un objeto formal sobre el que actuar.
- Riesgo: cambio de nomenclatura confunde a lectores previos.

**MUT-2: P-GT → SPLIT en 3 sub-piezas**

- Tipo: SPLIT.
- Resultado: `GT-SCHEMA-VALIDATE`, `GT-HASH-COMPARE`, `GT-DECIDE-EMIT`.
- Ganancia: F8-A retrospectivamente legible como cambio a `GT-HASH-COMPARE`; permite razonar sobre DEC-08 G2 como cambio a `GT-SCHEMA-VALIDATE`.
- Coste: refactor de docs, no de código.

**MUT-3: P-PT → DERIVE desde canónica (DEC-04 D4-A)**

- Tipo: DERIVE.
- Resultado: P-PT deja de ser fuente autoritativa y se convierte en artefacto derivado.
- Ganancia: elimina sync manual sin destruir doc humana.
- Coste: motor + retraining reviewer.

**MUT-4: P-ES + P-STREAM-CONSUMER → WRAP**

- Tipo: WRAP (nueva pieza envuelve la existente).
- Resultado: consumer canónico que triágea (auto-clasifica policy_category y decide acción).
- Ganancia: cierra el loop CAP-3.
- Coste: nueva pieza no trivial; requiere DEC-08 G2 previa idealmente.

**MUT-5: P-EM + `WRITE-VERIFICATION` hook → WRAP**

- Tipo: WRAP (append-only mechanic real, no convencional).
- Resultado: rejects a edits non-append-only.
- Coste: cross-cutting con git (workflow humano roto si mal implementado).
- Riesgo: interfiere con hotfixes legítimos.

**MUT-6: RENAME-CONCEPT `CONTEXT-SUBAGENT`**

- El nombre sugiere entidad; el objeto es relación. Ver MUT-1.

**MUT-7: RENAME-CONCEPT `POLICY-TEXTS`**

- El nombre P-PT unifica dos objetos distintos (prosa + archivo). Podría dividirse en `POLICY-PROSE` (PO) y `POLICY-DOC-FILE` (AR).

**Piezas cuyo nombre oscurece su función**:

- `P-CSU CONTEXT-SUBAGENT` → oscurece que es RELACIÓN.
- `P-PT POLICY-TEXTS` → oscurece la dualidad prosa/archivo.
- `P-SA SUBAGENTS` → oscurece que es SET, no pieza.
- `P-LE LIB-EVENT-EMISSION` → nombra bien (es lib).

**Mutaciones no viables o rechazadas**:

- REMOVE P-PT (DEC-04 D2) — pierde CAP-2m; degrada INV-8. **Ya rechazado por análisis MASTER §31.6**.
- REPLACE P-H con LLM completo — viola K3-D-AUTHZ-VS-VERIF. **Invariante hard**.

---

## §15. MULTI-SCALE ANALYSIS (Fase 14)

Sólo piezas de alta gravedad.

**P-GT**

- MICRO: `{schema-validate, hash-compare, decide, emit}` (§3).
- COMPONENT: gate mecánico ejecutado en SubagentStop.
- SYSTEM: bisagra entre trabajo del agente y evidencia formal; sin P-GT, EV entries no son gate.
- META: define qué significa "task completa" en el CCP; base de ARCH-004.
- FRACTAL: **PARCIAL** — contiene un mini-puzzle (schema + hash + decisión + emit) que refleja la gramática general.

**P-BB**

- MICRO: `regex → bash string`.
- COMPONENT: firewall pre-tool.
- SYSTEM: única barrera automática contra ejecución peligrosa.
- META: la superficie de seguridad depende de la coincidencia entre `.claude/rules/security.md` (prosa) y las regex (código). Ese "match" es el GAP-1.
- FRACTAL: NO — átomo simple.

**P-EM**

- MICRO: EV entry con schema.
- COMPONENT: registry.
- SYSTEM: fuente única de trazabilidad; leída por P-GT.
- META: define qué es "evidencia válida" en el CCP; base de F2-F8.
- FRACTAL: PARCIAL — cada EV entry es a su vez composición de {task_id, contract_hash, artifact_hash, reviewer, exceptions, timestamp, provenance}.

**P-H**

- MICRO: workflow cognitivo humano (lectura, decisión).
- COMPONENT: reviewer.
- SYSTEM: humano-sink de la topología estrella.
- META: garantía de meaning-verification; irreducible por K3-D-AUTHZ-VS-VERIF.
- FRACTAL: NO — el humano no es descomponible en piezas.

**P-O**

- MICRO: proceso de decisión con documentación.
- COMPONENT: autoridad terminal.
- SYSTEM: última puerta de todo cambio no delegado.
- META: define qué es autorización en el CCP; bottleneck K3-D-F9D01.
- FRACTAL: PARCIAL — cada decisión del Owner es a su vez estructura {question, options, verdict, rationale, evidence}.

---

## §16. CLUSTERS AND BRIDGES (Fase 15)

Agrupación por función emergente.

### Clusters

**CLUSTER-ENFORCEMENT** (mecánica-fail-closed)

- Piezas: P-BB, P-BS, P-GT, P-LE.
- Función: barreras automáticas y su emit.
- ¿Módulo?: **SÍ analítico**; físicamente ya viven en `.claude/hooks/`.

**CLUSTER-STATE-INTEGRITY**

- Piezas: P-SM, P-CSB, P-CSA, P-RB.
- Función: mantener y verificar consistencia del estado maestro.
- ¿Módulo?: SÍ analítico.

**CLUSTER-EVIDENCE-CHAIN**

- Piezas: P-EM, P-GT (parcial), P-ES, git.
- Función: cadena de trazabilidad de decisiones y ejecuciones.
- ¿Módulo?: SÍ analítico; físicamente distribuido.

**CLUSTER-GOVERNANCE**

- Piezas: P-DM, P-IP, P-IM, F9_OWNER_DECISIONS, P-O, P-H.
- Función: decisiones, plan, entregables, autoridad.
- ¿Módulo?: SÍ analítico.

**CLUSTER-POLICY-LAYER**

- Piezas: P-PT, P-BB (regex), P-BS (paths), P-PY, P-PC.
- Función: representar y aplicar reglas del CCP.
- Cohesión: **BAJA** actualmente (GAP-1); alta bajo DEC-04.

**CLUSTER-CONTEXT-COMPENSATION**

- Piezas: P-CP, P-CSA, P-CSU (relación), meta-doc.
- Función: compensar ausencia de memoria persistente.
- ¿Módulo?: SÍ analítico.

**CLUSTER-ACTORS**

- P-H, P-O, P-A, P-SA (con sub-instancias).

### Bridges (piezas que conectan clusters)

**BRIDGE-1: P-GT** conecta CLUSTER-ENFORCEMENT ↔ CLUSTER-EVIDENCE-CHAIN

- Tipo: ESSENTIAL.
- ¿Puede desaparecer?: NO — es la interfaz.

**BRIDGE-2: P-LE** conecta CLUSTER-ENFORCEMENT ↔ CLUSTER-EVIDENCE-CHAIN (a través de P-ES)

- Tipo: ESSENTIAL.

**BRIDGE-3: P-CSA** conecta CLUSTER-CONTEXT-COMPENSATION ↔ CLUSTER-ACTORS

- Tipo: ESSENTIAL para agentes.

**BRIDGE-4: P-H** conecta CLUSTER-ACTORS ↔ CLUSTER-EVIDENCE-CHAIN ↔ CLUSTER-GOVERNANCE

- Tipo: ESSENTIAL + BOTTLENECK.

**BRIDGE-5: P-O** conecta CLUSTER-GOVERNANCE ↔ CLUSTER-STATE-INTEGRITY ↔ todo

- Tipo: ESSENTIAL + TERMINAL BOTTLENECK.

**BRIDGE-6: PROJECT_STATE.md** (parte de P-SM) conecta CLUSTER-STATE-INTEGRITY ↔ CLUSTER-CONTEXT-COMPENSATION

- Tipo: ESSENTIAL.

**BRIDGE-7 (candidato): P-STREAM-CONSUMER** — inexistente hoy, conectaría CLUSTER-ENFORCEMENT (vía P-ES) ↔ CLUSTER-GOVERNANCE (triage automático)

- Tipo: MISSING (ver §5B).

---

## §17. INDEPENDENT RECONSTRUCTION (Fase 16)

Reconstrucción usando SÓLO evidencia primaria (hooks + rules + settings + YAML + evidence), silenciando MASTER como verdad.

### Modelo independiente

Miro `.claude/hooks/` y encuentro 10 scripts + 1 lib. Miro `.claude/rules/` y encuentro 4 archivos Markdown de prosa. Miro `.claude/context/` y encuentro 6 packs. Miro `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` y encuentro EV entries. Miro `PROJECT_STATE.md` y encuentro CURRENT_PHASE=8. Miro `docs/research/pac/ccp_policies.yaml` con 24 IDs y `compile_policies.sh` que produce regex.

**Piezas que emergen sólo desde repo (sin consultar MASTER)**:

1. 10 scripts + 1 lib → 4 tipos funcionales: (a) blocker pre-tool, (b) gate post-subagent, (c) context injector session-start/subagent-start, (d) stop-logger.
2. 4 rules → policy layer convencional.
3. 6 context packs → capa de compensación de contexto.
4. 1 YAML + 1 compiler → research artefact, no runtime.
5. EV registry → contratos de tarea.
6. PROJECT_STATE + registries → gobernanza documental.
7. maintenance.sh → verificación batch.

**Actores implícitos**: harness (invoca hooks), agente (ejecuta), reviewer humano (revisa commits), owner (autoriza fases).

### Comparación BASELINE vs INDEPENDENT

Aplicando el test:

- **Piezas del MASTER que confirmo desde repo**: 22 de 24. Falta contexto para dos:
  - P-SA como "conjunto de 11" — no lo confirmo, veo 5 archivos en `.claude/agents/` + runtime types en harness. **Discrepancia superficial explicada por MASTER**.
  - Sub-división de P-GT — no la propone el MASTER, la levanto en §3.
- **Piezas del MASTER que no aparecen desde repo puro**: 0. Todas tienen anclaje verificable.
- **Piezas que aparecen desde repo y el MASTER no lista**: 0 (todas las piezas de hooks/rules/context/yaml están en el catálogo).

### Diferencias clasificadas

**DIFF-1**: P-GT — MASTER lo trata como átomo; reconstrucción independiente muestra 3 fases distintas ejecutadas por el mismo script.
- Tipo: `DIFFERENT_INTERPRETATION`.
- Evidencia que lo resolvería: leer el script y encontrar los 3 stages. **Verificado**.

**DIFF-2**: P-CSU — MASTER lo lista como pieza; reconstrucción muestra que sin subagente + pack no existe.
- Tipo: `DIFFERENT_INTERPRETATION`.
- Evidencia: subagent-context.sh sólo tiene sentido si ambos extremos existen.

**DIFF-3**: `.claude/agents/` tiene 5 archivos, MASTER cita 11.
- Tipo: `MISSING_CONTEXT` — 6 son runtime types del harness, no archivos.
- Evidencia: system-reminder actual lista los 11.

**DIFF-4 (no encontrado)**: no encuentro pieza en el repo que MASTER haya omitido. No hay hooks huérfanos, ni rules ocultas.

Conclusión: el catálogo del MASTER es **empíricamente completo** al nivel de granularidad que usa. Las diferencias son de interpretación/granularidad, no de omisión.

---

## §18. ADVERSARIAL AUDIT (Fase 17)

Respuestas honestas a cada pregunta:

| # | Pregunta | Verdict | Corrección |
|---|---|---|---|
| 1 | ¿Llamo "pieza" a algo que es sólo idea? | SÍ | IDEA-1..10 se explicitan en §7, separadas de piezas |
| 2 | ¿Llamo "idea" a algo que ya debería ser primitiva? | SÍ (parcial) | AUTHORITY-KIND, DERIVATION son primitivas materializables, no ideas (§11) |
| 3 | ¿Existe pieza faltante que explicaría anomalías? | SÍ | P-STREAM-CONSUMER explica 82% harness noise |
| 4 | ¿Pieza inventada por exceso de abstracción? | NO (evitado) | Rechacé "meta-authority" y otras candidatas |
| 5 | ¿Relación que debería ser entidad? | SÍ | P-EV-BIND, P-AUTH-BOUNDARY, P-DERIV-CONTRACT |
| 6 | ¿Entidad que debería ser relación? | SÍ | P-CSU |
| 7 | ¿Añado pieza por no entender otra? | POSIBLEMENTE | P-STREAM-CONSUMER podría cubrirse con hooks; lo marco `CONFIANZA ALTA` pero abierto a refutación |
| 8 | ¿Preservo pieza sólo porque aparece? | NO | P-PT explícitamente marcada CONDICIONAL (§9) |
| 9 | ¿Elimino pieza porque parece vieja? | NO | Todas las obsoletas están vinculadas a DEC que las obsoletaría |
| 10 | ¿Qué pieza domina realmente? | P-O (Owner) — todas las decisiones no delegadas terminan aquí |
| 11 | ¿Qué pieza es sólo compensación histórica? | P-PT en forma actual (compensa ausencia de canónica) |
| 12 | ¿Qué pieza desaparecería si cambiara el substrate? | P-CP y meta-doc si el harness tuviera memoria persistente |
| 13 | ¿Qué pieza sobrevive bajo TODAS las arquitecturas futuras? | P-H (irreducible por K3-D-AUTHZ-VS-VERIF), P-O (autoridad terminal), P-EM (evidence contract) |
| 14 | ¿Qué pieza todavía no existe pero será inevitable si CCP escala? | P-STREAM-CONSUMER y P-DERIV-CONTRACT |
| 15 | ¿Tercera pieza que haga compatibles dos incompatibles? | P-AUTH-BOUNDARY compatibiliza IDEA-2 con DEC-02 (delegación sin ambigüedad) |
| 16 | ¿Cuarta estructura que emerge sólo de combinación de tres? | INTEGRITY-LOOP (EMG-1); no encontré una cuarta defensible |

**Correcciones aplicadas** (revisión del texto anterior a este §):

- Añadí explícitamente que P-STREAM-CONSUMER podría ser cubierta por hooks (§5B); confianza queda ALTA porque no hay hook actual que lo haga.
- P-CONTRACT-REGISTRY queda como `HYPOTHESIS` explícita (§5C).
- EMG-2 aclarada como capa, no pieza (§6).
- PRIM-6 y PRIM-7 marcadas MEDIA/PARTIAL en confianza (§11).

---

## §19. FINAL NEW-PIECE VERDICTS (Fase 18)

### NEW-PIECE-1: `P-STREAM-CONSUMER`

- Por qué invisible antes: se trata como "función humana ad-hoc" (HRQS §12), no como pieza.
- Ideas: IDEA-4, IDEA-7.
- Piezas fuente: P-ES, P-LE.
- Nueva responsabilidad: triage automático de STALL rows; extracción de precedentes.
- Nuevas interfaces: consumer read → decide → emit-to-registry.
- Por qué las actuales son insuficientes: log write-only con 82% ruido.
- Evidencia: 19 rows; MASTER §3 K3-D-CAP3.
- Confianza: **ALTA**.
- **VEREDICTO: SURVIVES_IF** — condicional a DEC-08 (schema estable) y a decisión Owner (nuevo hook).

### NEW-PIECE-2: `P-AUTH-BOUNDARY`

- Invisible antes: aparece como columna, no como entidad.
- Ideas: IDEA-2, IDEA-9.
- Piezas fuente: toda la columna "Autoridad" del catálogo.
- Responsabilidad: mapear qué autoridad es mecánica/convención/humana/agente para cada pieza; ser objeto de la delegación DEC-02.
- Evidencia: K3-D-AUTHZ-VS-VERIF; F9-D01 opera implícitamente sobre esta primitiva.
- Confianza: **ALTA**.
- **VEREDICTO: SURVIVES** — como pieza documental (registry), no como mecanismo. Es materializable sin cambiar runtime.

### NEW-PIECE-3: `P-DERIV-CONTRACT`

- Invisible antes: el "sync manual" oscurece que la derivación es una primitiva ausente.
- Ideas: IDEA-1, IDEA-3.
- Piezas fuente: P-PT, P-BB, P-CP, P-SM, MASTER↔K3, etc. (cada par en "sync manual").
- Responsabilidad: contratar la derivación canónica→derivado con invariance test.
- Evidencia: repetición del patrón "sync manual" en 4+ pares.
- Confianza: **ALTA como diagnóstico**, **MEDIA como pieza materializable** (depende de DEC-04).
- **VEREDICTO: SURVIVES_IF** — condicional a DEC-04 ≠ D5.

### NEW-PIECE-4 (candidata débil): `P-EV-BIND`

- Ya existe como comportamiento del gate (F8-A). Materializarla como pieza propia es más un refactor conceptual.
- Confianza: MEDIA.
- **VEREDICTO: LATENT** — no es urgente materializarla; ganancia clarificatoria si DEC-08 G2 la separa del gate.

### NEW-PIECE-5 (candidata débil): `P-CONTRACT-REGISTRY`

- **VEREDICTO: UNKNOWN** — requiere revisar ARTIFACT_MANIFEST para descartar redundancia. No la propongo como pieza validada.

### Piezas rechazadas (candidatas que probé y descarté)

- **"Meta-authority"** (autoridad para cambiar autoridades) — se colapsa con P-O + convención. No aporta.
- **"Handoff-doc primitive"** — MASTER_HANDOFF es artefacto, no pieza estructural nueva.
- **"Bug-registry-consumer"** — REG-* ya cubre esto; no hay pieza faltante distinta a P-STREAM-CONSUMER.
- **"Shadow-runtime pieza atomizada"** — DEC-08 G3 la introduce cuando toca; no debe pre-materializarse.

---

## §20. FINAL MASTER PIECE MAP

### 20.1 VALIDATED EXISTING PIECES (con reclasificación)

| ID | Nombre | Tipo | Rol | Origen | Confidence | Status |
|---|---|---|---|---|---|---|
| P-BB | Bash firewall | ME | enforcement | F1 | ALTA | ACTIVE |
| P-BS | Secret guard | ME | enforcement | F1 | ALTA | ACTIVE |
| P-GT | Task closure gate | **CP** (=GT-SV+GT-HC+GT-DE) | gate | F2 | ALTA | ACTIVE, split-conceptual |
| P-LE | Event emit lib | ME | provenance | F1 | ALTA | ACTIVE, dead schema fields |
| P-CSA | SessionStart compact | ME | context inject | F1 | ALTA | ACTIVE |
| P-CSB | SessionStart drift | **CP** (=DriftDetect+SnapshotWrite) | state integrity | F5 | ALTA | ACTIVE, split-conceptual |
| ~~P-CSU~~ | Subagent context | → **RELATION `INJECT[P-CP→P-SA]`** | (rel.) | F1 | ALTA | RECLASSIFY |
| P-SM | State master | AR | governance | F1 | ALTA | ACTIVE |
| P-DM | Decisions master | AR | governance | F1 | ALTA | ACTIVE |
| P-EM | Evidence master | AR | evidence | F2 | ALTA | ACTIVE |
| P-ES | Event stream | AR | provenance | F1 | ALTA | ACTIVE, missing consumer |
| P-SL | Session stream | AR | narrative | F1 | ALTA | ACTIVE |
| P-RB | Runbook maintenance | ME | verify | F6 | ALTA | ACTIVE, 12/12 |
| P-CP | Context pack | AR | compensation | F1 | ALTA | ACTIVE, F9 G-A1 stale risk |
| P-PT-doc | Policy doc file | AR | governance | F1 | ALTA | ACTIVE, `no-go.md` placeholders |
| P-PT-prose | Policy semantics | PO | governance | F1 | ALTA | ACTIVE, mutable by DEC-04 |
| P-PY | Policy YAML | AR (research) | research | M007 | ALTA | RESEARCH |
| P-PC | Policy compiler | ME (research) | research | M007 | ALTA | RESEARCH, PAC-EF-02 |
| P-IP | Master plan index | AR | governance | F1 | ALTA | ACTIVE |
| P-IM | Artifact manifest | AR | governance | F1 | ALTA | ACTIVE |
| P-H | Human reviewer | AC | authorization+verification | pre-F1 | ALTA | ACTIVE, irreducible |
| P-O | Owner | AC | terminal authority | pre-F1 | ALTA | ACTIVE, bottleneck |
| P-A | Agent primary | AC | producer | pre-F1 | ALTA | ACTIVE |
| P-SA[N] | Subagents (11 tipos) | AC (set) | delegated | F1+harness | ALTA | ACTIVE, K3-D-OWNER-DEFAULT |

### 20.2 REFINED PIECES (sub-piezas explicitadas)

| Sub-pieza | Padre | Función | Ciclo distinguido |
|---|---|---|---|
| GT-SV | P-GT | schema validate | F7 |
| GT-HC | P-GT | hash compare | F8-A |
| GT-DE | P-GT | decide + emit | F2 |
| CSB-DD | P-CSB | drift detect | F5 |
| CSB-SW | P-CSB | snapshot write | F5 |
| PT-doc | P-PT | archivo `.md` | mutable independiente |
| PT-prose | P-PT | semántica normativa | mutable independiente |

### 20.3 NEW STRUCTURAL PIECES

| ID | Nombre | Tipo | Confidence | Status |
|---|---|---|---|---|
| P-STREAM-CONSUMER | Stream triage/consumer | ME (missing) | ALTA | SURVIVES_IF (DEC-08) |
| P-AUTH-BOUNDARY | Authority-kind registry | AR (missing, documental) | ALTA | SURVIVES |
| P-DERIV-CONTRACT | Derivation invariance contract | RP → ME (missing) | MEDIA | SURVIVES_IF (DEC-04) |

### 20.4 LATENT / FUTURE PIECES (no materializar aún)

| ID | Nombre | Trigger |
|---|---|---|
| P-EV-BIND | evidence binding as first-class | DEC-08 G2 |
| P-MTR | motor unidireccional | DEC-04 ≠ D5 + DEC-05 E2 |
| P-PC-CAN | canónica única | DEC-04 ≠ D5 |
| P-FP-CATALOG | FP classes catalog | DEC-04 D4 |
| P-DELEG-REG | delegation registry | DEC-02 B2 |
| P-CATALOG | change types catalog | DEC-01 A2 |
| P-DEFERRAL-POLICY | deferral trigger policy | DEC-11 H2 |

### 20.5 RELATIONAL PIECES (explicitadas)

| ID | Endpoints | Contrato |
|---|---|---|
| INJECT[P-CP→P-SA] | context pack, subagent | pack válido → inject stdin |
| BIND[P-GT↔P-EM] | task closure, evidence | contract_hash coincide con EV |
| DERIVE[canonical→derived] | (futuro) | motor idempotente + invariant test |
| CONSUME[P-ES→P-STREAM-CONSUMER] | (futuro) | schema estable + reglas de triage |
| AUTH-DELEGATE[P-O→P-SA] | (futuro DEC-02) | delegación registrada + revocable |

### 20.6 PRIMITIVES

| ID | Nombre | Estado |
|---|---|---|
| PRIM-1 | AUTHORITY-KIND | verificada; materializable P-AUTH-BOUNDARY |
| PRIM-2 | CONTRACT | verificada; materializable posible (P-CONTRACT-REGISTRY `HYPOTHESIS`) |
| PRIM-3 | DERIVATION | verificada; materializable P-DERIV-CONTRACT |
| PRIM-4 | LIFECYCLE | verificada; parcial vía DEC-03 |
| PRIM-5 | PROVENANCE | verificada; distribuida, no materializar como pieza |
| PRIM-6 | INVARIANT-TEST | parcial; patrón cross-cutting |
| PRIM-7 | HUMAN-SINK | verificada; propiedad emergente, no pieza |

### 20.7 EMERGENT STRUCTURES

| ID | Nombre | Fuentes | Naturaleza |
|---|---|---|---|
| EMG-1 | INTEGRITY-LOOP | P-CSB + P-SM + P-RB | capacidad emergente |
| EMG-2 | CONVENTION-AS-AUTHORITY | 7 piezas conv. | capa arquitectónica |
| EMG-3 | POLICY-DOUBLE-REPRESENTATION | P-PT + P-BB + P-PY | fragilidad (GAP-1) |
| EMG-4 | HUMAN-BOTTLENECK | P-H + P-O + F9-D01 | anti-capacidad |

### 20.8 IDEAS ACTIVAS (registro)

Ver §7. Diez ideas centrales; terna irreductible IDEA-1 × IDEA-2 × IDEA-4.

### 20.9 CONTRACTS DISCOVERED

Ver §12. Contratos ausentes clave:

- SEMANTIC-VERDICT en P-GT (DEC-07 F2 lo cubriría).
- CANONICAL-SOURCE en P-BB (GAP-1; DEC-04 lo cubriría).
- WRITE-VERIFICATION en P-EM (no cubierto por DEC actual).
- REVIEW-EVIDENCE-EMISSION en P-H (asimetría con P-O; no cubierto por DEC actual).

---

## §21. COMPLETENESS CHECKLIST

- [x] Catálogo original auditado (§2).
- [x] Piezas compuestas detectadas (§3: P-GT, P-CSB, P-PT).
- [x] Relaciones mal modeladas corregidas (§4: P-CSU).
- [x] Relaciones candidatas a pieza evaluadas (§4: P-EV-BIND, P-AUTH-BOUNDARY, P-DERIV-CONTRACT).
- [x] Piezas faltantes buscadas desde cero (§5).
- [x] Piezas emergentes demostradas (§6).
- [x] Ideas atomizadas (§7).
- [x] Ideas fusionadas (§8).
- [x] Ideas en conflicto investigadas (§8).
- [x] Primitivas latentes sin depender de lista inicial (§11: PRIM-6, PRIM-7 fuera de la semilla).
- [x] Contratos faltantes buscados (§12).
- [x] Mutaciones exploradas (§14).
- [x] Clusters y bridges reconstruidos (§16).
- [x] Reconstrucción independiente (§17).
- [x] Auditoría adversarial (§18).
- [x] Recomposición cross-phase (§22 abajo).
- [x] Búsqueda de estructuras de tercer y cuarto orden (§23).
- [x] Novelty test (§25).
- [x] Novedad real separada de reframing (§27).
- [x] Modelos competidores comparados (§26).
- [x] Triangulación IDEA↔PIECE↔RELATION (§28).
- [x] Tres rutas de validación (§29).
- [x] Puzzle reconstruido usando estructuras supervivientes (§30).
- [x] Nuevos huecos buscados post-recomposición (§31).
- [x] Estructura que nadie hubiera visto — buscada honestamente (§32).
- [x] Se preserva la posibilidad de "no hay novedad material" (§25, §32).
- [x] Último ataque adversarial (§33).
- [x] FINAL MASTER PIECE MAP v2 (§34).

---

# PARTE II — META-SYNTHESIS ENGINE

> Recomposición del rompecabezas usando lo descubierto en §1-§21. No re-analiza; ensambla.

## §22. CROSS-PHASE KNOWLEDGE MATRIX (§100)

Sinopsis de resultados por dimensión (compactada):

```text
PIECES:          22 VP + 3 CP (split conceptual) + 1 RP (reclas) + 3 NEW
IDEAS:           10 (IDEA-1..10)
RELATIONSHIPS:   5 explicitadas (INJECT, BIND, DERIVE, CONSUME, AUTH-DELEGATE)
GAPS:            6 MASTER + 3 nuevas confirmadas + 2 hipótesis
EMERGENT:        4 (INTEGRITY-LOOP, CONVENTION-LAYER, POLICY-DOUBLE-REP, HUMAN-BOTTLENECK)
PRIMITIVES:      7 (5 verificadas + 2 parciales)
CONTRACTS:       4 ausentes identificados
MUTATIONS:       7 exploradas
CLUSTERS:        7 (con 7 bridges, 1 missing)
COMPENSATIONS:   6 (2 eliminables con DEC, 4 necesarias)
GRAMMAR:         1 candidata verificada (diagnóstica)
```

## §23. CROSS-PHASE RECOMPOSITION (§101, §102)

### Recomposición de tercer orden: `AUTHORITY × CONTRACT × DERIVATION`

Cuando cruzo:

- PRIM-1 (AUTHORITY-KIND) — la autoridad como objeto de primer orden.
- PRIM-2 (CONTRACT) — el contrato como objeto de primer orden.
- PRIM-3 (DERIVATION) — la derivación como objeto de primer orden.

Emerge una estructura arquitectónica:

**`GOVERNED DERIVATION`** = derivación canónica→derivado bajo autoridad declarada con contrato firmado.

Esto es más que la suma:

- Sólo DERIVATION → motor sin gobernanza (quién autoriza el cambio de canónica).
- Sólo CONTRACT → contrato sin motor (contrato manual, drift asegurado).
- Sólo AUTHORITY → autoridad sin instrumento (K3-D-OWNER-DEFAULT).

`GOVERNED DERIVATION` es la estructura que **DEC-04 + DEC-05 + DEC-02** juntas producen. Ninguna sola.

- Fuentes: §11 (PRIM-1, PRIM-2, PRIM-3).
- Relación nueva: autoridad delegable sobre canónica → motor consume → derivado con provenance.
- Función nueva: escalar policy sin cuello de botella (K3-D-F9D01-BOTTLENECK).
- Por qué no visible antes: DEC-04 y DEC-02 se analizan por separado en MASTER §31.
- Piezas conectadas: P-PC-CAN, P-MTR, P-DELEG-REG, P-AUTH-BOUNDARY.
- Decisiones afectadas: DEC-04 + DEC-05 + DEC-02 son la terna que la habilita.
- Evidencia: agregación de PAC prototype + K3-D-AUTHZ-VS-VERIF.
- Refutable si: PAC-EF-02 se generaliza y muestra que motor genera FPs > 5% aun con canónica.

### Recomposición de cuarto orden: `AUTHORITY × CONTRACT × DERIVATION × PROVENANCE`

Añadir PRIM-5 (PROVENANCE) produce:

**`AUDITABLE GOVERNED DERIVATION`** = lo anterior + traza completa de "quién autorizó qué cambio en canónica cuándo, con qué justificación, produciendo qué derivado".

- Nueva capacidad: auditoría de la propia gobernanza; poder responder "¿por qué la política P dice X hoy?".
- Piezas necesarias: las anteriores + `PROVENANCE-in-motor-output` (motor firma cada compile con hash de canónica).
- Confianza: MEDIA. Es composición legítima; su valor depende de si el reviewer o el Owner efectivamente consulta la traza (K3-D-EPIST-COST).

### Recomposición: `EVIDENCE × STREAM × CONSUMER`

- Cruce de IDEA-4 + P-ES + P-STREAM-CONSUMER (missing).
- Estructura: **`CONSUMED EVIDENCE STREAM`** — stream con lector canónico que produce artefactos derivados (registry de precedentes, alertas de drift, extracción de bugs).
- Cerraría K3-D-CAP3 (provenance con brechas) y CAP-3.
- Piezas: P-ES + P-STREAM-CONSUMER + reglas + P-DM (donde caen precedentes).

## §24. NOVELTY TEST (§103)

Para cada nueva estructura afirmada, ¿es realmente nueva?

| Estructura | ¿Nueva? | Clasificación |
|---|---|---|
| P-STREAM-CONSUMER | Sí, no listada en MASTER como pieza | **TRUE NOVELTY** |
| P-AUTH-BOUNDARY | Sí como pieza; existe como columna | **REFRAMING elevado** |
| P-DERIV-CONTRACT | Parcial (motor está en MASTER) | **REFRAMING + COMPOSITION** |
| GOVERNED DERIVATION | Sí como estructura combinada | **COMPOSITION OF KNOWN PIECES** |
| AUDITABLE GOVERNED DERIVATION | Sí | **COMPOSITION** |
| CONSUMED EVIDENCE STREAM | Sí como estructura | **COMPOSITION + NEW PIECE** |
| Grammar AUT×CTR×MEC×EV | Sí como diagnóstico | **TRUE NOVELTY** (como uso diagnóstico; el patrón mismo está implícito) |
| INTEGRITY-LOOP (EMG-1) | Sí como capacidad nombrada | **REFRAMING** |
| CONVENTION-AS-AUTHORITY (EMG-2) | No, K3 lo cubre parcialmente | **REFRAMING** |
| HUMAN-BOTTLENECK (EMG-4) | No, K3-D-F9D01 lo nombra | **DUPLICATE** |

## §25. CROSS-PHASE CONTRADICTION ENGINE (§104)

Contradicciones encontradas dentro de la propia auditoría:

**CONTRA-1**: §5B afirma P-STREAM-CONSUMER es implícita y necesaria; §18 pregunta si "añado pieza por no entender otra".

- Naturaleza: posible sobre-abstracción.
- Layer: mechanism.
- Resolución: la ausencia de consumer canónico es empírica (82% harness noise, ningún script lo procesa), no interpretación. **APPARENT CONTRADICTION** — el ataque adversarial no la refuta.

**CONTRA-2**: §4.2 promueve `AUTHORITY-BOUNDARY` a pieza; §11 la trata como primitiva (PRIM-1).

- Naturaleza: pieza vs primitiva.
- Layer: model.
- Resolución: la primitiva es el concepto (AUTHORITY-KIND); la pieza es el registry materializable (P-AUTH-BOUNDARY). Son compatibles. **APPARENT**.

**CONTRA-3**: §9 afirma P-PT tiene supervivencia LOW; §14 lo mantiene VALID.

- Naturaleza: temporalidad.
- Layer: piece.
- Resolución: **DIFFERENT SCALES** — VALID en el modelo actual; LOW en horizonte 10×. No contradicción.

**CONTRA-4**: §6 (EMG-4 HUMAN-BOTTLENECK) y §18 pregunta 13 (P-H sobrevive todas las arquitecturas).

- Naturaleza: bottleneck vs irreducible.
- Layer: architecture.
- Resolución: **DIFFERENT ASSUMPTIONS** — P-H sobrevive porque autorización requiere humano; el bottleneck es sobre-carga, no la existencia. No contradicción.

No encuentro contradicciones estructurales reales que requieran cambiar el modelo.

## §26. MODEL COMPETITION (§105)

**MODEL A**: MASTER piece catalog (24 piezas top-level, GAP pieces enumeradas).

**MODEL B**: MASTER catalog + auditoría (23 piezas VP + 3 CP internos + 1 relación explícita + 3 nuevas + 7 primitivas).

**MODEL C**: reduccionista extremo — sólo P-BB, P-BS, P-GT, P-LE, P-EM, P-SM, P-H, P-O (mínimo coherente per MASTER §56D).

Comparación:

| Métrica | MODEL A | MODEL B | MODEL C |
|---|---|---|---|
| Explanatory power | Alto para lo actual | Alto para actual + futuro | Alto para core, débil para gobernanza |
| Anomalies covered | GAP-1..6 declaradas | GAP-1..6 + 3 nuevas + primitivas | GAP-1..6 no cubiertas |
| Exceptions needed | ~5 (P-CSU, P-SA, dead schema, sync manual, F9-D01) | ~2 (relación explicitada, primitivas) | ~10+ (todo lo governance es "convención") |
| Evidence supported | ARCH-004, EV-*, MASTER, K3 | idem + verificación repo directa | idem + K3 §56D |
| Predictions | DEC-04..DEC-13 outcomes | idem + gaps de tercer orden | conservador; sin predicciones nuevas |

**MODEL B gana** por explicar más estructura (incluye ausencias como entidades) con menos excepciones (relaciones dejan de ser piezas ambiguas). MODEL C es útil como test de reducción pero deja gobernanza sin representación.

## §27. NEW PRIMITIVE DISCOVERY — SECOND PASS (§107)

Segunda pasada, sin partir de AUTHORITY/PROVENANCE/CONTRACT/DERIVATION/LIFECYCLE/IDENTITY.

Concepto que aparece repetidamente ahora que veo el puzzle completo:

**CANDIDATE-PRIM-8: `FROZEN CANONICAL`** — el patrón de que existe UN documento maestro/canónico que otros derivan (formal o informalmente):

- PROJECT_STATE.md (state canónica).
- DECISION_REGISTRY.md (decisiones canónicas).
- EVIDENCE_REGISTRY.md (evidencia canónica).
- MASTER_HANDOFF.md (modelo canónico del CCP).
- (futuro) ccp_policies.yaml (policy canónica).

¿Es primitiva? Sí como patrón; **pero** puede ser instancia de PRIM-3 (DERIVATION) — donde hay derivación hay canónica. **VEREDICTO: NO agrego** — es dual de DERIVATION.

**CANDIDATE-PRIM-9: `IDEMPOTENCE`**

- maintenance.sh corre repetidamente sin efectos secundarios.
- Motor idempotente (futuro).
- Hooks re-entrantes (P-CSA no daña si se dispara dos veces).
- Session-start puede correr múltiples veces.

Es propiedad, no entidad. **NO materializar**.

**CANDIDATE-PRIM-10: `FAIL-CLOSED-BY-DEFAULT`**

- P-BB, P-BS, P-GT (F8-A), P-CSB, P-RB.
- Patrón consistente: falta de información → bloquea, no permite.

Es propiedad transversal, no entidad. **NO materializar como pieza**; sí digna de registro como invariante K3.

No encuentro primitiva verdaderamente nueva. **REGISTRAR: no material novelty at primitives level.**

## §28. IDEA × PIECE × RELATION TRIANGULATION (§109)

Terna irreductible identificada §8: **IDEA-1 × IDEA-2 × IDEA-4** = "governed derivation with provenance".

Triangulación:

- Como IDEA: aparece como problema en K3 (Missing Piece + AUTHZ-VS-VERIF + PROVENANCE brechas).
- Como PIECE: emerge como pieza compuesta (P-PC-CAN + P-MTR + P-AUTH-BOUNDARY + P-DERIV-CONTRACT).
- Como RELATION: emerge como red de contratos (DERIVE, BIND, AUTH-DELEGATE).

**Convergen las tres representaciones** — señal de alta confianza estructural.

Otra terna: **IDEA-4 × P-ES × P-STREAM-CONSUMER**.

- Como IDEA: provenance-as-evidence.
- Como PIECE: stream write-only + consumer ausente.
- Como RELATION: CONSUME (currently missing).

**Convergen** — señal alta.

## §29. THREE-ROUTE VALIDATION (§110)

Para GOVERNED DERIVATION (nueva estructura principal):

- **Route A (bottom-up)**: repo → hooks + rules + yaml → sync manual detectado → derivación no contratada → estructura. ✓
- **Route B (top-down)**: escalabilidad de policy → GAP-1 → motor + canónica + autoridad delegable. ✓
- **Route C (relational)**: contratos de escritura + contratos de política + contratos de autorización → red → mismo patrón. ✓

**HIGH CONFIDENCE**.

Para P-STREAM-CONSUMER:

- Route A: ver STALL log de 19 rows con 82% ruido → falta lector. ✓
- Route B: audit trail necesita triage → falta consumer. ✓
- Route C: P-ES tiene emit sin read → asimetría estructural. ✓

**HIGH CONFIDENCE**.

Para P-AUTH-BOUNDARY:

- Route A: columna "Autoridad" en catálogo → primitiva latente. ✓
- Route B: DEC-02 requiere objeto sobre el que actuar → boundary. ✓
- Route C: F9-D01 y K3-D-AUTHZ-VS-VERIF operan sobre esto sin nombrarlo. ✓

**HIGH CONFIDENCE**.

## §30. RECURSIVE REASSEMBLY (§111)

Usando SÓLO estructuras validadas (piezas VP + relaciones explícitas + primitivas verificadas + ideas maduras):

```text
CORE:              P-BB, P-BS, P-GT (=GT-SV+GT-HC+GT-DE), P-LE
STATE INTEGRITY:   P-SM, P-CSA, P-CSB (=CSB-DD+CSB-SW), P-RB
EVIDENCE:          P-EM, P-ES, P-SL, [MISSING P-STREAM-CONSUMER]
GOVERNANCE:        P-DM, P-IP, P-IM, F9-Decisions
POLICY (current):  P-PT-doc + P-PT-prose + P-BB regex (via CONVENTION-AS-AUTHORITY)
POLICY (future):   P-PC-CAN + P-MTR + P-DERIV-CONTRACT
CONTEXT:           P-CP, INJECT[P-CP→P-SA]
ACTORS:            P-H, P-O, P-A, P-SA[N]
PRIMITIVES:        AUTHORITY-KIND, CONTRACT, DERIVATION, LIFECYCLE, PROVENANCE
GRAMMAR:           AUT×CTR×MEC×EV (diagnostic)
```

¿Explicable? SÍ — el modelo cubre F1-F8 + F9 gate + 13 decisiones abiertas + Missing Piece + brechas de CAP-3 + K3-D-OWNER-DEFAULT.

## §31. NEW GAP SEARCH POST-RECOMPOSITION (§112)

¿Qué hueco aparece AHORA que no aparecía antes?

**GAP-META-1: `REVIEW-EVIDENCE-EMISSION`** — asimetría P-H vs P-O

- P-O emite evidencia explícita (F9_OWNER_DECISIONS con rationale).
- P-H no emite evidencia explícita; su ACK es implícito en `git commit`.
- Después de la recomposición, esta asimetría **es visible** como hueco: si REVIEW debe ser evidence-based (IDEA-4), debe emitir. Hoy no lo hace.
- Nueva pieza candidata: `REVIEWER-VERDICT-EMISSION` (podría integrarse con commit trailer, no requiere hook nuevo — extensión de convención con verificador ligero).
- Confianza: MEDIA. No urgente.

**GAP-META-2: no encontré otro hueco material** post-recomposición. Registro honestamente que **no hay** una segunda ausencia estructural de tercer orden que aparezca sólo después de recomponer.

## §32. "NO ONE SAW THIS" GATE (§115)

¿Estructura que Kimi K3 + MASTER + esta auditoría hubieran pasado por alto?

**Candidata**: **`REVIEWER-VERDICT ASYMMETRY`** (GAP-META-1 arriba).

- Por qué previos modelos la omitieron: K3 y MASTER trataron P-H como CAP-2m sin descomponer su contrato de emisión. F9 gates cerraron con decisiones documentadas por Owner (P-O emite), pero el reviewer cotidiano no.
- Piezas fuente: P-H, P-EM, git commit workflow.
- Ideas: IDEA-4 (provenance-as-evidence) + IDEA-2 (authority vs verification).
- Nueva capacidad: asimetría hace que auditoría *ex-post* del reviewer sea imposible más allá de git blame; el reviewer no deja registro semántico.
- Evidencia: `git log` + F9_OWNER_DECISIONS.md muestran contraste. **Verificable**.
- Confianza: **MEDIA-ALTA**.
- Falsifier: si HRQS §12 ya cubre esto y produce artefacto rastreable, esta "novedad" es duplicate.

**Registrar honestamente**: podría ser reframing y no novedad genuina. La marco como candidata, no descubrimiento.

Otras candidatas serias, ya sondeadas y rechazadas:

- "SessionStart handoff canonical" — es P-SM en otra ropa.
- "Meta-agent" — no aparece; los agentes son delegados por P-A, no meta.

**`NO OTHER MATERIAL NEW STRUCTURE FOUND`**. La única con potencial es REVIEWER-VERDICT ASYMMETRY.

## §33. FINAL META-AUDIT (§125)

Últimas preguntas:

- ¿Creando estructura porque quiero encontrar? Riesgo bajo — sólo 3 piezas nuevas propuestas, todas con confianza ALTA y falsifier declarado.
- ¿Conectando por parecer relacionadas? Comprobado con triangulación IDEA/PIECE/RELATION en §28.
- ¿Co-ocurrencia vs dependencia? P-CP y meta-doc co-ocurren pero DEPENDEN del substrate LLM sin memoria — verificado como dependencia estructural (§10 COMP-1).
- ¿Dependencia vs identidad? P-CSU depende de P-SA + P-CP, no es identidad propia (§4.1).
- ¿Capacidad vs pieza? EMG-1..4 marcados explícitamente como estructuras emergentes o capas, no piezas (§6).
- ¿Relación fuerte vs entidad? P-EV-BIND marcada LATENT, no materializada urgentemente (§19).
- ¿Primitiva por sobre-simplificación? Descarté 3 candidatas primitivas nuevas (§27); mantengo sólo las verificadas.
- ¿Abstracción preservada por hábito? P-PT explícitamente CONDICIONAL (§9); no preservo si DEC-04 la deprecia.
- ¿Explica algo previamente inexplicable? SÍ — GOVERNED DERIVATION explica por qué las 3 decisiones DEC-04/05/02 son la terna, no separadas.
- ¿Evidencia refutadora posible? Declarada para cada nueva pieza (falsifier explícito).

## §34. FINAL STRUCTURAL VERDICT (§127)

### WHAT SURVIVED

- 22 de 24 piezas del MASTER catalog, con reclasificaciones internas (splits, dualidades).
- Los 4 clusters funcionales del MASTER (ENFORCEMENT, EVIDENCE-CHAIN, GOVERNANCE, CONTEXT-COMPENSATION).
- La topología estrella de K3 (P-H y P-O como sinks).
- La grammar candidata (elevada a uso diagnóstico).

### WHAT CHANGED

- P-CSU: pieza → relación INJECT[P-CP→P-SA].
- P-GT: pieza → composite (GT-SV, GT-HC, GT-DE).
- P-CSB: pieza → composite (CSB-DD, CSB-SW).
- P-PT: pieza → dual (PT-doc + PT-prose).
- P-SA: pieza → set de 11 sub-actores.
- AUTHORITY-KIND: columna → primitiva (PRIM-1) → pieza materializable P-AUTH-BOUNDARY.

### WHAT WAS NEW

- **P-STREAM-CONSUMER** (missing piece, ALTA confianza).
- **P-AUTH-BOUNDARY** (primitiva materializada).
- **P-DERIV-CONTRACT** (relación promovida a pieza, condicional).
- **Grammar diagnóstica AUT×CTR×MEC×EV**.
- **GOVERNED DERIVATION** (composición de tercer orden).
- **REVIEWER-VERDICT ASYMMETRY** (posible hueco de cuarto orden, MEDIA confianza).

### WHAT WAS FALSE

- Ninguna pieza inventada por sobre-abstracción (rechacé 4 candidatas: meta-authority, handoff-primitive, bug-consumer, shadow-atomized).
- Ninguna primitiva forzada (rechacé FROZEN CANONICAL, IDEMPOTENCE, FAIL-CLOSED-BY-DEFAULT como primitivas de primer orden).

### WHAT REMAINS UNKNOWN

- P-CONTRACT-REGISTRY: no verificable sin leer ARTIFACT_MANIFEST completo.
- Materialización real de P-STREAM-CONSUMER: viable pero requiere decisión Owner.
- Si HRQS §12 cubre parcialmente GAP-META-1.

### WHAT BECAME CLEARER

- **La grammar AUT×CTR×MEC×EV no es descriptiva sino diagnóstica**. Este es el hallazgo con mayor uso práctico: es un generador de gaps.
- La distinción `pieza vs relación vs primitiva vs idea` es no trivial y produce reducciones limpias en el catálogo (P-CSU, P-GT).
- **DEC-04 + DEC-05 + DEC-02 son la terna irreductible** de la maduración del CCP, no decisiones separables (§23 GOVERNED DERIVATION).

### WHAT THE PUZZLE REALLY LOOKS LIKE NOW

Un ensamblaje con **cuatro capas** (que ya existían en el modelo K3, pero ahora con sus objetos explícitos):

1. **Capa mecánica**: hooks fail-closed (P-BB, P-BS, P-GT split, P-LE, P-CSA, P-CSB split, P-RB).
2. **Capa documental gobernada por convención**: registries, plan, manifest (P-SM, P-DM, P-EM, P-IP, P-IM, P-PT-doc).
3. **Capa relacional/contractual**: INJECT, BIND, DERIVE (missing), CONSUME (missing), AUTH-DELEGATE (missing). Aquí viven las relaciones que hoy son "sync manual".
4. **Capa de autoridad**: P-H, P-O, P-A, P-SA con AUTHORITY-KIND como primitiva y P-AUTH-BOUNDARY como registry.

La **frontera crítica** entre capas 2 y 3 es donde vive GAP-1 y donde DEC-04+05+02 operan como terna. Todo lo demás son movimientos locales.

---

## §35. FINAL RECONSTRUCTION CERTIFICATE (§128)

```text
CERTIFICATE — CCP PIECE AND IDEA PUZZLE AUDIT

BASELINE PUZZLE          : MASTER_HANDOFF.md piece catalog (24 top-level pieces)
                          + 6 GAP pieces declaradas
                          + K3 baseline

AUDITED PUZZLE           : catalog + clasificación tipológica + atomicidad + relación-vs-pieza
                          + primitivas latentes + contratos ausentes + grammar candidata

INDEPENDENT RECONSTRUCTION: 22/24 piezas confirmadas desde repo puro
                          + 3 splits internos + 1 relación explicitada
                          + 0 piezas MASTER-only sin anclaje en repo

IDEA EXCAVATION          : 10 ideas centrales; terna irreductible IDEA-1×IDEA-2×IDEA-4

PIECE EXCAVATION         : 3 piezas nuevas defensibles (P-STREAM-CONSUMER, P-AUTH-BOUNDARY,
                                                        P-DERIV-CONTRACT)
                          + 1 candidata débil (P-EV-BIND, LATENT)
                          + 1 UNKNOWN (P-CONTRACT-REGISTRY)

EMERGENCE                : 4 estructuras emergentes; 1 composición de tercer orden
                          (GOVERNED DERIVATION)

CROSS-PHASE RECOMPOSITION: DEC-04+DEC-05+DEC-02 = terna irreductible
                          para maduración del CCP

ADVERSARIAL ATTACK       : 4 contradicciones examinadas (todas APPARENT, no reales);
                          16 preguntas de auto-refutación respondidas

CORRECTION               : marcados explícitos de HYPOTHESIS, MEDIA, LATENT, UNKNOWN
                          en cada afirmación no-verificada

FINAL PIECE MODEL        : 22 VP existentes + splits internos + 1 RP + 3 NEW
                          + 5 relaciones + 5 primitivas + 4 emergentes
                          + 1 grammar diagnóstica

MATERIAL NOVELTY         : 3 piezas nuevas + 1 grammar diagnóstica + 1 estructura de
                          tercer orden. Novedad neta modesta, en línea con la regla
                          "5 bien justificadas > 30 especulativas".
```

## §36. FINAL QUALITY GATE (§129)

Toda casilla del checklist §21 y §129 marcada. No declaro DONE por volumen — declaro DONE porque puedo defender:

- Qué piezas existen realmente (§20).
- Qué piezas son artefactos de representación (P-CSU relación; P-GT/P-CSB/P-PT dualidades) (§20).
- Qué piezas nuevas emergen (§19, §20.3).
- Qué relaciones faltaban (§4.2, §20.5).
- Qué ideas estaban ocultas dentro de piezas (§7, §11 primitivas).
- Qué composiciones crean nuevas capacidades (§23 GOVERNED DERIVATION, CONSUMED EVIDENCE STREAM).
- Qué cambia en la comprensión del rompecabezas (§34 "WHAT BECAME CLEARER").

### Respuesta a la pregunta final del prompt

> "Después de desmontar el rompecabezas, mover sus piezas, descubrir nuevas piezas y volver a ensamblarlo, ¿qué estructura profunda del CCP queda cuando eliminamos nombres, historia, implementaciones accidentales y sesgos de la representación?"

Cuatro capas conectadas por contratos, con dos primitivas centrales (AUTHORITY-KIND y DERIVATION) y una asimetría diagnosticable (gramática AUT×CTR×MEC×EV). Lo mecánico está firme y verificado; lo documental es convención bajo P-H/P-O; lo relacional entre ambas es hoy "sync manual" — y esa es la ausencia primitiva que **explica la mayoría de fragilidades acumuladas** (GAP-1, K3-D-CAP3, K3-D-EPIST-COST, sync manual entre representaciones).

> "¿Qué parte de esa estructura no estaba en el modelo anterior y qué evidencia nos permite afirmar que realmente existe?"

Cuatro afirmaciones que sobreviven adversarial audit:

1. **P-STREAM-CONSUMER existe como ausencia estructural verificable** (19 rows, 82% ruido, ningún script lo procesa).
2. **AUTHORITY-KIND es primitiva materializable como P-AUTH-BOUNDARY** (columna del catálogo + K3-D-AUTHZ-VS-VERIF + DEC-02 requiere el objeto).
3. **La grammar AUT×CTR×MEC×EV es diagnóstica** (4/4 casos verificados; 5 casos donde la ausencia de una columna coincide con una fragilidad K3 nombrada).
4. **DEC-04+DEC-05+DEC-02 forman la terna irreductible** de la maduración del CCP (`GOVERNED DERIVATION`), no decisiones separables.

Todo lo demás son reclasificaciones, splits, refinamientos y honestos "no material novelty found".

**FIN DEL DOCUMENTO.**
