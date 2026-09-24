# 02 — INDEPENDENT RECONSTRUCTION

> Reconstrucción del sistema **desde las fuentes primarias**, con nomenclatura histórica
> silenciada. Objetivo (§8 del prompt): describir lo que existe si se prohíben las palabras
> `F1..F9`, `M001..M008`, `PAC`, `READY-01..04`, `R1..R5`, `CAP-1..CAP-5`, `T8`, `ARCH-NNN`,
> `INV-N`, `H-01`, `LABYRINTH`.
>
> Los términos se restablecen sólo en §7, para poder comparar contra Kimi/Claude.

---

## 1. Cómo se hizo esta reconstrucción

- Se enumeraron los **archivos ejecutables** del control plane: hooks (`.claude/hooks/*.sh`,
  10 scripts + lib), skills (`.claude/skills/`), settings (`.claude/settings.json`), agents
  (`.claude/agents/*.md`) y rules (`.claude/rules/*.md`).
- Se enumeraron los **artefactos gobernados**: `PROJECT_STATE.md`, `DECISION_REGISTRY.md`,
  `EVIDENCE_REGISTRY.md`, `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl`,
  `docs/00_SYSTEM/CLAUDE_SESSION_LOG.md`, `evals/maintenance.sh`.
- Se observó el comportamiento reproducible con `bash evals/maintenance.sh` y con
  `wc -l`, `grep`, `jq` sobre el log real.
- Se examinó el **grafo de invocación entre hooks y su producto** para no describir
  intenciones documentales.
- Sólo lo que puede **derivarse de un archivo o de la salida de un comando** entra en la
  reconstrucción. Nombres inventados por la historia — o por las investigaciones anteriores —
  no aparecen hasta §7.

---

## 2. Componentes ejecutables observables

Los archivos ejecutables del control plane forman un grafo con estos nodos (nombres neutros):

```text
BLOCKER-BEFORE-BASH          .claude/hooks/bash-firewall.sh                (PreToolUse Bash)
BLOCKER-SECRET               .claude/hooks/secret-guard.sh                  (PreToolUse Bash/Read/Edit)
GATE-BEFORE-TASK-CLOSURE     .claude/hooks/task-completed-evidence.sh       (SubagentStop)
LOG-COMPACT-BEFORE           .claude/hooks/pre-compact-snapshot.sh          (PreCompact)
LOG-CONFIG-CHANGE            .claude/hooks/config-change-logger.sh          (PostToolUse Edit/Write)
LOG-STOP                     .claude/hooks/stop-logger.sh                   (Stop)
LOG-SUBAGENT-STOP            .claude/hooks/subagent-stop-logger.sh          (SubagentStop)
CONTEXT-SESSION-START-A      .claude/hooks/session-start-compact.sh         (SessionStart compact)
CONTEXT-SESSION-START-B      .claude/hooks/session-start-startup.sh         (SessionStart startup/resume/clear)
CONTEXT-SUBAGENT             .claude/hooks/subagent-context.sh              (SubagentStart, per-role)
LIB-EVENT-EMISSION           .claude/hooks/lib/stall-record.sh              (invoked from BLOCKERs)
```

Total: **10 hook scripts + 1 lib** = 509 líneas (`wc -l .claude/hooks/*.sh
.claude/hooks/lib/*.sh`).

### 2.1 Función observable de cada nodo (desde el propio código)

- **BLOCKER-BEFORE-BASH**: interpreta un JSON en stdin, extrae el comando, evalúa
  regexes/patrones ("supply chain curl|bash", "rm -rf /", "DROP DATABASE", etc.),
  invoca `LIB-EVENT-EMISSION` cuando decide bloquear, y sale `exit 2` para
  denegar. `exit 0` para permitir. No firma nada.
- **BLOCKER-SECRET**: para Bash/Read/Edit, evalúa acceso a `.env`, `*.pem`, `*.key`,
  `~/.ssh/*`, `~/.aws/credentials`; deniega vía `exit 2`.
- **GATE-BEFORE-TASK-CLOSURE**: al final del subagente, exige que el evento traiga
  `task_id + contract_hash + artifact_hash`; si falta, emite evento vía
  `LIB-EVENT-EMISSION` y bloquea el cierre.
- **LIB-EVENT-EMISSION**: emite un objeto JSON al `STALL_POLICY_LOG.jsonl` con un
  schema fijo: `schema_version, event_id, timestamp, source_hook, decision, stall_type,
  policy_category, action_hash, task_id, session_id, notes, had_alternative`.
  El campo `had_alternative` está **hard-coded a `null` en la línea 46**.
  El campo `session_id` se pasa como `""` por todos los callers y se convierte a `null`
  por la propia función.
- **LOG-***: escriben en `CLAUDE_SESSION_LOG.md` u otros logs; no bloquean.
- **CONTEXT-SESSION-START-A/B**: en el arranque de sesión, imprimen en stdout el
  contenido de `PROJECT_STATE.md` + `DECISION_REGISTRY.md` (formato condensado) para
  reinyectar contexto en la conversación.
- **CONTEXT-SUBAGENT**: al arrancar un subagente, imprime en stdout un pack de
  contexto derivado de `.claude/context/*.md` filtrado por `role`.

### 2.2 Artefactos gobernados observables

```text
STATE-MASTER                 PROJECT_STATE.md
DECISIONS-MASTER             DECISION_REGISTRY.md
EVIDENCE-MASTER              docs/00_SYSTEM/EVIDENCE_REGISTRY.md
EVENT-STREAM                 docs/00_SYSTEM/STALL_POLICY_LOG.jsonl
SESSION-STREAM               docs/00_SYSTEM/CLAUDE_SESSION_LOG.md
RUNBOOK-SUITE                evals/maintenance.sh (+ subchecks)
CONTEXT-PACK                 .claude/context/*.md
POLICY-TEXTS                 .claude/rules/*.md
POLICY-PROTO-YAML            docs/research/pac/ccp_policies.yaml
POLICY-COMPILER-PROTO        docs/research/pac/compile_policies.sh
INDEX-PLAN                   docs/MASTER_IMPLEMENTATION_PLAN.md
INDEX-MANIFEST               ARTIFACT_MANIFEST.md
```

### 2.3 Agentes

10 agents en `.claude/agents/`: `architect`, `implementer`, `code-reviewer`, `researcher`,
`security-auditor`, `Plan`, `Explore`, `general-purpose`, `claude`, `claude-code-guide`,
`statusline-setup`. Cada uno tiene una función delegada por el runtime; ninguno modifica los
artefactos del control plane sin pasar por los hooks.

---

## 3. Grafo de dependencias observable

```text
BLOCKER-BEFORE-BASH ──emits──▶ LIB-EVENT-EMISSION ──writes──▶ EVENT-STREAM
BLOCKER-SECRET       ──denies──▶ (no emission)
GATE-BEFORE-TASK-CLOSURE ──emits──▶ LIB-EVENT-EMISSION ──writes──▶ EVENT-STREAM
                          ──gates──▶ (Task cannot close without contract_hash+artifact_hash)
LOG-* ──writes──▶ SESSION-STREAM
CONTEXT-SESSION-START-* ──reads──▶ STATE-MASTER + DECISIONS-MASTER
CONTEXT-SUBAGENT ──reads──▶ CONTEXT-PACK
RUNBOOK-SUITE ──reads──▶ EVIDENCE-MASTER, STATE-MASTER, DECISIONS-MASTER, hooks
```

Observaciones directas del grafo:

- Sólo dos scripts **escriben** en el stream de eventos (BLOCKER-BEFORE-BASH y
  GATE-BEFORE-TASK-CLOSURE); todos los demás nodos son observadores o inyectores de contexto.
- Ningún script del control plane **lee** el EVENT-STREAM para tomar decisiones. El log es
  **write-only from the runtime's perspective**; su consumo es humano/CI.
- El único bloqueo runtime del cierre de tarea vive en GATE-BEFORE-TASK-CLOSURE +
  presencia de `contract_hash` + presencia de `artifact_hash`.
- No hay bucle de control automático: no existe un componente que lea el EVENT-STREAM y
  genere una política, un incidente o una decisión.

---

## 4. Máquina de estados observable de una tarea

Reconstruida a partir de los hooks + registries:

```text
[proposed]  ── no artifact ──┐
                             ▼
[executing] ── PreToolUse denied ──▶ [blocked] ──▶ event in EVENT-STREAM
             │
             ├── PostToolUse ──▶ nothing formal happens
             │
             ▼
[claimed complete] ─── SubagentStop ──▶ GATE-BEFORE-TASK-CLOSURE
                                          │
                                          ├── contract_hash+artifact_hash ok ──▶ [closed]
                                          │
                                          └── else ──▶ event + reject stop ──▶ still [claimed]
```

Un `[closed]` requiere que el agente pase por el gate; ningún otro path lo cierra
mecánicamente. El paso de `[claimed complete]` a `[closed]` es donde el sistema fabrica su
única garantía técnica: sin `contract_hash` o `artifact_hash`, no se puede terminar.

## 5. Flujo de información observable

```text
                        USER INTENT
                             │
                             ▼
                CONVERSATION IN SESSION                 (rendered by runtime)
                             │
                             ▼
           TOOLS INVOKED     ────▶  PreToolUse HOOKS  ──▶  BLOCK or ALLOW
                             │             │
                             ▼             ▼
                     TOOL EXECUTED     EVENT-STREAM (if blocked)
                             │
                             ▼
                        TASK COMPLETION CLAIM
                             │
                             ▼
                  SubagentStop HOOK GATE
                             │
                             ▼
          EVIDENCE-MASTER (task_id + contract_hash + artifact_hash)
                             │
                             ▼
                    Human review of the diff
                             │
                             ▼
                   Commit + Update STATE-MASTER
```

Puntos donde la información se transforma:

- **Intent → Tool call**: transformación no observable por el control plane; ocurre en el LLM.
- **Tool call → Block/Allow**: transformación gobernada por regex/patrones en BLOCKER-*.
- **Block → Event**: pérdida de contexto **irreversible** — el evento sólo captura
  `action_hash` (SHA-256 del comando) y `notes`; no captura la intención ni la alternativa.
- **Claim → Evidence**: exige `contract_hash` y `artifact_hash`; captura *qué* se hizo pero
  no *por qué* (eso vive en la conversación, no en el artefacto).
- **Evidence → Commit**: intervención humana; el reviewer humano es el único agente que
  correlaciona intención, ejecución y evidencia.

**Pérdida de información silenciosa observada** (§16 del prompt): entre `Block` y `Event`
se pierde la propuesta alternativa, y no existe un mecanismo mecánico que la registre.

---

## 6. Autoridad y trust

Reconstrucción sin usar el nombre "trust boundary":

- **Quien puede modificar `STATE-MASTER`**: cualquier tool que pueda editar Markdown;
  esto incluye el agente principal y cualquier subagente. La integridad se sostiene por
  `session-start-startup.sh` que **detecta drift** contra un hash esperado y advierte,
  pero no impide.
- **Quien puede modificar `EVIDENCE-MASTER`**: idem. No hay append-only enforcement
  técnico; sólo hay convención humana y advertencia por `pre-compact-snapshot.sh`.
- **Quien puede modificar `.claude/hooks/*.sh`**: cualquiera con acceso al repo. No hay
  autoridad interna; la única autoridad real es el reviewer humano en el commit.
- **Quien puede modificar `.claude/rules/*.md`**: cualquiera; no hay derivación desde
  ninguna canónica.
- **Quien puede modificar `.claude/settings.json`**: cualquiera; incluye `permissions` y
  `hooks`. El `config-change-logger.sh` deja rastro pero no impide.
- **Único gate técnico "duro"**: `GATE-BEFORE-TASK-CLOSURE`. Todo lo demás es
  observación o política humana.

**Conclusión desde el código, sin herencia**: la autoridad efectiva del sistema es un
grafo con dos únicas conexiones "duras" — bloqueo de tools peligrosas y bloqueo de cierre
sin evidencia — y todo lo demás es un contrato social con el reviewer humano como
único árbitro.

---

## 7. Reintroducción de nomenclatura histórica

Sólo ahora se comparan los nombres neutros con los históricos:

| Nombre neutro (§2)                | Nombre histórico                     |
|---|---|
| BLOCKER-BEFORE-BASH               | bash-firewall / P0                   |
| BLOCKER-SECRET                    | secret-guard / P0                    |
| GATE-BEFORE-TASK-CLOSURE          | Evidence Gate (F2/F8-A)              |
| LIB-EVENT-EMISSION                | stall-record.sh (R-2)                |
| CONTEXT-SESSION-START-*           | SessionStart context injection       |
| CONTEXT-SUBAGENT                  | ARCH-002 mechanism                   |
| STATE-MASTER                      | PROJECT_STATE.md                     |
| DECISIONS-MASTER                  | DECISION_REGISTRY.md                 |
| EVIDENCE-MASTER                   | EVIDENCE_REGISTRY.md                 |
| EVENT-STREAM                      | STALL_POLICY_LOG.jsonl               |
| RUNBOOK-SUITE                     | maintenance.sh                       |
| POLICY-TEXTS                      | .claude/rules/*.md                   |
| POLICY-PROTO-YAML/COMPILER-PROTO  | PAC prototype                        |

Coincidencias sustantivas:

- La clasificación de hooks P0/P1/P2 de Kimi mapea bien; no hay categoría "P0/P1/P2" en
  el código, pero la severidad efectiva (bloqueo vs. logging) sí es observable.
- La **capacidad "evidence-gated completion"** (INV-1 en el audit) corresponde 1:1 con
  GATE-BEFORE-TASK-CLOSURE.
- La **capacidad "fail-closed"** (INV-2) corresponde a la política del BLOCKER-* (todo hook
  P0 sale `exit 2` ante ambigüedad).
- La **capacidad "PROJECT_STATE authority"** (INV-3) NO tiene enforcement técnico duro,
  sólo drift detection en el SessionStart.
- La **"human trust boundary"** de Kimi corresponde a la observación §6: no existe
  autoridad interna más allá del reviewer humano.

Divergencias sustantivas:

- Los nombres "P0/P1/P2" agrupan por severidad pero **oscurecen que las funciones
  son distintas** (bloqueo, logging, contexto). Una taxonomía por función (§2) es
  más útil para razonar sobre reemplazos.
- La palabra "trust boundary anidada" (Kimi 09 §1) **no aparece como estructura** en la
  reconstrucción neutra. Lo que sí aparece es una topología **estrella**: dos hooks-P0
  hacia el usuario, un gate hacia el subagente, y todos los demás observadores emitiendo
  hacia streams read-only-by-humans. Ningún subagente verifica a otro subagente. La
  metáfora "anidada" sugiere niveles de confianza jerárquicos; el código muestra un único
  árbitro (humano) y muchos productores paralelos.
- La palabra "governance compiler" no tiene referente físico; el prototipo PAC existe
  pero está en `docs/research/`, no en el control plane runtime.

---

## 8. Reconstrucción alternativa por relaciones (§159 del prompt)

Silenciando también los nodos, empezar por relaciones:

```text
Relations observed:
  denies(hook, action)               → BLOCKER-BEFORE-BASH, BLOCKER-SECRET
  emits(hook, event)                 → LIB-EVENT-EMISSION
  gates(hook, close)                 → GATE-BEFORE-TASK-CLOSURE
  writes(hook, log)                  → LOG-*
  reads(hook, state)                 → CONTEXT-SESSION-START-*
  reads(hook, context-pack)          → CONTEXT-SUBAGENT
  verifies(runbook, artifact)        → RUNBOOK-SUITE
  updates(human, state)              → out-of-hook, in commit
  reviews(human, diff)               → out-of-hook, in commit
  authorizes(owner, decision)        → out-of-hook, in registry
  produces(agent, artifact)          → tool execution
```

Nodos que emergen:

```text
Actors: {agent, subagent, human-reviewer, owner}
Interfaces: {tool-invocation, task-close, session-start, subagent-start, commit}
Persistent stores: {state, decisions, evidence, events, session-log,
                    policy-texts, policy-proto-yaml}
Transforms: {block, allow, emit, gate, write, verify, review, authorize, update}
```

**Interfaces son la parte más informativa.** Toda garantía técnica del sistema vive en:

- `tool-invocation` (interceptada por BLOCKERs),
- `task-close` (interceptada por GATE),
- `commit` (interceptada por el reviewer humano).

Todo lo demás son **observaciones o contexto**. Esto vuelve más natural la afirmación §158
del prompt: la arquitectura efectiva de CCP puede describirse mejor por sus **interfaces**
que por sus componentes. Los componentes son intercambiables; las interfaces no lo son.

---

## 9. Reconstrucción alternativa por eventos (§160)

Eventos observables:

```text
tool-attempt        → block / allow
task-close-attempt  → block / allow
subagent-start      → context injected
session-start       → state read, drift check
config-edit         → log
compact-boundary    → snapshot
```

Cada evento tiene:

- Un productor (agente humano-through-LLM o subagente).
- Un decisor (BLOCKER/GATE/LOG hook).
- Un efecto persistente (evento en stream o log line).
- Un consumidor (humano, CI, o nadie).

El **catálogo de eventos es finito y estable**. La arquitectura por eventos sugiere que
CCP es una máquina que reacciona a 4–6 tipos de evento y produce artefactos observables.
No hay evento del tipo "evidence dispute", "policy proposal", "hypothesis update" —
categorías que la investigación previa nombra pero que el código no observa como evento.

---

## 10. Reconstrucción alternativa por estado (§161)

Estados observables del **sistema** (no del agente):

```text
INITIAL / STABLE     → maintenance PASS, state unchanged, no new events
DRIFT-DETECTED       → session-start-startup found hash mismatch
BLOCKED-ACTION       → hook denied; stream has new event
TASK-BLOCKED         → GATE denied close; stream has new event
STATE-DRIFT-WARN     → PROJECT_STATE integrity failed silently
CONFIG-CHANGED       → config-change-logger appended
COMPACT-BOUNDARY     → pre-compact-snapshot took snapshot
INCIDENT-OPEN        → EVIDENCE_REGISTRY has active INC (only INC-001 observed)
INCIDENT-CLOSED      → CTRL+REG+EV linked to INC
```

Estos estados **no se transitan por un componente controlador**; se transitan por escritura
directa a los artefactos. No hay una FSM implementada. La FSM es un patrón derivable de
observar cómo cambian los artefactos, no un objeto en el código.

**Conclusión sin herencia**: el "sistema de gobernanza" de CCP no es una FSM implementada.
Es un conjunto de artefactos y una convención humana sobre cómo transiten. La palabra
"invariant" pierde poder aquí: no hay un componente que ejecute la invariante; hay un
runbook (`maintenance.sh`) que la verifica *ex-post*.

---

## 11. Reconstrucción alternativa por decisiones (§162)

Decisiones observables (dónde el sistema pide autoridad a alguien):

```text
1. ¿Se permite este comando bash?             → BLOCKER-BEFORE-BASH (auto)
2. ¿Se permite este acceso a secretos?        → BLOCKER-SECRET (auto)
3. ¿Puede cerrarse esta tarea?                → GATE (auto, requires artifacts)
4. ¿Se acepta la evidencia?                   → human reviewer (no gate técnico)
5. ¿Se autoriza la próxima fase?              → owner (no gate técnico)
6. ¿Es válida la política actual?             → human (no gate técnico)
7. ¿Es materialidad para X unknown?           → owner (no gate técnico)
```

De 7 decisiones observables, **3 son automáticas** y **4 son humanas sin gate técnico**.
Esta observación **coincide con el audit** pero se establece aquí sin invocar
"trust boundary".

---

## 12. Reconstrucción alternativa por provenance (§128, §244)

Reconstruyendo el trayecto de una entidad "evidencia":

```text
task_id ── generado por el agente al abrir la tarea
      │
      ▼
contract_hash ── generado por el agente al declarar el contrato
      │
      ▼
artifact_hash ── generado por el agente al producir el artefacto
      │
      ▼
event enviado al SubagentStop hook
      │
      ▼
task-completed-evidence.sh valida presencia
      │
      ▼
si válido → task cierra; el HUMANO debe registrar la EV en EVIDENCE_REGISTRY.md
      │
      ▼
HUMAN commit
```

**Provenance break observada**: entre "task cierra" y "EV registrado" hay una discontinuidad.
El hook no escribe en `EVIDENCE_REGISTRY.md`; el humano lo hace. Si el humano olvida
registrar la EV, la task está cerrada pero la evidencia canónica no existe. Esto es un
**hueco de provenance humano-mediado** que ninguna nomenclatura previa nombra directamente.

Reconstruyendo el trayecto de una entidad "policy":

```text
Human writes .claude/rules/*.md          ── source of intent (informal)
     │
     ▼
Human edits bash-firewall.sh regexes     ── enforcement encoding
     │
     ▼
Human runs maintenance.sh                ── verification
     │
     ▼
Human commits                            ── frozen at HEAD
```

**No hay derivación mecánica** entre `.claude/rules/*.md` y `bash-firewall.sh`.
Ninguna estructura garantiza que el texto de `.claude/rules/no-go.md` y las regexes en
`bash-firewall.sh` describan el mismo conjunto de acciones prohibidas. Esta es la
**"duplicación" que la investigación previa observa**. La reconstrucción neutra la
identifica como una **ausencia de derivación**, no como un fenómeno accidental.

---

## 13. Modelo mínimo que emerge

Silenciando toda nomenclatura, el sistema que emerge es:

```text
CCP  =  ( 3 INTERFACES técnicas )     — tool-invocation, task-close, session-start
     +  ( 2 hard technical gates )    — BLOCKER-*, GATE-BEFORE-TASK-CLOSURE
     +  ( 1 event stream, write-only ) — EVENT-STREAM
     +  ( N artefactos gobernados por convención humana )
     +  ( 1 verificador ex-post )     — RUNBOOK-SUITE
     +  ( 1 árbitro final )           — reviewer humano en el commit
```

Esta es la parte **reproducible** del sistema. Todo lo demás —incluido "learning loop",
"trust boundary anidada", "governance compiler", "evidence-as-core"— es una **narrativa
sobre estos elementos**, no un elemento en sí.

Este modelo es intencionalmente austero. Lo que sobrevive va al `03_STRUCTURAL_DISCOVERY`
como punto de partida honesto. Lo que la investigación previa añadió será examinado uno por
uno ahí para determinar si es descubrimiento estructural o interpretación.

---

## 14. Discrepancias importantes con las descripciones previas

Observadas sin herencia, hay tres discrepancias que no se pueden reconciliar cambiando de
palabras:

1. **"Trust boundaries anidados" vs. "estrella con humano-sink"**. El código muestra que no
   hay agentes que verifiquen a otros agentes ni gates que verifiquen a otros gates. Todos
   los productores emiten hacia el mismo árbitro (humano). Esto es una topología **estrella**,
   no una jerarquía anidada. La palabra "anidada" es una imposición interpretativa.

2. **"Sistema de gobernanza como FSM"**. No hay FSM implementada. La FSM es una lectura
   *ex-post* del comportamiento agregado del sistema. Esto es importante porque implica que
   los invariantes técnicos verdaderos (INV-1, INV-2, INV-3, INV-7) son un subconjunto muy
   pequeño de las propiedades declaradas.

3. **"Missing piece = motor de derivación de política"**. La reconstrucción muestra que **ya
   hay** dos fuentes de política (textos y regex) y que la derivación entre ellas es humana.
   Introducir un "motor" es una elección de implementación de una capacidad ausente
   ("derivación mecánica desde una fuente canónica"), no la revelación de una pieza faltante.
   La pieza faltante no es un motor; es la **canónica sola**. Un motor sólo se necesita si
   ya se decidió que la canónica es la YAML.

Estas tres discrepancias son insumo directo del `03_STRUCTURAL_DISCOVERY`.

---

## 15. Lo que la reconstrucción independiente no puede resolver

Los siguientes puntos requieren fuentes fuera del código:

- **Por qué existe la duplicación política**: la reconstrucción sólo muestra que existe.
- **Por qué el `had_alternative` está hardcoded a null**: la reconstrucción muestra que
  lo está y que es intencional (el comentario del hook lo declara), pero no explica la
  decisión.
- **Cuál es la política operativa sobre "qué cuenta como incident"**: no hay archivo que lo
  defina. Sólo hay 1 INC (INC-001), que es evidencia negativa insuficiente.
- **Cuál es la definición de "materialidad" para triggers deferidos**: no aparece en
  ningún archivo.

Estos son UNKNOWN estructurales que el resto de K3 debe tratar como abiertos.

---

**Parada**. Lo siguiente es `03_STRUCTURAL_DISCOVERY.md`.
