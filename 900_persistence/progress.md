# Progress

> Registro cronológico del avance del proyecto. La entrada más reciente va arriba.
> Cada agente (Claude, Codex, opencode, Gemini) debe leer este archivo al iniciar una sesión
> y actualizarlo al terminar un bloque de trabajo significativo.

## Índice

> Mantener sincronizado: al añadir/editar una entrada del historial, actualizar también su fila aquí.
> Para saltar a una entrada, buscar su ancla (`#` + título en minúsculas con guiones).

| Fecha | Hito | Estado | Ancla |
|---|---|---|---|
| 2026-07-17 | Primer versionado en git y skill `register-harness` para portabilidad multi-agente | completado | `#2026-07-17--primer-versionado-en-git-y-skill-register-harness-para-portabilidad-multi-agente` |
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

### [2026-07-17] — Primer versionado en git y skill `register-harness` para portabilidad multi-agente
- **Estado:** completado
- **Resumen:** Se completó el primer versionado en git: se creó un `.gitignore` agnóstico (SO, editores, secretos, logs, deps) y se hizo el primer `git push` a `https://github.com/jdrodriguez1000/Base_Harness.git` (rama `main`), commits `0a6809e` y `0f0778c`. El usuario cambió `auto_push` de `false` a `true` en `905_context/project.yaml`. Se analizó la portabilidad multi-agente del harness verificando con documentación oficial (vía ctx7) cómo funcionan Codex (skills en `.agents/skills/<n>/SKILL.md`; agentes en `~/.codex/agents/*.toml`, TOML nivel usuario; lee `AGENTS.md`) y opencode (skills en `.opencode/skills/<n>/SKILL.md`; agentes en `.opencode/agents/*.md` con frontmatter propio mode/model/prompt/tools; lee `AGENTS.md`). Se creó el skill `register-harness` (`.claude/skills/register-harness/SKILL.md`) que audita la portabilidad del harness a otra herramienta, comparando la fuente de verdad (`.claude/`) contra lo que la herramienta destino necesita, e informa qué falta (modo actual: solo auditar, no escribir; herramienta soportada por ahora: opencode). Se probó la auditoría: `.claude/` está completa; para opencode faltan 5 elementos (`AGENTS.md` en raíz, 2 skills en `.opencode/skills/`, 2 agentes en `.opencode/agents/`). Hallazgo: este proyecto no tiene `AGENTS.md` en la raíz (solo `CLAUDE.md`); el `AGENTS.md` real vive en `template/`. Se re-sincronizó `template/.claude/` con la fuente, incluyendo el nuevo `register-harness` en el molde. Se registró `D-004` (register-harness como mecanismo oficial de portabilidad/sincronización, arquitectura de dos niveles), que absorbe la antigua `T-002`.
- **Siguiente paso:** El usuario hará una prueba en la próxima sesión, en una carpeta y terminal diferentes: clonar/copiar el harness desde GitHub y probarlo. Por eso todo debe quedar commiteado y empujado antes de cerrar esta sesión. Después: implementar la fase de PROVISIÓN de `register-harness` para opencode (crear `.opencode/skills` y `.opencode/agents`, asegurar `AGENTS.md` en raíz), espejar el procedimiento de `register-harness` dentro de `AGENTS.md` para resolver la bootstrap-paradoja, y extender el soporte a Codex y Gemini.
- **Referencias:** `.gitignore`, `.claude/skills/register-harness/SKILL.md`, `template/.claude/`, `905_context/project.yaml`, [[tasks]] T-002, T-007..T-011, [[decisions]] D-004

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
