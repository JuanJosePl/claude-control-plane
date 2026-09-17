<div align="center">

# Claude Control Plane

### Harness de ingenieria con evidencia para Claude Code

<p>
  <strong>Contexto</strong> · <strong>Estado</strong> · <strong>Memoria</strong> · <strong>Control</strong> · <strong>Ejecucion</strong>
</p>

<p>
  <a href="https://github.com/JuanJosePl/claude-control-plane/actions/workflows/control-plane.yml"><img src="https://github.com/JuanJosePl/claude-control-plane/actions/workflows/control-plane.yml/badge.svg" alt="Checks de mantenimiento"></a>
  <a href="https://github.com/JuanJosePl/claude-control-plane"><img src="https://img.shields.io/github/commit-activity/m/JuanJosePl/claude-control-plane" alt="Actividad de commits"></a>
  <a href="https://github.com/JuanJosePl/claude-control-plane/issues"><img src="https://img.shields.io/github/issues/JuanJosePl/claude-control-plane" alt="Issues"></a>
</p>

<p>
  <em>El agente produce artefactos. El control plane decide si esos artefactos estan terminados.</em>
</p>

</div>

## Por Que Existe

Los agentes de codigo son buenos produciendo resultados plausibles. Pero no definen por si solos
cuando algo esta terminado.

Claude Control Plane envuelve Claude Code con contexto por proyecto, estado, permisos, workflows,
gates de evidencia y aprendizaje de regresiones. El objetivo es que el trabajo de ingenieria sea:

- **Observable** — cada fase tiene estado, artefactos y evidencia.
- **Reversible** — checkpoints, referencias de rollback y limites de confianza explicitos.
- **Verificable** — los checks deterministas se ejecutan antes de aceptar claims.
- **Predecible** — el riesgo determina la lane de verificacion necesaria.

No es un segundo agente, una coleccion de prompts ni un plugin manager. Es un harness pequeno
alrededor del agente que ya utilizas.

## Inicio Rapido

```bash
git clone git@github.com:JuanJosePl/claude-control-plane.git
cd claude-control-plane
bash install.sh /ruta/a/tu-proyecto
```

El instalador crea un control plane `.claude/` a nivel de proyecto sin modificar el codigo de
produccion. Valida y reserializa `settings.json`, instala hooks y skills, crea los registros
canonicos de estado y deja disponibles los fixtures de regresion de incidentes.

Despues ejecuta Claude Code en el proyecto destino y escribe:

```text
/doctor
```

Completa los context packs generados antes de delegar trabajo del proyecto.

## Contrato Central

```text
INTENCION HUMANA
       ↓
SPEC / CONTRATO
       ↓
EJECUCION
       ↓
CHECKS DETERMINISTAS
       ↓
REVISION INDEPENDIENTE (si el riesgo lo exige)
       ↓
EVIDENCIA
       ↓
GATE TaskCompleted
       ├── BLOCK → recovery / incidente
       └── PASS  → entregar / aprender
```

La regla dura es simple:

> Una tarea no esta completa porque un agente lo diga. Esta completa cuando pasa el contrato de evidencia.

## Que Incluye

| Capa | Componentes | Proposito |
|---|---|---|
| Contexto | `CLAUDE.md`, rules, seis context packs | Identidad y restricciones permanentes del proyecto |
| Estado | `PROJECT_STATE.md`, registros de decisiones y artefactos | Una fuente operativa de verdad |
| Control | `settings.json`, firewall, secret guard, evidence gate | Enforcement de permisos y bloqueos |
| Ejecucion | Skills de proceso y agentes por rol | Workflows de ingenieria repetibles |
| Verificacion | TDD, code review, doubt y constraints | Checks deterministas e independientes |
| Aprendizaje | Registros de incidentes, controles y regresiones | Convertir fallos en controles permanentes |

## Modelo De Enforcement

| Nivel | Mecanismo | Ejemplo |
|---|---|---|
| L0 | Instruccion | `CLAUDE.md`, rules |
| L1 | Contexto | `.claude/context/*` |
| L2 | Workflow | TDD, code review, doubt, constraints |
| L3 | Permisos | `allow`, `ask`, `deny` en `settings.json` |
| L4 | Validacion determinista | checks shell, schema, fixtures de regresion |
| L5 | Hook bloqueante | `bash-firewall`, `secret-guard`, `TaskCompleted` |
| L6 | Revision independiente | `code-reviewer` con contexto fresco |
| L8 | Gate humano | seguridad, permisos y cambios irreversibles |

El sistema no obliga a cada tarea a pasar por todos los niveles. Los cambios de bajo riesgo se
mantienen ligeros; los de alto riesgo ganan verificacion mas fuerte.

## Evidence Gate

`TaskCompleted` lee el registro canonico ubicado en:

```text
docs/00_SYSTEM/EVIDENCE_REGISTRY.md
```

Para riesgo medio o superior, la evidencia de cierre requiere:

- `task_id` especifico de la tarea;
- estado `VERIFIED`;
- hashes SHA-256 del artefacto y del contrato;
- checks de tests, estaticos y seguridad;
- estado del reviewer;
- excepciones explicitas;
- timestamp y provenance.

La evidencia ausente o incompleta bloquea el cierre con codigo `2`.

## Workflows Disponibles

| Skill | Usala cuando |
|---|---|
| `/test-driven-development` | Cambian comportamientos, features o bugs |
| `/code-review-and-quality` | Un diff necesita revision contra un contrato |
| `/doubt-driven-development` | Un claim o decision necesita verificacion adversarial |
| `/constraint-driven-development` | Una tarea tiene restricciones no negociables o riesgo de gaming |
| `/incident` | Un fallo debe convertirse en control y regresion |
| `/evidence` | Un claim verificado necesita trazabilidad durable |
| `/doctor` | El control plane necesita un health check |
| `/gate` | Una fase necesita un check objetivo de salida |

## Aprendizaje De Incidentes

```text
INCIDENTE
     ↓
CAUSA RAIZ
     ↓
CONTROL AUSENTE
     ↓
REGRESION
     ↓
VERIFICACION
     ↓
REGISTRO DE CONTROLES
```

Todo incidente P0/P1 cerrado debe enlazar:

- `INCIDENT_REGISTRY.md` — sintoma, reproducer y causa raiz;
- `CONTROL_REGISTRY.md` — mecanismo activo de prevencion;
- `REGRESSION_REGISTRY.md` — test que demuestra que el control sigue funcionando;
- `EVIDENCE_REGISTRY.md` — hashes y resultado de verificacion.

## Mantenimiento

Ejecuta la suite determinista de mantenimiento:

```bash
evals/maintenance.sh
```

Comprueba:

- schema de settings y salida del instalador;
- sintaxis de hooks y shell;
- estructura de skills y fixtures de routing;
- comportamiento de regresiones de incidentes;
- snapshot de estado y deteccion de drift;
- provenance y hashes de evidencia;
- referencias de documentacion;
- regression budget.

El mismo check se ejecuta en GitHub Actions mediante
`.github/workflows/control-plane.yml`.

## Mapa Del Repositorio

```text
.
├── .claude/
│   ├── agents/              limites de roles y reviewer independiente
│   ├── context/             context packs del proyecto
│   ├── hooks/               enforcement y ciclo de vida del estado
│   ├── rules/               guidance de politicas permanentes
│   └── skills/              workflows de proceso y verificacion
├── docs/
│   ├── MASTER_IMPLEMENTATION_PLAN.md
│   ├── DESIGN.md
│   └── 00_SYSTEM/           estado, session log y evidencia
├── evals/                   fixtures deterministas y gates de mantenimiento
├── templates/               archivos instalados en proyectos destino
├── install.sh
├── PROJECT_STATE.md
├── ARTIFACT_MANIFEST.md
├── DECISION_REGISTRY.md
├── INCIDENT_REGISTRY.md
├── CONTROL_REGISTRY.md
└── REGRESSION_REGISTRY.md
```

## Estado De Implementacion

El plan inicial esta completo:

| Fase | Resultado | Evidencia |
|---|---|---|
| F1 — Fundacion instalable | PASS | `EV-001` |
| F2 — Evidence Contract | PASS | `EV-002` |
| F3 — Lanes SDLC y review | PASS | `EV-005` |
| F4 — Aprendizaje de incidentes | PASS | `EV-006` |
| F5 — Integridad y provenance | PASS | `EV-007` |
| F6 — Evals y mantenimiento | PASS | `EV-008` |

Contrato completo de implementacion: [`docs/MASTER_IMPLEMENTATION_PLAN.md`](docs/MASTER_IMPLEMENTATION_PLAN.md).

## Limites De Alcance

El plan inicial deliberadamente no construye:

- Agent Teams como dependencia del core;
- fallback entre proveedores;
- un plugin manager;
- un dashboard;
- mutation testing global;
- hooks agregados solo para llenar un catalogo de eventos.

La complejidad es un presupuesto. La nueva infraestructura debe eliminar un riesgo demostrado.

## Contribuir

Antes de proponer un cambio:

1. Lee el Master Implementation Plan.
2. Identifica la fase y el contrato afectados.
3. Ejecuta `evals/maintenance.sh`.
4. Anade evidencia con task ID y provenance.
5. Actualiza el registro correspondiente si cambian estado, controles o regresiones.

## Licencia

Revisa los terminos de licencia y propiedad del repositorio antes de redistribuir el control plane.
