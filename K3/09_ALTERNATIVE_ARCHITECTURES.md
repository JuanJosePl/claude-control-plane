# 09 — ALTERNATIVE ARCHITECTURES

> Arquitecturas competidoras genuinamente distintas, no meras variaciones. Cumple §101,
> §102 (no "best architecture"), §207 (rivalry), §229 (third option). Cada una descrita
> por lo que optimiza y por lo que sacrifica.

---

## 1. Reglas

- Cada arquitectura debe **satisfacer las constraints observables** de CCP:
  proyecto-scoped, provider-independent en el runtime, git como substrate, humano
  presente como reviewer/owner disponible.
- Cada arquitectura debe **explicar** los fenómenos actuales o **eliminarlos por
  diseño**.
- No hay "mejor". Se presentan trade-offs.

---

## 2. Arquitectura A — "Statu Quo Formalizado"

**Idea core**: mantener la topología estrella actual y **formalizar** las autoridades
implícitas + convenciones latentes, sin añadir automatización nueva.

### Capabilities

- CAP-2-sintáctica (hooks, actual).
- CAP-2-semántica (humano, actual).
- CAP-3 (git + registries, con brechas cerradas por convención declarativa).
- GAP-1 no cerrado; se acepta duplicación con revisión periódica.
- POL-LATENT-5 se formaliza como policy (política de "qué es incident" declarada;
  cadencia de HRQS).

### Control flow

- Idéntico al actual: pre-tool blocker → tool → post-close gate → human review commit.

### State model

- Idéntico. Añade: catálogo de "types of change × required gate" (E9 declarativo).
- Añade: front-matter mínimo en `docs/research/*.md` (`status:`, `derived_from:`,
  `supersedes:`).
- Añade: cadencia declarada de revisión de diferimientos.

### Evidence model

- CAP-3 actual + auditoría periódica de "EV without registration" (cerrar
  provenance break §12 de `02`).

### Verification model

- Idéntico.

### Policy model

- Idéntico: `.claude/rules/*.md` + `bash-firewall.sh`. Aceptar duplicación; añadir un
  runbook que verifica que **cada regex en firewall tiene una descripción en algún .md**
  (y viceversa). No es derivación, es coverage check.

### Provenance / Learning / Human boundary

- Idénticos.

### Provider boundary

- Provider-independent en runtime (bash, git).

### Scaling

- Rompe en S2 (10 agentes), S3 (multi-proyecto), S5 (audit externo). Sobrevive S1
  indefinidamente.

### Failure

- Fail-modes hoy: FS-1..FS-10 (audit). Fail-modes nuevos por formalización: ninguno.

### Reversibility

- Alta (git).

### Lock-in

- Bajo. Puede moverse hacia otra arquitectura en el futuro.

### Complejidad

- **Removida**: ambigüedad de autoridad.
- **Añadida**: catálogo declarativo (Markdown, mantenimiento humano).
- **Neta**: negativa (menos ambigüedad, misma masa).

### Elimina / Crea / Requiere

- **Elimina**: K3-D-OWNER-DEFAULT (por declaración de authorities).
- **Crea**: cadencia de review humano.
- **Requiere**: 3 nuevos docs (catálogo, política incident, cadencia).

### UNKNOWNs residuales

- U-01, U-05, U-06, U-08, U-09 permanecen abiertos.

### Verdict

- Arquitectura **de menor cambio**. Coherente con F9-D01=A actual. No resuelve escala.
- Óptimo si S1 es el escenario a largo plazo.

---

## 3. Arquitectura B — "Canonical Source + Motor Unidireccional"

**Idea core**: cerrar GAP-1 declarando una **canónica** y un **motor** que genera
enforcement. El motor NO es PAC-específico; es la clase de solución.

### Variantes

- **B.1**: canónica = YAML rico (como PAC prototype). Motor lo compila a firewall.
- **B.2**: canónica = tests ejecutables. Motor extrae patrones y genera firewall.
- **B.3**: canónica = `.claude/rules/*.md` con schema estricto. Motor parsea Markdown y
  genera firewall.

### Capabilities

- CAP-1 activo (canónica + motor).
- CAP-2-sintáctica actual.
- CAP-2-semántica humana (sin cambio).
- CAP-3 mejora (el motor emite provenance de generación).

### Control flow

- Mismo runtime; añade paso build-time: `canónica → motor → firewall + tests`.

### State model

- Canónica es nueva entidad. Firewall pasa a ser artefacto derivado (no editable
  directamente).

### Evidence model

- Se añade "evidencia de derivación": hash de canónica + hash de firewall generado deben
  matchear.

### Verification model

- CAP-2-sintáctica gana: coverage automática (el motor sabe qué policies existen).
- Se añade "test de idempotencia del motor": correr motor dos veces produce el mismo
  firewall.

### Policy model

- Cambia radicalmente: la fuente de política es la canónica; los `.md`/regexes son
  derivados o eliminados.

### Provenance

- Mejorada. Cada regla tiene origen (id en canónica).

### Learning

- Igual (POL-LATENT-5 no cambia).

### Human boundary

- El humano deja de editar regex; edita canónica. Reduce carga cognitiva.

### Provider boundary

- El motor es bash/python; provider-independent.

### Scaling

- Escala mejor bajo PT-2 (policies): la explosión combinatoria puede manejarse con
  gramática rica en canónica.
- No cambia la ruptura en S2/S3.

### Failure

- Nuevo FS: motor buggy produce firewall incorrecto. Requiere test de motor.
- FS existente PAC-EF-02: FP semántico. Requiere clasificación de FP classes en canónica
  (metadata `known_fp_classes:`).

### Reversibility

- Media. Migrar de vuelta a "manual sync" es doloroso (perdemos historial de policies
  en canónica).

### Lock-in

- Medio. Formato de canónica se convierte en contrato de largo plazo.

### Complejidad

- **Removida**: sync manual, drift potencial.
- **Añadida**: motor (nuevo TCB), formato canónica, tests de motor.
- **Neta**: variable según ratio de policies. Con 10 policies: negativa (peor). Con 100+:
  positiva.

### Elimina / Crea / Requiere

- **Elimina**: GAP-1, READY-01 y READY-02 (se convierten en "editar canónica").
- **Crea**: motor + formato canónica + FP classification framework.
- **Requiere**: D1a (elegir canónica) + D1b=motor + presupuesto de implementación.

### UNKNOWNs residuales

- U-04 (PAC FP rate) se resuelve empíricamente post-deploy.
- U-01, U-05, U-09 permanecen.

### Verdict

- Arquitectura **PAC-family**. Coherente con la lectura Kimi "Missing Piece".
- Elimina duplicación. Introduce motor como nuevo TCB.
- Sensible a escala de policies.

---

## 4. Arquitectura C — "Single Source + Tests como Contrato"

**Idea core**: eliminar la duplicación **borrando una capa**. La otra es la canónica
implícita. Los tests son el contrato ejecutable.

### Variantes

- **C.1**: eliminar `.claude/rules/*.md`; `bash-firewall.sh` regex es contrato + comentarios
  humanos son doc.
- **C.2**: eliminar `bash-firewall.sh` regex explícito; los hooks bash llaman a tests que
  son la política.

### Capabilities

- No CAP-1 (no hay canónica separada); coverage se logra por tests.
- CAP-2-sintáctica actual.
- CAP-2-semántica humana.
- CAP-3 actual.

### Control flow

- Idéntico si es C.1. Si C.2: pre-tool blocker ejecuta subset de tests para determinar
  block/allow. **Latencia añadida**.

### State model

- Menos entidades.

### Evidence model

- Igual.

### Verification model

- Coverage por tests. Cada test = una policy.

### Policy model

- Radicalmente simplificado. Sólo una fuente.

### Provenance

- Igual.

### Learning

- Igual.

### Human boundary

- El humano lee/escribe regex (C.1) o tests (C.2). Ambos son técnicos; menos ergonomía que
  Markdown.

### Provider boundary

- Provider-independent.

### Scaling

- Bajo PT-2, sufre: sin gramática rica, la mantención de 1000 tests es equivalente al
  problema original.

### Failure

- Nuevo FS: pérdida de documentación humana (Markdown). El humano razona con menos
  contexto.

### Reversibility

- Alta si se conservan los archivos borrados en git history.

### Lock-in

- Bajo.

### Complejidad

- **Removida**: la capa completa que se borra.
- **Añadida**: (C.2) latency en pre-tool.
- **Neta**: negativa. Es la más simple.

### Elimina / Crea / Requiere

- **Elimina**: GAP-1 (por deletion), READY-01, READY-02.
- **Crea**: (C.1) coste de razonar policy sin doc humana. (C.2) latency + complejidad de
  test-runner en pre-tool.
- **Requiere**: decisión Owner de qué capa borrar; migración de policies existentes.

### UNKNOWNs residuales

- U-01, U-05, U-06, U-09, U-11 permanecen.

### Verdict

- Arquitectura **radical simplification**. Sacrifica expresividad humana por simplicidad.
- Coherente con "los tests son el contrato" (test-driven governance).
- Sensible a escala de policies como B, pero sin gramática rica.

---

## 5. Arquitectura D — "Peer Verification + Segundo LLM"

**Idea core**: mecanizar CAP-2-semántica delegándola a un segundo LLM adversarial con
protocolo fijo, reduciendo la carga de la topología estrella.

### Capabilities

- CAP-2-sintáctica actual.
- CAP-2-semántica delegada parcialmente a LLM adversarial + humano como último recurso.
- CAP-3 actual.

### Control flow

- Pre-tool: idéntico.
- Post-tool subagentStop: el subagente `code-reviewer` se invoca **obligatoriamente**;
  su verdict alimenta el gate.
- Post-commit: pipeline dispara un tercer LLM (o el mismo modelo con distinto system prompt
  y contexto diferente) para audit adversarial. Si detecta divergencia con el implementer:
  flag para humano.

### State model

- Sin cambio.

### Evidence model

- Añade evidencia de "peer review LLM verdict".

### Verification model

- CAP-2-semántica pasa a ser **doble** (LLM adversarial + humano opcional).

### Policy model

- Sin cambio (podría combinarse con B).

### Provenance

- Añade huella de LLM verifier + prompt version + model version.

### Learning

- El log de verdicts LLM alimenta un future analysis of correlated failure.

### Human boundary

- Humano queda como escalación, no gate default. **Cambio profundo**.

### Provider boundary

- El segundo LLM introduce dependencia de provider (nuevo).

### Scaling

- Sobrevive S2 (10 agentes): cada agente tiene su reviewer LLM.
- Sobrevive S3 (multi-proyecto): reviewers replicables.
- **U-09 (correlated failure)** es el riesgo dominante.

### Failure

- Nuevo FS: correlated failure. Dos LLMs pueden compartir sesgo.
- Nuevo FS: jailbreak sobre el reviewer.
- FS existente: humano deja de estar en la loop cotidiana → puede perder skill/atención.

### Reversibility

- Media. Volver al humano-primary requiere re-desarrollar hábito.

### Lock-in

- Alto sobre provider LLM.

### Complejidad

- **Removida**: carga humana en review sintáctico.
- **Añadida**: LLM verifier + protocol + logging + dependency management.
- **Neta**: positiva (más compleja).

### Elimina / Crea / Requiere

- **Elimina**: fracción del bottleneck humano (§7 PT-1).
- **Crea**: provider dependence; risk de correlated failure.
- **Requiere**: prototipo + medición U-09; presupuesto continuo (LLM API cost).

### UNKNOWNs residuales

- U-01, U-05, U-06 permanecen; U-09 se resuelve empíricamente si se despliega.

### Verdict

- Arquitectura **automation-forward**. Rompe topología estrella parcialmente.
- Coherente con S2/S3. Introduce riesgo epistemológico.
- Requiere presupuesto y instrumentación (evals de U-09).

---

## 6. Arquitectura E — "Layered Trust with Formal Delegation Contract"

**Idea core**: introducir un **contrato formal de delegación** (declarativo, versionable)
que enumera qué decisiones el humano ha delegado a qué mecanismo. Todo lo demás requiere
humano.

### Capabilities

- CAP-2 bifurcada, con **frontera declarada** entre sintáctica (mecanismo) y semántica
  (humano por default, delegable con contrato).
- CAP-3 actual.
- Nueva capability: `CAP-DELEG` (contrato de delegación).

### Control flow

- Pre-tool: mismo.
- Post-close gate: mismo.
- Nuevo runbook: valida que cada nuevo tipo de change tiene entrada en el contrato de
  delegación.

### State model

- Nueva entidad: `DELEGATION_REGISTRY.md` con schema:
  ```
  action_type: <catalog>
  delegated_to: <human | hook | subagent | LLM-verifier>
  fallback: <human>
  activated_by: <ARCH-NNN or F9-D-NN>
  revocable: <yes | no>
  ```

### Evidence model

- Actual.

### Verification model

- Cada action pasa por el mecanismo declarado. El humano interviene si el mecanismo
  no está delegado o si el flag "fallback humano" se dispara.

### Policy model

- Ortogonal (puede combinarse con A/B/C).

### Provenance

- Cada evento incluye "mechanism used", derivable de `DELEGATION_REGISTRY`.

### Learning

- El registry mismo evoluciona por INC-CTRL-REG-EV.

### Human boundary

- **Declarado explícitamente** en lugar de default.

### Provider boundary

- Neutral.

### Scaling

- Sobrevive S2/S3 delegando gradualmente.

### Failure

- Nuevo FS: contrato de delegación con gap → default humano (statu quo). Fallback seguro.
- Nuevo FS: contrato de delegación mal escrito → automatiza más de lo pretendido. Requiere
  audit de contract.

### Reversibility

- Alta (revocar delegación = editar registry).

### Lock-in

- Bajo.

### Complejidad

- **Removida**: ambigüedad K3-D-OWNER-DEFAULT.
- **Añadida**: nueva entidad estatal + runbook.
- **Neta**: media (nueva entidad, low complexity per-entry).

### Elimina / Crea / Requiere

- **Elimina**: K3-D-OWNER-DEFAULT; hace **auditables** las delegaciones.
- **Crea**: registry + convención de edición.
- **Requiere**: definir schema; poblar inicial con delegaciones existentes (identificar
  qué se ha delegado implícitamente).

### UNKNOWNs residuales

- U-11 se resuelve (enumeración por poblar el registry).
- Resto sin cambio.

### Verdict

- Arquitectura **governance-explicit**. Ortogonal a otras (composable con B/C/D).
- Bajo costo, alto beneficio en claridad.
- **Descubrimiento**: E es el elemento común a las mejoras arquitectónicas — sin
  delegación explícita, ninguna de las otras opera sin ambigüedad.

---

## 7. Combinaciones viables

### A + E

Statu quo formalizado con contrato de delegación. Bajo cambio. Elimina ambigüedad.
Consistente con F9-D01=A.

### B + E

PAC + contrato de delegación. Delega la sync mecánica al motor. Elimina GAP-1 + K3-D-OWNER-DEFAULT.

### C + E

Simplificación radical + delegación explícita. Elimina más entidades pero pierde ergonomía
humana en policies.

### D + E

Delegación con verificador LLM. E es requisito para D — sin contrato explícito, la
delegación es implícita e insegura.

### A + B + E

Statu quo + añadir motor gradualmente + delegar cambios auto-generados. Bridging.

### Todas + shadow runtime (E7 §7 de 06)

Cualquier combinación puede añadir shadow runtime para instrumentar sin cruzar F9-D01=A
sobre el runtime real.

---

## 8. Matriz de arquitecturas × escenarios

```text
                 A statu quo  B canonical+motor  C single-src  D peer-LLM  E delegation
S1 stable        OK           OK                 OK            EXPENSIVE   OK
S2 10x agents    BREAK        WEAKEN             WEAKEN        OK          IMPROVES
S3 multi-project BREAK        BREAK              BREAK         OK          IMPROVES
S4 provider      OK           OK                 OK            BREAK       OK
S5 audit         BREAK        IMPROVES           WEAKEN        WEAKEN      IMPROVES
S6 substrate     OK           OK                 OK            OK          OK
```

Observaciones:

- **E domina** en S2/S3/S5 (mejora en todos).
- **A** es óptimo en S1 solamente.
- **B** es óptimo en S5 (audit gana provenance).
- **D** es sensible a S4 (provider dependence).
- **Ninguna** cubre todos los escenarios sola.

---

## 9. Descubrimiento estructural del capítulo

Al enumerar arquitecturas surge una observación no anterior:

**K3-D-DELEG-ORTOGONAL**: la delegación explícita (arquitectura E) es **ortogonal a las
demás** y las **mejora**. Es una capa transversal, no una alternativa. Cualquier
arquitectura futura de CCP se beneficia de E.

Esto sugiere que **la primera decisión Owner viable** no es "elegir A/B/C/D", sino
"adoptar E como capa transversal" — que es low-risk, low-cost, y desbloquea análisis
más rico de las demás.

---

## 10. Verdict del capítulo

- **5 arquitecturas** genuinamente distintas (A/B/C/D/E) + subvariantes.
- **6 combinaciones viables** documentadas.
- **E (delegation contract) es ortogonal y beneficia a las demás** — es la primera
  decisión de bajo coste que desbloquea todo lo demás.
- **Ninguna arquitectura domina en todos los escenarios**; el Owner debe elegir por
  escenario prevalente.
- **F9-D01=A** favorece A + E como camino inmediato; B/C/D requieren revisit.

Insumo directo para `13_MASTER_OWNER_DECISION_SYSTEM`, donde estas 5 arquitecturas se
convierten en opciones concretas por decisión.
