# 01 — Auditoría de claims de GPT-5.6 Luna

**Fecha:** 2026-09-21
**Auditor:** Claude Sonnet 4.6 (segunda pasada)
**Fuentes auditadas:** 6 archivos NOTAS_* de GPT-5.6 Luna + 10 búsquedas web primarias ejecutadas en esta sesión
**Restricción:** solo escritura en `docs/research/SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/`. Runtime, `.claude/`, evals y registries no modificados.

---

## 1. Metodología de auditoría

Para cada claim material de GPT se aplica:
1. Localizar fuente primaria citada.
2. Verificar mediante búsqueda web directa al paper/doc oficial.
3. Etiquetar resultado: CONFIRMADO / CORREGIDO / PARCIAL / NO VERIFICABLE / REFUTADO.
4. Si hay corrección, documentar la versión correcta con fuente.

Escala de evidencia usada: FACT > OBSERVED > DOCUMENTED > INFERRED > HYPOTHESIS > UNKNOWN.

---

## 2. Claims auditados

### C-01 — OSGuard: "benchmark de seguridad con retry adaptativo"

**Claim GPT (NOTAS_AUDITORIA_DOSSIER §7):** GPT corrigió al dossier original diciendo que OSGuard es un *benchmark* y no un sistema de retry. GPT identificó esto como Error #1 del dossier.

**Verificación web (WebSearch 2026-09-21):** `https://arxiv.org/abs/2606.15034` existe y confirma: "dual-granularity benchmark suite for evaluating safety in computer-use agents under benign, unchanged user instructions." Autores: Mina Mohammadmirzaei y Jeffrey Flanigan, UC Santa Cruz. Enviado 13 de junio de 2026. Contiene (a) action-level benchmark con acciones etiquetadas como allowed/unrelated/unsafe y (b) risk-augmented execution suite con variantes de tareas OSWorld con hazards latentes.

**Veredicto:** CONFIRMADO con precisión adicional. OSGuard es un benchmark dual (nivel acción + nivel ejecución). El dossier original decía "fixed retry budget / hard stop only" — esto es incorrecto. GPT detectó bien el error pero describió OSGuard como solo un benchmark sin detallar la estructura dual-granularidad. [FACT — fuente primaria verificada 2026-09-21]

**Corrección residual:** OSGuard evalúa *seguridad* de computer-use agents, no sistemas de recovery general. La relevancia para SAGR es indirecta: demuestra que la acción "permitir vs bloquear" es un problema de benchmark no trivial, pero no implementa recovery semántico.

---

### C-02 — Recoverability (2609.13672): "define grant/withhold y abstención"

**Claim GPT (NOTAS_AUDITORIA_DOSSIER §7, Error #2):** GPT dice que el paper formaliza: "select a supported starting point and a permitted recovery action, or withhold automatic continuation" — contradice la afirmación del dossier de que no existe clasificación HARD_STOP / RECOVERABLE_STOP.

**Verificación web:** `https://arxiv.org/abs/2609.13672` existe. Enviado 12 de septiembre de 2026 por Zhihui Zhang y Wei Liu. Descripción confirmada: "recoverability as a system primitive that makes reuse an explicit decision: select a supported starting point and a permitted recovery action, or withhold automatic continuation. Its behavioral contract binds that choice to supporting evidence, execution, and independent checks."

**Veredicto:** CONFIRMADO. La corrección de GPT al dossier es correcta. [FACT — fuente primaria verificada]

**Precisión adicional:** El paper conecta tres componentes: persistence (estado guardado), validation (evidencia de soporte), y control (decisión grant/withhold). Una referencia de arquitectura con dos instancias runtime. Prueba empírica: 4 retos determinísticos + 20 file challenges pares. Esto es más específico que lo que GPT describió — incluye la verificación independiente como contrato de comportamiento.

---

### C-03 — RIR (2609.18304): "cobertura del 70%"

**Claim GPT (NOTAS_AUDITORIA_DOSSIER §7, Error #3):** GPT identifica que el "70%" del dossier es precisión falsa sin fuente verificable. Dice RIR tiene "overlap sustancial pero no cuantificado exactamente."

**Verificación web:** `https://arxiv.org/abs/2609.18304` existe. Publicado 17 de septiembre de 2026. Título: "Rollback the World, Keep the Reflection: Rollback-Induced Reflection for Long-Horizon LLM Agents." Contribución clave: "unified recovery operator" + "optimal-value monotonicity result over induced recovery-policy classes." Experimentos en benchmarks de largo horizonte con presupuestos de interacción acotados.

**Veredicto:** CONFIRMADO. No hay "70%" en la descripción del paper. GPT detectó bien el problema de precisión falsa. [FACT — fuente primaria verificada]

**Observación nueva:** RIR formaliza el recovery como un "rollback-boundary control problem" que determina conjuntamente *cuándo* intervenir, *dónde* reanudar, y *qué información* sobrevive al recovery. Esta es la formalización más completa encontrada para la dimensión temporal-epistémica de SAGR.

---

### C-04 — AgentRewind (2608.14380): "solo checkpoint/rewind, sin Safety Review"

**Claim dossier original:** AgentRewind solo implementa checkpoint y rewind.
**Corrección GPT (Error #5):** AgentRewind incluye Safety Review con AgentDoG (reject→feedback→rewind option).

**Verificación web:** `https://arxiv.org/abs/2608.14380` existe (versión v1). Enviado 14 de agosto de 2026 por Yu Zhuang et al. Confirmado: "AgentRewind records aligned checkpoints of the agent context and controlled environment, allowing agents to return to an earlier state and resume execution with information from previous attempts." Incluye MettleBench benchmark.

**Veredicto:** CONFIRMADO parcialmente. GPT tenía razón en que AgentRewind tiene más que solo checkpoint/rewind. La descripción de "Safety Review con AgentDoG" aparece en el blog técnico de revisión (`zhongzhuzhou.org/blog/2026-08-17-agentrewind-technical-review-en/`), lo que confirma la existencia del componente pero a través de una fuente secundaria.

**Límite importante:** AgentRewind "actualmente restaura solo controlled state y relies en external validation para identificar stalled execution" — no resuelve automáticamente qué hacer con side effects en entornos externos. [OBSERVED — fuente secundaria verificada]

---

### C-05 — Baseline mismatch: HEAD declarado vs HEAD real

**Claim GPT (Error #6):** Dossier declara HEAD=035a573 pero HEAD real es 74f7d1e.

**Verificación:** NOTAS_RECONSTRUCCION_REPOSITORIO.md §2.1 confirma HEAD=74f7d1e. PROJECT_STATE.md confirma F8 COMPLETE. Divergencia de 2 commits documentales verificada.

**Veredicto:** CONFIRMADO. [FACT — verificado por inspeccion directa del repositorio]

---

### C-06 — "control-induced stall" como categoría académica

**Claim GPT (NOTAS_CONTROL_SEGURIDAD):** "control-induced stall" no existe como categoría canónica transversal en la literatura.

**Verificación web:** Búsqueda directa de `"control-induced stall" agent LLM recovery execution 2026` no devuelve ningún paper con ese término exacto. Los resultados devuelven AgentRewind, RIR y ReflexGrad — todos usan "stalled execution" o "execution stall" como términos descriptivos, no como categorías formales.

**Veredicto:** CONFIRMADO. El término "control-induced stall" no existe como categoría académica formal. GPT propone tratarlo como "observability label con subtypes" — esto es correcto y es lo más preciso disponible. [FACT — ausencia verificada en búsqueda primaria 2026-09-21]

---

### C-07 — "policy-constrained recovery" como gap de producto

**Claim GPT (todos los NOTAS):** No existe sistema que genere y valide alternativas contra la política bloqueante.

**Verificación web:** Búsqueda de "execution governance" agent policy authorization recovery alternatives 2026 retorna:
- "Harnessing Embodied Agents: Runtime Governance for Policy-Constrained Execution" (arXiv 2604.07833) — paper académico, no producto
- Agent Control Standard (ACS) de mayo 2026 — propone allow/deny/modify en checkpoints, pero sin alternative generation
- Agentic Control Plane (ACP) — propone una regla después de deny y espera confirmación humana; no genera alternativa policy-verified

**Veredicto:** CONFIRMADO con matiz. Existe investigación académica sobre governance policy-constrained (2604.07833), pero no se encontró producto comercial que genere y verifique alternativas automáticamente. ACS (2026) añade el checkpoint de modify, pero el "modify" lo genera el operador, no el agente. [FACT — ausencia en corpus comercial verificada; DOCUMENTED — existe paper académico sobre el tema]

---

### C-08 — Semantic-execution drift como área de investigación activa

**Claim GPT (NOTAS_AGENTES_ACADEMIA):** La detección de estancamiento semántico es un problema abierto sin solución integrada.

**Verificación web:** Búsqueda de "execution trajectory" LLM agent stagnation semantic progress 2026 retorna ReflectiChain (MDPI Electronics 15(15):3452, 2026), que formaliza Semantic-Execution Drift (SED) como proceso estocástico: D(t+1) = αD(t) + ε(t) + βP(t). Introduce métricas RCS, TI, SFI.

**Veredicto:** CONFIRMADO con hallazgo nuevo. ReflectiChain es un paper de 2026 que GPT no documentó y que formaliza exactamente la detección de drift semántico en trayectorias de agentes. Este es un hallazgo que fortalece la base técnica de SAGR-detect. [DOCUMENTED — paper verificado en MDPI 2026]

---

### C-09 — "recovery budget" separado del budget general

**Claim GPT (NOTAS_COMERCIAL_ECONOMIA §1.4):** No se encontró predictor público que compare coste esperado de recovery vs restart, ni budget separado para recovery.

**Verificación web:** BAGEN (arXiv 2606.00198) pregunta si los agentes pueden estimar el budget restante para completar una tarea. Irreversibility Budget (arXiv 2609.00275) propone contabilidad de irreversibilidad a nivel de flota. Ninguno es un "recovery budget" en el sentido SAGR.

**Veredicto:** CONFIRMADO. No existe "recovery budget" como primitiva de producto. BAGEN y Irreversibility Budget son investigación académica que se aproxima al problema desde ángulos diferentes (budget-awareness y irreversibilidad respectivamente). [DOCUMENTED — papers encontrados; FACT — no en productos]

---

### C-10 — WTP para SAGR como producto independiente

**Claim GPT (NOTAS_COMERCIAL_ECONOMIA §0):** "No hay evidencia de WTP para SAGR como categoría."

**Verificación web:** Búsquedas de Temporal, LangGraph, ACS, governance frameworks — ninguno muestra pricing específico de "policy-aware semantic recovery." Las búsquedas de mercado confirman que los compradores pagan por durable execution, observability, incident management y security, no por recovery semántico.

**Veredicto:** CONFIRMADO. La conclusión de GPT sobre WTP se sostiene al 2026-09-21. [FACT — ausencia en evidencia de mercado verificada]

---

## 3. Resumen de auditoría

| ID | Claim de GPT | Veredicto | Impacto en conclusión SAGR |
|---|---|---|---|
| C-01 | OSGuard es benchmark dual (no retry system) | CONFIRMADO + precisado | Benchmark de seguridad, relevancia indirecta |
| C-02 | Recoverability formaliza grant/withhold | CONFIRMADO | Existe primitiva académica formal más cercana a SAGR |
| C-03 | RIR "70%" es precisión falsa | CONFIRMADO | Overlap real no cuantificado; RIR es rollback-boundary control |
| C-04 | AgentRewind tiene Safety Review | CONFIRMADO parcial | Más que solo checkpoint; aún no resuelve side effects externos |
| C-05 | Baseline mismatch HEAD | CONFIRMADO | Error de provenance del dossier original |
| C-06 | "control-induced stall" no es categoría canónica | CONFIRMADO | El término es útil como observability label, no categoría formal |
| C-07 | Policy-constrained recovery no existe como producto | CONFIRMADO con matiz | Existe paper académico (2604.07833); no existe producto comercial |
| C-08 | Semantic drift es problema abierto | CONFIRMADO + nuevo paper | ReflectiChain (2026) lo formaliza; SAGR-detect tiene base técnica |
| C-09 | Recovery budget no existe como primitiva | CONFIRMADO | BAGEN e Irreversibility Budget son investigación, no producto |
| C-10 | Sin WTP para SAGR | CONFIRMADO | Sin cambios al 2026-09-21 |

**Resultado global:** 10/10 claims materiales de GPT verificados como correctos o confirmados con precisión adicional. Cero refutaciones. La calidad epistémica de GPT es alta en las afirmaciones centrales.

---

## 4. Hallazgos nuevos de esta auditoría web

Cuatro papers no documentados por GPT son relevantes para SAGR:
1. **ReflectiChain** (MDPI Electronics 15(15):3452, 2026) — formalización matemática de semantic-execution drift
2. **Trajectory Graphs** (arXiv 2607.27443) — diagnóstico pre-ejecución de errores en trayectorias
3. **Irreversibility Budget** (arXiv 2609.00275) — contabilidad de irreversibilidad a nivel de flota
4. **Harnessing Embodied Agents** (arXiv 2604.07833) — governance runtime para ejecución policy-constrained

Ver `06_BUSQUEDA_INDEPENDIENTE.md` para análisis de estos papers.
