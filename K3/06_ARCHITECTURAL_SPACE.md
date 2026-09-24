# 06 — ARCHITECTURAL SPACE

> Espacio de diseño (§47), false-alternative test (§22), false-unification test (§23),
> necessary distinction test (§24). No recomienda; delimita.

---

## 1. Ejes del espacio

Los ejes descubiertos como reales (no impuestos) durante la reconstrucción y
descubrimiento:

```text
E1. Policy source location:      { rules-md,  firewall-regex,  tests,  yaml }
E2. Policy synchronization:      { human,     mechanical (motor),  none (single source) }
E3. Verifier identity:           { humano,    LLM-adversarial,  second-human,  hooks-only }
E4. Verifier timing:              { pre-tool,  post-tool,  ex-post commit }
E5. Event stream consumption:     { none,     manual triage,  automated triage,  runbook }
E6. Artifact lifecycle model:     { none,     manual,  registry-based }
E7. Runtime observability:        { deferred, native runtime instrumented }
E8. Instrumentation completeness: { schema-partial, schema-complete }
E9. Authorization scope catalog:  { informal, catalog-declarative }
E10. Learning-loop trigger:       { manual, event-driven, hybrid }
```

Todos los ejes son **observables**: cada uno tiene un punto que CCP ocupa actualmente
y ≥1 alternativa concretamente instanciable.

### 1.1 Punto actual del sistema en cada eje

```text
E1: rules-md + firewall-regex          (dual, ambos parciales)
E2: human                              (ningún compilador en producción)
E3: humano + hooks-only for syntax     (bifurcación K3-D-CAP2)
E4: pre-tool (blockers) + ex-post commit (review)
E5: manual triage (HRQS §12), sin runbook
E6: none                               (K3-D-LIFECYCLE)
E7: deferred (F9-D02=B)
E8: schema-partial (K3-D-SCHEMA)
E9: informal                           (K3-D-OWNER-DEFAULT)
E10: manual                            (POL-LATENT-5)
```

Ocho de 10 ejes están en el punto menos formalizado. No es casualidad: la topología
estrella con humano-sink es coherente con "todos los ejes por default informales".

---

## 2. False-alternative tests

### 2.1 "Manual sync vs. PAC" no es alternativa binaria

Kimi implícitamente presenta la elección como binaria. K3 identifica 4 puntos reales en E2:

- (a) **manual sync** (actual): humano sincroniza rules ↔ firewall.
- (b) **motor unidireccional** (PAC): YAML canónica → firewall generado.
- (c) **motor bidireccional**: cambios en firewall se propagan a YAML.
- (d) **single source**: eliminar una de las dos capas.

Cada uno tiene trade-off distinto. Kimi/Claude reducen a (a) vs (b); K3 mantiene los 4 en
juego.

### 2.2 "Verificación humana vs. verificación mecánica" no es binaria

Bifurcación K3-D-CAP2: CAP-2-sintáctica ya es mecánica (hooks); CAP-2-semántica es humana.
La elección real no es "cambiar todo a mecánico"; es "¿la CAP-2-semántica se mantiene
humana, se delega a segundo LLM, o se retira del scope?"

### 2.3 "Runtime observability = native o nada"

Falsa. Puntos reales en E7:

- (a) deferred (actual).
- (b) native runtime + instrumentación completa.
- (c) shadow runtime: correr una capa de simulación que capture events sin cambiar hooks.
- (d) protocol adapter: capturar events por sniffing en el tool bus del substrate.

(c) y (d) no requieren F9-D01 revisit; son opciones intermedias no consideradas.

### 2.4 "Research artifacts sin lifecycle vs. registry pesado"

Falsa. Punto intermedio: `docs/research/` con front-matter mínimo (`status:
draft|active|superseded|archived`, `derived_from: [...]`, `supersedes: [...]`). No requiere
un registry nuevo ni hooks; es una convención declarativa.

---

## 3. False-unification tests

### 3.1 "Todo es evidence"

Rechazado por K3 §3 (03). Evidence es CAP-3 con brechas; policy (GAP-1), verification
(CAP-2) e incident learning (POL-LATENT-5) son ortogonales.

### 3.2 "Todo es trust boundary"

Rechazado por K3-D-STAR y K3-D-AUTHZ-VS-VERIF. Trust boundary conflate autorización
(humano) y verificación (mecanizable en parte).

### 3.3 "Todo es governance compiler"

Rechazado por Kimi mismo (auto-corrección aceptada). K3 mantiene: metáfora parcial.

### 3.4 "Todo es capability"

Riesgo detectado por K3: la lista CAP-1..CAP-5 mezcla capacidad, carencia, propiedad
del sustrato y política latente. Unificarlas bajo "capability" pierde la información
sobre **qué se puede decidir vs. qué se hereda**.

---

## 4. Necessary distinction tests

### 4.1 CAP-2-sintáctica vs. CAP-2-semántica — NECESARIA (§3.3 de 03)

Cada una tiene implementación distinta y trade-off distinto. No fusionar.

### 4.2 GAP vs. capability — NECESARIA (§7 de 03)

"CAP-1 = enforceable specification" enmascara que no hay canónica. Distinguir GAP-1
protege contra soluciones que asumen "sólo falta el motor".

### 4.3 Authorization vs. verification — NECESARIA (§4.7 de 05)

K3-D-AUTHZ-VS-VERIF. La reformulación "human trust boundary" pierde esta distinción y
sugiere que automatizar verificación reduciría carga humana. Falso: la carga es
principalmente autorización.

### 4.4 Policy divergence estado vs. policy definition — NECESARIA

`.claude/rules/*.md` vs. `bash-firewall.sh` puede diverger porque son dos entidades
sin sync mecánica (GAP-1) O porque las regexes cubren casos no expresables en Markdown.
Distinguir "gap por sync" de "gap por expresividad" es necesario. Kimi no lo hace.

### 4.5 Deferimiento con vs. sin trigger declarativo — NECESARIA

"Diferido hasta trigger concreto" (F9-D02=B, A-05, A-07, G-N5) sin trigger mecánico
declarado es distinto de "diferido hasta que N sesiones ocurran". El primero es un
diferimiento indefinido; el segundo es una condición observable.

---

## 5. El sub-espacio "cerrar GAP-1"

Cross-product de E1 × E2 sobre puntos viables:

```text
                         E2 sync
E1 source        | human    | motor uni  | motor bi   | none      |
─────────────────┼──────────┼────────────┼────────────┼───────────┤
rules-md         | actual   | reverse    | forbidden* | forbidden*|
firewall-regex   | mirror   | forbidden* | forbidden* | discard-md|
tests            | new      | test→both  | forbidden* | test-only |
yaml             | new      | PAC        | rare       | forbidden*|
─────────────────┴──────────┴────────────┴────────────┴───────────┘
* forbidden = would leave the other layer as dead code or duplicate the problem
```

Puntos viables:

- **(1,1) actual** = human sync + dual source. Estado presente.
- **(1,2) reverse** = motor lee md, escribe firewall. Sería PAC pero con `.claude/rules/`
  como canónica (los .md no están completos → discovery bloqueado).
- **(2,4) discard-md** = eliminar `.claude/rules/*.md`, aceptar firewall.sh como canónica.
- **(3,1) tests+human** = tests como canónica ejecutable, humano mantiene md como doc.
- **(3,2) test→both** = tests generan tanto md como firewall.
- **(3,4) test-only** = eliminar rules y firewall separados; que los tests sean el
  contrato.
- **(4,2) PAC** = YAML canónica, motor genera firewall (y opcionalmente md).

**7 puntos viables**, no 2. K3 los enumera para que `13` los presente al Owner sin
reducción binaria.

---

## 6. El sub-espacio "verificador para CAP-2-semántica"

E3 × E4 sobre puntos viables:

```text
                         E4 timing
E3 verifier          | pre-tool | post-tool | ex-post commit |
─────────────────────┼──────────┼───────────┼────────────────┤
humano               | forbidden| forbidden | actual          |
LLM adversarial      | rare     | possible  | possible        |
segundo humano       | expensive| possible  | rare            |
hooks-only           | actual   | actual    | no              |
─────────────────────┴──────────┴───────────┴─────────────────┘
```

Puntos viables:

- **(humano, ex-post commit)**: actual. CAP-2-semántica humana.
- **(LLM adv, post-tool)**: subagente code-reviewer bloqueante en subagentStop.
- **(LLM adv, ex-post commit)**: bot GitHub review en PR.
- **(segundo humano, post-tool)**: pair review. Alto coste.
- **(hooks-only, pre-tool)**: actual para CAP-2-sintáctica.

La elección Owner es: qué combinación se acepta para qué tipo de claim.

---

## 7. Ejes ortogonales confirmados

Comprobación §2.1 (audit): los subsistemas identificados como ortogonales
(enforcement, evidence gate, learning loop, state authority, authorization gates,
research surface) mapean a ejes distintos:

- Enforcement → E4 pre-tool.
- Evidence gate → E4 post-tool.
- Learning loop → E5 + E10.
- State authority → E9.
- Authorization gates → E9.
- Research surface → E6.

Ninguno se colapsa en otro. Confirmado ortogonal.

---

## 8. Regiones no exploradas

### 8.1 (E5 automated triage + E10 event-driven)

Un runbook lee STALL_POLICY_LOG, clasifica automáticamente eventos según regla, y produce
un feed de "eventos que requieren revisión humana". Reduce el backlog sin cambiar el
schema. **No requiere F9-D01 revisit si sólo lee**.

### 8.2 (E6 registry-based + E9 catalog-declarative)

Un catálogo de "types of change × required gate" hace explícitas las autoridades
no nombradas (§13 de 04). Podría vivir como `docs/00_SYSTEM/CHANGE_TYPES_CATALOG.md` sin
runtime change.

### 8.3 (E8 schema-complete + E7 shadow runtime)

Shadow runtime (correr en paralelo un runtime instrumentado sin cambiar el productivo)
permite recoger data sobre H-01 sin cruzar F9-D01 sobre el runtime real. Es un patrón
observable en otros sistemas (canary, dark launch); no ha sido considerado en CCP.

### 8.4 (E3 LLM adversarial + E4 post-tool)

Actualmente existe el subagente `code-reviewer` pero no está siendo invocado
sistemáticamente en subagentStop. Podría instrumentarse.

Las 4 regiones son insumo para `09_ALTERNATIVE_ARCHITECTURES`.

---

## 9. Trade-off surfaces

### 9.1 Simplicidad ↔ Expresividad

- Aumentar expresividad de política (YAML rico + compilador) sube complejidad.
- Reducir a "tests como canónica" pierde legibilidad humana.
- Un punto sweet-spot puede existir pero depende de las políticas reales por escribir.

### 9.2 Automatización ↔ Autoridad humana

- Automatizar verificación reduce carga sintáctica pero **no reduce autorización**.
- Automatizar autorización reduce carga humana pero requiere policy-as-code para
  autorizar mecánicamente.
- Trade-off asimétrico: verification cheap-to-mechanize, authorization costly.

### 9.3 Instrumentación ↔ Runtime stability

- Cambiar `stall-record.sh` para instrumentar más rompe F9-D01=A gate.
- Shadow runtime paga con complejidad operativa pero preserva el runtime productivo.

### 9.4 Provenance depth ↔ Human cost

- Provenance explícita (schemas ricos, references) reduce ambigüedad pero requiere que el
  humano/agente pueble metadatos.
- Provenance implícita (git blame + Markdown) es cheap pero exige reconstrucción por
  humano.

### 9.5 Consistencia entre sesiones ↔ Overhead

- Meta-doc reduce fricción entre sesiones pero crece indefinidamente.
- Sin meta-doc, cada sesión reconstruye. Sin persistencia verdadera, ambas son parches
  al mismo problema (K3-D-EXOGENOUS).

---

## 10. Combinaciones incoherentes descartadas

### 10.1 "PAC + human-only verificación semántica sin cambio en gate"

PAC produce nuevas regex; si CAP-2-semántica sigue humana y el gate no cambia, el humano
tendría que revisar cada compilación. No es peor que actual, pero no reduce carga.

### 10.2 "Cerrar LABYRINTH-1 sin cambiar K3-D-SCHEMA"

READY-03 se cerraría con caveat "N no es empírico". Es válido pero deja `U-01`/`U-02` en
UNKNOWN permanente. Coherente pero débil epistemológicamente.

### 10.3 "Nuevo agente sin catálogo de gates + sin código de gate para su categoría"

Agrega un tipo de change sin declarar la autoridad. Reproduce K3-D-OWNER-DEFAULT en más
lugares. Descartada como no viable.

---

## 11. Regiones dominadas

Una región A domina a B si en todos los ejes A es ≥ B y estrictamente > en al menos uno,
para el mismo problema.

- **Región "shadow runtime + schema completo" domina a "diferido"** para el subproblema
  "obtener data sobre H-01": mayor información, mismo coste F9-D01.
- **Región "catálogo declarativo + registry" domina a "informal"** para el subproblema
  "reducir ambigüedad de autoridad": mayor información, coste bajo.
- **Región "tests-as-canónica" domina a "duplicación actual"** en el eje E1
  únicamente si las políticas reales son fácilmente expresables como tests (asumido, no
  verificado).

Regiones **no dominadas** entre sí (Pareto):

- PAC (motor YAML) vs. discard-md (single source firewall): PAC mejora expresividad;
  discard mejora simplicidad.
- LLM adversarial post-tool vs. humano ex-post commit: LLM escala; humano tiene juicio.

---

## 12. Verdict del capítulo

- **10 ejes** identificados como reales; CCP ocupa 8 en el punto menos formalizado.
- **4 false alternatives** identificadas y expandidas a 7 puntos viables en E1×E2 y
  puntos múltiples en otras dimensiones.
- **4 false unifications** rechazadas explícitamente.
- **5 necessary distinctions** documentadas.
- **4 regiones no exploradas** con potencial arquitectónico.
- **3 combinaciones incoherentes** descartadas.
- **2 pares Pareto**, no dominadas entre sí.

El espacio arquitectónico es genuinamente mayor de lo que Kimi/Claude presentan. Las
decisiones Owner en `13` deben poder navegar este espacio, no reducirse a "PAC sí/no".
