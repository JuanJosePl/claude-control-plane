# 13 — MASTER OWNER DECISION SYSTEM

> Sistema estructurado de decisiones para el Owner. Cumple §92, §93 (owner gradient),
> §94 (decision minimization), §275 (idea→decision map). No decide por el Owner; delimita.

---

## 0. Cómo leer este documento

Cada decisión tiene:

- **ID**, **NOMBRE** (sin herencia histórica).
- **QUÉ CAPACIDAD CONTROLA** (mapa a basis K3).
- **POR QUÉ EXISTE** (evidencia y descubrimiento K3).
- **OPCIONES** (concretas, con instanciación viable).
- **EVIDENCIA** (K3 findings + corpus).
- **TRADE-OFFS** por opción.
- **DEPENDENCIAS**.
- **REVERSIBILIDAD / LOCK-IN**.
- **FAILURE MODES por opción**.
- **UNKNOWN residual**.
- **SI SE ELIGE X**: qué cambia; qué se desbloquea; qué no.
- **SI NO SE ELIGE**: qué queda igual; qué coste acumula.
- **DEFERIBLE**: cuánto tiempo/qué condición.
- **URGENCIA**: MUST-NOW / SHOULD-BEFORE-NEXT / CAN-DEFER.

**No hay recomendación por decisión**. K3 marca urgencia según análisis; el Owner
decide.

---

## 1. Vista ejecutiva de las 13 decisiones abiertas

```text
BLOQUE A — Delegation Enablement (transversal, low-cost)
  DEC-01  D-CATALOG      CAN-DEFER  (mejora todo lo demás)
  DEC-02  D-DELEG        CAN-DEFER  (mejora todo lo demás)
  DEC-03  D-LIFECYCLE    CAN-DEFER  (mejora todo lo demás)

BLOQUE B — Policy Architecture
  DEC-04  D-CANONICAL    SHOULD-BEFORE-NEXT (high lock-in)
  DEC-05  D-MOTOR        SHOULD-BEFORE-NEXT (conditional)
  DEC-06  READY-01/02    DERIVED       (auto-resolves from DEC-04+05)

BLOQUE C — Verification Delegation
  DEC-07  D-VERIFICADOR  CAN-DEFER  (S1 stable OK)

BLOQUE D — Data & Instrumentation (blocked by F9-D01)
  DEC-08  D-INSTR        SHOULD-BEFORE-NEXT (unlocks 3 UNKNOWNs)
  DEC-09  READY-03       DERIVED       (post DEC-08 + N sessions)

BLOQUE E — Format & Process
  DEC-10  READY-04       CAN-DEFER
  DEC-11  D-DEFERRAL-POLICY  SHOULD-BEFORE-NEXT (governance decay)
  DEC-12  D-META-DOC     CAN-DEFER

BLOQUE F — External-triggered
  DEC-13  Bundle: F9-D02, A-05, A-07, G-N5  WAIT-FOR-EXTERNAL
```

Urgencia consolidada: **0 MUST-NOW**, **4 SHOULD-BEFORE-NEXT** (DEC-04, DEC-05, DEC-08,
DEC-11), **6 CAN-DEFER**, **1 DERIVED-COMPOUND** (DEC-06, DEC-09), **1 EXTERNAL** (DEC-13).

Ninguna decisión es MUST-NOW porque F9-D01=A vigente + S1 estable => statu quo es viable.
Las 4 SHOULD-BEFORE-NEXT son las que evitan **degradación silenciosa**
(K3-D-EPIST-COST, K3-D-OWNER-DEFAULT, K3-D-DECISION-COUNT).

---

## 2. DEC-01 — D-CATALOG (Types of change × required gate)

- **CAPACIDAD**: CAP-AUTHZ + K3-D-OWNER-DEFAULT elimination.
- **POR QUÉ EXISTE**: `04 §5` observó tipos de cambio sin gate declarado. Cada uno
  cae por default al humano. K3-D-OWNER-DEFAULT.
- **OPCIONES**:
  - (A1) **No hacer nada**: statu quo. Default humano indefinido.
  - (A2) **Catálogo Markdown declarativo**: `docs/00_SYSTEM/CHANGE_TYPES_CATALOG.md`
    con tabla `type × gate × auth_holder × precedent`.
  - (A3) **Catálogo + hook de verificación**: hook que refuse commits que introduzcan
    tipo no listado. **Requiere F9-D01 revisit** (nuevo hook).
- **EVIDENCIA**: `04 §5` (8 tipos observados, ~3 sin gate); K3-D-OWNER-DEFAULT;
  U-11.
- **TRADE-OFFS**:
  - (A1) 0 coste; 0 mejora; K3-D-EPIST-COST sigue creciendo.
  - (A2) Bajo coste (Markdown, mantenimiento humano); alto beneficio en claridad; no
    require F9-D01 revisit.
  - (A3) Coste medio; alto beneficio; require F9-D01 revisit.
- **DEPENDENCIAS**: (A2/A3) precede a DEC-02 (D-DELEG). Sin catálogo, no hay
  categorías para delegar.
- **REVERSIBILIDAD**: alta.
- **LOCK-IN**: bajo.
- **FAILURE MODES**:
  - (A2) Catálogo desactualizado. Detectable por HRQS.
  - (A3) Hook con FP class → bloquea trabajo legítimo.
- **UNKNOWN residual**: U-11 se cierra con la enumeración inicial.
- **SI SE ELIGE A2/A3**: elimina zona gris. Habilita DEC-02.
- **SI NO SE ELIGE**: cada nuevo tipo de cambio genera improvisación.
- **DEFERIBLE**: sí, pero coste crece con cada nuevo tipo introducido.
- **URGENCIA**: CAN-DEFER (baja tasa hoy).

---

## 3. DEC-02 — D-DELEG (Delegation Contract)

- **CAPACIDAD**: CAP-AUTHZ formalización.
- **POR QUÉ EXISTE**: K3-D-DELEG-ORTOGONAL — capa transversal que mejora
  arquitecturas B/C/D.
- **OPCIONES**:
  - (B1) **No hacer nada**: delegación implícita continúa.
  - (B2) **Registry Markdown**: `docs/00_SYSTEM/DELEGATION_REGISTRY.md` con schema
    (`action_type, delegated_to, fallback, activated_by, revocable`).
  - (B3) **Registry + hook**: hook lee registry y valida que cada acción tenga
    entrada. **Requiere F9-D01 revisit**.
- **EVIDENCIA**: `09 §6` (Arquitectura E); K3-D-DELEG-ORTOGONAL; K3-D-DELEG-FIRST.
- **TRADE-OFFS**:
  - (B1) statu quo.
  - (B2) Bajo coste; alto beneficio (auditabilidad); fallback seguro (humano por
    default en gaps del registry).
  - (B3) Coste medio; máximo beneficio; require F9-D01 revisit.
- **DEPENDENCIAS**: DEC-01 (catálogo de tipos) es upstream.
- **REVERSIBILIDAD**: alta.
- **LOCK-IN**: bajo.
- **FAILURE MODES**:
  - (B2) Registry vago. Mitigable por review.
  - (B3) Hook rechaza acción legítima. Falla-cerrado seguro.
- **UNKNOWN**: si registry mecánico es suficiente para gobernanza fina.
- **SI SE ELIGE B2/B3**: K3-D-OWNER-DEFAULT eliminado. Habilita DEC-07 con claridad.
- **SI NO SE ELIGE**: default humano indefinido, invisible.
- **DEFERIBLE**: sí. Coste creciente con S2/S3.
- **URGENCIA**: CAN-DEFER (S1 OK).

---

## 4. DEC-03 — D-LIFECYCLE (Artifact lifecycles)

- **CAPACIDAD**: gobernanza de artefactos (K3-D-LIFECYCLE).
- **POR QUÉ EXISTE**: STALL events + research artifacts + deferrals sin lifecycle
  formal. `03 §10`.
- **OPCIONES**:
  - (C1) **No hacer nada**.
  - (C2) **Front-matter convención**: cada `docs/research/*.md` gana `status:`,
    `derived_from:`, `supersedes:`. Runbook periódico verifica coherencia.
  - (C3) **Registry activo**: `docs/00_SYSTEM/ARTIFACT_LIFECYCLE_REGISTRY.md` con
    transiciones auditadas.
  - (C4) **Sólo research artifacts** (subset de C2): STALL events y deferrals no cambian
    hoy.
- **EVIDENCIA**: K3-D-LIFECYCLE; V7 (`04 §8`); 75 archivos en `docs/research/` sin
  status.
- **TRADE-OFFS**:
  - (C1) statu quo; degrada con volumen (PT-3).
  - (C2) Bajo coste (front-matter); requiere disciplina.
  - (C3) Coste alto; máximo control.
  - (C4) Coste bajo; parcial; compromiso pragmático.
- **DEPENDENCIAS**: independiente de otras B/C. Beneficia a DEC-11.
- **REVERSIBILIDAD**: alta.
- **LOCK-IN**: bajo.
- **FAILURE MODES**: front-matter obsoleto (detectable por runbook).
- **UNKNOWN**: U-06 se resuelve por enumeración.
- **SI SE ELIGE C2/C3/C4**: contiene K3-D-LIFECYCLE. Habilita reducción de meta-doc
  antigua.
- **SI NO SE ELIGE**: crecimiento silencioso; PT-3 se activa antes.
- **DEFERIBLE**: sí. Coste crece con volumen.
- **URGENCIA**: CAN-DEFER (S1).

---

## 5. DEC-04 — D-CANONICAL (Fuente canónica de política)

- **CAPACIDAD**: cierre de GAP-1.
- **POR QUÉ EXISTE**: K3-D-PARTIAL demuestra que ambas representaciones son
  parciales. Ninguna es canónica hoy.
- **OPCIONES**:
  - (D1) **rules-md como canónica**: llenar placeholders, `.md` es fuente; firewall
    generado (motor) o revisado.
  - (D2) **firewall como canónica**: descartar `.md`; regex es contrato; comentarios
    inline como doc.
  - (D3) **tests como canónica**: cada policy = un test bloqueante; hooks llaman a
    tests.
  - (D4) **YAML canónica**: PAC-family; motor genera firewall (+ opcionalmente
    documentación).
  - (D5) **No decidir**: aceptar statu quo indefinido.
- **EVIDENCIA**: `06 §5` cross-product; K3-D-PARTIAL; K3-D-DERIVE-ONLY.
- **TRADE-OFFS**:
  - (D1) Legible humano; requiere motor + expresividad de Markdown restringida.
  - (D2) Menor legibilidad; máxima simplicidad; pierde intento humano.
  - (D3) Máxima verificabilidad; overhead ejecución (latency); menos legible sin
    doc separada.
  - (D4) Legibilidad media; máxima estructuración; introduce YAML como TCB.
  - (D5) statu quo. GAP-1 abierto.
- **DEPENDENCIAS**: DEC-05 (D-MOTOR) es conditional en D1/D3/D4.
- **REVERSIBILIDAD**: **BAJA** — cambiar canónica es doloroso. Único high-lock-in.
- **LOCK-IN**: alto.
- **FAILURE MODES**:
  - (D1) Motor no captura semántica → drift silencioso.
  - (D2) Perdemos memoria humana.
  - (D3) Tests como policy pueden ser gamed.
  - (D4) FP class discovery ya observada (PAC-EF-02).
- **UNKNOWN**: U-04, U-08 se aclaran post-deploy de opción elegida.
- **SI SE ELIGE**: elimina GAP-1 (o lo confirma con D5). READY-01/02 se transforman.
- **SI NO SE ELIGE**: duplicación indefinida; costo escala con nuevas policies.
- **DEFERIBLE**: sí, pero PT-2 (100+ policies) activa la urgencia.
- **URGENCIA**: SHOULD-BEFORE-NEXT (lock-in alto y aumenta con volumen).

---

## 6. DEC-05 — D-MOTOR (Mecanismo de derivación)

- **CAPACIDAD**: DERIVE en runtime (K3-D-DERIVE-ONLY).
- **POR QUÉ EXISTE**: condicional a DEC-04 en D1/D3/D4.
- **OPCIONES**:
  - (E1) **Manual sync**: humano copia canónica → firewall. Actual.
  - (E2) **Motor unidireccional** (PAC-style): canónica → firewall/tests.
  - (E3) **Motor bidireccional**: cambios en firewall triggerea canónica update.
- **EVIDENCIA**: PAC prototype existente; PAC-EF-02 como FP class.
- **TRADE-OFFS**:
  - (E1) Sin nuevo TCB; error humano posible.
  - (E2) Elimina drift; motor es nuevo TCB.
  - (E3) Máxima consistencia; máxima complejidad.
- **DEPENDENCIAS**: DEC-04 upstream (define input format).
- **REVERSIBILIDAD**: media.
- **LOCK-IN**: medio en formato canónica; motor reemplazable.
- **FAILURE MODES**:
  - (E2/E3) Motor bug → firewall incorrecto.
  - (E2/E3) FP class discovery.
- **UNKNOWN**: U-04 FP rate general.
- **SI SE ELIGE E2/E3**: READY-01/02 se convierten en edits de canónica.
- **SI NO SE ELIGE**: statu quo o solo canónica sin motor (drift persiste).
- **DEFERIBLE**: sí (conditional).
- **URGENCIA**: SHOULD-BEFORE-NEXT (conditional a DEC-04).

---

## 7. DEC-06 — READY-01/02 (derivadas de DEC-04+05)

- Auto-resuelven según elección DEC-04+05.
- Si (D5, E1): pendientes como hoy.
- Si (D1/D3/D4 + E2/E3): se convierten en actualizaciones de canónica.
- **URGENCIA**: DERIVED.

---

## 8. DEC-07 — D-VERIFICADOR (Implementación CAP-2-semántica)

- **CAPACIDAD**: CAP-2-semántica.
- **POR QUÉ EXISTE**: K3-D-CAP2 + K3-D-STAR; delegar reduce carga humana en S2/S3.
- **OPCIONES**:
  - (F1) **Humano solo** (actual).
  - (F2) **LLM adversarial + humano**: subagent `code-reviewer` invocado obligatoriamente
    en subagentStop. Humano escala.
  - (F3) **Dual-LLM**: dos LLMs adversariales, divergencia flag para humano.
  - (F4) **Segundo humano**: pair review. Alto coste.
- **EVIDENCIA**: `09 §5` Arquitectura D; U-05, U-09.
- **TRADE-OFFS**:
  - (F1) Máxima calidad; sub-escala.
  - (F2) Escala mejor; correlated failure riesgo.
  - (F3) Reduce correlated failure; complejidad + coste.
  - (F4) Impracticable con solo owner.
- **DEPENDENCIAS**: DEC-02 (D-DELEG) upstream para explicitar delegación.
- **REVERSIBILIDAD**: media.
- **LOCK-IN**: bajo.
- **FAILURE MODES**:
  - (F2/F3) Correlated failure (U-09).
  - (F2/F3) LLM alucinaciones sesgadas.
- **UNKNOWN**: U-05, U-09.
- **SI SE ELIGE F2/F3**: alivia PT-1. Introduce provider dependence.
- **SI NO SE ELIGE**: statu quo; PT-1 activa con S2.
- **DEFERIBLE**: sí bajo S1.
- **URGENCIA**: CAN-DEFER (S1 estable).

---

## 9. DEC-08 — D-INSTR (Cambiar schema hooks)

- **CAPACIDAD**: instrumentación para POL-LATENT-5 y CAP-3 completeness.
- **POR QUÉ EXISTE**: K3-D-SCHEMA (`had_alternative` hardcoded); K3-D-CAP3
  (`session_id` schema break); K3-D-F9D01-BOTTLENECK.
- **OPCIONES**:
  - (G1) **No hacer nada**: `had_alternative` sigue null; `session_id` sigue null;
    READY-03 no puede resolverse empíricamente.
  - (G2) **Modificar `stall-record.sh`**: aceptar `had_alternative` como input real +
    propagar `session_id`. Añadir `verdict:` field para clasificación. **Requiere F9-D01
    revisit puntual**.
  - (G3) **Shadow runtime**: correr un runtime paralelo instrumentado; el productivo
    no cambia. No cruza F9-D01. Alto coste operativo.
- **EVIDENCIA**: `stall-record.sh:46`; K3-D-SCHEMA; U-01, U-02.
- **TRADE-OFFS**:
  - (G1) K3-D-EPIST-COST sigue creciendo indefinidamente.
  - (G2) Bajo coste de cambio; cruza F9-D01=A. Debe presentarse como excepción o
    revisión formal.
  - (G3) No cruza F9-D01; alto coste operativo; efectividad depende de
    representatividad del shadow.
- **DEPENDENCIAS**: DEC-11 (D-DEFERRAL-POLICY) para triggerear F9-D01 revisit
  formalmente.
- **REVERSIBILIDAD**: alta (schema change; default null preserves historical).
- **LOCK-IN**: bajo.
- **FAILURE MODES**:
  - (G2) hook bug → eventos malformados. Detectable con tests.
  - (G3) shadow drift respecto al productivo.
- **UNKNOWN**: U-01, U-02 se hacen observables (no resueltos).
- **SI SE ELIGE G2**: desbloquea U-01, U-02, READY-03 empírica. Establece precedente de
  F9-D01 revisit para instrumentación.
- **SI NO SE ELIGE**: K3-D-EPIST-COST monotónico. READY-03 diferible indefinidamente.
- **DEFERIBLE**: técnicamente sí; con coste creciente.
- **URGENCIA**: SHOULD-BEFORE-NEXT (por K3-D-F9D01-BOTTLENECK).

---

## 10. DEC-09 — READY-03 (derivada de DEC-08 + N sesiones)

- Precondición: DEC-08 elegida G2/G3 + N sesiones observadas.
- Si G1 elegida: cierre con caveat "no empírico" o dejar abierto.
- **URGENCIA**: DERIVED post-DEC-08.

---

## 11. DEC-10 — READY-04 (Formato de mensaje)

- Independiente. Trivial.
- **OPCIONES**: elegir formato de mensaje entre alternativas del handoff correspondiente.
- **DEPENDENCIAS**: ninguna.
- **REVERSIBILIDAD**: alta.
- **LOCK-IN**: bajo.
- **URGENCIA**: CAN-DEFER.

---

## 12. DEC-11 — D-DEFERRAL-POLICY

- **CAPACIDAD**: cierre de K3-D-EPIST-COST + governance decay `07 §7`.
- **POR QUÉ EXISTE**: 4 deferrals abiertos ("hasta trigger concreto") sin condiciones
  mecánicas. Governance decay monotónico.
- **OPCIONES**:
  - (H1) **No hacer nada**: deferrals acumulan.
  - (H2) **Política declarativa**: cada deferimiento gana `trigger:` (condición
    mecánica o "revisión trimestral"). Sin trigger → default revisión trimestral.
  - (H3) **Política declarativa + runbook**: `maintenance.sh` incluye check
    "deferrals sin trigger o vencidos".
- **EVIDENCIA**: `07 §7`; K3-D-EPIST-COST.
- **TRADE-OFFS**:
  - (H1) statu quo.
  - (H2) Bajo coste; forzada disciplina; revisión trimestral suficiente.
  - (H3) Mayor auditabilidad; mismo coste bajo.
- **DEPENDENCIAS**: ninguna estrictamente. Facilita DEC-08 (revisita formal de F9-D01).
- **REVERSIBILIDAD**: alta.
- **LOCK-IN**: bajo.
- **FAILURE MODES**:
  - (H2) revisión trimestral se omite. Detectable por (H3).
  - (H3) runbook fallo si estructura cambia.
- **SI SE ELIGE H2/H3**: detiene governance decay. Fuerza revisión periódica.
- **SI NO SE ELIGE**: deferrals crecen; UNKNOWNs se acumulan bloqueados.
- **DEFERIBLE**: técnicamente sí, pero contradice su propio propósito.
- **URGENCIA**: SHOULD-BEFORE-NEXT.

---

## 13. DEC-12 — D-META-DOC

- **CAPACIDAD**: contención de crecimiento meta-doc (K3-D-EXOGENOUS).
- **POR QUÉ EXISTE**: 121 docs; crecimiento monotónico; K3-D-EXOGENOUS admite que
  substrate lo causa pero política puede contenerlo.
- **OPCIONES**:
  - (I1) **No hacer nada**: crecimiento libre.
  - (I2) **Política**: `docs/00_SYSTEM/` cap a 30 documentos activos; excedente →
    `archive/`. Runbook periódico.
  - (I3) **Convención por handoff**: cada nuevo handoff supersede al anterior
    (front-matter `supersedes:`), archivar automáticamente.
  - (I4) **Ambas**: I2 + I3.
- **EVIDENCIA**: K3-D-EXOGENOUS; `07 §5.3` (PT-3).
- **TRADE-OFFS**:
  - (I1) Rompe en PT-3.
  - (I2/I3/I4) Bajo coste; ayuda a S6 y a nuevos onboardings.
- **DEPENDENCIAS**: DEC-03 (lifecycle) si aplicado a `docs/00_SYSTEM/`.
- **REVERSIBILIDAD**: alta.
- **LOCK-IN**: bajo.
- **SI SE ELIGE**: retrasa PT-3.
- **URGENCIA**: CAN-DEFER.

---

## 14. DEC-13 — External-triggered bundle (F9-D02, A-05, A-07, G-N5)

- **CAPACIDAD**: capacidad relacionada a S5 (audit externo) y S4 (provider change).
- **POR QUÉ EXISTE**: cuatro deferrals con triggers externos ("compliance", "audit",
  "cliente").
- **OPCIONES**: **esperar trigger externo verificable**. No hay opción interna hoy.
- **URGENCIA**: WAIT-FOR-EXTERNAL.
- **NOTA**: DEC-11 formaliza el trigger declarativo. Ambos se refuerzan.

---

## 15. Mapa decisional consolidado

```text
                                    URGENCIA
                       ┌─────────────┬──────────────────────┐
                       │ SHOULD-NEXT │ CAN-DEFER            │
    ORTOGONAL          │             │ DEC-01 D-CATALOG     │
    (transversal)      │             │ DEC-02 D-DELEG       │
                       │             │ DEC-03 D-LIFECYCLE   │
                       │             │ DEC-10 READY-04      │
                       │             │ DEC-12 D-META-DOC    │
                       ├─────────────┼──────────────────────┤
    ESTRATÉGICA        │ DEC-04      │ DEC-07 D-VERIFICADOR │
    (arquitectura)     │ D-CANONICAL │                      │
                       │ DEC-05      │                      │
                       │ D-MOTOR     │                      │
                       │ DEC-08      │                      │
                       │ D-INSTR     │                      │
                       ├─────────────┼──────────────────────┤
    PROCESO            │ DEC-11      │                      │
                       │ D-DEFERRAL  │                      │
                       ├─────────────┴──────────────────────┤
    DERIVADA           │ DEC-06 READY-01/02 (from DEC-04+05)│
                       │ DEC-09 READY-03    (from DEC-08+N) │
                       ├─────────────────────────────────────┤
    EXTERNAL           │ DEC-13 bundle (F9-D02, A-05,07,G-N5)│
                       └─────────────────────────────────────┘
```

---

## 16. Sequencing scenarios (K3 view, sin recomendación)

### 16.1 Scenario "Owner elige mínima intervención"

- Statu quo. DEC-11 aprobada (D-DEFERRAL-POLICY). Todo lo demás CAN-DEFER.
- Consecuencia: sistema opera; K3-D-EPIST-COST se contiene por revisión trimestral;
  otros costes acumulan lento.
- Ganancia: bajo esfuerzo. Pérdida: bloqueadores estructurales persisten.

### 16.2 Scenario "Owner elige claridad y bajo coste"

- Aprobar Bloque A entero (DEC-01, DEC-02, DEC-03) + DEC-11 + DEC-12.
- Consecuencia: K3-D-OWNER-DEFAULT, K3-D-LIFECYCLE, K3-D-EPIST-COST atacados sin
  cruzar F9-D01.
- Ganancia: alta claridad. Pérdida: siguen pendientes decisiones estratégicas.

### 16.3 Scenario "Owner elige desbloquear estratégicos"

- Bloque A + DEC-11 + DEC-04 + DEC-05 (con implementación gradual).
- Consecuencia: GAP-1 cerrado. READY-01/02 se transforman.
- Ganancia: elimina duplicación. Pérdida: coste medio (motor, testing).

### 16.4 Scenario "Owner elige data para READY-03"

- DEC-11 + DEC-08 (opción G2 con F9-D01 revisit puntual y auditado).
- Consecuencia: U-01/U-02 se hacen observables. READY-03 puede resolverse con datos.
- Ganancia: cierre epistemológico. Pérdida: precedente de F9-D01 revisit (necesita
  política explícita).

### 16.5 Scenario "Owner elige escala futura"

- Bloque A + DEC-11 + DEC-07 (opción F2 con experimento pre-registro sobre U-09).
- Consecuencia: alivio de PT-1. Introduce provider dependence.
- Ganancia: preparación para S2. Pérdida: coste continuo LLM + riesgo epistemológico.

---

## 17. What K3 explicitly does NOT decide

- **No** elige entre A1/A2/A3, B1/B2/B3, C1..C4, D1..D5, E1/E2/E3, F1..F4, G1/G2/G3,
  H1..H3, I1..I4. Todas son Owner-only.
- **No** ordena las decisiones. Los escenarios §16 son ilustrativos.
- **No** revisita F9-D01 por sí solo. Sólo señala su coste epistemológico.
- **No** revisita F9-D02..F9-D05. Sólo cataloga sus implicaciones.

---

## 18. What K3 explicitly recommends (delimitando)

Recomendaciones **estructurales** (no decisiones):

1. **La lista de "decisiones pendientes" debe expandirse** de 4 (READY) a 13 en cualquier
   futuro paquete owner-facing. El paquete actual es incompleto.
2. **Marcar D-CANONICAL como high-lock-in** para su deliberación específica.
3. **DEC-11 (D-DEFERRAL-POLICY)** es candidata a mecanización (revisión trimestral por
   hook cron o runbook), ortogonal a cualquier arquitectura.
4. **Documentar K3-D-* discoveries en `DECISION_REGISTRY.md`** como contexto para futuras
   decisiones. K3 no lo hace por sí mismo (no autorizado).

---

## 19. Falsifiers para este documento

- **F-13-1**: si el Owner enfrentaría el proyecto exclusivamente en S1 estable
  indefinidamente, las urgencias SHOULD-BEFORE-NEXT son sobredimensionadas.
- **F-13-2**: si aparece evidencia empírica de que K3-D-EPIST-COST es negligible en la
  práctica, DEC-11 se degrada.
- **F-13-3**: si el sustrato cambia (S6), muchas decisiones (DEC-03, DEC-12) se
  transforman.

---

## 20. STOP

- Este documento **no autoriza** implementación.
- Este documento **no modifica** runtime, hooks, policies, registries, ni decisiones
  del owner.
- Este documento **no cierra** ningún deferimiento.
- El siguiente eslabón es el **Owner**, no M009.

**PARAR.**
