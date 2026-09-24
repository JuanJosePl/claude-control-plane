# 10 — ROOT CAPABILITY ANALYSIS

> Minimum root basis attack. Cumple §45 (root basis), §72 (basis competition), §100
> (final compression), §211 (periodic table), §213 (composition), §214 (minimization),
> §215 (sufficiency).

---

## 1. Punto de partida — herencia y reformulación

De `03 §7` la K3 minimum root basis es:

```text
ACTIVE       : { CAP-2-sintáctica, CAP-2-semántica, CAP-3 }
GAP          : { GAP-1 }
LATENT       : { POL-LATENT-5 }
SUBSTRATE    : { PROP-4 (from git) }
```

Comparación con la lista Claude/audit:

- CAP-1 → GAP-1 (carencia, no capacidad).
- CAP-2 → bifurcada (sintáctica + semántica).
- CAP-3 → mantiene con brechas.
- CAP-4 → PROP-4 (substrate).
- CAP-5 → POL-LATENT-5 (política latente, sub-implementada).

---

## 2. Attack test — completeness

**Pregunta**: ¿la K3 basis explica todo lo que la lista Claude explica?

| Fenómeno explicado por Claude/audit | Lo cubre K3? | Cómo |
|---|---|---|
| Duplicación policy/enforcement | Sí | GAP-1 |
| Recurrencia "proposer ≠ verifier" | Sí | CAP-2-semántica + sintáctica |
| Provenance en git + registries | Sí | CAP-3 |
| INC-001 loop completo | Sí | POL-LATENT-5 activada una vez |
| Reversibility por git | Sí | PROP-4 |
| F-FALSE_PASS-01 → F8-A | Sí | CAP-2-sintáctica hardening |
| PAC prototype | Sí | intento de cerrar GAP-1 |
| HRQS checklist | Sí | POL-LATENT-5 formalizada parcialmente |

Todo cubierto. **Completeness pass**.

---

## 3. Attack test — necessity

**Pregunta**: ¿cada elemento de K3 basis es necesario? ¿Alguno absorbe a otro?

### 3.1 ¿CAP-2-sintáctica absorbe CAP-3?

CAP-2-sintáctica verifica cierres; CAP-3 hace provenance. No: verificar ≠ trazar. Distintas.

### 3.2 ¿CAP-3 absorbe CAP-2-sintáctica?

Provenance sin verification no bloquea. No.

### 3.3 ¿GAP-1 absorbe CAP-2-sintáctica?

Una canónica no cerrada no elimina la necesidad de verificación runtime. No.

### 3.4 ¿POL-LATENT-5 absorbe CAP-3?

Learning loop necesita evidencia; usa CAP-3 pero no la reemplaza. No absorbe.

### 3.5 ¿PROP-4 absorbe algo?

PROP-4 es substrate. No es capacidad activa; no absorbe.

**Ningún elemento absorbe otro**. Necessity pass.

---

## 4. Attack test — sufficiency

**Pregunta**: si sólo tuviéramos estos 6 elementos, ¿qué de CCP no podríamos expresar?

### 4.1 ¿Podemos expresar "el reviewer humano commit-gate"?

- CAP-2-semántica lo describe.
- Pero **no describe** la relación autoritativa (humano tiene autoridad de owner).
- Falta: una noción de **authority holder**, no reducible a "verificador semántico".

### 4.2 ¿Podemos expresar "las decisiones ARCH-001..004 son activas y no pueden cambiar sin
autorización owner"?

- No hay entrada para "autoridad de decisión" en la basis.
- Kimi/audit lo tratan como consecuencia de "human trust boundary", pero K3 §4.7 de `05`
  distingue autorización de verificación (K3-D-AUTHZ-VS-VERIF).
- **Falta**: `CAP-AUTHZ` (autorización).

### 4.3 ¿Podemos expresar "SessionStart context injection"?

- No es una capacidad activa. Es un mecanismo del substrato-runtime CCP.
- Puede clasificarse como `SUBSTRATE-ADAPTIVE`: código que compensa fragilidad del sustrato.
- **Falta**: si consideramos que las hojas del audit incluyen sólo capacidades activas,
  entonces SessionStart cae bajo un tipo distinto ("compensatory mechanism").

### 4.4 ¿Podemos expresar "shadow runtime / dark deploy"?

No; no existe hoy. No debería requerir entrada en la basis actual.

### 4.5 Verdict de sufficiency

**Faltan dos elementos** que ni Claude ni Kimi listan:

- `CAP-AUTHZ` — capacidad de otorgar autorización. Distinguible de CAP-2-semántica.
- `COMP-SUBSTRATE` — compensación de sustrato (SessionStart, meta-doc, HRQS). No es
  capacidad; es una categoría de mecanismo.

---

## 5. Extension de la basis

Basis K3 corregida:

```text
ACTIVE CAPABILITIES (produce/verify/authorize):
  CAP-2s   Syntactic verification            (hooks, evals, gates)
  CAP-2m   Semantic verification              (currently: humano)
  CAP-3    Durable provenance / traceability  (git + registries)
  CAP-AUTHZ Authorization gating              (owner/humano por default)

GAPS (structural absences):
  GAP-1    Canonical policy source            (needed to reduce sync cost)

LATENT (declared but under-operating):
  POL-LATENT-5 Learning loop                  (INC-CTRL-REG-EV, ran once)

SUBSTRATE-INHERITED:
  PROP-4   Reversibility                      (via git)

SUBSTRATE-COMPENSATION:
  COMP-CTX Session context re-injection       (SessionStart + meta-doc)
```

Total: **4 capacidades activas + 1 gap + 1 política latente + 1 substrate + 1 compensation
category** = 8 elementos.

### 5.1 ¿Es esto una explosión?

Solía haber 5 CAP. Ahora hay 8 elementos. ¿Perdimos parsimonia?

- No — los 8 son **más informativos** (distinguen categorías que la lista de 5 mezclaba).
- La lista de 5 asignaba a "capabilities" cosas que no lo eran (PROP-4 substrate;
  POL-LATENT-5 policy latente; GAP-1 carencia).
- **La correcta unidad de comparación no es "número de elementos" sino "información por
  elemento"**. K3 basis tiene más elementos pero cada uno es homogéneo internamente.

### 5.2 Test de composición

Combinaciones observables:

- **CAP-2s + CAP-3** → enforceable traceability (etiqueta compuesta, no primitiva).
- **CAP-2m + CAP-AUTHZ** → gobierno humano (topología estrella).
- **POL-LATENT-5 + CAP-3** → learning loop cuando se dispara.
- **GAP-1 + CAP-AUTHZ** → cada cambio de policy requiere autorización manual (statu quo).

Las combinaciones **no** son emergentes por sí solas; son propiedades de la interacción
de los elementos. La periodic-table analogy (§211) sugiere que los "compuestos" son las
propiedades observables del sistema.

---

## 6. Ataque a "instrucción set" (§212)

Si CCP tuviera un conjunto mínimo de operaciones conceptuales, la enumeración sería:

```text
BLOCK       — deny a tool invocation
EMIT        — record an event
GATE        — condition a state transition on artifact presence
DERIVE      — compute one representation from another (currently missing)
VERIFY      — assert a property mechanically (syntactic)
JUDGE       — assert a property with human review (semantic)
AUTHORIZE   — grant permission for a change
RECORD      — write to a canonical registry
OBSERVE     — read state without modifying
REVERSE     — undo (via git)
```

10 operaciones. Cinco son mecánicas (BLOCK, EMIT, GATE, VERIFY, RECORD, OBSERVE, REVERSE).
Tres son humanas (JUDGE, AUTHORIZE, RECORD-humano). Una está ausente (DERIVE).

Consistencia con basis:

- CAP-2s = BLOCK + VERIFY + GATE.
- CAP-2m = JUDGE.
- CAP-3 = EMIT + RECORD + OBSERVE.
- CAP-AUTHZ = AUTHORIZE.
- GAP-1 = falta de DERIVE.
- POL-LATENT-5 = ciclo VERIFY+RECORD+JUDGE+AUTHORIZE que no se dispara regularmente.
- PROP-4 = REVERSE.
- COMP-CTX = OBSERVE + RECORD (leer estado, reinyectarlo).

### 6.1 ¿Es este el instruction set correcto?

**Ataque §214 minimization**: ¿alguno se puede combinar?

- BLOCK + VERIFY: BLOCK es "denegar"; VERIFY es "afirmar propiedad". Distintos.
  BLOCK usa VERIFY. Composable pero no idénticos.
- RECORD + EMIT: RECORD escribe a canónica; EMIT escribe a stream write-only. Distintos
  destinos, distintos consumers.
- JUDGE + AUTHORIZE: ambos humanos. Pero AUTHORIZE otorga permiso; JUDGE afirma propiedad.
  K3-D-AUTHZ-VS-VERIF los distingue explícitamente.

**Ataque §215 sufficiency**: ¿podríamos expresar CCP con menos?

- Sin DERIVE: statu quo. Coste = duplicación.
- Sin JUDGE: statu quo automatizado. Peligroso porque delega semántica.
- Sin AUTHORIZE: no owner gates. Cambios peligrosos sin control.
- Sin OBSERVE: no context injection. Rompe SessionStart.

Ninguna eliminación es viable.

### 6.2 Verdict instruction set

**10 operaciones son mínimas para expresar CCP**. Ninguna es redundante. `DERIVE` es la
única ausente hoy (produce GAP-1).

---

## 7. Comparación de bases

```text
                                     Kimi K2.7   Claude audit    K3
Number of "root elements"            5 (R1-R5)   5 (CAP-1..5)    8
Includes GAP category                No          Partial          Sí
Includes SUBSTRATE distinction       No          No               Sí
Includes COMPENSATION category       No          No               Sí
Bifurcates CAP-2                     No          No               Sí
Distinguishes AUTHZ from VERIF       No          No               Sí
Includes latent-vs-active            No          No               Sí
```

**K3 basis es asimétrica** (elementos de categorías distintas), pero más informativa. La
comparación por "número de root elements" es engañosa porque las categorías no son
equivalentes.

---

## 8. Instrumento periodic table (§211)

Aplicando la agrupación por función a mecanismos observables de CCP:

```text
TRANSFORM   : compile_policies.sh (prototype only)
STORE       : PROJECT_STATE.md, EVIDENCE_REGISTRY.md, DECISION_REGISTRY.md, STALL_POLICY_LOG.jsonl
DECIDE      : humano (commit review, owner authorization)
VERIFY      : bash-firewall.sh, secret-guard.sh, task-completed-evidence.sh, maintenance.sh
AUTHORIZE   : humano (via commit/registry edit)
OBSERVE     : session-start-*.sh, subagent-context.sh, query-log.sh
DERIVE      : (missing)
REVERSE     : git
LEARN       : humano (INC-CTRL-REG-EV manual)
CONNECT     : cross-refs Markdown (manual)
```

10 funciones observadas. **DERIVE** ausente en runtime; existe sólo en prototype
(`compile_policies.sh`). Esto vuelve visible que **el runtime CCP no tiene un solo mecanismo
que produzca una capa desde otra**. Todo lo demás está representado.

---

## 9. Ataque a `enforceable traceability` como primitiva

Del audit §24.1 se hereda como candidata a root capability. K3 §8 de `03` la degradó a
etiqueta compuesta (CAP-2s + CAP-3).

Test §221 anti-gravity: si eliminamos "enforceable traceability" del vocabulario, ¿el
sistema se explica igual?

- Sí. `CAP-2s + CAP-3` son elementos distintos con implementaciones distintas.
- La etiqueta compuesta es conveniente para conversación; no aporta información nueva.

**Confirmed**: `enforceable traceability` no es primitiva. Es una **conveniencia
narrativa** sobre dos primitivas ortogonales.

---

## 10. Descubrimientos K3 sobre la basis

### 10.1 K3-D-BASIS-CAT (categorías asimétricas)

La correcta basis de CCP tiene **categorías distintas** (capacidad activa vs. gap vs.
substrate vs. compensation vs. política latente). Aplanarlas a una sola dimensión pierde
información crucial.

### 10.2 K3-D-DERIVE-ONLY (única operación ausente)

De 10 operaciones conceptuales, sólo **DERIVE** está ausente en runtime. Todas las demás
existen en algún mecanismo. Esto **precisa GAP-1**: no es "falta una capacidad de
enforcement"; es "falta una operación de derivación entre representaciones".

### 10.3 K3-D-AUTHZ-CAT (autorización como capacidad de primer orden)

CAP-AUTHZ debe estar en la basis. Sin ella, la topología estrella no se explica
completamente y la delegación explícita (Arquitectura E de `09`) no tiene home.

### 10.4 K3-D-COMP-CAT (compensación como categoría)

`COMP-CTX` (SessionStart, meta-doc, HRQS) es una **categoría** de mecanismo que absorbe
fragilidad del sustrato. No es capacidad activa (no produce nada nuevo); no es gap (existe);
no es substrate (es código CCP). Es un tipo aparte.

Consecuencia: al proyectar arquitecturas alternativas, los mecanismos COMP-* pueden
evaluarse por "¿siguen siendo necesarios si el substrate mejora?" Bajo K3-D-EXOGENOUS
(`04 §9`), muchos COMP-* colapsarían.

---

## 11. Compression test (§100)

Comprimir K3 basis a menos elementos:

- ¿Podemos fusionar CAP-2s y CAP-2m? No (bifurcación necesaria).
- ¿Podemos fusionar CAP-3 y COMP-CTX? Ambos "leen estado", pero CAP-3 escribe canónico
  y COMP-CTX re-inyecta contexto. Distintos.
- ¿Podemos fusionar POL-LATENT-5 y CAP-AUTHZ? POL-LATENT-5 es un ciclo (VERIFY, JUDGE,
  RECORD); CAP-AUTHZ es un permiso puntual. Distintos.

**No hay compresión adicional viable sin perder información**. La basis de 8 elementos es
mínima para explicar CCP con las distinciones que el código exige.

---

## 12. Falsifiers de la K3 basis

- **F-BASIS-1**: si aparece un caso donde CAP-2-sintáctica y CAP-2-semántica son la misma
  cosa (una acción que puede ser evaluada por regex Y por juicio con idéntico resultado),
  la bifurcación es falsa.
  - Búsqueda: F-FALSE_PASS-01 muestra que hay claims que sólo la revisión humana detecta.
    No hay falsifier.
- **F-BASIS-2**: si el sistema opera sin CAP-AUTHZ (ninguna acción requiere autorización
  humana), CAP-AUTHZ es innecesaria.
  - Búsqueda: F9-D01..D05 son actos de CAP-AUTHZ. Persistent.
- **F-BASIS-3**: si COMP-CTX no reduce ninguna variable observable, es dead-code.
  - Búsqueda: SessionStart hooks se ejecutan cada arranque; la meta-doc es leída (parcialmente).
    No falsificado.
- **F-BASIS-4**: si DERIVE aparece en algún hook activo (no en prototype), GAP-1 es
  incorrecto.
  - Búsqueda: `grep` de derive-like mechanisms en `.claude/hooks/` no arroja resultados.
    Confirmado.

Ningún falsifier disparado.

---

## 13. Verdict del capítulo

- **K3 basis**: 4 capacidades activas + 1 gap + 1 latente + 1 substrate + 1 compensation
  = 8 elementos asimétricos.
- **Mínima** con las distinciones que el corpus exige.
- **Ninguna compresión adicional viable** sin perder información.
- **10 operaciones conceptuales** identificadas; sólo DERIVE ausente en runtime.
- **CAP-AUTHZ (autorización) y COMP-CTX (compensación de substrate)** son adiciones netas
  a la lista Claude/audit — su ausencia era una limitación de las listas anteriores.
- **enforceable traceability** confirmado como etiqueta compuesta, no primitiva.

Insumo directo para `11_ROOT_DECISION_ANALYSIS` (cada decisión Owner mapea a uno o más
elementos de la basis) y `13_MASTER_OWNER_DECISION_SYSTEM`.
