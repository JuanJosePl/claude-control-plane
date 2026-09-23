# 45 — Decisión de Implementación Preliminar

**Fecha:** 2026-09-21
**Auditor:** Claude Opus 4.7
**Alcance:** Responder qué decisión de implementación se justifica hoy, dado el estado de la reconciliación.

> **Opciones permitidas por master prompt §39:**
> - `NOT JUSTIFIED`
> - `REQUIRES REPRODUCTION`
> - `REQUIRES FIELD VALIDATION`
> - `REQUIRES COMMERCIAL VALIDATION`
> - `READY FOR EXPERIMENTAL F10 DESIGN`

---

## 1. Recorrido causal

1. **`43_CANDIDATO_DE_PROPUESTA §4` = PROPOSAL NOT READY.** Bloqueado por 4 elementos: comparación existing-art incompleta, diferencia conductual no demostrada, seguridad no justificada, complejidad no justificada.
2. **La comparación con existing-art requiere `REPRODUCTION`** de 4 candidatos (SRC-001, SRC-011, SRC-029, SRC-031). Es *desk research* + verificación técnica — no requiere campo.
3. **La complejidad requiere `FIELD VALIDATION`** de H-01 (frecuencia de STALL_POLICY en uso real) — 30 días de instrumentación mínima.
4. **La seguridad requiere `REPRODUCTION`** de un diseño concreto de non_bypass_verify — es investigación técnica, no campo.
5. **La comercialidad requiere `COMMERCIAL VALIDATION`** — pero es prematura si (1)-(3) no se cumplen.

## 2. Decisión

```
DECISION: REQUIRES REPRODUCTION + REQUIRES FIELD VALIDATION
IMPLEMENTATION: NOT AUTHORIZED
F10 STATUS: NOT OPENED
```

### Justificación causal

- La reconciliación **no elimina** el problema residual ni lo confirma. Lo deja en `HYPOTHESIS OPEN` con 4 pre-requisitos bloqueantes.
- Abrir F10 hoy fabricaría trabajo sin base. Contradice `EVIDENCE > CLAIM` y `BOUNDED UNCERTAINTY > FAKE CERTAINTY`.
- Cerrar la investigación como "NOT JUSTIFIED" sería honesto para *investigación adicional pura*, pero perdería la oportunidad de resolver 2 de los 4 bloqueantes con costo bajo (reproducción + instrumentación).

## 3. Trabajo autorizable ahora (sin F10)

Todo debajo se ejecuta como **investigación acotada** o **instrumentación**, no como implementación de fase:

### Tarea R-1 — Verificación de 4 candidatos de prior art
- **Salida:** `46_PRIOR_ART_VERIFICATION.md` (posterior) con verificación de: State-Aware Runtime v4, PCAA/Verification-Gated Mission-State Governance, ae-framework, VERITAS OS.
- **Método:** WebSearch + WebFetch a fuentes primarias (arXiv, Cambridge Open Engage, GitHub repos).
- **Criterio:** ¿implementa policy-aware alternative generation + non_bypass_verify para open-ended?
- **Impacto:** si al menos uno cubre → problema residual = 0 → tareas R-2..R-4 canceladas.
- **Costo:** 1-2 días desk research.
- **Autoridad requerida:** owner puede autorizarlo como research handoff.

### Tarea R-2 — Instrumentación mínima STALL_POLICY (Opción 1 de §44)
- **Salida:** skill `stall-policy-record` + log file en `docs/00_SYSTEM/STALL_POLICY_LOG.md`.
- **Función:** cuando bash-firewall o task-completed-evidence bloquean, registrar timestamp + task_id + tipo + "había alternativa? [manual]".
- **Método:** un skill nuevo + un log file append-only. **No** requiere hook nuevo si se puede envolver los hooks existentes con logging pasivo.
- **Criterio:** correr 30 días.
- **Impacto:** cierra H-01.
- **Costo:** ~2-4 horas de implementación + 30 días de operación normal.
- **Autoridad requerida:** owner debe autorizar como cambio menor de configuración. NO ES F10.

### Tarea R-3 — Diseño formal de non_bypass_verify (opcional, condicional a R-1)
- **Salida:** documento de investigación con propuesta técnica.
- **Método:** revisar literatura de semantic equivalence, program-equivalence, static analysis; proponer criterio operable para dominios de coding/investigación.
- **Criterio:** el diseño debe ser testeable en dataset controlado.
- **Ejecutar SÓLO si R-1 confirma que el gap existe.**

### Tarea R-4 — Field validation de comprador (opcional, condicional a R-1 + R-2)
- **Salida:** notas de entrevista.
- **Método:** el owner conversa con operadores conocidos.
- **Ejecutar SÓLO si R-1 y R-2 confirman técnica + utilidad.**

## 4. Trabajo NO autorizado

- ❌ Abrir F10 en ningún formato.
- ❌ Implementar la arquitectura de §44 Opción 3.
- ❌ Modificar F1-F8 (frozen).
- ❌ Modificar hooks existentes.
- ❌ Modificar agents / skills existentes salvo los estrictamente instrumentales.
- ❌ Modificar PROJECT_STATE fuera de una anotación de "research decision".
- ❌ Introducir cambios a DECISION_REGISTRY con ARCH-005+ sin owner explicit approval.
- ❌ Cualquier claim comercial (buyer, WTP, pilot) sin evidencia primaria de campo.

## 5. Reevaluación

- Después de R-1: reevaluar el estatus del residual. Si CLOSED, decisión final = `NOT JUSTIFIED`; se archiva la investigación.
- Después de R-2 (30 días): reevaluar H-01. Si < umbral (a definir tras primera semana), decisión final = `NOT JUSTIFIED` por utilidad. Si ≥ umbral y R-1 no cerró el gap, avanzar a R-3.
- Después de R-3: reevaluar seguridad. Si non_bypass_verify no tiene diseño testeable, decisión final = `NOT JUSTIFIED` por seguridad.
- Sólo después de R-1 (gap sobrevive) + R-2 (utilidad demostrada) + R-3 (diseño seguro) → reconsiderar `READY FOR EXPERIMENTAL F10 DESIGN`.

## 6. Estado del proyecto tras esta decisión

- `PROJECT_STATE.CURRENT_PHASE` sigue en F8 COMPLETE.
- `F9_DECISION` sigue = `F9 NOT JUSTIFIED`.
- `F10-F12` siguen = UNKNOWN / NOT STARTED.
- `NEXT_ALLOWED_PHASE` sigue = "None auto".
- Se añade nueva entrada research: `RESEARCH_RECONCILIATION_HEAD = <commit de este bundle>`.
- Se añade unknown gate: `RESIDUAL_HYPOTHESIS_STATUS = OPEN — pending R-1, R-2`.

## 7. Riesgo de esta decisión

- **Riesgo A (falso negativo):** el problema es real y grande, pero R-1 no lo detecta por sesgo de literatura. Mitigación: R-2 es paralelo y produce evidencia empírica independiente.
- **Riesgo B (falso positivo):** R-1 dice "gap existe" pero la implementación no aporta valor en R-2. Mitigación: R-3 y R-4 son condicionales.
- **Riesgo C (perder momentum):** archivar sin acción cierra la línea de investigación. Mitigación: R-1 es de bajo costo; permite decisión informada.

## 8. Recomendación al owner

- Ejecutar **R-1** (verificación de 4 candidatos de prior art) como próxima acción de investigación. Es el paso más barato y el único que puede cerrar el residual con desk research únicamente.
- Considerar **R-2** (instrumentación STALL_POLICY) en paralelo si el costo es tolerable — es la única forma de responder H-01.
- **No** autorizar R-3 / R-4 hasta ver resultados de R-1 y R-2.
- **No** interpretar esta reconciliación como razón para abrir F10.
