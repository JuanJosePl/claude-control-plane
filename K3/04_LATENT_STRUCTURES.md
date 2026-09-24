# 04 — LATENT STRUCTURES

> Variables latentes, estados ocultos, autoridades no nombradas, dependencias no
> declaradas. Cumple §14–§16 (latent hunt), §162 (decision-first view), §184 (dimension
> discovery), §244 (architectural memory).

---

## 1. Método

Para cada variable candidata se preguntó:

- ¿Qué fenómenos explica?
- ¿Dónde aparece indirectamente?
- ¿Quién la produce/consume/transforma?
- ¿Podría hacerse explícita? ¿Debería seguir derivada?

Sólo variables que aparecen indirectamente en ≥2 lugares independientes se registran.
El resto se descarta.

---

## 2. Variable latente 1 — `trust-in-agent-output`

### 2.1 Dónde aparece indirectamente

- **GATE-BEFORE-TASK-CLOSURE**: exige `contract_hash + artifact_hash` porque **no confía**
  en la palabra del agente.
- **BLOCKER-BEFORE-BASH**: exige regex explícito porque **no confía** en la
  interpretación del agente sobre "no destructive".
- **`code-reviewer` subagente**: existe como capa adicional porque **no confía** en el
  implementer.
- **Reviewer humano en el commit**: última instancia porque **no confía** en el
  code-reviewer.

### 2.2 Estado actual

Trust-in-agent-output es **cero por defecto** en CCP: todo output pasa por gate o revisión.
Esta política no está declarada; se **infiere** del comportamiento.

### 2.3 ¿Es una variable o una constante?

Es constante hoy (siempre 0). El sistema fue diseñado como si trust fuera
0 y todavía opera así. **No se ha declarado explícitamente**, pero es la
propiedad que hace que la topología estrella sea la única consistente.

### 2.4 ¿Debería hacerse explícita?

Sí. Formalizar `trust-in-agent-output = 0` como principio declarado (no como comportamiento
emergente) elimina la ambigüedad sobre cuándo, si nunca, cambiaría. Aparece como candidato a
principio explícito en `13_MASTER_OWNER_DECISION_SYSTEM`.

---

## 3. Variable latente 2 — `evidence-quality`

### 3.1 Dónde aparece indirectamente

- El GATE exige `contract_hash + artifact_hash` — trata la presencia como suficiente.
  **No hay noción de calidad**.
- `EVIDENCE_REGISTRY.md` tiene EV-001..EV-016 con "claim / observation / evidence" —
  el humano evalúa la calidad al aceptar/rechazar en revisión.
- F-FALSE_PASS-01 demostró que "presencia formal ≠ calidad": un agente puede firmar su
  propia evidencia. F8-A añadió `contract_hash` como contramedida sintáctica.

### 3.2 Estado actual

Evidence quality es **implícita**: `contract_hash + artifact_hash + human review` produce
una evidencia aceptada. No hay un score, un tier o una taxonomía de calidad.

### 3.3 ¿Es una variable?

Sí. Es binaria en el gate ("presente/ausente") y difusa en el reviewer humano
("suficiente/insuficiente"). No es observable ex-post.

### 3.4 Consecuencia

Cualquier claim que dependa de "cuántas evidencias fuertes tiene el sistema" no puede
responderse porque **la variable no existe formalmente**. Kimi/Claude cuentan "16 EV" —
pero ninguna EV tiene un score de calidad. El count trata a EV-006 (INC real) igual que a
EV-013 (log rotation).

---

## 4. Variable latente 3 — `provenance-depth`

### 4.1 Dónde aparece indirectamente

- El audit §6.4 nota: "código → comportamiento → doc F1-F9 → M001-M007 → Kimi → root
  claim" es una cadena de 5 pasos. Cada paso es una capa de derivación.
- Las EVs referencian claims que referencian código que referencia decisiones que
  referencian evidencia previa. Los grafos son deep.
- Ningún artefacto tiene un campo `derived_from: [list]`. La provenance se lee del texto.

### 4.2 Estado actual

Provenance-depth es **implícita en la estructura de referencias Markdown** y en git.
Ningún hook la mide; ningún runbook la calcula.

### 4.3 ¿Debería hacerse explícita?

**Débil**. Hacer explícita la depth añadiría metadatos a cada artefacto y requeriría un
compilador de dependencias. El coste es alto; el beneficio es visible sólo en decisiones
grandes. Para K3, se marca como **candidata a instrumentación pero baja prioridad**.

---

## 5. Variable latente 4 — `authorization-scope`

### 5.1 Dónde aparece indirectamente

- F9-D01 = "no autorizar nuevos cambios runtime" — un scope, no una decisión puntual.
- ARCH-001 = "proyecto-scoped" — un scope de instalación.
- READY-01..04 = "gate para 4 tipos de cambio".
- Comportamiento observable: cada tipo de cambio tiene un ámbito autorizado diferente,
  pero no hay tabla que los enuncie.

### 5.2 Autorizaciones observables por tipo

```text
Change type                    Authorization required           Currently open?
────────────────────────────────────────────────────────────────────────────────
Add regex to bash-firewall     Owner (READY-01 gate)            NO (pending)
Add hook to settings.json      Owner (READY-02 gate)            NO (pending)
Cerrar LABYRINTH-1             Owner (READY-03 gate)            NO (pending)
Cambiar formato de mensaje     Owner (READY-04 gate)            NO (pending)
Cambiar runtime post-F8        Owner (F9-D01, permanent)        Gate closed by default
Cambiar instrumentación STALL  ???                              UNKNOWN — no gate declared
Añadir agente                  ???                              UNKNOWN — no gate declared
Modificar canonical rules      ???                              UNKNOWN — no gate declared
```

**Hallazgo latente**: existen tipos de cambio (fila 6–8) que **no tienen gate declarado**.
El sistema opera "por convención" en esos casos. La decisión de qué gate debería
existir para cada tipo de cambio es un **decision-space no cartografiado**.

### 5.3 Verdict

`authorization-scope` es una variable latente de alto valor: descubrirla completamente
requeriría un catálogo de "types of change × required gates". Este catálogo **no existe**.
Su ausencia es un hueco de gobernanza.

---

## 6. Variable latente 5 — `reviewer-attention-budget`

### 6.1 Dónde aparece indirectamente

- HRQS es una checklist manual (M008). La existencia de la checklist implica que el
  reviewer humano estaba omitiendo pasos.
- La densidad de commits y la cantidad de research artifacts crece; no hay indicación de
  que el tiempo del reviewer haya crecido proporcionalmente.
- El audit §329 pregunta explícitamente si CCP está pagando "cost of documentation" en
  lugar de "cost of enforcement".

### 6.2 ¿Es medible?

Sí en principio (cronómetro por review); no en la práctica (no se mide).

### 6.3 Efecto estructural

Bajo la topología estrella, `reviewer-attention-budget` es **la variable escalar
dominante**. Si baja, la calidad de la CAP-2-semántica baja. Toda la protección semántica
del control plane depende de una variable que **no está siendo instrumentada ni gobernada**.

### 6.4 Verdict

Variable latente de alto valor. Candidata directa a hacerse explícita: un runbook simple
podría contabilizar reviews-pendientes y flag "budget exceeded". No requiere runtime
change (podría vivir en RUNBOOK-SUITE).

---

## 7. Variable latente 6 — `event-classification-backlog`

### 7.1 Estado actual

- 18 eventos en STALL log, 0 clasificados.
- HRQS §12 pide clasificación humana en la checklist, pero no hay campo en el JSONL
  (K3-D-SCHEMA).
- Ningún runbook cuenta "eventos pendientes de clasificación".

### 7.2 Efecto estructural

- Sin clasificación, cualquier análisis H-01 opera sobre datos no etiquetados.
- El backlog crece linealmente con el uso del sistema.

### 7.3 Verdict

Variable latente que **degrada silenciosamente el poder predictivo del sistema**. La
solución sintáctica (un campo `verdict:` en el JSONL) es baja fricción; la solución
semántica (política de clasificación) requiere D3 (§13 de `03`).

---

## 8. Variable latente 7 — `research-artifact-status`

### 8.1 Aparece indirectamente

- `docs/research/*` tiene 75 archivos; muchos son borradores, informes, dossieres,
  handoffs.
- `CCP_EXPLORATION_ENGINE.md` es un índice manual del research.
- No hay campo "status" en cada research artifact; el humano infiere del contexto.

### 8.2 Efecto estructural

- Un research artifact obsoleto puede seguir siendo referenciado por otro artefacto que
  se lee como actual. Esto crea drift epistemológico.
- El corpus crece; el humano decreasingly puede clasificarlo mentalmente.

### 8.3 Verdict

Variable latente de crecimiento no gobernado. Corresponde a K3-D-LIFECYCLE (`03 §10`).
Aparece como decision D5 en `03 §13`.

---

## 9. Variable latente 8 — `session-context-fidelity`

### 9.1 Aparece indirectamente

- El SessionStart hook inyecta un condensado de PROJECT_STATE + DECISION_REGISTRY.
- La recuperación post-compactación (visible en el mensaje inicial de esta sesión)
  reconstruye estado desde `PROJECT_STATE.md`.
- La cantidad de documentos "meta" (61_CCP_COMPLETE_HANDOFF.md, 61A..61G, ROOT_ANALYSIS,
  este mismo K3) sugiere que la fidelidad de contexto entre sesiones **no es perfecta**
  y se compensa con documentación creciente.

### 9.2 ¿Es una propiedad del sustrato o del control plane?

- Del **sustrato** (LLM sesiones tienen contexto acotado, se comprime, se pierde).
- El control plane responde con **reinyección de contexto** (SessionStart, SubagentStart).
- La meta-documentación crece porque la reinyección es incompleta.

### 9.3 Verdict

Variable latente exógena (viene del sustrato agente). La estructura del control plane
**absorbe** su efecto vía inyección + documentación. **Ningún hallazgo de K3 puede reducir
esta variable a cero** — es propiedad del sustrato.

**K3-D-EXOGENOUS**: la meta-documentación creciente no es un defecto arquitectónico del
control plane; es la respuesta racional a `session-context-fidelity < 1`. Un cambio de
arquitectura no la elimina; sólo un cambio de sustrato (LLM con memoria persistente
verificable) la reduciría.

---

## 10. Variable latente 9 — `governance-drift-rate`

### 10.1 Aparece indirectamente

- `session-start-startup.sh` calcula un hash sobre PROJECT_STATE.md y advierte si difiere
  del esperado. **Aparece drift regularmente** (STATE_INTEGRITY: DRIFT_DETECTED en la
  cabecera de esta sesión).
- El drift no bloquea; sólo advierte. El humano acepta o corrige.
- El log de drift no existe; el evento se muestra en pantalla y se pierde.

### 10.2 Efecto estructural

- La authority declarada de PROJECT_STATE.md se contradice con la frecuencia de drift
  observada.
- La actitud "drift → warn → human decides" es coherente con `trust-in-agent-output = 0`.

### 10.3 Verdict

Variable latente medible; actualmente no registrada. Su tasa a lo largo del tiempo es
información epistemológicamente valiosa (¿el sistema se estabiliza o se descontrola?)
que **el sistema no captura**.

---

## 11. Variable latente 10 — `decision-graduation-rate`

### 11.1 Aparece indirectamente

- READY-01..04 llevan pendientes desde M004 (según handoffs). No hay expiration.
- CDT-02, A-05, A-07, G-N5 están "diferidos hasta trigger" — trigger no definido
  mecánicamente.
- El `decision graduation` (paso de "pending" a "resolved") es humano y sin cadencia.

### 11.2 Efecto estructural

- Decisiones deferidas indefinidamente son equivalentes operativamente a "no existentes".
- Los diferimientos acumulados son deuda decisional.

### 11.3 Verdict

Variable latente que aparece en el "authorization backlog". Ninguna estructura la
mide. Aparece como parte del análisis en `11_ROOT_DECISION_ANALYSIS`.

---

## 12. Estados ocultos observables

Además de las variables, K3 identifica **estados del sistema que no son nombrados**:

### 12.1 Estado `STATE-DRIFT-WARN-UNSEEN`

Cuando el hash calculado por `session-start-startup.sh` difiere pero el usuario ignora la
advertencia. El sistema queda operando con drift no reconciliado hasta que alguien lo
corrija. No hay flag ni contador.

### 12.2 Estado `TASK-COMPLETED-EV-UNREGISTERED`

Cuando el GATE deja pasar el cierre pero el humano no registra la EV en
`EVIDENCE_REGISTRY.md`. Provenance break §12 de `02`. No hay verificación ni bloqueo.

### 12.3 Estado `POLICY-DIVERGENT`

Cuando `.claude/rules/*.md` cambia pero `bash-firewall.sh` no (o viceversa). El estado
divergente vive hasta la próxima revisión humana. `maintenance.sh` no lo verifica
semánticamente (sólo verifica que ambos existan y sean parseables).

### 12.4 Estado `RESEARCH-ARTIFACT-OBSOLETE-BUT-CITED`

Cuando un research artifact ha sido superado pero sigue siendo referenciado por otro
artefacto activo. Aparece en la cadena `Kimi 09 § convergencia parcial` → `audit
convergencia parcial` → `K3 rechaza convergencia estructural`. Cada capa cita la anterior
como si fuera actual.

### 12.5 Consecuencia

Cuatro estados sin gobernanza. Ningún hook los detecta. Ninguna variable los mide.
Su acumulación degrada la **fidelidad de la representación del sistema** sobre sí mismo.

---

## 13. Autoridades no nombradas

### 13.1 `authority-over-schema`

Quién decide qué campos existen en STALL_POLICY_LOG. No hay dueño declarado. Cambiar
`had_alternative` de constante a variable de input requeriría autorización, pero
**no está claro qué gate se aplica**. F9-D01 aplica a "runtime change" — ¿cambiar un
hook para instrumentar mejor cuenta como runtime change? Ambigüedad.

### 13.2 `authority-over-lifecycle`

Quién decide cuándo un research artifact es obsoleto. No hay dueño; el humano infiere.

### 13.3 `authority-over-authorization-scope`

Quién decide qué gates existen. Los READY-* fueron creados en handoffs específicos; no hay
mecanismo para "declarar un nuevo tipo de gate". La decisión D-catalog-of-gates (§5 aquí)
no tiene dueño.

### 13.4 Consecuencia

Autoridades no declaradas son un tipo especial de UNKNOWN: no es que "no sepamos la
respuesta"; es que **no sabemos a quién preguntar**. En una topología estrella, el default
es "el humano en el commit" — pero eso no escala.

---

## 14. Test contra la teoría "star topology" (K3-D-STAR)

De todo lo anterior:

- Variables latentes de alto valor (§6 reviewer-attention-budget, §9 session-context-fidelity,
  §11 decision-graduation-rate) todas dependen del mismo actor (humano-central).
- Estados ocultos (§12) todos requieren al mismo actor para transitar (humano-central).
- Autoridades no nombradas (§13) todas apuntan al mismo default (humano-central).

**Convergencia**: las 10 variables latentes, 4 estados ocultos y 3 autoridades no nombradas
identifican **al mismo cuello de botella**. Esto confirma K3-D-STAR y **agrega** que
"human as sink" no es sólo un patrón de arquitectura ejecutable — es también el default
para **todo lo que no fue formalizado**. La topología estrella no sólo describe el runtime;
describe la política de defaults.

---

## 15. Descubrimiento K3 — el "unknown owner problem"

Los §13.1, §13.2, §13.3 comparten forma:

```text
Existe una decisión.
No hay dueño declarado.
Cae por defecto al humano-central.
```

**K3-D-OWNER-DEFAULT**: **el default operativo de CCP es "si la decisión no está
formalizada, el humano-central la absorbe"**. Esto es una **política implícita de
absorción** que hace parecer que "el humano lo controla todo" — pero en realidad es que
"nada se ha delegado formalmente".

Consecuencia estratégica: **cualquier reducción de carga humana requiere primero delegar
explícitamente, no automatizar más**. La automatización sin delegación explícita crea
zonas grises donde el humano no sabe si debe intervenir o no. La topología estrella no se
rompe por añadir automatización; se rompe por **formalizar autoridad**.

---

## 16. Latent structure map

```text
                         REVIEWER-HUMANO-CENTRAL
                                  ▲
                                  │ absorbe todo lo no delegado
                                  │
    ┌─────────────────┬───────────┼───────────────────────────┐
    │                 │           │                           │
[V1: trust=0]  [V2: eviq]  [V3: prov-depth]  [V4: auth-scope]  [V5: attn]
    │                 │           │                           │
    │                 │           │                           │
[V6: cls-backlog] [V7: rsch-status] [V8: ses-fidelity] [V9: drift-rate] [V10: dec-grad]
    │
[Hidden states: DRIFT-UNSEEN, EV-UNREGISTERED, POLICY-DIVERGENT, RSCH-OBSOLETE-CITED]
    │
[Unnamed authorities: schema, lifecycle, gate-catalog]
```

Todas las hojas convergen al humano-central. No hay ninguna variable latente ni estado
oculto que se resuelva sin él bajo la arquitectura actual.

---

## 17. Verdict del capítulo

1. **10 variables latentes** identificadas y verificadas contra el código; 5 son de alto
   impacto (V1, V4, V5, V6, V9).
2. **4 estados ocultos** sin gobernanza; todos requieren al humano para transitar.
3. **3 autoridades no nombradas** cuya ausencia crea la política implícita de absorción
   por default (K3-D-OWNER-DEFAULT).
4. **K3-D-EXOGENOUS**: la meta-documentación creciente es la respuesta racional a la
   fidelidad de contexto sub-1 del sustrato; no es un defecto arquitectónico.
5. **La topología estrella se refuerza**: no sólo describe el runtime; describe la
   política de defaults.

Insumo directo para `05_CAUSAL_MODEL` (cadenas de compensación) y
`13_MASTER_OWNER_DECISION_SYSTEM` (decisiones de delegación explícita).
