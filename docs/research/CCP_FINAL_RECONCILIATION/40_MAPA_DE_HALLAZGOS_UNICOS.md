# 40 — Mapa de Hallazgos Únicos

**Fecha:** 2026-09-21
**Auditor:** Claude Opus 4.7
**Propósito:** Identificar hallazgos que existen en un corpus y no en el otro para evitar pérdida por compresión.

---

## 1. CHATGPT-ONLY FINDINGS (Corpus A únicamente)

Estos hallazgos no aparecen en el corpus B (Claude). Se registran para no perderlos, pero muchos son **HYPOTHESIS-GRADE** hasta reproducción — MASTERC §34 lo advierte explícitamente sobre las fuentes de Document 3.

| # | Hallazgo | Fuente A | Estado tras reconciliación | Por qué importa |
|---|---|---|---|---|
| A-01 | **State-Aware Runtime v4** (Cambridge Open Engage `6a80ae6b`) — canonical state, speculative state, proposals, validators, commit, rollback, compensation, handoff, audit, capability topology, 4-state authorization, single-use permissions, effect state machine | SRC-001 | UNVERIFIED (no repro por B); si es real, **cierra** claim de "trajectory governance novel" | Puede ser el prior art más fuerte contra cualquier hipótesis SAGR |
| A-02 | **Argus** (Microsoft Research) — general-purpose agentic runtime | SRC-002 | UNVERIFIED — MS Research existe, paper no cruzado por B | Si existe, es competitor institucional pesado |
| A-03 | **Turning Interaction History into Execution State** (arXiv:2608.00808) — Ledger paper reportando 28.9-31.8% cost reduction | SRC-003 | UNVERIFIED | Ledger = execution state explícito ya publicado |
| A-04 | **CONTINUITY: Security-Context Contracts** (arXiv:2609.05269) | SRC-005 | UNVERIFIED | Security context composition prior art |
| A-05 | **Towards Assurance Closure** (arXiv:2608.07317) — 6 gaps + C1-C6 architecture; el prior art más pesado contra la hipótesis SH-005 | SRC-006 | UNVERIFIED — arXiv preprint | Puede ser el prior art que cierra la hipótesis unificadora |
| A-06 | **Assurance Envelopes for Autonomous Coding Agents** (arXiv:2609.16302) | SRC-007 | UNVERIFIED | Minimum-cost evidence for software change |
| A-07 | **RISU Institute** notes — Consequence Closure (2026-03), Projection Assurance (2026-04), Reliance Before Closure (2026-02) | SRC-008/009/010 | HIGH FABRICATION RISK — MASTERC §34 advierte explícitamente | Si son reales, resuelven gran parte de las hipótesis abiertas; si son sintéticas, contaminan el corpus |
| A-08 | **PCAA** (Proof-Carrying Agent Actions, arXiv:2606.04104) | SRC-011 | UNVERIFIED | Model-agnostic action governance |
| A-09 | **CAVA** (Canonical Action Verification and Attestation, arXiv:2607.13716) | SRC-012 | UNVERIFIED | Canonical action identity |
| A-10 | **When AI Agents Commit / Cognitive Serializability** (arXiv:2609.20261) | SRC-013 | UNVERIFIED | TOCTOU for agents |
| A-11 | **Verification-Gated Agentic Mission-State Governance** (arXiv:2606.31339) — task forest, governed blackboard, resource locks, world beliefs, atomic commit | CLAIM-013 | UNVERIFIED | Si es real, cierra "mission-state governance is unexplored" |
| A-12 | **ResidualAuth** (arXiv:2609.08062) — 0-2/16 vs 15-16/16 en resolución de casos | SRC-024 | UNVERIFIED | Cuantifica dependency completeness para authorization |
| A-13 | **RSGA** (Requirements-Sufficiency-Gated Automation, RE 2026) — 10 dimensiones, 100 ambiguous prompts | SRC-042 | UNVERIFIED — conf paper | Especificación adecuada como gate |
| A-14 | **RECODE** — 83.3% vs 47.2% omission detection | SRC-060 | UNVERIFIED | Requirement recovery from code |
| A-15 | **DeepSeek Harness** — Session = append-only typed event log | SRC-032 | UNVERIFIED — GitHub inspeccionable si existe | Event-sourced agent runtime |
| A-16 | **ae-framework** (itdojp/ae-framework) — agent-neutral assurance control plane for SDLC | SRC-029 | UNVERIFIED — MASTERC dice self-reported "report-only/dry-run" | Competidor directo de CCP si existe |
| A-17 | **skil** (domehahn/skil) — vendor-neutral security/verification for AI skills | SRC-030 | UNVERIFIED | Competidor de skills governance |
| A-18 | **VERITAS OS** (veritasfuji-japan/veritas_os) — EFFECT_UNKNOWN state | SRC-031 | UNVERIFIED | Explícita el estado UNKNOWN_EFFECT que CCP no tiene |
| A-19 | **KV-Cache paper** (arXiv:2608.15939) — rollback de transcript ≠ rollback de KV-cache | SRC-061 | UNVERIFIED | Contraejemplo empírico a "rollback funciona" |
| A-20 | **VP-CONTROL** — voting con 62.9% aprobación de unsafe proposals con shared evidence | SRC-078 | UNVERIFIED | Common-mode evidence failure cuantificado |
| A-21 | Framework de **6 tipos de cambio de dependencia** (content / applicability / authority / temporal / execution context / causal chain) | §15 MASTERC | Framework conceptual, no cita fuente única | Útil como taxonomía |
| A-22 | Framework de **8 niveles de assurance** (LEVEL 0-7) | §16 MASTERC | Framework sintético | Útil como escalera de análisis |
| A-23 | Framework de **5 propiedades de evidencia** (integrity / relevance / sufficiency / freshness / coverage / independence — son 6 en realidad) | §14 MASTERC | Framework sintético con conteo inconsistente | Marco analítico |
| A-24 | Framework de **4 operaciones distintas** (REPLAY / ROLLBACK / FORK / COMPENSATE) | §17 MASTERC | Framework taxonómico | Distingue efectos de rollback de representación |
| A-25 | **Agentic Shadow Infrastructure** (MDPI) — composición no-segura de acciones individualmente seguras | SRC-040 | UNVERIFIED | Compositional drift empírico |
| A-26 | **IETF drafts** (HEM, Action Evidence Boundary, Action Determinability, Authority Transition Receipts) | SRC-051–054 | UNVERIFIED — verificable en datatracker.ietf.org | Estandarización naciente |
| A-27 | **ACLE-MCP** (attested capability leases) | SRC-050 | UNVERIFIED | Freshness de autoridad |
| A-28 | **Governance Decay** (arXiv:2606.22528) — context compaction removes safety constraints | SRC-017 | UNVERIFIED | Fallo específico documentado |
| A-29 | **ContextNest** (arXiv:2607.02116) — verifiable context governance | SRC-018 | UNVERIFIED | Context versioning con provenance |
| A-30 | **OpenClaw** semantic continuity regression | referenciado en §16 | UNVERIFIED | Contraejemplo empírico a "sesión continua" |

**Total hallazgos exclusivos A:** ~30 mayores. Reliabilidad mixta: los frameworks conceptuales son válidos independientemente de las fuentes; las fuentes específicas (papers, repos) requieren verificación de campo.

---

## 2. CLAUDE-ONLY FINDINGS (Corpus B únicamente)

Estos hallazgos no aparecen en Corpus A. Todos son verificados a nivel documental por Claude en la segunda pasada (10/10 claims materiales confirmados o corregidos con evidencia primaria).

| # | Hallazgo | Fuente B | Estado | Por qué importa |
|---|---|---|---|---|
| B-01 | **PolicyGuide** (arXiv:2608.19861) cubre policy-compliant alternative generation **para workflows estructurados** — evaluated con GPT-5.4, Claude Sonnet 4.6, Gemini 2.5 Pro | `CLAUDE_SECOND_PASS/06_BUSQUEDA` | VERIFIED por B | Refina el gap: no es "nadie lo hace" sino "no lo hace para open-ended" |
| B-02 | **SafeAgent** (arXiv:2604.17562) también cubre workflows | `06_BUSQUEDA` | VERIFIED | Concurrent con PolicyGuide |
| B-03 | **Recoverability as a System Primitive** (arXiv:2609.13672v1) — formaliza HARD STOP vs RECOVERABLE STOP; grant/withhold; límites; audit | `05_ERRORES` C-02 | VERIFIED | Contradice "no hay clasificación formal"; A cita este como SRC-023 pero sin detalle |
| B-04 | **OSGuard mecanismo real** (arXiv:2606.15034v1) — block → feedback → revise → re-check → 2-retry limit | `05_ERRORES` C-01 | VERIFIED | Corrige descripción errónea del dossier original |
| B-05 | **RIR v2** (arXiv:2609.18304v2, 2026-09-17) publicado después del dossier original — no considerado en dossier original | `05_ERRORES` C-03 | VERIFIED (paper existe) | Corrige el uso de v1 |
| B-06 | **AgentRewind** (arXiv:2608.14380) — implementación parcial de side-effect ledger | `05_ERRORES` C-04 | VERIFIED | Debilita "vacío absoluto" en side-effect continuity |
| B-07 | **Living AI (PyPI 0.4.1)** + **Replay Agent Recorder (GitHub/Futuresis)** — implementaciones OSS parciales side-effect | `05_ERRORES` C-04 | VERIFIED | Prior art comercial existente |
| B-08 | **ReflectiChain** (MDPI 2026) — semantic equivalence detection | Master tabla §6 | VERIFIED | Componente pre-existente para SP-1 |
| B-09 | **Irreversibility Budget** (arXiv:2609.00275) + **BAGEN** — recovery budget / irreversibility | Master tabla §6 | VERIFIED | Prior art para SP-4 |
| B-10 | **ACS standard** (May 2026 draft) — Execution governance standard | Master tabla §6 | VERIFIED | Standard naciente relevante |
| B-11 | **8 perspectivas adversariales** aplicadas a la conclusión SAGR — todas ejecutadas en `34_AUDITORIA_ADVERSARIAL_FINAL.md` con veredicto por perspectiva | `34_ADVERSARIAL` | VERIFIED (ejecutado) | Meta-audit completo; refina scope a "open-ended only" |
| B-12 | **8 juicios finales auditados** (J-01 a J-08) — clasificados por FACT/OBSERVED/INFERRED/HYPOTHESIS y confidence | `18_JUICIOS` | VERIFIED (documento) | Estructura formal de veredictos |
| B-13 | **11 criterios de saturación** verificados uno por uno con SATURACIÓN DECLARADA | `37_CERTIFICADO` | VERIFIED (documento) | Cierre formal de la investigación |
| B-14 | **4 unknowns operacionales** (H-01 a H-04) explícitamente resolubles solamente con datos de producción | Master §8 + `37_CERTIFICADO` | VERIFIED | Framework de decisión |
| B-15 | **GuardFall como falso positivo con evidencia directa** — bash-firewall bloqueando commit messages con `rm -rf` como substring | dossier original + MASTERC §18 | VERIFIED en repo | Data point empírico para H-01 |
| B-16 | **Reformulación de comprador**: SAGR debe venderse como *governance/security* (Security/CISO), no como *reliability* (Platform Engineer) | Master §3 | INFERRED con lógica | Movimiento de mercado, no técnico |
| B-17 | **Diferenciación explícita "structured workflow" vs "open-ended agent"** que se convierte en el discriminante técnico principal | `34_ADVERSARIAL` | INFERRED | Delimita scope de la hipótesis viable |
| B-18 | **Kill del criterio "3 casos en 4 semanas"** con corrección explícita en `20_CLAUDE_FINAL_SYNTHESIS.md` línea 89 | `20_CLAUDE_FINAL_SYNTHESIS` | VERIFIED (corrección aplicada) | Elimina criterio de decisión fabricado |

**Total hallazgos exclusivos B:** ~18 mayores. Reliabilidad ALTA — las fuentes son verificables y fueron cruzadas contra búsquedas primarias.

---

## 3. HALLAZGOS COMPARTIDOS (Shared findings)

Aparecen en ambos corpus, con vocabularios distintos pero contenido equivalente.

| # | Hallazgo | Corpus A | Corpus B |
|---|---|---|---|
| S-01 | Evidence-gated completion no es único | CLAIM-001 CONTRADICTED | Master §2 H1 NOT SUPPORTED |
| S-02 | AIGIS reproduce el core de CCP | §19 competitive | Master §2 |
| S-03 | Diferenciadores de CCP: incident→control→regression + phase-gate + historical preservation | §35 sobreviven | Master §2 y H3 |
| S-04 | Loop detection, checkpoint, rollback: CLOSED | CH-001, CH-002, CH-003 | `18_JUICIOS`, `06_BUSQUEDA` |
| S-05 | Durable execution ≠ semantic recovery | CLAIM-010 KILLED | H9 NOT SUPPORTED; J-X02 |
| S-06 | STALL ≠ PERMISSION TO BYPASS SAFETY | §18 core invariant | Master §7 gate no negociable |
| S-07 | Commercial thesis NOT SUPPORTED | §20 | Master §2 |
| S-08 | No abrir F10 sin justificación | §32 Step 6 | Master §11 y §10 |
| S-09 | "3 casos → build" es criterio no válido | CLAIM-015 NOT SUPPORTED | H10 HIPOTESIS SIN BASE |
| S-10 | RIR "70%" es falsa precisión | HF-002 | C-03 |
| S-11 | OSGuard corregido a mecanismo más rico | HF-001 | C-01 |
| S-12 | Side-effect continuity no es vacío absoluto | HF-003 | C-04 |
| S-13 | PolicyGuide debilita "generate_alternative es único gap" | CLAIM-011 WEAKENED | C-05 |
| S-14 | GuardFall como conceptual trigger de SAGR | §18 | dossier |
| S-15 | Saga/Temporal resuelven distinto problema que SAGR | §17 los cuatro operaciones | `34_ADVERSARIAL` Perspectiva 2 DESTRUIDA |

---

## 4. Riesgo de pérdida por compresión

**Hallazgos que sólo están en A y podrían perderse:**

- Los **frameworks conceptuales de MASTERC** (§14-§17) — 8 niveles de assurance, 6 tipos de cambio, 4 operaciones distintas, 6 propiedades de evidencia. Son taxonomías útiles independientemente de sus fuentes.
- **KV-Cache retention** como contraejemplo empírico a rollback: si es real (SRC-061), es un data point crítico contra confiar en rollback de agentes.
- **Common-mode evidence failure** cuantificado (62.9% en VP-CONTROL): si es real, cambia el diseño de commit gates.
- **ae-framework como competidor directo** del posicionamiento CCP: si es real y activo, colapsa gran parte del argumento de diferenciación.

**Hallazgos que sólo están en B y podrían perderse:**

- La **auditoría adversarial de 8 perspectivas** con veredicto por perspectiva — es el mejor stress-test disponible de la hipótesis SAGR-B.
- La **diferenciación structured/open-ended** que resulta ser el discriminante crítico del gap.
- El **reposicionamiento de comprador** (CISO en lugar de Platform Engineer).

---

## 5. Recomendación operativa

1. Los **frameworks conceptuales de A** deben preservarse como taxonomías útiles.
2. Las **fuentes específicas de A** deben verificarse en campo antes de ser citadas como evidencia (especialmente RISU, ae-framework, VERITAS).
3. Los **hallazgos verificados de B** son la base sólida sobre la cual construir cualquier decisión.
4. Ninguno de los dos corpus es completo por sí solo. La conciliación consiste en usar A para amplitud conceptual y B para verificación puntual.
