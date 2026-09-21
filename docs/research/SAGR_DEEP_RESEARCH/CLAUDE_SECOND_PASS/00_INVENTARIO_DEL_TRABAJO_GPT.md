# 00 — Inventario forense del trabajo de GPT-5.6 Luna

**Fecha de inventario:** 2026-09-21
**Auditor:** Claude Opus 4.7 (segunda pasada)
**Alcance:** documental. No se modificó runtime, `.claude/`, `evals/`, `install.sh`, `PROJECT_STATE.md` ni registries. El único árbol escrito por esta pasada es `docs/research/SAGR_DEEP_RESEARCH/CLAUDE_SECOND_PASS/`.
**Nota epistémica clave:** esta segunda pasada no tiene acceso web ejecutable en esta sesión (WebFetch/WebSearch aparecen como *deferred tools* del harness). Por tanto, no se re-descargaron los papers, tickets o docs oficiales citados por GPT. Todas las verificaciones aquí son de consistencia interna, cruces con evidencia local del repositorio, y reasoning adversarial.

## 1. Objetivo del inventario

Antes de auditar contenido, se establece qué produjo realmente GPT-5.6 Luna, qué no produjo, y qué fracción del contrato original (§83 y §101–§103 del prompt) queda vacante.

## 2. Contrato de entregables mandado por el prompt original

Según los §83 y §101–§103 del master prompt en `docs/research/SAGR_DEEP_RESEARCH/`, GPT-5.6 Luna debía producir **al menos 30 archivos numerados**:

- `00_INDICE.md`
- `01_RECONSTRUCCION_DEL_PROYECTO.md`
- `02_RECONSTRUCCION_PROFUNDA_DEL_PROBLEMA.md`
- `03_MAPA_DE_INVESTIGACION.md`
- `04_CATALOGO_DE_MECANISMOS.md`
- `05_EQUIVALENCIAS_OCULTAS.md`
- `06_MAPA_DE_SOLUCIONES_EXISTENTES.md`
- `07_MAPA_DE_COMPOSICIONES.md`
- `08_TAXONOMIA_DE_FALLOS.md`
- `09_TAXONOMIA_DE_RECOVERY.md`
- `10_MODELO_DE_ESTADO_Y_TRAYECTORIA.md`
- `11_MODELO_DE_CONTEXTO_MEMORIA_EVIDENCIA.md`
- `12_MODELO_DE_COSTO.md`
- `13_MODELO_DE_SEGURIDAD.md`
- `14_MODELO_DE_RECURSION_Y_GOBERNANZA.md`
- `15_MODELO_DE_MEDICION.md`
- `16_MODELOS_ALTERNATIVOS.md`
- `17_IDEAS_NUEVAS.md`
- `18_IDEAS_DESCARTADAS.md`
- `19_MODELO_UNIFICADO.md`
- `20_ARQUITECTURA_CONCEPTUAL.md`
- `21_FALSIFICACION.md`
- `22_REALIDAD_COMPETITIVA.md`
- `23_REALIDAD_COMERCIAL.md`
- `24_REGISTRO_DE_FUENTES.md`
- `25_REGISTRO_DE_AFIrmACIONES.md`
- `26_REGISTRO_DE_IDEAS.md`
- `27_LIMITACIONES.md`
- `28_PROXIMA_EVIDENCIA.md`
- `29_SINTESIS_FINAL.md`
- `30_EL_NUCLEO_REAL.md`

Y suplementos §101–§103:

- `31_GRAFO_DE_EVIDENCIA.md`
- `32_REGISTRO_DE_BUSQUEDAS.md`
- `33_MATRIZ_DE_COBERTURA_DE_INVESTIGACION.md`
- `34_AUDITORIA_ADVERSARIAL_FINAL.md`
- `35_AUDITORIA_DE_CONSISTENCIA.md`
- `36_DICCIONARIO_DEFINICIONES.md`
- `37_CERTIFICADO_DE_SATURACION.md`

**Total contratado:** 38 archivos con estructura y nombres específicos.

## 3. Archivos realmente producidos por GPT-5.6 Luna

Estado al 2026-09-21 en `docs/research/SAGR_DEEP_RESEARCH/`:

| Archivo | Tamaño | Líneas | Rol declarado |
|---|---|---|---|
| `NOTAS_AGENTES_ACADEMIA.md` | 67 KB | 529 | Evidencia primaria sobre loops, estancamiento, recuperación en agentes LLM |
| `NOTAS_AUDITORIA_DOSSIER.md` | 40 KB | 333 | Auditoría adversarial independiente del dossier SAGR |
| `NOTAS_COMERCIAL_ECONOMIA.md` | 74 KB | 667 | Realidad competitiva, económica y de compra |
| `NOTAS_CONTROL_SEGURIDAD.md` | 73 KB | 562 | Existencia y semántica de `control-induced stall` |
| `NOTAS_RECONSTRUCCION_REPOSITORIO.md` | 47 KB | 750 | Reconstrucción forense del repositorio |
| `NOTAS_SISTEMAS_CLASICOS.md` | 58 KB | 611 | Analogías funcionales en sistemas clásicos |

**Total producido:** 6 archivos, ~360 KB, ~3.450 líneas.

**Ratio de cumplimiento estructural:** 6/38 = **15,8 %** del contrato de nombres/estructura de entregables.

## 4. Mapa de cobertura conceptual GPT vs contrato

Aunque GPT no produjo los archivos numerados, cubrió **temas** que aparecerían en varios de los archivos contratados. La cobertura conceptual es más alta que la estructural.

| Archivo contratado | Cobertura conceptual en NOTAS_* de GPT | Ratio |
|---|---|---|
| 01_RECONSTRUCCION_DEL_PROYECTO | `NOTAS_RECONSTRUCCION_REPOSITORIO.md` completo | ALTA |
| 02_RECONSTRUCCION_PROFUNDA_DEL_PROBLEMA | Distribuido entre `NOTAS_AUDITORIA_DOSSIER` §”Problema fundamental”, `NOTAS_CONTROL_SEGURIDAD` §1 | MEDIA |
| 03_MAPA_DE_INVESTIGACION | Ausente como artefacto explícito; se puede reconstruir desde §”Log de búsquedas y contraste” de `NOTAS_AUDITORIA_DOSSIER` y §”Método” de cada NOTAS | BAJA |
| 04_CATALOGO_DE_MECANISMOS | `NOTAS_SISTEMAS_CLASICOS` §3 (matriz de analogías), `NOTAS_AGENTES_ACADEMIA` §2 (taxonomía) | ALTA |
| 05_EQUIVALENCIAS_OCULTAS | `NOTAS_SISTEMAS_CLASICOS` §3 + §4–§9 | ALTA |
| 06_MAPA_DE_SOLUCIONES_EXISTENTES | `NOTAS_COMERCIAL_ECONOMIA` §2–§6 | ALTA |
| 07_MAPA_DE_COMPOSICIONES | Parcialmente en `NOTAS_AUDITORIA_DOSSIER` §”Duplicación de primitivas” | MEDIA |
| 08_TAXONOMIA_DE_FALLOS | `NOTAS_AGENTES_ACADEMIA` §2, `NOTAS_CONTROL_SEGURIDAD` §2–§3 | ALTA |
| 09_TAXONOMIA_DE_RECOVERY | `NOTAS_AGENTES_ACADEMIA` §3–§5 | MEDIA |
| 10_MODELO_DE_ESTADO_Y_TRAYECTORIA | Ausente como artefacto formal. Fragmentos en `NOTAS_SISTEMAS_CLASICOS` §4 y `NOTAS_CONTROL_SEGURIDAD` §1 (modelo mínimo `x[t+1]=f(...)`) | BAJA |
| 11_MODELO_DE_CONTEXTO_MEMORIA_EVIDENCIA | Ausente como modelo unificado. Insumos en `NOTAS_AGENTES_ACADEMIA` §”Contexto, memoria, rollback” | BAJA |
| 12_MODELO_DE_COSTO | Insumos parciales en `NOTAS_COMERCIAL_ECONOMIA` §”Coste vs restart” | BAJA |
| 13_MODELO_DE_SEGURIDAD | `NOTAS_CONTROL_SEGURIDAD` cubre teoría de control y autorización, pero no compila un `MODELO_DE_SEGURIDAD` unificado para SAGR | MEDIA |
| 14_MODELO_DE_RECURSION_Y_GOBERNANZA | Ausente como artefacto formal | BAJA |
| 15_MODELO_DE_MEDICION | Ausente como artefacto formal | BAJA |
| 16_MODELOS_ALTERNATIVOS | Insumos parciales en `NOTAS_AUDITORIA_DOSSIER` §”Alternativas más simples” | MEDIA |
| 17_IDEAS_NUEVAS | Ausente como registro estructurado | BAJA |
| 18_IDEAS_DESCARTADAS | Distribuido entre §”Contradicciones internas” de `NOTAS_AUDITORIA_DOSSIER` | BAJA |
| 19_MODELO_UNIFICADO | Insumo parcial: §”Problema fundamental” de `NOTAS_AUDITORIA_DOSSIER` (contrato de 4 relaciones) | BAJA |
| 20_ARQUITECTURA_CONCEPTUAL | Ausente | NULA |
| 21_FALSIFICACION | Insumo en `NOTAS_AUDITORIA_DOSSIER` §”Anclaje y sesgos” | MEDIA |
| 22_REALIDAD_COMPETITIVA | `NOTAS_COMERCIAL_ECONOMIA` §2–§6 | ALTA |
| 23_REALIDAD_COMERCIAL | `NOTAS_COMERCIAL_ECONOMIA` §”Comprador/WTP” | ALTA |
| 24_REGISTRO_DE_FUENTES | Fuentes dispersas al final de cada NOTAS. No hay ledger unificado | MEDIA |
| 25_REGISTRO_DE_AFIrmACIONES | Ausente como registro central | NULA |
| 26_REGISTRO_DE_IDEAS | Ausente | NULA |
| 27_LIMITACIONES | Distribuido en cabeceras de cada NOTAS | MEDIA |
| 28_PROXIMA_EVIDENCIA | Parcialmente en `NOTAS_AUDITORIA_DOSSIER` §”Qué evidencia cambiaría la conclusión” | MEDIA |
| 29_SINTESIS_FINAL | Distribuido, no unificado | BAJA |
| 30_EL_NUCLEO_REAL | Ausente. Ninguna NOTAS ejecuta la reformulación “ya no es recovery sino ___” exigida por §84 | NULA |
| 31_GRAFO_DE_EVIDENCIA | Ausente | NULA |
| 32_REGISTRO_DE_BUSQUEDAS | Parcial en `NOTAS_AUDITORIA_DOSSIER` §”Log de búsquedas y contraste” | MEDIA |
| 33_MATRIZ_DE_COBERTURA_DE_INVESTIGACION | Ausente | NULA |
| 34_AUDITORIA_ADVERSARIAL_FINAL | Cumplida sólo respecto al dossier, no respecto a la investigación propia | MEDIA |
| 35_AUDITORIA_DE_CONSISTENCIA | Ausente | NULA |
| 36_DICCIONARIO_DEFINICIONES | Ausente | NULA |
| 37_CERTIFICADO_DE_SATURACION | Ausente | NULA |

**Cobertura conceptual estimada:** ~55–60 % (alta en cinco áreas, nula o baja en once).
**Cobertura estructural:** 15,8 %.

## 5. Hallazgo estructural mayor

GPT-5.6 Luna eligió una organización topical (por dominio) en vez de la organización por artefactos numerados que el prompt exigía. Consecuencias:

1. **Faltan los registros ledger** (fuentes, claims, ideas, búsquedas). Sin ellos, la trazabilidad afirmación → fuente es local a cada NOTAS y no auditable de forma centralizada.
2. **Falta el modelo unificado y la arquitectura conceptual**. La “cereza del pastel” exigida por §84 no fue producida. Existe una síntesis ciega (`NOTAS_AUDITORIA_DOSSIER` §”Problema fundamental”) que se aproxima, pero no cumple los 26 puntos del checklist §84.
3. **Falta el certificado de saturación**. El §121 exige demostrar por qué se cierra la investigación. Ninguna NOTAS ejecuta ese cierre formal.
4. **Falta el diccionario de definiciones estables** (§109). Términos como `estado`, `trayectoria`, `progreso`, `stall`, `HARD STOP`, `RECOVERABLE STOP` aparecen con matices variables entre NOTAS. Ver `35_AUDITORIA_DE_CONSISTENCIA.md` (esta pasada la produce).
5. **Falta la matriz de cobertura de investigación** (§103). Sin ella no se puede argumentar qué dominios fueron efectivamente explorados y cuáles se dieron por cubiertos sin evidencia.

**Interpretación:** GPT-5.6 Luna hizo investigación temáticamente sólida, pero no cumplió el contrato de entregables. El déficit no es superficial: los archivos faltantes son precisamente los que exigen la verificación cruzada, la disciplina de provenance y el veredicto final.

## 6. Calidad interna de los 6 NOTAS producidos

Independientemente del incumplimiento estructural, la calidad interna es alta en varios ejes:

- **Etiquetas de evidencia disciplinadas** (FACT / OBSERVED / DOCUMENTED / CLAIM / INFERRED / UNKNOWN / NOT REEXECUTED / NOT OBSERVED IN THIS REPOSITORY). Se preserva la separación entre observado y afirmado.
- **Regla de ausencia bien aplicada**: se usa “no encontrado en el corpus público primario revisado al 2026-09-21” en lugar de “no existe”.
- **Distinción CONCEPTO / IMPLEMENTACIÓN / PRODUCCIÓN**: presente y aplicada en `NOTAS_SISTEMAS_CLASICOS`.
- **Contradicciones internas del dossier** correctamente detectadas (OSGuard, RIR %, Recoverability, `AI Runtime Infrastructure`).
- **Baseline forense** identifica el desfase entre HEAD declarado (`035a573`) y HEAD real (`74f7d1e`).

## 7. Debilidades internas de los 6 NOTAS

- **Referencias al mismo modelo** (GPT) para adjudicar disputas entre GPT y dossier. No hay un tercer contexto real. El propio `NOTAS_AUDITORIA_DOSSIER` admite “un solo contexto” aunque afirma reducir sesgo por fuentes primarias.
- **URLs y IDs de arXiv** no verificados independientemente en esta pasada. Se aceptan como citados. Cualquier vulnerabilidad en la cita se propaga a los NOTAS y de allí a la conclusión.
- **Ausencia de reproducción**: GPT no ejecutó ninguno de los OSS listados (`loopless`, `livingai`, `Replay Agent Recorder`, AIGIS, ni benchmark de OSGuard). Es una limitación explícitamente declarada, correcta, pero sigue siendo una limitación.
- **Fechas presentadas como pasadas para papers futuros**: varios papers citados llevan fechas de septiembre 2026 y son tratados como “muy recientes”. La coherencia con la fecha de la investigación (2026-09-21) exige que su contenido se lea como reportado por el paper, no como validado empíricamente por terceros. El `NOTAS_AUDITORIA_DOSSIER` §”Precision audit” lo reconoce.
- **Sin registro de búsquedas negativas explícito** por dominio. Se registra parcialmente qué se consultó y qué falló (HTTP 429), pero no una matriz sistemática de dominios × búsquedas × resultado.

## 8. Ficheros y outputs conservados intactos

Ningún archivo NOTAS_* fue movido, renombrado ni editado. Esta segunda pasada preserva el trabajo de GPT por completo. Todo el trabajo nuevo vive en `CLAUDE_SECOND_PASS/`.

## 9. Estado de PROJECT_STATE.md, DECISION_REGISTRY.md y demás registries

Verificado (lectura directa 2026-09-21):

- `PROJECT_STATE.md`: `CURRENT_PHASE: 8`, `PHASE_STATUS: COMPLETE`, `F9 NOT JUSTIFIED`, `F10-F12 UNKNOWN / NOT STARTED`. Sin modificación por esta investigación.
- `LAST_GIT_CHECKPOINT: 9a52875`. HEAD actual `74f7d1e`. Divergencia documentada previamente en el dossier y en la auditoría GPT; esta pasada no la corrige (fuera de alcance).
- `.claude/settings.json` y hooks: no inspeccionados en profundidad en esta pasada (ya lo hizo `NOTAS_RECONSTRUCCION_REPOSITORIO.md`). Se acepta su descripción como CLAIM verificado por GPT.

## 10. Conclusión del inventario

El trabajo de GPT-5.6 Luna es **sustantivo pero incompleto**:

- Cumple ~15 % de la estructura contratada.
- Cubre ~55–60 % del contenido conceptual esperado, con calidad alta donde entrega y ausencia total en 11 áreas.
- Corrige errores del dossier con evidencia primaria citada.
- No produce el veredicto final unificado (30_EL_NUCLEO_REAL, 19_MODELO_UNIFICADO, 20_ARQUITECTURA_CONCEPTUAL).

Esta segunda pasada de Claude tiene por tanto una función doble:
1. **Auditar** el trabajo de GPT (archivos 01–05 y 10–17 de esta pasada).
2. **Completar** las áreas contratadas y no entregadas por GPT (archivos 06–13 y 18–20).

El siguiente paso es `01_AUDITORIA_DE_CLAIMS_GPT.md`.
