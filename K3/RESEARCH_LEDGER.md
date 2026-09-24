# RESEARCH LEDGER — K3 execution

> Registro de preguntas, hipótesis, hallazgos, falsificadores y next-actions.
> Última actualización: 2026-09-24 (Claude Code execution).

---

## Preguntas de investigación (Q-*)

| ID | Pregunta | Por qué importa | Status | Finding | Falsifier | Next action |
|---|---|---|---|---|---|---|
| Q-01 | ¿La bifurcación CAP-2 (sintáctica/semántica) es real? | Determina viabilidad de delegación LLM | RESOLVED | SUPPORTED, ver `03 §3` | encontrar caso semántico reducible a regex | ninguna |
| Q-02 | ¿La topología es estrella o anidada? | Cambia proyecciones de escala | RESOLVED | Estrella; `03 §9`, `04 §14` | encontrar decisor no-humano en zonas grises | ninguna |
| Q-03 | ¿Existe categoría "research artifact" faltante? | Gobernanza a escala | RESOLVED | Sí + STALL + deferrals = 1 clase (K3-D-LIFECYCLE) | encontrar lifecycle formal en cualquiera de las 3 | Owner (DEC-03) |
| Q-04 | ¿`had_alternative` es schema-dead? | Precondición de READY-03 empírica | VERIFIED | `stall-record.sh:46` literal | encontrar caller que pase valor real | Owner (DEC-08) |
| Q-05 | ¿Cuánta duplicación real hay policy vs enforcement? | Framing GAP-1 | RESOLVED | Ambas capas parciales; K3-D-PARTIAL | encontrar capa completa | Owner (DEC-04) |
| Q-06 | ¿CCP tiene "meta-doc" excesiva o proporcional? | K3-D-EXOGENOUS | HYPOTHESIS | Meta-doc es respuesta al substrate | mostrar que un cambio de topología (no substrate) la elimina | Fuera de scope |
| Q-07 | ¿Cuáles son las autoridades no nombradas? | K3-D-OWNER-DEFAULT | RESOLVED | schema, lifecycle, gate-catalog | encontrar dueño formal | Owner (DEC-01/02) |
| Q-08 | ¿Cuántas decisiones abiertas reales hay? | Corrige paquete owner | RESOLVED | 13 (no 4). `11 §3` | encontrar decisión adicional o quitar una | Owner |
| Q-09 | ¿F9-D01 es bottleneck epistemológico? | K3-D-F9D01-BOTTLENECK | RESOLVED | Sí, bloquea 3 UNKNOWNs | encontrar path independiente de F9-D01 | Owner (DEC-08) |
| Q-10 | ¿La delegación explícita es capa transversal? | K3-D-DELEG-ORTOGONAL | RESOLVED | Sí; mejora en 3 escenarios | mostrar arquitectura donde delegation es perjudicial | Owner (DEC-02) |
| Q-11 | ¿PROP-4 (reversibility) es CCP capability o substrate? | Corrige lista Claude | RESOLVED | Substrate (git); no CCP | encontrar mecanismo CCP-específico | ninguna |
| Q-12 | ¿POL-LATENT-5 es activa o latente? | Corrige lista Claude | RESOLVED | Latente (ran 1×, INC-001) | encontrar >1 ciclo en corpus | ninguna |
| Q-13 | ¿Existen 10 operaciones conceptuales o menos? | Instruction set analysis | RESOLVED | 10; sólo DERIVE ausente | reducir sin perder distinción | ninguna |
| Q-14 | ¿CAP-AUTHZ debe estar en la basis? | Sufficiency test | RESOLVED | Sí; K3-D-AUTHZ-CAT | mostrar autorización reducible a verification | ninguna |
| Q-15 | ¿Es la basis mínima realmente mínima? | §100 compression | RESOLVED | Sí, 8 asimétricos irreducibles | encontrar compresión sin pérdida | ninguna |
| Q-16 | ¿Correlated failure en dual-LLM verifier? | U-09 | UNRESOLVED | HYPOTHESIS: prior alta | prototipo experimental | Owner (DEC-07 exploración) |
| Q-17 | ¿H-01 tiene materialidad real? | U-01 | UNRESOLVED | inobservable sin D-INSTR | K3-D-SCHEMA cerrado + N sesiones | Owner (DEC-08) |
| Q-18 | ¿CAP-2-semántica es mecanizable? | U-05 | UNRESOLVED | HYPOTHESIS: parcial | experimento controlado | Owner |
| Q-19 | ¿PAC produce FP semánticos > PAC-EF-02? | U-04, U-08 | UNRESOLVED | HYPOTHESIS: alta | deploy en producción | Owner (DEC-05) |
| Q-20 | ¿Native runtime instrumentable sin F9-D01 revisit? | U-03 | UNRESOLVED | HYPOTHESIS: shadow runtime posible | prototipo shadow | Owner (DEC-13) |
| Q-21 | ¿Cuáles types of change están sin gate? | U-11 | UNRESOLVED | Enumeración pendiente | comparar commit log vs gates | K3-post enumeración |
| Q-22 | ¿Cuál es el reuse rate real de meta-doc? | U-07 | UNRESOLVED (weak) | proxy: K3 se completó sin abrir 61A..G, indicativo | instrumentar Read en handoffs | K3-post |
| Q-23 | ¿Governance decay tasa observable? | K3-D-EPIST-COST | UNRESOLVED | monotónico, tasa desconocida | contar deferrals por trimestre | Owner (DEC-11) |
| Q-24 | ¿Convergencia estructural en F9+? | Kimi claim | RESOLVED | Sólo operativa; K3 rechaza estructural | encontrar reducción de componentes real | ninguna |
| Q-25 | ¿Pipeline→star phase change es sharp? | K3-D-PHASE-CHANGE | PARTIAL | Es DAG paralelo, no estrella pura | ninguna | none |

25 preguntas. **15 RESOLVED, 8 UNRESOLVED (5 blocked by owner decisions), 2 PARTIAL/HYPOTHESIS**.

---

## Hipótesis K3 (K3-D-*)

Ver `12 §5` para el catálogo completo con confidence.

- 8 VERIFIED
- 13 SUPPORTED
- 2 HYPOTHESIS (K3-D-EXOGENOUS, K3-D-SUBSTRATE-FRACTION)
- 1 PARTIAL (K3-D-PHASE-CHANGE)

---

## UNKNOWNs (U-*)

Ver `08 §1` y `08 §5` para clasificación completa.

- **U-01, U-02, U-03, U-04**: blocked by F9-D01/D02 decisions.
- **U-05, U-09**: require experiment (LLM adversarial + adversarial batteries).
- **U-06, U-11**: cheap-to-resolve (enumeration).
- **U-07**: proxy resolved (K3 completed without reading 61A..G).
- **U-08**: post-deploy of D-CANONICAL=YAML+motor.
- **U-10**: requires external comparison; not resolvable with corpus.

---

## Owner decisions map (D-* → next action)

Ver `13` para el sistema completo.

- **DEC-01, DEC-02, DEC-03**: CAN-DEFER; low-cost; ortogonales; transversal benefit.
- **DEC-04, DEC-05**: SHOULD-BEFORE-NEXT; DEC-04 high-lock-in.
- **DEC-07**: CAN-DEFER; requires U-09 experiment.
- **DEC-08**: SHOULD-BEFORE-NEXT; unblocks 3 UNKNOWNs; requires F9-D01 revisit.
- **DEC-10**: CAN-DEFER; trivial.
- **DEC-11**: SHOULD-BEFORE-NEXT; halts governance decay.
- **DEC-12**: CAN-DEFER; contain meta-doc growth.
- **DEC-13**: WAIT-FOR-EXTERNAL.

---

## Provenance por hallazgo

Todo hallazgo K3 tiene provenance a fuente primaria:

| ID | Fuente primaria | Reproducible con |
|---|---|---|
| K3-D1 | `.claude/hooks/lib/stall-record.sh:46` | `grep had_alternative .claude/hooks/lib/stall-record.sh` |
| K3-D4 | `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | `jq -r '.task_id' STALL_POLICY_LOG.jsonl \| sort \| uniq -c` |
| K3-D-STAR | Reconstrucción `02`, análisis `04 §14` | Lectura de hooks + trace |
| K3-D-CAP2 | `03 §3.3` | ejemplos F-FALSE_PASS-01 vs. F8-A |
| K3-D-CAP3 | `docs/00_SYSTEM/STALL_POLICY_LOG.jsonl` | `jq -r '.session_id'` = 18× null |
| K3-D-LIFECYCLE | `03 §10` | 3 fuentes: STALL, docs/research/, deferrals |
| K3-D-SCHEMA | K3-D1 + `11 §5` | `stall-record.sh:46` + trace to READY-03 |
| K3-D-PARTIAL | `.claude/rules/no-go.md` (placeholders) + firewall regex | `grep '{{' .claude/rules/*.md` |
| K3-D-OWNER-DEFAULT | `04 §15` | enumeración de authorities no nombradas |
| K3-D-EXOGENOUS | `04 §9` | HYPOTHESIS: requiere U-10 |
| K3-D-AUTHZ-VS-VERIF | `05 §4.7` | intervention experiment |
| K3-D-PHASE-CHANGE | `05 §6.4` | F1..F8 secuenciales vs. M001..M008 DAG |
| K3-D-EPIST-COST | `08 §2` | 4 UNKNOWNs bloqueados por F9-D01/D02 |
| K3-D-SUBSTRATE-FRACTION | `05 §5.5` CF-5 | HYPOTHESIS |
| K3-D-DELEG-ORTOGONAL | `09 §8` | matriz arquitecturas × escenarios |
| K3-D-BASIS-CAT | `10 §7` | comparación bases |
| K3-D-DERIVE-ONLY | `10 §8` | periodic table |
| K3-D-AUTHZ-CAT | `10 §4.2` + F9-D01..D05 | sufficiency test |
| K3-D-COMP-CAT | `10 §4.3` + SessionStart hooks | sufficiency test |
| K3-D-ABSORPTION | `11 §4` | absorption analysis |
| K3-D-DECISION-COUNT | `11 §3` | inventario |
| K3-D-F9D01-BOTTLENECK | `11 §5` | dependency graph |
| K3-D-CANONICAL-CENTRAL | `11 §11` | lock-in analysis |
| K3-D-DELEG-FIRST | `11 §12` | sequencing recommendation |
| K3-D-DUAL-MODEL | `12 §7.4` | countermodel Cm |

---

## Falsifiers no disparados

Ninguno disparado durante K3. Los principales activos:

- **F-M1**: Eliminar humano sin degradar → falsaría K3-D-STAR.
- **F-M2**: CAP-2-semántica mecanizable a ≥ humano → D2 reduce a "sólo máquina".
- **F-M3**: Cambio de topología (no substrate) elimina meta-doc → K3-D-EXOGENOUS falso.
- **F-M4**: 18 STALL events con clasificación TP consistente → K3-D-SCHEMA parcialmente
  resoluble sin cambio schema.
- **F-M5**: Componente crítico sin trace git/registries → CAP-3 más débil.

---

## Baseline actualizada al fin de K3

- STALL_POLICY_LOG.jsonl: **18 líneas** (drift +2 desde audit; +1 desde Kimi K3 partial).
- Hooks: 10 scripts + 1 lib = 509 líneas.
- PAC yaml: 24 IDs (23 policies + 1 normalization).
- docs total: **121 archivos** Markdown.
- EV: 16 reales + 1 template.
- Rules: 4 archivos; 1/4 con `{{placeholders}}` (no-go.md).
- Nueva EV NOT registered como resultado de K3 (K3 no autoriza runtime change).

---

## STOP condition

K3 declara stop porque:

- Estructuras críticas explicadas o marcadas UNKNOWN con precondición identificada.
- Alternativas relevantes comparadas (5 arquitecturas + combinaciones).
- UNKNOWNs de alto impacto identificados y priorizados.
- Claims críticos clasificados (`08 §4` falsification matrix).
- Modelos históricos atacados (`03 §2..§7`, `12 §3..§4`).
- Nuevas estructuras atacadas (`08 §4` falsification matrix K3).
- Espacio arquitectónico explorado (`06`, `09`).
- Decisiones Owner delimitadas (`13`).
- Residuo inexplicado explícito (U-01..U-11, K3-D-EXOGENOUS, K3-D-SUBSTRATE-FRACTION).
- No queda investigación de alto valor obvia sin cruzar F9-D01 o requerir experimento.
