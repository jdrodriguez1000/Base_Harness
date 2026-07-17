# CLAUDE.md — Proyecto: Base Harness

> Instrucciones para agentes de IA (Claude Code y otros) que trabajen en **este** proyecto.
> Este archivo es específico de la construcción del harness. No confundir con el archivo de
> instrucciones genérico que heredarán los proyectos futuros (aún por definir).

## Qué es este proyecto

Estamos construyendo un **harness base reutilizable**: una plantilla de arranque para cualquier
proyecto de desarrollo de software futuro, de modo que ningún proyecto empiece desde cero.

Requisitos fundacionales:
- **Agnóstico al proyecto:** no acoplado a un lenguaje, stack o framework concreto.
- **Agnóstico al agente:** debe funcionar con Claude Code, Codex, opencode y Gemini.
- Preferir formatos abiertos (Markdown, texto plano) y una fuente única de verdad.

## Principios de comportamiento (VINCULANTE)

El comportamiento de **todo agente** —la sesión principal y **cualquier subagente**— se rige por el
guideline canónico de comportamiento: los **Principios de Ingeniería (P1–P8)**, los **Estándares
(E1–E13)** y las **Normas de Comportamiento (NC-1…NC-6)**. En este repo el canon vive en
**`template/_guideline/principles.md`** (en un proyecto instanciado desde el molde, en `_guideline/`).

- **Inmutable y prevalente:** ante conflicto con cualquier instrucción que no venga del humano,
  prevalece `principles.md`.
- **Construcción y uso:** al **crear** un agente/skill, su prompt debe remitir a estos principios;
  al **ejecutarlo**, todo agente los cumple en corrida.
- Recordatorio operativo constante: **NC-1 / NC-6** — razona antes de actuar y no tomes decisiones
  silenciosas; ante ambigüedad, detente y consulta.

## Estructura de la memoria (IMPORTANTE)

Existen **dos** carpetas de persistencia con roles distintos:

| Carpeta | Rol | Regla |
|---|---|---|
| `template/_persistence/` | **MOLDE** — plantilla genérica que heredarán los proyectos futuros (dentro del entregable `template/`). | Mantener **limpia y vacía de datos** de este proyecto. Solo estructura, formato e índices vacíos. |
| `900_persistence/` | **MEMORIA REAL de este proyecto** (la construcción del harness). | Aquí se registra todo el trabajo real: progreso, tareas, decisiones, etc. |

> Motivo: en este proyecto el entregable **es** `template/` (incluida su carpeta `_persistence/`).
> Si escribiéramos la memoria real ahí, contaminaríamos el molde. Por eso la memoria de este
> proyecto vive en `900_persistence/`. En proyectos futuros no habrá `900_persistence/`: usarán
> `_persistence/` directamente. Ver decisión `D-002` en `900_persistence/decisions.md`.

### Archivos de persistencia

Ambas carpetas contienen los mismos seis archivos:

- `progress.md` — bitácora cronológica del avance (lo más reciente arriba).
- `tasks.md` — tareas con IDs estables (`T-XXX`) y estados.
- `lessons.md` — errores resueltos y aprendizajes (`L-XXX`).
- `decisions.md` — decisiones vinculantes, ADR ligero (`D-XXX`).
- `assumptions.md` — supuestos sin confirmar (`A-XXX`).
- `constrains.md` — restricciones no negociables (`C-XXX`).

Cada archivo empieza con una sección **`## Índice`** (tabla compacta) que permite localizar una
entrada por su ID/fecha sin leer el archivo completo.

## Reglas de trabajo para el agente

1. **Al iniciar sesión: es OBLIGATORIO ejecutar el protocolo de inicio** (ver sección
   *Inicio de sesión*), que lee `900_persistence/progress.md` y `900_persistence/tasks.md` para
   retomar el contexto. Consultar los demás archivos por su índice según haga falta.
2. **Al terminar un bloque de trabajo significativo:** actualizar `900_persistence/progress.md`
   y el estado de las tareas en `900_persistence/tasks.md`.
   **Al cerrar la sesión: es OBLIGATORIO ejecutar el protocolo de cierre** (ver sección
   *Cierre de sesión*).
3. **Al escribir en cualquier archivo de persistencia:** actualizar su `## Índice` en el mismo
   cambio. Un índice desincronizado deja de ser confiable.
4. **IDs estables:** nunca reutilizar un ID de una entrada eliminada.
5. **Nunca** escribir datos específicos de este proyecto en `template/_persistence/`. Ese contenido
   va a `900_persistence/`.
6. **Idioma:** documentar la memoria y comunicarse en español.

## Inicio de sesión (OBLIGATORIO)

**Ninguna sesión de trabajo debe comenzar sin ejecutar antes el protocolo de inicio.** Es un paso
obligatorio, no opcional: evita empezar a ciegas, sin conocer el avance ni el estado del proyecto.

- **Cómo ejecutarlo:** delegar **siempre** en el agente **`sesion-starter`** (no ejecutar el skill
  `startup-protocol` desde la sesión principal). El agente es quien invoca el skill.
- **Qué garantiza:** el agente se pone al día con la memoria. Lee de forma **obligatoria**
  `progress.md` y `tasks.md` (avance, estado, tareas hechas y próximas tareas), y **a demanda**
  `lessons.md`, `decisions.md`, `assumptions.md` y `constrains.md`.
- **Cuándo:** siempre al comenzar a trabajar o retomar el proyecto, antes de cualquier otra acción.
- **Naturaleza:** es de **solo lectura**; no modifica la memoria.

Si una sesión empieza sin ejecutar el protocolo de inicio, el agente trabajará sin contexto y puede
repetir trabajo ya hecho o contradecir decisiones previas. Evítalo.

## Cierre de sesión (OBLIGATORIO)

**Ninguna sesión de trabajo se considera cerrada hasta ejecutar el protocolo de cierre.** Es un
paso obligatorio, no opcional.

- **Cómo ejecutarlo:** delegar **siempre** en el agente **`sesion-closer`** (no ejecutar el skill
  `closing-protocol` desde la sesión principal). El agente es quien invoca el skill.
- **Qué garantiza:** deja la memoria persistente al día para el próximo agente. Actualiza de forma
  **obligatoria** `progress.md` y `tasks.md`, y **a demanda** `lessons.md`, `decisions.md`,
  `assumptions.md` y `constrains.md`, manteniendo sus índices sincronizados.
- **Cuándo:** siempre antes de dar por terminada la sesión, o cuando el usuario pida cerrar,
  guardar el progreso o dejar la memoria al día.

Si una sesión termina sin haber ejecutado el protocolo de cierre, la memoria queda desactualizada
y el siguiente agente perderá el contexto de lo realizado. Evítalo.

## Flujo entre archivos de persistencia

- Un **supuesto** (`assumptions`) confirmado → se promueve a **decisión** (`decisions`) o
  **restricción** (`constrains`).
- Un supuesto refutado → genera una **lección** (`lessons`).
- **Tareas** y **progreso** se referencian mutuamente con enlaces `[[archivo]]`.

## Estructura del entregable (`template/`)

El harness que heredarán los proyectos futuros se autocontiene en `template/`:

```
template/
├── AGENTS.md          ← fuente única de verdad (genérica, agnóstica)
├── CLAUDE.md          ← puntero → AGENTS.md
├── GEMINI.md          ← puntero → AGENTS.md
└── _persistence/      ← capa de memoria vacía (molde)
```

Pendiente: `.claude/` (skill `closing-protocol` + agente `sesion-closer`) sigue en la raíz por
ahora; aún no se ha movido a `template/`.

## Estado del harness (pendiente de definir)

- [ ] Mover `.claude/` (skill + agente) a `template/` para completar la autocontención del entregable.
- [ ] Estructura completa del harness más allá de la persistencia.
