# CCP Research Context Master

> Documento de consolidación. Fuente única de contexto para toda la investigación de mercado y
> arquitectural realizada sobre el Claude Control Plane desde Sep-2026. Leer este archivo antes
> de cualquier sesión de investigación o decisión sobre F10–F12 o SAGR.
>
> **No es un plan de implementación. No abre ninguna fase.**

**Última actualización:** 2026-09-21
**HEAD al momento del cierre:** `ccc0760`
**Fase activa:** F8 COMPLETE / F9 NOT JUSTIFIED / F10–F12 NOT STARTED

---

## 1. Cadena de investigación completa

| Documento | Autor | Fecha | Propósito |
|---|---|---|---|
| `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_REPORT.md` | GPT + Claude | Sep-2026 | Validación de mercado inicial |
| `CLAUDE_CONTROL_PLANE_MARKET_VALIDATION_AUDIT.md` | Claude | Sep-2026 | Auditoría de la validación |
| `CLAUDE_CONTROL_PLANE_MARKET_SOURCES.md` | Claude | Sep-2026 | Fuentes de mercado |
| `CLAUDE_CONTROL_PLANE_AIGIS_TEARDOWN.md` | Claude | Sep-2026 | Teardown competitivo de AIGIS |
| `CLAUDE_CONTROL_PLANE_FIELD_VALIDATION_PACKET.md` | Claude | Sep-2026 | Paquete de validación de campo |
| `CCP_SAGR_RESEARCH_DOSSIER.md` | GPT-5.6 Luna | 2026-09-21 | Investigación inicial de SAGR (17 tracks) |
| `SAGR_DEEP_RESEARCH/NOTAS_*.md` (6 archivos) | GPT-5.6 Luna | 2026-09-21 | Investigación temática profunda |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/` (28 archivos) | Claude Sonnet 4.6 | 2026-09-21 | Auditoría forense + investigación independiente |

---

## 2. Conclusiones de la investigación previa (pre-SAGR)

### Tesis comercial: NOT SUPPORTED

- No hay entrevistas, piloto, presupuesto ni WTP demostrado para CCP como producto standalone.
- La tesis de "control plane como servicio" no sobrevivió validación de mercado.

### Diferenciadores supervivientes (post-AIGIS teardown)

AIGIS (competitor) reproduce sustancialmente la ejecución core de CCP. Lo que AIGIS no tiene:

1. **Cadena Incident → Control → Regression** con historial auditado
2. **Preservación histórica** de evidencia y decisiones
3. **Disciplina de phase-gate** con gates formales de owner

H1 (evidence-gated completion): NO ÚNICO post-AIGIS.
H3 (incident→control→regression loop): TODAVÍA ÚNICO vs AIGIS.

### Decisiones de owner (F9 gate, cerrado 2026-09-20)

| ID | Decisión | Resultado |
|---|---|---|
| F9-D01 | ¿Implementar F9? | A — No implementar |
| F9-D02 | ¿Adoptar native Claude Code? | B — Esperar trigger concreto |
| F9-D03 | ¿Prioridad evidence vs recovery? | B — Evidence primero |
| F9-D04 | ¿Trust boundary? | B — Git + human reviewer |
| F9-D05 | ¿Mantener AIGIS como referencia? | A — Sí, mantener |

---

## 3. La hipótesis SAGR — origen y evolución

### Formulación original (dossier)

"State-Aware Governed Recovery" — detectar stagnation, loops, degradación de contexto,
explosión de costos, control-induced stalls; recuperar via exploración acotada, subagentes,
restauración de estado, reconstrucción de contexto mínimo, re-verificación.

### Reformulación tras la investigación completa

**SAGR ya no es "recovery". SAGR es governance de la continuación.**

| Concepto | Quién lo resuelve |
|---|---|
| **Recovery** = volver a estado bueno después de fallo | Temporal, DBOS, LangGraph, checkpoints |
| **Governance de la continuación** = decidir qué puede hacer el agente cuando ya no puede hacer lo que planeaba, verificando que la alternativa no sea un bypass de política | **Nadie todavía** (para open-ended agents) |

La distinción importa porque mueve SAGR de "recovery" (commoditizada) a "execution governance"
(no commoditizada). El comprador ya no es el Platform Engineer — es el Security/CISO Engineer
que necesita saber que los agentes no encontrarán caminos alternativos a acciones prohibidas.

---

## 4. Correcciones aplicadas por la investigación

Cinco claims del dossier original fueron corregidos con fuentes primarias:

### C-01: OSGuard
- **Dossier decía:** "fixed retry budget / hard stop only"
- **Evidencia real (arXiv:2606.15034v1):** implementa bloqueo de política → feedback → revisión
  de acción → re-chequeo → límite de 2 reintentos
- **Impacto:** contradice el claim amplio "no existe arquitectura que interactúe con acción bloqueada"

### C-02: Recoverability as a System Primitive
- **Dossier decía:** "no hay clasificación formal HARD STOP vs RECOVERABLE STOP"
- **Evidencia real (arXiv:2609.13672v1):** sí formaliza la clasificación, con selección de
  punto de recuperación por evidencia, acción permitida, decisión grant/withhold, límites y
  registro de auditoría
- **Impacto:** P5/P12/P13/P21 de SAGR tienen precedente formal en investigación

### C-03: RIR "60–70%"
- **Dossier decía:** RIR cubre 70% de la composición SAGR
- **Evidencia real:** no existe rúbrica, denominador ni cálculo reproducible en el paper;
  versión v2 (arXiv:2609.18304v2, 2026-09-17) existente y no considerada
- **Corrección:** "solapamiento sustantivo, alcance exacto no cuantificado"

### C-04: Side-effect continuity
- **Dossier decía:** campo vacío, sin implementación
- **Evidencia real:** Living AI (PyPI 0.4.1), Replay Agent Recorder (GitHub/Futuresis),
  AgentRewind (arXiv:2608.14380) — implementaciones parciales en OSS/investigación
- **Corrección:** "implementaciones parciales existen; madurez comercial y garantía general
  no demostradas"

### C-05: "Únicos bloqueantes técnicos"
- **Claim (síntesis anterior):** `generate_alternative + non_bypass_verify` son los únicos
  bloqueantes técnicos pendientes que nadie implementó
- **Evidencia real:** PolicyGuide (arXiv:2608.19861) y SafeAgent (arXiv:2604.17562) implementan
  `generate_alternative` para **workflows estructurados**
- **Corrección:** el gap real es más estrecho: para **open-ended agents** (coding, investigación,
  razonamiento sin workflow pre-definido) no hay implementación pública conocida
- **Bloqueantes adicionales identificados:** (1) detección confiable STALL_POLICY vs otros
  tipos de stall, (2) preservación de side effects para no duplicarlos en recovery

---

## 5. Hipótesis finales auditadas

| ID | Hipótesis | Estado | Evidencia clave |
|---|---|---|---|
| H1 | Evidence-gated completion es único | NOT SUPPORTED | AIGIS lo reproduce |
| H2 | CCP tiene mercado standalone | NOT SUPPORTED | Sin WTP, buyers ni piloto |
| H3 | Incident→control→regression es único | PARTIALLY SUPPORTED | AIGIS no lo tiene; no validado comercialmente |
| H4 | Control-induced stall es categoría nueva | PARTIALLY SUPPORTED | Concepto funcional válido; no nombre canónico establecido |
| H5 | SAGR como recovery es novel | NOT SUPPORTED | Temporal+DBOS+LangGraph cubren recovery de crashes |
| H6 | SAGR como governance de continuación es novel | PARTIALLY SUPPORTED | PolicyGuide/SafeAgent cubren workflows estructurados; open-ended sigue abierto |
| H7 | generate_alternative para open-ended agents está sin implementar | SUPPORTED (PROVISIONAL) | No encontrado en búsquedas públicas; requiere confirmación de campo |
| H8 | non_bypass_verify no existe | PARTIALLY SUPPORTED | No encontrado como primitiva implementada; existe como concepto en Recoverability |
| H9 | Durable execution resuelve recovery semántico | NOT SUPPORTED | Todos documentan que su replay re-ejecuta LLM/API con posibles resultados distintos |
| H10 | "3 casos en 4 semanas" justifica construir SAGR | HYPOTHESIS — SIN BASE | Umbral ilustrativo sin base estadística; ver criterios en §7 |

---

## 6. Estado técnico del espacio de soluciones

### Lo que YA existe (público)

| Capacidad | Implementación | Madurez |
|---|---|---|
| Loop detection | LangGraph, AutoGPT, loopless | OSS / Research |
| Checkpoint + rollback | Temporal, DBOS, LangGraph, AgentRewind | PROD (Temporal, DBOS) / Research (AgentRewind) |
| State fingerprinting | RIR (arXiv:2609.18304) | Research |
| HARD STOP vs RECOVERABLE classification | Recoverability (arXiv:2609.13672) | Research |
| Policy block + feedback + retry | OSGuard (arXiv:2606.15034) | Research |
| generate_alternative (structured workflows) | PolicyGuide, SafeAgent | Research |
| Side-effect ledger / non-reexecution | Living AI, Replay Agent Recorder | OSS Alpha |
| Semantic equivalence detection | ReflectiChain (MDPI 2026) | Research |
| Recovery budget / irreversibility | Irreversibility Budget (arXiv:2609.00275), BAGEN | Research |
| Execution governance standard | ACS (May 2026 draft) | Draft Standard |

### Lo que NO existe todavía (para open-ended agents)

1. `generate_alternative(S, O, P, A_blocked) → A' | NONE` con:
   - Precisión suficiente (no genera NONE cuando existe alternativa)
   - Conservadurismo suficiente (no genera A' que viole P de formas no obvias)
   - Verificabilidad (tercero puede confirmar A' no es bypass)
2. `non_bypass_verify(A', A_blocked, P) → SAFE | UNSAFE` como primitiva implementada
3. STALL_POLICY detector confiable (distinguir "política me bloquea" de otros tipos de stall)
4. Continuidad de side effects **garantizada** para todos los efectos externos

---

## 7. Criterios de decisión para el owner

### Umbral operacional (reemplaza el "3 casos en 4 semanas" no demostrado)

Para justificar construir SAGR, se necesitan TODAS estas evidencias:

1. **Frecuencia real de STALL_POLICY:** instrumentar CCP con contador; ¿cuántos stalls por
   política ocurren por semana de uso real?
2. **Fracción con alternativa viable:** de esos stalls, ¿en cuántos el usuario sabía que
   había una forma válida de continuar que el agente no intentó?
3. **Costo comparativo:** ¿cuánto cuestan en tokens/tiempo esos stalls vs un restart completo?
4. **Viabilidad de non_bypass_verify:** ¿puede verificarse en el contexto específico de CCP
   que una alternativa generada no es un bypass del intent de la política?

**Experimento mínimo:** instrumentar `bash-firewall.sh` y `task-completed-evidence.sh` para
registrar STALL_POLICY events. Correr 30 días. Contar y clasificar. No requiere abrir F10.

### Gate de seguridad (no negociable)

> STALL ≠ PERMISSION TO BYPASS SAFETY

El mecanismo de recovery no puede convertirse en circumvention. Si `generate_alternative`
produce una acción que logra el mismo resultado prohibido, el sistema ha fallado su invariante
más importante. Cualquier implementación de SAGR debe tratar esto como un invariante de
primer orden, no como una feature opcional.

---

## 8. Incertidumbres irresolubles por desk research

| ID | Incertidumbre | Por qué no se puede resolver con desk research |
|---|---|---|
| H-01 | Frecuencia real de STALL_POLICY en CCP | Requiere logs de producción reales |
| H-02 | Implementación de non_bypass_verify para open-ended agents | Requiere experimento o paper nuevo post-2026-09-21 |
| H-03 | WTP real de operadores para governance de continuación | Requiere entrevistas con operadores de agentes en producción |
| H-04 | Adopción real del estándar ACS (May 2026) | Requiere datos de campo de adopción |

---

## 9. Arquitectura conceptual mínima (no implementación)

Si se construyera, SAGR tendría estas capas:

```
┌─────────────────────────────────────────────────────┐
│  EXECUTION LAYER (agente ejecuta normalmente)        │
└────────────────────┬────────────────────────────────┘
                     │ STALL detectado
┌────────────────────▼────────────────────────────────┐
│  CLASSIFICATION LAYER                                │
│  ¿Es HARD_STOP (irresoluble) o STALL_POLICY?        │
│  ¿Hay alternativa viable dentro de la política?      │
└────────────────────┬────────────────────────────────┘
                     │ STALL_POLICY + alternativa posible
┌────────────────────▼────────────────────────────────┐
│  ALTERNATIVE GENERATION (el problema sin resolver)   │
│  generate_alternative(S, O, P, A_blocked) → A' | NONE│
└────────────────────┬────────────────────────────────┘
                     │ A' propuesta
┌────────────────────▼────────────────────────────────┐
│  NON-BYPASS VERIFICATION (el otro problema)          │
│  verify(A', A_blocked, P) → SAFE | UNSAFE            │
└────────────────────┬────────────────────────────────┘
                     │ SAFE
┌────────────────────▼────────────────────────────────┐
│  CONTINUATION (agente continúa con A')               │
│  + side-effect ledger + evidence trail               │
└─────────────────────────────────────────────────────┘
```

Cada capa excepto la de ejecución es nueva respecto a los sistemas actuales para open-ended
agents. La de alternative generation y non-bypass verification son los únicos problemas técnicos
genuinamente no resueltos en este espacio.

---

## 10. Veredicto de cierre

### RESEARCH COMPLETE para desk research

La investigación se cierra porque:
- Las familias principales de mecanismos fueron cubiertas (17 dominios)
- Los equivalentes ocultos fueron investigados y registrados
- Las hipótesis sobrevivientes tienen falsificadores definidos
- Las hipótesis muertas tienen evidencia de muerte
- Lo que queda (H-01 a H-04) requiere experimento real, entrevistas o datos de producción

### Estado de SAGR

**SAGR como concepto**: PARTIALLY SUPPORTED — existe el problema, existen piezas parciales,
falta el ensamblaje completo con el invariante de seguridad para open-ended agents.

**SAGR como proyecto de implementación para CCP**: REQUIRES FIELD VALIDATION — la decisión
depende de los 4 criterios del §7, ninguno de los cuales puede resolverse con desk research.

**SAGR como oportunidad comercial externa**: COMMERCIAL UNKNOWN — sin entrevistas, sin WTP,
sin buyer identificado con presupuesto.

---

## 11. Próximos pasos recomendados

### Inmediato (sin abrir F10)
- [ ] Instrumentar bash-firewall con contador de STALL_POLICY events
- [ ] Definir formato de log: timestamp, task_id, policy_type, had_alternative (manual)
- [ ] Correr 30 días y recopilar datos

### Condicional (si H-01 y H-02 se resuelven favorablemente)
- [ ] Diseñar F10 con alcance mínimo: solo el clasificador HARD_STOP vs STALL_POLICY
- [ ] Benchmarking de generate_alternative con los papers de sept-2026 como baseline
- [ ] Gate de owner antes de implementar non_bypass_verify

### No recomendado sin validación previa
- [ ] Implementar la arquitectura completa de SAGR sin datos de campo

---

## 12. Referencias cruzadas

| Documento | Contiene |
|---|---|
| `SAGR_DEEP_RESEARCH/NOTAS_SISTEMAS_CLASICOS.md` | Analogías en 12 dominios clásicos |
| `SAGR_DEEP_RESEARCH/NOTAS_AGENTES_ACADEMIA.md` | 9+ papers de agents 2026 |
| `SAGR_DEEP_RESEARCH/NOTAS_COMERCIAL_ECONOMIA.md` | Realidad competitiva y WTP |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/05_ERRORES_Y_CORRECCIONES.md` | Correcciones detalladas con fuentes |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/12_RECONSTRUCCION_DEL_MODELO.md` | Modelo unificado completo |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/13_RECONSTRUCCION_DE_LA_ARQUITECTURA.md` | Arquitectura conceptual detallada |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/18_JUICIOS_FINALES_AUDITADOS.md` | Tabla completa de hipótesis |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/34_AUDITORIA_ADVERSARIAL_FINAL.md` | 8 perspectivas adversariales |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/37_CERTIFICADO_DE_SATURACION.md` | Cierre formal de investigación |
| `SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/38_AUDITORIA_FINAL_DEL_MASTER.md` | Auditoría completa del programa |

---

*Claude Sonnet 4.6 — Consolidación final — 2026-09-21 — HEAD `ccc0760`*
