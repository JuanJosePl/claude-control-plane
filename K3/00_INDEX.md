# K3 — ROOT / ARCHITECTURAL DISCOVERY ENGINE

> Tercera capa de reconstrucción de CCP.
> Fecha: 2026-09-24.
> Modo: investigación. Ningún runtime, hook, policy, registry ni decisión del Owner se
> modifica. No genera M009 ni abre movimientos.

---

## Executores y provenance

- **`00_INDEX.md` y `01_RESEARCH_BASELINE.md`** — Kimi K3 partial execution (2026-09-24 AM).
- **`02_INDEPENDENT_RECONSTRUCTION.md`..`13_MASTER_OWNER_DECISION_SYSTEM.md` +
  `RESEARCH_LEDGER.md`** — Claude Code K3 execution (2026-09-24 PM).
- Este `00_INDEX.md` fue actualizado por Claude Code al cerrar la corrida completa;
  el original de Kimi describe el plan, éste describe el corpus real producido.

La reconciliación entre Kimi K3 partial y Claude Code K3 se documenta en
`01_RESEARCH_BASELINE.md §2` (verificación de K3-D1 y K3-D4) y en la baseline
actualizada de `RESEARCH_LEDGER.md`.

---

## Qué es K3

K3 ataca el corpus completo de CCP — Kimi K2.7 (Root Analysis 00–10), el Audit Gate 2.0
de Claude (`docs/00_SYSTEM/ROOT_ANALYSIS/11_KIMI_ROOT_ANALYSIS_AUDIT.md`), la K3 partial
de Kimi (`K3/01_RESEARCH_BASELINE.md`) y las fuentes primarias del repositorio — para
determinar qué estructura mínima explica la realidad observada, con qué supuestos, qué
alternativas arquitectónicas viven, y qué decisiones del Owner son realmente necesarias.

El input contract se hereda del Audit §32 con las verificaciones adicionales del
baseline K3. Lo REFUTED se trata como REFUTED; lo UNKNOWN como UNKNOWN.
K3 no eleva HYPOTHESIS a VERIFIED.

## Corpus real producido

| # | Documento | Función | Ejecutor |
|---|---|---|---|
| 00 | `00_INDEX.md` | Este archivo. Mapa de lectura + ledger resumen. | Kimi + Claude Code |
| 01 | `01_RESEARCH_BASELINE.md` | Herencia, U-01/U-02 recheck, línea base verificada. | Kimi |
| 02 | `02_INDEPENDENT_RECONSTRUCTION.md` | CCP desde fuentes primarias, sin nomenclatura histórica. | Claude Code |
| 03 | `03_STRUCTURAL_DISCOVERY.md` | Ataque a CAP-1..CAP-5; K3-D-* discoveries. | Claude Code |
| 04 | `04_LATENT_STRUCTURES.md` | Variables latentes, estados ocultos, autoridades no nombradas. | Claude Code |
| 05 | `05_CAUSAL_MODEL.md` | Cadenas causales, intervention engine, countermodels. | Claude Code |
| 06 | `06_ARCHITECTURAL_SPACE.md` | 10 ejes; 7 puntos viables en E1×E2; regiones no exploradas. | Claude Code |
| 07 | `07_SCALING_AND_PROJECTION.md` | Proyecciones agentes/policies/proyectos/sesiones; 6 phase transitions. | Claude Code |
| 08 | `08_UNKNOWN_AND_FALSIFICATION.md` | 11 UNKNOWNs; 12 hipótesis K3 en formato falsificable. | Claude Code |
| 09 | `09_ALTERNATIVE_ARCHITECTURES.md` | 5 arquitecturas A/B/C/D/E + 6 combinaciones. | Claude Code |
| 10 | `10_ROOT_CAPABILITY_ANALYSIS.md` | K3 basis: 8 elementos asimétricos + 10 operaciones. | Claude Code |
| 11 | `11_ROOT_DECISION_ANALYSIS.md` | 13 decisiones abiertas reales; dependency graph; sequencing. | Claude Code |
| 12 | `12_RESEARCH_SYNTHESIS.md` | Síntesis; 24 K3-D discoveries; 7 WOW findings; executive output. | Claude Code |
| 13 | `13_MASTER_OWNER_DECISION_SYSTEM.md` | Sistema estructurado de decisiones para el Owner. | Claude Code |
| — | `RESEARCH_LEDGER.md` | Ledger de 25 preguntas, provenance por hallazgo, falsifiers. | Claude Code |

---

## Veredicto de K3 (ejecutivo)

### Sobrevive del análisis Kimi/Claude

- Cronología F1–F9, ARCH-001..004, F9-D01..D05.
- Duplicación policy/enforcement como fenómeno real (aunque reformulado como GAP-1).
- Recurrencia de verificación independiente como patrón estructural (bifurcada en CAP-2s/CAP-2m).
- Provenance en git+registries (CAP-3 activa, con brechas cerradas por convención).
- INC-001 como único ciclo learning-loop completo.
- Reviewer humano como árbitro dominante.
- Breakpoint operativo 2026-09-20.

### Sobrevive con reformulación

- **R1..R5 → decisiones sobre capacidades**, pero con basis K3 asimétrica (8 elementos).
- **Missing Piece → GAP-1**; la única operación conceptual ausente en runtime es DERIVE.
- **Invariantes** = 4 técnicos + 4 políticas humanas (audit) → K3 confirma con
  distinción adicional autorización/verificación.
- **Convergencia parcial** → convergencia operativa + divergencia documental (framing
  más honesto).

### No sobrevive

- Conteo STALL "3 eventos" → 18 líneas actuales, drift creciente.
- "18 decisiones → 5 root decisions" como reducción numérica.
- "H-01 = 0 en campo" → el log mide harness (14/18 fixture replays), no campo.
- "CAP-1..CAP-5" como lista homogénea (K3-D-BASIS-CAT).
- "Trust boundaries anidados" como framing dominante (K3-D-STAR).
- "Enforceable traceability" como root capability (etiqueta compuesta).
- "PAC como Missing Piece" (PAC es implementación de DERIVE en dominio policy).

### Descubrimientos K3 principales

Ver `12 §5` para las 24 K3-D discoveries. Highlights:

1. **K3-D-SCHEMA**: `had_alternative` hardcoded a null en `stall-record.sh:46`.
   READY-03 tiene precondición D-INSTR no declarada.
2. **K3-D-PARTIAL**: la duplicación es entre representaciones parciales; llenar la
   canónica es precondición para cualquier motor.
3. **K3-D-STAR + K3-D-OWNER-DEFAULT**: topología estrella con humano como sink; la
   política implícita de defaults es "todo lo no delegado va al humano".
4. **K3-D-LIFECYCLE**: STALL events + research artifacts + deferrals son una sola clase
   estructural (entidades sin ciclo de vida).
5. **K3-D-BASIS-CAT**: basis correcta tiene categorías asimétricas (capacidad activa,
   gap, substrate, compensación, política latente).
6. **K3-D-DERIVE-ONLY**: de 10 operaciones conceptuales, sólo DERIVE está ausente en
   runtime.
7. **K3-D-AUTHZ-VS-VERIF**: la mayor carga humana es autorización, no verificación;
   automatizar CAP-2-sintáctica no reduce carga esencial.
8. **K3-D-DECISION-COUNT**: 13 decisiones abiertas reales (no 4).
9. **K3-D-F9D01-BOTTLENECK**: F9-D01=A es gate root del decision graph; bloquea 3
   UNKNOWNs (K3-D-EPIST-COST monotónico).
10. **K3-D-DELEG-ORTOGONAL**: la delegación explícita (Arquitectura E) es capa
    transversal; mejora todas las demás arquitecturas.
11. **K3-D-EXOGENOUS**: la meta-doc creciente es respuesta racional al sustrato; no es
    defecto arquitectónico.
12. **K3-D-DUAL-MODEL**: CCP admite al menos dos descripciones estructurales complementarias
    (K3 arquitecturacentrista + Cm procesocentrista).

---

## Cómo leer

1. **`01`** — línea base heredada + rechecks (Kimi).
2. **`02`** — CCP reconstruido desde cero, sin herencia (Claude Code).
3. **`03`–`10`** — ataque estructural, descubrimientos, alternativas, basis mínima.
4. **`11`** — decision space real (13 decisiones abiertas).
5. **`12`** — síntesis; break-your-master-model; executive output.
6. **`13`** — Master Owner Decision System (el deliverable).
7. **`RESEARCH_LEDGER`** — provenance, falsifiers, next actions.

---

## Regla de lectura

Nada en K3 decide por el Owner. Donde K3 reduce decisiones es porque **demuestra que la
decisión era derivable** (READY-01/02 de DEC-04+05; READY-03 de DEC-08+N), no porque
K3 la resuelva.

Donde K3 amplia decisiones (13 vs. 4) es porque **hace visibles** decisiones latentes
que la topología estrella absorbía por default (K3-D-OWNER-DEFAULT).

---

## Baseline al cierre

- STALL_POLICY_LOG.jsonl: 18 líneas (0 clasificadas).
- Hooks: 10 scripts + lib (509 líneas).
- Docs total: 121 (44 en `00_SYSTEM/`, 75 en `research/`).
- Rules: 4 archivos, 1/4 con placeholders.
- PAC YAML: 24 IDs (23 policies + 1 normalization).
- EV registry: 16 reales + 1 template.
- ARCH: 001..004 activas.
- F9-D01..D05: closed 2026-09-20.
- READY-01..04: pending; expanded to 13 open decisions per K3 (`11`, `13`).

---

## PARAR

K3 es investigación. El siguiente eslabón es el **Owner**, no M009. Ninguna implementación
de las decisiones D-* es autorizada por este corpus.

Este documento no autoriza runtime, hooks, policies, registries, deferral changes, ni
decisiones del Owner.

**FIN.**
