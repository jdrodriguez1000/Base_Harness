# Progress

> Registro cronológico del avance del proyecto. La entrada más reciente va arriba.
> Cada agente (Claude, Codex, opencode, Gemini) debe leer este archivo al iniciar una sesión
> y actualizarlo al terminar un bloque de trabajo significativo.

## Índice

> Mantener sincronizado: al añadir/editar una entrada del historial, actualizar también su fila aquí.
> Para saltar a una entrada, buscar su ancla (`#` + título en minúsculas con guiones).

| Fecha | Hito | Estado | Ancla |
|---|---|---|---|
| 2026-07-17 | Provisión opencode (T-008), bootstrap-paradoja (T-009) y README de portabilidad | completado | `#2026-07-17--provisión-opencode-t-008-bootstrap-paradoja-t-009-y-readme-de-portabilidad` |
| 2026-07-17 | Validación real de la auditoría `register-harness` en `proyecto_prueba` | completado | `#2026-07-17--validación-real-de-la-auditoría-register-harness-en-proyecto_prueba` |
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

### [2026-07-17] — Provisión opencode (T-008), bootstrap-paradoja (T-009) y README de portabilidad
- **Estado:** completado
- **Resumen:** Sesión de construcción sobre `register-harness`. **(1) T-008 — fase de PROVISIÓN para opencode:** se extendió el skill de "solo auditar" a "auditar + provisionar" con puerta de confirmación (Paso 3): skills por copia directa, agentes por traducción de frontmatter Claude→opencode (tablas concretas de campos, tools y modelos; `mode: subagent`, se eliminan `name`/`color`, `tools` como mapa booleano con `write:false`/`edit:false` en el de solo lectura). Formato opencode verificado con doc oficial vía ctx7. **(2) Dos ajustes pedidos por el usuario tras prueba real:** (a) el agente `sesion-starter` no se activaba porque su `description` no contenía frases naturales ("iniciemos la sesión") y el agente principal elegía el skill; se enriquecieron las `description` de ambos agentes con frases naturales y se marcaron como punto de entrada preferido (además, en opencode se puede forzar con `@nombre`); (b) el usuario trabaja en opencode por **suscripción** (modelos OpenAI, no API Anthropic), así que los modelos destino pasaron a `sesion-starter → openai/gpt-5.6-luna` y `sesion-closer → openai/gpt-5.6-terra`. **(3) T-009 — bootstrap-paradoja resuelta para opencode** en dos frentes: (b) se añadió a `AGENTS.md` la sección *Portabilidad del harness* (espejo resumido del procedimiento, ya que todas las herramientas leen `AGENTS.md`) que apunta al detalle canónico en `.claude/skills/register-harness/SKILL.md`; (a) la provisión ahora **copia el propio `register-harness`** a `.opencode/skills/` → opencode queda autosuficiente para re-sincronizarse solo. Se documentó la **regla de oro** (editar la fuente `.claude/`, re-sync; nunca editar el reflejo `.opencode/`) y el modo **re-sync** (sobrescribe). **(4)** Se creó `template/README.md`: guía práctica de las dos modalidades (auditar / provisionar + sub-modo re-sync), el flujo para ajustar un agente/skill desde cualquier herramienta, y cuándo cambiar el procedimiento de portabilidad (tocando skill + espejo de `AGENTS.md`). Todo lo tocado en `.claude/` se sincronizó al molde `template/.claude/` (verificado idéntico).
- **Siguiente paso:** Re-provisionar `proyecto_prueba` (re-sync) para recoger los cambios (modelos, descripciones, autosuficiencia). Luego atacar T-010/T-011 (Codex y Gemini): verificar sus mecanismos con doc oficial antes de implementar su mapa de auditoría/provisión.
- **Referencias:** `.claude/skills/register-harness/SKILL.md`, `.claude/agents/`, `template/AGENTS.md`, `template/README.md`, [[tasks]] T-008, T-009, T-012, [[decisions]] D-004, D-005, [[lessons]] L-002

### [2026-07-17] — Validación real de la auditoría `register-harness` en `proyecto_prueba`
- **Estado:** completado
- **Resumen:** No se escribió código nuevo en el harness principal; la sesión fue de validación y planificación. Se validó con éxito el skill `register-harness` (modo auditoría) en una prueba real: el usuario creó una carpeta `proyecto_prueba`, copió el contenido de `template/` (incluyendo `register-harness`) a la raíz, y ejecutó la auditoría desde Claude Code. Resultado correcto: fuente de verdad completa; `AGENTS.md` en la raíz cubierto (baseline); faltan los 4 elementos nativos de opencode (`.opencode/skills/startup-protocol/SKILL.md`, `.opencode/skills/closing-protocol/SKILL.md`, `.opencode/agents/sesion-starter.md`, `.opencode/agents/sesion-closer.md`). El patrón de auditoría queda validado de punta a punta. Se clarificó también el flujo objetivo de provisión: estando en Claude Code se ejecuta `register-harness`, que (una vez construida la fase de provisión) creará la carpeta `.opencode/` con los skills (copia directa) y los agentes (traducidos a formato opencode), y luego el usuario abre opencode y trabaja con todo nativo. Se confirmó que el nombre correcto de la carpeta es `.opencode` (no "open_code") y que hoy `register-harness` SOLO audita, no provisiona.
- **Siguiente paso:** La próxima sesión será construir la fase de PROVISIÓN de `register-harness` para opencode (T-008): crear `.opencode/skills/` copiando los `SKILL.md` y `.opencode/agents/` traduciendo el frontmatter Claude→opencode, con confirmación del usuario antes de escribir.
- **Referencias:** `.claude/skills/register-harness/SKILL.md`, `template/`, [[tasks]] T-008, [[decisions]] D-004

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
