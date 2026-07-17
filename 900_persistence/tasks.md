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
| T-008 | Fase de PROVISIÓN de `register-harness` para opencode (crear `.opencode/skills` copiando `SKILL.md`, traducir agentes a formato opencode, asegurar `AGENTS.md` en raíz) | completada | alta |
| T-009 | Espejar el procedimiento de `register-harness` dentro de `AGENTS.md` + autoprovisión (resolver la bootstrap-paradoja para poder ejecutarlo desde dentro de opencode) | completada | media |
| T-010 | Extender `register-harness` a Codex y Gemini | en progreso (Gemini hecho, falta Codex) | media |
| T-011 | Verificar mecanismos de Gemini (`GEMINI.md`, comandos) con documentación oficial | completada | media |
| T-012 | Re-provisionar (`re-sync`) `proyecto_prueba` para recoger los cambios de T-008/T-009 (modelos, descripciones de agentes, autosuficiencia, README) | pendiente | alta |
| T-013 | Provisionar un `.gemini/` real en un proyecto destino para validar de punta a punta la fase de provisión de Gemini | pendiente | media |
| T-014 | Cablear `template/_guideline/principles.md` como comportamiento vinculante en `AGENTS.md`, `CLAUDE.md`, agentes de sesión y `register-harness` | completada | alta |
| T-015 | Crear `template/_guideline/methodology.md` agnóstico (dos ejes, arquetipos, ciclo de vida) + diferenciación Prototipo (deseabilidad/factibilidad) vs MVP | completada | alta |
| T-016 | Segunda ronda de `methodology.md`: elimina prototipado por-incremento, añade contratos/flujos de observabilidad-evaluación (entregables y código), Revisor de código, especialización de flota; simplifica `AGENTS.md` | completada | alta |
| T-017 | Tercera ronda de `methodology.md`: §7.1 estado por incremento (`state.yaml`) — espina única, capas etiquetadas, Single Writer, hermano de seguridad (§5.2) | completada (modelo base; gates/TDD continúan en T-018) | alta |
| T-018 | **[PRÓXIMA]** Modelar en `state.yaml` los gates con sus resoluciones (`gate_paso_5/7/9`: `status`, `fecha`, `resoluciones`) y los casos TDD dentro de Construir; relacionar con la estructura física de `_increments/<id>/` y `_template/` | pendiente | alta |

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

- [ ] T-018 — **[PRÓXIMA TAREA]** Modelar en `state.yaml` (§7.1) los **gates con sus resoluciones** (como en la muestra `temp.md`: `gate_paso_5/7/9` con `status`, `fecha` y lista de `resoluciones`) y el modelado de los **casos TDD** dentro de Construir. Relacionar con la estructura física de carpetas para artefactos por incremento y una posible `_template/` de entregables (pendiente de instanciación desde `D-008`), donde se aterrizará la ruta real de `_increments/<id>/`. Vigilar el gatillo de división en dos archivos ([[assumptions]] A-001).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-008, D-014, D-015, D-016, D-017, [[assumptions]] A-001
- [ ] T-012 — Re-provisionar (`re-sync`) `proyecto_prueba` para recoger los cambios de T-008/T-009: modelos destino (`openai/gpt-5.6-luna` / `-terra`), nuevas `description` de agentes, autosuficiencia (`register-harness` nativo en `.opencode/`), sección de portabilidad en `AGENTS.md` y `README.md`.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-005
- [ ] T-003 — Rellenar `905_context/business.md` con los datos reales de la empresa.
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [ ] T-004 — Evaluar hooks SessionStart/Stop para forzar técnicamente los protocolos de inicio/cierre.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-005 — Decidir si `business.md` se versiona (posible información sensible) → `.gitignore`.
      Prioridad: media · Responsable: — · Ref: [[progress]]
- [ ] T-006 — Considerar añadir IDs `P-XXX` a `progress.md` para uniformar la búsqueda por ID.
      Prioridad: baja · Responsable: — · Ref: [[progress]]
- [ ] T-013 — Provisionar un `.gemini/` real en un proyecto destino para validar de punta a punta la fase de provisión de Gemini (análoga a la validación ya hecha con opencode).
      Prioridad: media · Responsable: — · Ref: [[progress]]

## En progreso

- [~] T-010 — Extender `register-harness` a Codex y Gemini. Gemini completado (Paso 4 del skill, verificado con doc oficial vía ctx7); falta Codex.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-004

## Completadas

- [x] T-001 — Definir la estructura completa del harness base.
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [x] T-002 — Mantener sincronizadas las dos copias de `.claude/` (raíz vs `template/.claude/`). Absorbida/reemplazada por el skill `register-harness`, que la convierte en un procedimiento auditable y (a futuro) automatizable en vez de sincronización manual.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-004
- [x] T-007 — Crear `.gitignore` agnóstico (SO, editores, secretos, logs, deps) y hacer el primer `git push` a `https://github.com/jdrodriguez1000/Base_Harness.git` (rama `main`).
      Prioridad: alta · Responsable: — · Ref: [[progress]]
- [x] T-008 — Fase de PROVISIÓN de `register-harness` para opencode: skills por copia directa, agentes por traducción de frontmatter (tablas de campos/tools/modelos), con puerta de confirmación. Incluye los dos ajustes posteriores: `description` de agentes con frases naturales (activación) y modelos destino `openai/gpt-5.6-luna` / `-terra` (suscripción, no API Anthropic).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-004, [[lessons]] L-002
- [x] T-009 — Resolver la bootstrap-paradoja para opencode: sección *Portabilidad del harness* en `AGENTS.md` (espejo del procedimiento) + autoprovisión de `register-harness` en `.opencode/skills/` (autosuficiencia). Documentada la regla de oro y el modo re-sync.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[decisions]] D-005
- [x] T-011 — Verificar mecanismos de Gemini (skills nativos en `.gemini/skills/<n>/SKILL.md`, agentes en `.gemini/agents/<n>.md`) con documentación oficial (ctx7 + web) antes de extender `register-harness`.
      Prioridad: media · Responsable: — · Ref: [[progress]], [[tasks]] T-010
- [x] T-014 — Cablear `template/_guideline/principles.md` (confirmado agnóstico, P1–P8/E1–E13/NC-1…NC-6) como comportamiento vinculante en `template/AGENTS.md`, `CLAUDE.md`, agentes de sesión (`sesion-starter`/`sesion-closer`, ambas copias) y `register-harness` (fuente única de verdad/baseline).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-007
- [x] T-015 — Crear `template/_guideline/methodology.md` agnóstico (dos tipos de proyecto, dos ejes madurez/incremento, ciclo de vida de 13 pasos, arquetipos de agente) y reescribir §4 (Estadios de madurez) con la distinción Prototipo deseabilidad/factibilidad y la frontera dura Prototipo→MVP.
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-008, D-009
- [x] T-016 — Segunda ronda de `methodology.md`: elimina "Prototipar" como fase por-incremento (ciclo 13→11 pasos + spikes de excepción), añade §5.1 (contrato constructor de entregables), §10.1 (flujo observabilidad), §8.1 (flujo evaluación), §3.1 (observabilidad/evaluación TDD), §5.2 (Revisor de código), §5.3 (especialización de flota) y tabla de contenidos; simplifica `template/AGENTS.md` de 273 a 101 líneas (regla de diseño: marco mínimo + punteros, sin duplicar procedimientos).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-010, D-011, D-012, D-013, [[assumptions]] A-001
- [x] T-017 — Tercera ronda de `methodology.md`: §7.1 estado por incremento (`state.yaml`) — espina única de 11 pasos, capas técnicas como tareas etiquetadas (`component`/`owner`), revisiones transversales como entradas de evaluación en Verificar, Single Writer (orquestador), reanudación vía rama de la slice; §5.2 nota "hermano de seguridad" (`security-reviewer`).
      Prioridad: alta · Responsable: — · Ref: [[progress]], [[decisions]] D-014, D-015, D-016, D-017

## Bloqueadas
