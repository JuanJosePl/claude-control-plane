# AUTHORITY-KIND

> Taxonomía canónica de PRIM-1 (AUTHORITY-KIND) y sus reglas cerradas de evolución.
> Materialización de ARCH-006 / DEC-AUTH-BOUNDARY (Owner Choice: AB5 + VOCAB-A, 2026-09-26).
>
> Este documento NO enumera autoridad por pieza. NO es un registry pieza → authority.
> Su alcance es exclusivamente **taxonomía + reglas de evolución**.

---

## §1 Propósito

AUTHORITY-KIND es la primitiva que responde a la pregunta: *¿qué clase de autoridad ejerce este
elemento cuando decide algo dentro del Control Plane?* Su materialización como objeto de primer
orden hace explícita una distinción que hasta 2026-09-26 vivía como columna descriptiva del piece
catalog (`PIECE_AND_IDEA_PUZZLE_AUDIT.md` §590 — PRIM-1 VERIFIED), no como entidad.

Este archivo es el **source-of-truth único** de:

1. las cuatro clases canónicas de autoridad;
2. la política de vocabulario cerrado (VOCAB-A);
3. las reglas explícitas de evolución;
4. el mecanismo de reapertura formal ante una nueva clase.

Este archivo **NO** es source-of-truth de:

- asignación pieza → authority-kind;
- delegación entre clases (reservado a DEC-02);
- enforcement o runtime de authority-kind;
- catálogo de autoridades del sistema.

**Contrato de scope**: se puede describir la implementación con una sola frase.

> Formalizar la taxonomía de AUTHORITY-KIND y sus reglas cerradas de evolución, sin enumerar
> autoridad por pieza.

Si el contenido de este documento deja de sostener esa frase, hay scope-leakage hacia AB2 y debe
corregirse antes de cualquier commit.

---

## §2 Vocabulario canónico

El vocabulario de AUTHORITY-KIND es **CERRADO** y contiene exactamente cuatro clases:

```text
{ mecánica, convención, humana, agente }
```

Cardinalidad: **4 exactamente**. Ninguna más, ninguna menos.

Cualquier autoridad ATTESTED del Control Plane pertenece semánticamente a una y sólo una de las
cuatro. Si aparece una instancia que no encaja materialmente en ninguna, la respuesta correcta es
**registrar el gap** (§8) y **reabrir ARCH-006** (§5); NO ampliar el vocabulario in situ.

Clases explícitamente **NO** canónicas (permanecen HYPOTHESIS o pertenecen a otros ejes):

- `external-service`, `compliance-authority`, `evaluator` — HYPOTHESIS (M011);
- `observ.`, `interno` — no son authority-kind (pertenecen a otros ejes según M011).

---

## §3 Definiciones semánticas

Cada clase se define con: definición, boundary, ejemplos VERIFIED (aislados, no enumerativos),
contraejemplos, qué la distingue de las otras tres, y qué NO significa. Los ejemplos ilustran; no
constituyen registry.

### `mecánica`

- **Definición**: autoridad ejercida por código determinista que decide en el instante de la
  operación (hooks con exit-code no-cero, validadores automáticos, scripts que aceptan/rechazan
  reproducciblemente).
- **Boundary**: opera sin interpretación humana en el momento de la decisión; su resultado es
  reproducible con la misma entrada.
- **Ejemplos VERIFIED**: los gates ejecutables descritos en `PIECE_AND_IDEA_PUZZLE_AUDIT.md`
  §127-129 (validadores de schema, comparadores de hash, emisores de exit-code) son instancias
  ATTESTED de esta clase. `bash-firewall` y `secret-guard` en `.claude/rules/*.md` mencionan
  también enforcement de esta naturaleza.
- **Contraejemplos**: un linter que sólo emite *warnings* ignorables (no decide); un watcher que
  registra pero no bloquea; un script que sugiere pero no obliga.
- **Qué la distingue**: `convención` autoriza por texto; `humana` requiere acto humano puntual;
  `agente` requiere decisión de un agente Claude. `mecánica` es la única que no requiere ningún
  acto interpretativo en tiempo de decisión.
- **NO significa**: cualquier código; sólo aquel cuya salida es autoritativa. Un script que
  genera reportes descriptivos NO es autoridad mecánica.
- **Clasificación de evidencia**: **VERIFIED**.

### `convención`

- **Definición**: autoridad ejercida por texto normativo acordado (rules, políticas, contratos
  documentales) cuya vinculación proviene de la convención de leerlo y respetarlo, no de un
  enforcement automático.
- **Boundary**: la fuente autoritativa es la prosa; el enforcement puede existir aparte y ser de
  otra clase (típicamente `mecánica`), pero la autoridad reside en el texto.
- **Ejemplos VERIFIED**: `CLAUDE.md` como instrucciones permanentes del proyecto, los archivos
  bajo `.claude/rules/`, `docs/00_SYSTEM/DEFERRAL_POLICY.md` como política canónica formalizada en
  ARCH-005. `PIECE_AND_IDEA_PUZZLE_AUDIT.md` §93 y §200 documentan instancias ATTESTED de esta
  clase.
- **Contraejemplos**: un README informativo (no vinculante); notas de sesión (no normativas);
  documentación de referencia sin peso obligatorio.
- **Qué la distingue**: `mecánica` decide sin lectura humana en el instante; `humana` es acto
  puntual de una persona; `agente` es acto de un agente. `convención` es texto que persiste y
  vincula por acuerdo.
- **NO significa**: cualquier archivo Markdown; sólo aquellos cuyo contenido es normativo y
  vinculante bajo el contrato del proyecto.
- **Clasificación de evidencia**: **VERIFIED**.

### `humana`

- **Definición**: autoridad ejercida por una persona designada (Owner, reviewer humano) mediante
  decisión explícita y puntual dentro de una gate o acto de revisión.
- **Boundary**: el acto humano es la unidad de autoridad; requiere presencia y decisión, no puede
  derivarse mecánicamente ni delegarse a un agente sin reapertura.
- **Ejemplos VERIFIED**: los Owner Decision Gates (F9-D01..D05, DEC-11, DEC-AUTH-BOUNDARY) son
  actos de autoridad humana registrados. El reviewer humano en la frontera `git + reviewer`
  documentada en F9-D04=B (`PROJECT_STATE.md` Nota 56) es otra instancia ATTESTED.
- **Contraejemplos**: un agente asistiendo al Owner en preparar el gate (es `agente`, no
  `humana`); una política firmada por humano en un artefacto (es `convención`, no `humana`);
  cualquier acción humana no designada como acto de autoridad.
- **Qué la distingue**: `mecánica`/`convención`/`agente` son autoridades que operan sin acto
  humano puntual en el instante de decisión; `humana` requiere ese acto.
- **NO significa**: cualquier interacción de una persona con el sistema; sólo actos de autoridad
  designada dentro de una gate o revisión con peso vinculante.
- **Clasificación de evidencia**: **VERIFIED**.

### `agente`

- **Definición**: autoridad ejercida por un agente Claude Code (sesión principal o subagente)
  actuando dentro de un contrato explícito y observable, con el output quedando registrado.
- **Boundary**: el agente decide dentro del scope autorizado por un acto previo (`humana` o
  `convención`); su decisión queda observable; no puede exceder autorización sin reapertura por
  autoridad superior.
- **Ejemplos VERIFIED**: la sesión principal actualizando bookkeeping tras Owner Choice
  (persistencia post-gate); un `implementer` agent aplicando un cambio autorizado dentro de su
  contrato. `PIECE_AND_IDEA_PUZZLE_AUDIT.md` §200 documenta esta clase como parte de la
  separación ATTESTED.
- **Contraejemplos**: un agente actuando fuera de scope autorizado (esto es violación, no
  autoridad); una acción determinista de un hook lanzada durante la sesión (es `mecánica`, no
  `agente`); un LLM que sólo genera texto informativo sin decisión vinculante.
- **Qué la distingue**: `mecánica` es código sin agente en el loop; `convención` es texto
  persistente; `humana` es acto de una persona designada. `agente` es la única clase cuya
  autoridad depende de una autorización previa a otra clase.
- **NO significa**: cualquier salida de un LLM; sólo actos autorizados y observables dentro de
  contrato explícito.
- **Clasificación de evidencia**: **VERIFIED**.

---

## §4 Contrato VOCAB-A (CLOSED)

```text
VOCAB_POLICY                = A (CLOSED)
CANONICAL_CLASSES           = { mecánica, convención, humana, agente }
CARDINALITY                 = exactamente 4
ORDINARY_MODIFICATION       = NO ADMITIDA
NEW_CLASS_PROCEDURE         = reapertura formal de ARCH-006 con Owner Choice explícito
IMPLICIT_META-AUTHORITY     = PROHIBIDA
IMPLICIT_OWNER_TRANSACTION  = PROHIBIDA
```

VOCAB-A significa: el vocabulario está cerrado. Ninguna clase adicional puede agregarse mediante
modificación ordinaria de este archivo, ni de otro archivo del proyecto. Cualquier expansión
requiere el procedimiento de §5.

---

## §5 Reglas de evolución

Las siguientes preguntas tienen respuesta única y vinculante bajo VOCAB-A.

1. **¿Qué constituye una nueva clase?** Una autoridad ATTESTED (no HYPOTHESIS) que, tras análisis
   semántico, no se subsume en `mecánica`, `convención`, `humana` ni `agente`, y cuya diferencia
   con las cuatro es material y no reducible.
2. **¿Qué NO constituye una nueva clase?** Un subtipo dentro de una clase existente (`mecánica.hook`
   no es una clase, es un subtipo de `mecánica`); una etiqueta descriptiva sin peso autoritativo
   (`observ.`, `interno`); una fuente externa que ejerce autoridad a través de una de las cuatro
   (una API externa consumida por un hook = `mecánica`; un compliance officer humano = `humana`).
3. **¿Quién puede proponer una nueva clase?** Cualquier agente o humano puede señalar el gap.
   Sólo el Owner puede autorizar la reapertura formal de ARCH-006.
4. **¿Qué evidencia justificaría el análisis?** Una instancia ATTESTED presente en el repositorio
   (no HYPOTHESIS, no propuesta futura) que resista el análisis de subsunción en las cuatro
   clases.
5. **¿Qué artefacto debe registrar la necesidad?** La sección §8 (Gaps) de este documento, con
   referencia explícita a la instancia ATTESTED y su clasificación como HYPOTHESIS / CANDIDATE
   GAP. La taxonomía no se modifica hasta reapertura.
6. **¿Qué evento fuerza reapertura de ARCH-006?** Cualquiera de estos disparadores (equivalentes
   a los `REVIEW TRIGGER` de ARCH-006 en `DECISION_REGISTRY.md`):
   - una autoridad ATTESTED que no encaja en las cuatro clases (Trigger T2);
   - uso implícito detectado de meta-authority en runtime, hooks o documentos canónicos (Trigger
     T4);
   - evidencia concreta de que un mapping pieza-por-pieza es necesario (Trigger T1 — no obliga a
     modificar VOCAB-A, pero habilita reapertura hacia AB2);
   - DEC-02 se abre y requiere referencia canónica a AUTHORITY-KIND que la taxonomía sola no
     puede resolver (Trigger T3).
7. **¿Qué NO puede hacerse silenciosamente?** Agregar una clase al vocabulario; renombrar una
   clase existente; expandir artificialmente la definición de una clase para absorber una
   instancia que no encaja; introducir sinónimos como si fueran clases distintas (por ejemplo,
   `convención documental` ≠ una clase adicional a `convención`); crear una capa "meta-authority"
   sobre las cuatro.

La autoridad final sobre el vocabulario es del **Owner** (clase `humana`). Ningún proceso
automático puede modificar la taxonomía.

---

## §6 Prohibiciones

Las siguientes construcciones están **prohibidas** por ARCH-006 (AB5+VOCAB-A). Su aparición en
runtime, hooks, skills, agents, rules, o en documentos canónicos, debe interpretarse como
violación del contrato y disparar el Trigger T4 de §5.6:

- **meta-authority**: cualquier autoridad que decida *sobre* las cuatro clases (por ejemplo, un
  árbitro entre `mecánica` y `humana`) sin ser ella misma una instancia de una de las cuatro;
- **agregación silenciosa** de una quinta clase (sin reapertura formal);
- **VOCAB-B**: mecanismo de extensión ordinaria del vocabulario;
- **VOCAB-C**: mecanismo de extensión por transacción Owner-controlled dentro del vocabulario
  (una nueva clase sigue requiriendo reapertura formal de la decisión, no una transacción de
  extensión);
- **mini-gates** o "owner-extension transactions" que actúen como puertas intermedias entre la
  modificación ordinaria y la reapertura formal;
- **piece → authority mapping** dentro de este documento (sea explícito o implícito por
  enumeración exhaustiva de ejemplos);
- **DELEGATION_REGISTRY** o cualquier registro de asignación pieza-autoridad (reservado a
  DEC-02);
- **AUTHORITY_BOUNDARY.md** o artefactos con nombre y alcance de AB2;
- **enforcement automático** de la taxonomía (hooks, CI checks, scripts);
- **absorción de instancias que no encajan** mediante ampliación forzada de una definición.

---

## §7 Relación con otras decisiones

- **DEC-02 (D-DELEG)**: relación `SOFT / ENABLER`. La materialización de AUTHORITY-KIND facilita
  la formulación conceptual de la delegación entre clases, pero **NO** abre DEC-02, **NO** la
  condiciona como precondición HARD, y **NO** crea `DELEGATION_REGISTRY`. Si DEC-02 se abre en el
  futuro, este documento puede referenciarse como fuente de vocabulario; DEC-02 decidirá sus
  propios objetos.
- **DEC-12**: la relación no es HARD. DEC-12 permanece formulable posteriormente sin que
  AUTHORITY-KIND sea una precondición estructural.
- **ARCH-005 (DEC-11, DEFERRAL_POLICY)**: precedente procedimental (docs-only, sin runtime, sin
  enforcement, YAML in-document, sin registry paralelo). ARCH-006 sigue el mismo patrón pero
  **NO** hereda su contenido, alcance ni reglas específicas. El precedente es procedimental, no
  estructural.
- **ARCH-001..004**: no afectadas por esta decisión. AUTHORITY-KIND es una primitiva conceptual,
  no un cambio de arquitectura del control plane.
- **F9-D01..D05**: F9-D01=A mantiene la gate closure; este documento no altera esa decisión. F9
  DEFERRED entries (CDT-02, AC-03, NH-11, F10-F12) permanecen en su estado actual.
- **MASTER_HANDOFF.md**: permanece `snapshot`. Este documento **NO** modifica MASTER_HANDOFF, ni
  se añade a él como sección, ni cambia su contrato. La discoverability de AUTHORITY_KIND.md se
  resuelve por su ubicación canónica en `docs/00_SYSTEM/` (misma familia que
  `DEFERRAL_POLICY.md`), no por embedding en MASTER_HANDOFF.
- **CLAUDE.md** y **docs/DESIGN.md**: no se modifican en esta implementación. La incorporación de
  este documento al bootstrap del proyecto queda **DEFERRED** para autorización Owner separada,
  si en algún momento se considera necesaria.

---

## §8 Gaps

Al momento de la implementación de ARCH-006, no hay gaps registrados: las cuatro clases tienen
evidencia ATTESTED suficiente y no se conoce ninguna instancia autoritativa del sistema que
resista subsunción en ellas.

Esta sección permanece **reservada** para el registro futuro de:

- instancias ATTESTED que no encajen en `mecánica`, `convención`, `humana` ni `agente`, marcadas
  como `HYPOTHESIS / CANDIDATE GAP`;
- evidencia acumulada relevante para una eventual reapertura formal de ARCH-006 bajo Trigger
  T2/T4 de §5.6.

Cualquier entrada en esta sección **NO** modifica el vocabulario canónico; sólo alimenta el
análisis para una futura decisión Owner.

---

## §9 Provenance y evidencia

Fuentes utilizadas para las definiciones y la taxonomía:

- **`docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md`**
  - §62: identifica la distinción `mecánica / convención / humana / agente` como columna del
    piece catalog, primitiva latente pre-materialización.
  - §200: caracteriza AUTHORITY-BOUNDARY como separación entre las cuatro clases.
  - §590: `PRIM-1: AUTHORITY-KIND (VERIFICADA)`.
  - §127-129, §219-220: ejemplos VERIFIED de instancias `mecánica`.
  - §93: autoridad convencional documentada como columna del piece catalog (evidencia para
    `convención`).
- **`docs/00_SYSTEM/DECISION_SPACE_PREPARED.md`**
  - §70-71, §94, §236: referencias a PRIM-1 AUTHORITY-KIND como primitiva materializable.
- **`DECISION_REGISTRY.md` · ARCH-006**: contrato de la decisión Owner (AB5 + VOCAB-A,
  2026-09-26), review triggers, prohibiciones estructurales.
- **`docs/00_SYSTEM/DECISION_HISTORY.md` · DEC-AUTH-BOUNDARY**: entry de aprendizaje con
  UNKNOWN AT TIME y TRIGGER SET.
- **`PROJECT_STATE.md` · Nota 56 y F9-D04=B**: evidencia ATTESTED de la clase `humana` en la
  frontera `git + reviewer`.
- **`.claude/rules/*.md`**: instancias de la clase `convención` (rules normativas del proyecto).
- **`CLAUDE.md`**: instancia de la clase `convención` (instrucciones permanentes del proyecto).
- **M009 / M010 / M011**: movimientos que produjeron el espacio decisional, la validación
  adversarial y las correcciones que hoy son inmutables (vocabulario canónico ATTESTED,
  relación DEC-02 SOFT/ENABLER, MASTER_HANDOFF snapshot, AB5 diferenciada, coste real de AB2,
  reversibilidad correcta de AB4).

Todas las afirmaciones de definición semántica en §3 están clasificadas como **VERIFIED**. Las
afirmaciones de esta sección son **DOCUMENTED** (referencias a artefactos existentes en el
repositorio).

---

## Contrato final

Este documento materializa PRIM-1 (AUTHORITY-KIND) como objeto canónico de primer orden bajo
AB5 + VOCAB-A. Su alcance está limitado a la taxonomía y a las reglas de evolución; su modificación
está sujeta al procedimiento formal descrito en §5. Nada en este documento asigna autoridad a
piezas específicas del sistema, delega entre clases, o introduce enforcement runtime.
