# 03 — DECISION ARCHITECTURE

> Fase 4 del protocolo maestro: extraer el ledger completo de decisiones, construir el grafo
> causal y colapsar decisiones secundarias hacia decisiones raíz.

---

## 1. Decision Ledger Completo

### 1.1 Decisiones arquitectónicas del build (ARCH-xxx)

#### ARCH-001 — Scope de proyecto

| Campo | Valor |
|---|---|
| ID | ARCH-001 |
| TEXTO | El control plane se instala a nivel de proyecto en `.claude/`. |
| FECHA | 2026-09-16 |
| MOTIVO DOCUMENTADO | Necesidad de un harness por proyecto sin modificar el código de producción del proyecto destino. |
| EVIDENCIA QUE LA SOPORTA | EV-001; `install.sh` instala en `.claude/` del proyecto destino [VERIFICADO]. |
| ALTERNATIVAS CONSIDERADAS | Instalación global; instalación como dependencia npm/composer; plugin de IDE. |
| ALTERNATIVAS NO CONSIDERADAS | Ninguna documentada explícitamente. |
| CONSECUENCIAS DIRECTAS | Cada proyecto tiene su propio control plane; desacoplamiento del código de producción; posibilidad de versionado por proyecto. |
| CONSECUENCIAS INDIRECTAS | Requiere installer idempotente; trust boundary Git + reviewer humano del proyecto. |
| DEPENDENCIAS | Ninguna (decisión raíz temprana). |
| DECISIONES QUE GENERA | ARCH-002, ARCH-003, todos los hooks y registries viven bajo `.claude/`. |
| DECISIONES QUE ELIMINA | Cualquier diseño global o centralizado. |
| REVERSIBILIDAD | ALTA — cambiar scope implica reescribir `install.sh` y mover archivos. |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con repositorio real [VERIFICADO]. |

#### ARCH-002 — Carga de context packs por rol

| Campo | Valor |
|---|---|
| ID | ARCH-002 |
| TEXTO | `SubagentStart.additionalContext` carga packs por rol; no se depende de `skills:` en frontmatter de agentes sin prueba de runtime. |
| FECHA | 2026-09-16 |
| MOTIVO DOCUMENTADO | Evitar depender de mecanismos de carga de skills no verificados en runtime nativo. |
| EVIDENCIA QUE LA SOPORTA | EV-001; `subagent-context.sh` implementa carga selectiva [VERIFICADO]. |
| ALTERNATIVAS CONSIDERADAS | Usar `skills:` en frontmatter de agentes. |
| ALTERNATIVAS NO CONSIDERADAS | Ninguna documentada. |
| CONSECUENCIAS DIRECTAS | Contexto por rol controlado explícitamente; evita sorpresas de carga nativa. |
| CONSECUENCIAS INDIRECTAS | Mantiene viva la pregunta sobre runtime nativo (F9-D02=B). |
| DEPENDENCIAS | ARCH-001. |
| DECISIONES QUE GENERA | Definición de 6 context packs; agente `code-reviewer` con contexto fresco. |
| DECISIONES QUE ELIMINA | Cualquier diseño que asuma skills nativos verificados. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con repositorio real [VERIFICADO]. |

#### ARCH-003 — Ruta canónica de evidence

| Campo | Valor |
|---|---|
| ID | ARCH-003 |
| TEXTO | Toda evidencia de cambios vive en `docs/00_SYSTEM/EVIDENCE_REGISTRY.md`. |
| FECHA | 2026-09-16 |
| MOTIVO DOCUMENTADO | Una sola fuente de verdad para evidencia verificada. |
| EVIDENCIA QUE LA SOPORTA | EV-001; `EVIDENCE_REGISTRY.md` existe con 16 entradas [VERIFICADO]. |
| ALTERNATIVAS CONSIDERADAS | Evidencia dispersa por fase; evidencia en Git tags; evidencia en JSON. |
| CONSECUENCIAS DIRECTAS | `task-completed-evidence.sh` consulta un único registro. |
| CONSECUENCIAS INDIRECTAS | Centraliza riesgo de falsificación/omisión en un archivo; requiere reviewer humano. |
| DEPENDENCIAS | ARCH-001. |
| DECISIONES QUE GENERA | Formato EV-NNN; schema de evidence; maintenance verifica conteo. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con repositorio real [VERIFICADO]. |

#### ARCH-004 — Task Tracking Semantics

| Campo | Valor |
|---|---|
| ID | ARCH-004 |
| TEXTO | El trabajo se clasifica como CONTRACTUAL TASK, INTERNAL TODO / CHECKLIST, SUBTASK o RESEARCH NOTE. Solo CONTRACTUAL TASK requiere evidencia VERIFIED y pasa por TaskCompleted. |
| FECHA | 2026-09-18 (F7); addendum F8-A 2026-09-19 |
| MOTIVO DOCUMENTADO | Evitar que TODOs de investigación pasen por evidence gate; evitar false-PASS por reutilización de task_id. |
| EVIDENCIA QUE LA SOPORTA | EV-012 (F7); EV-015 (F8-A); `F7_F12_RESEARCH_HANDOFF.md` §J/AI [VERIFICADO]. |
| ALTERNATIVAS CONSIDERADAS | Todo trabajo requiere evidence; ninguna clasificación. |
| CONSECUENCIAS DIRECTAS | Diferenciación de riesgo por tipo de trabajo; research notes no bloquean. |
| CONSECUENCIAS INDIRECTAS | F8-A endurece contract_hash a obligatorio, cerrando transición. |
| DEPENDENCIAS | F2 evidence contract. |
| DECISIONES QUE GENERA | F8-A addendum; task_id con formato `<fase>-<slug>-YYYY-MM-DD-<hash>`. |
| REVERSIBILIDAD | MEDIA — cambiar semántica afecta todos los task_id históricos. |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con repositorio real [VERIFICADO]. |

#### F8-A — contract_hash obligatorio

| Campo | Valor |
|---|---|
| ID | F8-A |
| TEXTO | `contract_hash` es obligatorio para toda CONTRACTUAL TASK. Su omisión es fail-closed y bloquea TaskCompleted con exit 2. |
| FECHA | 2026-09-19 |
| MOTIVO DOCUMENTADO | Cerrar bypass F-FALSE_PASS-01 (task_id reutilizado sin contract_hash). |
| EVIDENCIA QUE LA SOPORTA | EV-015; `task-completed-evidence.sh` requiere contract_hash [VERIFICADO]. |
| ALTERNATIVAS CONSIDERADAS | Mantener opcional con warning; usar hash de artifact únicamente. |
| CONSECUENCIAS DIRECTAS | TaskCompleted falla cerrado si falta contract_hash. |
| CONSECUENCIAS INDIRECTAS | Aumenta fricción legítima para tareas sin contrato explícito. |
| DEPENDENCIAS | ARCH-004. |
| REVERSIBILIDAD | MEDIA |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con repositorio real [VERIFICADO]. |

#### F8-B — Reject malformed JSON en firewall

| Campo | Valor |
|---|---|
| ID | F8-B |
| TEXTO | `bash-firewall.sh` rechaza JSON malformado como bloqueo (fail-closed). |
| FECHA | 2026-09-19 |
| MOTIVO DOCUMENTADO | JSON malformado pasaba como comando vacío, permitiendo bypass. |
| EVIDENCIA QUE LA SOPORTA | EV-016; `bash-firewall.sh` valida JSON parseable [VERIFICADO]. |
| ALTERNATIVAS CONSIDERADAS | Permitir payload malformado con warning. |
| CONSECUENCIAS DIRECTAS | JSON inválido → block. |
| CONSECUENCIAS INDIRECTAS | Posible FP si runtime cambia payload shape. |
| DEPENDENCIAS | F7 firewall. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con repositorio real [VERIFICADO]. |

---

### 1.2 Decisiones del gate F9 (F9-D01..D05)

#### F9-D01 — Keep F9 implementation closed

| Campo | Valor |
|---|---|
| ID | F9-D01 |
| TEXTO | No se autoriza implementación runtime de F9. F7/F8 permanecen congelados. |
| FECHA | 2026-09-20 |
| MOTIVO DOCUMENTADO | F9 research concluyó `NOT JUSTIFIED`; ningún candidato justifica nueva implementación. |
| EVIDENCIA QUE LA SOPORTA | `F9_RESEARCH.md`; `F9_OWNER_DECISIONS.md` [DOCUMENTADO]. |
| ALTERNATIVAS CONSIDERADAS | Autorizar implementación parcial de A-05/A-07/G-N5; abrir F10. |
| CONSECUENCIAS DIRECTAS | Todo cambio runtime requiere nuevo problema+evidencia+contrato. |
| CONSECUENCIAS INDIRECTAS | Investigación M001-M007 no se convierte en implementación. |
| DEPENDENCIAS | F8 COMPLETE; F9 research completo. |
| DECISIONES QUE GENERA | F9-D02, F9-D03, F9-D04, F9-D05. |
| DECISIONES QUE ELIMINA | Cualquier implementación automática post-F8. |
| REVERSIBILIDAD | ALTA — owner puede autorizar nuevo trabajo. |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con `F9_OWNER_DECISIONS.md` [VERIFICADO]. |

#### F9-D02 — Defer native Claude Code evidence

| Campo | Valor |
|---|---|
| ID | F9-D02 |
| TEXTO | No se ejecutan probes de runtime nativo de Claude Code ahora. Etiqueta `NATIVE CLAUDE CODE LIFECYCLE = NOT VERIFIED`. |
| FECHA | 2026-09-20 |
| MOTIVO DOCUMENTADO | Ausencia de evidencia nativa no es defecto; no hay trigger concreto. |
| EVIDENCIA QUE LA SOPORTA | `F9_OWNER_DECISIONS.md` §3.2 [DOCUMENTADO]. |
| CONSECUENCIAS DIRECTAS | Verificación limitada a scripts/fixtures en OpenCode. |
| CONSECUENCIAS INDIRECTAS | Incertidumbre persistente sobre comportamiento nativo real. |
| DEPENDENCIAS | F9-D01. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | ACTIVA |
| VERIFICACIÓN | Coincide con `F9_OWNER_DECISIONS.md` [VERIFICADO]. |

#### F9-D03 — Keep documentary candidates deferred

| Campo | Valor |
|---|---|
| ID | F9-D03 |
| TEXTO | Candidatos documentales (G-S1, G-S2, G-Bob-1, G-A1, G-N1, G-N2) permanecen diferidos. |
| FECHA | 2026-09-20 |
| MOTIVO DOCUMENTADO | No justifican micro-tareas propias; no se "limpia" el roadmap como actividad. |
| EVIDENCIA QUE LA SOPORTA | `F9_OWNER_DECISIONS.md` §3.3 [DOCUMENTADO]. |
| CONSECUENCIAS DIRECTAS | Roadmap conserva deuda documentada pero no activa. |
| DEPENDENCIAS | F9-D01. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | ACTIVA |

#### F9-D04 — External requirement trigger for integrity work

| Campo | Valor |
|---|---|
| ID | F9-D04 |
| TEXTO | A-05, A-07, G-N5 (recompute hash, hook self-mod detection, registry append-only) no se implementan sin requerimiento externo verificable. |
| FECHA | 2026-09-20 |
| MOTIVO DOCUMENTADO | El trust boundary Git + reviewer humano es suficiente a escala actual. |
| EVIDENCIA QUE LA SOPORTA | `F9_OWNER_DECISIONS.md` §3.4 [DOCUMENTADO]. |
| CONSECUENCIAS DIRECTAS | Límite explícito de trust boundary; no expansión automática. |
| CONSECUENCIAS INDIRECTAS | Triggers definidos: auditoría, compliance, requerimiento contractual/cliente. |
| DEPENDENCIAS | F9-D01. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | ACTIVA |

#### F9-D05 — Keep F10-F12 unknown

| Campo | Valor |
|---|---|
| ID | F9-D05 |
| TEXTO | F10-F12 permanecen UNKNOWN / NOT STARTED hasta que aparezca problema+evidencia concreto. |
| FECHA | 2026-09-20 |
| MOTIVO DOCUMENTADO | No se definen contratos de fase preventivamente. |
| EVIDENCIA QUE LA SOPORTA | `F9_OWNER_DECISIONS.md` §3.5 [DOCUMENTADO]. |
| CONSECUENCIAS DIRECTAS | Ninguna fase futura pre-autorizada. |
| CONSECUENCIAS INDIRECTAS | El siguiente trabajo debe justificarse desde cero. |
| DEPENDENCIAS | F9-D01. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | ACTIVA |

---

### 1.3 Decisiones del Owner listas para autorizar (READY-01..04)

#### READY-01 — AC-02 authorization / policy repair classification

| Campo | Valor |
|---|---|
| ID | READY-01 |
| TEXTO | ¿Las 4 reparaciones de políticas (POL-05, POL-08, POL-10, POL-13) son "mejora documental" o "cambio de regla"? |
| FECHA | 2026-09-23 |
| MOTIVO DOCUMENTADO | 4 políticas son PARTIAL; reparaciones reducen UNKNOWN de R-3. |
| EVIDENCIA QUE LA SOPORTA | `58_OWNER_DECISION_PACKAGE.md`; CDT-01 87.5% SAFE [DOCUMENTADO]. |
| ALTERNATIVAS CONSIDERADAS | NO (rule change → requiere autorización separada); workaround como guidance document. |
| CONSECUENCIAS DIRECTAS | Si YES: implementar 8 oraciones en 4 archivos `.claude/rules/*.md`. Si NO: políticas permanecen PARTIAL. |
| CONSECUENCIAS INDIRECTAS | Afecta L1-C Condition 2. |
| DEPENDENCIAS | F9-D01 (no cambios de regla sin autorización). |
| DECISIONES QUE GENERA | L1-C Condition 2 satisfecha (si YES + implementación). |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | PENDIENTE / OWNER_DECISION_READY |

#### READY-02 — NH-02 patterns + Level-1 normalization

| Campo | Valor |
|---|---|
| ID | READY-02 |
| TEXTO | ¿Autorizar añadir P1', P2' y normalización NH-09 (2 sed) a `bash-firewall.sh`? |
| FECHA | 2026-09-23 |
| MOTIVO DOCUMENTADO | Cerrar gaps sintácticos: `printenv NAMED_SECRET`, `${VAR}` y variantes quoted. |
| EVIDENCIA QUE LA SOPORTA | `58_OWNER_DECISION_PACKAGE.md`; corpus NH-04; 58A SAFE_NORMALIZATION [DOCUMENTADO]. |
| ALTERNATIVAS CONSIDERADAS | Defer P3 (FP MEDIUM); no añadir normalización. |
| CONSECUENCIAS DIRECTAS | ~6 líneas nuevas en `bash-firewall.sh`; cierra bypasses sintácticos conocidos. |
| CONSECUENCIAS INDIRECTAS | Afecta L1-C Condition 1; introduce riesgo de FP P1'/P2'. |
| DEPENDENCIAS | F9-D01; NH-10 (ya satisfecho). |
| DECISIONES QUE GENERA | L1-C Condition 1 satisfecha (si YES + implementación). |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | PENDIENTE / OWNER_DECISION_READY |

#### READY-03 — L1-C risk acceptance + N threshold

| Campo | Valor |
|---|---|
| ID | READY-03 |
| TEXTO | ¿Aceptar la formulación L1-C como criterio de cierre de LABYRINTH-1, condicionado a H-01 < N? Definir N. |
| FECHA | 2026-09-23 |
| MOTIVO DOCUMENTADO | LABYRINTH-1 no puede cerrarse absolutamente; requiere aceptación de residual + threshold empírico. |
| EVIDENCIA QUE LA SOPORTA | `58_OWNER_DECISION_PACKAGE.md`; 57_MOVEMENT_004 §9 [DOCUMENTADO]. |
| ALTERNATIVAS CONSIDERADAS | Mantener LABYRINTH-1 OPEN indefinidamente; implementar AC-03 (no autorizado). |
| CONSECUENCIAS DIRECTAS | Si YES: LABYRINTH-1 → CONDITIONALLY_CLOSED; agenda de investigación se detiene. |
| CONSECUENCIAS INDIRECTAS | Define trigger de reactivación por H-01. |
| DEPENDENCIAS | F9-D01; READY-01/02 opcionales pero recomendados. |
| DECISIONES QUE GENERA | L1-C Conditions 4+5 satisfechas; H-01 monitoring operacional. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | PENDIENTE / OWNER_DECISION_READY |

#### READY-04 — Enhanced-B denial messages

| Campo | Valor |
|---|---|
| ID | READY-04 |
| TEXTO | ¿Autorizar modificar `bash-firewall.sh` y `task-completed-evidence.sh` para emitir mensajes de denegación estructurados (policy_id, prohibited_outcome, next_action, escalation_path_reference)? |
| FECHA | 2026-09-23 |
| MOTIVO DOCUMENTADO | Mejorar calidad de revisión humana de STALL_POLICY; urgente por PAC-EF-02 FPs. |
| EVIDENCIA QUE LA SOPORTA | `58_OWNER_DECISION_PACKAGE.md`; 57_MOVEMENT_004 §5 [DOCUMENTADO]. |
| ALTERNATIVAS CONSIDERADAS | Mantener mensajes mínimos actuales. |
| CONSECUENCIAS DIRECTAS | Output format change; sin cambio de lógica de enforcement. |
| CONSECUENCIAS INDIRECTAS | Mejora resolución de STA-02; referencia a NH-10 §12. |
| DEPENDENCIAS | NH-10 (satisfecho); F9-D01. |
| REVERSIBILIDAD | ALTA |
| ESTADO ACTUAL | PENDIENTE / OWNER_DECISION_READY |

---

### 1.4 Decisiones implícitas / históricas relevantes

| ID | TEXTO | FECHA | ESTADO | NOTAS |
|---|---|---|---|---|
| F7-BUNDLE-A | Implementar anti-loop Stop | 2026-09-18 | ACTIVA | EV-009..EV-014 |
| F7-BUNDLE-B | Firewall hardening | 2026-09-18 | ACTIVA | EV-009..EV-014 |
| F7-BUNDLE-C | Evidence coupling | 2026-09-18 | ACTIVA | EV-009..EV-014 |
| F7-BUNDLE-D | Session log rotation | 2026-09-18 | ACTIVA | EV-009..EV-014 |
| F7-BUNDLE-E | Installer idempotency | 2026-09-18 | ACTIVA | EV-009..EV-014 |
| M007-PAC-PROTOTYPE | Crear prototipo PAC (13 políticas YAML + compiler) | 2026-09-23 | ACTIVA como research | No autorizado para producción |
| M008-HRQS | Añadir §13 HRQS a handbook | 2026-09-23 | COMPLETADO | Documentación-only |
| M008-PAC-CORPUS | Completar corpus PAC a 23 políticas | 2026-09-23 | COMPLETADO | Research artifact |

---

## 2. Decision Graph

```text
DECISIÓN RAÍZ: ¿Qué es el trust boundary de CCP?
│
├── Alternativa A tomada (ARCH-001 + F9-D04)
│   │   "Trust boundary = Git + reviewer humano a nivel de proyecto"
│   │
│   ├── consecuencia directa: A-05/A-07/G-N5 quedan fuera de scope
│   ├── consecuencia directa: F9-D01=A (no expandir enforcement sin evidencia)
│   ├── decisión derivada: F9-D02=B (native runtime no verificado)
│   ├── decisión derivada: F9-D03=B (candidatos documentales diferidos)
│   ├── decisión derivada: F9-D05=A (F10-F12 unknown)
│   └── decisión derivada: READY-01/02/03/04 como owner gates
│
└── Alternativa B descartada (sin documentar explícitamente)
    "Trust boundary = self-verifying system (artifact hash recompute, hook self-mod detection, registry append-only)"
    ├── universo alternativo: A-05/A-07/G-N5 implementados
    ├── universo alternativo: posible F9 de integridad
    └── universo alternativo: mayor complejidad, mayor superficie de fallo


DECISIÓN RAÍZ: ¿Cómo se representa la política?
│
├── Alternativa A tomada (ARCH-002 + F1-F8)
│   │   "Política humana en Markdown + traducción manual a regex bash"
│   │
│   ├── consecuencia directa: duplicación política ↔ enforcement
│   ├── consecuencia directa: READY-01 (disambiguation) y READY-02 (patterns)
│   └── decisión derivada: M007 PAC como prototipo alternativo
│
└── Alternativa B candidata (PAC)
    "Política como YAML compilado a patrones bash"
    ├── consecuencia: READY-01/02 colapsan en una decisión
    ├── consecuencia: requiere adoptar PAC en producción
    └── bloqueo: F9-D01=A + sin autorización PAC production


DECISIÓN RAÍZ: ¿Qué hacer con LABYRINTH-1?
│
├── Alternativa A: Implementar R-3 / AC-03
│   │   "Crear verificador independiente de no-bypass"
│   │   └── bloqueada por F9-D01=A + CDT-02 requiere nuevo agente
│
├── Alternativa B: Aceptación condicional (READY-03)
│   │   "L1-C closure con B-path + threshold N"
│   │   └── depende de READY-01/02 para cobertura completa
│
└── Alternativa C: Mantener OPEN (default actual)
    "Continuar investigación sin cerrar"
    └── genera overhead continuo
```

---

## 3. Decision Collapse

### 3.1 Todas las decisiones visibles

1. ARCH-001 (scope proyecto)
2. ARCH-002 (context packs)
3. ARCH-003 (ruta evidence)
4. ARCH-004 (task semantics)
5. F8-A (contract_hash obligatorio)
6. F8-B (reject malformed JSON)
7. F9-D01 (F9 cerrado)
8. F9-D02 (native deferred)
9. F9-D03 (documentary deferred)
10. F9-D04 (integrity external trigger)
11. F9-D05 (F10-F12 unknown)
12. READY-01 (AC-02 classification)
13. READY-02 (P1'+P2'+NH-09)
14. READY-03 (L1-C acceptance + N)
15. READY-04 (enhanced-B messages)
16. PAC production adoption
17. CDT-02 (new agent auth)
18. H-01 threshold / materiality

### 3.2 Colapso hacia decisiones raíz

```text
DECISIONES RAÍZ (K=5):

R1. TRUST BOUNDARY
    "¿Git + reviewer humano es suficiente, o se expande a controles técnicos adicionales?"
    → Colapsa: F9-D04, A-05, A-07, G-N5
    → Si se expande: habilita F9-D04 reconsideración
    → Si se mantiene: esas decisiones quedan diferidas

R2. IMPLEMENTACIÓN POST-F8
    "¿Se autoriza cualquier implementación runtime post-F8?"
    → Colapsa: F9-D01, READY-02, READY-04, PAC production, CDT-02
    → Si NO (actual): todas permanecen bloqueadas
    → Si SÍ: se desbloquean selectivamente según contrato

R3. REPRESENTACIÓN DE POLÍTICA
    "¿Se mantiene Markdown+regex manual o se adopta PAC (Policy-as-Code)?"
    → Colapsa: READY-01, READY-02 parcialmente, futuras reparaciones de política
    → Si PAC: READY-01/02 se convierten en especificación YAML
    → Si manual: continúan como decisiones separadas

R4. LABYRINTH-1 CLOSURE
    "¿Se acepta L1-C como resolución condicional o se mantiene OPEN?"
    → Colapsa: READY-03, H-01 threshold, agenda de investigación
    → Si YES: research de LABYRINTH-1 se detiene; monitor H-01
    → Si NO: investigación continúa sin criterio claro

R5. NATIVE RUNTIME VERIFICATION
    "¿Se investigan/verifican comportamientos nativos de Claude Code ahora?"
    → Colapsa: F9-D02, varios UNKNOWNS técnicos
    → Si YES: requiere ambiente disposable + probes
    → Si NO (actual): incertidumbre aceptada
```

### 3.3 Decisiones que permanecen INDEPENDIENTES

- ARCH-001, ARCH-002, ARCH-003, ARCH-004: ya tomadas, no dependen de R1-R5.
- F8-A, F8-B: ya implementadas, no dependen de R1-R5.
- READY-04: depende de NH-10 (satisfecho) y F9-D01; es independiente de READY-01/02/03 en cuanto a autorización.

### 3.4 Decisiones CONDICIONADAS

- READY-01/02: su impacto máximo se alcanza si R4 (L1-C) se acepta.
- READY-03: sin definir N, el trigger de reactivación es no-operacional.
- PAC production: condicionada a R2 (autorización post-F8) y R3 (adoptar PAC).

---

## 4. Root Claim Test para decisiones raíz

### R1 — Trust boundary

| Pregunta | Respuesta |
|---|---|
| ¿Explica más de un fenómeno? | Sí: A-05, A-07, G-N5, F9-D04. |
| ¿Explica decisiones de diferentes etapas? | Sí: F8 deferrals y F9 owner decisions. |
| ¿Explica componentes de diferentes capas? | Sí: hooks, registries, Git workflow. |
| ¿Reduce necesidad de múltiples mecanismos? | Sí: si se expande, múltiples controles se activan juntos. |
| ¿Predice algo observable? | Sí: si aparece auditoría/compliance, R1 se revisita. |
| ¿Tiene evidencia en contra? | No activa; trust boundary actual opera sin incidentes. |
| ¿Puede falsificarse? | Sí: un incidente que el reviewer humano no detecte. |

**Veredicto:** R1 es decisión raíz válida.

### R2 — Implementación post-F8

| Pregunta | Respuesta |
|---|---|
| ¿Explica más de un fenómeno? | Sí: F9-D01, READY-02, READY-04, PAC, CDT-02. |
| ¿Explica decisiones de diferentes etapas? | Sí: F9 closure y READY packages. |
| ¿Explica componentes de diferentes capas? | Sí: hooks, skills, agents. |
| ¿Reduce necesidad de múltiples mecanismos? | Sí: autorización única desbloquea múltiples paths. |
| ¿Predice algo observable? | Sí: nuevo problema+evidencia → F9-D01 se revisita. |
| ¿Tiene evidencia en contra? | No. |
| ¿Puede falsificarse? | Sí: owner autoriza implementación sin nuevo problema concreto. |

**Veredicto:** R2 es decisión raíz válida.

### R3 — Representación de política

| Pregunta | Respuesta |
|---|---|
| ¿Explica más de un fenómeno? | Sí: READY-01, READY-02, duplicación política/enforcement, PAC. |
| ¿Explica decisiones de diferentes etapas? | Sí: F1-F8 build y M007 research. |
| ¿Explica componentes de diferentes capas? | Sí: `.claude/rules/*.md`, `bash-firewall.sh`, prototipo PAC. |
| ¿Reduce necesidad de múltiples mecanismos? | Sí: PAC absorbe reparaciones y patterns. |
| ¿Predice algo observable? | Sí: si PAC se adopta, READY-01/02 desaparecen como decisiones separadas. |
| ¿Tiene evidencia en contra? | PAC-EF-02 demuestra que la compilación no es libre de FP. |
| ¿Puede falsificarse? | Sí: PAC en producción produce drift o FP inaceptable. |

**Veredicto:** R3 es decisión raíz válida, aunque con evidencia parcial en contra.

### R4 — LABYRINTH-1 closure

| Pregunta | Respuesta |
|---|---|
| ¿Explica más de un fenómeno? | Sí: READY-03, H-01 threshold, agenda de investigación. |
| ¿Explica decisiones de diferentes etapas? | Sí: F9 research, M003-M007. |
| ¿Explica componentes de diferentes capas? | Sí: R-3 protocol, hooks, human review. |
| ¿Reduce necesidad de múltiples mecanismos? | Sí: aceptación condicional evita implementar AC-03. |
| ¿Predice algo observable? | Sí: si H-01 < N, no se reabre. |
| ¿Tiene evidencia en contra? | H-01 desconocido; no se puede afirmar que sea inmaterial. |
| ¿Puede falsificarse? | Sí: un evento real de bypass con alternativa viable. |

**Veredicto:** R4 es decisión raíz válida con UNKNOWN importante.

### R5 — Native runtime verification

| Pregunta | Respuesta |
|---|---|
| ¿Explica más de un fenómeno? | Sí: F9-D02, G-B11 phantom SubagentStop, Tier 3 auth issues. |
| ¿Explica decisiones de diferentes etapas? | Sí: F3, F9. |
| ¿Explica componentes de diferentes capas? | Sí: settings.json, hooks, runtime nativo. |
| ¿Reduce necesidad de múltiples mecanismos? | Parcial: resolvería incertidumbres técnicas. |
| ¿Predice algo observable? | Sí: probes nativos confirman/refutan comportamientos. |
| ¿Tiene evidencia en contra? | No. |
| ¿Puede falsificarse? | Sí: un problema nativo reproducible. |

**Veredicto:** R5 es decisión raíz válida.

---

## 5. Resumen de la fase 4

- **Decisiones raíz identificadas:** 5 (R1 trust boundary, R2 implementación post-F8, R3 representación de política, R4 LABYRINTH-1 closure, R5 native runtime).
- **Decisiones activas tomadas:** ARCH-001..004, F8-A, F8-B, F9-D01..D05.
- **Decisiones pendientes del Owner:** READY-01..04.
- **Colapso más importante:** R3 (PAC) puede absorber READY-01/02; R4 (L1-C) puede cerrar la agenda de investigación.
- **UNKNOWN crítico:** H-01 materiality y N threshold para R4.
