# Progress

> Registro cronológico del avance del proyecto. La entrada más reciente va arriba.
> Cada agente (Claude, Codex, opencode, Gemini) debe leer este archivo al iniciar una sesión
> y actualizarlo al terminar un bloque de trabajo significativo.

## Índice

> Mantener sincronizado: al añadir/editar una entrada del historial, actualizar también su fila aquí.
> Para saltar a una entrada, buscar su ancla (`#` + título en minúsculas con guiones).

| Fecha | Hito | Estado | Ancla |
|---|---|---|---|
| 2026-07-17 | Inicialización del harness base | completado | `#2026-07-17--inicialización-del-harness-base` |
| 2026-07-17 | Capa de persistencia con índices y separación molde/instancia | completado | `#2026-07-17--capa-de-persistencia-con-índices-y-separación-moldeinstancia` |
| 2026-07-17 | CLAUDE.md de este proyecto | completado | `#2026-07-17--claudemd-de-este-proyecto` |
| 2026-07-17 | Protocolos de inicio/cierre, entregable `template/` autocontenido y contexto declarativo | completado | `#2026-07-17--protocolos-de-iniciocierre-entregable-template-autocontenido-y-contexto-declarativo` |

## Formato de entrada

```
### [YYYY-MM-DD] — <título breve del hito>
- **Estado:** en progreso | completado | bloqueado
- **Resumen:** qué se hizo en esta sesión.
- **Siguiente paso:** qué queda pendiente inmediatamente después.
- **Referencias:** archivos, tareas ([[tasks]]) o decisiones ([[decisions]]) relacionadas.
```

---

## Historial

### [2026-07-17] — Protocolos de inicio/cierre, entregable `template/` autocontenido y contexto declarativo
- **Estado:** completado
- **Resumen:** Se creó el skill `closing-protocol` y el agente `sesion-closer` (green, sonnet) que lo invoca; y el skill `startup-protocol` (solo lectura) con el agente `sesion-starter` (blue, haiku). Se actualizó el `CLAUDE.md` de la raíz para hacer obligatorios ambos protocolos. Se creó `template/` como entregable autocontenido: `AGENTS.md` (fuente única de verdad, agnóstica) con punteros `CLAUDE.md`/`GEMINI.md`, protocolos en línea, `template/_persistence/` (molde movido) y `template/.claude/` (copia de `agents` y `skills` de la raíz). Se auditó la agnosticidad de skills/agentes/template, eliminando referencias hardcodeadas a `900_persistence` (el Paso 0 ahora usa convención de nombre y luego `project.yaml`). Se creó la carpeta de contexto declarativo: `template/_context/` (molde) y `905_context/` (real, con `project.yaml` — repo, rama, `auto_push:false`, `persistence.dir` — y `business.md`). Se cableó el Paso 6 (commit & push) del `closing-protocol` para leer `project.yaml`, y el Paso 0 de ambos protocolos para leer `persistence.dir`. Se hizo `git init`, rama `main`, y se añadió `origin` apuntando a `https://github.com/jdrodriguez1000/Base_Harness.git`.
- **Siguiente paso:** Rellenar `905_context/business.md` con datos reales; mantener sincronizadas las dos copias de `.claude/` (raíz vs `template/.claude/`); confirmar con el usuario el primer `git push`.
- **Referencias:** `.claude/skills/closing-protocol/`, `.claude/skills/startup-protocol/`, `.claude/agents/`, `template/`, `905_context/project.yaml`, [[tasks]] T-002..T-006, [[decisions]] D-003, [[lessons]] L-001

### [2026-07-17] — CLAUDE.md de este proyecto
- **Estado:** completado
- **Resumen:** Se crea `CLAUDE.md` en la raíz, específico de la construcción del harness: describe el proyecto, la distinción molde/instancia (`_persistence/` vs `900_persistence/`), los 6 archivos de memoria, y 6 reglas de trabajo para el agente.
- **Siguiente paso:** Definir el archivo de instrucciones **genérico** para proyectos futuros y su estrategia de sincronización multi-agente (Claude/Codex/opencode/Gemini).
- **Referencias:** `CLAUDE.md`, [[decisions]] D-002

### [2026-07-17] — Capa de persistencia con índices y separación molde/instancia
- **Estado:** completado
- **Resumen:** Se añadió a cada archivo de persistencia una sección `## Índice` para búsqueda sin lectura completa. Se separó el molde (`_persistence/`, limpio) de la memoria real de este proyecto (`900_persistence/`). Registrado en `D-002`.
- **Siguiente paso:** Crear el `CLAUDE.md` de este proyecto.
- **Referencias:** `_persistence/`, `900_persistence/`, [[decisions]] D-002

### [2026-07-17] — Inicialización del harness base
- **Estado:** completado
- **Resumen:** Se crea la capa de persistencia con los seis archivos base (`progress`, `tasks`, `lessons`, `decisions`, `assumptions`, `constrains`).
- **Siguiente paso:** Añadir índices de búsqueda a cada archivo.
- **Referencias:** `_persistence/`
