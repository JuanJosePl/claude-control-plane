# POST-ARCH-007 DECISION SPACE RECOMPOSITION — PARTIAL EXECUTION

> Stratum-C analytical artifact (untracked). NOT canonical. NOT an Owner Decision.
> NOT an implementation authorization. NOT a checkpoint.
> Fecha: 2026-09-27. Autor: Claude Opus 4.7 (analyst, no decisor).
> Estado: **PARTIAL — session interrupted by usage-limit boundary**.
>
> Reglas: DETERMINAR ≠ CORREGIR · RECOMENDAR ≠ DECIDIR · CANDIDATE ≠ OPEN · OPEN ≠ OWNER_CHOSEN.

---

## §0. EXECUTIVE NOTE (READ FIRST)

Esta ejecución del Master Prompt "POST-ARCH-007 Decision Space Recomposition" **se detuvo antes
de completar el análisis integral de 40+ secciones**. El corte se produjo en el bloque de lectura
de baselines (después de reconstruir strata, verificar checkpoint y revalidar la relación
DEC-01→DEC-02 desde `DEC-01_D-CATALOG_DECISION_GATE.md §14`). El material capturado aquí es
**auditable pero incompleto**: se afirma únicamente lo verificado en esta sesión.

**Confidence global del artefacto**: MEDIA para §1-§6 (baseline + strata + snapshot verificados
en disco); MEDIA-BAJA para §7 (dependency revalidation basada exclusivamente en la lectura del
gate document); **UNKNOWN** para todo el resto (§8+ del Master Prompt). Ninguna recomendación
sobre "siguiente decisión" se emite aquí; hacerlo con esta profundidad sería un anti-patrón que
esta misma sesión hubo de identificar contra sí.

---

## §1. BASELINE VERIFICATION

```text
git rev-parse HEAD           → e5293591500c515e64f87417a72a8a1c8655da47   ✓ matches expected e529359
git branch --show-current    → main
git log --oneline -5:
   e529359 [CONFIG] checkpoint: ARCH-007 (DEC-01 D-CATALOG) implementation — E SPLIT+DEFER
   473759c [CONFIG] checkpoint: ARCH-006 (DEC-AUTH-BOUNDARY) implementation — AB5 + VOCAB-A
   cd0511c [CONFIG] checkpoint: DEC-11 (ARCH-005) implementation — HYB-FINAL-v4 retrofit
   4277830 [CONFIG] checkpoint: DEC-11 closed (ARCH-005 persisted, IMPL_PENDING)
   f496897 [CONFIG] checkpoint: MASTER_HANDOFF + K3 corpus + RA audit

git show --stat HEAD:
   DECISION_REGISTRY.md               | 114 ++++++++++++++++++
   PROJECT_STATE.md                   |  54 ++++++++++++--
   docs/00_SYSTEM/DECISION_HISTORY.md | 104 ++++++++++++++++++-
   3 files changed, 261 insertions(+), 11 deletions(-)
```

**Verdict**: HEAD coincide con el expected del Master Prompt. Sin divergencia. Sin necesidad de
corrección.

---

## §2. STRATUM ANALYSIS

| Stratum | Ámbito | Contenido observado (2026-09-27) |
|---|---|---|
| **A — CHECKPOINTED** | Todo hasta `e529359` incluyendo ARCH-001..ARCH-007. | Persistido en HEAD; git-show confirma que ARCH-007 se materializó como docs-only bookkeeping (3 archivos, sin runtime, sin hooks, sin skills, sin rules, sin taxonomía nueva). |
| **B — POST-CHECKPOINT BOOKKEEPING** | Modificaciones staged/unstaged posteriores a `e529359`. | `M PROJECT_STATE.md` (única diff: `LAST_GIT_CHECKPOINT: 473759c → e529359`, línea 146). `M docs/00_SYSTEM/CLAUDE_SESSION_LOG.md` (append de 4 entradas de sesión 2026-09-27 10:01/10:43/11:00/11:14). **Ambas son bookkeeping legítimo del post-commit ARCH-007**. |
| **C — ANALYTICAL ARTIFACTS** | Untracked, no comiteados por este trabajo. | `CCP_MASTER_EXECUTION_PROMPT.md`; `docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md`; `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md`; `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md`. Este artefacto (`POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md`) es nuevo Stratum-C de esta sesión. |

Regla operativa: **no borrar, no stagear, no comitear** ningún Stratum-C. Su persistencia queda
a criterio Owner.

---

## §3. ARCH-007 CHECKPOINT VALIDATION

Verificado en `git show e529359`:

- ✓ ARCH-007 presente en `DECISION_REGISTRY.md` (líneas 165-270).
- ✓ Owner Choice registrada como **E (SPLIT + DEFER)**.
- ✓ E1 (type-taxonomy) DEFERRED con bloque YAML `dec01.T1..T6` en `PROJECT_STATE.DEFERRED`.
- ✓ E2 (gate-mapping) RETIRED con `RESOLVED_BY:` = hooks + rules + settings.
- ✓ E3 (auth_holder-mapping) RETIRED con `RESOLVED_BY:` = ARCH-006 / AUTHORITY_KIND.md.
- ✓ E4 (precedent-index) RETIRED con `RESOLVED_BY:` = DECISION_REGISTRY + DECISION_HISTORY + git.
- ✓ Relación DEC-01 → DEC-02 registrada como **SOFT / ENABLER** (no HARD histórico), con
  referencia al gate document §14 como fuente de la revalidación.
- ✓ Sin runtime nuevo, sin hooks, sin rules, sin creación de `CHANGE_TYPES_CATALOG.md`,
  `CHANGE_TYPE_TAXONOMY.md`, `DELEGATION_REGISTRY.md`, `AUTHORITY_BOUNDARY.md`.
- ✓ ARCH-006 intacto (verificado por diff: cambios en `DECISION_REGISTRY.md` en HEAD tocan solo
  bloque ARCH-007, no ARCH-006).
- ✓ DECISION_HISTORY.md contiene entrada DEC-01 con 3 in-flight lessons (framing genealogy;
  SPLIT+DEFER pattern; ARCH-006 propagation gap).

**Verdict**: ARCH-007 checkpoint íntegro. Sin inconsistencias detectadas.

---

## §4. CANONICAL STATE SNAPSHOT (post-ARCH-007)

Consolidado de `PROJECT_STATE.md`, `DECISION_REGISTRY.md`, `docs/00_SYSTEM/DECISION_HISTORY.md`:

```text
CURRENT_PHASE               : 8
PHASE_STATUS                : COMPLETE
LAST_GIT_CHECKPOINT         : e529359
IMPLEMENTATION_READY        : false
NEXT_ALLOWED_PHASE          : None auto — owner-driven decision requerida

ACTIVE_DECISIONS (registered ARCH-*):
  ARCH-001  Scope de proyecto (INFRA, APROBADA)
  ARCH-002  Carga de context packs (INFRA, APROBADA)
  ARCH-003  Ruta canonica de evidence (INFRA, APROBADA)
  ARCH-004  Task Tracking Semantics (PROCESS, APROBADA + F8-A addendum)
  ARCH-005  Deferral Policy (DEC-11) — GOVERNANCE, CHECKPOINTED cd0511c
  ARCH-006  DEC-AUTH-BOUNDARY (AUTHORITY_KIND) — GOVERNANCE, CHECKPOINTED 473759c
  ARCH-007  DEC-01 D-CATALOG (SPLIT + DEFER) — GOVERNANCE, CHECKPOINTED e529359

RESOLVED_OWNER_DECISIONS:
  F9-D01=A, F9-D02=B, F9-D03=B, F9-D04=B, F9-D05=A (2026-09-20)
  DEC-11 = HYB-FINAL-v4                          (2026-09-26)
  DEC-AUTH-BOUNDARY = AB5 + VOCAB-A              (2026-09-26)
  DEC-01 = E (SPLIT + DEFER)                     (2026-09-27)

DEFERRED (con trigger blocks YAML):
  CDT-02       (cluster-B, EVENT owner authorization)
  AC-03        (cluster-B, EVENT owner authorization; TRIGGER-4 external)
  NH-11        (HYPOTHESIS-tier, exempt per INV-4)
  F10-F12      (LINK a F9-D05 T1..T7)
  DEC-01-E1    (type-taxonomy — dec01.T1..T6, combine ANY)

ENVIRONMENT_BLOCKS: H-01 materiality; P1'/P2' FP rate; Native Claude Code lifecycle
```

Nota canónica: **DEC-01 monolítico histórico ya NO figura como decisión activa ni pending**. Fue
retirado del grafo activo por particionamiento; sólo E1 permanece observable como DEFERRED.

---

## §5. DECISION STATE RECONCILIATION (SETS A–E)

Regla Master Prompt §6: `ACTIVE_DECISIONS` ≠ `OPEN OWNER_CANDIDATES`.

### SET A — IN-FORCE / ACTIVE (approved & vigentes)

```
ARCH-001, ARCH-002, ARCH-003, ARCH-004, ARCH-005, ARCH-006, ARCH-007
```

### SET B — CLOSED / RESOLVED (owner-chosen, absorbed into A)

```
F9-D01..D05             (2026-09-20)
DEC-11 → ARCH-005       (2026-09-26)
DEC-AUTH-BOUNDARY → ARCH-006 (2026-09-26)
DEC-01 → ARCH-007       (2026-09-27, via SPLIT+DEFER)
```

### SET C — DEFERRED (Owner-authorized, con trigger canónico)

```
CDT-02       (EVENT owner authorization)
AC-03        (EVENT owner authorization + TRIGGER-4 external)
NH-11        (HYPOTHESIS-tier, no observable predicate)
F10-F12      (LINK a F9-D05 T1..T7)
DEC-01-E1    (dec01.T1..T6, combine ANY)
```

### SET D — OPEN OWNER CANDIDATES (require new Owner Choice)

**UNKNOWN / PENDING analysis.** Esta sesión NO completó la revalidación individual de cada
candidato histórico (DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-08, DEC-12,
DEC-STREAM-CONSUMER, DEC-REVIEWER-VERDICT) contra el nuevo estado post-ARCH-007. No se emite
recomendación de "siguiente decisión" hasta que esa revalidación se complete en una sesión
sucesora.

Lo único revalidado en esta sesión (§7 abajo): la dependencia **DEC-01 → DEC-02** ya no es
HARD; es SOFT/ENABLER. Esto significa que DEC-02, si eventualmente se abriera, NO está
técnicamente bloqueada por la ausencia de un D-CATALOG materializado. Pero eso NO implica que
DEC-02 sea la siguiente decisión candidata: ese juicio requiere el análisis §22-§34 del Master
Prompt que no se ejecutó.

### SET E — RETIRED / ABSORBED

```
DEC-06        RETIRED (deriva de DEC-04+DEC-05)
DEC-09        RETIRED (deriva de DEC-08 + N sesiones)
DEC-10        RETIRED (trivial, reversibilidad total)
DEC-13        RETIRED (no es decisión; absorbida por ARCH-005 trigger)

Sub-decisiones DEC-01 post-ARCH-007:
DEC-01-E2     RETIRED  → RESOLVED_BY hooks + rules + settings
DEC-01-E3     RETIRED  → RESOLVED_BY ARCH-006 / AUTHORITY_KIND.md
DEC-01-E4     RETIRED  → RESOLVED_BY DECISION_REGISTRY + DECISION_HISTORY + git
```

---

## §6. GHOST DECISION SCAN (parcial)

Búsqueda de decisiones absorbidas/retiradas que sigan apareciendo como si estuvieran abiertas.

Verificado en `PROJECT_STATE.md`, `DECISION_REGISTRY.md`, `docs/00_SYSTEM/DECISION_HISTORY.md`:

- ✓ **NO GHOSTS** para DEC-06, DEC-09, DEC-10, DEC-13 (no aparecen como pending).
- ✓ **NO GHOSTS** para DEC-01 monolítico (retirado del grafo activo; solo E1 observable como DEFERRED).
- ⚠ **NO VERIFICADO** en `MASTER_HANDOFF.md` (3903 líneas, no leído en esta sesión). Es posible
  que MASTER_HANDOFF §13.1 aún contenga la formulación histórica A1/A2/A3 de DEC-01; la
  entrada DECISION_HISTORY.md DEC-01 in-flight lesson "framing genealogy" reconoce que
  MASTER_HANDOFF §7.1/§13.1 mantiene el framing pre-ataque. Esto NO es una inconsistencia si
  MASTER_HANDOFF es tratado como **snapshot** (ARCH-006 §7 declara MASTER_HANDOFF snapshot).
- ⚠ **NO VERIFICADO** en `DECISION_SPACE_PREPARED.md` (2145 líneas, leído parcialmente).
  §2.3 preserva DEC-01 D-CATALOG como VALID; §3.1 preserva DEC-01→DEC-02 [HARD]; §4.1 preserva
  A1/A2/A3. **Esas afirmaciones están ahora invalidadas por ARCH-007 pero el documento es
  Stratum-C untracked (frozen snapshot analítico)**. No requiere corrección; requiere que el
  lector futuro sepa leer ambos documentos con conciencia de fecha.

**Verdict parcial**: No hay ghosts en fuentes canónicas verificadas. Los artefactos analíticos
Stratum-C reflejan el estado del momento de su producción; deben leerse como snapshots
epistémicos, no como fuentes de verdad post-ARCH-007.

---

## §7. DEC-01 → DEC-02 REVALIDATION (heredado del gate document §14)

Esta sección resume la revalidación ya ejecutada en `DEC-01_D-CATALOG_DECISION_GATE.md §14`
(que forma parte de la evidencia sobre la que ARCH-007 se decidió). NO es análisis nuevo de
esta sesión; es re-lectura y compact-summary del contenido ya persistido.

**Historical claim**: `DEC-01 → DEC-02 = HARD` (MASTER §8.1; DECISION_SPACE_PREPARED §3.1).

**Semantic attack (gate §14.2)**: la formulación canónica de DEC-02 (MASTER §13.2) opera sobre
`action_type`, no `change_type`. Éstas son dimensiones distintas:

- `action_type` = qué acción es delegable (code-review, authorization, verification,
  artifact-production). Enumerable por AUTHORITY_KIND `{ mecánica, convención, humana, agente }`.
- `change_type` = qué prefijo lleva el commit (feat, fix, docs, arch, decision, security,
  infra, config — ya en `.claude/rules/git-policy.md`).

**Revised classification (gate §14.4)**: **SOFT / OPTIONAL_BENEFIT**, no HARD.

**Consecuencia relevante para la recomposición**:

- La afirmación histórica "DEC-01 precondición HARD del Bloque A completo" es hereditary error
  del framing pre-ARCH-006.
- **DEC-02 puede diseñarse hoy** consultando `AUTHORITY_KIND.md` como taxonomía canónica única;
  ARCH-007 no es precondición HARD.
- La urgencia declarada en DECISION_SPACE_PREPARED §6.1 ("`DEC-01 → DEC-02` obligatorio en
  Bloque A") **desaparece**.

**Confidence**: MEDIA-ALTA (misma confidence declarada en el gate §14.4). Refutable solo si un
futuro DEC-02 elige `change_type` como key primaria del registry — escenario que activaría el
trigger `dec01.T2` y reabriría E1.

**No se examina aquí** la relación análoga ARCH-006 → DEC-02: `AUTHORITY_KIND.md §7` ya la
declara SOFT/ENABLER. Corolario cruzado: DEC-02 no tiene HARD upstream conocido después de
ARCH-005/ARCH-006/ARCH-007.

---

## §8. ARCH-007 PROPAGATION AUDIT

Efectos verificables de ARCH-007 (DEC-01 = E SPLIT+DEFER) sobre el resto del sistema.

### 8.1 Premisas invalidadas por ARCH-007

| Premisa histórica | Origen | Estado post-ARCH-007 |
|---|---|---|
| "D-CATALOG es la pieza faltante que Kimi K3 identificó como GAP" | MASTER §28.1 (CATALOG entre 6 GAP pieces) | **INVALIDATED**: D-CATALOG monolítico no era una entidad coherente. GAP-piece list se reduce de 6 → 5 (DERIVE-OP, DELEG-REG, LIFECYCLE-REG, POL-CANON, SHADOW-RT). |
| "DEC-01 → DEC-02 es HARD (categorías son precondición del registry)" | MASTER §8.1; DECISION_SPACE_PREPARED §3.1 | **INVALIDATED → SOFT/ENABLER** por gate §14. Consecuencia: DEC-02 sin HARD upstream. |
| "El Bloque A (governance base) tiene 6 decisiones acopladas" | DECISION_SPACE_PREPARED §6.1 | **INVALIDATED**: DEC-01 retirada del Bloque A; ARCH-005/ARCH-006 ya cerradas → sólo restan DEC-02, DEC-12, DEC-03 potencialmente en un Bloque A degenerado a 3. |
| "A2 (Markdown declarativo) es quick win 85% confidence" | DECISION_SPACE_PREPARED §4.1 | **INVALIDATED**: Alternative D del gate document rechazada estructuralmente. |

### 8.2 Piezas afectadas por ARCH-007

- **P-CAT** (nueva pieza propuesta en MASTER §31.1 vía DEC-01 A2): **NEVER MATERIALIZED**. RETIRE definitivo.
- **CATALOG** en la lista GAP: retirado como decisión monolítica; sólo E1 permanece observable como DEFERRED. La ausencia semántica queda registrada, no exige materialización.

### 8.3 Precedente introducido por ARCH-007 (nuevo patrón de decisión)

**SPLIT + DEFER** como técnica de cierre: particionar un objeto histórico monolítico en sub-decisiones con veredictos independientes, RETIRE con `RESOLVED_BY:` puntero a fuente-de-verdad efectiva, y DEFER sólo el remanente observable.

Es un patrón **procedural nuevo** disponible para futuras decisiones donde el ataque adversarial revele que la formulación heredada mezcla objetos con source-of-truth distinto. Se suma al catálogo de patrones procedurales:

- ARCH-005 pattern: docs-only retrofit + YAML in-document (representación ≠ semántica).
- ARCH-006 pattern: taxonomy-only + closed vocab + reopening procedure (AB5).
- ARCH-007 pattern: SPLIT + DEFER + RETIRE con RESOLVED_BY.

Los tres son **precedentes procedimentales, no estructurales**. Cada decisión futura los invoca por analogía; no los hereda por obligación.

### 8.4 Downstream propagation

- **DEC-02 (D-DELEG)**: pierde precondición HARD; ahora sólo tiene SOFT/ENABLER a ARCH-006 y ARCH-007.
- **DEC-12 (D-META-DOC)**: no afectada directamente por ARCH-007. Sigue ortogonal.
- **DEC-03/04/05/07/08/STREAM-CONSUMER/REVIEWER-VERDICT**: no afectadas directamente por ARCH-007.
- **MASTER_HANDOFF §7-13**: contiene framing histórico de DEC-01 A1/A2/A3. **NO se corrige** — MASTER_HANDOFF es snapshot por ARCH-006 §7 (no living document). El lector futuro debe reconciliar contra DECISION_REGISTRY.
- **DECISION_SPACE_PREPARED**: contiene framing de DEC-01 pre-ARCH-006 (§4.1) y sequencing con DEC-01 como precondición HARD (§6.1). **NO se corrige** — Stratum-C untracked snapshot analítico. Los readers deben leer con conciencia de fecha (2026-09-25).

### 8.5 Verdict del propagation audit

- **1 GAP-piece retirada** (CATALOG).
- **1 arista HARD reclasificada a SOFT/ENABLER** (DEC-01→DEC-02).
- **1 nuevo patrón procedural** (SPLIT+DEFER+RESOLVED_BY).
- **Ningún runtime, hook, rule, skill o registry modificado** — coherente con ALCANCE docs-only de ARCH-007.
- **Ningún ghost detectado** en fuentes canónicas.

---

## §9. VOCABULARY DISAMBIGUATION — DEC-02 REQUIREMENTS

Regla del Master Prompt §9: **no asumir** `authority-kind = action-type = change-type`.

### 9.1 Cinco dimensiones distintas identificables en el CCP

| Dimensión | Definición operativa | Fuente-de-verdad canónica actual | Materializada como |
|---|---|---|---|
| **AUTHORITY_KIND** | Clase de autoridad que decide (`{mecánica, convención, humana, agente}`) | `docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006, CLOSED VOCAB-A) | Taxonomía canónica de primer orden |
| **ACTION_TYPE** | Qué acción es delegable (code-review, verification, authorization, artifact-production, decision, deferral, ...) | **NO existe fuente canónica**. Aparece implícitamente en `.claude/agents/*.md` (5 archivos + 6 runtime) | UNKNOWN — cada agent lista sus tools, no sus actions |
| **CHANGE_TYPE** | Prefijo del commit (`feat, fix, docs, arch, decision, security, infra, config`) | `.claude/rules/git-policy.md` (línea 3) | Rule text en `.claude/rules/` |
| **TASK_TYPE** | Clasificación del trabajo (`CONTRACTUAL TASK, INTERNAL TODO, SUBTASK, RESEARCH NOTE`) | ARCH-004 (DECISION_REGISTRY.md) + F8-A addendum | Decisión ARCH-004 |
| **VERIFICATION_TYPE** | Qué se verifica y contra qué (schema, hash, evidence, semantic, invariant, drift) | Distribuida entre `.claude/hooks/lib/`, EV entries, DEC-07 formulación futura | Distributed, no canonical |

**Corolario clave**: son cinco dimensiones semánticamente distintas. Ninguna se subsume en otra. Confundirlas es el error histórico del framing D-CATALOG A2 (mezclaba `change_type × gate × auth_holder × precedent` = cuatro dimensiones distintas colapsadas en una tabla).

### 9.2 Qué necesita DEC-02 (D-DELEG) para formularse

Reconstrucción desde el problema:

- **Problema**: `K3-D-OWNER-DEFAULT` — toda autoridad no delegada defaultea al Owner humano, creando bottleneck.
- **Objeto de la decisión**: registrar delegaciones explícitas con contrato revocable.
- **Key primaria del registry**: debe ser `action_type` (qué se delega), no `change_type` (qué commit produce).

**Necesita**:

1. **Vocabulario de acciones delegables**. NO existe canonical. **Info-gap-1**: enumerar acciones actualmente ejecutadas por agentes/humanos + candidatas a delegación. Este es un **experimento previo** (correlaciona con EXP-D01-04 del gate).
2. **Referencia a AUTHORITY_KIND** para el campo `delegated_to` — SÍ existe (`ARCH-006 AUTHORITY_KIND.md`).
3. **Reglas de fallback** — `humana` como default per K3-D-OWNER-DEFAULT.
4. **Reglas de revocación** — SÍ derivable (patrón ARCH-005: reopening procedure).
5. **Formulación de `activated_by`** — enlaza con DEFERRAL_POLICY.md (ARCH-005) como precedente procedural.

**NO necesita**:

- D-CATALOG (revalidado gate §14).
- CHANGE_TYPE (dimensión ortogonal a `action_type`).
- TASK_TYPE (ARCH-004 ya vigente; no requiere cambio para DEC-02).
- VERIFICATION_TYPE (competencia de DEC-07, no DEC-02).

### 9.3 Estado de precondiciones para DEC-02

| Precondición | Estado |
|---|---|
| Vocabulario de authority-kind | ✓ existente (ARCH-006) |
| Vocabulario de action-type | ✗ **UNKNOWN — no enumerado canónicamente** |
| Procedural pattern (deferral / revocación) | ✓ existente (ARCH-005) |
| Piezas actor identificadas | ✓ existente (`.claude/agents/*.md` + runtime; P-A, P-H, P-O, P-SA en piece catalog) |
| K3-D-OWNER-DEFAULT contextualizado | ✓ existente (F9 decisions + PROJECT_STATE) |

**Verdict**: DEC-02 tiene **una precondición no cubierta** (`action-type` vocabulary), pero esa precondición **puede resolverse en el mismo gate de DEC-02** (enumeración ATTESTED de acciones observadas + declaración de vocab abierto vs cerrado). No requiere una decisión previa independiente.

### 9.4 Consecuencia para el decision space

- DEC-02 es formulable hoy. Su gate deberá incluir un análisis de vocabulario `action-type` (con precedente ARCH-006 VOCAB-A para elegir CLOSED vs OPEN).
- **Ninguna nueva decisión** llamada "DEC-ACTION-TAXONOMY" debe crearse ex-ante. Sería el mismo anti-patrón que llevó a DEC-01 monolítico (crear una pieza antes de decidir el problema).

---

## §10. DAG REVALIDATION — HISTORICAL EDGES

Método: cada arista del DAG histórico se re-evalúa con criterio semántico HARD / SOFT / CONDITIONAL / COUPLED / INFORMATIONAL / ABSORBED / INVALIDATED.

| Arista histórica (DECISION_SPACE_PREPARED §3.1) | Clasificación histórica | Clasificación post-ARCH-007 | Justificación |
|---|---|---|---|
| DEC-01 → DEC-02 | HARD | **INVALIDATED / SOFT-ENABLER** | Gate §14. Absorbida por SPLIT+DEFER. |
| DEC-01 → DEC-11 | SOFT | **ABSORBED** | ARCH-005 ya cerrada; DEC-01 ya cerrada; arista sin trabajo pendiente. |
| DEC-02 → DEC-07 | HARD | **HARD (verificable)** | DEC-07 F2 (LLM adversarial) presupone delegación explícita registrada. Sin DEC-02, F2 es delegación implícita → riesgo governance documentado. |
| DEC-02 ↔ DEC-AUTH-BOUNDARY | MUTUAL | **ABSORBED** | DEC-AUTH-BOUNDARY = ARCH-006 (cerrada). AUTHORITY_KIND.md §7 declara SOFT/ENABLER hacia DEC-02, no HARD. |
| DEC-04 → DEC-05 | HARD | **HARD** | Motor sin canónica declarada es incoherente. Preservada. |
| DEC-04 → DEC-06 | HARD | **RETIRED** | DEC-06 retirada como decisión (DECISION_SPACE_PREPARED §2.1). |
| DEC-05 → DEC-06 | HARD | **RETIRED** | Idem. |
| DEC-08 → DEC-09 | HARD | **RETIRED** | DEC-09 retirada como decisión. |
| DEC-08 ↔ DEC-STREAM-CONSUMER | MUTUAL | **SOFT / MUTUAL-ILLUMINATION** | Schema estable ilumina consumer; consumer ilumina schema. Ninguna es precondición HARD de la otra. |
| DEC-11 → DEC-08 | HARD | **ABSORBED** | ARCH-005 cerrada. DEC-08, si se abriera, invocaría ARCH-005 como precedente procedural — no HARD. |
| DEC-11 → DEC-13 | ABSORB | **CONSUMED** | DEC-13 absorbida como campo `trigger:` de ARCH-005. Retirada. |
| DEC-03 → DEC-12 | SOFT | **SOFT (preservada)** | Front-matter (DEC-03) facilita política supersedes (DEC-12), pero no la habilita. |
| DEC-04 + DEC-05 + DEC-02 | COUPLED (irreducible triple) | **REQUIRES ATTACK** (§12 abajo) | Hipótesis heredada; reexaminada. |
| DEC-07 → DEC-REVIEWER-VERDICT | SOFT | **SOFT-INFORMATIONAL** | Reformulable como sub-decisión de DEC-07 (§20 abajo). |
| DEC-AUTH-BOUNDARY → DEC-02 | HARD | **ABSORBED / SOFT** | Ya cerrada ARCH-006; relación declarada SOFT/ENABLER en AUTHORITY_KIND.md §7. |
| DEC-AUTH-BOUNDARY → DEC-04 | SOFT | **ABSORBED** | ARCH-006 cerrada; sin trabajo pendiente. |
| DEC-STREAM-CONSUMER → DEC-11 | SOFT | **ABSORBED** | ARCH-005 cerrada; consumer, si se decidiera, no requiere ARCH-005 como HARD. |

**Aristas post-ARCH-007 que sobreviven como HARD ATTIVA**:

```
DEC-02 → DEC-07              (HARD: delegación explícita para verificación LLM)
DEC-04 → DEC-05              (HARD: motor requires canónica declarada)
```

**Aristas SOFT/INFORMATIONAL activas**:

```
DEC-03 → DEC-12              SOFT
DEC-08 ↔ DEC-STREAM-CONSUMER MUTUAL-ILLUMINATION
DEC-07 → DEC-REVIEWER-VERDICT SOFT-INFORMATIONAL (o reformulable como sub-decisión)
```

---

## §11. DAG REBUILT FROM ZERO

Reconstrucción independiente, sin heredar del DAG histórico.

### 11.1 Nodes (decisiones potencialmente open)

Excluyendo cerradas (ARCH-*) y retiradas (DEC-06/09/10/13/E2/E3/E4):

```
DEC-02  D-DELEG
DEC-03  D-LIFECYCLE
DEC-04  D-CANONICAL
DEC-05  D-MOTOR
DEC-07  D-VERIFICADOR
DEC-08  D-INSTR
DEC-12  D-META-DOC
DEC-STREAM-CONSUMER
DEC-REVIEWER-VERDICT
DEC-01-E1  type-taxonomy  (DEFERRED, no open)
```

### 11.2 Edges (post-ARCH-007, verificadas §10)

```
DEC-02  → DEC-07                HARD
DEC-04  → DEC-05                HARD
DEC-03  → DEC-12                SOFT
DEC-08  ↔ DEC-STREAM-CONSUMER   MUTUAL-ILLUMINATION
DEC-07  → DEC-REVIEWER-VERDICT  SOFT-INFORMATIONAL  (o subsumible)
```

### 11.3 Roots (sin edges entrantes activos)

```
DEC-02       (sin HARD upstream conocido)
DEC-03       (sin upstream)
DEC-04       (sin upstream; su premisa DERIVATION es primitiva latente, no decisión previa)
DEC-08       (sin HARD upstream; ARCH-005 disponible como precedente procedural)
DEC-12       (sin upstream)
DEC-01-E1    (DEFERRED — no root activo)
```

### 11.4 Sinks (sin edges salientes)

```
DEC-07                          (con SOFT-INFORMATIONAL a DEC-REVIEWER-VERDICT)
DEC-STREAM-CONSUMER
DEC-REVIEWER-VERDICT
DEC-12
DEC-05                          (sink en su rama; sólo depende de DEC-04)
```

### 11.5 Dominators

Ninguna decisión pending domina el conjunto downstream de otras dos o más. **Sin dominators claros post-ARCH-007**. Este es un cambio material: pre-ARCH-007 DEC-01 se presentaba como dominator del Bloque A; ahora ninguna es load-bearing sobre múltiples otras.

### 11.6 Cut sets

Conjunto mínimo cuya resolución divide el espacio:

- `{DEC-04}` corta: si DEC-04=D5 (statu quo), DEC-05 se disuelve; si DEC-04≠D5, DEC-05 se activa.
- `{DEC-02}` corta: si DEC-02=B1 (statu quo), DEC-07 F2 se vuelve riesgo governance; si DEC-02=B2, DEC-07 F2 es viable.

### 11.7 Coupled clusters

Único cluster estructural sobreviviente:

- **`{DEC-04, DEC-05}`** — canonical + motor. Coupled porque decidir uno sin el otro es incoherente (D5+E2 sin canónica ¿compila qué?; D4+E1 canónica sin motor ⇒ drift asegurado).
- **La triple `{DEC-04, DEC-05, DEC-02}` requiere ataque (§12 abajo)** — no se acepta como coupled sin re-verificación.

### 11.8 Orphans (sin consumer downstream claro)

```
DEC-12                          (ortogonal a todo)
DEC-STREAM-CONSUMER             (con DEC-08 mutual-illumination pero nada downstream)
DEC-REVIEWER-VERDICT            (potencial subsumible en DEC-07)
```

### 11.9 Visual DAG (compact)

```text
              (roots)
DEC-02 ──HARD──▶ DEC-07 ──SOFT-INF──▶ DEC-REVIEWER-VERDICT
                                         (candidate absorb into DEC-07)

DEC-04 ──HARD──▶ DEC-05                 (coupled cluster)

DEC-03 ──SOFT──▶ DEC-12                 (independent branch)

DEC-08 ◀─MUT-ILL─▶ DEC-STREAM-CONSUMER  (mutually informative)

(all roots have no HARD upstream. ARCH-005/006/007 available as procedural precedents.)
```

---

## §12. IRREDUCIBLE TRIPLE — REVALIDATED AS HYPOTHESIS

Hipótesis histórica (DECISION_SPACE_PREPARED §1, §3.4): **`DEC-04 + DEC-05 + DEC-02 = GOVERNED DERIVATION`** (irreducible triple).

### 12.1 Ataques al axioma

**Ataque 1**: ¿DEC-02 realmente pertenece al mismo núcleo que DEC-04+DEC-05?

- DEC-04 y DEC-05 tratan **DERIVATION** (canónica → derivado, con motor).
- DEC-02 trata **DELEGATION** (registro de qué acción delegada a quién).
- Son primitivas distintas (PRIM-3 DERIVATION vs PRIM-1 AUTHORITY-KIND ya materializada en ARCH-006).
- La "unión" DEC-04+DEC-05+DEC-02 se apoyaba en el argumento: "si D4 canonical YAML, ¿bajo qué autoridad se edita?" — pero **AUTHORITY_KIND ya provee la clase de autoridad; DELEGATION_REGISTRY (DEC-02) es un objeto separado de DERIVATION_MOTOR**.

**Ataque 2**: ¿DEC-04 depende de DEC-02?

- DEC-04 pregunta: "¿cerramos GAP-1 con canónica declarada?" — respuesta técnica sobre formato y motor.
- DEC-02 pregunta: "¿registramos delegaciones explícitas?" — respuesta procedural sobre gobernanza.
- **No hay dependencia técnica bidireccional**. DEC-04 puede formularse sin DEC-02 (D4 canonical YAML editable por humano; delegación es materia separada).

**Ataque 3**: ¿DEC-05 depende de DEC-04?

- **SÍ, HARD**. Motor sin canónica declarada es incoherente. Esta es la única arista del "triple" que sobrevive como HARD.

**Ataque 4**: ¿la triple es realmente irreducible?

- Descomponible en **par acoplado `{DEC-04, DEC-05}`** + **decisión ortogonal DEC-02**.
- El framing histórico ("irreducible triple") es **residual del pre-ARCH-006**: cuando AUTHORITY-KIND vivía sólo como columna, sí había sensación de que "autoridad sobre canónica" requería DEC-02. Post-ARCH-006, esa autoridad es taxonomía ya provista.

### 12.2 Verdict

- La **"irreducible triple"** es una **hipótesis heredada refutada** por el ataque.
- El coupled cluster real es **`{DEC-04, DEC-05}`** (par).
- **DEC-02 es ortogonal** al par canonical/motor.

**Confidence del ataque**: MED-HIGH (75%). Refutable si aparece un requerimiento concreto donde el motor de DERIVATION requiera un registro DELEGATION-KEY como input (no hipotético actualmente).

### 12.3 Consecuencia estructural

- No existe una decisión "raíz irreducible" que domine el resto del decision space post-ARCH-007.
- El decision space es **más disperso y menos jerárquico** de lo que sugería el framing pre-ARCH-006/007.
- **In-flight lesson** (segunda vez que se aplica el patrón de ARCH-007): una hipótesis heredada de niveles anteriores requiere ataque de coupling + consumer analysis antes de asumir su formulación.

---

## §13. DEC-12 REANALYSIS (D-META-DOC)

### 13.1 Formulación histórica

DECISION_SPACE_PREPARED §4.9: política de cap sobre `docs/00_SYSTEM/` (44 archivos hoy; propuesta cap 30). Opciones I1/I2/I3/I4.

### 13.2 Análisis multi-dimensional del problema

| Sub-problema | Existencia empírica | Fuente-de-verdad canónica actual |
|---|---|---|
| CARDINALITY | ~44 archivos en `docs/00_SYSTEM/`; ninguna política de cap | Sin fuente canónica |
| DISCOVERABILITY | Reviewers y agentes navegan por `ls` + `grep`; no hay índice canónico | Sin fuente canónica; MASTER_HANDOFF es snapshot no vivo |
| ROLE-GOVERNANCE | Cada archivo tiene rol implícito (registry, snapshot, handoff, policy, evidence) sin declaración explícita | Sin fuente canónica |
| DUPLICATION | Detectada: MASTER_HANDOFF §7-§13 duplica formulación de decisiones que también están en DECISION_REGISTRY; snapshots analíticos Stratum-C solapan a veces | Sin fuente canónica |
| MAINTENANCE | Sin política; stale risk documentado en PT-3 | Sin fuente canónica |

**Descomposición**: DEC-12 mezcla 5 sub-problemas. Aplica el mismo patrón que DEC-01: ataque de homogeneidad.

### 13.3 Homogeneity test

- **CARDINALITY** → resoluble por convención simple (cap = N).
- **DISCOVERABILITY** → resoluble por índice + convención de naming.
- **ROLE-GOVERNANCE** → resoluble por front-matter (DEC-03 sub-set).
- **DUPLICATION** → resoluble por retire con RESOLVED_BY (patrón ARCH-007 SPLIT+DEFER).
- **MAINTENANCE** → resoluble por lifecycle registry o front-matter periódico.

Los 5 son heterogéneos. Materializar DEC-12 como decisión monolítica **repetiría el error de DEC-01**.

### 13.4 Estado post-ARCH-007

**Candidato**: DEC-12 admite un **SPLIT análogo a ARCH-007**:

- **12.a CARDINALITY POLICY** — trivial (elegir cap explícito o "no cap"). Reversibilidad total. Coste 30 min. **Candidato quick-win**.
- **12.b DISCOVERABILITY INDEX** — resoluble con archivo índice (`docs/00_SYSTEM/INDEX.md`) enumerando artefactos por rol. Docs-only. Bajo lock-in.
- **12.c ROLE-GOVERNANCE** → subsumible en DEC-03 (front-matter con `role:` field).
- **12.d DUPLICATION AUDIT** — actividad de mantenimiento, no decisión. RETIRE.
- **12.e MAINTENANCE POLICY** → subsumible en DEC-03 (lifecycle field).

**Verdict**: DEC-12 puede **RETIRE** (12.d) + **ABSORB** (12.c, 12.e → DEC-03) + **SPLIT** (12.a, 12.b como sub-decisiones micro).

**Confidence**: MED (65%). Requiere Owner criterion sobre cap.

### 13.5 ¿Es DEC-12 una decisión estructural?

**NO** en sentido estricto: es una preocupación documental sin implicación arquitectural. La decisión estructural real (LIFECYCLE) está en DEC-03. **DEC-12 puede tratarse como derived de DEC-03**.

---

## §14. DEC-03 REANALYSIS (D-LIFECYCLE)

### 14.1 Formulación histórica

DECISION_SPACE_PREPARED §4.3: front-matter en research artifacts (C1..C4).

### 14.2 Ataque LIFECYCLE

Pregunta central: **¿LIFECYCLE es una primitiva general del CCP o una familia de lifecycles específicos?**

Instancias empíricas de "lifecycle" en el CCP:

| Entidad | Lifecycle observado | Fuente-de-verdad canónica |
|---|---|---|
| Fases F1-F12 | `RESEARCH → COMPLETE → CHECKPOINT → SUPERSEDED` | PROJECT_STATE.md + ARTIFACT_MANIFEST |
| Decisiones ARCH-* | `PENDING → OWNER_CHOSEN → IMPL_AUTHORIZED → EXECUTED → CONFORMANCE_PASS → CHECKPOINTED` | DECISION_REGISTRY.md |
| Deferrals | `DEFERRED (con trigger) → REACTIVATABLE / RESOLVED` | ARCH-005 DEFERRAL_POLICY |
| Evidence entries | `FRESH → STALE → OBSOLETE` | EVIDENCE_REGISTRY.md (parcial) |
| Meta-docs | `ACTIVE → ARCHIVED → OBSOLETE` | Sin fuente canónica |
| Research artifacts | `DRAFT → COMPLETE → SUPERSEDED` | Sin fuente canónica |
| STALL rows | `EMIT → CONSUMED / IGNORED` | Sin consumer canónico |

**Los 7 lifecycles son estructuralmente distintos** (transitions, actors, evidence semantics distintos). No hay una máquina de estados unificada.

### 14.3 Verdict

- **DEC-03 no debería formularse como "lifecycle universal"** — sería el mismo anti-patrón que DEC-01.
- **DEC-03 correctamente formulada** = "front-matter convention para research artifacts + meta-docs" (subset C4 del histórico).
- Las otras lifecycles ya tienen fuente-de-verdad canónica (ARCH-* para decisiones, ARCH-005 para deferrals, ARTIFACT_MANIFEST + PROJECT_STATE para fases).
- **Anti-pattern check**: NO crear `LIFECYCLE_REGISTRY.md` unificado. Sería un derived view sin motor — mismo error que hubiera sido D-CATALOG A2.

### 14.4 Formulación post-ARCH-007

DEC-03 = "adoptar convención `status:`/`role:`/`supersedes:` en front-matter de `docs/research/*.md` y `docs/00_SYSTEM/*.md` (o subset)". Alcance limitado. Bajo lock-in. **Candidato quick-win** con precedente ARCH-005 (docs-only, sin runtime, sin enforcement mecánico).

---

## §15. DEC-04 REANALYSIS (D-CANONICAL)

### 15.1 Pregunta central re-formulada

Pregunta histórica (DECISION_SPACE_PREPARED §5.1.a): "¿cerrar GAP-1?"

**Ataque**: la formulación mezcla dos preguntas:

- **15.a Semantic**: ¿existe un problema empírico de sync manual entre `.claude/rules/*.md` y `.claude/hooks/*.sh` que justifique DERIVATION?
- **15.b Architectural**: ¿qué formato canónico + qué motor?

Análoga estructura a DEC-01 (que también mezclaba dimensiones distintas).

### 15.2 Estado empírico

- **PIECE_AND_IDEA_PUZZLE_AUDIT §11 PRIM-3**: DERIVATION identificada como primitiva central ausente (confidence ALTA).
- **PIECE_AND_IDEA_PUZZLE_AUDIT §12**: contract AUSENTE `CANONICAL-SOURCE` en P-BB (GAP-1).
- **Empirical**: 4 rules `.md` (1 con placeholders); 24 IDs en PAC prototype; 82% harness noise en STALL log — sin patrón de drift documentado.

**Info-gap**: la existencia empírica del problema (drift entre `.md` y regex) está **DOCUMENTED** en MASTER pero **NO VERIFIED** empíricamente en un incidente concreto. Análogo al gap que reveló DEC-01: hipótesis heredada sin evidencia material.

### 15.3 Split candidato para DEC-04

- **15.a SEMANTIC-QUESTION (¿existe DRIFT verificable?)** — resoluble con experimento shadow (EXP-D01-01-analog: instrumentar detección de divergencia `.md` vs regex durante 60 días).
- **15.b FORMAT-DECISION (D1/D2/D3/D4)** — sólo relevante si 15.a = SÍ.

**Verdict**: DEC-04 en su formulación histórica sufre el mismo anti-patrón que DEC-01. Debería atacarse antes de abrir el gate: **experimento shadow primero, formulación después**.

**In-flight lesson (tercer ejemplo)**: PRIM-3 DERIVATION es primitiva latente sólo con confidence ALTA de existencia, no de necesidad de materialización. La lección de ARCH-007 aplica: distinguir primitiva-latente-existe vs primitiva-latente-load-bearing.

### 15.4 Lock-in de DEC-04

**ALTO en todas las opciones no-triviales** (documentado en DECISION_SPACE_PREPARED §5.4). Sigue siendo el caso post-ARCH-007. Esto refuerza la conclusión: **DEC-04 no debe abrirse sin experimento previo**.

---

## §16. DEC-05 REANALYSIS (D-MOTOR)

### 16.1 Formulación

Motor unidireccional (E2), bidireccional (E3), o manual (E1).

### 16.2 Ataque semántico

**"Motor"** puede significar distintas cosas:

- DERIVATION (canónica → derivado, e.g., YAML → regex).
- EXECUTION (interpretar y ejecutar policy).
- VALIDATION (verificar propiedades).
- RECONCILIATION (detectar drift).
- PROJECTION (generar vista).
- ORCHESTRATION (coordinar flujos).

**PIECE_AND_IDEA_PUZZLE_AUDIT §11 PRIM-3** trata DERIVATION específicamente. Las otras 5 son primitivas separadas.

### 16.3 Verdict

- **DEC-05 correctamente formulada** = "motor de DERIVATION" (subset del término genérico "motor").
- Es **sub-decisión estructural de DEC-04**. Coupled cluster confirmed en §11.7.
- No merece formulación independiente pre-DEC-04.

**Confidence**: HIGH (85%). El coupling {DEC-04, DEC-05} es semánticamente inevitable.

---

## §17. DEC-07 REANALYSIS (D-VERIFICADOR)

### 17.1 Ataque de vocabulario

**Distinguir**:

- REVIEWER (P-H): actor humano que ejerce autoridad `humana` (ARCH-006) sobre un commit.
- VERIFIER: actor/mecanismo que valida propiedades (`mecánica` en hooks; `agente` si LLM adversarial).
- VERDICT: output semántico de una revisión (aprobado / rechazado / con-notas).
- EVIDENCE: registro material de un cambio (P-EM entries).
- AUTHORITY: quién puede vinculantemente decidir (AUTHORITY_KIND).

**Pregunta central de DEC-07**: ¿se materializa un **VERIFIER** de clase `agente` (LLM adversarial) como capa adicional al REVIEWER humano?

### 17.2 Estado post-ARCH-007

- **ARCH-006 §6 prohibiciones** impactan: si un LLM verifier "decide", debe ser clase `agente` autorizado por acto previo `humana` o `convención` (per §3 boundary). No puede introducir "meta-authority" implícita.
- **P-GT semantic-verdict contract ausente** (PIECE_AND_IDEA_PUZZLE_AUDIT §12): P-GT valida sintaxis pero no significado. DEC-07 F2 llenaría este contract.
- **DEC-02 HARD upstream**: sin registro explícito de delegación, F2 sería delegación implícita → violación gobernanza.

### 17.3 Vocabulary decision (sub-analógica ARCH-006)

Si DEC-07 se abriera post-DEC-02, requeriría un **VOCAB decision** análogo a ARCH-006:

- VOCAB-A CLOSED: sólo `{humano, LLM-adversarial}` como verificadores.
- VOCAB-OPEN: futuros verificadores incrementalmente.

**In-flight lesson (patrón ARCH-006 aplicado)**: cualquier VERIFIER taxonomy debe respetar VOCAB-A cerrado por default.

### 17.4 Verdict

- DEC-07 está **HARD-bloqueada** por DEC-02.
- Su formulación post-DEC-02 debe distinguir REVIEWER / VERIFIER / VERDICT explícitamente.
- **DEC-REVIEWER-VERDICT** (nueva del AUDIT §5B) es subsumible aquí como sub-decisión (§20 abajo).

---

## §18. DEC-08 REANALYSIS (D-INSTR)

### 18.1 Formulación

Schema extendido STALL con `verdict:`, `had_alternative`, `session_id` reales (G1/G2/G3).

### 18.2 Estado post-ARCH-005

- ARCH-005 ya cerrada → precedente procedural para "revisit F9-D01 con formal deferral policy" limpio.
- G2 (schema completo runtime) **sigue cruzando F9-D01** — ARCH-005 no elimina el gate, sólo provee precedente.
- G3 (shadow) sigue viable.

### 18.3 Ataque coupling con DEC-STREAM-CONSUMER

- Sin consumer, schema extendido produce datos sin lector → **no compra información**.
- Sin schema, consumer trabaja sobre datos parciales → **utilidad limitada**.
- Es **mutual-illumination** (§10, §11), no HARD.

### 18.4 Verdict

- DEC-08 puede formularse hoy sin HARD upstream.
- **Priorización de opción**: G3 (shadow) es dominante por no cruzar F9-D01 (info sin cutover).
- **Coupling con DEC-STREAM-CONSUMER**: decidir en paquete es prudente pero no obligatorio.

**Confidence**: MED-HIGH (70%). G3 shadow es un candidato de experimento reversible con alto info-value.

---

## §19. DEC-STREAM-CONSUMER REANALYSIS

### 19.1 Estado empírico

- 19 filas hoy; 82% harness noise (§8.4 de PIECE_AND_IDEA_PUZZLE_AUDIT).
- P-STREAM-CONSUMER identificada como GAP-NEW-1 con confidence ALTA (piece missing).
- HRQS §12 documenta consumer humano manual.

### 19.2 ¿Es realmente una decisión?

Test del Master Prompt §43:

- PROBLEM: log write-only sin lector operativo. ✓
- EVIDENCE: 19 filas, 82% noise, ningún consumer canónico. ✓
- MULTIPLE PLAUSIBLE OPTIONS: CO1-CO4 (do-nothing, manual, automatic-rules, LLM-triage). ✓
- DOWNSTREAM IMPACT: DEC-08 utility, K3-D-CAP3 provenance. ✓ (MEDIO)
- LOCK-IN OR GOVERNANCE CONSEQUENCE: CO3/CO4 crean nueva pieza runtime. ✓ (MEDIO-BAJO)

**Sí, es decisión válida**. Pero **no es urgente** (volumen actual bajo). Candidato natural: DEFER con trigger de volumen.

### 19.3 Verdict

- DEC-STREAM-CONSUMER **válida como decisión** pero **candidata a DEFER** con trigger observable.
- Trigger propuesto (a formalizar sólo por Owner en gate futuro): `volumen STALL ≥50/mes` o `DEC-08 G2 activado`.

---

## §20. DEC-REVIEWER-VERDICT REANALYSIS

### 20.1 Estado

- Confidence MEDIA-ALTA (audit §32 GAP-META-1).
- Asimetría P-H vs P-O: reviewer ACK implícito en git commit; Owner emite F9_OWNER_DECISIONS explícito.
- HRQS §12 puede cubrir parcialmente (info-gap-5 del gate document §21).

### 20.2 ¿Es decisión independiente o sub-decisión de DEC-07?

**Argumento a favor de sub-decisión**: si DEC-07 F2 introduce LLM adversarial verifier, éste **necesita comparar con verdict humano**. Sin verdict humano formalizado, DEC-07 F2 no tiene ground truth para calibrar.

**Argumento a favor de independiente**: DEC-REVIEWER-VERDICT tiene sentido incluso sin DEC-07 (mejora auditabilidad ex-post por git blame + trailer).

### 20.3 Verdict

- **Formulable como sub-decisión de DEC-07** cuando/si DEC-07 se abra.
- **Formulable ahora** como quick-win convencional (RV2 commit trailer) sin bloquear nada.
- **Candidato marginal**: bajo valor esperado; alto ratio de sensibilidad al criterio Owner.
- **Info-gap crítico**: verificar cobertura HRQS §12 antes de abrir (EXP: 30 min).

---

## §21. GHOST DECISION SCAN — FORMAL EXTENSION

Búsqueda extendida más allá de fuentes canónicas: incluye MASTER_HANDOFF y DECISION_SPACE_PREPARED con criterio "aparece como pending post-ARCH-007 sin justificación".

### 21.1 MASTER_HANDOFF ghost check

**Contexto**: MASTER_HANDOFF §7-§13 documenta las 13 decisiones históricas (incluidas DEC-06, DEC-09, DEC-10, DEC-13 RETIRED).

**Análisis**: MASTER_HANDOFF es **snapshot** por ARCH-006 §7. No es living. Su preservación del framing histórico **NO es un ghost** en sentido operativo: el lector futuro debe leer con DECISION_REGISTRY como fuente-de-verdad canónica.

**Verdict**: NO GHOST en MASTER_HANDOFF (por criterio "snapshot").

### 21.2 DECISION_SPACE_PREPARED ghost check

**Contexto**: DECISION_SPACE_PREPARED §2.3 lista 12 decisiones VALID; §3.1 mantiene DEC-01→DEC-02 HARD; §4.1 mantiene A2 con 85% confidence.

**Análisis**: es **Stratum-C untracked frozen snapshot** (2026-09-25). Sus afirmaciones sobre DEC-01 están invalidadas por ARCH-007, pero el documento **NO se corrige** porque no es fuente-de-verdad canónica. El lector debe leer con conciencia de fecha.

**Verdict**: NO GHOST en DECISION_SPACE_PREPARED (por criterio "Stratum-C snapshot"). Sin embargo, este artefacto lo **complementa** explícitamente para lectores futuros.

### 21.3 DEC-01_D-CATALOG_DECISION_GATE ghost check

**Contexto**: gate document (2075 líneas) preparó el Owner Choice de ARCH-007.

**Análisis**: análogo a DECISION_SPACE_PREPARED. Stratum-C frozen. Su §16.5 alternativa E se convirtió en ARCH-007 OWNER_CHOSEN.

**Verdict**: NO GHOST (por criterio "gate document ya utilizado").

### 21.4 Búsqueda residual

Grep sobre fuentes canónicas para `DEC-01|DEC-06|DEC-09|DEC-10|DEC-13|CATALOG|DELEG-REG|READY-03|READY-04|AUTHORITY-BOUNDARY`:

- ✓ Sin ocurrencias de estas como "pending / open" en PROJECT_STATE, DECISION_REGISTRY, DECISION_HISTORY.
- ✓ Referencias en MASTER_HANDOFF, DECISION_SPACE_PREPARED, PIECE_AND_IDEA_PUZZLE_AUDIT son históricas (fecha 2026-09-24/25).

**Resultado final**: `NO GHOSTS` en fuentes canónicas activas.

---

## §22. LATENT NEW DECISIONS HUNT

Búsqueda inversa: preguntas que emerjan tras ARCH-005/006/007 con:

```
PROBLEM + EVIDENCE + MULTIPLE OPTIONS + DOWNSTREAM IMPACT + NON-TRIVIAL TRADEOFF + LOCK-IN
```

### 22.1 Candidato NEW-C1: DEC-DERIVATION-EXISTENCE

- **PROBLEM**: PRIM-3 DERIVATION identificada como primitiva latente central. Su necesidad de materialización es hipótesis, no hecho verificado (§15.2).
- **EVIDENCE**: PIECE_AND_IDEA_PUZZLE_AUDIT §11 PRIM-3 confidence ALTA de existencia; **NO** evidencia de incidente material de drift.
- **OPTIONS**: (a) experimentar shadow-drift-detection 60 días; (b) asumir problema y abrir DEC-04 directamente; (c) diferir hasta trigger de incidente.
- **DOWNSTREAM**: si (a) muestra drift → DEC-04 opens; si (a) muestra estabilidad → DEC-04 permanece DEFER.
- **TRADEOFF**: (b) lock-in alto sin evidencia; (a) coste bajo con info alta; (c) governance decay potencial.
- **LOCK-IN**: (b) alto; (a) bajo; (c) bajo.

**Verdict**: **Candidata válida como pre-decisión / experimento** (no como decision monolítica). Puede ejecutarse como shadow test sin abrir DEC-04.

### 22.2 Candidato NEW-C2: DEC-RECOMPOSITION-PROTOCOL

- **PROBLEM**: los tres movimientos recientes (ARCH-005/006/007) requirieron recomposición explícita del decision space cada vez. ¿Debería el CCP tener un protocolo canónico de recomposición post-checkpoint?
- **EVIDENCE**: M009 (post-DEC-11), M013 (post-ARCH-006), esta sesión (post-ARCH-007) — tres iteraciones del mismo proceso.
- **OPTIONS**: (a) status quo (recomposición ad-hoc); (b) skill CCP para recomposición; (c) política documental.
- **DOWNSTREAM**: afecta velocity de próximas decisiones.
- **TRADEOFF**: (b) crea runtime tooling; (c) es meta-governance overhead; (a) inconsistencia entre recomposiciones.
- **LOCK-IN**: (b) MEDIO (skill runtime); (c) BAJO; (a) NULO.

**Verdict**: **Candidata débil**. La necesidad es real pero (a) funciona; (b) sería anti-patrón de piece-first (crear pieza antes de establecer patrón). **REGISTRAR como INFO GAP, no como decisión ahora**.

### 22.3 Candidato NEW-C3: DEC-SNAPSHOT-VS-LIVING

- **PROBLEM**: MASTER_HANDOFF, DECISION_SPACE_PREPARED, gate documents son "snapshots" implícitos. ¿Debería el CCP tener un contract explícito para artefactos snapshot vs living?
- **EVIDENCE**: ARCH-006 §7 declara MASTER_HANDOFF snapshot; DECISION_SPACE_PREPARED implícitamente snapshot; DEC-01_D-CATALOG_DECISION_GATE.md implícitamente snapshot. Sin política.
- **OPTIONS**: (a) status quo; (b) front-matter `role: snapshot|living` (subset DEC-03); (c) política formal.
- **DOWNSTREAM**: afecta cómo lectores futuros reconcilian fuentes.
- **TRADEOFF**: (b) subsumible en DEC-03; (c) meta-governance overhead.
- **LOCK-IN**: MUY BAJO.

**Verdict**: **Absorbible en DEC-03** (front-matter). No es decisión independiente. **NO NEW DECISION**.

### 22.4 Candidato NEW-C4: DEC-EXPERIMENT-CATALOG

- **PROBLEM**: los tres movimientos recientes generaron experimentos propuestos (EXP-D01-01..04, EXP-D04-shadow, etc.) que actualmente viven en documents distintos sin registry.
- **EVIDENCE**: DEC-01 gate §20 propone 4 experimentos; DECISION_SPACE_PREPARED §7 propone 6 INFO-GAPs.
- **OPTIONS**: (a) status quo; (b) `EXPERIMENT_REGISTRY.md`; (c) subsumir en DEC-11 DEFERRAL_POLICY.
- **DOWNSTREAM**: mejor visibilidad de qué información se está comprando.
- **TRADEOFF**: (b) nuevo registry ↔ mismo anti-patrón que DEC-01 A2 hubiera creado.
- **LOCK-IN**: MEDIO si (b).

**Verdict**: **NO NEW DECISION**. Mismo anti-patrón. Subsumible en (c) DEFERRAL_POLICY como campo `experiments:` o simplemente enumerar in-document en gate documents cuando aparezcan.

### 22.5 Resumen del hunt

| Candidato | Verdict | Razón |
|---|---|---|
| NEW-C1 DEC-DERIVATION-EXISTENCE | Válida como pre-decisión / experimento | Pero se ejecuta como shadow, no como decision gate |
| NEW-C2 DEC-RECOMPOSITION-PROTOCOL | Descartada | Ant-patrón piece-first |
| NEW-C3 DEC-SNAPSHOT-VS-LIVING | Absorbible en DEC-03 | Sub-decisión |
| NEW-C4 DEC-EXPERIMENT-CATALOG | Descartada | Anti-patrón nuevo registry |

**Neta latente decisions**: **0 verdaderamente nuevas**. La única "candidata" es un experimento pre-DEC-04, no una decisión.

---

## §23. SECOND-ORDER GAP HUNT

Estructura que faltaba para que ARCH-005/006/007 fueran fáciles de gobernar:

| Estructura | Estado | ¿Es decisión latente? |
|---|---|---|
| Propagation control (cómo se propaga una decisión al resto) | Ejecutado ad-hoc por movements (M009/M013/esta sesión) | NO — patrón procedural, no decisión |
| Decision genealogy | Preservada en git log + DECISION_HISTORY | NO — ya existe |
| Canonical decision space | PROJECT_STATE + DECISION_REGISTRY | ✓ existe |
| Dependency registry | Documentado en gate documents específicos | NO — subsumible en gate documents |
| Trigger ownership | ARCH-005 DEFERRAL_POLICY provee format | ✓ existe |
| Evidence-to-decision linkage | ARCH-003 EVIDENCE_REGISTRY + ARCH-004 EV binding | ✓ existe |
| Decision-state semantics | ACTIVE/RESOLVED/DEFERRED/RETIRED/ABSORBED — usado pero no formalizado | Marginal — sub-decisión de DEC-03 o quick-win convención |
| Retired/superseded semantics | ARCH-007 introduce `RESOLVED_BY:` pattern | ✓ patrón procedural nuevo (no requiere decisión formal) |
| Recomposition protocol | Ejecutado ad-hoc | NO — ver §22.2 |
| Authority vocabulary boundaries | ARCH-006 VOCAB-A CLOSED | ✓ existe |
| Subdecision lifecycle | ARCH-007 introduce E1..E4 partitioning + DEFER/RETIRE | ✓ patrón procedural nuevo |

**Neta**: **cero decisiones latentes nuevas** desde perspective second-order. Los patrones procedurales introducidos por ARCH-005/006/007 llenan la mayoría de gaps antes de que se materialicen.

---

## §24. DECISION SPACE MATURITY AUDIT

### 24.1 ¿El sistema distingue correctamente estados?

| Estado | Distinción operativa | Verificable | Verdict |
|---|---|---|---|
| ACTIVE (in-force) | ARCH-* aprobado | ✓ DECISION_REGISTRY | ✓ |
| OPEN (pending Owner Choice) | En decision space pero sin OWNER_CHOSEN | ✓ PROJECT_STATE | ✓ |
| DEFERRED | En DEFERRED con trigger YAML | ✓ ARCH-005 formato | ✓ |
| RETIRED | Marcada en DECISION_HISTORY con RESOLVED_BY | ✓ patrón ARCH-007 | ✓ |
| SUPERSEDED | Aún no observado empíricamente | UNKNOWN | UNKNOWN |
| ABSORBED | DEC-13 → ARCH-005 trigger field | ✓ patrón ARCH-005 | ✓ |
| CANDIDATE | Este artefacto lista candidatos; no forma canónica | ✗ sin forma canónica | GAP |

**Verdict**: 6/7 estados tienen forma canónica; SUPERSEDED sin observación empírica; CANDIDATE sin representación canónica (vive en analytical artifacts).

### 24.2 ¿Puede explicar por qué existe una decisión?

- ARCH-* tienen sección `DECISION:` + `EVIDENCIA:` + `RELACIÓN CON OTRAS DECISIONES:`. ✓
- DEC-* pending viven en analytical artifacts con framework rico. ✓

### 24.3 ¿Puede identificar dependencia histórica incorrecta?

- ✓ Precedente: gate §14 revalidó DEC-01→DEC-02 como INVALIDATED.
- ✓ Este artefacto §10 revalidó todas las aristas históricas.

### 24.4 ¿Puede detectar decisión retirada que reaparece?

- ✓ Ghost scan §6 + §21 no detectó ghosts.

### 24.5 ¿Puede identificar decisión nueva que emerge del cambio?

- ✓ Latent hunt §22 procesado; resultado: 0 verdaderamente nuevas.

### 24.6 Maturity verdict

- **Alta madurez** en distinciones de estado y trazabilidad.
- **Marginal**: SUPERSEDED sin observación empírica; CANDIDATE sin registro canónico.
- **NO ACTION**: los gaps son marginales y no bloquean gobernanza.

---

## §25. ROADMAP INERTIA TEST

Decisiones que sobreviven sólo por estar en plan histórico.

| Decisión | Justificación actual | Consumer actual | Verdict |
|---|---|---|---|
| DEC-02 D-DELEG | K3-D-OWNER-DEFAULT problema real; DEC-07 F2 dependiente HARD | Owner scaling planning; DEC-07 futuro | SUPPORTED |
| DEC-03 D-LIFECYCLE | K3-D-LIFECYCLE problema documentado; front-matter valor | research/ ~75 archivos; docs/00_SYSTEM ~44 archivos | SUPPORTED (aunque restringido a subset C4) |
| DEC-04 D-CANONICAL | PRIM-3 DERIVATION latente; GAP-1 documentado | Motor no existe; sync manual actual | **WEAKLY_SUPPORTED** — falta evidencia empírica de incidente material |
| DEC-05 D-MOTOR | Coupled con DEC-04 | Solo si DEC-04 ≠ D5 | **CONDITIONAL** |
| DEC-07 D-VERIFICADOR | HARD upstream DEC-02; volumen review humano hipótesis | Owner en S1 (1 humano); crece con S2/S3 | **WEAKLY_SUPPORTED** — dependiente de escalamiento hipotético |
| DEC-08 D-INSTR | 3 UNKNOWNs bloqueados; 82% harness noise en STALL | HRQS §12 humano; consumer inexistente | SUPPORTED |
| DEC-12 D-META-DOC | 44 archivos actuales; PT-3 fricción documentada | Reviewer / agentes navegación | **WEAKLY_SUPPORTED** — subsumible en DEC-03 |
| DEC-STREAM-CONSUMER | P-STREAM-CONSUMER GAP-NEW-1; 19 filas 82% noise | HRQS §12 manual | **WEAKLY_SUPPORTED** — volumen actual bajo |
| DEC-REVIEWER-VERDICT | GAP-META-1 audit; asimetría P-H vs P-O | Solo si DEC-07 F2 futuro | **WEAKLY_SUPPORTED** — subsumible en DEC-07 |

**Neta inertial**: 4/9 candidatos abiertos son WEAKLY_SUPPORTED. 3/9 subsumibles o condicionales. Sólo 2 (DEC-02, DEC-08) sobreviven con SUPPORTED completo.

**In-flight lesson**: el decision space post-ARCH-007 está más disperso de lo que MASTER_HANDOFF sugería. Buena parte del "roadmap" era inertia + framing prematuro.

---

## §26. PIECE-FIRST VS PROBLEM-FIRST TEST

Para cada candidato: ¿la decisión responde a `piece → justification` o a `problem → evidence → alternatives`?

| Decisión | Origen | Patrón |
|---|---|---|
| DEC-02 D-DELEG | K3-D-OWNER-DEFAULT (problema documentado) | **problem-first** ✓ |
| DEC-03 D-LIFECYCLE | K3-D-LIFECYCLE + volumen research | **problem-first** ✓ |
| DEC-04 D-CANONICAL | PRIM-3 DERIVATION latente + GAP-1 | **problem-first** con caveat (necesidad no verificada empíricamente) |
| DEC-05 D-MOTOR | Deriva de DEC-04 | **piece-first** ✗ (motor sin problema propio) |
| DEC-07 D-VERIFICADOR | K3-U-09 correlated failure + scaling S2/S3 hipotético | **problem-first** con caveat (evidencia parcial) |
| DEC-08 D-INSTR | 3 UNKNOWNs + STALL schema partial | **problem-first** ✓ |
| DEC-12 D-META-DOC | PT-3 + cardinalidad ~44 | **problem-first** ✓ (aunque múltiples sub-problemas) |
| DEC-STREAM-CONSUMER | P-STREAM-CONSUMER GAP-NEW-1 | **piece-first** ✗ (pieza identificada; problema empírico marginal) |
| DEC-REVIEWER-VERDICT | GAP-META-1 asimetría | **piece-first** parcial (asimetría es propiedad de piezas) |

**Anti-patterns detectados**:

- DEC-05 sólo tiene sentido si DEC-04 se abre → **NO abrir DEC-05 independiente**.
- DEC-STREAM-CONSUMER pieza-first → **preferir DEFER hasta trigger de volumen**.
- DEC-REVIEWER-VERDICT parcial → **preferir absorber en DEC-07** si DEC-07 se abre.

---

## §27. BENEFIT > COMPLEXITY

Regla ARCH-006 aplicada.

| Decisión | Valor (V) | Complejidad (C) | Lock-in (L) | Info-gain (I) | V > C + L?  |
|---|---|---|---|---|---|
| DEC-02 D-DELEG | ALTO (K3-D-OWNER-DEFAULT resuelto) | BAJO (~2h Markdown) | BAJO | MED | **SÍ** ✓ |
| DEC-03 D-LIFECYCLE | MED (usabilidad research/) | BAJO (~1h) | BAJO | BAJO | **SÍ** ✓ |
| DEC-04 D-CANONICAL | ALTO (LT) o BAJO (si drift no material) | ALTO (motor + FP framework) | ALTO | MED | **DEPENDS** (shadow first) |
| DEC-05 D-MOTOR | Dependent DEC-04 | Dependent | Dependent | Dependent | **N/A independiente** |
| DEC-07 D-VERIFICADOR | MED (dep. scaling) | MED-ALTO | ALTO (LLM provider) | ALTO (shadow) | **DEPENDS** (DEC-02 + escalamiento) |
| DEC-08 D-INSTR G3 shadow | ALTO (desbloquea 3 UNKNOWNs) | BAJO | BAJO | ALTO | **SÍ** ✓ |
| DEC-12 D-META-DOC (12.a) | BAJO (cap) | MUY BAJO | NULO | BAJO | **MARGINAL** |
| DEC-STREAM-CONSUMER CO2 | BAJO (volumen actual bajo) | MUY BAJO | BAJO | MED | **DEFER dominant** |
| DEC-REVIEWER-VERDICT RV2 | BAJO | MUY BAJO | NULO | BAJO | **MARGINAL** o absorb |

**Ganan V > C**:
- DEC-02 (claro)
- DEC-03 (subset C4)
- DEC-08 G3 shadow (claro; no cruza F9-D01)

**Requieren info primero** (shadow / experiment):
- DEC-04 (drift verification)
- DEC-07 (LLM calibration + escalamiento)

**Marginales / diferibles**:
- DEC-12, DEC-STREAM-CONSUMER, DEC-REVIEWER-VERDICT.

---

## §28. LOCK-IN MAP POST-ARCH-007

| Decisión | Semantic | Governance | Workflow | Runtime | Data | Tool | Migration cost |
|---|---|---|---|---|---|---|---|
| DEC-02 B2 | BAJO | BAJO | BAJO | NULO | BAJO | NULO | BAJO |
| DEC-03 C4 | BAJO | BAJO | BAJO | NULO | NULO | NULO | BAJO |
| DEC-04 D4 | ALTO | MED | ALTO | MED | ALTO | MED | ALTO |
| DEC-04 D5 (statu quo) | NULO | NULO | NULO | NULO | NULO | NULO | N/A |
| DEC-04 shadow experiment | NULO | NULO | NULO | NULO | NULO | NULO | N/A |
| DEC-05 (dep) | MED | BAJO | BAJO | MED | BAJO | MED | MED |
| DEC-07 F2 | MED | ALTO (delegation) | MED | ALTO (LLM provider) | BAJO | ALTO | ALTO |
| DEC-07 F1 (statu quo) | NULO | NULO | NULO | NULO | NULO | NULO | N/A |
| DEC-08 G3 shadow | BAJO | BAJO | NULO | BAJO | BAJO | BAJO | BAJO |
| DEC-08 G2 runtime | MED | MED (cruza F9-D01) | BAJO | MED | BAJO | BAJO | MED |
| DEC-12 (subset 12.a cap) | NULO | NULO | BAJO | NULO | NULO | NULO | NULO |
| DEC-STREAM-CONSUMER CO2 | BAJO | BAJO | BAJO | NULO | BAJO | NULO | BAJO |
| DEC-STREAM-CONSUMER CO3 | MED | BAJO | BAJO | MED | MED | BAJO | MED |
| DEC-REVIEWER-VERDICT RV2 | BAJO | BAJO | BAJO | NULO | BAJO | NULO | BAJO |

**Decisiones a NO tomar prematuramente** (lock-in ALTO):
- **DEC-04 D1/D3/D4** — lock-in ALTO en semantic + workflow + data. Requiere shadow first.
- **DEC-07 F2** — lock-in ALTO en governance + tool (LLM provider) + workflow. Requiere DEC-02 previa + calibración empírica.

---

## §29. INFORMATION VALUE MAP

| Decisión / Experimento | Decision Cost | Info Gain | Reversibility | Downstream Unlock |
|---|---|---|---|---|
| DEC-02 B2 | BAJO | MED | ALTA | DEC-07 |
| DEC-04 shadow drift detection (60 días) | BAJO | ALTO | N/A (experimento) | DEC-04 decision con evidencia |
| DEC-08 G3 shadow (30-60 días) | BAJO | ALTO | ALTA | 3 UNKNOWNs, DEC-STREAM-CONSUMER utility |
| DEC-03 C4 | BAJO | BAJO | ALTA | Usabilidad; base DEC-12 sub-decisiones |
| DEC-07 F2 shadow LLM (100 commits históricos) | BAJO | ALTO | N/A | DEC-07 decision con calibración |
| DEC-REVIEWER-VERDICT: verify HRQS §12 coverage | MUY BAJO | ALTO | ALTA | Determina si es decisión real o duplicate |
| EXP: draft DEC-02 usando AUTHORITY_KIND (Stratum-C) | BAJO | ALTO | ALTA | Confirma §7/§9 revalidación |
| DEC-12 (12.a) cap = N | MUY BAJO | BAJO | ALTA | Marginal |

### 29.1 Cuadrantes

**High info / low lock-in** (candidatos excelentes para ejecutar):
- DEC-04 shadow drift.
- DEC-08 G3 shadow.
- DEC-07 F2 shadow históricos.
- EXP HRQS §12 coverage verification.
- EXP DEC-02 draft con AUTHORITY_KIND (EXP-D01-04 gate §20.4).

**High lock-in / low info** (retrasar):
- DEC-04 D1/D3/D4 sin shadow.
- DEC-07 F2 sin DEC-02 y sin calibración.

**Low value / low complexity** (opcional):
- DEC-12 12.a.
- DEC-REVIEWER-VERDICT RV2.

**High downstream leverage**:
- DEC-02 (desbloquea DEC-07 y elimina K3-D-OWNER-DEFAULT).
- DEC-08 G3 shadow (desbloquea 3 UNKNOWNs).

---

## §30. EXPERIMENT CATALOG POST-ARCH-007

Sólo experimentos con **information gain determinante** y **lock-in bajo**.

### EXP-A: Draft DEC-02 con AUTHORITY_KIND como taxonomía única

- **Pregunta**: ¿DEC-02 realmente formulable sin D-CATALOG y sólo con AUTHORITY_KIND?
- **Método**: draft `docs/00_SYSTEM/DEC-02_DELEG_DRAFT.md` como Stratum-C.
- **Coste**: BAJO-MED (~2-4h).
- **Duración**: 1 semana.
- **Cruza F9-D01**: NO.
- **Info gain**: ALTO. Confirma §7/§9 revalidación empíricamente.
- **Falsifier**: si emerge necesidad no cubierta (por ejemplo, `change_type` como key requerido) → activar `dec01.T2` trigger.
- **Ownership**: Owner-authorized (research-tier).

### EXP-B: Shadow drift detection `.md ↔ regex`

- **Pregunta**: ¿existe drift verificable entre `.claude/rules/*.md` y `.claude/hooks/*.sh` regex?
- **Método**: script en `docs/research/` que compara reglas prosa vs regex enforced, corriendo periódicamente.
- **Coste**: BAJO (~1-2 días implementación + costo research recurrente muy bajo).
- **Duración**: 60 días.
- **Cruza F9-D01**: NO (research, no runtime).
- **Info gain**: ALTO. Desbloquea DEC-04 decision con evidencia empírica de necesidad (o de ausencia).
- **Falsifier**: si drift < 1 caso/mes → DEC-04 permanece DEFER con confidence baja; si drift ≥ 3/mes → DEC-04 opens con evidencia.

### EXP-C: STALL G3 shadow instrumentation

- **Pregunta**: ¿cuál es la distribución real de STALL con schema completo?
- **Método**: DEC-08 G3 (shadow schema) — instrumentación paralela sin cutover.
- **Coste**: BAJO-MED.
- **Duración**: 30-60 días.
- **Cruza F9-D01**: NO (G3 shadow explícitamente evita).
- **Info gain**: ALTO. Desbloquea 3 UNKNOWNs + DEC-STREAM-CONSUMER utility.
- **Owner authorization**: puede requerirla (dependencia F9-D01 boundary).

### EXP-D: HRQS §12 coverage of REVIEWER-VERDICT

- **Pregunta**: ¿HRQS §12 ya cubre GAP-META-1?
- **Método**: leer HRQS §12 actual + inspeccionar 20 commits reviewer recientes.
- **Coste**: MUY BAJO (~30 min).
- **Duración**: 1 día.
- **Cruza F9-D01**: NO.
- **Info gain**: ALTO. Determina si DEC-REVIEWER-VERDICT es decisión real o duplicate.

### EXP-E: LLM reviewer shadow (100 commits históricos)

- **Pregunta**: FP/FN rate del LLM reviewer sobre commits reales.
- **Método**: correr `code-reviewer` sobre 100 commits históricos offline, comparar con reviewer humano implícito.
- **Coste**: BAJO (script + LLM API).
- **Duración**: 1-2 días.
- **Cruza F9-D01**: NO (offline).
- **Info gain**: ALTO. Cambia recommendation confidence DEC-07 de 50% a ≥70%.
- **Pre-req**: EXP-D primero (para tener ground truth explícito).

### Prioridad de EXPs por ratio información/coste

1. **EXP-D** (HRQS §12 coverage) — 30 min → alto info sobre DEC-REVIEWER-VERDICT.
2. **EXP-A** (DEC-02 draft) — 2-4h → alto info sobre revalidación §14.
3. **EXP-B** (drift shadow) — 1-2 días implementación → info determinante DEC-04.
4. **EXP-C** (STALL G3 shadow) — Owner-authorization possible → info DEC-08.
5. **EXP-E** (LLM shadow) — 1-2 días → post EXP-D.

---

## §31. CURRENT DECISION OBJECTS

Lista consolidada post-ARCH-007, sin priorización.

```
ACTIVE (ARCH-*):
  ARCH-001, ARCH-002, ARCH-003, ARCH-004
  ARCH-005 (DEC-11 DEFERRAL_POLICY)
  ARCH-006 (DEC-AUTH-BOUNDARY / AUTHORITY_KIND)
  ARCH-007 (DEC-01 D-CATALOG SPLIT+DEFER)

DEFERRED (Owner-authorized, con trigger canónico):
  CDT-02, AC-03, NH-11, F10-F12, DEC-01-E1

OPEN (potencialmente Owner-decidibles, pending análisis individual):
  DEC-02  D-DELEG                    [problem-first, SUPPORTED, HARD → DEC-07]
  DEC-03  D-LIFECYCLE                [problem-first, SUPPORTED (subset C4)]
  DEC-04  D-CANONICAL                [problem-first weak, WEAKLY_SUPPORTED, lock-in ALTO]
  DEC-05  D-MOTOR                    [piece-first, dependent DEC-04]
  DEC-07  D-VERIFICADOR              [problem-first weak, HARD ← DEC-02]
  DEC-08  D-INSTR                    [problem-first, SUPPORTED, G3 shadow disponible]
  DEC-12  D-META-DOC                 [mixed; subsumible en DEC-03 + quick-win 12.a]
  DEC-STREAM-CONSUMER                [piece-first, WEAKLY_SUPPORTED, defer candidate]
  DEC-REVIEWER-VERDICT               [piece-first parcial, absorb into DEC-07 candidate]

CANDIDATE PRE-DECISIONS / EXPERIMENTS:
  EXP-A DEC-02 draft
  EXP-B drift shadow (pre-DEC-04)
  EXP-C STALL G3 shadow (pre-DEC-08 G2 or absorption)
  EXP-D HRQS §12 verify
  EXP-E LLM shadow (pre-DEC-07 F2)

RETIRED / ABSORBED:
  DEC-01 (monolítico) → ARCH-007 SPLIT+DEFER
  DEC-01-E2, E3, E4 (RETIRED con RESOLVED_BY)
  DEC-06, DEC-09, DEC-10, DEC-13
  DEC-AUTH-BOUNDARY → ARCH-006

NO NEW LATENT DECISIONS THIS RECOMPOSITION.
```

---

## §32. OWNER CANDIDATE SET

Filtro: decisiones **verdaderamente abiertas** que un Owner podría decidir hoy sin bloqueo estructural.

| ID | Sub-recomendación | Coste Owner | Impact | Blocker |
|---|---|---|---|---|
| DEC-02 B2 | Materializar DELEGATION_REGISTRY con `action_type` key + AUTHORITY_KIND | 2-3h análisis Owner + implementación docs-only | ALTO (resuelve K3-D-OWNER-DEFAULT) | ninguno |
| DEC-03 C4 | Front-matter en research + subset meta-docs | 1h Owner criterion + retrofit docs-only | MED | ninguno |
| DEC-08 G3 | Shadow instrumentation (no cruza F9-D01) | 1h Owner authorization + implementación | ALTO (desbloquea 3 UNKNOWNs) | ninguno |
| DEC-12 12.a cap | Cap explícito sobre `docs/00_SYSTEM/` | 30 min Owner decision | BAJO | ninguno |
| EXP-D HRQS §12 verify | Verificación de cobertura previa a DEC-REVIEWER-VERDICT | 30 min lectura | BAJO | ninguno |
| EXP-B drift shadow | Shadow drift detection | 1h Owner authorization + implementación research | ALTO (info pre-DEC-04) | ninguno |
| EXP-A DEC-02 draft | Draft de DEC-02 usando AUTHORITY_KIND | 2-4h investigación | ALTO (info pre-DEC-02 formal) | ninguno |

### 32.1 Exclusiones del candidate set

- **DEC-04**: excluida hasta EXP-B ejecutado (lock-in ALTO sin evidencia).
- **DEC-05**: excluida por dependencia DEC-04.
- **DEC-07 F2**: excluida hasta DEC-02 + EXP-E.
- **DEC-STREAM-CONSUMER**: candidato DEFER, no candidato open.
- **DEC-REVIEWER-VERDICT**: candidato absorb into DEC-07 o DEFER hasta EXP-D.

---

## §33. CANDIDATE PRIORITIZATION

Criterios (no matemáticos, ordenados por importancia):

1. **Reversibility + low lock-in** primero.
2. **Information gain** determinante para decisiones futuras.
3. **Downstream unlock** medible.
4. **Owner bottleneck** minimizado.
5. **Evidence sufficiency** actual.

| Prioridad | Candidato | Justificación primary |
|---|---|---|
| **P1** | EXP-D HRQS §12 verify | 30 min + info sobre DEC-REVIEWER-VERDICT (absorb vs open). Menor coste con determinación clara. |
| **P2** | EXP-A DEC-02 draft (Stratum-C) | Confirma §7/§9 revalidación empíricamente antes de abrir DEC-02 formal. Alto info / bajo lock-in. |
| **P3** | DEC-03 C4 | Quick-win convencional; base para DEC-12 sub-decisiones; bajo lock-in. |
| **P4** | DEC-12 12.a (cap) | Micro-decisión. Reduce fricción documental. |
| **P5** | EXP-B drift shadow | Compra información determinante para DEC-04. Prevention de opening prematuro con lock-in ALTO. |
| **P6** | DEC-02 gate opening (con EXP-A completo) | Root decision; desbloquea DEC-07. |
| **P7** | EXP-C STALL G3 shadow | Info pre-DEC-08 G2; desbloquea 3 UNKNOWNs. |
| **P8** | DEC-08 gate opening (post EXP-C) | Con evidencia de shadow. |

**No se recomienda** ejecutar todas en paralelo. Sequencing sugerido (no autorizado, Owner-driven):

```
Semana 1: P1 + P2 (EXP-D + EXP-A) — 3-4h total. Compra info sobre DEC-02 y DEC-REVIEWER-VERDICT.
Semana 2: P3 + P4 (DEC-03 C4 + DEC-12 12.a) — quick-wins convencionales.
Semana 3-8: P5 (EXP-B drift shadow ejecutándose en background).
Semana 4+: P6 (DEC-02 gate) usando output de EXP-A.
Post DEC-02: P7 + P8 (EXP-C + DEC-08).
Post EXP-B: DEC-04 decision con evidencia.
```

**Owner puede desviarse de este sequencing según preferencia**. La lista es advice, no plan.

---

## §34. ROOT SET (analytical, no Owner-choice)

**Roots verdaderos post-ARCH-007** (sin HARD upstream):

- **DEC-02** — semantic root (desbloquea DEC-07; resuelve K3-D-OWNER-DEFAULT).
- **DEC-03** — orthogonal root (independiente).
- **DEC-04** — architectural root (con caveat: requiere EXP-B primero).
- **DEC-08** — instrumentation root (G3 shadow inmediatamente ejecutable).
- **DEC-12** — documental root (bajo valor, marginal).

**Classification analítica**:

- **PRIMARY ROOT**: **DEC-02** (mayor downstream unlock + información gain).
- **SECONDARY ROOT**: **DEC-08 G3** (independiente; info gain alto sin lock-in).
- **ORTHOGONAL ROOT**: **DEC-03** (no toca ninguna otra decisión).
- **DEFERRED ROOT**: **DEC-04** (requiere shadow primero por lock-in ALTO).

**Nota crítica**: estos son **root candidates**, no decisions Owner-abiertas. Owner conserva prerrogativa completa de elegir cualquier orden.

---

## §35. IS THERE REALLY A NEXT MOVE?

Análisis obligatorio del Master Prompt §34.

### CASE A — Existe un siguiente decision gate claramente justificable

**Argumento a favor**: DEC-02 tiene problem-first justification, SUPPORTED confidence, ningún HARD upstream, y desbloquea DEC-07. Su ausencia perpetúa K3-D-OWNER-DEFAULT.

**Argumento en contra**: EXP-A (draft DEC-02 con AUTHORITY_KIND) tiene coste 2-4h y compra información significativa sobre si la revalidación §14 es empíricamente sostenible. Abrir DEC-02 sin EXP-A prematuramente asume la revalidación.

**Verdict CASE A**: **NO INMEDIATAMENTE**. DEC-02 es viable pero **EXP-A debería precederlo**.

### CASE B — Hay dos o más candidatos similares y hace falta otro experimento

**Argumento**: DEC-02 y DEC-04 son ambos roots. DEC-04 requiere EXP-B primero por lock-in ALTO. DEC-02 gana en información pre-existente (ARCH-006 provee AUTHORITY_KIND).

**Verdict CASE B**: **PARCIALMENTE**. DEC-02 se puede preparar; DEC-04 debe esperar.

### CASE C — No hay suficiente evidencia para abrir ninguna nueva decisión

**Argumento**: DEC-03 C4, DEC-12 12.a son quick-wins con evidencia empírica clara. **NO se aplica CASE C**.

**Verdict CASE C**: **NO**.

### CASE D — La siguiente acción correcta no es una decisión sino recomposición/experimento

**Argumento**: EXP-D (HRQS verify), EXP-A (DEC-02 draft), EXP-B (drift shadow) son experimentos con bajo coste, alto info-gain, ejecutables sin cruzar F9-D01.

**Verdict CASE D**: **SÍ, PARCIALMENTE**. Estos experimentos preceden productivamente a los gates.

### CASE E — Descubrimos una nueva decisión latente que domina las antiguas

**Argumento**: §22 latent hunt resultó en 0 verdaderamente nuevas. §23 second-order gap hunt igualmente. **NO se aplica CASE E**.

**Verdict CASE E**: **NO**.

### Verdict consolidado

- **CASE D dominante** (experimentos primero).
- **CASE A subyacente** (DEC-02 tras EXP-A).
- **CASE C rechazada** (DEC-03/12 disponibles).
- **CASE E rechazada** (no latent).

**El próximo movimiento correcto NO es abrir un gate**. Es **ejecutar EXP-D y EXP-A** (bajo coste, alto info), y **evaluar DEC-03 C4 y DEC-12 12.a** como quick-wins. Sólo tras EXP-A ejecutado, DEC-02 se convierte en gate candidate con confidence alta.

---

## §36. ADVERSARIAL AUDIT (self-attack)

### 36.1 ¿Heredé demasiado del mapa anterior?

- **Riesgo**: sí, en §10 DAG revalidation partí del DAG histórico y evalué edge por edge. Podría haber reconstruido desde cero antes.
- **Mitigación**: §11 hice reconstrucción independiente y coincide en aristas HARD (DEC-02→DEC-07, DEC-04→DEC-05).
- **Verdict**: riesgo controlado.

### 36.2 ¿Confundí active con open?

- **Verdict**: NO. §5 separó SET A (in-force), SET B (closed/resolved), SET D (open candidates).

### 36.3 ¿Conservé dependencias porque estaban escritas en MASTER_HANDOFF?

- **Riesgo**: parcial. DEC-02→DEC-07 HARD sobrevive porque presupongo "delegación explícita necesaria para verificación LLM". Es semánticamente sólido pero heredado.
- **Mitigación**: el argumento es reproducible desde principios (governance risk de delegación implícita).
- **Verdict**: riesgo aceptable con caveat.

### 36.4 ¿Traté AUTHORITY_KIND como action taxonomy sin evidencia?

- **Verdict**: **NO**. §9 explícitamente distinguí AUTHORITY_KIND vs ACTION_TYPE vs CHANGE_TYPE.

### 36.5 ¿Traté DEC-02 como inevitable siguiente?

- **Verdict**: **NO**. §35 CASE D dominante; DEC-02 es P6 en priorización tras EXP-A.

### 36.6 ¿Usé cardinalidad documental como proxy de governance problem?

- **Verdict**: parcial. DEC-12 usa cardinalidad; pero identifiqué que es descomponible en 5 sub-problemas y sólo 12.a es cardinalidad.

### 36.7 ¿Creé demasiadas nuevas decisiones?

- **Verdict**: **NO**. §22 rechacé todas las candidates NEW (0 verdaderamente nuevas).

### 36.8 ¿Retiré algo con consumer?

- **Verdict**: **NO**. DEC-05 no se "retiró" — permanece como sub-decisión coupled a DEC-04.

### 36.9 ¿Confundí candidate con open?

- **Verdict**: **NO**. §32 candidate set explícitamente separa de OPEN decisions.

### 36.10 ¿Alguna decisión debería ser absorbida?

- **Sí, identificado**: DEC-REVIEWER-VERDICT absorbible en DEC-07 (§20.3); DEC-12 (12.c, 12.e) subsumibles en DEC-03.

### 36.11 ¿Algún problema necesita experimento antes de gate?

- **Sí**: DEC-04 (EXP-B), DEC-02 (EXP-A), DEC-REVIEWER-VERDICT (EXP-D).

### 36.12 ¿Algún nuevo artefacto sería otra fuente de verdad?

- **Riesgo**: este artefacto podría convertirse en tal si Owner lo trata como canonical.
- **Mitigación**: Stratum-C untracked; marcado como analytical.

### 36.13 ¿Estoy optimizando avance en lugar de info-gain?

- **Verdict**: **NO**. §35 explícitamente concluyó CASE D (experimentos primero).

---

## §37. THIRD-LEVEL PERSPECTIVES

### 37.1 Minimalist Engineer

> "You already retired DEC-01 monolithic. Do the same to DEC-12 (subsume into DEC-03), DEC-05 (couple to DEC-04, don't open independently), DEC-REVIEWER-VERDICT (absorb into DEC-07 if DEC-07 opens). Reduce 9 open decisions to 5. Then ask: do you need any of the 5 open NOW, or do experiments buy enough info to defer 3 more?"

Peso: ALTO. Alinea con anti-inertia principle.

### 37.2 Control Plane Architect

> "The pattern from ARCH-005/006/007 is: taxonomy + rules > registry + enforcement. DEC-02 is the natural next test of this pattern: can DELEGATION be a taxonomy + rules (action-type vocab + revocation rules) rather than a registry pieza-por-pieza? If yes, DEC-02 becomes 'AB5-analog for delegation'. If not, that itself is informative. EXP-A tests exactly this."

Peso: ALTO. Reconoce dirección arquitectónica.

### 37.3 Future Maintainer (12-24 meses)

> "In 12 months someone will read PROJECT_STATE and see 6 DEFERRED items + 9 open + 3 recent ARCH-*. They need to know why. This artifact + DECISION_HISTORY entries preserve the reasoning. The next actionable thing is: don't create more open decisions; execute cheap experiments; when DEC-02 opens, use ARCH-006/007 as procedural precedents."

Peso: ALTO. Enfatiza legibilidad y no-proliferación.

### 37.4 Convergencia

Las tres perspectivas convergen en:

1. Reducir el conjunto open (absorbing/subsuming donde sea posible).
2. Ejecutar experimentos baratos primero (EXP-D, EXP-A).
3. Cuando abrir gates, aplicar patrones ARCH-005/006/007.
4. No crear nuevas decisiones por inercia.

---

## §38. PROPAGATION MATRIX

| Cambio | Artifact impact | Decision impact | Dependency impact | Evidence impact | Owner impact |
|---|---|---|---|---|---|
| **ARCH-005 (DEC-11)** | +1 policy doc (DEFERRAL_POLICY.md); YAML blocks retrofit en 3 docs | +1 active decision; absorbs DEC-13 | Habilita ARCH-006/007 procedural precedent | Sin nueva EVIDENCE_REGISTRY entry | Enables DEC-08 formal opening |
| **ARCH-006 (DEC-AUTH-BOUNDARY)** | +1 canonical doc (AUTHORITY_KIND.md, 315 líneas) | +1 active decision; materializes PRIM-1 | Revalidates DEC-02 relation SOFT/ENABLER; §6 prohibitions constrain future decisions | Sin EVIDENCE_REGISTRY entry (docs-only) | Enables DEC-01 gate with proper framing |
| **ARCH-007 (DEC-01)** | Zero artifacts (docs-only bookkeeping in 3 existing docs) | -1 monolithic decision (DEC-01 retired); +1 DEFERRED (E1); +3 RETIRED (E2/E3/E4 with RESOLVED_BY) | Reclassifies DEC-01→DEC-02 as SOFT/ENABLER; introduces SPLIT+DEFER pattern | Sin EVIDENCE_REGISTRY entry | Owner precedent: retire monolithic decisions with adversarial audit |

**Cross-cutting propagation**:

- MASTER_HANDOFF §7-13 permanece con framing 13-decision histórico (snapshot, no living).
- DECISION_SPACE_PREPARED permanece con framing pre-ARCH-006 (Stratum-C, frozen).
- Este artefacto (POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md) es la reconciliación explícita.

---

## §39. DECISION GENEALOGY

```text
KIMI K3
  ↓ (13 decisions identified)
MASTER_HANDOFF (2026-09-24)
  ↓ (13-decision map preserved; DEC-06/09/10/13 flagged as derivable/retire)
DECISION_SPACE_PREPARED (2026-09-25)
  ↓ (12-decision map; 3 new; DEC-11/DEC-01 as roots)
ARCH-005 = DEC-11 (2026-09-26)
  ↓ (deferral policy formalized; DEC-13 absorbed)
ARCH-006 = DEC-AUTH-BOUNDARY (2026-09-26/27)
  ↓ (AUTHORITY_KIND materialized; DEC-02 relation SOFT/ENABLER)
ARCH-007 = DEC-01 (2026-09-27)
  ↓ (SPLIT+DEFER; E1 deferred; E2/E3/E4 RESOLVED_BY retired)
POST-ARCH-007 RECOMPOSITION (2026-09-27, this document)
  ↓ (9 open decisions revalidated; 4 weakly supported; irreducible triple → coupled pair)
CURRENT DECISION SPACE
  = { DEC-02, DEC-03, DEC-04+DEC-05 (coupled), DEC-07, DEC-08, DEC-12, DEC-STREAM-CONSUMER, DEC-REVIEWER-VERDICT }
   with 4 candidates for absorb/defer/subsume.
```

**Decisions inheritadas del mapa histórico**: 9.
**Decisions reformuladas**: 0 (todas mantienen formulación semántica).
**Decisions invalidated**: 4 (DEC-01 monolítico + DEC-06/09/10/13 previamente).
**Decisions absorbed**: 1 (DEC-13 → ARCH-005).
**Decisions newly emerged**: 0.

**Key insight de genealogy**: los 3 últimos movimientos (ARCH-005/006/007) redujeron el espacio de trabajo activo sin producir decisiones "revolucionarias nuevas". Cada uno atacó una hipótesis heredada (piece-first framing) y la retiró o taxonomizó. Este es el pattern estable.

---

## §40. DECISION SPACE QUALITY SCORECARD

| Dimensión | Evaluación cualitativa |
|---|---|
| Completeness | ALTA — 9 open decisions cubren governance base + arquitectura + instrumentation + verification |
| Coherence | ALTA — cada decisión tiene frontera semántica clara post-ARCH-007 |
| Traceability | ALTA — DECISION_REGISTRY + DECISION_HISTORY + git log |
| Non-duplication | ALTA — sin decisions duplicadas post-retirement de DEC-01 monolítico |
| Dependency correctness | MED-ALTA — §10 revalidó; DEC-02→DEC-07 y DEC-04→DEC-05 son las HARD remaining |
| Owner clarity | MEDIA — Owner necesita este artefacto para navegar el espacio post-ARCH-007 |
| Reversibility (por decision) | ALTA — la mayoría low lock-in; DEC-04/07 excepciones documentadas |
| Evidence quality | MED — DEC-04/07 dependen de experimentos aún no ejecutados |
| Evolution | ALTA — patrones ARCH-005/006/007 permiten recomposición sin ruptura |

**Verdict global**: decision space **maduro y coherente**. Los gaps son marginales y direccionables por experimentos baratos.

---

## §41. FINAL RECOMPOSITION

```text
FINAL DECISION SPACE POST-ARCH-007
════════════════════════════════════════════

IN-FORCE:              ARCH-001, ARCH-002, ARCH-003, ARCH-004,
                       ARCH-005, ARCH-006, ARCH-007

DEFERRED:              CDT-02, AC-03, NH-11, F10-F12, DEC-01-E1

OPEN (with dependencies):
                       DEC-02 D-DELEG           [PRIMARY ROOT, HARD → DEC-07]
                       DEC-03 D-LIFECYCLE       [ORTHOGONAL ROOT]
                       DEC-04 D-CANONICAL       [DEFERRED ROOT — requires EXP-B]
                       DEC-05 D-MOTOR           [COUPLED to DEC-04]
                       DEC-07 D-VERIFICADOR     [HARD ← DEC-02, requires DEC-02 + EXP-E]
                       DEC-08 D-INSTR           [SECONDARY ROOT — G3 shadow avail]
                       DEC-12 D-META-DOC        [MARGINAL, decomposable]
                       DEC-STREAM-CONSUMER      [DEFER candidate]
                       DEC-REVIEWER-VERDICT     [absorb into DEC-07 candidate]

RETIRED:               DEC-01 monolítico → ARCH-007
                       DEC-01-E2, E3, E4 (RESOLVED_BY)
                       DEC-06, DEC-09, DEC-10, DEC-13
                       (all pre-recomposition retirements confirmed)

ABSORBED:              DEC-13 → ARCH-005 (trigger field)
                       DEC-AUTH-BOUNDARY → ARCH-006

CANDIDATE ABSORPTIONS: DEC-REVIEWER-VERDICT → DEC-07 (if opened)
                       DEC-12 (12.c, 12.e) → DEC-03 (front-matter fields)

NEW LATENT DECISIONS:  0 (zero — no verdaderamente nuevas)

BIGGEST BOTTLENECK:    NINGUNO estructural.
                       Info-gap: evidence pre-DEC-04 (drift materiality).

PROCEDURAL PATTERNS AVAILABLE:
                       ARCH-005 pattern: docs-only retrofit + YAML in-doc.
                       ARCH-006 pattern: taxonomy + closed vocab + reopening procedure.
                       ARCH-007 pattern: SPLIT + DEFER + RETIRE con RESOLVED_BY.
```

---

## §42. OWNER HANDOFF

### CURRENT STATE (post-ARCH-007)

- HEAD = `e529359`. ARCH-007 checkpointed.
- 7 ACTIVE decisions.
- 5 DEFERRED items with canonical trigger YAML.
- 9 potentially-open candidates (with 4 marked for absorption/subsumption).
- 0 new latent decisions from this recomposition.

### WHAT CHANGED (después de ARCH-007)

1. **DEC-01 monolítico**: retirado. Sólo E1 permanece observable.
2. **Aristas HARD del DAG**: reducidas de ~5 a **2** (DEC-02→DEC-07 y DEC-04→DEC-05).
3. **"Irreducible triple"**: refutada como axioma; el coupling real es par **{DEC-04, DEC-05}**.
4. **Bloque A histórico** (6 decisions): degenerado a 3 (DEC-02, DEC-12, DEC-03) con distintas madurez.
5. **Patrón procedural nuevo**: SPLIT+DEFER+RESOLVED_BY añadido al vocabulario.
6. **GAP-piece "CATALOG"**: retirada; lista reducida a 5 (DERIVE-OP, DELEG-REG, LIFECYCLE-REG, POL-CANON, SHADOW-RT).

### WHAT DISAPPEARED (dependencias/decisiones que dejaron de existir)

- DEC-01 → DEC-02 HARD.
- DEC-AUTH-BOUNDARY → DEC-02 HARD (ARCH-006 §7 declaró SOFT/ENABLER).
- DEC-11 → DEC-08 HARD (ARCH-005 cerrada; ahora precedente procedural).
- "Bloque A completo como precondición".

### WHAT REMAINS OPEN (verdaderamente Owner-decidibles hoy)

- **DEC-02 D-DELEG** (root; SUPPORTED; requiere EXP-A previa recomendada).
- **DEC-03 C4** (subset front-matter; quick-win).
- **DEC-08 G3 shadow** (root; SUPPORTED; ejecutable sin cruzar F9-D01).
- **DEC-12 12.a** (cap; micro-decisión).

### WHAT IS DEFERRED (por ARCH-007 y precedentes)

- **DEC-01-E1** con dec01.T1..T6 (combine ANY).
- **CDT-02, AC-03, NH-11, F10-F12** (pre-existentes).
- **DEC-04** (deferred por lock-in ALTO; requiere EXP-B primero).
- **DEC-07 F2** (deferred por HARD ← DEC-02 + EXP-E primero).

### NEW CANDIDATES (sufficient justification)

**Cero decisiones verdaderamente nuevas**. Cuatro **candidatos a absorción/subsumción**:

- DEC-REVIEWER-VERDICT → absorb into DEC-07 (si se abre).
- DEC-12 12.c/12.e → subsumibles en DEC-03.
- DEC-05 → coupled a DEC-04 (no independiente).
- DEC-STREAM-CONSUMER → DEFER hasta trigger de volumen.

### ROOT CANDIDATES (analytical)

- **PRIMARY**: DEC-02 (post EXP-A).
- **SECONDARY**: DEC-08 G3 (ejecutable ya).
- **ORTHOGONAL**: DEC-03.
- **DEFERRED**: DEC-04 (post EXP-B).

### DEPENDENCY CHANGES (respecto DECISION_SPACE_PREPARED §3.1)

- 4 HARD edges eliminated (§10).
- 2 HARD edges survive (DEC-02→DEC-07, DEC-04→DEC-05).
- 1 mutual-illumination pair (DEC-08 ↔ DEC-STREAM-CONSUMER).
- 1 SOFT edge (DEC-03→DEC-12).

### INFORMATION GAPS (que importan)

- **INFO-G-1**: ¿existe drift material verificable entre `.md` y regex? → resoluble EXP-B.
- **INFO-G-2**: ¿HRQS §12 cubre GAP-META-1? → resoluble EXP-D (30 min).
- **INFO-G-3**: ¿DEC-02 formulable sin D-CATALOG? → resoluble EXP-A.
- **INFO-G-4**: FP/FN rate del LLM reviewer sobre commits reales → resoluble EXP-E.
- **INFO-G-5**: ¿Volumen STALL crecerá? → observacional, sin experimento explícito.

### REVERSIBLE EXPERIMENTS

- **EXP-D** (HRQS verify, 30 min).
- **EXP-A** (DEC-02 draft, 2-4h).
- **EXP-B** (drift shadow, 60 días background).
- **EXP-C** (STALL G3 shadow, 30-60 días).
- **EXP-E** (LLM shadow, 1-2 días — post EXP-D).

Ver §30 para detalles.

### PREMATURE DECISIONS TO AVOID

- **DEC-04 D1/D3/D4** sin EXP-B.
- **DEC-07 F2** sin DEC-02 + EXP-E.
- **DEC-STREAM-CONSUMER CO3/CO4** sin volumen ≥50/mes.
- **DEC-05** independiente (no tiene sentido sin DEC-04).
- **DEC-REVIEWER-VERDICT** sin EXP-D primero.
- **Nuevo registry o taxonomy** ex-ante (mismo anti-patrón que hubiera sido DEC-01 A2).

### NEXT-GATE CANDIDATE

```text
CANDIDATE — NOT OWNER CHOSEN — NOT OPENED — NOT AUTHORIZED

Preferred candidate:  DEC-02 D-DELEG
Preferred precondition: EXP-A (draft DEC-02 con AUTHORITY_KIND, 2-4h Stratum-C)

Alternative primary candidate: DEC-08 G3 shadow (ejecutable inmediatamente)
Alternative low-risk: DEC-03 C4 + DEC-12 12.a como quick-wins

Rationale: DEC-02 tiene root+SUPPORTED+HARD-unlock a DEC-07; EXP-A antes reduce
riesgo de opening prematuro con framing implícito de DEC-01 residual.
```

### ALTERNATIVE NEXT MOVES (max 3)

**PATH 1 — Experiment-first**:
Ejecutar EXP-D + EXP-A (semana 1). Con outputs, evaluar apertura de DEC-02 y decisión sobre DEC-REVIEWER-VERDICT (absorb vs DEFER).

**PATH 2 — Quick-wins-first**:
Cerrar DEC-03 C4 + DEC-12 12.a como docs-only convenciones (semana 1). Después ejecutar experimentos.

**PATH 3 — Defer todo, execute experiments en background**:
Ejecutar EXP-B (drift shadow) + EXP-D en semana 1. No abrir ningún gate hasta outputs disponibles. Aceptar que decision space permanece "large open" durante ese período.

**No hay PATH 4 recomendado que sea "abrir DEC-02 gate directamente"**. La preparación previa con EXP-A es materialmente más informativa (2-4h coste vs. potencial reworking del gate).

### DECISION BOUNDARY

**Qué está en Owner authority**:

- Elegir entre PATH 1/2/3 o cualquier variante.
- Autorizar cualquier experimento (EXP-A..E).
- Abrir cualquier gate en cualquier orden.
- Ignorar completamente estas recomendaciones.

**Qué NO está en Owner authority por este artefacto**:

- Este artefacto **no** modifica el decision space canónico.
- **No** implementa ninguna decisión.
- **No** materializa nada.

---

## §43. CONFIDENCE TABLE

| Sección / claim | Confidence | Fuente / justificación |
|---|---|---|
| §1 Baseline | HIGH (95%) | git verificado |
| §2 Strata | HIGH (95%) | git status directo |
| §3 ARCH-007 integrity | HIGH (95%) | git show + registry read |
| §4 Canonical snapshot | HIGH (95%) | fuentes canónicas |
| §5 SET reconciliation | HIGH (90%) | fuentes canónicas |
| §6+§21 Ghost scan | HIGH (85%) | scan directo + criterio snapshot vs living |
| §7+§9 DEC-01→DEC-02 revalidation | MED-HIGH (75%) | gate §14 argumento sólido; refutable si DEC-02 elige change_type key |
| §8 Propagation audit | HIGH (85%) | verificable en registry + gate document |
| §10 DAG edge revalidation | MED-HIGH (75%) | argumentos reproducibles; algunos requieren gate individual |
| §11 DAG rebuild | MED-HIGH (75%) | reconstructor independiente coincide con §10 |
| §12 Irreducible triple refutada | MED-HIGH (75%) | ataque semántico sólido; refutable con requerimiento concreto de coupling |
| §13-§20 Individual reanalyses | MED (65-75%) | análisis conceptual; sin experimentos empíricos ejecutados |
| §22 Latent hunt (0 new) | MED-HIGH (75%) | criterio PROBLEM+EVIDENCE+OPTIONS aplicado; podría revelarse candidato tras experimentos |
| §23 Second-order gap hunt | MED (70%) | análisis del patrón procedural |
| §24-§27 Tests de madurez / roadmap / piece-first / benefit>complexity | MED-HIGH (75%) | criterios reproducibles |
| §28 Lock-in map | MED-HIGH (75%) | estimaciones cualitativas |
| §29 Info value map | MED (70%) | dependent de outputs no ejecutados |
| §30 Experiment catalog | HIGH (80%) | experimentos declarados con costes verificables |
| §31-§34 Candidate set / prioritization / roots | MED-HIGH (75%) | ordenamiento cualitativo |
| §35 CASE analysis | HIGH (80%) | argumento reproducible |
| §36 Adversarial self-attack | HIGH (85%) | risk registration explícito |
| §37 Three perspectives | HIGH (80%) | patrón de convergencia |
| §38-§40 Propagation matrix / genealogy / quality | HIGH (80%) | traza documental verificada |
| §41 Final recomposition | MED-HIGH (75%) | consolidación de secciones previas |
| §42 Owner handoff | MED-HIGH (75%) | recomendaciones no vinculantes |

**Conclusiones con confidence <60%** (evitar como recomendación fuerte):

- Preferencia entre PATH 1/2/3 (§42) — depende de Owner criterion.
- Absorption de DEC-REVIEWER-VERDICT en DEC-07 — pendiente EXP-D.
- Subsumption de DEC-12 en DEC-03 — pendiente DEC-03 gate.

---

## §44. STATUS DECLARATION (FINAL)

- **NO Owner Choice** emitida en este artefacto.
- **NO IMPLEMENTATION AUTHORIZATION** emitida.
- **NO CHECKPOINT** propuesto por esta sesión.
- **NO NEW DECISION** creada.
- **NO EDGE DE DEPENDENCY MODIFICADA** en fuente canónica (solo re-reading y re-classification analítica).
- **NO RUNTIME, HOOK, SKILL, RULE, REGISTRY MODIFICADO**.
- Este artefacto es **Stratum-C untracked**; su persistencia queda a criterio Owner.

**Success criterion del Master Prompt §48**: se demuestra qué cambió el espacio decisional como consecuencia de ARCH-007 (§8, §10, §12, §38, §39) y qué sigue siendo estructuralmente necesario después de eliminar el framing obsoleto (§25 roadmap inertia, §26 piece-first vs problem-first, §27 benefit>complexity). El próximo movimiento correcto **no es abrir DEC-02**, es ejecutar EXP-A/D como precondición (§35 CASE D). El resultado puede coincidir con DEC-02 tras experimentos, pero **no se fuerza** CASE A.

**END — POST-ARCH-007 DECISION SPACE RECOMPOSITION — COMPLETE**
