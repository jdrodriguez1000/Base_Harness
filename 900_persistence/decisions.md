# Decisions (ADR ligero)

> Registro de decisiones importantes (Architecture Decision Records simplificados).
> Una decisión aquí es vinculante hasta que otra decisión posterior la reemplace explícitamente.

## Índice

> Mantener sincronizado: al registrar o cambiar el estado de una decisión, actualizar su fila aquí.
> Buscar por ID (`D-XXX`) para localizar la decisión sin leer todo el archivo.

| ID | Decisión | Estado | Fecha |
|---|---|---|---|
| D-001 | Adoptar una capa de persistencia en `_persistence/` | aceptada | 2026-07-17 |
| D-002 | Separar la plantilla (`_persistence/`) de la memoria de este proyecto (`900_persistence/`) | aceptada | 2026-07-17 |
| D-003 | Añadir `_context/project.yaml` como contexto declarativo; su sección `repository` es la fuente de verdad de la URL del repo (Rol B) | aceptada | 2026-07-17 |
| D-004 | `register-harness` como mecanismo oficial de portabilidad/sincronización; fuente única de verdad = `.claude/`; arquitectura de dos niveles | aceptada | 2026-07-17 |
| D-005 | Resolver la bootstrap-paradoja con doble frente: espejo del procedimiento en `AGENTS.md` + autoprovisión de `register-harness` en el destino | aceptada | 2026-07-17 |

## Formato

```
### D-001 — <título de la decisión>
- **Estado:** propuesta | aceptada | reemplazada por D-XXX
- **Fecha:** YYYY-MM-DD
- **Contexto:** qué situación obliga a decidir.
- **Decisión:** qué se decidió.
- **Alternativas consideradas:** opciones descartadas y por qué.
- **Consecuencias:** implicaciones (positivas y negativas).
```

---

## Registro

### D-001 — Adoptar una capa de persistencia en `_persistence/`
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** El harness debe conservar memoria entre sesiones y entre distintos agentes (Claude Code, Codex, opencode, Gemini).
- **Decisión:** Centralizar el estado del proyecto en archivos Markdown dentro de `_persistence/`.
- **Alternativas consideradas:** Base de datos o herramienta externa (descartada por acoplar el harness a infraestructura y romper la portabilidad).
- **Consecuencias:** Persistencia legible por humanos y por cualquier agente, versionable en git; requiere disciplina de actualización manual.

### D-002 — Separar la plantilla (`_persistence/`) de la memoria de este proyecto (`900_persistence/`)
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** En este proyecto el entregable ES la carpeta `_persistence/` (el molde reutilizable). Si registráramos aquí la memoria real de su construcción, contaminaríamos la plantilla que heredarán otros proyectos.
- **Decisión:** La memoria real de ESTE proyecto vive en `900_persistence/`. La carpeta `_persistence/` se conserva como plantilla limpia y genérica. En proyectos futuros no existe `900_persistence/`: esos proyectos usan `_persistence/` directamente como su memoria de trabajo, porque ahí `_persistence/` ya no es un entregable sino una herramienta.
- **Alternativas consideradas:** (a) Usar `_persistence/` también en este proyecto (descartada: mezcla molde y contenido). (b) Duplicar manualmente sin convención (descartada: sin trazabilidad).
- **Consecuencias:** Doble carpeta solo durante la construcción del harness; regla clara de "molde vs. instancia"; requiere mantener `_persistence/` libre de datos específicos de este proyecto.

### D-003 — Añadir `_context/project.yaml` como contexto declarativo; Rol B: fuente de verdad de la URL del repo
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** Los protocolos de inicio/cierre y el Paso 6 (commit & push) del `closing-protocol` necesitaban conocer, sin hardcodear, dónde vive la memoria (`persistence.dir`) y los metadatos del repositorio (URL, rama, política de `auto_push`) para mantener los skills y agentes agnósticos.
- **Decisión:** Crear `_context/project.yaml` (molde en `template/_context/`, real en `905_context/`) como fuente única de verdad declarativa del proyecto. Su sección `repository` (Rol B) resuelve la URL del remoto para el commit & push automático, evitando URLs hardcodeadas en skills/agentes.
- **Alternativas consideradas:** Hardcodear la URL del repo en el skill `closing-protocol` (descartada: rompe la agnosticidad y obliga a editar el skill por proyecto). Detectar el remoto solo por convención de carpeta sin yaml (descartada: no permite declarar `auto_push` ni otros metadatos).
- **Consecuencias:** El Paso 0 de ambos protocolos y el Paso 6 del `closing-protocol` dependen de `project.yaml` cuando existe, con respaldo por convención de nombre si no existe; requiere mantener `project.yaml` actualizado si cambia el remoto o la política de push.

### D-004 — `register-harness` como mecanismo oficial de portabilidad/sincronización
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** El harness debe poder usarse desde distintas herramientas de agente (Claude Code, Codex, opencode, Gemini), cada una con su propio formato y ubicación de skills/agentes. Mantener sincronizadas a mano varias copias (p. ej. `.claude/` vs `template/.claude/`, o futuras `.opencode/`) es frágil y no escala (era el problema que registraba `T-002`). Se verificó con documentación oficial (vía ctx7) que Codex usa `.agents/skills/<n>/SKILL.md` (formato compatible) y `~/.codex/agents/*.toml`, y que opencode usa `.opencode/skills/<n>/SKILL.md` (formato compatible) y `.opencode/agents/*.md` (frontmatter propio); ambos leen `AGENTS.md`.
- **Decisión:** Adoptar `register-harness` como el mecanismo oficial de portabilidad y sincronización del harness. `.claude/` es la **fuente única de verdad**. Arquitectura de dos niveles: **Nivel 1** — `AGENTS.md` con los protocolos escritos en línea (texto plano, universal, no depende del formato de ninguna herramienta); **Nivel 2** — skills y agentes nativos por herramienta (`.claude/`, `.opencode/`, `.agents/`, etc.), generados/auditados a partir de la fuente. Esta decisión absorbe y reemplaza la tarea manual `T-002` de sincronizar copias de `.claude/`.
- **Alternativas consideradas:** (a) Seguir sincronizando copias a mano por convención sin skill dedicado (descartada: no escala a 4 herramientas y sin trazabilidad de qué falta). (b) Un único formato "universal" de skill que todas las herramientas leyeran directamente (descartada: cada herramienta ya tiene su propio formato y ubicación fijados por su propia documentación, no controlable desde este proyecto).
- **Consecuencias:** `register-harness` empieza en modo solo-auditoría (informa qué falta, no escribe); queda pendiente una fase de PROVISIÓN que sí genere los artefactos faltantes para cada herramienta (`T-008`), así como resolver la bootstrap-paradoja de poder invocar el propio `register-harness` desde dentro de una herramienta distinta a Claude Code (`T-009`), y extender el soporte a Codex y Gemini (`T-010`, `T-011`).

### D-005 — Resolver la bootstrap-paradoja con doble frente (espejo en `AGENTS.md` + autoprovisión)
- **Estado:** aceptada
- **Fecha:** 2026-07-17
- **Contexto:** `register-harness` vive como skill de Claude Code. Si un agente está en otra herramienta (p. ej. opencode) y el harness aún no se ha provisionado ahí, no tiene el skill nativo para arrancar la portabilidad ni para re-sincronizar tras editar la fuente. Es la "bootstrap-paradoja": para portar el harness hace falta una pieza que solo existe en la herramienta base.
- **Decisión:** Resolverla con **dos frentes complementarios**. **(b) Espejo en `AGENTS.md`:** añadir la sección *Portabilidad del harness* con el procedimiento resumido (auditar/provisionar, ubicaciones destino, traducción de frontmatter, modelos), que apunta al detalle canónico en `.claude/skills/register-harness/SKILL.md`. Como **todas** las herramientas leen `AGENTS.md`, cualquier agente puede portar el harness aunque parta de cero. **(a) Autoprovisión:** la fase de provisión copia el propio `register-harness` a `.opencode/skills/register-harness/SKILL.md`, dejando a la herramienta destino **autosuficiente** para re-auditar/re-sincronizar sin depender de Claude Code. Fundamento común: la fuente de verdad son **archivos de texto** (`.claude/…`) que cualquier herramienta lee con sus tools de archivo; no es una capacidad exclusiva de Claude.
- **Alternativas consideradas:** (a solo) copiar `register-harness` al destino sin espejo en `AGENTS.md` (descartada: no resuelve el arranque *inicial*, cuando aún no hay nada provisionado). (b solo) espejar únicamente en `AGENTS.md` sin autoprovisión (descartada: obliga a re-sincronizar siempre "a mano" siguiendo el texto, sin skill nativo). Mantener una sola copia del procedimiento (descartada: el bootstrap exige que el arranque no dependa de `.claude/`).
- **Consecuencias:** El procedimiento de portabilidad queda **duplicado** en dos sitios (skill `register-harness` + sección de `AGENTS.md`) que hay que mantener **alineados** al cambiarlo (ver [[lessons]] L-001 sobre riesgo de desincronización). Por ahora resuelto solo para **opencode**; Codex y Gemini replicarán el patrón (`T-010`/`T-011`). La regla operativa: editar la fuente `.claude/` y re-sincronizar (modo re-sync, que sobrescribe); nunca editar el reflejo del destino.

