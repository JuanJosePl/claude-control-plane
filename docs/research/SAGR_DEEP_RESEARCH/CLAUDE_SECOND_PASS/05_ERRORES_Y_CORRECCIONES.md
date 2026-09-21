# 05 — Errores y correcciones

**Fecha:** 2026-09-21
**Auditor:** Claude Sonnet 4.6 (segunda pasada)
**Alcance:** errores en el dossier original (CCP_SAGR_RESEARCH_DOSSIER.md) ya identificados por GPT, más errores nuevos encontrados en esta segunda pasada.

---

## 1. Errores del dossier original (previamente identificados por GPT)

### E-01 — OSGuard descrito como sistema de retry con hard stop

**Texto incorrecto en dossier:** "OSGuard: fixed retry budget / hard stop only" (línea ~342 del dossier).  
**Corrección verificada:** OSGuard (arXiv:2606.15034) es un benchmark de seguridad dual-granularidad para computer-use agents, no un sistema de runtime con retry budget. Sus dos componentes son: (1) action-level benchmark con labeled actions y (2) risk-augmented execution suite con OSWorld task variants con hazards latentes.  
**Fuente de corrección:** `https://arxiv.org/abs/2606.15034` — verificada 2026-09-21.  
**Severidad:** ALTA — cambia la caracterización de una cita primaria usada para soportar un claim de "qué existe."  
**Estado:** CORREGIDO en esta segunda pasada. [FACT]

---

### E-02 — Recoverability (2609.13672) descrito como sin clasificación HARD_STOP/RECOVERABLE

**Texto incorrecto en dossier:** Afirmación de que no existe clasificación formal de estados de recuperación en la literatura de agentes.  
**Corrección verificada:** El paper define explícitamente "select a supported starting point and a permitted recovery action, or withhold automatic continuation" — esto es exactamente la distinción RECOVERABLE (select + proceed) vs HARD_STOP (withhold). El behavioral contract vincula la decisión a supporting evidence, lo que añade una dimensión epistémica ausente en el dossier.  
**Fuente de corrección:** `https://arxiv.org/abs/2609.13672` — verificada 2026-09-21.  
**Severidad:** ALTA — el dossier afirmaba una ausencia que no es tal.  
**Estado:** CORREGIDO. [FACT]

---

### E-03 — RIR: "70% de cobertura de recuperación"

**Texto incorrecto en dossier:** Afirmación de que RIR cubre el 70% de los fallos de recovery.  
**Corrección verificada:** El abstract de arXiv:2609.18304 no menciona ningún porcentaje de cobertura. El paper presenta un "unified recovery operator" con resultados empíricos en benchmarks, pero sin cifra del 70%. Esta fue una precisión falsa sin fuente verificable.  
**Fuente de corrección:** `https://arxiv.org/abs/2609.18304` — verificada 2026-09-21.  
**Severidad:** MEDIA — afecta la cuantificación de una afirmación, no la existencia del sistema.  
**Estado:** CORREGIDO. La corrección es: "RIR formaliza recovery como rollback-boundary control problem y reporta mejoras en benchmarks de largo horizonte; no hay cifra de cobertura del 70%." [FACT]

---

### E-04 — Side-effect continuity declarada como "no existe"

**Texto incorrecto en dossier:** Afirmación de que no existen sistemas con ledger de side effects para recovery de agentes.  
**Corrección verificada (por GPT, confirmada aquí):** Living AI (PyPI 0.4.1), Replay Agent Recorder (GitHub, alpha) y AgentRewind (2608.14380) implementan parcialmente side-effect tracking/continuity. La categoría existe en estado alpha/investigación.  
**Severidad:** MEDIA — la afirmación de ausencia total es incorrecta; la ausencia de implementación de producción madura es correcta.  
**Estado:** CORREGIDO a: "existe investigación y tools alpha; no existe implementación de producción madura y validada." [DOCUMENTED]

---

### E-05 — AgentRewind descrito como solo checkpoint/rewind

**Texto incorrecto en dossier:** AgentRewind implementa solo checkpoint y rewind sin componente de safety review.  
**Corrección verificada:** AgentRewind (2608.14380v1) incluye un componente de Safety Review denominado AgentDoG con un mecanismo reject→feedback→rewind option. También incluye MettleBench, un benchmark para evaluar task completion y partial progress.  
**Fuente de corrección:** `https://arxiv.org/abs/2608.14380` + blog técnico del autor (zhongzhuzhou.org).  
**Severidad:** MEDIA — cambia la caracterización de la completitud del sistema.  
**Estado:** CORREGIDO. [OBSERVED para componente AgentDoG via fuente secundaria]

---

### E-06 — Baseline del repositorio declarado como 035a573

**Texto incorrecto en dossier:** "HEAD=035a573" en línea 6 del dossier.  
**Corrección verificada:** HEAD real del repositorio es `74f7d1e` — dos commits documentales posteriores. El dossier tiene una fecha de baseline desactualizada que afecta cualquier referencia a "el estado actual del repositorio."  
**Severidad:** BAJA para contenido técnico (los dos commits son documentales); MEDIA para integridad de provenance.  
**Estado:** DOCUMENTADO. No es corregible en el dossier original (no modificamos ese archivo). [FACT]

---

## 2. Errores nuevos encontrados en esta segunda pasada

### E-07 — NOTAS_AUDITORIA_DOSSIER: "single model context" como limitación no declarada explícitamente en portada

**Descripción:** NOTAS_AUDITORIA_DOSSIER §7 reconoce que las correcciones al dossier las hace el mismo GPT que investigó — lo que crea un problema de circularidad epistémica (mismo modelo corrigiéndose a sí mismo). Esta limitación existe pero está relegada a un párrafo interno.  
**Impacto:** No es un error factual sino un error metodológico. Las correcciones son correctas en los casos verificados (E-01 a E-05), pero la metodología tiene un sesgo estructural que no está suficientemente destacado.  
**Corrección recomendada:** Declarar en la portada de cada NOTAS_AUDITORIA que "esta auditoría fue producida por el mismo modelo que ejecutó la investigación original; todas las correcciones han sido re-verificadas contra fuentes primarias donde fue posible."  
**Estado:** DOCUMENTADO como limitación metodológica. Esta segunda pasada mitiga esta limitación al ser un modelo diferente (Claude Sonnet 4.6 vs GPT-5.6 Luna) verificando independientemente. [OBSERVED]

---

### E-08 — NOTAS_COMERCIAL_ECONOMIA: ACS no aparece en el análisis de governance frameworks

**Descripción:** El Agent Control Standard (ACS), anunciado en mayo de 2026 con propuesta de checkpoints estandarizados (allow/deny/modify), no aparece en NOTAS_COMERCIAL_ECONOMIA ni en NOTAS_CONTROL_SEGURIDAD.  
**Impacto:** El análisis de governance standards puede estar incompleto. ACS es relevante porque propone un estándar de middleware con allow/deny/modify en checkpoints — lo más cercano a un estándar de industria para policy enforcement en agents.  
**Corrección:** ACS se documenta en `06_BUSQUEDA_INDEPENDIENTE.md` de esta segunda pasada.  
**Estado:** DOCUMENTADO como omisión. [DOCUMENTED — ACS encontrado en búsqueda web 2026-09-21]

---

### E-09 — NOTAS_AGENTES_ACADEMIA: ReflectiChain (MDPI 2026) no documentada

**Descripción:** ReflectiChain (MDPI Electronics 15(15):3452, 2026) formaliza Semantic-Execution Drift como proceso estocástico con métricas RCS/TI/SFI. Este paper es directamente relevante para SAGR-detect (componente de detección de estancamiento semántico) y no aparece en NOTAS_AGENTES_ACADEMIA.  
**Impacto:** La formalización matemática del drift semántico existe en la literatura y no fue incluida. Esto debilita levemente el claim de que SAGR-detect no tiene base formal en la literatura.  
**Corrección:** ReflectiChain se documenta en `06_BUSQUEDA_INDEPENDIENTE.md`.  
**Estado:** DOCUMENTADO como omisión. [DOCUMENTED — paper verificado en MDPI 2026]

---

### E-10 — NOTAS_SISTEMAS_CLASICOS: Irreversibility Budget (2609.00275) no documentado

**Descripción:** arXiv:2609.00275 "The Irreversibility Budget: Fleet-Level Risk Accounting and Admission Control for Agent Operating Systems" propone contabilidad de irreversibilidad a nivel de flota — directamente relevante para el "recovery budget" de SAGR. No aparece en NOTAS_SISTEMAS_CLASICOS.  
**Impacto:** La discusión de "recovery budget" como primitiva es más rica de lo que GPT documentó. El Irreversibility Budget opera a nivel de flota, no de sesión individual, lo que abre una dimensión no explorada.  
**Corrección:** Se documenta en `06_BUSQUEDA_INDEPENDIENTE.md`.  
**Estado:** DOCUMENTADO como omisión. [DOCUMENTED — paper verificado en búsqueda 2026-09-21]

---

## 3. Resumen de errores

| ID | Origen | Tipo | Severidad | Estado |
|---|---|---|---|---|
| E-01 | Dossier original | Error factual (caracterización incorrecta) | ALTA | CORREGIDO |
| E-02 | Dossier original | Error factual (ausencia no verificada) | ALTA | CORREGIDO |
| E-03 | Dossier original | Error de precisión (cifra sin fuente) | MEDIA | CORREGIDO |
| E-04 | Dossier original | Error factual (afirmación de ausencia) | MEDIA | CORREGIDO |
| E-05 | Dossier original | Error factual (caracterización incompleta) | MEDIA | CORREGIDO |
| E-06 | Dossier original | Error de provenance (baseline desactualizado) | BAJA | DOCUMENTADO |
| E-07 | NOTAS GPT | Error metodológico (circularidad epistémica) | MEDIA | DOCUMENTADO |
| E-08 | NOTAS GPT | Omisión (ACS no incluido) | BAJA | DOCUMENTADO |
| E-09 | NOTAS GPT | Omisión (ReflectiChain no incluido) | BAJA | DOCUMENTADO |
| E-10 | NOTAS GPT | Omisión (Irreversibility Budget no incluido) | BAJA | DOCUMENTADO |

**Conclusión:** Los errores críticos (E-01, E-02) estaban en el dossier original, no en el trabajo de GPT. GPT detectó correctamente E-01 a E-05. Esta segunda pasada añade E-07 a E-10, que son omisiones de alcance, no errores factuales. La base factual del trabajo de GPT es sólida.
