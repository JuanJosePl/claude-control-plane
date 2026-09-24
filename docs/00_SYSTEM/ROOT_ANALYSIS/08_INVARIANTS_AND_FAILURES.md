# 08 — INVARIANTS AND FAILURES

> Fase 10 del protocolo maestro: descubrir invariantes reales, mapear la superficie de fallo
> y evaluar el complexity budget de componentes y propuestas.

---

## 1. Invariant Discovery

### INV-1 — Evidence-gated completion

| Campo | Valor |
|---|---|
| ENUNCIADO | Una CONTRACTUAL TASK no se cierra sin evidencia VERIFIED que satisfaga el contrato. |
| ¿SE VERIFICA EN EL REPO? | Sí [VERIFICADO] |
| ¿ESTÁ ENFORCED? | Sí — `task-completed-evidence.sh` bloquea con exit 2. |
| ¿QUÉ PASA SI SE VIOLA? | Un agente puede declarar DONE sin haber cumplido el contrato. |
| ¿CÓMO SE DETECTA? | Hook compara payload con `EVIDENCE_REGISTRY.md`. |
| ¿CÓMO SE RECUPERA? | Rechazar TaskCompleted; exigir evidencia válida. |

### INV-2 — Fail-closed enforcement

| Campo | Valor |
|---|---|
| ENUNCIADO | Si un hook de seguridad no puede determinar que una acción es segura, la bloquea. |
| ¿SE VERIFICA EN EL REPO? | Sí [VERIFICADO] |
| ¿ESTÁ ENFORCED? | Sí — F8-A y F8-B hicieron explícito el fail-closed. |
| ¿QUÉ PASA SI SE VIOLA? | Bypasses silenciosos (ej. JSON malformado pasando como vacío). |
| ¿CÓMO SE DETECTA? | Fixtures de regresión; maintenance suite. |
| ¿CÓMO SE RECUPERA? | Endurecer hook; añadir fixture. |

### INV-3 — Project State authority

| Campo | Valor |
|---|---|
| ENUNCIADO | `PROJECT_STATE.md` es la fuente única de estado operativo; sus mirrors no la reemplazan. |
| ¿SE VERIFICA EN EL REPO? | Sí [VERIFICADO] |
| ¿ESTÁ ENFORCED? | Parcialmente — `session-start-compact.sh` detecta drift. |
| ¿QUÉ PASA SI SE VIOLA? | Estado inconsistente; decisiones basadas en información errónea. |
| ¿CÓMO SE DETECTA? | Drift detection en SessionStart; maintenance. |
| ¿CÓMO SE RECUPERA? | Manual — actualizar PROJECT_STATE desde el canonical. |

### INV-4 — Owner authorization for P0 changes

| Campo | Valor |
|---|---|
| ENUNCIADO | Cambios en hooks P0, runtime crítico o fases requieren autorización explícita del Owner. |
| ¿SE VERIFICA EN EL REPO? | Sí [VERIFICADO] |
| ¿ESTÁ ENFORCED? | Por política y convención; no por hook técnico. |
| ¿QUÉ PASA SI SE VIOLA? | Cambio de enforcement sin control. |
| ¿CÓMO SE DETECTA? | Git diff + reviewer humano. |
| ¿CÓMO SE RECUPERA? | Revertir; requerir autorización. |

### INV-5 — F7/F8 frozen

| Campo | Valor |
|---|---|
| ENUNCIADO | F7 y F8 runtime, evidence y regressions permanecen congelados salvo nueva fase autorizada. |
| ¿SE VERIFICA EN EL REPO? | Sí [VERIFICADO] |
| ¿ESTÁ ENFORCED? | Por decisión F9-D01=A; por convención; por Git checkpoints. |
| ¿QUÉ PASA SI SE VIOLA? | Perder baseline de confianza; invalidar evidence histórica. |
| ¿CÓMO SE DETECTA? | Git diff contra checkpoints `47874a5` y `2cd7953`. |
| ¿CÓMO SE RECUPERA? | Revertir; abrir nueva fase con contrato. |

### INV-6 — Evidence append-only

| Campo | Valor |
|---|---|
| ENUNCIADO | Las entradas `EV-NNN` no se modifican; las correcciones son nuevas entradas. |
| ¿SE VERIFICA EN EL REPO? | Sí por convención [DOCUMENTADO] |
| ¿ESTÁ ENFORCED? | No técnicamente; por política y reviewer. |
| ¿QUÉ PASA SI SE VIOLA? | Provenance perdida; posible falsificación. |
| ¿CÓMO SE DETECTA? | Git diff; reviewer. |
| ¿CÓMO SE RECUPERA? | Revertir; F9-D04 requiere requerimiento externo para append-only técnico. |

### INV-7 — Maintenance 12/12 PASS

| Campo | Valor |
|---|---|
| ENUNCIADO | `evals/maintenance.sh` debe reportar 12/12 PASS para considerar el repositorio sano. |
| ¿SE VERIFICA EN EL REPO? | Sí [VERIFICADO] |
| ¿ESTÁ ENFORCED? | Sí — script ejecutable; CI workflow. |
| ¿QUÉ PASA SI SE VIOLA? | Estado del repo no verificable; posible drift. |
| ¿CÓMO SE DETECTA? | Ejecutar `bash evals/maintenance.sh`. |
| ¿CÓMO SE RECUPERA? | Corregir fallo detectado. |

### INV-8 — Human reviewer as trust boundary

| Campo | Valor |
|---|---|
| ENUNCIADO | El reviewer humano es el trust boundary final para cambios que cruzan el alcance de los hooks. |
| ¿SE VERIFICA EN EL REPO? | Sí [VERIFICADO] |
| ¿ESTÁ ENFORCED? | Por política; no técnicamente. |
| ¿QUÉ PASA SI SE VIOLA? | Bypass de controles; cambios no autorizados. |
| ¿CÓMO SE DETECTA? | Git diff; audit trail. |
| ¿CÓMO SE RECUPERA? | Revertir; reforzar HRQS. |

---

## 2. Failure Surface Map

### FS-1 — Acumulación de regex en `bash-firewall.sh`

| Campo | Valor |
|---|---|
| TIPO | arquitectónico |
| DESCRIPCIÓN | `bash-firewall.sh` combina demasiadas familias de patrones en un solo archivo. |
| CAUSA RAÍZ | Ausencia de motor de políticas; cada nueva amenaza añade regex manual. |
| SÍNTOMA | Dificultad para razonar sobre cobertura; riesgo de FP/FN silenciosos. |
| IMPACTO | Alto si escala; medio actualmente. |
| DETECTABILIDAD | Media — requiere auditoría manual. |
| RECUPERABILIDAD | Alta — refactorizar o adoptar PAC. |
| PREVENCIÓN | PAC; métrica de cobertura; tests por familia. |
| MECANISMO ACTUAL | PARCIAL — maintenance verifica sintaxis, no semántica. |

### FS-2 — Falso positivo no clasificado (PAC-EF-02)

| Campo | Valor |
|---|---|
| TIPO | enforcement / observabilidad |
| DESCRIPCIÓN | Un nombre de patrón en un literal produce stall sin contexto suficiente para el revisor. |
| CAUSA RAÍZ | Regex no distingue intención semántica; `had_alternative=null`. |
| SÍNTOMA | Stall difícil de clasificar; fricción humana. |
| IMPACTO | Medio — afecta productividad, no seguridad. |
| DETECTABILIDAD | Media — requiere revisión humana con HRQS. |
| RECUPERABILIDAD | Alta — READY-04 mejora mensajes; PAC-EF-02 documentado. |
| PREVENCIÓN | READY-04; clasificación automática de FP conocidos. |
| MECANISMO ACTUAL | PARCIAL — HRQS añadido en M008. |

### FS-3 — Evidencia incorrecta o falsificada

| Campo | Valor |
|---|---|
| TIPO | evidencia |
| DESCRIPCIÓN | Una entrada `EV-NNN` no corresponde al artifact real o al contrato. |
| CAUSA RAÍZ | `artifact_hash` no se recompute; `contract_hash` no se deriva automáticamente. |
| SÍNTOMA | TaskCompleted pasa con evidencia inválida. |
| IMPACTO | Alto — socava el núcleo de CCP. |
| DETECTABILIDAD | Baja — solo reviewer humano detecta inconsistencias. |
| RECUPERABILIDAD | Media — requiere auditoría y nuevas entradas. |
| PREVENCIÓN | A-05/A-07 (diferido); reviewer humano. |
| MECANISMO ACTUAL | PARCIAL — Git diff + reviewer. |

### FS-4 — Drift de `PROJECT_STATE.md`

| Campo | Valor |
|---|---|
| TIPO | estado |
| DESCRIPCIÓN | Estado operativo no refleja la realidad del repo. |
| CAUSA RAÍZ | Actualización manual; posible olvido. |
| SÍNTOMA | Decisión basada en estado obsoleto. |
| IMPACTO | Medio. |
| DETECTABILIDAD | Alta — `session-start-compact.sh` + maintenance. |
| RECUPERABILIDAD | Alta — actualizar estado. |
| PREVENCIÓN | Drift detection; maintenance. |
| MECANISMO ACTUAL | EXISTE. |

### FS-5 — Hook no intercepta nuevo tipo de payload

| Campo | Valor |
|---|---|
| TIPO | enforcement |
| DESCRIPCIÓN | Un cambio en el runtime de Claude Code altera el payload y el hook no lo reconoce. |
| CAUSA RAÍZ | Dependencia del shape actual del payload; native runtime NOT_VERIFIED. |
| SÍNTOMA | Comando pasa sin verificación o bloqueo inesperado. |
| IMPACTO | Alto si ocurre. |
| DETECTABILIDAD | Baja sin probes nativos. |
| RECUPERABILIDAD | Media — actualizar hook; requeriría F9-D02 reconsideración. |
| PREVENCIÓN | Native runtime probes; tests de payload. |
| MECANISMO ACTUAL | NO EXISTE — F9-D02=B. |

### FS-6 — Reviewer humano omite cambio P0

| Campo | Valor |
|---|---|
| TIPO | coordinación |
| DESCRIPCIÓN | Un cambio en hooks P0 pasa sin que el reviewer identifique su naturaleza. |
| CAUSA RAÍZ | Falta de HRQS antes de M008; cambios pequeños pueden parecer inocuos. |
| SÍNTOMA | Enforcement alterado sin autorización. |
| IMPACTO | Alto. |
| DETECTABILIDAD | Media — Git diff muestra el cambio; depende del reviewer. |
| RECUPERABILIDAD | Alta — revertir. |
| PREVENCIÓN | HRQS; checklist de cambios P0; owner gates. |
| MECANISMO ACTUAL | PARCIAL — HRQS añadido. |

### FS-7 — Materialización de LABYRINTH-1

| Campo | Valor |
|---|---|
| TIPO | decisión / observabilidad |
| DESCRIPCIÓN | Aparece un bypass real con alternativa viable en uso de producción. |
| CAUSA RAÍZ | Residual aceptado en READY-03 sin datos H-01. |
| SÍNTOMA | STALL_POLICY event con `had_alternative` verdadero; posible bypass. |
| IMPACTO | Dependiente del contexto; potencialmente alto. |
| DETECTABILIDAD | Media — R-2 instrumentado; requiere threshold N. |
| RECUPERABILIDAD | Alta si trigger definido — reabrir LABYRINTH-1. |
| PREVENCIÓN | READY-03 con N definido; monitor H-01; READY-01/02. |
| MECANISMO ACTUAL | PARCIAL — instrumentación existe, aceptación no. |

### FS-8 — Dependencia de tools externos en maintenance

| Campo | Valor |
|---|---|
| TIPO | dependencia |
| DESCRIPCIÓN | `maintenance.sh` depende de bash, jq y posiblemente otros binarios. |
| CAUSA RAÍZ | Scripts shell requieren entorno. |
| SÍNTOMA | Maintenance falla en entorno sin tools. |
| IMPACTO | Bajo en entorno controlado; medio si se cambia de CI. |
| DETECTABILIDAD | Alta — maintenance falla inmediatamente. |
| RECUPERABILIDAD | Alta — instalar dependencias. |
| PREVENCIÓN | Documentar dependencias; contenerizar. |
| MECANISMO ACTUAL | PARCIAL — GitHub Actions controlado. |

### FS-9 — Context pack desactualizado

| Campo | Valor |
|---|---|
| TIPO | contexto |
| DESCRIPCIÓN | Un context pack contiene información obsoleta que guía al agente a una decisión incorrecta. |
| CAUSA RAÍZ | Actualización manual; falta de invalidación automática. |
| SÍNTOMA | Decisiones del agente basadas en estado antiguo. |
| IMPACTO | Medio. |
| DETECTABILIDAD | Baja — solo se detecta por comportamiento anómalo. |
| RECUPERABILIDAD | Alta — actualizar pack. |
| PREVENCIÓN | Revisión periódica; versionado. |
| MECANISMO ACTUAL | PARCIAL — no hay cadencia formal. |

### FS-10 — F9-D01=A interpretado como "nunca más cambios"

| Campo | Valor |
|---|---|
| TIPO | interpretación |
| DESCRIPCIÓN | La decisión de no implementar F9 se interpreta como prohibición absoluta de cualquier cambio. |
| CAUSA RAÍZ | Ambigüedad en la comunicación de la decisión. |
| SÍNTOMA | Se rechazan incluso mejoras autorizadas (HRQS, PAC corpus). |
| IMPACTO | Medio — paraliza progreso legítimo. |
| DETECTABILIDAD | Media — requiere revisar si el cambio es runtime o documentation. |
| RECUPERABILIDAD | Alta — aclarar alcance de F9-D01=A. |
| PREVENCIÓN | Documentación explícita en `F9_OWNER_DECISIONS.md`. |
| MECANISMO ACTUAL | EXISTE — `F9_OWNER_DECISIONS.md` §4 define scope. |

---

## 3. Complexity Budget

### 3.1 Componentes actuales

| Elemento | Complejidad | Beneficio | B/C |
|---|---|---|---|
| `bash-firewall.sh` | ALTA | ALTO | = (beneficio alto pero complejidad creciente) |
| `task-completed-evidence.sh` | MEDIA | ALTO | > |
| `secret-guard.sh` | BAJA | ALTO | > |
| `EVIDENCE_REGISTRY.md` | MEDIA | ALTO | > |
| `PROJECT_STATE.md` | MEDIA | ALTO | > |
| `maintenance.sh` | MEDIA | ALTO | > |
| `CCP_EXPLORATION_ENGINE.md` | MEDIA | ALTO | > |
| Prototipo PAC | MEDIA | MEDIO (research) | = (solo research) |
| HRQS §13 | BAJA | MEDIO | > |
| Duplicación política/enforcement | ALTA | BAJO | < |
| Múltiples archivos de decisiones | MEDIA | BAJO | < |
| Investigación NH-08/AC-03/CDT-02 sin trigger | ALTA | BAJO | < |

### 3.2 Propuestas

| Elemento | Complejidad | Beneficio | B/C | Veredicto |
|---|---|---|---|---|
| Adoptar PAC en producción | ALTA | ALTO | = / > | Justificado solo si escala políticas |
| READY-01 (4 reparaciones textuales) | BAJA | MEDIO | > | Recomendado si owner autoriza |
| READY-02 (P1'+P2'+NH-09) | BAJA | MEDIO | > | Recomendado si owner autoriza |
| READY-03 (L1-C acceptance) | BAJA | ALTO | > | Recomendado con N=1 |
| READY-04 (enhanced-B messages) | BAJA | MEDIO | > | Opcional, mejora calidad |
| A-05 artifact hash recompute | MEDIA | BAJO | < | Diferido correctamente |
| A-07 hook self-mod detection | MEDIA | BAJO | < | Diferido correctamente |
| G-N5 registry append-only | MEDIA | BAJO | < | Diferido correctamente |
| Native runtime probes | ALTA | DESCONOCIDO | ? | Diferido correctamente |

---

## 4. Resumen de la fase 10

- **Invariantes reales:** evidence-gated completion, fail-closed, Project State authority, Owner auth for P0, F7/F8 frozen, evidence append-only, maintenance 12/12, human reviewer trust boundary.
- **Invariantes no técnicamente enforced:** evidence append-only, Owner auth for P0, human reviewer boundary.
- **Superficie de fallo principal:** `bash-firewall.sh` acumulación de regex; evidencia incorrecta/falsificada; bypass nativo no detectado; materialización de LABYRINTH-1; omisión de reviewer humano.
- **Fallos sin detección automática:** FS-3 (evidencia incorrecta), FS-5 (payload nativo), FS-9 (context pack obsoleto).
- **Fallos sin recuperación automática:** FS-3, FS-7 (depende de trigger), FS-5.
- **Complexity budget:** duplicación política y múltiples archivos de decisiones tienen B/C < 1; READY-01/02/03/04 tienen B/C > 1.
