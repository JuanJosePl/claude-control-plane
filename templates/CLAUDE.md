<!-- INSTRUCCIONES
CLAUDE.md — Instrucciones del proyecto para Claude Code
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ESTE ARCHIVO SE LEE EN CADA SESIÓN — mantenerlo ≤ 150 líneas.

SECCIONES QUE DEBES COMPLETAR:
  [ ] Proyecto: nombre, qué hace, equipo, horizonte temporal
  [ ] Stack: tecnologías decididas (no opciones)
  [ ] Módulos o componentes principales del sistema
  [ ] Fases de ejecución (adaptar al número de fases de tu proyecto)
  [ ] Decisiones tomadas (las que bloquearían trabajo futuro)
  [ ] Reglas obligatorias (las no negociables de tu dominio)
  [ ] Anti-patrones conocidos (errores previos o del dominio)

SECCIONES FIJAS (NO EDITAR — son parte del control plane):
  ## Control Plane — Comandos operativos
  ## Compact Instructions

TAMAÑO OBJETIVO: ≤ 150 líneas. Si crece más, mover contenido a context packs.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BORRAR ESTE BLOQUE AL INSTALAR
-->

# {{PROJECT_NAME}} — Claude Code Workspace

## Proyecto
**{{PROJECT_NAME}}** — {{descripción en una línea}}
**Equipo:** {{nombres y roles}}
**Horizonte:** {{fecha objetivo · país}}

## Stack decidido
- **Backend:** {{tecnología}}
- **Frontend:** {{tecnología}}
- **DB:** {{tecnología}}
- **Infra:** {{docker/cloud}}

## Componentes principales
{{0. Nombre | 1. Nombre | 2. Nombre}}

## Fases de ejecución
```
FASE 0: {{nombre}} → {{directorio/}}   ◀ ACTUAL
FASE 1: {{nombre}} → {{directorio/}}
...
```

## Decisiones tomadas
- **{{ID}}:** {{decisión en una línea}}

## Reglas obligatorias
1. {{regla #1}}
2. {{regla #2}}

## Anti-patrones conocidos
- {{anti-patrón #1}}

## Control Plane — Comandos operativos
- `/estado` · `/gate` · `/cerrar-fase` · `/checkpoint`
- `/doctor` · `/audit-config` · `/audit-context`
- `/evidence` · `/adr` · `/no-go` · `/recovery E-{N}`

Fuentes de verdad: `PROJECT_STATE.md` · `DECISION_REGISTRY.md` · `ARTIFACT_MANIFEST.md`

## Skills disponibles
- *(agregar las domain skills de tu proyecto aquí)*

## Compact Instructions
Al resumir esta conversación, preservar:
- Decisiones de arquitectura y su justificación
- Estado de cada fase (completa/en progreso/pendiente)
- Módulos implementados y sus contratos de API
- Errores encontrados y sus soluciones
