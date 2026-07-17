# Tasks

> Lista viva de tareas del proyecto. Fuente única de trabajo pendiente y en curso.
> Estados: `[ ]` pendiente · `[~]` en progreso · `[x]` completada · `[!]` bloqueada.

## Índice

> Mantener sincronizado: al crear/mover/cerrar una tarea, actualizar su fila aquí.
> Buscar por ID (`T-XXX`) para localizar la tarea sin leer todo el archivo.

| ID | Tarea | Estado | Prioridad |
|---|---|---|---|
| T-001 | Definir la estructura completa del harness base | completada | alta |
| T-002 | Mantener sincronizadas las dos copias de `.claude/` (raíz vs `template/.claude/`) | completada (absorbida por `register-harness`, ver D-004) | media |
| T-003 | Rellenar `905_context/business.md` con los datos reales de la empresa | pendiente | alta |
| T-004 | Evaluar hooks SessionStart/Stop para forzar técnicamente los protocolos de inicio/cierre | pendiente | media |
| T-005 | Decidir si `business.md` se versiona (posible información sensible) o va a `.gitignore` | pendiente | media |
| T-006 | Añadir IDs `P-XXX` a `progress.md` para uniformar la búsqueda por ID | pendiente | baja |
| T-007 | Crear `.gitignore` agnóstico y hacer el primer `git push` a GitHub | completada | alta |
| T-008 | **[PRÓXIMA]** Fase de PROVISIÓN de `register-harness` para opencode (crear `.opencode/skills` copiando `SKILL.md`, traducir agentes a formato opencode, asegurar `AGENTS.md` en raíz) | pendiente | alta |
| T-009 | Espejar el procedimiento de `register-harness` dentro de `AGENTS.md` (resolver la bootstrap-paradoja para poder ejecutarlo desde dentro de opencode/codex) | pendiente | media |
| T-010 | Extender `register-harness` a Codex y Gemini | pendiente | media |
| T-011 | Verificar mecanismos de Gemini (`GEMINI.md`, comandos) con documentación oficial | pendiente | media |

## Convención de ID

- Cada tarea tiene un ID estable: `T-001`, `T-002`, ...
- No reutilizar IDs de tareas eliminadas.
- Las subtareas se anidan bajo su tarea padre.

## Formato

```
- [ ] T-001 — <descripción de la tarea>
      Prioridad: alta | media | baja · Responsable: <agente/persona> · Ref: [[progress]]
```

---

## Backlog

- [ ] T-008 — **[PRÓXIMA TAREA]** Fase de PROVISIÓN de `register-harness` para opencode: crear `.opencode/skills/` copiando `SKILL.md`, traducir agentes a formato opencode (`.opencode/agents/*.md`), asegurar `AGENTS.md` en raíz. Confirmado con prueba real en `proyecto_prueba` (ver [[progress]] 2026-07-17).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-004
- [ ] T-003 — Rellenar `905_context/business.md` con los datos reales de la empresa.
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [ ] T-004 — Evaluar hooks SessionStart/Stop para forzar técnicamente los protocolos de inicio/cierre.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-005 — Decidir si `business.md` se versiona (posible información sensible) → `.gitignore`.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-006 — Considerar añadir IDs `P-XXX` a `progress.md` para uniformar la búsqueda por ID.
      Prioridad: baja · Responsable: — · Ref: [[progress]]
- [ ] T-009 — Espejar el procedimiento de `register-harness` dentro de `AGENTS.md` para resolver la bootstrap-paradoja (poder ejecutarlo desde dentro de opencode/codex, sin depender de `.claude/`).
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-004
- [ ] T-010 — Extender `register-harness` a Codex y Gemini.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-004
- [ ] T-011 — Verificar mecanismos de Gemini (`GEMINI.md`, comandos) con documentación oficial (ctx7) antes de extender `register-harness`.
      Prioridad: media · Responsable: — · Ref: [[progress]]

## En progreso

## Completadas

- [x] T-001 — Definir la estructura completa del harness base.
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [x] T-002 — Mantener sincronizadas las dos copias de `.claude/` (raíz vs `template/.claude/`). Absorbida/reemplazada por el skill `register-harness`, que la convierte en un procedimiento auditable y (a futuro) automatizable en vez de sincronización manual.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-004
- [x] T-007 — Crear `.gitignore` agnóstico (SO, editores, secretos, logs, deps) y hacer el primer `git push` a `https://github.com/jdrodriguez1000/Base_Harness.git` (rama `main`).
      Prioridad: alta · Responsable: — · Ref: [[progress]]

## Bloqueadas
