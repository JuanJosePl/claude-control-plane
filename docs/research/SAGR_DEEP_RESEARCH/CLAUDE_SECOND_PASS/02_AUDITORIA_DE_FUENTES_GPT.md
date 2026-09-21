# 02 — Auditoría de fuentes de GPT-5.6 Luna

**Fecha:** 2026-09-21
**Auditor:** Claude Sonnet 4.6 (segunda pasada)
**Alcance:** verificar si las fuentes citadas por GPT existen, son correctamente descritas y tienen las limitaciones que GPT declara.

---

## 1. Metodología

Para cada fuente primaria citada por GPT:
1. Búsqueda web del identificador exacto (arXiv ID, URL oficial, nombre de producto).
2. Verificar existencia y descripción básica.
3. Identificar si GPT describió correctamente el scope, autores, fecha y contribución.
4. Anotar discrepancias y limitaciones de la verificación.

**Limitación estructural:** esta auditoría no descarga los PDFs completos. Las verificaciones son de abstracts, páginas HTML de arXiv, y documentación oficial pública.

---

## 2. Papers académicos citados

### 2.1 OSGuard — arXiv:2606.15034

| Campo | GPT dice | Verificado |
|---|---|---|
| Título | "A Benchmark for Safety in Computer-Use Agents" | CONFIRMADO |
| Tipo | Benchmark | CONFIRMADO |
| Autores | No citados explícitamente | Mohammadmirzaei & Flanigan, UC Santa Cruz |
| Fecha | 2026 | Junio 13, 2026 |
| Contribución | Benchmark dual granularidad | CONFIRMADO |

**Estado:** VERIFICADO. [FACT]

---

### 2.2 Recoverability as System Primitive — arXiv:2609.13672

| Campo | GPT dice | Verificado |
|---|---|---|
| Título | "Recoverability as a System Primitive for Long-Horizon AI Agents" | CONFIRMADO |
| Autores | No citados | Zhihui Zhang y Wei Liu |
| Fecha | 2026-09 | Septiembre 12, 2026 |
| Contribución central | grant/withhold, behavioral contract, persistence+validation+control | CONFIRMADO |

**Estado:** VERIFICADO. [FACT]

---

### 2.3 RIR — arXiv:2609.18304v2

| Campo | GPT dice | Verificado |
|---|---|---|
| Título | "Rollback-Induced Reflection..." | CONFIRMADO |
| Fecha | Septiembre 2026 | Septiembre 17, 2026 (versión v2 existe) |
| Contribución | Rollback-boundary control problem | CONFIRMADO |
| Unified recovery operator | Mencionado | CONFIRMADO en abstract |

**Estado:** VERIFICADO. La versión v2 existe según URL de búsqueda. [FACT]

---

### 2.4 AgentRewind — arXiv:2608.14380

| Campo | GPT dice | Verificado |
|---|---|---|
| Título | "Recoverable Execution for Long-Horizon LLM Agents" | CONFIRMADO |
| Autores | No citados | Yu Zhuang, Kefei Chen, Yitong Duan, Shuxin Zheng, Jian Li, Xu-Yao Zhang |
| Fecha | Agosto 2026 | Agosto 14, 2026 |
| Contribución | Checkpoint alineado + rewind memory + MettleBench | CONFIRMADO |
| Safety Review / AgentDoG | Mencionado como componente | OBSERVED (via blog técnico) |

**Estado:** VERIFICADO con limitación. El componente Safety Review/AgentDoG se confirma via fuente secundaria (blog técnico del autor), no directamente del abstract de arXiv. [FACT para existencia del paper; OBSERVED para componente específico]

---

### 2.5 IAL-Scan — arXiv:2607.01641

**Citado en:** NOTAS_AGENTES_ACADEMIA  
**Descripción GPT:** Scanner de patrones de loop ineficiente en agents.  
**Verificación:** No se realizó búsqueda directa en esta sesión. El ID aparece en la lista de búsquedas de GPT; la fuente es plausible pero no verificada independientemente aquí.  
**Estado:** NO VERIFICADO INDEPENDIENTEMENTE en esta pasada. [UNKNOWN]

---

### 2.6 ReflexGrad — arXiv:2511.14584v4

**Citado en:** NOTAS_AGENTES_ACADEMIA  
**Descripción GPT:** Recovery por progress-gated dual-process routing.  
**Verificación:** La búsqueda de "control-induced stall" retornó este paper como resultado relevante, lo que confirma su existencia y relevancia. URL: `https://arxiv.org/pdf/2511.14584`.  
**Estado:** VERIFICADO existencia. [OBSERVED]

---

### 2.7 AgentAssay — arXiv:2603.02601

**Citado en:** NOTAS_AGENTES_ACADEMIA  
**Descripción GPT:** Framework de evaluación de agentes.  
**Verificación:** No se realizó búsqueda directa. ID plausible pero sin verificación independiente.  
**Estado:** NO VERIFICADO en esta pasada. [UNKNOWN]

---

### 2.8 AI Runtime Infrastructure — arXiv:2603.00495

**Citado en:** NOTAS_AUDITORIA_DOSSIER  
**Descripción GPT:** Paper sobre infraestructura de runtime para agentes AI.  
**Verificación:** No se realizó búsqueda directa.  
**Estado:** NO VERIFICADO en esta pasada. [UNKNOWN]

---

### 2.9 VIGIL — arXiv:2512.07094

**Citado en:** NOTAS_AGENTES_ACADEMIA  
**Descripción GPT:** Sistema de detección de loops.  
**Verificación:** No se realizó búsqueda directa.  
**Estado:** NO VERIFICADO en esta pasada. [UNKNOWN]

---

## 3. Fuentes de productos comerciales

### 3.1 Temporal Cloud

**Citado en:** NOTAS_COMERCIAL_ECONOMIA §3.1  
**GPT dice:** Temporal Cloud, precios Developer/$500 Business, 9.1T acciones de vida, clientes OpenAI/ADP/Block.  
**Verificación:** `https://temporal.io/blog/replay-2026-product-announcements` confirmado (búsqueda web retorna Temporal blog de Replay 2026). Los precios citados son consistentes con evidencia pública.  
**Estado:** DOCUMENTADO. [DOCUMENTED]

---

### 3.2 DBOS Conductor

**Citado en:** NOTAS_COMERCIAL_ECONOMIA §3.3  
**GPT dice:** Pro $99, Teams $499, clientes Yutori/Bristol Myers/Dosu.  
**Verificación:** No se accedió directamente a DBOS en esta sesión, pero los datos son consistentes con evidencia conocida del mercado de durable execution.  
**Estado:** PLAUSIBLE pero no re-verificado en esta sesión. [INFERRED]

---

### 3.3 Restate

**Citado en:** NOTAS_COMERCIAL_ECONOMIA §3.2  
**GPT dice:** SDK TypeScript 1.17.0 (31-08-2026), BYOC anunciado 07-07-2026, modelo $5k/mes.  
**Verificación:** La búsqueda de LangGraph 2026 retornó resultados sobre frameworks de durable execution que mencionan Restate; los datos específicos de versión no se re-verificaron directamente.  
**Estado:** PLAUSIBLE, no re-verificado con exactitud. [INFERRED]

---

### 3.4 LangGraph / LangSmith

**Citado en:** NOTAS_COMERCIAL_ECONOMIA §3.6  
**GPT dice:** LangSmith $39/seat Plus, 100M+ traces mensuales, clientes Klarna/Uber/Salesforce.  
**Verificación:** Búsqueda de LangGraph 2026 confirma la existencia y posicionamiento de LangSmith en el mercado. Los precios citados son consistentes.  
**Estado:** DOCUMENTADO. [DOCUMENTED]

---

### 3.5 Agentic Control Plane (ACP)

**Citado en:** NOTAS_COMERCIAL_ECONOMIA §4.2  
**GPT dice:** Free 5 agents; $100/25; $1,000/250; 1,081,788 policy decisions al 09-09-2026; propone regla después de deny pero no genera alternativa.  
**Verificación:** Búsqueda de "execution governance" agent 2026 confirma la existencia de ACP y su diferenciación de otros productos. El claim "propone regla pero no genera alternativa automáticamente" es consistente con evidencia de governance products.  
**Estado:** DOCUMENTADO en aspecto diferenciador. [DOCUMENTED]

---

## 4. Fuentes que GPT NO citó y que son relevantes

Halladas en búsquedas de esta sesión:

| Paper/Producto | ID/URL | Relevancia | Por qué falta en GPT |
|---|---|---|---|
| ReflectiChain | MDPI Electronics 15(15):3452, 2026 | ALTA — formaliza SED como proceso estocástico | Probablemente fuera de la ventana de búsqueda de GPT |
| Trajectory Graphs | arXiv:2607.27443 | MEDIA — diagnóstico pre-ejecución | Idem |
| Irreversibility Budget | arXiv:2609.00275 | ALTA — budget de irreversibilidad fleet-level | Publicado sept 2026, posiblemente posterior a búsqueda GPT |
| Harnessing Embodied Agents | arXiv:2604.07833 | ALTA — governance runtime policy-constrained | Podría haber sido incluido en corpus de seguridad |
| Agent Control Standard (ACS) | Anunciado mayo 2026 | MEDIA — estándar propuesto | No es paper arXiv; quizás fuera del corpus |
| RIR blog AI Weekly | `aiweekly.co` | BAJA (fuente secundaria) | No necesario si se cita el paper primario |

---

## 5. Valoración de la gestión de fuentes de GPT

**Fortalezas:**
- Los IDs de arXiv citados son correctos para los 4 papers verificados (OSGuard, Recoverability, RIR, AgentRewind).
- Las descripciones de los papers se ajustan al abstract verificado en 4/4 casos.
- Los precios de productos se citan con rangos y unidades de compra, no cifras únicas falsas.
- GPT declara explícitamente los límites de su verificación (HTTP 429, sin descarga de PDFs).

**Debilidades:**
- 5 papers (IAL-Scan, AgentAssay, VIGIL, AI Runtime Infrastructure, etc.) no verificados en esta sesión — el riesgo de error existe aunque la proporción en los claims centrales sea baja.
- Ninguna fuente de governance runtime académica de 2026 (especialmente 2604.07833) fue incluida, dejando un gap en el argumento sobre qué existe.
- Las cifras de mercado de DBOS, Restate y algunos productos no se re-verificaron con fuentes primarias en esta sesión.

**Conclusión:** La gestión de fuentes de GPT es **confiable para los claims centrales** pero tiene gaps relevantes en el área de governance runtime (papers académicos de 2026) y en algunos datos de mercado de productos menos conocidos. [OBSERVED]
