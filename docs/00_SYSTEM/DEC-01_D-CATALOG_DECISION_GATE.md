# DEC-01 D-CATALOG — DECISION GATE

> Auditoría estructural profunda + Owner Decision Gate para DEC-01/D-CATALOG.
> Baseline: `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md`, `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md`,
> `docs/00_SYSTEM/MASTER_HANDOFF.md`, `docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006),
> `DECISION_REGISTRY.md` (ARCH-001..006), `PROJECT_STATE.md`.
> Fecha: 2026-09-27. Autor: Claude Opus 4.7 (investigador, no decisor).
> **STATUS: DECISION GATE OPEN — NO OWNER_CHOSEN — NO IMPLEMENTATION.**
> **Este documento no cierra la decisión. Prepara el gate para Owner.**

Epistemología: `VERIFIED` · `DOCUMENTED` · `INFERENCE` · `HYPOTHESIS` · `CONTRADICTED` · `UNKNOWN`.
Regla operativa: preferir `UNKNOWN` explícito antes que invento; separar `OBSERVACIÓN /
DETERMINACIÓN / ALTERNATIVAS / RECOMENDACIÓN TÉCNICA / OWNER DECISION`.

---

## §1. EXECUTIVE SUMMARY

**Hallazgo central**: "D-CATALOG" tal como fue formulado históricamente (K3 §13.1, MASTER §13.1,
DECISION_SPACE_PREPARED §4.1) **no es una entidad semántica coherente**. La formulación
"catálogo `type × gate × auth_holder × precedent`" **agrupa cuatro dimensiones con
source-of-truth ya existente**, cada una con su propio ciclo de vida, autoridad y fuente
canónica. Materializar D-CATALOG como pieza de primer orden (opción A2 histórica) **crearía
un derived view disfrazado de canónico**, con lock-in de sincronización y coste de
mantenimiento no justificado por evidencia empírica.

**Cuatro sub-hallazgos que sobreviven al ataque adversarial**:

1. **La columna `type`** (tipos de cambio) **ya está enumerada canónicamente** en
   `.claude/rules/git-policy.md` (feat, fix, docs, arch, decision, security, infra, config).
   Un nuevo `CHANGE_TYPES_CATALOG.md` **duplicaría** esa fuente.
2. **La columna `auth_holder`** **ya se resolvió** en ARCH-006 / AUTHORITY_KIND
   (`{ mecánica, convención, humana, agente }` VOCAB-A CLOSED). Repetirla en D-CATALOG
   crearía mapping pieza→autoridad — **precisamente lo que ARCH-006 prohíbe** (§6
   Prohibiciones: "piece → authority mapping").
3. **La columna `gate`** es una relación derivable desde `.claude/hooks/` +
   `.claude/rules/` + `.claude/settings.json`. No es un objeto propio.
4. **La columna `precedent`** ya vive en `DECISION_REGISTRY.md` + `DECISION_HISTORY.md` +
   git log. No es un objeto propio.

**Corolario**: D-CATALOG **no sobrevive el test de homogeneidad semántica** (§6). No comparte
identidad, lifecycle, owner, versionado ni consumidores unificados. Es una **abstracción
prematura de conveniencia documental**.

**Empirical experiment** (§13): los últimos 30 commits se concentran en 2 tipos (`[RESEARCH]`,
`[CONFIG]`, con phase-tags `[F7]`, `[F8]`, `[F9]` de fases previas). No hay presión empírica
para una taxonomía más rica que la ya presente en `git-policy.md`.

**DEC-01 → DEC-02 HARD dependency revalidada como CONTESTED** (§14): la dependencia histórica
se apoya en una conflación semántica: la "categoría" que DEC-02 necesita es *action_type*
(qué acción es delegable), no *change_type* (qué prefijo lleva el commit). ARCH-006 ya
provee categorías de autoridad; DEC-02 puede formularse sin D-CATALOG.

**Decision space válido** (§16): las alternativas técnicamente sostenibles son
**STATUS_QUO**, **REFORMULATE/SPLIT** en sub-decisiones más pequeñas, y **DEFER** con
triggers observables. La formulación monolítica A2 histórica **no es una alternativa
técnicamente sostenible** después del ataque adversarial. La formulación A3 (con hook)
**cruzaría F9-D01=A** sin justificación empírica y queda estructuralmente prohibida por
V-AUTH-4 trigger (introducción implícita de mecánica sobre autoridad).

**Recommendation confidence**: `<60% para adopción monolítica`, **`>80% para SPLIT + DEFER`
tras aplicar precedente ARCH-006**. Por regla epistemológica (§34), ninguna recomendación
suficientemente fuerte para un tercero se emite sobre A2/A3; el trabajo del Owner es elegir
entre `REFORMULATE / SPLIT / DEFER / RETIRE`.

**Non-decision explícita**: este documento **no elige** por Owner y **no autoriza
implementación** de ninguna alternativa. La decisión persistirá únicamente después de una
acción explícita futura de Owner.

---

## §2. BASELINE SNAPSHOT

Comandos ejecutados 2026-09-27:

```text
git status --short
   M DECISION_REGISTRY.md
   M PROJECT_STATE.md
   M docs/00_SYSTEM/CLAUDE_SESSION_LOG.md
   M docs/00_SYSTEM/DECISION_HISTORY.md
   ?? CCP_MASTER_EXECUTION_PROMPT.md
   ?? docs/00_SYSTEM/DECISION_SPACE_PREPARED.md
   ?? docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md

git log --oneline -5
   473759c [CONFIG] checkpoint: ARCH-006 (DEC-AUTH-BOUNDARY) implementation — AB5 + VOCAB-A
   cd0511c [CONFIG] checkpoint: DEC-11 (ARCH-005) implementation — HYB-FINAL-v4 retrofit
   4277830 [CONFIG] checkpoint: DEC-11 closed (ARCH-005 persisted, IMPL_PENDING)
   f496897 [CONFIG] checkpoint: MASTER_HANDOFF + K3 corpus + RA audit
   1a6232d [RESEARCH] ROOT_ANALYSIS: complete F1-F12 protocol execution + 32 questions answered

git branch --show-current            → main
git rev-parse HEAD                    → 473759c9ee64469b3ab0899ef039ff823afe1e15
```

### Stratum classification (post-checkpoint hygiene)

| Stratum | Contenido | Regla operativa |
|---|---|---|
| **A — checkpointed** | HEAD = `473759c` (ARCH-006 implementation) | Base inmutable. |
| **B — bookkeeping unstaged** | `PROJECT_STATE.md`, `DECISION_REGISTRY.md`, `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`, `docs/00_SYSTEM/DECISION_HISTORY.md` | Cambios posteriores al checkpoint 473759c documentados en la conversación previa. NO tocar en esta sesión. |
| **C — artefactos analíticos untracked** | `CCP_MASTER_EXECUTION_PROMPT.md`, `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md`, `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md` | Artefactos analíticos previos (M009-M013). **NO borrar. NO stagear. NO comitear.** |

Este documento (`DEC-01_D-CATALOG_DECISION_GATE.md`) es **nuevo artefacto Stratum C** de esta
sesión. **NO se commitea** por este trabajo. Su persistencia queda a criterio Owner.

**PROJECT_STATE snapshot** (líneas 5-10):
- CURRENT_PHASE=8, PHASE_STATUS=COMPLETE.
- ACTIVE_DECISIONS: ARCH-001, ARCH-002, ARCH-003, ARCH-004, ARCH-005, ARCH-006.
- LAST_GIT_CHECKPOINT: 473759c.
- IMPLEMENTATION_READY: false.
- NEXT_ALLOWED_PHASE: None auto; requires new owner-driven project decision.

---

## §3. HISTORICAL RECONSTRUCTION — how DEC-01 was born

DEC-01 aparece por primera vez en el **decision graph de Kimi K3** y se documenta
explícitamente en varios documentos. Reconstruyo cada aparición con su formulación literal.

### 3.1 Primera formulación (Kimi K3 → MASTER_HANDOFF §7.1, línea 524)

```text
| DEC-01 | D-CATALOG (change-type × gate) | A | GOVERNANCE | CAN-DEFER | Sí (schema derivable) |
```

**Origen**: nomenclatura K3, bloque governance A, urgencia `CAN-DEFER`, marcada como
"schema derivable" (Owner-only). Nombre corto: **D-CATALOG (change-type × gate)** — nótese
que la formulación *columnar* aquí es **binaria**: `type × gate`.

### 3.2 Expansión a cuatro columnas (MASTER §13.1, línea 831)

```text
A2 — Catálogo Markdown declarativo
- Identidad: docs/00_SYSTEM/CHANGE_TYPES_CATALOG.md con tabla
  type × gate × auth_holder × precedent.
```

**Ampliación de scope**: de 2 columnas (K3) a 4 columnas. Se añadieron `auth_holder` (autoridad)
y `precedent` (jurisprudencia interna). Sin justificación estructural documentada para la
ampliación; es una decisión de diseño MASTER, no K3.

### 3.3 Descripción funcional (MASTER §13.1, líneas 830-843)

```text
Beneficios: elimina zona gris K3-D-OWNER-DEFAULT sin cambiar runtime; habilita DEC-02.
Costes: mantenimiento humano; ~1–2 horas construcción inicial; ~15 min/mes.
Impacto arquitect: ninguno de runtime.
Impacto epistemológico: hace visible qué autoridades están implícitas.
Impacto futuro: precondición limpia para DEC-02.
Second-order: reviewer humano tiene tabla de referencia para clasificar cambios.
Third-order: nueva discusión sobre "esto es tipo X o Y" migra del ad-hoc al comparativo.
```

**Función declarada**:
1. Eliminar `K3-D-OWNER-DEFAULT` (todo lo no delegado defaultea a humano).
2. Habilitar `DEC-02` (delegación).
3. Referencia para reviewer.

### 3.4 Piece-catalog listing (MASTER §28.2, línea 1555)

```text
Missing pieces (gaps): DERIVE-OP, DELEG-REG, CATALOG, LIFECYCLE-REG, POL-CANON, SHADOW-RT.
```

**Estatus**: `CATALOG` listada como **GAP piece** al mismo nivel que `DELEG-REG`,
`LIFECYCLE-REG`, `POL-CANON`. Todas son ausencias declaradas del CCP, no piezas presentes.

### 3.5 Piece displacement analysis (MASTER §31.1)

```text
DEC-01 A2 — INSERT
- Pieza movida: INSERT nueva pieza CATALOG (P-CAT).
- Interfaces afectadas: ninguna técnica; workflow humano cambia.
- Piezas desplazadas: convención implícita → convención declarativa.
- Piezas obsoletas: K3-D-OWNER-DEFAULT (parcialmente).
- Piezas nuevas: P-CAT.
- Invariantes: preserva INV-1..INV-8.
```

**Nota**: INSERT INTERFACES: **ninguna técnica**. D-CATALOG es puramente documental. Su
"movimiento" es convención implícita → convención declarativa. Autoridad: `convención` (per
ARCH-006 taxonomía).

### 3.6 DECISION_SPACE_PREPARED §4.1 (post-AUDIT, 2026-09-25)

Preservó la formulación A1/A2/A3 con algunas correcciones de framing:

- Opciones A1 (no hacer nada), A2 (Markdown declarativo), A3 (Markdown + hook — **cruza
  F9-D01**).
- Recommendation confidence: 85% para A2 como "quick win".
- Impacto sobre DEC-02: "sin categorías, DELEGATION_REGISTRY no tiene qué keys usar".
- Condicional: "Si Owner rechaza generar DEC-02 → catálogo pierde valor operativo".

Este documento **fue preparado antes de ARCH-006** (DEC-AUTH-BOUNDARY, 2026-09-26). ARCH-006
cambió el paisaje semántico de forma sustantiva para DEC-01 pero **no se ha propagado la
implicación al framing de DEC-01**. Este es un gap de coherencia que este Decision Gate
identifica y aborda.

### 3.7 PIECE_AND_IDEA_PUZZLE_AUDIT §5A (2026-09-25)

```text
5A. EXPLICIT MISSING
Ninguna que el MASTER no haya listado ya (los 6 GAP): DERIVE-OP, DELEG-REG, CATALOG,
LIFECYCLE-REG, POL-CANON, SHADOW-RT. No agrego duplicados; me remito al MASTER §28.1.
```

**AUDIT sostiene la ausencia de D-CATALOG como pieza faltante** pero no reevalúa si esa
ausencia es realmente un gap material. Es un caso de heredar el catálogo sin cuestionarlo.

### 3.8 Tabla de reconstrucción histórica

| Fuente | Formulación | Columnas | Consumidores declarados | Naturaleza semántica |
|---|---|---|---|---|
| K3 §13 (via MASTER §7.1) | `D-CATALOG (change-type × gate)` | 2 | schema derivable | derived index |
| MASTER §13.1 (2026-09-24) | `CHANGE_TYPES_CATALOG.md, type × gate × auth_holder × precedent` | 4 | reviewer humano; DEC-02; workflow | **join view** entre 4 fuentes |
| MASTER §28.1 (piece catalog) | `CATALOG` (GAP piece) | — | (missing) | gap declarado, no descrito |
| MASTER §31.1 | INSERT `P-CAT` | — | reviewer; workflow | pieza documental |
| MASTER §58.1 | `C1-A2-Min`, `C1-A2-Bal`, `C1-A3-Full` | 5 tipos observados + placeholder | reviewer | Markdown catalog |
| DECISION_SPACE_PREPARED §4.1 (2026-09-25) | `catálogo de tipos de cambio` (reformulado) | (inherit MASTER 4) | reviewer; DEC-02 | doc convención |
| PIECE_AND_IDEA_PUZZLE_AUDIT §5A | `CATALOG` GAP-piece hereda | — | — | heredado sin ataque |
| DECISION_SPACE_PREPARED §10 FICHA DEC-01 | "empezamos con 5 tipos observados + placeholder otros" | — | Owner | quick win |

**Divergencia entre fuentes** (identificada):

- K3 usa 2 columnas; MASTER pasa a 4 sin justificación estructural registrada.
- MASTER §13.1 dice "elimina K3-D-OWNER-DEFAULT" pero MASTER §31.1 aclara "parcialmente
  (no una pieza, sino un patrón)". El beneficio dominante declarado es **parcial**, no
  categórico.
- MASTER §58.1 propone "5 tipos observados"; en el corpus empírico real (§13 de este
  documento) los tipos son ≤2 dominantes.
- AUDIT hereda sin ataque; DECISION_SPACE_PREPARED reproduce formulación pre-ARCH-006 sin
  incorporar el precedente semántico de AB5+VOCAB-A.

---

## §4. EVIDENCE MATRIX

Toda afirmación relevante del análisis clasificada por autoridad epistemológica.

| # | Afirmación | Clasificación | Fuente / verificación |
|---|---|---|---|
| E1 | No existe `CHANGE_TYPES_CATALOG.md` en el repositorio hoy. | `VERIFIED` | `ls docs/00_SYSTEM/` no muestra tal archivo (2026-09-27). |
| E2 | `.claude/rules/git-policy.md` enumera 8 tipos de commit canónicos: feat, fix, docs, arch, decision, security, infra, config. | `VERIFIED` | Lectura directa del archivo, línea 3. |
| E3 | `docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006, 315 líneas) formaliza taxonomía cerrada de autoridad con 4 clases `{ mecánica, convención, humana, agente }`. | `VERIFIED` | Lectura directa; commit `473759c` (2026-09-27). |
| E4 | ARCH-006 §6 **prohíbe explícitamente** "piece → authority mapping", "DELEGATION_REGISTRY", "AUTHORITY_BOUNDARY.md o artefactos con nombre y alcance de AB2", y "meta-authority". | `VERIFIED` | AUTHORITY_KIND.md §6 líneas 207-228. |
| E5 | `DECISION_REGISTRY.md` contiene ARCH-001..ARCH-006 como decisiones activas con historial. | `VERIFIED` | Lectura directa (2026-09-27). |
| E6 | `DECISION_HISTORY.md` es "compact learning index of Owner-closed DEC-* decisions". | `VERIFIED` | Lectura directa. |
| E7 | K3 formuló DEC-01 como 2 columnas (`type × gate`); MASTER lo expandió a 4 sin registro de justificación estructural. | `DOCUMENTED` | Comparación MASTER §7.1 vs §13.1. |
| E8 | Los últimos 30 commits se concentran en ≤2 tipos dominantes (`[RESEARCH]`, `[CONFIG]`); phase-tags históricos `[F7]`, `[F8]`, `[F9]` corresponden a fases ya cerradas. | `VERIFIED` | Empirical experiment §13. |
| E9 | La formulación A3 "hook rechaza commit con tipo no listado" cruza F9-D01=A ("gate closure kept, no runtime changes"). | `VERIFIED` | F9-D01=A per `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`; A3 introduce nuevo hook runtime. |
| E10 | La dependencia HARD DEC-01 → DEC-02 se justifica como "categorías precondición del registry" (`DECISION_SPACE_PREPARED §3.1`). | `DOCUMENTED` | DECISION_SPACE_PREPARED línea 139. |
| E11 | La formulación de DEC-02 (`action_type, delegated_to, fallback, activated_by, revocable`) usa "action_type" no "change_type". | `VERIFIED` | MASTER §13.2 línea 875. |
| E12 | ARCH-006 relación con DEC-02 es explícitamente **SOFT / ENABLER, no HARD**. | `VERIFIED` | AUTHORITY_KIND.md §7 líneas 234-240; ARCH-006 §RELACIÓN CON OTRAS DECISIONES. |
| E13 | ARCH-005 (DEC-11 / DEFERRAL_POLICY) es precedente procedimental de "taxonomy + change rules only, no registry". | `VERIFIED` | DECISION_REGISTRY.md ARCH-005 SCOPE. |
| E14 | `docs/CONTROL_PLANE_HANDBOOK.md` §12 contiene HRQS (Human Review Quality Standard) con checklist de revisión. | `VERIFIED` | Grep resultado línea 995+. |
| E15 | `docs/00_SYSTEM/CCP_RESEARCH_ARCHITECTURAL_KNOWLEDGE_ATLAS.md` (153k), `MASTER_HANDOFF.md` (195k) contienen abundante material sobre governance sin materializar D-CATALOG. | `VERIFIED` | ls -la del directorio. |
| E16 | El "sync manual" es la fragilidad central del CCP (identificada como GAP-1 en múltiples fuentes). Materializar D-CATALOG como join view añade otro punto de sync manual. | `INFERENCE` | Análisis §11 (redundancy). |
| E17 | No hay hook, script, agente o skill que consuma un `CHANGE_TYPES_CATALOG.md` hoy. | `VERIFIED` | grep en `.claude/hooks/`, `.claude/agents/`, no matches. |
| E18 | No existe evidencia empírica documentada de un incidente donde la ausencia de D-CATALOG haya causado un problema material. | `VERIFIED` (por ausencia) | INCIDENT_REGISTRY.md, BEHAVIORAL_RELIABILITY_AUDIT.md no citan tal incidente. |
| E19 | Existe "K3-D-OWNER-DEFAULT" como zona gris documentada (todo lo no delegado defaultea al Owner). | `DOCUMENTED` | MASTER §6.3, K3 corpus. |
| E20 | K3-D-OWNER-DEFAULT ya se **reduce parcialmente** vía AUTHORITY_KIND (ARCH-006) — la taxonomía de autoridad hace explícito qué clase de autoridad opera. | `INFERENCE` | Análisis §17 (impacto ARCH-006 sobre D-CATALOG). |
| E21 | Ninguna afirmación de MASTER §13.1 o DECISION_SPACE_PREPARED §4.1 tiene como fuente evidencia empírica de un problema concreto atribuido a la ausencia de D-CATALOG. | `VERIFIED` (auditoría textual) | Repaso completo de ambos documentos. |

**Contradicciones detectadas**:

- **C1**: MASTER §13.1 dice "elimina K3-D-OWNER-DEFAULT"; MASTER §31.1 dice "parcialmente
  (no una pieza, sino un patrón)". Autoridad mayor: §31.1 (más específica y posterior en la
  narrativa). Incertidumbre residual: **magnitud del beneficio es "parcial", no
  categórico**.
- **C2**: `DECISION_SPACE_PREPARED §3.1` marca DEC-01 → DEC-02 como HARD; el análisis de
  esta sesión (§14) argumenta CONTESTED por conflación semántica `change_type` vs
  `action_type`. Autoridad mayor: análisis nuevo con evidencia E11 + E12 del paisaje
  post-ARCH-006 no considerado en el documento previo.

---

## §5. SEMANTIC DEFINITION — attack: is D-CATALOG a real entity?

Este es el punto más importante del ataque. **Hipótesis a destruir**:

> H0: "D-CATALOG es una única abstracción coherente que representa una frontera semántica
> real del CCP".

### 5.1 Test de identidad

**Pregunta**: ¿tiene D-CATALOG una única identidad, o varias identidades encubiertas?

Descompongo la formulación MASTER: `type × gate × auth_holder × precedent`.

| Sub-objeto | Identidad | Fuente-de-verdad efectiva hoy |
|---|---|---|
| `type` | Tipo de cambio (commit classification) | `.claude/rules/git-policy.md` (línea 3, enumeración canónica de 8 tipos) |
| `gate` | Mecanismo de enforcement aplicable | `.claude/hooks/*.sh` + `.claude/rules/*.md` + `.claude/settings.json` |
| `auth_holder` | Clase de autoridad ATTESTED | `docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006, taxonomía cerrada) |
| `precedent` | Jurisprudencia interna | `DECISION_REGISTRY.md` + `DECISION_HISTORY.md` + git log |

**Veredicto**: **cuatro identidades independientes**, cada una con su fuente-de-verdad
propia. D-CATALOG no tiene identidad propia — sería una **join view** sobre cuatro fuentes.

### 5.2 Test de lifecycle

¿Los sub-objetos tienen el mismo ciclo de vida?

- `type`: cambia cuando el equipo adopta un nuevo prefijo (evento raro, últimos 30
  commits sin cambio).
- `gate`: cambia cuando se añade/modifica un hook o rule (F7, F8-A demuestran ejemplos).
- `auth_holder`: cambia cuando reabre ARCH-006 (VOCAB-A CLOSED); frecuencia mínima
  esperada.
- `precedent`: crece con cada decisión Owner cerrada (append-only). Frecuencia media.

**Cuatro lifecycles distintos**. No hay lifecycle común. **Falla el test**.

### 5.3 Test de autoridad

¿Los sub-objetos tienen el mismo tipo de autoridad?

- `type`: `convención` (git-policy.md es convention layer).
- `gate`: `mecánica` (los hooks deciden en tiempo real).
- `auth_holder`: taxonomía autorizada por `humana` (Owner ARCH-006) sobre clases mixtas.
- `precedent`: append-only sobre `humana` (Owner) para DECISION_HISTORY.

**Cuatro authority-kinds distintas** (por ARCH-006 taxonomía). No hay autoridad
compartida. **Falla el test**.

### 5.4 Test de consumidor

¿Los mismos consumidores usan las cuatro columnas?

- `type`: reviewer humano y `git-policy` rule; no lo consume ningún hook para decisión.
- `gate`: hooks lo *son* — no lo consumen desde un catálogo; el enforcement es primario.
- `auth_holder`: **no tiene consumer runtime** por diseño ARCH-006 §6 (prohibido mapping).
- `precedent`: Owner + reviewer humano (via DECISION_HISTORY / DECISION_REGISTRY).

**Ninguna intersección de consumidores** entre las cuatro columnas. **Falla el test**.

### 5.5 Test de source-of-truth

¿Los sub-objetos comparten fuente canónica?

Ya enumerado: **cuatro fuentes independientes ya existentes**. Materializar D-CATALOG
crearía una **quinta fuente derivada**, con obligación implícita de sincronización manual
con las cuatro. Esto es **exactamente el anti-patrón "sync manual" identificado como GAP-1
central del CCP**.

### 5.6 Test de failure mode

¿Los sub-objetos fallan de la misma manera?

- `type stale`: nuevo tipo de commit sin actualizar catálogo → confusión reviewer.
- `gate stale`: nuevo hook sin actualizar catálogo → catálogo miente sobre enforcement.
- `auth_holder stale`: **imposible** — VOCAB-A CLOSED requiere reapertura formal.
- `precedent stale`: append-only histórico; no puede quedar stale por definición.

**Cuatro failure modes distintos con distinta severidad**. No comparten failure semantics.
**Falla el test**.

### 5.7 Veredicto de homogeneidad

**H0 CONTRADICTED**. Todas las pruebas de homogeneidad semántica fallan. D-CATALOG **no es
una entidad semántica coherente**. Es la **superposición de cuatro objetos con fuentes,
lifecycles, autoridades, consumidores y failure modes distintos**, agrupados por
conveniencia documental en la formulación K3/MASTER.

**Confidence**: `HIGH` (85%). La única duda residual es si algún caso de uso concreto
requiere el join view materializado (lo cual, por §11 redundancy, se resuelve como *NO
observado empíricamente*).

---

## §6. HOMOGENEITY TEST — extended

Aplicando explícitamente las 12 preguntas del Master Prompt §6 a los sub-objetos que la
formulación histórica agrupó:

| # | Criterio | `type` | `gate` | `auth_holder` | `precedent` | Comparten? |
|---|---|---|---|---|---|---|
| 1 | Mismo tipo de identidad | string enum | script + regla | taxonomía cerrada | evento histórico | **NO** |
| 2 | Mismo lifecycle | rara vez | F7/F8 style | ARCH-006 reopening | append-only | **NO** |
| 3 | Mismo owner | equipo/convención | maintainer runtime | Owner (VOCAB-A) | Owner | Parcial |
| 4 | Mismas reglas de versionado | por convención | por script | ARCH-006 §5 | append-only | **NO** |
| 5 | Misma provenance | git-policy.md | hooks/ | AUTHORITY_KIND.md | DEC HISTORY + REG | **NO** |
| 6 | Mismos consumidores | reviewer | runtime | (ninguno por prohibición) | Owner + reviewer | **NO** |
| 7 | Mismo tipo de autoridad | convención | mecánica | humana (para VOCAB) | humana (Owner) | Parcial |
| 8 | Mismo tipo de cambio | añadir enum | añadir script/rule | reapertura formal | append entry | **NO** |
| 9 | Mismos invariantes | prefijo válido | fail-closed | VOCAB-A CLOSED | append-only | **NO** |
| 10 | Mismas condiciones de eliminación | deprecación de prefijo | eliminar hook | reapertura formal | ninguna (historial) | **NO** |
| 11 | Mismo patrón de lookup | grep en rules | invocación de hook | lectura de doc | grep en registry | **NO** |
| 12 | Mismo coste de inconsistencia | reviewer confuso | policy hole | drift semántico | pérdida histórica | Alto pero distinto |

**Score de homogeneidad**: 0/12 completos, 2/12 parciales, 10/12 fallos.

**Corolario**: la formulación monolítica `type × gate × auth_holder × precedent`
**mezcla objetos que sólo comparten "aparecer en el gobierno del CCP"**. No es una
partición semántica válida.

**Partición mejor propuesta**:

```text
{type}                → responsabilidad de git-policy.md (ya presente)
{gate}                → responsabilidad de hooks + rules (ya presente)
{auth_holder}         → responsabilidad de AUTHORITY_KIND.md (ARCH-006, ya materializado)
{precedent}           → responsabilidad de DECISION_REGISTRY + DECISION_HISTORY (ya presentes)
```

Cada objeto **ya tiene su fuente-de-verdad canónica**. La "ausencia de D-CATALOG" no es
una ausencia de estructura; es la **ausencia de un join view que nadie ha demostrado
necesitar**.

---

## §7. CATALOG vs REGISTRY vs TAXONOMY — conceptual distinction

El Master Prompt exige distinguir explícitamente estos términos, evitando tratarlos como
sinónimos. Aplico la distinción a D-CATALOG.

### 7.1 Definiciones operativas

| Término | Definición operativa (contra prácticas del CCP) | Ejemplo canónico en CCP |
|---|---|---|
| **Catalog** | Enumeración descriptiva con propiedades; consulta preferentemente por browsing/lookup. | (no hay canonical ejemplo — hipotético en A2) |
| **Registry** | Fuente-de-verdad de identidades registradas; suele soportar auth flow y revocation. | `DECISION_REGISTRY.md`, `EVIDENCE_REGISTRY.md`, hipotéticos DELEG-REG. |
| **Taxonomy** | Vocabulario cerrado con relaciones semánticas; regla de evolución explícita. | `AUTHORITY_KIND.md` (ARCH-006 VOCAB-A). |
| **Index** | Puntero desde clave → recurso; derivable de otro artefacto. | ARTIFACT_MANIFEST §Índice, git log. |
| **Inventory** | Conteo de instancias existentes en un momento; snapshot. | STALL_POLICY_LOG.jsonl. |
| **Manifest** | Lista contractual de entregables; obliga cumplimiento. | `ARTIFACT_MANIFEST.md`. |
| **Schema** | Contrato de forma de datos. | `evidence contract`, `contract_hash` schema. |
| **Configuration** | Parámetros operativos runtime. | `.claude/settings.json`. |
| **Event log** | Append-only de eventos observados. | `STALL_POLICY_LOG.jsonl`, git log. |
| **Decision registry** | Registry específico de decisiones. | `DECISION_REGISTRY.md`. |
| **State model** | Objeto que describe fase / status / transiciones. | `PROJECT_STATE.md`. |

### 7.2 Test: ¿cuál palabra describe realmente lo que se propone en A2?

Aplicando las columnas de la formulación histórica:

- **Si D-CATALOG es un `Catalog`** (enumeración descriptiva con propiedades): entonces es
  documento de referencia sin contrato. Pero A2 declara "habilita DEC-02", lo que implica
  que **algo lo consumirá como contrato**. Contradicción de propósito. **No encaja
  puramente**.

- **Si D-CATALOG es un `Registry`** (fuente-de-verdad con auth/revocation): entonces debe
  tener autoridad sobre lo listado. Pero **ninguna de las 4 columnas tiene autoridad
  primaria en D-CATALOG**; todas la tienen en fuentes externas. **No encaja**.

- **Si D-CATALOG es una `Taxonomy`** (vocabulario cerrado + reglas de evolución): entonces
  debería declarar tipos con reglas de cambio. La columna `type` sí es taxonomizable —
  pero **ya vive en `git-policy.md`**; y ARCH-006 estableció el precedente de que las
  taxonomías del CCP siguen el patrón AB5 (docs-only, closed vocab, no registry). Encaja
  **solo para la columna `type`**, y **como duplicación de git-policy.md**.

- **Si D-CATALOG es un `Index`** (puntero derivable): entonces es join view sobre fuentes
  existentes. **Encaja mejor** pero convierte a D-CATALOG en artefacto derivado, no fuente
  de verdad, y añade un punto de sincronización (GAP-1).

- **Si D-CATALOG es un `Manifest`** (contractual): entonces obliga cumplimiento. Ninguna
  columna evidencia esto. **No encaja**.

**Veredicto**: la formulación histórica A2 usa "Catálogo" (palabra sin significado técnico
preciso) para lo que en cada caso es un objeto distinto o un artefacto derivado. Es un
**abuso terminológico** que oscurece la naturaleza real del objeto.

### 7.3 Consecuencias del abuso terminológico

- **DEC-01 → DEC-02 HARD** es literal si D-CATALOG es Registry con autoridad. Es contestado
  si es Index derivado. Es SOFT si es Taxonomy (per ARCH-006 precedent).
- **A3 "hook rechaza tipo no listado"** solo tiene sentido si D-CATALOG es Registry
  autoritativo. Como Index, no puede rechazar; como Taxonomy, git-policy.md ya cumple ese
  rol.
- **"Elimina K3-D-OWNER-DEFAULT"** solo se sostiene si D-CATALOG es **el objeto**
  autoritativo sobre "quién decide"; pero ese objeto **es** AUTHORITY_KIND.md por ARCH-006.

---

## §8. MULTI-REPRESENTATION ANALYSIS

Analizo D-CATALOG bajo múltiples representaciones para descubrir su naturaleza real.

### 8.1 Graph representation

```text
Nodos existentes:                              Nodos hipotéticos si A2:
  git-policy.md         (type enum)              CHANGE_TYPES_CATALOG.md
  hooks/*, rules/*      (gate)
  AUTHORITY_KIND.md     (auth_holder)
  DECISION_REGISTRY.md  (precedent)
  DECISION_HISTORY.md   (precedent)

Edges hipotéticos (post-A2):
  CHANGE_TYPES_CATALOG.md ─mirrors→ git-policy.md.types
  CHANGE_TYPES_CATALOG.md ─references→ hooks (gate column)
  CHANGE_TYPES_CATALOG.md ─references→ AUTHORITY_KIND.md (auth column) [prohibido §6]
  CHANGE_TYPES_CATALOG.md ─references→ DECISION_REGISTRY (precedent column)
```

**Análisis**:

- Un nodo real (`CHANGE_TYPES_CATALOG.md`) con **cuatro edges de dependencia hacia
  fuentes existentes**.
- Su propiedad crítica: **es leaf en el grafo de fuente-de-verdad**. Nada lo tiene como
  upstream canónico.
- Consecuencia: si desaparece D-CATALOG, **no se pierde información**. Sólo se pierde el
  join view.
- Contraparte: si desaparece cualquiera de sus 4 upstreams, D-CATALOG queda semanticamente
  inválido.

**Test formal**: ¿nodo D-CATALOG con in-degree=0 en fuente-de-verdad es una entidad
autónoma? **No**. Es un artefacto de proyección.

### 8.2 DAG de dependencias

```text
                                git-policy.md
                                     │
                             hooks/, rules/, settings
                                     │
                            AUTHORITY_KIND.md (ARCH-006)
                                     │
                            DECISION_REGISTRY.md
                                     │
                            DECISION_HISTORY.md
                                     │
                           ┌─────────┴─────────┐
                           ▼                   ▼
             (opción A2: derived view)   (opción A1: no derived view)
                CHANGE_TYPES_CATALOG.md         (nothing)
```

- Sin D-CATALOG, el grafo es completo para sus consumidores actuales
  (reviewer humano tiene rules + AUTHORITY_KIND; DEC-02 futuro tiene AUTHORITY_KIND).
- Con D-CATALOG, se añade nodo hoja con obligación de sync manual → **añade un edge de
  fragilidad, no de estructura**.

### 8.3 State machine

**Estados de D-CATALOG**:

```text
NON-EXISTENT → CREATED → { FRESH | STALE } → DELETED
```

- Entrada a `CREATED`: acción manual del Owner (A2).
- Transición `FRESH → STALE`: cualquier cambio en las 4 fuentes upstream sin retrofit.
- Transición `STALE → FRESH`: acción humana explícita (mantenimiento ~15 min/mes).
- Salida a `DELETED`: `git revert` (reversibilidad ALTA).

**No hay lifecycle común** con ningún otro objeto del CCP. Es lifecycle de artefacto
documental típico.

### 8.4 Control loop (Owner review workflow)

```text
OBSERVE       : Owner clasifica cambio pendiente.
DETERMINE     : ¿qué tipo de cambio es? → consulta git-policy.md
                ¿bajo qué autoridad? → consulta AUTHORITY_KIND.md
                ¿precedente? → consulta DECISION_REGISTRY.md
DECIDE        : Owner emite decisión (F9-D01..D05, DEC-11, DEC-AUTH-BOUNDARY, ...).
AUTHORIZE     : Owner ACK explícito.
CHANGE        : agente / reviewer ejecuta bajo autorización.
VERIFY        : maintenance.sh 12/12 + conformance V-* checks.
CHECKPOINT    : git commit + PROJECT_STATE update.
RECOMPOSE     : DECISION_HISTORY entry + framing update.
```

**Pregunta**: ¿en qué paso D-CATALOG agrega información no accesible desde las 4 fuentes
existentes?

**Respuesta**: en ninguno. El paso `DETERMINE` consulta 3 fuentes distintas hoy; D-CATALOG
sólo añade una capa de indirección sin nueva semántica.

### 8.5 Information flow

```text
Source of truth       Representation      Consumer
──────────────        ──────────────      ──────────
git-policy.md    ──►  [8 tipos]      ──►  reviewer humano, commit convention
hooks/, rules/   ──►  [gates activos] ──► runtime, reviewer
AUTHORITY_KIND   ──►  [4 clases]     ──►  reviewer, futuro DEC-02
DECISION_REG     ──►  [ADRs]         ──►  Owner, reviewer, análisis
DECISION_HIST    ──►  [learning]      ──►  Owner, futuro-yo, análisis
```

**Con A2 añadido**:

```text
git-policy.md    ─mirror→ CHANGE_TYPES_CATALOG  ─►  reviewer humano
hooks/, rules/   ─mirror→ CHANGE_TYPES_CATALOG  ─►  (redundante con hooks/)
AUTHORITY_KIND   ─mirror→ CHANGE_TYPES_CATALOG  ─►  (prohibido por §6 ARCH-006)
DECISION_REG     ─mirror→ CHANGE_TYPES_CATALOG  ─►  (redundante con REG)
```

**Cuatro mirror-links** que crean cuatro obligaciones de sincronización. Sin motor de
derivación (que sería DEC-04 D4/E2, hard-to-reverse), es sync manual. **Anti-patrón GAP-1
declarado**.

### 8.6 Abstraction lattice

```text
raw evidence              (git log, hook exits, EV entries)
    │
observations              (reviewer notes, HRQS §12)
    │
classification            [git-policy.md: 8 types] ── ya presente
    │
taxonomy                  [AUTHORITY_KIND.md: 4 classes] ── ya presente (ARCH-006)
    │
registry                  [DECISION_REGISTRY.md: ARCH-*] ── ya presente
    │
canonical decision object [OWNER_CHOICE artifacts] ── ya presente
```

**Pregunta**: ¿en qué nivel de abstracción D-CATALOG agrega valor?

- En "classification": `git-policy.md` ya lo hace.
- En "taxonomy": ARCH-006 ya lo hace para autoridad; se rehúsa hacer piece-mapping.
- En "registry": DECISION_REGISTRY ya lo hace.
- En "canonical decision object": F9_OWNER_DECISIONS + ARCH-006 ya lo hacen.

**Ninguno de los niveles queda sin cubrir. D-CATALOG no llena ningún hueco en el lattice.**

### 8.7 Consolidated multi-representation verdict

Bajo las 6 representaciones (graph, DAG, state machine, control loop, information flow,
abstraction lattice), **D-CATALOG aparece consistentemente como artefacto derivado, no
como entidad de primer orden**. Ninguna representación produce evidencia de que agregue
estructura semántica que no exista ya en otro artefacto.

---

## §9. CONSUMER ANALYSIS

Owner-facing question: ¿quién consumiría realmente D-CATALOG?

### 9.1 Consumidores actuales declarados (MASTER §13.1)

| Consumidor | Uso declarado | Fuente actual sin D-CATALOG | ¿Necesita D-CATALOG? |
|---|---|---|---|
| Reviewer humano | "tabla de referencia para clasificar cambios" | git-policy.md + rules/ + AUTHORITY_KIND.md | **NO** — 3 fuentes ya cubren |
| Owner (P-O) | (implícito) "eliminar K3-D-OWNER-DEFAULT" | AUTHORITY_KIND.md reduce K3-D-OWNER-DEFAULT parcialmente | **NO** — cubierto por ARCH-006 |
| DEC-02 futuro | "categorías precondición del registry" | AUTHORITY_KIND.md (SOFT/ENABLER per ARCH-006 §7) | **CONTESTED** — ver §14 |
| Workflow ad-hoc | "comparativo vs improvisado" | HRQS §12 checklist en handbook | **NO** — HRQS ya provee |

### 9.2 Consumidores potenciales

| Consumidor | Escenario que lo activaría | ¿Activo hoy? |
|---|---|---|
| Nuevo colaborador humano (S2/S3) | onboarding a proyecto con tipos ricos | **NO** — proyecto es S1 (1-2 humanos) |
| Agentes (P-A / P-SA) | agent-guided classification | **NO** — sin hooks que lo consuman (E17) |
| Verificadores (V-* conformance) | validación de tipo de cambio previa a commit | **NO** — no hay V-CATALOG check |
| CI / maintenance.sh | check "todo commit tiene tipo listado" | **NO** — no autorizado por F9-D01 |

### 9.3 Test crítico: "sería útil consumirlo" ≠ "el sistema necesita materializarlo"

Aplicando el Master Prompt §14 sobre distinción obligatoria:

- **"Sería útil"** (hipotético): reviewer podría consultar una tabla en vez de tres. Utility
  MEDIA.
- **"El sistema necesita"** (empírico): no hay caso documentado donde la ausencia haya
  producido un fallo material verificable (E18).

**Veredicto**: no hay evidencia de necesidad; hay hipótesis de conveniencia. Insuficiente
para materializar como entidad de primer orden.

### 9.4 Consumer paradox

Si D-CATALOG se materializa y **nadie lo consume automáticamente** (E17), entonces:

- Reviewer humano puede olvidar consultarlo → sync es asimétrico.
- Owner puede editar upstream (git-policy, hooks) sin propagar → catálogo queda stale.
- Sin `evals/maintenance.sh` check (fuera de scope por ARCH-005 NO-GOALS), no hay drift
  detection.

Este es el **"discoverability paradox"**: se añade un objeto para mejorar discoverability
y termina siendo el objeto peor mantenido del CCP.

---

## §10. SOURCE-OF-TRUTH ANALYSIS

¿Qué tipo de source-of-truth sería D-CATALOG?

### 10.1 Análisis por opción histórica

| Opción | ¿Canonical? | ¿Derived? | ¿Index? | ¿Doc? | ¿Governance? | ¿Hybrid? |
|---|---|---|---|---|---|---|
| A1 (no hacer) | N/A | N/A | N/A | N/A | N/A | N/A |
| A2 (Markdown declarativo) | **pretende ser** | **es** (per §5-§8) | **es** | **es** | intento fallido | mezcla involuntaria |
| A3 (A2 + hook) | pretende ser | contradictorio | contradictorio | secundario | intento incompleto | mezcla |

**A2 es hybrid involuntario**: pretende ser canonical pero **es derived**, quiere ser
governance pero **usurpa** ARCH-006, sirve como doc pero **duplica** fuentes existentes.

### 10.2 Peligros específicos

- **Stale data**: sin motor de derivación (DEC-04 D4/D5 no decidida), cada divergencia con
  4 upstreams es fallo silente. Detectable solo por HRQS trimestral (mismo canal que ya
  supervisa 44+ artefactos).
- **Semantic drift**: nueva clase de autoridad autorizada (reapertura ARCH-006) puede
  quedar sin propagar → D-CATALOG miente sobre autoridad.
- **Dual truth**: reviewer usa D-CATALOG; hook usa `.claude/rules/git-policy.md`. Si
  divergen, ¿cuál manda? Nunca declarado.
- **Synchronization**: cada cambio en cualquier upstream requiere revisit de D-CATALOG.
  4 upstreams × cambios/mes = coste real ≥ 15 min/mes declarado.
- **Migration**: ninguna prevista.
- **Provenance**: opaque (D-CATALOG no declara "esta fila viene de X").
- **Versioning**: sin política declarada.
- **Deletion**: git revert (alta reversibilidad).
- **Recovery**: si upstreams divergen, no hay algoritmo canónico de reconciliación.

### 10.3 Regla ARCH-006 §6 aplicada

ARCH-006 prohíbe explícitamente:

- `piece → authority mapping` (dentro o fuera de AUTHORITY_KIND.md).
- `DELEGATION_REGISTRY` o cualquier registro pieza-autoridad.
- `AUTHORITY_BOUNDARY.md o artefactos con nombre y alcance de AB2`.

**Interpretación estricta**: la columna `auth_holder` de la formulación A2 histórica de
D-CATALOG **es** un mapping (change-type → authority-kind). Aunque el mapping esté por
tipo de cambio y no por pieza, semánticamente crea el mismo tipo de estructura prohibida
por ARCH-006. **Materializar A2 en su forma actual violaría ARCH-006 §6 por analogía y
por trigger T4** (uso implícito de meta-authority: quien decide "qué autoridad aplica a
qué tipo" sin ser una de las cuatro clases).

**Interpretación conservadora**: si Owner considera que ARCH-006 §6 T4 NO se activa por
`change-type → auth_class` mapping, aún así el artefacto duplica el trabajo semántico de
`AUTHORITY_KIND.md` combinado con la clasificación de commits. **La conservadora deja
espacio al Owner para decidir; la estricta cierra puertas**.

---

## §11. REDUNDANCY ANALYSIS

Para cada función atribuida a D-CATALOG, verifico si ya existe en otra pieza.

| Función atribuida a D-CATALOG | ¿Ya existe? | ¿Dónde? | Diferencia | ¿D-CATALOG agrega valor? |
|---|---|---|---|---|
| Enumerar tipos de cambio | **SÍ** | `.claude/rules/git-policy.md` línea 3 | git-policy es rule (autoridad `convención`), no doc consultivo; hoy 8 tipos | **NO** — duplica |
| Mapear tipo → gate mecánica | **SÍ** (parcialmente) | `.claude/hooks/*.sh` + `.claude/rules/*.md` | los hooks *son* los gates; D-CATALOG sería descripción | **NO** — duplica |
| Mapear tipo → auth_holder | **SÍ** (implícitamente por ARCH-006) | `AUTHORITY_KIND.md` §3 | ARCH-006 categoriza autoridad de piezas; el mapping "change-type → authority" es prohibición §6 | **NO** + PROHIBIDO por §6 |
| Registrar precedentes | **SÍ** | `DECISION_REGISTRY.md` + `DECISION_HISTORY.md` + git log | REG contiene decisiones estructuradas; git tiene historia; DECISION_HISTORY tiene lessons | **NO** — duplica |
| Habilitar DEC-02 | **CONTESTED** | AUTHORITY_KIND.md provee taxonomía (per ARCH-006 SOFT/ENABLER) | D-CATALOG no es precondición HARD si DEC-02 usa la taxonomía canónica | **NO** — solapa con ARCH-006 |
| Eliminar K3-D-OWNER-DEFAULT | **SÍ (parcialmente)** | ARCH-006 hace explícita la clase de autoridad | La zona gris residual es "quién ejecuta", no "qué autoridad aplica" | **NO** — cubierto parcial |
| Referencia para reviewer humano | **SÍ** | HRQS §12 handbook + git-policy + AUTHORITY_KIND | HRQS §12 es checklist; combinable con las otras | **NO** — HRQS cubre |
| Precondición para automatización | **NO USE CASE** | (ningún hook lo consume; E17) | — | **NO valor operativo** |

### 11.1 Duplicaciones y anti-patrones

Materializar D-CATALOG A2 crearía:

- **Duplicación de source of truth para tipos de cambio** (D-CATALOG vs git-policy.md).
- **Múltiples representaciones competidoras** para autoridad
  (D-CATALOG.auth_holder vs AUTHORITY_KIND.md classes).
- **Divergencia probable** a mediano plazo por sync manual.
- **Mantenimiento doble** (~15 min/mes declarado × 4 upstreams).
- **Autoridad ambigua** (quién manda ante conflicto: git-policy.md o D-CATALOG?).
- **Inconsistencias futuras** garantizadas.

### 11.2 GAP-1 restatement

El "sync manual entre representaciones" fue identificado en AUDIT §5B GAP-NEW-3 como
fragilidad estructural del CCP. Materializar D-CATALOG **añade un caso más de sync
manual** — precisamente el patrón que DEC-04 intenta resolver.

**Corolario**: D-CATALOG A2 es semánticamente contraria a la dirección arquitectónica
canónica del CCP hacia "derived views con motor idempotente" (DEC-04 D4/D5).

---

## §12. NECESSITY TEST

Aplicando el Master Prompt §10 sin aceptar "sería ordenado" como justificación.

### 12.1 Beneficio → problema → evidencia → coste

Para cada beneficio declarado en MASTER §13.1:

**Beneficio 1: "Elimina zona gris K3-D-OWNER-DEFAULT"**

- Problema actual: sí, K3-D-OWNER-DEFAULT es zona gris documentada.
- Evidencia del problema: MASTER §6.3, K3 corpus.
- Coste actual: Owner absorbe defaults implícitos. Real pero no cuantificado.
- Mecanismo mediante el cual D-CATALOG lo resuelve: hace explícito el mapping
  `change-type → auth_holder`.
- Beneficio esperado: parcial. MASTER §31.1 aclara "parcialmente".
- Coste introducido: sync manual con AUTHORITY_KIND (semántica prohibida por ARCH-006).
- **Balance**: NEGATIVO. ARCH-006 ya reduce K3-D-OWNER-DEFAULT en la dimensión autoridad.
  D-CATALOG añadiría beneficio marginal con coste alto.

**Beneficio 2: "Habilita DEC-02"**

- Problema actual: DEC-02 formulable sin categorías canónicas.
- Evidencia del problema: MASTER §13.2 escenarios "B2 sin DEC-01 → registry sin categorías
  degrada rápido".
- Coste actual: DEC-02 (delegación) no puede diseñarse en abstracto.
- Mecanismo mediante el cual D-CATALOG lo resuelve: provee las "keys" del registry.
- Beneficio esperado: alto SI las keys son `change_type`.
- Coste introducido: precondición estructural fija sobre DEC-02.
- **Balance**: **CONTESTED**. Ver §14. Las keys que DEC-02 realmente necesita son
  `action_type`, no `change_type`. La HARD es inherit-error.

**Beneficio 3: "Reviewer humano tiene tabla de referencia"**

- Problema actual: reviewer improvisa clasificación.
- Evidencia del problema: MASTER §13.1 declaración.
- Coste actual: variabilidad de clasificación entre revisiones.
- Mecanismo: doc consultivo.
- Beneficio esperado: reducción de variabilidad.
- Coste introducido: nuevo artefacto a mantener; drift si upstreams cambian.
- **Balance**: NEUTRO. HRQS §12 + git-policy + AUTHORITY_KIND cubren.

### 12.2 Otros beneficios candidatos

| Beneficio candidato | Aplica a D-CATALOG? | Sostén empírico |
|---|---|---|
| Discoverability | Parcial (join view) | Ninguno documentado |
| Consistency | Contradictorio (añade sync) | Ninguno |
| Verification | No (E17) | Ninguno |
| Automation | No | Ninguno |
| Explainability | Parcial | Ninguno |
| Traceability | No (redundante con DECISION_REG) | Ninguno |
| Governance | Parcial (§10 análisis) | Ninguno |
| Recovery | No | Ninguno |
| Evolution | Parcial | Ninguno |
| Reuse | Parcial | Ninguno |

**Ningún beneficio candidato tiene sostén empírico**. Todos son hipotéticos.

### 12.3 Necessity verdict

**H0 (D-CATALOG es necesario)** carece de sostén empírico. Materializarlo sería adoptar
una hipótesis como arquitectura sin evidencia. **Fails necessity test**.

---

## §13. EMPIRICAL 30-COMMIT EXPERIMENT

Aplicando Master Prompt §12 — clasificación empírica de los últimos 30 commits.

### 13.1 Bulk classification (git log --oneline -30)

Corpus (ver §2 baseline snapshot). Cuenta por prefijo tag:

```text
Prefijo    Count   %
──────    ──────  ──
[CONFIG]   11      37%   (checkpoints, PROJECT_STATE updates, docs closures)
[RESEARCH] 19      63%   (movements, root analysis, gate research)
[F7]        0       0%   (phase pre-checkpoint tags — no aparecen en últimos 30)
[F8]        0       0%   (idem)
[F9]        0       0%   (idem; documentados en historial anterior)
```

Nota: expansión a los últimos 50 commits produce distribución similar: `[RESEARCH] 19`,
`[F7] 17`, `[CONFIG] 11`, `[F8] 9`, `[F9] 1`.

### 13.2 Semantic classification por commit

Aplicando análisis manual a los 30 commits, clasificando qué cambió realmente:

| # | hash | change_type declarado | change_type real | auth_holder efectivo | contract activado |
|---|---|---|---|---|---|
| 1 | 473759c | [CONFIG] | governance-taxonomy materialization | humana (Owner) | ARCH-006 |
| 2 | cd0511c | [CONFIG] | governance-policy retrofit | humana (Owner) | ARCH-005 |
| 3 | 4277830 | [CONFIG] | governance-decision closure | humana (Owner) | ARCH-005 IMPL_PENDING |
| 4 | f496897 | [CONFIG] | documentation checkpoint | humana + agente | analytical artifacts |
| 5 | 1a6232d | [RESEARCH] | root-analysis F1-F12 | agente | research doc |
| 6 | 9ea8367 | [CONFIG] | PROJECT_STATE update | humana + agente | bookkeeping |
| 7 | f6a874f | [RESEARCH] | HRQS + PAC corpus | agente | research doc |
| 8 | c41c8c9 | [RESEARCH] | phase-A handoff reconstruction | agente | research doc |
| 9 | e066757 | [CONFIG] | PROJECT_STATE update | humana + agente | bookkeeping |
| 10 | df489d0 | [RESEARCH] | frontier breakout | agente | research doc |
| 11 | 62b5d4c | [RESEARCH] | pre-authorization gate | agente | research doc |
| 12 | 0c098bc | [CONFIG] | PROJECT_STATE update | humana + agente | bookkeeping |
| 13 | f4730e4 | [RESEARCH] | NH-10 impl + owner package | agente | research doc |
| 14 | b908ff9 | [RESEARCH] | frontier integration | agente | research doc |
| 15 | 3350742 | [RESEARCH] | master frontier closure | agente | research doc |
| 16 | bf68de6 | [RESEARCH] | policy repair test | agente | research doc |
| 17 | 22c4b14 | [RESEARCH] | frontier resolution | agente | research doc |
| 18 | e48f9a1 | [CONFIG] | PROJECT_STATE checkpoint | humana + agente | bookkeeping |
| 19 | d8cff63 | [RESEARCH] | R-3 empirical + CCP engine | agente | research doc |
| 20 | 4ede92f | [RESEARCH] | research consolidation | agente | research doc |
| 21 | ccc0760 | [CONFIG] | PROJECT_STATE bookkeeping | humana + agente | bookkeeping |
| 22 | 3336bd6 | [RESEARCH] | SAGR deep research | agente | research doc |
| 23 | 74f7d1e | [RESEARCH] | field validation prep | agente | research doc |
| 24 | 035a573 | [RESEARCH] | terminal business gate | agente | research doc |
| 25 | 01fe762 | [RESEARCH] | thesis reconstruction | agente | research doc |
| 26 | 5980863 | [RESEARCH] | buyer/competitive gate | agente | research doc |
| 27 | 07cc702 | [RESEARCH] | market thesis loop | agente | research doc |
| 28 | 0433d2c | [RESEARCH] | market evidence hardening | agente | research doc |
| 29 | 10a60d9 | [CONFIG] | F9 owner decision gate closure | humana | F9-D01..D05 |
| 30 | 05c78ac | [CONFIG] | post-F9 doc reconciliation | agente | doc |

### 13.3 Distribución empírica

```text
change_type real          Count   %
──────────────────         ────    ──
research doc               17      57%
bookkeeping                 5      17%
governance decision/impl    4      13%
documentation checkpoint    1       3%
F9 gate closure             2       7%
policy/repair               1       3%
```

**Dos categorías dominan** (research doc + bookkeeping) con 22/30 = 73%.

### 13.4 auth_holder distribución

```text
auth_holder                Count   %
──────────                 ────    ──
agente                     18      60%
humana + agente             8      27%
humana                      4      13%
```

**Distribución consistente con topología estrella (K3)**: agente produce, humana autoriza.

### 13.5 Preguntas del experimento

**Pregunta 1**: ¿los 30 commits muestran una taxonomía estable o mezcla de dimensiones?

**Respuesta**: taxonomía estable de **2 dimensiones dominantes** (research vs
config/governance), con auth-flow consistente (agente produce, humana autoriza). No hay
presión empírica para una taxonomía más rica que la ya presente en `git-policy.md`.

**Pregunta 2**: ¿existe algún commit donde la ausencia de D-CATALOG causó fricción?

**Respuesta**: **NO** documentado. Todos los commits siguen convención `[TAG]: descripción`
sin conflicto de clasificación registrado.

**Pregunta 3**: ¿D-CATALOG habría aportado información?

**Respuesta**: NO en los últimos 30 commits. La información ya está distribuida en `TAG`
prefijo + descripción libre + provenance git + REGISTRY entries cuando aplica.

**Pregunta 4**: ¿el vocabulario actual (8 tipos git-policy) captura los tipos observados?

**Respuesta**: **SÍ**, con clasificación ampliamente cubierta por `config` +
`decision` + `security` + `arch`. La distinción `[RESEARCH]` no está en git-policy pero
aparece como convención "control plane" que git-policy explícitamente reconoce (línea 4:
"Control plane usa `[CONFIG]`") — nota que este uso de `[RESEARCH]` **contradice**
git-policy.md en la práctica, un pequeño gap ya existente que D-CATALOG **no
resolvería** (crearía el mismo gap doble).

### 13.6 Evidence integrity

- Grep en `.claude/hooks/`, `.claude/agents/` para uso de "catalog": **no matches**.
- Grep en `docs/` para `CHANGE_TYPES_CATALOG`: **matches solo en docs de propuesta**
  (MASTER, DECISION_SPACE_PREPARED, AUDIT).
- Ningún incidente en `INCIDENT_REGISTRY.md` atribuible a ausencia de D-CATALOG.

### 13.7 Verdict del experimento

- Corpus **homogéneo** → no requiere taxonomía rica.
- git-policy.md **cubre suficientemente** los tipos observados.
- **Contradice** la premisa de "5 tipos observados + placeholder" de MASTER §58.1
  (empíricamente son ≤2 dominantes).
- **Refuerza** la conclusión §5-§12: D-CATALOG no tiene justificación empírica.

**Confidence del experimento**: MEDIA-ALTA (n=30 es pequeño pero representativo del régimen
de la fase 8 CCP).

---

## §14. DEC-02 DEPENDENCY REVALIDATION

Tarea explícita del Master Prompt §26: revalidar `DEC-01 → DEC-02 = HARD`.

### 14.1 Evidencia histórica de HARD

- MASTER §8.1: `DEC-01 D-CATALOG ──feeds──▶ DEC-02 D-DELEG (categories to delegate)`.
- MASTER §8.2: "DEC-01 → DEC-03: sin catálogo de cambios, LIFECYCLE registry no sabe qué
  gobernar".
- MASTER §13.2: "WRONG (B2 sin DEC-01): registry sin categorías es puro texto libre;
  degrada rápido".
- DECISION_SPACE_PREPARED §3.1: `DEC-01 → DEC-02 [HARD] categorías precondición de
  registry`.

### 14.2 Semantic attack

**Formulación de DEC-02 (MASTER §13.2)**:

> Registry Markdown con `action_type, delegated_to, fallback, activated_by, revocable`.

El **key column** es `action_type`, no `change_type`.

- `action_type`: qué acción es delegable (e.g., "code review", "authorization",
  "verification", "artifact production").
- `change_type`: qué tipo de commit produce el cambio (e.g., "feat", "fix", "docs").

**Éstas son dimensiones distintas**. Una delegación puede aplicar a "code review" que a su
vez puede ser tanto `feat` como `fix` como `docs`. Un `change_type` puede activar varias
delegaciones o ninguna.

### 14.3 Analytical test

**Escenario S1**: DEC-02 realmente necesita DEC-01

Análisis: para que sea cierto, DEC-02 tendría que enumerar **por change_type qué acciones
son delegables**. Esta formulación NO es la que aparece en MASTER §13.2 ni en
DECISION_SPACE_PREPARED §4.2. Es una **posible** formulación de DEC-02, pero no la
canónica.

**Escenario S2**: DEC-02 puede formularse sin DEC-01

Análisis: DEC-02 tiene columnas `action_type`, `delegated_to`, `fallback`, `activated_by`,
`revocable`. Las tres últimas son metadatos sin dependencia de D-CATALOG:

- `delegated_to`: pieza / subagente / actor concreto (AUTHORITY_KIND provee las clases).
- `fallback`: default humano (K3-D-OWNER-DEFAULT vigente hasta que otro deleg lo cubra).
- `activated_by`: evento observable (política Owner, per DEFERRAL_POLICY).
- `revocable`: booleano.

Y `action_type` puede ser enumerado por AUTHORITY_KIND (`{ mecánica, convención, humana,
agente }` es la partición de acciones autorizables). **DEC-02 se puede formular con
ARCH-006 como precondición SOFT/ENABLER (per ARCH-006 §7)**, exactamente como la
prescripción canónica actual.

**Escenario S3**: DEC-02 solamente se beneficia de DEC-01

Análisis: si D-CATALOG existiera, podría iluminar patrones "cambios `[FEAT]` casi siempre
delegados a `implementer`". Es un **beneficio marginal a-posteriori**, no una
precondición.

**Escenario dominante**: **S2**. La formulación canónica actual de DEC-02 opera sobre
`action_type` (o equivalente semántico en AUTHORITY_KIND). D-CATALOG contribuye a un
**refinamiento a-posteriori**, no a una precondición.

### 14.4 Revised classification

**DEC-01 → DEC-02**: **SOFT / OPTIONAL_BENEFIT**, no HARD.

- HARD sería el caso si DEC-02 se reformulara con `change_type` como key primaria del
  registry. Esa reformulación no es canónica hoy.
- SOFT es el caso actual: D-CATALOG ilumina, no habilita, DEC-02.

**Confidence de la revalidación**: MEDIA-ALTA. Podría ser refutada por Owner Decision
sobre DEC-02 que elija `change_type` como key. Ver §15 (falsifiers).

### 14.5 Consecuencias de la revalidación

- La justificación "DEC-01 es precondición HARD de DEC-02" **no es sostenible** después de
  ARCH-006.
- El argumento "sin DEC-01, DEC-02 sin keys" es hereditary error del framing pre-ARCH-006.
- **DEC-02 puede diseñarse hoy** consultando AUTHORITY_KIND.md como taxonomía canónica.

**Corolario**: la urgencia de DEC-01 declarada en documentos previos ("precondición de
DEC-02, precondición del Bloque A completo") **desaparece** post-ARCH-006. DEC-01 puede
diferirse indefinidamente sin bloquear DEC-02.

---

## §15. DOWNSTREAM IMPACT

Impacto de cada alternativa sobre las otras decisiones activas.

### 15.1 Sobre decisiones activas

| Decisión | STATUS_QUO (A1) | REFORMULATE / SPLIT | A2 (Markdown canonical) | A3 (A2 + hook) |
|---|---|---|---|---|
| ARCH-001 (scope proyecto) | no afecta | no afecta | no afecta | no afecta |
| ARCH-002 (context packs) | no afecta | no afecta | no afecta | no afecta |
| ARCH-003 (evidence path) | no afecta | no afecta | no afecta | no afecta |
| ARCH-004 (task tracking) | no afecta | no afecta | no afecta | posible fricción if task_type overlap |
| ARCH-005 (deferral policy) | no afecta | no afecta | no afecta | crearía nuevo deferral scope |
| ARCH-006 (AUTHORITY_KIND) | no afecta | invocable como referencia | **RISK §6 T4** (auth mapping implícito) | **RISK §6 T4** |

### 15.2 Sobre decisiones abiertas (per DECISION_SPACE_PREPARED)

| Decisión | STATUS_QUO | REFORMULATE / SPLIT | A2 | A3 |
|---|---|---|---|---|
| DEC-02 D-DELEG | formulable | facilitable | falsely-HARD-precondition | idem A2 + hook cost |
| DEC-03 D-LIFECYCLE | ortogonal | ortogonal | soft link (lifecycle categories) | idem A2 |
| DEC-04 D-CANONICAL | ortogonal | ortogonal | ortogonal | ortogonal |
| DEC-05 D-MOTOR | ortogonal | ortogonal | ortogonal | ortogonal |
| DEC-07 D-VERIFICADOR | ortogonal | ortogonal | ortogonal | ortogonal |
| DEC-08 D-INSTR | ortogonal | ortogonal | ortogonal | cruza F9-D01 dobly |
| DEC-11 D-DEFERRAL-POLICY (already ARCH-005) | ya cerrada | ya cerrada | ya cerrada | ya cerrada |
| DEC-12 D-META-DOC | ortogonal | complementaria | complementaria | complementaria |
| DEC-STREAM-CONSUMER | ortogonal | ortogonal | ortogonal | ortogonal |
| DEC-REVIEWER-VERDICT | ortogonal | ortogonal | ortogonal | ortogonal |

### 15.3 Nueva información aportada por cada alternativa

| Decisión / Info | STATUS_QUO | REFORMULATE / SPLIT | A2 | A3 |
|---|---|---|---|---|
| Descubrimiento de necesidad D-CATALOG | no aprende | libera espacio de decisión y proporciona experimentos | no aprende (asume necesidad) | no aprende |
| Empírica de tipos de cambio | git log queda como fuente | idem + observaciones estructuradas | catálogo puede ser stale | idem A2 |
| Precondición para DEC-02 | claro que no lo es | claro que no lo es | falso positive (SUFI) | idem A2 |
| Preservación de invariantes ARCH-006 | preserva | preserva | riesgo trigger T4 | idem A2 |
| Preservación de F9-D01 | preserva | preserva | preserva | **viola** |

### 15.4 Verdict downstream

- **STATUS_QUO** y **REFORMULATE/SPLIT** son ortogonales al resto del sistema.
- **A2** introduce ruido semántico frente a ARCH-006 (riesgo T4 potencial).
- **A3** además viola F9-D01=A y compromete el precedente de ARCH-005.

---

## §16. ALTERNATIVE ARCHITECTURE SET

Generado siguiendo Master Prompt §18-§19. Cada alternativa es semanticamente distinta.

### 16.1 Alternativa A — STATUS QUO

- **Identidad**: no materializar D-CATALOG.
- **Justificación**: §5-§14. La ausencia de D-CATALOG no ha producido incidente
  material verificable. Las fuentes existentes cubren las funciones declaradas.
- **Coste**: cero. No hay coste opportunity si no hay use-case activo.
- **Ganancia**: preserva composabilidad del CCP (no añade nuevo sync).
- **Lock-in**: BAJO.
- **Reversibilidad**: N/A.
- **Riesgo**: si eventualmente aparece use-case verificable, hay que crear D-CATALOG bajo
  otro nombre (esperable en horizonte).

### 16.2 Alternativa B — TAXONOMY-ONLY (siguiendo precedente ARCH-006)

- **Identidad**: formalizar sólo una **clasificación mínima** siguiendo el patrón AB5 de
  ARCH-006 (taxonomy + change rules only, sin registry pieza-por-pieza, sin mapping
  explícito a autoridad).
- **Justificación**: git-policy.md ya lista tipos; podríamos elevar esa lista a taxonomía
  canónica cerrada con reglas de evolución (mismo patrón que AUTHORITY_KIND).
- **Alcance**: `docs/00_SYSTEM/CHANGE_TYPE_TAXONOMY.md` con:
  - vocabulario cerrado (los 8 tipos actuales + `research` como novena clase ATTESTED per
    empírica §13).
  - reglas de cambio (VOCAB-A-analog: reapertura formal para nueva clase).
  - relación explícita con git-policy.md (uno es taxonomía; otro es rule que la aplica).
- **NO-alcance**: mapping change-type → gate; mapping change-type → auth_holder; registro
  de precedentes; enforcement runtime.
- **Coste**: BAJO (~1-2h construcción; sin mantenimiento significativo).
- **Ganancia**: reglas de evolución explícitas del vocabulario; consistencia con ARCH-006
  precedent.
- **Lock-in**: BAJO (docs-only; mismo perfil que AUTHORITY_KIND).
- **Reversibilidad**: ALTA.
- **Riesgo**: crear artefacto que duplique git-policy si no se declara relación
  taxonomía↔rule claramente.
- **Diferencia con A2 original**: A2 mezcla 4 columnas; B mantiene sólo `type` como
  taxonomía + reglas.

### 16.3 Alternativa C — DERIVED VIEW

- **Identidad**: crear un **view derivado** (no fuente-de-verdad) que agregue información
  de las 4 fuentes existentes en un solo doc consultivo.
- **Justificación**: si Owner considera valuable el join view, exponerlo como derivación
  explícita (posiblemente generada por script en el futuro) preserva source-of-truth único
  para cada dimensión.
- **Alcance**: `docs/00_SYSTEM/CHANGE_TYPES_VIEW.md` con:
  - encabezado que declara "DERIVED VIEW; source of truth vive en git-policy.md,
    AUTHORITY_KIND.md, hooks/, DECISION_REGISTRY".
  - contenido join generado manualmente o vía script (motor viene con DEC-04, no en scope
    hoy).
  - explícito marker `derived_from:` (aprovechando DEC-03 C2 style, si se implementa).
- **Coste**: BAJO-MEDIO (~2-4h construcción; sync manual o motor con DEC-04).
- **Ganancia**: discoverability sin lock-in canónico.
- **Lock-in**: BAJO en A1 sentido (docs); MEDIO si se compromete con DEC-04 D4 futuro.
- **Reversibilidad**: ALTA.
- **Riesgo**: sync manual (GAP-1 anti-patrón). Sólo aceptable si Owner considera el
  beneficio discoverability suficiente para justificar coste sync.
- **Diferencia con A2 original**: reconoce explícitamente que es artefacto derivado, no
  canónico.

### 16.4 Alternativa D — CANONICAL REGISTRY (formulación A2 original)

- **Identidad**: materializar `CHANGE_TYPES_CATALOG.md` como pieza canónica de primer
  orden con las 4 columnas `type × gate × auth_holder × precedent`.
- **Justificación (original)**: MASTER §13.1.
- **Ataques que sufre** (§5-§14, §17-§18): homogeneidad falla, ARCH-006 §6 conflicto,
  redundancia con 4 fuentes existentes, DEC-02 HARD contestada.
- **Coste**: MEDIO (construcción ~1-2h + sync manual perpetuo + riesgo violación §6 T4).
- **Ganancia**: parcial en discoverability; falsa en precondición DEC-02.
- **Lock-in**: MEDIO (una vez materializado, reviewer workflow depende).
- **Reversibilidad**: MEDIA (docs revertibles, workflow requiere retraining).
- **Riesgo**: **contradice precedente ARCH-006 semánticamente**. No recomendable después
  del ataque adversarial.
- **Recommendation confidence**: <60% para adopción.

### 16.5 Alternativa E — SPLIT + DEFER

- **Identidad**: separar D-CATALOG en las sub-decisiones que la componen y decidir cada
  una por separado. Diferir aquellas sin justificación empírica.
- **Alcance**:
  - **Sub-decisión E1** — `type-taxonomy`: cubierta por Alternativa B si Owner considera
    útil; diferible si no.
  - **Sub-decisión E2** — `gate-mapping`: **retirar** (ya cubierta por hooks/rules;
    documentar la ausencia en el registry decisional como "resolved: no materialization
    needed").
  - **Sub-decisión E3** — `auth_holder-mapping`: **retirar** (ARCH-006 §6 prohíbe;
    documentar como "resolved by ARCH-006").
  - **Sub-decisión E4** — `precedent-index`: **retirar** (cubierta por
    DECISION_REGISTRY + DECISION_HISTORY; documentar).
- **Coste**: BAJO (documentación de retiros; posible taxonomía si E1 se materializa).
- **Ganancia**: **limpieza semántica del decision space**; cierra ambigüedad; alinea con
  ARCH-006 precedent.
- **Lock-in**: BAJO.
- **Reversibilidad**: ALTA.
- **Riesgo**: si Owner considera "eliminar DEC-01 de la lista" prematuro, puede
  reformularse como DEFER en lugar de RETIRE.

### 16.6 Alternativa F — DEFER

- **Identidad**: no cerrar DEC-01 hoy; declarar triggers observables para reactivación.
- **Alcance**: DEC-01 permanece en decision space; se registra en
  `PROJECT_STATE.DEFERRED` con `trigger:` YAML per ARCH-005 formato.
- **Triggers propuestos** (ver §23): ver §23 con detalle.
- **Coste**: CERO.
- **Ganancia**: no fija arquitectura; adquiere información sobre uso real antes de
  decidir.
- **Lock-in**: BAJO.
- **Reversibilidad**: N/A.
- **Riesgo**: gobernanza incremental; sin trigger real, DEC-01 se convierte en decisión
  perpetua.

### 16.7 Alternativa G — RETIRE (opción implícita en el Master Prompt §33)

- **Identidad**: eliminar DEC-01 de la lista de decisiones activas del CCP; declarar que
  la formulación original **no representa una frontera semántica del CCP** y que sus
  sub-objetos ya tienen source-of-truth canónico.
- **Alcance**: registrar RETIRED en DECISION_HISTORY con lección aprendida (framing
  heredado sin ataque).
- **Coste**: CERO (documental).
- **Ganancia**: cierra la ambigüedad; limpia el decision graph.
- **Lock-in**: BAJO (revocable en futuro si evidencia aparece).
- **Reversibilidad**: ALTA.
- **Riesgo**: si Owner considera prematuro retirar, DEFER (F) es alternativa próxima.

### 16.8 Alternativas descartadas explícitamente

- **"A2 con revision_period trimestral"** (DECISION_SPACE_PREPARED §4.1
  "alternativas híbridas"): no resuelve el problema semántico; añade proceso.
- **"A3 hook en warn mode"** (DECISION_SPACE_PREPARED §4.1): sigue introduciendo hook
  runtime; sigue cruzando F9-D01 aunque en modo warn; no elimina el conflicto con ARCH-006.
- **"A2 embedded en piece catalog del AUDIT"** (DECISION_SPACE_PREPARED §4.11 estilo):
  irrelevante — piece catalog del AUDIT no es artefacto canónico ejecutable.

---

## §17. BEFORE → AFTER (para cada alternativa relevante)

### 17.1 Alternativa A — STATUS QUO

- **BEFORE**: reviewer improvisa clasificación de commit; consulta git-policy.md al
  redactar mensaje; consulta AUTHORITY_KIND.md cuando hay ambigüedad de autoridad;
  precedente vive en git log + DECISION_REGISTRY.
- **AFTER**: idéntico. Ninguna estructura nueva. Ninguna estructura eliminada.
- **GAIN**: preservación de coherencia con ARCH-006; sin riesgo trigger T4.
- **REGRESSION**: reviewer sigue consultando 3+ fuentes (mismo baseline).
- **UNCHANGED**: todo.

### 17.2 Alternativa B — TAXONOMY-ONLY

- **BEFORE**: git-policy.md enumera 8 tipos como rule text; sin reglas de evolución
  explícitas.
- **AFTER**: `docs/00_SYSTEM/CHANGE_TYPE_TAXONOMY.md` como taxonomía canónica cerrada con
  reglas de evolución; git-policy.md apunta a la taxonomía como source. Empíricamente
  se añade `research` como novena clase ATTESTED.
- **GAIN**: reglas de evolución del vocabulario explícitas; coherencia con ARCH-006
  patrón AB5.
- **REGRESSION**: nueva fuente-de-verdad para tipos; sync con git-policy.md convierte
  ésta en derivación o requiere merge.
- **UNCHANGED**: hooks, auth_holder mapping, precedent, DEC-02 formulación.

### 17.3 Alternativa C — DERIVED VIEW

- **BEFORE**: cuatro fuentes de verdad independientes.
- **AFTER**: cuatro fuentes + `CHANGE_TYPES_VIEW.md` derivado con encabezado `DERIVED
  FROM:`.
- **GAIN**: discoverability mejorada; explícita naturaleza derivada.
- **REGRESSION**: sync manual (o motor futuro con DEC-04); riesgo drift si no hay motor.
- **UNCHANGED**: sources of truth.

### 17.4 Alternativa D — CANONICAL REGISTRY (A2)

- **BEFORE**: cuatro fuentes de verdad independientes.
- **AFTER**: cinco fuentes de verdad **compitiendo**; ninguna resolución de conflicto
  declarada.
- **GAIN**: reviewer tiene tabla única (percibida).
- **REGRESSION**:
  - sync manual con 4 upstreams;
  - conflicto latente con ARCH-006 §6 (mapping change-type → authority);
  - añade el mismo GAP-1 anti-patrón.
- **UNCHANGED**: hooks, git-policy formal (aunque semanticamente su rol cambia).

### 17.5 Alternativa E — SPLIT + DEFER

- **BEFORE**: DEC-01 monolítico en decision space; ambigüedad de framing.
- **AFTER**: DEC-01 particionada en E1..E4 con veredictos claros
  (defer / retire / retire / retire).
- **GAIN**: limpieza semántica; coherencia con ARCH-006 y ARCH-005 precedents.
- **REGRESSION**: ninguna material.
- **UNCHANGED**: fuentes de verdad; workflow reviewer.

### 17.6 Alternativa F — DEFER

- **BEFORE**: DEC-01 en decision space pending.
- **AFTER**: DEC-01 en `PROJECT_STATE.DEFERRED` con triggers YAML per ARCH-005.
- **GAIN**: no fija arquitectura; adquiere información antes de decidir.
- **REGRESSION**: DEC-01 continúa ocupando slot en decision graph.
- **UNCHANGED**: fuentes de verdad; workflow.

### 17.7 Alternativa G — RETIRE

- **BEFORE**: DEC-01 en decision space como Owner-pending.
- **AFTER**: DEC-01 marcada RETIRED en DECISION_HISTORY con lección; salida del decision
  graph.
- **GAIN**: máxima limpieza; ejemplo de "framing heredado sin ataque debe ser retirado".
- **REGRESSION**: si Owner luego decide que era necesaria, hay que reabrir.
- **UNCHANGED**: fuentes de verdad; workflow.

---

## §18. REGRESSION MATRIX

Para cada alternativa, análisis de WIN / SAME / LOSS.

| Dimensión | A (STATUS) | B (TAXONOMY) | C (DERIVED) | D (CANONICAL) | E (SPLIT) | F (DEFER) | G (RETIRE) |
|---|---|---|---|---|---|---|---|
| Duplicación source of truth | SAME | LOSS (mild) | LOSS (marked derived) | **LOSS** | WIN | SAME | WIN |
| Maintenance overhead | SAME | LOSS (mild) | LOSS (marked) | **LOSS** | WIN | SAME | WIN |
| Semantic freeze / lock-in | SAME | LOSS (mild, revocable) | SAME | **LOSS** | SAME | SAME | WIN |
| Discoverability paradox | SAME | SAME | SAME | **LOSS** | SAME | SAME | SAME |
| Stale registry risk | SAME | SAME | **LOSS** | **LOSS** | SAME | SAME | WIN |
| Authority conflict (§6 ARCH-006) | SAME | SAME | POSSIBLE-LOSS | **LOSS** | WIN | SAME | WIN |
| Migration cost | SAME | LOW | LOW-MED | HIGH | LOW | SAME | LOW |
| Governance decay | SAME | WIN (mild) | POSSIBLE-WIN | LOSS (mixed) | WIN | SAME | WIN |
| Reviewer workflow clarity | SAME | WIN (mild) | POSSIBLE-WIN | POSSIBLE-WIN | SAME | SAME | SAME |
| Preservation of ARCH-006 precedent | SAME | **WIN** | SAME | **LOSS** | **WIN** | SAME | **WIN** |

**Regressions dominantes en cada alternativa**:

- A: cero regresiones (baseline).
- B: introduce nueva source-of-truth; mitigable si convención `derived_from:` está clara.
- C: sync burden; mitigable con motor DEC-04 (fuera de scope).
- D: **múltiples regresiones estructurales**; recomendación explícita en contra.
- E: limpia el decision space; ninguna regresión material.
- F: mantiene ambigüedad temporal; requiere trigger real.
- G: máxima limpieza; requiere confianza Owner en el ataque adversarial.

---

## §19. LOCK-IN ANALYSIS

Aplicando Master Prompt §17.

| Dimensión | A (STATUS) | B (TAXONOMY) | C (DERIVED) | D (CANONICAL) | E (SPLIT) | F (DEFER) | G (RETIRE) |
|---|---|---|---|---|---|---|---|
| Reversibilidad | perfecto | ALTA | ALTA | MEDIA | ALTA | perfecto | ALTA |
| Coste de salida | nulo | git revert | git revert + retirar view | retraining reviewer | documentación | nulo | reabrir DEC-01 |
| Dependencias creadas | ninguna | git-policy → taxonomy | 4 sync obligations | 4 sync obligations + workflow | ninguna | ninguna | ninguna |
| Contratos fijados | ninguno | vocab CLOSED (VOCAB-A style) | derived-from convention | tabla y schema | none | none | none |
| Semantic lock-in | ninguno | vocabulario | none real | tabla × 4 dims | none | none | none |
| Organizational lock-in | ninguno | mínimo | reviewer workflow | reviewer workflow + Owner review | ninguno | ninguno | ninguno |
| Tool lock-in | ninguno | mínimo | mínimo | Markdown table | ninguno | ninguno | ninguno |
| Data lock-in | ninguno | ninguno | derived data replicated | duplicated data | ninguno | ninguno | ninguno |
| Governance lock-in | ninguno | reapertura formal para nueva clase | ninguno | tabla fija en decision graph | ninguno | ninguno | ninguno |

**"Small abstraction now, large migration later"**:

- **D (CANONICAL)** produce el peor caso: la tabla `type × gate × auth × precedent` se
  convierte en artefacto que gates y reviews eventualmente dependen, y migrar a otra
  arquitectura (por ejemplo, motor de derivación DEC-04) requiere retirar la tabla y
  reeducar reviewer.
- **B (TAXONOMY)** produce el mejor "small abstraction" con perfil de lock-in idéntico a
  ARCH-006: bajo.

---

## §20. REVERSIBLE EXPERIMENTS

Aplicando Master Prompt §23. Experimentos que **compran información** sin fijar
arquitectura.

### 20.1 EXP-D01-01 — HRQS uso empírico

- **Descripción**: monitorear durante 30-60 días **cuántas veces** un reviewer humano
  necesita consultar simultáneamente git-policy.md + AUTHORITY_KIND.md + DECISION_REGISTRY
  para clasificar un cambio.
- **Método**: registrar en STALL_POLICY_LOG.jsonl con nueva categoría
  `policy_category=change_classification` cuando el reviewer tenga que consultar >1 fuente.
- **Coste**: BAJO (~30 min instrumentación; sin cambio en runtime).
- **Duración**: 30-60 días.
- **Cruza F9-D01**: NO (append-only al log existente; el flag de nueva categoría se puede
  agregar como convención en HRQS §12 sin nuevo hook).
- **Valor**: **ALTO**. Determina si el "reviewer improvisa" es problema real o hipotético.
- **Falsifiers**: si aparecen ≥10 casos en 30 días → indicar utilidad de join view; si ≤2
  → confirmar hipótesis actual (D-CATALOG no necesario).

### 20.2 EXP-D01-02 — Corpus de tipos ampliado

- **Descripción**: analizar los últimos **100** commits (no sólo 30) y clasificar tipos
  reales.
- **Método**: `git log --all --oneline -100` + análisis manual del cambio semántico.
- **Coste**: MUY BAJO (1-2h).
- **Duración**: 1-2 días.
- **Cruza F9-D01**: NO.
- **Valor**: MEDIO. Aumenta n del experimento §13. Puede confirmar/refutar la
  homogeneidad observada.

### 20.3 EXP-D01-03 — Piloto de taxonomía (Alternativa B)

- **Descripción**: si Owner tiene interés en Alternativa B, redactar borrador de
  `CHANGE_TYPE_TAXONOMY.md` (siguiendo patrón AUTHORITY_KIND) y mantenerlo como Stratum-C
  artefacto analítico durante 30-60 días para observar utilidad.
- **Método**: crear archivo con status="draft"; observar si algún workflow lo utiliza.
- **Coste**: BAJO (~2h).
- **Duración**: 30-60 días.
- **Cruza F9-D01**: NO.
- **Valor**: MEDIO. Informa decisión Owner sobre B sin comprometer arquitectura.

### 20.4 EXP-D01-04 — DEC-02 formulación con AUTHORITY_KIND como taxonomía única

- **Descripción**: redactar borrador de DEC-02 usando AUTHORITY_KIND.md como fuente
  taxonómica única y verificar si emerge alguna necesidad no cubierta.
- **Método**: draft `DEC-02_DELEG_TAXONOMY_TEST.md` como Stratum-C.
- **Coste**: BAJO-MEDIO (~2-4h).
- **Duración**: 1 semana.
- **Cruza F9-D01**: NO.
- **Valor**: **ALTO**. Prueba directa de si DEC-02 realmente necesita D-CATALOG. Si
  formulable sin D-CATALOG → §14 revalidación confirmada.

### 20.5 Priorización

Ratio información/coste:

- **EXP-D01-04**: ALTO valor + BAJO coste + resuelve pregunta central §14.
- **EXP-D01-01**: ALTO valor + BAJO coste + resuelve pregunta central §9-§12.
- **EXP-D01-02**: MEDIO valor + MUY BAJO coste + gain marginal.
- **EXP-D01-03**: MEDIO valor + MEDIO coste + útil solo si Owner considera B.

**Recomendación operativa**: correr **EXP-D01-01 + EXP-D01-04 en paralelo** (2-4 semanas)
antes de cerrar DEC-01. Ambos no cruzan F9-D01 y compran información determinante.

---

## §21. INFORMATION GAPS

Preguntas que quedan sin responder tras esta investigación.

- **INFO-GAP-D01-1**: ¿el reviewer humano actual consulta simultáneamente ≥2 fuentes al
  clasificar cambios? **UNKNOWN — resoluble con EXP-D01-01**.
- **INFO-GAP-D01-2**: ¿DEC-02 formulable sin D-CATALOG en la práctica? **UNKNOWN, con
  argumento §14 pero sin verificación empírica — resoluble con EXP-D01-04**.
- **INFO-GAP-D01-3**: ¿existe algún hook / script actual que pretendería consumir
  D-CATALOG y no puede porque no existe? **UNKNOWN pero probable NO — verificable con
  `.claude/hooks/` grep**.
- **INFO-GAP-D01-4**: ¿el gap "convención `[RESEARCH]` vs git-policy 8 tipos" es un
  incidente material? **UNKNOWN, posiblemente marginal**.
- **INFO-GAP-D01-5**: ¿Owner considera que "quick win" documental de A2 vale el coste
  semántico documentado en §5-§18? **UNKNOWN — no observable, Owner-only**.
- **INFO-GAP-D01-6**: ¿algún consumidor futuro (S2 team, agent auto-classification)
  requiere el join view? **UNKNOWN, especulativo**.

---

## §22. FALSIFIERS

Evidencia futura que invalidaría cada conclusión principal.

### 22.1 STATUS_QUO (A) rechazable si

- EXP-D01-01 registra ≥10 casos/mes de consulta simultánea multi-fuente.
- Aparecen ≥3 nuevos tipos de commit fuera de la lista actual git-policy.md en 3 meses.
- Un incidente material atribuible a ausencia de D-CATALOG se documenta en
  INCIDENT_REGISTRY.

### 22.2 TAXONOMY-ONLY (B) rechazable si

- Se detecta que "elevar git-policy.md a taxonomy" es cambio cosmético sin ganancia real
  (git-policy ya cumple función normativa).
- Owner considera que preservar git-policy.md como fuente única es preferible.
- Aparecen ≥5 nuevos tipos en 6 meses (evidencia de que taxonomía cerrada es prematura).

### 22.3 DERIVED VIEW (C) rechazable si

- HRQS §12 muestra que 3-fuentes-separadas no es problema real.
- Sin motor DEC-04, el sync manual introduce drift verificable en ≤1 mes.

### 22.4 CANONICAL REGISTRY (D) rechazable si

- **Ya rechazable**: §5-§14 argumentan que la formulación monolítica falla varios tests
  estructurales.
- Se demuestra que ARCH-006 §6 T4 se activa por change-type → auth mapping.

### 22.5 SPLIT + DEFER (E) rechazable si

- Owner considera que retirar sub-decisiones es prematuro (F preferible).
- Emergence de use-case para join view completo.

### 22.6 DEFER (F) rechazable si

- Sin triggers concretos y observables, se convierte en decisión perpetua.
- Existe presión operativa clara (DEC-02 formulándose) que requiere resolución.

### 22.7 RETIRE (G) rechazable si

- Owner considera que "eliminar del decision space" comunica algo perdido.
- Un caso material aparece post-retiro y hay que reabrir con costes de reboot.

---

## §23. DEFERRAL TRIGGERS

Si Owner elige **DEFER (F)**, los triggers deben ser observables (per ARCH-005). Propuesta
YAML compatible con `DEFERRAL_POLICY.md`:

```yaml
# ejemplo — NO se persiste hasta autorización Owner
deferral: dec01
combine: ANY
provenance: "DEC-01_D-CATALOG_DECISION_GATE.md §23"
triggers:
  - id: dec01.T1
    type: EVENT
    predicate: "EXP-D01-01 muestra ≥10 casos/mes de consulta multi-fuente para clasificar cambios."
    provenance: "DEC-01_D-CATALOG_DECISION_GATE.md §20.1"
  - id: dec01.T2
    type: EVENT
    predicate: "DEC-02 se abre y requiere `change_type` como key primaria del registry (no cubierta por AUTHORITY_KIND)."
    provenance: "DEC-01_D-CATALOG_DECISION_GATE.md §14, §20.4"
  - id: dec01.T3
    type: COUNT
    predicate: "Aparecen ≥3 nuevos tipos de commit fuera de la lista actual git-policy.md en 3 meses."
    provenance: "DEC-01_D-CATALOG_DECISION_GATE.md §22.1"
  - id: dec01.T4
    type: EVENT
    predicate: "Un incidente material atribuido a ausencia de D-CATALOG se documenta en INCIDENT_REGISTRY."
    provenance: "DEC-01_D-CATALOG_DECISION_GATE.md §22.1"
  - id: dec01.T5
    type: EVENT
    predicate: "Owner planea escalamiento a S2/S3 (≥2 humanos activos) y quiere onboarding uniform."
    provenance: "DEC-01_D-CATALOG_DECISION_GATE.md §9.2"
  - id: dec01.T6
    type: LINK
    predicate: "ARCH-006 T3 se activa (DEC-02 requiere referencia canónica adicional)."
    link: arch06.T3
    provenance: "AUTHORITY_KIND.md §5.6 T3"
```

**Distinción explícita**: estos son **triggers de reactivación**, no autorizaciones.

Formato compatible con retrofit inmediato per ARCH-005 §7.

---

## §24. SECOND-ORDER ADVERSARIAL AUDIT

Aplicando Master Prompt §30 sobre el análisis previo.

**Pregunta 1**: ¿qué evidencia omití?

- **Posible omisión**: `docs/00_SYSTEM/61_CCP_COMPLETE_HANDOFF.md` y familia 61A-61G. No
  verifiqué explícitamente si algún handoff nuevo redefine DEC-01. **UNKNOWN, mitigable con
  grep dirigido**.
- **Posible omisión**: `ROOT_ANALYSIS/` directorio. No verifiqué contenido. **UNKNOWN,
  mitigable**.
- Grepqueado: ninguna redefinición material detectada durante la sesión;
  MASTER_HANDOFF.md es la fuente canónica del framing.

**Pregunta 2**: ¿estoy confundiendo conveniencia con necesidad?

- Argumenté que "sería útil" ≠ "sistema necesita". Consistente en la investigación.
- **Riesgo residual**: Owner puede valorar utilidad por preferencia. Es su prerrogativa
  (§34).

**Pregunta 3**: ¿estoy heredando vocabulario histórico como si fuera semántica?

- Sí, deliberadamente: usé "D-CATALOG" para hablar del objeto histórico. Pero mostré §5
  que "catalog" es vocablo sin significado técnico preciso; mi análisis no depende del
  vocablo.

**Pregunta 4**: ¿estoy confundiendo representación con entidad?

- Sí, deliberadamente. Es la pregunta central §5-§7 y la respondí: D-CATALOG A2 sería
  representación (join view), no entidad de primer orden.

**Pregunta 5**: ¿estoy creando un registro porque "suena arquitectónico"?

- No. Recomendé lo opuesto: no crear el registro.

**Pregunta 6**: ¿estoy usando DEC-02 como justificación circular?

- Ataqué explícitamente el ciclo DEC-01 → DEC-02 (§14). El argumento circular está
  documentado como error en la formulación previa, no como fundamento de mi análisis.

**Pregunta 7**: ¿la dependencia HARD es solamente procedimental?

- Sí (§14). La HARD aparece por ordenamiento histórico de trabajo, no por semántica.

**Pregunta 8**: ¿hay un problema más pequeño que resuelva el mismo gap?

- **SÍ**: Alternativa B (TAXONOMY-ONLY) o E (SPLIT + selectivo taxonomy) o F (DEFER)
  resuelven parcialmente el gap declarado "K3-D-OWNER-DEFAULT" sin materializar el
  monolítico A2.
- Aún mejor: el gap ya está parcialmente resuelto por ARCH-006 (autoridad) y git-policy
  (types).

**Pregunta 9**: ¿estoy pasando de análisis a diseño sin autorización?

- **NO**. Todas las alternativas se presentan como options-space para Owner. Ninguna es
  "la respuesta".

**Correcciones aplicadas durante la escritura**:

- El análisis inicial trataba a A2 como "quick win probable"; después de §5-§14, quedó
  claro que A2 tiene múltiples ataques estructurales. Se corrigió a `<60% confidence`.
- Se añadió §17.5-§17.7 tras notar que E, F, G no tenían BEFORE/AFTER en primera pasada.
- El "riesgo T4" de ARCH-006 §6 fue formalizado tras revisar AUTHORITY_KIND.md
  específicamente para el punto §10.3.

---

## §25. THIRD-LEVEL PERSPECTIVES

Aplicando Master Prompt §31 con 3 perspectivas independientes.

### 25.1 Minimalist Engineer

> "Every abstraction is a debt. If two Markdown files can hold what one file, plus a rule
> in git-policy.md and a taxonomy in AUTHORITY_KIND.md already hold, delete the second
> file. D-CATALOG A2 is the second file. Retire it. If Owner wants discoverability, put a
> paragraph in the Handbook §12 referencing all three sources. Zero new artifacts."

**Peso**: alto. Es la posición más consistente con las reglas operativas del CCP (evitar
sync manual, evitar artefactos derivados sin motor).

### 25.2 Control Plane Architect

> "The pattern that emerges from ARCH-005 and ARCH-006 is: prefer taxonomy + rules over
> registry + enforcement. D-CATALOG A2 breaks this pattern by mixing four objects with
> distinct semantics. The correct expression is either B (TAXONOMY-ONLY) for the `type`
> column, or E (SPLIT) recognizing each column has its rightful home. But watch for
> future evidence: if the corpus grows and we need `change_type` in DEC-02 keys, we may
> need a lightweight taxonomy after all. Don't retire silently — DEFER (F) with observable
> triggers preserves optionality."

**Peso**: alto. Reconoce la dirección arquitectónica del CCP y advierte contra
retiro silencioso.

### 25.3 Future Maintainer (12-24 meses)

> "In 12 months, the person maintaining this repo will read PROJECT_STATE, MASTER_HANDOFF,
> DECISION_SPACE_PREPARED and see 'DEC-01 open'. They'll waste hours re-deriving what this
> gate document already answered. Whatever alternative Owner picks, please leave a
> permanent trace so the next reader doesn't re-open the same investigation. E or G with
> DECISION_HISTORY entry is the maintainer-friendliest. F with clear triggers is a fair
> second."

**Peso**: alto. Enfatiza legibilidad del decision graph para futuros lectores.

### 25.4 Conflict analysis

Las tres perspectivas no colisionan estructuralmente:

- Minimalist: retire (G) o accept SPLIT (E) with retirements.
- Architect: defer (F) or SPLIT (E) preserving TAXONOMY option.
- Maintainer: E o G o F — todas con permanent trace.

**Convergencia**: **E (SPLIT) satisface las tres**. F como respaldo si SPLIT es
prematuro.

---

## §26. TEST — ¿Qué pasa si D-CATALOG desaparece?

Aplicando Master Prompt §28. Thought experiment obligatorio.

Supón que DEC-01 se retira completamente hoy. ¿Qué se pierde?

- **Ninguna decisión queda imposible**: ARCH-001..006 se sostienen; DEC-02 formulable con
  AUTHORITY_KIND; DEC-04..12 ortogonales.
- **Ninguna operación runtime falla**: hooks siguen operando; maintenance.sh 12/12 sigue
  pasando; SubagentStart context injection normal.
- **Ninguna evidencia se pierde**: EVIDENCE_REGISTRY intacto; git log intacto;
  DECISION_REGISTRY intacto.
- **Reviewer humano workflow**: sin cambio (D-CATALOG no existe hoy tampoco).
- **Discoverability**: reviewer consulta 3 fuentes en vez de 1 hipotética. No hay
  regresión respecto al baseline actual.

**Casi todo sigue funcionando**. Este resultado es fuerte evidencia empírica de que
D-CATALOG **no es load-bearing**.

**Confidence del test**: `HIGH`. Consistente con toda la investigación previa.

---

## §27. TEST — ¿Qué pasa si D-CATALOG se materializa?

Aplicando Master Prompt §29. Simulación.

Supón que Owner elige A2 (D CANONICAL). Estados posibles:

- **creation**: reviewer construye tabla inicial con 5-9 tipos + 4 columnas. Coste
  declarado: 1-2h.
- **change (type)**: nuevo tipo de commit adoptado → reviewer edita `type × ...` en
  D-CATALOG **y** `.claude/rules/git-policy.md`. Sync manual (potencial drift).
- **change (gate)**: nuevo hook → reviewer edita D-CATALOG. Puede olvidarse. Drift
  probable.
- **change (auth_holder)**: **prohibido por ARCH-006 §6** (piece → auth mapping). Trigger
  T4 potencial.
- **change (precedent)**: cada decisión Owner (ARCH-007, DEC-02, ...) → append a
  D-CATALOG **y** DECISION_REGISTRY. Sync manual.
- **verification**: HRQS §12 podría añadir "verify D-CATALOG fresh". Costo trimestral.
- **consumer access**: reviewer consulta D-CATALOG en lugar de 3 fuentes. Beneficio
  hipotético.
- **versioning**: sin política declarada.
- **conflict**: D-CATALOG dice "auth=mecánica"; AUTHORITY_KIND dice "no mapping". ¿Cuál
  manda?
- **deprecation**: git revert; retraining reviewer.
- **removal**: git revert + workflow rollback.
- **recovery**: reconstituir desde 4 upstreams si D-CATALOG destruído.

**Nuevos contratos**: (a) sync manual con 4 upstreams; (b) política de reconciliación
inexistente; (c) posible auto-tabla en HRQS.

**Nuevas responsabilidades**: reviewer humano vigila 5 fuentes en vez de 4.

**Nuevas clases de error**: drift silencioso; conflict con ARCH-006; falso-consumer.

**Nuevos problemas de autoridad**: ¿quién es autoritativo si D-CATALOG.auth conflicta con
AUTHORITY_KIND? No declarado.

**Nuevos puntos de drift**: cada cambio en upstreams sin retrofit.

**Confidence del test**: `HIGH`. Materialización introduce problemas estructurales sin
resolver problemas empíricamente documentados.

---

## §28. FINAL DECISION SPACE

Consolidación de alternativas técnicamente sostenibles después de todos los ataques.

### 28.1 Válidas técnicamente

| Alternativa | Nombre | Recommendation confidence | Notas |
|---|---|---|---|
| **A** | STATUS QUO | 70% | Válida pero pierde oportunidad de limpiar decision graph |
| **B** | TAXONOMY-ONLY | 60-70% | Válida si Owner considera vocabulario cerrado útil independientemente |
| **C** | DERIVED VIEW | 40-50% | Válida como quick-win visual; riesgo sync manual |
| **E** | SPLIT + DEFER | **70-80%** | Recomendación técnica más limpia |
| **F** | DEFER | 60-70% | Válida si Owner quiere preservar optionality |
| **G** | RETIRE | 50-60% | Válida si Owner acepta el ataque adversarial completo |

### 28.2 Rechazadas por el ataque adversarial

| Alternativa | Nombre | Razón de rechazo |
|---|---|---|
| **D** | CANONICAL REGISTRY (A2 original) | Falla homogeneidad §5-§6; redundancia §11; ARCH-006 §6 conflict §10.3; DEC-02 HARD contested §14 |
| **A2 con revision_period** | híbrida DECISION_SPACE_PREPARED §4.1 | Añade proceso sin resolver conflictos estructurales |
| **A3** | Registry + hook | Viola F9-D01 sin justificación empírica; misma crítica que A2 + F9-D01 conflict |
| **A3 warn mode** | Registry + hook warn | Sigue introduciendo hook runtime; sigue cruzando F9-D01 |

### 28.3 Owner Decision Space

Owner debe elegir entre **A / B / C / E / F / G**. **D queda rechazada** por argumentación
estructural (no por opinión). El Master Prompt §33 lista `ADOPT / REFORMULATE / SPLIT /
MERGE-WITH / DEFER / RETIRE`; aplicándolo:

- **ADOPT** → aplicable sólo si Owner elige B (adoptar taxonomía únicamente).
- **REFORMULATE** → aplicable si Owner elige B o C (reformular D-CATALOG como taxonomía o
  como derived view).
- **SPLIT** → aplicable si Owner elige E.
- **MERGE-WITH** → aplicable si Owner elige B con integración explícita en git-policy /
  AUTHORITY_KIND (variante particular de B).
- **DEFER** → aplicable si Owner elige F.
- **RETIRE** → aplicable si Owner elige G.

---

## §29. CONFIDENCE

Para cada conclusión principal.

| Conclusión | Confidence | Fundamento |
|---|---|---|
| D-CATALOG no es entidad semántica coherente | **HIGH** (85%) | §5-§7 homogeneidad falla en 10/12 criterios |
| D-CATALOG A2 conflicta con ARCH-006 §6 | **HIGH** (80%) | §10.3 análisis literal; interpretation-dependent |
| DEC-01 → DEC-02 HARD es contestada | **MED-HIGH** (75%) | §14 argumento sólido; refutable si DEC-02 se reformula |
| No hay evidencia empírica de necesidad | **HIGH** (90%) | §12 exhaustiva; consistente con §13 corpus |
| ARCH-006 precedent debe aplicarse | **HIGH** (80%) | §7, §16.2, §16.5 |
| Alternativa D debe rechazarse | **HIGH** (80%) | §5-§14, §17-§19 convergen |
| Alternativa E es opcion técnicamente mejor | **MED** (65%) | Depende de tolerancia Owner a "retirar sub-decisiones" |
| Experimentos §20 compran información determinante | **HIGH** (80%) | Bajo coste, alto valor, no cruzan gates |

**Conclusiones con confidence <60%** (no presentar como recomendación suficiente):

- Preferencia entre E, F, G — dependen de preferencia Owner.
- Necesidad de EXP-D01-03 (taxonomía piloto) — dependiente de elección Alternativa B.

---

## §30. OWNER DECISION BRIEF

> Ficha autosuficiente. Owner debe poder decidir SIN releer este documento.

### Decision

Qué debe decidir Owner: **el estatus de DEC-01/D-CATALOG en el decision space del CCP**,
entre las alternativas técnicamente sostenibles:

- **A — STATUS QUO** (no materializar; DEC-01 continúa abierta).
- **B — TAXONOMY-ONLY** (materializar sólo taxonomía cerrada de tipos de cambio siguiendo
  patrón ARCH-006).
- **C — DERIVED VIEW** (materializar como view derivado explícitamente marcado).
- **E — SPLIT + DEFER** (particionar en E1-E4 y decidir cada una: mayoría retire, E1
  defer/adopt).
- **F — DEFER** (registrar en `PROJECT_STATE.DEFERRED` con triggers observables).
- **G — RETIRE** (marcar RETIRED en DECISION_HISTORY con lección aprendida).

**Alternativa D (CANONICAL REGISTRY A2 original) queda estructuralmente rechazada por el
ataque adversarial**. No aparece en el espacio Owner.

### Why now

- ARCH-006 (2026-09-26/27) cambió el paisaje semántico de D-CATALOG. Su columna
  `auth_holder` es ahora prohibida por precedente §6.
- La formulación previa (DECISION_SPACE_PREPARED 2026-09-25) no incorporó ARCH-006.
- Sin resolver DEC-01 con framing correcto, el decision graph queda con framing heredado
  y bloquea claridad para las siguientes decisiones (DEC-02, DEC-12).

### What is actually known

- No existe `CHANGE_TYPES_CATALOG.md` hoy (E1).
- `.claude/rules/git-policy.md` enumera 8 tipos canónicos (E2).
- `docs/00_SYSTEM/AUTHORITY_KIND.md` (ARCH-006) formaliza taxonomía cerrada de autoridad
  (E3).
- ARCH-006 §6 prohíbe piece→authority mapping (E4).
- `DECISION_REGISTRY.md` + `DECISION_HISTORY.md` cubren precedentes (E5, E6).
- ARCH-006 relación con DEC-02 es SOFT/ENABLER, no HARD (E12).
- No hay evidencia empírica de un incidente material atribuible a ausencia de D-CATALOG
  (E18).
- Últimos 30 commits: 2 tipos dominantes; no hay presión empírica para taxonomía rica
  (§13).

### What remains uncertain

- ¿EXP-D01-01 (multi-fuente reviewer consult) mostrará casos frecuentes? (INFO-GAP-D01-1)
- ¿EXP-D01-04 (DEC-02 sin D-CATALOG) revelará necesidad no contemplada? (INFO-GAP-D01-2)
- ¿Owner acepta la interpretación estricta de ARCH-006 §6 T4 sobre change-type→auth
  mapping? (INFO-GAP-D01-5)
- ¿Escalamiento a S2/S3 activaría necesidad de discoverability? (§9.2 hipotético)

### Valid alternatives

A, B, C, E, F, G (ver §16 y §28). **D rechazada por §5-§19**.

### Main trade-offs

- **A (STATUS QUO)**: 0 cost, 0 lock-in, deja decision graph con framing heredado.
- **B (TAXONOMY-ONLY)**: 1-2h, closed vocab útil, aligns ARCH-006, duplica levemente
  git-policy.
- **C (DERIVED VIEW)**: 2-4h, sync burden real, discoverability con marca "derived".
- **E (SPLIT + DEFER)**: 1-2h documental, limpia decision graph, retira sub-decisiones sin
  necesidad demostrada.
- **F (DEFER)**: 30 min, preserva optionality, requiere disciplina para revisit real.
- **G (RETIRE)**: 30 min, máxima limpieza, requiere confianza en ataque adversarial.

### Lock-in

Ver §19. **B, C, F, G**: bajo lock-in. **A2 (rechazada)**: MEDIO lock-in en workflow
reviewer.

### Recommended investigation

Antes de cerrar, correr **EXP-D01-01 + EXP-D01-04** en paralelo (2-4 semanas). Ambos no
cruzan F9-D01 y resuelven las dos preguntas centrales.

**Alternativa a experimentos**: elegir E (SPLIT + DEFER) permite decidir hoy con framing
corregido, sin necesidad de esperar experimentos.

### Conditions for deferral

Ver §23 triggers YAML. **combine: ANY** con 6 triggers observables. Formato compatible con
ARCH-005 retrofit.

### Downstream impact

Ver §15. **A, B, C, E, F, G**: ortogonal o positivo. **D**: introduce ruido con ARCH-006.

### Decision boundary

**Qué se decide en DEC-01**: estatus de una **posible materialización de un objeto
llamado D-CATALOG** en el CCP. Nada más.

**Qué NO se decide en DEC-01**:

- Sino relación DEC-02 → AUTHORITY_KIND (esa es DEC-02).
- El status de `[RESEARCH]` como convención vs git-policy (gap ya identificado, no scope
  de DEC-01).
- Enforcement de tipos de commit (fuera de scope si no A3).
- Cambio en HRQS §12 (podría ser subsecuente, no requisito).
- Cambio en git-policy.md.

### Explicit non-decisions

- Este documento **no** decide entre A/B/C/E/F/G.
- Este documento **no** autoriza implementación de ninguna alternativa.
- Este documento **no** modifica PROJECT_STATE, DECISION_REGISTRY, DECISION_HISTORY para
  declarar DEC-01 cerrada.
- Este documento **no** commitea nada.
- Este documento **no** declara implicación estructural sobre DEC-02 más allá de
  contestar HARD → SOFT/ENABLER.

---

## §31. GATE INTEGRITY CHECK

Verificación obligatoria antes de cerrar (Master Prompt §37).

### Gate integrity

- [x] DEC-01 sigue siendo una decisión abierta.
- [x] No se declaró `OWNER_CHOSEN`.
- [x] No se declaró `IMPLEMENTATION_AUTHORIZED`.
- [x] No se implementó ninguna alternativa.

### Evidence integrity

- [x] No hay hipótesis presentada como hecho. Todas las afirmaciones tienen
  clasificación epistemológica.
- [x] Las contradicciones están registradas (C1, C2 en §4).
- [x] Las conclusiones fuertes tienen evidencia (§29 confidence table).

### Semantic integrity

- [x] Se probó que "catalog" sea una entidad coherente (§5-§7): CONTRADICTED.
- [x] Se probaron alternativas que niegan esa hipótesis (§16 A, B, C, E, F, G).
- [x] Se evitó usar "catalog", "registry", "taxonomy" como sinónimos (§7 explícito).

### Dependency integrity

- [x] Se revalidó DEC-01 → DEC-02 (§14): reclasificada de HARD a SOFT/ENABLER.
- [x] No se heredó una dependencia sin evidencia.
- [x] Se revisaron efectos sobre DEC-02, DEC-04/05/07/08/11/12 (§15).

### Lock-in integrity

- [x] Cada alternativa tiene reversibilidad (§19).
- [x] Cada alternativa tiene lock-in (§19).
- [x] Cada alternativa tiene coste de salida (§19).
- [x] Se identificaron falsificadores (§22).

### Experiment integrity

- [x] Se ejecutó el análisis de los últimos 30 commits (§13).
- [x] Se clasificó el corpus empíricamente (§13.2, §13.3, §13.4).
- [x] Se explicó qué información aporta (§13.5).
- [x] Se explicó qué no puede demostrar (§13.5 pregunta 3).

### Owner integrity

- [x] Owner recibe alternativas reales (§16, §28).
- [x] Owner recibe incertidumbres (§21).
- [x] Owner recibe condiciones de cambio (§22, §23).
- [x] Owner no recibe una decisión disfrazada de análisis.

### Discipline

- [x] NO se hizo commit.
- [x] NO se hizo checkpoint.
- [x] NO se modificaron `PROJECT_STATE.md`, `DECISION_REGISTRY.md`, `DECISION_HISTORY.md`.
- [x] Solo se registró el nuevo artefacto analítico (`DEC-01_D-CATALOG_DECISION_GATE.md`)
  como Stratum C untracked.

---

## §32. APPENDIX — Comparative Matrix (compacted)

Para la decisión Owner, matriz consolidada. Escala: `+` gain, `−` loss, `~` neutral, `N/A`
no aplicable.

| Criterio | A | B | C | E | F | G |
|---|---:|---:|---:|---:|---:|---:|
| Valor directo | ~ | + | + | + | ~ | ~ |
| Complejidad | ~ | + | ~ | + | ~ | + |
| Reversibilidad | + | + | + | + | + | + |
| Lock-in | + | + | ~ | + | + | + |
| Governance risk | + | + | ~ | + | + | + |
| Semantic drift risk | + | + | − | + | + | + |
| Maintenance | + | ~ | − | + | + | + |
| Discoverability | ~ | + | + | ~ | ~ | ~ |
| Verification value | N/A | + | ~ | + | ~ | ~ |
| Information gain | + | ~ | ~ | + | + | + |
| Downstream impact | + | + | + | + | + | + |
| ARCH-006 coherence | + | + | + | + | + | + |
| F9-D01 preservation | + | + | + | + | + | + |
| Decision graph clarity | ~ | + | ~ | + | ~ | + |
| Maintainer readability | + | + | + | + | + | + |

**Valores calificativos, no cuantificados**. La preferencia Owner es dominante.

---

## §33. FIN — FINAL RECONSTRUCTION CERTIFICATE

```text
CERTIFICATE — DEC-01 D-CATALOG DECISION GATE

BASELINE PROMPT       : CCP_MASTER_EXECUTION_PROMPT.md (2026-09-27 handoff)
ARTIFACT PRODUCED     : docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md
STRATUM               : C (untracked analytical artifact)
HEAD BASELINE         : 473759c (ARCH-006 checkpoint)

INVESTIGATION SCOPE   : § 1-32 covered per Master Prompt §36 requirements.
                        - Baseline snapshot: §2.
                        - Historical reconstruction: §3.
                        - Evidence matrix: §4.
                        - Semantic homogeneity attack: §5, §6.
                        - Terminological analysis: §7.
                        - Multi-representation: §8.
                        - Consumer analysis: §9.
                        - Source-of-truth analysis: §10.
                        - Redundancy analysis: §11.
                        - Necessity test: §12.
                        - Empirical 30-commit experiment: §13.
                        - DEC-02 dependency revalidation: §14.
                        - Downstream impact: §15.
                        - Alternative set: §16.
                        - Before → After: §17.
                        - Regression matrix: §18.
                        - Lock-in analysis: §19.
                        - Reversible experiments: §20.
                        - Information gaps: §21.
                        - Falsifiers: §22.
                        - Deferral triggers: §23.
                        - Second-order adversarial audit: §24.
                        - Three perspectives: §25.
                        - Absence thought experiment: §26.
                        - Materialization thought experiment: §27.
                        - Final decision space: §28.
                        - Confidence: §29.
                        - Owner Decision Brief: §30.
                        - Consistency checks: §31.
                        - Comparative matrix: §32.

KEY STRUCTURAL FINDINGS (per §1 executive):
                        (1) D-CATALOG NOT a coherent semantic entity — homogeneity fails.
                        (2) `type` column duplicates `.claude/rules/git-policy.md`.
                        (3) `auth_holder` column PROHIBITED by ARCH-006 §6 T4 potential.
                        (4) `gate` column duplicates hooks + rules.
                        (5) `precedent` column duplicates DECISION_REGISTRY + HISTORY.
                        (6) DEC-02 dependency HARD → SOFT/ENABLER after ARCH-006.
                        (7) No empirical evidence of material need in 30-commit corpus.
                        (8) Alternative D (CANONICAL A2) REJECTED by adversarial audit.

OWNER DECISION SPACE  : { A STATUS_QUO, B TAXONOMY-ONLY, C DERIVED_VIEW,
                          E SPLIT+DEFER, F DEFER, G RETIRE }
                        (D CANONICAL_REGISTRY rejected by argument structure.)

DECISIONS DEFERRED    : all six alternatives await explicit Owner choice.
                        NO OWNER_CHOSEN in this artifact.
                        NO IMPLEMENTATION_AUTHORIZED in this artifact.

CONFIDENCE            : HIGH for structural findings (§29).
                        MED for choice preference (E preferred technically but
                        Owner preference dominates).

CHECKPOINT DISCIPLINE : NO commit. NO PROJECT_STATE mutation.
                        NO DECISION_REGISTRY mutation. NO DECISION_HISTORY mutation.
                        Artifact remains Stratum-C until Owner action.

NEXT STEP             : Owner review of §30 (OWNER DECISION BRIEF).
                        Optionally: run EXP-D01-01 + EXP-D01-04 in parallel first.

DOCUMENT SELF-SUFFICIENCY : YES. Owner can evaluate DEC-01 reading §1 + §30 without
                            revisiting prior artifacts.

MASTER PROMPT §37 CHECKLIST : all boxes marked (§31).
```

**FIN DEL DOCUMENTO. DECISION GATE PREPARADO. AWAITING OWNER DECISION.**
