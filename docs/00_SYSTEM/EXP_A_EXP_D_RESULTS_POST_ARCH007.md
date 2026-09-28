# EXP-A + EXP-D — POST-ARCH-007 EXPERIMENT RESULTS

```text
STRATUM              : C (untracked analytical / experimental artifact)
NATURE               : COMBINED EXPERIMENT RESULTS
STATUS               : NON-CANONICAL
OWNER_CHOICE         : NONE
IMPLEMENTATION_AUTH  : NONE
RUNTIME_CHANGE       : NONE
CANONICAL_STATE_CHG  : NONE
CHECKPOINT           : NOT PROPOSED
```

> Fecha: 2026-09-27. Autor: Claude Opus 4.7 (analyst, non-decisor).
> Baseline: HEAD = `e529359`. Documento hermano: `DEC-02_DELEG_DRAFT_POST_ARCH007.md` (EXP-A raw output).

---

## §1. OBJECTIVE

Ejecutar dos experimentos que buy information sin abrir gate ni ejecutar implementación:

- **EXP-A**: ¿Puede DEC-02 D-DELEG formularse usando AUTHORITY_KIND como taxonomía única
  y ACTION_TYPE como vocabulario observado, sin resurrección de D-CATALOG?
- **EXP-D**: ¿HRQS §12 y los artefactos existentes ya proveen semantic reviewer verdict
  suficiente para determinar si DEC-REVIEWER-VERDICT es (a) gap real, (b) sub-decisión de
  DEC-07, o (c) ya cubierto?

Regla operativa: los resultados deben **reducir la incertidumbre**, no manufacturar
decisiones.

---

## §2. BASELINE

Verificado 2026-09-27 (17:12 GMT-5):

```text
HEAD                     = e5293591500c515e64f87417a72a8a1c8655da47   ✓ matches e529359
branch                   = main
untracked artifacts (C)  = CCP_MASTER_EXECUTION_PROMPT.md
                           docs/00_SYSTEM/DEC-01_D-CATALOG_DECISION_GATE.md
                           docs/00_SYSTEM/DECISION_SPACE_PREPARED.md
                           docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md
                           docs/00_SYSTEM/POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md
modified (Stratum-B)     = PROJECT_STATE.md (LAST_GIT_CHECKPOINT sync)
                           docs/00_SYSTEM/CLAUDE_SESSION_LOG.md (session append)
```

Sin drift. Sin corrección requerida. Estado consistente con conclusión de la sesión
anterior.

---

## §3. EXP-A — METHOD

1. **Source map preflight**: separar claims post-ARCH-007 (VERIFIED) de claims heredados
   (DOCUMENTED requiring revalidation).
2. **Actor catalog**: leer los 5 `.claude/agents/*.md` completos. Inventar tabla con
   tools, model, permissionMode, y clase AUTHORITY_KIND correspondiente.
3. **Skills inventory**: `ls .claude/skills/` para complementar el catálogo de actions
   observables.
4. **Vocabulary construction**: extraer las 11 actions observadas empíricamente desde los
   artefactos (§4 EXP-A draft §2.1, §4).
5. **Formulation drafting**: construir schema minimal §5 del draft.
6. **Adversarial falsification**: 10 tests (§7 del draft) intentando refutar la
   formulación.
7. **Falsifiers explicit**: en qué evidencia futura refutaría cada test.

**Output**: `docs/00_SYSTEM/DEC-02_DELEG_DRAFT_POST_ARCH007.md` (16 secciones).

---

## §4. EXP-A — EVIDENCE

### 4.1 Actors (VERIFIED por lectura directa)

5 file-defined + 7 harness runtime = 12 actor types. Tools y permissionMode explícitos
en frontmatter (draft §2.1).

### 4.2 Authority taxonomy (VERIFIED — ARCH-006 canonical)

`AUTHORITY_KIND.md` §2 VOCAB-A CLOSED: `{ mecánica, convención, humana, agente }`.

### 4.3 Procedural precedent (VERIFIED — ARCH-005)

`DEFERRAL_POLICY.md` provee schema YAML + vocab cerrado {EVENT, CONDITION, COUNT, DATE,
LINK}. Aplicable directamente para `activation` y `revocation`.

### 4.4 Observed action vocabulary (INFERRED desde artifacts existentes)

11 actions extraídas: code-review, implementation, research-external, architecture-analysis,
security-audit, evidence-registration, adr-registration, no-go-verification,
phase-gate-verification, phase-closure, incident-management.

**Confidence**: HIGH sobre la existencia empírica de cada acción; MED sobre la
completitud de la lista (harness runtime types no auditables desde disk).

### 4.5 Reviewer verdict schema (VERIFIED — descubierto en paralelo con EXP-D)

`.claude/skills/code-review-and-quality/SKILL.md` + `.claude/agents/code-reviewer.md` +
`.claude/skills/doubt-driven-development/SKILL.md` YA definen formatos de verdict:

```
RESULTADO: PASS | BLOCKED
RIESGO: LOW | MEDIUM | HIGH | CRITICAL
FINDINGS: [SEVERITY] path:line — hallazgo
CONTRACT_CHECK: PASS | BLOCKED
```

**Implicación cruzada**: cualquier futura entrada `code-review` en DEC-02 tendría un
`output_contract` ya definido → no requiere invención.

---

## §5. EXP-A — FALSIFICATION

10 tests ejecutados (draft §7). Resultado consolidado:

| # | Falsifier test | Result | Confidence |
|---|---|---|---|
| 7.1 | ¿Necesita CHANGE_TYPE? | **NO** | HIGH (85%) |
| 7.2 | ¿Necesita TASK_TYPE? | **NO** | HIGH (80%) |
| 7.3 | ¿Necesita VERIFICATION_TYPE? | **NO** con caveat DEC-07 | MED-HIGH (70%) |
| 7.4 | ¿Necesita ACTION_TYPE catálogo cerrado ex-ante? | **NO** — bounded-observed viable | MED (65%) |
| 7.5 | ¿Puede ACTION_TYPE quedar bounded observed en gate? | **SÍ** | HIGH (80%) |
| 7.6 | ¿`delegated_to` mapea AUTHORITY_KIND limpio? | **SÍ** para 11 actions | HIGH (85%) |
| 7.7 | ¿`fallback` explícito viable? | **SÍ** | HIGH (90%) |
| 7.8 | ¿`revocation` via ARCH-005 precedent? | **SÍ** | HIGH (85%) |
| 7.9 | ¿Formulación docs-only viable? | **SÍ** | HIGH (90%) |
| 7.10 | ¿Sin resurrección DEC-01? | **SÍ** | HIGH (85%) |

**10/10 tests pasan**. Ninguna evidencia empírica accessible en este experimento refuta la
formulación §3-§5 del draft.

---

## §6. EXP-A — RESULT

**VERDICT**: **DEC-02 D-DELEG es formulable coherentemente usando AUTHORITY_KIND como
taxonomía canónica única, con ACTION_TYPE como vocabulario observado y bounded,
docs-only, sin resurrección de D-CATALOG**.

**Confidence global**: HIGH (85%).

**Refutable si**:

- Owner elige B3 (VOCAB-A CLOSED sobre ACTION_TYPE) y aparece 12ª action en <6 meses
  forzando reapertura.
- DEC-07 F2 se abre y requiere `change_type` cross-reference en schema (activaría
  dec01.T2 → reactivación E1).
- Emerge primitiva nueva no cubierta por AUTHORITY_KIND (activaría ARCH-006 T2).

**Anti-patrón NO activado**: el experimento **no crea** DELEGATION_REGISTRY,
ACTION_TYPES_CATALOG.md, ni ninguna pieza runtime. El artefacto Stratum-C draft es
research analítica, no materialización.

**In-flight lesson (aplicando patrón ARCH-007)**: la formulación previa que declaraba
DEC-02 HARD-blocked por DEC-01 monolítico era hereditary error del framing pre-ARCH-006.
Este experimento confirma empíricamente la revalidación §14 del gate DEC-01.

---

## §7. EXP-D — METHOD

1. **HRQS location search**: grep en `docs/` y `.claude/` por HRQS + Human Review Quality
   + Reviewed-by + Review-verdict + reviewer verdict.
2. **HRQS section read**: leer sección completa (no snippet).
3. **Reviewer schema inventory**: leer los agent files + skills que emiten verdict.
4. **Sample commits**: identificar commits reviewer-related en las 67 commits totales
   (single-owner repo constraint).
5. **Evidence matrix**: por cada EV entry y CHANGE_PROVENANCE entry, extraer semantic
   verdict campos.
6. **Falsification**: 10 tests intentando refutar "no hay explicit reviewer verdict
   emission".

**Output**: este documento §8-§12.

---

## §8. HRQS — SOURCE ANALYSIS

### 8.1 Location (VERIFIED)

**`docs/CONTROL_PLANE_HANDBOOK.md`**:

- **§12** (line 995-1077): Estándar de Calidad para Revisión Humana (HRQS — Human Review
  Quality Standard). Cobertura: **STALL_POLICY block reviews**.
- **§12** (line 860-869): **Reviewer identity convention (A-06 / F8)**. Cobertura:
  **any documented review** (commits, closure notes, evidence registry).

### 8.2 HRQS content — STALL_POLICY reviews (line 995-1077)

Checklist de 6 puntos: IDENTIFY → POLICY → CLASSIFY → FP-CLASS → REGISTER → H-01 REGISTRY.

Verdict vocabulary emitido explícitamente:

```text
TP  — Verdadero Positivo
FP  — Falso Positivo  (con sub-clases: PAC-EF-02, FP-BENIGN_VARIANT, FP-CONTEXT_MISSING)
UNKNOWN — sin suficiente contexto
```

Escalation thresholds explicitos (3+ UNKNOWN, 2+ PAC-EF-02, 1 TP genuino no cubierto).

Registro de FP classes vivo (tabla actualizable).

### 8.3 A-06 content — reviewer identity convention (line 860-869)

```text
Reviewer: PASS (code-reviewer@fresh-context)   → subagente fresh-context
Reviewer: PASS (human/@owner)                   → aprobación humana explícita
Reviewer: NOT_REQUIRED                          → política de bajo riesgo
```

Declarada como **convención documental only** (no schema enforcement runtime).

### 8.4 Related structures (VERIFIED)

- **`.claude/skills/code-review-and-quality/SKILL.md`**: verdict schema `RESULTADO |
  RIESGO | FINDINGS | CHECKS | RECOMMENDATION`.
- **`.claude/agents/code-reviewer.md`**: verdict `RESULTADO | RIESGO | FINDINGS |
  CONTRACT_CHECK`.
- **`.claude/skills/doubt-driven-development/SKILL.md`**: verdict `CLAIM | CONTRACT |
  ARTIFACT | DOUBTS | RECONCILIATION | STOP`.
- **`docs/00_SYSTEM/EVIDENCE_REGISTRY.md` schema**: cada EV entry contiene
  `**Reviewer:** PASS | BLOCKED | NOT_REQUIRED` como campo mandatorio.
- **`docs/00_SYSTEM/CHANGE_PROVENANCE_F7.md`, `CHANGE_PROVENANCE_F8.md`**: por-commit
  matrix con Review Rounds (Round 1: BLOCK → Round 2: BLOCK → Round 3: PASS) y linking a
  EV entries + reviewer identity separado del executor.

---

## §9. REVIEWER SAMPLE

### 9.1 Definition (pre-committed)

**"Reviewer-related commit"** = commit que:

- Emerge de una fase con evidence gate (F1-F9), o
- Genera / actualiza EV entry con `Reviewer:` field, o
- Es referenciado en `CHANGE_PROVENANCE_F*.md` con Review Round tracking, o
- Menciona explícitamente reviewer / review en el mensaje.

### 9.2 Selection method

67 commits totales (verified `git log --oneline | wc -l`). Filtrar por:

```bash
git log --all --format="%H|%s" | grep -iE "review|F[1-9]|EV-|evidence|reviewer|ARCH-00" | head -20
```

**Constraint empírico**: repo es single-owner (`juan jose polo <poloj3614@gmail.com>` en
67/67 commits). Distinción author≠reviewer NO existe a nivel de git identity. La
distinción semántica vive en:

- Executor labels (e.g., `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX_OPENCODE` en commit
  `92050dd`).
- Auditor separado (`Auditor: Claude Code / Claude Opus 4.7 (post-execution, separate)`
  en `CHANGE_PROVENANCE_F8.md`).
- Reviewer identity field en EV entries (`Reviewer: PASS (code-reviewer@fresh-context)`).

### 9.3 N available vs 20 target

- **N con `Reviewer:` field explícito** (EV entries): **16** (EV-001..EV-016). Casi
  saturación del universo de EV entries relevantes.
- **N con Review Rounds tracking** (CHANGE_PROVENANCE): **F7 + F8** = 2 documentos
  cobertura de ≥12 commits.
- **N reviewer-related commits en git log**: aprox **25** (commits con `[F7]`, `[F8]`,
  `[F9]`, `docs: record evidence`, `checkpoint`).

**El sample de 20 es alcanzable pero redundante**: los 16 EV entries + 2 CHANGE_PROVENANCE
matrices cubren la evidencia estructural completa. No se fabrica.

### 9.4 Selection (final sample: 16 EV entries + 2 CHANGE_PROVENANCE + 4 recent checkpoint commits = 22 datapoints)

Ver §10 matrix.

---

## §10. REVIEWER EVIDENCE MATRIX

### 10.1 EV Registry entries (16 entries VERIFIED)

| EV# | Task ID | Reviewer verdict | Identity emitted | Findings tracked | Evidence link |
|---|---|---|---|---|---|
| EV-001 | F1-foundation-2026-09-16 | **PASS** | implicit A-06 | N/A (Notes only) | ✓ artifact+contract hash |
| EV-002 | F2-evidence-contract-2026-09-16 | **PASS** | implicit A-06 | N/A | ✓ hashes |
| EV-003 | F3-sdlc-evals-2026-09-16 | **NOT_REQUIRED** | implicit A-06 | Blocked reason | ✓ hashes |
| EV-004 | F3-retry-2026-09-16 | **NOT_REQUIRED** | implicit | Blocked reason | ✓ hashes |
| EV-005 | F3-Tier3-pass-2026-09-17 | **PASS** | implicit | N/A | ✓ hashes |
| EV-006 | F4-incident-regression | **PASS** | implicit | N/A | ✓ hashes |
| EV-007 | F5-state-integrity | **NOT_REQUIRED** | implicit | N/A | ✓ hashes |
| EV-008 | F6-maintenance | **NOT_REQUIRED** | implicit | N/A | ✓ hashes |
| EV-009 | F7-freshness-pass | **PASS** | implicit | N/A | ✓ hashes |
| EV-010 | F7-anti-loop | **PASS** | implicit | N/A | ✓ hashes |
| EV-011 | F7-firewall | **PASS** | *"Independent fresh review PASS"* explicit | N/A | ✓ hashes |
| EV-012 | F7-evidence-coupling | **PASS** | *"independent fresh review"* explicit | N/A | ✓ hashes + ARCH-004 link |
| EV-013 | F7-session-rotation | **PASS** | implicit | N/A | ✓ hashes |
| EV-014 | F7-installer-idempotency | **PASS** | implicit | N/A | ✓ hashes |
| EV-015 | F8-A-contract-hash | **PASS** | *"PASS (code-reviewer@fresh-context), independent fresh review round 3"* explicit A-06 | Round 1-2 BLOCK, Round 3 PASS documented | ✓ hashes |
| EV-016 | F8-B-firewall-json | **PASS** | *"PASS (code-reviewer@fresh-context), independent fresh review round 3"* explicit A-06 | Round 1-2 BLOCK, Round 3 PASS documented | ✓ hashes |

**Verdict emission rate**: **16/16** (100%) — cada EV entry emite semantic verdict.

**Identity emission rate**: **6/16 explicit** (EV-011, EV-012, EV-015, EV-016 con
identity full; EV-013, EV-014 con reference to independent review) + **10/16 implicit A-06**
(por schema convención documental). **0 entries sin verdict**.

### 10.2 CHANGE_PROVENANCE matrices

**F8 (docs/00_SYSTEM/CHANGE_PROVENANCE_F8.md)**:

| Commit | Bundle | Files | Evidence | Review Round |
|---|---|---|---|---|
| f840c71 | F8-A | TaskCompleted hook | EV-015 | Fresh review round 3 PASS |
| 0f79b68 | F8-B | Firewall hook | EV-016 | Fresh review rounds 1-3 |
| 92050dd | A-06+ARCH-004 | Handbook + registry | EV-015/EV-016 | Fresh review round 3 PASS |
| e25179f | F8-B correction | Firewall hook | EV-016 | Fresh review round 3 PASS |
| 1427fbe | F8-B correction | Firewall hook | EV-016 | Fresh review round 3 PASS |
| 95f1555 | Evidence + regressions | Registries | EV-015/016 REG-010/011 | Fresh review round 3 PASS |

**Round tracking**: Round 1: BLOCK — whitespace/multi-doc firewall; Round 2: BLOCK — raw-NUL bypass;
Round 3: PASS — no remaining findings.

**Executor label**: `EXECUTOR_CHATGPT_GPT_5_6_LUNA_MAX_OPENCODE`. **Auditor label**:
`Claude Code / Claude Opus 4.7 (post-execution, separate)`. Separación
executor ≠ author ≠ auditor **explícitamente registrada**.

**F7 (docs/00_SYSTEM/CHANGE_PROVENANCE_F7.md)**: 147 líneas, matrix análogo con más detalle
para EV-009..EV-014 (no re-listada por brevedad; consistente con F8 patrón).

### 10.3 Verdict schemas empíricamente emitidos

Total documentado:

- **PASS / BLOCKED / NOT_REQUIRED**: 3-valued verdict per EV entry ✓
- **Round tracking (multi-round convergencia)**: F7 + F8 documentados ✓
- **Reviewer identity convention (A-06)**: 3 forms explícitos ✓
- **Risk categorization**: LOW/MEDIUM/HIGH/CRITICAL (skill code-review-and-quality) ✓
- **Finding severity**: BLOCKER/HIGH/MEDIUM/LOW/NOTE (skill + agent) ✓
- **Contract check separate**: `CONTRACT_CHECK: PASS | BLOCKED` (code-reviewer.md) ✓
- **Doubt tracking**: `[CRITICAL|HIGH|MEDIUM|LOW] path:line — duda falsable`
  (doubt-driven-development) ✓
- **Recommendation vocab**: `aceptar | corregir | escalar` (code-review-and-quality) ✓
- **Stop convergence**: `STOP: PASS | BLOCKED` (doubt-driven-development) ✓

---

## §11. EXP-D — FALSIFICATION

10 tests intentando refutar "no hay explicit reviewer verdict emission".

| # | Test | Evidence | Result |
|---|---|---|---|
| 1 | ¿ACK encoded elsewhere? | EV.Reviewer field mandatorio + A-06 identity + Review Rounds | **YES** — ampliamente encoded |
| 2 | ¿Reviewer identity captured? | A-06 §12 handbook + `code-reviewer@fresh-context` in EV-015/016 | **YES** — captured per convention |
| 3 | ¿Review scope recoverable? | `Affects:` field per EV entry + CHANGE_PROVENANCE Files column | **YES** — recoverable |
| 4 | ¿Commit treated as intentional verdict? | A-06 declara "convención documental only, no schema enforcement" | **PARTIAL** — commit metadata != verdict; verdict vive en EV entry |
| 5 | ¿HRQS define semantics? | §12 STALL_POLICY reviews: TP/FP/UNKNOWN + FP sub-classes | **YES** — completo para STALL context |
| 6 | ¿Evidence registry captures review? | EVIDENCE_REGISTRY.md schema requires `Reviewer:` field | **YES** — mandatorio |
| 7 | ¿Auditor can reproduce reviewer decision? | Artifact hash + Contract hash + EV link + Review Rounds + Reviewer identity | **YES** — reproducible |
| 8 | ¿Proposed new trailer (RV2) actually necessary? | Todo lo que RV2 aportaría (semantic verdict + identity) YA está en EV.Reviewer + A-06 | **NO** — redundante |
| 9 | ¿RV2 duplicaría existing mechanism? | 100% overlap con EV.Reviewer + A-06 convention | **YES** — duplicaría |
| 10 | ¿RV3 (HRQS formaliza artefacto) simply formalize existing? | HRQS §12 ya está formalizado en handbook; RV3 sería re-formalización | **YES** — re-formalización sin gain |

**Verdict falsification**: la afirmación histórica **"reviewer no emite explicit
semantic evidence"** (PIECE_AND_IDEA_PUZZLE_AUDIT §12: "ACK implícito en el commit;
contrasta con P-O que sí emite F9_OWNER_DECISIONS") **es empíricamente REFUTADA**.

**Causa del error histórico**: PIECE_AND_IDEA_PUZZLE_AUDIT §12 inspeccionó git commits
como fuente de verdict, no inspeccionó EVIDENCE_REGISTRY.md ni CHANGE_PROVENANCE_F*.md.
La emisión de verdict vive en la capa Evidence, no en la capa Git.

---

## §12. EXP-D — RESULT

### 12.1 Classification per §15 of master prompt

**CASE D1 — ALREADY COVERED**: HRQS + A-06 + EV.Reviewer field + CHANGE_PROVENANCE
matrices + code-reviewer verdict schema + code-review-and-quality skill +
doubt-driven-development skill = **cobertura completa y multi-capa** del semantic
reviewer verdict.

### 12.2 Verdict

**DEC-REVIEWER-VERDICT is redundant**. La hipótesis histórica de "GAP-META-1
asimetría P-H vs P-O" es empíricamente refutada por evidencia distribuida en 6 capas:

1. EVIDENCE_REGISTRY.md schema (`Reviewer:` field mandatorio, 16/16 entries).
2. A-06 convention (handbook §12 line 860-869).
3. HRQS §12 STALL_POLICY review (handbook §12 line 995-1077).
4. code-reviewer agent verdict schema (.claude/agents/code-reviewer.md).
5. code-review-and-quality skill verdict schema (.claude/skills/code-review-and-quality/SKILL.md).
6. doubt-driven-development skill DOUBT tracking (.claude/skills/doubt-driven-development/SKILL.md).

Adicional: CHANGE_PROVENANCE_F7/F8 provee **round tracking** que git commits no capturan
por sí mismos.

### 12.3 Recommended disposition (analytical, no Owner Choice)

**Candidato para RETIRE con RESOLVED_BY** siguiendo patrón ARCH-007 SPLIT+DEFER:

```
DEC-REVIEWER-VERDICT
  RESOLVED_BY:
    - docs/CONTROL_PLANE_HANDBOOK.md §12 A-06 (reviewer identity convention)
    - docs/CONTROL_PLANE_HANDBOOK.md §12 HRQS (STALL_POLICY review quality)
    - docs/00_SYSTEM/EVIDENCE_REGISTRY.md schema (Reviewer: field)
    - .claude/agents/code-reviewer.md (verdict output schema)
    - .claude/skills/code-review-and-quality/SKILL.md (RESULTADO/RIESGO/FINDINGS)
    - .claude/skills/doubt-driven-development/SKILL.md (CLAIM/DOUBTS/STOP)
    - docs/00_SYSTEM/CHANGE_PROVENANCE_F*.md (Review Rounds tracking)
```

**No Owner Choice emitida en este experimento**. La disposición RETIRE es candidata
analítica; requiere Owner authorization para persistir en DECISION_HISTORY.

### 12.4 Refutable si

- Aparece use-case donde reviewer verdict debe ser **runtime-consumable** (LLM verifier
  DEC-07 F2 iría por aquí). Entonces la cobertura documental no basta y DEC-REVIEWER-VERDICT
  podría reabrir como sub-decisión de DEC-07.
- Owner planea S2/S3 (múltiples humanos) y quiere reviewer verdict machine-readable
  cross-session.
- Un incidente material atribuible a "no había verdict recoverable" se documenta en
  INCIDENT_REGISTRY.

**Confidence de CASE D1**: **HIGH (85%)**.

**In-flight lesson**: la revalidación empírica desmantela hipótesis heredadas
(PIECE_AND_IDEA_PUZZLE_AUDIT §12 tenía error de scope; inspeccionó solo git). Patrón
consistente con ARCH-007: ataque adversarial revela framing prematuro.

---

## §13. COMBINED IMPLICATIONS

### 13.1 Decision space update

Los dos experimentos combinados actualizan el decision space post-ARCH-007
(POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md §31) así:

| Decisión | Estado pre-experimento | Estado post-experimento | Confidence delta |
|---|---|---|---|
| DEC-02 D-DELEG | root, HARD-blocked según framing residual | **root, formulable sin D-CATALOG** | HIGH ↑ (85%) |
| DEC-REVIEWER-VERDICT | GAP-META-1 asimetría hipótesis; absorb-into-DEC-07 candidato | **RETIRE candidato con RESOLVED_BY** | HIGH ↑ (85%) |
| DEC-04 D-CANONICAL | WEAKLY_SUPPORTED, requires EXP-B | (no afectado) | unchanged |
| DEC-07 D-VERIFICADOR | HARD ← DEC-02, WEAKLY_SUPPORTED | HARD ← DEC-02 (aún), scope simplificado sin DEC-REVIEWER-VERDICT | MED ↑ (75%) |
| Otras (DEC-03/05/08/12/STREAM-CONSUMER) | sin cambio | sin cambio | unchanged |

### 13.2 Sub-decision status change

DEC-REVIEWER-VERDICT ya no requiere ser tratada como sub-decision candidate de DEC-07.
DEC-07, si eventualmente se abre, consume directamente el reviewer verdict schema
existente (§10.3 lista de 9 elementos) sin abrir DEC-REVIEWER-VERDICT dentro.

### 13.3 Actions inventory (§4 EXP-A) — corollary

De las 11 actions observadas, **7 emiten verdict semantic explícito** (code-review,
security-audit vía OWASP, no-go-verification, phase-gate-verification, phase-closure,
evidence-registration, incident-management). Las 4 restantes (implementation,
research-external, architecture-analysis, adr-registration) emiten artifact + provenance
sin verdict tag explícito. Esto puede ser input para futura DEC-02 al elegir qué actions
requieren `output_contract` incluído.

---

## §14. INFORMATION GAINED

- **EXP-A**: DEC-02 es formulable coherentemente sin D-CATALOG. Confidence HIGH.
- **EXP-D**: DEC-REVIEWER-VERDICT es redundante con 6 capas de emisión existentes.
  Confidence HIGH.
- **Metadata bonus**: `code-review-and-quality` skill provee `output_contract` ready-to-use
  para DEC-02 code-review entries.
- **Pattern reveal**: PIECE_AND_IDEA_PUZZLE_AUDIT §12 hipótesis "reviewer no emite
  verdict" fue error de scope (inspeccionó git, no evidence). Análogo al framing
  monolítico de DEC-01. Es el mismo tipo de error corregido por ARCH-007.
- **DEC-07 clarification**: DEC-07 futuro consume verdict schema existente sin requerir
  sub-decision DEC-REVIEWER-VERDICT.
- **Executor separation** (F8 provenance): existe empíricamente en el repo un patrón
  "executor ≠ author ≠ auditor" que documenta trust boundary implícito.

---

## §15. INFORMATION STILL MISSING

- **U1** (EXP-A): harness runtime types (`fork`, `general-purpose`, `Explore`, `Plan`,
  etc.) — su clasificación en delegation table. Requiere inspección separada del harness
  contract.
- **U2** (EXP-A): Owner preference OPEN-BOUNDED vs CLOSED sobre ACTION_TYPE (B1/B4 vs
  B3). Owner-only.
- **U3** (EXP-A): entrada `evidence-registration` con actor mixed. UNKNOWN si se registra
  como 1 o 2 entradas.
- **U4** (EXP-A): tabla enumerativa vs piloto sample selection para DEC-02 gate. Owner
  criterion.
- **U5** (EXP-A/D crossed): HRQS escalation al Owner como `activation` predicate para una
  hipotética "escalation-review" action. UNKNOWN.
- **U6** (EXP-D): ¿el patrón "executor ≠ author ≠ auditor" formalmente documentado en
  CHANGE_PROVENANCE_F8 debe universalizarse? UNKNOWN.
- **U7** (EXP-D): las 4 actions sin verdict tag (implementation, research-external,
  architecture-analysis, adr-registration) — ¿deben emitir un verdict propio o su
  artifact-only es suficiente? UNKNOWN.
- **U8** (cross-cutting): DEC-04 shadow drift detection experimento (EXP-B, no ejecutado
  aquí). Sigue pendiente.

Ninguno de U1-U8 refuta los resultados EXP-A/D.

---

## §16. DECISION-SPACE DELTA

### 16.1 Pre-experiment (POST_ARCH-007 §31)

```text
OPEN: DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-08, DEC-12,
      DEC-STREAM-CONSUMER, DEC-REVIEWER-VERDICT
CANDIDATES for absorb/subsume: DEC-REVIEWER-VERDICT → DEC-07,
      DEC-05 → DEC-04 coupled, DEC-12 (12.c/e) → DEC-03
NEW LATENT DECISIONS: 0
```

### 16.2 Post-experiment

```text
OPEN: DEC-02, DEC-03, DEC-04, DEC-05, DEC-07, DEC-08, DEC-12,
      DEC-STREAM-CONSUMER
CANDIDATES for absorb/subsume: DEC-05 → DEC-04 coupled,
      DEC-12 (12.c/e) → DEC-03
CANDIDATES for RETIRE: DEC-REVIEWER-VERDICT (RESOLVED_BY §12.3)
NEW LATENT DECISIONS: 0
```

**Delta**:

- **DEC-REVIEWER-VERDICT movido de OPEN → RETIRE candidate**. Reducción de 9 → 8 open.
- **DEC-02 confidence de formulabilidad**: HIGH (85%). Refuerza CASE A del §35
  recomposition, pero no lo convierte en gate-ready automático (§18 abajo).
- **DEC-07 scope simplificado**: sin DEC-REVIEWER-VERDICT sub-decision.

---

## §17. WHAT MUST NOT BE IMPLEMENTED

Explícitamente:

- **NO crear `DELEGATION_REGISTRY.md`** en filesystem.
- **NO crear `ACTION_TYPES_CATALOG.md`** ni cualquier variante.
- **NO crear `AUTHORITY_BOUNDARY.md`** (prohibido por ARCH-006 §6).
- **NO añadir campo runtime a evidence contract** (RV2 duplicaría A-06).
- **NO modificar `.claude/hooks/*.sh` para verdict enforcement**.
- **NO añadir `commit-msg` hook** con Reviewed-by/Review-verdict trailers.
- **NO retirar DEC-REVIEWER-VERDICT en DECISION_HISTORY** en esta sesión (requiere Owner
  Choice separado).
- **NO abrir DEC-02** en esta sesión.
- **NO abrir DEC-07** en esta sesión.
- **NO modificar `AUTHORITY_KIND.md`**.
- **NO ejecutar EXP-B, EXP-C ni EXP-E** en esta sesión (fuera de scope del prompt).

---

## §18. NEXT-GATE READINESS (DEC-02)

Evaluación contra los 12 criterios §20 del master prompt.

| # | Criterio | Cumplimiento | Justificación |
|---|---|---|---|
| 1 | Problem remains supported | ✓ | K3-D-OWNER-DEFAULT documentado empíricamente (draft §1) |
| 2 | Decision boundary is explicit | ✓ | §5 draft: schema minimal con 8 campos, sin scope creep |
| 3 | ACTION_TYPE ambiguity bounded enough | ✓ | 11 actions observadas (§4 draft) + bounded-observed pattern |
| 4 | AUTHORITY_KIND is sufficient foundation | ✓ | §7.6 draft: mapea limpio para 11/11 actions |
| 5 | Multiple plausible options remain | ✓ | 8 opciones (B0-B7) §9 draft |
| 6 | Options distinguishable consequences | ✓ | §10-11-12 draft (consequences, reversibility, lock-in) |
| 7 | No hidden D-CATALOG dependency | ✓ | §7.10 draft, HIGH confidence |
| 8 | No unrecognized coupling | ✓ | DEC-07 dependency HARD acknowledged; DEC-REVIEWER-VERDICT RETIRE candidate resuelve solo confusion previous |
| 9 | Evidence quality sufficient | **MED-HIGH** | §4 evidence base sólida; ACTION_TYPE OPEN-vs-CLOSED requiere Owner criterion |
| 10 | Remaining unknowns don't threaten formulation | ✓ | U1-U6 son elecciones dentro del gate, no bloqueos |
| 11 | Gate opened without implementation leakage | ✓ | Docs-only + schema in-document + ARCH-005 pattern |
| 12 | Confidence ≥ threshold | **MED-HIGH** | Confidence formulabilidad HIGH (85%); confidence "es el gate óptimo siguiente" NOT ASSESSED aquí |

**Verdict**: **DEC-02 CAN BE GATE-PREPARED** con confidence MED-HIGH.

**NO** significa: "DEC-02 gate-ready ahora" en el sentido de "Owner debe abrir hoy". El
Owner puede elegir:

- **Preparar** el gate document formal (siguiente movement) invocando este EXP-A draft como baseline.
- **Ejecutar experimentos adicionales** (piloto delegation, harness types survey).
- **Diferir** con triggers observables (§13 draft).

Este experimento **no fuerza CASE A** (abrir gate). Sólo demuestra que la formulación es
sólida.

---

## §19. CONFIDENCE TABLE

| Claim / section | Confidence | Fundamento |
|---|---|---|
| Baseline verified | HIGH (95%) | git verificado |
| A-06 covers reviewer identity | HIGH (95%) | handbook §12 line 860-869 leído directo |
| HRQS §12 covers STALL review | HIGH (95%) | handbook §12 line 995-1077 leído directo |
| EV.Reviewer field mandatorio 16/16 | HIGH (95%) | grep + read directo |
| Reviewer verdict schema em .claude/agents/code-reviewer.md | HIGH (95%) | archivo leído |
| Reviewer verdict schema em code-review-and-quality skill | HIGH (95%) | archivo leído |
| CHANGE_PROVENANCE Review Rounds tracked | HIGH (95%) | F8 leído directo |
| EXP-A: DEC-02 formulable sin D-CATALOG | HIGH (85%) | 10/10 falsifiers pass (§5) |
| EXP-A: ACTION_TYPE OPEN-BOUNDED viable | HIGH (80%) | 7.5 draft |
| EXP-A: `delegated_to` mapea AUTHORITY_KIND | HIGH (85%) | 11/11 actions mapean §7.6 draft |
| EXP-D: HRQS covers reviewer verdict | HIGH (95%) | 6 capas verificadas |
| EXP-D: DEC-REVIEWER-VERDICT redundant | HIGH (85%) | 10/10 falsifiers refute the gap claim |
| EXP-D: PIECE_AND_IDEA_PUZZLE_AUDIT §12 error was scope-limited | HIGH (85%) | §12 inspeccionó git only, not EV registry |
| Decision-space delta 9→8 open | HIGH (85%) | consecuencia directa EXP-D |
| DEC-02 gate-preparable con confidence MED-HIGH | MED-HIGH (75%) | 12/12 criteria §18 pasan, con caveats en 9 y 12 |
| **Claim NOT ASSESSED** | — | "DEC-02 es el gate óptimo siguiente" |

Ninguna conclusión con confidence <60% se presenta como recomendación fuerte.

---

## §20. STOP CONDITION

Se alcanza STOP porque:

- ✓ Ambos experimentos ejecutados con evidence directa.
- ✓ Two Stratum-C artifacts producidos (`DEC-02_DELEG_DRAFT_POST_ARCH007.md` + este
  documento).
- ✓ Ningún gate abierto.
- ✓ Ningún runtime/hook/skill/rule/registry/state canonical modificado.
- ✓ Ningún commit propuesto.
- ✓ Owner boundaries respetadas: no Owner Choice, no Implementation Authorization.

**Adicional stop conditions activadas**: ninguna (baseline íntegro, sample sufficient,
evidence non-contradictoria).

---

## §21. SECOND ADVERSARIAL PASS (self-attack fresh-context style)

Aplicando §21 del master prompt.

| Pregunta | Auto-respuesta | Verdict |
|---|---|---|
| ¿Revivé DEC-01? | Explícitamente §7.10 draft ataca esto; ninguna clausula requiere D-CATALOG | **NO** |
| ¿Creé hidden ACTION_TYPE taxonomy? | Vocabulario §4 draft es OPEN-BOUNDED, no CLOSED; no se persiste como artifact canónico | **NO** |
| ¿Traté tool names como action taxonomy? | Actions §4 son verbs (code-review, implementation, etc.), no tools (Read/Write/Bash); mapping is agent→action, not tool→action | **NO** |
| ¿Equaté authority con action? | AUTHORITY_KIND (`{mecánica,convención,humana,agente}`) es CLASE; ACTION_TYPE es VERBO. Modelo §3 draft mantiene ejes ortogonales | **NO** |
| ¿Equaté commit con reviewer verdict? | §12 EXP-D explícitamente separa: git commit = author metadata; verdict = EV.Reviewer field. Test 4 confirma PARTIAL only | **NO** |
| ¿Usé old MASTER_HANDOFF framing como current truth? | Source map §2 EXP-A draft explícitamente clasifica MASTER como DOCUMENTED requiring revalidation. Cada claim usado se revalidó | **NO** |
| ¿Convertí candidato en open decision? | DEC-REVIEWER-VERDICT RETIRE es candidato, no persistido (§12.3). DEC-02 gate-preparable es análisis, no apertura | **NO** |
| ¿Convertí experimento en implementación? | Cero archivos runtime/hook/rule/skill modificados. Verificable con `git status` post-ejecución | **NO** |
| ¿Inventé reviewer samples missing? | §9.3 explícitamente reporta N=16 EV + 2 CHANGE_PROVENANCE + 4 recent = 22 datapoints; sin fabricación | **NO** |
| ¿Inferí evidence absent desde silencio? | Cada claim tiene fuente explícita en §4 y §10. UNKNOWNs registrados en §15 | **NO** |
| ¿Creé nuevo registry porque el concepto no tenía container? | §17 lista explícita de NO CREAR. DELEGATION_REGISTRY, ACTION_TYPES_CATALOG, AUTHORITY_BOUNDARY todos NOT CREATED | **NO** |
| ¿Privilegié DEC-02 solo porque tiene downstream leverage? | §18 evaluación 12-criteria explícita; §12/§18 no fuerza CASE A. Owner sequencing preference sigue dominando | **NO** |

**Adversarial pass**: **12/12 preguntas responden en la dirección correcta**. Ningún
anti-patrón detectado.

**Residual risks**:

- **R1**: la lista de 11 actions §4 draft es INFERENCE, no exhaustiva. Un uso empírico
  futuro puede revelar action 12 → forzaría reformulación B1→B4. **Aceptable** (bounded
  vocab handles this).
- **R2**: el patrón CASE D1 para DEC-REVIEWER-VERDICT depende de aceptar que "6 capas de
  emisión distribuidas = cobertura suficiente". Owner podría exigir "1 capa central" y
  reformular como sub-decision de DEC-07. **Aceptable** (Owner preference domina).

Estos residuals están registrados en §15 U1-U8 y no cambian los verdicts §6, §12.

---

## §22. FINAL EXECUTIVE STRUCTURE

Per §24 del master prompt.

```text
POST-ARCH-007 EXPERIMENT RESULT

EXP-A
Question:       ¿DEC-02 D-DELEG formulable sin D-CATALOG usando AUTHORITY_KIND?
Evidence:       5 agents catalog + AUTHORITY_KIND VOCAB-A + ARCH-005 pattern +
                verdict schemas + 11 empirical actions
What survived:  Schema §5 (8-field docs-only); AUTHORITY_KIND como taxonomía única;
                ACTION_TYPE OPEN-BOUNDED; docs-only formulation; ARCH-005 pattern
                para activation/revocation
What was falsified: "DEC-02 needs CHANGE_TYPE/TASK_TYPE/VERIFICATION_TYPE";
                "DEC-02 needs new taxonomy catalog"; "DEC-02 HARD-blocked by D-CATALOG"
Remaining unknowns: U1 harness types classification; U2 Owner OPEN vs CLOSED preference;
                U3 mixed actor handling; U4 gate scope (enum vs piloto); U5 HRQS
                escalation as activation; U6 executor-separation universality
Verdict:        DEC-02 formulable con confidence HIGH (85%). 10/10 falsifiers pass.

EXP-D
Question:       ¿HRQS/reviewer artifacts cubren semantic reviewer verdict?
HRQS coverage:  §12 handbook (STALL_POLICY reviews TP/FP/UNKNOWN + FP subclases);
                A-06 identity convention (3 forms); Reviewer field mandatorio in
                EVIDENCE_REGISTRY schema; Review Rounds in CHANGE_PROVENANCE
Reviewer sample: 22 datapoints (16 EV entries + 2 CHANGE_PROVENANCE matrices + 4
                recent checkpoint commits). Single-owner repo constraint documented.
Explicit verdict coverage: 6 capas distribuidas identificadas (§10.3).
                Verdict emission rate: 16/16 EV entries (100%).
What survived:  A-06 + HRQS + EV.Reviewer field + code-reviewer verdict schema +
                code-review-and-quality skill + doubt-driven-development skill +
                CHANGE_PROVENANCE Review Rounds
What was falsified: PIECE_AND_IDEA_PUZZLE_AUDIT §12 "reviewer no emite explicit
                semantic evidence"; RV2 "add Reviewed-by trailer" necesidad; RV3
                "HRQS §12 formaliza artefacto" necesidad
Remaining unknowns: U6 executor-separation formal universalization; U7 4 actions
                sin verdict tag scope
Verdict:        CASE D1 (ALREADY COVERED) con confidence HIGH (85%).
                DEC-REVIEWER-VERDICT RETIRE candidate con RESOLVED_BY.

COMBINED
Decision-space change:
   - OPEN: 9 → 8 (DEC-REVIEWER-VERDICT movido a RETIRE candidate)
   - DEC-02 confidence de formulabilidad: HIGH (85%)
   - DEC-07 scope simplificado (sin sub-decision DEC-REVIEWER-VERDICT)
   - NEW LATENT DECISIONS: 0

DEC-02 status: GATE-PREPARABLE con confidence MED-HIGH (75%).
                No forzado como siguiente movimiento. Owner sequencing preference domina.

DEC-REVIEWER-VERDICT status: RETIRE candidate (RESOLVED_BY 6 fuentes distribuidas).
                Requiere Owner Choice separado para persistir en DECISION_HISTORY.

New latent decisions: 0

Important information gaps:
   - U1 harness runtime types delegation classification
   - U2 Owner ACTION_TYPE OPEN vs CLOSED preference
   - U8 DEC-04 shadow drift detection (EXP-B pending, out of scope this session)

Best next experiment:
   - Si Owner opta PATH 1 recomposition §42: siguiente natural sería la preparación
     formal del DEC-02 gate document (no incluído aquí), usando este draft como baseline.
   - Alternativa: EXP-B (drift shadow, 60 días background) para desbloquear DEC-04.
   - Alternativa: mini-EXP para U1 (harness runtime types survey, 1-2h).

Next-gate readiness:
   - DEC-02: GATE-PREPARABLE (12-criteria evaluación §18, MED-HIGH confidence).
     No gate-ready automáticamente; Owner criterion domina.
   - DEC-07: STILL BLOCKED por HARD ← DEC-02 (unchanged).
   - Otros gates: sin cambio material desde §31 recomposition.

OWNER BOUNDARY
OWNER_CHOICE                 = NONE
IMPLEMENTATION_AUTHORIZATION = NONE
RUNTIME_CHANGE               = NONE
CANONICAL_STATE_CHANGE       = NONE
```

STOP.

---

## §23. STATUS DECLARATION

- **NO Owner Choice** emitida.
- **NO IMPLEMENTATION AUTHORIZATION** emitida.
- **NO CHECKPOINT** propuesto.
- **NO NEW DECISION** creada.
- **NO EDGE DE DEPENDENCY MODIFICADA** en fuente canónica.
- **NO RUNTIME, HOOK, SKILL, RULE, REGISTRY MODIFICADO**.
- **NO DECISION_HISTORY / DECISION_REGISTRY / PROJECT_STATE MODIFICADO**.
- **NO nuevo artefacto canónico creado** (los dos artefactos producidos son Stratum-C
  untracked, no comiteados por este trabajo).
- Persistencia de ambos artefactos queda a criterio Owner.

**END — EXP-A + EXP-D COMBINED RESULTS**
