# DEC-02 D-DELEG — DRAFT POST-ARCH-007

```text
STRATUM              : C (untracked analytical artifact)
NATURE               : DRAFT / FORMULATION EXPERIMENT (EXP-A output)
STATUS               : NON-CANONICAL
OWNER_CHOICE         : NONE
IMPLEMENTATION_AUTH  : NONE
RUNTIME_CHANGE       : NONE
CHECKPOINT           : NOT PROPOSED
```

> **Ámbito**: este documento **NO decide DEC-02**. Es una prueba de formulabilidad:
> demostrar (o refutar) que DEC-02 puede escribirse usando `AUTHORITY_KIND` como taxonomía
> canónica única y `ACTION_TYPE` como vocabulario **observado y provisional**, sin
> resurrecir el framing retirado de D-CATALOG y sin crear ningún registry/taxonomy nuevo.
> Preserva la boundary post-ARCH-007. Fecha: 2026-09-27. Autor: Claude Opus 4.7 (analyst).

---

## §1. PROBLEM

**K3-D-OWNER-DEFAULT** — todo lo no delegado explícitamente **defaultea al humano
Owner**. Es un bottleneck operativo documentado en MASTER §13.2, K3, y confirmado
empíricamente en el corpus de 5 subagentes + 7 tipos runtime (`.claude/agents/*.md` +
harness types).

Ejemplos observables del defaulteo silencioso:

- `code-reviewer` ejecuta revisiones autónomas pero cada revisión "activa" requiere Owner
  para autorizar los findings actionables → no hay contrato explícito de qué reviews
  quedan pre-autorizadas y cuáles requieren Owner gate.
- `implementer` puede escribir código (permissionMode `acceptEdits`), pero **quién decide
  cuándo se despacha implementer** es implícito.
- `researcher`, `architect`, `security-auditor` idem.
- **Ninguna delegación explícita, revocable, con contrato** existe hoy.

Consecuencia: cualquier decisión "delegar X a subagente" es K3-D-OWNER-DEFAULT reforzado:
el default es Owner, y sólo la práctica implícita mueve algunos casos al agente.

---

## §2. EXISTING EVIDENCE

### 2.1 Actor catalog (VERIFIED)

**File-defined subagents** (`.claude/agents/*.md`, 5 archivos):

| Actor | Tools declaradas | Model | permissionMode | Naturaleza (per AUTHORITY_KIND §3) |
|---|---|---|---|---|
| `architect` | Read, Glob, Grep, Write, Edit (no Bash) | opus | plan | `agente` operando bajo `convención` (docs write only) |
| `code-reviewer` | Read, Glob, Grep (read-only) | sonnet | default | `agente` (read-only verdict emitter) |
| `implementer` | Read, Glob, Grep, Write, Edit, Bash | sonnet | acceptEdits | `agente` (highest tool scope) |
| `researcher` | Read, Glob, Grep, WebSearch, WebFetch (no writes) | sonnet | default | `agente` operando en frontera externa |
| `security-auditor` | Read, Glob, Grep (read-only) | opus | default | `agente` (read-only audit) |

**Runtime types (harness-injected, no file)**: `claude`, `claude-code-guide`, `Explore`,
`fork`, `general-purpose`, `Plan`, `statusline-setup`. **No están en `.claude/agents/`**;
son tipos gestionados por el harness Claude Code. **UNKNOWN** si el contrato de
delegación aplica a ellos igual que a los file-defined; requiere análisis separado si
DEC-02 se abre formalmente.

### 2.2 Authority taxonomy (VERIFIED — ARCH-006 canonical)

`docs/00_SYSTEM/AUTHORITY_KIND.md` §2 (VOCAB-A CLOSED):

```
{ mecánica, convención, humana, agente }
```

Cardinalidad 4 exactamente. Modificación ordinaria PROHIBIDA. Reapertura requiere ARCH-006
formal reopening.

### 2.3 Procedural precedent (VERIFIED — ARCH-005)

`docs/00_SYSTEM/DEFERRAL_POLICY.md`: patrón docs-only + YAML in-document + trigger
canónico + vocabulario cerrado {EVENT, CONDITION, COUNT, DATE, LINK}. Aplicable como
precedente procedimental a la formulación de `activation` y `revocation` en DEC-02.

### 2.4 Reviewer verdict schema (VERIFIED — descubierto en EXP-D)

`.claude/skills/code-review-and-quality/SKILL.md` + `.claude/agents/code-reviewer.md`:

```
RESULTADO: PASS | BLOCKED
RIESGO: LOW | MEDIUM | HIGH | CRITICAL
FINDINGS: [SEVERITY] path:line — hallazgo
CONTRACT_CHECK: PASS | BLOCKED
```

Este formato es **evidencia empírica de que el CCP ya tiene un contrato de output
observable para el actor `code-reviewer`**. Cualquier futura entrada `code-review` en un
DELEGATION_REGISTRY hipotético consumiría exactamente este schema como `output_contract`.

### 2.5 K3-D-OWNER-DEFAULT documentation (DOCUMENTED — MASTER)

MASTER_HANDOFF §13.2 y DECISION_SPACE_PREPARED §4.2 documentan el problema. **DOCUMENTED**
porque MASTER es snapshot; el problema empírico persiste.

---

## §3. AUTHORITY MODEL

DEC-02 opera **sobre AUTHORITY_KIND**, no lo reemplaza.

Modelo propuesto (`VERIFIED` como formulación posible; no como decisión):

```text
DELEGATION = (
    action_type              : observed-vocabulary bounded per gate
    delegated_from           : AUTHORITY_KIND value (usually 'humana')
    delegated_to             : AUTHORITY_KIND value (usually 'agente' or 'mecánica')
    fallback                 : AUTHORITY_KIND value (usually 'humana')
    activation               : predicate observable (EVENT | CONDITION | COUNT | DATE | LINK)
    revocation               : predicate observable + procedure
    scope                    : bounded operational context
    provenance               : source-of-record (this decision + gate)
)
```

**Puntos críticos del modelo**:

1. **`delegated_from`, `delegated_to`, `fallback`** son valores de AUTHORITY_KIND. **No se
   inventan clases nuevas**. VOCAB-A CLOSED se respeta literalmente.
2. **`action_type`** es un **campo string libre** con vocabulario **observado y provisional**,
   NO canonicalizado en un nuevo registry/taxonomy. Ver §4.
3. **`activation` / `revocation`** usan el vocabulario cerrado de ARCH-005 DEFERRAL_POLICY §3.
4. **`scope`** es descripción operativa (docs-only), no schema-enforced.
5. **`provenance`** apunta al gate de DEC-02 + la entrada específica → traza inmutable
   por git.

---

## §4. OBSERVED ACTION VOCABULARY (bounded, provisional)

Vocabulario empírico derivado de los actores catalogados (§2.1). **No canonical**. Sólo
identifica qué acciones existen hoy como semi-implícitamente delegables.

| Candidate action_type | Derivación empírica | Actor típico | Fuente-de-verdad de la acción |
|---|---|---|---|
| `code-review` | agent code-reviewer.md + skill code-review-and-quality | `code-reviewer` | .claude/agents/code-reviewer.md + skill SKILL.md |
| `implementation` | agent implementer.md | `implementer` | .claude/agents/implementer.md |
| `research-external` | agent researcher.md + WebSearch/WebFetch tools | `researcher` | .claude/agents/researcher.md |
| `architecture-analysis` | agent architect.md | `architect` | .claude/agents/architect.md |
| `security-audit` | agent security-auditor.md + OWASP checklist | `security-auditor` | .claude/agents/security-auditor.md |
| `evidence-registration` | skill evidence + hook task-completed-evidence | mixed (agent produce, hook enforce) | .claude/skills/evidence/SKILL.md |
| `adr-registration` | skill adr | `humana` (Owner) o `agente` con Owner ack | .claude/skills/adr/SKILL.md |
| `no-go-verification` | skill no-go | agent o humana | .claude/skills/no-go/SKILL.md |
| `phase-gate-verification` | skill gate | `humana` | .claude/skills/gate/SKILL.md |
| `phase-closure` | skill cerrar-fase | `humana` | .claude/skills/cerrar-fase/SKILL.md |
| `incident-management` | skill incident | `humana` (default) o `agente` autorizado | .claude/skills/incident/SKILL.md |

**Nota epistemológica**: esta tabla es **INFERENCE** desde artefactos existentes; no es
canonical. Materializarla como registry crearía anti-patrón (ver §7 falsifier item 4).

**UNKNOWN**: acciones ejecutadas por harness runtime types (`fork`, `general-purpose`,
`Explore`, `Plan`) — no están en `.claude/agents/`, requieren análisis separado.

**UNKNOWN**: acciones que no tienen agente/skill formal pero existen (por ejemplo, "revisar
un PR", "auditar un commit histórico", "verificar HRQS §12"). El vocabulario observado no
es exhaustivo.

---

## §5. REQUIRED FIELDS (minimum viable)

Para cada entrada en un hipotético registro de delegación (docs-only, sin registry
materializado):

```text
ENTRY               : <action_type> → <delegated_to>
action_type         : string, from observed vocab §4 or 'UNKNOWN'
delegated_from      : AUTHORITY_KIND value
delegated_to        : AUTHORITY_KIND value
fallback            : AUTHORITY_KIND value  (default: 'humana')
activation          : YAML block per ARCH-005 §3 vocab
revocation          : predicate + reference to reopening procedure
scope               : one-sentence operational description
provenance          : reference to gate document + entry line
```

Ejemplo ilustrativo (**NOT AUTHORIZED, NOT CANONICAL**):

```yaml
# ejemplo hipotético — NO se persiste hasta autorización Owner
- action_type: code-review
  delegated_from: humana
  delegated_to: agente
  fallback: humana
  activation:
    type: EVENT
    predicate: "Reviewer humano invoca /code-review-and-quality o despacha code-reviewer agent"
    provenance: "DEC-02 gate §N"
  revocation:
    predicate: "Reviewer humano rechaza el verdict del agente vía HRQS §12"
    procedure: "Verdict humano supersede; agente retorna a fallback humana"
  scope: "Fresh-context reviews of implementer/architect output pre-commit"
  provenance: "DEC-02 gate entry-01"
```

**El ejemplo NO se materializa** en ningún archivo runtime, hook, rule o registry en esta
sesión. Es ilustrativo del schema documental posible.

---

## §6. WHAT DEC-02 DOES NOT NEED

| Item | Necesidad | Justificación |
|---|---|---|
| `CHANGE_TYPE` | **NO** | Dimensión distinta a `action_type`. `git-policy.md` ya cubre change_type; irrelevante para delegation. |
| `TASK_TYPE` | **NO** | ARCH-004 ya distingue CONTRACTUAL/TODO/SUBTASK/RESEARCH. Ortogonal a delegation. |
| `VERIFICATION_TYPE` | **NO** | Competencia de DEC-07 (verificador). DEC-02 sólo registra a quién se delega, no cómo se verifica. |
| Nuevo `ACTION_TYPES_CATALOG.md` | **NO** | Ver §7 anti-pattern test. Vocabulario observado y bounded per gate es suficiente. |
| Nuevo `AUTHORITY_BOUNDARY.md` | **PROHIBIDO** por ARCH-006 §6 (piece→authority mapping ban). |
| Nuevo `DELEGATION_REGISTRY.md` como pieza runtime | **NO** | Docs-only en el gate; sin materialización filesystem. |
| Reapertura de DEC-01 | **NO** | ARCH-007 retiró DEC-01 monolítico; formulación de DEC-02 sin resurrección de D-CATALOG. |
| Modificación de AUTHORITY_KIND | **NO** | VOCAB-A CLOSED. Cualquier necesidad de nueva clase activa ARCH-006 T2/T4. |
| Enforcement mecánico (hook nuevo) | **NO** | Docs-only preservado. |
| Cruce de F9-D01 | **NO** | F9-D01=A vigente. |

---

## §7. FALSIFIERS

Cada pregunta test intenta refutar la formulación §3-§5.

### 7.1 ¿Necesita delegation CHANGE_TYPE?

**Análisis**: si una delegación fuera "code-review para `feat` commits solamente", el key
sería un compuesto `(action_type, change_type)`. Pero:

- El uso empírico de `code-reviewer` no distingue por change_type (fresh-context review
  aplica igual a feat/fix/docs).
- El schema del EV entry (que ya emite verdict) tampoco distingue por change_type.
- Ninguna revisión histórica documentada (EV-001..EV-016) filtró por change_type.

**Verdict**: **NO** — CHANGE_TYPE no fuerza entrada en el key primary. Puede aparecer como
`scope` opcional pero no es campo obligatorio.

**Confidence**: HIGH (85%). Refutable si aparece una necesidad concreta de delegación
change_type-específica.

### 7.2 ¿Necesita delegation TASK_TYPE?

**Análisis**: ARCH-004 ya distingue CONTRACTUAL/TODO/SUBTASK/RESEARCH. Una delegación
puede aplicar a cualquier tipo. Ejemplo: `code-review` aplica a CONTRACTUAL principalmente
pero también podría aplicar a RESEARCH si se autoriza.

**Verdict**: **NO** — TASK_TYPE es un filter de `scope`, no una key primary.

**Confidence**: HIGH (80%).

### 7.3 ¿Necesita delegation VERIFICATION_TYPE?

**Análisis**: VERIFICATION_TYPE (schema, hash, evidence, semantic) es competencia de
DEC-07. Una entrada delegation puede especificar `output_contract` (como el schema del
verdict) pero eso no la convierte en VERIFICATION_TYPE per se.

**Verdict**: **NO** — pero requiere consistencia si DEC-07 se abre con vocabulario
cerrado.

**Confidence**: MED-HIGH (70%).

### 7.4 ¿Necesita ACTION_TYPE una taxonomía canónica cerrada?

**Análisis**: Un vocabulario cerrado tipo VOCAB-A (ARCH-006) para ACTION_TYPE tendría
costs y benefits similares a ARCH-006:

- **Benefits**: prevenir semantic drift; reapertura formal para nueva clase; consistencia.
- **Costs**: rigidez ante actions latentes; ARCH-007 lesson: no crear pieza antes de tener
  problem+evidence de necesidad.

La pregunta empírica: **¿cuántas nuevas actions han emergido en 67 commits?**

- code-review, implementation, research-external, architecture-analysis, security-audit,
  evidence-registration, adr-registration, no-go-verification, phase-gate-verification,
  phase-closure, incident-management (11 observadas §4).
- Growth rate: los skills se añadieron incrementalmente (M001-M013). Sin cap actualmente.
- Escalamiento previsto: si S2/S3 (múltiples humanos), nuevas actions humana-específicas
  probablemente.

**Verdict provisional**: **BOUNDED-OBSERVED vocab es más apropiado**, con posibilidad de
convertir a VOCAB-A CLOSED en un gate futuro si la growth rate produce ≥1 nueva action
por semestre sin cabida clara. **Vocabulario abierto con enumeration de gate no es
CATÁLOGO** — es prosa dentro del gate document.

**Confidence**: MED (65%). Owner decision domina.

### 7.5 ¿Puede ACTION_TYPE permanecer bounded observed dentro del gate?

**Análisis**: Sí, siguiendo patrón ARCH-005 §5 (schema in-document, no registry
paralelo). El gate document enumera las 11 actions observadas + declara "vocabulario
observado; nueva action se enumera con evidencia empírica al mismo gate".

**Verdict**: **SÍ** — es la formulación mínima.

**Confidence**: HIGH (80%).

### 7.6 ¿Mapea `delegated_to` limpio sobre AUTHORITY_KIND?

**Análisis**: Los 5 subagentes file-defined son todos `agente` per AUTHORITY_KIND §3. Los
runtime types (`fork`, etc.) UNKNOWN. Owner es `humana`. Hooks son `mecánica`.

Test: para las 11 actions §4, ¿todas mapean sin ambigüedad?

- `code-review` → `agente` (code-reviewer.md) o `humana` (Owner review). ✓ Dos opciones
  discretas; no requiere clase nueva.
- `implementation` → `agente` (implementer.md) o `humana` (Owner directo). ✓
- `research-external` → `agente` (researcher.md). ✓
- `architecture-analysis` → `agente` (architect.md) o `humana`. ✓
- `security-audit` → `agente` (security-auditor.md). ✓
- `evidence-registration` → mixed: `agente` (produce entry) + `mecánica` (hook enforce). ✓
- `adr-registration` → `humana` (Owner) o `agente` (con Owner ACK). ✓
- `phase-gate-verification`, `phase-closure` → `humana` (Owner). ✓
- `incident-management` → `humana` (default) o `agente` autorizado. ✓
- `no-go-verification` → `agente` o `humana`. ✓

**Verdict**: **SÍ** — mapea limpio. Sin necesidad de VOCAB-B/C o meta-authority.

**Confidence**: HIGH (85%).

### 7.7 ¿Puede `fallback` permanecer explícito?

**Análisis**: Sí. Default `humana` per K3-D-OWNER-DEFAULT es explícito.

**Verdict**: **SÍ**.

**Confidence**: HIGH (90%).

### 7.8 ¿Puede `revocation` usar precedente procedural existente?

**Análisis**: ARCH-005 provee precedente docs-only + trigger canónico + reversibilidad
(git revert). ARCH-006 provee precedente de reapertura formal para cambio de vocabulario.

Formulación: `revocation.procedure` = "Reviewer humano supersede verdict del agente; para
revocar delegación permanentemente, reabrir DEC-02 gate".

**Verdict**: **SÍ**.

**Confidence**: HIGH (85%).

### 7.9 ¿Puede la formulación permanecer docs-only?

**Análisis**: Sí — ARCH-005 y ARCH-006 lo hacen. El gate document + entradas enumeradas
in-document + trigger YAML per ARCH-005 §3. Sin runtime.

**Verdict**: **SÍ**.

**Confidence**: HIGH (90%).

### 7.10 ¿Puede formularse sin resurrección de DEC-01?

**Análisis**: Verificado explícitamente:

- No requiere `CHANGE_TYPE` como key (§7.1).
- No requiere `CHANGE_TYPES_CATALOG.md` (§6).
- No mapea action_type contra change_type (§7.2).
- AUTHORITY_KIND es la única taxonomía canónica invocada.
- Prohibiciones ARCH-006 §6 respetadas: no piece→authority mapping (delegations son
  action→authority, no piece→authority; `code-reviewer` es actor, no pieza asignada a
  autoridad).

**Verdict**: **SÍ**.

**Confidence**: HIGH (85%).

---

## §8. OPEN UNKNOWNS

Después de este experimento, quedan sin resolver:

1. **U1**: ¿Los harness runtime types (`fork`, `general-purpose`, etc.) entran en el mismo
   registry o requieren tratamiento separado? UNKNOWN.
2. **U2**: ¿ACTION_TYPE debe ser CLOSED (VOCAB-A analog) o OPEN-BOUNDED? Owner decision.
3. **U3**: ¿La entrada `evidence-registration` con actor mixed `agente + mecánica` es una
   sola entrada o dos? UNKNOWN.
4. **U4**: ¿DEC-02 gate incluye tabla enumerativa de las 11 actions observed, o sólo el
   schema + primeras 2-3 delegations piloto (patrón ARCH-006 evidencia ATTESTED)?
5. **U5**: ¿HRQS §12 escalation al Owner (docs/CONTROL_PLANE_HANDBOOK.md §12) es una
   `activation` implícita para "escalation-review" action? UNKNOWN.
6. **U6**: ¿DEC-02 abre "delegation-modification" como sub-action delegable, o toda
   modificación de la tabla es Owner-only? UNKNOWN.

Ninguno de estos U1-U6 refuta la formulación §3-§5. Todos son elecciones dentro del
Owner-decision-space del gate.

---

## §9. CANDIDATE OPTIONS (without choosing)

Opciones de gate identificadas para DEC-02 (formulación posible; NO recomendación):

| Opción | Descripción | Lock-in | Reversibility |
|---|---|---|---|
| **B0** | No hacer nada (statu quo K3-D-OWNER-DEFAULT persiste) | NULO | N/A |
| **B1** | Delegation table docs-only en DEC-02 gate document, con 11 actions observed + AUTHORITY_KIND mapping + activation/revocation YAML | BAJO | ALTA (git revert) |
| **B2** | B1 + "piloto delegation" seleccionada (1 sola entrada activated) + observación 30-60 días antes de expandir | BAJO | ALTA |
| **B3** | B1 + VOCAB-A CLOSED sobre ACTION_TYPE (11 clases exactas) + reopening procedure per ARCH-006 pattern | MED (semantic) | MED (reopening required) |
| **B4** | B1 con ACTION_TYPE OPEN-BOUNDED (11 observadas + regla "nueva action requires evidence ATTESTED al gate") | BAJO | ALTA |
| **B5** | B1 + DEC-07 opening simultáneo (delegación con verifier LLM adversarial) | ALTO | MED (LLM provider lock-in) |
| **B6** | DEFER — no abrir DEC-02 hoy; declarar triggers observables para reactivación | NULO | N/A |
| **B7** | RETIRE — declarar K3-D-OWNER-DEFAULT como statu quo permanente | BAJO | ALTA |

**Rechazadas explícitamente por §7 falsifiers**:

- Formulación monolítica con `(change_type, action_type, task_type)` como composite key — refutada §7.1-7.2.
- Nuevo `DELEGATION_REGISTRY.md` como pieza runtime — anti-patrón §7.
- ACTION_TYPE catálogo pre-DEC-02 — anti-patrón ARCH-007 lesson.

---

## §10. CONSEQUENCES

### 10.1 If B1 or B4 chosen (docs-only, bounded vocab)

- Elimina K3-D-OWNER-DEFAULT como default silencioso.
- Permite Owner referenciar delegations al despachar work.
- Compatible con DEC-07 futuro (F2 LLM verifier consume delegation entries).
- Sin runtime side effects.

### 10.2 If B2 chosen (piloto)

- Compra información sobre "¿la delegación explícita funciona en la práctica?".
- Bajo riesgo; alto info gain.

### 10.3 If B3 chosen (VOCAB-A CLOSED)

- Consistencia procedural con ARCH-006.
- Riesgo: rigidez ante new actions emergentes.
- Trigger de reapertura formal para expansion.

### 10.4 If B6 chosen (DEFER)

- Mantiene K3-D-OWNER-DEFAULT.
- Preserva optionality.
- Requiere triggers observables (por analogía ARCH-005).

---

## §11. REVERSIBILITY

| Opción | Reset path |
|---|---|
| B0 | N/A |
| B1/B4 | `git revert` del commit del gate; sin runtime |
| B2 | `git revert` + retirar piloto |
| B3 | `git revert` + reopening procedure per ARCH-006 |
| B5 | `git revert` + retirar LLM provider hook; retraining humano |
| B6 | N/A |
| B7 | `git revert`; nuevo gate para reabrir |

Todas ALTA o N/A, excepto B5 (MED por LLM provider lock-in).

---

## §12. LOCK-IN

- **Semantic**: B3 introduce vocab cerrado sobre ACTION_TYPE — reopening required. B4
  evita esto.
- **Governance**: B1-B4 introducen "delegation" como categoría gobernanza. B5 añade
  provider dep.
- **Workflow**: B2 impone piloto observation window; no bloquea.
- **Runtime**: **NINGUNA opción B0-B4/B6/B7 tiene lock-in runtime**. B5 sí.

---

## §13. WHAT WOULD TRIGGER A FORMAL DEC-02 GATE

Predicados observables que motivarían Owner-authorized apertura formal:

- **dec02.T1** EVENT: Owner enfrenta ≥3 despachos de subagente/semana donde la
  clasificación "¿es delegable?" produce ambigüedad; K3-D-OWNER-DEFAULT como bottleneck
  observable.
- **dec02.T2** EVENT: DEC-07 se prepara — F2 LLM adversarial verifier requiere entrada
  explícita en un delegation registry (verifier necesita saber "quién está autorizado a
  producir el artifact que estoy revisando").
- **dec02.T3** COUNT: ≥2 delegaciones implícitas históricas resultan en incidente
  (implementer output no aceptado, o code-reviewer verdict inconsistente).
- **dec02.T4** EVENT: Owner planea escalamiento S2/S3 (múltiples humanos) — delegation
  explícita requerida para onboarding.
- **dec02.T5** EVENT: EXP-A ejecutado (este documento) demuestra que la formulación no
  requiere D-CATALOG y Owner acepta el framing.
- **dec02.T6** LINK: ARCH-006 T3 activa (DEC-02 se abre y requiere AUTHORITY_KIND
  referencing) — auto-cumplible.

**Formato compatible con ARCH-005 DEFERRAL_POLICY §5 para retrofit si Owner DEFER en el
futuro**.

---

## §14. CONFIDENCE TABLE

| Claim | Confidence | Fundamento |
|---|---|---|
| DEC-02 formulable sin CHANGE_TYPE | HIGH (85%) | §7.1 |
| DEC-02 formulable sin TASK_TYPE | HIGH (80%) | §7.2 |
| DEC-02 formulable sin VERIFICATION_TYPE | MED-HIGH (70%) | §7.3, depende de DEC-07 future |
| ACTION_TYPE OPEN-BOUNDED viable | HIGH (80%) | §7.5 |
| `delegated_to` mapea AUTHORITY_KIND | HIGH (85%) | §7.6 |
| Fallback explícito viable | HIGH (90%) | §7.7 |
| Revocation via ARCH-005 precedent | HIGH (85%) | §7.8 |
| Docs-only viable | HIGH (90%) | §7.9 |
| Sin resurrección DEC-01 | HIGH (85%) | §7.10 |
| **Neta: DEC-02 formulable sin D-CATALOG** | **HIGH (85%)** | §7 falsifiers 10/10 pasan |

**Refutable si**:

- Owner elige B3 (VOCAB-A CLOSED) y descubre 12ª action emergente en <6 meses → forzaría
  reapertura formal.
- DEC-07 F2 se abre y requiere `change_type` como cross-reference key en el schema
  registry (activaría dec01.T2 → reactivación de E1).
- Aparece nueva primitive latent no cubierta por AUTHORITY_KIND (activaría ARCH-006 T2).

---

## §15. FINAL VERDICT (formulability, not decision)

**DEC-02 es formulable coherentemente sin resurrección de D-CATALOG.**

- Los 10 falsifier tests pasan (§7).
- El schema §5 requiere sólo campos observables + AUTHORITY_KIND como taxonomía única.
- Los patrones ARCH-005 (docs-only + YAML trigger) y ARCH-006 (VOCAB CLOSED con
  reapertura) son ambos aplicables como precedentes procedimentales.
- El vocabulario ACTION_TYPE puede permanecer OPEN-BOUNDED (B1/B4) o cerrarse
  ulteriormente (B3) sin bloquear la formulación inicial.

**Confidence de formulabilidad**: **HIGH (85%)**.

**Confidence de "DEC-02 es siguiente gate óptimo"**: **NOT ASSESSED en este experimento**.
Ese juicio requiere Owner sequencing preference + información de EXP-D + PATH selection
(§42 recomposition). Este experimento sólo prueba que la formulación es posible sin
D-CATALOG.

---

## §16. STATUS DECLARATION

- **NO Owner Choice** emitida.
- **NO DEC-02 gate opened**.
- **NO nueva pieza materializada**.
- **NO cambio en canonical state**.
- **NO modificación en `AUTHORITY_KIND.md`, `DEFERRAL_POLICY.md`, `.claude/*`**.
- **NO `DELEGATION_REGISTRY.md`, `ACTION_TYPES_CATALOG.md`, ni ningún nuevo artefacto
  canónico creado**.
- **NO checkpoint propuesto**.
- Este artefacto es Stratum-C untracked; su persistencia queda a criterio Owner.

**END — DEC-02 D-DELEG DRAFT (EXP-A output)**
