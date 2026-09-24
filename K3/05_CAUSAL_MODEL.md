# 05 — CAUSAL MODEL

> Cadenas causales verificadas contra el corpus real, countermodels, intervention engine.
> Cumple §35 (causal reconstruction), §36 (intervention/counterfactual engine),
> §310 (countermodel generator), §311 (discriminating evidence).

---

## 1. Cadenas causales VERIFIED (evidencia primaria en git/registries)

### 1.1 `INC-001 → CTRL-001 → REG-001 → EV-006`

- **INC-001**: registered in `EVIDENCE_REGISTRY.md` como base para EV-006 (F4 incident
  regression). Contenido: incident real, no adversarial.
- **CTRL-001**: control derivado para prevenir recurrencia.
- **REG-001**: regression test para el control.
- **EV-006**: evidencia que cierra el ciclo.
- **Verificación**: `grep "EV-006" EVIDENCE_REGISTRY.md` confirma. La cadena es
  reconstruible.

**Verdict**: **VERIFIED**. Este es el único ciclo learning-loop completo del corpus real.

### 1.2 `F-FALSE_PASS-01 → F8-A (contract_hash obligatorio) → EV-015`

- **F-FALSE_PASS-01**: hallazgo adversarial en F7 handoff (`docs/00_SYSTEM/F7_F12_RESEARCH_HANDOFF.md`).
- **F8-A**: cambio a `task-completed-evidence.sh` para exigir `contract_hash`.
- **EV-015**: `## EV-015 — F8-A contract_hash is fail-closed`.
- Cadena reconstruible en handoffs + git log.

**Verdict**: **VERIFIED con caveat**. El hallazgo fue adversarial (auto-generado por
Claude en un audit), no un incidente orgánico. Distinción importante: la cadena es
válida como aprendizaje, pero **el input no es evidence "from the wild"**.

### 1.3 `PAC-EF-02 → HRQS (handbook §12) → query-log.sh`

- **PAC-EF-02**: false positive detectado al compilar la política PAC.
- **HRQS**: Human Review Quality Standard, checklist añadido al handbook.
- **query-log.sh**: script creado en M007 para monitorear el log.
- Cadena reconstruible en `CCP_EXPLORATION_ENGINE.md` + commits M007/M008.

**Verdict**: **SUPPORTED as attenuated learning loop**. No es un ciclo INC→CTRL→REG→EV
completo; es una respuesta **documental + tooling** a un FP. La distinción es
importante: el sistema respondió con doc y tooling, no con un incidente formal. Esto es
evidencia de POL-LATENT-5 (learning loop existe como policy latency, se dispara sólo para
INC clásicos).

### 1.4 `F9-D01 gate → M001..M008 → ROOT_ANALYSIS → this K3`

Kimi y Claude tratan esto como cadena causal. K3 la reconstruye:

- F9-D01=A (2026-09-20): "no autorizar implementación".
- M001..M008 (2026-09-23): 8 movimientos de investigación bajo la restricción.
- ROOT_ANALYSIS (2026-09-24): consolidación por Kimi K2.7.
- 11_KIMI_ROOT_ANALYSIS_AUDIT (2026-09-24): audit por Claude Opus 4.7.
- K3 partial (2026-09-24, Kimi): index + baseline.
- K3 completo (2026-09-24, Claude Code): este corpus.

**Ataque**: ¿es causación o correlación?

- Sin F9-D01=A, ¿habrían ocurrido M001..M007? Probablemente sí, con otro orden.
  El gate no *causó* los movimientos; abrió el espacio en el que eran la actividad
  autorizada.
- Sin M001..M007, ¿habría ROOT_ANALYSIS? Con menos material, probablemente sí pero más
  débil.
- **Correcto framing**: F9-D01=A es una **condición habilitante**, no una causa
  productora. Cadena narrativa, no causal en sentido estricto.

**Verdict**: **INFERENCE (narrative)**. Cambio importante respecto a Kimi: no debe
tratarse como respaldo causal para "M001..M007 fueron consecuencia de F9-D01".

---

## 2. Cadenas causales candidatas (SUPPORTED weak)

### 2.1 `GAP-1 → PAC prototype → PAC-EF-02 → HRQS`

- GAP-1 (ausencia de canónica) → alguien intentó derivar de las representaciones parciales.
- PAC como prototipo de derivación.
- Al compilar, aparece FP no clasificable → PAC-EF-02.
- HRQS como respuesta.

Cadena estructural verificable en artefactos. **SUPPORTED**.

### 2.2 `Star topology → reviewer load growth → HRQS + meta-documentation`

- Topología estrella → toda decisión no-formalizada va al humano.
- Con el crecimiento del research corpus, la carga sube.
- Respuesta: HRQS checklist + meta-doc para "cargar contexto rápido".

Cadena inferible. **SUPPORTED as hypothesis**.

### 2.3 `K3-D-SCHEMA (had_alternative null) → clasificación imposible → READY-03 sin datos → LABYRINTH-1 sin cierre empírico`

- Hard-coded en `stall-record.sh:46`.
- Sin campo → no clasificación.
- Sin clasificación → sin data.
- Sin data → READY-03 no puede resolverse empíricamente.
- Sin READY-03 → LABYRINTH-1 abierta.

Cadena mecánica reconstruible. **VERIFIED**.

---

## 3. Third-variable checks

### 3.1 F9-D01 y ARCH-001 co-causan diferimientos

Kimi §07 trata F9-D01 como causa de "diferimientos" (A-05, A-07, G-N5). El audit §23.2
observa que ARCH-001 (proyecto-scoped) también los co-causa. K3 confirma: sin
proyecto-scoped, el trust boundary global habría exigido controles internos más fuertes
independientemente de F9-D01. **Co-causación observable**.

### 3.2 PAC prototipo y HRQS co-derivan de PAC-EF-02

Audit §23.2 sugerencia. K3 confirma: el prototipo PAC provocó PAC-EF-02; PAC-EF-02
provocó HRQS. HRQS **no** viene del prototipo directamente. Cadena secuencial, no
co-causación.

### 3.3 Meta-documentación y research corpus growth

Ambos crecen. Third variable candidate: `session-context-fidelity < 1`
(K3-D-EXOGENOUS). Confirma que ambas variables observadas son consecuencias, no causas
mutuas. Ni la meta-doc causa el research growth ni al revés; ambas son respuestas al
substrate.

---

## 4. Intervention engine

Para cada estructura importante:

### 4.1 `INTERVENCIÓN: eliminar GATE-BEFORE-TASK-CLOSURE`

- ¿Qué desaparece? La garantía técnica de `contract_hash + artifact_hash` en cierre.
- ¿Qué sobrevive? Todas las EVs actuales (persisten en registry); las cadenas de
  compensación (HRQS, code-reviewer).
- ¿Qué cambia? Nuevos closures no exigirían evidencia formal; el sistema regresaría a
  F-FALSE_PASS-01 potencial.
- **Análisis**: F8-A es un patch de una regresión conocida. Su eliminación reintroduce
  el bug.
- **Verdict**: GATE es el único componente cuya eliminación reintroduce inmediatamente un
  bug documentado. **Critical component confirmed**.

### 4.2 `INTERVENCIÓN: eliminar BLOCKER-BEFORE-BASH`

- ¿Qué desaparece? La denegación mecánica de comandos peligrosos.
- ¿Qué sobrevive? Todo lo demás; los tests siguen operando.
- ¿Qué cambia? El agente puede ejecutar `rm -rf /`, `DROP DATABASE`, `curl | bash`
  sin bloqueo. La única barrera es el reviewer humano (el humano no ve el comando *antes*;
  ve el resultado en el diff).
- **Análisis**: El bloqueo pre-tool es la única prevención antes de efectos.
- **Verdict**: Crítico como prevención mecánica; no está claro cuántas veces ha
  bloqueado un intento genuinamente peligroso (14/18 events son fixture replays; 3 son
  tests). **Crítico por diseño; escasa evidencia de campo**.

### 4.3 `INTERVENCIÓN: reemplazar reviewer humano por segundo LLM adversarial`

- ¿Qué desaparece? Independencia epistemológica del árbitro (ambos LLMs pueden
  compartir sesgos).
- ¿Qué sobrevive? Provenance, evidence gate, blockers.
- ¿Qué cambia? Escala: el segundo LLM puede revisar más rápido; el humano se libera de
  revisiones mecánicas.
- **Riesgo**: correlated failure. Un jailbreak que engaña al implementer puede engañar
  al reviewer.
- **Verdict**: reduce carga humana; introduce riesgo epistemológico. Es una decisión
  Owner sobre CAP-2-semántica.

### 4.4 `INTERVENCIÓN: llenar `.claude/rules/no-go.md` con contenido real y borrar bash-firewall.sh`

- ¿Qué desaparece? Enforcement mecánico.
- ¿Qué sobrevive? Documentación de política.
- ¿Qué cambia? Todo intento peligroso pasa; el humano lo detecta ex-post.
- **Verdict**: no viable; equivale a eliminar CAP-2-sintáctica.

### 4.5 `INTERVENCIÓN: llenar `.claude/rules/no-go.md` y GENERAR bash-firewall.sh desde ahí`

- Equivalente a PAC en producción.
- ¿Qué desaparece? Duplicación sintáctica; la sync manual.
- ¿Qué sobrevive? Todo lo demás.
- ¿Qué cambia? Se agrega dependencia en el compilador (nuevo TCB).
- **Riesgo**: FP class discovery (PAC-EF-02). Ya observado.
- **Verdict**: es una elección de implementación para GAP-1; debe pasar por D1a=YAML/rules
  y D1b=motor. Ver `13`.

### 4.6 `INTERVENCIÓN: hacer `had_alternative` un input real`

- ¿Qué desaparece? El schema-dead field.
- ¿Qué sobrevive? Todos los eventos ya emitidos (siguen con null).
- ¿Qué cambia? Los nuevos eventos pueden clasificarse. El log deja de ser 100% ruido de
  harness.
- **Precondición**: F9-D01 gate abierto para runtime change.
- **Verdict**: intervención mínima que desbloquea READY-03 empírico. Cost bajo, benefit alto.
  Aparece como decision-item en `13`.

### 4.7 `INTERVENCIÓN: eliminar reviewer humano`

Ejercicio conceptual, no propuesta.

- ¿Qué desaparece? CAP-2-semántica. Todas las decisiones diferidas quedan sin dueño.
- ¿Qué sobrevive? CAP-2-sintáctica (hooks, evals). Provenance. Gate técnico.
- ¿Qué cambia? El sistema opera pero no puede autorizar nada. Se congela.
- **Verdict**: revela que el humano no está haciendo enforcement (ese es de los hooks);
  está haciendo **autorización**. La autorización, no la verificación, es lo que
  desaparece. Distinción crucial: "human trust boundary" es realmente "human authorization
  boundary" para la mayoría de casos.

**K3-D-AUTHZ-VS-VERIF**: el rol dominante del humano no es verificar (que los hooks pueden
sintácticamente); es **autorizar** (que los hooks no pueden). La reformulación "human
trust boundary" pierde esta distinción.

---

## 5. Counterfactuals estructurales

### 5.1 CF-1: "Si CCP hubiera nacido con YAML canónica + compilador"

- No habría duplicación.
- El PAC prototype no sería innovación; sería infra.
- READY-01/02 no existirían.
- ¿Qué existiría igual? Reviewer humano (autorización), gate técnico (evidence),
  event stream, learning loop parcial.
- **Verdict**: CF-1 elimina GAP-1 pero no elimina la topología estrella.

### 5.2 CF-2: "Si CCP hubiera nacido sin la separación rules/firewall"

- Una única capa de política; menos superficie.
- Menos flexibility (no se puede leer política humanamente sin leer regex).
- **Verdict**: CF-2 es viable pero perdería auditabilidad humana. Trade-off: expresividad
  vs. simplicidad.

### 5.3 CF-3: "Si CCP hubiera nacido con schema STALL correcto"

- `had_alternative` y `session_id` como inputs reales desde F1.
- Habría data desde el arranque.
- READY-03 podría cerrarse empíricamente cuando N=1 se alcanzara.
- **Verdict**: CF-3 muestra que **K3-D-SCHEMA no es un bug local; es una decisión
  de diseño temprana con consecuencias downstream de segundo orden**. La deuda de
  instrumentación temprana produjo la imposibilidad actual de decidir READY-03
  empíricamente.

### 5.4 CF-4: "Si el reviewer humano hubiera sido un segundo LLM adversarial desde F1"

- CAP-2-semántica delegada a máquina.
- Riesgo epistemológico (correlated failure).
- Escala mejor.
- **Verdict**: contrafactual no probable; ninguna evidencia de que CCP tuvo esa opción
  disponible en F1. **Ejercicio de espacio arquitectónico**, no de historia.

### 5.5 CF-5: "Si el sustrato tuviera memoria persistente verificable"

- `session-context-fidelity → 1`.
- Meta-documentación colapsa.
- Handoffs innecesarios.
- **Verdict**: extraordinariamente diferente. CCP dejaría de existir en su forma actual:
  la mayoría de su superficie es respuesta a la fragilidad del sustrato. Este
  contrafactual es **más importante** que los CF-1..CF-4 porque muestra qué fracción
  de CCP existe por el control plane vs. por el substrato.

**K3-D-SUBSTRATE-FRACTION**: una fracción significativa (probablemente >30%) de la
complejidad de CCP existe por propiedades del substrato agente, no por el problema que CCP
resuelve. Este es un límite a lo que puede lograrse rediseñando el control plane sin
tocar el substrato.

---

## 6. Countermodel

### 6.1 Modelo K3 (síntesis §100 hipotética)

> "CCP es una estrella con humano-sink, dos gates duros y una carencia (GAP-1). Las
> capacidades activas son CAP-2 (bifurcada), CAP-3 (con brechas), y CAP-5 (latente).
> La meta-doc creciente es respuesta racional al sustrato."

### 6.2 Countermodel serio (construido para atacar el modelo K3)

**Modelo alternativo "CCP como Pipeline con Retroalimentación Humana Controlada"**:

> "CCP es una pipeline `intent → tools → evidence → commit` con dos correcciones runtime
> (blockers) y una corrección post-runtime (reviewer). Las 'capacidades' son roles del
> pipeline, no primitivas independientes. La topología estrella es una lectura sesgada de
> un pipeline lineal con un checkpoint humano fijo."

### 6.3 Discriminación entre modelos

¿Qué evidencia distinguiría K3-star vs. countermodel-pipeline?

- Si CCP fuera pipeline lineal, agregar agentes en paralelo NO debería aumentar
  la carga humana (cada agente tiene su pipeline). K3-D-STAR predice que sí (todos
  convergen al mismo humano).
- **Evidencia observable**: HRQS existe **porque** la carga humana crece; es una
  respuesta a un cuello de botella único. Un pipeline lineal no habría producido HRQS
  como una checklist unificada; habría producido revisiones per-pipeline.
- **Verdict**: la evidencia HRQS discrimina a favor de K3-star.

### 6.4 Zonas donde countermodel-pipeline sobrevive

- F1..F8 son un pipeline (fases secuenciales). Aquí countermodel funciona bien.
- F9 en adelante deja de ser pipeline (M001..M008 no son fases; son movimientos paralelos
  de investigación). Aquí K3-star describe mejor.
- **Conclusión**: **CCP fue un pipeline en F1..F8 y se convirtió en una estrella en F9→**.
  La transición ocurrió sin ser nombrada. La "convergencia estructural parcial" de Kimi es
  otra forma de decir lo mismo: convergencia del build (fase pipeline cerrada) +
  divergencia del research (fase estrella iniciada).

**K3-D-PHASE-CHANGE**: el sistema pasó de arquitectura pipeline a arquitectura estrella
en el momento F9-D01=A. Esta transición no está nombrada; sin nombrarla, no puede
gobernarse. Las decisiones D1..D6 del `13` la enfrentan.

---

## 7. Cadenas causales que Kimi/Claude sostienen y K3 rechaza

- "M001..M007 fueron causadas por F9-D01": narrative, no causal. F9-D01 abrió espacio;
  no causó los movimientos.
- "Kimi 05 §5: la existencia de PAC-EF-02 confirma la Missing Piece": PAC-EF-02 confirma
  una **carencia** distinta (validación semántica); la conclusión no se sigue.
- "F-FALSE_PASS-01 confirma la necesidad de human trust boundary": confirma la necesidad
  de CAP-2 (que puede o no ser humana); no confirma que deba ser humana específicamente.

Ninguna de estas rechazadas invalida las decisiones tomadas; sólo limpia la retórica.

---

## 8. Discriminating evidence for open UNKNOWNS

Para cada UNKNOWN del audit §32, qué evidencia lo desbloquearía:

| UNKNOWN | Evidencia discriminante |
|---|---|
| U-01 H-01 materiality | Cambio K3-D-SCHEMA (had_alternative real) + monitoreo N sesiones de uso "campo" (no evals). Sin esa instrumentación, U-01 es inobservable. |
| U-02 STALL classification | Cambio K3-D-SCHEMA + política de clasificación (HRQS §12 formalizado con `verdict:` en JSONL). |
| U-03 Native runtime | Ejecución en runtime nativo Claude Code + probing de tool events. Requiere F9-D02 revisit. |
| U-04 PAC FP rate en campo | Deploy PAC como enforcement + registro de FP encontrados. Requiere D1a=YAML y D1b=motor. |
| U-05 CAP-2-semántica sin humano | Diseño de segundo verificador adversarial + experimento controlado. Fuera de scope actual. |
| U-06 Research artifact lifecycle | Decisión D5 y observación de N artefactos a lo largo de M meses. |

**Observación estructural**: 4 de 6 UNKNOWNs (U-01, U-02, U-03, U-04) requieren cambios
runtime que están bloqueados por F9-D01=A. **F9-D01=A no es sólo un no-go; es la razón por
la que los UNKNOWNs de instrumentación permanecen abiertos**. Este es un descubrimiento
de segundo orden: F9-D01=A tiene un costo epistemológico creciente que no fue nombrado en
la decisión original.

**K3-D-EPIST-COST**: los diferimientos "hasta trigger concreto" acumulan **coste
epistemológico** — cada UNKNOWN no observado retrasa la respuesta a otras decisiones que
dependen de él. El costo no aparece en el paquete READY porque el paquete no lo instrumenta.

---

## 9. Summary del capítulo

- 3 cadenas causales VERIFIED (INC-001, F-FALSE_PASS-01→F8-A, K3-D-SCHEMA → LABYRINTH-1).
- 3 cadenas SUPPORTED (GAP-1→PAC, star topology→HRQS, PAC prototype→PAC-EF-02).
- 3 rechazos narrativos de Kimi/Claude (M001..M007 causation, PAC-EF-02→MissingPiece,
  F-FALSE_PASS-01→humanTrust).
- 5 counterfactuals: CF-1..CF-5 con **CF-3 (schema temprana correcta) y CF-5 (substrate
  con memoria) como los de mayor valor explicativo**.
- 6 intervention experiments con **K3-D-AUTHZ-VS-VERIF** como descubrimiento estructural
  (el humano autoriza; la verificación sintáctica ya está mecanizada).
- 1 phase-change discovery: **K3-D-PHASE-CHANGE** (pipeline→star en F9-D01=A, sin
  nombrar).
- 1 second-order cost: **K3-D-EPIST-COST** (los diferimientos crean deuda epistemológica).
- 1 substrate discovery: **K3-D-SUBSTRATE-FRACTION** (>30% de CCP es respuesta al
  substrato, no al problema).

Insumo directo para `06_ARCHITECTURAL_SPACE` (opciones para GAP-1), `08_UNKNOWN_AND_FALSIFICATION`
(mapeo de UNKNOWNs a instrumentación bloqueada), `13_MASTER_OWNER_DECISION_SYSTEM`.
