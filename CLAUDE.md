# Claude Control Plane — Bootstrap

Este repositorio es la infraestructura del control plane, no un proyecto de producto. Antes de
modificar cualquier archivo, carga el contexto operativo en este orden:

1. `docs/MASTER_IMPLEMENTATION_PLAN.md` — contrato y fases de implementación.
2. `PROJECT_STATE.md` — fase, objetivo, bloqueadores y siguiente fase permitida.
3. `ARTIFACT_MANIFEST.md` — entregables y gate de fase.
4. `docs/DESIGN.md` — arquitectura y fuentes de verdad.
5. `docs/CONTROL_PLANE_HANDBOOK.md` — operación, hooks, skills y casos de uso.
6. `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` — evidencia y último resultado verificable.
7. `git status` y `git log --oneline -5` — estado real del working tree.

## Reglas Operativas

- Auditar el runtime real antes de confiar en la documentación.
- Ejecutar `AUDIT → IMPLEMENT → TEST → VERIFY → EVIDENCE → GATE`.
- No iniciar una fase si la anterior no tiene `PASS` explícito.
- No agregar hooks, skills, agentes, registries o infraestructura fuera del Master Plan.
- Si un claim no puede verificarse, marcarlo `UNKNOWN` o `BLOCKED`, nunca asumirlo.
- Mantener `PROJECT_STATE.md` como fuente única del estado operativo.
- Mantener `docs/00_SYSTEM/EVIDENCE_REGISTRY.md` como fuente única de evidencia.
- Ejecutar `evals/maintenance.sh` antes de cerrar cambios del control plane.

## Carga De Contexto De Agentes

`SubagentStart` inyecta los context packs según el rol. No depender del campo `skills:` del
frontmatter del agente como mecanismo de carga runtime.

## Documentacion

- Entrada rapida: `README.md`.
- Manual operativo: `docs/CONTROL_PLANE_HANDBOOK.md`.
- Plan y contrato: `docs/MASTER_IMPLEMENTATION_PLAN.md`.
- Arquitectura: `docs/DESIGN.md`.
