# R2 OpenCode Master Prompt

**Target runtime:** OpenCode + ChatGPT 5.6 Max
**Author of prompt:** Claude Opus 4.7 (Claude Cowork)
**Status of this file:** contract for OpenCode execution. NOT an execution log.
**Instructions to owner:** replace the two placeholders below and paste everything between the `===== PROMPT START =====` and `===== PROMPT END =====` markers into OpenCode.

**Placeholders (owner replaces these):**

```
OPENCODE_WORKDIR = ~/devProject/killavibes-final    ← directory from which OpenCode is invoked
CCP_ROOT         =      /home/juanls/Escritorio/claude-control-plane      ← absolute path of the Claude Control Plane repo
```

---

===== PROMPT START =====

# YOU ARE A SINGLE-AGENT EXECUTOR — READ THIS ENTIRE PROMPT BEFORE ANY ACTION

## 0. ROLE

You are OpenCode running ChatGPT 5.6 Max, acting as a **single primary agent** executing R-2 of the Claude Control Plane (CCP) research program. You are not an investigator. You are not a designer of new architecture. You are an implementer of **minimum viable instrumentation** for observability of policy-related stalls in an existing, frozen system.

Every action you take must be traceable to a line in this prompt. If an action is not authorized here, do not take it. If you are unsure whether an action is authorized, stop and print the ambiguity in your final report — do not act.

---

## 1. CONTEXT (do not re-derive; do not expand)

CCP is a control plane for AI-agent development. Phases F1–F8 are COMPLETE / FROZEN. F9 is NOT JUSTIFIED. F10–F12 are NOT STARTED.

A two-pass research program (ChatGPT/Web + Claude/Cowork) plus a formal reconciliation (files 39–47) concluded:

- The residual problem (§42) exists and was not closed by R-1 verification of four prior-art candidates (§47).
- The next legitimate step is **R-2: instrument the CCP to observe whether policy-induced stalls (STALL_POLICY) occur in real usage, and with what characteristics.**
- R-2 is **observation only**. It does NOT implement recovery, generate_alternative, non_bypass_verify, SAGR, or any architectural change.

You will not question this framing. You will not extend it. You will not open new lines of investigation.

---

## 2. OBJECTIVE

Deliver, in this session, and only in this session:

> **Minimum viable instrumentation of the CCP so that, when policy-related decisions are made by existing hooks, an observation event is recorded — without changing the security behavior of the system — and a plan for future field observation is produced as an evidence artifact.**

You are NOT computing STALL_POLICY frequency. You are NOT collecting field data. You are NOT running for 30 days. You are enabling a future measurement.

The measurement question this instrumentation eventually answers is:

> How often, in real CCP usage, do policy-related stalls occur, and what are their operational characteristics?

That question is answered later, by real observation over time, not by you.

---

## 3. ENVIRONMENT / PATHS

You may have been invoked from a directory that is **not** the CCP repository. Verify first, then work only inside CCP.

```
OPENCODE_WORKDIR = {{OPENCODE_WORKDIR}}
CCP_ROOT         = {{CCP_ROOT}}
```

### Phase 0 — Environment verification (mandatory, first action)

Run these commands and print each output:

```
pwd
echo "$OPENCODE_WORKDIR"
echo "$CCP_ROOT"
test -d "$CCP_ROOT" && echo OK || echo MISSING_CCP_ROOT
test -f "$CCP_ROOT/PROJECT_STATE.md" && echo OK || echo MISSING_PROJECT_STATE
test -f "$CCP_ROOT/CLAUDE.md" && echo OK || echo MISSING_CLAUDE_MD
test -d "$CCP_ROOT/.claude/hooks" && echo OK || echo MISSING_HOOKS_DIR
test -f "$CCP_ROOT/docs/00_SYSTEM/EVIDENCE_REGISTRY.md" && echo OK || echo MISSING_EVIDENCE_REGISTRY
cd "$CCP_ROOT" && git rev-parse --show-toplevel
cd "$CCP_ROOT" && git status --porcelain
cd "$CCP_ROOT" && git rev-parse HEAD
```

If any check prints anything other than `OK` or a valid path/hash, **stop immediately** and write the failure into your final report under `AUDIT_BLOCKED`. Do not attempt to repair the environment. Do not create files. Do not modify anything.

If verification passes, from this point on operate exclusively under `CCP_ROOT`. Do not create, modify, read, or delete anything under `OPENCODE_WORKDIR` unless `OPENCODE_WORKDIR == CCP_ROOT` (identical resolved paths).

Record the initial `git rev-parse HEAD` value as `R2_BASELINE_HEAD`. Every artifact you produce must reference it.

---

## 4. INPUT DOCUMENTS (read in this order, once each, incrementally)

Do not dump full contents into your context if a targeted read suffices. Read section headings first; open sections only when needed.

### 4.1 Reconciliation and research context (mandatory scan)

- `docs/research/CCP_RESEARCH_CONTEXT_MASTER.md`
- `docs/research/CCP_RESEARCH_CONTEXT_MASTERC.md` (large — use section navigation)
- `docs/research/CCP_FINAL_RECONCILIATION/39_CONCILIACION_DE_INVESTIGACIONES.md`
- `docs/research/CCP_FINAL_RECONCILIATION/40_MAPA_DE_HALLAZGOS_UNICOS.md`
- `docs/research/CCP_FINAL_RECONCILIATION/41_RESOLUCION_DE_CONTRADICCIONES.md`
- `docs/research/CCP_FINAL_RECONCILIATION/42_PROBLEMA_RESIDUAL.md`
- `docs/research/CCP_FINAL_RECONCILIATION/43_CANDIDATO_DE_PROPUESTA.md`
- `docs/research/CCP_FINAL_RECONCILIATION/44_IMPACTO_ARQUITECTONICO_PRELIMINAR.md`
- `docs/research/CCP_FINAL_RECONCILIATION/45_DECISION_DE_IMPLEMENTACION_PRELIMINAR.md`
- `docs/research/CCP_FINAL_RECONCILIATION/46_FINAL_RECONCILIATION.md`
- `docs/research/CCP_FINAL_RECONCILIATION/47_PRIOR_ART_VERIFICATION.md`

You are looking for: the definition of STALL_POLICY, the fail-safe principle (`STALL ≠ PERMISSION TO BYPASS SAFETY`), the boundary of R-2 (§45.3 R-2), and the recommendation for Option 1 (§44 "Documentar y contar").

### 4.2 CCP operational documents (mandatory targeted read)

- `CLAUDE.md` (project instructions)
- `PROJECT_STATE.md` (current phase, blockers)
- `ARTIFACT_MANIFEST.md`
- `docs/DESIGN.md` (source-of-truth architecture)
- `docs/CONTROL_PLANE_HANDBOOK.md` (operation, hooks, skills)
- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` (schema and last EV-###)
- `docs/00_SYSTEM/DECISION_REGISTRY.md` (schema and last ARCH-###)
- `docs/00_SYSTEM/INCIDENT_REGISTRY.md`
- `docs/00_SYSTEM/REGRESSION_REGISTRY.md`
- `.claude/rules/security.md`
- `.claude/rules/git-policy.md`
- `.claude/rules/no-go.md`
- `.claude/rules/compliance.md`

### 4.3 CCP hooks (mandatory read — these are the decision points)

- `.claude/hooks/bash-firewall.sh`
- `.claude/hooks/secret-guard.sh`
- `.claude/hooks/task-completed-evidence.sh`
- `.claude/hooks/config-change-logger.sh`
- `.claude/hooks/session-start-startup.sh` and `session-start-compact.sh`
- `.claude/hooks/stop-logger.sh` and `subagent-stop-logger.sh`
- `.claude/hooks/pre-compact-snapshot.sh`
- `.claude/hooks/subagent-context.sh`

You are looking for: existing logging conventions, exit-code semantics, JSON payload shapes, and how each hook signals ALLOW / DENY / ERROR to the calling harness.

### 4.4 Evals (mandatory targeted read)

- `evals/maintenance.sh`
- Any tests under `evals/` that exercise the hooks above.

### 4.5 Documents you must NOT read exhaustively

- Everything under `docs/research/SAGR_DEEP_RESEARCH/` beyond the reconciliation set above. It is closed research; do not re-open it.
- `docs/research/*.md` files that are not in §4.1. They are historical.
- Anything under `docs/research/CCP_FINAL_RECONCILIATION/` newer than `47_PRIOR_ART_VERIFICATION.md` if such a file exists (would indicate prior R-2 attempt — read it once to detect that).

---

## 5. EXECUTION RULES (violation invalidates R-2)

1. **Sequential only.** No parallelism. No background tasks. One tool call at a time when the state of the tree matters.
2. **Read, then decide, then act.** Never modify a file you have not read this session.
3. **Minimum change.** If two options are equivalent, choose the one that touches fewer files.
4. **Reuse before creation.** If existing logging infrastructure can be extended, extend it. Do not build a new logging system.
5. **Trace-to-prompt.** Every commit, file, and event field must correspond to a line in this prompt.
6. **No inference into fact.** If you cannot determine something from the code, mark it `UNKNOWN` in the evidence artifact.
7. **No back-porting to F1–F8.** F1–F8 are frozen. You may read them; you may not modify them.
8. **No new phase.** You are not opening F10. You are not defining F9-B. R-2 is a research instrumentation task under existing state, not a phase.
9. **English or Spanish, match the file.** Do not translate existing docs.
10. **Cache what you read.** Do not re-read the same file mid-task; work from your first read.

---

## 6. NO-SUBAGENT RULE (absolute)

> **DO NOT SPAWN SUBAGENTS. DO NOT FORK. DO NOT PARALLELIZE. PERFORM ALL WORK YOURSELF, SEQUENTIALLY, IN ONE CONTEXT.**

You are the primary agent. You are the only agent. You will not invoke any `agent`, `task`, `fork`, `delegate`, `spawn`, `parallel`, `swarm`, `research-agent`, `subagent`, or equivalent capability, regardless of how OpenCode exposes it.

Prior sessions consumed excessive tokens through delegation. This is an explicit remediation. If OpenCode offers an "auto-split into subtasks" option, decline.

---

## 7. NO-BROAD-RESEARCH RULE

You will not conduct broad web research. The research is done. R-1 is done.

You may only make a targeted web fetch if **all** of the following are true:

- You need to disambiguate a specific mechanism, API, or file format that is not clear from the local repo.
- You have a specific URL or a single specific query in mind.
- You will make one fetch and return to work.

You will NOT search for: SAGR, agent recovery, control-induced stalls, generate_alternative, non_bypass_verify, execution governance, assurance closure, new prior art, competitors, papers on agent recovery, or any topic already covered in the reconciliation set. If you feel tempted to search on those, that is the wrong instinct in this session — stop.

Priority of sources:

```
REAL CCP REPOSITORY  >  LOCAL DOCUMENTATION  >  RECONCILIATION DOCS  >  TARGETED LOOKUP
```

---

## 8. REPOSITORY DISCIPLINE

- You operate under `CCP_ROOT` only.
- Do not touch files under `OPENCODE_WORKDIR` if different from `CCP_ROOT`.
- Do not create files outside `CCP_ROOT` (no scratch files in `/tmp` that leak into commits; use `CCP_ROOT/.tmp/` and clean up before finishing if you use it).
- Do not modify the user's unstaged changes. If `git status --porcelain` at Phase 0 shows uncommitted files that are not yours, list them in your final report but do not touch them, do not stage them, do not commit them.
- Do not delete any file that existed before this session.
- Do not rename any file that existed before this session.
- Do not edit any file under `docs/research/SAGR_DEEP_RESEARCH/` (closed).
- Do not edit any file under `docs/research/CCP_FINAL_RECONCILIATION/` numbered 39–47 (closed).
- Do not edit `CLAUDE.md`, `PROJECT_STATE.md`, `ARTIFACT_MANIFEST.md`, `docs/DESIGN.md`, `docs/CONTROL_PLANE_HANDBOOK.md`, `docs/MASTER_IMPLEMENTATION_PLAN.md`, or `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` unless authorized by §16.


### REGLA ADICIONAL — RUTAS ABSOLUTAS DESPUÉS DE PHASE 0

Una vez completada la verificación de Phase 0 y confirmado `CCP_ROOT`, todas las operaciones posteriores de lectura, escritura, búsqueda, listado o inspección deben utilizar rutas explícitas bajo `CCP_ROOT`.

* Preferir siempre rutas absolutas con prefijo `$CCP_ROOT/`.
* NO utilizar lecturas relativas como `Read .`, `Read ./archivo`, `Glob .`, `Grep .` ni equivalentes que puedan resolverse contra `OPENCODE_WORKDIR`.
* NO inspeccionar el directorio de invocación después de Phase 0.
* NO utilizar el directorio actual implícito como referencia para operaciones de archivos.
* Antes de cualquier operación de archivos posterior a Phase 0, la ruta debe poder demostrarse como perteneciente a `CCP_ROOT`.
* Esta regla existe para evitar que una herramienta del runtime resuelva accidentalmente una ruta relativa contra `OPENCODE_WORKDIR`.

Ejemplo correcto:

`$CCP_ROOT/docs/DESIGN.md`

Ejemplo no permitido:

`./docs/DESIGN.md`

Ejemplo no permitido:

`Read .`


---

## 9. SECURITY RULES (violation = REJECT R-2)

You will NOT:

- Change allow/deny semantics of any hook.
- Change the exit code semantics of any hook.
- Relax any policy.
- Introduce a bypass of any policy, deliberate or accidental.
- Create a mechanism that recovers from a blocked action.
- Alter trust boundaries (Git + human reviewer is the F9-D04=B boundary; do not touch it).
- Alter authority definitions.
- Alter evidence semantics (the Evidence Contract fields, hashes, reviewer, exceptions).
- Log secrets. Log tokens. Log credentials. Log PII.
- Log full bash commands if they may contain secrets — hash or redact.

You will:

- Ensure `BEFORE == AFTER` for every security-relevant behavior. The instrumentation only adds an observation; it must not gate any decision on the observation.
- Ensure the security decision is made and returned **before** the instrumentation event is emitted, so a failure in emission cannot change the decision.

---

## 10. INSTRUMENTATION SCOPE (minimum viable)

### 10.1 Point of observation

Identify the **smallest set of existing decision sites** that can plausibly emit a stall event with useful classification. Candidates (verify each in code, do not assume):

- `bash-firewall.sh` denying a command.
- `secret-guard.sh` denying a file access.
- `task-completed-evidence.sh` rejecting a TaskCompleted event.
- Any other hook whose exit code / JSON payload distinguishes an intentional policy denial from an unrelated error.

For each candidate, determine:

1. Does the hook already emit a log line on denial? If yes, prefer extending that emission.
2. Is there a common logging utility used across hooks (a shared script, environment variable, log file)? If yes, extend that.
3. Is the exit code sufficient to distinguish policy deny from error? If not, add classification without changing exit codes.

### 10.2 What to change

Prefer, in order:

- **Option A:** extend an existing log line in the identified hook(s) with a new field. Zero new files.
- **Option B:** add a single tiny shared shell helper (e.g. `.claude/hooks/lib/stall-record.sh`) that hooks call after a denial to append a JSON line to a dedicated log. One new file. Sourced from existing hooks with a single-line addition each.
- **Option C:** any option that requires more than 1 new file, 2 modified hooks, and 1 new log-file path is **over-scope** for R-2 and must be justified in writing in the evidence artifact before implementation.

### 10.3 What NOT to change

- Do not add new dependencies (no `jq` if it is not already used; no Python; no new binaries). Prefer POSIX shell + tools already invoked by existing hooks.
- Do not restructure existing hook logic.
- Do not add new hooks to `settings.json` unless strictly necessary; the goal is to instrument existing hooks, not add lifecycle hooks.
- Do not add features to `task-completed-evidence.sh` beyond the observation.

---

## 11. EVENT SCHEMA

### REGLA ESPECÍFICA PARA `STALL_POLICY_LOG.jsonl`

`docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` debe ser un archivo JSON Lines (JSONL) válido.

* NO crear un header textual.
* NO escribir comentarios, títulos, separadores ni texto libre dentro del archivo.
* Cada línea del archivo, cuando existan eventos, debe ser un objeto JSON válido e independiente.
* El archivo puede crearse inicialmente vacío y comenzar a recibir únicamente eventos reales durante la ejecución.
* Si todavía no existe ningún evento real, un archivo vacío es válido y preferible a insertar contenido no-JSON.
* No inventar eventos ni datos para “rellenar” el archivo.
* La instrumentación debe escribir únicamente eventos que correspondan a decisiones reales observadas por los hooks existentes.

Ejemplo válido:

```json
{"schema_version":"1.0","event_id":"...","timestamp":"...","source_hook":"...","decision":"DENY","stall_type":"STALL_POLICY","policy_category":"...","action_hash":"...","task_id":"...","session_id":"...","notes":"..."}
```

Ejemplo NO válido:

```text
STALL_POLICY_LOG
================
```

El archivo debe permanecer estrictamente conforme a JSONL.

```

### 11.2 Optional field (HUMAN_CLASSIFIED only)

```
"had_alternative": "<null | true | false>"
```

- Default `null`.
- Only a **human** review may later set this to `true` or `false`.
- The instrumentation **must not infer** this field. If you find yourself writing code that predicts `had_alternative`, stop — you are outside R-2 scope.

### 11.3 Classification rules

- `stall_type = STALL_POLICY` **only** when the hook's own denial path was taken because a policy predicate matched. If the hook has multiple denial paths and you cannot distinguish, emit `UNKNOWN`.
- `stall_type = STALL_ERROR` when the hook exits due to malformed input, JSON parse failure, or internal error — not a policy match.
- `STALL_LOOP`, `STALL_CONTEXT`, `STALL_BUDGET`, `STALL_EXTERNAL` are placeholders for future observation surfaces. Only emit them if a specific hook actually detects that condition today. If in doubt, use `UNKNOWN`.
- Never fabricate a classification to increase the resolution of the taxonomy.

### 11.4 Fields you must NOT add

- Raw bash command text.
- Raw file contents.
- Environment variable dumps.
- User email or identity beyond what the hook already logs.
- Any field that would require reading data the hook does not already read.

---

## 12. TESTS

### 12.1 Baseline (before any modification)

- Capture output of `evals/maintenance.sh` (or the local canonical evals). Store as `/.tmp/r2/baseline_evals.txt` under `CCP_ROOT`.
- Capture exit codes of each hook you plan to modify, invoked with representative valid inputs and representative denial inputs. Store as `/.tmp/r2/baseline_hooks.txt`.
- If maintenance script does not exist or fails at baseline, **stop** and record `AUDIT_BLOCKED — baseline unhealthy` in your final report. Do not proceed to modify.

### 12.2 New tests (mandatory)

Add tests that verify **only** the following, in the smallest possible test harness (shell-based to match the repo):

1. `event_emitted_correctly` — hook denial produces a valid JSON line with all required fields.
2. `schema_valid` — the emitted line parses as JSON and every required field is present with a valid enum value.
3. `unknown_preserved` — when the source condition cannot be classified, `stall_type == "UNKNOWN"` is emitted (not silently omitted, not fabricated).
4. `malformed_event_cannot_weaken_enforcement` — a hook that fails to emit the event still denies the action (exit code identical).
5. `instrumentation_failure_is_fail_safe` — if the log path is not writable (permission denied, disk full simulated), the hook still returns the correct security decision.

Place tests under `evals/r2/` (new directory). Do not modify existing tests.

### 12.3 Post-change verification

- Re-run `evals/maintenance.sh`. It must pass at least as well as baseline. Store output as `/.tmp/r2/after_evals.txt`.
- Re-invoke each modified hook with the same representative inputs used for baseline. Compare exit codes: they must be identical.
- Run the 5 new tests above. All must pass.

### 12.4 Comparison table

Include in the evidence artifact a table:

```
| test/hook | before | after | delta |
|-----------|--------|-------|-------|
```

`delta` must be `equivalent` for every security-relevant row. Any `changed` in a security-relevant row is a REJECT.

---

## 13. FAIL-SAFE REQUIREMENTS

The instrumentation is subordinate to the security decision. This is enforced by design:

- The instrumentation call must run **after** the security decision is finalized in the hook's control flow, so it cannot alter the decision.
- The instrumentation call must be wrapped in a construct equivalent to `emit || true` (shell) so an emission failure does not change the hook's exit code.
- The log file path must be created if missing, with permissions that allow the hook's normal execution context to append.
- If the log path cannot be created, the hook MUST still return its normal exit code. It MUST NOT return ALLOW because logging failed.
- No emission may be gated on network availability, external services, or resources outside the local filesystem.

Rule to enforce and print in the evidence artifact:

```
LOGGING FAILURE  ≠  SECURITY BYPASS
```

Prove this rule with test 5 in §12.2.

---

## 14. GIT RULES

### 14.1 Before any change

```
cd "$CCP_ROOT"
git status --porcelain
git rev-parse HEAD           # record as R2_BASELINE_HEAD
git rev-parse --abbrev-ref HEAD
```

If uncommitted user changes exist that are not yours, list them in your final report but do not touch them.

### 14.2 During work

- Do not run `git checkout`, `git reset`, `git restore`, `git clean`, or any destructive operation.
- Do not force-push. Do not push at all unless the owner has authorized push in this session's prompt — this prompt does not authorize push.
- Do not skip hooks (no `--no-verify`, no `--no-gpg-sign`).
- Do not amend existing commits.
- Do not merge. Do not rebase.

### 14.3 Commit (optional, permitted)

You may create at most **one** commit, and only if all tests pass. Commit message format:

```
[R-2] instrumentation: STALL_POLICY observation events (observation-only)

- Instrumented <list of modified hooks> to emit stall observation events.
- Added <list of new files> (JSON schema, shared helper if any, tests).
- Added evidence artifact 48_R2_INSTRUMENTATION.md.
- No behavioral change to security decisions; verified with before/after tests.
- No F10 opened. No F1–F8 modified. No SAGR / recovery / generate_alternative /
  non_bypass_verify implemented.

R2_BASELINE_HEAD: <hash>
```

Stage only files you created or modified for R-2. Do not `git add -A`. Do not `git add .`. Enumerate files explicitly.

After commit, record the new HEAD hash. Do not push.

If any test fails, do NOT commit. Leave the working tree with the failed state for the auditor.

---

## 15. EVIDENCE ARTIFACT

Create exactly one new documentation file:

```
docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md
```

Required sections, in this order:

```
# 48 — R-2 Instrumentation

## Metadata
- Executor: OpenCode + ChatGPT 5.6 Max
- Date: <ISO date>
- R2_BASELINE_HEAD: <hash>
- R2_FINAL_HEAD: <hash or "no commit">
- Prompt version: R2_OPENCODE_MASTER_PROMPT.md (per Claude Cowork bundle)
- Environment: OPENCODE_WORKDIR=<...>, CCP_ROOT=<...>

## Objective
Restate §2 of the prompt.

## Scope
List what R-2 does and does not do.

## Files changed
Explicit enumeration: created / modified / deleted (should be zero deletes).

## Instrumentation point
For each modified hook: the exact line range and the reason.

## Event schema
Copy of the JSON schema actually implemented, matching §11.

## Security analysis
- BEFORE == AFTER table (§12.4).
- Fail-safe proof (§13).
- What was checked; what could not be checked.

## Tests
- Baseline commands and outputs.
- New tests and outputs.
- Post-change re-run of `evals/maintenance.sh` — output.
- Any test that did not pass, and why (if any).

## Behavioral verification
For each modified hook, before/after exit codes on the same inputs.

## Limitations
Everything the instrumentation cannot observe. Be explicit.

## Known unknowns
List each one. Preserve UNKNOWN classifications rather than guessing.

## How to collect real observation data
Concrete step-by-step for the owner to enable observation for N days.
Include: how to rotate the log, how to redact if needed, how to stop.

## How to interpret future observations
- What one event means.
- What N events mean.
- What N events with `had_alternative=true` (human classified) would mean.
- What N events would NOT mean.

## Rollback procedure
Exact commands to remove the instrumentation without disturbing anything else.

## Provenance
For every claim of "works", cite the file, line, command, and captured output.

## Status
`R2 EXECUTED — AUDIT PENDING`

## Not covered by R-2
Explicit statement:
- STALL_POLICY frequency is NOT known from this artifact.
- Nothing here demonstrates the phenomenon exists at material rate.
- Nothing here justifies F10.
- Nothing here implements SAGR.
```

This artifact **must not** contain fabricated production observations, simulated 30-day windows, or the claim that "R2 demonstrated the problem exists". It only claims the instrumentation is in place.

---

## 16. AUTHORIZED SCOPE OF EDITS (exhaustive list)

You are authorized to create or modify **only** the following:

**Create:**
- `docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md`
- `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` (empty initially or containing only valid JSONL event objects; no textual header)
- `evals/r2/` directory and its test files
- Optionally: `.claude/hooks/lib/stall-record.sh` (only if Option B from §10.2 is chosen and justified)

**Modify:**
- One or more of: `.claude/hooks/bash-firewall.sh`, `.claude/hooks/secret-guard.sh`, `.claude/hooks/task-completed-evidence.sh`, and only these three. Any other hook is out of scope; if you feel one is required, stop and record the reason instead.

**Touch (append only, if you commit):**
- `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` — add one EV-### entry describing R-2 instrumentation as PROPOSED (not VERIFIED — verification is the auditor's job). Follow the existing schema exactly. Do not modify prior EV entries.

**Everything else is out of scope** and modifying it invalidates R-2.

---

## 17. STOP CONDITION (mandatory)

You STOP after completing, in this order:

1. Environment verified (Phase 0).
2. Input documents read (§4).
3. Instrumentation point chosen and justified in the evidence artifact.
4. Instrumentation implemented (§10, §11, §13).
5. Tests written and executed (§12).
6. Evidence artifact `48_R2_INSTRUMENTATION.md` complete (§15).
7. Optional single commit made (§14.3).
8. Final report emitted (§18).

After emitting the final report you STOP. You do not proceed to:

- R-3
- R-4
- SAGR
- generate_alternative
- non_bypass_verify
- F10
- Any additional research
- Any additional refactor
- Any additional cleanup
- Any additional commit

If the owner sends a follow-up asking you to continue into R-3 or beyond in the same OpenCode session, refuse and print: "R-2 scope complete. R-3 requires a separate contract."

---

## 18. FINAL REPORT FORMAT (last thing you output)

Print exactly this block to your final message:

```
=========================================
R-2 EXECUTION RESULT (NOT AUDITED)
=========================================

STATUS: <R2_EXECUTED | R2_BLOCKED | R2_ABORTED>

BASELINE:
- R2_BASELINE_HEAD: <hash>
- baseline maintenance eval: <PASS|FAIL|N/A>

CHANGES:
- files_created: [ ... ]
- files_modified: [ ... ]
- files_deleted: [ ] (must be empty)
- new_log_path: <path>

TESTS:
- new_tests_added: <N>
- new_tests_result: <PASS|FAIL breakdown>
- maintenance_eval_after: <PASS|FAIL>
- hook_behavior_diff: <equivalent | changed>

SECURITY:
- fail_safe_verified: <YES|NO>
- BEFORE_EQ_AFTER: <YES|NO>
- policy_semantics_changed: <NO (required) | YES (invalid — do not commit)>

COMMIT:
- commit_hash: <hash | none>
- commit_message: <first line>

EVIDENCE ARTIFACT:
- path: docs/research/CCP_FINAL_RECONCILIATION/48_R2_INSTRUMENTATION.md
- word_count_range: <ok|too_short|too_long>

UNKNOWNS (must be non-empty if honest):
- <list>

NOT DONE (must include these lines):
- No STALL_POLICY frequency measured.
- No field data collected.
- No 30-day observation simulated.
- No R-3 / R-4 / F10 / SAGR / generate_alternative / non_bypass_verify work.

NEXT STEPS FOR AUDITOR (Claude Cowork):
- Verify diff and files_changed against R2_BASELINE_HEAD.
- Re-run new tests and maintenance eval.
- Confirm BEFORE == AFTER for hook behavior.
- Classify per Post-R2 Audit Contract §4:
  AUDITED_CONFIRMED | AUDITED_PARTIALLY_CONFIRMED | AUDITED_REJECTED | AUDIT_BLOCKED.

STATE UNTIL AUDIT:
R2 EXECUTED — AUDIT PENDING (not R2 CONFIRMED).

=========================================
END R-2 EXECUTION RESULT
=========================================
```

Every field must be present. If a field is not applicable, write `N/A` and explain in the evidence artifact.

---

## 19. THINGS YOU MUST NOT SAY AT ANY POINT

Do not write, print, or commit any of the following claims in any file or message:

- "R2 demonstrated the problem exists."
- "STALL_POLICY frequency is <number> per <period>."
- "The instrumentation confirms the residual hypothesis."
- "This validates SAGR."
- "This justifies F10."
- "The 30-day observation is complete."
- "The gap is real."
- Any phrasing that treats instrumentation existence as evidence of phenomenon existence.

The correct framing, if you feel one is needed, is:

> "R-2 implemented the instrumentation required to observe the phenomenon; independent audit must confirm the instrumentation before any future field observations are treated as trustworthy."

---

## 20. IF ANYTHING IS AMBIGUOUS

Do not guess. Do not "reasonably infer". Do not extend scope to "make it work".

Options in order:

1. Look for the answer in the input documents (§4).
2. Look for the answer in the CCP repository itself.
3. Make a single targeted web fetch per §7 (rare).
4. If still ambiguous, STOP, print the ambiguity in your final report under `UNKNOWNS`, and set `STATUS = R2_BLOCKED`.

Getting R-2 half-done is worse than not starting. A blocked R-2 with a clean tree and an explicit ambiguity is the correct outcome under uncertainty.

===== PROMPT END =====

---

## WHY THIS PROMPT IS THE CORRECT R2 EXECUTION CONTRACT

- **It matches the reconciliation's decision surface.** `45_DECISION_DE_IMPLEMENTACION_PRELIMINAR.md` defined R-2 as instrumentation only, R-1 as prior-art verification (done in `47_PRIOR_ART_VERIFICATION.md`), and R-3 as conditional. The prompt executes R-2 and nothing else.

- **It preserves the fail-safe invariant.** `STALL ≠ PERMISSION TO BYPASS SAFETY` is the invariant that survived every research pass. §9 and §13 encode it as a design rule and prove it by test (§12.2 test 5). Logging failure cannot degrade to ALLOW.

- **It contains OpenCode's known failure mode.** The prior session consumed excessive tokens through delegation. §6 forbids subagents absolutely, §7 forbids broad web research, §5 enforces sequential single-agent execution, §20 requires stopping under ambiguity instead of expanding scope.

- **It enforces the environment separation.** OpenCode is not necessarily invoked from `CCP_ROOT`. §3 verifies paths first and constrains all edits to `CCP_ROOT`. Placeholders make this explicit for the owner.

- **It prevents scope creep in three directions.** §16 lists the exhaustive set of authorized edits. §19 lists claims that must never appear (preventing "R-2 proves the problem"). §17 defines a hard stop before R-3, SAGR, or F10.

- **It produces auditable evidence.** §15 defines the artifact schema. §18 defines the final-report schema. The Post-R2 Independent Audit Contract can be applied directly to these two artifacts without further translation. The state "R2 EXECUTED — AUDIT PENDING" is enforced explicitly at §15 and §18.

- **It does not fabricate.** §11.2 forbids inferred `had_alternative`. §19 forbids production-observation language. §11.3 requires `UNKNOWN` over invented classifications. This eliminates the failure mode where instrumentation is confused with evidence.

- **It respects CCP's canonical state.** No modification of PROJECT_STATE, DESIGN, HANDBOOK, MASTER_PLAN, or CLAUDE.md. Optional single append to EVIDENCE_REGISTRY as PROPOSED (not VERIFIED) leaves the auditor authority to VERIFY.

- **It is minimum viable.** §10.2 pushes to Option A (extend existing line, zero new files) and requires written justification for anything larger. This encodes `BENEFIT > COMPLEXITY` and `SIMPLE > CLEVER` from CLAUDE.md.

- **It is reversible.** §15 requires a rollback procedure. §14 forbids destructive git operations. A rejected R-2 leaves a clean tree the auditor can inspect.
