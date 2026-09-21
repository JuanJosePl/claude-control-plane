# 12 — Reconstrucción del modelo

**Fecha:** 2026-09-21
**Investigador:** Claude Sonnet 4.6 (segunda pasada)
**Alcance:** producir el modelo formal unificado de SAGR que GPT no generó (Gap G-01 de `03_AUDITORIA_DE_COBERTURA_GPT.md`).

---

## 1. Modelo de estado y trayectoria del agente

### 1.1 Espacio de estados

Sea un agente A ejecutando una tarea T con objetivo O.

- **Estado del agente:** `S_a = (context, history, working_memory)` — todo lo que el agente conoce
- **Estado del entorno:** `S_e = (filesystem, APIs, databases, external_state)` — el mundo fuera del agente
- **Estado de governance:** `S_g = (policies, permissions, budget, side_effects_log)` — las reglas y el registro
- **Estado completo:** `S = (S_a, S_e, S_g)` al tiempo t

### 1.2 Trayectoria

Una trayectoria de ejecución es la secuencia:
```
τ = [S_0, A_1, S_1, A_2, S_2, ..., A_t, S_t]
```
donde `A_i` es la acción tomada en el paso i y `S_i` es el estado resultante.

### 1.3 Objetivo y progreso

- **Objetivo:** `O = {completion_criteria, intent_description, policy_constraints}`
- **Progreso semántico:** `P(S_t, O) ∈ [0,1]` — qué fracción del objetivo está completada (función difícil de computar)
- **Drift semántico:** `D(t) = |P(S_t, O) - expected_progress(t)|` — desviación del progreso esperado (base de ReflectiChain)

---

## 2. Clasificación de estados

### 2.1 Estados terminales normales

- **COMPLETE(O):** P(S_t, O) ≥ threshold_completion
- **HARD_STOP:** Ninguna acción A_t+1 disponible satisface policy(A_t+1, S_g) = allow

### 2.2 Estados de bloqueo no-trivial (el dominio de SAGR)

- **STALL_SEMANTIC:** D(t) > threshold_drift durante N pasos consecutivos
- **STALL_LOOP:** La acción A_t es semánticamente idéntica a alguna A_{t-k} para k ≤ window
- **STALL_POLICY:** policy(A_best, S_g) = deny para todas las acciones A_best ∈ argmax(progress)
- **STALL_BUDGET:** remaining_budget(S_g) < cost_estimate(recovery) + cost_estimate(completion)
- **STALL_CONTEXT:** |S_a.context| > max_context y la compactación perdería información crítica

### 2.3 Función de clasificación de SAGR

La función central de SAGR es `classify_stall(τ, O, S_g)`:

```
classify_stall(τ, O, S_g) → {
  CONTINUE: continuar normalmente
  RECOVERABLE: existe A' ≠ A_best tal que policy(A', S_g) = allow ∧ progress(A', O) > 0
  HARD_STOP: no existe tal A'; abortar
  ESCALATE: incertidumbre demasiado alta; requerir input humano
}
```

---

## 3. El componente de recovery

### 3.1 Condición necesaria para recovery

Para que `classify_stall = RECOVERABLE`, se requiere:
1. **Checkpoint válido:** ∃ checkpoint `C ⊆ τ` tal que `S_g.side_effects_log(C)` está completo y verificado
2. **Alternativa existente:** ∃ A' tal que `policy(A', S_g) = allow` y `progress(A', O) > 0`
3. **No-bypass:** A' no es semánticamente equivalente a A_blocked bajo recomposición de acciones
4. **Presupuesto suficiente:** `remaining_budget > cost_estimate(recovery_path(A'))`

### 3.2 Función de generación de alternativa

```
generate_alternative(S_t, O, S_g, A_blocked) → A' | NONE
```

Donde A' satisface las 4 condiciones anteriores.

**Esta función es el componente no resuelto de SAGR.** En la literatura solo existe en forma parcial:
- Recoverability (2609.13672): formaliza la decisión grant/withhold pero no la generación de A'
- Harnessing Embodied Agents (2604.07833): el "recovery manager" invoca estrategias predefinidas, no generación dinámica

---

## 4. El modelo económico de recovery

### 4.1 Función de coste de recovery

```
C_recovery = cost_checkpoint_restore + cost_alternative_generation + cost_alternative_execution + cost_verification
```

### 4.2 Función de coste de restart

```
C_restart = cost_work_lost + cost_restart_execution + cost_reaching_checkpoint_from_start
```

### 4.3 Decisión óptima

```
decision = argmin(C_recovery × (1 - P_recovery_success), C_restart, C_hard_stop)
```

Donde `P_recovery_success = P(generate_alternative ≠ NONE ∧ A' produces progress)`.

**El problema:** `P_recovery_success` es difícil de estimar. BAGEN (2606.00198) propone estimación de budget restante para completion, lo que puede informar `P_recovery_success` parcialmente.

---

## 5. El modelo de governance de recovery

### 5.1 Invariante de seguridad

Para que el recovery sea aceptable desde el punto de vista de governance:

```
∀ A' en recovery_path(A'):
  policy(A', S_g) = allow
  ∧ audit_log.record(A', S_t, justification)
  ∧ ¬bypass_detect(A', A_blocked, O, P)
```

El predicado `bypass_detect` es el más difícil: detectar si A' es un bypass encubierto de A_blocked.

### 5.2 Protocolo mínimo de non-bypass verification

No existe en la literatura. Esta segunda pasada propone (como HYPOTHESIS, no como implementación):

1. **Intent preservation check:** semantic_similarity(intent(A'), intent(O)) > threshold_intent
2. **Policy differential check:** Para cada constraint c en policy P: if A_blocked violates c, then A' must not approach c from a different angle that achieves the same prohibited outcome
3. **Human review gate:** Para acciones de alto riesgo, siempre enviar A' a revisión humana antes de ejecutar, incluso si pasa los checks automáticos

**Ninguno de estos checks es verificable formalmente sin ambigüedad.** Es una limitación fundamental del estado actual. [HYPOTHESIS]

---

## 6. Conexión con el repositorio CCP

El CCP en su estado actual (F8 COMPLETE) tiene estos componentes del modelo:

| Componente del modelo | Estado en CCP |
|---|---|
| `classify_stall` para STALL_LOOP | Parcial — max_turns, bash-firewall |
| `classify_stall` para STALL_CONTEXT | Parcial — PreCompact hook, snapshot |
| `classify_stall` para STALL_POLICY | Ausente |
| `generate_alternative` | Ausente |
| `C_recovery` estimation | Ausente |
| `audit_log` de stalls | Ausente |
| `non_bypass_verification` | Ausente |

El CCP implementaría SAGR si se añadieran los 4 componentes ausentes. El componente `generate_alternative` es el que requiere investigación adicional (NH-05 de `09_NUEVAS_HIPOTESIS.md`).
