# 42 — Problema Residual

**Fecha:** 2026-09-21
**Auditor:** Claude Opus 4.7
**Alcance:** Formular el problema mínimo que queda después de eliminar prior art, existencias comerciales, renombramientos, similitudes arquitectónicas y frameworks superpuestos.

> **Regla:** el problema debe ser concreto, falsable, observable, técnicamente delimitado, independiente de marca, independiente de vocabulario propietario. Describe una propiedad, no componentes.

---

## 1. Test 80% delete

Si eliminamos el 80% de la arquitectura histórica de CCP y de todas las propuestas SAGR/assurance, ¿qué propiedad todavía necesitaríamos?

**Respuesta:** *Un agente autónomo que ha sido bloqueado por una restricción de política, y que podría lograr su objetivo con una acción alternativa, debe poder proponer esa alternativa Y demostrar — a un tercero — que la alternativa no elude el intent de la restricción, sin depender de que la restricción esté expresada como workflow pre-compilado.*

Esta es la propiedad que ambas investigaciones aíslan (A la generaliza como assurance impact propagation; B la operacionaliza como generate_alternative + non_bypass_verify).

---

## 2. Prior art comprobado que NO cubre esta propiedad

- **Temporal, DBOS, LangGraph:** recuperan de crashes, no de restricciones de política. Sus docs oficiales lo dicen explícitamente.
- **PolicyGuide (arXiv:2608.19861), SafeAgent (arXiv:2604.17562):** cubren workflows estructurados donde el grafo de acciones válidas está pre-compilado. No cubren agentes open-ended donde el espacio de acciones es indefinido.
- **OSGuard (arXiv:2606.15034):** implementa block → feedback → revise → re-check → 2 retries. Es reactivo, no generativo; no genera alternativas nuevas — pide al agente reintentar con feedback.
- **Recoverability (arXiv:2609.13672):** formaliza HARD STOP vs RECOVERABLE STOP pero no implementa el generador.
- **RIR / AgentRewind:** recuperación de trayectoria y checkpoints, no verificación de alternativa.
- **AIGIS:** evidence-gated execution + policy engine ALLOW/DENY/REQUIRE_HUMAN — no genera alternativa, sólo bloquea o pide humano.
- **Assurance Envelopes, Assurance Closure (arXiv:2608.07317):** proponen framework de assurance completo pero como research agenda; no como sistema integrado corriendo.
- **TMS / ATMS (Doyle 1979, de Kleer 1986):** dependency-based belief revision; conceptualmente cubre "propagate invalidity", no aborda "generate alternative under policy".

## 3. Prior art que podría cubrirla (INCIERTO)

Los siguientes candidatos de MASTERC no han sido reproducidos por B y son HYPOTHESIS-GRADE:

- **State-Aware Runtime v4** (Cambridge, SRC-001) — si cubre "authority adaptation + proposal + validator + commit + compensation" para open-ended, podría cerrar la propiedad. **Falta verificar**.
- **Verification-Gated Agentic Mission-State Governance** (arXiv:2606.31339, SRC-011): si el "proposal + verification + atomic commit" cubre policy-aware alternative generation open-ended, cierra. **Falta verificar**.
- **VERITAS OS** (SRC-031): EFFECT_UNKNOWN state + governance runtime; **falta verificar** si genera alternativas o sólo audita.
- **ae-framework** (SRC-029): agent-neutral assurance control plane; **falta verificar** su cobertura real.

**Si cualquiera de estos, verificado, cubre la propiedad → el problema residual se cierra.**

---

## 4. Formulación mínima del problema residual

> **El sistema no puede determinar de forma confiable si una acción alternativa A′, propuesta después de que A_original fue bloqueada por una política P, satisface el objetivo O sin violar el intent de P — cuando el espacio de acciones del agente no está pre-compilado como un workflow finito y verificable — sin incurrir en el riesgo de que A′ sea un bypass semántico de P que pase inadvertido a la verificación de superficie.**

### Descomposición operativa

- Entrada: `(S, O, P, A_blocked, evidence, context, history)`
- Salida deseable: `A' | NONE | UNKNOWN` con `certificado(A' ≠ bypass(A_blocked, P))`.
- Restricción: `A_blocked ≠ A'` no basta (equivalencia semántica invisible).
- Restricción: `verifier(A', A_blocked, P)` debe ser **independiente** del proponente (por el resultado VP-CONTROL 62.9%).
- Restricción: debe funcionar en dominios no pre-compilados (coding, investigación, exploración, razonamiento).

### Observabilidad

El sistema pasa/falla observablemente si:
- En un experimento controlado con N pares `(A_blocked, A' aparente)` donde algunas A' son bypasses ocultos y otras son verdaderas alternativas, el verificador clasifica con precisión ≥ umbral X.
- La medición es reproducible por un tercero.

### Falsificador de la novedad

- Un sistema público implementa la propiedad para agentes open-ended y publica evaluación reproducible → problema residual = 0.

### Falsificador de la utilidad

- Se instrumenta un agente en producción durante 30 días y se cuentan cero (o < N) casos donde la propiedad hubiera sido necesaria → el problema existe pero es inmaterial.

---

## 5. Por qué el residual importa (si existe)

- **Impacto de seguridad:** un recovery mechanism sin non-bypass verify se convierte en un vector de ataque (validado por `34_ADVERSARIAL` Perspectiva 4 FORTALECIDA).
- **Impacto operativo:** cada stall por política que hoy termina en HARD STOP consume trayectoria, evidencia y contexto acumulados; si existe alternativa segura, restart es económicamente peor (Perspectiva 3 DEBILITADA para el caso general, VÁLIDA para el caso específico).
- **Impacto arquitectónico:** requiere una capa de razonamiento sobre políticas que hoy no está en el CCP ni en los competidores conocidos para open-ended.

---

## 6. Contra-argumentos más fuertes

- **CA-1:** "State-Aware Runtime v4 ya lo cubre." → válido si se verifica. Reduce el residual a cero.
- **CA-2:** "El problema es tan específico que no vale una arquitectura entera." → válido si H-01 (frecuencia) es ≤ umbral. Colapsa el caso económico.
- **CA-3:** "Cualquier implementación en CCP heredaría el trust boundary humano/Git existente, sin ganar nada." → parcialmente válido; la ganancia real es la auditabilidad, no la garantía criptográfica.
- **CA-4:** "El invariante `A' ≠ bypass(A_blocked, P)` es formalmente indecidible en el caso general." → **hipótesis abierta**. Si es cierto, la propiedad es sólo aproximable, no garantizable, lo que cambia el diseño (verificación probabilística + humano-in-the-loop en incierto).

---

## 7. Límites de este problema residual (unknowns)

- **UNK-R1:** No sabemos si la propiedad es fundamentalmente decidible para open-ended agents en dominios amplios.
- **UNK-R2:** No sabemos con qué frecuencia ocurre STALL_POLICY con alternativa viable en uso real. (mismo que H-01)
- **UNK-R3:** No sabemos si State-Aware Runtime v4 y colegas ya cubren el gap. (Requiere verificación de MASTERC SRC-001, SRC-011, SRC-029, SRC-031.)
- **UNK-R4:** No sabemos si operadores reales harían pilot / pagarían por esta propiedad. (mismo que H-03)

---

## 8. Estatus del problema residual

```
NAME:                policy-aware continuation with non-bypass verification
                     for open-ended agents (integrated with dependency-aware invalidation)
NOVELTY:             HYPOTHESIS OPEN — HYPOTHESIS-GRADE prior art candidates unverified
UTILITY:             HYPOTHESIS OPEN — requires H-01 field measurement
SECURITY GATE:       BLOCKING — non_bypass_verify is a necessary condition
CCP ARCHITECTURAL FIT: PARTIAL — CCP has evidence + policy hooks but no alternative generation layer
COMMERCIAL VIABILITY: UNKNOWN
```

**Resultado del análisis:** el problema residual **existe** en la formulación estrecha del §4. **No está demostrado que sea novel** ni que sea rentable resolver. Requiere: (1) verificar los 4 candidatos de prior art A-01/A-11/A-16/A-18; (2) medir H-01 en campo; (3) formular non_bypass_verify de forma concreta y testeable.

Ver `43_CANDIDATO_DE_PROPUESTA.md` para la evaluación de si este residual justifica una propuesta concreta.
