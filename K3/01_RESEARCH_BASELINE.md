# 01 — RESEARCH BASELINE

> Estado heredado + rechecks obligatorios ejecutados. Todo lo que K3 usa como fundamento
> está clasificado aquí CON evidencia primaria, no con la interpretación de Kimi/Claude.

---

## 1. Input contract heredado — reestablecido contra primaria

El Audit Gate 2.0 (Claude Opus 4.7) separa VERIFIED/SUPPORTED/REFORMULATED/REFUTED/UNKNOWN.
K3 rechequea cada categoría contra el repositorio real antes de usarla.

### 1.1 VERIFIED (rechequeado por K3)

| Claim | Fuente primaria verificada | K3 result |
|---|---|---|
| ARCH-001..004 activas | `DECISION_REGISTRY.md` (contenido íntegro leído) | CONFIRMADO |
| F9-D01..D05 cerradas | `F9_OWNER_DECISIONS.md` + `PROJECT_STATE.md` | CONFIRMADO |
| 16 EV reales | `grep -c "^## EV-"` = 17; 1 template + 16 reales | CONFIRMADO |
| READY-01..04 pendientes | `PROJECT_STATE.md` OWNER_GATES | CONFIRMADO |
| Duplicación rules↔regex | Ver §2 abajo — **reformulada por K3** | PARCIAL |
| PAC compila 23+1 | `grep` de `docs/research/pac/ccp_policies.yaml` | VERIFICADO (ajustado) |
| maintenance PASS | Ejecutado; docs/regression_budget/evidence_freshness/firewall_positive/secret_guard_positive = PASS | CONFIRMADO |
| Breakpoint 2026-09-20 | `git log`: `10a60d9 [CONFIG] docs: close f9 owner decision gate` | CONFIRMADO |
| Recurrencia verificación independiente | F-FALSE_PASS-01 / B-1 / PI-1 / CDT-02 / AC-03 en handoffs | CONFIRMADO como patrón documental |

### 1.2 REFUTED (recogido como REFUTED, no heredado)

| Claim REFUTED | Evidencia primaria que lo mata |
|---|---|
| STALL "3 eventos" | `wc -l STALL_POLICY_LOG.jsonl` = **17 líneas** al momento de K3 (audit dijo 16; continúa creciendo). |
| PAC adoption / CDT-02 / H-01-threshold como "18 decisiones visibles" | Son proposal/track/unknown, no paquetes de decisión (audit §8). |
| INV-4/5/6/8 como invariantes técnicas | Son políticas por convención humana (audit §19; K3 confirma en 08 § código: no hay enforcement). |

### 1.3 REFORMULATED (recibido en esa forma)

R1..R5 como decisiones sobre capacidades (CAP-1..CAP-5). K3 acepta la reformulación
como hipótesis de trabajo y la ataca en `03`.

### 1.4 UNKNOWN heredados

U-01 (H-01 materiality), U-02 (clasificación STALL), U-03 (native runtime), U-04 (PAC FP
rate), U-05 (CAP-2 sin humano), U-06 (research artifact lifecycle).

---

## 2. U-01 / U-02 MUST-RECHECK — ejecutado por K3

El prompt exige: antes de usar cualquier conclusión sobre H-01, N o materialidad STALL,
rechequear el corpus activo. K3 lo hizo leyendo el `.jsonl` completo y el hook que emite.

### 2.1 Composición real del log (17 eventos)

| # | source | policy_category | task_id | action_hash | clasificación K3 |
|---|---|---|---|---|---|
| 1 | bash-firewall | 'rm -rf root' | null | única | SYNTHETIC (test fixture) |
| 2–9, 11–14, 16–17 | task-completed | contract_hash_required | **F1-foundation-2026-09-16** (idéntico) | **idéntico hash en todos** | SYNTHETIC / REPLAY |
| 10 | bash-firewall | 'supply chain curl\|bash' | null | única | UNKNOWN (posible test) |
| 15 | bash-firewall | 'DROP DATABASE' | null | única | SYNTHETIC (PAC corpus commit según audit) |

**Recuento:** 14 eventos `contract_hash_required` sobre un task_id fixture con el mismo
action_hash; 3 eventos bash-firewall; 0 con `had_alternative != null`.

> El audit reportó 16 líneas; K3 detecta 17 a la fecha. El log crece entre sesiones
> porque los eventos provienen del harness de evals (`fixtures` y sesiones que corren
> `evals/**`) — no del uso orgánico del sistema.

### 2.2 Hallazgo estructural nuevo (K3-D1): `had_alternative` es un schema-dead field

En `.claude/hooks/lib/stall-record.sh`, la plantilla jq emite literalmente:

```bash
'{... ,had_alternative:null}'
```

El `session_id` se pasa como `""` por los callers y queda `null`. Las dos `notes` vistas
son `"policy predicate matched"` / `"classification is conservative; alternative is not
inferred"` — el propio hook declara que no inferirá alternativas.

**Consecuencia (más fuerte que el audit):** U-02 no es "16 eventos sin clasificar"; es
que **el campo no puede llenarse mecánicamente**. H-01 no es una métrica no observada —
es una métrica *no observable* con la instrumentación actual. Cualquier decisión
READY-03 que presuponga "monitoreo H-01 con trigger N" requiere antes cambiar
`stall-record.sh` (runtime) — lo cual cruza el gate F9-D01. K3 no propone esa
implementación; sólo re-encuadra la dependencia.

### 2.3 Hallazgo estructural nuevo (K3-D4): la tasa base del log es ruido de harness

14/17 = 82% del log son replays del fixture `F1-foundation-2026-09-16` generados cuando
evals o sesiones intentan cerrar la histórica task F1 sin contract_hash. El log no
muestrea comportamiento del agente en uso real; muestrea la actividad de la suite de
evaluación. La asunción "H-01 = 0 en campo" (Kimi 00 §Estado) usa ese log como proxy; el
proxy mide el harness, no el campo. El argumento estructural de READY-03 con N debe
declararse no empírico.

**Estado:** U-01 sigue UNKNOWN; U-2 reclasificado por K3 como `SCHEMA-DEAD`, y READY-03
tiene una dependencia oculta (cambio de instrumentación) que el paquete READY original
no declara. Esto **cambia el orden de las decisiones** — ver `11_ROOT_DECISION_ANALYSIS`.

### 2.4 Falsificador de la reformulación anterior

Si alguien argumenta "basta con clasificar los 17 eventos y resolver U-02", el propio
schema del hook lo refuta: la clasificación ex-post no es en el log. Ningún evento
llevará `had_alternative=true` hasta que el runtime cambie. K3 marca esa dependencia
explícita.

---

## 3. Baseline cuantitativa del corpus

| Métrica | Valor primario | Nota |
|---|---|---|
| Markdown totales | 198 | incl. docs/00_SYSTEM y docs/research |
| docs/00_SYSTEM | 44 ficheros | incluye 61A..61G handoffs + ROOT_ANALYSIS |
| docs/research | 77 ficheros, 2.3 MB | mezcla CCP-research + business research |
| Hooks | 10 scripts + lib/stall-record.sh (461 líneas totales) | `wc -l .claude/hooks/*.sh` |
| Skills | 24 | incl. 6 context-* (memoria inyectada a agentes) |
| INC | 1 real (INC-001) | `grep` contra schema |
| CTRL | 1 real (CTRL-001) | mismo |
| REG | 11 reales | +1 template |
| EV | 16 reales | +1 template |
| STALL | 17 eventos | 14 fixture replay |
| reglas `.claude/rules/` | 4 ficheros | 2 con `{{placeholders}}` (template-state) |

---

## 4. Lo que K3 declara heredado como baseline

- VERIFIED: secciones §1.1 (sin nueva ambigüedad).
- SUPPORTED: verificados en su forma auditada (T8 narrativa, núcleo H3/H4/H10, cadenas
  de compensación, sobrecarga de `bash-firewall.sh`).
- REFORMULATED: aceptado como hipótesis de trabajo; atacado en `03`.
- REFUTED: eliminado de la base.
- UNKNOWN: rechequeados U-01/U-02 (completado en §2); U-03..U-06 siguen abiertos.

**Parada.** Lo siguiente es `02_INDEPENDENT_RECONSTRUCTION.md`.
