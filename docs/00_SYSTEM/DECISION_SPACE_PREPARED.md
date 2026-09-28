# DECISION SPACE PREPARED — CCP Owner Handoff

> Preparación del espacio de decisión del Owner. Ejecuta el MASTER PROMPT v1 posterior al AUDIT.
> Baselines: `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md` + `docs/00_SYSTEM/MASTER_HANDOFF.md`.
> Salida única de esta fase. NO modifica runtime, hooks, policies, registries ni PROJECT_STATE.
> No cierra decisiones. Prepara el tablero para que el Owner decida.
> Fecha: 2026-09-25. Autor: Claude Opus 4.7 (preparador, no decisor).

Epistemología aplicada:

- `VERIFIED` · `DOCUMENTED` · `INFERENCE` · `HYPOTHESIS` · `CONTRADICTED` · `OBSOLETE` · `UNKNOWN`.
- Preferir `UNKNOWN` explícito antes que invento.
- Ninguna "recomendación" es absoluta; siempre condicional a evidencia y contexto Owner.

---

## §0. BASELINE SNAPSHOT

```text
git status                    → main; 56 ahead of origin; PROJECT_STATE modificado; audit + prompt untracked
git log --oneline -3
  f496897 [CONFIG] checkpoint: MASTER_HANDOFF + K3 corpus + RA audit
  1a6232d [RESEARCH] ROOT_ANALYSIS: complete F1-F12 protocol
  9ea8367 [CONFIG] PROJECT_STATE: checkpoint f6a874f — MOVEMENT 008

wc -l docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md → 1663
wc -l docs/00_SYSTEM/MASTER_HANDOFF.md              → 3903
Decisiones enumeradas en MASTER §13                → 13 (DEC-01..DEC-13)
F9 owner decisions cerradas                         → F9-D01..D05 (2026-09-20)
LAST_GIT_CHECKPOINT                                  → f496897
CURRENT_PHASE                                        → 8 COMPLETE
STALL_POLICY_LOG                                     → 19 filas
```

Piezas nuevas del AUDIT que crean decisiones nuevas:

- `P-STREAM-CONSUMER` (confianza ALTA) → DEC-STREAM-CONSUMER.
- `P-AUTH-BOUNDARY` (confianza ALTA) → DEC-AUTH-BOUNDARY.
- `REVIEWER-VERDICT ASYMMETRY` (confianza MEDIA-ALTA) → DEC-REVIEWER-VERDICT.
- `P-CONTRACT-REGISTRY` (`UNKNOWN`, requiere lectura ARTIFACT_MANIFEST) → NO promovida a decisión.

---

## §1. EXECUTIVE FINDING

De las 13 decisiones originales del MASTER, **9 sobreviven como decisiones reales**: DEC-01, DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-08, DEC-11, DEC-12. **DEC-06 y DEC-09 son derivadas** (se resuelven automáticamente al decidir upstream), **DEC-10 es trivial** (elección de formato con reversibilidad total) y **DEC-13 no es decisión** (es espera de trigger externo). El AUDIT hizo emerger **3 decisiones nuevas defendibles**: DEC-STREAM-CONSUMER, DEC-AUTH-BOUNDARY, DEC-REVIEWER-VERDICT. **Total real: 12 decisiones**.

**Terna irreductible confirmada**: DEC-04 (canónica) + DEC-05 (motor) + DEC-02 (delegación) = `GOVERNED DERIVATION`. No son separables; el AUDIT §23 lo estableció y esta preparación lo mantiene. Deben decidirse como paquete o al menos en secuencia inmediata.

**Secuencia recomendada (en una línea)**: `DEC-11 → DEC-01 → DEC-02 → DEC-12 → DEC-03 → DEC-AUTH-BOUNDARY → {DEC-04+DEC-05 paquete} → DEC-08 → DEC-STREAM-CONSUMER → DEC-07 → DEC-REVIEWER-VERDICT`. La lógica: primero decisiones de bajo lock-in y alto valor de información (Bloque A + DEC-11), luego materialización de primitivas (AUTH-BOUNDARY), luego la terna irreductible, luego lo que la terna habilita.

**Info gaps críticos** identificados:

1. Sin corpus de política real, DEC-04 se decide sin evidencia empírica de FP rate — resoluble con PAC shadow compile.
2. Sin volumen histórico de STALL con schema completo, DEC-08 recomendación es baja-confianza — resoluble con G3 shadow o G2 tras DEC-11.
3. Sin piloto de delegación, DEC-02 se decide en abstracto — resoluble con 1 delegación piloto en registry.

**Advertencia**: DEC-04 es la única decisión con `lock-in ALTO` en todas sus opciones no-triviales. Recibe tratamiento especial en §5. No debe cerrarse en la misma sesión que decisiones adjacentes sin haber leído §5 completo.

**Regla de handoff**: cada ficha del §10 está diseñada para que el Owner decida esa decisión sin releer este documento entero. Si una ficha requiere contexto adicional, la ficha falló y hay que reformarla.

---

## §2. DECISION SPACE VALIDATION (FASE 1)

### 2.1 Auditoría de las 13 decisiones originales

| DEC | Nombre | STATUS | AUDIT IMPACT | Justificación |
|---|---|---|---|---|
| DEC-01 | D-CATALOG | **VALID** | reforzada por PRIM-1 (AUTHORITY-KIND) — el catálogo declara autoridad por tipo de cambio | opciones mutuamente excluyentes; consecuencias distinguibles; DEC-02 depende |
| DEC-02 | D-DELEG | **VALID** | pieza NUEVA P-AUTH-BOUNDARY es el objeto sobre el que actúa | delegación opera sobre AUTHORITY-KIND; requiere el registry |
| DEC-03 | D-LIFECYCLE | **VALID** | PRIM-4 (LIFECYCLE) — DEC-03 es su materialización parcial | front-matter cambia semántica de archivos; DEC-12 depende |
| DEC-04 | D-CANONICAL | **VALID + IRREDUCIBLE** | terna con DEC-05+DEC-02 confirmada; PRIM-3 (DERIVATION) | requiere tratamiento especial §5 |
| DEC-05 | D-MOTOR | **VALID + IRREDUCIBLE** | dep. de DEC-04; sólo relevante si D-CANONICAL ≠ D5 | opciones triviales sin DEC-04 |
| DEC-06 | READY-01/02 | **DERIVED — RETIRE** | AUDIT lo confirma: se resuelve por (DEC-04, DEC-05) | no es decisión independiente; ejecutar según terna |
| DEC-07 | D-VERIFICADOR | **VALID** | DEC-REVIEWER-VERDICT (nueva) la ilumina | delegación de verificación semántica; requiere DEC-02 |
| DEC-08 | D-INSTR | **VALID pero CONDITIONAL** | ambigüedad F9-D01 se resuelve con DEC-11 | opciones existen; recomendación requiere DEC-11 primero |
| DEC-09 | READY-03 | **DERIVED — RETIRE** | resuelto post-DEC-08 + N sesiones | Owner define N cuando decida DEC-08 |
| DEC-10 | READY-04 | **TRIVIAL — RETIRE** | elección de formato con reversibilidad total | no requiere framework rico; decisión de 30 segundos |
| DEC-11 | D-DEFERRAL-POLICY | **VALID** | IDEA-7 del AUDIT; PRIM-4 (LIFECYCLE) | detiene governance decay; habilita DEC-08 formal |
| DEC-12 | D-META-DOC | **VALID** | reforzada por análisis §10 COMP-2 del AUDIT | contiene PT-3; independiente |
| DEC-13 | External-triggered bundle | **RETIRE — NOT-A-DECISION** | AUDIT confirma: es espera, no elección | reformular como campo `trigger:` dentro de DEC-11 |

### 2.2 Decisiones NUEVAS del AUDIT

**DEC-STREAM-CONSUMER** (nueva)

- ORIGEN: AUDIT §5B (GAP-NEW-1); pieza faltante P-STREAM-CONSUMER; 82% harness noise sobre 19 rows.
- CONFIDENCE: ALTA.
- JUSTIFICACIÓN: sin consumer canónico, DEC-08 (schema extendido) produce datos que nadie procesa. Es decisión, no acción trivial: hay al menos 3 opciones (no hacer / consumer manual documentado / consumer automático con reglas).

**DEC-AUTH-BOUNDARY** (nueva)

- ORIGEN: AUDIT §5B (GAP-NEW-2); PRIM-1 materializable.
- CONFIDENCE: ALTA.
- JUSTIFICACIÓN: sin registry explícito, DEC-02 (delegación) opera en abstracto. Es decisión: hay al menos 2 opciones (documental / semi-programático).

**DEC-REVIEWER-VERDICT** (nueva)

- ORIGEN: AUDIT §32 GAP-META-1; asimetría P-H vs P-O.
- CONFIDENCE: MEDIA-ALTA.
- JUSTIFICACIÓN: reviewer humano no emite evidencia semántica explícita; P-O sí. Cerrar la asimetría es decisión no-trivial (afecta workflow humano).

### 2.3 DECISION SPACE VALIDATED consolidado

```text
DECISIÓN INDEPENDIENTE          STATUS
──────────────────────────────  ──────────────
DEC-01 D-CATALOG                 VALID
DEC-02 D-DELEG                   VALID
DEC-03 D-LIFECYCLE               VALID
DEC-04 D-CANONICAL               VALID + IRREDUCIBLE (terna)
DEC-05 D-MOTOR                   VALID + IRREDUCIBLE (terna)
DEC-07 D-VERIFICADOR             VALID
DEC-08 D-INSTR                   VALID + CONDITIONAL
DEC-11 D-DEFERRAL-POLICY         VALID
DEC-12 D-META-DOC                VALID
DEC-STREAM-CONSUMER              NEW
DEC-AUTH-BOUNDARY                NEW
DEC-REVIEWER-VERDICT             NEW

RETIRADAS / DERIVADAS            RAZÓN
──────────────────────────────  ──────────────────────────────
DEC-06 READY-01/02               deriva de (DEC-04, DEC-05)
DEC-09 READY-03                  deriva de DEC-08 + N sesiones
DEC-10 READY-04                  trivial; reversibilidad total; decisión de 30s
DEC-13 external-triggered        no es decisión; absorbida por DEC-11 trigger:
```

**Total decisiones a preparar**: **12**.

---

## §3. DEPENDENCY GRAPH (FASE 2)

### 3.1 Dependencias

```text
DEC-01 → DEC-02              [HARD]     categorías precondición de registry
DEC-01 → DEC-11              [SOFT]     tipos categorizados mejoran política deferral
DEC-02 → DEC-07              [HARD]     delegación requerida para verificador
DEC-02 → DEC-AUTH-BOUNDARY   [MUTUAL]   registry es el objeto; delegación es el acto
DEC-04 → DEC-05              [HARD]     motor requiere canónica declarada
DEC-04 → DEC-06              [HARD]     READY-01/02 forma cambia con canónica
DEC-05 → DEC-06              [HARD]     motor determina cómo se edita canónica
DEC-08 → DEC-09              [HARD]     READY-03 empírica requiere schema completo
DEC-08 → DEC-STREAM-CONSUMER [MUTUAL]   schema y consumer se iluminan
DEC-11 → DEC-08              [HARD]     precedente F9-D01 revisit requiere política
DEC-11 → DEC-13*             [ABSORB]   DEC-13 se convierte en campo trigger: de DEC-11
DEC-03 → DEC-12              [SOFT]     lifecycle facilita política meta-doc cap
DEC-04 + DEC-05 + DEC-02     [COUPLED]  terna GOVERNED DERIVATION
DEC-07 → DEC-REVIEWER-VERDICT [SOFT]    delegación LLM ilumina asimetría
DEC-AUTH-BOUNDARY → DEC-02   [HARD]     registry precede a delegación operativa
DEC-AUTH-BOUNDARY → DEC-04   [SOFT]     autoridad sobre canónica requiere claridad
DEC-STREAM-CONSUMER → DEC-11 [SOFT]     consumer con reglas requiere política deferral
```

### 3.2 Componentes conexos

**Componente A — Governance base** (bajo lock-in, alta info value):
- {DEC-01, DEC-02, DEC-AUTH-BOUNDARY, DEC-11, DEC-12, DEC-03}

**Componente B — Governed Derivation** (terna irreducible):
- {DEC-04, DEC-05, DEC-02}

**Componente C — Instrumentation loop**:
- {DEC-08, DEC-STREAM-CONSUMER, DEC-11}

**Componente D — Verification delegation**:
- {DEC-07, DEC-REVIEWER-VERDICT, DEC-02}

DEC-02 aparece en 3 componentes (A, B, D) — nodo puente central.

### 3.3 Cadena crítica (HARD PRECEDENCE más larga)

```text
DEC-AUTH-BOUNDARY → DEC-01 → DEC-02 → DEC-07 → DEC-REVIEWER-VERDICT
                                    ↓
                              {DEC-04 → DEC-05 → DEC-06}
```

Longitud: 5 nodos. DEC-02 es el punto de bifurcación.

### 3.4 Nodos raíz (sin precedencias entrantes)

- DEC-11 (nada la bloquea).
- DEC-12 (nada la bloquea).
- DEC-03 (nada la bloquea).
- DEC-AUTH-BOUNDARY (nada la bloquea; ilumina DEC-02).

### 3.5 Nodos hoja (nada depende de ellos)

- DEC-REVIEWER-VERDICT.
- DEC-STREAM-CONSUMER (una vez decidida DEC-08).
- DEC-12.

---

## §4. PER-DECISION ANALYSIS (FASE 3)

> Framework rico completo para cada decisión del DECISION SPACE VALIDATED.
> Ninguna sección omitida; cuando algún campo no aplica, se registra "N/A" con razón.

---

### 4.1 DEC-01 — D-CATALOG

```text
════════════════════════════════════════════════════════════
DEC-01 — D-CATALOG (catálogo de tipos de cambio)
════════════════════════════════════════════════════════════

STATUS ................ VALID
PRECEDENCIAS .......... ninguna
DEPENDENCIAS .......... DEC-02 (HARD), DEC-11 (SOFT)
CATEGORÍA ............. governance / documental
```

**ESPACIO DE OPCIONES**

- **A1 — No hacer nada**. Statu quo; cada tipo de cambio se improvisa por reviewer.
- **A2 — Catálogo Markdown declarativo**. `CHANGE_TYPES_CATALOG.md` con tabla `type × gate × auth_holder × precedent`.
- **A3 — Catálogo + hook de verificación**. A2 + hook rechaza commit con tipo no listado. **Cruza F9-D01**.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: no existe catálogo hoy (`ls docs/00_SYSTEM/CHANGE_TYPES*` → nada).
- `DOCUMENTED`: K3-D-OWNER-DEFAULT (zona gris que consume atención Owner).
- `DOCUMENTED`: reviewer improvisa clasificación caso por caso.
- `INFERENCE`: pocos tipos observados en git log (feat/fix/docs/arch/decision/security/infra/config).

**PIEZAS AFECTADAS**

- Insertadas (A2): nueva pieza `P-CATALOG` (AR documental).
- Movidas: workflow reviewer (consulta al catálogo).
- Primitivas tocadas: PRIM-1 AUTHORITY-KIND (explicita quién decide qué).

**BEFORE → AFTER (Op A2)**

- BEFORE: reviewer clasifica cambio "ad-hoc" en cada commit; no hay tabla de referencia.
- AFTER: reviewer compara contra `CHANGE_TYPES_CATALOG.md`; K3-D-OWNER-DEFAULT reducido; DEC-02 desbloqueado.
- INTERFACES: ninguna técnica cambia; workflow humano se enriquece.

**REGRESIONES POSIBLES**

- Catálogo desactualizado detectable por HRQS trimestral; no bloquea.
- Catálogo demasiado rígido puede rechazar clasificaciones legítimas → mitigable con "otros" bucket.

**COSTE**

- Implementación: BAJO (~1-2h construcción inicial).
- Mantenimiento: BAJO (~15 min/mes review).
- Cognitivo humano: BAJO (reviewer consulta tabla).

**RIESGO**

- Técnico: NINGUNO (Markdown).
- Governance: MÍNIMO (posible sobre-clasificación).
- Precedente: crea patrón declarativo para registries futuros.

**REVERSIBILIDAD**

- ALTA. `git revert`; nadie depende técnicamente del catálogo.

**LOCK-IN**

- BAJO. Formato Markdown; contenido editable; no compromete arquitectura.

**VALOR DE INFORMACIÓN**

- Info faltante clave: si los 5 tipos observados son todos los que aparecen en S1, o si emergirán más.
- Experimento reversible: crear catálogo con 5 tipos + placeholder "otros"; monitorear 1 mes.
- Umbral: si ≥3 clasificaciones caen en "otros" en 1 mes → extender catálogo.

**ALTERNATIVAS HÍBRIDAS**

- A2 con `revision_period: quarterly` en el propio catálogo → cierra loop de mantenimiento.
- A3 sin cruzar F9-D01: hook en modo "warn" (no bloquea, solo advierte) → aporta 80% del enforcement con 0% del riesgo governance.

**IMPACTO SOBRE DECISIONES FUTURAS**

- DEC-02: sin categorías, DELEGATION_REGISTRY no tiene qué keys usar.
- DEC-11: tipos de deferral pueden mapearse a `change_type` del catálogo.
- DEC-04: los cambios a canónica pueden tener su propio tipo (`config-schema-change`).

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner planea escalar el equipo a >1 humano → A3 (variant warn) gana peso.
- Si aparecen ≥5 tipos nuevos en próximos 3 meses → catálogo insuficiente; escalar a schema formal.
- Si nunca se ejecuta DEC-02 → catálogo pierde valor operativo (queda como doc pasiva).

**RECOMMENDATION CONFIDENCE**

- 85% para A2 como paso mínimo. A2 es dominante por coste bajo + lock-in bajo + habilita DEC-02.
- A3 tiene sentido sólo con DEC-11 previa.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Materializamos el catálogo de tipos de cambio como Markdown (A2) o esperamos a más señal?**
- Owner necesita saber:
  - Cuántos tipos de cambio distintos ha visto en los últimos 3 meses.
  - Si prevé sumar contribuidores.
  - Si quiere que DEC-02 sea la siguiente.

---

### 4.2 DEC-02 — D-DELEG

```text
════════════════════════════════════════════════════════════
DEC-02 — D-DELEG (registry de delegaciones)
════════════════════════════════════════════════════════════

STATUS ................ VALID
PRECEDENCIAS .......... DEC-01 (HARD), DEC-AUTH-BOUNDARY (HARD)
DEPENDENCIAS .......... DEC-07 (HARD), DEC-04 (SOFT)
CATEGORÍA ............. governance / authority
```

**ESPACIO DE OPCIONES**

- **B1 — No hacer nada**. Delegación implícita; default siempre humano (K3-D-OWNER-DEFAULT vigente).
- **B2 — Registry Markdown**. `DELEGATION_REGISTRY.md` con `action_type, delegated_to, fallback, activated_by, revocable`.
- **B3 — Registry + hook**. B2 + hook valida presencia de entrada antes de acción delegable. **Cruza F9-D01**.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: no existe registry hoy.
- `DOCUMENTED`: K3-D-OWNER-DEFAULT — todas las autoridades no delegadas caen al humano.
- `DOCUMENTED`: 5 subagentes en `.claude/agents/` + 6 tipos runtime; ninguno tiene delegación explícita registrada.
- `INFERENCE`: el patrón de uso de subagentes es delegación de facto sin contrato.

**PIEZAS AFECTADAS**

- Insertadas: `P-DELEG-REG` (AR).
- Movidas: P-O (deja de ser default silencioso), P-SA (opera bajo delegación explícita).
- Primitivas: PRIM-1 AUTHORITY-KIND se vuelve consultable; PRIM-2 CONTRACT se aplica a delegación.
- Relación nueva: `AUTH-DELEGATE[P-O → P-SA]` con contrato revocable.

**BEFORE → AFTER (Op B2)**

- BEFORE: "¿quién decide X?" respondido por default (humano) sin registro.
- AFTER: consulta a `DELEGATION_REGISTRY.md`; si no está listado, default humano explícito.
- INTERFACES: ninguna técnica; workflow reviewer + Owner cambia.

**REGRESIONES POSIBLES**

- Registry vago mitigable con review.
- Falsa sensación de control si delegación no se ejecuta (registry sin uso real).

**COSTE**

- Implementación: BAJO (~2h construcción inicial).
- Mantenimiento: BAJO (~10 min por entrada).
- Cognitivo: BAJO-MEDIO (obliga a pensar delegación como acto declarativo).

**RIESGO**

- Técnico: NULO.
- Governance: BAJO. Mayor visibilidad reduce riesgo.
- Precedente: legitima el patrón "declarar antes de actuar".

**REVERSIBILIDAD**

- ALTA. Registry es texto.

**LOCK-IN**

- BAJO.

**VALOR DE INFORMACIÓN**

- Info faltante: cuántas delegaciones existen implícitamente hoy.
- Experimento: enumerar cada uso de subagente en los últimos 30 días y clasificar como "delegación explícita / implícita / ad-hoc".
- Umbral: si ≥5 delegaciones implícitas se detectan → registry se vuelve urgente.

**ALTERNATIVAS HÍBRIDAS**

- B2 con `revocation_procedure` explícito en cada entrada.
- B2 con "delegación piloto" — 1 sola delegación registrada como caso de prueba antes de generalizar.

**IMPACTO SOBRE DECISIONES FUTURAS**

- DEC-07: sin B2, F2 (LLM verifier) sería delegación implícita — riesgo governance.
- DEC-04: si D4/D1, el motor edita canónica bajo qué autoridad? Registry lo aclara.
- DEC-REVIEWER-VERDICT: reviewer humano vs LLM podría ser entry en registry.

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner rechaza delegar cualquier cosa a subagentes → B1 (statu quo) coherente.
- Si Owner planea DEC-07 F2 → B2 obligatoria antes.
- Si Owner rechaza siquiera declarar delegaciones → discutir K3-D-F9D01-BOTTLENECK explícitamente.

**RECOMMENDATION CONFIDENCE**

- 80% para B2. Coste bajo, información alta, precondición limpia para DEC-07.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Convertimos las delegaciones implícitas en registry explícito, sin cruzar F9-D01?**
- Owner necesita saber:
  - Qué subagentes ya usa de facto.
  - Si acepta que "delegar sin registrar" es K3-D-OWNER-DEFAULT.
  - Si DEC-07 está en horizonte próximo.

---

### 4.3 DEC-03 — D-LIFECYCLE

```text
════════════════════════════════════════════════════════════
DEC-03 — D-LIFECYCLE (front-matter en research artifacts)
════════════════════════════════════════════════════════════

STATUS ................ VALID
PRECEDENCIAS .......... ninguna (raíz)
DEPENDENCIAS .......... DEC-12 (SOFT)
CATEGORÍA ............. governance / documental
```

**ESPACIO DE OPCIONES**

- **C1 — No hacer nada**. K3-D-LIFECYCLE persiste; degrada con volumen.
- **C2 — Front-matter convención**. Cada `docs/research/*.md` gana `status:`, `derived_from:`, `supersedes:`.
- **C3 — Registry activo**. `ARTIFACT_LIFECYCLE_REGISTRY.md` centralizado.
- **C4 — Sólo research artifacts** (subset C2).

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: `docs/research/` tiene ≥75 archivos; ninguno con front-matter uniforme.
- `DOCUMENTED`: crecimiento silencioso; K3-D-LIFECYCLE nombrado explícitamente.
- `INFERENCE`: al escalar (S2/S3), sin lifecycle se degrada la usabilidad del directorio.

**PIEZAS AFECTADAS**

- Insertadas: convención + runbook check.
- Primitivas: PRIM-4 LIFECYCLE se materializa parcialmente.

**BEFORE → AFTER (Op C2)**

- BEFORE: crecimiento silencioso; qué está activo vs archivado es implícito.
- AFTER: cada archivo declara estado; runbook trimestral detecta stale.
- INTERFACES: workflow de creación de doc research adquiere paso "añadir front-matter".

**REGRESIONES POSIBLES**

- Front-matter obsoleto (detectable por runbook).
- Disciplina humana requerida.

**COSTE**

- Implementación: BAJO (~1h para migrar 75+ archivos con script simple).
- Mantenimiento: MUY BAJO (~30s por archivo nuevo).
- Cognitivo: BAJO.

**RIESGO**

- Técnico: NULO.
- Governance: BAJO.
- Precedente: legitima el patrón "cada doc declara su ciclo".

**REVERSIBILIDAD**

- ALTA.

**LOCK-IN**

- BAJO.

**VALOR DE INFORMACIÓN**

- Info faltante: cuántos docs de research están efectivamente OBSOLETE hoy.
- Experimento: correr un script que enumere docs sin cambios en >90 días como candidatos a archive.

**ALTERNATIVAS HÍBRIDAS**

- C2 + auto-script que genera front-matter desde git log (fecha, autor) como bootstrap.
- C4 solo para research (evita disciplina en docs core como PROJECT_STATE).

**IMPACTO SOBRE DECISIONES FUTURAS**

- DEC-12: front-matter permite política supersedes automática.
- DEC-STREAM-CONSUMER: consumer puede consumir front-matter para filtrar docs activos.

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si volumen se estabiliza y no crece → C4 (subset) suficiente.
- Si Owner planea rotación agresiva de docs → C3 (registry) gana peso.

**RECOMMENDATION CONFIDENCE**

- 70% para C2 o C4. Diferencia entre ambas es sólo scope.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Añadimos front-matter obligatorio a research (C4) o a todos los docs (C2)?**
- Owner necesita saber:
  - Volumen actual de `docs/research/` y crecimiento previsto.
  - Si va a mantener research o archivarla post-K3.

---

### 4.4 DEC-04 — D-CANONICAL (tratamiento estándar; ver §5 para profundidad)

```text
════════════════════════════════════════════════════════════
DEC-04 — D-CANONICAL (fuente canónica de policy)
════════════════════════════════════════════════════════════

STATUS ................ VALID + IRREDUCIBLE (con DEC-05, DEC-02)
PRECEDENCIAS .......... DEC-AUTH-BOUNDARY (SOFT), DEC-02 (COUPLED)
DEPENDENCIAS .......... DEC-05 (HARD), DEC-06 (HARD DERIVED)
CATEGORÍA ............. arquitectural / policy layer
```

**ESPACIO DE OPCIONES**

- **D1 — rules-md canónica**. `.claude/rules/*.md` completo; motor genera firewall.
- **D2 — firewall canónica**. Regex como contrato; `.md` deprecados.
- **D3 — tests canónica**. Cada policy = test bloqueante; hooks llaman tests.
- **D4 — YAML canónica (PAC-family)**. YAML rico; motor genera firewall + tests + opcional `.md`.
- **D5 — No decidir**. Statu quo; GAP-1 abierto.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: 4 rules `.md` (1/4 con placeholders en `no-go.md`); regex en `bash-firewall.sh` 83 líneas; PAC prototype en `docs/research/pac/` con 24 IDs.
- `VERIFIED`: PAC-EF-02 documentada (FP class por nombre de política en literal).
- `DOCUMENTED`: sync manual entre `.md` y regex es la fragilidad central del CCP.
- `HYPOTHESIS`: motor idempotente es viable a escala; verificable con corpus de 20+ policies validadas.

**PIEZAS AFECTADAS**

- (D4) Insertadas: `P-PC-CAN` (canónica), `P-MTR` (motor), `P-FP-CATALOG`, `P-DERIV-CONTRACT`.
- Movidas: P-PT (deprecada o derivada); P-BB (pasa a artefacto derivado); P-PY/P-PC (promovidos de research a runtime).
- Primitivas materializadas: PRIM-3 DERIVATION (central del AUDIT).

**BEFORE → AFTER (Op D4)**

- BEFORE: dual `{P-PT prosa, P-BB regex}` con sync manual.
- AFTER: `{P-PC-CAN YAML} → {P-MTR motor} → {P-BB regex derivado, tests derivados, .md derivado opcional}`.
- INTERFACES: build pipeline corre P-MTR antes de commit; workflow humano edita YAML no regex.

**REGRESIONES POSIBLES**

- Motor bug → firewall incorrecto (mitigable con tests de invariancia).
- FP class nuevas (PAC-EF-02 muestra que emergen).
- Pérdida de comentarios humanos si no se preservan explícitamente en YAML.

**COSTE**

- Implementación: ALTO (motor + tests + FP framework + migración; ~2-4 semanas dedicadas).
- Mantenimiento: MEDIO (motor + YAML + FP catalog).
- Cognitivo: MEDIO-ALTO (reviewer edita YAML; onboarding YAML).

**RIESGO**

- Técnico: MEDIO (motor bug es real).
- Governance: BAJO (canónica única simplifica autoridad).
- Precedente: legitima YAML como TCB del CCP.

**REVERSIBILIDAD**

- **MEDIA**. `git revert` restaura estado; motor bridge queda como código muerto; workflow humano requiere retraining para volver a editar regex.

**LOCK-IN**

- **ALTO** (todas las opciones D1-D4). Formato canónico compromete arquitectura futura.
- D5 tiene lock-in bajo pero LT (long-term value) = 0.

**VALOR DE INFORMACIÓN**

- Info faltante clave: FP rate real de PAC sobre corpus de 20+ policies.
- Experimento reversible: PAC shadow compilation en CI durante 3 meses SIN cutover; medir FP rate.
- Umbral: si FP <5% → D4 se refuerza; si >10% → reconsiderar.

**ALTERNATIVAS HÍBRIDAS**

- **D4 + DEC-11 H2 + shadow**: motor corre en CI, produce warnings, NO reemplaza firewall runtime → compra información sin cutover.
- **D1 con `.md` estructurado + parser restringido**: menor lock-in tecnológico, menor gain en escalabilidad.
- **DEC-04 diferida productivamente**: D5 explícito con `trigger: 20+ policies o 3 FPs documentados`.

**IMPACTO SOBRE DECISIONES FUTURAS**

- DEC-05: obligatoria si D1/D3/D4.
- DEC-06: forma cambia (READY-01/02 son edits de canónica).
- DEC-07: F2 puede consumir metadata YAML (`known_fp_classes:`) para calibrar reviewer LLM.
- DEC-11: revisit F9-D01 es precondición si motor toca runtime.

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner planea PT-2 (100+ policies) → D4 gana peso decisivo.
- Si Owner mantiene S1 (10 policies) → D5 sigue siendo racional.
- Si PAC-EF-02 escala a >5% FP rate → D4 recomendación baja.
- Si Owner rechaza YAML como TCB → D1 gana peso (Markdown estructurado).

**RECOMMENDATION CONFIDENCE**

- **<60% para cualquier opción hoy**. Evidencia insuficiente para recomendar a tercero.
- Sugerencia: NO decidir DEC-04 en solitario hoy. Correr experimento shadow (§7 INFO-GAP-1) primero.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Cerramos GAP-1 con canónica declarada (D1/D3/D4) o compramos información antes (D5 + shadow experiment)?**
- Owner necesita saber:
  - Volumen de policies esperado a 12 meses.
  - Tolerancia a lock-in de formato canónico.
  - Si acepta 3 meses de shadow antes de cutover.
- Ver §5 para tratamiento completo.

---

### 4.5 DEC-05 — D-MOTOR

```text
════════════════════════════════════════════════════════════
DEC-05 — D-MOTOR (motor de derivación canónica → derivados)
════════════════════════════════════════════════════════════

STATUS ................ VALID + IRREDUCIBLE (con DEC-04)
PRECEDENCIAS .......... DEC-04 (HARD)
DEPENDENCIAS .......... DEC-06 (HARD DERIVED)
CATEGORÍA ............. arquitectural / derivation
```

**ESPACIO DE OPCIONES**

- **E1 — Manual sync**. Sin nuevo TCB; humano actualiza derivados a mano.
- **E2 — Motor unidireccional**. Canónica → motor → firewall + tests + opcional `.md`.
- **E3 — Motor bidireccional**. E2 + derivación inversa.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: `compile_policies.sh` (~150 líneas) prueba E2 en research.
- `DOCUMENTED`: PAC-EF-02 muestra FP class emergen (E2 no es plug-and-play).
- `INFERENCE`: E1 con DEC-04 ≠ D5 es incoherente (drift asegurado).

**PIEZAS AFECTADAS**

- Insertadas: P-MTR + P-DERIV-CONTRACT.
- Primitivas: PRIM-3 DERIVATION.

**BEFORE → AFTER (Op E2)**

- BEFORE: sync manual (o inexistente).
- AFTER: cambio en canónica → build → nuevo firewall generado.
- INTERFACES: CI pipeline gana step de motor; commit rechazado si motor no idempotente.

**REGRESIONES POSIBLES**

- Motor bug → firewall incorrecto (mitigable con tests dedicated).
- Latencia CI por motor lento.

**COSTE**

- Implementación: MEDIO (motor + tests idempotencia + tests no-drift).
- Mantenimiento: MEDIO (motor requiere ajustes con nuevas FP classes).
- Cognitivo: BAJO (una vez implementado, transparente).

**RIESGO**

- Técnico: MEDIO.
- Governance: BAJO.
- Precedente: motor como TCB legitima futuros motores derivadores.

**REVERSIBILIDAD**

- MEDIA. Sin motor, canónica queda sin sincronización → drift.

**LOCK-IN**

- MEDIO (motor reemplazable si canónica se mantiene).

**VALOR DE INFORMACIÓN**

- Info faltante: idempotencia real de PAC compiler sobre corpus grande.
- Experimento: correr motor 100× sobre YAML actual + comparar outputs.

**ALTERNATIVAS HÍBRIDAS**

- E2 con motor en shadow (produce diff advisory, no reemplaza).
- E2 con motor en pre-commit hook (bloquea commit si drift, no si build).

**IMPACTO SOBRE DECISIONES FUTURAS**

- Habilita DEC-06 (READY-01/02 son edits de canónica).
- Ilumina DEC-07 (metadata YAML puede alimentar reviewer LLM).
- Ilumina DEC-STREAM-CONSUMER (motor puede emitir eventos consumibles).

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si DEC-04 = D5 → E1 (o N/A).
- Si DEC-04 ≠ D5 → E2 dominante (E1 incoherente, E3 sobre-engineered).

**RECOMMENDATION CONFIDENCE**

- 75% para E2 si DEC-04 ≠ D5. Baja si DEC-04 aún indecidida.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **Coacoplada con DEC-04. ¿Motor unidireccional viable (E2) o bidireccional (E3)?**
- Owner necesita saber:
  - Si acepta motor como TCB nuevo.
  - Que E3 rara vez es justificable (complejidad extra).

---

### 4.6 DEC-07 — D-VERIFICADOR

```text
════════════════════════════════════════════════════════════
DEC-07 — D-VERIFICADOR (verificación semántica post-tool)
════════════════════════════════════════════════════════════

STATUS ................ VALID
PRECEDENCIAS .......... DEC-02 (HARD)
DEPENDENCIAS .......... DEC-REVIEWER-VERDICT (SOFT)
CATEGORÍA ............. delegation / verification
```

**ESPACIO DE OPCIONES**

- **F1 — Humano solo** (actual).
- **F2 — LLM adversarial + humano**. Subagente `code-reviewer` invocado obligatoriamente en SubagentStop.
- **F3 — Dual-LLM adversarial**.
- **F4 — Segundo humano**. Impracticable con solo Owner.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: `.claude/agents/code-reviewer.md` existe (read-only tools).
- `DOCUMENTED`: F1 escala mal en S2/S3; K3-U-09 (correlated failure) documentado.
- `HYPOTHESIS`: F2 alivia PT-1 (carga humana).

**PIEZAS AFECTADAS**

- (F2) Movidas: P-H (menor carga sintáctica); P-A (recibe verdict pre-review).
- Nuevas interfaces: `subagentStop → code-reviewer verdict → gate`.
- Primitivas tocadas: PRIM-1 AUTHORITY-KIND (verificación delegada).

**BEFORE → AFTER (Op F2)**

- BEFORE: humano ex-post commit; sin filtro sintáctico previo.
- AFTER: LLM post-tool + humano ex-post commit; humano ve pre-filtrado.
- INTERFACES: nuevo verdict logging; potencial fallo de skill humano por dependencia.

**REGRESIONES POSIBLES**

- Correlated failure (U-09): dos LLMs comparten sesgo.
- Jailbreak sobre el reviewer.
- Skill drift del humano.

**COSTE**

- Implementación: MEDIO.
- Mantenimiento: MEDIO (LLM provider dependency, upgrades).
- Recurrente: LLM API cost por commit.

**RIESGO**

- Técnico: MEDIO (jailbreak, correlated failure).
- Governance: MEDIO sin DEC-02 (delegación implícita).
- Provider dependence: ALTA.

**REVERSIBILIDAD**

- MEDIA. Volver a F1 requiere restaurar skill humano (posible pérdida).

**LOCK-IN**

- ALTO sobre provider LLM.

**VALOR DE INFORMACIÓN**

- Info faltante: FP/FN rate de LLM reviewer sobre commits pasados.
- Experimento: correr LLM reviewer sobre 100 commits históricos sin bloquear; comparar con reviewer humano.

**ALTERNATIVAS HÍBRIDAS**

- F2 sólo en modo "advisory" (no bloquea).
- F2 con abstraction layer (varios providers intercambiables).
- F2 solo para tipos de cambio ≠ security/arch (mantener humano para high-stakes).

**IMPACTO SOBRE DECISIONES FUTURAS**

- Ilumina DEC-REVIEWER-VERDICT (cómo emitir verdict).
- Requiere DEC-02 upstream para delegación explícita.

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner planea escalar equipo → F2 gana peso.
- Si Owner rechaza dependencia LLM → F1.
- Si experimento muestra FP LLM >20% → F2 baja.

**RECOMMENDATION CONFIDENCE**

- 50%. Alta variabilidad; depende de tolerancia a LLM dependency.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Delegamos verificación sintáctica a LLM adversarial (F2) o mantenemos humano-only (F1)?**
- Owner necesita saber:
  - Volumen de commits/día y carga humana actual.
  - Tolerancia a provider dependence.
  - Si acepta correr shadow experiment primero.

---

### 4.7 DEC-08 — D-INSTR

```text
════════════════════════════════════════════════════════════
DEC-08 — D-INSTR (schema STALL completo)
════════════════════════════════════════════════════════════

STATUS ................ VALID + CONDITIONAL (bloqueada por F9-D01=A)
PRECEDENCIAS .......... DEC-11 (HARD para G2)
DEPENDENCIAS .......... DEC-09 (DERIVED), DEC-STREAM-CONSUMER (MUTUAL)
CATEGORÍA ............. schema / instrumentation
```

**ESPACIO DE OPCIONES**

- **G1 — No hacer nada**. `had_alternative` = null; `session_id` = null.
- **G2 — Modificar `stall-record.sh`**. Aceptar inputs reales; añadir `verdict:` field. **Cruza F9-D01**.
- **G3 — Shadow runtime**. Instrumentado paralelo; productivo no cambia.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: `stall-record.sh:46` hardcodea `had_alternative:null`; `session_id` es "" → null.
- `VERIFIED`: 19 rows con schema partial; 82% harness noise.
- `DOCUMENTED`: 3 UNKNOWNs (U-01, U-02, READY-03 empírica) bloqueados sin schema completo.

**PIEZAS AFECTADAS**

- (G2) Movidas: P-LE schema (`had_alternative`, `session_id`, `verdict`).
- Vecinos: P-BB, P-GT (callers deben propagar valores reales).
- Primitivas: PRIM-5 PROVENANCE se completa.

**BEFORE → AFTER (Op G2)**

- BEFORE: schema-partial; 2 fields dead.
- AFTER: schema-complete; verdict field disponible; U-01/U-02/READY-03 observables.
- INTERFACES: schema extendido; backwards-compat con default null.

**REGRESIONES POSIBLES**

- Hook bug → eventos malformados (mitigable con tests).
- Precedente F9-D01 revisit sin DEC-11 → ad-hoc.

**COSTE**

- Implementación: BAJO (~20 LoC).
- Mantenimiento: BAJO.
- Cognitivo: BAJO.

**RIESGO**

- Técnico: BAJO.
- Governance: MEDIO sin DEC-11 (precedente ad-hoc).
- Precedente: legitima F9-D01 revisit formal si con DEC-11.

**REVERSIBILIDAD**

- ALTA (default null preserva histórico).

**LOCK-IN**

- BAJO.

**VALOR DE INFORMACIÓN**

- Info faltante: distribución real de STALLs por policy_category y verdict.
- Experimento: G2 en shadow durante 30 días → produce datos sin cruzar F9-D01 en producción.

**ALTERNATIVAS HÍBRIDAS**

- G2 con DEC-11 previa formal (dominante).
- G3 shadow como precursor de G2 (compra información).
- G2 sólo con `verdict:` (sin tocar `had_alternative` y `session_id`).

**IMPACTO SOBRE DECISIONES FUTURAS**

- Habilita DEC-09 empírica (READY-03).
- Ilumina DEC-STREAM-CONSUMER (consumer necesita schema estable).
- Establece precedente de revisit F9-D01 (bueno si con DEC-11; malo si ad-hoc).

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si DEC-11 aprobada previa → G2 dominante.
- Si Owner rechaza revisit F9-D01 → G3 (shadow).
- Si volumen STALL crece rápido → urgencia sube.

**RECOMMENDATION CONFIDENCE**

- 65% para G2 CON DEC-11 previa. Baja sin DEC-11.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Extendemos schema STALL con F9-D01 revisit formal (G2 + DEC-11) o vamos por shadow (G3)?**
- Owner necesita saber:
  - Si DEC-11 está en horizonte.
  - Cuántos UNKNOWNs realmente dependen de esto.
  - Si tolera ~20 LoC de cambio en hook con revisit documentado.

---

### 4.8 DEC-11 — D-DEFERRAL-POLICY

```text
════════════════════════════════════════════════════════════
DEC-11 — D-DEFERRAL-POLICY (política de deferrals con trigger)
════════════════════════════════════════════════════════════

STATUS ................ VALID (raíz DAG)
PRECEDENCIAS .......... ninguna
DEPENDENCIAS .......... DEC-08 (HARD), DEC-13-absorbido
CATEGORÍA ............. governance / meta-policy
```

**ESPACIO DE OPCIONES**

- **H1 — No hacer nada**. Deferrals acumulan; governance decay monotónico.
- **H2 — Política declarativa**. Cada deferimiento gana `trigger:`; default trimestral.
- **H3 — Política + runbook**. H2 + `maintenance.sh` check "deferrals sin trigger o vencidos".

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: F9-D01..D05 son deferrals con rationale pero sin `trigger:` mecánico declarado.
- `DOCUMENTED`: K3-D-DEFERRAL-LIFECYCLE nombra el problema.
- `INFERENCE`: sin política, cada revisit crea precedente ad-hoc.

**PIEZAS AFECTADAS**

- Insertadas: `DEFERRAL_POLICY.md` + convención.
- Primitivas: PRIM-4 LIFECYCLE se refuerza.
- Ideas: IDEA-7 (deferral as policy) materializada.

**BEFORE → AFTER (Op H2)**

- BEFORE: deferrals "hasta trigger concreto" sin criterio.
- AFTER: cada deferral con condición observable; revisión periódica.
- INTERFACES: workflow Owner cambia (declarar trigger al diferir).

**REGRESIONES POSIBLES**

- Trigger vago detectable en review.
- Sobre-formalización si volumen es bajo.

**COSTE**

- Implementación: BAJO (30 min/deferral inicial retrofit).
- Mantenimiento: BAJO (~1h trimestral).
- Cognitivo: BAJO-MEDIO (obliga a pensar cuándo revisitar).

**RIESGO**

- Técnico: NULO.
- Governance: BAJO (mayor claridad).
- Precedente: legitima "declarar antes de diferir".

**REVERSIBILIDAD**

- ALTA.

**LOCK-IN**

- BAJO.

**VALOR DE INFORMACIÓN**

- Info faltante: cuántos deferrals implícitos existen hoy.
- Experimento: enumerar F9-D01..D05 + otros deferrals históricos + retrofit `trigger:`.

**ALTERNATIVAS HÍBRIDAS**

- H2 + retrofit inmediato para F9-D01..D05.
- H2 + campo `escalation:` (a quién se notifica cuando trigger se dispara).
- H3 con check en `maintenance.sh` (que ya corre 12/12).

**IMPACTO SOBRE DECISIONES FUTURAS**

- Habilita DEC-08 G2 con precedente formal.
- Absorbe DEC-13 (external-triggered) como campo `trigger:`.
- Base para toda decisión futura de "diferir".

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner planea DEC-08 pronto → H2 obligatoria antes.
- Si Owner tolera governance decay → H1 (statu quo) coherente pero costoso a mediano plazo.

**RECOMMENDATION CONFIDENCE**

- 85% para H2 (o H3, marginalmente mejor).

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Formalizamos deferrals con `trigger:` obligatorio (H2 o H3)?**
- Owner necesita saber:
  - Que H2 desbloquea DEC-08 con precedente limpio.
  - Que H3 es coste marginal sobre H2 con máxima auditabilidad.
  - Que sin esto, cada revisit F9-D01 crea precedente ad-hoc.

---

### 4.9 DEC-12 — D-META-DOC

```text
════════════════════════════════════════════════════════════
DEC-12 — D-META-DOC (política de cap sobre meta-doc)
════════════════════════════════════════════════════════════

STATUS ................ VALID (raíz DAG)
PRECEDENCIAS .......... ninguna
DEPENDENCIAS .......... DEC-03 (SOFT)
CATEGORÍA ............. governance / documental
```

**ESPACIO DE OPCIONES**

- **I1 — No hacer nada**. Meta-doc crece libre; PT-3 activo antes.
- **I2 — Política de cap**. 30 activos en `docs/00_SYSTEM/`; excedente → archive.
- **I3 — Convención supersedes**. Cada handoff → `supersedes:` archivado.
- **I4 — I2 + I3**. Ambas.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: `docs/00_SYSTEM/` tiene 44 archivos hoy (>30, ya sobre cap propuesto).
- `DOCUMENTED`: PT-3 (fricción por volumen doc).
- `INFERENCE`: sin cap, degradación de usabilidad monotónica.

**PIEZAS AFECTADAS**

- Insertadas: política + `archive/` directorio.
- Movidas: workflow handoff (declarar supersedes).

**BEFORE → AFTER (Op I4)**

- BEFORE: crecimiento monotónico; 44 archivos en `docs/00_SYSTEM/`.
- AFTER: cap enforced por convención; supersedes rastrea evolución.
- INTERFACES: reviewer archiva excedente.

**REGRESIONES POSIBLES**

- Archive prematuro de doc aún útil.

**COSTE**

- Implementación: BAJO (~1h para archivar 14+ archivos excedentes).
- Mantenimiento: BAJO.
- Cognitivo: BAJO.

**RIESGO**

- Técnico: NULO.
- Governance: BAJO.

**REVERSIBILIDAD**

- ALTA.

**LOCK-IN**

- BAJO.

**VALOR DE INFORMACIÓN**

- Info faltante: cuáles archivos actuales son obsoletos vs activos.
- Experimento: revisar cada archivo con últimos 90 días de acceso/edit.

**ALTERNATIVAS HÍBRIDAS**

- I4 + script auto-archive por edad.
- I2 solo (sin supersedes explícito).

**IMPACTO SOBRE DECISIONES FUTURAS**

- Reduce fricción para agentes futuros (menos archivos que leer).
- Complementa DEC-03 (front-matter permite auto-supersedes).

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner quiere preservar histórico legible sin archive → I3 solo.
- Si Owner prioriza performance de context loading → I4.

**RECOMMENDATION CONFIDENCE**

- 75% para I4.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Aplicamos cap 30 + supersedes convención (I4)?**
- Owner necesita saber:
  - Que hoy hay 44 archivos en `docs/00_SYSTEM/`.
  - Que cap es convención, no enforcement mecánico.

---

### 4.10 DEC-STREAM-CONSUMER (nueva)

```text
════════════════════════════════════════════════════════════
DEC-STREAM-CONSUMER — construcción de consumer para STALL log
════════════════════════════════════════════════════════════

STATUS ................ NEW
PRECEDENCIAS .......... DEC-08 (MUTUAL), DEC-11 (SOFT)
DEPENDENCIAS .......... ninguna hoja
CATEGORÍA ............. instrumentation / consumer
```

**ESPACIO DE OPCIONES**

- **CO1 — No hacer nada**. STALL log write-only; triage manual ad-hoc via HRQS §12.
- **CO2 — Consumer manual documentado**. Convención + script CLI que ejecuta reviewer bajo demanda.
- **CO3 — Consumer automático con reglas**. Script en `maintenance.sh` que clasifica y emite reporte periódico.
- **CO4 — Consumer LLM-triage**. LLM procesa nuevas filas y produce recomendaciones.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: 19 filas hoy; 82% harness noise.
- `DOCUMENTED`: sin consumer, log crece sin propósito operativo.
- `INFERENCE`: si DEC-08 G2 → schema estable → consumer se vuelve más útil.

**PIEZAS AFECTADAS**

- Insertada: `P-STREAM-CONSUMER` (ME).
- Movidas: HRQS §12 se compensa parcialmente por consumer automático.
- Relación nueva: `CONSUME[P-ES → P-STREAM-CONSUMER]`.

**BEFORE → AFTER (Op CO3)**

- BEFORE: log write-only; señales enterradas en 82% ruido.
- AFTER: reporte periódico con clasificación; señal accesible.
- INTERFACES: `maintenance.sh` gana step; posible email/notification si crítico.

**REGRESIONES POSIBLES**

- Consumer bug clasifica mal → falsa señal.
- Consumer sin schema completo (DEC-08 G1) → baja utilidad.

**COSTE**

- Implementación: CO2 BAJO / CO3 MEDIO / CO4 ALTO.
- Mantenimiento: proporcional.
- Cognitivo: BAJO.

**RIESGO**

- Técnico: BAJO-MEDIO.
- Governance: BAJO.

**REVERSIBILIDAD**

- ALTA (script eliminable).

**LOCK-IN**

- BAJO (CO2), MEDIO (CO3), ALTO (CO4).

**VALOR DE INFORMACIÓN**

- Info faltante: patrones reales de STALL con schema completo.
- Experimento: CO2 primero → informa CO3 más adelante.

**ALTERNATIVAS HÍBRIDAS**

- CO2 + reglas mínimas hardcoded (10 líneas).
- CO3 sólo para `stall_type=UNKNOWN` (foco en lo diagnosticado como no-clasificado).

**IMPACTO SOBRE DECISIONES FUTURAS**

- Ilumina DEC-08 (consumer estable requiere schema estable).
- Facilita DEC-09 empírica (consumer produce metrics).

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si DEC-08 = G1 → CO2 solo (no vale la pena automatizar sobre schema partial).
- Si DEC-08 = G2 → CO3 se vuelve viable.
- Si volumen STALL crece a >100/mes → CO3/CO4 urgente.

**RECOMMENDATION CONFIDENCE**

- 60% para CO2 como primer paso, CO3 tras DEC-08 G2.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Cerramos el loop write→read del STALL log con consumer?**
- Owner necesita saber:
  - Que CO2 es coste mínimo y compra información para CO3.
  - Que sin DEC-08, el valor es limitado.

---

### 4.11 DEC-AUTH-BOUNDARY (nueva)

```text
════════════════════════════════════════════════════════════
DEC-AUTH-BOUNDARY — materialización de primitiva AUTHORITY-KIND
════════════════════════════════════════════════════════════

STATUS ................ NEW
PRECEDENCIAS .......... ninguna (raíz)
DEPENDENCIAS .......... DEC-02 (HARD), DEC-04 (SOFT)
CATEGORÍA ............. governance / meta-model
```

**ESPACIO DE OPCIONES**

- **AB1 — No hacer nada**. AUTHORITY-KIND vive como columna del piece catalog; no como entidad.
- **AB2 — Registry documental**. `AUTHORITY_BOUNDARY.md` mapea cada pieza a `mecánica|convención|humana|agente` con reglas de cambio.
- **AB3 — Registry + integración con DELEG-REG**. AB2 + referencia mutua con DEC-02.

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: cada pieza del catálogo AUDIT tiene columna "Autoridad".
- `DOCUMENTED`: K3-D-AUTHZ-VS-VERIF sin registro explícito del objeto.
- `INFERENCE`: DEC-02 opera en abstracto sin este objeto.

**PIEZAS AFECTADAS**

- Insertada: `P-AUTH-BOUNDARY` (AR).
- Primitivas: PRIM-1 AUTHORITY-KIND materializada.

**BEFORE → AFTER (Op AB2)**

- BEFORE: columna implícita del catálogo.
- AFTER: registry consultable + reglas de cambio de autoridad.

**REGRESIONES POSIBLES**

- Registry desactualizado (detectable en HRQS).

**COSTE**

- Implementación: BAJO (~1-2h).
- Mantenimiento: BAJO.

**RIESGO**

- Técnico: NULO.
- Governance: BAJO.

**REVERSIBILIDAD**

- ALTA.

**LOCK-IN**

- BAJO.

**VALOR DE INFORMACIÓN**

- Info faltante: cuántas piezas cambian de autoridad realmente.
- Experimento: enumerar los últimos 6 cambios de autoridad efectivos (F9-D01, F8-A endureció P-GT, etc.).

**ALTERNATIVAS HÍBRIDAS**

- AB2 embebido en piece catalog del AUDIT (evitar doc separada).
- AB3 con integración explícita en DELEG-REG.

**IMPACTO SOBRE DECISIONES FUTURAS**

- Precondición limpia para DEC-02.
- Ilumina DEC-04 (autoridad sobre canónica).
- Ilumina DEC-07 (delegación de verificación).

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner considera que la columna del piece catalog es suficiente → AB1.
- Si Owner planea DEC-02 en próximas semanas → AB2 obligatoria.

**RECOMMENDATION CONFIDENCE**

- 75% para AB2 como precursor de DEC-02.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Materializamos AUTHORITY-KIND como registry documental (AB2)?**
- Owner necesita saber:
  - Que DEC-02 depende conceptualmente de este objeto.
  - Que es una decisión de bajo lock-in y alto valor conceptual.

---

### 4.12 DEC-REVIEWER-VERDICT (nueva)

```text
════════════════════════════════════════════════════════════
DEC-REVIEWER-VERDICT — cerrar asimetría P-H vs P-O
════════════════════════════════════════════════════════════

STATUS ................ NEW
PRECEDENCIAS .......... DEC-07 (SOFT)
DEPENDENCIAS .......... ninguna hoja
CATEGORÍA ............. governance / evidence
```

**ESPACIO DE OPCIONES**

- **RV1 — No hacer nada**. Reviewer humano ACK implícito en `git commit`; sin verdict semántico.
- **RV2 — Commit trailer convención**. Cada commit reviewer añade `Reviewed-by:` + `Review-verdict:` en trailer.
- **RV3 — HRQS §12 formaliza artefacto**. Cada review produce entry en registry (más pesado).

**EVIDENCIA DISPONIBLE**

- `VERIFIED`: F9_OWNER_DECISIONS.md contiene decisiones Owner con rationale; no hay equivalente para reviewer.
- `DOCUMENTED`: asimetría identificada en AUDIT §32 GAP-META-1.
- `INFERENCE`: reviewer verdict semántico no capturado → auditoría ex-post limitada a `git blame`.

**PIEZAS AFECTADAS**

- (RV2) Movidas: convención de commit reviewer.
- Primitivas: PRIM-5 PROVENANCE se completa para reviewer.

**BEFORE → AFTER (Op RV2)**

- BEFORE: `git blame` es única traza del reviewer.
- AFTER: commit trailer con verdict semántico consultable.

**REGRESIONES POSIBLES**

- Trailer omitido en apuro (mitigable con git hook `commit-msg`).
- Trailer vago sin significado.

**COSTE**

- Implementación: BAJO (documentar convención + ejemplo).
- Mantenimiento: MUY BAJO.
- Cognitivo: BAJO (30s por commit reviewer).

**RIESGO**

- Técnico: NULO.
- Governance: BAJO (mayor traza).

**REVERSIBILIDAD**

- ALTA.

**LOCK-IN**

- BAJO.

**VALOR DE INFORMACIÓN**

- Info faltante: si HRQS §12 ya cubre esto parcialmente.
- Experimento: revisar HRQS §12 actual + últimos 20 commits reviewer.

**ALTERNATIVAS HÍBRIDAS**

- RV2 con enum de verdicts (`approved | approved-with-notes | requested-changes`).
- RV2 sólo para tipos de cambio ≠ trivial.

**IMPACTO SOBRE DECISIONES FUTURAS**

- Base para DEC-07 F2 (comparar verdict humano vs LLM).
- Ilumina experimentos de calibración reviewer LLM.

**CONDICIONES BAJO LAS QUE CAMBIA LA RECOMENDACIÓN**

- Si Owner tolera asimetría P-H vs P-O → RV1.
- Si Owner planea DEC-07 F2 → RV2 obligatoria.

**RECOMMENDATION CONFIDENCE**

- 55%. Novedad AUDIT MEDIA-ALTA; sin verificar redundancia con HRQS §12.

**PREPARACIÓN PARA EL OWNER**

- Pregunta central: **¿Convertimos ACK implícito reviewer en trailer semántico (RV2)?**
- Owner necesita saber:
  - Que HRQS §12 puede o no cubrir esto (verificar antes).
  - Que RV2 es precursor limpio para DEC-07 F2.

---

## §5. DEC-04 DEEP TREATMENT (FASE 4)

DEC-04 requiere análisis extendido por su lock-in ALTO en todas las opciones no-triviales.

### 5.1 Descomposición de la decisión

DEC-04 tal como está formulada ("D1/D2/D3/D4/D5") mezcla 3 decisiones más pequeñas:

**Sub-decisión 5.1.a — ¿Cerrar GAP-1?**

- Opciones: SÍ / NO / DEFER-EMPIRICAL.
- SÍ implica: al menos una canónica declarada + al menos un derivado.
- NO implica: D5 permanentemente + aceptar sync manual como statu quo.
- DEFER-EMPIRICAL implica: D5 con `trigger: 20+ policies o 3 FPs documentados`.

**Sub-decisión 5.1.b — ¿Qué formato de canónica?**

- Sólo aplica si 5.1.a = SÍ.
- Opciones: `.md estructurado` (D1) / `regex` (D2) / `tests` (D3) / `YAML` (D4).

**Sub-decisión 5.1.c — ¿Dirección de motor?**

- Sólo aplica si canónica ≠ D5.
- Opciones: unidireccional (E2) / bidireccional (E3) / manual (E1).
- Se solapa con DEC-05.

**Conclusión**: DEC-04 debería reformularse como paquete 5.1.a + 5.1.b + DEC-05, presentado al Owner en ese orden. **La sub-decisión 5.1.a es la que domina el resto**.

### 5.2 Mapeo contra la terna GOVERNED DERIVATION

| DEC-04 | DEC-05 | DEC-02 | Coherente | Racional |
|---|---|---|---|---|
| D4 | E2 | B2 | **SÍ** | Máxima gobernanza + escalabilidad. ALTO lock-in. |
| D4 | E1 | * | **NO** | canónica declarada + sync manual = drift asegurado. |
| D4 | E3 | B2 | Parcial | Sobre-engineered; ganancia baja. |
| D1 | E2 | B2 | SÍ | Menor lock-in tecnológico; menor escalabilidad. |
| D1 | E2 | B1 | Parcial | Motor edita canónica sin delegación explícita → K3-D-OWNER-DEFAULT. |
| D2 | E1 | * | Parcial | Simplificación extrema; pérdida ergonómica alta. |
| D3 | E2 | B2 | SÍ | Paradigma tests-as-contract; lock-in TCB tests. |
| D5 | N/A | * | SÍ | Statu quo; LT value = 0. |
| D5 | E2 | * | **NO** | Motor sin canónica ¿qué compila? |

**Combinaciones incoherentes explícitas**: `D4+E1`, `D5+E2`.
**Combinaciones dominantes**: `D4+E2+B2` (máximo valor + máximo lock-in); `D1+E2+B2` (balance).

### 5.3 Shadow / Experiment Paths

Para cada opción no trivial, path shadow que produce información sin cutover:

**D4 + E2 shadow**:

- Correr `compile_policies.sh` en CI diariamente sobre `ccp_policies.yaml`.
- Comparar output regex contra `bash-firewall.sh` actual.
- Medir: FP rate sobre 30 días, tiempo de motor, idempotencia.
- Duración recomendada: 3 meses.
- Coste: 0 runtime, ~2 días implementación CI.
- **NO cruza F9-D01** (research → CI, no runtime).

**D1 shadow**:

- Migrar 1 rule (`security.md`) a formato estructurado propuesto.
- Escribir parser Markdown restringido.
- Correr parser + compare con firewall.
- Duración: 4 semanas.
- Coste: mayor que D4 shadow (parser custom).

**D3 shadow**:

- Escribir 5 policies como tests bloqueantes.
- Correr en pre-tool con timing.
- Medir: latencia agregada.
- Duración: 4 semanas.
- Coste: MEDIO.

**Recomendación**: **D4 shadow es el path que compra más información con menor coste**. Es un experimento reversible que informaría el cutover DEC-04 dentro de 3 meses.

### 5.4 Lock-in Budget

Qué se cierra irreversiblemente con cada opción:

**D1**:

- Formato Markdown estructurado como TCB.
- Parser custom es dependencia futura.
- Decisiones futuras de policy compleja limitadas por gramática MD.

**D2**:

- Regex como único contrato de policy.
- Pérdida permanente de doc humana estructurada.
- Reviewer humano dependencia de skill regex.
- Onboarding severamente afectado.

**D3**:

- Test runner como TCB.
- Latencia pre-tool comprometida.
- Framework de tests es dependencia recurrente.

**D4**:

- YAML como formato canónico permanente.
- Motor como TCB nuevo.
- FP framework como pieza permanente.
- Migración off-YAML es costosa.

**D5**:

- Lock-in bajo pero costo acumulativo (sync manual perpetuo; drift asegurado a largo plazo).

**Conclusión**: **D2 tiene el peor lock-in** (elimina doc humana permanentemente). **D5 tiene el menor lock-in pero paga costo acumulativo**. **D4 tiene el mayor lock-in técnico pero es el que maximiza LT value**.

### 5.5 Falsifier explícito

Evidencia que haría rechazar cada opción:

**D4 rechazable si**:

- PAC shadow experiment muestra FP rate >10% sostenido.
- Motor produce outputs no idempotentes en >5% de corridas.
- Reviewer humano rechaza YAML como formato de trabajo (>50% resistance).

**D1 rechazable si**:

- Parser Markdown custom introduce ambiguity en >10% de policies.
- Expresividad Markdown insuficiente para >20% del corpus futuro.

**D3 rechazable si**:

- Latencia pre-tool aumenta >200ms por policy.
- Tests permiten gaming (bypass detectado en test).

**D5 rechazable si**:

- Policy corpus crece a 20+ dentro de 6 meses.
- ≥3 incidentes concretos de drift `.md ↔ regex`.

**D2 rechazable si**: prácticamente cualquier evidencia (opción con peor tradeoff).

### 5.6 Reset Path

Si dentro de 6 meses el Owner quiere volver atrás:

**Desde D4 a D5**:

- `git revert` de motor + YAML.
- Restaurar sync manual de `.md ↔ regex`.
- Coste: MEDIO. Workflow humano requiere retraining.
- Datos históricos: preservados (git).

**Desde D1 a D5**:

- Restaurar placeholders en `.md`.
- Eliminar parser.
- Coste: BAJO.

**Desde D3 a D5**:

- Reinstalar regex en firewall.
- Eliminar test framework de hooks.
- Coste: MEDIO. Latencia rollback.

**Desde D2 a D5**:

- Restaurar `.md` desde histórico git.
- Coste: BAJO técnico, ALTO humano (reconstruir memoria).

**Desde D5 a D1/D3/D4**:

- Path completo del cutover; coste igual que primera implementación.

### 5.7 Recomendación condicional (no absoluta)

```text
Si Owner tolera lock-in ALTO Y planea PT-2 (100+ policies):
  → D4+E2+B2 dominante. Correr shadow 3 meses antes de cutover.

Si Owner prioriza legibilidad humana Y ergonomía:
  → D1+E2+B2. Parser Markdown restringido; menor escalabilidad.

Si Owner acepta statu quo con costo acumulativo:
  → D5 explícito con DEC-11 H2 y trigger declarativo.
  Nunca "D5 por default"; siempre "D5 con condiciones".

Si Owner rechaza cualquier lock-in significativo:
  → D5 + PAC shadow research permanente.
```

**Ninguna de estas es "la respuesta"**. Son cuatro configuraciones coherentes; el Owner elige según su horizonte y tolerancia al lock-in.

---

## §6. SEQUENCING (FASE 5)

### 6.1 Secuencia recomendada

Criterio de prioridad: raíces DAG con bajo lock-in y alto valor de información primero.

```text
FASE OPERATIVA A — GOVERNANCE BASE (semana 1-2)
  1. DEC-11 H2       (raíz DAG; habilita DEC-08 formal; coste bajo)
  2. DEC-01 A2       (raíz DAG; precondición DEC-02; coste bajo)
  3. DEC-AUTH-BOUNDARY AB2 (raíz DAG; precondición conceptual DEC-02; coste bajo)
  4. DEC-02 B2       (habilita DEC-07; elimina K3-D-OWNER-DEFAULT; coste bajo)
  5. DEC-12 I4       (independiente; coste bajo; reduce PT-3)
  6. DEC-03 C4       (independiente; coste bajo)

FASE OPERATIVA B — INSTRUMENTATION (semana 3-4)
  7. DEC-08 G2       (requiere DEC-11 previa; coste bajo; desbloquea UNKNOWNs)
  8. DEC-STREAM-CONSUMER CO2 (coste bajo; ilumina CO3 futuro)

FASE OPERATIVA C — GOVERNED DERIVATION (mes 2-4)
  9. Iniciar D4 shadow experiment (§5.3); NO decidir DEC-04 aún.
  10. DEC-04 + DEC-05 + DEC-06 (paquete tras 3 meses de shadow data).

FASE OPERATIVA D — VERIFICATION DELEGATION (mes 5+)
  11. DEC-REVIEWER-VERDICT RV2 (precursor DEC-07 F2).
  12. DEC-07 F2 (con datos de commits históricos y shadow LLM).
```

### 6.2 Secuencia alternativa

Si Owner prioriza **cerrar GAP-1 rápido** (no comprar información):

```text
1. DEC-11 H2                       (precondición formal)
2. DEC-01 + DEC-AUTH-BOUNDARY + DEC-02   (Bloque A completo en paralelo)
3. DEC-04 + DEC-05 + DEC-06         (terna directa, sin shadow)
4. Resto según secuencia recomendada.
```

Tradeoff: cierra GAP-1 en 6-8 semanas vs 5-6 meses. Coste: decidir DEC-04 con evidencia limitada (recommendation confidence <60%).

### 6.3 Bloques coherentes

- **Bloque A (Governance base)**: {DEC-11, DEC-01, DEC-AUTH-BOUNDARY, DEC-02, DEC-12, DEC-03}. Todo lock-in bajo; decidibles en una sesión de Owner sin riesgo.
- **Bloque B (Instrumentation loop)**: {DEC-08, DEC-STREAM-CONSUMER}. Requiere Bloque A parcial (DEC-11).
- **Bloque IRREDUCIBLE (Governed Derivation)**: {DEC-04, DEC-05, DEC-06}. Decidir como unidad; requiere shadow experiment o aceptar bajo confidence.
- **Bloque D (Verification)**: {DEC-REVIEWER-VERDICT, DEC-07}. Puede ir en paralelo con Bloque B.

### 6.4 Quick wins (bajo coste, alto valor)

- DEC-11 H2: 30 min/deferral + 1h retrofit de F9-D01..D05 → detiene governance decay.
- DEC-01 A2: 1-2h → elimina zona gris K3-D-OWNER-DEFAULT parcialmente.
- DEC-12 I4: 1h + archive → mejora usabilidad `docs/00_SYSTEM/` inmediata.
- DEC-AUTH-BOUNDARY AB2: 1-2h → materializa primitiva; ilumina DEC-02.

**Recomendación**: los 4 quick wins pueden cerrarse en **una sola sesión de Owner de 2-3 horas**. Producen governance base sin cruzar F9-D01.

### 6.5 Deferrables con trigger declarativo

Aplicando IDEA-7 (DEC-11 H2):

- **DEC-04**: `trigger: (PAC shadow FP rate <5% sostenido 3 meses) OR (corpus policy ≥20 IDs)`.
- **DEC-07 F2**: `trigger: (DEC-02 aprobada) AND (backlog reviewer humano ≥N commits/semana)`.
- **DEC-STREAM-CONSUMER CO3**: `trigger: (DEC-08 G2 aprobada) AND (volumen STALL ≥100/mes)`.
- **DEC-REVIEWER-VERDICT**: `trigger: (DEC-07 F2 en horizonte próximo)`.

### 6.6 Hard blockers

Decisiones sin las cuales el CCP no puede avanzar:

- **DEC-11**: sin política de deferral, cada revisit crea precedente ad-hoc. **Debe decidirse pronto**.
- **DEC-04 (implícita)**: puede diferirse formalmente con DEC-11 H2, pero no puede ignorarse indefinidamente.

---

## §7. INFORMATION VALUE + EXPERIMENTS (FASE 6)

### INFO-GAP-1: FP rate real de PAC sobre corpus real

```text
DESCRIPCIÓN     : FP rate de motor PAC sobre 20+ policies validadas.
DECISIONES      : DEC-04 (crítica), DEC-05 (crítica), DEC-07 F2 (parcial).
CÓMO OBTENERLA  :
  Experimento reversible: PAC shadow compilation en CI diaria durante 3 meses.
  Coste: ~2 días implementación + costo CI recurrente bajo.
  Duración: 3 meses.
  Requiere autorización Owner: NO (research, no runtime).
VALOR           : ALTO. Desbloquea DEC-04 con confidence ≥70%.
CROSS F9-D01    : NO.
```

### INFO-GAP-2: Distribución real de STALL con schema completo

```text
DESCRIPCIÓN     : patrones de STALL por policy_category y verdict con datos reales.
DECISIONES      : DEC-08 (crítica), DEC-09 (crítica), DEC-STREAM-CONSUMER (parcial).
CÓMO OBTENERLA  :
  Opción A: DEC-08 G3 (shadow runtime). Coste: MEDIO. NO cruza F9-D01.
  Opción B: DEC-08 G2 tras DEC-11 H2. Coste: BAJO. Cruza F9-D01 con precedente formal.
  Duración: 30-60 días.
VALOR           : ALTO. Desbloquea 3 UNKNOWNs (U-01, U-02, READY-03 empírica).
CROSS F9-D01    : Depende de opción.
```

### INFO-GAP-3: Piloto de delegación

```text
DESCRIPCIÓN     : evidencia empírica de que delegación explícita funciona.
DECISIONES      : DEC-02 (parcial), DEC-07 (parcial).
CÓMO OBTENERLA  :
  Registrar 1 delegación piloto en DELEG-REG hipotético (Markdown draft).
  Ejemplo: delegación de `code-reviewer` para tipos de cambio `docs/*`.
  Duración: 30 días.
  Coste: BAJO.
  Requiere autorización Owner: SÍ para "activarla".
VALOR           : MEDIO. Ilumina DEC-02 con caso concreto.
CROSS F9-D01    : NO (registro documental).
```

### INFO-GAP-4: LLM verifier calibración

```text
DESCRIPCIÓN     : FP/FN rate del LLM reviewer sobre commits reales.
DECISIONES      : DEC-07 (crítica), DEC-REVIEWER-VERDICT (parcial).
CÓMO OBTENERLA  :
  Correr LLM reviewer sobre 100 commits históricos (last 6 months).
  Comparar con verdicts humanos (git blame + review comments si existen).
  Coste: BAJO (script + LLM API).
  Duración: 1-2 días.
VALOR           : ALTO. Cambia recommendation confidence DEC-07 de 50% a ≥70%.
CROSS F9-D01    : NO (offline).
```

### INFO-GAP-5: Cobertura HRQS §12 sobre reviewer verdict

```text
DESCRIPCIÓN     : verificar si HRQS §12 ya cubre GAP-META-1 del AUDIT.
DECISIONES      : DEC-REVIEWER-VERDICT (crítica).
CÓMO OBTENERLA  :
  Leer HRQS §12 actual + revisar últimos 20 commits reviewer.
  Coste: MUY BAJO (30 min).
VALOR           : ALTO. Determina si DEC-REVIEWER-VERDICT es real o duplicate.
CROSS F9-D01    : NO.
```

### INFO-GAP-6: Volumen real de policy corpus

```text
DESCRIPCIÓN     : cuántas policies el CCP realmente necesitará a 12 meses.
DECISIONES      : DEC-04 (crítica).
CÓMO OBTENERLA  :
  Owner declara horizonte + escenarios S1/S2/S3.
  Enumeración de policies latentes en `docs/research/pac/`.
VALOR           : ALTO. Cambia peso relativo D4 vs D5.
CROSS F9-D01    : NO.
```

**Priorización experimental**: INFO-GAP-1 y INFO-GAP-5 son los de mejor ratio información/coste. Ambos pueden iniciarse esta semana sin autorización adicional.

---

## §8. CONDITIONAL TREES (FASE 7)

### 8.1 Árbol DEC-04 → downstream

```text
DEC-04
├── D4 (YAML canónica)
│   ├── DEC-05
│   │   ├── E2 → coherente; DEC-06 = edits YAML
│   │   ├── E1 → INCOHERENTE (drift asegurado)
│   │   └── E3 → sobre-engineered
│   ├── DEC-06 → auto-derivada (edits YAML)
│   ├── DEC-07 F2 → puede consumir metadata YAML
│   └── DEC-STREAM-CONSUMER → puede correlacionar con `policy_id` del YAML
├── D1 (Markdown canónica)
│   └── DEC-05 E2 con parser MD custom
├── D3 (tests canónica)
│   └── nuevo TCB test runner
├── D2 (regex canónica)
│   └── DEC-05 se disuelve (sin canónica declarada)
│   └── pérdida P-PT
└── D5 (statu quo)
    ├── DEC-05 → N/A
    ├── DEC-06 → statu quo (owner aprueba caso por caso)
    └── DEC-11 → prioridad ALTA (deferral formal necesario)
```

### 8.2 Árbol DEC-11 → downstream

```text
DEC-11
├── H1 (no hacer nada)
│   └── DEC-08 G2 → precedente ad-hoc si se decide
│   └── governance decay monotónico
├── H2 (política declarativa)
│   ├── DEC-08 G2 → viable con precedente formal
│   └── DEC-13 → absorbida como campo `trigger:`
└── H3 (H2 + runbook)
    └── mismo que H2 + auditabilidad automática
```

### 8.3 Árbol DEC-02 → downstream

```text
DEC-02
├── B1 (no hacer nada)
│   ├── DEC-07 F2 → delegación implícita (riesgo governance)
│   └── K3-D-OWNER-DEFAULT persiste
├── B2 (registry Markdown)
│   ├── DEC-07 F2 → viable con delegación explícita
│   ├── DEC-04 D4 → autoridad sobre canónica clara
│   └── DEC-REVIEWER-VERDICT → puede referenciar DELEG-REG
└── B3 (registry + hook)
    └── Cruza F9-D01; requiere DEC-11 previa
```

### 8.4 Árbol DEC-08 → downstream

```text
DEC-08
├── G1 (no hacer nada)
│   ├── DEC-09 → cierre con caveat "no empírico"
│   └── DEC-STREAM-CONSUMER → CO2 solo (schema partial limita utilidad)
├── G2 (schema completo runtime)
│   ├── DEC-09 → resolvible con N sesiones
│   ├── DEC-STREAM-CONSUMER → CO3 viable
│   └── requiere DEC-11 previa (o precedente ad-hoc)
└── G3 (shadow runtime)
    └── produce datos sin cruzar F9-D01; coste operativo
```

---

## §9. ADVERSARIAL AUDIT (FASE 8)

Preguntas + correcciones:

- [x] **¿Recomendando implícitamente sin cruzar la línea?** — TODA recomendación es condicional. Ningún "elegí X" absoluto.
- [x] **¿Asumiendo que las 13 originales eran correctas?** — 4 retiradas (DEC-06, DEC-09, DEC-10, DEC-13); 3 nuevas agregadas.
- [x] **¿Tratando decisiones acopladas como independientes?** — Terna DEC-04+05+02 marcada IRREDUCIBLE en §2, §3, §5, §6.
- [x] **¿Ignorando información faltante crítica?** — 6 INFO-GAPs listados en §7, con experimentos reversibles.
- [x] **¿Contando el mismo argumento en múltiples decisiones sin decir que es el mismo?** — K3-D-OWNER-DEFAULT referenciado con etiqueta consistente; no duplicado como razonamiento nuevo.
- [x] **¿Secuencia recomendada minimiza lock-in o esfuerzo?** — Explícito: raíces DAG bajo-lock-in primero (§6.1).
- [x] **¿DEC-04 recibió tratamiento proporcional?** — §5 es la sección más extensa del documento.
- [x] **¿Preservé la incertidumbre?** — Marcas HYPOTHESIS, UNKNOWN, INFERENCE distribuidas; ninguna afirmación forzada.
- [x] **¿Alguna "opción" es ausencia de opción?** — DEC-04 D5 explícitamente marcada como "defer productivo con trigger", no default silencioso.
- [x] **¿Hay decisiones nuevas del AUDIT omitidas?** — 3 incluidas; `P-CONTRACT-REGISTRY` marcada UNKNOWN, no promovida.

**Correcciones aplicadas durante escritura**:

- INFO-GAP-5 agregado explícitamente después de detectar que DEC-REVIEWER-VERDICT podría ser duplicate de HRQS §12.
- DEC-04 §5.7 reformulada de "recomendación" a "4 configuraciones coherentes" para no cruzar la línea.
- Secuencia alternativa (§6.2) agregada para tolerancia distinta a información.

---

## §10. OWNER HANDOFF PACKAGE

> Ficha mínima autocontenida por decisión. Diseñada para que el Owner decida SIN releer este documento.

---

### FICHA — DEC-11 D-DEFERRAL-POLICY (RAÍZ, quick win)

**Pregunta**: ¿Cada deferral gana campo `trigger:` obligatorio?

**Opciones**:

- **H1**: statu quo (deferrals sin trigger; governance decay).
- **H2**: convención declarativa (cada deferral con `trigger:` observable).
- **H3**: H2 + check en `maintenance.sh`.

**Sabemos**: F9-D01..D05 son deferrals sin `trigger:` mecánico; sin política, cada revisit crea precedente ad-hoc.

**NO sabemos**: si Owner prefiere trimestral fijo vs trigger declarativo por deferral.

**Condicional**: si Owner planea DEC-08 pronto → H2 obligatoria antes.

**Preguntas al Owner**:

- ¿Aceptás retrofit `trigger:` a F9-D01..D05 en 1 hora?
- ¿H3 (con runbook check) o H2 (sin)?

---

### FICHA — DEC-01 D-CATALOG (quick win)

**Pregunta**: ¿Materializamos catálogo de tipos de cambio como Markdown?

**Opciones**:

- **A1**: statu quo (reviewer improvisa).
- **A2**: `CHANGE_TYPES_CATALOG.md` con `type × gate × auth_holder × precedent`.
- **A3**: A2 + hook rechaza tipo no listado (**cruza F9-D01**).

**Sabemos**: 5 tipos observados en git log; sin catálogo, DEC-02 no puede formularse limpiamente.

**NO sabemos**: si emergerán más tipos.

**Condicional**: A2 dominante si DEC-02 está en horizonte próximo.

**Preguntas al Owner**:

- ¿Empezamos con los 5 tipos observados + placeholder "otros"?

---

### FICHA — DEC-AUTH-BOUNDARY (quick win, nueva)

**Pregunta**: ¿Materializamos AUTHORITY-KIND como registry documental?

**Opciones**:

- **AB1**: statu quo (columna del piece catalog).
- **AB2**: `AUTHORITY_BOUNDARY.md` con reglas de cambio.
- **AB3**: AB2 + integración con DELEG-REG.

**Sabemos**: primitiva verificada en AUDIT; DEC-02 opera sobre este objeto.

**NO sabemos**: si Owner considera que la columna del catálogo es suficiente.

**Condicional**: AB2 obligatoria si DEC-02 en horizonte.

**Preguntas al Owner**:

- ¿AB2 como precursor limpio de DEC-02?

---

### FICHA — DEC-02 D-DELEG

**Pregunta**: ¿Registry Markdown de delegaciones?

**Opciones**:

- **B1**: statu quo (K3-D-OWNER-DEFAULT persiste).
- **B2**: `DELEGATION_REGISTRY.md` con contratos revocables.
- **B3**: B2 + hook (**cruza F9-D01**).

**Sabemos**: 5 subagentes + 6 tipos runtime; ninguno con delegación explícita.

**NO sabemos**: cuántas delegaciones implícitas existen hoy.

**Condicional**: B2 obligatoria antes de DEC-07 F2.

**Preguntas al Owner**:

- ¿1 delegación piloto (INFO-GAP-3) antes de generalizar?

---

### FICHA — DEC-12 D-META-DOC (quick win, independiente)

**Pregunta**: ¿Cap 30 + supersedes convención?

**Opciones**:

- **I1**: crecimiento libre.
- **I2**: cap 30 archivos.
- **I3**: supersedes convención.
- **I4**: I2 + I3.

**Sabemos**: hoy hay 44 archivos en `docs/00_SYSTEM/` (>30, sobre cap propuesto).

**NO sabemos**: cuáles archivos actuales son obsoletos.

**Condicional**: I4 dominante para reducir fricción agentes futuros.

**Preguntas al Owner**:

- ¿Archivar 14+ archivos excedentes esta semana?

---

### FICHA — DEC-03 D-LIFECYCLE (independiente)

**Pregunta**: ¿Front-matter en research artifacts?

**Opciones**:

- **C1**: crecimiento silencioso.
- **C2**: front-matter en todos los docs.
- **C3**: registry activo (`ARTIFACT_LIFECYCLE_REGISTRY.md`).
- **C4**: front-matter sólo research.

**Sabemos**: `docs/research/` tiene ≥75 archivos sin front-matter uniforme.

**NO sabemos**: cuántos están obsoletos.

**Condicional**: C4 suficiente si Owner archiva research post-K3.

**Preguntas al Owner**:

- ¿C4 (sólo research) o C2 (todo)?

---

### FICHA — DEC-08 D-INSTR (requiere DEC-11 previa)

**Pregunta**: ¿Extendemos schema STALL runtime (G2) o vamos por shadow (G3)?

**Opciones**:

- **G1**: statu quo (dead fields).
- **G2**: modificar `stall-record.sh` (~20 LoC). **Cruza F9-D01; requiere DEC-11**.
- **G3**: shadow runtime instrumentado.

**Sabemos**: 3 UNKNOWNs bloqueados por schema-partial; `stall-record.sh:46` hardcodea `had_alternative:null`.

**NO sabemos**: distribución real de STALLs sin schema completo.

**Condicional**: G2 dominante si DEC-11 H2 aprobada previamente.

**Preguntas al Owner**:

- ¿DEC-11 H2 primero, luego G2? O ¿G3 shadow inmediato?

---

### FICHA — DEC-STREAM-CONSUMER (nueva, requiere DEC-08 idealmente)

**Pregunta**: ¿Cerramos loop write→read del STALL log?

**Opciones**:

- **CO1**: statu quo (triage manual).
- **CO2**: consumer manual documentado.
- **CO3**: consumer automático con reglas.
- **CO4**: consumer LLM-triage.

**Sabemos**: 82% harness noise; log write-only sin lector.

**NO sabemos**: patrones reales con schema completo.

**Condicional**: CO2 como primer paso; CO3 tras DEC-08 G2.

**Preguntas al Owner**:

- ¿CO2 esta semana o esperar DEC-08?

---

### FICHA — DEC-04 D-CANONICAL ⚠️ ALTO LOCK-IN

**Pregunta**: ¿Cerramos GAP-1 con canónica declarada o compramos información antes?

**Opciones**:

- **D1**: Markdown estructurado canónico.
- **D2**: regex canónico (pérdida de doc humana).
- **D3**: tests canónicos.
- **D4**: YAML canónico (PAC-family).
- **D5**: statu quo con `trigger:` declarativo.

**Sabemos**: PAC prototype existe; PAC-EF-02 muestra FP class emerge; sync manual es la fragilidad central del CCP.

**NO sabemos**: FP rate real de PAC sobre corpus de 20+ policies (INFO-GAP-1).

**Condicional**: si Owner planea PT-2 (100+ policies) → D4+E2+B2 dominante. Si prioriza legibilidad → D1. Si tolera statu quo → D5+trigger.

**Recomendación operacional**: **NO decidir DEC-04 hoy**. Correr D4 shadow experiment 3 meses (§5.3), decidir con datos.

**Preguntas al Owner**:

- ¿Horizonte de volumen policy a 12 meses?
- ¿Tolerancia a lock-in YAML?
- ¿Aceptás 3 meses de shadow antes de cutover?

**Ver también**: §5 tratamiento completo (obligatorio antes de cerrar esta ficha).

---

### FICHA — DEC-05 D-MOTOR (dep. DEC-04)

**Pregunta**: ¿Motor unidireccional (E2) o bidireccional (E3)?

**Opciones**:

- **E1**: manual sync (incoherente si DEC-04 ≠ D5).
- **E2**: motor unidireccional canónica → derivados.
- **E3**: bidireccional (rara vez justificable).

**Sabemos**: `compile_policies.sh` prueba E2 en research.

**Condicional**: E2 si DEC-04 ≠ D5. E1 si DEC-04 = D5.

**Preguntas al Owner**:

- Cocoacoplada con DEC-04. Decidir como paquete.

---

### FICHA — DEC-REVIEWER-VERDICT (nueva)

**Pregunta**: ¿Convertimos ACK reviewer en trailer semántico?

**Opciones**:

- **RV1**: statu quo (`git blame` como traza).
- **RV2**: commit trailer con `Reviewed-by:` + `Review-verdict:`.
- **RV3**: registry HRQS.

**Sabemos**: asimetría P-H vs P-O identificada en AUDIT §32.

**NO sabemos**: si HRQS §12 ya cubre esto (INFO-GAP-5).

**Condicional**: RV2 obligatoria si DEC-07 F2 en horizonte.

**Preguntas al Owner**:

- ¿Verificar HRQS §12 antes de decidir? (INFO-GAP-5 lo resuelve en 30 min).

---

### FICHA — DEC-07 D-VERIFICADOR

**Pregunta**: ¿Delegamos verificación sintáctica a LLM adversarial?

**Opciones**:

- **F1**: humano solo (actual).
- **F2**: LLM + humano.
- **F3**: dual-LLM.
- **F4**: segundo humano (impracticable).

**Sabemos**: `code-reviewer` subagente existe; K3-U-09 (correlated failure) documentado.

**NO sabemos**: FP/FN rate LLM sobre commits reales (INFO-GAP-4).

**Condicional**: F2 dominante si DEC-02 previa + INFO-GAP-4 muestra FP <20%.

**Preguntas al Owner**:

- ¿Volumen de commits/día actual?
- ¿Correr INFO-GAP-4 antes de decidir?

---

## §11. COMPLETENESS CHECKLIST

- [x] BASELINE_SNAPSHOT registrado (§0).
- [x] Las 13 decisiones originales auditadas (§2.1).
- [x] Decisiones nuevas del AUDIT propuestas y evaluadas (§2.2).
- [x] Decision space validated consolidado (§2.3).
- [x] Dependency graph completo (§3).
- [x] Terna irreducible confirmada (§3.2, §5.2).
- [x] Per-decision analysis con framework rico (§4).
- [x] Ningún campo del framework omitido por comodidad.
- [x] DEC-04 con tratamiento especial (§5).
- [x] Sequencing recomendado + alternativa (§6).
- [x] Quick wins identificados (§6.4).
- [x] Deferrables con trigger declarativo (§6.5).
- [x] INFO-GAPs con experimentos reversibles (§7).
- [x] Conditional trees para decisiones acopladas (§8).
- [x] Adversarial audit ejecutado (§9).
- [x] Owner Handoff Package con fichas autocontenidas (§10).
- [x] Ninguna decisión cerrada; sólo espacios preparados.
- [x] Ninguna recomendación absoluta; todas condicionales.
- [x] Epistemología preservada (VERIFIED/DOCUMENTED/INFERENCE/HYPOTHESIS/UNKNOWN).

**Estado**: DECISION_SPACE_PREPARED completo. Owner puede iniciar decisiones siguiendo §6.1 o §6.2 con fichas §10.

---

## APÉNDICE — PRÓXIMOS PASOS PARA EL OWNER

1. **Leer §1 Executive Finding + §10 Owner Handoff Package** (~15 min).
2. **Decidir secuencia**: §6.1 (con shadow) vs §6.2 (rápido, menor confidence).
3. **Sesión Owner 1** (2-3h): cerrar los 4 quick wins (§6.4) — Bloque A (governance base).
4. **Sesión Owner 2**: iniciar DEC-08 G2 tras DEC-11.
5. **Iniciar experimentos** INFO-GAP-1 (PAC shadow) e INFO-GAP-5 (HRQS §12 verificación) en paralelo.
6. **Sesión Owner 3 (mes 2-4)**: cerrar la terna GOVERNED DERIVATION con datos.
7. **Sesiones posteriores**: DEC-07 y DEC-REVIEWER-VERDICT con INFO-GAP-4 resuelto.

**Cada sesión Owner debe re-alimentar el espacio de la siguiente decisión** (recomposición dinámica). Este documento NO es final; es la mesa preparada. Después de cada decisión cerrada, las fichas subsiguientes deben re-verificarse contra el nuevo estado.

**FIN DEL DOCUMENTO.**
