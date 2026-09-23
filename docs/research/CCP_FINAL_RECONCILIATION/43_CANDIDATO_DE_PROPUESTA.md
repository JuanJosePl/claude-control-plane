# 43 — Candidato de Propuesta

**Fecha:** 2026-09-21
**Auditor:** Claude Opus 4.7
**Alcance:** Evaluar si el problema residual (§42) justifica una propuesta concreta según los criterios del master prompt §37.

---

## 1. Estado del criterio

Según el master prompt §37, una propuesta necesita **TODOS** los elementos siguientes:

```
REAL PROBLEM
+ REAL CCP GAP
+ BEHAVIORAL DIFFERENCE
+ EXISTING-ART COMPARISON
+ SECURITY JUSTIFICATION
+ COMPLEXITY JUSTIFICATION
+ MEASURABLE OUTCOME
+ FALSIFIER
```

Si falta uno → `PROPOSAL NOT READY`.

---

## 2. Chequeo de cada elemento

### REAL PROBLEM
- **Estado:** PARTIAL.
- **Evidencia a favor:** GuardFall es data point verificado. Investigación académica activa (Recoverability, RIR, AgentRewind, PolicyGuide 2026). Convergencia de dos investigaciones independientes.
- **Evidencia en contra:** frecuencia real desconocida (H-01). Un data point (GuardFall) no es medición.
- **Veredicto:** REAL PROBLEM POSIBLE, NO MEDIDO.

### REAL CCP GAP
- **Estado:** PARTIAL.
- **Evidencia a favor:** CCP no tiene layer de alternative generation ni non_bypass_verify. bash-firewall es sólo blocker, no proposer.
- **Evidencia en contra:** CCP tiene evidence gate + policy hooks; el gap podría cerrarse con un skill de recovery + intervención humana, sin nueva arquitectura.
- **Veredicto:** GAP EXISTE pero puede ser cubierto por mecanismos más ligeros que una capa nueva.

### BEHAVIORAL DIFFERENCE (vs sistemas existentes)
- **Estado:** UNKNOWN.
- **Evidencia a favor:** ninguna implementación pública verificada para open-ended agents.
- **Evidencia en contra:** State-Aware Runtime v4, Verification-Gated Mission-State Governance (SRC-001, SRC-011) podrían cubrirla — no verificado por B.
- **Veredicto:** DIFERENCIACIÓN NO DEMOSTRADA. Requiere verificar los 4 candidatos de prior art (§42.3).

### EXISTING-ART COMPARISON
- **Estado:** INCOMPLETO.
- **Corpus B ha comparado:** PolicyGuide, SafeAgent, OSGuard, Recoverability, Temporal, DBOS, LangGraph, AWS Step Functions, Azure AI Agents (WEAKENED o KILLED en varios).
- **Corpus A menciona pero no comparó:** State-Aware Runtime v4, Argus, VERITAS OS, ae-framework, Turning Interaction History (Ledger), CONTINUUM.
- **Veredicto:** Comparación INCOMPLETA. Estas verificaciones son bloqueantes.

### SECURITY JUSTIFICATION
- **Estado:** BLOQUEADO.
- **Evidencia:** `34_ADVERSARIAL` Perspectiva 4 FORTALECIDA: SAGR sin non_bypass_verify es peor que no SAGR. non_bypass_verify no está implementado. Nadie sabe cómo hacerlo para open-ended de forma robusta. Esto es el bloqueante crítico.
- **Consecuencia:** Cualquier propuesta debe tratar non_bypass_verify como condición necesaria previa. Sin diseño testeable de non_bypass_verify, la propuesta es insegura por diseño.
- **Veredicto:** NO JUSTIFICADA hasta tener diseño concreto de non_bypass_verify.

### COMPLEXITY JUSTIFICATION
- **Estado:** NO DEMOSTRADA.
- **Argumento a favor:** Si H-01 es alta y non_bypass_verify se resuelve, evita perder trayectorias valiosas.
- **Argumento en contra:** Añadir capa arquitectónica a CCP contradice `SIMPLE > CLEVER`, `BENEFIT > COMPLEXITY`. El costo de mantener otra capa es alto en un control plane que ya tiene 10 hooks, 22 skills, 5 agents, 6 context packs.
- **Veredicto:** SIN JUSTIFICACIÓN de complejidad hasta que H-01 muestre volumen material.

### MEASURABLE OUTCOME
- **Estado:** POSIBLE.
- **Métricas propuestas:** (a) recall/precision de non_bypass_verify en dataset controlado; (b) reducción de HARD STOPS en trayectorias con evidencia de alternativa viable; (c) ausencia de bypasses semánticos detectados en auditoría posterior.
- **Veredicto:** MÉTRICAS FORMULABLES, no instrumentadas.

### FALSIFIER
- **Estado:** SÍ.
- **Falsificador de novedad:** implementación pública existente para open-ended agents.
- **Falsificador de utilidad:** cero casos en 30 días de instrumentación H-01.
- **Falsificador de seguridad:** cualquier bypass semántico no detectado por non_bypass_verify en test suite.
- **Veredicto:** FALSIFICADORES EXPLÍCITOS Y ADECUADOS.

---

## 3. Score final

| Elemento | Estado | ¿Bloquea? |
|---|---|---|
| REAL PROBLEM | PARTIAL | NO (bloquea utilidad, no propuesta) |
| REAL CCP GAP | PARTIAL | NO |
| BEHAVIORAL DIFFERENCE | UNKNOWN | **SÍ** |
| EXISTING-ART COMPARISON | INCOMPLETE | **SÍ** |
| SECURITY JUSTIFICATION | BLOCKED | **SÍ** |
| COMPLEXITY JUSTIFICATION | UNDEMONSTRATED | **SÍ** (por H-01) |
| MEASURABLE OUTCOME | FORMULABLE | NO |
| FALSIFIER | SÍ | NO |

**4 de 8 elementos bloquean.**

---

## 4. Veredicto

```
PROPOSAL NOT READY
```

**Justificación:**

- La diferenciación conductual **no está demostrada** frente a candidatos como State-Aware Runtime v4 y Verification-Gated Mission-State Governance.
- La comparación con existing art **no está completa** (4 candidatos de A sin verificar).
- La justificación de seguridad **no puede darse** sin un diseño testeable de `non_bypass_verify`; hasta entonces, SAGR es un vector de ataque potencial.
- La complejidad **no está justificada** sin la medición de H-01.

---

## 5. Pre-requisitos para reclasificar como "PROPOSAL READY"

**Todos deben cumplirse:**

1. **Verificación de 4 candidatos de prior art:** SRC-001 (State-Aware Runtime v4), SRC-011 (PCAA / Verification-Gated Mission-State Governance), SRC-029 (ae-framework), SRC-031 (VERITAS OS). Cada uno debe evaluarse: ¿implementa policy-aware alternative generation + non_bypass_verify para open-ended agents? Si sí para cualquiera → problema residual = 0, propuesta muerta.
2. **Medición H-01 en 30 días:** instrumentar CCP con STALL_POLICY counter + campo manual "había alternativa viable". Necesitamos N ≥ umbral (a determinar tras primera semana) para justificar complejidad.
3. **Diseño formal de non_bypass_verify:** propuesta técnica sobre cómo verificar independencia semántica entre A' y A_blocked en un dominio abierto. Sin este diseño, no hay propuesta segura.
4. **Field evidence de comprador o uso:** al menos 1 operador (puede ser el propio owner) con caso documentado que motive el trabajo. Sin uso demostrado, la propuesta es investigación básica.

---

## 6. Recomendación

- **NO** formular propuesta ahora.
- **NO** llamar a esto "innovation", "unique", "novel" o "cherry".
- **SÍ** ejecutar los 4 pre-requisitos secuencialmente. El (1) es el más barato (desk research verificable, ~1-2 días). Si (1) cierra el problema, (2)-(4) no se necesitan.
- **SÍ** documentar el actual estado como "hipótesis con prior art parcial, sin justificación operativa aún".

---

## 7. Riesgo de sesgo de confirmación

Advertencia: el marco de esta reconciliación fue producido después de invertir esfuerzo significativo en la investigación SAGR. Es un patrón conocido de sesgo *sunk cost* + *investment justification* concluir "existe un residual que vale la pena". Debe pesarse: si el owner llega a esta reconciliación **sin** haber invertido en SAGR previamente, ¿comenzaría a investigar policy-aware alternative generation? Es un umbral honesto para decidir si el residual es real o retrospectivo.
