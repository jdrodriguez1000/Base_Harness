# Tasks

> Lista viva de tareas del proyecto. Fuente única de trabajo pendiente y en curso.
> Estados: `[ ]` pendiente · `[~]` en progreso · `[x]` completada · `[!]` bloqueada.

## Índice

> Mantener sincronizado: al crear/mover/cerrar una tarea, actualizar su fila aquí.
> Buscar por ID (`T-XXX`) para localizar la tarea sin leer todo el archivo.

| ID | Tarea | Estado | Prioridad |
|---|---|---|---|
| T-001 | Definir la estructura completa del harness base | completada | alta |
| T-002 | Mantener sincronizadas las dos copias de `.claude/` (raíz vs `template/.claude/`) | pendiente | media |
| T-003 | Rellenar `905_context/business.md` con los datos reales de la empresa | pendiente | alta |
| T-004 | Evaluar hooks SessionStart/Stop para forzar técnicamente los protocolos de inicio/cierre | pendiente | media |
| T-005 | Decidir si `business.md` se versiona (posible información sensible) o va a `.gitignore` | pendiente | media |
| T-006 | Añadir IDs `P-XXX` a `progress.md` para uniformar la búsqueda por ID | pendiente | baja |

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

- [ ] T-002 — Mantener sincronizadas las dos copias de `.claude/` (raíz = fuente de verdad; `template/.claude/` = reflejo). Considerar un script que automatice la re-copia.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-003 — Rellenar `905_context/business.md` con los datos reales de la empresa.
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [ ] T-004 — Evaluar hooks SessionStart/Stop para forzar técnicamente los protocolos de inicio/cierre.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-005 — Decidir si `business.md` se versiona (posible información sensible) → `.gitignore`.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-006 — Considerar añadir IDs `P-XXX` a `progress.md` para uniformar la búsqueda por ID.
      Prioridad: baja · Responsable: — · Ref: [[progress]]

## En progreso

## Completadas

- [x] T-001 — Definir la estructura completa del harness base.
      Prioridad: alta · Responsable: — · Ref: [[progress]]

## Bloqueadas
